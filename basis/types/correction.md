---
type: data-type
id: correction
defines: correction
owner: product-authority
status: approved
approved: 2026-08-22
version: 1
created: 2026-08-21
updated: 2026-08-21
---

# Data type: correction

## Purpose

One durable correction met during a session: a rule, preference, or mode
change that must outlive the session. It records where the correction
went — the definition it amends and the filed work item — so the session
record can point without carrying. Produced and checked by the `collect`
step of
[`../processes/session-handoff.md`](../processes/session-handoff.md).

## Schema

```yaml
schema:
  type: object
  fields:
    target: {type: string}
    bead: {type: string}
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-21 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-22 | state | draft → approved. |
