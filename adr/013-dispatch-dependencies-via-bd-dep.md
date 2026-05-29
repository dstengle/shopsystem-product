# ADR-013 — Dispatch dependencies via `bd dep add` honored by `shop-msg send`

**Status:** proposed (2026-05-29)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md) (bd is
authoritative state-of-record for dispatch lifecycle); [ADR-011](011-outbox-atomicity-bd-first.md)
(atomicity protocol enables the queued-mode write); [ADR-012](012-bead-message-field-mapping.md)
(field mapping carries the dependency marker).
**Related beads:** [[lead-ji28]] (the empirical incident — messaging-side
re-dispatch was held in agent memory after the scenarios-side leg landed,
and the held dispatch was lost across `/compact` until the user manually
flagged it); [[lead-ymct]] (parallel-dispatch deadlock mechanism; the
lead-ji28 case is the third recorded instance of the same class);
[[lead-pfmb]] / [[lead-xscs]] (carrier-pattern beads whose role recedes
once `depends-on` is first-class in the dispatch path).

## Context

PDR-010 names the lead as the implicit cross-BC coordinator: when BC1's
dispatch depends on BC2's work landing first, the sequencing lives in
the lead. Today that sequencing lives only in the routing agent's
working memory between turns. The failure mode (failure mode C in
PDR-010's taxonomy) is mechanical: when context evaporates — `/compact`,
session boundary, an unrelated subagent dispatch that consumes the
intervening turn — the deferred dispatch never fires. There is no
queryable, on-disk record that BC1 is waiting on BC2.

**Empirical record (2026-05-28 / 2026-05-29, lead-ji28 fanout):**

- The lead authored two dispatches as a coordinated fanout from
  `lead-ji28`: an `assign_scenarios` to `shopsystem-scenarios` (carrying
  the canonical ScenarioPayload schema change) and a `request_bugfix` to
  `shopsystem-messaging` (carrying the wire-form alignment that depends
  on the scenarios-side schema change landing).
- Both were dispatched simultaneously. `shopsystem-messaging` correctly
  refused its leg with a `clarify` citing the lead-018 invariant: it
  cannot adopt a wire form whose canonical payload schema has not yet
  shipped.
- The lead Architect recognized the dependency, deferred the messaging
  re-dispatch until the scenarios leg's `work_done` landed, and held the
  deferral in agent context as "messaging is queued behind scenarios".
- The scenarios leg's `work_done` did land. The lead reconciled it, but
  the held messaging re-dispatch was not promoted; the deferral state
  was lost across an intervening `/compact`.
- The user manually flagged the held dispatch on a later turn. The
  messaging re-dispatch then fired and landed cleanly. The exact failure
  mode this ADR cures is the gap between "scenarios closed" and "user
  manually flagged it" — a gap that, in the worst case, is unbounded.

bd already carries the primitive needed to externalize this sequencing:
`bd dep add <dependent> <depends-on>` records a queryable depends-on
edge between two lead beads. Combining ADR-011 (atomicity protocol) and
ADR-012 (field mapping), the dispatch path can consult that graph
before depositing the postgres row, and the reconciliation path can
promote queued dispatches when a predecessor closes.

## Decision

1. `shop-msg send` SHALL consult `bd show <work_id>` (or equivalent bd
   introspection) for any `depends-on` edges before depositing the
   postgres row. The introspection is a discrete pre-deposit step
   alongside the existing payload-schema validation.

2. If the work_id has one or more `depends-on` edges and any predecessor
   bead is not in `dispatch_state=closed` (per ADR-012's field mapping),
   `shop-msg send` MUST NOT silently proceed. It SHALL choose one of two
   modes:

   - **Strict mode (default):** refuse the send with a non-zero exit
     code and a clear error citing the unmet dependency (predecessor
     work_id, predecessor's current `dispatch_state`). No postgres row
     is written.
   - **Queued mode (`--queue-on-dependency`):** write a bd-side entry
     with `dispatch_state=outbox_pending` and a
     `pending_dependency=<predecessor_work_id>` marker (per ADR-012's
     field-mapping shape). NO postgres row is written at this time. The
     CLI exits zero with a clear message that the dispatch is queued.

3. The deposit refusal contract (strict mode) is total: a refused
   `shop-msg send` MUST leave no partial state — no postgres row, no
   bd-side `dispatch_state` mutation, no outbox artifact. The refusal is
   recoverable by either (a) waiting for the predecessor to close and
   re-running, or (b) re-running with `--queue-on-dependency`.

4. The queued-mode write protocol piggybacks ADR-011's atomicity
   protocol: the bd-side `outbox_pending` write and the
   `pending_dependency` marker are a single atomic unit. A queued
   dispatch is observable via `bd show` and via a new
   `shop-msg pending queued --lead <name>` listing (the listing
   surface is a follow-up bead; the underlying bd state is queryable
   today).

5. Closure of a bead — whether via explicit `bd close <id>` or via
   reconciliation-side mutation of `dispatch_state` to `closed` — MUST
   trigger a promote scan. The scan enumerates all beads with
   `pending_dependency=<closing_work_id>` and, for each such queued
   dispatch whose remaining `depends-on` edges are all `closed`, deposits
   the postgres row and transitions the bd-side `dispatch_state` from
   `outbox_pending` to `outbox_live` (per ADR-012's lifecycle).

6. The promote action MUST be idempotent. Repeated promote scans on the
   same closing bead leave the same final state: each queued dispatch
   either becomes live (exactly once) or remains queued (if other
   predecessors are still open). A queued dispatch already promoted to
   live is a no-op for subsequent scans.

7. Cross-BC dependencies are first-class. `lead-X` (dispatched to BC A)
   MAY depend on `lead-Y` (dispatched to BC B); both beads live in lead
   bd, the edge lives in lead bd, and both legs of the fanout are
   visible to `shop-msg send` and to the promote scan. No BC-side
   coordination is required; the lead remains the sole holder of the
   cross-BC sequence.

8. The dependency graph SHALL be acyclic. `bd dep add` already enforces
   this on the bd side; `shop-msg send` does not need to re-check. A
   detected cycle (should bd ever permit one) is a bd-side bug, not a
   dispatch-side error path.

## Alternatives considered

**Option A — Pure-prose role discipline ("be careful, always honor your
mental queue across sessions").** Rejected, demonstrably brittle. The
lead-ji28 incident is the empirical refutation: the lead Architect
correctly identified the dependency, correctly deferred the dispatch,
and lost the deferral anyway because the medium (agent working memory)
does not survive `/compact`. The lead-ymct catalog records two prior
instances of the same class. A discipline that fails for predictable
mechanical reasons is not a control; it's a wish.

**Option B — Add a parallel `shop-msg`-only dependency table (postgres-
native, not bd-backed).** Rejected. PDR-010 names bd as authoritative
for dispatch state of record; splitting dependency edges into a separate
postgres table reintroduces the dual-write problem PDR-010 was written
to eliminate. The `dispatch_state` field (ADR-012) and the `bd dep add`
edge are already in the same store; keeping the dependency graph there
preserves the single-source-of-truth principle.

**Option C — Make queued mode the default (no strict refusal).**
Rejected for this turn. Strict mode surfaces the unmet dependency
loudly, which is the right default when the dispatch path is new and
the failure modes of silent queueing are not yet observed in
production. Queued mode is opt-in via an explicit flag; if operational
experience shows the flag is set on substantially every coordinated
fanout, a future ADR can flip the default.

## Consequences

- `shop-msg send` grows the bd-introspection step. The implementation
  must handle the bd-unreachable case (fail fast with a clear error,
  consistent with the existing DB-unreachable posture for the postgres
  deposit).
- The lead-architect role template (`.claude/agents/lead-architect.md`
  and the canonical source in `shopsystem-templates`) gets a pre-emit
  instruction: "before dispatching a leg of a coordinated fanout, run
  `bd dep add` to record the cross-BC sequence; the dispatch path will
  honor it." This is the template-side complement to the CLI change;
  without it, the lead Architect does not know the new primitive exists.
- The carrier pattern (lead-pfmb, lead-xscs) — currently the workaround
  for class-C stalls, where a placeholder bead carries the deferred
  dispatch's intent — becomes optional rather than mandatory. The
  pattern remains useful for cases where the dispatch's authoring is
  itself deferred (the lead does not yet know what to send), but for
  cases where the dispatch is fully authored and only its firing is
  gated, `bd dep add` plus queued mode replaces the carrier.
- The reconciliation path (ADR-012's `dispatch_state=closed` transition)
  acquires a side effect: the promote scan. The scan's cost is bounded
  by the number of queued dispatches naming the closing bead as a
  pending dependency — in practice, single digits per closure event.
- The lead-ji28 messaging re-dispatch is grandfathered. ADR-013 applies
  prospectively; the incident is the proposal's birth motivation, not a
  violation under the rule as it existed at the time.
- A follow-up bead tracks the `shop-msg send` implementation work
  against `shopsystem-messaging` (the BC that owns the CLI). The
  `shopsystem-templates` template edit is a separate follow-up; neither
  is dispatched in this ADR.
