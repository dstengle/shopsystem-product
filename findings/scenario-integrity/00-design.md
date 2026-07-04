# Scenario data-integrity + process guards — design (epic lead-vzxd)

**Date:** 2026-07-04 (rev-2) · **Branch:** `dagger-spike` · **Lead shop:**
shopsystem-product · **Blocks:** DDD review `lead-bh2m`
**Status:** DESIGN ONLY — no `shop-msg` dispatch. Router dispatches after
David reviews. All findings are artifact/`bd export` surface only (ADR-018).

Companion decision record: **ADR-056** (rev-2).
Rev-2 folds in David's four directions (R1 provenance=grouping; R2 defined-end
consistency gate; R3 service-dependency model; R4 helper confirmed) + the
BC-self-tagging resolution refinement.

---

## 0. The three-dimension tag model (headline)

| Dimension | Tag | Level | Card. | Resolves |
|-----------|-----|-------|-------|----------|
| Owner | `@bc:<name>` \| `@bc:unassigned` | **feature** (inherited) | 1 | which bounded context owns it |
| Provenance / grouping | `@origin:<ref>` \| `@origin:unresolved` | **feature** (inherited) | 1 | originating decision = the feature |
| Identity | `@scenario_hash:<16hex>` | **scenario** | 1 | block-only canonical hash |
| Service dep (optional) | `@service:<name>` | feature | 0..1 | exercised supporting service (postgres / agent-vault-broker) |

**A feature = (originating decision × owning context)** (ADR-056 D6). Because
both owner and origin are constant within a feature, both are feature-level
and inherited; only `@scenario_hash` is per-scenario. This is David's
"feature-level-inherited tags are ideal" model, and it is *forced* by Gherkin
feature-level inheritance (you cannot mix `@bc` within one feature file).

---

## A. Deep pre-state (empirical)

### A.i — beads ownership resolvability (unchanged; now a SEED, not the resolver)

Method: `hash→BC` + `work_id→dispatched_to_bc` maps from `bd export --all`
(182 dispatch beads; 379 pinned hashes) matched against 562 scenarios
(`scenarios list`).

| Layer | Signal | Scen. | Cum.% |
|------|--------|-------|-------|
| 1 | exact block-only hash → single BC (AUTHORITATIVE) | 166 | 29.5% |
| 2 | existing in-file `@bc:` tag | 49 | 38.3% |
| 3 | work_id comment → `dispatched_to_bc` (weak) | 14 | 40.7% |
| 4 | residual | 333 | (59.3%) |

**~40% lead-side ceiling, from 56% hash drift** (213/379 pinned hashes match
no current body). **Per David's refinement, this is NOT the backfill
resolver** — it is a SEED/cross-check. The resolver is **BC self-tagging**
(A.iv).

### A.ii — Consumer repoint list (beads → tags)

lead-architect `@scenario_hash` enumeration · reconciliation · scenario-to-BC
assignment · `request_scenario_register` import (now carries `@bc`/`@origin`)
· `bc-emit` gate + bc-reviewer/bc-implementer templates (`shopsystem-templates`)
· DDD review `lead-bh2m` (reads `@bc` + `@origin` grouping) ·
scenario-completion journal (ADR-023/024/025) · beads dispatch metadata itself
(→ audit-only).

### A.iii — Register-vehicle characterization (CONFIRMED)

`request_scenario_register` = VISIBILITY only (BC→lead mirror), never a
universal-tagging mechanism. Post-cutover it becomes the RETURN PATH carrying
BC-self-tagged `@bc`/`@origin` back into the lead mirror.

### A.iv — Provenance derivability + the ONE derivation (R1)

**Method (lead-side floor):** for each scenario, derive its originating
decision from (a) in-file `ADR-NNN`/`PDR-NNN`/`brief`/`lead-<id>` references;
(b) the dispatch bead(s) pinning its hash, transitively to THEIR ADR/PDR refs.
Corpus reference density: 102 files cite an ADR, 64 a PDR, 22 a brief, 193 a
bead.

**Result (562 scenarios):**

| Origin via | Scen. |
|-----------|-------|
| ADR (direct or via bead) | 153 |
| bead (ref only, no ADR/PDR) | 81 |
| bead (dispatched) | 33 |
| PDR | 17 |
| **NONE derivable lead-side** | **278** |

**Provenance derivable lead-side ≈ 50.5% (284/562); 49.5% NONE.** Note this
is HIGHER than owner-by-hash (29.5%) and drift-independent, because ADR/PDR
refs live in file comments regardless of body edits. **BC self-tagging raises
it further** (the BC sees its own commit/PR/bead history). Residual →
`@origin:unresolved` (transitional).

**Provenance = grouping:** scenarios sharing (originating decision × owning
context) FORM a feature; the feature is tagged with that `@origin` + `@bc`.
One derivation yields both. "Harder to backfill, but necessary" (David).

### A.v — Service-dependency model (R3) — grounded in ADR-028

**ADR-028 already decides this:** the agent-vault broker + postgres are
lead-shop **SUPPORTING SERVICES (compose alongside each other), explicitly NOT
BCs**; the broker's own behaviors are pinned by a **lead-owned integration-
check surface**. This is exactly why `features/agent-vault-broker/`'s 13
scenarios hash-resolved to `shopsystem-templates` (the rendered standup
surface), not to a broker BC.

**Proposed model (default):**
- Service deps are a **distinct `@service:<name>` category**, NOT domain `@bc`
  owners. DDD mapping: external-system / generic subdomain.
- New **`services:` section in `bc-manifest.yaml`**: `postgres`,
  `agent-vault-broker`. `@service:` values validate against it.
- Every scenario STILL carries mandatory feature-level `@bc:<owner>` = the
  CONSUMING context, plus optional `@service:<name>` when it exercises a dep.
- `features/agent-vault-broker/` (13) → `@bc:shopsystem-product`
  (lead-owned integration surface, ADR-028) + `@service:agent-vault-broker`.
  postgres pinned indirectly (`shop-msg watch/notify`) →
  `@bc:shopsystem-messaging` + `@service:postgres`.

**Residual product call → David:** confirm `shopsystem-agent-vault-broker` is
a `services:` entry (not a `bcs:` BC), and that the broker-integration
scenarios are lead-owned (`@bc:shopsystem-product`) rather than owned by a
consuming BC. Default above assumes ADR-028's "lead-owned integration surface."

---

## B. MUST-VERIFY — consolidation is HASH-PRESERVING (load-bearing, unchanged)

**YES under the parser path.** `scenarios list`/`count` reproduce 100%
(417/417) of embedded `@scenario_hash` tags. Consolidated two bare messaging
scenarios into one `Feature:`-headed file across 3 tag/boundary variants
(combined-line, separate-line, blanks+comment) — all hashes preserved; adding
`@bc` (and by the same mechanic `@origin`) to `templates/213` left its hash
unchanged. Feature-level `@bc`/`@origin` inheritance therefore does NOT perturb
`@scenario_hash`.

**Two-canonicalization hazard (must fix):** raw `scenarios hash` diverges from
the parser path when tags/comments/`Feature:` are present (`messaging/23`:
parser `266fbc…` vs raw `5cb73…`). The `awk … | scenarios hash` recompute is
unsafe. Fix (ADR-056 D5): mandate the parser path everywhere; reconcile
`scenarios hash` to parse-then-hash (ADR-019 single canonicalization). Also
note the tool's parser is LENIENT (accepts bare no-`Feature:` files) — the
`@cucumber/gherkin` linter in `scenarios validate` is what forces the header.

---

## C. Decomposition → vehicles → BCs, with sequencing

Legend: **AS** `assign_scenarios` · **BF** `request_bugfix` · **MT**
`request_maintenance`.

### C1 — `scenarios validate` + 3-dim schema + `@cucumber/gherkin` linter + `--aggregate` gate + hash-reconcile + create/modify helper → `shopsystem-scenarios`
- **Vehicle: AS (net-new)** for `validate`/schema/tag-enforcement/`--aggregate`
  (all net-new; PO authors the pinning scenarios) + **BF** for the `scenarios
  hash` single-canonicalization reconcile (tighten existing unpinned behavior).
- Schema enforces all three dimensions (ADR-056 D4): off-the-shelf-Gherkin,
  one `Feature:`, feature-level `@bc` + `@origin`, per-scenario `@scenario_hash`
  == parser hash; `@service:` validated against the new manifest section.
- **Helper CONFIRMED (R4):** scoped conformant create/modify/consolidate
  surface — emits `Feature:`-headed grouped Gherkin with correct feature-level
  `@bc`/`@origin` + per-scenario `@scenario_hash`. Makes C3 mechanical.

### C2 — `bc-manifest.yaml` reconciliation (lead, this repo)
Add real BCs (`shopsystem-bc-launcher-dagger`, confirm others) to `bcs:`; add
a **`services:` section** (`postgres`, `agent-vault-broker`); NEVER add
`fabro-e2e*` spike names. Defines the legal `@bc`/`@service` value sets.

### C3 — ONE-TIME resolution/backfill + structural consolidation (BC-SELF-TAGGING led)
Canonical scenarios live in the BCs; the lead cannot edit BC source (ADR-018).
- **Vehicle: per-BC MT (`request_maintenance`) sweeps** — one per owning
  context. **Each BC SELF-TAGS its own repo** (`@bc` = itself near-100%;
  `@origin` from its own history), consolidates into `Feature:`-headed grouped
  files, stamps per-scenario `@scenario_hash`, and runs `scenarios validate`
  before emit. The lead includes its **beads-derived seed/cross-check map** in
  each sweep (NOT as the resolver). Flat change (no new scenarios, hashes
  preserved) → MT.
- **Lead's OWN `features/` mirror:** edited directly (lead-owned) — receives
  BC-self-tagged registers via `request_scenario_register` import + tags its
  genuinely-lead-owned integration scenarios (`@bc:shopsystem-product`).
- Residual → `@bc:unassigned` / `@origin:unresolved` (TRANSITIONAL; drive to
  zero — D8).

### C4 — Consumer repointing (A.ii)
Lead-side process/template repoints in this repo + role templates; the
template-gate repoints (`bc-emit`, bc-reviewer/implementer) are `shopsystem-
templates`-owned → part of C6.

### C5 — Cutover
Deauthorize beads for assignment; the in-file `@bc`/`@origin` tags become
authoritative.

### C6 — Enforcement guard + DEFINED-END consistency gate (R2)
- **BF → `shopsystem-templates`:** extend the `bc-emit work-done` gate
  (ADR-042) to run `scenarios validate` (schema + `@bc`/`@origin` presence +
  off-the-shelf-Gherkin), and wire it into CI. Tightens an existing gate → BF.
- **Aggregate consistency gate:** wire `scenarios validate --aggregate` into
  the **`bin/doctor`/`system-manifest` coherence gate (ADR-047 D4)** so the
  system is **RED until zero `@bc:unassigned` + zero `@origin:unresolved` +
  all files schema-valid**. Templates-owned (renders `bin/doctor`). **This
  green gate = DONE for `lead-vzxd`.**

### Sequencing / blocking order

```
1. ADR-056 accepted + C2 bc-manifest reconciled (bcs + services)   [lead]
       │
2. C1: scenarios validate + 3-dim schema + linter + --aggregate
       + hash-reconcile + helper                        [AS+BF → scenarios]
   (guard + aggregate check must EXIST before backfill so DONE is measurable)
       │
3. C3: backfill (BC self-tagging led) + consolidation   [per-BC MT + lead edit]
   (uses validate from step 2; provenance tier-2 needs David — §D)
       │
4. C4+C5 cutover: deauthorize beads, repoint consumers to tags   [lead+templates]
       │
5. C6: enforce (bc-emit + CI) + wire aggregate gate into bin/doctor  [BF→templates]
   -> gate stays RED until C3 drives transitional markers to zero = DONE
```

Guard+gate first (so DONE is measurable and backfill is checkable), backfill
next (BC self-tagging), cutover, enforce. The defined end is mechanical: the
ADR-047 aggregate gate turns GREEN exactly when the corpus is fully tagged,
provenanced, and conformant.

---

## D. Chosen forms + residual David decisions

**Tag forms:** owner `@bc:<name>|@bc:unassigned`; provenance `@origin:<ref>|
@origin:unresolved` (ref = `adr-NNN|pdr-NNN|brief-<slug>|<lead-bead-id>`,
precedence adr>pdr>brief>bead); identity `@scenario_hash:<16hex>`; service
`@service:<name>`. Unified `@origin:` chosen over separate `@adr-NNN/@pdr-NNN`
(one rule, one grep, uniform shape, one root per feature). Transitional
sentinels `@bc:unassigned` / `@origin:unresolved` are forcing markers driven
to zero by the aggregate gate.

**Schema spine:** off-the-shelf-`@cucumber/gherkin`-valid · exactly one
`Feature:` · feature-level `@bc` + `@origin` (inherited) · per-scenario
`@scenario_hash` == parser block-only hash · block-only canonicalization
(ADR-019, single path).

**Residual decisions that genuinely need David (vocab/scope):**
1. **Feature = (decision × BC) confirmation.** Recommended and forced by
   inheritance; confirm this is the grouping `lead-bh2m` will consume (vs a
   looser "one decision, possibly multi-BC" feature that would break
   feature-level `@bc`).
2. **Provenance tier-2 review.** ~49.5% lead-underivable; BC self-tagging
   closes most, but the genuinely-origin-ambiguous residual needs a product
   pass before `@origin:<ref>` vs `@origin:unresolved`. Product-authority
   review.
3. **Service-dependency ownership (A.v).** Confirm `agent-vault-broker` is a
   `services:` entry (not a `bcs:` BC) and its integration scenarios are
   `@bc:shopsystem-product` (lead-owned per ADR-028) vs owned by a consuming
   BC. Confirm postgres modeled the same way.
4. **`bc-manifest` `bcs:` additions.** Confirm `shopsystem-bc-launcher-dagger`
   (and any other real dispatch-history BC) is manifest-worthy; `fabro-e2e*`
   are spikes, excluded.
5. **Lead owner token.** `@bc:shopsystem-product` proposed for lead-owned
   scenarios (shop name / ADR-038 product slug); confirm the spelling.
