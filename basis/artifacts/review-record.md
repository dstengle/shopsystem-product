---
type: artifact-typedef
id: review-record-typedef
defines: review-record
owner: product-authority
status: approved
approved: 2026-08-22
version: 2
created: 2026-08-22
updated: 2026-08-23
ancestry: [review-record]
---

# Artifact type: review-record

## Identity and ancestry

- **Type:** `review-record` — the anchor of a review conversation: what
  is under review, the outcomes applied, and the conversation's state.
  It is what makes a review bounded — the conversation begins when the
  record opens, ends when the authority closes or cancels it, and
  survives transcript boundaries because the record, not the transcript,
  carries the state. The record holds no decision ledger: a decision is
  applied as changes to the affected artifacts, and those artifacts'
  Document History is the durable trace.
- **Produced by:** the `open` step of
  [`../processes/review-conversation.md`](../processes/review-conversation.md).
  **Consumed by:** the apply step; the router resuming a held run (the
  State section names the resume point); anyone auditing a change reads
  the changed artifact's Document History, not this record.

## Required frontmatter

`type: review-record`, `id`, `status` (open | held | closed | cancelled),
`conversation-type: review`, `work-item` (the run's anchor in the
registry), `created`, `updated`; `branched-from` (the parent run) when
the conversation is a sub-process of another run; `closed` (date) once
closed or cancelled.

## Required sections

1. **Material** — what is under review, as links.
2. **Outcomes** — while the conversation runs, each decision as the
   change it produced: what changed, where (links to the amended
   artifacts, whose Document History carries the entry). No decision
   numbering, no standing ledger — a record entry that outlives its
   application is a defect.
3. **State** — while open or held: the next ready action, stated so a
   fresh reader can resume the conversation. On close or cancel: the
   outcome — what the review approved, rejected, or abandoned.

## Commitment (Definition of Done)

A review record is done (closed) when every outcome links to the
artifacts that carry its changes and the State section states the
overall result. A closed record is history: nothing in the live system
may cite it as authority — the changed definitions are the authority.
**Consequence on failure:** the conversation is not closed — it is open
or held, and the work item stays open with it.

## Sources

The session-record shape (shopsystem-knowledge) for the anchor pattern;
document-control practice: a change is traced in the changed document's
revision history, not in a parallel decision log.

## Derived review checklist

- Frontmatter status matches the work item's state. *(§Required frontmatter)*
- Every outcome links to the artifacts carrying its changes. *(§Required sections 2)*
- State names a resume point or an outcome — never empty. *(§Required sections 3)*
- No live document cites this record as authority — mechanical (the
  reference lint). *(§Commitment)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-22 | update | Authored (seed layer). |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Ledger removed by owner direction: decisions live as changes in the affected artifacts' Document History; the Rulings section becomes Outcomes; closed records are history no live document may cite. |
