---
type: fitness-set
id: adr-fitness
owner: product-authority
status: approved
approved: 2026-09-02
version: 1
created: 2026-09-02
updated: 2026-09-02
target-type: adr
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: adr

An adr is the solutions architect role's record of one architecture
decision and its reasons; the
[adr typedef](../artifacts/adr.md) defines the type. These scenarios
are the criteria set the
[adr-authoring](../processes/adr-authoring.md) process screens a
record against, alongside the architecture principle set (criterion
`principles`). Evaluated by the `cold-reviewer` role, never executed.
The judge's model and prompt version are recorded with each round
verdict. The judge reads only the criteria set, the architecture
principle set, and the artifact; every scenario therefore asks for
what the artifact itself carries — a fact it must carry is what these
scenarios make it carry. Whether the named role held the right it
exercised is the PM role's ruling at the decide step, not the judge's.

The record's parts: context, decision, and consequences follow
Nygard's architecture decision record form; considered options follow
MADR, carried inside Context per the typedef; decider, right, and
reversibility mirror the product-decision-record typedef's shop
additions; the principles-screen statement follows the solutions
architect role's conformance accountability.

## Scenarios

Scenario 1: one decision
  Given the record
  When its title and its decision statement are parsed
  Then the title names the decision in one line and the decision
  statement states exactly one decision, as a sentence a reader can
  act on

Scenario 2: the context carries the forces and the real options
  Given the record's context
  When it is read
  Then it states the forces and the pre-state with the evidence they
  rest on, and either names at least one option the deciding role
  could have chosen with the reason it was not, or states that no
  other option was real

Scenario 3: the decider and the right are named
  Given the record's statement of who decided
  When it is read
  Then it names the role that decided and the decision right it
  exercised, or the escalation that settled it

Scenario 4: consequences are priced
  Given the record's consequences
  When each consequence is read
  Then it names what changes, for whom, and what it costs or
  forecloses, and a consequence that bounds Bounded Context shops is
  stated as a bound

Scenario 5: reversibility is stated
  Given the record
  When a reader asks how hard the decision is to reverse
  Then the record says so and, for a decision it calls hard to
  reverse, names what would trigger revisiting it

Scenario 6: the principles screen is stated
  Given the record and the architecture principle set
  When the reader asks how the decision stands against the set
  Then the record states the screen's result — conformance, or the
  named principle it cannot satisfy with the escalation that carries
  the exception

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — one decision | "Quote the title and the decision sentence. Is the title one line naming the decision, and the sentence one decision, actionable? Any no = fail." |
| 2 — context with real options | "Does the context state forces and pre-state with evidence, and either one option with the reason against it or that none was real? Cite the passage or its absence." |
| 3 — decider and right named | "Does the record name the deciding role and the right exercised, or the escalation? Cite the sentence or its absence." |
| 4 — consequences priced | "For each consequence: what changes, for whom, at what cost? Is a bound on Bounded Context shops stated as one? Cite any consequence missing a part." |
| 5 — reversibility | "Does the record state how hard the decision is to reverse and, if hard, what would trigger revisiting it? Cite the sentence or its absence." |
| 6 — principles screen | "Does the record state the architecture-principles screen's result — conformance, or the named principle and its escalation? Cite the sentence or its absence." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Authored through the definition-chain-migration process alongside the adr typedef; scenarios 1–5 mirror the product-decision-record fitness set with the options criterion moved into Context per the typedef, scenario 6 projects the solutions architect role's conformance accountability. |
| 1 | 2026-09-02 | state | draft → approved by the owner with the chain (brief-033 ask 1). |
