---
type: data-type
id: verification
defines: verification
owner: product-authority
status: approved
approved: 2026-08-19
version: 2
created: 2026-08-19
updated: 2026-08-23
---

# Data type: verification

## Purpose

The verdict of checking a BC's `work_done` demonstration against the
dispatched scenarios and the register. Produced by the `verify` step of
[`../processes/reconcile-and-close.md`](../processes/reconcile-and-close.md);
consumed by its routing, consume-close, and file-tail steps.

## Schema

```yaml
schema:
  type: object
  fields:
    verdict: {type: string, enum: [reconcile, discrepancy]}
    evidence: {type: string}
    scenario_status:
      type: array
      items:
        type: object
        fields:
          scenario_id: {type: string}
          status: {type: string, enum: [done, blocked, deferred]}
    reported_items:
      type: array
      items:
        type: object
        fields:
          category: {type: string, enum: [defect, observation, deferred-scenario]}
          summary: {type: string}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-19 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
