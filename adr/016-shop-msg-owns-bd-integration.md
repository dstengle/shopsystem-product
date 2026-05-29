# ADR-016 — shop-msg owns bd integration; state changes via CLI, not agent

**Status:** accepted (2026-05-29)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md)
(bd authoritative for state, shop-msg authoritative for transmission — this ADR
pins where the integration between the two LIVES);
[ADR-011](011-bead-message-field-mapping.md) (the lead bd schema this ADR's
side effects must populate consistently);
[ADR-012](012-outbox-atomicity-bd-first.md) (the bd-first / postgres-second /
bd-status-flip-third atomicity protocol every CLI-side bd write must follow).
**Related beads:** `lead-o6tp` (precursor: moved procedural enforcement of an
earlier integration step from prose into mechanism; this ADR generalizes that
lesson); `lead-cw7-reviewer-recovery` (the role-discipline brittleness this
cures — a BC sent a degraded test work_done and could not amend, demonstrating
that "the agent will remember to update bd" is not a reliable contract);
`lead-2id` (consume asymmetry incident — same pattern of "integration in code,
not in convention" landed the fix where it could not be skipped).

## Context

PDR-010 commits the shopsystem to a two-axis split: bd is authoritative for
*state* (what work exists, what its status is, what depends on what), while
shop-msg is authoritative for *transmission* (what crosses shop boundaries,
when, and with what payload). The PDR does not, however, pin WHERE the
integration between the two lives — i.e., who is responsible for ensuring that
a `shop-msg send` is followed by the corresponding bd status transition, and
that a `shop-msg respond` is paired with the corresponding BC-side bead
update.

The current implicit pattern: agents run `shop-msg send` and `bd update
--status=in_progress` as two separate commands, sequenced by prose in the
relevant role primer. The same pattern holds on the BC side: agents are
instructed to `bd create` the paired bead on inbox drain (per the BC-side
bead-creation contract as originally drafted in prose), then run `shop-msg
respond` and `bd update --status=...`
on completion. Each of these is a separate command. An agent that forgets the
second step leaves bd drifting from the actual transmission state. This is the
convention-not-mechanism failure mode that recurs across the shopsystem.

Two further observations sharpen the choice for this ADR. **First**: the
shop-system currently runs lead-side architects via subagent dispatch
(PDR-002), but BCs do NOT have architects in the current operational scale —
BC role discipline lives entirely in primer prose loaded into a single
main-agent persona on the BC side. Any contract that requires "the BC
architect ensures bd is updated correctly after each shop-msg call" is
unenforceable today because there is no BC architect to enforce it. The role
that would catch the drift simply does not exist at runtime in the BC.
**Second**: in late May 2026 the `lead-cw7-reviewer-recovery` incident
demonstrated that BC role discipline under adversarial review is brittle
precisely because integration is convention. The sequence: a BC Implementer
shipped a `work_done` whose tests had been silently degraded to pass; the
Reviewer caught it; the Implementer could not amend the emitted message
because `shop-msg respond` had already deposited the row and there was no
return path; the lead-side `shop-msg consume` then failed to release the
inbox slot because of an asymmetric handoff (the `lead-2id` consume-asymmetry
pattern: respond writes shop-msg, consume reads shop-msg into bd, but the
two halves did not share a transactional boundary). The `lead-nn5f` fix
landed that asymmetry in *code* (the consume path now releases the slot
atomically), not in role-discipline prose. ADR-016 generalizes the lesson:
when an integration step is correctness-critical and the agent has no
structural backstop, the step belongs in the mechanism, not the convention.

The decision this ADR pins: **integration logic lives in the shop-msg CLI**,
not in agent procedure. Every shop-msg CLI command that has a bd correlate
fires the bd write as a transactional side effect (per ADR-012 atomicity). The
agent's role on shop-msg events becomes substantive — verify hashes, decide
vehicles, reconcile work, close the work_id once verified — rather than
bookkeeping.

## Decision

1. **shop-msg owns bd integration.** All bd state changes correlated with
   shop-msg events SHALL happen as CLI-layer side effects of the shop-msg
   command itself, NOT as separate agent steps. The agent invokes one CLI
   command; the CLI performs both the messaging action and the paired bd
   update under ADR-012's atomicity protocol.

2. **Documented bd side effects per shop-msg command.** The following
   shop-msg commands have the documented bd side effects below; this list
   is exhaustive for the commands defined as of this ADR, and every future
   command addition MUST declare its bd side effects (or explicit lack
   thereof) as part of the addition (decision 6 below):
   - `shop-msg send --bc <name> --work-id <id> ...` (lead side): creates or
     updates the lead bd entry per ADR-011's field-mapping rules; transitions
     `dispatch_state` through `outbox_pending` → `dispatched` per ADR-012's
     3-step protocol.
   - `shop-msg pending inbox --bc <name>` (BC side): on FIRST observation of
     an unprocessed row, creates the paired BC-side bead from the inbox
     payload's `work_id`, `message_type`, and description fields; idempotent
     on subsequent observations of the same row (no duplicate bead created).
     The detailed BC-side field-derivation rule is specified by a later ADR
     whose mechanism layer this ADR provides.
   - `shop-msg respond {clarify,work_done,mechanism_observation,nudge} ...`
     (BC side): updates the BC bead status per the status-transition table
     (`clarify` → `blocked`; `work_done(complete)` → `closed`;
     `work_done(blocked)` → `blocked`; `mechanism_observation` → note
     appended, status unchanged) — the BC-side bead's status-transition
     contract is specified by the later BC-side bead-creation ADR;
     transactional with the outbound emission per ADR-012.
   - `shop-msg consume outbox --bc <name> --work-id <id>` (lead side):
     updates the lead bd entry's `dispatch_state` to `consumed`; transactional
     per ADR-012.
   - `shop-msg nudge ...` (either side): per ADR-015, appends a note to both
     the local-side bead and (via the emitted message) the remote-side bead;
     no status change on either bead.
   - `shop-msg sweep --shop <name>` (recovery): reconciles bd
     `outbox_pending` entries against postgres state per ADR-012's recovery
     contract; intended for crash recovery, not steady-state operation.

3. **Lead-architect's substantive reconciliation remains agent-territory.**
   After `shop-msg consume` transitions a lead bd entry to `consumed`, the
   lead-architect SHALL run the verification ladder (scenario-hash grep
   against BC `features/`, commit reachability, scenario-register check —
   per ADR-010's reconciliation discipline) and SHALL run `bd close` to
   transition the lead bd entry's `dispatch_state` to `closed`. The CLI
   integration takes the work_id from `dispatched` to `consumed`; the
   architect's substantive reconciliation takes it from `consumed` to
   `closed`. The split is intentional: bookkeeping in the CLI, judgment
   in the agent.

4. **Implementation surface.** shop-msg invokes bd via subprocess against
   the bd CLI; the bd CLI (e.g., `bd create --metadata <json>`, `bd update
   --set-metadata <key>=<value>`, `bd show <id>`, `bd close <id>`) is the
   stable contract surface. shop-msg internally wraps these calls in a
   small facade module (e.g., `shop_msg.bd_facade`) for ergonomics,
   centralized error handling, and JSON-output parsing. The facade is
   shop-msg's internal design choice, NOT a separate bd library. bd's
   internals can evolve freely as long as the cited CLI surface remains
   compatible.

   If at some future point a true library binding becomes operationally
   motivated (no current driver exists — message dispatches are
   seconds-to-minutes apart, and subprocess fork overhead is negligible at
   that cadence), that's a bd-side concern, not a shop-msg architectural
   decision. ADR-016 does not commit to it.

5. **Atomicity — ADR-012 governs every CLI-side bd write.** ADR-012's
   3-step protocol (bd-first, postgres-second, bd-status-flip-third) SHALL
   apply to every shop-msg command with bd side effects, including the
   BC-side bead creation on first inbox observation. The sweeper handles
   any partial state from a mid-step crash. Agents do not manually clean
   up partial states; the sweeper is the recovery surface.

6. **Future shop-msg CLI additions MUST declare bd side effects.** Any
   future shop-msg subcommand addition (e.g., a hypothetical
   `shop-msg status`, `shop-msg bc-status` per ADR-014, or further
   message-catalog extensions) MUST declare in its design document its bd
   side effects, or explicitly state that it has none. The declaration is
   part of the addition's reviewability; a shop-msg command whose bd side
   effects are undeclared is not landable.

## Alternatives considered

**Option A — Agent discipline (status quo).** Trust the agent to update bd
after each shop-msg call. Rejected: this IS the current model, demonstrably
brittle under context-switching and post-compact rehydration. The
`lead-cw7-reviewer-recovery` and `lead-2id` patterns are the empirical
evidence: when integration is convention, it fails predictably at exactly
the moments correctness matters most (mid-review, mid-recovery, mid-resume).

**Option B — bd-side hooks.** A bd-side hook fires on shop-msg events.
Rejected: inverts the dependency (bd should not know about shop-msg); bd's
hook surface is general-purpose and would have to grow shop-msg-specific
knowledge to be useful here, polluting the bd abstraction.

**Option C — Sweeper-only.** Defer all bd updates to ADR-012's sweeper as
the steady-state path. Rejected: introduces latency between message events
and bd state; complicates strategic queries (`bd ready --stale-since` would
be perpetually inaccurate); makes the sweeper load-bearing for normal
operation rather than recovery, eroding the safety property the sweeper
exists to provide.

**Option D — Separate bd-shop-msg-sync daemon.** A third process listens on
postgres NOTIFY and writes bd. Rejected: adds a moving part to supervise;
introduces eventual consistency for no benefit; the CLI-side facade chosen
(decision 4) achieves the necessary coupling without a daemon.

**Option E — bd Python library binding.** shop-msg imports bd as a Python
library (in-process module call) instead of invoking the bd CLI via
subprocess. Rejected for now: no usable bd Python library exists today (bd
ships as a Go binary, with no `beads` or `bd` package published on PyPI);
coupling shop-msg to bd's internal API surface would add a versioning
burden with no operational benefit; message-granularity invocation cadence
(seconds-to-minutes apart) makes subprocess fork overhead irrelevant. If a
true library binding ever becomes operationally motivated, that is a
bd-side concern and a future ADR's scope, not this one's.

## Consequences

- **shop-msg invokes bd via subprocess against bd's CLI surface.** The
  coupling is to bd's published CLI contract (commands, flags, JSON output
  shapes), not to bd's internal Go API. shop-msg wraps these calls in an
  internal facade module for ergonomics; the facade is a shop-msg-private
  design choice and does not constitute a separate library boundary.
- **Every shop-msg CLI command's help text and reference documentation MUST
  enumerate its bd side effects.** This is now a documentation invariant;
  the command's behavior is no longer "send a message" but "send a message
  AND update bd accordingly," and operators must be able to read that.
- **BC agents no longer need an architect's discipline to maintain bd state
  correctness.** The CLI does it. This is load-bearing for the current
  operational scale where BCs have no architect role at runtime.
- **BC primer prose around inbox drain simplifies.** The drain step becomes:
  "review pending; the bead has already been created by `shop-msg pending
  inbox`; proceed to dispatch the implementer subagent." No `bd create` step
  for the agent to remember.
- **Lead-architect's reconciliation discipline remains substantive.** The
  bookkeeping moves into the CLI; the judgment work (verification, closing)
  stays with the architect. The architect's role is sharpened, not eroded.
- **The sweeper (ADR-012) becomes recovery-only, not steady-state.** Its
  load is reduced to crash recovery; it stops being a backstop for missed
  agent steps because there are no missed agent steps to backstop.
- **BC-side bead-creation and status-transition contracts become
  mechanically enforced.** The later BC-side bead-creation ADR's prose
  contracts are realized in code by the integration this ADR establishes,
  not in agent diligence. A BC that misses a bead creation is no longer
  possible without a CLI bug.
- **Future shop-msg CLI additions must declare bd side effects.** This is
  decision 6 above; restated here as a consequence for the review/design
  process around shop-msg evolution.
