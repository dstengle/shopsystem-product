---
type: intent-record
id: intent-011
title: Each artifact kind needs a writing skill that guides authoring through its lifecycle, and the system must enforce that every kind has a valid one
status: recorded
created: 2026-07-25
updated: 2026-07-25
authors: [dstengle, "Claude (lead-pm)"]
description: "The corpus validates artifacts but does not GUIDE their creation: an author can freehand a decision doc with no provenance, wrong status, or a jumped lifecycle (the withdrawn ADR-067/PDR-035-draft; a lead-pm ADR misstep on 2026-07-25). Each of the eight kinds needs a per-type writing skill that bundles its template and schema checks so authoring is guided to the typedef, and shop-templates must enforce that every kind has a writing skill whose content is valid. This is the authoring-guidance layer — the missing half of 'the document and role system is not up and running fully.'"
stakeholder: dstengle
session: sess-2026-07-25-a
superseded-by:
beads: [lead-2lxya]
---

# intent-011 — per-artifact writing skills and their enforcement

## Verbatim anchors

- 2026-07-25 (dstengle): "the big issue is that the document and role system is
  not up and running fully, leading to issues with how the work is being
  performed."
- `drafts/artifact-system-restructuring.md`: "#4 Per-artifact writing skills —
  PDR (each type has a writing skill bundling template + schema checks); ADR
  (skill-template structure); ADR (shop-templates enforces: every type has a
  writing skill; skills have valid content)."

## The goal behind the ask

The knowledge system *validates* artifacts (per-file `validate` + the coherence
gate) but nothing *guides* their creation. So authoring keeps jumping the
lifecycle: freehand decision docs with no provenance, artifacts authored at the
wrong `status`, the withdrawn ADR-067/PDR-035-draft, and — concretely this very
session — a lead-pm reflex to "have a subagent draft an ADR" with no intent
anchor and no lifecycle discipline, caught only by the product authority. Each of
the eight kinds needs a **writing skill** that bundles its template and schema
checks, so an author is walked to the typedef and the lifecycle rather than
improvising; and **shop-templates must enforce** that every kind has such a skill
and that the skill's content is valid.

## Who it serves

The operating roles (PM/PO/Architect) authoring into the corpus — they get guided
authoring instead of tribal knowledge — and the product authority, who stops
having to catch lifecycle jumps by hand. This is the counterpart to the coherence
gate: the gate catches bad artifacts after the fact; the writing skills prevent
them at authoring time.

## Constraints

- **Needs slice #3** (the per-type schemas the writing skills check against).
- Writing skills bundle the existing per-type template + schema checks (they reuse
  `shop-knowledge template`/`schema`/`validate`, not a parallel copy).
- Enforcement lives in **shopsystem-templates** (role behavior + skill discipline
  is its ubiquitous language), gate rules in scenarios — per the draft's lane
  discipline.

## Non-goals

- The per-type schemas themselves (slice #3).
- The base schema (slice #2) and tooling (folded #5/#6/#7).
- Rewriting the existing PM/discovery skills — this is about the artifact
  *writing* skills per kind, not the discovery/shaping skill set.

## Appetite signal

Moderate: eight per-type writing skills (template + schema-check bundle), one
skill-template structure, and one enforcement mechanism. Bounded by reusing the
existing template/schema/validate surface.

## Failure conditions

- Writing skills fork the template/schema instead of reusing the single source →
  drift, the exact failure the typedef→generator mechanism exists to prevent.
- Enforcement is advisory-only → kinds ship without writing skills and authoring
  keeps improvising, leaving the authoring-guidance gap open.

## Open threads

- Whether the eight writing skills are one skill parameterized by kind or eight
  discrete skills — a slicing/mechanism call for this slice's ADR.
- Interaction with the role-prompt "consult-decision-index" gate (lead-x7bp
  lineage): whether the writing skill also injects the relevant accepted-decision
  context at authoring time. Flag for the schema/enforcement ADR.
