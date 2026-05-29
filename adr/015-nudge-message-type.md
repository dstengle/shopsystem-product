# ADR-015 — `nudge` message type for operational liveness

**Status:** accepted (2026-05-29)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md)
(operational-liveness primitives: the framework lacks lightweight signaling
for "I noticed something on your side; what's happening?"); [ADR-014](014-presence-heartbeat-via-shop-msg-watch.md)
(presence heartbeat detects offline; `nudge` is the operator-triggered response
to detected-online-but-stalled); [§4 spec catalog](../04-message-catalog.md)
(message catalog this ADR extends).
**Related beads:** `lead-ymct` (parallel-dispatch deadlock mechanism — a
nudge unblocks the deadlock without architectural deliberation);
`lead-7wp` (lost dispatches — `status-check` surfaces them);
`lead-ji28` (cross-BC sequencing held in agent memory — `predecessor-landed`
moves the sequencing record onto the wire).

## Context

The existing message catalog —
`assign_scenarios` / `request_bugfix` / `request_maintenance` /
`clarify` / `work_done` / `mechanism_observation` — leaves a gap between
two adjacent primitives:

- **`clarify` is too heavy.** It carries architectural-decision semantics
  per ADR-009/010: a structured question, a resolution dispatch on a fresh
  lead bead, scope rules on the resolving `work_done`. Using `clarify` for
  "are you still alive?" or "did you receive the dispatch?" muddies the
  channel and burns deliberation cycles on what is operationally a ping.
- **`mechanism_observation` is too informational.** It records a
  cross-cutting framework observation; it is not actionable, does not
  expect a reply, and does not surface a stall.

Three observed failure classes sit in this gap:

- **Failure mode A — BC stalled mid-pipeline.** The BC has accepted a
  dispatch but is wedged (Implementer waiting on environment, Reviewer
  un-dispatched, queue silently drained). The lead has no primitive for
  "what phase are you in?" short of authoring a clarify.
- **Failure mode B — BC offline.** ADR-014's presence heartbeat detects
  this. Once detected, the operator needs a triggered primitive to
  resume the conversation when the BC returns — a nudge with reason
  `status-check` is that primitive.
- **Failure mode C — cross-BC sequencing held in agent memory.** A
  queued dispatch waits for an implicit predecessor (e.g., a sibling BC
  must land changes on origin/main first per ADR-013). Today the lead
  carries the sequencing in agent memory and re-dispatches when ready.
  A `predecessor-landed` nudge moves the sequencing record onto the
  wire.

The current workaround in all three cases is the carrier pattern: the
lead files a fresh bead and re-dispatches against it. The workaround
requires the lead to *know* the BC is stalled — there is no inbound
primitive a stalled BC can use to say "I'm waiting on you" without
escalating to a full clarify.

Tonight's user feedback framed the design impulse:
> "the system gets hung up sometimes and a 'nudge' can get the system moving again."

## Decision

A new message type `nudge` is added to the catalog. Specifically:

1. **Message type registration.** `nudge` MUST be registered in
   shopsystem-messaging's catalog alongside the six existing types. It
   carries a `reason` enum (below), an optional free-form `note`, and an
   optional `work_id` reference; it does NOT carry `scenario_hashes`.

2. **Reason taxonomy.** The `reason` field MUST be one of:
   - `stuck-on-you` — sender is waiting on the receiver. Optional
     `--note` describes what is expected. Typical direction: BC→lead.
   - `status-check` — sender asks for current pipeline phase. Receiver
     MUST reply with a `nudge` carrying its current phase (e.g.,
     `implementer-in-progress`, `reviewer-pending`, `blocked-on-X`) in
     the `note` field. Typical direction: lead→BC.
   - `predecessor-landed` — lead→BC; notifies that a previously-pending
     dependency is now reachable on origin/main; the BC may proceed with
     a queued dispatch (per ADR-013).
   - `general` — catchall. `--note` is REQUIRED when reason is `general`.

3. **CLI surface.** The BC-side invocation MUST be
   `shop-msg nudge --bc <name> [--work-id <id>] --reason <reason> [--note "<text>"]`.
   The lead-side equivalent MUST be
   `shop-msg send nudge --bc <name> [--work-id <id>] --reason <reason> [--note "<text>"]`,
   matching the existing `shop-msg send <type>` family for outbound lead
   traffic.

4. **Bidirectional semantics.** Either lead OR BC MAY originate a
   `nudge`. The direction is not constrained by `reason`, but the
   typical pairings above SHOULD be honored in role-template prose to
   keep the operational vocabulary consistent.

5. **Standing rules on receipt.**
   - BC receives `status-check` → BC MUST reply with a single `nudge`
     carrying its current phase. Cap: one reply per inbound nudge — the
     receiver MUST NOT chain replies.
   - Lead receives `stuck-on-you` → the router MUST dispatch
     `lead-architect` for investigation. The resolution lands as a
     dispatch on a fresh lead bead, not as a return nudge.
   - Lead receives `predecessor-landed` → reserved as a return path; the
     typical direction is lead→BC, so a lead-inbound `predecessor-landed`
     is treated as informational and routed to `lead-architect` for
     review.
   - Lead receives content that is informational rather than operational
     (e.g., a finding about framework mechanics) framed as a nudge → the
     router MUST reject the framing and ask the sender to reframe as
     `mechanism_observation`. The nudge channel is operational only.

6. **Non-blocking auxiliary semantics.** A `nudge` is NOT subject to
   ADR-009/010 clarify-resolution rules. A nudge MUST NOT block the
   original dispatch's lifecycle, MUST NOT extend or modify the
   originating bead's open/closed state, and MUST NOT count as a
   `work_done` precondition. Nudges are auxiliary signaling on top of
   the existing dispatch lifecycle.

7. **No `scenario_hashes`.** A `nudge` payload MUST NOT carry a
   `scenario_hashes` field. Nudges are transmission-layer pings, not
   scenario state. A nudge that references a `work_id` references the
   dispatch lifecycle by ID only; it makes no claim about scenario
   coverage.

## Alternatives considered

**Option A — Extend `clarify` with a `nudge` sub-reason.** Rejected.
`clarify` carries architectural-decision semantics: ADR-009 governs its
resolution vehicle, ADR-010 governs the resolving `work_done`'s scope,
and the BC's clarify-default posture (per the BC Implementer template)
treats clarify reception as a deliberation trigger. Adding a sub-reason
that opts out of all three contracts dilutes both the operational
primitive (which becomes weighed down by clarify's machinery) and the
architectural primitive (which loses its deliberation contract). The
two semantics deserve distinct catalog entries.

**Option B — Add a heartbeat-response field to `mechanism_observation`.**
Rejected. `mechanism_observation` is informational by construction: no
reply expected, no actionability, no lifecycle. Bolting an
"actionable-please-reply" mode onto it inverts its semantics and forces
every receiver to inspect the payload to decide whether the message
expects engagement. A distinct type is cheaper.

**Option C — Skip the new message type and rely on out-of-band signaling
(direct git push, Slack ping, side-channel notification).** Rejected.
The framework's contract is that all inter-shop coordination flows
through `shop-msg`; introducing out-of-band signaling for the stalled
case carves a hole in the contract precisely where observability matters
most. The catalog should grow to cover the gap, not route around it.

## Consequences

- **shopsystem-messaging** registers `nudge` in its message catalog
  alongside the six existing types and ships the
  `shop-msg nudge` / `shop-msg send nudge` CLI surfaces. The new type's
  payload schema (reason enum, optional note, optional work_id, no
  scenario_hashes) is the additive schema delta.
- **Role templates carried by shopsystem-templates** learn the standing
  rules:
  - `lead-po.md` / `lead-architect.md` — the lead-architect dispatch
    rule for inbound `stuck-on-you`, plus the lead-side surface for
    originating `status-check` and `predecessor-landed`.
  - `bc-implementer.md` — the BC-side status-check reply rule (cap one
    reply, current phase in `note`), plus the BC's ability to originate
    `stuck-on-you` when blocked on the lead.
- **Router prose** (the lead shop's `lead-primer.md`) gains a standing
  rule for nudge events from `shop-msg watch`: `<work_id> nudge` events
  route per the standing rules above.
- **BC primer prose** (the BC shop's `bc-primer.md`) gains a parallel
  standing rule on the BC side for inbound lead-originated nudges.
- **Bead state is unaffected by exchanged nudges.** A nudge does not
  open, close, or modify the state of any bead. The dispatch lifecycle
  (assign / bugfix / maintenance → work_done) remains the sole driver of
  bead state per §6 of the spec.
- **PDR-010** moves toward closure once the messaging-side registration,
  CLI surface, and template-side standing rules land. ADR-014's
  presence heartbeat and ADR-015's operator-triggered nudge are
  complementary: ADR-014 detects offline; ADR-015 is the operator's
  primitive for resuming the conversation.

Implementation of nudge storage uses `direction='nudge'` (distinct from
`inbox`/`outbox`); the keying preserves the single-row-per-(bc,work_id,direction,message_type)
invariant for dispatch traffic while allowing multiple nudges to coexist.
The bd-facade gains `append_note(work_id, text)` wrapping `bd note`; the
canonical nudge note format is
`nudge: reason=<reason> work_id=<work_id> at=<iso8601_utc>`. The
status-check reply standing rule is primer-prose (templates-BC scope),
not CLI-enforced. Channel-misuse classification is operator discipline,
not pinned by scenario. (Per lead-1w7r clarify-resolution; ADR-015
remains `accepted` — the Consequences amendment does not require a
status flip, analogous to ADR-013's lead-p0ez amendment.)
