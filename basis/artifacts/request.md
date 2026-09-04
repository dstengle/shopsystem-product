---
type: artifact-typedef
id: request-typedef
defines: request
owner: product-authority
status: approved
approved: 2026-08-19
version: 3
created: 2026-08-19
updated: 2026-09-04
ancestry: [request]
---

# Artifact type: request

## Identity and ancestry

- **Type:** `request` — the generic root for documents that ask a reader
  to act or decide. Specializations (e.g. `decision-brief`) declare it in
  their ancestry so a validator that knows only `request` can still check
  them at this level.
- **Two producing paths, one type.** A request is either *emitted* — a
  document the shop writes to ask its reader for action or decision —
  or *received*: the durable record of an ask, one expression of
  intent an originator brought the lead shop, made on arrival and
  routed from that record. Both ask a named reader to act or decide;
  the received ask asks the lead-pm role for a route. The received
  path is the front-end record the shop keeps for every ask, per
  [adr-2026-09-04-request-front-end](../../decisions/adr-2026-09-04-request-front-end.md).
- **Produced by:** any process whose output asks for action or decision
  (the emitted path); the
  [request-intake](../processes/request-intake.md) process (pending,
  authored alongside this amendment) for a received ask — recording is
  any lead-shop role's act on meeting the ask, inside that process or
  while running another. **Consumed by:** the named reader; for a
  received ask, the lead-pm role (the reader, which routes), the
  [discovery conversation](../processes/discovery-conversation.md)
  (as its input when the route leads there), the `small-change`
  process (pending; the small-change lane) when the route leads there,
  and the originator, who reads the route and its reason from it.
- **Where instances live:** a received ask's request lives in
  `requests/` at the repository root, id `req-YYYY-MM-DD-<slug>` —
  the date the ask arrived, then a short slug of what was asked.

## Required frontmatter

`type`, `status`, `date`, `reader` — the root set every request
carries. For a received ask, `date` is the date the ask arrived and
`reader` is `lead-pm`; the field set is closed over the root set plus
the following:

- `id` — `req-YYYY-MM-DD-<slug>`.
- `version` — integer, starting at 1; bumped on every content update.
- `owner` — `lead-pm`.
- `created`, `updated`.
- `originator` — who expressed the intent, by role or by name.
- `received-through` — the contract the ask entered through, in the
  form the initiative's Framing uses. On this branch:
  `operational-contract`, with the note that the lead shop's
  operational contract has no artifact yet (lead-4kymc, the work item
  for the missing artifact); the request is the record at entry until
  that artifact lands and names it.
- `arose-in` — optional: the process run or conversation the ask
  arose in, by its id, when it did not arrive at the door directly.
- `route` — `awaiting` | `discovery` | `small-change` | `declined`.
- `route-reason` — one line: why this route.
- `routed-to` — a link to where the route led: an initiative, a
  change definition, or a decline's decision record; empty while the
  route is `awaiting`.
- `work-item` — optional: the register item opened for the routed
  ask. The item points at the request by id; the request may name the
  item, and never depends on it.

Status values and their writers, for a received ask:

- `recorded` — any lead-shop role, on meeting the ask; `route` is
  `awaiting`. The same record whichever role meets the ask and
  whoever fills that role; a role that meets an ask does not hold it
  for the lead-pm role to record.
- `routed` — the lead-pm role, at the request-intake process's route
  step: `route` set with its reason, said to the originator before
  any action on it. A later change of route — a change found not
  simple sent to discovery — is the lead-pm role's, recorded with its
  reason the same way, the status unchanged.
- `declined` — the lead-pm role, only with the product authority's
  ruling; the record survives as readable.
- `done` — the small-change process's record step, when the verified
  result is recorded; or the discovery conversation's frame step, when
  the initiative it frames references the request.

A specialization's status set is its own (`decision-brief`: draft |
delivered | decided); the root requires only that `status` be present.

## Required sections

1. **What is requested** — named early, not implied. For a received
   ask: the originator's words verbatim, quoted and dated — nothing
   paraphrased; where the ask arose in a run or a conversation, the
   words it arose in.
2. **From whom** — the reader, named. For a received ask: the reader
   (the lead-pm role) and the originator.

For a received ask, two more:

3. **Route** — the route said, its reason, and the originator's
   answer: accepted, objected — with the route standing after the
   objection and the reason that answers it — or not yet answered. A
   route is acted on only after it was said; a route not yet answered
   is recorded as said, with no action taken on it.
4. **Result** — where the route led. For a simple change: the change's
   definition (written by the lead-po role, referencing this request),
   the check's verdict recorded by a role other than the maker, and
   the verified result — the effect demonstrated in the running
   system. For a discovery: the initiative made, by id. For a decline:
   the authority's ruling and its reason, in words the originator can
   act on. Empty while the route is `awaiting`.

## Rules

- The ask's words have one home: this request. Every other appearance
  — the list of requests awaiting a route, a discovery conversation's
  anchor, an initiative's Framing, a change's definition, a work item
  — references the request by its id or is rendered from it; a
  quotation carries the reference.
- A work-register item, a session record, or a transcript is not the
  record of an ask. An ask that exists only in one of these is not
  recorded.
- A decline is recorded only with the product authority's ruling; a
  declined request is not removed.
- The request states the contract the ask entered through
  (`received-through`); a trace — a Framing, a change's definition, a
  verified result — that dead-ends before a request is a recording
  defect.
- The route reaches a Bounded Context shop only as scenario assignment
  sends work; no request travels to a shop as itself.

## Sources

ISO/IEC/IEEE 15289 (generic content types); DITA-style ancestry (this is
the root type specializations declare). For the received path: the
service-request record of ITIL request management — a record per
request with a status and a routed fulfilment — and the architecture
principle set's `intent-provenance` (record intent at the contract it
entered before working on it).

## Commitment (Definition of Done)

An emitted request is done when the named reader can tell what is
being asked of them from the document alone. A received ask's request
is done when its route has led to a recorded result — the verified
result of a simple change, or the initiative made from it — or to a
surviving decline. **Consequence on failure:** an emitted request
returns to the author, and no obligation attaches to the reader; a
received ask's request stays `recorded` or `routed`, visible as
awaiting its route or its result, and no work counts as done for it.

## Derived review checklist

- The opening names what is requested; for a received ask, the
  originator's words verbatim, quoted and dated. *(§Required sections 1)*
- The reader is named; for a received ask, the lead-pm role and the
  originator. *(§Required sections 2)*
- Frontmatter carries `type`, `status`, `date`, `reader`; for a
  received ask, the closed received set, `route` one of its four
  values, `routed-to` filled once the route is not `awaiting`.
  *(§Required frontmatter)*
- Status written by the role and step the list names; `declined` only
  with the authority's ruling. *(§Required frontmatter; §Rules)*
- Route said before acted on; an objection answered in the standing
  route's reason; an unanswered route recorded as said. *(§Required
  sections 3)*
- Result carries, for a simple change, the definition, a checker other
  than the maker, and the demonstrated effect; for a decline, the
  ruling and reason. *(§Required sections 4)*
- The ask's words appear elsewhere only by reference or rendering;
  `received-through` states the contract. *(§Rules)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-19 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-09-04 | update | The received-ask path added, under init-request-routing / feat-request-routing (constraint C1: the existing root amended, no new type) on the authority's standing direction of 2026-09-04, per adr-2026-09-04-request-front-end §2–3: a received ask's request is the durable record of an ask, made on arrival by any lead-shop role and routed by the lead-pm role. Added: the second producing path with the request-intake process named as pending (authored alongside); instances in `requests/`, id `req-YYYY-MM-DD-<slug>`; the received field set (`id`, `version`, `owner`, `created`, `updated`, `originator`, `received-through`, `arose-in`, `route`, `route-reason`, `routed-to`, `work-item`) closed over the root set; status values `recorded`, `routed`, `declined`, `done` with their writers; sections 3 Route and 4 Result; Rules (one home for the ask's words, no record in a register item or transcript, decline only with the authority, the contract stated, `intent-provenance`'s exception carried through lead-4kymc); Sources and Commitment extended; the checklist re-derived. The emitted path — the root sense `decision-brief` declares — stands unchanged. |
