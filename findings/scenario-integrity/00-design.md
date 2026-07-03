# Scenario data-integrity + process guards — design (epic lead-vzxd)

**Date:** 2026-07-03 · **Branch:** `dagger-spike` · **Lead shop:**
shopsystem-product · **Blocks:** DDD review `lead-bh2m`
**Status:** DESIGN ONLY — no `shop-msg` dispatch. Router dispatches after
David reviews. All findings are artifact/`bd export` surface only (ADR-018);
no BC source cloned or read.

Companion decision record: **ADR-056**
(`adr/056-scenario-file-schema-off-the-shelf-gherkin-validation-and-bc-tag-source-of-truth-cutover.md`).

---

## A. Deep pre-state (empirical)

### A.i — Can beads resolve ownership for the untagged corpus?

**Method.** Built two maps from `bd export --all` (843 records):
`hash → {bc}` and `work_id → dispatched_to_bc` from the dispatch-bead
metadata fields `scenario_hashes_pinned` and `dispatched_to_bc` (182 dispatch
beads: 66 `assign_scenarios`, 116 `request_bugfix`; 379 distinct pinned
hashes). Enumerated the corpus with `scenarios list` over all 484
`.gherkin` files (562 scenarios, each with its authoritative parser
block-only hash). Matched every scenario hash against the beads map.

**Worked examples.**
- `features/templates/213-…update-renders…ops-coordinates….gherkin` →
  `scenarios list` = `4c646ae20a1540e3` → in beads map → `shopsystem-templates`.
  RESOLVED (authoritative).
- `features/messaging/23-consume-outbox-per-message-type….gherkin` →
  `266fbc83d32ad724` → in beads map → `shopsystem-messaging`. RESOLVED.
- `features/bc-manifest/*.gherkin` (25 scenarios) → none of their hashes are
  in the beads map, no in-file tag, no resolving work_id comment →
  `@bc:unassigned`.

**Result — layered resolvability (562 scenarios):**

| Layer | Signal | Scenarios | Cum. % |
|------|--------|-----------|--------|
| 1 | Exact block-only hash → single BC in beads map (AUTHORITATIVE) | 166 | 29.5% |
| 2 | Existing in-file `@bc:` tag | 49 | 38.3% |
| 3 | work_id comment → bead `dispatched_to_bc` (weak) | 14 | 40.7% |
| 4 | **Residual → `@bc:unassigned`** | **333** | (59.3%) |

**Finding: beads cleanly resolves only ~30% authoritatively (~41% with
weaker in-file/comment signals). ~59% is NOT derivable from beads.** Two
root causes: (a) **56% hash drift** — 213 of 379 beads-pinned hashes no
longer match any current scenario body (bodies edited/superseded after
dispatch, plus throwaway spike dispatches); (b) large corpora
(`templates` 178 residual, `messaging-registry` 56, `bc-manifest` 25) were
authored/held or dispatched via non-hash-pinning paths, so the *current*
body hash was never pinned in beads.

**Directory is a hint, not an authority.** Per-directory purity of the
hash-resolved scenarios:
- PURE→single BC: `messaging`→messaging, `messaging-registry`→messaging,
  `bc-launcher`→bc-launcher, `scenarios`→scenarios, `beads-health`→templates,
  `dagger-ci`→bc-launcher-dagger, **`agent-vault-broker`→*templates*** (dir
  name ≠ BC name).
- MIXED: `templates` (79 templates + **1 messaging leak**),
  `scenario-journal` (6 scenarios + 3 messaging).
- NO hash-evidence (resolved only by existing tags, if any): `bc-manifest`,
  `devcontainer` (17 existing tags), `docs`, `fabro-orchestration`,
  `launcher-credentials` (8 existing `@bc:shopsystem-bc-launcher` tags —
  dir name ≠ tag), `spike-lifecycle`, `test-harness`.

So directory-default is safe ONLY for pure dirs and ONLY as a review-queue
proposal (ADR-056 D7 tier 2); mixed and dir-name≠BC cases force human review.

### A.ii — Consumers that read scenario ownership from beads (must repoint at cutover)

No `bin/` script reads scenario ownership today (`bin/` = agent-vault +
shop-shell only). The consumers are process/mechanism ones:

1. **lead-architect pre-state `@scenario_hash` enumeration** — the
   conflict-set enumeration; today ownership is inferred via dispatch
   history, post-cutover reads the `@bc` tag.
2. **Reconciliation** (router standing rule + lead-architect) — "assigned
   owner" cross-check; beads → audit-only.
3. **Scenario-to-BC assignment / assign-per-structurizr** — per-scenario
   owner of record becomes the tag.
4. **`request_scenario_register` / lead-mirror import** — imported scenarios
   carry/receive the tag (see A.iii).
5. **`bc-emit work-done` gate (ADR-042) + `bc-reviewer`/`bc-implementer`
   templates** — the enforcement wiring point (owned by
   `shopsystem-templates`).
6. **DDD review `lead-bh2m`** — the blocked consumer; reads ownership off the
   tag post-cutover.
7. **Scenario-completion journal (ADR-023/024/025, `scenarios` BC)** — keyed
   by hash; note the tag if it reports per-BC.
8. **beads dispatch metadata itself** (`dispatched_to_bc`,
   `scenario_hashes_pinned`) — the deauthorized source; historical/audit only
   after cutover.

### A.iii — Register-vehicle characterization (CONFIRMED)

`request_scenario_register` imports a BC's scenario register into the lead
mirror = **VISIBILITY only** (BC→lead, closing the known-incomplete-mirror
gap). It is the *reverse* flow from ownership assignment and was never a
universal-tagging mechanism. The pre-state characterization ("the 'we did
this already' partial") is **correct**: it makes BC-side pins visible in the
lead mirror; it does not stamp `@bc` ownership across the corpus. Post-cutover
its imported scenarios should carry/receive their `@bc` tag.

---

## B. MUST-VERIFY — is consolidation HASH-PRESERVING? (load-bearing)

**Answer: YES under the parser path — verified empirically. But the shipped
tool has TWO canonicalizations and only the parser path is safe.**

**B.1 — Two canonicalizations exist.**
- **Parser path** (`scenarios list` / `scenarios count`): parses Gherkin,
  extracts each scenario node, hashes it block-only, **ignoring** `@bc` /
  `@scenario_hash` / comments / `Feature:`. Reproduces **100% (417/417)** of
  embedded `@scenario_hash` tags across the corpus, **zero mismatches**.
- **Raw-stdin path** (`scenarios hash < text`): canonicalizes literal text,
  **retains** `@bc`/comment/`Feature:` as content → diverges. Example:
  `features/messaging/23-*` → parser `266fbc83d32ad724` vs raw-block
  `5cb732540fec3c93`. The recipe `awk '/Scenario:/{p=1} p' FILE | scenarios
  hash` is right for `templates/213` (coincidence) and **wrong** for
  `messaging/23`. **This is the slice-16-class "two inputs to the
  canonicalization rule" hazard, live in the shipped tool.**

**B.2 — Consolidation is hash-preserving under the parser path.** Consolidated
two currently-bare messaging scenarios (`23`→`266fbc83d32ad724`,
`24`→`414b25f9c253556f`) into one `Feature:`-headed multi-scenario file across
three tag/boundary variants: (V1) combined `@scenario_hash:… @bc:…` single
line; (V2) separate `@bc` + `@scenario_hash` lines; (V3) indented tags +
blank lines + a `# comment` between scenarios. **All three:** `scenarios
list` reproduced both hashes exactly. Independently added `@bc` to
`templates/213` (separate line AND combined line): `scenarios list` unchanged
at `4c646ae20a1540e3`. So adding a `Feature:` header, grouping scenarios,
backfilling `@bc`, and inter-scenario blanks/comments **do not perturb any
`@scenario_hash`**.

**B.3 — Required tool posture (owned here).** Because the parser path already
excludes tags/comments/`Feature:`, no block-boundary change is needed — the
parser stops at the scenario node correctly. The fix is to **mandate the
parser path for all recompute/validation** and **reconcile `scenarios hash`**
to parse-then-hash (ADR-019 single canonicalization; ADR-056 D3), so the raw
divergence cannot re-enter. Also note: the tool's parser is **lenient** — it
accepts bare no-`Feature:` files (`scenarios count` returns 1 on a bare file).
Off-the-shelf `@cucumber/gherkin` would REJECT those; that rejection is
exactly what `scenarios validate` adds (forces the `Feature:` header).

---

## C. Decomposition → vehicles → BCs, with sequencing

Legend: **AS** = `assign_scenarios` (net-new), **BF** = `request_bugfix`
(tighten unpinned existing), **MT** = `request_maintenance` (flat).
Pre-state per ADR-018 is artifact-surface; PO authors any pinning scenarios
before dispatch.

### C1 — `scenarios validate` + schema + off-the-shelf linter (+ optional create/modify) → `shopsystem-scenarios`
- **Vehicle: AS (net-new).** `scenarios` has NO validate/schema/tag-enforcement
  today — all net-new. PO must author the pinning scenarios (schema rules
  D1.2–D1.4, exit-nonzero, JSON output, pinned `@cucumber/gherkin`, known-BC
  set from `bc-manifest.yaml`).
- **Also in this unit (BF): reconcile `scenarios hash`** to the single
  canonicalization (ADR-056 D3) — existing unpinned behavior tightened so raw
  and parser paths cannot disagree.
- **Optional create/modify Gherkin surface — tradeoff (David's "if easier"):**
  RECOMMEND YES, scoped. A `scenarios add-scenario` / `scenarios consolidate`
  that emits conformant grouped Gherkin (Feature header, per-scenario tags,
  correct block-only `@scenario_hash`) makes the one-time consolidation (C2)
  mechanical and hash-safe, and gives the go-forward "tool produces conformant
  Gherkin" property David wants. Cost: more surface in the `scenarios` BC.
  Net: worth it — the consolidation is otherwise 484-file hand-editing with
  hash-recompute risk. Keep it minimal (emit + re-tag; not a full editor).

### C2 — ONE-TIME resolution/backfill + structural consolidation
Canonical scenarios live in the BCs; the lead cannot edit BC source (ADR-018).
So the backfill/consolidation must land **in each BC repo**.
- **Vehicle: per-BC MT (`request_maintenance`) sweeps** — one per owning BC
  (`shopsystem-messaging`, `shopsystem-scenarios`, `shopsystem-templates`,
  `shopsystem-bc-launcher`, `shopsystem-devcontainer`, `shopsystem-test-harness`,
  plus the reconciled `shopsystem-bc-launcher-dagger`,
  `shopsystem-agent-vault-broker`). **Justification:** the edit is FLAT — add
  `Feature:` header, group scenarios, stamp the pre-resolved `@bc` +
  `@scenario_hash` — introducing NO new scenarios and (B.2) NOT changing any
  `@scenario_hash`. Flat change, no new behavior pinned → MT, not AS/BF. Each
  MT carries: the lead-resolved tag map for that BC's scenarios (tier-1
  auto + David-confirmed tier-2), the grouping instruction (D6), and
  "validate with `scenarios validate` before emit."
- **The lead's OWN `features/` mirror** is edited directly here (not via a
  vehicle — it is lead-owned): same consolidation + tag backfill, validated
  with `scenarios validate`.
- **`@bc:unassigned`** stamped on every residual scenario so no file leaves
  the sweep tag-absent.

### C3 — Consumer repointing (A.ii list)
- Ownership-reader repoints (lead-architect enumeration, reconciliation,
  assignment, register import, DDD review) are **lead-side process/template
  changes** — handled in this repo + the role templates.
- Template-gate repoints (`bc-emit`, `bc-reviewer`, `bc-implementer`) are
  owned by **`shopsystem-templates`** → part of C4.

### C4 — Enforcement guard
- **Vehicle: BF (`request_bugfix`) → `shopsystem-templates`.** The `bc-emit
  work-done` gate (ADR-042) already enforces hash-match (existing behavior);
  extend it to also run `scenarios validate` (schema + `@bc` presence +
  off-the-shelf-Gherkin). This TIGHTENS an existing gate → BF, not AS. Wire
  the same check into CI. PO authors the tightening scenarios; enumerate the
  ADR-042 pins being extended in the dispatch.

### Sequencing / blocking order

```
1. ADR-056 accepted + bc-manifest.yaml reconciled (D5)   [lead, this repo]
       │
2. C1: scenarios validate + schema + linter + hash reconcile   [AS+BF → scenarios]
   (the GUARD must exist before backfill so backfill is checkable)
       │
3. C2: backfill + consolidation, per-BC + lead mirror     [per-BC MT + lead edit]
   (uses scenarios validate from step 2; tier-2 review needs David — see D)
       │
4. C3 cutover: deauthorize beads, repoint consumers to tag  [lead + templates]
       │
5. C4: enforce — wire scenarios validate into bc-emit gate + CI   [BF → templates]
```

Rationale: **guard first** (can't safely backfill 484 files without a
validator), **backfill next** (produces the conformant corpus),
**cutover+repoint** (flip the source of truth once the tag is populated),
**enforce last** (lock it so nothing regresses). Step 2 blocks 3; 3 blocks 4;
4 blocks 5. Step 1 blocks all.

---

## D. Chosen forms + open decisions

**Unassigned-tag form: `@bc:unassigned`** (recommended, default kept). Keeps
the single `@bc:` namespace so one validation rule ("exactly one `@bc:<token>`
per scenario") covers owned and unowned alike; grep-able backlog
(`grep -r '@bc:unassigned' features/`); reads naturally. Rejected
alternatives: `@unassigned` (breaks the uniform `@bc:` rule), `@bc:none` /
`@bc:TBD` (ambiguous vs a real BC named none/tbd).

**Schema spine (ADR-056 D1):** off-the-shelf-`@cucumber/gherkin`-valid · exactly
one `Feature:` · every scenario has exactly one `@bc:<name>|@bc:unassigned` ·
every scenario has one `@scenario_hash:<16hex>` == parser block-only hash ·
canonicalization block-only & tag/comment/`Feature:`-insensitive (ADR-019).

**Open decisions that genuinely need David (vocab/scope):**
1. **Grouping definition — what is "a feature"?** (ADR-056 D6). Product-judgment
   call, coupled to the DDD feature-clustering in `lead-bh2m`. Recommend
   deciding it *inside* `lead-bh2m` and letting C2 consolidate by
   directory/topic in the interim (hash-preserving, owner-safe either way).
   Naming this as a David decision, not deciding it here.
2. **Tier-2 backfill review.** The ~333 non-authoritative scenarios need a
   product-owner pass over the directory-default/heuristic proposals before
   they become `@bc:<name>` vs `@bc:unassigned`. This is a product-authority
   review, not an operational call.
3. **`bc-manifest.yaml` reconciliation (D5):** confirm `shopsystem-bc-launcher-dagger`
   and `shopsystem-agent-vault-broker` are real, manifest-worthy BCs (they
   appear in dispatch history but not the manifest); the `fabro-e2e*`
   throwaways are spike names and must NOT become owners.
4. **`scenarios` create/modify surface (C1):** flagged "if easier" — recommend
   YES (scoped consolidate/emit helper); confirm the added-surface tradeoff is
   acceptable.
