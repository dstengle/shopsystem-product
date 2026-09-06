---
type: product-decision-record
id: pdr-2026-09-06-bet-role-decisions
status: checked
version: 3
date: 2026-09-06
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-06
updated: 2026-09-06
---

# Product decision record: the bet on init-role-decisions

## Context

The initiative-check — the process that attaches feasibility and
usability to an initiative, screens it once, allows one revise, and
ends in the authority's bet — reached its decide step on 2026-09-06
with two findings held for the authority, because neither is the
lead-pm's to repair: the architect's one-session verdict resting on
"the request-routing precedent" — an earlier change the shop made in
one session, named in the initiative's Feasibility and usability
section as the reason but not described there, so a reader of the
initiative alone cannot check it; and the 500-word cap's split (the
architect's D2) — whether the initiative typedef's word bound divides
between the framing sections and the attachments, or the full offer
lives outside it. At the bet the authority ruled the cap soft, with
20% variance, and left the attachments' home as the checked design
decision's *first candidate* — the first of the three questions that
decision names as needing a record of its own: whether the
initiative's cap splits, or the full attachment stands outside it.
That ruling is recorded in the initiative's Document History (v8);
its home is the initiative typedef, the authority's own, not this
record.

The design decision the bet rests on stood checked before it:
[adr-2026-09-05-role-offer](adr-2026-09-05-role-offer.md) (v3) — a
role's offer on attaching to an initiative is one data type the attach
step outputs, whichever role attaches. The authority's review before
the bet (initiative v7) bounded what that offer carries at the bet:
the verdict with its reasons, the architecture decisions required, the
risks, the unknowns, the evidence — the architect's work list is not
part of it, and implementation guidance is a separate artifact, being
made through req-2026-09-06-implementation-guidance, not this
initiative's feature.

## 1. Decision

The product authority takes the go on
[init-role-decisions](../initiatives/init-role-decisions.md), betting
the initiative's appetite — one working session of the lead shop — on
the initiative at v8, the text after the one screen and the one revise
with the two held findings unrepaired (Context), on 2026-09-06.

The authority's bet is the decision, under the `bet` right — the right
the product-decision-record typedef admits for the authority's go,
hold, or no-go on an initiative. The authority took it in person, as
"bet for init-role-decisions", at the decide step of the
initiative-check, reading the initiative's Framing, For whom, and
Appetite sections and the two held findings; the lead-pm recorded it
in the initiative's Document History (v8). The go stands unless the
authority reverses it by a cancellation under the same right (§4).

## 2. Alternatives

- **Hold — for the cap's split to be ruled first.** The authority
  could have held the bet until the 500-word cap's split (Context) had
  a record, since the architect named it as a decision the bet depends
  on. Declined: the authority ruled the cap soft with 20% variance at
  the bet, and the attachments' home stands as the checked design
  decision's first candidate (Context) — so nothing the appetite
  spends waited on it.
- **No-go — decline the initiative.** Declined: the gap is live — 0 of
  4 role definitions name the decisions the role owns, so the lead-pm
  supplies the offer's shape by hand each time — and the two
  attachments this check produced, each made from the step's own
  prompt with nothing added by the lead-pm, show the roles can offer
  it unasked. The change is the definition, not the capability.

## 3. Consequences

- The initiative moves `proposed` → `planned`: for the lead shop, the
  PO role authors its feature in the feature-authoring process and the
  backlog order places it. Cost: the appetite — one working session of
  the lead shop — is committed to this initiative and not available to
  other work.
- The bet is on the initiative at v8 with the architect's precedent
  reading unrepaired (Context): for every later reader and check, a
  one-session verdict whose reason the initiative does not carry is
  the text of record. Cost: a screen verdict on that passage is
  foreclosed for this initiative — if the precedent does not hold, the
  session runs over and that is found in the session, not at the check
  of record.
- The attachments' home stays unrecorded under this bet: for the
  attaching roles, the full offer keeps landing in a Document History
  row, and the authority reads it there at the bet — the reading form
  the designer's R4 names as unobserved. The cap ruled soft with 20%
  variance reaches the initiative typedef and its fitness set by the
  authority's own amendment, outside this appetite. Cost: until the
  first candidate has its record, every initiative with two
  attachments repeats this form, and the cold reviewer reads the word
  bound as the typedef states it.
- The initiative's two no-gos bind for the spent appetite — the
  step-communication request stays its own request, and the bet's
  owner and subject are unchanged: for the lead shop and any role that
  would take up that work, each is foreclosed for this initiative and
  needs a new decision to reopen. Cost: a change to how an agent's
  instruction is assembled, should the offer's shape turn out to need
  one, has no remedy under this bet; it waits for that request.
- The measure's count starts now, and the initiative cannot close
  until four observations exist — each role seen offering on the
  decisions its definition names, at its own step — across steps the
  appetite does not contain: for the four roles and the authority as
  the role-definition typedef's owner. Cost: the initiative-check has
  an attach step for two roles only, so the PM and PO observations
  come at their own steps, and nothing counts done until each role is
  observed there — the session's appetite may close before the count
  does.
- The offer at the bet is bounded to the authority's five parts
  (Context): for the architect role, which authors the data type, and
  the designer role, which screens its field names; the work list and
  implementation guidance are outside the type. Cost: the
  implementation-guidance artifact is a second request with its own
  route and record, not this initiative's feature; work that reaches
  for it inside this appetite is out of scope.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one. Before the
session is spent, the cost of reversal is that record. After it, the
session is sunk, and undoing what it built is the design decision's
own reversal (adr-2026-09-05-role-offer §4): low while the type stands
alone, hard once the four role definitions, the role-definition
typedef's fitness set, and the initiative-check reference it. Review
triggers: the appetite is exhausted without the measure — any role
definition still not naming the decisions it owns, or a role observed
at its step not offering on them unasked; feature work reaching
outside the two no-gos; the first candidate's record moving the
offer's rendering out of the initiative; a role whose domain the five
parts cannot carry; or the authority ruling that the held precedent
reading (Context) was a defect it would not have bet on.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Made by the PO role for the authority's go of 2026-09-06 on init-role-decisions — "bet for init-role-decisions", taken in person at the initiative-check decide step after the one screen and the one revise, the lead-pm recording it (initiative v8) — from the maker's text `basis/guidelines/product-decision-record.md` (v7; `generated: true`, produced by `basis/tools/compile_typedef.py` from `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`), layered on `basis/guidelines/base-writing-style.md` (v2). Before any check ran, the author applied the checker's text `basis/fitness/product-decision-record.fitness.md` (produced from the same source, the same digest) to this draft, each scenario read as Given/When/Then: scenario 1 (one decision) pass — §1's first sentence is the one go; the cap ruling taken at the same step is in Context with its home named as the initiative typedef, not a second decision here; scenario 2 (the alternatives were real) pass — the hold and the no-go, each a choice the authority could have made, each with its reason; scenario 3 (decider and right) pass — `decided-by: product-authority`, `right: bet`, and §1 naming both; scenario 4 (consequences priced) pass — six consequences, each with what changes, for whom, and its cost or what it forecloses; scenario 5 (reversibility) pass — §4 states the cost before and after the session, the threshold at which reversal turns hard, and five review triggers. Status draft pending the PO output check (form only — the decider is the authority). |
| 1 | 2026-09-06 | review | PO output check, the one screen (judge: claude-fable-5-1 / screen prompt v6; criteria the produced fitness set `basis/fitness/product-decision-record.fitness.md`, source `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`): one confident — "first candidate" undefined at its first use in Context; two wobbly, ruled by the lead-pm — Context's first paragraph carrying the screen's tally (judge stamp, counts, "repaired all six") alongside the two held findings; the measure consequence's first clause restating the measure rather than what the go changes. |
| 2 | 2026-09-06 | update | The one revise, all three: "first candidate" defined at its first use in Context — the attachments' home the checked ADR names as the first of three questions needing a record of its own, the initiative's cap splitting or the full attachment standing outside it; the screen's tally cut from Context's first paragraph, the two held findings and why they were held kept; the measure consequence's first clause now states what the go changes — the count starts now, and the initiative cannot close until four observations exist across steps the appetite does not contain. The author applied the produced fitness set's scenarios to the result again before returning: scenario 1 pass (§1's first sentence is the one go, unchanged); scenario 2 pass (hold and no-go, each with its reason, the hold's reason standing on Context's definition of the first candidate); scenario 3 pass (frontmatter and §1 unchanged on decider and right); scenario 4 pass (six consequences, the fifth now opening with what changes, its for-whom and cost unchanged); scenario 5 pass (§4 unchanged). |
| 3 | 2026-09-06 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise — the confident finding (a term before its explanation) repaired, the two wobbly ruled; the criteria the judge read were the fitness set produced from the typedef, the same source and digest the maker's text names. |
