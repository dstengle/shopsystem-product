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

- **R20 (2026-08-22).** The conversation-model package is approved:
  [`review-record`](../artifacts/review-record.md) and
  [`review-conversation`](../processes/review-conversation.md) carry
  `approved: 2026-08-22`; the run-lifecycle and sub-process amendments
  ride the process-definition typedef's own pending approval. Directed
  and applied: the remaining two conversation types —
  [`discovery-conversation`](../processes/discovery-conversation.md)
  (interlocutor dialogue; closes onto a session record by invoking
  session-handoff as the first sub-process step; nothing operationalized
  before the authority converges) and
  [`work-conversation`](../processes/work-conversation.md) (scoped to
  one work item; every exchange lands as a comment on it; closing the
  conversation does not close the item). Both draft, compiled, linted.

- **R21 (2026-08-22).** The discovery and work conversation types are
  approved:
  [`discovery-conversation`](../processes/discovery-conversation.md) and
  [`work-conversation`](../processes/work-conversation.md) carry
  `approved: 2026-08-22`. All three conversation types now stand
  approved; every conversation in the lead shop has a defined type,
  anchor, and end.

- **R22 (2026-08-22).** The memory action table is approved as amended
  and executed: 55 retire, 11 route-to-chain, 1 to backlog. Amendments:
  the archive lives on the branch `archive/memory-2026-08`, never on
  `main` (context-poisoning risk); the sc06 scenario body rides in
  backlog work item lead-df2pj, not the archive. Executed: archive
  branch pushed (verbatim, all 67), six chain-input work items filed,
  bulk forget completed — `bd memories` returns zero. The memory channel
  is closed; conversation anchors own cross-session state.

- **R23 (2026-08-22).** The remaining approval surface is approved: the
  nine-principle working set (`approved: 2026-08-22` — the prompt
  rendering regenerated with it), all nine seed typedefs, the
  definition-chain-migration and session-handoff processes, and the
  three supporting data types. Nothing on the branch remains in draft.
  The seed layer stands; migration is unblocked behind the migration
  plan's regeneration.

## State

Open — **checkpoint 2026-08-22** (transcript boundary; not a close).

Resume point: the authority rules on the migration plan
(`drafts/migration-plan.md` on `main`, rev 2, cold-read verified).
Ask 1: approve the action table and run order as a block. Ask 2: three
authority calls — adr-033 (recommend retire), adr-046 (recommend
retire), the system-BOM bundle (recommend retire + one backlog item
carrying the intent). Silence on a call carries it into the
decision-chain review; nothing retires by silence. On approval, Phase 1
begins with run 1: the architecture principle set through
`definition-chain-migration`, the authority at its review steps.

For the resuming session: the basis worktree is at
`/home/vscode/basis-experiment` (branch `experiment/new-basis`); the
ledger above plus README rulings R1–R18 are the review's full history;
the memory channel is closed (R22) — state lives only in governed
records; standing session protocol is in the shop primer.
