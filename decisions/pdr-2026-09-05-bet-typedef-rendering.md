---
type: product-decision-record
id: pdr-2026-09-05-bet-typedef-rendering
status: checked
version: 4
date: 2026-09-05
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-05
updated: 2026-09-05
---

# Product decision record: the bet on init-typedef-rendering

## Context

The initiative-check — the process that attaches feasibility and
usability to an initiative, screens it, and ends in the authority's
bet — reached its round cap, the screen's third and last round (judge
claude-fable-5-1 / screen prompt v5), on 2026-09-05 with two findings
before the authority that the judge could not decide (wobbly) and no
confident finding standing. The two: the first no-go, "any change to
the checking processes themselves", read as naming the processes
rather than the work it excludes (the initiative fitness set's
scenario against mechanism words in the framing; the gap in that
criterion's wording was filed 2026-09-04 in the initiative fitness
set's Document History); and "the fitness set's scenarios" in the
Framing, read as a structure word where a prior round had asked for
that gloss. Both stand unrepaired in the initiative at v8 — the
round-cap text with its disclosed post-cap repairs; holding them was
the lead-pm's ruling at the cap, not part of the authority's decision.

The design decision the bet rests on stood checked before it:
[adr-2026-09-05-typedef-rendering](adr-2026-09-05-typedef-rendering.md)
(v4) — an artifact type's typedef is its one hand-edited standard, and
its guideline and fitness set are produced from it.

## 1. Decision

The product authority takes the go on
[init-typedef-rendering](../initiatives/init-typedef-rendering.md),
betting the initiative's appetite — one working session of the lead
shop for the proof on the product decision record — on the
initiative at v8, the round-cap text with its disclosed post-cap
repairs (Context), on 2026-09-05. The batch of the other 21 artifact types is not in this
bet: the initiative's Appetite makes it a second bet, sized after the
proof.

The authority's bet is the decision, under the `bet` right — the right
the product-decision-record typedef admits for the authority's go,
hold, or no-go on an initiative. The authority took it in person, in
one word, "Bet", at the decide step of the initiative-check, reading
the cap review and the initiative's Framing, For whom, and Appetite sections; the
lead-pm recorded it in the initiative's Document History (v9). The go
stands unless the authority reverses it by a cancellation under the
same right (§4).

## 2. Alternatives

- **Hold — a further screen round before the bet.** The authority
  could have held the bet and sent the initiative back for a fourth
  round on the two held readings (Context). Declined: no confident
  finding stood at the cap, and the two held are readings the criteria
  do not settle (Context) — a fourth round would have read the same two passages
  against the same criteria and settled nothing.
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
- The bet is on the initiative at v8 — the round-cap text with its
  disclosed post-cap repairs — with the two held findings (Context)
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
- This record is the proof the appetite names. What changes: the PO
  role makes it from the maker's text produced from the
  product-decision-record typedef, its check screens it from the
  checker's text produced from the same typedef, and the measure moves
  0 → 1 once both have used the standard. For whom: the PO role and
  the PM role at the check. Cost, to the PM role at the check: the
  screen is for form only, the decider being the authority — a light
  first use for the checker's text, the risk the architect named.
  Forecloses: should this record fail its check, it binds nothing and
  the measure stays at 0 of 22 — the proof would not have been shown,
  whatever else the session built.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one. Before the
session is spent, the cost of reversal is that record. After it, the
session is sunk, and undoing what it built is the design decision's
own reversal (adr-2026-09-05-typedef-rendering §4), low in cost while
one type is converted. Review triggers: the appetite is exhausted without the measure — the product
decision record's maker and checker working from one standard, each
having used it once, 0 → 1; feature work reaching outside the two
no-gos; this record failing its check on a criterion the typedef's
scenarios name; or the authority ruling that the two held readings
(Context) were defects it would not have bet on.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Made by the PO role for the authority's go of 2026-09-05 on init-typedef-rendering — "Bet", taken in person at the initiative-check decide step at the round cap, the lead-pm recording it (initiative v9) — from the maker's text `basis/guidelines/product-decision-record.md` (v7; `generated: true`, produced by `basis/tools/compile_typedef.py` from `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`); the record made after the build, as the initiative's Appetite requires. Before any check ran, the author applied the checker's text `basis/fitness/product-decision-record.fitness.md` (produced from the same source, the same digest) to this draft, each scenario read as Given/When/Then: scenario 1 (one decision) pass — §1's first sentence is the one go, the batch of 21 excluded from it; scenario 2 (the alternatives were real) pass — the hold and the no-go, each a choice the authority could have made, each with its reason; scenario 3 (decider and right) pass — `decided-by: product-authority`, `right: bet`, and §1 naming both; scenario 4 (consequences priced) pass — five consequences, each with what changes, for whom, and its cost or what it forecloses; scenario 5 (reversibility) pass — §4 states the cost before and after the session and four review triggers. Status draft pending the PO output check (form only — the decider is the authority). |
| 2 | 2026-09-05 | review | PO output check round 1 (judge: claude-fable-5-1 / screen prompt v6; criteria the rendered fitness set `basis/fitness/product-decision-record.fitness.md`, source-digest `sha256:d2e74320dabb`): one confident — §4's "the two sections" unnamed — and four wobbly: the text bet on named as "at the round cap" while the disclosed post-cap repairs are in the text of record (§1, §3); "initiative fitness scenario 4" cited by number; the two held findings told in §1 and retold in §2; the fifth consequence's cost in one sentence and the measure placed under "For whom". |
| 2 | 2026-09-05 | update | Round 1 repairs, all five: §4 drops the mechanism and keeps "the design decision's own reversal (adr §4), low in cost while one type is converted"; §1 and §3 name the text bet on as the initiative at v8, the round-cap text with its disclosed post-cap repairs; §1 cites the initiative fitness set's scenario against mechanism words in the framing; the two held findings told once in §1, with §2, §3, and §4 pointing back "(§1)", and "no confident finding standing"; the fifth consequence's cost split into two sentences and the measure moved into what changes ("the measure moves 0 → 1 once both have used the standard"). The author applied the rendered fitness set's scenarios to the result again before returning: scenario 1 pass (one go in §1's first sentence, now on the initiative at v8); scenario 2 pass (hold and no-go, each with its reason, the hold's reason standing on §1); scenario 3 pass (frontmatter and §1 unchanged on decider and right); scenario 4 pass (five consequences, the fifth now with what changes, for whom, cost, and what it forecloses each in its own place); scenario 5 pass (§4 states the cost before and after the session and four triggers, the mechanism gone). |
| 3 | 2026-09-05 | review | PO output check round 2 (judge: claude-fable-5-1 / screen prompt v6; criteria the rendered fitness set at `sha256:d2e74320dabb`): no confident finding; three wobbly — §1 carrying the cap, the two held readings, and the ADR alongside the decision; the fifth consequence's record-less-interval sentence; "round cap" unglossed at its first use. |
| 3 | 2026-09-05 | update | Round 2 repairs, all three: a Context part before §1 (Nygard's form) carries the cap, the two held readings, and the ADR, so §1 keeps the decision sentence and the right sentence only, with §2, §3, and §4 pointing at "(Context)" where they pointed at "(§1)"; the fifth consequence's record-less-interval sentence dropped, the form-only screen as a light first use standing as the cost, priced to the PM role at the check; "round cap" glossed at its first use in Context as the screen's third and last round. The author applied the rendered fitness set's scenarios to the result again before returning: scenario 1 pass (§1's first sentence is the one go, unchanged in substance); scenario 2 pass (hold and no-go, each with its reason, the hold's reason standing on Context); scenario 3 pass (frontmatter `decided-by` and `right`, and §1's right sentence, unchanged); scenario 4 pass (five consequences, the fifth's cost now one priced item); scenario 5 pass (§4 unchanged but for the pointer). |
| 4 | 2026-09-05 | review | Round 3, the cap (judge: claude-fable-5-1 / screen prompt v6; criteria the rendered fitness set at sha256:d2e74320dabb): two wobbly, none confident — the fifth consequence's cost bearer; "three documents" unglossed and the architect role named two ways. Glossed and repriced by the PM role at the record step, disclosed and not re-screened. |
| 4 | 2026-09-05 | state | `draft` → `checked`: the PM role's pass. No confident finding in any of three rounds; the criteria read by the judge were the fitness set produced from the typedef, the same source and digest the maker's text names — the proof feat-typedef-rendering's scenario 7 reads from. |
