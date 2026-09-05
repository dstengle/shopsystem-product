---
type: fitness-set
id: product-decision-record-fitness
target-type: product-decision-record
judged: true
executable: false
judged-by: cold-reviewer
owner: product-authority
status: approved
approved: 2026-08-31
version: 7
created: 2026-08-26
updated: 2026-09-05
generated: true
generated-by: basis/tools/compile_typedef.py
source: basis/artifacts/product-decision-record.md
source-digest: sha256:d2e74320dabb
---

<!-- Generated from `basis/artifacts/product-decision-record.md` (its Fitness scenarios section) by `basis/tools/compile_typedef.py`; do not edit by hand — edit the typedef and re-render. -->

# Fitness set: product decision record

A product decision record is the PO role's record of one product-level
decision and its reasons. These scenarios are the criteria set the
[PO output check](../processes/po-output-check.md) screens a record
against, alongside the framing (criterion `framing`). **Judged by:**
`cold-reviewer`, never executed; the judge's model and prompt version
are recorded with each round verdict. The judge reads only the
criteria set, the framing, and the artifact; every scenario therefore
asks for what the artifact itself carries, and a fact it must carry —
a term's definition, a reference, a reason — is what these scenarios
make it carry.

The record's parts: decision and consequences follow Nygard's
architecture decision record form; considered alternatives follow
MADR; decider (from the roles' decision rights) and reversibility are
the shop's own additions — adopted and extended per
`external-standards-first`; whether the named role held the right it
exercised is the PM role's ruling at the decide step, not the judge's.

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
