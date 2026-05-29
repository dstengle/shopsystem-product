# ADR-012 — Bead/message field mapping: lead bd schema for projecting shop-msg lifecycle

**Status:** proposed (2026-05-29)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [PDR-010](../pdr/010-bd-shop-msg-authority-split.md) (bd is
authoritative for state; shop-msg is authoritative for transmission);
[ADR-011](011-bd-shop-msg-atomicity-protocol.md) (the atomicity protocol
that mutates the fields named here as part of `shop-msg send` / `shop-msg
respond` / reconciliation close).
**Related beads:** [[lead-cw7]] (commit-reachability check requires
`bc_origin_main_commit_*` provenance — the schema makes the check
queryable rather than ad-hoc), [[lead-plt]] (BC work_done summary
placeholder and incomplete `scenario_hashes` — the schema makes the
defect visible at query time on the lead side), [[lead-ymct]]
(parallel-dispatch deadlock — `depends_on_dispatch` is the query-able
cure for the carrier pattern).

## Context

Today the lead's bd notes carry dispatch facts — which BC, which
message_type, which scenario hashes shipped, what the BC emitted back —
as free-form prose in the bead's body and successive `bd update --notes`
appends. The facts are reliably recorded; they are not reliably
*queryable*. "What's in flight to shopsystem-messaging right now, what
state is each, and which depend on others" is answerable only by reading
every bd entry's prose — which collapses to "read the architect's
session memory" in practice.

The symptom is **post-compact rehydration failure**. Strategic state —
what's blocked on what, which dispatches await work_done, which BCs have
backlogs — lives in agent context, not bd. A session compact drops it.
MEMORY.md's `project_session_checkpoint_2026_05_29.md` entry is a
workaround that manually pins the state the schema should expose.

The schema is **already doing the work informally**. [[lead-cw7]]
established that reconciliation must verify the lead-`<id>` commit is on
the BC's origin/main; the SHA is today captured only in prose, if at
all, and the check runs only when the architect remembers. [[lead-plt]]
is the emit-fidelity axis: a work_done landed with a placeholder summary
and an incomplete `scenario_hashes` list, caught only by manual grep — a
schema field that pins expected hashes at dispatch makes verification a
comparison, not a discovery. [[lead-ymct]] is the strategic-query case:
parallel dispatches to the same BC produce a commit-sequencing deadlock
that the carrier pattern mitigates only if the architect manually tracks
who is queued behind whom; `depends_on_dispatch` makes the dependency
graph greppable.

PDR-010 names the authority split: bd owns state, shop-msg owns
transmission. The split obligates bd to project enough of the message
lifecycle that strategic queries do not require a join with `shop-msg
pending`. This ADR specifies that projection.

## Decision

**The lead bd entry for any outbound dispatch MUST carry the following
fields**, encoded per the encoding mechanism below.

### Required fields per dispatch bead

| Field | Type | Set at | Notes |
|---|---|---|---|
| `dispatched_to_bc` | string \| null | `shop-msg send` | Canonical BC name (e.g., `shopsystem-messaging`); null for lead-internal beads. |
| `dispatch_message_type` | enum | `shop-msg send` | One of `assign_scenarios`, `request_bugfix`, `request_maintenance`, `nudge`. |
| `dispatch_state` | enum | `shop-msg send`, then updated by lifecycle events | Subset of ADR-011's atomicity statuses: `outbox_pending`, `dispatched`, `bc_in_progress`, `bc_emitted`, `consumed`, `closed`. |
| `last_response_received_at` | ISO-8601 timestamp \| null | BC emission events (work_done, clarify, mechanism_observation, nudge) | Most recent BC emission against this work_id. |
| `last_response_message_type` | enum \| null | BC emission events | One of `work_done`, `clarify`, `mechanism_observation`, `nudge`. |
| `scenario_hashes_pinned` | comma-separated string \| empty | `shop-msg send` | Lead-side desired-state coverage; the canonical-block hashes the dispatch carries. Empty for `request_maintenance` and `nudge`. |
| `depends_on_dispatch` | work_id \| null | `shop-msg send` (or `bd update`) | Predecessor dispatch this one is queued behind, per ADR-013 carrier pattern. |
| `bc_origin_main_commit_at_dispatch` | git SHA \| null | `shop-msg send` | The BC's `origin/main` SHA at dispatch time, captured for reachability auditing per [[lead-cw7]]. Null for lead-internal beads. |
| `bc_origin_main_commit_at_close` | git SHA \| null | reconciliation close | The BC's `origin/main` SHA at the moment the architect transitions `dispatch_state` to `closed`. |

### Encoding mechanism

bd does not enforce a structured schema for arbitrary fields. The
encoding lands in the bd entry's **`--notes` block under a canonical
`## Dispatch state` header**, with one line per field of the form
`key: value`. Example:

```
## Dispatch state
dispatched_to_bc: shopsystem-messaging
dispatch_message_type: request_bugfix
dispatch_state: bc_emitted
last_response_received_at: 2026-05-29T14:22:08Z
last_response_message_type: work_done
scenario_hashes_pinned: 9457dfff7e3f9e90,2b5d558d548b0606
depends_on_dispatch: lead-767
bc_origin_main_commit_at_dispatch: b14b0ba
bc_origin_main_commit_at_close:
```

The `## Dispatch state` block is canonical; bd entries MAY carry
additional prose notes before or after the block, but the block itself
is the projection surface for strategic queries. A bd entry that carries
the block MUST keep it as the first H2 heading in `--notes`, so
`bd show <id> | head` reliably surfaces it.

### Canonical key names

Key names are exactly as listed in the table above: lowercase,
underscored. A future PDR can extend the set; the names listed here are
canonical and MUST NOT be renamed in-place.

### Update points

1. **`shop-msg send`** writes the initial block atomically with the bd
   entry per ADR-011's protocol. It computes `dispatched_to_bc`,
   `dispatch_message_type`, `scenario_hashes_pinned` (from the payload),
   and `bc_origin_main_commit_at_dispatch` (by querying the BC's clone),
   and sets `dispatch_state` to `outbox_pending` (transient) or
   `dispatched` (terminal). `depends_on_dispatch` is operator-supplied
   via a CLI flag.
2. **BC-side `shop-msg respond`** does NOT mutate the lead's bd entry.
   Lead-side `shop-msg consume outbox` (or the Monitor-driven
   reconciliation step) updates `last_response_received_at`,
   `last_response_message_type`, and transitions `dispatch_state` to
   `bc_emitted` (first emission), `consumed` (lead consume), or `closed`
   (reconciliation close).
3. **Lead-architect reconciliation close** sets
   `bc_origin_main_commit_at_close` to the BC's `origin/main` SHA at the
   moment the reconciliation grep against `features/` runs (per
   ADR-010), and transitions `dispatch_state` to `closed`.

### Contract with ADR-011 (atomicity)

ADR-011 governs the atomicity of bd-entry write + shop-msg outbox row
write. ADR-012 specifies what the bd entry MUST contain at the moment
ADR-011's atomic boundary closes. The two ADRs are layered: ADR-011's
"the writes are atomic" combined with ADR-012's "these are the fields
that get written" closes the gap.

### Forward-compat

bd entries written before ADR-012 lands do not carry the block; entries
written under future ADRs MAY carry additional fields. The strategic-
query layer MUST treat a missing field as `unknown` rather than block
the query. New canonical fields are added by ADR amendment; legacy
entries default to `unknown` until backfilled.

## Alternatives considered

**Option A — Opaque JSON in a single bd note.** Rejected. The point of
the projection is that strategic queries grep or scan without parsing
structured data. JSON in a `--notes` field requires `jq` plus
prose-parsing of the surrounding entry, re-introducing the prose-parsing
problem this ADR exists to solve. The `## Dispatch state` block with
`key: value` lines is greppable, diffable, and human-readable.

**Option B — Store the projection in shop-msg row metadata.** Rejected.
PDR-010 puts state in bd; shop-msg owns transmission artefacts. Pinning
the projection in shop-msg inverts the authority and forces strategic
queries to read shop-msg as the source of truth.

**Option C — Use bd's structured `--metadata` if it supports it.** Kept
as **preferred** if bd grows a structured metadata facility before the
strategic-query layer ships. The `## Dispatch state` block is the
fallback that works today. Canonical key names hold regardless of
encoding; a migration step would copy block contents into structured
fields without renaming.

## Consequences

- **Lead bd entries become queryable for strategic state.** A future
  `bd ready --shop-system` (or grep over `--notes`) surfaces every
  in-flight dispatch's BC, state, predecessor dependency, and expected
  scenario coverage without touching shop-msg storage.
- **Lead-architect reconciliation tightens.** Closing a dispatch
  requires setting `bc_origin_main_commit_at_close` and transitioning
  `dispatch_state` to `closed`. The architect role template
  (`.claude/agents/lead-architect.md` and its canonical source in
  `shopsystem-templates`) inherits the field-update step as a
  reconciliation precondition. A follow-up bead tracks the template
  edit.
- **`shop-msg send` gains the responsibility** of writing the initial
  block atomically with the outbox row. The CLI acquires a
  `--depends-on` flag and computes `bc_origin_main_commit_at_dispatch`
  by querying the BC's clone. A follow-up bead in shopsystem-messaging
  tracks the CLI surface.
- **BC-side bd schema differs.** The BC's own bd entry carries a
  different projection — no `bc_origin_main_commit_*`, but it does need
  `lead_work_id` to thread back. ADR-016 covers the BC-side schema;
  ADR-012 is lead-only.
- **Post-compact rehydration becomes a query, not a memory dump.** The
  architect can reconstruct in-flight state by scanning `## Dispatch
  state` blocks rather than relying on MEMORY.md checkpoints. The
  session-checkpoint pattern can retire once the strategic-query layer
  lands.
- **[[lead-cw7]]'s reachability check becomes mechanical** —
  `git merge-base --is-ancestor` against
  `bc_origin_main_commit_at_close`, no prose reading.
- **[[lead-plt]]'s emit-fidelity gap becomes visible at query time.**
  Lead-side `scenario_hashes_pinned` (expected) vs the BC's work_done
  payload (claimed) is a structured comparison, not a manual grep.
- **[[lead-ymct]]'s carrier pattern becomes queryable.** Setting
  `depends_on_dispatch: lead-767` makes the dependency graph greppable;
  `bd ready` can surface "what is queued behind lead-767" without
  prose-reading every bead.
