---
type: review-record
id: review-new-basis
status: open
conversation-type: review
work-item: lead-kmrd4
created: 2026-08-10
updated: 2026-08-22
---

# Review record: the new-basis experiment

## Material

- [`basis/`](../README.md) on `experiment/new-basis` — the experiment
  index is the walkthrough and the approval surface.
- The amended [principle set](../principles.md) and the draft seed
  typedefs, processes, and types the index lists.

## Rulings

R1–R18 predate this record type and are recorded in the
[experiment index](../README.md) — grandfathered there, linked here as
the ledger's opening span. From R19 the ledger lives in this record.

- **R19 (2026-08-22).** Conversations get definitions: the
  process-definition typedef gains the run lifecycle (running / held /
  done / cancelled; `hold-after` auto-parks inactive runs with a resume
  point) and sub-process steps (a conversation invoked from a parent
  process is a branched conversation, `branched-from` on its anchor);
  [`review-record`](../artifacts/review-record.md) is the anchor type;
  [`review-conversation`](../processes/review-conversation.md) defines
  the conversation this review has been all along; this record is the
  first instance. Applied: this file, both definitions, glossary terms
  (run, hold, checkpoint, branched conversation), compiler sub-process
  rendering.

## State

Open. Next ready action: the authority reviews the conversation-model
package (run lifecycle, review-record, review-conversation, this record)
alongside the standing approval surface — the amended nine-principle
set, the seed typedefs, the migration and handoff processes — and the
frozen-memories ruling remains outstanding.
