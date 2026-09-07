---
type: product-decision-record
id: pdr-2026-09-07-bet-process-runner
status: checked
version: 3
date: 2026-09-07
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-07
updated: 2026-09-07
---

# Product decision record: the bet on init-process-runner

## Context

The initiative-check — the process that attaches feasibility and
usability to an initiative, screens it once, allows one revise, and
ends in the authority's bet — reached its decide step on 2026-09-07
for [init-process-runner](../initiatives/init-process-runner.md), a
sub-initiative of init-run-efficiency. The one screen (initiative v4)
found four confident and seven wobbly findings; the one revise
(v5) repaired every confident finding and left two for the authority:
the originator's quoted word "model" in the Framing, and the
designer's decisions D1 and D2 with record "none". The authority took
the bet in person: "Bet, quotes stay, accept the designer's records"
(initiative v6). Its words at the act settle the two findings and
decide nothing further: the quoted words stand as quoted, and the
designer's D1 and D2 record in the experience guidance corpus, not
in `decisions/`.

The decision the bet rests on stood checked before the step:
[adr-2026-09-07-coordinator-role](adr-2026-09-07-coordinator-role.md)
(v3) — a running process is run by the lead shop's `router` role, a
defined role restartable at any step from the run's anchor, and by no
code runner.

## 1. Decision

The product authority, choosing among go, hold, and no-go under the
`bet` right — the right the product-decision-record typedef admits
for the authority's decision on an initiative — takes the go on
[init-process-runner](../initiatives/init-process-runner.md), betting
its appetite — one working session of the lead shop for one process
run end to end by the router, the run's context measured — on the
initiative at v6, on 2026-09-07.

## 2. Alternatives

- **Hold — until the quote is reworded or the designer's decisions
  have records in `decisions/`.** Declined: the quoted "model" is the
  originator's own words, and the framing reports them; the
  designer's decisions land in the corpus by that role's exclusive
  domain, the precedent set at init-tool-skills. Nothing the appetite
  spends waited on either.
- **No-go — the lead-pm keeps coordinating runs by hand.** Declined:
  the lead-pm's session cost 64M of the 85M tokens of context
  init-tool-skills spent, and the parent's target is under 5M per
  feature against about 42M now (req-2026-09-07-run-efficiency,
  section 3's evidence; init-run-efficiency, For whom); the
  authority's direction is that the lead-pm should not coordinate a
  running graph at all.

## 3. Consequences

- The initiative moves `proposed` → `planned`. For the lead shop: the
  PO role authors its feature and the backlog order places it — the
  router's definition and one run end to end, measured. Cost: one
  working session committed to this run and to no other work.
- The router role gets a definition. For the PO role, which defines
  the feature, and the authority, which approves the definition
  through the role-definition chain. Cost: one definition, its
  rendering, and one approval. Forecloses: a router that exercises
  judgement beyond running the definition as written.
- The architecture decision's consequences start being spent. For the
  solutions architect role: the run's state in the anchor, agent steps
  launched with their declared inputs alone, conditions recorded
  beside the branch taken. Cost: one write to the anchor per step; the
  whole skill loaded at each start. Forecloses: a code runner inside
  this appetite.
- Parseable agent outputs enter the backlog as enabler work. For the
  product authority, the process definitions' owner: a line the
  compiler appends to each agent prompt, so the router can branch on
  `review.verdict`. Cost: one compiler change and every skill
  re-rendered. The run depends on it — the router cannot branch
  without it — and the backlog order honours that dependency.
- The designer's D1 and D2 stand as corpus entries. For the designer
  role: the assistant type as the first offer, and the one shape of a
  human step at the prompt, entered as hypotheses before delivery.
  Cost: the entries are the designer's work inside this session.
- The measure is a hypothesis until the run is recorded. For the
  delivering agent and the PO role: "under 1M" is claimed only by the
  first run's measured context. Cost: the initiative cannot close on
  the definition standing.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one. Before the
session is spent, the cost is that record. After it, the session is
sunk, and undoing what it built is the architecture decision's own
reversal (its §4): low, since the router's definition is removed or
replaced by a runner reading the same definitions and anchor, and no
Bounded Context shop depends on it. The run's operating assumption,
from the architecture decision: the router restarts from the anchor
at least once per sub-process, because a session's context only
grows. Review triggers: the run does not complete end to end within
the appetite; the router's context per delivered feature stays above
1M under that assumption; the first run mis-reads a condition; the
migration review decides the runner is the shopsystem's engine; or
any trigger the architecture decision names for itself.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Made by the PO role for the authority's go of 2026-09-07 on init-process-runner ("Bet, quotes stay, accept the designer's records", initiative v6), from `basis/guidelines/product-decision-record.md` (v7, produced from `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`) on `basis/guidelines/base-writing-style.md` (v2); self-checked against `basis/fitness/product-decision-record.fitness.md` (same source and digest) before the check: scenario 1 pass (§1's first sentence is the one go; the two rulings are how the bet was taken), 2 pass (hold and no-go, each with its reason), 3 pass (`decided-by: product-authority`, `right: bet`, both named in §1), 4 pass (six consequences, each with what changes, for whom, and its cost or what it forecloses), 5 pass (§4 states the cost before and after the session, calls it low, and names five triggers). Status draft pending the PO output check, form only. |
| 2 | 2026-09-07 | update | The one revise from the PO output check's screen, eight findings: the authority's two rulings moved to Context as its words at the act, §1 one go with go/hold/no-go introduced first; the enabler's last sentence restated as a dependency the ordering honours; the no-go's numbers sourced to the request's evidence and the parent's For whom; the router consequence forecloses judgement beyond the definition as written; "process owner" named as the product authority; the conformance-screen clause cut; "a rendering of one step" dropped; the restart per sub-process stated in §4 as the run's operating assumption, from the ADR. Self-check against the same fitness set: scenario 1 pass, 2 pass, 3 pass, 4 pass, 5 pass. |
| 3 | 2026-09-07 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise; every named finding repaired, the wobbly ones ruled with the review. |
