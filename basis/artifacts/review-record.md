---
type: artifact-typedef
id: review-record-typedef
defines: review-record
owner: product-authority
status: approved
approved: 2026-08-22
version: 1
created: 2026-08-22
updated: 2026-08-22
ancestry: [review-record]
---

# Artifact type: review-record

## Identity and ancestry

- **Type:** `review-record` — the anchor of a review conversation: what
  is under review, the rulings issued, and the conversation's state. It
  is what makes a review bounded — the conversation begins when the
  record opens, ends when the authority closes or cancels it, and
  survives transcript boundaries because the record, not the transcript,
  carries the state.
- **Produced by:** the `open` step of
  [`../processes/review-conversation.md`](../processes/review-conversation.md).
  **Consumed by:** the apply step (the ledger it appends to); the router
  resuming a held run (the State section names the resume point); anyone
  auditing which ruling authorized a change.

## Required frontmatter

`type: review-record`, `id`, `status` (open | held | closed | cancelled),
`conversation-type: review`, `work-item` (the run's anchor in the
registry), `created`, `updated`; `branched-from` (the parent run) when
the conversation is a sub-process of another run; `closed` (date) once
closed or cancelled.

## Required sections

1. **Material** — what is under review, as links.
2. **Rulings** — the numbered ledger: Rn, date, the ruling in one or two
   sentences, and a link to where it was applied. Rulings are appended,
   never rewritten; a reversed ruling gets a new entry citing the old.
3. **State** — while open or held: the next ready action, stated so a
   fresh reader can resume the conversation. On close or cancel: the
   outcome — what the review approved, rejected, or abandoned.

## Commitment (Definition of Done)

A review record is done (closed) when every ruling in the ledger links
to its application and the State section states the outcome.
**Consequence on failure:** the conversation is not closed — it is open
or held, and the work item stays open with it.

## Sources

The session-record shape (shopsystem-knowledge) for the anchor pattern;
decision-log practice (an append-only ledger of dated decisions); this
experiment's R-ledger, which ran R1–R18 inside an index and proved the
shape before this type existed.

## Derived review checklist

- Frontmatter status matches the work item's state. *(§Required frontmatter)*
- Every ruling links to its application. *(§Required sections 2)*
- State names a resume point or an outcome — never empty. *(§Required sections 3)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-22 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-22 | state | draft → approved. |
