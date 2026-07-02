# Slice 4 — PRODUCTIONIZE spec (the deliverable shopsystem-bc-launcher must build)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Epic:** lead-fzxt (Slice 4) · **Bead:** lead-6tks
**Graduated from:** ADR-052..055 + `features/dagger-ci/01-04`. **Proof source:** `02-dagger-experiment.md`,
`02a-experiment.md`; **egress recipe:** `01a-egress.md`; **shape:** `01-dagger-target-spec.md`.

**Scope note (ADR-018).** This is a lead-host SPEC. It cites only the contract/artifact surface: the
read-only-observable PUBLIC bc-launcher CI/Dockerfiles (fetched via read-only `gh api`, dummy `GH_TOKEN`,
proxy injects — NOT persisted into `/workspace`), the graduated ADRs+scenarios, and the on-host spike
proofs. **No BC source is cloned here.** The `src/` sketches are the SPEC of what the BC will author in
ITS clone (IS-5 — the BC owns its CI); the lead never edits BC source. This spec is the CARRIER content
for the companion `request_maintenance` dispatch (assign_scenarios has no description field), same pattern
as the fabro-def delivery.

This is the PRODUCTION deliverable — NOT the spike's faithful slice. It builds the REAL Dockerfile
verbatim; the faithful-slice was a spike iteration convenience only.

---

## 0. bc-launcher PRE-STATE (verified read-only, 2026-07-02)

Verified against `dstengle/shopsystem-bc-launcher` (public), read-only `gh api`:

- **Capability is NET-NEW.** `search/code q=dagger` → `total_count: 0`; `contents/dagger.json` → 404;
  `contents/ci` → 404. No dagger anywhere in the repo. (Q1 discriminator: no capability → `assign_scenarios`.)
- **`.github/workflows/publish-bc-base.yml`** (the WRAP target) has TWO build jobs, BOTH using
  `docker/build-push-action@v6`:
  1. `build-and-publish` (bc-base): `context: ./docker/bc-base`, `file: ./docker/bc-base/Dockerfile`,
     `push: true`, `build-args: SHOPSYSTEM_BC_LAUNCHER_VERSION=${{ github.ref_name }}`, dual-tag
     `:${{ github.ref_name }}` + `:latest`, OCI labels (version=ref_name, revision=sha,
     shopsystem.shop-templates.version=<resolved ARG default> — defeats upstream `3.1.2`), then a
     non-fatal `continue-on-error` visibility=public PATCH (user-package endpoint).
  2. `build-and-publish-bc-lead` (bc-lead): `needs: build-and-publish`, `context: ./docker/bc-lead`,
     `FROM ghcr.io/dstengle/shopsystem-bc-base:<version>` (BASE_VERSION build-arg = ref_name) — the
     **private-GHCR-resolver residual lands HERE**. Mirrors bc-base's tag/label/visibility exactly.
  - Trigger `on: push: tags: ['v*']`; `permissions: contents:read, packages:write`; GHCR login via
    `docker/login-action@v3` with `secrets.GITHUB_TOKEN`. Rollback = published-by-version property
    (scenario 41 `be11d615375564e1`); publish contract scenario 37 `b688a5feaf1cf34a`.
- **`docker/bc-base/Dockerfile`** (332 lines): `FROM mcr.microsoft.com/devcontainers/python:3.11`
  (line 22, PUBLIC base → NO_PROXY-direct). Build-time egress RUNs: agent-vault v0.32.0 (~98),
  fabro `ARG FABRO_VERSION=v0.254.0` (131) download from `github.com/fabro-sh/fabro/releases/download`
  (140) + `fabro --version` self-check (147), beads (175). `agent-vault-ca.sh` is COPY'd at line 255
  and wired as the **runtime ENTRYPOINT** (331); comment at 319 confirms "no update-ca-certificates is
  run" at build time. **→ CONFIRMS ADR-055: the real Dockerfile trusts the agent-vault CA only at
  RUNTIME, never before its build-time egress RUNs, so a MITM-local build-time CA-trust prerequisite
  is required (NOT a shipped-path IS-3 bend).** COPY sources (`agent-vault-ca.sh`, `anthropic-oauth-shim`,
  `bc-healthcheck.sh`, `bootstrap-entrypoint.sh`) all live in `docker/bc-base/` → **build context is
  `docker/bc-base`, not repo root** (load-bearing for COPY-path fidelity; the dagger `docker_build`
  MUST use the same context dir).
- **`tests/`**: a pytest-bdd structural suite (`test_bc_base_*` + `test_bc_container_*`);
  `test_bc_base_fabro_and_oauth_shim.py` is the fabro/shim install gate the spike split against;
  `pyproject.toml` `[project] dependencies = []`, has `[tool.pytest.ini_options]`. The dagger module
  needs its OWN `pyproject.toml` (dagger-io SDK pin) under `ci/`.

---

## 1. THE DAGGER MODULE (author under `ci/` in the bc-launcher repo)

```
ci/
  dagger.json          # name: bc-launcher-ci ; engineVersion: "v0.21.7"   <- divergence guard (ADR-053 D1)
  src/bc_launcher_ci/
    main.py            # @object_type BcLauncherCi
  pyproject.toml       # dagger-io SDK pin
```

`engineVersion: "v0.21.7"` is the SINGLE pin that makes local == CI (ADR-053 D1): the CLI refuses a
mismatched engine, so a dev laptop and the GHA runner resolve the SAME DAG on the SAME engine.

### 1.1 ONE shared build CORE

```python
@object_type
class BcLauncherCi:
    @function
    def build(self, source: dagger.Directory,
              dockerfile: str = "Dockerfile",
              fabro_version: str = "v0.254.0") -> dagger.Container:
        # source = the docker/bc-base build context (ABS path client-side, Slice-0 cwd gotcha).
        # docker_build the REAL Dockerfile VERBATIM (IS-3) — no hand-ported variant.
        return source.docker_build(
            dockerfile=dockerfile,
            build_args=[dagger.BuildArg("FABRO_VERSION", fabro_version)],  # + declared VCS-pin ARGs
        )
```

- Build context = `docker/bc-base` (matches the current workflow context so COPY paths stay verbatim).
- Build-time self-checks (`fabro --version` @147 etc.) are free coverage: a bad pin REDs the build and
  `docker_build` propagates that RED to the dagger process.

### 1.2 `build-and-test` (LOCAL gate) — scenarios 01 + 02

```python
@function
async def build_and_test(self, source, fabro_version="v0.254.0") -> str:
    base = self.build(source, fabro_version=fabro_version)   # real build; asset-sidecar 404 REDs HERE (scn 01)
    real = await (base
        .with_exec(["fabro", "--version"])
        .with_exec(["agent-vault", "--version"])
        .with_exec(["anthropic-oauth-shim", "--help"])
        .with_exec(["sh","-c","command -v scenarios && command -v bd && command -v gh"])
        .stdout())                                            # REAL_IMAGE_TIER_OK
    struct = await (source.with_exec(["pytest","tests/","-q"]).stdout())  # Tier 1 structural relocation
    return real + struct

@function
async def shim_listen_smoke(self, source, fabro_version="v0.254.0") -> str:
    base = self.build(source, fabro_version=fabro_version)   # bounded TCP connect 127.0.0.1:8788 (ADR-049 D2)
    # REDs SHIM_NOT_LISTENING on a shim that parses --help but never binds (scn 02)
```

- **scenario 01** (`2c66a1b1d1b6f092`): the checksum-sidecar 404 REDs `build-and-test` while the
  structural suite (FakeDockerDriver canned exit-0, no sidecar text-pin) stays GREEN — before any tag.
- **scenario 02** (`c7b2c587be09770b`): `shim_listen_smoke` REDs on the non-binding shim while `--help`
  + structural stay GREEN. Real-image liveness the `--help` gate cannot see.
- Tier-1 structural suite is RELOCATION value (fast, current contract) — keep it; whether the
  `test_bc_base_*` Dockerfile-shape pins FOLD into the real-image tier is a **reconciliation decision**
  (residual R3), NOT decided in the dispatch.

### 1.3 `build_test_and_push` (CI gate) — scenario 03

```python
@function
async def build_test_and_push(self, source, version, ghcr_token: dagger.Secret,
                              fabro_version="v0.254.0",
                              registry="ghcr.io/dstengle/shopsystem-bc-base") -> str:
    combined = await self.build_and_test(source, fabro_version)   # SAME CORE + SAME TESTS FIRST (gate)
    base = self.build(source, fabro_version=fabro_version)
    authed = base.with_registry_auth("ghcr.io", "x", ghcr_token)
    d1 = await authed.publish(f"{registry}:{version}")
    d2 = await authed.publish(f"{registry}:latest")               # same content -> same digest
    return f"{combined}\npushed {version} {d1} == latest {d2}"
```

- **scenario 03** (`514d075dbe616f02`): push tier runs ONLY after the same test tiers are green; `version`
  and `latest` resolve to ONE content-addressed digest over the SAME `build()` core `build-and-test` ran.
  No-divergence is STRUCTURAL (identical core via identical `dagger call` shape), not asserted.

### 1.4 The agent-vault EGRESS recipe (engine precondition) — scenario 04

`build_test_and_push` runs against an engine provisioned per the `01a` recipe + Slice-2 NEW-A/B/C.
Provide a `bin/dagger-engine-up` helper in the BC repo AND the CI `env:` block (§2). Recipe:

1. **Engine: `--privileged --network shopsystem`** (192.168.0.0/20). Default `bridge` has NO route to
   the proxy at 192.168.0.2 (Finding 1).
2. **Proxy env on the engine:** `HTTP(S)_PROXY`/`http(s)_proxy` = the agent-vault handle
   (`http://av_agt_...@192.168.0.2:14322`, **IP not DNS**). BuildKit propagates the daemon proxy env into
   every `RUN` — ZERO Dockerfile edits for the proxy half (Finding 3).
3. **`NO_PROXY`** must carry **registry APEX forms** (NEW-A: Go `httpproxy` treats leading-dot as
   subdomains-only, so `mcr.microsoft.com` apex still got MITM'd): `localhost,127.0.0.1,mcr.microsoft.com,
   data.mcr.microsoft.com,.mcr.microsoft.com,.azureedge.net,.azurefd.net,.docker.io,.docker.com,
   .cloudfront.net,.cloudflare.docker.com,registry.dagger.io` **PLUS dagger-infra hosts** (NEW-B:
   module-runtime codegen builds direct): `proxy.golang.org,sum.golang.org,storage.googleapis.com,
   pypi.org,.pythonhosted.org`. **`github.com` is DELIBERATELY NOT in NO_PROXY** → fabro/agent-vault
   release downloads stay PROXIED through agent-vault (IS-2 intact, ADR-054).
4. **Engine config that must live inside the engine** (`/etc/dagger/engine.toml`; insecure-registry for
   a scratch registry, etc.) is injected via **`docker cp` + `docker restart`, NOT a host `-v`** (NEW-C:
   the docker daemon cannot see devcontainer scratchpad mounts).
5. **Secret seam (ADR-054 D1):** credential inputs are `dagger.Secret` sourced `cmd://`/`env://` with a
   **DUMMY** value; the proxy injects the real cred on-wire; dagger scrubs it from logs; **nothing real
   is baked into any image layer**. `dagger init/develop` run against the DEFAULT direct engine; only
   `dagger call` targets the egress engine.

- **scenario 04** (`2c13b47417b86d09`): build-time fabro download routes through agent-vault (github
  proxied, dummy token), public base pull stays direct (NO_PROXY apex), module-runtime codegen direct.

### 1.5 The build-time CA-TRUST base prerequisite (ADR-055 — MITM-local infra)

The real Dockerfile trusts the agent-vault CA only at RUNTIME (entrypoint @331), so building it through
the MITM engine x509-fails at the first egress RUN. **Under real CI (direct public egress, no MITM) the
Dockerfile is verbatim as-is — this is NOT a shipped-path IS-3 bend.** For the LOCAL MITM loop only,
provide a build-time CA-trust prerequisite (ADR-055, `01a` option 2): a CA-trusting base variant carrying
the agent-vault CA in the system store **and** the Python/pip/git env fan
(`SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE`/`PIP_CERT`/`GIT_SSL_CAINFO`), delivered WITHOUT editing the real
`FROM` line. Reject direct build egress (IS-2 violation, ADR-054). This is a build-substrate/base concern,
not app divergence.

---

## 2. THE WRAP-NOT-REPLACE change to `publish-bc-base.yml` (ADR-052)

Swap **ONLY** the `docker/build-push-action@v6` step for a `dagger/dagger-for-github@v8.3.0` call — in
**BOTH** jobs. Everything that makes it a RELEASE stays byte-for-byte: `v*` trigger, `docker/login-action`
GHCR cred source (`secrets.GITHUB_TOKEN`), dual-tag, OCI labels (incl. the shop-templates-version resolve
step + upstream-3.1.2 defeat), visibility=public PATCH (non-fatal), rollback-by-version, and the bc-lead
`needs: build-and-publish` ordering.

```yaml
      # provision the agent-vault-capable engine (01a recipe + NEW-A/B/C) — runner shares agent-vault net
      - name: dagger engine (agent-vault egress)
        run: bin/dagger-engine-up          # privileged, --network shopsystem, HTTP(S)_PROXY + NO_PROXY apex/infra
      - uses: dagger/dagger-for-github@v8.3.0          # <=== REPLACES build-push-action@v6 ONLY
        with:
          version: v0.21.7                              # == dagger.json engineVersion (divergence guard)
          verb: call
          module: ci
          args: >
            build-test-and-push --source=./docker/bc-base
            --version=${{ github.ref_name }} --ghcr-token=env://GHCR_TOKEN
        env:
          _EXPERIMENTAL_DAGGER_RUNNER_HOST: docker-container://dagger-ci-engine
          GHCR_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- **bc-base job:** `--source=./docker/bc-base`. **bc-lead job:** wraps identically calling a
  `build_lead_and_push` entrypoint; carry the **private-GHCR resolver residual** here (bc-lead's
  `FROM bc-base:vX` GHCR pull needs engine-resolver CA trust that `SSL_CERT_FILE` did NOT satisfy —
  for the local loop, chain bc-lead off the freshly-built local base `Container`, sidestepping the
  proxied private pull; ADR-055 / `01a` Finding 4).
- What MOVED: build+push EXECUTION → dagger, and the workflow GAINED the test tiers it never ran.
  What did NOT move: trigger, cred source, dual-tag, labels, visibility PATCH, rollback, needs-ordering.

---

## 3. RESIDUALS the BC must handle / carry (name them in the dispatch)

- **R1 — private-GHCR resolver** (bc-lead `FROM bc-base:vX`): engine dockerfile-frontend resolver CA
  trust for a PROXIED private pull is unresolved. Local loop: resolve bc-lead from the freshly-built
  local base. Carry as an explicit open item.
- **R2 — CA-trust base decision** (ADR-055): graduate/sanction the build-time CA-trust base variant for
  the MITM-local loop; MITM-local only, NOT shipped-path IS-3.
- **R3 — structural-suite FOLD**: whether the `test_bc_base_*` Dockerfile-shape pins fold into the
  real-image tier is a reconciliation call — the module RELOCATES the suite as Tier 1 for now; do NOT
  delete pins in this dispatch.
- **R4 — fabro-e2e Seam-C nesting** (optional/advanced): docker-out-of-docker + agent-vault broker/
  `SHOPMSG_DSN` reachability for a live `fabro validate` LEG1 — NOT on the default build-and-test path.
- **R5 — engine-in-BC-container dogfood**: full engine boot nested in a fabro node in a BC container —
  the Slice-4 dogfood nesting hazard; NOT required for the authoring deliverable (the module SOURCE is a
  real deliverable that satisfies work-done without executing dagger).
