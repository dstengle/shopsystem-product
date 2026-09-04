---
type: product-decision-record
id: pdr-2026-09-04-bet-request-routing
status: checked
version: 4
date: 2026-09-04
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-04
updated: 2026-09-04
---

# Product decision record: the bet on init-request-routing

## 1. Decision

The product authority takes the go on
[init-request-routing](../initiatives/init-request-routing.md),
betting the initiative's appetite — one working session of the lead
shop — on the text as it stood at the initiative-check's round cap on
2026-09-04.

The authority's bet is the decision, exercised through its standing
direction of 2026-09-04 — "continue all the way through implementation
unless there is anything absolutely requiring clarification from me.
If this initiative needs an ADR, make sure the architect produces
that. Otherwise you have my permission to continue through." — and
applied at the initiative-check decide step by the lead-pm, who
recorded it. The go is taken now, on that direction, and stands unless
the authority reverses it at delivery by a cancellation under the same
right (§4). It was applied at the cap (round 3, judge claude-fable-5-1 / screen prompt
v5) with three findings open that the judge could not decide (wobbly),
none it could (confident), and none a criterion fails to name
(uncovered), each named in the initiative's Document History. What
became of the three — one repaired after the cap to the judge's own
wording and disclosed, two held unrepaired — is the lead-pm's ruling,
recorded in the initiative's Document History and in this record's,
and is not part of the authority's decision.

## 2. Alternatives

- **Hold — for the authority's clarification.** The authority's
  direction carved out one hold — "unless there is anything absolutely
  requiring clarification from me" — so the authority could have been
  asked to hold the bet and rule on the two held readings (§1, named
  in §3). Declined: the bet did not need the authority, because no
  finding was confident and the held readings turn on what the
  criteria do not settle. The open question is whether the criterion's
  wording should settle them — a change to the initiative fitness set,
  a definition the authority owns, filed in that set's Document
  History for the authority to rule on its own later, and not a
  condition of this bet.
- **No-go — decline the initiative.** Declined: the gap is live — the
  measure stands at 0, the only door for an ask being discovery and the
  only path the full flow — and the solutions architect role's
  feasibility verdict in the initiative's Feasibility and usability
  section stands: feasible within one session, the verified example
  included, on the roles-availability precedent.

## 3. Consequences

- The initiative moves `proposed` → `planned`: for the lead shop, the
  PO role authors its first feature in the feature-authoring process
  and the backlog order places its features-to-be. Cost: the appetite
  — one working session of the lead shop — is committed to this
  initiative and is not available to other work.
- The bet is on the round-cap text with the two held findings (§1)
  unrepaired — the Appetite's no-gos naming what they exclude
  (initiative fitness scenario 4) and the Framing's three route
  destinations (scenario 4): for every later reader and check, that
  text is the text of record. Cost: a screen verdict on those two passages is foreclosed
  for this initiative — if either is a real defect, it is carried into
  feature authoring and surfaces there rather than at the check of
  record.
- The initiative's six no-gos, as its Appetite section states, bind
  for the spent appetite: for the lead shop and any role that would
  take up that work, each is foreclosed for this initiative and would
  need a new decision to reopen — among them, the one the Framing's
  problem statement rests on: no bet and no screen of record for a
  simple change.
- The bet is exercised through the authority's standing direction: for
  the PM role and the authority, the direction quoted in §1 and the
  lead-pm's state entry in the initiative are the record the go stands
  on, and it stands unless reversed at delivery. Cost: should the
  authority hold that the direction did not cover this bet, the
  session's work on the initiative to that point — its placement in
  the backlog order, any feature authored under it, and any definition
  amended for it — is lost with the cancellation.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one; before the
session is spent the cost of reversal is only that record, and after
it the session is sunk. Review trigger: the appetite is exhausted
without the measure — a simple functional change reaching a verified
result through a recorded, routed ask, the full flow untouched, 0 → 1
— or feature authoring surfaces work outside the no-gos' boundary, or
the authority rules that its standing direction did not cover this
bet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Made by the PO role for the authority's go of 2026-09-04 on init-request-routing, taken in the initiative-check decide step at the round cap on the authority's standing direction for the session, the lead-pm recording it; status draft pending the PO output check (form only — the decider is the authority). |
| 2 | 2026-09-04 | review | PO output check round 1 (judge: claude-fable-5-1 / screen prompt v6): three wobbly findings, none confident — §1 carried the lead-pm's two holds with their reasons, so the decision could not be told from the holds (scenario 1; §1 kept to the bet, the disposition of the three findings stated as the lead-pm's ruling and not the authority's decision, the account moved here: the contract clause, initiative fitness scenario 1, repaired post-cap to the judge's wording and disclosed; the no-gos read as naming structures, scenario 4, held because a no-go must name what it excludes; the three route destinations read as mechanism, scenario 4, held because the routes are the authority's own decision from the discovery, an outcome); the Hold alternative named a fourth screen round, unavailable at the cap (scenario 2; restated as the hold the direction carved out — for the authority's clarification — declined because nothing was judged to require it); "wobbly", "confident", "uncovered" used without introduction (uncovered; each defined at first use in §1). Repaired. |
| 3 | 2026-09-04 | review | PO output check round 2 (judge: claude-fable-5-1 / screen prompt v6): four wobbly findings, none confident — "takes the go" against "for ratification at delivery" read as two statuses (scenario 1; one stated: the go is taken now on the standing direction and stands unless the authority reverses it at delivery by a cancellation under the same right; Consequence 4 aligned to "stands unless reversed"); "those two passages" in Consequence 2 not decidable from the body (scenario 4; the two held passages named there — the Appetite's no-gos naming what they exclude, the Framing's three route destinations); the Hold alternative filed a question for "the owner" without reconciling that the owner is the authority, and stated the choice as the lead-pm's (scenario 2; restated as the authority's own hold, declined because the bet did not need the authority, the open question being a change to the fitness set the authority rules on its own later, not a condition of the bet); Consequence 3 listed the four work-item no-gos as if from the Framing (framing; replaced with a reference to the Appetite's six, only the Framing-traced no-go named). Repaired. |
| 4 | 2026-09-04 | review | Round 3, the cap (judge: claude-fable-5-1 / screen prompt v6): four wobbly findings, none confident, no uncovered defect the criteria could not reach — the bet's text named as "at the round cap" while the disclosed post-cap repair is in the text of record; the account of the three cap findings sitting inside §1; the reversal window stated at delivery in §1 and priced before the session in §4; "round cap" and "decide step" unintroduced. Not repaired at the cap. |
| 4 | 2026-09-04 | state | `draft` → `checked`: the PM role's pass. Reasons: no finding was confident in any of three rounds and each round's wobbly set was different — churn on wording the criteria do not settle, not a defect the criteria name. For the reader: the text of record is the initiative at version 2 after its disclosed post-cap repair; reversal is a cancellation at any point, priced by §4. |
