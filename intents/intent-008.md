---
type: intent-record
id: intent-008
derived-by: [cand-006]
title: The artifact system needs an authoritative foundational statement — what artifacts are for, the kinds and how they compose, and the two-views requirement
status: recorded
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "The founding requirement of the artifact system — why artifacts exist, the eight kinds and how they compose, and the two-views/self-containment rule with its changelog exception — lives only in scattered predecessors (PDR-031, PDR-032) and a non-authoritative draft, so authoring keeps jumping the lifecycle and the current-system view has no anchor. Slice #1 of the artifact-system restructuring (lead-uhxoc) needs a foundational needs statement to be that anchor."
stakeholder: dstengle
session: sess-2026-07-25-a
superseded-by:
beads: [lead-uhxoc]
---

# intent-008 — the foundational artifact-system needs

## Verbatim anchors

- 2026-07-25 (dstengle): "the big issue is that the document and role system
  is not up and running fully, leading to issues with how the work is being
  performed."
- 2026-07-20 (dstengle, `sess-2026-07-20-a`): accepted documents must give a
  *consistent current view of the system, not its transformation over time* —
  the `accepted` set is self-contained and mutually consistent; superseded docs
  and the supersede chains are the transformation view, reachable but never
  required to read the present.

## The goal behind the ask

An authoritative statement of the artifact system's founding requirement, so the
corpus has an anchor the rest of the restructuring supersedes into or references.
It names *why* the product keeps artifacts at all, *what* the eight kinds are and
*how* they compose (the provenance spine plus the reference and derive
relationships between kinds), and the *two-views / self-containment* requirement
with its changelog exception. Today this is captured only in a non-authoritative
draft and split across PDR-031 and PDR-032; the corpus is typed and gate-green
but has no doc that states the founding requirement the schema then serves.

## Who it serves

The product authority (who reasons about the system from its accepted set) and
the agents operating the shop — the PM, PO, and Architect roles that author into
the corpus, plus the coherence gate that enforces it. When the founding
requirement has no anchor, authoring jumps the lifecycle (freehand decision docs
with no provenance, the withdrawn ADR-067/PDR-035, the drift where a bead
over-reports open work) — the symptom this intent removes the root of.

## Constraints

- **Requirement-only.** States the two-views/self-containment requirement and
  names the kinds and their composition at capability level. The schema
  mechanics — the materialized edge pairs, tags, distribution, external
  references — belong to the next slice, not here.
- **Capability altitude.** No field names, no edge-pair mechanics, no CLI.
- **Clean restart.** The foundational statement formally supersedes PDR-031
  (fully) and the founding/needs portion of PDR-032, so the accepted set stays
  self-consistent the moment it lands (PDR-032 is jointly superseded across this
  slice and the schema/per-artifact slices).

## Non-goals

- The base schema and edge mechanics (restructuring slice #2).
- The per-artifact needs and schemas (slice #3).
- The per-artifact writing skills and their enforcement (slice #4).
- The navigation / rendering / query tooling (slices #5–7).

## Appetite signal

Small-to-moderate: one focused needs statement, crisp enough for the schema
slice to encode. Not a mechanism, not a build.

## Failure conditions

- It drifts into specifying fields, edge names, or tooling behavior — then it has
  overrun into slice #2 and stopped being a needs statement.
- It leaves PDR-031/032 un-superseded — then two founding docs coexist and the
  current-system view is no longer self-consistent.

## Open threads

- The N:M split of PDR-032 across slices #1/#2/#3 (which portion each successor
  carries) is decided as those successors are drafted; this intent fixes only
  that slice #1 carries PDR-032's founding/needs portion.
