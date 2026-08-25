---
type: data-type
id: check-decision
defines: check-decision
owner: product-authority
status: draft
version: 3
created: 2026-08-25
updated: 2026-08-25
---

# Data type: check-decision

## Purpose

The PM role's decision on a piece of the PO role's output, taken from
a screen verdict. Produced by the `decide` step of
[`../processes/po-output-check.md`](../processes/po-output-check.md);
consumed by its `record` step and written into the
checked artifact's Document History. `pass` accepts the output against
the framing; `fail` names the criterion the output missed;
`definition-change` says the criteria themselves were insufficient and
names the gap to file. The `decide` step writes every field; that
`criterion` accompanies `fail` and `gap` accompanies
`definition-change` is a judged check on the decision, not a schema
constraint.

## Schema

```yaml
schema:
  type: object
  fields:
    verdict: {type: string, enum: [pass, fail, definition-change]}
    criterion: {type: string, optional: true}   # required when verdict is fail: the criterion missed, by name
    gap: {type: string, optional: true}         # required when verdict is definition-change: the definition and what it lacks
    reasons: {type: string}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-25 | update | Authored with the po-output-check process by owner decision: the PM role decides from a screen verdict, never from reading every artifact. |
| 1 | 2026-08-25 | review | Screened with the process: the conditional fields are judged, not mechanical; a line-broken token. |
| 2 | 2026-08-25 | update | Writer and the judged nature of the conditional fields stated; token repaired. |
| 3 | 2026-08-25 | update | Consumer corrected: the record step only. |
