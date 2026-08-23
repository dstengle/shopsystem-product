---
type: data-type
id: validation-report
defines: validation-report
owner: product-authority
status: approved
approved: 2026-08-22
version: 1
created: 2026-08-21
updated: 2026-08-21
---

# Data type: validation-report

## Purpose

The result of validating a document against its type: pass or the named
violations. Produced by the `validate` step of
[`../processes/session-handoff.md`](../processes/session-handoff.md);
consumed by that process's `route-validation`, `repair`, and
`file-defect` steps.

## Schema

```yaml
schema:
  type: object
  fields:
    ok: {type: boolean}
    errors: {type: array, items: {type: string}}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-21 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-22 | state | draft → approved. |
