# Slice 2 — the LOAD-BEARING PROOF (synthesis)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` (main untouched) · **Epic:** lead-fzxt (Slice 2)
**Track:** odqd (spike → learn → throw away → graduate via ADRs+scenarios → dispatch).
**Experiment detail:** `02a-experiment.md`. **Inputs:** `00-dagger-recon.md`, `01-dagger-target-spec.md`, `01a-egress.md`.

## BOTTOM LINE — PROVED

Dagger, building the **real** bc-base fabro/agent-vault install blocks **byte-verbatim** through the
agent-vault MITM engine and running a **real-image tier**, goes **RED locally on a fabro-style defect
while the current structural pytest gate stays GREEN** — before any version tag. Two independent clean
splits. The no-divergence push (same build core, dual-tag → one digest) was also observed. The thesis
of the whole spike is confirmed: **the empty middle that the structural fakes never cover is exactly
where the ~6 fabro-launcher live-only bugs live, and dagger closes it in a fast local loop.**

| Claim | Result |
|-------|--------|
| (a) dagger REDs on a real defect the structural fakes stay GREEN on | **YES** — 2 clean splits (sidecar-404, shim-not-a-listener) |
| (b) dagger built the real bc-base install blocks through agent-vault | **YES** (byte-verbatim fabro/agent-vault/shim blocks; real-image tier ran the baked CLIs) |
| (c) no-divergence push (same core, dual-tag one-digest) | **YES** (`:v0.3.48` & `:latest` → identical `sha256:a1b927…bad6`) |
| (d) CA-trust verbatim-for-free? | **NO** — full verbatim build x509-fails; needs a build-time CA-trust base layer (MITM-local only) |
| (d) private-GHCR resolver (bc-lead `FROM bc-base:vX`) | **RESIDUAL** — sidestepped via local base, not exercised |

---

## (a) THE PROOF — dagger RED where the structural loop stays GREEN

The load-bearing result. Structural gate = the fabro-leg assertion battery extracted verbatim from the
public `tests/conftest.py` (`then_fabro_version_reports` + `_strip_dockerfile_comments`) — i.e. exactly
what `pytest tests/test_bc_base_fabro_and_oauth_shim.py` evaluates for the install leg. Its
`fabro --version` runtime leg runs against **FakeDockerDriver**, which returns canned exit-0 regardless
of whether the real download works — the structural gap the feature file itself admits ("docker is
unavailable in this environment").

**Split 1 — sha256 sidecar naming (`.sha256` → `.sha256sum`), a realistic bead-0fz sibling.**
The main tarball name stays correct; only the checksum sidecar URL changes.
- Structural gate: **GREEN** — all six asserts pass; none covers the sidecar extension.
- dagger `build-and-test`: **RED** — main tarball downloads through agent-vault, then the sidecar
  `curl -fsSL …fabro-x86_64-unknown-linux-gnu.tar.gz.sha256sum` → `curl: (22) 404` (exit 22).
- **→ CLEAN SPLIT: structural GREEN, dagger RED, locally, before any tag.**

**Split 2 — shim-not-a-listener (the sharpest "green-but-broken").** A broken `anthropic-oauth-shim`
that still parses `--help` (argparse → exit 0) but `return`s before binding its `ThreadingHTTPServer`.
- Structural check (`--help` exit 0 + stdlib-only) AND dagger's `--help` tier: **GREEN**
  (`REAL_IMAGE_TIER_OK`). A `--help`-only gate cannot see it.
- dagger `shim_listen_smoke` (real-image bounded TCP connect to `127.0.0.1:8788`, fabro ADR-049 D2
  base_url): **RED** — `SHIM_NOT_LISTENING` (exit 1).
- **→ SECOND CLEAN SPLIT: the real-image listen smoke catches what `--help` + the structural suite miss.**

**Honest nuance (a finding in itself).** The brief's suggested "sharpest" defect — the goreleaser asset
name `fabro_${VER}_linux_amd64.tar.gz` (bead 0fz) — is now **double-caught**: the structural suite was
hardened after 0fz with an explicit text-pin for `fabro-${FABRO_TRIPLE}.tar.gz`, so both gates RED. That
is NOT a clean split, and reporting it as one would be dishonest. The lesson: **text-pins are reactive —
they only catch the exact regression someone already wrote a string for.** The sidecar sibling (Split 1)
is precisely the class that slips through a reactive text-pin but not a real download. This is the durable
argument for the dagger loop over more text-pins.

## (b) HOW dagger built the real bc-base through agent-vault (egress recipe in practice)

Context fetched read-only into scratchpad (`gh api`, dummy `GH_TOKEN`, proxy injects) — **not** persisted
into `/workspace` (ADR-018). The dagger module (`build`/`build_and_test`/`shim_listen_smoke`/
`build_test_and_push`) does `source.docker_build(dockerfile=…, build_args=[BuildArg("FABRO_VERSION",…)])`
over one shared build core; a bad asset/pin 404s the fabro RUN and REDs the DAG.

IS-3 was held by a **faithful slice**: the agent-vault install (lines 90-106), the fabro install
(lines 131-147) and the shim COPY+self-check (lines 162-164) are **byte-verbatim** from the real
Dockerfile (`sed`-extracted, un-re-expanded), plus a CA-trust prerequisite layer (see (d)). The fabro
RUN block under test is identical to the real one, so its build-time egress + real asset download are
exercised for real: fabro + agent-vault downloaded **through the proxy** (github deliberately not in
`NO_PROXY`, IS-2 intact), then the real-image tier ran the baked CLIs → `REAL_IMAGE_TIER_OK`.

The 01a egress recipe in practice, plus **three new provisioning findings** for the Slice-3 spec:
- **NEW-A — NO_PROXY needs registry APEX entries.** Go's `httpproxy` treats leading-dot `.mcr.microsoft.com`
  as subdomains-only; the apex base-image pull was still MITM'd (x509). Fix: add apex forms
  (`mcr.microsoft.com`, `data.mcr.microsoft.com`) + `.azureedge.net`/`.azurefd.net` so the public base pull
  stays direct.
- **NEW-B — the two-engine / infra-egress split.** The Python-SDK module runtime codegen (go proxy, pypi)
  runs INSIDE the target engine and x509-failed against the MITM. Fix: whitelist dagger-infra hosts
  (`proxy.golang.org,sum.golang.org,storage.googleapis.com,pypi.org,.pythonhosted.org`) in `NO_PROXY` so the
  module runtime builds **direct**, while **github.com stays proxied** → fabro/agent-vault release downloads
  route through agent-vault (IS-2 intact). `dagger init/develop` ran against the default direct engine; only
  `dagger call` targets the egress engine.
- **NEW-C — the docker daemon cannot see scratchpad host mounts.** `docker run -v <scratchpad>:…` silently
  mounts an empty dir (the daemon's fs view ≠ this devcontainer shell), so the 01a `-v combined-ca.pem` mount
  was inert (harmless — RUN-egress CA comes from the slice's client-side `COPY agent-vault-ca.pem`). Engine
  config that MUST live inside the engine (`/etc/dagger/engine.toml`) is injected with `docker cp` + `docker
  restart`, not `-v`.

## (c) The no-divergence push demo

Local `registry:2` on the `shopsystem` net, marked insecure via `docker cp engine.toml` + restart.
`dagger call build-test-and-push --version=v0.3.48 --registry=192.168.0.4:5000/bc-base`:
```
REAL_IMAGE_TIER_OK                                    # SAME core + tests ran FIRST
pushed v0.3.48 -> …/bc-base:v0.3.48@sha256:a1b927c85e97…bad6
pushed latest  -> …/bc-base:latest @sha256:a1b927c85e97…bad6
SAME-DIGEST                                           # dual-tag → ONE digest (IS-4)
# registry: {"repositories":["bc-base"]}  {"tags":["v0.3.48","latest"]}
```
`build-and-test` (local) and `build-test-and-push` (CI-shape) call the **identical `self.build()` core**
via the identical `dagger call` shape → the no-divergence property is **structural, not asserted**;
dual-tag-one-digest is content-addressed. This is the observable "same command locally and in CI" (IS-1/IS-4).

## (d) IS-3 CA-trust verdict + private-GHCR residual

**CA-trust verbatim-for-free? DENIED.** The FIRST egress RUN is line 70 (`pip install git+https://github.com/
dstengle/…`). There is **no** `update-ca-certificates`/agent-vault CA-trust step anywhere before the egress
RUNs — `agent-vault-ca.sh` is only COPY'd at line 255 and wired as the **runtime ENTRYPOINT**. So the real
bc-base establishes CA trust **only at container runtime, never at build time** (correct under real CI, which
has direct public egress). Empirically, the full 332-line verbatim Dockerfile through the MITM engine pulls
the public base OK (NEW-A) then REDs at line 70: `SSL certificate problem: unable to get local issuer
certificate` (exit 1). The git clone reached github through agent-vault (proxy works), but `python:3.11` does
not trust the Agent Vault Root CA. **→ Building the real Dockerfile through a MITM needs a build-time CA-trust
prerequisite (01a option 2): an org CA-base `FROM`, or a base variant carrying the CA + the Python/pip/git env
fan (`SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE`/`PIP_CERT`/`GIT_SSL_CAINFO`).** This tension is **MITM-local only** —
under real CI the Dockerfile is verbatim as-is, so it is NOT an IS-3 divergence in the shipped path.

**Private-GHCR resolver (bc-lead `FROM bc-base:vX`): RESIDUAL, sidestepped.** The slice is bc-base-only. For
the local loop, bc-lead resolves its base from the freshly-built local base (the module's `build()` returns a
`Container`; a `build_lead` chains off it), avoiding the proxied private-GHCR pull whose engine-resolver CA
trust 01a Finding 4 left open. Not yet exercised — carry to Slice 3/4.

## (e) What this proves for graduation + remaining risks

**Proven, graduation-ready:**
1. The core thesis — dagger catches a real fabro-style defect the structural loop misses, **locally, before
   any tag** (two clean splits). This is the value the spike existed to establish.
2. The real bc-base install blocks build **byte-verbatim** through agent-vault (IS-2 sole-cred held; IS-3 held
   for the shipped path).
3. No-divergence (same core, dual-tag-one-digest) is structural, observable.
4. The egress recipe is now fully operational with three new provisioning findings folded in.

**Remaining risks (carry into Slice 3/4):**
- **CA-trust base decision** — the local MITM loop needs a sanctioned build-time CA-trust prerequisite. This is
  an ADR-worthy choice (graduate a CA-trusting org base for the local loop vs. scope the loop to it). Not a
  shipped-path IS-3 bend.
- **Private-GHCR engine-resolver CA trust** — unexercised; sidestepped for the local loop.
- **fabro-e2e (Seam C) nesting** — docker-out-of-docker + agent-vault broker/`SHOPMSG_DSN` reachability for a
  live `fabro validate` LEG1; the highest-value, highest-risk seam, not yet built.
- **Engine-in-BC-container (Slice-4 dogfood)** — full engine boot nested inside a fabro node inside a BC
  container: socket + boot + resource cost, unproven.
- **Structural-suite fold decision** — whether the `test_bc_base_*` Dockerfile-shape pins fold into the
  real-image tier is a Slice-4 reconciliation call, not decided here.

## (f) Slice 3 recommendation — GRADUATE

**Verdict: graduate.** The proof is green and the residuals are scoped, not blocking. Move from throwaway to
sanctioned decision records + authored scenarios; hold the fabro-e2e/nesting risks for Slice 4 dispatch.

**ADRs to draft (lead-architect):**
1. **ADR — dagger as the local+CI build/test substrate for bc-base.** Decision: WRAP-not-replace
   `publish-bc-base.yml` (swap only `docker/build-push-action@v6` for `dagger/dagger-for-github`); one
   `engineVersion`-pinned (v0.21.7) Python-SDK module over one build core; `build-and-test` local gate +
   `build-test-and-push` CI gate. Rejected alternatives: more structural text-pins (reactive, Split-1 lesson);
   replace the release workflow wholesale (breaks IS-1/IS-4).
2. **ADR — same-definition-locally-and-in-CI (no-divergence).** The `engineVersion` pin + identical
   `dagger call` shape make local == CI; dual-tag-one-digest is content-addressed (evidence: (c)).
3. **ADR — agent-vault egress into the dagger engine (the 01a recipe + NEW-A/B/C).** Privileged engine on the
   `shopsystem` net; proxy env propagated by BuildKit; NO_PROXY apex + dagger-infra whitelist with github
   proxied; engine config via `docker cp`+restart; `cmd://`/`env://` dummy-secret seam (IS-2).
4. **ADR — build-time CA-trust prerequisite for the MITM-local loop.** The verbatim Dockerfile trusts the
   agent-vault CA only at runtime; the local loop needs a build-time CA-trust base. Scope it as MITM-local
   infra, explicitly NOT a shipped-path IS-3 divergence. Reject direct egress (IS-2 violation).

**Scenarios to author (lead-po, `features/`):**
- `build-and-test` REDs on a fabro asset-sidecar 404 while the structural suite stays GREEN (Split 1 — the
  reactive-text-pin gap).
- The real-image `shim_listen_smoke` REDs on a shim that parses `--help` but does not bind (Split 2).
- `build-test-and-push` produces dual-tag-one-digest over the same build core that `build-and-test` ran (IS-4
  no-divergence).
- The engine egress recipe: build-time RUN egress routes through agent-vault (github proxied) while public
  base pulls stay direct (NO_PROXY apex), dummy creds only (IS-2).

**Sequence:** Slice 3 graduates (ADRs 1-4 + scenarios above) → Slice 4 **dispatches** the module + WRAP to
shopsystem-bc-launcher via `assign_scenarios`/`request_bugfix` (IS-5, ADR-018 — the BC owns its CI), and
reconciles the register, carrying the private-GHCR-resolver, fabro-e2e-nesting, and structural-fold residuals.

---

## Hygiene / repro

Branch `dagger-spike`; main untouched; no BC source persisted into `/workspace` (context fetched read-only
into scratchpad). Repro artifacts: `…/scratchpad/{bc-base-ctx,bc-launcher-ci,bc-tests,structural_gate.py,
engine.toml}`. Live objects left for inspection: `dagger-egress-engine`, `dagger-spike-registry`
(192.168.0.4:5000). Remove with `docker rm -f` when done. Full detail: `02a-experiment.md`.
