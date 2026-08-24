---
type: artifact-typedef
id: research-index-typedef
defines: research-index
owner: product-authority
status: draft
version: 3
created: 2026-08-23
updated: 2026-08-23
ancestry: [research-index]
---

# Artifact type: research-index

## Identity and ancestry

- **Type:** `research-index` — the single register of research
  reports: for each, its question, date, status, and where its body
  lives. The index is the one research record the live system
  carries; report bodies never leave the `research` branch.
- **Produced by:** the deliver step of the research-inquiry process
  ([`../processes/research-inquiry.md`](../processes/research-inquiry.md)),
  which adds or updates one row per delivered report. **Consumed by:**
  any seat that needs to know what has been researched before asking
  again; the researcher role checking for prior work in `frame`.

## Required frontmatter

`type: research-index`, `id`, `owner`, `status`, `version`, `created`,
`updated`.

## Rules

- Exactly one instance exists, on the `rebaseline` branch at
  `research/index.md`; every other appearance is a pointer to it
  (single source of truth). `main` carries nothing.
- A row carries a report's id, question (verbatim), date, status
  (draft | delivered), and location as `<branch>:<path>`; the body is
  never copied into the index.
- A report without a row is undelivered; a row without a reachable
  body is a defect.
- The index loads only inside a research activity — a step that
  declares it as an input. It is never named in the primer or any
  other ambient context: research is ephemeral and activity-scoped,
  and loading its register into every session violates least-context.

## Required sections

1. **Reports** — the table, one row per report, newest first.
2. **Reading a report** — the one command that opens a body from the
   live system (`git show <branch>:<path>`).

## Commitment (Definition of Done)

The index is done when every delivered report has a row whose location
resolves. **Consequence on failure:** the missing report is not citable
from the live system until its row exists.

## Sources

Registry practice: a catalogue record per item with a locator,
separate from the item (library catalogue / document-register
convention); the shop's single-source-of-truth and least-context
principles (bodies stay off the live tree; the index is the load).

## Derived review checklist

- One instance, on `rebaseline`. *(§Rules)*
- Every row's location resolves via `git show`. *(§Rules; Commitment)*
- Every delivered research report has a row. *(Commitment)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored by owner direction: the research pointer moves out of README prose into a typed register. |
| 2 | 2026-08-23 | update | Owner direction: the index is activity-scoped context only — never loaded by the primer or any ambient context. |
| 3 | 2026-08-23 | update | Owner direction: the research index instance lives on `rebaseline` at `research/index.md`, not on `main`. |
