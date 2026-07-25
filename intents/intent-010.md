---
type: intent-record
id: intent-010
title: Each artifact kind needs its own stated needs and schema — explode the bundled taxonomy into per-type docs on top of the base schema
status: recorded
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "The eight artifact kinds (adr, pdr, brief, intent-record, candidate, session-record, current-state, prioritization-record) have distinct purposes, required sections, status lifecycles, and edge participation, but today those per-type needs are bundled inside PDR-032's taxonomy and the generated typedefs rather than each being stated in its own doc. Slice #3 explodes the taxonomy into per-type needs (why each kind exists, what it distinctly requires) and per-type schema (its fields/sections on top of the base schema from slice #2), and resolves the current-state versioned-vs-singleton typedef conflict."
stakeholder: dstengle
session: sess-2026-07-25-a
superseded-by:
beads: [lead-4vvdo]
---

# intent-010 — per-artifact needs and schema

## Verbatim anchors

- `drafts/artifact-system-restructuring.md`: "#3 Per-artifact needs (PDR ×8) +
  per-artifact schema (ADR ×8) — the bulk; explodes PDR-032's taxonomy into
  per-type docs." Open slicing call: "whether #3 is one intent or per-type."
- 2026-07-20 (dstengle, `sess-2026-07-20-a`): the current-state typedef conflict
  — the typedef models current-state as a versioned, supersede-able artifact
  while the live doc is a singleton rewritten in place; "resolve in the
  per-artifact schema work."

## The goal behind the ask

Each of the eight kinds has distinct needs: what it is *for*, what sections it
must carry, what status lifecycle it moves through, and which of the base
schema's edges it participates in (e.g. a session produces; a candidate derives
from an intent; a PDR derives from a candidate and can supersede prior PDRs).
Today those per-type needs are bundled inside PDR-032's single taxonomy and the
generated typedefs — legible to the generator but not each stated as an
authoritative per-type need/schema doc. This slice explodes the taxonomy into
per-type **needs** (the why per kind) and per-type **schema** (each kind's fields
and sections on top of slice #2's base schema), so each kind's contract is
individually stated and superseded cleanly out of PDR-032.

It also **resolves the current-state typedef conflict**: whether current-state is
a versioned, supersede-able artifact (`current-state-NNN`, `status`
current/superseded) or the singleton living document it is in practice.

## Who it serves

The operating roles authoring each kind (they get a per-type contract instead of
reading one bundled taxonomy) and the generator/gate (per-type schemas single-
sourced from per-type typedefs). It is the bulk of the restructuring — the layer
that makes "artifact system" mean eight well-specified kinds rather than one
taxonomy.

## Constraints

- **Needs slice #1** (the kinds and two-views requirement) and **slice #2** (the
  base schema every per-type schema extends).
- Per-type schemas are **additive on the base** — a per-type schema states only
  what that kind adds to or constrains beyond the base (sections, status enum,
  edge participation), never re-declaring base fields.
- The eight kinds are fixed here (adr, pdr, brief, intent-record, candidate,
  session-record, current-state, prioritization-record); scenario is external
  (owned by the scenarios BC) and out of scope.

## Non-goals

- The base schema itself (slice #2).
- Per-artifact writing skills and their enforcement (slice #4).
- The programmatic-access tooling (folded slice #5/#6/#7).

## Appetite signal

Large — this is the bulk. But bounded: eight kinds, each a needs statement plus a
schema delta on the base, plus one conflict (current-state) to resolve.

## Failure conditions

- Per-type schemas re-declare base fields and drift from the base schema.
- The current-state conflict is left unresolved (the typedef and the live doc stay
  in disagreement, as they are today).
- The explosion loses PDR-032's coherence — some taxonomy content ends up owned by
  no per-type doc (orphaned) as PDR-032 is jointly superseded.

## Open threads

- **Granularity (flagged for the product authority):** this slice is authored as
  one intent → one candidate → one per-type-needs PDR → one per-type-schema ADR
  (all eight kinds in sectioned docs), not eight separate PDR/ADR pairs — the
  router's autonomous call under the draft's explicit open-slicing latitude. If
  the authority prefers per-type docs, this re-splits.
- **current-state resolution:** the versioned-vs-singleton decision is made in
  this slice's schema doc; the draft leans versioned (each snapshot accepted,
  priors superseded = history), which fits the two-views framing — but it is a
  genuine decision for the authority.
