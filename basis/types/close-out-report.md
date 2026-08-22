---
type: data-type
id: close-out-report
defines: close-out-report
owner: product-authority
status: approved
approved: 2026-08-22
created: 2026-08-22
updated: 2026-08-22
---

# Data type: close-out-report

## Purpose

The result of one close-out stage: which record ids were moved to the
archive, which were deleted (recoverable only via the snapshot tag), and
which failed the post-check — a row not where its action says it should
be. Produced by the `post-check` step of
[`../processes/corpus-close-out.md`](../processes/corpus-close-out.md);
consumed by that step's own check (a non-empty `failed` fails the run
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
