# ADR-017 — shop-msg owns bd integration; state changes via CLI, not agent

**Status:** proposed (2026-05-29)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md)
(bd authoritative for state, shop-msg authoritative for transmission — this ADR
pins where the integration between the two LIVES);
[ADR-011](011-outbox-atomicity-bd-first.md) (the bd-first / postgres-second /
bd-status-flip-third atomicity protocol every CLI-side bd write must follow);
[ADR-012](012-bead-message-field-mapping.md) (the lead bd schema this ADR's
side effects must populate consistently);
[ADR-016](016-bc-side-bead-creation.md) (BC-side bead-creation and
status-transition contract whose mechanism this ADR realizes).
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
that a `shop-msg respond` is paired with the BC-side bead update ADR-016
requires.

The current implicit pattern: agents run `shop-msg send` and `bd update
--status=in_progress` as two separate commands, sequenced by prose in the
relevant role primer. The same pattern holds on the BC side: agents are
instructed to `bd create` the paired bead on inbox drain (per ADR-016 as
originally drafted), then run `shop-msg respond` and `bd update --status=...`
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
**Second**: the recent `lead-cw7-reviewer-recovery` incident demonstrated that
BC role discipline under adversarial review is brittle precisely because
integration is convention; the BC sent a degraded test work_done and could
not amend, with the consume mechanism failing to release the lead-inbox slot.
The `lead-nn5f` fix landed that asymmetry in *code*, not in role-discipline
prose. ADR-017 generalizes the lesson: when an integration step is correctness-
critical and the agent has no structural backstop, the step belongs in the
mechanism, not the convention.

The decision this ADR pins: **integration logic lives in the shop-msg CLI**,
not in agent procedure. Every shop-msg CLI command that has a bd correlate
fires the bd write as a transactional side effect (per ADR-011 atomicity). The
agent's role on shop-msg events becomes substantive — verify hashes, decide
vehicles, reconcile work, close the work_id once verified — rather than
bookkeeping.

## Decision

1. **shop-msg owns bd integration.** All bd state changes correlated with
   shop-msg events SHALL happen as CLI-layer side effects of the shop-msg
   command itself, NOT as separate agent steps. The agent invokes one CLI
   command; the CLI performs both the messaging action and the paired bd
   update under ADR-011's atomicity protocol.

2. **Documented bd side effects per shop-msg command.** The following
   shop-msg commands have the documented bd side effects below; this list
   is exhaustive for the commands defined as of this ADR, and every future
   command addition MUST declare its bd side effects (or explicit lack
   thereof) as part of the addition (decision 6 below):
   - `shop-msg send --bc <name> --work-id <id> ...` (lead side): creates or
     updates the lead bd entry per ADR-012's field-mapping rules; transitions
     `dispatch_state` through `outbox_pending` → `dispatched` per ADR-011's
     3-step protocol.
   - `shop-msg pending inbox --bc <name>` (BC side): on FIRST observation of
     an unprocessed row, creates the paired BC-side bead per ADR-016's
     field-derivation rules; idempotent on subsequent observations of the
     same row (no duplicate bead created).
   - `shop-msg respond {clarify,work_done,mechanism_observation,nudge} ...`
     (BC side): updates the BC bead status per ADR-016's status-transition
     table (`clarify` → `blocked`; `work_done(complete)` → `closed`;
     `work_done(blocked)` → `blocked`; `mechanism_observation` → note
     appended, status unchanged); transactional with the outbound emission
     per ADR-011.
   - `shop-msg consume outbox --bc <name> --work-id <id>` (lead side):
     updates the lead bd entry's `dispatch_state` to `consumed`; transactional
     per ADR-011.
   - `shop-msg nudge ...` (either side): per ADR-015, appends a note to both
     the local-side bead and (via the emitted message) the remote-side bead;
     no status change on either bead.
   - `shop-msg sweep --shop <name>` (recovery): reconciles bd
     `outbox_pending` entries against postgres state per ADR-011's recovery
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

4. **Implementation surface — library coupling, not subprocess.** shop-msg
   SHALL import bd as a Python library (an in-process module call), NOT
   shell out to `bd` as a subprocess. The coupling is intentional and
   appropriate: both packages are shop-system-specific (by name and purpose),
   both live in this monorepo's BC topology, and both are versioned together
   under the shopsystem release cadence. The bd library surface used by
   shop-msg MUST be stable and documented; bd-side internal changes that
   break shop-msg's expectations are a versioning concern handled by the
   normal BC scenario-pinning process (out of scope for this ADR).

5. **Atomicity — ADR-011 governs every CLI-side bd write.** ADR-011's
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

**Option C — Sweeper-only.** Defer all bd updates to ADR-011's sweeper as
the steady-state path. Rejected: introduces latency between message events
and bd state; complicates strategic queries (`bd ready --stale-since` would
be perpetually inaccurate); makes the sweeper load-bearing for normal
operation rather than recovery, eroding the safety property the sweeper
exists to provide.

**Option D — Separate bd-shop-msg-sync daemon.** A third process listens on
postgres NOTIFY and writes bd. Rejected: adds a moving part to supervise;
introduces eventual consistency for no benefit; the in-process integration
in option chosen (decision 4) achieves the same coupling without a daemon.

## Consequences

- **shop-msg gains a bd library dependency.** Stated explicitly: shop-msg's
  package is shop-system-specific (by name and purpose), so the coupling is
  appropriate and not an architectural smell.
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
- **The sweeper (ADR-011) becomes recovery-only, not steady-state.** Its
  load is reduced to crash recovery; it stops being a backstop for missed
  agent steps because there are no missed agent steps to backstop.
- **ADR-016's bead-creation and status-transition contracts become
  mechanically enforced.** The ADR's prose contracts are now realized in
  code, not in agent diligence. A BC that misses a bead creation is no
  longer possible without a CLI bug.
- **Future shop-msg CLI additions must declare bd side effects.** This is
  decision 6 above; restated here as a consequence for the review/design
  process around shop-msg evolution.
