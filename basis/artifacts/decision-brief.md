---
type: artifact-typedef
id: decision-brief-typedef
defines: decision-brief
status: experiment
created: 2026-08-10
updated: 2026-08-19
ancestry: [request, decision-brief]
---

# Artifact type: decision-brief

## Identity and ancestry

- **Type:** `decision-brief`
- **Generic type:** request — it requests decisions.
  **Ancestry:** `request → decision-brief` (generic fallback: any validator
  that knows `request` may check this type at that level).
- **User-need quadrant:** action + work — the reader
  is deciding, now. One quadrant per document; a brief that drifts into
  explanation fails its type.
- **Produced by:** [`../processes/stakeholder-presentation.md`](../processes/stakeholder-presentation.md).
  **Consumed by:** the product authority, at a sitting.

## Required frontmatter

`type`, `status` (draft | delivered | decided), `date`, `reader`,
`decisions-requested` (count), `annex` (link), `verified-by` (cold-read
round record). Schema-validated; unknown keys rejected (closed field set,
per the authority's strictness directive).

## Required sections

1. **The answer first** — SCQA opening, ≤4 sentences, then the
   recommendation; states which asks gate work and which default on silence.
2. **Asks** — each: question → recommendation → inline evidence → default.
   Block-ratification asks state what ratification binds vs what stays a
   drafting default.
3. **Deferred** (if anything is) — deferrals are notes, never asks.
4. **Annex link** — the full material, labeled optional.

## Commitment (Definition of Done)

A decision-brief is done when: the reader can make every requested decision
from the brief alone in one short sitting; budgets hold (decision layer
≤ ~400 words, total ≤ ~1,500); an independent cold read has passed it (O3 of
the producing process). **Consequence on failure:** the brief returns to the
author for re-forming — it is not deliverable, and decisions made from a
failed brief are not recorded as ratifications.

## Derived review checklist (from this schema — cite-or-delete rule)

- Frontmatter validates; unknown keys rejected. *(schema)*
- Answer-first section states gate-vs-default. *(§Required sections 1)*
- Every ask complete per the four-part form. *(§Required sections 2)*
- Budgets measured. *(Commitment)*
- Cold-read record present. *(Commitment)*
- Quality of prose: judged via
  [`../fitness/decision-brief.fitness.md`](../fitness/decision-brief.fitness.md).
