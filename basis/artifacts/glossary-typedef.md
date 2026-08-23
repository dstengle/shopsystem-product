---
type: artifact-typedef
id: glossary-typedef
defines: glossary
owner: product-authority
status: approved
approved: 2026-08-22
version: 2
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition, glossary]
---

# Artifact type: glossary

## Identity and ancestry

- **Type:** `glossary` — the hand-curated half of the defined-term list;
  the other half is every schema element name. Together they are the
  restricted language the `use-defined-terms` principle mandates.
- **Produced by:** seed drafting; grown one decision or one definition at a
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
- Definitions ≤2 lines; banned near-synonyms named where decisions created
  them. *(§Required sections 2)*
- Sampled terms from approved documents resolve — judged spot-check plus
  mechanical lint. *(Commitment)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
