---
type: fitness-set
id: acceptance-scenarios-fitness
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
target-type: acceptance-scenarios
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: acceptance scenarios

An acceptance scenario is a Gherkin scenario that states, as a
requirement, what counts as done for one behavior; a set of them is
what the PO role submits for a behavior (the acceptance scenarios
themselves are executable by the owning shop; this fitness set judges
their quality and is never executed). These scenarios are the criteria
set the [PO output check](../processes/po-output-check.md) screens a
submitted set against, alongside the framing (criterion `framing`).
Evaluated by the `cold-reviewer` role. The judge's model and prompt
version are recorded with each round verdict.
The judge reads only the criteria set, the framing, and the artifact;
every scenario therefore asks for what the artifact itself carries, and
a fact it must carry — a term's definition, a reference, a reason — is
what these scenarios make it carry. These scenarios stand in for the
pending acceptance-scenario typedef and are its first draft; the
typedef inherits them (the co-production statement and the tag's
content are what this set asks the typedef to carry).

## Scenarios

Scenario 1: each scenario is one observable behavior
  Given a scenario in the set
  When its Given/When/Then is read
  Then the When is one action or event, the Then an outcome observable
  in the running system, and no step names an implementation detail

Scenario 2: co-produced with the owning shop
  Given the set's statement of who contributed
  When it is read
  Then the owning Bounded Context shop is named as the source of the
  steps and edge cases, and, where the behavior has an interaction, the
  product designer role's usability acceptance criteria and the
  accessibility criteria are present (the lead-product-designer role's
  accountabilities; the experience principle `accessible-by-standard`)

Scenario 3: identity fields are present
  Given each scenario
  When its header is read
  Then it carries a tag naming the behavior and its Bounded Context and
  a hash field (whether the hash matches the text is a mechanical
  check to be filed as a lint, not this judge's)

Scenario 4: the named edges are covered
  Given the failure and boundary cases the framing or the set's stated
  shop contribution names
  When each is read against the set
  Then it is a scenario in the set or is marked out of scope with a
  reason

Scenario 5: interaction types are named
  Given a behavior a person or agent reaches through an interaction
  When the set is read
  Then it names the interaction types the behavior must hold on (the
  experience principle `core-task-parity`)

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — one observable behavior | "For each scenario: is the When one action, the Then observable in the running system, and no step implementation-specific? Cite any failing scenario." |
| 2 — co-produced | "Is the owning shop named as the source of steps and edge cases? Where the behavior has an interaction, are usability and accessibility criteria present? Cite or name the absence." |
| 3 — identity fields | "For each scenario: tag naming behavior and context present? hash field present? Cite any scenario without both." |
| 4 — named edges covered | "For each failure or boundary case the framing or the set's stated shop contribution names: cite the scenario or the out-of-scope note. Any uncovered = fail." |
| 5 — interaction types named | "Does the set name the interaction types the behavior must hold on? Cite the sentence or its absence." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the criteria set the PO output check screens acceptance-scenario sets against; rests on the lead-po role (co-production, hash, tag) and the experience principles (interaction types, usability criteria). |
| 1 | 2026-08-26 | review | Screened: findings — "usability criteria" alone where the principles ask for accessibility criteria and the designer role supplies usability ones; an attribution record no definition carries; a hash comparison a reading judge cannot make; edge cases the judge would invent. |
| 2 | 2026-08-26 | update | Repairs: usability and accessibility criteria both named with their sources; co-production stated as what the set must say; hash reduced to presence with the comparison filed as mechanical; edges bound to those the framing, brief, or shop names; typedef-draft status stated. |
| 2 | 2026-08-26 | review | Re-screened: findings — scenario 4 read the brief, which the screen does not load; scenario 2's sources lived only in the history. |
| 3 | 2026-08-26 | update | Repairs: edges bound to the framing and the set's own shop contribution; usability and accessibility criteria sourced in the Then; the hash lint marked to-be-filed. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every Then decidable from the criteria set, the framing, and the artifact; attributions accurate. |
