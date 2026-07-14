---
type: intent-record
id: intent-005
title: Ordering mechanism for multiple simultaneously-live intent records
status: recorded
created: 2026-07-14
updated: 2026-07-14
authors: [dstengle, "Claude (acting lead-pm)"]
description: Stakeholder intent for a tested, working mechanism to order more than one live intent record against each other, using the untested prioritizations/ artifact type.
stakeholder: dstengle
session: sess-2026-07-14-b
superseded-by:
beads: []
---

# intent-005 — Ordering mechanism for multiple simultaneously-live intent records

## Verbatim anchors

2026-07-14: "The candidates are numbered and that seems like it will
be a problem for capturing and ordering things. How will backlog type
items work? Will they stop at intent? Does that have enough
information for prioritization or should there be a candidate?"

2026-07-14: "I'm not sure what you would write for 5, especially when
you bring up the 154 ready beads. I agree that dealing with them is an
issue but I'm curious what you mean here."

## The goal behind the ask

`candidates/` and `intent/` use sequential numeric IDs (identity only,
not priority). The `prioritizations/` artifact type is declared in
`current-state.md`'s Lead shop section and the "sequencing" PM mode
maps to it — but the directory has never been created and the
mechanism has never been exercised. This session surfaced the gap
concretely: `intent-002` was shaped and committed ahead of `intent-003`
purely because their ordering was an obvious structural blocker
(resolved by an ad hoc stakeholder instruction — "if you see something
easy to prioritize as a blocker, move forward"), not by any artifact or
mechanism. A harder case — multiple live intent records with no
blocking relationship between them, requiring a genuine judgment call —
has not been tested.

**Correction to the router's own earlier framing:** an initial version
of this concern conflated the `bd` operational backlog (154 `bd ready`
issues — already-scoped engineering tasks with their own working
priority field and dependency graph, never touching `intent/` or
`candidates/`) with the PM/product backlog (intent records awaiting a
shaping decision — currently just one, `intent-003`). Those are
different backlogs solving different problems; the `bd` scale question
is a separate, already-tracked concern (closer to `lead-21ig`,
periodic system-health/hygiene checks), not a PM-shaping problem. This
intent is scoped to the PM/intent backlog only.

## Who it serves

The product authority, at the moment more than one intent record is
live and a real choice — not an obvious structural blocker — has to be
made about which to shape/commit next.

## Constraints

- Should not require full shaping (a candidate) just to establish
  relative order — that would defeat the just-in-time-shaping economy
  this session already demonstrated (`intent-003` deliberately stayed
  unshaped while `intent-002` went through two feasibility probes and
  an empirical container test to become `cand-002`).
- Whatever ordering signal is required should be obtainable from an
  intent record as currently specified, or name precisely what
  additional (still lightweight, non-candidate-level) information an
  intent record is missing for this purpose.

## Non-goals

- Ordering or triaging the `bd` operational/engineering backlog — that
  already has a working mechanism (priority field + dependency graph)
  and is out of scope here.
- Full candidate-level shaping as a prioritization prerequisite.

## Appetite signal

Not stated. Appetite for implementation to be set at candidate shaping.

## Failure conditions

- A prioritization mechanism that in practice requires shaping
  everything first to compare it, defeating its own purpose.
- Continuing to resolve intent-ordering by ad hoc instruction
  indefinitely, with `prioritizations/` never actually getting used.

## Open threads

- Whether existing intent-record fields (problem, why-now, appetite
  signal) carry enough signal for a coarse ordering pass, or whether a
  new lightweight field (e.g. rough size/urgency, explicit dependency
  links to other intents) is needed without escalating to full
  candidate shaping.
- What a `prioritizations/` record actually looks like in practice —
  it has a declared home and a PM-mode skill, but zero prior instances
  to pattern-match against; this is genuinely first-use territory.
- Whether ordering should also account for structural
  blocking/dependency relationships between intents explicitly (as
  happened organically between `intent-002`/`intent-003`) as a
  first-class field, given that was the one case actually exercised so
  far.
