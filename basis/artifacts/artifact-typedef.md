---
type: artifact-typedef
id: artifact-typedef-typedef
defines: artifact-typedef
owner: product-authority
status: approved
approved: 2026-08-22
version: 3
created: 2026-08-19
updated: 2026-09-05
ancestry: [definition, artifact-typedef]
---

# Artifact type: artifact-typedef

## Identity and ancestry

- **Type:** `artifact-typedef` — the single source that defines a
  document type: its identity, ancestry, required frontmatter, required
  sections, and commitment. Templates, schema fragments, and validators
  are its renderings; the typedef is the only hand-edited form. For a
  type whose guideline and fitness set are produced, the typedef also
  carries the type's writing rules and its fitness scenarios (the
  Writing rules and Fitness scenarios sections below), and that type's
  guideline and fitness set are renderings of the typedef too: produced
  from those two sections by `basis/tools/compile_typedef.py`, written
  at the paths the checks read (`basis/guidelines/<type>.md`,
  `basis/fitness/<type>.fitness.md`), kept current by the
  typedef-rendering process (`basis/processes/typedef-rendering.md`,
  pending), and never edited by hand — a change to the type's rules or
  tests is an edit to the typedef with a Document History row, and the
  two texts are produced again from it.
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
6. **Writing rules** — required for a type whose guideline is produced;
   otherwise absent. The guideline's content in the guideline's own
   form (quality-guideline typedef §Required sections): the voice
   principle, the Highlights block, the layers and precedence, then a
   `### Rules` heading with the rules numbered, each with its
   before/after pair, test, criterion, decision, and derived check.
   The compiler copies the section verbatim into the guideline, with
   its third-level headings raised one level.
7. **Fitness scenarios** — required for a type whose fitness set is
   produced; otherwise absent. The fitness set's content in the
   fitness set's own form (fitness-set typedef §Required sections):
   the intro naming the check that reads it and a `**Judged by:**`
   line naming the judging role, then a `### Scenarios` heading with
   the Given/When/Then scenarios and a `### Compile mapping` heading
   with the table taking each Then into one judge-rubric assertion.
   The compiler copies the section verbatim into the fitness set, with
   its third-level headings raised one level.
8. **Derived review checklist** — every entry cites the clause it
   projects (cite-or-delete). It stays in the typedef; it is not
   produced from the two sections above.

## Rules

- A **section** is a markdown heading. Required sections appear as
  headings in the listed order; intro prose and additional sections may
  sit between them without breaking the order.
- **No pinned example links.** Examples are found, not pinned: the
  validator lists currently-conforming instances on demand; a pinned
  example drifts as the collection changes.
- Schemas of existing types evolve and new types are added through the
  owner's approval — the registry is open and versioned, never fixed.
- A type has either both of the Writing rules and Fitness scenarios
  sections or neither. With them, the type's guideline and fitness set
  are produced from the typedef and carry `generated: true`,
  `generated-by`, `source` (the typedef's path), and `source-digest`
  (sha256 of the typedef's text, first twelve hex digits); a text
  whose digest or content differs from a fresh production is not
  current and is produced again, never edited to match. Without them,
  the guideline and fitness set are hand-written as before.

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
- Every checklist entry cites a clause. *(§Required sections 8)*
- Writing rules and Fitness scenarios both present or both absent; when
  present, each in the form its produced text's typedef requires.
  *(§Required sections 6–7, §Rules)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-09-05 | update | Under init-typedef-rendering / feat-typedef-rendering (the architect's constraint C5; the design decision adr-2026-09-05-typedef-rendering): two sections admitted, Writing rules and Fitness scenarios, required for a type whose guideline and fitness set are produced, each in the form the produced text's own typedef requires; for such a type the guideline and fitness set are renderings of the typedef, produced by basis/tools/compile_typedef.py and kept current by the typedef-rendering process (pending, cited by path), marked generated with source and source-digest, never edited by hand; the derived review checklist stays in the typedef; the required-sections list renumbered (the checklist is now 8) and its self-citation updated. Made by the lead-solutions-architect role. |
