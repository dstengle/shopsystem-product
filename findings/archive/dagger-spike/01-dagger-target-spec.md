# Slice 1 — Dagger target spec (the module + the WRAP integration)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Epic:** lead-fzxt (Slice 1) · **Track:** odqd
**Inputs:** Slice 0 recon (`00-dagger-recon.md` + legs 00a/00b/00c) + the EGRESS resolution
(`01a-egress.md`). This spec is the throwaway-experiment target for Slice 2 and the
graduation source (ADRs+scenarios) for Slice 3.

**Scope note (ADR-018).** This is a SPEC written on the lead host. It cites only the
contract/artifact surface (the read-only-observable public bc-launcher CI + Dockerfiles,
the on-host dagger proofs from Slices 0/1a). No BC source is cloned here; the real module
lands inside the bc-launcher repo via Slice-4 dispatch (IS-5). The `src/` sketches below
are the SPEC of what that BC will author, not lead-owned code.

---

## 0. One-paragraph shape

ONE Python-SDK dagger module, `engineVersion` pinned to **v0.21.7**, exposes a small set of
functions over **ONE shared build core**. The core `dockerBuild`s the **real**
`docker/bc-base/Dockerfile` (and, chained, `docker/bc-lead/Dockerfile`) **verbatim** (IS-3),
threading agent-vault egress into the engine per the proven `01a` recipe. Two public
entrypoints wrap that core: **`build-and-test`** (LOCAL: build + structural pytest tier +
NEW real-image tier) and **`build-test-and-push`** (CI: the same core + GHCR dual-tag push,
IS-4). `publish-bc-base.yml` is WRAPPED not replaced — only its `docker/build-push-action@v6`
step becomes a `dagger/dagger-for-github` call to `build-test-and-push`; trigger, credential
source, dual-tag, OCI labels, visibility PATCH, rollback all stay (IS-1/IS-4/IS-5). Because
the module is one pinned engineVersion invoked by the identical `dagger call`, the LOCAL and
CI executions do not diverge — that identity is the whole value proposition.

---

## 1. THE DAGGER MODULE

### 1.1 Module shape

```
bc-launcher/
  ci/                      # the dagger module (lives IN the BC repo, Slice 4)
    dagger.json            # name: bc-launcher-ci ; engineVersion: "v0.21.7"  <- divergence guard
    src/
      main/
        __init__.py        # @object_type BcLauncherCi  — functions below
    pyproject.toml         # dagger-io SDK pin
```

`dagger.json` **`engineVersion: "v0.21.7"`** is the single pin that makes local == CI: the
CLI refuses to run the module under a mismatched engine, so a dev laptop and the GHA runner
resolve the SAME DAG on the SAME engine.

### 1.2 The shared build CORE (one function every entrypoint calls)

```python
@object_type
class BcLauncherCi:

    @function
    async def _build_base(
        self,
        source: dagger.Directory,          # host | directory <repo-root> ; passed as ABS path (Slice-0 gotcha)
        fabro_version: str = "v0.254.0",   # -> --build-args FABRO_VERSION=... (real ARG, Finding 2 control)
        # ...the other VCS-pin ARGs the Dockerfile declares (messaging/scenarios/shop-templates/self-pin)
    ) -> dagger.Container:
        # dockerBuild the REAL Dockerfile VERBATIM (IS-3). No hand-ported variant.
        return source.docker_build(
            dockerfile="docker/bc-base/Dockerfile",
            build_args=[dagger.BuildArg("FABRO_VERSION", fabro_version), ...],
        )
```

- The `dockerBuild` primitive was proven in Slice 0 (Leg A): builds the actual Dockerfile
  through the BuildKit frontend, RUN/COPY/ENV/WORKDIR honored, no divergence.
- **build-time self-checks are free coverage.** The real bc-base Dockerfile already runs
  `--version`/`--help` self-checks on every baked CLI (fabro, shim, scenarios, bd, gh) as
  build-time `RUN`s; a bad pin fails the build. `dockerBuild` propagates that RED to the
  dagger process (Leg A RED-propagation), so the core catches the cheapest defect class
  with zero extra code.
- **bc-lead** is the chained second build (`FROM bc-base:BASE_VERSION`); spec it as
  `_build_lead(base_ref)` reusing the base digest. NOTE the `01a` open item: a **private
  GHCR** `FROM` pull needs engine-resolver CA trust that `SSL_CERT_FILE` did NOT satisfy —
  for the local loop, resolve bc-lead's base from the freshly-built local image (pass the
  built base `Container` / local tag rather than a GHCR pull) to sidestep the resolver gap.
  bc-base's own `FROM mcr.microsoft.com/...` is PUBLIC → `NO_PROXY`-direct, unaffected.

### 1.3 Inputs

| Input | Vehicle | Notes |
|-------|---------|-------|
| repo source | `dagger.Directory` (`host | directory <ABS>`) | absolute path (Slice-0 cwd gotcha) |
| `FABRO_VERSION` + the VCS pins | `--build-args` (declared `ARG`s) | Finding 2: dagger passes declared ARGs fine; do NOT rely on predefined `http_proxy` ARG (ignored) |
| agent-vault credential | engine env + `cmd://` secret bridge | dummy value; proxy injects real on-wire (IS-2) |
| GHCR token (CI only) | `env://` / `cmd://` dummy secret | proxy injects; used by push tier only |

### 1.4 Egress recipe (from `01a`, folded into module provisioning)

The module does NOT invent egress; it **requires the engine be provisioned per the `01a`
recipe** and documents that as a precondition (a `bin/dagger-engine-up` helper in the BC
repo, plus the CI `env:` block in §2):

1. **Engine container: privileged + on the `shopsystem` docker net** (192.168.0.0/20).
   Default `bridge` has no route to the proxy at 192.168.0.2 (Finding 1).
2. **Proxy env on the engine:** `HTTP(S)_PROXY`/`http(s)_proxy` = the agent-vault handle
   (`http://av_agt_...@192.168.0.2:14322`, IP not DNS). BuildKit propagates daemon proxy
   env into every `RUN` (Finding 3) — **zero Dockerfile edits** for the proxy half.
3. **`NO_PROXY`** = `localhost,127.0.0.1,.docker.io,.docker.com,.cloudfront.net,`
   `.cloudflare.docker.com,.mcr.microsoft.com,registry.dagger.io` so PUBLIC base-image
   pulls stay direct (Finding 4 — proxied pulls x509-fail; the resolver ignores engine
   `SSL_CERT_FILE`).
4. **MITM CA trust inside `RUN`:** must come from the BASE IMAGE (Finding 5 — no engine
   knob injects a CA file into a `RUN` rootfs). **Slice-1 VERIFY item (cheap, do first in
   Slice 2):** does the real bc-base establish agent-vault CA trust EARLY (before the
   pip-from-git `RUN`s)? It bakes agent-vault v0.32.0 + CA/bootstrap entrypoints — if that
   CA trust (system store **and** the Python `certifi`/pip/git env fan: `SSL_CERT_FILE`,
   `REQUESTS_CA_BUNDLE`, `PIP_CERT`, `GIT_SSL_CAINFO`) lands before the egress RUNs and
   matches the CI CA, the real Dockerfile is **verbatim for free** (IS-3 fully satisfied).
   If NOT, fall to `01a` option 2 (pin `FROM` to an org CA-base — one-line, minimal IS-3
   bend) — NEVER option 3 (direct egress violates IS-2).
5. Point the CLI at the engine via `_EXPERIMENTAL_DAGGER_RUNNER_HOST=docker-container://<engine>`.

### 1.5 The agent-vault SECRET seam (IS-2)

Per Slice-0 Leg A: `cmd://` runs on the CLIENT HOST and inherits the host's proxy env.
The module takes credential inputs as `dagger.Secret` sourced `cmd://<fetch-script>` (dummy
token; the host-side script calls agent-vault through the proxy). dagger SCRUBS the value
from its logs; **nothing real is baked into any image layer**. Same shape locally and in CI
(in CI the fetch script/`env://` reads the runner's agent-vault handle). This satisfies IS-2
end to end.

### 1.6 Public function A — `build-and-test` (LOCAL)

```python
@function
async def build_and_test(self, source: dagger.Directory, fabro_version: str = "v0.254.0") -> str:
    base = self._build_base(source, fabro_version)          # real build (self-checks RED here)
    # TIER 1 — structural pytest (relocation of the existing suite; fast, fakes)
    struct = await (source.with_... .with_exec(["pytest", "tests/", "-q"]).stdout())
    # TIER 2 — NEW real-image tier: run the FRESHLY BUILT image, exercise what the fakes cannot
    real = await (base
        .with_exec(["fabro", "--version"])
        .with_exec(["anthropic-oauth-shim", "--help"])       # + a bounded `listen` smoke (see §3)
        .with_exec(["sh", "-c", "command -v scenarios && command -v bd && command -v gh"])
        .with_exec(["sh", "-c", "<the build-time self-check battery, re-run against the live image>"])
        .stdout())
    return struct + real
```

- **Tier 1** is the existing 46-feature structural pytest-bdd suite, run under dagger. This
  is *relocation-only* value (Seam B) — keep it because it is fast and it is the current
  contract; do NOT delete the `test_bc_base_*` Dockerfile-shape pins in Slice 1 (Slice-4
  reconciliation decides that, per Slice-0 open item 5).
- **Tier 2 is the NEW value** — the "empty middle" the structural fakes never cover: it
  RUNS the real freshly-built image (`with_exec` against the `base` container) and asserts
  the baked CLIs actually execute (`fabro --version`, `anthropic-oauth-shim --help` +
  bounded listen smoke, `scenarios`/`bd`/`gh` present, the self-check battery live). A
  nonzero exit REDs the dagger process (Leg A RED-propagation).
- Returns nonzero → `dagger call build-and-test` exits nonzero → usable as a local
  pre-tag gate.

### 1.7 Public function B — `build-test-and-push` (CI)

```python
@function
async def build_test_and_push(
    self, source: dagger.Directory, version: str, fabro_version: str = "v0.254.0",
    ghcr_token: dagger.Secret, registry: str = "ghcr.io/dstengle/shopsystem-bc-base",
) -> str:
    combined = await self.build_and_test(source, fabro_version)   # SAME CORE + SAME TESTS first
    base = self._build_base(source, fabro_version)
    # GHCR push: dual-tag {version, latest} at ONE digest (IS-4), OCI labels applied by the
    # Dockerfile/publish (version=ref_name, revision=sha, shopsystem.shop-templates.version;
    # defeats upstream 3.1.2). Publish returns one digest; tag it twice.
    ref = await base.with_registry_auth("ghcr.io", "x", ghcr_token)
    d1  = await base.publish(f"{registry}:{version}")
    d2  = await base.publish(f"{registry}:latest")   # same content -> same digest
    return f"{combined}\npushed {d1} == {d2}"
```

- The push tier runs ONLY AFTER build-and-test is green — CI now gains the local loop's
  test coverage it never had (Slice-0 finding: NONE of the 3 workflows run tests).
- **Dual-tag-one-digest / OCI labels / visibility PATCH** are the IS-4 release contract.
  dagger `publish` of identical content yields the same digest; the visibility=public PATCH
  stays in the GHA wrapper (§2) as a non-fatal post-push step (it is a GitHub API call, not
  a build concern). Confirm digest identity as a Slice-2 check (Slice-0 open item 2).

### 1.8 Same command locally + in CI (IS: no divergence)

- Local: `dagger call build-and-test --source=. --fabro-version=v0.254.0`
- CI: `dagger/dagger-for-github@v8.3.0` with `verb: call` /
  `args: build-test-and-push --source=. --version=${{ github.ref_name }} ...` — the SAME
  module, SAME engineVersion, SAME function. One DAG, two entrypoints, zero divergence.

---

## 2. THE WRAP-NOT-REPLACE CHANGE to `publish-bc-base.yml`

**Principle:** swap ONLY the `docker/build-push-action@v6` step for a `dagger/dagger-for-github`
call to `build-test-and-push`. Everything that makes it a *release* — the `v*` trigger, the
GHCR credential source (`secrets.GITHUB_TOKEN`), the dual-tag, the OCI labels, the visibility
PATCH, the rollback — stays in the workflow. dagger absorbs the build+push EXECUTION and ADDS
the test tiers; the release contract stays byte-for-byte (IS-1/IS-4/IS-5).

### BEFORE (today, sketch of the real job-1 build step)

```yaml
on:
  push:
    tags: ['v*']                       # <- KEEP
jobs:
  build-base:
    runs-on: ubuntu-latest
    permissions: { packages: write, contents: read }
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3   # <- KEEP (GHCR cred source = secrets.GITHUB_TOKEN)
        with: { registry: ghcr.io, username: ${{ github.actor }}, password: ${{ secrets.GITHUB_TOKEN }} }
      - uses: docker/build-push-action@v6           # <=== THE ONLY STEP DAGGER REPLACES
        with:
          context: .
          file: docker/bc-base/Dockerfile
          push: true
          build-args: FABRO_VERSION=${{ ... }}
          tags: |
            ghcr.io/.../bc-base:${{ github.ref_name }}
            ghcr.io/.../bc-base:latest                # <- dual-tag KEPT (now via dagger publish)
          labels: |                                    # <- OCI labels KEPT
            org.opencontainers.image.version=${{ github.ref_name }}
            ...
      - name: visibility PATCH                         # <- KEEP (non-fatal GitHub API)
        run: gh api ... -f visibility=public || true
      # rollback-by-tag semantics                      # <- KEEP
```

### AFTER (WRAP)

```yaml
on:
  push:
    tags: ['v*']                       # <- UNCHANGED
jobs:
  build-base:
    runs-on: ubuntu-latest                             # runner must SHARE agent-vault's network
    permissions: { packages: write, contents: read }
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3                   # <- UNCHANGED (same GHCR cred source)
        with: { registry: ghcr.io, username: ${{ github.actor }}, password: ${{ secrets.GITHUB_TOKEN }} }

      # provision the agent-vault-capable engine (01a recipe) — proxy env + shopsystem net
      - name: dagger engine (agent-vault egress)
        run: bin/dagger-engine-up            # privileged, --network shopsystem, HTTP(S)_PROXY+NO_PROXY
        env:
          AGENT_VAULT_PROXY: ${{ ... }}       # engine env, NOT an image layer (IS-2)

      - uses: dagger/dagger-for-github@v8.3.0          # <=== REPLACES build-push-action ONLY
        with:
          version: v0.21.7                              # == dagger.json engineVersion (divergence guard)
          verb: call
          module: ci
          args: >
            build-test-and-push
            --source=.
            --version=${{ github.ref_name }}
            --fabro-version=${{ ... }}
            --ghcr-token=env://GHCR_TOKEN                # dummy; proxy injects real on-wire
        env:
          _EXPERIMENTAL_DAGGER_RUNNER_HOST: docker-container://dagger-ci-engine
          GHCR_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: visibility PATCH                          # <- UNCHANGED (still a GitHub API call)
        run: gh api ... -f visibility=public || true
      # rollback-by-tag                                 # <- UNCHANGED
```

**What moved:** build+push EXECUTION → dagger, and the workflow GAINED the test tiers (§1.6)
it never ran. **What did NOT move:** trigger, cred source, dual-tag, labels, visibility PATCH,
rollback — the IS-1/IS-4 release contract. job-2 (bc-lead) wraps identically, calling a
`build-lead-and-push` entrypoint; carry the `01a` private-GHCR-resolver open item there.

---

## 3. THE FABRO-E2E TIER (Seam C — the Slice-2 value target, optional/advanced)

Spec it as an **optional advanced function**, `fabro_e2e`, NOT on the default `build-and-test`
path — because it needs runtime privileges the build tier does not:

```python
@function
async def fabro_e2e(self, source, ...) -> str:
    base = self._build_base(source, ...)
    # run the REAL image as a live container under --orchestrator fabro, so `fabro validate`
    # LEG1 runs FOR-REAL instead of pytest.skip (Slice-0: the only near-real test skips offline)
    return await (base
        .with_unix_socket("/var/run/docker.sock", docker_sock)   # docker-out-of-docker nesting
        .with_(agent_vault_network_service)                       # broker reachability + SHOPMSG_DSN
        .with_exec(["fabro", "validate", "--def", "<bc-def>"])
        .stdout())
```

**What is hard (carry as Slice-2 risk, Slice-0 open items 3/4):**
- **docker-socket nesting** — the built image must launch a sibling container (docker-out-of-
  docker). dagger `with_unix_socket` binds the host docker.sock into the exec; the engine is
  already privileged. Resource/perf cost of engine + nested run is real.
- **agent-vault network + broker reachability** — the e2e container needs the `shopsystem`
  net (same as the engine, `01a` Finding 1) AND a live messaging DB (`SHOPMSG_DSN`) + broker
  for `fabro validate` LEG1 to actually exchange. This is the ~6-bug live surface.
- **engine-in-BC-container (Slice-4 dogfood, §5)** — nesting a full dagger engine inside a
  fabro node inside a BC container: socket + engine boot + resource cost. Defer proof to
  Slice 2/4; note it now.

This is the highest-leverage / highest-risk seam (analog of the fabro f6ta Seam-b) and the
SOLE reason the spike delivers value the structural loop cannot. It is optional in Slice 1
so the build+test tiers can land green first, then e2e is layered.

---

## 4. ACCEPTANCE CRITERIA for Slice 2 (the experiment)

Slice 2 is GREEN when a LOCAL `dagger call build-and-test` (or `fabro_e2e`) does ALL of:

1. **Builds the REAL `docker/bc-base/Dockerfile` verbatim** (no hand-ported variant, IS-3),
   through the agent-vault engine (`01a` recipe), with the CA-trust question resolved
   (verify-first item §1.4.4) — build-time egress RUNs succeed THROUGH agent-vault, dummy
   creds only (IS-2).
2. **Runs the structural pytest tier AND the real-image tier** (§1.6) against the freshly
   built image — the tier the structural fakes lack executes the baked CLIs live.
3. **REDs on a fabro-style defect the structural loop MISSED** — the load-bearing proof.
   Reproduce ONE of the ~6 live-only fabro-launcher bugs and show dagger catches it at
   build/real-run time. Candidate defects (pick the cheapest to reproduce):
   - **fabro asset-URL 404** — a bad `FABRO_VERSION`/asset pin: the build-time
     `curl`-download RUN 404s → build REDs (structural fakes never download).
   - **shim-not-a-listener** — `anthropic-oauth-shim` is present but does not actually
     `listen`: the real-image tier's bounded `listen` smoke REDs; a `--help`-only check or
     a fake would pass. This is the sharpest "structural-green-but-broken" demonstration.
   - **Defect-D-style bug** — a baked-CLI `--version` self-check that passes structurally
     (text pin present) but the real binary fails to execute (bad wheel / missing runtime
     dep) → real-run REDs.
   The criterion: introduce the defect (bad pin / broken shim), show the CURRENT structural
   suite stays GREEN, show dagger `build-and-test` goes RED — locally, before any tag/release.
4. **The SAME module/function is the one the WRAP `publish-bc-base.yml` would call** (§2) —
   demonstrate `build-test-and-push` runs the identical core (push tier can target a scratch
   registry for the throwaway). No-divergence property observable, not asserted.
5. **Throwaway hygiene** — the experiment lives on `dagger-spike`, uses a scratchpad build
   context or runs inside a bc-launcher container (Dockerfiles are read-only-observable, not
   cloned per ADR-018); no lead-host BC source, main untouched.

---

## 5. DOGFOOD-FABRO productionization angle (Slice 4)

Slice 4 **DISPATCHES** the real dagger-ification to shopsystem-bc-launcher (IS-5 — the BC
owns its CI; the lead never edits BC source). The module (§1) + the WRAP (§2) become an
`assign_scenarios`/`request_bugfix` target authored from the graduated ADRs+scenarios
(Slice 3). The dogfood payoff: the productionized loop runs UNDER `--orchestrator fabro`, so
dagger becomes exactly the real-build check the fail-closed fabro Reviewer (ADR-051, sole
gated emitter) currently LACKS — it closes the structural gap INSIDE the fabro loop, before
`work_done`. **Nesting hazard to prove in Slice 2/4:** dagger-engine-in-fabro-node-in-BC-
container (docker socket + engine boot + resource cost, §3). Sequence: Slice 2 proves the
value (RED on a real defect); Slice 3 graduates it (ADRs: dagger as local+CI substrate;
same-definition property; agent-vault egress recipe; WRAP relationship to publish-bc-base.yml)
+ authors the scenarios; Slice 4 dispatches, and reconciles the register (including the
Slice-0 open item 5 — whether the `test_bc_base_*` Dockerfile-shape pins fold into the
real-image tier).

---

## 6. Open items carried from Slice 1 into Slice 2

1. **CA-trust verify-first** (§1.4.4) — does the real bc-base establish agent-vault CA trust
   BEFORE its egress RUNs? Determines whether IS-3 is verbatim-for-free or needs the one-line
   org-CA-base `FROM` (`01a` option 2). Do this FIRST in Slice 2.
2. **Private-GHCR engine-resolver CA trust** (`01a` Finding 4 open item) — bc-lead's
   `FROM bc-base:vX` GHCR pull; engine `SSL_CERT_FILE` did not satisfy the dockerfile-frontend
   resolver. For the local loop, resolve bc-lead from the locally-built base to sidestep.
3. **Dual-tag-one-digest + label/visibility fidelity** (Slice-0 open item 2, IS-4) — confirm
   dagger `publish` reproduces digest identity, OCI labels (incl. defeating upstream 3.1.2),
   and that the visibility PATCH stays in the GHA wrapper.
4. **Seam-C nesting** (§3) — docker-out-of-docker + agent-vault broker/`SHOPMSG_DSN`
   reachability for a live `fabro validate` LEG1.
5. **Engine-in-BC-container viability** (§5) — resource/perf of a full engine boot nested for
   the Slice-4 dogfood.
