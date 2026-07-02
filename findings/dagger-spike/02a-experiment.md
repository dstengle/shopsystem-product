# Slice 2 — the EXPERIMENT (load-bearing proof): dagger REDs on a real fabro-style defect the structural pytest suite stays GREEN on

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Epic:** lead-fzxt (Slice 2, EXPERIMENT leg)
**Inputs:** Slice 0 (`00-*`), Slice 1 spec (`01-*`), Slice 1a egress recipe (`01a-egress.md`).
**Engine:** dagger v0.21.7, custom `dagger-egress-engine` (privileged, `shopsystem` net) per the 01a recipe.

## BOTTOM LINE

**PROVED.** Dagger, building the REAL bc-base fabro-install RUN block VERBATIM through the
agent-vault MITM engine, goes **RED locally** on a fabro-style asset-naming defect **while the
structural pytest gate stays GREEN** — before any version tag. Two independent clean splits
were demonstrated (a fabro asset-sidecar 404 caught at build time; a shim-not-a-listener bug
caught by a real-image listen smoke). The no-divergence push (dual-tag / one-digest, same
build core) was also observed against a local registry.

| Claim | Result |
|-------|--------|
| dagger builds the REAL bc-base slice (verbatim fabro block) through agent-vault | **YES** (GREEN; fabro+agent-vault downloaded through the proxy, real-image tier ran the baked CLIs) |
| dagger REDs on a real fabro-style defect while structural pytest stays GREEN | **YES** — the load-bearing proof (2 clean splits: sidecar-404 + shim-not-a-listener) |
| no-divergence push observed (same core, dual-tag one-digest) | **YES** (`:v0.3.48` and `:latest` → identical `sha256:a1b927…bad6`) |
| CA-trust verbatim-for-free? | **NO** — real bc-base establishes agent-vault CA trust ONLY at runtime (entrypoint), never at build time; a build-time CA-trust prerequisite layer is required (01a option 2) |
| blocker | none |

---

## 1. THE REAL bc-base BUILD CONTEXT (fetched read-only into scratchpad, ADR-018)

Fetched via read-only `gh api` (dummy `GH_TOKEN`, proxy injects) into
`…/scratchpad/bc-base-ctx/` — **not** persisted into `/workspace`:
`Dockerfile` (20214 B, 332 lines), `agent-vault-ca.sh`, `anthropic-oauth-shim`,
`bc-healthcheck.sh`, `bootstrap-entrypoint.sh`.

**The fabro-install RUN block (real Dockerfile lines 131-147)** — `ARG FABRO_VERSION=v0.254.0`;
`uname -m` → Rust target-triple; downloads `fabro-${FABRO_TRIPLE}.tar.gz` (+ `.sha256` sidecar)
from `github.com/fabro-sh/fabro/releases/download/${FABRO_VERSION}`; `sha256sum -c`;
`--strip-components=1`; `install …/usr/local/bin/fabro`; build-time `fabro --version` self-check.
The comment block explicitly records bead **0fz**: the earlier goreleaser-style guess
`fabro_${VER}_linux_${ARCH}.tar.gz` **404'd** against fabro's real Rust assets.

**CA-trust ordering (the decisive residual answer).** The FIRST egress RUN is line 70
(`pip install … git+https://github.com/dstengle/…`). There is **NO** `update-ca-certificates`
/ agent-vault CA-trust step anywhere before the egress RUNs. `agent-vault-ca.sh` is only
`COPY`'d at line 255 and wired as the **runtime ENTRYPOINT** (+ `/etc/profile.d`). So the real
build establishes CA trust **only at container runtime, never at build time** — because the real
CI runner has direct public egress (no MITM). **Through the agent-vault MITM this is NOT
verbatim-for-free** (proof in §3.1).

Verified fabro v0.254.0 assets (read-only `gh api`): real
`fabro-x86_64-unknown-linux-gnu.tar.gz` (+`.sha256`) **exists**; goreleaser form
`fabro_0.254.0_linux_amd64.tar.gz` **does not** (404 = bead 0fz).

---

## 2. THE DAGGER MODULE + ENGINE

### 2.1 Module (`…/scratchpad/bc-launcher-ci/`, Python SDK, `engineVersion: "v0.21.7"`)

One shared build CORE + four functions (full source in scratchpad `src/bc_launcher_ci/main.py`):

- `build(source, dockerfile, fabro_version)` → `Container` — `source.docker_build(dockerfile=…,
  build_args=[BuildArg("FABRO_VERSION", …)])`. Builds the Dockerfile **verbatim**; a bad
  asset/pin 404s the fabro RUN and REDs the DAG.
- `build_and_test` → LOCAL gate: `build()` + real-image tier (`fabro --version`,
  `agent-vault --version`, `anthropic-oauth-shim --help`, `command -v` battery → `REAL_IMAGE_TIER_OK`).
- `shim_listen_smoke` → starts `anthropic-oauth-shim` and probes a bounded TCP connect to
  `127.0.0.1:8788` (fabro ADR-049 D2 base_url); REDs on shim-not-a-listener.
- `build_test_and_push(…, version, registry)` → CI gate: SAME core + tests, then
  `base.publish(:version)` and `base.publish(:latest)`, compares digests (dual-tag one-digest).

`build-and-test` and `build-test-and-push` both call the **identical `self.build()` core**
via the **identical `dagger call` shape** → the no-divergence property is structural, not asserted.

### 2.2 The faithful SLICE (IS-3) — `Dockerfile.slice`

The full 2.1 GB verbatim build is impractical to iterate on, so per the brief a **faithful
slice** is used: the agent-vault install (lines 90-106), the fabro install (lines 131-147), and
the `anthropic-oauth-shim` COPY+self-check (lines 162-164) are **byte-verbatim** from the real
Dockerfile (extracted with `sed -n`, spliced un-re-expanded). The ONLY addition is a **CA-trust
prerequisite layer** (`COPY agent-vault-ca.pem` → system store + `SSL_CERT_FILE`/
`REQUESTS_CA_BUNDLE`/`PIP_CERT`/`GIT_SSL_CAINFO` fan) — the 01a option-2 infra prerequisite, NOT
app divergence. The fabro RUN block under test is identical to the real one, so its build-time
egress + asset download are exercised for real.

### 2.3 Engine provisioning (01a recipe + THREE new Slice-2 findings)

Base recipe (01a): privileged engine on `shopsystem` net; `HTTP(S)_PROXY` = agent-vault handle
(IP `192.168.0.2:14322`); `_EXPERIMENTAL_DAGGER_RUNNER_HOST=docker-container://dagger-egress-engine`.

- **NEW-A — NO_PROXY apex entries.** Go's `httpproxy` treats a leading-dot `.mcr.microsoft.com`
  as **subdomains only**; the apex `mcr.microsoft.com` base-image pull was still MITM'd
  (`x509`). Fix: add the **apex** forms (`mcr.microsoft.com`, `data.mcr.microsoft.com`) +
  `.azureedge.net`/`.azurefd.net` so the PUBLIC base pull stays direct.
- **NEW-B — the two-engine / infra-egress split.** The Python-SDK **module runtime codegen**
  (go proxy `proxy.golang.org`, pip/pypi) runs INSIDE the target engine; against the MITM engine
  it `x509`-failed (`ensure dagger package … gqlgen … certificate signed by unknown authority`).
  Fix: whitelist **dagger-infra hosts** (`proxy.golang.org,sum.golang.org,storage.googleapis.com,
  pypi.org,.pythonhosted.org`) in the engine `NO_PROXY` so the module runtime builds **direct**,
  while **github.com is deliberately NOT whitelisted** → fabro/agent-vault **release downloads
  stay PROXIED** through agent-vault (IS-2 intact). `dagger init/develop` were run against the
  **default direct-egress engine**; only `dagger call` targets the egress engine.
- **NEW-C — docker daemon cannot see scratchpad host mounts.** `docker run -v <scratchpad>:…`
  silently mounts an **empty dir** (the daemon's filesystem view ≠ this devcontainer shell), so
  the 01a `-v combined-ca.pem` engine mount was **inert** (harmless — RUN-egress CA comes from
  the slice's `COPY agent-vault-ca.pem`, which dagger loads **client-side** via
  `host | directory`, not a docker mount). Engine config that MUST live inside the engine
  (`/etc/dagger/engine.toml`) is injected with **`docker cp` + `docker restart`**, not `-v`.

---

## 3. RESULTS

### 3.1 CA-trust residual — VERBATIM FULL build FAILS (NOT verbatim-for-free)

`dagger … host | directory <ctx> | docker-build --dockerfile Dockerfile` (the REAL 332-line
Dockerfile, unmodified) through the egress engine:

- base pull `mcr.microsoft.com/devcontainers/python:3.11` → **OK** (NO_PROXY-direct, NEW-A).
- FIRST egress RUN (line 70, pip-from-git) →
  `fatal: unable to access 'https://github.com/dstengle/shopsystem-messaging.git/': SSL
  certificate problem: unable to get local issuer certificate` → **build RED (exit 1)**.

The git clone **reached github through agent-vault** (proxy routing works, 01a Finding 3) but the
`python:3.11` base does **not** trust the Agent Vault Root CA and the Dockerfile adds no
build-time CA trust. **Answer to the Slice-1 verify-first item: CA-trust is NOT verbatim-for-free;
the real bc-base needs a build-time CA-trust prerequisite (01a option 2) to build through a MITM.**

### 3.2 GREEN baseline — the faithful slice builds through agent-vault + real-image tier runs

`dagger call build-and-test --source=<ctx> --fabro-version=v0.254.0` (egress engine):
fabro + agent-vault downloaded **through the proxy** (github not in NO_PROXY), then:
```
/usr/local/bin/fabro
/usr/local/bin/agent-vault
/usr/local/bin/anthropic-oauth-shim
REAL_IMAGE_TIER_OK      (exit 0)
```
`shim_listen_smoke` on the good slice → `SHIM_LISTENING_8788_OK` (exit 0) — the real shim binds
127.0.0.1:8788.

### 3.3 THE PROOF — RED-vs-GREEN splits

The structural gate reproduced is the fabro-leg assertion battery **extracted verbatim** from the
public `tests/conftest.py` (`then_fabro_version_reports`, lines ~12278-12352) +
`_strip_dockerfile_comments` (line 10842) — i.e. exactly what
`pytest tests/test_bc_base_fabro_and_oauth_shim.py` evaluates for the install leg. (The
`fabro --version` runtime leg runs against the **FakeDockerDriver**, which returns a canned
exit-0 regardless of whether the real download works — the structural gap the feature file itself
admits: "docker is unavailable in this environment.") Running the full pytest requires cloning the
BC package (ADR-018) and pytest isn't installed, so the gate's exact expressions were run against
the Dockerfile texts — faithful to the gate's own logic.

**Defect A — goreleaser asset name (bead 0fz, the brief's "sharpest").** Revert the fabro asset to
`fabro_${FABRO_VERSION#v}_linux_amd64.tar.gz`.
- Structural gate: **RED** — `[FAIL] composes real fabro-${FABRO_TRIPLE}.tar.gz asset name`.
- dagger `build-and-test`: **RED** — `curl: (22) … 404` at the fabro RUN (exit 22).
- **HONEST NUANCE:** the structural suite was **hardened after 0fz** with an explicit text-pin
  asserting `fabro-${FABRO_TRIPLE}.tar.gz` and rejecting the goreleaser form. So the brief's
  suggested defect is now **double-caught** — NOT a clean split. This is itself a finding: text
  pins are **reactive** — they only catch the exact regression someone already wrote a string for.

**Defect B — sha256 sidecar naming (`.sha256` → `.sha256sum`), a realistic 0fz sibling the
text-pins DON'T anticipate.** The main tarball name stays correct; only the checksum sidecar URL
changes.
- Structural gate: **GREEN** — all six asserts PASS (no assert covers the sidecar extension):
  `ARG FABRO_VERSION pin ✓ · fabro-sh/fabro ✓ · /usr/local/bin/fabro ✓ · Rust triples ✓ ·
  fabro-${FABRO_TRIPLE}.tar.gz ✓ · fabro --version ✓ → GREEN`.
- dagger `build-and-test`: **RED** — main tarball downloads (through agent-vault), then
  `curl -fsSL …/fabro-x86_64-unknown-linux-gnu.tar.gz.sha256sum` → `curl: (22) … 404` (exit 22).
- **→ THE CLEAN SPLIT: structural GREEN, dagger RED, locally, before any tag.**

**Defect C — shim-not-a-listener (the sharpest "green-but-broken").** A broken
`anthropic-oauth-shim` that still parses `--help` (argparse → exit 0) but `return`s before binding
the `ThreadingHTTPServer`.
- Structural check (`python3 <shim> --help` exit 0 + stdlib-only) and dagger's own `--help` tier
  (`build-and-test`): **GREEN** — `REAL_IMAGE_TIER_OK` (exit 0). A `--help`-only gate cannot see it.
- dagger `shim_listen_smoke` (real-image bounded listen on 127.0.0.1:8788): **RED** —
  `SHIM_NOT_LISTENING` (exit 1).
- **→ SECOND CLEAN SPLIT: the real-image listen smoke catches what `--help` + the structural
  suite miss.**

### 3.4 NO-DIVERGENCE push (same core, dual-tag one-digest)

Local registry `registry:2` on the `shopsystem` net; engine marks it insecure via
`docker cp engine.toml` (`[registry."192.168.0.4:5000"] http=true insecure=true`) + restart.
`dagger call build-test-and-push --version=v0.3.48 --registry=192.168.0.4:5000/bc-base`:
```
REAL_IMAGE_TIER_OK                                    # SAME core + tests ran FIRST
pushed v0.3.48 -> …/bc-base:v0.3.48@sha256:a1b927c85e97…bad6
pushed latest  -> …/bc-base:latest @sha256:a1b927c85e97…bad6
SAME-DIGEST                                           # dual-tag → ONE digest (IS-4)
# registry: {"repositories":["bc-base"]}  {"tags":["v0.3.48","latest"]}
```
The **identical build core** backs the local `build-and-test` and the CI-shape
`build-test-and-push`; dual-tag-one-digest is content-addressed. Same-command-locally-and-in-CI
observed, not asserted.

---

## 4. RESIDUALS (confirm/deny for Slice 3)

- **CA-trust verbatim-for-free? DENIED (§3.1).** The real bc-base establishes agent-vault CA trust
  only at runtime (entrypoint), never before its build-time egress RUNs. Building the real
  Dockerfile through a MITM needs a **build-time CA-trust prerequisite** (01a option 2: an org
  CA-base `FROM`, or a base-image variant carrying the CA + Python/pip/git env fan). Under real CI
  (public egress, no MITM) the Dockerfile is verbatim as-is — the tension is **MITM-local only**.
  **Slice-3 ADR input:** either graduate the CA-trust base as the sanctioned local-loop
  prerequisite, or scope the local dagger loop to the CA-trusting org base.
- **Private-GHCR resolver (bc-lead FROM bc-base:vX): sidestepped, not exercised.** The slice is
  bc-base-only. For the local loop, bc-lead resolves its base from the **freshly-built local
  base** (the module's `build()` returns a `Container`; a `build_lead` would chain off it), which
  avoids the proxied private-GHCR pull whose engine-resolver CA trust 01a Finding 4 left open.
  Carry to Slice 3/4.
- **New engine-provisioning learnings for the WRAP/CI spec (Slice 3):** NO_PROXY needs registry
  **apex** entries (NEW-A) **and** dagger-infra hosts whitelisted while github stays proxied
  (NEW-B); engine config that must live inside the engine is injected via `docker cp`+restart, not
  a host `-v` (NEW-C). In CI (`dagger/dagger-for-github`) the runner shares agent-vault's network
  and the same env/config is applied to the provisioned engine.

## 5. Throwaway hygiene / repro artifacts

Branch `dagger-spike`; main untouched; no BC source persisted into `/workspace` (context fetched
read-only into scratchpad only). Repro artifacts live in
`…/scratchpad/{bc-base-ctx,bc-launcher-ci,bc-tests,structural_gate.py,engine.toml}`. Live objects
left running for inspection: `dagger-egress-engine` (agent-vault engine, insecure-registry cfg),
`dagger-spike-registry` (192.168.0.4:5000). Remove with `docker rm -f` when done.
</content>
