---
type: quality-guideline
id: initiative-guideline
target-type: initiative
owner: product-authority
status: draft
version: 3
created: 2026-08-28
updated: 2026-08-28
---

# Guideline: initiative

**Voice principle.** Write the initiative for the authority who must
bet on it in one reading and for the PO role who must make features
from it with no one to ask: the problem in the originator's words, one
measure, a bound, what it will not do — and nothing about how.

**Highlights (the layer compiled into generating context):** the
originator quoted, the problem and outcome stated, the contract named
· one measure, its current condition quantified, its target · an
appetite in time or capacity; every no-go with a reason · no
technology, structure, or form · feasibility attached; usability attached or
asked · contexts, relationship kinds, and the cross-context flow, or
"not yet" · one page.

**Layers:** this guideline adds initiative rules on top of the
[base writing style](base-writing-style.md); the base always applies
and is never overridden. When rules conflict, an approved principle
beats the [initiative typedef](../artifacts/initiative.md), which beats
this guideline. Every rule feeds the
[initiative fitness set](../fitness/initiative.fitness.md), scored by
the cold reviewer in the `initiative-check` process (pending).

---

## Rules

**1. Quote the originator; state the problem, the outcome, the contract.**
Before: "Operators have asked for better visibility into failures."
After: "Originator (operator, 2026-08-20, through the operational
contract): 'I open every run to find the one that failed.' Problem:
failed runs are not distinguishable from the run list. Outcome: a
failed run is noticed within one glance."
*Test:* read the Framing section. *Criterion:* the originator's words
are quoted; the problem, the outcome, and the contract are each
stated. *Decision:* yes/no per initiative.
*Derived check:* judged — initiative fitness scenario 1.

**2. Who, one measure, a current condition, a target, the types.**
Before: "Success: operators are happier with the run list."
After: "For: operators. Measure: time from a run's failure to an
operator noticing it. Now: median 40 minutes. Target: under one
minute. Interaction types: cli, gui."
*Test:* read the For whom section. *Criterion:* who; exactly one
measure, its current condition quantified, its target stated; the
interaction types or "none" with a reason.
*Decision:* yes/no per initiative.
*Derived check:* judged — initiative fitness scenario 2.

**3. Bound the appetite; reason every no-go.**
Before: "We'll do what it takes; notifications are out of scope."
After: "Appetite: two weeks of the reporting shop. No-gos: notifying
on failure — a separate initiative (alerting) serves it; historical
failure analysis — no originator has asked."
*Test:* read the Appetite section. *Criterion:* a bound in time or
capacity is stated; every no-go carries its reason. *Decision:* yes/no
per initiative.
*Derived check:* judged — initiative fitness scenario 3.

**4. No solution.**
Before: "Add a status column backed by the failures table and a `--failed`
flag."
After: "The outcome holds on the command line and the graphical
interaction; how a failure becomes visible is the shops'."
*Test:* in the Framing, For whom, and Appetite sections, list every
sentence naming a technology, structure, or interface form.
*Criterion:* the list is empty; an interaction type named is a what. *Decision:* yes/no per initiative.
*Derived check:* judged — initiative fitness scenario 4.

**5. Attach feasibility; attach usability or ask.**
Before: "Feasibility: to be confirmed."
After: "Feasibility (architect, 2026-08-21): feasible within the
current stack; the run log already records failure. Usability: not yet
— ask to the product designer role, default 'a hypothesis stands until
the first user test'."
*Test:* read the Feasibility and usability section. *Criterion:* the
verdict with reasons is present; where §2 names an interaction type,
the usability evidence or hypothesis is present or marked "not yet"
with the ask that requests it. *Decision:* yes/no per
initiative.
*Derived check:* judged — initiative fitness scenario 5.

**6. Name the contexts and the flow, or "not yet".**
Before: "Touches reporting and maybe export."
After: "Decomposition (architect): reporting, export; contract
reporting → export: customer–supplier; cross-context flow: none — each
context reads the run log directly." or "Decomposition: not yet."
*Test:* read the Decomposition section. *Criterion:* contexts,
relationship kinds, and the flow or "none" are stated, or the section
says "not yet". *Decision:* yes/no per initiative.
*Derived check:* judged — initiative fitness scenario 6.

**7. One page.**
Before: "Background. The reporting area has grown over three years,
first as a nightly batch, then as an on-demand list; operators have
raised its failures in four retrospectives…" (four hundred words
before the problem).
After: "Operators cannot tell which of last night's runs failed
without opening each one." — the history cut; the whole initiative
within 500 words.
*Test:* count words outside the Document History; read the Framing,
For whom, and Appetite sections alone. *Criterion:* at most 500 words
(the typedef's rule); the bet — spend, problem, outcome — is statable
from those three sections. *Decision:*
yes/no per initiative.
*Derived check:* judged — initiative fitness scenario 7.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-28 | update | Authored with the initiative typedef; one rule per fitness scenario. |
| 1 | 2026-08-28 | review | Screened: findings — rule 2 stricter than its scenario (a source); rules 5 and 7 out of step with the repaired typedef; two stumbles. |
| 2 | 2026-08-28 | update | Repairs aligned to the typedef v2 and fitness v2. |
| 2 | 2026-08-28 | review | Re-screened: one finding — rule 7's bound; a description in place of a before/after. |
| 3 | 2026-08-28 | update | Rule 7 reads §1–3 with a prose before/after. |
| 3 | 2026-08-28 | review | Final screen (round 3): clean. |
