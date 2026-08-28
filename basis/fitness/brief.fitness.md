---
type: fitness-set
id: brief-fitness
owner: product-authority
status: superseded
approved: 2026-08-26
version: 3
created: 2026-08-26
updated: 2026-08-28
target-type: brief
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: brief

A brief is the PO role's bounded statement of a problem and its scope
for a Bounded Context shop (the typedef is pending on this branch; the
frozen corpus on `main` is the reference). These scenarios are the
criteria set the [PO output check](../processes/po-output-check.md)
screens a brief against, alongside the PM role's framing, which is
always the criterion named `framing`. They are evaluated by the
`cold-reviewer` role, never executed — no step definitions exist or
will exist. The judge's model and prompt version are recorded with each
round verdict.
The judge reads only the criteria set, the framing, and the artifact;
every scenario therefore asks for what the artifact itself carries, and
a fact it must carry — a term's definition, a reference, a reason — is
what these scenarios make it carry. These scenarios stand in for the
pending typedef and are its first draft; the typedef inherits them.

## Scenarios

Scenario 1: declined scope carries its reason
  Given each statement the brief marks out of scope
  When it is read
  Then it carries the reason it is out of scope

Scenario 2: the problem, not the solution
  Given the brief's statement of what the shop is asked for
  When it is parsed for design or implementation choices
  Then it states the problem and the outcome and names no how — no
  technology, structure, or interface form the shop would otherwise
  choose; naming an interaction type the behavior must hold on is a
  what, not a form

Scenario 3: scope has an edge
  Given the pieces of work the framing or the brief itself names as
  neighbouring
  When each is read against the scope
  Then the brief says whether it is in or out, or names the rule that
  decides

Scenario 4: the shop can act from it alone
  Given the brief without its author present
  When the receiving shop reads it
  Then every term is defined in the brief or the framing, every
  referenced artifact is linked, and every question the framing or the brief
  itself raises is either answered or listed as open

Scenario 5: the first paragraph states the problem and the outcome
  Given the brief alone
  When the reader stops after the first paragraph
  Then the problem and the outcome are already stated (this set's
  proposal for the typedef, after the decision-brief form)

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — declined scope reasoned | "For each out-of-scope mark: is a reason stated? Cite any without one." |
| 2 — problem, not solution | "List every sentence that chooses a technology, structure, or interface form (an interaction type named is not a form). Empty list = pass." |
| 3 — scope has an edge | "For each neighbouring piece of work the framing or brief names: does the brief say in or out, or name the deciding rule? Cite." |
| 4 — actionable alone | "List undefined terms, unlinked references, and questions the framing or brief raises that are neither answered nor listed as open. Empty list = pass." |
| 5 — first paragraph | "Does paragraph 1 state the problem and the outcome? Quote it, or answer no." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the criteria set the PO output check screens briefs against; the brief typedef is pending, so scenarios rest on the lead-po role's accountabilities and the framing. |
| 1 | 2026-08-26 | review | Screened: findings — scenario 1 duplicated the process's `framing` criterion; scenario 4 cited the glossary the judge cannot read; scenario 5's title mismatched its Then; scenario 3 let the judge invent neighbours. |
| 2 | 2026-08-26 | update | Repairs: scenario 1 reduced to the residual (declined scope reasoned); terms defined in the brief or framing; neighbours bound to those the framing or brief names; scenario 5 retitled and sourced; the judge's inputs and the typedef-draft status stated in the intro. |
| 2 | 2026-08-26 | review | Re-screened: findings — scenario 5 cited lead-po for a rule it does not carry; scenario 4 let the judge pick the questions. |
| 3 | 2026-08-26 | update | Repairs: scenario 5 attributed to this set's proposal after the decision-brief form; questions bound to those the framing or brief raises; scenario 1's Then widened to any out-of-scope reason. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every Then decidable from the criteria set, the framing, and the artifact; attributions accurate. |
| 3 | 2026-08-26 | state | draft → approved by the owner. |
| 3 | 2026-08-28 | state | superseded — owner decision: shops receive their assigned scenarios, not briefs; the brief's content lives in the feature's narrative and the initiative. Kept as a record; not to be instantiated. |
