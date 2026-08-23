---
type: artifact-typedef
id: request-typedef
defines: request
owner: product-authority
status: approved
approved: 2026-08-19
version: 1
created: 2026-08-19
updated: 2026-08-19
ancestry: [request]
---

# Artifact type: request

## Identity and ancestry

- **Type:** `request` — the generic root for documents that ask a reader
  to act or decide. Specializations (e.g. `decision-brief`) declare it in
  their ancestry so a validator that knows only `request` can still check
  them at this level.
- **Produced by:** any process whose output asks for action or decision.
  **Consumed by:** the named reader.

## Required frontmatter

`type`, `status`, `date`, `reader`.

## Required sections

1. **What is requested** — named early, not implied.
2. **From whom** — the reader, named.

## Sources

ISO/IEC/IEEE 15289 (generic content types); DITA-style ancestry (this is
the root type specializations declare).

## Commitment (Definition of Done)

A request is done when the named reader can tell what is being asked of
them from the document alone. **Consequence on failure:** the request
returns to the author; no obligation attaches to the reader.

## Derived review checklist

- The opening names what is requested. *(§Required sections 1)*
- The reader is named. *(§Required sections 2)*
- Frontmatter carries `type`, `status`, `date`, `reader`. *(§Required frontmatter)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-19 | state | draft → approved. |
