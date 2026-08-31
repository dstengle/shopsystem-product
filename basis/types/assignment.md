---
type: data-type
id: assignment
defines: assignment
owner: product-authority
status: draft
version: 2
created: 2026-08-28
updated: 2026-08-31
---

# Data type: assignment

## Purpose

The solutions architect role's assignment of a checked feature's
scenarios: for each Bounded Context tagged, the scenario tags it
receives and the pre-state read — the context's contracts and the
feature repository. Every entry dispatches as `assign_scenarios`;
bugfix and maintenance requests are the result of operational
activities, not of assignment. Produced by
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
          scenario_hashes: {type: array, items: {type: string}}   # the @hash: values of the scenarios this context receives — a scenario's identity, as the feature repository holds it
          pre_state: {type: string}               # what was read: the contracts and feature repository consulted
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-28 | update | Authored with the scenario-assignment process so the vehicle is chosen per context from the pre-state and carried as data, not fixed in a command. The three vehicles are the frozen corpus's message types, imported by name. |
| 2 | 2026-08-31 | update | Owner direction: the vehicle field removed — assignment dispatches assign_scenarios only; bugfix and maintenance requests are the result of operational activities, not of assignment; pre-state is the contracts and the feature repository. |
