---
type: artifact-typedef
id: artifact-typedef-typedef
defines: artifact-typedef
owner: product-authority
status: draft
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition, artifact-typedef]
---

# Artifact type: artifact-typedef

## Identity and ancestry

- **Type:** `artifact-typedef` — the single source that defines a
  document type: its identity, ancestry, required frontmatter, required
  sections, and commitment. Templates, schema fragments, and validators
  are its renderings; the typedef is the only hand-edited form.
- **This document conforms to itself.** The definition regress terminates
  here: the product authority approves this typedef and the principle set
  by hand; everything else is checked against a typedef.
- **Produced by:** seed drafting or a governed registry amendment.
  **Consumed by:** authors (via the rendered template), validators (via
  the rendered schema), reviewers (via the derived checklist).

## Required frontmatter

`type: artifact-typedef`, `id`, `defines` (the type name instances carry
in their `type` field), `owner`, `status`, `created`, `updated`,
`ancestry` (from the generic root to the type this document defines).
Every instance also carries the identity base `definition` requires
(`owner`, `status`, `approved` when applicable); a type's field set is
closed over that base plus its own list.

## Required sections

1. **Identity and ancestry** — what the type is; who produces and
   consumes instances.
2. **Required frontmatter** — the instance field set, closed unless
   stated open.
3. **Required sections** — the instance body structure.
4. **Commitment (Definition of Done)** — when an instance is done, with a
   stated consequence on failure.
5. **Sources** — the established forms the type composes; format
   provenance lives here, not in instances and not in an index.
6. **Derived review checklist** — every entry cites the clause it
   projects (cite-or-delete).

## Rules

- A **section** is a markdown heading. Required sections appear as
  headings in the listed order; intro prose and additional sections may
  sit between them without breaking the order.
- **No pinned example links.** Examples are found, not pinned: the
  validator lists currently-conforming instances on demand; a pinned
  example drifts as the collection changes.
- Schemas of existing types evolve and new types are added through the
  owner's approval — the registry is open and versioned, never fixed.

## Commitment (Definition of Done)

An artifact-typedef is done when a validator can check any instance from
it alone and an author can write a conforming instance from its rendered
template alone. **Consequence on failure:** instances of the type cannot
be validated, so none are deliverable.

## Sources

ISO/IEC/IEEE 15289 (generic content types); DITA specialization and
ancestry declaration; Scrum's artifact-commitment pairing; the live
system's typedef lineage (PDR-032 sole ownership, ADR-059 generated
drift-gated renderings).

## Derived review checklist

- `defines` matches the `type` field its instances carry. *(schema)*
- Every required section present, in order. *(§Required sections)*
- Commitment states a consequence. *(§Required sections 4)*
- Sources present; no pinned example links anywhere. *(§Sources, §Rules)*
- Every checklist entry cites a clause. *(§Required sections 6)*
