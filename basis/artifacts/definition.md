---
type: artifact-typedef
id: definition-typedef
defines: definition
owner: product-authority
status: approved
approved: 2026-08-22
version: 2
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition]
---

# Artifact type: definition

## Identity and ancestry

- **Type:** `definition` — the generic root for documents that state what
  good looks like for something else: a process, a document type, a role,
  a term list, a rule set. Specializations (e.g. `process-definition`,
  `artifact-typedef`) declare it in their ancestry, so a validator that
  knows only `definition` can check any definition document against the
  two requirements below.
- **Produced by:** seed drafting, or governed evolution of an approved
  definition. **Consumed by:** every agent whose work the definition
  governs; compilers and validators that render or check against it.

## Required frontmatter

`type`, `id`, `status` (draft | approved | superseded), `owner` (the seat
that approves changes), `version` (integer, starting at 1; bumped on
every content update), `created`, `updated`; `approved` (date of the most recent approval) once approved — retained
through a later draft amendment to mark the last approved version.

## Required sections

1. An **opening** that states what the document defines before the
   first section heading.
2. A closing **checks section** (its heading contains "check") — every
   definition implies at least one check; a definition no check can cite
   does not govern anything.
3. A **Document History** section, the last section of the document: a
   table `| Version | Date | Kind | Entry |` where Kind is `update` (a
   content change; bumps the version), `review` (a review round and its
   verdict; cites the version reviewed), or `state` (a status change,
   e.g. draft → approved; cites the version it applies to). All
   change-log, review-log, and state-log content lives here — inline
   amendment notes and formal review-log frontmatter structures (e.g. a
   `verified-by` block) are ruled out. Generated renderings are exempt:
   their history is their source's.

## Commitment (Definition of Done)

A definition is done when the governed work can be performed and checked
from it alone. **Consequence on failure:** the definition — and any
activity that would depend on it — does not enter the system
(`define-good-up-front`).

## Sources

Deming's operational definitions (a definition others can work from:
test, criterion, decision); the `define-good-up-front` principle.

## Derived review checklist

- Frontmatter complete; owner named; version present. *(schema)*
- The opening states what the document defines. *(§Required sections 1)*
- At least one derived check exists and cites a clause. *(§Required sections 2)*
- Document History is the last section; no inline amendment notes or
  review-log frontmatter remain — mechanical. *(§Required sections 3)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer). |
| 1 | 2026-08-22 | state | draft → approved (R23). |
| 2 | 2026-08-23 | update | Version and Document History requirements added by authority direction; inline amendment notes and review-log frontmatter (verified-by) ruled out. |
