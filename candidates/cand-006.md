---
type: candidate
id: cand-006
title: A foundational artifact-system needs statement — the anchor the restructuring supersedes into
status: shaped
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "Shape for slice #1 of the artifact-system restructuring: a foundational needs statement that names why artifacts exist, the eight kinds and how they compose, and the two-views/self-containment requirement with its changelog exception — requirement-only, no schema mechanics — and that formally supersedes PDR-031 and PDR-032's founding portion so the accepted set stays self-consistent."
derives-from: [intent-008]
session: sess-2026-07-25-a
experiments: []
brief:
parked-until:
beads: [lead-uhxoc]
---

# cand-006 — a foundational artifact-system needs statement

## Verbatim anchors

- 2026-07-25 (dstengle): "the big issue is that the document and role system is
  not up and running fully, leading to issues with how the work is being
  performed."
- 2026-07-25 (dstengle, shaping decisions): the slice-#1 line is drawn at
  **requirement-only** (name the kinds and composition and the two-views rule as
  a requirement; leave the edge mechanics to slice #2); and slice #1 **owns the
  supersession** of PDR-031 (fully) and PDR-032's founding portion.
- 2026-07-20 (dstengle, `sess-2026-07-20-a`): the two-views principle — the
  accepted set is the current-system view (self-contained, mutually consistent);
  the supersede chains are the transformation view, reachable but never required.

## Problem

The corpus is typed, plural, and gate-green (`cand-005` closed the precondition
chain), but *why* the artifact system exists, what the eight kinds are for, how
they compose, and the two-views/self-containment requirement live nowhere
authoritative — they are split across PDR-031 (BC founding) and PDR-032 (type
system and taxonomy) and captured, non-authoritatively, in
`drafts/artifact-system-restructuring.md`. `current-state.md` does not narrate
the artifact system at all. With no anchor for the founding requirement,
authoring keeps jumping the lifecycle: freehand decision docs with no provenance,
the withdrawn ADR-067/PDR-035, and the work-tracking drift where a bead
over-reports open work. This slice is the anchor the other six supersede into or
reference.

## Appetite

Small-to-moderate. One focused **needs** statement (a PDR), crisp enough for the
schema slice (#2) to encode. It is a why/needs statement, not a mechanism and not
a build. If it starts specifying fields, edge names, or tooling behavior, the
appetite is blown and it has overrun into #2.

## Solution sketch

A foundational needs document at capability altitude that states:

- **Why the product keeps artifacts** — decisions, intent, and shape are durable
  and must be reasoned about as a set, not reconstructed from history.
- **The eight kinds and how they compose** — the provenance spine
  (scenario → PDR → candidate → intent → session) plus the reference and derive
  relationships between kinds, described as *concepts*: what each kind is for and
  which kinds it hangs from. No field names, no edge-pair mechanics.
- **The two-views / self-containment requirement** — the accepted set is the
  current-system view and must be self-contained (no accepted doc reaches into a
  superseded one to be understood) and mutually consistent; the supersede chains
  are the transformation view, reachable but never required to read the present.
  `status` is the axis that separates the views. Coherence is stated here as the
  founding *requirement the schema serves*, not as a mechanism.
- **The changelog exception** — self-containment binds the content sections; the
  changelog is the one sanctioned place an accepted doc names its superseded
  predecessor.

The document carries `supersedes` edges to **PDR-031** (fully) and **PDR-032**
(its founding/needs portion; PDR-032 is jointly superseded across #1/#2/#3), so
the accepted set is self-consistent the moment this lands.

## Rabbit holes

- **Bleeding into the schema (#2).** The strongest pull: naming edge pairs,
  materialization posture, tags/distribution fields. Cut — those are #2.
- **Re-litigating the eight kinds.** The kinds already exist in the typedef; this
  slice states the *need* for them and their composition, it does not redesign
  the type set.
- **The `current-state` typedef conflict** (versioned vs. singleton-living-doc) —
  a real known issue, but it is per-artifact-schema work (slice #3). Named as
  out-of-scope, not resolved here.
- **The N:M supersession split of PDR-032** across #1/#2/#3 — this slice fixes
  only that it carries PDR-032's founding portion; the full split is decided as
  #2/#3 are drafted.

## No-gos

- No field names, edge-pair mechanics, materialization posture, tags,
  distribution values, CLI, or flags — all of that is slice #2 or later.
- Not the per-artifact needs or schemas (#3), not writing skills (#4), not
  navigation/rendering/query tooling (#5–7).
- Does not redefine the eight kinds; does not resolve the `current-state` typedef
  conflict.

## Evidence / experiments

- The founding requirement and decomposition were developed and sharpened by the
  product authority across `sess-2026-07-19-a` and `sess-2026-07-20-a`, captured
  in `drafts/artifact-system-restructuring.md` (non-authoritative planning
  capture per ADR-065).
- The lifecycle-jumping and work-tracking drift this slice roots out are recorded
  in `sess-2026-07-25-a` and `lead-t96cf`.
- No feasibility probe needed: this is a needs statement at capability altitude,
  no technical unknown blocks convergence.

## Resolution

**Shaped 2026-07-25** in `sess-2026-07-25-a`, deriving from `intent-008`. The two
scoping decisions that pinned the shape are the product authority's:
**requirement-only** for the #1↔#2 line, and **#1 owns the supersession** of
PDR-031 and PDR-032's founding portion. Appetite, shape, boundaries, and rabbit
holes are pinned; ready to hand to the lead-po for commitment (the foundational
needs PDR is the terminal deliverable of the slice).

## Changelog

- 2026-07-25 opened and shaped in `sess-2026-07-25-a`, deriving from
  `intent-008`, as slice #1 of the `lead-uhxoc` artifact-system restructuring;
  scope pinned by the product authority's two shaping decisions (requirement-only;
  own the PDR-031/032 supersession in #1).
