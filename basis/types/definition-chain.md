---
type: data-type
id: definition-chain
defines: definition-chain
owner: product-authority
status: draft
created: 2026-08-20
updated: 2026-08-20
---

# Data type: definition-chain

The complete definition of good for one artifact type: the six linked
definitions that must exist before any instance of the type is authored
or rewritten. Produced by the `build-chain` step of
[`../processes/definition-chain-migration.md`](../processes/definition-chain-migration.md);
consumed by its review, ratification, and rewrite steps.

```yaml
schema:
  type: object
  fields:
    artifact_type: {type: string}
    typedef: {type: string}
    guideline: {type: string}
    fitness: {type: string}
    process: {type: string}
    roles: {type: array, items: {type: string}}
    skill: {type: string}
    status: {type: string, enum: [draft, ratified, parked]}
```

Each link field holds the id of the definition document filling that
link; the skill is the compiled rendering of the process link, never
hand-written.
