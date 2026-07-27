---
# Lineage: arc42 living overview / Diátaxis Reference tier / the product
# fact sheet. VERSIONED per ADR-069 D7 — each snapshot is `current`
# (`current-state-NNN`); when the current-system view changes materially a new
# snapshot is authored `current` and this one becomes `superseded`. Present-tense
# fact plus links; if a sentence explains WHY, it belongs in a decision record.
# Stewarded by the lead-pm; the mechanical update obligation fires at decision
# acceptance via the `incorporates` gate. The README and site are outward
# renderings of this document — every capability claim there anchors here.
type: current-state
id: current-state-001
title: shopsystem-product — current state
status: current
created: 2026-07-12
updated: 2026-07-27
authors: [dstengle, "Claude (lead-pm)"]
description: Current-state fact sheet for shopsystem-product — first versioned snapshot, migrated from the prior singleton per ADR-069 D7.
incorporates: [adr-001, adr-002, adr-004, adr-005, adr-006, adr-008, adr-009, adr-010, adr-011, adr-012, adr-013, adr-014, adr-015, adr-016, adr-017, adr-018, adr-019, adr-020, adr-021, adr-022, adr-024, adr-025, adr-026, adr-027, adr-028, adr-029, adr-030, adr-031, adr-032, adr-033, adr-036, adr-037, adr-038, adr-039, adr-040, adr-041, adr-043, adr-056, adr-057, adr-060, adr-061, adr-063, adr-065, adr-066, adr-067, adr-068, adr-069, adr-070, adr-071, pdr-007, pdr-009, pdr-010, pdr-021, pdr-022, pdr-029, pdr-033, pdr-035, pdr-036, pdr-037, pdr-038, pdr-900]   # every accepted PDR/ADR id; gate-checked
substrate:
  system: shopsystem
  bom-version: self
beads: []
---

# shopsystem-product — current state

## Current decisions

shopsystem-product is the outward face of the shopsystem framework itself — a
lead shop that routes product intent into bounded contexts (BCs) rather than
building implementation code in place. Its stakeholders are the product authority
and the agents operating the shop; it classifies each request, authors intent as
briefs, PDRs, and Gherkin scenarios, verifies BC pre-state empirically against
the contract surface, and dispatches work to BCs via `shop-msg`. The BC-shop loop
runs inside each BC container; the lead shop's own move is reconciliation when
`work_done` returns.

**Artifact system (live).** The product's own decisions, intent, and shape are
kept as a typed artifact corpus governed by `shopsystem-knowledge`: eight kinds
on a single-sourced typedef→generator base schema carrying three materialized,
gate-enforced bidirectional edge pairs (supersedes/superseded-by,
derives-from/derived-by, references/referenced-by), N:M supersession, `tags`,
external references, and a `product-lead | product-wide | bc-local` distribution
scope (adr-067). Per-type schemas are additive on that base, and current-state is
versioned (adr-069). A read-only corpus CLI — `shop-knowledge navigate | render |
query` — traverses the frontmatter graph with current-system/transformation view
filtering (adr-068). Per-kind `write-<kind>` authoring skills, generated from one
structure and referencing the live template/schema, are enforced blocking by
`shopsystem-templates` (adr-070, adr-071). The two views over one corpus — the
`accepted` current-system view (self-contained) and the transformation view (the
supersede chains) — are the founding requirement (pdr-035).

### Lead shop

- **Name:** shopsystem-product · **Product authority:** dstengle
- **Artifacts:** intents `intents/`, candidates `candidates/`, sessions
  `sessions/`, prioritizations `prioritizations/`, briefs `briefs/`, product
  decisions `pdrs/`, architecture decisions `adrs/`, and this versioned
  current-state. Findings are retired (ADR-065); durable findings content is
  absorbed as notes into typed artifacts.
- **Artifact lifecycle:** graph form at
  [`artifact-lifecycle.md`](artifact-lifecycle.md) (`cand-005`) — cross-type flow
  plus per-type status lifecycle.

### Owned bounded contexts

<!-- Seed: one entry per BC this product recognizes and builds, following the
template entry shape below. -->

#### &lt;bc-canonical-name&gt;

- **Does:** &lt;one present-tense sentence.&gt;
- **Interface:** &lt;CLI / schema / image / API, with version line.&gt;
- **Contract:** `features/&lt;bc-name&gt;/`
- **Shaped by:** &lt;accepted decision ids — the same ids in `incorporates`.&gt;
- **Status:** live | provisional | retiring

### Platform substrate

<!-- Seed: shopsystem components this product runs on but does not build, at the
pinned BOM version (`self` for the self-hosting instance). One line each. -->

- `&lt;component&gt;` @ &lt;version&gt; — &lt;one clause: used for what.&gt;

### System invariants

<!-- Seed: cross-cutting present-tense facts, each citing its decision. -->

- &lt;invariant.&gt; (&lt;decision-id&gt;)

## Stewardship

Stewarded by the lead-pm. The update obligation is mechanical: on acceptance of
any PDR/ADR its id is added to `incorporates` — gate-checked, so every accepted
decision must be claimed here. The README and site are outward renderings of this
document; every capability claim there anchors to an entry here.

**Versioning (ADR-069 D7).** current-state is a versioned artifact. This is
snapshot `current-state-001` (`status: current`), migrated 2026-07-27 from the
prior singleton (`id: current-state`, `status: live`). Routine `incorporates`
updates and fact edits are made in place on the current snapshot. When the
current-system view changes materially, a new snapshot `current-state-NNN` is
authored `current` and this one moves to `superseded` — its facts frozen as part
of the transformation view.
