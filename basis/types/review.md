---
type: data-type
id: review
defines: review
owner: product-authority
status: ratified
ratified: 2026-08-19
created: 2026-08-19
updated: 2026-08-19
---

# Data type: review

One cold-read round's verdict and findings. Produced by the `cold-read`
step of
[`../processes/stakeholder-presentation.md`](../processes/stakeholder-presentation.md);
consumed by its routing and revision steps and appended to the round log.
The judge output scored against
[`../fitness/decision-brief.fitness.md`](../fitness/decision-brief.fitness.md)
conforms to this same shape.

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
