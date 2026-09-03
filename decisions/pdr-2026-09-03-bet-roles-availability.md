---
type: product-decision-record
id: pdr-2026-09-03-bet-roles-availability
status: checked
version: 4
date: 2026-09-03
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-03
updated: 2026-09-03
---

# Product decision record: the bet on init-roles-availability

## 1. Decision

The product authority takes the go on
[init-roles-availability](../initiatives/init-roles-availability.md),
betting the initiative's appetite — one working session of the lead
shop — on the text as it stood at the initiative-check's round cap on
2026-09-03.

The authority's bet is the decision, exercised through its standing
direction of 2026-09-03 — "run this through to the end since it is
low-risk" — and applied at the initiative-check decide step by the
lead-pm, who recorded it. It was applied at the cap (round 3, judge
claude-fable-5-1 / screen prompt v5) with two wobbly findings open,
neither confident and no uncovered defect, each already settled by a
ruling the authority had made on init-skills-availability: the
originator's quoted "claude" and "skills" against initiative fitness
scenario 4 (that screen's round 3 confined solution words to the
originator's quote), and the Framing's outcome clause "maintained by a
defined process with its own check" (the authority's own wording of
2026-09-02, that initiative's v5).

## 2. Alternatives

- **Hold — a fourth screen round.** Declined: the initiative-check
  reached its round cap at round 3, and neither of the two open
  findings (§1) was confident. Both stand on the authority's prior
  rulings, so a further round would re-screen text the authority had
  already ruled on. The judge's proposal that scenario 4 exempt the
  originator's quoted words — the finding recurring on both
  initiatives — is filed for the owner in the initiative fitness set's
  Document History; it is the owner's to decide and not settled here.
- **No-go — decline the initiative.** Declined: the gap is live (0 of
  6 approved roles instantiated from an approved source; the two roles
  the runtime does instantiate come from the frozen corpus, unapproved
  on this branch), the solutions architect role's feasibility verdict
  in the initiative's Feasibility and usability section stands — feasible, within the
  appetite, nothing at the load point to conflict with — and the
  authority itself named the work low-risk.

## 3. Consequences

- The initiative moves `proposed` → `planned`: for the lead shop, the
  PO role authors its first feature in the feature-authoring process
  and the backlog order places its features-to-be. Cost: the appetite
  — one working session of the lead shop — is committed to this
  initiative and is not available to other work.
- The bet is on the round-cap text with the two open findings (§1)
  unrepaired: for every later reader and check, that text is the text
  of record. Cost: a screen verdict on those two passages is foreclosed
  for this initiative — if either is a real defect, it is carried into
  feature authoring and surfaces there rather than at the check of
  record.
- The initiative's no-gos bind for the spent appetite: for the lead
  shop and any role that would take up that work, deepening the role
  definitions (brief-030 ask 1), using the frozen corpus's role
  material as source, touching what the frozen corpus loads before
  cut-over, and widening beyond roles in this session are foreclosed
  for this initiative; the wider rendering work stands as a backlog
  item in the authority's words, and each no-go would need a new
  decision to reopen.
- The bet is exercised through the authority's standing direction: for
  the PM role and the authority, the direction quoted in the
  initiative's Framing and the lead-pm's state entry are the record the go
  stands on. Cost: should the authority hold that the direction did not
  cover this bet, the session's work on the initiative to that point —
  its placement in the backlog order and any feature authored under it
  — is lost with the cancellation.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one; before the
session is spent the cost of reversal is only that record, and after
it the session is sunk. Review trigger: the appetite is exhausted
without the outcome — an agent filling a role operating from the
approved definition of that role, loaded at its point of work from an
approved source maintained by a defined process with its own check,
6 of 6 demonstrated in the running system — or feature authoring
surfaces work outside the no-gos' boundary, or the authority rules
that its standing direction did not cover this bet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-03 | update | Made by the PO role for the authority's go of 2026-09-03 on init-roles-availability, taken in the initiative-check decide step at the round cap on the authority's standing direction for the session, the lead-pm recording it; status draft pending the PO output check (form only — the decider is the authority). |
| 2 | 2026-09-03 | review | PO output check round 1 (judge: claude-fable-5-1 / screen prompt v6): six findings — the decider qualified into ambiguity (scenario 3; the bet stated once as the authority's, exercised through its standing direction and applied by the lead-pm); a second action in the decision sentence (scenario 1; ended at the bet, the state change carried in Consequences only); the load point stated "empty" against the initiative's "does not exist" (factual; corrected with the mechanism dropped); the architect's render mechanism restated in Alternative 2 (framing; the verdict cited instead); the scenario-4 exemption matter stated twice (framing; kept in Alternative 1 only); Consequence 4's cost a risk, not a price (scenario 4; priced as the session's work lost). Repaired. |
| 3 | 2026-09-03 | review | PO output check round 2 (judge: claude-fable-5-1 / screen prompt v6): three wobbly findings — Consequence 2's cost named the closure, not a price (scenario 4; priced as the screen verdict foreclosed, a real defect surfacing in feature authoring instead); the two open findings recounted three times (framing; the full account kept in §1, Alternative 1 and Consequence 2 refer to it); section pointers into the initiative numbered where its headings are not (minor; replaced with the section names). Repaired. |
| 4 | 2026-09-03 | review | Round 3, the cap (judge: claude-fable-5-1 / screen prompt v6): three wobbly findings, none confident, no uncovered defect — Consequence 4 read as restated mechanism; the reversibility trigger's "demonstrated in the running system" beyond the initiative's measure; Alternative 1 named as a fourth round rather than a hold for repair. Not repaired at the cap. |
| 4 | 2026-09-03 | state | `draft` → `checked`: the PM role's pass. Reasons: no finding was confident in any of three rounds and each round's wobbly set was different — churn on wording the criteria do not settle, not a defect the criteria name. The trigger's "demonstrated in the running system" is kept deliberately: it is the delivery-verified principle applied to the measure. |
