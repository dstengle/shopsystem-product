# 09 — Handoff pdr-P01 vs existing shopsystem-knowledge drafts: collision reconciliation (lead-ig97)

**Bead:** lead-ig97 (parent epic lead-ac1f). Ratification-independent
de-risking spike for ingesting `/tmp/handoff-package` (pdr-P01). No BC
dispatched; contract/artifact-surface verification only (ADR-018 D1/D2 — no
BC source on this host).

**Verdict in one line: EXTEND.** The existing kind-extensible knowledge
model (PDR-031, with two PINNED feature files) grows to absorb the payload's
richer per-type taxonomy and gate rules 4–8; it is NOT a rename to align
into, and it must NOT be superseded (supersede would regress capabilities
already pinned on the contract surface).

---

## Contract-surface pre-state (what is pinned vs merely proposed)

Enumeration over `features/shopsystem-knowledge/` (`grep -r @scenario_hash`,
reconciled with `git ls-files`):

- **PINNED (committed, real hashes) — 10 scenarios, 2 files:**
  - `authoring_discovery.feature` — 5 pins (`60f070ecddc891e5`,
    `bea7c4aa89633418`, `3092efb62e739d3a`, `f77904953e96124e`,
    `4f85b0b3af16073e`). The PDR-031 *primary* capability (adversarial
    discovery). The payload says NOTHING about this.
  - `single_source_projection.feature` — 5 pins (`d121b489919c177e`,
    `d71b9384bb5d13d9`, `9feadfd3e1a0efad`, `dbd9846f04d8e22b`,
    `f4b64423b77dd3e2`). Load-bearing: `scenarios hash` over the first
    block reproduces `d121b489919c177e`, and that scenario pins *"an L0 card
    carrying the id, title, status and **description** drawn from the
    frontmatter"* — i.e. `description` is a pinned frontmatter field the
    projection depends on.
- **PROPOSED (untracked, `@scenario_hash:pending`) — 23 scenarios, 5 files:**
  `frontmatter_schema_conformance`, `coherence_gate_typed_edges`,
  `coherence_gate_advisory_blocking`, `distribution_boundary`,
  `active_digest_generation`. Treat as PO drafts, not pinned.

Governing decisions read: PDR-031 (kind-extensible, discovery-first, v1 =
ONE kind `architecture-decision`; kind-extensibility is a v1 *shape*
requirement; L1-to-BC distribution is an explicit v1 NON-GOAL), ADR-047 D3
(advisory-at-authoring / blocking-at-distribution split the
`coherence_gate_advisory_blocking` drafts cite), ADR-057 + ADR-021 + PDR-014
(the pour mechanism). pdr-P01 status is **proposed** and NOT ratified; this
spike is ratification-independent.

---

## 1. Field-vocabulary verdict: NOT a pure rename

`kind`↔`type` and `date`↔`created`/`updated` do **not** rename one model
onto the other; they encode different granularity and a broader domain.

- **`kind` (existing) is COARSER than `type` (payload).** In PDR-031 `kind`
  is the knowledge *category* axis — `architecture-decision` vs the
  designed-for-but-unbuilt `development-principle` / `skill-recipe` /
  `experiment-research`. The entire ADR/PDR/brief corpus is ONE `kind`. In
  the payload, `type` is the *document-shape* axis with 8 values, EACH with
  its own id pattern, status enum, and link fields. Payload `adr`/`pdr`/
  `brief` all sit *inside* the existing `kind=architecture-decision`; they
  are sub-shapes of one kind, not three kinds. So `kind` and `type` are two
  different levels of one hierarchy, not two names for one field.
- **The payload adds a whole domain the existing model never modeled.**
  `intent-record`, `candidate`, `session-record`, `prioritization-record`,
  and `current-state` are PM-process artifacts with no counterpart in the
  decisions-only existing model. This is net domain, not vocabulary drift.
- **`date`→`created`/`updated` is a field SPLIT (semantic enrichment), not
  a rename.** The payload distinguishes creation from last-substantive-edit
  (`00-conventions.md` line 29). One field becoming two with new meaning is
  additive, absorbable — but still not a rename.
- **A genuine field CONFLICT exists: `description`.** The existing model
  REQUIRES `description` (pinned by `d121b489919c177e`, which feeds the L0
  card). The payload schema has **no `description` field at all** (only
  `title`). Adopting the payload schema verbatim would break a pinned
  projection. Conversely the payload REQUIRES `authors` (minItems 1); the
  existing field set does not carry it. These are the two field-level
  reconciliations any merge must resolve, and the `description` one is the
  single strongest argument against wholesale payload adoption.

Conclusion: the two schemas encode **genuinely different domains at
different granularity**, sharing only `id`/`title`/`status`. This rules out
"pure rename / align-into-payload."

---

## 2. Gate-rule overlap matrix (payload rules 1–8)

| # | Payload gate rule | Status vs existing drafts | Evidence |
|---|---|---|---|
| 1 | Frontmatter validates against schema | **COVERED (rule) / DIVERGENT (content)** | `frontmatter_schema_conformance` pins required-field + status-enum + typed-edge validation. The *check* exists; the *schema* differs (per-kind fields vs 8 per-type branches). |
| 2 | Every link field resolves | **PARTIAL OVERLAP** | `coherence_gate_typed_edges` dangling-edge scenario pins "edge to a target id not present in corpus." Covers resolution generically; the payload's richer link taxonomy (`derives-from`/`experiments`/`brief`/`candidate`/`produced`/`revised`/`incorporates`) is net-new surface for that same check. |
| 3 | Supersession links bidirectional | **COVERED** | `coherence_gate_typed_edges` asymmetric-supersede + active-yet-superseded pins pin exactly this (and MORE — see below). |
| 4 | `candidate==briefed` ⇒ brief set + backlink | **NET-NEW** | No `candidate` type in existing model. |
| 5 | `brief.candidate` required for briefs > 015 | **NET-NEW** | No `brief`/`candidate` types. |
| 6 | Closed session ⇒ ≥1 produced/revised | **NET-NEW** | No `session-record` type. |
| 7 | Accepted PDR/ADR claimed by some `incorporates` | **NET-NEW** | No `current-state` type. |
| 8 | Warning tier: draft-age | **NET-NEW check on an EXISTING mechanism** | The advisory/warning *severity* tier already exists (`coherence_gate_advisory_blocking`); the draft-age *check* is new content riding it. |

**Existing model is RICHER than the payload in three places (no payload
counterpart):**
- **supersede-cycle** and **active-yet-superseded** typed-edge checks
  (`coherence_gate_typed_edges`) — payload rule 3 only asserts
  bidirectionality.
- **Advisory/blocking MODE split** (`coherence_gate_advisory_blocking`,
  ADR-047-D3): authoring=advisory-never-blocks, distribution=blocking-
  vetoes-pour. Payload has a severity *tier* (rule 8) but no mode split.
- **Distribution boundary + active digest** (`distribution_boundary`,
  `active_digest_generation`): L1 pours to BCs, L2 lead-only. Payload
  models no distribution at all.

**True CONFLICTS (not just gaps):**
- Schema field set: `description` required-and-pinned (existing) vs absent
  (payload); `authors` required (payload) vs unmodeled (existing).
- Discriminator field: `kind` (existing accessor/projection axis, pinned by
  `f4b64423b77dd3e2` which refuses an unregistered kind) vs `type` (payload
  per-document discriminator). A document cannot validate against both
  schemas as written.

---

## 3. Recommendation: EXTEND (not align, not supersede)

**Why not ALIGN (payload conforms to existing kind/date model):** forcing 8
document shapes into the single `kind` field discards the payload's real
value — per-type id patterns, per-type status enums, per-type link fields,
and gate rules 4–7. Align throws away exactly what the payload contributes.

**Why not SUPERSEDE (payload replaces the drafts):** the payload is silent
on the PDR-031 *primary* capability (authoring-time adversarial discovery,
5 PINNED scenarios) and on projections/distribution/mode-split (10+
scenarios, 5 of them pinned). Supersede would retire pinned coverage —
including `d121b489919c177e`'s dependence on `description` — and regress the
centerpiece PDR-031 was written to buy. It also inverts PDR-031's
discovery-first reframe back toward the gate-heavy prototype PDR-031
explicitly demoted.

**Why EXTEND fits:** PDR-031 D5 makes kind-extensibility a v1 *shape*
requirement precisely so new artifact families register rather than fork.
The payload's PM artifacts are that extension. Concretely:

1. Keep `kind` as the coarse accessor/projection/routing axis (preserves
   the two pinned files). Introduce the payload's `type` as a per-document
   *sub-shape* discriminator *under* a kind — `adr`/`pdr`/`brief` as
   sub-types of `kind=architecture-decision`; the PM artifacts
   (`intent-record`/`candidate`/`session-record`/`prioritization-record`/
   `current-state`) as one or more NEW registered kinds.
2. Field reconciliation, ADDITIVE so no pinned hash retires: **preserve
   `description`** (L0 depends on it, `d121b489919c177e`); absorb
   `created`/`updated` as an enrichment of `date`; add `authors` as a new
   required field.
3. Gate rules 4–8 land as NEW coherence checks riding the ALREADY-drafted
   advisory/blocking mode-split + doctor-form finding machinery. Rules 1 & 3
   are already covered (additive tightening at most).

**Implication for P01 dispatch scope:** the ownership decision (P01 D:
knowledge BC owns the type system + gate) is compatible with EXTEND as-is.
But the 5 `@scenario_hash:pending` drafts must be RE-AUTHORED by lead-po to
the reconciled vocabulary *before* dispatch, and the reconciliation must be
proven additive against the two pinned files (`scenarios hash` must still
reproduce all 10 pinned hashes, or those specific hashes enter an explicit
retirement list). pdr-P01 should be amended to record that it EXTENDS
PDR-031's kind model rather than introducing a parallel `type` model.

---

## 4. Spike #2 — pour generalization: FENCED FOLLOW-ON (not free)

From the artifact/BOM surface, distributing knowledge-BC (non-role) assets
via the pour requires a structural change; it is not available without one.

- The pour is **single-supplier** today: `shop-templates` is baked into
  `bc-base` (ADR-021), and `bc-container launch` runs the `shop-templates`
  pour INSIDE the container at launch (ADR-057 D-context/D2; PDR-014 is the
  canonical pour). It emits `.claude/` and `.fabro/` from ONE component's
  baked assets.
- pdr-P01 boundary rule (4) *itself* frames knowledge-BC distribution as a
  second supplier the pour must gain ("distributes knowledge-BC assets
  **alongside** role templates as a supplier/consumer relationship, both
  versioning independently in the BOM"), and its Consequences put "pour
  generalization … on the critical path (fenced in cand-P01)."
- cand-P01 fences it explicitly: "if pouring is hardwired to role
  templates, extending it to knowledge-BC assets may exceed appetite —
  fence it as a follow-on if so." The pour IS hardwired to a single
  baked supplier per ADR-057/ADR-021.

**Verdict:** FENCED FOLLOW-ON. Adding a second pour supplier (knowledge-BC
assets baked/pulled + a second pour source, versioned as a distinct BOM
component per ADR-047) is a structural change, not a config tweak. The
existing `distribution_boundary` / `active_digest_generation` DRAFTS already
*assume* a knowledge-BC→BC pour that does not structurally exist yet — a
second reason those drafts are proposed, not pinned. Do NOT put pour
generalization in the P01 dispatch; carry it as its own fenced candidate/
bead.

---

## 5. Net dispatch scope for P01 if ratified (after EXTEND reconciliation)

An `assign_scenarios` to shopsystem-knowledge would carry, roughly:

- **Type-system extension:** register the payload's document shapes as
  sub-types under the existing kind axis (adr/pdr/brief under
  `architecture-decision`; the PM artifacts as new kind(s)); grow the
  frontmatter schema to validate per-type branches (id patterns, per-type
  status enums, per-type link fields) — ADDITIVELY over the preserved
  `id/kind/title/status/date+created/updated/description(+authors)` core.
- **Net-new gate checks (rules 4–8 + link taxonomy of rule 2):**
  briefed↔brief backlink, brief.candidate for briefs > 015, closed-session
  non-empty produced/revised, accepted-decision `incorporates` claim,
  draft-age warning tier, and full link-field resolution across the richer
  taxonomy — each riding the drafted advisory/blocking mode-split +
  doctor-form finding surface.
- **The 5 pending drafts, re-authored** to the reconciled vocabulary and
  re-hashed by lead-po; the 2 pinned files carried UNCHANGED (or their
  hashes explicitly retired if reconciliation proves non-additive).

**Explicitly NOT in the P01 dispatch:**
- Pour generalization (§4) — fenced structural follow-on.
- The discovery-first adversarial pass — already pinned, unchanged by P01.
- Legacy corpus migration (~90 docs prose→enum) — cand-P01 no-go, own
  candidate.
- The PM role/topology material — that is pdr-P02's scope, not P01's.

---

## Caveats

- pdr-P01/P02 are **proposed, not ratified**; this finding informs
  ratification, it does not presume it (per the bead's ratification-
  independence). Router reconciles lead-ig97 status.
- All verification is contract/artifact-surface (ADR-018): this repo's
  `features/`, `adr/`, `pdr/`, and the installed `scenarios hash` tool. No
  BC source exists on this host; none was read or run.
- Provisional `P`-ids renumber into real sequences on ingestion
  (MANIFEST §"Provisional numbering"); that renumber is mechanical and does
  not affect this verdict.
