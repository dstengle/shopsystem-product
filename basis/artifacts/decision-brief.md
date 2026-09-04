---
type: artifact-typedef
id: decision-brief-typedef
defines: decision-brief
owner: product-authority
status: approved
approved: 2026-08-19
version: 4
created: 2026-08-10
updated: 2026-09-04
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
  **Consumed by:** the product authority, at a review.

## Required frontmatter

`type`, `id`, `status` (draft | delivered | decided), `version`,
`date`, `reader`, `decisions-requested` (count), `annex` (link).
Optional: `relates-to` — a list of one or more paths, each from the
repository root to an artifact the brief is about: an initiative, a
feature, a decision record, a work item, or another artifact of the
shop. It carries what the brief relates to, so a reader can reach
what is decided on from the brief; every path in it resolves to an
existing file. Schema-validated; unknown keys rejected (closed field
set, per the authority's strictness directive); the lint at
[`../tools/lint_basis.py`](../tools/lint_basis.py) checks every brief
in `briefs/` by this set, and one brief alone with `--brief <path>`.
The cold-read round record lives as `review` entries in the Document
History — one per round with the verdict and the judge's model —
never in frontmatter, per the definition typedef's Document History
rule.

## Required sections

1. **The answer first** — SCQA opening, ≤4 sentences, then the
   recommendation; states which asks gate work and which default on silence.
2. **Asks** — each: question → recommendation → inline evidence → default.
   Block-approval asks state what approval binds vs what stays a
   drafting default.
3. **Deferred** (if anything is) — deferrals are notes, never asks.
4. **Annex link** — the full material, labeled optional.

## Commitment (Definition of Done)

A decision-brief is done when: the reader can make every requested decision
from the brief alone in one short reading; budgets hold (decision layer
≤ ~400 words, total ≤ ~1,500); an independent cold read has passed it (O3 of
the producing process). **Consequence on failure:** the brief returns to the
author for re-forming — it is not deliverable, and decisions made from a
failed brief are not recorded as approvals.

## Sources

ISO/IEC/IEEE 15289 (generic content types); DITA-style ancestry
declaration; Scrum's artifact-commitment pairing; layer and ask structure
from Minto/SCQA, BLUF, and government briefing-note practice.

## Derived review checklist (from this schema — cite-or-delete rule)

- Frontmatter validates; unknown keys rejected. *(schema)*
- Every `relates-to` path resolves from the repository root. *(schema)*
- Answer-first section states gate-vs-default. *(§Required sections 1)*
- Every ask complete per the four-part form. *(§Required sections 2)*
- Budgets measured. *(Commitment)*
- Cold-read rounds recorded as Document History review entries. *(Commitment; definition typedef §Required sections 3)*
- Quality of prose: judged via
  [`../fitness/decision-brief.fitness.md`](../fitness/decision-brief.fitness.md).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-10 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-19 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-08-23 | update | Owner direction: verified-by removed from the frontmatter set — cold-read rounds are Document History review entries; id and version join the closed field set, reconciling the deferred versioning-standard conflict. |
| 4 | 2026-09-04 | update | Under req-2026-09-04-brief-relates-to at the small-change process's make step: `relates-to` added to the closed field set as an optional list of repository-root paths to the artifacts the brief is about, each resolving; the lint that checks the set and the `--brief` mode named; the derived checklist gains the path-resolution line. Made by the lead-solutions-architect role. |
