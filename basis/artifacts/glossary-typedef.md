---
type: artifact-typedef
id: glossary-typedef
defines: glossary
owner: product-authority
status: draft
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition, glossary]
---

# Artifact type: glossary

## Identity and ancestry

- **Type:** `glossary` — the hand-curated half of the defined-term list;
  the other half is every schema element name. Together they are the
  restricted language the `use-defined-terms` principle mandates.
- **Produced by:** seed drafting; grown one ruling or one definition at a
  time. **Consumed by:** every writer before coining a term; reviewers
  and the undefined-term/near-synonym checks.

## Required frontmatter

`type: glossary`, `id`, `owner`, `status`, `created`, `updated`.

## Required sections

1. **How the list combines** — one short paragraph stating that the
   defined-term list is this document plus every schema element name.
2. **Terms** — one bullet per term: the term in bold, then a one-or-two
   line definition. A definition may name a banned near-synonym
   ("Not 'kind'") so the losing term stays findable by the lint.

## Commitment (Definition of Done)

A glossary is done when every important term used in approved documents
resolves here or to a schema element. **Consequence on failure:** the
undefined term is a defect the author repairs by defining or replacing
it.

## Sources

Controlled-vocabulary practice (ISO 704 terminology work; ASD-STE100
restricted language); the `use-defined-terms` principle.

## Derived review checklist

- Combination rule stated. *(§Required sections 1)*
- Definitions ≤2 lines; banned near-synonyms named where rulings created
  them. *(§Required sections 2)*
- Sampled terms from approved documents resolve — judged spot-check plus
  mechanical lint. *(Commitment)*
