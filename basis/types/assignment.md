---
type: data-type
id: assignment
defines: assignment
owner: product-authority
status: draft
version: 1
created: 2026-08-28
updated: 2026-08-28
---

# Data type: assignment

## Purpose

The solutions architect role's assignment of a checked feature's
scenarios: for each Bounded Context tagged, the vehicle chosen from
that context's pre-state and the scenario tags it receives. Produced by
the `assign` step of
[`../processes/scenario-assignment.md`](../processes/scenario-assignment.md);
consumed by its `dispatch` and `record` steps. The `assign` step writes
every field.

## Schema

```yaml
schema:
  type: object
  fields:
    entries:
      type: array
      items:
        type: object
        fields:
          context: {type: string}                 # the Bounded Context's name, as tagged
          vehicle: {type: string, enum: [assign_scenarios, request_bugfix, request_maintenance]}   # the message type the pre-state selects (the frozen corpus's three)
          scenario_hashes: {type: array, items: {type: string}}   # the @hash: values of the scenarios this context receives — a scenario's identity, as the registers hold it
          pre_state: {type: string}               # what was read: the contracts and register consulted
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-28 | update | Authored with the scenario-assignment process so the vehicle is chosen per context from the pre-state and carried as data, not fixed in a command. The three vehicles are the frozen corpus's message types, imported by name. |
