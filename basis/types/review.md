---
type: data-type
id: review
defines: review
owner: product-authority
status: approved
approved: 2026-08-19
version: 2
created: 2026-08-19
updated: 2026-08-19
---

# Data type: review

## Purpose

One cold-read round's verdict and findings. Produced by the `cold-read`
step of
[`../processes/stakeholder-presentation.md`](../processes/stakeholder-presentation.md);
consumed by its routing and revision steps and appended to the round log.
The judge output scored against
[`../fitness/decision-brief.fitness.md`](../fitness/decision-brief.fitness.md)
conforms to this same shape.

## Schema

```yaml
schema:
  type: object
  fields:
    verdict: {type: string, enum: [clean, tradeoffs-accepted, findings]}
    stumbles: {type: array, items: {type: string}}
    unintroduced_terms: {type: array, items: {type: string}}
    ask_decidability:
      type: array
      items: {type: string, enum: [confident, wobbly, cannot-decide]}
    top_changes: {type: array, items: {type: string}, maxItems: 3}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-19 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
