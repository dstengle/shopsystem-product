---
type: data-type
id: validation-report
defines: validation-report
owner: product-authority
status: draft
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
