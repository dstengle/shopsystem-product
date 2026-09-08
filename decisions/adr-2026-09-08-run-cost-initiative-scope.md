---
type: adr
id: adr-2026-09-08-run-cost-initiative-scope
title: Run-cost measurement in this initiative is scoped to session-handoff's session-record anchor
status: checked
version: 3
date: 2026-09-08
decided-by: lead-solutions-architect
right: decomposition
owner: lead-solutions-architect
created: 2026-09-08
updated: 2026-09-08
derives-from: [adr-2026-09-08-run-cost-artifact]
---

# ADR: Run-cost measurement in this initiative is scoped to session-handoff's session-record anchor

## 1. Context

Terms, from the glossary: a *session record* is the anchor of a
discovery conversation — outcome, produced and revised lists, open
threads, select quotes; an *anchor* is the governed record a
conversation attaches to and carries its state across transcript
boundaries; a *close process* is one of three: `session-handoff-process`
produces the session record; `reconcile-and-close` closes a work item;
a review conversation, once that process is defined on this branch,
will produce a review record.

Pre-state, 2026-09-08, read from lead-shop-held records.
`init-run-measurement` (v3) frames the outcome in the originator's own
words (product authority, req-2026-09-07-run-efficiency): "Outcome:
every session close records, without a model, one row per agent run —
step, role, minutes, context tokens, output tokens where the harness
gives them, tool uses — *beside the session record*, so any run can be
analysed on request." The framing's own scope-setting words,
"beside the session record," fix the target: the session record
produced and owned by `session-handoff-process`. 

Three close processes and anchors exist or are planned on this branch.
(1) `session-handoff-process` (v3) produces the session record and is
the process this initiative names directly. (2) `reconcile-and-close`
(v4) closes a work item (the anchor of a scenario-assignment
conversation), with its own router-run close step; this process has no
row-writing step of its own. (3) A review conversation has no anchor
process defined on this branch at all (the branch primer names the
reconcile-side amendments and the review-conversation anchor process
as open work). The initiative's appetite names scope boundaries:
"no-gos: no analysis in the step itself — rows only; no measure that
needs a model to compute." No appetite constraint is stated
against reconcile-and-close or review-conversation rows; the
constraint is by framing alone.

Forces. `intent-provenance`: the initiative is framed from the
authority's own words, which name the session record — not the work item
and not the review record. To expand the scope to those two anchors
would mean expanding the initiative beyond what was asked for, not
building what was asked for. `local-comprehension`: the initiative
describes a single piece of work — one runtime step in one process
(`session-handoff-process`'s new runtime step after `collect`), one
artifact type paired with the session record, one feature. Trying to
bundle three different close processes and two new artifact types
(for work-item and review-record rows) into one initiative would make
the scope too large to describe and understand as one thing.
`actor-neutral-discipline`: whoever closes a session through
`session-handoff-process` records a row; whoever closes a work item
through `reconcile-and-close` is a different activity with its own
outcome, and the row for that outcome belongs in that activity's own
process, not borrowed from this one.

Options that were real:

- **Bundle run-cost rows for all three anchors into one initiative.**
  Declined: the originator named "the session record" — not "every
  close anchor" — setting the scope by their own framing words; to
  expand beyond that would be replacing the stated outcome with a
  different one. `reconcile-and-close` has its own close step and its
  own process definition, owned by the same role as `session-handoff`
  but serving a different activity (closing a work item, not a session);
  the same row-writing step at one process's close does not transfer
  meaning to another's. A review conversation, once its process is
  defined, will belong to a yet-separate activity; bundling its row
  collection with two others would mean deciding for that future
  activity before it is framed. The appetite's own no-gos ("rows only,"
  "no model") apply to any such row, but are not an appetite to bundle
  three into one.
- **Defer any decision; build the step for reconcile-and-close and
  review-conversation rows preemptively so they're ready when needed.**
  Declined: the initiative is triggered by the authority's bet on a
  specific framing. To decide and build for close processes the
  authority has not asked for would be anticipatory engineering,
  building what is not yet framed or bet on. When reconcile-and-close
  calls for the same step, that call is a separate initiative with its
  own bet and its own decision (this one does not carry that decision).

## 2. Decision

The run-cost row collection that init-run-measurement frames and bets
on is scoped to the session-record anchor closed by `session-handoff-process`.

### 2.1 Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms, no exception carried. `knowable-shape` — the decision does not
create or describe a first-class entity; it narrows the scope of an
initiative to an existing process's anchor. `contracts-between-contexts`
— no Bounded Context is in scope; the decision concerns the lead shop's
own process decomposition. `actor-neutral-discipline` — the
row-collection requirement this decision establishes attaches to the
`session-handoff-process` activity, not to whoever performs it: a
human PM, an agent, or a service closing a session each produce the
same row under the same requirement, with no fork by actor kind.
`local-comprehension` — by keeping the initiative's scope
to one process and one anchor, the feature that builds it stays
comprehensible as one thing; bundling three close activities would
force a reader into multiple process definitions to understand one
initiative. `bidirectional-conformance` — this record is the design
decision, recorded before the feature is built; the feature is scoped
by this decision and nothing more. `intent-provenance` — traces
without a gap: the product authority's framing in req-2026-09-07-run-efficiency
("beside the session record") carries through sess-2026-09-07-b and
init-run-measurement to this record; the scope is not expanded beyond
what was asked for.

## 3. Consequences

- One initiative, one outcome. What changes: `init-run-measurement` is
  bounded by this decision to the session-handoff process and its
  session-record anchor; the feature that builds it is scoped to one
  runtime step, one artifact type, one audience (the authority reading
  the session-close cost). For whom: the authority, who bets on this
  specific framing; the lead-po role, who sizes the feature to one
  outcome. Cost: clarity of scope. Forecloses: a bundle of three
  outcomes in one feature.
- Reconcile-and-close and review conversations defer to separate work.
  What changes: if the authority later wants row collection for a
  work-item close, that is a separate discovery conversation, a separate
  initiative, a separate bet, and a separate feature. The same applies
  to review-conversation rows once that process is defined. For whom:
  the PM role, who will frame those separate initiatives when asked; the
  lead-solutions-architect role, who will make separate decomposition
  decisions about where each row collection belongs. Cost: the authority
  must ask separately for each if each is wanted; starting today with one
  means the next two are opt-in, not bundled. Forecloses: assuming that
  the row-writing mechanics built for session-handoff automatically
  transfer to other close processes without a separate decision and bet.
- The decision that produces the session-record artifact, recorded at
  adr-2026-09-08-run-cost-artifact, is unaffected. What changes:
  nothing — adr-2026-09-08-run-cost-artifact stands alone, independent
  of whether reconcile-and-close or review conversations later decide
  to add their own row collection. For whom: the PO role, who builds
  the artifact adr-2026-09-08-run-cost-artifact defines, as planned;
  any future initiative for another close's rows. Cost: none.
  Forecloses: nothing — a future initiative may reuse the artifact
  patterns adr-2026-09-08-run-cost-artifact defines, or define new ones
  tailored to a work-item close or a review close.

Bound on Bounded Context shops: none. No Bounded Context is in scope;
this decision governs the lead shop's own process decomposition.

## 4. Reversibility

Reversible at low cost before the feature ships: the initiative can
be re-scoped or reframed with nothing sunk beyond this record. After
it ships, the decision is embodied in what `session-handoff-process`
does, and reversal costs the scope mismatch — unwinding row collection
built to the session-record anchor and re-deciding scope for a
different one. Review triggers: the authority later requests run-cost
rows for a work-item close or review-conversation close, making a
separate initiative necessary (not a reversal but a separate decision;
this one holds).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the lead-solutions-architect role from the D2 decision recorded at init-run-measurement's initiative-check attach-architecture step (that initiative's Document History v2), triggered by this role's bet on initiatives/init-run-measurement.md. Pre-state read from lead-shop-held records alone: the initiative in full, init-run-measurement's framing words, session-handoff-process (v3) and reconcile-and-close (v4), the branch primer's statement of open work on review conversations, and the appetite constraints stated in the initiative. Screened against the architecture principle set: conforms, no exception carried. One decision: the scope is the session record. |
| 1 | 2026-09-08 | update | Finding 3 (reversibility criterion) repaired by lead-solutions-architect: PM answered that reversibility is pre-ship only; post-ship reversal incurs scope-mismatch costs and is expensive. Reversibility section restated to reflect this: "Reversible pre-ship only" replacing "Reversible at low cost." |
| 2 | 2026-09-08 | update | Review round 1 repaired by lead-solutions-architect at the adr-authoring revise step, superseding the v1 out-of-role repair above (made outside the process, without this step's provenance): title trimmed to one line, one decision — the deferred-scope clause dropped, its substance already carried in Context and Consequences (criterion 1); the principles-screen `actor-neutral-discipline` paragraph rewritten to test actor-kind neutrality within `session-handoff-process` alone, dropping the cross-activity comparison it had wrongly carried (criterion principles); Reversibility restated directly from the lead-pm's answered ask — reversible at low cost before the feature ships, reversal costing the scope mismatch after (criterion 5); "D1" replaced throughout the affected Consequences bullet with the record's own id, adr-2026-09-08-run-cost-artifact (uncovered, per lead-pm ruling). |
| 3 | 2026-09-08 | state | `draft` → `checked`: the PM role's pass, read from the record against the review — one decision in the title and §2, the actor-neutral screen on one activity, reversibility as the answered ask states, the record cited by id; the earlier out-of-role repair superseded by the architect's revise (v2). Recorded by the lead-pm at the record step, the child run lead-ml7u0 having ended before the revise was redone. |
