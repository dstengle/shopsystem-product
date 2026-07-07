---
id: ADR-053
kind: adr
title: "Same-definition-locally-and-in-CI (no-divergence): the engineVersion pin + identical `dagger call` shape make local == CI, and dual-tag-one-digest is content-addressed"
status: accepted
date: "2026-07-02"
description: "One dagger definition runs locally and in CI with no divergence: engine-version pin, dual-tag, one digest."
beads: [lead-5xnd, lead-fzxt, lead-owned]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018, ADR-021, ADR-029, ADR-052, ADR-054, ADR-055, PDR-011]
  pins: []
  related: []
---
# ADR-053 -- Same-definition-locally-and-in-CI (no-divergence): the engineVersion pin + identical `dagger call` shape make local == CI, and dual-tag-one-digest is content-addressed

- Status: Accepted (2026-07-02)
- Date: 2026-07-02
- Implements: hard-invariant #1 of the dagger spike (NO divergence from the
  real pipeline — the same definition runs locally and in CI over the real
  Dockerfile/tests/publish verbatim) as an enforceable contract, plus IS-4
  (the GHCR image/label/digest identity). Graduates the Slice-2 no-divergence
  push result (findings/dagger-spike/02-dagger-experiment.md (c),
  02a-experiment.md §3.4) via the odqd iterative-experimentation track
  (spike → learn → throw away → graduate via ADRs + scenarios). The
  spike-vehicle product decisions are SETTLED under ADR-029/030/032 and are
  NOT re-litigated here.
- Anchored on (decisions this builds on -- NOT re-decided here):
  - [ADR-052](052-dagger-is-the-local-and-ci-build-test-substrate-wrap-not-replace-publish-bc-base.md)
    -- the UMBRELLA dagger-graduation decision (ONE engineVersion-pinned
    module over ONE build core, WRAP-not-REPLACE `publish-bc-base.yml`, adding
    the real-image tier the structural-only fakes lack). This ADR is a SIBLING
    realization: it formalizes the no-divergence property of the module/WRAP
    that ADR-052 defines. ADR-054 (agent-vault egress) and ADR-055 (CA-trust
    carve-out) are the other siblings.
  - [ADR-021](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
    -- the `bc-base` image is owned by bc-launcher and its build is the
    pipeline BOTH the local `dagger call` and the CI `dagger/dagger-for-github`
    invocation run; dagger wraps ITS build, never a lead-owned variant (IS-5,
    Slice-4 dispatch, no lead edits).
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) --
    the pre-state is the contract/artifact surface; the no-divergence push
    was OBSERVED on-host during the spike, never established by reading or
    running BC source.
  - lead-5xnd (bead, CLOSED) -- the GHCR OCI-label/version/digest contract =
    IS-4, preserved by the ADR-052 WRAP and pinned as content-addressed by
    D3 here (scenario 03).
- Bead: lead-fzxt (P1, the dagger-spike epic, proof banked 2026-07-02).
  Realizes hard-invariant #1 and IS-4; SIBLING of ADR-054/055 under the
  ADR-052 umbrella; depends-on ADR-052 (the module/WRAP it makes
  non-divergent).

## Context

The dagger spike (epic lead-fzxt) asked whether dagger can serve as the
local+CI build/test substrate for `bc-base` WITHOUT breaking the hard
invariants — chief among them #1: **no divergence from the real pipeline**.
The motivating gap is the fabro empty-middle: bc-launcher CI verifies
STRUCTURALLY only (3 workflows, NONE run tests; the suite asserts Dockerfile
TEXT, never a built image), which is exactly where ~6 fabro-launcher defects
surfaced only at live e2e (findings/dagger-spike/00-dagger-recon.md). The
value of adding a real-build/real-image tier (ADR-052) is worthless if the
thing developers run locally is a hand-ported variant that DRIFTS from what
CI runs — a "test" that passes locally and a release that builds differently
in CI would re-open the empty middle from the other side.

This ADR pins the property that closes that door: the SAME definition runs
locally and in CI. Not "a local runner and a CI runner that we keep in sync
by discipline," but one module, one pinned engine, one shared build core, two
entrypoints — so local == CI is STRUCTURAL, and the release identity
(dual-tag → one digest) is CONTENT-ADDRESSED and OBSERVED, not asserted.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's
`features/`, `adr/`/`pdr/`, message schemas, `shop-msg` mailbox state, and
scenario hashes via the installed `scenarios hash` CLI on 2026-07-02. Per
spike-vehicle ADR-032, the spike's `findings/dagger-spike/*.md` (00/01/01a/
02/02a) are the artifact surface for this graduation:

1. **The `engineVersion` pin IS the divergence guard**
   (findings/dagger-spike/00-dagger-recon.md §(a), 01-dagger-target-spec.md
   §1.1). A dagger module is `dagger.json` + `src/`, pinned to a specific
   `engineVersion: "v0.21.7"`. The CLI REFUSES to run the module under a
   mismatched engine, so a dev laptop and the GHA runner resolve the SAME DAG
   on the SAME engine version. `dagger/dagger-for-github@v8.3.0` uses
   `verb: call` + `args:`, which is LITERALLY the same `dagger call` the
   developer runs locally.

2. **ONE shared build core, two entrypoints — STRUCTURAL, not
   discipline-kept** (findings/dagger-spike/01-dagger-target-spec.md §1.2/§1.6/
   §1.7, 00-dagger-recon.md §(c) WRAP-not-REPLACE). The module exposes the
   same build core two ways: `build-and-test` (LOCAL: build + structural
   pytest tier + the NEW real-image tier) and `build-test-and-push` (CI: the
   same core + GHCR dual-tag push). The push tier runs ONLY AFTER the same
   test tiers are green (§1.7) — so CI gains the local loop's tests instead of
   running none.

3. **Dual-tag → ONE digest was OBSERVED, not asserted**
   (findings/dagger-spike/02-dagger-experiment.md (c) + 02a-experiment.md
   §3.4). `base.publish(:v0.3.48)` and `base.publish(:latest)` over one build
   core produced identical digests:
   `:v0.3.48 → …/bc-base:v0.3.48@sha256:a1b927c85e97…bad6` and
   `:latest → …/bc-base:latest @sha256:a1b927c85e97…bad6` → `SAME-DIGEST`.
   Content-addressed dual-tag is the observable "same command locally and in
   CI" (IS-1/IS-4).

4. **The invocation shapes are identical**
   (findings/dagger-spike/01-dagger-target-spec.md §1.8). Local:
   `dagger call build-and-test --source=. --fabro-version=v0.254.0`; CI:
   `dagger/dagger-for-github@v8.3.0` with `verb: call` /
   `args: build-test-and-push --source=. --version=${{ github.ref_name }} …`
   — the SAME module, SAME engineVersion, SAME function core. One DAG, two
   entrypoints, zero divergence.

5. **@scenario_hash retirement enumeration — EMPTY (nothing retired)**
   (mirrors ADR-051 pre-state finding 6). `grep -r "@scenario_hash" features/`
   carries NO scenario pinning a dagger/CI-build/real-image-tier/
   no-divergence/dual-tag behavior; `features/dagger-ci/` does not yet exist.
   The existing `features/bc-launcher/*.gherkin` pin launcher CLI runtime
   commands (launch/attach/inject/monitor), a DISTINCT surface these do not
   duplicate. This ADR authors no Gherkin and retires no pinned coverage; the
   `features/dagger-ci/` pins are net-new lead-process contract pins authored
   by lead-po next.

## Decision

### D1 -- The divergence guard is the `dagger.json` `engineVersion` pin (v0.21.7): the CLI refuses a mismatched engine, so local `dagger call` and CI `dagger/dagger-for-github` resolve ONE DAG on ONE engine (realizes hard-invariant #1; anchors on ADR-021)

Local == CI is enforced by the pin, not by convention. `dagger.json` pins
`engineVersion: "v0.21.7"`; the CLI refuses to run the module under a
mismatched engine, so a dev laptop and the GHA runner resolve the SAME DAG on
the SAME engine. The local invocation
`dagger call build-and-test --source=. …` and the CI invocation
`dagger/dagger-for-github verb:call args: build-test-and-push --source=. …`
are literally the same command over the same module / same function core /
same pinned engine (pre-state findings 1, 4). There is ONE DAG with two
entrypoints and zero divergence — an unpinned engine that let local and CI
silently resolve different DAGs is precisely what this pin forbids.

### D2 -- No-divergence is STRUCTURAL, not asserted: `build-and-test` and `build-test-and-push` call the IDENTICAL shared build core, and the push tier runs ONLY after the same test tiers are green (realizes hard-invariant #1; closes the empty-middle gap under ADR-052)

The two entrypoints are not parallel re-implementations kept in sync; they
call the ONE shared build core that `dockerBuild`s the REAL
`docker/bc-base/Dockerfile` verbatim (IS-2, ADR-052). `build-and-test` runs
the structural pytest tier + the new real-image tier; `build-test-and-push`
runs the SAME core + the SAME test tiers and gates the GHCR push to run ONLY
AFTER those tiers are green (pre-state finding 2). This is what closes the
empty middle from the CI side: CI can no longer push an image its tests never
exercised, because the push tier is downstream of the identical test tiers
the local loop runs. Divergence is therefore a structural impossibility of
the DAG shape, not a property maintained by developer discipline.

### D3 -- Dual-tag {version, latest} at ONE digest is CONTENT-ADDRESSED and OBSERVED, not asserted (realizes IS-4; preserves lead-5xnd GHCR identity)

The release identity IS-4 (GHCR image/label/digest) is preserved as a
content-addressed fact, not a claimed one. Publishing the SAME built image
under `{version, latest}` yields ONE digest because the content is identical
— OBSERVED in the spike: `:v0.3.48` and `:latest` both resolved to
`sha256:a1b927c85e97…bad6` (SAME-DIGEST, pre-state finding 3;
findings/dagger-spike/02-dagger-experiment.md (c), 02a-experiment.md §3.4).
The ADR-052 WRAP keeps the dual-tag/OCI-label/visibility semantics of
`publish-bc-base.yml`; this ADR pins that their equality must be OBSERVED as
one content-addressed digest over the same build core, never merely asserted
by tagging convention.

## Consequences

- **Local `dagger call build-and-test` is a faithful pre-CI gate** (D1/D2):
  because the engine is pinned and both entrypoints call the identical build
  core, a green local run means CI runs the same DAG on the same engine —
  developers gain a real-build/real-image check before push (closing the
  empty middle ADR-052 names) without a drift risk between what they run and
  what ships.
- **CI can no longer push an untested image** (D2): the push tier is
  downstream of the same test tiers the local loop runs; a red test tier
  blocks the push structurally, not by a hand-maintained job ordering.
- **The release identity IS-4 is content-addressed** (D3): reconciliation
  (lead-architect) and the release-line contract (lead-5xnd) can trust that
  `{version, latest}` name ONE digest because the content is identical, an
  observable property, not a tagging assertion.
- **The contract is version-coupled to dagger v0.21.7** (D1): the
  `engineVersion` pin is the load-bearing divergence guard. A future dagger
  that changes engine-resolution or the `verb:call` shape must be re-verified
  against this ADR before local == CI can be re-claimed.
- **The `features/dagger-ci/` pins reference this ADR** and their block-only
  `@scenario_hash` values are recorded here (defense-in-depth: lead-architect
  VERIFIES the PO-authored hashes, does not introduce them). Scenario 03
  (`build-test-and-push` produces dual-tag {version, latest} at ONE digest
  over the SAME build core that `build-and-test` ran, `@scenario_hash:514d075dbe616f02`)
  pins this ADR; scenario 01 (real build catches the sidecar-404 defect the
  structural fakes miss, `@scenario_hash:2c66a1b1d1b6f092`) pins ADR-052/053
  jointly. The block-only hashes are recomputed with
  `awk '/^[[:space:]]*Scenario:/{p=1} p' FILE | scenarios hash` (do NOT filter
  `@scenario_hash` lines); both were VERIFIED by lead-architect on the
  2026-07-02 graduation-reconcile boundary and reproduce their PO-authored
  tags. No `@scenario_hash` is retired (pre-state finding 5).

## Follow-ups / dependencies (named, not designed here)

- **Slice-4 dispatch of the module + WRAP** — the module and the
  WRAP-not-REPLACE `publish-bc-base.yml` change are NET-NEW CI test behavior
  (bc-launcher CI runs no tests today) → `assign_scenarios` to
  shopsystem-bc-launcher carrying the `features/dagger-ci/` pins, run UNDER
  `--orchestrator fabro` (dogfood, ADR-051 Reviewer gap). Filed as a child
  bead of lead-fzxt, blocked on the 4 ADRs + 4 scenarios landing; that bead's
  ID becomes the outward work_id. Re-run the empty `@scenario_hash`
  enumeration at dispatch and cite the contract-surface pre-state (ADR-018 D1)
  in the dispatch description.
- **Private-GHCR engine-resolver CA trust for `bc-lead FROM bc-base:vX`** —
  the engine `SSL_CERT_FILE` did NOT satisfy the dockerfile-frontend resolver;
  sidestepped in Slice 2 by resolving `bc-lead` from the freshly-built local
  base (findings/dagger-spike/01a-egress.md Finding 4). Unexercised for the
  real `bc-lead` CI leg; resolve there. Refs ADR-054.
- **Structural-suite fold decision** — whether the `test_bc_base_*`
  Dockerfile-shape text-pins fold into the real-image tier once dagger builds
  the real image is a Slice-4 RECONCILIATION call by the BC, NOT pre-decided
  here; keep BOTH the fast structural tier AND the real-image tier until then.

## Alternatives considered

- **Hand-port a dagger variant of the Dockerfile / a separate local runner
  kept in sync with CI by discipline.** Rejected (D1/D2): a second definition
  defeats no-divergence outright — the whole point of the graduation is that
  local and CI run the ONE real Dockerfile through the ONE shared build core,
  so a drift-by-discipline surface is the empty middle re-opened from the
  other side.
- **Leave the engine unpinned (no `dagger.json engineVersion`).** Rejected
  (D1): an unpinned engine lets a dev laptop and the GHA runner silently
  resolve DIFFERENT DAGs on different engine versions; the CLI's
  refuse-on-mismatch pin is the only thing that makes local == CI a guarantee
  rather than a hope.
- **Assert digest identity by tagging convention instead of observing the
  content-addressed push.** Rejected (D3): IS-4 must be an OBSERVED
  content-addressed fact (`:v0.3.48` and `:latest` → identical
  `sha256:a1b927…bad6`); a tagging convention that merely names two tags does
  not prove they carry one digest, and asserting identity is exactly the
  reactive-pin failure the spike set out to avoid.
- **Split test and push into separate CI jobs coordinated by job ordering.**
  Rejected (D2): job-ordering discipline is not structural — the push tier
  runs ONLY AFTER the same in-DAG test tiers are green because it is
  downstream in the ONE DAG, not because a separate job's `needs:` was wired
  correctly.
