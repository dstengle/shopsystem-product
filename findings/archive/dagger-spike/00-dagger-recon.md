> **ARCHIVED** — historical spike record, not current state (ADR-065). Superseded by: ADR-052, ADR-053, ADR-054, ADR-055 (dagger as build/test substrate).

# Slice 0 — dagger recon (synthesis)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Epic:** lead-fzxt · **Track:** odqd
iterative-experimentation (spike → learn → throw away → graduate via ADRs+scenarios →
productionize via BC dispatch).

Detail legs (read these for the raw evidence):
- Leg A — dagger tool characterization: [`00a-dagger-tool.md`](00a-dagger-tool.md)
- Leg B — real bc-launcher CI/build/publish pipeline: [`00b-bclauncher-ci.md`](00b-bclauncher-ci.md)
- Leg C — dagger → shop mapping (seams & invariants): [`00c-shop-mapping.md`](00c-shop-mapping.md)

**Bottom line:** dagger is a good fit and the build+test primitive is trivial to express;
the whole spike reduces to pointing it at the *real* bc-base Dockerfile + launcher tests +
fabro e2e and threading agent-vault egress into the engine. Everything needed for Slice 1
is installed and characterized on this host. No blockers.

---

## (a) The dagger tool — model, install, build, test-run, secrets seam, no-divergence

**Install / host state.** `dagger v0.21.7` is installed to `~/.local/bin` (curl the
official `install.sh`, `BIN_DIR=$HOME/.local/bin` to avoid sudo). Docker is present and
healthy (client 29.6.1 / server 29.5.3, `/var/run/docker.sock`). No host Go/Node/Python
deps are needed — the SDK runtime executes **inside the engine container**.

**Engine model.** Dagger = a CLI + a **BuildKit-derived engine that runs as a privileged
Docker container** (`registry.dagger.io/engine:v0.21.7`, bridge network, cache volume at
`/var/lib/dagger`). The CLI auto-provisions it on first use (~12s cold, ~0.2s warm). The
API is a **lazy GraphQL DAG** the engine resolves; you author it four ways (Dagger Shell,
SDK **modules**, `dagger call`, raw `dagger query`) over **one runtime**. Author the real
pipeline as a **Python SDK module** — Dagger Shell quoting is too fragile for non-trivial
`sh -c` bodies.

**Container build (invariant-1 primitive).** `host | directory <ABS-path> | docker-build`
builds the **actual Dockerfile unmodified** via the BuildKit Dockerfile frontend — proven
against a multi-step Dockerfile honoring RUN/COPY/CMD/WORKDIR/ENV. This is exactly the
shape of the real bc-base build: dagger builds the Dockerfile **as-is, no hand-ported
variant** (satisfies no-divergence). Gotcha: `host | directory .` resolves against dagger's
system workdir, not shell cwd — always pass an absolute path.

**Test-run + RED propagation.** `with-exec` runs the test command in the built image; a
**nonzero exit fails the pipeline AND the dagger process** (`Error: exit code: 7` →
`$?=1`). Packaged as a reusable `build_and_test(src, test_cmd)` function, `dagger call`
exits nonzero on a failing test. That is the Slice-2 primitive: "build the real image, run
the real tests, go red on failure" as one reusable function.

**Secrets → agent-vault seam (decisive).** dagger `secret` providers confirmed: `env://`,
`cmd://`, `file://` (unknown scheme rejected; `op://`/`vault://` exist upstream but are not
our path). dagger **scrubs** secret values from its own logs (0 raw appearances even with
`echo $TOK`). The decisive finding: **`cmd://` runs on the CLIENT HOST, not the engine**,
and inherits the host's `HTTPS_PROXY`. So the agent-vault bridge = a host-side `cmd://`
fetch script that calls agent-vault through the proxy, whose stdout dagger ingests as a
scrubbed `Secret` and injects into the build/test container. This mirrors fabro's proven
shim shape and bakes **no secret into any image** (satisfies invariant #2).

**Same-locally-and-in-CI (the no-divergence value prop).** A module is `dagger.json` +
`src/`, pinned to a specific **`engineVersion` (v0.21.7)** — that pin is the divergence
guard. Local invocation is `dagger call <fn> --arg=… <chain>`. CI invocation via
`dagger/dagger-for-github@v8.3.0` uses `verb: call` + `args:`, which is **literally the
same command**. One module, one engine version, one function → identical execution locally
and in GHA. This is the core "doesn't deviate" property and is what closes the fabro gap.

---

## (b) The real bc-launcher CI/build+test pipeline dagger must run

Characterized entirely via **read-only `gh`** on the public `dstengle/shopsystem-bc-launcher`
repo (proxy-authed, dummy `GH_TOKEN`, **no BC source cloned** — ADR-018 respected).

**Exactly three workflows, and NONE run tests:**
- `publish-bc-base.yml` — **on push tag `v*`**. Job 1 builds+pushes **bc-base**, then job 2
  (`needs:` job 1) builds+pushes **bc-lead** `FROM bc-base:vX` via `BASE_VERSION` build-arg.
  Both use `docker/build-push-action@v6`, `push: true`, GHCR login via
  `secrets.GITHUB_TOKEN`, **dual-tag `{version, latest}` at one digest**, OCI labels
  (`version`=ref_name, `revision`=sha, `shopsystem.shop-templates.version`; these defeat the
  upstream `org.opencontainers.image.version=3.1.2`), + a non-fatal `visibility=public`
  PATCH. **No test step.**
- `rebuild-bc-base.yml` — `repository_dispatch`, `--no-cache` re-push of `:latest`.
- `poll-bc-base-deps.yml` — daily cron; resolves each baked dep's latest release, sed-bumps
  the Dockerfile pin, commits, rebuilds `:latest`. **DEPS pin surface dagger must respect:**
  shop-templates, shop-msg, scenarios, beads, fabro, self-pin.

**The double structural gap = the fabro failure mode dagger targets.** The 60+-file /
46-feature pytest-bdd suite runs **OFF-CI on the build host** and is **STRUCTURAL by
construction**: `conftest.py` states all docker/git/github interaction is faked
(`FakeDockerDriver`/`FakeGitDriver`/`FakeGitHubDriver`, no live daemon); even the
`test_bc_base_*` tests assert against **Dockerfile/YAML text**, never a built image. So CI
builds+publishes but never runs the image or tests, and the test host runs tests but only
against fakes. The **empty middle** — build the real Dockerfile + run the real image — is
exactly where the fabro-launcher productionization burned ~6 fix rounds. The only near-real
test (`test_bc_container_fabro_def_validates.py` LEG1 running the real `fabro validate`
binary) `pytest.skip`s honestly when offline and still never boots a live container+broker.

**The real Dockerfiles.** `docker/bc-base/Dockerfile` (332 lines, FROM
`mcr.microsoft.com/devcontainers/python:3.11`) bakes 4 pip VCS-pinned framework CLIs
(messaging v0.4.4, scenarios v0.2.0, shop-templates v0.48.0, bc-launcher self-pin v0.3.48),
agent-vault v0.32.0, fabro (`ARG FABRO_VERSION=v0.254.0`), anthropic-oauth-shim, bd 1.0.3,
gh, claude, synthetic `__PLACEHOLDER__` `~/.claude` state, CA/bootstrap/healthcheck
entrypoints — with **build-time `--version`/`--help` self-checks that fail the build on a
bad pin** (the cheapest defect class dagger catches). `docker/bc-lead/Dockerfile` (91 lines)
is `FROM bc-base:BASE_VERSION` + docker-cli + docker-compose + dolt 1.43.14. Every build-time
`RUN` (pip-from-git, curl GitHub releases, apt, claude install) is an on-wire egress/cred
touchpoint a local dagger build must route through agent-vault.

Recent `publish-bc-base` runs are ~3–5 min pure build+push successes (v0.3.48 …).

---

## (c) The shop mapping — seams, invariant surfaces, and WRAP-not-REPLACE

**3 SEAMS:**
- **Seam A — build+push: CLEAN.** dagger `dockerBuild` wraps the real Dockerfile verbatim;
  build-args + OCI labels + dual-tag-one-digest reproducible.
- **Seam B — test-loop: CLEAN locally but relocation-only** unless the tests run against a
  *really-built image*. Running the existing structural suite under dagger just moves it;
  the value is running it (and a real-image tier) against the freshly built image.
- **Seam C — fabro e2e: PARTIAL** (highest leverage / highest risk; analog of f6ta Seam-b).
  Needs docker-socket nesting (run the built bc-base as a sibling/service) + agent-vault
  network reachability so `fabro validate` LEG1 runs **for-real instead of SKIP** — this is
  where the ~6 live-only fabro bugs would RED locally, before `work_done`.

**5 INVARIANT SURFACES dagger must NOT change:**
- **IS-1 release/publish contract** — `v*` trigger, both-tags-one-digest, rollback-by-tag.
- **IS-2 real Dockerfile + tests, no divergence** — dagger builds the real Dockerfile as-is.
- **IS-3 agent-vault is the sole cred surface** (ADR-049) — dummy secrets, proxy injects real.
- **IS-4 GHCR image/label contract** (lead-5xnd) — labels/visibility/digest identity.
- **IS-5 BC owns its CI** (ADR-018/021/022) — productionize by DISPATCH, never lead edits.

**WRAP not REPLACE — the no-divergence contract.** One dagger module exposes the **same
build core** two ways: `build+test` (local dev CLI) and `build+test+push` (CI). GHA becomes
a **thin `dagger/dagger-for-github` wrapper** that keeps the `v*` trigger, GHCR credential
source, visibility PATCH, and tag/rollback semantics — dagger absorbs only the build+push
**execution** and *adds* the local test/e2e loop. The `docker/build-push-action@v6` step is
precisely what dagger replaces; the release contract stays byte-for-byte.

**Dogfood.** Slice 4 dispatch runs under `--orchestrator fabro`; dagger is exactly the
real-build check the fail-closed fabro Reviewer (ADR-051, sole gated emitter) currently
lacks — it closes the structural gap **inside** the loop before `work_done`. Nesting hazard
to watch: dagger-engine-in-fabro-node-in-BC-container (socket + engine boot + resource cost).

---

## (d) The agent-vault credential seam for dagger

The recipe mirrors fabro's proven bypass and keeps IS-3 intact:

1. **dagger secrets carry ONLY dummy values** (`GITHUB_TOKEN=dummy`, etc.). The proxy
   injects real creds **on-wire**; nothing real is ever in a dagger secret or an image layer.
2. **Client-side bridge.** The host has `HTTPS_PROXY=agent-vault:14322` + the MITM CA
   (`~/.agent-vault/mitm-ca.pem`, exported via the SSL_CERT_FILE / REQUESTS_CA_BUNDLE /
   CURL_CA_BUNDLE / NODE_EXTRA_CA_CERTS / GIT_SSL_CAINFO / DENO_CERT fan; `NO_PROXY`
   includes agent-vault). A `cmd://` fetch script runs on the client host, inherits that
   proxy env, and dagger wraps its stdout as a scrubbed `Secret`.
3. **The hard part — engine/BuildKit egress.** The dagger **engine carries no
   `HTTP(S)_PROXY` / CA and cannot resolve `agent-vault`**, and BuildKit build steps do NOT
   inherit the host proxy/CA. So the ~dozen build-time HTTPS `RUN`s in the real bc-base
   Dockerfile leave the engine with **direct** egress today. Slice 1 must decide how to
   thread agent-vault into the engine + build steps: (i) configure the engine container
   with proxy env + inject the MITM CA into build-time `RUN` egress **without editing the
   Dockerfile** (IS-2 tension — `python:3.11` base does not trust the MITM CA), or (ii)
   accept direct egress for the build host as policy. This is the **central Slice-1 risk**.

---

## (e) Cross-cutting risks + open questions (carried into Slice 1/2)

1. **[Slice 1, central risk] Engine/BuildKit egress through agent-vault.** Does the engine
   inherit `HTTPS_PROXY` + MITM CA, and can that propagate to build-time `RUN` steps of an
   **unmodified** Dockerfile whose `python:3.11` base doesn't trust the MITM CA? Resolve
   before Slice 2, or explicitly accept direct build egress as policy.
2. **[Slice 1] Release-contract fidelity.** Confirm dagger `dockerBuild` + publish
   reproduces build-args, OCI labels (incl. defeating upstream 3.1.2), both-tags-one-digest,
   and the visibility PATCH (IS-1/IS-4) — and that the SAME build core backs both the local
   `build+test` fn and the CI `build+test+push` fn.
3. **[Slice 2] Fabro-e2e nesting + reachability (Seam C).** Can dagger launch the real
   `docker run bc-base --orchestrator fabro` sibling (docker-out-of-docker) and reach
   agent-vault broker + messaging DB (`SHOPMSG_DSN`) so `fabro validate` LEG1 runs for-real?
   Hardest/highest-value item.
4. **[Slice 2, dogfood] Engine-in-BC-container viability.** Does a full dagger engine boot
   inside a BC container (resource/perf), for the Slice-4 dogfood nesting?
5. **[Slice 4, defer] Test-suite reconciliation.** The `test_bc_base_*` Dockerfile-shape
   pins may become redundant once dagger builds the real image. Flag for the BC to reconcile
   in Slice 4; do NOT pre-decide — keep the fast structural tier AND add a real-image tier.
6. **[cheap Slice-1 checks]** Build-context provenance for the Slice-2 throwaway (scratchpad
   fixture vs. running inside a bc-launcher container, since the Dockerfile+assets are
   read-only-observable but not cloned per ADR-018); vscode docker-group membership for
   engine provisioning; engine runs **privileged** (note for hardened runners).

---

## (f) RECOMMENDATION for Slice 1 (spec the target pipeline)

**Proceed to Slice 1 as planned — no blockers.** Spec ONE Python-SDK dagger module,
`engineVersion`-pinned to v0.21.7, that exposes the same build core two ways: a local
`build-and-test` function (dockerBuild the real `docker/bc-base` + `docker/bc-lead`
Dockerfiles verbatim, then run the real launcher tests — plus a real-image tier — against
the freshly built image) and a CI `build-test-and-push` function that adds only the GHCR
push. Nail the **WRAP-not-REPLACE** contract: `publish-bc-base.yml` keeps its `v*` trigger,
GHCR credential source, dual-tag-one-digest, OCI labels, visibility PATCH, and rollback
semantics, and swaps its `docker/build-push-action@v6` step for a `dagger/dagger-for-github`
call to the same module (IS-1/IS-4 preserved). The **make-or-break design decision to
resolve first** is the agent-vault egress path into the dagger engine + BuildKit build
steps — spec whether the engine gets proxy env + MITM-CA injection into unmodified-Dockerfile
`RUN` egress (preserving IS-2/IS-3) or direct build egress is accepted as policy; everything
else (build primitive, RED propagation, `cmd://` client-side secret bridge, same-command
local+CI) is already proven in Leg A. Carry the fabro-e2e nesting (Seam C) as the explicit
Slice-2 target and the sole reason the spike delivers value the current structural loop
cannot.
