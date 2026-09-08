---
type: product-decision-record
id: pdr-2026-09-08-bet-run-measurement
status: draft
version: 1
date: 2026-09-08
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-08
updated: 2026-09-08
---

# Product decision record: the bet on init-run-measurement

## Context

The initiative-check process attaches feasibility and usability to an
initiative, screens it once, allows one revise, and ends in the
authority's bet. For
[init-run-measurement](../initiatives/init-run-measurement.md) (v3, a
sub-initiative of init-run-efficiency), the run on anchor lead-fresb
reached its decide step on 2026-09-08 after one screen and one revise.
The authority's word at the act: "bet." The lead-pm restated the
appetite at the bet as one working session — narrower than the
initiative's own stated bound of two hours and 50K context tokens.

The decisions the bet rests on stood checked before the step:
[adr-2026-09-08-run-cost-artifact](adr-2026-09-08-run-cost-artifact.md)
(v2) — the cost row lands in a new lead-shop artifact kept beside the
session record, written only by a runtime step added at
session-handoff's `collect` step — and
[adr-2026-09-08-run-cost-initiative-scope](adr-2026-09-08-run-cost-initiative-scope.md)
(v3) — the measurement is scoped to session-handoff's own session-record
anchor alone, not reconcile-and-close or a review conversation.

## 1. Decision

The product authority, choosing among go, hold, and no-go under the
`bet` right, takes the go on
[init-run-measurement](../initiatives/init-run-measurement.md), betting
one working session on the initiative at the point the two decisions
above stood checked, on 2026-09-08.

## 2. Alternatives

- **Hold — until the sibling init-process-runner's rollout reaches
  every session, so the "every session" target is reachable at bet
  time.** Declined: the outcome does not need full coverage on day
  one; the fields it asks for are already readable, without a model,
  for any run the router moves today, and the appetite bet on is one
  working session, not a wait on a sibling initiative's own separate
  measure.
- **No-go — keep reading transcripts by hand, as done once for
  init-tool-skills.** Declined: the fields the outcome asks for are
  already computable mechanically from the run's anchor and the
  harness's usage report for a router-moved run; a hand read costs
  more than one working session and leaves no repeatable rows behind
  it.

## 3. Consequences

- The initiative moves `proposed` → `planned`. For the PO role: it
  authors the feature within the two checked decisions' bounds. Cost:
  one working session committed to this build and no other.
- A new artifact type is defined, kept beside the session record and
  never folded into the session-record schema. For the PO role, who
  authors its typedef, guideline, and fitness set; for the maker, bound
  to reference the session record's own id rather than restate it.
  Cost: one new typedef and its rendering.
- session-handoff-process gains a runtime step immediately after
  `collect`. For the PO role, who authors the step; for the router,
  whose `collect` step this step now follows, unchanged in what it
  itself produces. Cost: one process-definition version and one skill
  re-render.
- The measurement stays scoped to the session-handoff anchor. For the
  authority, whose "every session" reading is bounded until a separate
  initiative widens it to reconcile-and-close or a review conversation.
  Cost: a session closed by either of those gets no row under this
  bet.
- A field the harness does not expose, most often output tokens, is
  left blank rather than estimated. For the authority reading the
  rows: an honest, incomplete row rather than a modeled number. Cost:
  the row's own gaps stand until the harness exposes more; forecloses
  a model computing what the harness omits.
- The "every session" measure stays a hypothesis. For the PO role: the
  initiative cannot close on the target standing; it closes only as
  the sibling init-process-runner's rollout reaches every session's
  work. Cost: the measure is read, not claimed, until then.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one. Before the
session is spent, the cost is that record. After it, the session is
sunk; undoing what it built is low cost per
adr-2026-09-08-run-cost-artifact's own reversal (§4): the artifact and
the runtime step are removed without touching the session-record
schema or what session-handoff-process promises elsewhere. Review
triggers: the sibling init-process-runner's rollout reaches every
session, prompting a check of whether the same step belongs on
reconcile-and-close's close step and a review conversation's anchor;
the harness begins exposing a field it does not today; a field this
scope assigns to the runtime step turns out to need a decision no
runtime step can make.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Made by the PO role for the authority's go of 2026-09-08 on init-run-measurement (initiative-check run, anchor lead-fresb, one screen and one revise; the lead-pm's restatement of the appetite at the bet: one working session), from basis/guidelines/product-decision-record.md (v7) on basis/guidelines/base-writing-style.md; self-checked against basis/fitness/product-decision-record.fitness.md before the check: scenario 1 pass (§1 states one go, the appetite named); scenario 2 pass (hold and no-go, each with its reason); scenario 3 pass (`decided-by: product-authority`, `right: bet`, both named in §1); scenario 4 pass (six consequences, each naming what changes, for whom, and its cost or what it forecloses); scenario 5 pass (§4 states the cost before and after the session and names three triggers). Status draft pending the PO output check, form only. |
