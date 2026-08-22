---
type: data-type
id: action-table
defines: action-table
owner: product-authority
status: approved
approved: 2026-08-22
created: 2026-08-22
updated: 2026-08-22
---

# Data type: action-table

## Purpose

The governed channel for the migration plan's per-record decisions: one
row per corpus record, carrying the authority-approved action and any
per-keeper rewrite directives. Rows are approved row by row or in blocks
at a review; the table is the only lawful source of per-keeper
directives and family nominations — a directive never travels inside a
retired document. Produced by the migration-plan review (the authority
approves the rows); consumed by the `build-chain`, `exemplar-rewrite`,
and `rewrite-keepers` steps of
[`../processes/definition-chain-migration.md`](../processes/definition-chain-migration.md)
and by every step of
[`../processes/corpus-close-out.md`](../processes/corpus-close-out.md).

`family` values are nominations, not commitments: the chain review
decides final record granularity. A row awaiting a ruling carries the
row marker `authority-call` in the plan; such a row has no `action` yet
and does not enter an instance of this type until ruled.

## Schema

```yaml
schema:
  type: array
  items:
    type: object
    fields:
      id: {type: string}
      path: {type: string}
      action: {type: string, enum: [keep-rewrite, keep, retire, terminal]}
      family: {type: string, optional: true}
      directives: {type: array, items: {type: string}, optional: true}
      evidence: {type: string}
```

Field notes: `id` is the record id (e.g. `brief-022`); `path` is the
record's path in the active tree; `family` is an optional F-code
nominating a family the record may fold into; `directives` are the
authority-approved per-keeper rewrite instructions applied at rewrite;
`evidence` is the one-line census evidence the action was ruled on.
