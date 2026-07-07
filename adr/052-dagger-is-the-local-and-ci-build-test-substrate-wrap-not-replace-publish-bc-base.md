---
id: ADR-052
kind: adr
title: "Dagger is the local+CI build/test substrate for bc-base: ONE engineVersion-pinned module over ONE build core, WRAP-not-REPLACE publish-bc-base.yml, adding the real-image tier the structural-only fakes lack"
status: accepted
date: "2026-07-02"
description: "Dagger is the local+CI build/test substrate for bc-base: ONE engineVersion-pinned module over ONE build core, WRAP-not-REPLACE publish-bc-base.yml, adding the real-image tier th..."
beads: [lead-5xnd, lead-fzxt, lead-owned]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018, ADR-021, ADR-029, ADR-030, ADR-032, PDR-011]
  pins: []
  related: []
---
# ADR-052 -- Dagger is the local+CI build/test substrate for bc-base: ONE engineVersion-pinned module over ONE build core, WRAP-not-REPLACE publish-bc-base.yml, adding the real-image tier the structural-only fakes lack

- Status: Accepted (2026-07-02)
- Date: 2026-07-02
- Implements: the dagger-spike hard invariant **"graduate via ADRs +
  scenarios"** and its no-divergence / agent-vault-sole-cred / official-release-
  path / BC-owns-CI invariant set, as an enforceable substrate contract;
  graduates the Slice-2 LOAD-BEARING PROOF (findings/dagger-spike/02-dagger-
  experiment.md §a/§b/§c) via the odqd iterative-experimentation track
  (spike → learn → throw away → graduate via ADRs + scenarios → productionize
  via BC dispatch). The spike-vehicle product decisions are SETTLED under
  ADR-029/030/032 and are NOT re-litigated here; the throwaway dagger module is
  reference-only.
- Anchored on (decisions this builds on -- NOT re-decided here):
  - [ADR-021](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
    -- the `bc-base` image is OWNED by bc-launcher (IS-5); dagger WRAPS
    that BC's own build of its own Dockerfile, never a lead-owned variant. The
    lead productionizes by DISPATCH (Slice 4), never by editing BC CI.
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) -- the
    contract-surface rule: the pre-state below was established from the
    artifact surface (read-only `gh` on the public bc-launcher repo, the spike
    findings), never by reading, running, or git-observing BC source cloned
    onto the lead host.
  - lead-5xnd (bead, CLOSED) -- the GHCR OCI-label / version / digest contract
    (IS-4: `{version, latest}` dual-tag at one digest, labels defeating the
    upstream `org.opencontainers.image.version`, visibility PATCH) that the
    WRAP preserves byte-for-byte and scenario 03 pins.
  - [ADR-029](029-spike-vehicle-extend-pdr014-graduation-no-request-spike.md) /
    [ADR-030](030-spike-isolation-contract-scratch-dummy-teardown-to-findings.md) /
    [ADR-032](032-spikes-execute-via-workflow-return-markdown-findings.md) --
    the spike vehicle + iterative-experimentation track this graduates THROUGH;
    per ADR-032 the `findings/dagger-spike/*.md` markdown is the spike artifact
    surface. SETTLED, not re-decided.
- Bead: lead-fzxt (P1, the dagger-spike epic, proof banked GREEN 2026-07-02;
  stays OPEN as the productionization epic through Slice 4). This ADR is the
  **UMBRELLA** of the dagger graduation (the analog of ADR-048 for the fabro
  graduation); REALIZED BY its sibling ADRs
  [ADR-053](053-same-dagger-definition-runs-locally-and-in-ci-no-divergence-engineversion-pin-dual-tag-one-digest.md)
  (no-divergence),
  [ADR-054](054-agent-vault-is-sole-credential-surface-for-the-dagger-build-egress.md)
  (agent-vault build egress), and
  [ADR-055](055-build-time-ca-trust-is-mitm-local-infra-not-a-shipped-path-is-3-bend.md)
  (build-time CA-trust carve-out), each Anchored on this ADR.

## Context

The dagger spike (epic lead-fzxt) asked whether dagger can serve as the
local+CI build/test substrate for the bc-launcher-owned `bc-base` image
WITHOUT diverging from the real release pipeline. The motivating defect class
is the **fabro empty-middle gap**: the fabro-launcher productionization burned
~6 fix rounds on defects that surfaced only at live e2e, because nothing built
the real image and ran it before publish.

The recon established that gap concretely on the real bc-launcher CI. There are
exactly **three workflows and NONE run tests**; the 60+-file pytest-bdd suite
runs OFF-CI on the build host and is STRUCTURAL by construction — `conftest.py`
fakes all docker/git/github interaction, and even the `test_bc_base_*` tests
assert against Dockerfile TEXT, never a built image. So CI builds+publishes but
never runs the image, and the test host runs tests only against fakes. The
**empty middle** — build the real Dockerfile, then run the real image — is
exactly where the fabro-launcher live-only bugs lived. This ADR is the umbrella
that stands up dagger as the substrate closing that gap, and under which the
three realizing ADRs (053/054/055) pin no-divergence, agent-vault build egress,
and the CA-trust carve-out. Dagger is also the real-build check the fail-closed
fabro Reviewer (ADR-051, sole gated emitter) currently LACKS — the Slice-4
dispatch runs UNDER `--orchestrator fabro` as a dogfood, closing the structural
gap inside the loop before `work_done`.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's
`features/`, `adr/`/`pdr/`, message schemas, `shop-msg` mailbox state, and
scenario hashes via the installed `scenarios hash` CLI on 2026-07-02. Per
spike-vehicle ADR-032, the spike's `findings/dagger-spike/*.md` (00-dagger-
recon.md, 01-dagger-target-spec.md, 01a-egress.md, 02-dagger-experiment.md,
02a-experiment.md) are the artifact surface for this graduation; the real
bc-launcher pipeline was characterized entirely via read-only `gh` on the
public `dstengle/shopsystem-bc-launcher` repo (dummy `GH_TOKEN`, no BC source
cloned).

1. **bc-launcher CI verifies STRUCTURALLY only — the empty middle**
   (00-dagger-recon.md §b). Exactly three workflows, and NONE run tests:
   `publish-bc-base.yml` (on `v*` tag — build+push bc-base then bc-lead
   `FROM bc-base:vX`, both via `docker/build-push-action@v6`, dual-tag one
   digest, OCI labels, visibility PATCH; **no test step**),
   `rebuild-bc-base.yml`, `poll-bc-base-deps.yml`. The pytest-bdd suite runs
   OFF-CI and is faked (`FakeDockerDriver`/`FakeGitDriver`/`FakeGitHubDriver`);
   `test_bc_base_*` assert Dockerfile/YAML TEXT, never a built image. The one
   near-real leg (`test_bc_container_fabro_def_validates.py` LEG1)
   `pytest.skip`s when offline. → the fabro empty-middle where ~6 launcher
   defects surfaced only at live e2e.

2. **The build+test+RED primitive is proven** (00-dagger-recon.md §a).
   `dagger v0.21.7` installed to `~/.local/bin`; the engine is a privileged
   BuildKit-derived container. `host | directory <abs> | docker-build` builds
   the ACTUAL Dockerfile unmodified (no hand-ported variant → no-divergence);
   `with-exec` runs the real test command in the built image and a nonzero exit
   FAILS the pipeline AND the `dagger call` process. The same-locally-and-in-CI
   property rides an `engineVersion` (v0.21.7) pin, with CI via
   `dagger/dagger-for-github` `verb: call` being literally the same command
   (formalized in ADR-053).

3. **The PROOF — dagger REDs where the structural loop stays GREEN**
   (02-dagger-experiment.md §a, 02a-experiment.md). Two independent clean
   splits, locally, before any version tag: **Split 1** (sidecar-404) — a
   `.sha256 → .sha256sum` checksum-sidecar rename (a realistic bead-0fz
   sibling; main tarball name correct) → structural gate GREEN (no text-pin
   covers the sidecar extension), dagger `build-and-test` RED (`curl: (22)
   404`); **Split 2** (shim-not-a-listener) — an `anthropic-oauth-shim` that
   parses `--help` (argparse exit 0) but returns before binding its
   `ThreadingHTTPServer` → structural suite AND a `--help`-only tier GREEN
   (`REAL_IMAGE_TIER_OK`), dagger `shim_listen_smoke` (real-image TCP connect
   `127.0.0.1:8788`, fabro ADR-049 D2 base_url) RED (`SHIM_NOT_LISTENING`). The
   durable lesson: text-pins are REACTIVE (they catch only the exact regression
   someone already wrote a string for); the sidecar sibling is precisely the
   class that slips a reactive text-pin but not a real download.

4. **The real bc-base install blocks build byte-verbatim through agent-vault,
   and the no-divergence push was observed** (02-dagger-experiment.md §b/§c).
   The agent-vault, fabro, and shim install blocks build byte-verbatim from the
   real 332-line Dockerfile through the agent-vault MITM engine (github proxied,
   IS-2 intact); the real-image tier ran the baked CLIs → `REAL_IMAGE_TIER_OK`.
   `build-and-test` and `build-test-and-push` call the identical `self.build()`
   core; `:v0.3.48` and `:latest` pushed to ONE identical digest
   (`sha256:a1b927…bad6`), content-addressed (formalized in ADR-053; egress
   recipe in ADR-054; the CA-trust prerequisite carved out in ADR-055).

5. **@scenario_hash retirement enumeration — EMPTY (nothing retired).**
   `grep -r "@scenario_hash" features/` carries NO scenario pinning any
   dagger / CI-build / real-image-tier / agent-vault-egress behavior — there is
   no dagger pin in `features/` at all (`features/dagger-ci/` does not yet
   exist). The existing `features/bc-launcher/*.gherkin` pin launcher CLI
   runtime commands (launch/attach/inject/monitor), a DISTINCT surface these
   scenarios do not duplicate. The four new `features/dagger-ci/` pins are
   NET-NEW; NOTHING is retired, superseded, or contradicted (mirrors ADR-051
   pre-state finding 6). This enumeration is re-run at the Slice-4 dispatch
   boundary per message-type sufficiency check 5.

## Decision

### D1 -- ONE engineVersion-pinned Python-SDK dagger module over ONE shared build core, two entrypoints, adding the real-image tier the structural-only fakes lack (closes the fabro empty-middle gap; realizes no-divergence; honors IS-2)

The canonical bc-base build/test substrate is a single Python-SDK dagger
module, `engineVersion`-pinned to **v0.21.7**, exposing the SAME build core two
ways:

- **`build-and-test`** (LOCAL dev CLI): `docker_build` the real
  `docker/bc-base/Dockerfile` (and `docker/bc-lead/Dockerfile`) VERBATIM — no
  hand-ported variant (IS-2 / no-divergence) — then run the structural pytest
  tier PLUS the **NEW real-image tier** that runs the freshly built image.
- **`build-test-and-push`** (CI): the identical build core + test tiers, then
  the GHCR push. The push tier runs ONLY after the same test tiers are green,
  closing the gap that CI ran no tests.

The build primitive is proven: `docker_build` builds the real Dockerfile
unmodified and a nonzero `with-exec` exit REDs the DAG and the `dagger call`
process (pre-state finding 2). The real-image tier is what the structural fakes
cannot be: where `FakeDockerDriver` returns canned exit-0, the real-image tier
built and ran the baked CLIs and caught two defects the structural gate stayed
GREEN on (pre-state finding 3). No-divergence of the two entrypoints is
formalized in ADR-053; the agent-vault egress that lets the build core reach
the network is ADR-054; the build-time CA-trust prerequisite the MITM-local
loop needs is carved out in ADR-055.

### D2 -- WRAP-not-REPLACE publish-bc-base.yml: swap ONLY docker/build-push-action@v6 for a dagger/dagger-for-github call to the same module; keep the entire release contract (realizes IS-1/IS-4/IS-5; Anchored on ADR-021, lead-5xnd)

`publish-bc-base.yml` is WRAPPED, not replaced. The ONLY change is swapping the
`docker/build-push-action@v6` step for a `dagger/dagger-for-github` call to the
`build-test-and-push` entrypoint of the same module. Everything the release
contract owns stays byte-for-byte:

- the `v*` push trigger (IS-1);
- the GHCR credential source (`secrets.GITHUB_TOKEN` login);
- the `{version, latest}` dual-tag at one digest (IS-4, lead-5xnd);
- the OCI labels (including those defeating the upstream
  `org.opencontainers.image.version`) and the non-fatal `visibility=public`
  PATCH (IS-4);
- rollback-by-tag semantics (IS-1);
- the two-job bc-base → bc-lead `FROM bc-base:vX` shape.

dagger absorbs only the build+push EXECUTION and ADDS the local test/e2e loop;
the release contract is untouched. Because `bc-base` is owned by bc-launcher
(ADR-021, IS-5), this WRAP is PRODUCTIONIZED BY DISPATCH to
shopsystem-bc-launcher in Slice 4 (`assign_scenarios`, net-new CI test
behavior), never by a lead-side edit of BC CI (IS-5 / ADR-018).

### D3 -- The NEW real-image tier is the graduated value: it runs the baked CLIs LIVE where the fakes return canned exit-0 (pins the pre-state finding-3 splits)

The graduated value is the real-image tier, not the relocation of the
structural suite. It boots the freshly built image and exercises it live:
`fabro --version`, a bounded `shim_listen_smoke` (real TCP connect to the
ADR-049 D2 shim `base_url`), and presence of the baked CLIs
(`scenarios`/`bd`/`gh`). This is the tier that produced both clean splits
(pre-state finding 3): the sidecar-404 that a reactive text-pin never covered,
and the shim that parses `--help` but never binds a listener — neither of which
a structural, faked, or `--help`-only gate can see. Keeping BOTH a fast
structural tier AND the real-image tier (the structural-fold question) is a
Slice-4 reconciliation call for the BC, not pre-decided here.

## Consequences

- **The fabro empty-middle gap is closed by construction** (D1/D3): the real
  Dockerfile is built and the real image is run before publish, in a fast local
  loop and again in CI. The ~6-fix-round class of live-only defects now REDs
  locally before any tag (pre-state finding 3), inside the fabro loop at Slice 4
  (ADR-051 Reviewer gap).
- **The release contract is preserved, not re-authored** (D2): IS-1 (`v*`
  trigger, rollback), IS-4 (dual-tag-one-digest, labels, visibility — lead-5xnd)
  and the bc-base→bc-lead shape are byte-for-byte; only the
  `docker/build-push-action@v6` execution step changes. A rollback or a
  re-tag behaves exactly as today.
- **Productionization is a DISPATCH, not a lead edit** (D2 / ADR-021 / IS-5):
  because bc-launcher owns its CI, the module + WRAP graduate to
  shopsystem-bc-launcher via `assign_scenarios` (net-new CI test behavior) in
  Slice 4; the empty `@scenario_hash` enumeration (pre-state finding 5) is
  re-verified and the contract-surface pre-state (ADR-018 D1) is cited in the
  dispatch description.
- **The realizing siblings each pin one surface** (ADR-053 no-divergence,
  ADR-054 agent-vault build egress, ADR-055 CA-trust carve-out), Anchored on
  this umbrella; each surface is independently citable and separately amendable.
- **The `features/dagger-ci/` pins reference this ADR and its siblings; their
  block-only `@scenario_hash` values are VERIFIED, not introduced, by
  lead-architect at the graduation/dispatch boundary** (defense-in-depth per
  ADR-051; lead-po authors and introduces each hash, lead-architect recomputes
  it block-only via the installed `scenarios hash` CLI and does not introduce
  it). The four net-new pins and the record they reference:
  `01-real-build-catches-defect-structural-fakes-miss.gherkin`
  (`@scenario_hash:2c66a1b1d1b6f092`, Split 1) → this ADR + ADR-053;
  `02-real-image-tier-catches-shim-not-a-listener.gherkin`
  (`@scenario_hash:c7b2c587be09770b`, Split 2) → this ADR (D3);
  `03-same-build-core-local-equals-ci-dual-tag-one-digest.gherkin`
  (`@scenario_hash:514d075dbe616f02`) → ADR-053 (IS-4);
  `04-agent-vault-egress-github-proxied-base-direct-dummy-creds.gherkin`
  (`@scenario_hash:2c13b47417b86d09`) → ADR-054 (IS-2). No `@scenario_hash` is
  retired (pre-state finding 5); the four hashes above were recorded and
  VERIFIED by lead-architect at the 2026-07-02 graduation-reconcile boundary —
  each recomputed block-only via `awk '/^[[:space:]]*Scenario:/{p=1} p' FILE |
  scenarios hash` and confirmed to reproduce the PO-authored tag.

## Follow-ups / dependencies (named, not designed here)

- **Slice-4 dispatch bead** (blocked on the 4 ADRs + the 4 `features/dagger-ci/`
  pins landing): dispatch the dagger module + WRAP `publish-bc-base.yml` to
  shopsystem-bc-launcher via `assign_scenarios` (net-new CI test behavior), run
  the dispatch UNDER `--orchestrator fabro` (dogfood of the ADR-051 fail-closed
  Reviewer's real-build gap), reconcile the register. Child of lead-fzxt; that
  bead's ID becomes the outward `work_id`.
- **CA-trust base decision** — choose the sanctioned build-time CA-trust
  prerequisite for the local MITM dagger loop (org CA-base `FROM` vs a base
  variant carrying the CA + the `SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE`/`PIP_CERT`/
  `GIT_SSL_CAINFO` env fan). ADR-055 scopes it MITM-local; the WHICH is
  deferred. Refs ADR-055, ADR-045.
- **Private-GHCR engine-resolver CA trust** for bc-lead `FROM bc-base:vX` —
  the engine `SSL_CERT_FILE` did NOT satisfy the dockerfile-frontend resolver;
  sidestepped in Slice 2 by resolving bc-lead from the freshly-built local base.
  Unexercised; resolve for the real bc-lead CI leg (01a Finding 4).
- **fabro-e2e Seam-C nesting** — docker-out-of-docker (`with_unix_socket`) +
  agent-vault broker / `SHOPMSG_DSN` reachability so `fabro validate` LEG1 runs
  FOR-REAL instead of `pytest.skip`. Highest-value / highest-risk seam; the ~6
  live-only fabro-launcher bugs live here (01-dagger-target-spec.md §3).
- **Engine-in-BC-container dogfood viability** — prove a full dagger engine
  boots inside a fabro node inside a BC container (socket + boot + resource/perf
  cost) for the Slice-4 under-fabro dispatch (00-dagger-recon.md §c/§e).
- **Structural-suite fold decision** — whether the `test_bc_base_*`
  Dockerfile-shape text-pins fold into the real-image tier once dagger builds
  the real image. A Slice-4 RECONCILIATION call by the BC, NOT pre-decided; keep
  both the fast structural tier AND the real-image tier until then.

These follow-ups are NOTED, not created; flagged for router/BC at reconcile.

## Alternatives considered

- **Add more structural text-pins instead of a real build.** Rejected (D1/D3):
  text-pins are REACTIVE — the Split-1 sidecar lesson is that they catch only
  the exact regression someone already wrote a string for. The `.sha256sum`
  sidecar rename passed all six structural asserts and REDed only under a real
  download (02-dagger-experiment.md §a). Only building and running the real
  image makes the check anticipatory rather than reactive.
- **Replace `publish-bc-base.yml` wholesale with a new dagger pipeline.**
  Rejected (D2): a wholesale replacement risks the `v*` trigger, the GHCR
  credential source, the dual-tag-one-digest / OCI-label / visibility contract,
  and rollback — breaking IS-1/IS-4 (lead-5xnd). WRAP swaps ONLY the
  `docker/build-push-action@v6` execution step and preserves the release
  contract byte-for-byte.
- **Have the lead edit bc-launcher CI directly.** Rejected (D2 / IS-5): the
  `bc-base` image and its CI are OWNED by bc-launcher (ADR-021), and the lead
  carries no BC source and does not edit BC CI (ADR-018). Productionization is
  by DISPATCH (`assign_scenarios`) in Slice 4, never a lead-side edit.
- **Hand-port the Dockerfile into a dagger-native build definition.** Rejected
  (D1 / IS-2): a hand-ported variant defeats no-divergence — the whole value is
  that dagger `docker_build`s the REAL Dockerfile unmodified so local == CI ==
  the shipped image (00-dagger-recon.md §a; formalized in ADR-053).
