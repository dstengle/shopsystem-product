---
type: product-decision-record
id: pdr-2026-09-05-bet-typedef-rendering
status: draft
version: 1
date: 2026-09-05
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-05
updated: 2026-09-05
---

# Product decision record: the bet on init-typedef-rendering

## 1. Decision

The product authority takes the go on
[init-typedef-rendering](../initiatives/init-typedef-rendering.md),
betting the initiative's appetite — one working session of the lead
shop for the proof on the product decision record — on the
initiative's text as it stood at the initiative-check's round cap on
2026-09-05. The batch of the other 21 artifact types is not in this
bet: the initiative's Appetite makes it a second bet, sized after the
proof.

The authority's bet is the decision, under the `bet` right — the right
the product-decision-record typedef admits for the authority's go,
hold, or no-go on an initiative. The authority took it in person, in
one word, "Bet", at the decide step of the initiative-check (the
process that attaches feasibility and usability to an initiative,
screens it, and ends in the authority's bet), reading the cap review
and the initiative's Framing, For whom, and Appetite sections; the
lead-pm recorded it in the initiative's Document History (v9). The go
stands unless the authority reverses it by a cancellation under the
same right (§4).

The bet was taken at the round cap — the screen's third and last
round (judge claude-fable-5-1 / screen prompt v5) — with two findings
before the authority that the judge could not decide (wobbly) and none
it could (confident). The two: the first no-go, "any change to the
checking processes themselves", read as naming the processes rather
than the work it excludes (initiative fitness scenario 4; the gap in
that criterion's wording was filed 2026-09-04 in the initiative
fitness set's Document History); and "the fitness set's scenarios" in
the Framing, read as a structure word where a prior round had asked
for that gloss. Both stand unrepaired in the text of record; holding
them was the lead-pm's ruling at the cap, not part of the authority's
decision.

The design decision the bet rests on stood checked before it:
[adr-2026-09-05-typedef-rendering](adr-2026-09-05-typedef-rendering.md)
(v4) — an artifact type's typedef is its one hand-edited standard, and
its guideline and fitness set are produced from it.

## 2. Alternatives

- **Hold — a further screen round before the bet.** The authority
  could have held the bet and sent the initiative back for a fourth
  round on the two held readings. Declined: no confident finding stood
  at the cap, and the two held are readings the criteria do not
  settle — whether a no-go must name the work it excludes is an open
  gap in the initiative fitness set's wording, filed 2026-09-04 for
  the authority to rule on in that definition, and "the fitness set's
  scenarios" is the gloss a prior round asked for. A fourth round
  would have read the same two passages against the same criteria and
  settled nothing.
- **No-go — decline the initiative.** Declined: the gap is live — 0 of
  22 artifact types have one standard for their maker and their
  checker, so a change to any type's standard today reaches its
  guideline and its fitness set only by hand, and not reliably — and
  the solutions architect role's verdict in the initiative's
  Feasibility and usability section stands: feasible in one session,
  the product decision record's three documents already matching rule
  for rule and the compiler following an existing pattern.

## 3. Consequences

- The initiative moves `proposed` → `planned`: for the lead shop, the
  PO role authors its feature in the feature-authoring process and the
  backlog order places it. Cost: the appetite — one working session of
  the lead shop — is committed to this initiative and not available to
  other work.
- The bet is on the round-cap text with the two held findings (§1)
  unrepaired: for every later reader and check, that text is the text
  of record. Cost: a screen verdict on those two passages is foreclosed
  for this initiative — if either is a real defect, it is carried into
  feature authoring and found there rather than at the check of record.
- The initiative's two no-gos bind for the spent appetite — no change
  to the checking processes themselves, and no check that the standards
  of different types agree with each other: for the lead shop and any
  role that would take up that work, each is foreclosed for this
  initiative and needs a new decision to reopen. Cost: a check whose
  own definition turns out to fit the produced text badly has no remedy
  under this bet; it waits for a later request.
- The other 21 artifact types stay as they are: for their makers and
  checkers, the standard remains hand-written in up to three places
  until a second bet, sized after the proof, converts them as one
  batch. Cost: the initiative's measure stops at 1 of 22 under this
  bet, and the second bet is its own initiative-check and its own
  record.
- This record is the proof the appetite names: the PO role makes it
  from the maker's text produced from the product-decision-record
  typedef, and its check screens it from the checker's text produced
  from the same typedef. For whom: the PO role and the PM role at the
  check, and the initiative's measure, which counts the type once both
  have used the standard. Cost: the go stood on the lead-pm's state
  entry alone from the bet until this record was made, because the
  Appetite requires the record made after the build; and the check
  screens it for form only, the decider being the authority — a light
  first use for the checker's text, the risk the architect named.
  Forecloses: should this record fail its check, it binds nothing and
  the measure stays at 0 of 22 — the proof would not have been shown,
  whatever else the session built.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one. Before the
session is spent, the cost of reversal is that record. After it, the
session is sunk, and undoing what it built is the design decision's
own reversal, low in cost while one type is converted: the two
sections come out of the typedef, the guideline's and the fitness
set's own frontmatter and history come back from source control, and
the compiler is deleted (adr-2026-09-05-typedef-rendering §4). Review
triggers: the appetite is exhausted without the measure — the product
decision record's maker and checker working from one standard, each
having used it once, 0 → 1; feature work reaching outside the two
no-gos; this record failing its check on a criterion the typedef's
scenarios name; or the authority ruling that the two held readings
were defects it would not have bet on.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Made by the PO role for the authority's go of 2026-09-05 on init-typedef-rendering — "Bet", taken in person at the initiative-check decide step at the round cap, the lead-pm recording it (initiative v9) — from the maker's text `basis/guidelines/product-decision-record.md` (v7; `generated: true`, produced by `basis/tools/compile_typedef.py` from `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`); the record made after the build, as the initiative's Appetite requires. Before any check ran, the author applied the checker's text `basis/fitness/product-decision-record.fitness.md` (produced from the same source, the same digest) to this draft, each scenario read as Given/When/Then: scenario 1 (one decision) pass — §1's first sentence is the one go, the batch of 21 excluded from it; scenario 2 (the alternatives were real) pass — the hold and the no-go, each a choice the authority could have made, each with its reason; scenario 3 (decider and right) pass — `decided-by: product-authority`, `right: bet`, and §1 naming both; scenario 4 (consequences priced) pass — five consequences, each with what changes, for whom, and its cost or what it forecloses; scenario 5 (reversibility) pass — §4 states the cost before and after the session and four review triggers. Status draft pending the PO output check (form only — the decider is the authority). |
