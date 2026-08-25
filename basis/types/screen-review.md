---
type: data-type
id: screen-review
defines: screen-review
owner: product-authority
status: draft
version: 2
created: 2026-08-25
updated: 2026-08-25
---

# Data type: screen-review

## Purpose

One screen round's verdict and findings against a named criteria set.
Produced by the `screen` step of
[`../processes/po-output-check.md`](../processes/po-output-check.md);
consumed by its routing, `revise`, and `decide` steps and appended to
the round log. Each finding names the criterion it fails — or
`uncovered`, for a defect no criterion names — carries the quoted text,
and states whether the screener could decide it (`confident`) or not
(`wobbly`) — a wobbly finding quotes the whole passage, since the PM
role decides from the review alone. `change` is the repair the screener
proposes for that finding; `top_changes` the three the screener would
make first. The `screen` step writes every field.

## Schema

```yaml
schema:
  type: object
  fields:
    verdict: {type: string, enum: [clean, findings]}
    findings:
      type: array
      items:
        type: object
        fields:
          criterion: {type: string}          # the criterion's name — "framing" is always one — or the literal "uncovered"
          quote: {type: string}
          change: {type: string}
          decidability: {type: string, enum: [confident, wobbly]}
    top_changes: {type: array, items: {type: string}, maxItems: 3}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-25 | update | Authored with the po-output-check process: the `review` type carries no per-finding criterion, quote, or decidability, which the check's routing and decision read. |
| 2 | 2026-08-25 | update | Screen repairs: the artifact is not opened by the decider; change and top_changes explained; writer stated. |
