---
type: data-type
id: delivery
defines: delivery
status: experiment
created: 2026-08-19
updated: 2026-08-19
---

# Data type: delivery

The record that a presentation reached its reader. Produced by the
`deliver` step of
[`../processes/stakeholder-presentation.md`](../processes/stakeholder-presentation.md);
it is the process instance's terminal output.

```yaml
schema:
  type: object
  fields:
    delivered: {type: boolean}
    open_findings_stated: {type: boolean}
```
