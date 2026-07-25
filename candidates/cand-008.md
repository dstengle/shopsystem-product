---
type: candidate
id: cand-008
title: Per-type needs and schema for the eight kinds — additive on the base schema, with the current-state conflict resolved
status: shaped
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "Shape for slice #3: explode PDR-032's bundled taxonomy into per-type needs and per-type schema for the eight kinds (adr, pdr, brief, intent-record, candidate, session-record, current-state, prioritization-record). Each per-type schema is additive on slice #2's base schema (sections, status enum, edge participation only — never re-declaring base fields). Resolves the current-state versioned-vs-singleton typedef conflict."
derives-from: [intent-010]
session: sess-2026-07-25-a
experiments: []
brief:
parked-until:
beads: [lead-4vvdo]
---

# cand-008 — per-type needs and schema for the eight kinds

## Verbatim anchors

- `drafts/artifact-system-restructuring.md`: "#3 ... explodes PDR-032's taxonomy
  into per-type docs"; open call "whether #3 is one intent or per-type."
- 2026-07-20 (dstengle): the current-state typedef conflict — resolve in the
  per-artifact schema work.

## Problem

PDR-032 owns the type system as one bundled taxonomy; the per-type contracts
(purpose, required sections, status lifecycle, which base edges each kind uses)
are legible to the generator but not stated authoritatively per kind. So no
single accepted doc says what an `intent-record` is for and requires versus a
`candidate` versus a `prioritization-record`. And the `current-state` typedef
disagrees with the live doc (versioned-NNN vs singleton). This slice makes each
kind's contract explicit and additive on the base schema, and resolves the
current-state conflict.

## Appetite

Large but bounded: eight kinds, each a per-type needs statement plus a schema
delta on the base, plus one conflict (current-state) to resolve. No new kinds; no
base-schema changes.

## Solution sketch

Two lanes, at capability/schema altitude:

- **Per-type needs (a PDR)** — for each of the eight kinds, state why it exists,
  what it is for in the workflow, and what it distinctly requires (its
  characteristic sections and its place on the provenance spine / edge
  participation). Named as concepts, not field syntax.
- **Per-type schema (an ADR)** — for each kind, specify only what it **adds to or
  constrains beyond** the base schema (slice #2): its required sections, its
  `status` enum, and which base edges it participates in. Never re-declares base
  fields; single-sourced from per-type typedefs via the same generator mechanism
  the base schema carries forward.

Both authored as **one sectioned doc per lane** (all eight kinds inside), not
eight separate docs (granularity flagged). PDR-032 is jointly superseded (with #1
and #2) as its taxonomy content re-homes into these per-type docs — nothing
orphaned.

**current-state resolution.** Decide versioned (`current-state-NNN`, snapshots
accepted, priors superseded) vs. singleton-living-doc. This candidate leans
**versioned** — it fits the two-views framing (each snapshot is a current view;
priors are transformation history) and removes the standing typedef-vs-instance
disagreement — but marks it a genuine product decision.

## Rabbit holes

- **Re-declaring base fields per type** — the additive discipline is the whole
  point; a per-type schema that repeats base fields will drift from the base.
- **Orphaned taxonomy content** — PDR-032's coverage must fully re-home; a
  coverage check (every PDR-032 taxonomy claim lands in some per-type doc) is
  needed before the joint supersession is clean.
- **current-state migration cost** — if versioned, the live singleton
  `current-state.md` becomes `current-state-001` etc.; scope that as a follow-on,
  not inside this slice's schema decision.
- **Scenario is not one of the eight** — it is external (scenarios BC); do not
  pull it into the per-type set.

## No-gos

- No base-schema changes (slice #2), no writing skills (slice #4), no tooling
  (folded #5/#6/#7).
- No new artifact kinds; the eight are fixed.
- Does not perform the current-state instance migration (only decides the model).

## Evidence / experiments

- Grounded in PDR-032 (the taxonomy being exploded), adr-067 (the base schema),
  pdr-035 (the kinds + two-views), and the generated typedefs (current per-type
  shape). A bounded Architect pre-state check of PDR-032's taxonomy coverage vs.
  the eight typedefs should precede the schema ADR's convergence; flagged in the
  ADR dispatch. No experiments.

## Resolution

**Shaped 2026-07-25** in `sess-2026-07-25-a`, deriving from `intent-010`.
Authored as one-doc-per-lane (granularity flagged); current-state leans versioned
(flagged). Ready for the per-type needs PDR and the per-type schema ADR (built on
adr-067).

## Changelog

- 2026-07-25 opened and shaped in `sess-2026-07-25-a`, deriving from `intent-010`,
  as restructuring slice #3 (per-type needs + schema for the eight kinds).
