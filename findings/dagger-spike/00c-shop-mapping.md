# Slice 0 Leg C — dagger → shop mapping: seams & invariant surfaces

**Epic:** lead-fzxt · **Branch:** `dagger-spike` (off main @199b495, main untouched) ·
**Date:** 2026-07-02 · READ-ONLY recon (read-only `gh` on public
`dstengle/shopsystem-bc-launcher`; no BC source cloned to the lead host per ADR-018).

This is the dagger analog of what f6ta did for fabro
(`findings/fabro-spike/00b-f6ta-seams.md`): map dagger onto the shop's real
build+test(+e2e) contract, name the **seams** (where dagger substitutes *how*
something runs) and the **invariant surfaces** (what dagger must NOT change).

> GOAL restated: a dagger.io pipeline that runs the **REAL**
> bc-base/bc-launcher build+test(+fabro e2e) definition **LOCALLY** — the *same*
> module locally and in CI — so launcher/image defects are caught in a fast
> local loop **before** the `version-tag → publish-bc-base.yml → GHCR` round-trip.
> Root cause it attacks: the bc-launcher build host verifies **STRUCTURALLY**
> (fake docker/git/github drivers; no docker daemon, no fabro, no agent-vault),
> so the fabro launcher productionization (lead-kqgp) burned ~6 fix rounds, every
> defect caught only at the live e2e.

---

## 0. Ground truth recovered this leg (the real CI + the real test surface)

### 0.1 The three bc-launcher workflows (the entire published CI)
Read verbatim via `gh api .../contents/.github/workflows`:

| Workflow | Trigger | What it does |
|---|---|---|
| **publish-bc-base.yml** | `push: tags: v*` | job `build-and-publish`: checkout → ghcr login (`GITHUB_TOKEN`) → resolve baked `SHOP_TEMPLATES_VERSION` from the Dockerfile ARG → `docker/build-push-action@v6` build `docker/bc-base/Dockerfile`, push **both** `:<tag>` and `:latest` at the SAME digest, set OCI labels (`version`=`github.ref_name`, `revision`=`github.sha`, `shopsystem.shop-templates.version`), then a non-fatal public-visibility PATCH. Second job `build-and-publish-bc-lead` (`needs: build-and-publish`) mirrors it for `bc-lead` FROM `bc-base:<this-version>`. |
| **rebuild-bc-base.yml** | `repository_dispatch: [rebuild-bc-base]` | rebuild `docker/bc-base/Dockerfile` `--no-cache`, re-push `:latest` at the new digest. |
| **poll-bc-base-deps.yml** | `schedule: cron 0 7 * * *` + `workflow_dispatch` | ADR-022/lead-czwo centralized dep poll: resolve each baked dep's latest release (shop-templates, shop-msg, scenarios, beads, **fabro**, bc-launcher self-pin) with its OWN `GITHUB_TOKEN`, bump the Dockerfile pin(s), commit, rebuild + republish `:latest`. |

**Crucial:** there is **NO test-running workflow.** The pytest suite is NOT a GHA
gate — it is the BC-loop's in-container **structural** Reviewer gate. CI only
builds+publishes the image. So dagger has TWO distinct insertion contexts: (i) the
GHA build/publish (wrap, don't disturb the release contract), and (ii) the
**local** build+test loop that today doesn't exist at all outside the BC container.

### 0.2 The real Dockerfile (`docker/bc-base/Dockerfile`)
`FROM mcr.microsoft.com/devcontainers/python:3.11`, then RUN steps that all make
**outbound HTTPS at build time**:
- `pip install` four framework CLIs from `git+https://github.com/dstengle/...@vX`
  (shop-msg v0.4.4, scenarios v0.2.0, shop-templates `${SHOP_TEMPLATES_VERSION}`,
  bc-launcher self-pin v0.3.48).
- curl+checksum installs of **agent-vault v0.32.0** (Infisical), **fabro v0.254.0**
  (fabro-sh, ARG `FABRO_VERSION`), **bd 1.0.3** (steveyegge), `gh` (apt repo),
  **claude** (`claude.ai/install.sh`, as vscode).
- COPYs the committed `anthropic-oauth-shim`, `agent-vault-ca.sh`,
  `bootstrap-entrypoint.sh`, `bc-healthcheck.sh`; bakes synthetic
  logged-in claude state (`__PLACEHOLDER__` creds — the broker swaps on-wire).
- `USER vscode`, `ENTRYPOINT agent-vault-ca.sh`, `CMD sleep infinity`.

Every one of those RUN downloads is an on-wire credential/egress touchpoint — the
exact place a local dagger build must route through agent-vault (see §3).

### 0.3 The test surface (`tests/`, 60+ files) is STRUCTURAL BY CONSTRUCTION
`conftest.py` header, verbatim: *"All Docker interaction is stubbed via
FakeDockerDriver — no live daemon required. All GitHub and git operations …
stubbed via FakeGitHubDriver and FakeGitDriver."* The suite is `pytest-bdd`
over `features/*.feature`, `testpaths=["tests"]`. Drivers: `fake_driver.py`,
`fake_git_driver.py`, `fake_github_driver.py`. Even the `bc_base_*` image tests
(`test_bc_base_framework_cli_pins`, `..._fabro_and_oauth_shim`,
`..._image_publishing`, `..._version_surface`, `..._healthcheck`) assert against
the **Dockerfile text / declared YAML**, not a built image — the "declarative
artifact is the proxy for out-of-band live state" precedent named in
poll-bc-base-deps.yml. **This is the gap dagger closes:** the tests prove the
*declaration*; nothing proves the *built image actually works*.

### 0.4 Local host capability (measured this leg)
- `docker` 29.5.3 present, `/var/run/docker.sock` present (root:984).
- **`dagger v0.21.7` already installed** (`~/.local/bin/dagger`, engine
  `registry.dagger.io/engine:v0.21.7`).
- agent-vault egress fully wired in env: `HTTPS_PROXY=http://…@agent-vault:14322`,
  MITM CA at `/home/vscode/.agent-vault/mitm-ca.pem` exported through the full
  fan of trust vars (`SSL_CERT_FILE`, `REQUESTS_CA_BUNDLE`, `CURL_CA_BUNDLE`,
  `NODE_EXTRA_CA_CERTS`, `GIT_SSL_CAINFO`, `DENO_CERT`), `NO_PROXY` includes
  `agent-vault,localhost,127.0.0.1`, `AGENT_VAULT_ADDR=http://agent-vault:14321`.

---

## 1. Can dagger run build + test + e2e LOCALLY? (per stage)

Dagger's model: a host `dagger` CLI talks to a containerized **dagger engine**
(BuildKit-based); every pipeline step runs inside engine-managed containers; a
**dagger module** (Functions, in Go/Python/TypeScript SDK, or Dagger Shell) is
the single source invoked identically by the dev CLI and by GHA.

### (a) Build bc-base from the real Dockerfile — **YES, locally, cleanly**
Dagger's `Directory.dockerBuild()` / `Container.build(context, dockerfile=)` runs
the **existing Dockerfile verbatim** through the engine's BuildKit — this is the
**no-divergence-preserving** primitive (contrast: re-expressing the Dockerfile as
a `withExec` chain would be a hand-built variant — FORBIDDEN, see §4 IS-2). It
accepts `--build-arg` (thread `SHOPSYSTEM_BC_LAUNCHER_VERSION`,
`SHOP_TEMPLATES_VERSION`) and labels. **Special handling required:** every RUN
step does outbound HTTPS (pip-from-git, curl GitHub releases). On the lead host
that egress MUST traverse agent-vault + trust the MITM CA (§3) — and BuildKit does
**not** inherit host proxy/CA automatically. In GHA the same build goes direct
(no proxy) with a real `GITHUB_TOKEN`. Same *definition*, different *env* — that
asymmetry is legitimate and is exactly the cred seam (§3).

### (b) Run the launcher test suite — **YES, locally, trivially**
The suite is pure `pytest`/`pytest-bdd` with fake drivers → **no docker daemon,
no network, no creds**. Dagger runs it as `container.from(python:3.11)
.withDirectory(src).withExec(["pip","install","-e",".[test]"])
.withExec(["pytest"])` — fully local, fully cacheable. This stage is *easy*; it is
also, by itself, **not the win** — running the structural suite in dagger just
relocates the same structural coverage. The win is stage (c) + running the suite
**against a really-built image** so the `bc_base_*` "declared-shape" assertions get
a live counterpart.

### (c) fabro e2e (launch a real container + fabro + agent-vault) — **PARTIAL: needs docker-socket nesting + network reachability; the hard seam**
This is the launcher's real move: `docker run bc-base` → in-container
`agent-vault run -- claude` under `--orchestrator fabro`. To reproduce it *inside*
dagger you must launch a real sibling container from within a dagger step. Options:
- **docker-out-of-docker:** mount `/var/run/docker.sock` into the dagger step
  (`Container.withUnixSocket`) and `docker run` the real image — closest to the
  live path, but the launched container inherits the *host* docker network, not
  dagger's engine network.
- **dagger Services:** model the BC as a `Service` binding — cleaner dagger-native
  but *diverges* from the real `docker run` launch path (risks IS-2).
Two unknowns block this on paper (see §5): whether a dagger workload container can
reach `agent-vault:14322` (different netns), and the resource/perf cost of
docker-in-dagger. **This stage is where dagger's leverage is highest AND its
uncertainty is highest** — the fabro-launcher bugs that burned 6 rounds all lived
here. Slice 2's proof (RED-on-a-known-live-bug) must land in stage (c) or in a
built-image variant of (b), not in the pure structural suite.

---

## 2. The "no-divergence / same-locally-and-in-CI" contract

Dagger's core value proposition *is* invariant #1: one module, invoked the same
way from a laptop and a runner. The mechanism:

- **Single source of truth = the dagger module** (checked into
  `shopsystem-bc-launcher`). `dagger call build-bc-base --version=vX` runs the
  identical graph whether the caller is a dev shell or a GHA step. GHA becomes a
  **thin wrapper**: `checkout → install dagger → dagger call …` with GHCR creds
  passed as dagger secrets. No build logic lives in YAML anymore.

- **Real Dockerfile stays the atom.** The module's build node is
  `dockerBuild(docker/bc-base/Dockerfile)` — the same file publish-bc-base.yml
  feeds to `docker/build-push-action`. Dagger wraps it; it does not reimplement it.

### What STAYS vs what dagger ABSORBS (mapping onto publish-bc-base.yml)

| publish-bc-base.yml element | Disposition |
|---|---|
| `on: push: tags: v*` | **STAYS in GHA.** The release trigger is the contract; dagger has no opinion on it. |
| ghcr login / `GITHUB_TOKEN` | **STAYS in GHA** as the credential *source*; passed INTO the module as a dagger secret. |
| resolve `SHOP_TEMPLATES_VERSION` from ARG | **ABSORBED** — the module resolves + threads it (or GHA resolves and passes `--shop-templates-version`). |
| `docker/build-push-action@v6` build+push | **ABSORBED** — `dagger call build-bc-base … publish --tags=vX,latest`. This is the step dagger replaces; it is ALSO the step that now runs **locally** (minus `publish`). |
| both tags → same digest | **ABSORBED but preserved as behavior** — `Container.publish()` to both refs from one built container. |
| OCI labels (version/revision/shop-templates) incl. defeating upstream `3.1.2` | **ABSORBED, must be preserved bit-for-bit** (IS-4). |
| public-visibility PATCH | **STAYS in GHA** (post-publish `gh api`, non-fatal) — not a build concern. |
| bc-lead `needs: build-and-publish` ordering + `BASE_VERSION` | **ABSORBED** as a module dependency edge (build bc-lead FROM the bc-base container produced in the same run). |
| rollback = re-point `:latest` at prior digest | **STAYS** — a registry/runbook property, untouched. |

**Net:** dagger absorbs *execution of the build+push and adds the local test/e2e
loop*; GHA retains *the trigger, the GHCR credential source, the visibility PATCH,
and the tag/rollback semantics*. That is a **WRAP, not a REPLACE**, of the release
contract — invariant #3 preserved. `rebuild-bc-base.yml` and `poll-bc-base-deps.yml`
get the same treatment (their build step → `dagger call`), their triggers untouched.

---

## 3. The agent-vault credential seam (dagger secrets ↔ agent-vault)

Direct analog of fabro's bypass (`anthropic-oauth-shim` / HTTPS_PROXY, ADR-049):
**agent-vault is the sole credential surface; secrets stores hold only DUMMY
placeholders; the egress proxy injects the real credential on the wire.**

Dagger's native secret model: `dagger.Secret` sourced from env/file/host-vault,
mounted into containers via `withSecretVariable` / `withMountedSecret`, never
baked into a layer (not in build cache, scrubbed from logs). The **bridge recipe**
mirrors fabro's proven bypass:
1. Every dagger secret carries a **dummy** value (e.g. `GITHUB_TOKEN=dummy`,
   `ANTHROPIC_API_KEY=dummy`). Nothing real is stored.
2. Every container/build step in the module gets `HTTPS_PROXY`/`HTTP_PROXY`
   =`http://…@agent-vault:14322`, `NO_PROXY`, and the **MITM CA** wired through
   the full trust-var fan (`SSL_CERT_FILE`, `REQUESTS_CA_BUNDLE`, `CURL_CA_BUNDLE`,
   `NODE_EXTRA_CA_CERTS`, `GIT_SSL_CAINFO`, `DENO_CERT`) — exactly the env this
   host already exports (§0.4). The proxy then injects the real cred on-wire.

**The load-bearing uncertainty — dagger's isolation cuts against this** (unlike
fabro, whose nodes run as host subprocesses that inherit env directly):
- The **dagger engine is its own container**; it does NOT inherit the host's
  `HTTPS_PROXY`/CA by default. Engine-level proxy config
  (`_EXPERIMENTAL_DAGGER_*` / engine `docker run` env) must be set explicitly.
- **BuildKit (stage a) is the sharp edge.** The Dockerfile's RUN steps do
  build-time HTTPS to github.com/pypi. The base `python:3.11` cert store does
  **not** contain the MITM CA. So the CA must reach *inside the build* — via a
  build secret/mount or a Dockerfile that trusts it — WITHOUT editing the real
  Dockerfile (IS-2 tension). How to inject a host MITM CA into an unmodified
  Dockerfile's RUN egress inside dagger BuildKit is **unproven → Slice 1/2**.
- **Network reachability:** `agent-vault:14322` is a hostname on the host's
  network. A dagger workload container sits on the engine's network namespace —
  whether it can resolve/reach `agent-vault` (vs needing host-network, a service
  binding, or an IP) is **unproven → Slice 1/2**. Same reachability question
  gates the stage-(c) e2e.

In CI (GHA) this seam is *absent*: the runner has direct internet and a real
`GITHUB_TOKEN`. So the module must accept creds+egress as **parameters** (dummy
secret + proxy env locally; real secret + no proxy in CI). Parameterizing
cred/egress at the module boundary is what keeps *one definition* honest across
both environments.

---

## 4. Seams & invariant surfaces (the f6ta-style framing for dagger)

### THE 3 SEAMS — where dagger attaches (substitutes *how*, not *what*)

**Seam A — the build+push execution step. Verdict: CLEAN.**
`docker/build-push-action@v6` (in publish-bc-base.yml + rebuild-bc-base.yml +
poll-bc-base-deps.yml) → `dagger call build-bc-base … publish`. Dagger's
`dockerBuild` wraps the **real Dockerfile verbatim**; tag/label/digest semantics
reproduced by `Container.publish()`. Clean because dagger's whole design target is
"same build locally + in CI," and `dockerBuild` avoids re-expressing the Dockerfile.

**Seam B — the test-execution loop. Verdict: CLEAN locally, but relocation-only
unless paired with a built image.** No CI test gate exists today; the structural
`pytest` suite is the BC-loop's in-container Reviewer gate. Dagger adds a local
test stage (pure pytest, fake drivers, no docker/creds). Trivial to run; the
*value* only appears when the same stage also runs **against the really-built
bc-base image** (giving the `bc_base_*` declared-shape assertions a live twin).

**Seam C — the fabro e2e (real container + fabro + agent-vault). Verdict:
PARTIAL / special-handling.** Requires docker-socket nesting
(`withUnixSocket(/var/run/docker.sock)` → `docker run bc-base` under
`--orchestrator fabro`) or a dagger `Service` model (which diverges from the real
`docker run`). Gated by two unproven items: agent-vault reachability from inside a
dagger container, and docker-in-dagger cost. This is the highest-leverage /
highest-risk seam — the 6 fabro-launcher bugs all lived at this live e2e. (Direct
analog of f6ta's Seam-b "PARTIAL / refuted as drop-in.")

### THE 5 INVARIANT SURFACES — what dagger must NOT change (preserve)

**IS-1 — the release/publish contract.** `on: push: tags: v*` trigger; version-tag
semantics; both `:<tag>` and `:latest` at ONE digest; the public-visibility
assertion; rollback = re-point `:latest` at a prior immutable digest. Dagger WRAPS
the build; the trigger + tag/rollback contract stay GHA/registry-owned.
*Source: publish-bc-base.yml (pins scenarios 37/41), rebuild-bc-base.yml (38).*

**IS-2 — the REAL Dockerfile + REAL tests (no-divergence).** dagger must
`dockerBuild(docker/bc-base/Dockerfile)` verbatim (NOT a re-expressed `withExec`
variant) and run the REAL `tests/` suite — not a hand-built lookalike. This is
hard-invariant #1 ("doesn't deviate too far"). The MITM-CA-into-build problem (§3)
must be solved WITHOUT editing the Dockerfile, or it violates IS-2.
*Source: plan.md hard-invariant #1; David explicit.*

**IS-3 — agent-vault as SOLE credential surface.** No baked secrets; dagger
secrets hold only dummy placeholders; the proxy injects real creds on-wire; the
MITM CA + `HTTPS_PROXY` must reach build/test/e2e containers. Native dagger secret
*storage* is permitted only as a dummy carrier — never as the real credential.
*Source: plan.md hard-invariant #2; ADR-049 (agent-vault sole cred surface,
fabro-native secrets forbidden) — dagger inherits the same prohibition.*

**IS-4 — the GHCR image contract.** Image names
`ghcr.io/dstengle/shopsystem-bc-base` (+ `-bc-lead`); the digest/tag/OCI-label
surface consumers pull, including the labels that defeat the upstream
`org.opencontainers.image.version=3.1.2` and carry
`shopsystem.shop-templates.version`. Dagger's publish must reproduce these
bit-for-bit.
*Source: publish-bc-base.yml labels: block (lead-5xnd); plan hard-invariant #3.*

**IS-5 — BC ownership of its CI.** The dagger-ification lands in
`shopsystem-bc-launcher` by DISPATCH (Slice 4), never by lead edits of BC source.
The lead may only characterize via read-only `gh` (as done this leg).
*Source: plan hard-invariant #4; ADR-018 (empirical-verification-is-contract-
surface), ADR-021/022 (bc-base owned by bc-launcher, centralized in bc-launcher).*

> Compare f6ta: 2 seams / 3 invariant surfaces for fabro. Dagger's surface is
> **release-pipeline-shaped** rather than runtime-loop-shaped, so it enumerates
> 3 seams / 5 invariant surfaces — but the SHAPE is identical: one CLEAN
> substitution (Seam A ≈ f6ta Seam-a launch), one PARTIAL/special-handling
> substitution (Seam C ≈ f6ta Seam-b loop), and agent-vault promoted to a
> first-class invariant surface (IS-3 = the same 4th surface the fabro epic added
> beyond f6ta's original three).

---

## 5. DOGFOOD-FABRO angle (David's directive: BC processes the dispatch under `--orchestrator fabro`)

Slice 4 dispatches the dagger-ification to `shopsystem-bc-launcher`, and the BC
processes it under in-container fabro orchestration (ADR-048/050/051). Implications:

- **Synergy, not conflict — dagger is the tool fabro's Reviewer was missing.**
  ADR-051 makes the fabro **Reviewer the SOLE gated emitter (fail-closed)**. Today
  that Reviewer verifies STRUCTURALLY (fake-driver pytest) — the precise cause of
  the 6 fix rounds. A local dagger build+test is exactly the **real-build check the
  Reviewer node can run before emitting `work_done`.** Dagger closes the gap
  *inside* the loop that fabro fail-closes. This is the strongest case for the
  spike: dagger becomes a fabro Reviewer-node command.

- **Shared credential surface, no new cred vector.** fabro (ADR-049) and dagger
  (IS-3) BOTH treat agent-vault as sole cred surface. The same `HTTPS_PROXY` +
  MITM-CA env must reach fabro's nodes AND dagger's containers. One consistent
  seam — dagger introduces no new credential authority.

- **Nesting hazard (flag for Slice 1/2):** this is **dagger-inside-a-fabro-node-
  inside-a-BC-container.** The BC container already mounts the docker socket
  (`test_bc_container_workspace_mount_and_docker_socket.py`) and already engages
  fabro via `--orchestrator` (`test_bc_container_orchestrator_flag_engage_tier.py`),
  so the plumbing exists — but dagger provisions its OWN engine container via that
  socket (docker-out-of-docker), which itself needs proxy+CA and adds resource/perf
  cost. Whether a full dagger engine is viable inside a BC container is unproven.

- **ADR-018 harvest surface still holds:** the lead reconciles Slice 4 via
  `shop-msg read outbox` + `scenarios hash` — NOT by reading dagger/fabro run
  outputs. Dagger changes *what the Reviewer runs*, not *how the lead harvests*.

---

## 6. What CANNOT be determined without Slice 1/2 hands-on (flagged)

1. **Does the dagger ENGINE container inherit `HTTPS_PROXY` + MITM CA?** Dagger
   provisions the engine; env propagation to the engine and to BuildKit build
   steps is unproven (needs explicit engine config).
2. **Can the MITM CA be injected into an UNMODIFIED Dockerfile's build-time RUN
   egress inside dagger BuildKit** (pip-from-git, curl GitHub releases) without
   editing the Dockerfile (IS-2)? The `python:3.11` base does not trust the MITM
   CA. Unproven — the central Slice-1 risk.
3. **Is `agent-vault:14322` reachable from inside a dagger workload container**
   (different network namespace)? Gates BOTH the build proxy and the stage-(c)
   e2e. Unproven.
4. **docker-socket nesting for the fabro e2e** — can dagger launch the real
   `docker run bc-base … --orchestrator fabro` sibling and have it reach
   agent-vault + messaging? Unproven; the hardest/highest-value item.
5. **Does dagger `dockerBuild` + `publish` reproduce the exact release contract** —
   build-args, OCI labels (incl. defeating upstream `3.1.2`), and both-tags-one-
   digest — that IS-1/IS-4 require? Needs empirical confirmation.
6. **Local docker-socket group access** (is `vscode` in group 984?) for dagger's
   own engine provisioning on this host. Cheap to check in Slice 1.
7. **dagger-in-a-BC-container viability** (the dogfood nesting, §5) — resource/perf
   and whether the engine boots there. Unproven.

---

## Sources
- Read-only `gh api dstengle/shopsystem-bc-launcher/...` (with `GH_TOKEN=dummy`,
  proxy-injected): `.github/workflows/{publish-bc-base,rebuild-bc-base,
  poll-bc-base-deps}.yml`; `docker/bc-base/Dockerfile`; `tests/` listing +
  `conftest.py` + `fake_driver.py` head; `features/` listing; `pyproject.toml`.
- Local host: `docker version`, `dagger version`, proxy/CA env.
- `findings/dagger-spike/plan.md` (goal + 5 hard invariants).
- `findings/fabro-spike/00b-f6ta-seams.md` (the analog framing being mirrored).
- ADRs: 018, 021, 022, 048, 049, 050, 051. plan invariants #1–#5.
