---
type: fitness-set
id: product-decision-record-fitness
owner: product-authority
status: approved
approved: 2026-08-26
version: 3
created: 2026-08-26
updated: 2026-08-26
target-type: product-decision-record
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: product decision record

A product decision record is the PO role's record of one product-level
decision and its reasons (the typedef is pending on this branch; the
frozen corpus on `main` is the reference). These scenarios are the
criteria set the [PO output check](../processes/po-output-check.md)
screens a record against, alongside the framing (criterion `framing`).
Evaluated by the `cold-reviewer` role, never executed. The judge's
model and prompt version are recorded with each round verdict.
The judge reads only the criteria set, the framing, and the artifact;
every scenario therefore asks for what the artifact itself carries, and
a fact it must carry — a term's definition, a reference, a reason — is
what these scenarios make it carry. These scenarios stand in for the
pending typedef and are its first draft; the typedef inherits them.

The record's parts: decision and consequences follow Nygard's
architecture decision record form; considered alternatives follow
MADR; decider (from the roles' decision rights) and reversibility are
this set's proposal for the typedef — adopted and extended per
`external-standards-first`; whether the named role held the
right it exercised is the PM role's ruling at the decide step, not the
judge's.

## Scenarios

Scenario 1: one decision
  Given the record
  When its decision statement is parsed
  Then it states exactly one decision, as a sentence a reader can act
  on

Scenario 2: the alternatives were real
  Given the record's alternatives
  When each alternative is read
  Then at least one alternative is stated that the deciding role could
  have chosen, with the reason it was not

Scenario 3: the decider and the right are named
  Given the record's statement of who decided
  When it is read
  Then it names the role that decided and the decision right it
  exercised, or the escalation that settled it

Scenario 4: consequences are priced
  Given the record's consequences
  When each consequence is read
  Then it names what changes, for whom, and what it costs or forecloses

Scenario 5: reversibility is stated
  Given the record
  When a reader asks how hard the decision is to reverse
  Then the record says so and, for a decision it calls hard to reverse,
  names what would trigger revisiting it

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — one decision | "Quote the decision sentence. Is it one decision, actionable? Any no = fail." |
| 2 — real alternatives | "Is at least one alternative stated that the deciding role could have chosen, with the reason against it? Cite it or its absence." |
| 3 — decider and right named | "Does the record name the deciding role and the right exercised, or the escalation? Cite the sentence or its absence." |
| 4 — consequences priced | "For each consequence: what changes, for whom, at what cost? Cite any consequence missing one." |
| 5 — reversibility | "Does the record state how hard the decision is to reverse and, if hard, what would trigger revisiting it? Cite the sentence or its absence." |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the criteria set the PO output check screens product decision records against; the typedef is pending. Scenario 3 rests on the four approved roles' decision rights. |
| 1 | 2026-08-26 | review | Screened: findings — scenario 3 misattributed scope to the PO role, restated the roles' decision rights in a second home, and asked the judge for the PM's domain ruling; the record's parts had no named source; scenario 2 named the wrong actor. |
| 2 | 2026-08-26 | update | Repairs: scenario 3 is a presence check (role and right named, or escalation); the ADR form named as the source of the parts; the deciding role is the actor of alternatives; the framing clause dropped from scenario 1; intro states the judge's inputs. |
| 2 | 2026-08-26 | review | Re-screened: findings — the ADR form was credited with parts it does not carry. |
| 3 | 2026-08-26 | update | Repairs: decision and consequences credited to Nygard, alternatives to MADR, decider and reversibility marked as this set's proposal. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every Then decidable from the criteria set, the framing, and the artifact; attributions accurate. |
| 3 | 2026-08-26 | state | draft → approved by the owner. |
