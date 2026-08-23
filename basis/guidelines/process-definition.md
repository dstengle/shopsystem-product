---
type: quality-guideline
id: process-definition-guideline
target-type: process-definition
owner: product-authority
status: approved
approved: 2026-08-23
version: 1
created: 2026-08-23
updated: 2026-08-23
---

# Guideline: process definition

**Voice principle.** Write for the runtime that must construct a
workflow from the steps and the reviewer who must connect every
outcome to its witness: every element either executes, routes,
witnesses, or declares a contract — explanation lives in body prose,
never inside a step.

**Highlights (the layer compiled into generating context):** every
outcome names its witness · prose inside a step only in `prompt` ·
every loop declares a labeled success exit, a cap, or both · a step
reads only what it lists — the declared list is the context load list ·
the result is the artifact, not a status.

**Layers:** this guideline adds process-definition rules on top of the
[base writing style](base-writing-style.md); the base always applies
and is never overridden. When rules conflict, an approved principle
beats the
[process-definition typedef](../artifacts/process-definition.md),
which beats this guideline.

---

## Rules

**1. Give every outcome a witness.**
Before: "O1. The review is high-quality."
After: "O1. Every decision is applied before the next exchange —
witnessed by the check on `apply`."
*Test:* read each outcome. *Criterion:* it names the step, check, or
branch that witnesses it, and that witness exists in the steps
section. *Decision:* yes/no per outcome.
*Derived check:* judged — scenario 2 of
[process-definition.fitness.md](../fitness/process-definition.fitness.md).

**2. Keep prose out of steps.**
Before: a step record carrying "This step is important because
reviewers often forget to check the register."
After: the sentence moved to body text before the steps section, or
into the step's `prompt` if the agent needs it.
*Test:* scan every step record. *Criterion:* prose appears only in
`prompt` fields; runtime steps carry `set`, `run`, or `branches` and
no sentences. *Decision:* yes/no per step.
*Derived check:* mechanical — the no-prose row of the typedef's
derived review checklist.

**3. Declare every loop's exits, labeled.**
Before: revise → review → revise with no cap and an unlabeled edge.
After: "failsafe exit: round >= 3 → park" and "success exit: clean →
approve" as labeled branch rows.
*Test:* trace every cycle in the flow. *Criterion:* each cycle carries
a labeled reached-state success exit, a round or budget cap, or both.
*Decision:* yes/no per cycle.
*Derived check:* judged — fitness scenario 3; mechanical presence in
the loop-exit row of the typedef checklist.

**4. Let a step read only what it lists.**
Before: a prompt telling the agent to "check the register and any
related records you find useful."
After: the register declared as an input; the prompt references only
declared inputs.
*Test:* compare each step's prompt, checks, and run template to its
declared inputs and outputs. *Criterion:* every reference resolves to
a declared name; the declared list is the step's context load list —
an undeclared load is a defect. *Decision:* yes/no per step.
*Derived check:* judged — fitness scenario 4.

**5. Return the artifact, not a status.**
Before: "result: report — a summary of what the run did."
After: "result: set — the principle-set the run produced."
*Test:* read the `result` declaration against the purpose. *Criterion:*
the run returns the artifact it exists to produce, or omits `result`
with outcomes that pin the run's value. *Decision:* yes/no per
process.
*Derived check:* judged — fitness scenario 5.

**6. Direct judgment with the guiding statement, not instructions.**
Before: "Guiding statement: first draft, then review, then ship."
After: "Guiding statement: everything binding lands in the governed
artifacts it changes; nothing binding lives only in the transcript."
*Test:* read the guiding statement. *Criterion:* it states a judgment
that applies across every step, never a sequence — sequences are
steps. *Decision:* yes/no per statement (vacuously pass when absent).
*Derived check:* judged — fitness scenario 6.

## Sources

Style-guide anatomy per the quality-guideline typedef; Deming's
operational definitions (test, criterion, decision per rule); the
external forms the process-definition typedef adopts (ISO/IEC/IEEE
24774 header, GitHub-Actions-shaped steps, CEL conditions, dual-exit
loops) — this guideline projects them into authoring rules; the before
examples are generic counter-examples, never drawn from this product's
history.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored as the process-definition meta-chain's guideline, with the existing basis processes as exemplars. |
| 1 | 2026-08-23 | state | draft → approved by the owner, with the exemplar screens' findings accepted as valid and their repairs directed. |
