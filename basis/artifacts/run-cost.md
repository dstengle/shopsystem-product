---
type: artifact-typedef
id: run-cost-typedef
defines: run-cost
owner: product-authority
status: approved
approved: 2026-09-08
version: 2
created: 2026-09-08
updated: 2026-09-09
ancestry: [run-cost]
---

# Artifact type: run-cost

## Identity and ancestry

- **Type:** `run-cost` — the cost rows for one session's close: one row
  per agent run recorded on the session's anchor, naming step, role,
  minutes, context tokens, output tokens, and tool uses, none of them
  computed by a model. A mechanical record, never a governing
  definition: nobody approves an instance, and none is amended once
  written.
- **Produced by:** the `write-cost-rows` step of
  [session-handoff-process](../processes/session-handoff.md), a runtime
  step, from the execution's anchor and the harness's own usage report alone.
  **Consumed by:** the authority, who reads the cost; the run-efficiency
  parent initiative, whose measure the rows feed.

## Required frontmatter

`type: run-cost`, `id`, `session` (the path of the session record this
instance sits beside), `anchor` (the `bd` work item id the rows were
read from), `created`, `updated`. The field set is closed.

## Required sections

1. **Rows** — one table row per agent run the anchor records: step,
   role, minutes, context tokens, output tokens, tool uses. A field the
   harness's usage report does not expose for that run is blank.

## Commitment (Definition of Done)

An instance is done when its rows can be read without opening the
session record or a transcript. **Consequence on failure:** the
authority reads transcripts by hand instead, the cost this feature
exists to remove.

## Sources

The cost row's fields and the blank-field rule from
adr-2026-09-08-run-cost-artifact; the file-beside-the-record form from
the implementation-guidance typedef's own precedent, so the session
record it sits beside is never amended.

## Derived review checklist

- `session` and `anchor` present; the session record itself unchanged.
  *(§Required frontmatter)*
- Every row names step, role, minutes, context tokens, output tokens,
  tool uses; a field the usage report withheld is blank, never a
  number a model supplied. *(§Required sections 1)*
- No row for a runtime step. *(§Identity and ancestry)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored under feat-run-measurement's five scenarios assigned to shopsystem-product (guidance/feat-run-measurement-shopsystem-product.md v1), per adr-2026-09-08-run-cost-artifact (D1: a new artifact beside the session record, never an amendment to `pkg:shopsystem-knowledge/session-record`) and U2's default (one file per session record, in `sessions/`, named to pair with it). No Writing rules or Fitness scenarios sections: no role's judgment goes into an instance, so nothing is judged. Maker's evaluation against the artifact-typedef typedef's derived checklist: `defines` matches the instance `type`; the six required sections present in order; the commitment states a consequence; sources present, no pinned example links; every checklist entry cites a clause; Writing rules and Fitness scenarios both absent, matching (neither present). Made by the lead-solutions-architect role. |
| 1 | 2026-09-08 | state | draft → approved, made together with the session-handoff-process amendment it serves and the demonstrated row at sessions/sess-2026-09-07-b-cost.md, under the same working session. |
| 2 | 2026-09-09 | update | `run` propagated to `execution` as the noun for a process instance, under req-2026-09-08-definition-vs-instance / feat-execution-vocabulary (shopsystem-product): mechanical, determiner-adjacent occurrences only (`a/the/this/one/another/each/no/any run(s)`); `run-by`, `run` as a schema field or step key, and compound/heading uses (e.g. `run-cost`, `run list`, `Run lifecycle`) left unchanged, that residue disclosed as not done in this pass. Self-check against define-good-up-front: diffed against the file's pre-edit text; no requirement, field name, or heading changed. Made by the lead-solutions-architect role. |
