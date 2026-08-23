---
type: artifact-typedef
id: data-type-typedef
defines: data-type
owner: product-authority
status: approved
approved: 2026-08-22
version: 1
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition, data-type]
---

# Artifact type: data-type

## Identity and ancestry

- **Type:** `data-type` — a named, schema-defined structure that passes
  between process steps but is not a human-readable document (e.g. a
  review verdict, a verification record). Registered so process `data`
  blocks reference it by `$ref` and never define it inline.
- **Produced by:** the author of the first process that needs the
  structure. **Consumed by:** every process that references it; the
  compiler's resolver; validators; judges whose output must conform.

## Required frontmatter

`type: data-type`, `id`, `defines` (the name `$ref` resolves), `owner`,
`status`, `created`, `updated`.

## Required sections

1. **Purpose** — one short paragraph: what the structure carries, which
   step produces it, which steps consume it, with links.
2. **Schema** — one `yaml` block in the registry's compact dialect:
   JSON Schema type names; `fields` maps field names to types (the
   `properties` equivalent); every field is required unless it carries
   `optional: true`; enum value lists are closed (exhaustive); `$ref`
   allowed for nesting.

## Commitment (Definition of Done)

A data type is done when a validator can check an instance from the
schema block alone. **Consequence on failure:** `$ref`s to it fail the
compile, so no process that needs it compiles.

## Sources

JSON Schema (type vocabulary and constraints); the `use-defined-terms`
principle (field names are defined terms).

## Derived review checklist

- `defines` matches the id processes reference. *(schema)*
- Producer and consumers named and linked. *(§Required sections 1)*
- Every field typed; enums closed. *(§Required sections 2)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-22 | state | draft → approved. |
