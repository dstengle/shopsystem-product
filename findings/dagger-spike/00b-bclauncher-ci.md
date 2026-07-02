# Slice 0 / Leg B — the REAL bc-launcher CI/build pipeline dagger must run

**Scope:** Characterize the actual CI/build/publish definition of the PUBLIC
`dstengle/shopsystem-bc-launcher` repo, so Slice 1 can spec a dagger module that
runs the SAME definition locally + in CI with NO divergence.

**Method (disciplined):** read-only `gh` against the public repo (the same move
architects used during the fabro effort). NO BC source cloned to the lead host.
Files pulled via `gh api .../contents/<path> --jq .content | base64 -d` into the
scratchpad only. `GH_TOKEN=dummy` (agent-vault proxy injects the real token;
`gh` is v2.95.0; host is NOT `gh auth login`'d — the proxy is the auth path).

---

## 0. TL;DR — the shape of the real pipeline (and the gap the spike targets)

The repo has **THREE workflows, and NONE of them run the pytest suite**:

| workflow | trigger | what it does |
|---|---|---|
| `publish-bc-base.yml` | `on: push tags v*` | build+push **bc-base** then **bc-lead** to GHCR (version + latest). **No tests.** |
| `rebuild-bc-base.yml` | `repository_dispatch: rebuild-bc-base` | `--no-cache` rebuild bc-base, re-push `:latest` only. **No tests.** |
| `poll-bc-base-deps.yml` | `schedule: 0 7 * * *` + `workflow_dispatch` | resolve latest release of each baked dep, bump the Dockerfile pin, commit, rebuild+re-push `:latest`. **No tests.** |

**The 62-test pytest-bdd suite is entirely STRUCTURAL and runs OUTSIDE CI** — on
the bc-launcher build host during the in-container BC Implementer→Reviewer loop.
Its own docstring (tests/conftest.py:4-6): *"All Docker interaction is stubbed
via FakeDockerDriver — no live daemon required. All GitHub and git operations …
stubbed via FakeGitHubDriver and FakeGitDriver."* So:

- **CI (GHA) builds+publishes the image but never runs the image or the tests.**
- **The test host runs the tests but against FAKES — no docker, no fabro, no
  agent-vault, no real image.**

That double gap is EXACTLY the fabro-productionization failure mode (epic
lead-kqgp, ~6 fix rounds, every defect caught only at live e2e): nothing between
"structural fakes pass" and "GHCR release + live launch" actually BUILDS the
Dockerfile and RUNS the resulting container. **The dagger module's job is to
occupy that empty middle** — build the real Dockerfile and exercise the real
image locally, with the same module invoked by GHA.

---

## 1. `publish-bc-base.yml` — the version-tag → GHCR publish path

Path: `.github/workflows/publish-bc-base.yml` (188 lines). This is the official
release path the fabro effort round-tripped through (recent runs below).

**Trigger:** `on: push: tags: ["v*"]`. **Permissions:** `contents: read`,
`packages: write`.

**Job 1 — `build-and-publish` (bc-base), runs-on ubuntu-latest:**
1. `actions/checkout@v4`.
2. `docker/login-action@v3` → `ghcr.io`, user `${{ github.actor }}`, password
   `${{ secrets.GITHUB_TOKEN }}` (the built-in GHA token — no PAT).
3. **Resolve baked shop-templates version** — `sed -n 's/^ARG
   SHOP_TEMPLATES_VERSION=\(v[0-9.]*\).*/\1/p' docker/bc-base/Dockerfile` →
   `$GITHUB_OUTPUT` (so the OCI label tracks the ARG default actually baked;
   lead-5xnd).
4. **`docker/build-push-action@v6`** — `context: ./docker/bc-base`, `file:
   ./docker/bc-base/Dockerfile`, `push: true`.
   - `build-args: SHOPSYSTEM_BC_LAUNCHER_VERSION=${{ github.ref_name }}` (the
     pushed tag → baked ENV).
   - `labels:` `org.opencontainers.image.version=${{ github.ref_name }}`,
     `.revision=${{ github.sha }}`, `shopsystem.shop-templates.version=<resolved>`
     (build-set labels override the misleading upstream devcontainer-base
     `version=3.1.2`).
   - `tags:` `ghcr.io/dstengle/shopsystem-bc-base:${{ github.ref_name }}` **and**
     `:latest` — SAME digest gets both (immutable version + moving latest; this
     is the rollback observable, scenario 41).
5. **Set package visibility public** — `continue-on-error: true`, `gh api
   --method PATCH /users/dstengle/packages/container/shopsystem-bc-base/visibility
   -f visibility=public || true` (redundant idempotent reassertion, non-fatal).

**Job 2 — `build-and-publish-bc-lead`, `needs: build-and-publish`:** identical
shape for `./docker/bc-lead`, but adds `build-args: BASE_VERSION=${{
github.ref_name }}` so **bc-lead:vX is built FROM bc-base:vX pushed earlier in
the SAME run** (the `needs:` enforces ordering). Tags
`ghcr.io/dstengle/shopsystem-bc-lead:{vX,latest}` + the same visibility PATCH.

**Rollback (documented trailer, scenario 41 / `be11d615375564e1`):** every
release is pushed by immutable `v*` tag, so any prior digest stays pullable; roll
back = re-point `latest` at an earlier digest (`docker buildx imagetools create`
or a dispatch) with no rebuild. Runbook `docs/runbooks/bc-base-rollback.md`.

**Recent runs (the "285xxxxx" ids the task references):** all `success`, ~3-5min:
- `28558318616` v0.3.48 (Defect D fabro engage fix — lead-esy4) 3m49s
- `28555651388` v0.3.47, `28552359196` v0.3.46, `28548534130` v0.3.45,
  `28544699830` v0.3.44 (lead-so2h oauth-shim), `28539553462` v0.3.43.

The ~3-5min wall time = pure `docker build` (multi-tool bake) + push. Confirms
**no test phase in CI**; the round-trip cost the fabro effort paid per fix is
this build+push + live launch, not a test run.

---

## 2. The other workflows + the test setup

### `rebuild-bc-base.yml` (54 lines)
`repository_dispatch: types: [rebuild-bc-base]`. One job: checkout → ghcr login →
`build-push-action@v6` `context: ./docker/bc-base`, `no-cache: true`, `push`,
`tags: ...bc-base:latest` only. Retirement note: the old
`shopsystem-templates-released` fan-in is retired (ADR-022, lead-czwo); only the
bare manual rebuild remains. **No tests.**

### `poll-bc-base-deps.yml` (220 lines, ADR-022 / lead-czwo)
`schedule: "0 7 * * *"` + `workflow_dispatch`. `permissions: contents: write,
packages: write`. ONE job `check-bump-rebuild`:
- Iterates a `DEPS` array of `<dep-key>|<canonical owner/repo>`:
  `shop-templates|dstengle/shopsystem-templates`,
  `shop-msg|dstengle/shopsystem-messaging`,
  `scenarios|dstengle/shopsystem-scenarios`, `beads|steveyegge/beads`,
  `fabro|fabro-sh/fabro`,
  `shopsystem-bc-launcher|dstengle/shopsystem-bc-launcher` (the **self-pin**).
- For each: `gh release view --repo <repo> --json tagName` (using the workflow's
  OWN `GITHUB_TOKEN`, NOT a cross-repo dispatch PAT), grep the current pin out of
  the Dockerfile, and if latest != pin → `sed -i` bump the pin in place.
- If anything changed: `git commit` the bumped Dockerfile + `git push` (bump is
  committed BEFORE the build), ghcr login, `build-push-action@v6`
  `context: ./docker/bc-base`, `no-cache`, re-push `:latest`. No-op run makes no
  commit and no build. **No tests.**

This workflow is the machine-readable spec of **which pins live in the Dockerfile
and how they are shaped** — dagger's build-arg / pin surface must match it.

### Test setup — `pyproject.toml`, `tests/`, `features/`
- `pyproject.toml`: `name = shopsystem-bc-launcher`, `version = 0.3.48`,
  `requires-python >=3.11`, `dependencies = []` (stdlib-only runtime),
  console-script `bc-container = bc_launcher.cli:main`, package-data ships the
  fabro-def bundle (`assets/fabro-def/*`, ADR-051 lead-h2bj),
  `[tool.pytest.ini_options] testpaths = ["tests"]`.
- **62 `tests/test_*.py` files, 46 `features/*.feature` files** — pytest-bdd. The
  test files are thin `scenarios("../features/....feature")` bindings; ALL step
  defs live in one **`tests/conftest.py` (~13,900 lines)**. (The "305-test suite"
  seen during fabro is the expanded scenario/step count across these bindings.)
- Naming split: `test_bc_base_*` = image/Dockerfile-shape pins (framework CLI
  pins, healthcheck, shop-templates pin, version surface, image publishing);
  `test_bc_container_*` / `test_lead_*` / `test_bclaunch_*` = launcher behavior
  (launch image selection, clone/broker wiring, CA trust, credentials, prompt
  submit, fabro path oauth-shim wiring, etc.).
- **These are STRUCTURAL**: `conftest.py:96` `fake_driver()` → `FakeDockerDriver`;
  manifest steps use `FakeGitHubDriver`/`FakeGitDriver`. They assert on Dockerfile
  TEXT and on launcher argument-construction against fakes — they never build the
  image or start a container. This is the "verifies STRUCTURALLY (no
  docker/fabro/agent-vault)" property the plan calls out.

**The ONE partial exception — `test_bc_container_fabro_def_validates.py`
(`@scenario_hash:2dfefe2ba81e418d`, lead-ky63):** LEG 1 runs the **REAL fabro
binary** `fabro validate --no-upgrade-check --json <workflow.fabro>` and asserts
exit 0 + empty diagnostics. The helper `_ky63_fabro_binary` (conftest ~12715)
prefers on-PATH/cached fabro, else DOWNLOADS the target-triple asset from
`fabro-sh/fabro` **via HTTPS_PROXY** (`fabro-<triple>.tar.gz`, strip the nested
`fabro` member) — and **SKIPs honestly** (`pytest.skip`) if the binary "cannot be
obtained (no network)". LEG 2 parses the committed `workflow.fabro` for ADR-051
structural invariants; LEG 3 asserts the vault is `__PLACEHOLDER__`-only. So even
the "real" test only reaches for a real *binary* over the proxy and validates a
def statically — it still does NOT build the image or run a live container +
broker. On the structural build host with no proxy egress it SKIPs. This is the
closest existing thing to a real check, and it shows the exact seam dagger
extends: **give the pipeline real egress (agent-vault proxy) + a real container so
these legs run for-real instead of skipping.**

---

## 3. The bc-base Dockerfile — what dagger must reproduce

Path: `docker/bc-base/Dockerfile` (332 lines). `FROM
mcr.microsoft.com/devcontainers/python:3.11`. This is the artifact-of-record; the
whole spike is "build THIS, locally, the same way CI does." What it bakes, in
order:

1. **Version ARGs → persisted ENV/LABEL:** `ARG SHOP_TEMPLATES_VERSION=v0.48.0`,
   `ARG SHOPSYSTEM_BC_LAUNCHER_VERSION=v0.3.48` → promoted to `ENV` (surfaces in
   `docker inspect`, lead-5xnd) + `LABEL shopsystem.shop-templates.version`.
2. **Four framework CLIs (pip, VCS version-pins):** one `pip install --no-cache-dir`
   of `shopsystem-messaging@…@v0.4.4`, `scenarios@…@v0.2.0`,
   `shop-templates@…@${SHOP_TEMPLATES_VERSION}`,
   `shopsystem-bc-launcher@…@v0.3.48` (the self-pin) — all
   `git+https://github.com/dstengle/<repo>.git@vX`.
3. **agent-vault (Infisical Go binary, pinned v0.32.0):** `uname -m`→arch case,
   curl tarball + `checksums.txt`, `sha256sum -c`, install to
   `/usr/local/bin`, build-time `agent-vault --version` self-check. Pin is
   explicit (must stay broker-compatible; NOT `latest`).
4. **fabro (fabro-sh/fabro Rust binary):** `ARG FABRO_VERSION=v0.254.0`,
   target-triple asset `fabro-<triple>.tar.gz` + `.sha256` sidecar,
   `--strip-components=1`, install, `fabro --version` self-check. (ARG bumped by
   poll workflow, lead-ckq5.)
5. **anthropic-oauth-shim:** `COPY` a committed stdlib-only python3
   ThreadingHTTPServer reverse-proxy (binds 127.0.0.1:8788, strips inbound auth,
   adds dummy Bearer + `anthropic-beta: oauth-2025-04-20`, forwards upstream via
   HTTPS_PROXY so agent-vault injects the real OAuth); `chmod` + `--help`
   self-check. NO real secret baked (lead-so2h).
6. **beads (bd, steveyegge/beads Go binary, `BD_VERSION=1.0.3`):** arch case,
   curl|tar, install, `bd --version`.
7. **apt:** `tmux git` (agent session + clone).
8. **GitHub CLI (gh):** official apt repo keyring + `gh --version` (needed for the
   BC push-to-origin gate, lead-ym1b).
9. **Claude Code CLI:** as `USER vscode`, `curl -fsSL https://claude.ai/install.sh
   | bash` into `/home/vscode/.local`; `ENV PATH` adds it.
10. **Synthetic logged-in Claude state:** writes `~/.claude/.credentials.json`
    (nested `claudeAiOauth`, `__PLACEHOLDER__` tokens, far-future expiry) +
    `~/.claude.json` (onboarding/trust/`bypassPermissionsModeAccepted`), vscode-
    owned — boots straight to agent; broker swaps real Authorization on the wire.
11. **agent-vault-ca.sh:** `COPY` → both image `ENTRYPOINT` (PID 1 CA
    materialization from `AGENT_VAULT_CA_PEM`) AND `/etc/profile.d/` (so
    `docker exec … agent-vault run -- claude` re-materializes the CA).
12. **bootstrap-entrypoint.sh:** `COPY` — the one-time interactive human-auth mode
    of this SAME image (lead-f6xs).
13. **bc-healthcheck.sh + `HEALTHCHECK`:** TCP-probes broker + messaging DB from
    runtime env; sets `.State.Health` (bclaunch-wuo).
14. **/workspace + /home/vscode/.config chowned vscode; `WORKDIR /workspace`;
    `USER vscode`; `ENTRYPOINT [agent-vault-ca.sh]`; `CMD [sleep infinity]`.**

**Build-time self-checks that FAIL the build (dagger inherits these for free by
running the real Dockerfile): `agent-vault --version`, `fabro --version`,
`anthropic-oauth-shim --help`, `bd --version`, `gh --version`.** These are the
cheapest defects dagger catches locally — a bad pin / 404 asset REDs the build
before any release, which is precisely a class of the fabro-effort bugs.

**bc-lead Dockerfile** (`docker/bc-lead/Dockerfile`, 91 lines): `ARG
BASE_VERSION=v0.3.6`, `FROM ghcr.io/dstengle/shopsystem-bc-base:${BASE_VERSION}`,
adds ONLY docker-ce-cli + docker-compose-plugin (`docker --version`,
`docker compose version` self-checks) + the dolt engine binary (`DOLT_VERSION=
1.43.14`, `dolt version`), then `USER vscode`. It is bc-base + the docker client
(launcher is the only role that runs docker; PDR-020 Addendum II). **Dagger must
build bc-lead FROM the bc-base it just built in the same run** (mirror the CI
`needs:` + `BASE_VERSION` threading) to keep no-divergence.

---

## 4. What a dagger LOCAL run of this pipeline needs (seams for Slice 1/2)

1. **Build context = `docker/bc-base/` and `docker/bc-lead/`** (CI uses
   `context: ./docker/bc-base`, file the Dockerfile in it). The COPY'd assets
   (`anthropic-oauth-shim`, `agent-vault-ca.sh`, `bootstrap-entrypoint.sh`,
   `bc-healthcheck.sh`) live in that context dir — dagger needs those bytes. In
   the real productionized module they come from the checked-out repo; in the
   spike they are read-only-observable but NOT cloned to the lead host, so the
   Slice-2 throwaway builds against a scratchpad copy or a minimal fixture — the
   REAL dagger-ification (Slice 4) runs inside the BC where the context is native.
2. **Docker engine to build the image.** Dagger runs an OCI builder in its own
   engine (BuildKit-based); a Dockerfile build is a first-class dagger op
   (`Container.build(context, dockerfile=…, buildArgs=…)`), so **no docker-in-
   docker hand-rolling** is required for the *build* — that is the invariant-1
   win (dagger builds the REAL Dockerfile, not a hand-ported set of `.container`
   steps). Confirm this against Leg A's dagger-model notes (`00a-*`).
3. **Build-args dagger must thread (to match CI exactly):**
   - bc-base: `SHOPSYSTEM_BC_LAUNCHER_VERSION=<tag>` (+ optional
     `SHOP_TEMPLATES_VERSION`, `FABRO_VERSION` overrides — else the ARG defaults).
   - bc-lead: `BASE_VERSION=<tag>`, `SHOPSYSTEM_BC_LAUNCHER_VERSION=<tag>`, FROM
     the just-built bc-base (ordering = CI `needs:`).
   - OCI `labels:` (version/revision/shop-templates.version) — set the same way so
     `docker inspect` parity holds (the `test_bc_base_version_surface` /
     `image_publishing` pins assert on these).
4. **Network egress during build goes through agent-vault (`HTTPS_PROXY`),** NOT
   baked secrets (invariant 2). The Dockerfile's build-time downloads (agent-vault,
   fabro, bd, dolt, gh apt, claude install, pip VCS clones from github) all need
   egress; locally that is the agent-vault proxy already in env
   (`HTTPS_PROXY=http://…@agent-vault:14322`). BuildKit must be told to forward
   the proxy into build steps (build-arg/secret/`--build-context` env). This is a
   real seam: CI has open GitHub egress + `GITHUB_TOKEN` for GHCR login; the local
   dagger run substitutes the agent-vault proxy for both egress AND the injected
   credentials (dummy token on the wire, proxy swaps the real one).
5. **Secrets:** CI uses `secrets.GITHUB_TOKEN` for (a) `ghcr.io` docker login
   (push) and (b) the visibility PATCH. **The local loop must NOT push** — Slice
   2 builds + runs + tests locally, skipping the `push: true` / GHCR login /
   visibility PATCH (those stay CI-only so the official release path is
   preserved, invariant 3). Dagger secrets are typed (`dagger.Secret`, never
   interpolated into layers/logs) — the GHCR token for the CI-invoked path comes
   from `secrets.GITHUB_TOKEN`; the local path uses agent-vault, so no real secret
   is ever baked (matches the Dockerfile's own `__PLACEHOLDER__` discipline).
6. **The fabro e2e — where it fits (the payoff, Slice 2):** a real e2e needs a
   RUNNING container from the built image + a reachable **agent-vault broker** +
   the messaging DB (the healthcheck's two probe targets). Two fidelity tiers:
   - **Build + structural (cheap, deterministic):** dagger builds the real image;
     the build-time `--version`/`--help` self-checks (§3) run for-real; then run
     the pytest suite inside/against the built image. Catches pin/404/missing-tool
     defects the fake-driver suite can't.
   - **Live e2e (high fidelity):** `dagger` starts the built bc-base/bc-lead
     container as a service, wires `HTTPS_PROXY` → agent-vault + `SHOPMSG_DSN` →
     a messaging DB service, and runs the fabro path (`agent-vault run -- claude`
     / `fabro validate` LEG 1 for-real instead of SKIP). This is where the ~6
     fabro-launcher live-only bugs would have REDed locally. Dagger service
     bindings + the agent-vault proxy are the mechanism; confirm the broker is
     reachable from inside the dagger engine's network (a NO_PROXY /
     service-binding detail for Slice 2).

**No-divergence check for Slice 1:** the dagger module must consume `context:
./docker/bc-base` + the committed Dockerfile + the SAME build-args/labels/tag
scheme as `publish-bc-base.yml`, and (ideally) be the thing GHA's
`build-push-action` step is REPLACED by — i.e. GHA calls `dagger call
build-and-publish --tag $ref` and the local dev calls `dagger call build-and-test`
against the identical `build` function. The publish tail (GHCR push + visibility
PATCH + the version/latest dual-tag + bc-lead `needs` ordering + rollback-by-tag)
must remain byte-for-byte the current contract (invariant 3).

---

## Open seams to resolve in Slice 1

- **Where does the pytest suite run in the target design?** Today: structural, off-
  CI, on the build host against fakes. Dagger could run it (a) still structural but
  now gated in CI, and/or (b) against the freshly built image. Decide the split;
  the fake-driver suite is fast and deterministic and should stay, but the
  Dockerfile-shape pins (`test_bc_base_*`) become redundant once dagger builds the
  real image — flag for the BC (Slice 4) to reconcile, don't pre-decide here.
- **Build context provenance in the spike.** The COPY'd assets + Dockerfile are
  read-only-observable but not cloned to the lead host (ADR-018). The Slice-2
  throwaway needs SOME context bytes; the honest options are a scratchpad fixture
  vs. running the experiment inside a bc-launcher container. Note for the plan; the
  real module ships INSIDE bc-launcher where context is native (Slice 4 dispatch).
- **agent-vault reachability from the dagger engine network** (proxy + broker CA)
  — the live-e2e tier depends on it; verify against Leg A's dagger-secrets/engine
  notes.
- **GHCR push stays CI-only.** Confirm the module exposes build/test as a local
  function and build/test/push as the CI function over the SAME build core, so the
  official release path (`v*` tag → publish) is untouched.

---

## Provenance (commands used — all read-only, proxy-authed, dummy GH_TOKEN)

```
gh repo view dstengle/shopsystem-bc-launcher
gh api repos/dstengle/shopsystem-bc-launcher/contents/.github/workflows
gh api '.../git/trees/HEAD?recursive=1'                       # full tree
gh api .../contents/.github/workflows/{publish,rebuild,poll}-bc-base.yml
gh api .../contents/docker/bc-base/Dockerfile
gh api .../contents/docker/bc-lead/Dockerfile
gh api .../contents/pyproject.toml
gh api .../contents/tests/conftest.py                          # ~13.9k lines
gh api .../contents/tests/test_bc_container_fabro_def_validates.py
gh api .../contents/AGENTS.md
gh api .../contents/features                                   # 46 .feature files
gh run list --repo dstengle/shopsystem-bc-launcher --workflow publish-bc-base.yml
```
All target files were public and readable; nothing was inaccessible.
