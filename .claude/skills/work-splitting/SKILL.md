---
name: work-splitting
description: Split an Epic or an oversized requirement into thin, vertical slices — each pinning one coherent behavior — using proven split patterns, so scenarios stay single-behavior and work stays right-sized. Use when decomposing an Epic into scenarios, when a scenario carries multiple When/Then, or when an assigned unit is too big to build and review cleanly.
---

# Work / scenario splitting (adapted, EXPERIMENTAL)

**Discipline 4 — Specification as the contract (right-sizing).** Adapted from
`deanpeters/Product-Manager-Skills/skills/user-story-splitting` (Lawrence &
Green, *Humanizing Work Guide to Splitting User Stories*). See
[`../README.md`](../README.md).

## Why the PO reaches for this — technique, not artifact

We do **not** split "user stories." We split **Epics into scenarios** and keep
each scenario single-behavior. Thin vertical slices ship sooner, review cleaner,
and trace to one outcome. In a system where the BC fleet builds *exactly* what is
specified, a fat multi-behavior scenario is a fat, ambiguous contract — so
right-sizing is a specification-quality act, not a planning convenience.

## The unit being split

- an **Epic** → the scenarios that realize its outcome;
- an **oversized scenario** → focused single-behavior scenarios;
- an **assigned work unit** → right-sized before dispatch.

The leaf is always a **Gherkin scenario** (the contract atom), never a story.

## The split patterns (apply in order; stop at the first that fits)

1. **Workflow steps** — sequential steps → separate scenarios.
2. **Business-rule variations** — different rules (permissions, calculations) →
   one scenario each.
3. **Data variations** — different input types → separate scenarios.
4. **Acceptance-criteria complexity** — **multiple When/Then in one scenario →
   split along them.** In BDD this is the primary tell *and* basic Gherkin
   hygiene: one scenario, one behavior.
5. **Major effort** — deliver an incremental technical milestone as a thin slice.
6. **External dependencies** — split along dependency boundaries.
7. **Ops/infra steps** — split deployment/infra concerns out.
8. **Tiny act of discovery** — when none fit, a small spike to unpack the unknown.

## Vertical, not horizontal (the rule that matters)

Every slice must pin a coherent **behavior/outcome** — never a **layer**
("front-end scenario") and never an **engineering task** ("set up the DB").

Task decomposition is a *different* activity: inside a BC the Implementer's
sub-issue breakdown (§4.2) is engineering tasks. This skill right-sizes the
**requirement/behavior** upstream of that. The two compose — thin scenarios make
the BC's internal task breakdown tractable — but do not confuse them. (This skill
is the lead's lever; the BC's internal-design quality is a separate, architect
concern.)

## Lands in our artifacts

- An **Epic** (lead-owned, outcome-anchored) → its scenarios in `features/`.
- An oversized scenario → focused scenarios, each tracing **forward to one
  testable behavior** (Discipline 4 sufficiency) and **back to a problem**
  (Discipline 1).
- Feeds dispatch: `assign_scenarios` should carry thin, single-behavior
  scenarios, not a bundle.

## Product-general

Identical technique for consumer-product scenarios and framework-as-product
scenarios — the patterns are about behavior shape, not domain.

## Posture & sufficiency

- **COMMIT-TO-SPECIFICS:** commit the split; surface a genuinely ambiguous slice
  boundary as a `clarify` rather than stalling.
- **Sufficiency:** no surviving scenario bundles multiple behaviors (no stray
  When/Then pairs that are really separate scenarios); every slice passes the
  "would a Reviewer accept this as *one thing*?" check; no slice is a layer or a
  task.
