# PDR-032 — shopsystem-knowledge owns the artifact type system and coherence gate (EXTEND)

**Status:** accepted (ratified by dstengle, 2026-07-09 **as amended**) — landed as
PDR-032 from handoff-package `pdr-P01` (external PM-mode session
`sess-2026-07-09-a`).
**Authors:** Claude (acting lead-pm), dstengle
**Decision-makers:** dstengle
**Amends:** [PDR-031](031-shopsystem-knowledge-context-discovery-first.md) —
**partial amendment.** Renames PDR-031's `kind` discriminator axis to a single
`type` axis and enriches its single-source frontmatter field set (below). **Not a
full supersession:** PDR-031's discovery-first PRIMARY capability (authoring-time
adversarial covered/contradicts/supersedes analysis, 5 pinned discovery hashes),
its single-source L0/L1/L2 projections + index, and its opt-in coherence-gate
posture (typed-edge/supersede-cycle floor always-on; `governed-delta` tripwire
opt-in) are all preserved and extended, not reversed. See PDR-031's Amended-by
note.
**Derives-from:** `cand-P01` (from handoff-package `sess-2026-07-09-a`; not yet
landed in this repo — referenced so the lineage is not dangling).
**Reconciliation evidence:** [finding 09 —
`findings/progressive-disclosure/09-handoff-P01-collision-reconciliation.md`](../findings/progressive-disclosure/09-handoff-P01-collision-reconciliation.md)
(bead lead-ig97; verdict **EXTEND**, not align, not supersede).
**Lead bead:** [`lead-qw6s`](#) (P1; parent epic `lead-ac1f`). Round-1 scenario
re-authoring (`kind`→`type` rework + re-hash) is bead [`lead-a56c`](#), running in
parallel; the `assign_scenarios` dispatch to shopsystem-knowledge is bead
[`lead-ykan`](#). **This landing does none of that** — it lands the decision record
only.

## The question

Which bounded context owns the product-artifact type system — the frontmatter
conventions, document templates, JSON Schema, and the coherence gate that
validates the artifact graph — and how does that ownership reconcile with the
already-committed `shopsystem-knowledge` model (PDR-031)?

## Context

The system is adopting a richer PM-layer artifact taxonomy plus structured
frontmatter for briefs/PDRs/ADRs and a current-state living doc (`cand-P01`).
Three BCs plausibly claim the work: shopsystem-templates (ships templates today),
shopsystem-scenarios (has validation tools), and the new shopsystem-knowledge. The
templates BC's name describes its packaging medium, not its domain — its content
is role behavior. The scenarios BC's validation (canonicalization, hashing) is
scenario-contract semantics, not generic document linting.

A collision had to be reconciled first: shopsystem-knowledge already exists as a
committed decision (PDR-031) with two PINNED feature files —
`authoring_discovery.feature` (5 pinned discovery hashes) and
`single_source_projection.feature` (5 pinned hashes, including
`d121b489919c177e`, which pins a `description` frontmatter field the L0 card
projection depends on). The handoff payload proposed a parallel 8-`type`
frontmatter schema that (a) used a `type` discriminator where PDR-031 uses `kind`,
(b) dropped `description`, and (c) added net-new PM artifact families
(intent-record, candidate, session-record, prioritization-record, current-state)
and gate rules the existing model never modeled. Finding 09 established, entirely
against the contract/artifact surface (ADR-018), that the right move is **EXTEND**:
grow the committed model to absorb the payload's richer taxonomy and gate rules
rather than align the payload down into `kind` or supersede the pinned coverage.

## Options considered

### Option A — shopsystem-templates owns it

**Pros:** pour/distribution machinery already lives there; the "template" name
suggests fit.
**Cons:** organizes by medium, not meaning — document formats and role behaviors
share a file format, not a domain; accelerates the BC into a junk drawer and
entrenches the misnomer.

### Option B — shopsystem-scenarios owns it

**Pros:** validation competence exists; the gate could reuse tooling.
**Cons:** stretches "scenario contract semantics" into "anything that checks
documents"; the gate's domain is the cross-artifact graph, of which feature files
are one node type.

### Option C — shopsystem-knowledge owns it, EXTENDING PDR-031 (chosen, as amended)

**Pros:** the artifact corpus — what kinds of knowledge exist, their shapes,
links, and integrity — IS a knowledge domain; the ownership is compatible with the
already-committed PDR-031 model; the progressive-disclosure findings become its
founding evidence.
**Cons:** the new BC takes on core work immediately; the `type` unification forces
rework and re-hashing of ~10 pinned `kind`-referencing scenarios; pour must gain a
second supplier to distribute knowledge-BC assets (fenced follow-on).

**Reconciliation sub-options (finding 09):** ALIGN (force 8 shapes into the single
`kind` field) discards the payload's real value — per-type id patterns, status
enums, link fields, gate rules 4–7. SUPERSEDE (payload replaces the drafts) retires
pinned coverage and inverts PDR-031's discovery-first reframe back toward the
gate-heavy prototype it demoted. EXTEND is the only option that preserves the
pinned surface while absorbing the net-new domain.

## Decision

The **shopsystem-knowledge BC owns the artifact type system** — the conventions
document, the artifact templates, the frontmatter JSON Schema, and the coherence
gate — **EXTENDING the existing PDR-031 knowledge model rather than superseding
it.** Concretely:

1. **Ownership (the core pdr-P01 decision).** shopsystem-knowledge owns the artifact
   type system and coherence gate. This extends, does not replace, the
   discovery-first knowledge context PDR-031 founded.

2. **Vocabulary unifies on `type` (dstengle amendment).** Rename the existing
   `kind` axis to `type`: a **single `type` discriminator** over the 8 artifact
   types — `intent-record`, `candidate`, `session-record`, `prioritization-record`,
   `brief`, `pdr`, `adr`, `current-state`. This is **NOT a dual `kind`+`type`
   axis** (the minimal-churn shape finding 09 recommended); dstengle amended that
   recommendation to a single unified discriminator for clarity.

3. **`description` is KEPT.** `description` remains a **required** frontmatter
   field. It was pinned by scenario `d121b489919c177e` (the L0 card projection
   draws `id`/`title`/`status`/`description` from frontmatter); the handoff payload
   schema had dropped it, and this amendment restores/keeps it.

4. **Date field enriched.** `date` → `created` + `updated` (a semantic split
   distinguishing creation from last-substantive-edit); add `authors` as a new
   required field.

5. **Gate rules 4–8 land as NET-NEW checks.** Link resolution across the 8 types,
   `candidate==briefed` ⇒ brief-set + backlink, `brief.candidate` required for
   briefs beyond 015, closed-session ⇒ ≥1 produced/revised, accepted PDR/ADR
   claimed by some `incorporates` edge, and draft-age warnings land as net-new
   checks **layered on** the existing machinery, which is PRESERVED: the
   advisory/blocking mode split (authoring-advisory / distribution-blocking,
   ADR-047 D3), doctor-form findings, the distribution boundary, and the
   typed-edge / supersede-cycle checks (rules 1 and 3 are already covered — additive
   tightening at most).

6. **Cost accepted (dstengle).** dstengle explicitly accepts that the ~10 pinned
   scenarios referencing `kind` — PDR-031's 5 discovery hashes plus the
   projection / distribution / mode-split family — require rework and re-hashing as
   the cost of the `type` unification. Reconciliation against the two pinned files
   must either reproduce all pinned hashes or enter an explicit retirement list;
   that rework is Round-1 PO work (bead `lead-a56c`), not this landing.

7. **Pour generalization is a fenced follow-on.** Distributing knowledge-BC
   (non-role) assets via the pour requires a structural change — the pour is
   single-supplier today (`shop-templates` baked into `bc-base` per ADR-021; the
   pour runs inside the container at launch per ADR-057/PDR-014). Adding a second
   pour supplier is out of this decision's scope and carried as its own fenced
   candidate/bead.

8. **pdr-P01 boundary rules preserved.** (a) Roles are behavior (templates BC),
   artifacts are knowledge (knowledge BC), scenarios are the executable contract
   (scenarios BC) — role templates reference knowledge-BC formats, never the
   reverse. (b) The gate owns the cross-artifact link graph and **calls the
   scenarios CLI** to enumerate features/tags — it does **not** reimplement
   canonicalization or hashing. (c) The knowledge BC owns shapes and integrity,
   **never artifact instances**, which remain each product's lead-repo data. (d)
   The pour distributes knowledge-BC assets alongside role templates as a
   supplier/consumer relationship, both components versioning independently in the
   BOM.

## Consequences

Easier: newcomer legibility (one BC answers "what is a candidate?"); recursion
stays clean (downstream products pin the knowledge component for their artifact
system); a single `type` discriminator reads more clearly than a two-level
`kind`/`type` hierarchy. Harder: the `type` unification forces rework and
re-hashing of ~10 pinned scenarios (accepted, item 6); pour generalization moves
onto a future critical path (fenced, item 7); the templates BC's name grows more
wrong — a rename (e.g. toward "roles") becomes a future question this PDR
deliberately does not decide. Current-state impact: the knowledge BC entry gains
"Does: owns the artifact type system, shapes, and the coherence gate"; the
templates BC entry is unchanged in scope.

### Scope / appetite (set by dstengle)

Two rounds:

- **Round 1** — gate + schema EXTEND dispatched to the shopsystem-knowledge BC
  (the `type` unification, the `description`/`created`/`updated`/`authors` field
  reconciliation, gate rules 4–8, and the ~10 pinned-scenario rework).
- **Round 2** — pdr-P02 role/skill material (the lead-pm template, PM skills,
  role-deltas) dispatched to the shopsystem-templates BC, with a lead re-render.

**Explicitly OUT of appetite:** legacy corpus migration (prose-status → enum
across ~90 docs) is deferred to its own future candidate. Pour generalization is
fenced (item 7).

**Router-resolved naming (deferred session question).** The new artifact home is a
new **`candidates/` directory** — it does NOT absorb the existing generic
`drafts/` directory. This resolves the session's deferred naming question.

## Cross-references

- [PDR-031](031-shopsystem-knowledge-context-discovery-first.md) — the
  discovery-first shopsystem-knowledge founding this PDR partially amends
  (`kind`→`type` rename + frontmatter field enrichment); see its Amended-by note.
  The discovery-first primary capability, single-source projections, and opt-in
  gate posture are untouched.
- [finding 09 —
  `findings/progressive-disclosure/09-handoff-P01-collision-reconciliation.md`](../findings/progressive-disclosure/09-handoff-P01-collision-reconciliation.md)
  — the ratification-independent collision-reconciliation spike (bead lead-ig97)
  whose **EXTEND** verdict is the evidence for this decision.
- [PDR-033](033-pm-as-main-session-mode.md) — PM as main-session mode (landed from
  handoff `pdr-P02`); the Round-2 role/skill material rides its Phase-3 work.
- [ADR-047](../adr/047-system-version-manifest-bom-schema-release-wiring-and-coherence-gate-mechanics.md)
  / [ADR-021](../adr/021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
  / [ADR-057](../adr/057-bc-work-loop-single-sourced-two-poured-projections-claude-and-fabro-def-generated-at-pour-not-baked.md)
  / [PDR-014](014-lead-skill-group-pour-and-graduation-path.md) — the
  advisory/blocking mode split and the single-supplier pour mechanism this decision
  preserves (and whose generalization it fences).
- [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) — all
  reconciliation in finding 09 is contract/artifact-surface only; no BC source on
  this host.
- `cand-P01`, `sess-2026-07-09-a` (handoff-package) — the derives-from lineage and
  originating PM session; not yet landed in-repo.

## Changelog

- 2026-07-09 drafted in `sess-2026-07-09-a` (as `pdr-P01`); proposed.
- 2026-07-09 ratified by dstengle **as amended (EXTEND)**; landed as PDR-032 from
  handoff-package `pdr-P01`. Frontmatter adapted to the house convention (H1 +
  bold-field header). Amendments recorded per finding 09 + dstengle: single `type`
  discriminator (not dual kind+type), `description` kept, `date`→`created`/`updated`
  + `authors`, gate rules 4–8 as net-new checks on preserved machinery, ~10 pinned
  `kind`-scenarios accepted for rework/re-hash, pour generalization fenced,
  `candidates/` naming resolved. Bidirectional partial-amendment linkage with
  PDR-031 recorded (this side + PDR-031 Amended-by note).
</content>
</invoke>
