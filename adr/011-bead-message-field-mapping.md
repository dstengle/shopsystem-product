# ADR-011 — Bead/message field mapping: lead bd schema for projecting shop-msg lifecycle

**Status:** proposed (2026-05-29)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md) (bd is
authoritative for state; shop-msg is authoritative for transmission). The
atomicity protocol that mutates the fields named here (as part of `shop-msg
send` / `shop-msg respond` / reconciliation close) is specified by a later
ADR which references this one for the canonical enum and field set; the
dispatch-dependency marker (`pending_dependency`, `depends_on_dispatch`)
defined here is consumed by a later ADR that adds queued-mode dispatch.
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

**ADR-011 is the canonical holder of both the `dispatch_state` enum and
the field set named below.** The atomicity-protocol ADR and the
dispatch-dependency ADR (both later in the sequence) reference this ADR
for both; neither redefines the enum or the fields. Any future amendment
to either the enum or the field set lands here.

**The lead bd entry for any outbound dispatch MUST carry the following
fields**, encoded per the encoding mechanism below.

### Canonical `dispatch_state` enum

The `dispatch_state` field takes exactly one of these five values:

1. `outbox_pending` — bd intent recorded; postgres deposit not yet
   completed. Set transiently by `shop-msg send` (per the later atomicity-
   protocol ADR, Step 1) and set persistently for queued dispatches by
   the later dispatch-dependency ADR (queued mode, awaiting predecessor
   closure).
2. `dispatched` — postgres row deposited; BC has not yet emitted a
   response. The atomicity-protocol ADR's lead-side Step-3 terminal.
3. `bc_emitted` — BC has emitted a terminal response (`work_done`,
   `clarify`, or `mechanism_observation`); lead has not yet consumed.
4. `consumed` — lead has consumed the BC's emission (per `lead-nn5f`'s
   consume-releases-lead-inbox-slot mechanism).
5. `closed` — lead-architect has reconciled and closed the bead.

Rejected / removed variants from earlier drafts:

- `emitted` (former atomicity-ADR spelling) is renamed to `bc_emitted` for
  clarity; the prior spelling MUST NOT be used.
- `bc_in_progress` (former field-mapping draft) is DROPPED. The lead cannot
  observe this state without a BC nudge, and it carries no decision
  weight that `dispatched` does not already carry.
- `outbox_live` (former dispatch-dependency-ADR draft) is REMOVED. The
  dispatch-dependency ADR uses `dispatched` for "postgres row deposited,
  BC has not yet emitted."

### Required fields per dispatch bead

| Field | Type | Set at | Notes |
|---|---|---|---|
| `dispatched_to_bc` | string \| null | `shop-msg send` | Canonical BC name (e.g., `shopsystem-messaging`); null for lead-internal beads. |
| `dispatch_message_type` | enum | `shop-msg send` | One of `assign_scenarios`, `request_bugfix`, `request_maintenance`, `nudge`. |
| `dispatch_state` | enum | `shop-msg send`, then updated by lifecycle events | One of the five canonical values defined above. |
| `pending_dependency` | work_id \| empty | `shop-msg send --queue-on-dependency` (per the later dispatch-dependency ADR); cleared on promote | Present (non-empty) when `dispatch_state = outbox_pending` AND the dispatch is queued behind a predecessor per the later dispatch-dependency ADR. Empty otherwise. |
| `last_response_received_at` | ISO-8601 timestamp \| null | BC emission events (work_done, clarify, mechanism_observation, nudge) | Most recent BC emission against this work_id. |
| `last_response_message_type` | enum \| null | BC emission events | One of `work_done`, `clarify`, `mechanism_observation`, `nudge`. |
| `scenario_hashes_pinned` | comma-separated string \| empty | `shop-msg send` | Lead-side desired-state coverage; the canonical-block hashes the dispatch carries. Empty for `request_maintenance` and `nudge`. |
| `depends_on_dispatch` | work_id \| null | `shop-msg send` (or `bd update`) | Predecessor dispatch this one is queued behind, per the later dispatch-dependency ADR's carrier pattern. Distinct from `pending_dependency`: `depends_on_dispatch` is the declared cross-BC sequence edge (set whether or not strict mode refused); `pending_dependency` is the live "waiting on" marker active only while the queued bead sits at `outbox_pending`. |
| `bc_origin_main_commit_at_dispatch` | git SHA \| null | `shop-msg send` | The BC's `origin/main` SHA at dispatch time, captured for reachability auditing per [[lead-cw7]]. Null for lead-internal beads. |
| `bc_origin_main_commit_at_close` | git SHA \| null | reconciliation close | The BC's `origin/main` SHA at the moment the architect transitions `dispatch_state` to `closed`. |

### Encoding mechanism

bd supports structured metadata as a first-class facility (confirmed via
`bd create --help` and `bd update --help`: `--metadata <json|@file>`,
`--set-metadata key=value` repeatable, `--unset-metadata key`
repeatable). The canonical encoding for ADR-011 fields is **structured
bd metadata via this mechanism** — `bd create --metadata` at dispatch
time, `bd update --set-metadata key=value` for lifecycle transitions,
`bd update --unset-metadata key` to clear fields (e.g.,
`pending_dependency` on promote).

Implementations SHOULD use the exact CLI surface above when it remains
the canonical bd metadata API. If bd's metadata surface evolves
(renaming, JSON-schema enforcement, or a more structured CLI), the
canonical key names and value shapes named in this ADR survive the
migration; only the wire form of `--set-metadata` / `--metadata` would
change. The authoritative reference is `bd --help` at the time of
implementation.

A typical dispatch creates the bead with all initial fields in one
`--metadata` JSON payload; subsequent lifecycle transitions use
`--set-metadata` / `--unset-metadata` to mutate one field at a time.
Example initial-dispatch payload (illustrative shape, not normative
wire syntax):

```
{
  "dispatched_to_bc": "shopsystem-messaging",
  "dispatch_message_type": "request_bugfix",
  "dispatch_state": "dispatched",
  "pending_dependency": "",
  "scenario_hashes_pinned": "9457dfff7e3f9e90,2b5d558d548b0606",
  "depends_on_dispatch": "lead-767",
  "bc_origin_main_commit_at_dispatch": "b14b0ba"
}
```

The free-form prose `## Dispatch state` notes block is NOT canonical.
Earlier drafts of this ADR proposed it as a fallback in case bd lacked
structured metadata; bd does support it, so the prose block is
explicitly out of scope and SHOULD NOT be written by tooling that
implements this ADR.

### Canonical key names

Key names are exactly as listed in the table above: lowercase,
underscored. A future PDR can extend the set; the names listed here are
canonical and MUST NOT be renamed in-place.

### Update points

1. **`shop-msg send`** writes the initial bd metadata atomically with
   the bd entry (per the later atomicity-protocol ADR), using `bd create
   --metadata`. It computes `dispatched_to_bc`, `dispatch_message_type`,
   `scenario_hashes_pinned` (from the payload), and
   `bc_origin_main_commit_at_dispatch` (by querying the BC's clone), and
   sets `dispatch_state` to `outbox_pending` (transient) or `dispatched`
   (terminal). `depends_on_dispatch` is operator-supplied via a CLI
   flag. For queued-mode dispatches (per the later dispatch-dependency
   ADR), `pending_dependency` is set to the predecessor `work_id` and
   `dispatch_state` remains at `outbox_pending` until promote-scan.
2. **BC-side `shop-msg respond`** does NOT mutate the lead's bd entry.
   Lead-side `shop-msg consume outbox` (or the Monitor-driven
   reconciliation step) uses `bd update --set-metadata` to update
   `last_response_received_at`, `last_response_message_type`, and
   transitions `dispatch_state` to `bc_emitted` (first emission) or
   `consumed` (lead consume).
3. **Lead-architect reconciliation close** uses `bd update
   --set-metadata` to set `bc_origin_main_commit_at_close` to the BC's
   `origin/main` SHA at the moment the reconciliation grep against
   `features/` runs (per ADR-010), and transitions `dispatch_state` to
   `closed`.
4. **Promote scan (defined by the later dispatch-dependency ADR)** uses
   `bd update --set-metadata dispatch_state=dispatched` and `bd update
   --unset-metadata pending_dependency` to flip a queued bead from
   `outbox_pending` to `dispatched` at the moment the postgres row is
   deposited.

### Contract with the atomicity-protocol ADR

A later ADR governs the atomicity of bd-entry write + shop-msg outbox row
write. ADR-011 specifies what the bd entry MUST contain at the moment
that atomicity boundary closes. The two ADRs are layered: "the writes
are atomic" combined with ADR-011's "these are the fields that get
written" closes the gap.

### Forward-compat

bd entries written before ADR-011 lands do not carry the block; entries
written under future ADRs MAY carry additional fields. The strategic-
query layer MUST treat a missing field as `unknown` rather than block
the query. New canonical fields are added by ADR amendment; legacy
entries default to `unknown` until backfilled.

## Alternatives considered

**Option A — Opaque JSON in a single bd `--notes` block.** Rejected.
JSON in `--notes` requires `jq` plus prose-parsing of the surrounding
entry to find the JSON region; strategic queries should not need a
two-stage parse. bd's structured `--metadata` surface is the
single-stage equivalent.

**Option B — Store the projection in shop-msg row metadata.** Rejected.
PDR-010 puts state in bd; shop-msg owns transmission artefacts. Pinning
the projection in shop-msg inverts the authority and forces strategic
queries to read shop-msg as the source of truth.

**Option C — Free-form `## Dispatch state` notes block under
`--notes`.** Rejected (and explicitly removed from the Decision
section). An earlier draft of this ADR kept the prose block as a
fallback for the case where bd had no structured metadata facility. bd
does support `--metadata` / `--set-metadata` / `--unset-metadata`, so
the fallback is not needed. Carrying both would split tooling between
two encodings; committing to the structured form is cheaper and avoids
the parse-the-prose-block failure mode.

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
  `lead_work_id` to thread back. A later BC-side-bead ADR covers the
  BC-side schema; ADR-011 is lead-only.
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
