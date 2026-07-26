---
type: candidate
id: cand-009
title: Per-type writing skills that bundle template + schema checks, with shop-templates enforcing every kind has a valid one
status: committed
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "Shape for slice #4: each of the eight kinds gets a writing skill that bundles its per-type template and schema checks (reusing shop-knowledge template/schema/validate, not a fork) so authoring is guided to the typedef and lifecycle; shop-templates enforces that every kind has a writing skill and that each skill's content is valid. The authoring-guidance layer that prevents lifecycle jumps at creation time."
derives-from: [intent-011]
session: sess-2026-07-25-a
experiments: []
brief:
parked-until:
beads: [lead-2lxya]
---

# cand-009 — per-type writing skills and their enforcement

## Verbatim anchors

- 2026-07-25 (dstengle): the document and role system "is not up and running
  fully, leading to issues with how the work is being performed."
- `drafts/artifact-system-restructuring.md`: "#4 ... each type has a writing skill
  bundling template + schema checks ... shop-templates enforces: every type has a
  writing skill; skills have valid content."

## Problem

The knowledge system validates artifacts but does not guide their creation, so
authoring jumps the lifecycle — freehand decision docs, wrong `status`, missing
provenance (the withdrawn ADR-067/PDR-035-draft; a lead-pm ADR misstep caught by
the authority on 2026-07-25). The gate catches bad artifacts after the fact;
nothing prevents them at authoring time. Each kind needs a writing skill that
walks the author to its template and schema, and the system must guarantee every
kind actually has such a skill.

## Appetite

Moderate: eight per-type writing skills (each a template + schema-check bundle),
one skill-template structure, one enforcement mechanism. Bounded by reusing the
existing `shop-knowledge template`/`schema`/`validate` surface.

## Solution sketch

At capability altitude, three parts:

- **Per-type writing skills** — for each of the eight kinds, a writing skill that
  bundles the kind's template (from `shop-knowledge template <kind>`) and its
  schema checks (`shop-knowledge validate`), and walks the author through the
  kind's lifecycle: provenance edges to set, correct starting `status`, required
  sections. The skill *reuses* the single-sourced template/schema — it never
  copies them (copies drift, the exact failure the generator mechanism prevents).
- **Skill-template structure** — a common structure every per-type writing skill
  follows, so the eight are consistent and generatable.
- **Enforcement** — shop-templates enforces that every recognized kind has a
  writing skill and that each skill's content is valid (points at the live
  template/schema, covers the kind's required sections). Enforcement is
  **blocking**, not advisory — an advisory check leaves the gap open.

Lane homes per the draft: needs → this PDR; skill-template structure + enforcement
mechanism → ADRs; role behaviour + enforcement lives in shopsystem-templates; gate
rules in scenarios.

## Rabbit holes

- **Skills forking the template/schema** instead of pointing at the single source
  → drift. The reuse discipline is the whole point.
- **Advisory-only enforcement** → kinds ship without skills and authoring keeps
  improvising.
- **One-vs-eight skills** — whether the writing skill is one skill parameterized by
  kind or eight discrete skills; a mechanism call for this slice's ADR.
- **Consult-decision-index coupling** (lead-x7bp lineage) — whether the writing
  skill also injects relevant accepted-decision context at authoring time; keep as
  a flagged option, not baked in here.

## No-gos

- Not the per-type schemas (slice #3), base schema (#2), or tooling (folded
  #5/#6/#7).
- Skills do not fork or re-implement templates/schemas.
- Does not rewrite the existing PM/discovery skill set — this is the artifact
  *writing* skills per kind.

## Evidence / experiments

- Grounded in intent-011, the per-type schemas of slice #3 (adr-069, the check
  target), and the live `shop-knowledge template`/`schema`/`validate` surface plus
  the `shop-templates` enforcement precedent (`bin/check-knowledge-artifacts`,
  `doctor`). A bounded Architect pre-state check of the shop-templates
  writing-skill/enforcement surface should precede the enforcement ADR; flagged in
  its dispatch. No experiments.

## Resolution

**Shaped 2026-07-25** in `sess-2026-07-25-a`, deriving from `intent-011`. This is
the authoring-guidance layer — the counterpart to the coherence gate. Ready for
the needs PDR and, on slice #3's schema landing, the skill-template-structure ADR
and the shop-templates-enforcement ADR (both dispatched to the architect;
enforcement realized via shopsystem-templates). One-vs-eight-skills and the
consult-decision-index coupling are flagged mechanism calls.

## Changelog

- 2026-07-25 opened and shaped in `sess-2026-07-25-a`, deriving from `intent-011`,
  as restructuring slice #4 (per-type writing skills + enforcement).
