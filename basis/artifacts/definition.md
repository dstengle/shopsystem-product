---
type: artifact-typedef
id: definition-typedef
defines: definition
owner: product-authority
status: draft
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition]
---

# Artifact type: definition

## Identity and ancestry

- **Type:** `definition` — the generic root for documents that state what
  good looks like for something else: a process, a document type, a role,
  a term list, a rule set. Specializations (e.g. `process-definition`,
  `artifact-typedef`) declare it in their ancestry so a validator that
  knows only `definition` can still check them at this level.
- **Produced by:** seed drafting, or governed evolution of a ratified
  definition. **Consumed by:** every agent whose work the definition
  governs; compilers and validators that render or check against it.

## Required frontmatter

`type`, `id`, `status` (draft | ratified | superseded), `owner` (the seat
that ratifies changes), `created`, `updated`; `ratified` (date) once
status is ratified.

## Required sections

1. **What it defines** — named early, not implied.
2. **Derived checks** — every definition implies at least one check; a
   definition no check can cite does not govern anything.

## Commitment (Definition of Done)

A definition is done when the governed work can be performed and checked
from it alone. **Consequence on failure:** the definition — and any
activity that would depend on it — does not enter the system
(`define-good-up-front`).

## Sources

Deming's operational definitions (a definition others can work from:
test, criterion, decision); the `define-good-up-front` principle.

## Derived review checklist

- Frontmatter complete; owner named. *(schema)*
- What it defines is stated in the opening. *(§Required sections 1)*
- At least one derived check exists and cites a clause. *(§Required sections 2)*
