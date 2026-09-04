---
type: fitness-set
id: initiative-fitness
owner: product-authority
status: approved
approved: 2026-08-31
version: 4
created: 2026-08-28
updated: 2026-08-31
target-type: initiative
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: initiative

An initiative is the product-level problem artifact the PM role makes:
the framing, the measure, the appetite and no-gos, the feasibility and
usability attachments, and the decomposition. These scenarios are the
criteria set the
[initiative-check](../processes/initiative-check.md) process screens
an initiative against; the typedef says why that
screen is the check of record. Evaluated by the `cold-reviewer` role,
never executed.
The judge reads only the criteria set and the initiative; every fact a
scenario judges is one the initiative must carry. The judge's model
and prompt version are recorded with each round verdict.

## Scenarios

Scenario 1: the framing is complete and in the originator's words
  Given the Framing section
  When it is read
  Then it quotes the originator's own expression, states the problem
  taken to be worth solving and the outcome it serves, and names the
  contract the intent entered through

Scenario 2: the outcome has a measure, a current condition, and a target
  Given the For whom section
  When it is read
  Then it names who has the problem, one measure with its current
  condition, quantified, and its target, and the interaction types the
  outcome must hold on or "none" with a reason

Scenario 3: appetite bounded, no-gos reasoned
  Given the Appetite section
  When it is read
  Then it states a bound in time or capacity, and every no-go carries
  its reason

Scenario 4: the problem, not the solution
  Given the Framing, For whom, and Appetite sections
  When they are parsed for design or implementation choices
  Then no technology, structure, or interface form is named; an
  interaction type named is a what

Scenario 5: feasibility and usability attached or asked
  Given the Feasibility and usability section
  When it is read
  Then the solutions architect's verdict is present with reasons, and,
  where the For whom section names an interaction type, the designer's
  evidence or hypothesis is present or marked "not yet" with the ask
  that requests it

Scenario 6: decomposition attached or not yet
  Given the Decomposition section
  When it is read
  Then it names the Bounded Contexts touched, each relied-on
  contract's relationship kind, and the cross-context flow or "none"
  — or it is marked "not yet"

Scenario 7: one page
  Given the initiative alone
  When it is read in one sitting
  Then it holds at most 500 words outside the Document History (the
  typedef's rule) and a reader can say what the bet is — what is
  spent, on what, for which outcome — from the Framing, For whom, and
  Appetite sections alone

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — framing complete | "Is the originator quoted? Are problem, outcome, and contract each stated? Cite any missing." |
| 2 — measured outcome | "Who has the problem? Quote the one measure, its quantified current condition, its target, and the interaction types or 'none' with a reason; any absent = fail." |
| 3 — appetite and no-gos | "Is a bound in time or capacity stated? For each no-go, is a reason given? Cite any without." |
| 4 — no solution | "In the Framing, For whom, and Appetite sections, list every sentence that names a technology, structure, or interface form (an interaction type is not a form). Empty list = pass." |
| 5 — attachments | "Feasibility verdict present with reasons (absent = fail)? Where an interaction type is named, usability evidence or hypothesis present, or 'not yet' with an ask? Cite." |
| 6 — decomposition | "Contexts, relationship kinds, and flow-or-none present, or 'not yet'? Cite." |
| 7 — one page | "Word count outside the Document History at most 500? Can the bet — spend, problem, outcome — be stated from the Framing, For whom, and Appetite sections alone? Cite." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-28 | update | Authored with the initiative typedef as the check of record on the PM role's framing; one scenario per required section plus the no-solution and one-page rules. |
| 1 | 2026-08-28 | review | Screened: findings — scenario 4 failed every initiative with a decomposition; scenario 5 judged a fact the initiative did not carry; the carrying process unnamed. |
| 2 | 2026-08-28 | update | Repairs: scenario 4 scoped to §1–3; interaction types carried in §2 and read by scenarios 2 and 5; feasibility mandatory; the 500-word bound taken from the typedef; the pending process named. |
| 2 | 2026-08-28 | review | Re-screened: one finding — scenario 7's bound excluded the appetite the bet spends. |
| 3 | 2026-08-28 | update | Scenario 7 reads §1–3. |
| 3 | 2026-08-28 | review | Final screen (round 3): clean. |
| 4 | 2026-08-31 | update | Batch A: the carrying process authored and linked. |
| 4 | 2026-08-31 | state | draft → approved with batch A+B as one block (brief-032 ask 2, default accepted). |
| 4 | 2026-09-03 | review | Gap filed for the owner by the PM role, from the init-roles-availability screen (round 3, judge claude-fable-5-1): scenario 4 states no exemption for the originator's quoted words, so a quote naming a technology or form draws a wobbly finding on every initiative — init-skills-availability drew it too. The judge proposes exempting the originator's quoted words in scenario 4's Then. The owner decides; the set is unchanged until then. |
| 4 | 2026-09-04 | review | Owner's ruling on the gap filed 2026-09-03: no exemption — scenario 4 stands as written; the framer's wording changes instead, and the discovery conversation is to catch solution words before the frame step (bead filed). Gap closed. |
| 4 | 2026-09-04 | review | Gap filed for the owner by the PM role, from the init-request-routing screen (round 3, judge claude-fable-5-1): scenario 4 carries no reading for a no-go that names a structure in order to exclude it — the judge could not decide whether an exclusion names a structure. The PM role's reading at the bet: a no-go must name what it excludes, so exclusions are outside the rule; the owner's to confirm or amend. |
