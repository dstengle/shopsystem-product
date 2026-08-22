---
type: data-type
id: verification
defines: verification
owner: product-authority
status: approved
approved: 2026-08-19
created: 2026-08-19
updated: 2026-08-19
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
