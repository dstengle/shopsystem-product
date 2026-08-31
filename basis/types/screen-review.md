---
type: data-type
id: screen-review
defines: screen-review
owner: product-authority
status: approved
approved: 2026-08-26
version: 5
created: 2026-08-25
updated: 2026-08-31
---

# Data type: screen-review

## Purpose

One screen round's verdict and findings against a named criteria set.
Produced by the `screen` step of
[`../processes/po-output-check.md`](../processes/po-output-check.md),
of
[`../processes/interaction-conformance-check.md`](../processes/interaction-conformance-check.md),
and of
[`../processes/initiative-check.md`](../processes/initiative-check.md);
consumed by their decision steps and, in the PO output check and the
initiative check, by routing and revision steps and the round log. Each finding names the criterion it fails — or
`uncovered`, for a defect no criterion names — carries the quoted text,
and states whether the screener could decide it (`confident`) or not
(`wobbly`) — a wobbly finding quotes the whole passage, since the deciding
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
          criterion: {type: string}          # the criterion's name (in the PO check "framing" is always one), or the literal "uncovered"; a criterion the corpus cannot decide keeps its name and says "record absent:", "record empty:", or "entry is a hypothesis:" in change
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
| 2 | 2026-08-26 | state | draft → approved by the owner. |
| 3 | 2026-08-26 | update | Second producer named (interaction-conformance-check); the record-absent form defined in the criterion comment. |
| 4 | 2026-08-31 | update | Third producer named (initiative-check), with batch A+B; the producer list stays exhaustive. |
| 5 | 2026-08-31 | update | Round-3 screen: the consumption clause extended to the initiative check's routing, revision, and round log. |
