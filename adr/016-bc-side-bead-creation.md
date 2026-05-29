# ADR-016 — BC-side bead creation on inbox drain; cross-reference via shared work_id

**Status:** proposed (2026-05-29)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md)
(loose cross-shop visibility constraint: each shop's bd is sovereign; the
lead does NOT pull BC bd); [ADR-011](011-outbox-atomicity-bd-first.md) (shop-msg
+ bd atomicity protocol governs side-effect status transitions);
[ADR-012](012-bead-message-field-mapping.md) (lead bd schema for
emission projections — the symmetric lead-side picture this ADR mirrors on
the BC side); [ADR-015](015-nudge-message-type.md) (nudge handling on
BC side; informs the message-type → bead-type mapping).
**Related beads:** `lead-bp3` (lead-side consume-inbox CLI gap — moot under
bd-authoritative routing); implicit user feedback driving this ADR — **BC
sovereignty must be preserved; the lead's view = BC emissions, not BC
internals**.

## Context

PDR-010 commits the shopsystem to a loose cross-shop visibility model:
each shop's bd is sovereign, the lead does NOT pull BC bd, and the only
contract between shops is the shared `work_id` carried in `shop-msg`
emissions. The lead's bd tracks the lead's own desired state plus the
projection of BC emissions (per ADR-012); the BC's bd tracks the BC's
internal work tracking.

The contract leaves a coordination question open: when the lead dispatches
work `lead-X` to BC `shopsystem-foo` via `shop-msg send`, the BC's bd has
no row for `lead-X`. When and how does a BC-side bead come into existence
to track the inbound work, and what is its lifecycle relationship to
`shop-msg respond` emissions on the BC side?

The current implicit contract lives in BC role-template prose ("on drain,
the Implementer creates a bd issue for the work"). It is not pinned in an
ADR. The absence of a written ADR produces two failure modes:

1. **Drift across BC implementations.** Each BC's role-template copy can
   diverge in how the bead is created, what fields are populated, and
   what status transitions occur on `shop-msg respond`. Without an ADR
   anchoring the contract, BCs may end up with inconsistent internal
   tracking — making cross-BC reconciliation by lead architects harder
   than necessary.
2. **Erosion of BC sovereignty.** Without a written boundary, the
   temptation arises for the lead shop to "just peek at the BC's bd" to
   answer questions about BC-side progress. That re-creates the
   "read repos/\*" antipattern PDR-010 explicitly prevents: cross-shop
   visibility via filesystem rather than via the shop-msg contract.

The BC's internal bead lifecycle is a private matter. The lead must use
shop-msg emissions as the contract; the BC must have a deterministic
bead-creation step on drain so its own queue is reasonable to operate on.
This ADR pins both halves.

## Decision

1. **Drain-time bead creation.** On `shop-msg pending inbox --bc <name>`
   returning a row the BC has not yet acted on, the BC's session-start
   drain SHALL create a paired BC-side bead via `bd create` before
   dispatching the BC subagent that will service the message. The bead
   exists so the BC's own queue (`bd ready`, `bd list`, `bd show`)
   accurately reflects inbound work.

2. **Default field derivation.** The created bead's fields SHALL be
   derived from the inbox message payload as follows:
   - `title`: derived from the inbox message's payload subject or
     description, truncated as needed for bd's title constraints. If
     subject is absent, fall back to `"<message_type> from lead
     (<work_id>)"`.
   - `type`: derived from the message_type — `assign_scenarios` →
     `feature`; `request_bugfix` → `bug`; `request_maintenance` →
     `task`; `request_shop_card` → `task`; `request_scenario_register`
     → `task`; `nudge` → `task` (or skipped if the nudge's referenced
     work_id already has an open BC bead, per ADR-015);
     `mechanism_observation` is inbound-from-BC-to-lead and does not
     arrive in a BC inbox.
   - `priority`: copied from the lead's priority if carried in the
     message metadata; else default per BC convention.
   - `notes`: cross-reference the lead work_id as `Lead work_id:
     <lead-X>` so future operators on either side can correlate. This
     is the only required cross-reference; no further lead-side bd
     state is mirrored.

3. **ID-namespace + cross-reference convention.** The BC-side bead's ID
   SHALL be issued in the BC's local bd namespace (e.g.,
   `shopsystem-messaging-{nanoid}`). The cross-reference between shops
   is by lead's `work_id` (carried in the bead's `notes`), NOT by BC
   bd ID. The lead never learns the BC bead ID and never needs to.

4. **Status-transition contract on shop-msg respond.** Per ADR-011's
   atomicity protocol, `shop-msg respond` on the BC side SHALL update
   the BC bead's status as a side effect of the same transactional
   boundary as the outbound emission:
   - `clarify` → BC bead status set to `blocked`, with a note appended
     summarizing the question raised.
   - `work_done(complete)` → BC bead status set to `closed`.
   - `work_done(blocked)` → BC bead status set to `blocked`, with a
     note appended explaining the blocker.
   - `mechanism_observation` emitted from BC → status unchanged; a
     note appended recording the observation.

5. **Internal follow-up work is private by default.** The BC bead MAY
   carry follow-up work the BC files internally (e.g., "while
   implementing X, noticed Y; should refactor Z"). These follow-ups
   stay private to the BC unless the BC explicitly emits a
   `mechanism_observation` referencing them. The lead does NOT see
   them via any other channel.

6. **No cross-shop bd pull.** The lead SHALL NOT pull BC bd state by
   any mechanism — not dolt-pull, not direct DB read, not filesystem
   inspection of `.beads/`. If the lead wants to know about BC-side
   work, the BC MUST emit via `shop-msg`. The lead's view of the BC
   is exactly the set of messages the BC has emitted — period.

## Alternatives considered

**Option A — Lead dispatches the BC bead ID alongside the work_id.**
Rejected. This would couple shop namespaces: the lead would need to
know (or pre-allocate) a BC bd ID at dispatch time, which either
requires the lead to read BC bd (violating PDR-010 sovereignty) or
requires the BC to pre-register an ID before the dispatch (introducing
a round trip before any work). The shared `work_id` is already
sufficient cross-reference; adding a second identifier buys nothing and
costs the sovereignty boundary.

**Option B — BC opts out of bd entirely for inbox-drained work.**
Rejected. The BC's own work tracking is its own concern; not having a
bead for inbound work means the BC cannot reason about its own queue
(no `bd ready`, no `bd list` view of in-flight inbound work, no
`bd show` for context). The cost of skipping bd on the BC side is
borne by every BC operator. Inbound work being trackable in the same
mechanism as BC-internal work is the simpler, cheaper invariant.

## Consequences

- **BC primer update.** `bc-primer.md` in `shopsystem-templates` gains
  the bead-creation step in its drain procedure: after listing pending
  inbox rows, create a paired bead per the default-field-derivation rule
  before dispatching the implementer subagent. A follow-up bead tracks
  the canonical-template edit.
- **BC implementer / reviewer templates.** The status-transition rules
  in decision (4) embed into the BC implementer and reviewer templates:
  on every `shop-msg respond` invocation, the bd status transition is
  part of the same activity, not a separate step.
- **BC-side sweeper.** ADR-011's atomicity sweeper on the BC side
  handles partial states (bead created but no inbound message acted on,
  or message responded to but bead status not transitioned). The
  sweeper's BC-side rules inherit from this ADR's status-transition
  contract.
- **Cross-shop visibility stays loose.** The lead's role discipline does
  not change: lead-architect and lead-po never query BC bd; the lead's
  view of BC work continues to be exactly the BC's `shop-msg`
  emissions, projected into the lead's own bd per ADR-012.
- **Reconciliation surface.** A BC's failure to create a drain-time
  bead is privately observable to the BC but invisible to the lead
  (correctly — it's a BC-internal hygiene matter). The lead sees only
  whether the BC eventually emits `work_done`, `clarify`, or stays
  silent past a reasonable horizon; that visibility is unchanged by
  this ADR.
- **Onboarding new BCs.** A new BC adopting `shopsystem-templates`
  inherits this contract automatically via the BC primer and templates;
  no per-BC ADR is needed. The contract is canonical for the
  shopsystem as a whole.
