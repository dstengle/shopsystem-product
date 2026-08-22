---
type: artifact-typedef
id: migration-plan-typedef
defines: migration-plan
owner: product-authority
status: approved
approved: 2026-08-22
created: 2026-08-22
updated: 2026-08-22
ancestry: [request, migration-plan]
---

# Artifact type: migration-plan

Authored on the authority's ruling of 2026-08-22: migrations happen
periodically and should have a definition — the type gets a typedef,
not a bootstrap exception.

## Identity and ancestry

- **Type:** `migration-plan`
- **Generic type:** request — it requests one block ruling (the
  action assigned to every record of a corpus) plus named open
  rulings.
  **Ancestry:** `request → migration-plan` (generic fallback: any
  validator that knows `request` may check this type at that level).
- **User-need quadrant:** action + work — the reader is ruling on
  per-record actions and a schedule, now.
- **Produced by:** the census/rebaseline activity of a re-founding or
  periodic migration; paired at delivery with a decision-brief
  produced by
  [`../processes/stakeholder-presentation.md`](../processes/stakeholder-presentation.md).
  **Consumed by:** the product authority (rules on it) and the
  migration runs (execute it): each
  [`definition-chain-migration`](../processes/definition-chain-migration.md)
  run takes its keeper rows; each
  [`corpus-close-out`](../processes/corpus-close-out.md) stage takes
  its retire and terminal rows — both through the `action-table` typed
  input, never by re-parsing the plan's prose.

## Required frontmatter

`type`, `id`, `revision` (integer, increments per returned review),
`supersedes` (predecessor instrument or none), `owner`, `status`
(draft | approved | executing | executed | superseded), `created`,
`updated`. Schema-validated; unknown keys rejected (closed field set,
per the authority's strictness directive).

## Required sections

1. **How to rule** — what block approval makes final vs what it only
   nominates, and how silence is handled per open item.
2. **Vocabulary** — every term of art either marked as glossary-defined
   or defined in-document; every external reference (record ids, work
   items, prior rulings) glossed where first used.
3. **Summary** — totals by lane and action, units never mixed
   (records, trees, and scenario pins on separate lines), every count
   machine-derived from the live tree and the derivation named.
4. **Run order** — one entry per migration run plus mechanical
   close-out stages; each entry names its artifact type(s).
5. **Execution readiness and entry conditions** — per run: which chain
   links pre-exist (from the linter, not prose claims), keeper-list
   source, tools required, target tree; blocking preconditions named.
6. **The authority's review surface** — every review touchpoint from
   plan approval through mass rewrite to close-out, with the
   accept/reject options at each.
7. **Action tables** — one row per record: id, action
   (keep-rewrite | keep | retire | terminal), one-line evidence;
   authority-call rows marked awaiting ruling.
8. **Open rulings** — each: question, recommendation, default if
   unruled.
9. **What demonstrates done** — the running-system demonstration for
   run-done and migration-done (delivery-verified; counts and status
   stamps alone never suffice).
10. **Sources** — external forms adopted, or the recorded gap
    justifying bespoke structure.
11. **Rewrite families appendix** (when families are nominated) — the
    authoritative family map: code, name, members, nominated output,
    rationale; nominations only unless the target type's chain exists.

## Commitment (Definition of Done)

A migration-plan is done (approvable) when: every count is
machine-derived and reconciles against the live tree; every row
carries evidence; every external reference is glossed in-document;
per-run entry conditions are stated and their blocking preconditions
named; the plan is delivered through a stakeholder-presentation run
(decision-brief + independent cold read + round log) — never as the
raw decision surface. **Consequence on failure:** the plan returns to
its author; rulings made from a failed plan are not recorded as
approvals.

## Sources

Records-management retention schedule (ISO 15489 practice — the
schedule that assigns each record class its retain/transfer/destroy
action) for the action-table form; data
migration runbook practice (entry conditions, reversibility snapshot,
verification gates) for the run structure; the decision-brief pairing
follows this shop's stakeholder-presentation process.

## Derived review checklist (from this schema — cite-or-delete rule)

- Frontmatter validates; unknown keys rejected. *(schema)*
- Block-approval scope states final vs nominated. *(§Required 1)*
- No unglossed term or reference. *(§Required 2; cold read)*
- Counts machine-derived, units unmixed, derivation named.
  *(§Required 3)*
- Every run has entry conditions from linter truth. *(§Required 5)*
- Done-standard is a running-system demonstration. *(§Required 9)*
- Delivered via stakeholder-presentation with round log.
  *(Commitment)*
