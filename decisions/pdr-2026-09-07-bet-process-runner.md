---
type: product-decision-record
id: pdr-2026-09-07-bet-process-runner
status: draft
version: 1
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
(initiative v6).

The decision the bet rests on stood checked before the step:
[adr-2026-09-07-coordinator-role](adr-2026-09-07-coordinator-role.md)
(v3) — a running process is run by the lead shop's `router` role, a
defined role restartable at any step from the run's anchor, and by no
code runner.

## 1. Decision

The product authority takes the go on
[init-process-runner](../initiatives/init-process-runner.md), betting
its appetite — one working session of the lead shop for one process
run end to end by the router, the run's context measured — on the
initiative at v6, on 2026-09-07.

The authority decided under the `bet` right, the right the
product-decision-record typedef admits for the authority's go, hold,
or no-go on an initiative. Its two rulings at the step are part of
the same bet: the originator's quoted words stand as quoted, and the
designer's D1 and D2 stand with their records in the experience
guidance corpus, not in `decisions/`.

## 2. Alternatives

- **Hold — until the quote is reworded or the designer's decisions
  have records in `decisions/`.** Declined: the quoted "model" is the
  originator's own words, and the framing reports them; the
  designer's decisions land in the corpus by that role's exclusive
  domain, the precedent set at init-tool-skills. Nothing the appetite
  spends waited on either.
- **No-go — the lead-pm keeps coordinating runs by hand.** Declined:
  the lead-pm's session cost 64M of the 85M tokens init-tool-skills
  spent; the authority's direction is that the lead-pm should not
  coordinate a running graph at all, and the parent's target (under
  5M per feature) cannot be reached while it does.

## 3. Consequences

- The initiative moves `proposed` → `planned`. For the lead shop: the
  PO role authors its feature and the backlog order places it — the
  router's definition and one run end to end, measured. Cost: one
  working session committed to this run and to no other work.
- The router role gets a definition. For the PO role, which defines
  the feature, and the authority, which approves the definition
  through the role-definition chain. Cost: one definition, its
  rendering, and one approval. Forecloses: a router that decides.
- The architecture decision's consequences start being spent. For the
  solutions architect role: the run's state in the anchor, agent steps
  launched with their declared inputs alone, conditions recorded
  beside the branch taken. Cost: one write to the anchor per step; the
  whole skill loaded at each start until a rendering of one step
  exists. Forecloses: a code runner inside this appetite.
- Parseable agent outputs enter the backlog as enabler work. For the
  process owner: a line the compiler appends to each agent prompt, so
  the router can branch on `review.verdict`. Cost: one compiler
  change and every skill re-rendered. The PO role places it before
  the run, since the run cannot branch without it.
- The designer's D1 and D2 stand as corpus entries. For the designer
  role: the assistant type as the first offer, and the one shape of a
  human step at the prompt, entered as hypotheses before delivery.
  Cost: the entries are the designer's work inside this session;
  without them the conformance screen returns a finding against the
  corpus, not the run.
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
Bounded Context shop depends on it. Review triggers: the run does not
complete end to end within the appetite; the router's context per
delivered feature stays above 1M after a restart per sub-process; the
first run mis-reads a condition; the migration review decides the
runner is the shopsystem's engine; or any trigger the architecture
decision names for itself.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Made by the PO role for the authority's go of 2026-09-07 on init-process-runner ("Bet, quotes stay, accept the designer's records", initiative v6), from `basis/guidelines/product-decision-record.md` (v7, produced from `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`) on `basis/guidelines/base-writing-style.md` (v2); self-checked against `basis/fitness/product-decision-record.fitness.md` (same source and digest) before the check: scenario 1 pass (§1's first sentence is the one go; the two rulings are how the bet was taken), 2 pass (hold and no-go, each with its reason), 3 pass (`decided-by: product-authority`, `right: bet`, both named in §1), 4 pass (six consequences, each with what changes, for whom, and its cost or what it forecloses), 5 pass (§4 states the cost before and after the session, calls it low, and names five triggers). Status draft pending the PO output check, form only. |
