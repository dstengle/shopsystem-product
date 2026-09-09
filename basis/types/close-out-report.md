---
type: data-type
id: close-out-report
defines: close-out-report
owner: product-authority
status: approved
approved: 2026-08-22
version: 3
created: 2026-08-22
updated: 2026-09-09
---

# Data type: close-out-report

## Purpose

The result of one close-out stage: which record ids were moved to the
archive, which were deleted (recoverable only via the snapshot tag), and
which failed the post-check — a row not where its action says it should
be. Produced by the `post-check` step of
[`../processes/corpus-close-out.md`](../processes/corpus-close-out.md);
consumed by that step's own check (a non-empty `failed` fails the execution
loudly) and by the migration plan's run log.

## Schema

```yaml
schema:
  type: object
  fields:
    stage: {type: string}
    moved: {type: array, items: {type: string}}
    deleted: {type: array, items: {type: string}}
    failed: {type: array, items: {type: string}}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-22 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-09-09 | update | `run` propagated to `execution` as the noun for a process instance, under req-2026-09-08-definition-vs-instance / feat-execution-vocabulary (shopsystem-product): mechanical, determiner-adjacent occurrences only (`a/the/this/one/another/each/no/any run(s)`); `run-by`, `run` as a schema field or step key, and compound/heading uses (e.g. `run-cost`, `run list`, `Run lifecycle`) left unchanged, that residue disclosed as not done in this pass. Self-check against define-good-up-front: diffed against the file's pre-edit text; no requirement, field name, or heading changed. Made by the lead-solutions-architect role. |
