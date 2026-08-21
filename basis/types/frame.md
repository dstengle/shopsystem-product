---
type: data-type
id: frame
defines: frame
owner: product-authority
status: approved
approved: 2026-08-19
created: 2026-08-19
updated: 2026-08-19
---

# Data type: frame

The framing of a presentation: who reads it, what they must decide, which
asks gate the next unit of work. Produced by the `frame` step of
[`../processes/stakeholder-presentation.md`](../processes/stakeholder-presentation.md);
consumed by `compose`.

```yaml
schema:
  type: object
  fields:
    reader: {type: string}
    decisions: {type: array, items: {type: string}}
    asks: {type: array, items: {type: string}}
    deferrals: {type: array, items: {type: string}}
```
