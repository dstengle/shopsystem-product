---
type: data-type
id: frame
defines: frame
owner: product-authority
status: approved
approved: 2026-08-19
version: 2
created: 2026-08-19
updated: 2026-08-19
---

# Data type: frame

## Purpose

The framing of a presentation: who reads it, what they must decide, which
asks gate the next unit of work. Produced by the `frame` step of
[`../processes/stakeholder-presentation.md`](../processes/stakeholder-presentation.md);
consumed by `compose`.

## Schema

```yaml
schema:
  type: object
  fields:
    reader: {type: string}
    decisions: {type: array, items: {type: string}}
    asks: {type: array, items: {type: string}}
    deferrals: {type: array, items: {type: string}}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-19 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
