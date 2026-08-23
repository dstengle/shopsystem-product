---
type: data-type
id: definition-chain
defines: definition-chain
owner: product-authority
status: approved
approved: 2026-08-22
version: 1
created: 2026-08-20
updated: 2026-08-22
---

# Data type: definition-chain

## Purpose

The complete definition of good for one artifact type: the six links —
typedef, guideline, fitness set, process, roles, skill — that must exist
before any instance of the type is authored or rewritten. **The chain is
derived, never hand-written**: the linter assembles it from references
the documents already carry — the typedef's `defines`, the guideline's
and fitness set's `target-type`, the process's `produces` and its steps'
roles, the skill's `derived-from` — because hand-assembly would duplicate
those references (`single-source-of-truth`). Its `status` is derived the
same way: approved only when every linked document is approved. Produced
by the `derive-chain` and `rederive-chain` steps of
[`../processes/definition-chain-migration.md`](../processes/definition-chain-migration.md);
consumed by that process's `authority-review`, `approve-chain`,
`rewrite-keepers`, and `park` steps.

## Schema

```yaml
schema:
  type: object
  fields:
    artifact_type: {type: string}
    typedef: {type: string}
    guideline: {type: string}
    fitness: {type: string}
    process: {type: string}
    roles: {type: array, items: {type: string}}
    skill: {type: string}
    status: {type: string, enum: [draft, approved]}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-20 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-22 | state | draft → approved. |
