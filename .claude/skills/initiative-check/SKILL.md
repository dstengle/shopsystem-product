---
name: initiative-check
description: "Take a proposed initiative to the bet: the solutions architect and product\
  \ designer roles attach the sections they own, the cold reviewer screens the whole\
  \ against the initiative fitness set \u2014 the check of record on the PM role's\
  \ framing \u2014 and the authority decides, from the verdict, whether to spend the\
  \ appetite. Use when a proposed initiative needs its feasibility, decomposition,\
  \ and usability attached, the check of record run, and the authority's bet taken."
type: skill
id: initiative-check-skill
status: approved
created: 2026-08-31
updated: 2026-09-02
generated: true
generated-by: basis/tools/compile_process.py
derived-from: initiative-check-process
source: basis/processes/initiative-check.md
source-digest: sha256:48e0471c65eb
activation: model-judged
promotion: experiment-local
---

# Initiative check (compiled from `initiative-check-process`)

Take a proposed initiative to the bet: the solutions architect and product designer roles attach the sections they own, the cold reviewer screens the whole against the initiative fitness set — the check of record on the PM role's framing — and the authority decides, from the verdict, whether to spend the appetite.

**The bet is taken on the screen's verdict and the initiative's own first three sections, never on advocacy; a finding in another role's attachment is that role's to answer, not the reviser's to rewrite.**

Result of a run: `initiative` (string).

```mermaid
flowchart TD
  attach_architecture(["Attach feasibility and decomposition — agent: lead-solutions-architect<br/>in — initiative: string, contracts: string, repository: string<br/>out — initiative: string"])
  attach_usability(["Attach usability evidence — agent: lead-product-designer<br/>in — initiative: string, experience_principles: string, core_tasks: string<br/>out — initiative: string"])
  screen(["Screen against the fitness set — agent: cold-reviewer<br/>in — initiative: string, criteria_path: string<br/>out — review: screen-review, judge_stamp: string"])
  log_round["Record the round — runtime<br/>in — review: screen-review, round_log: screen-review[], judge_stamp: string, judge_log: string[]<br/>sets — round_log: screen-review[], judge_log: string[]"]
  route_screen{"Route on the screen<br/>in — review: screen-review, round: integer, round_cap: integer"}
  revise(["Revise the initiative — agent: lead-pm<br/>in — initiative: string, review: screen-review, ask: ask<br/>out — initiative: string"])
  advance_round["Advance the round — runtime<br/>in — round: integer<br/>sets — round: integer"]
  decide[["Take the bet — human: product-authority<br/>in — review: screen-review, round_log: screen-review[], initiative: string<br/>out — bet: string, reasons: string"]]
  record(["Record the bet — agent: lead-pm<br/>in — initiative: string, bet: string, reasons: string, round_log: screen-review[], judge_log: string[]<br/>out — initiative: string"])
  __end(("end<br/>result — initiative: string"))
  __start(("start")) --> attach_architecture
  attach_architecture --> attach_usability
  attach_usability --> screen
  screen --> log_round
  log_round --> route_screen
  route_screen -->|success exit: clean| decide
  route_screen -->|definition exit: every finding is uncovered — nothing a repair can reach| decide
  route_screen -->|failsafe exit: round >= round_cap — decide with findings open| decide
  route_screen -->|else| revise
  revise --> advance_round
  advance_round --> screen
  decide --> record
  record --> __end
```

## attach-architecture — Attach feasibility and decomposition

Run by an agent in role `lead-solutions-architect`. reads: initiative, contracts, repository · writes: initiative.
- then: `attach-usability`

Prompt:

```text
Read the initiative. Write into its Decomposition section the
Bounded Contexts it touches, the relationship kind of each
contract between them it relies on, and the cross-context flow —
the saga or process manager that will carry it, or "none" when
the contexts need no flow between them. Write into its
Feasibility and usability section your feasibility verdict with
its reasons. Judge from the contracts at contracts and the
feature repository at repository — your role's admissible
evidence, never a context's internals. Infeasible is a verdict:
give it with reasons rather than withholding one. Return the
initiative.
```

## attach-usability — Attach usability evidence

Run by an agent in role `lead-product-designer`. reads: initiative, experience_principles, core_tasks · writes: initiative.
- then: `screen`

Prompt:

```text
Read the initiative. Where its For whom section names an
interaction type, write into the Feasibility and usability
section the usability evidence for the outcome on those types,
or the hypothesis it stands on, or "not yet" with the text of
the ask that requests it — judged against the experience
principle set at experience_principles and the core-task list at
core_tasks, your role's standard. Where
the For whom section says "none", write that no usability
attachment is due, with the section's reason. Return the
initiative.
```

## screen — Screen against the fitness set

Run by an agent in role `cold-reviewer` (fresh context every run). reads: initiative, criteria_path · writes: review, judge_stamp.
- then: `log-round`

Prompt:

```text
State, as judge_stamp, the model and prompt version you judge
as. Read the criteria set at criteria_path and the initiative at
initiative — nothing else. Judge the initiative against every
scenario. Report every finding with the criterion it fails by
name, the quoted text, the change, and whether you could decide
it (confident) or not (wobbly); for a wobbly finding quote the
whole passage, since the authority decides from the review. A
defect no criterion names is a finding with criterion
"uncovered". Verdict "clean" only if there are no findings;
otherwise "findings" with the top three changes.
```

## log-round — Record the round

Run by the runtime — no agent, no prose. reads: review, round_log, judge_stamp, judge_log · writes: round_log, judge_log.

```yaml
set:
  round_log: round_log + [review]
  judge_log: judge_log + [judge_stamp]
next: route-screen
```

## route-screen — Route on the screen

Run by the runtime — no agent, no prose. reads: review, round, round_cap · writes: —.

```yaml
branches:
- label: 'success exit: clean'
  when: review.verdict == "clean"
  next: decide
- label: "definition exit: every finding is uncovered \u2014 nothing a repair can\
    \ reach"
  when: size(review.findings) > 0 && review.findings.all(f, f.criterion == "uncovered")
  next: decide
- label: "failsafe exit: round >= round_cap \u2014 decide with findings open"
  when: round >= round_cap
  next: decide
- else: revise
```

## revise — Revise the initiative

Run by an agent in role `lead-pm`. reads: initiative, review, ask · writes: initiative.
- may ask: `lead-solutions-architect`, `lead-product-designer` — return an `ask` (with default and checkpoint) in place of outputs; at most one per run.
- then: `advance-round`

Prompt:

```text
Assist step. Repair every finding whose criterion is named and
whose passage the PM role owns — the Framing, For whom,
Appetite, and Features sections. A finding in the Feasibility
and usability or Decomposition sections is another role's
attachment: return an ask to the role that owns it — the
solutions architect for feasibility and decomposition, the
product designer for usability — with the question, the default
you will apply if unanswered, and a checkpoint of the repairs
made so far; never rewrite another role's verdict. Leave
findings marked "uncovered" as they are — they are the decide
step's. On the first pass ask is absent; if it carries an answer
or resolved defaulted, apply it and finish the repairs.
```

## advance-round — Advance the round

Run by the runtime — no agent, no prose. reads: round · writes: round.

```yaml
set:
  round: round + 1
next: screen
```

## decide — Take the bet

Run by a human holding role `product-authority`. reads: review, round_log, initiative · writes: bet, reasons.
- then: `record`

Prompt:

```text
From the final review, the round log, and the initiative's
Framing, For whom, and Appetite sections, take the go/no-go on
spending the appetite. "bet": spend it — the initiative becomes
planned and features are made from it; available when the
screen is clean, or when its only findings are uncovered and
you judge none of them needs a criterion — say so in the
reasons. An initiative still failing a named criterion at the
round cap cannot be bet on — the typedef's commitment: it stays
proposed with the criterion named. "hold": it stays proposed —
say what would change your mind. "cancel": with the reason —
the record of the decline survives. Record your reasons.
```

## record — Record the bet

Run by an agent in role `lead-pm`. reads: initiative, bet, reasons, round_log, judge_log · writes: initiative.
- then: `end`

Prompt:

```text
Assist step. Write into the initiative's Document History one
review entry per round with its verdict and, from judge_log,
the screening judge's model and prompt version — the record the
fitness set promises — then a state entry
carrying the decision and its reasons. Set the status: "planned"
on bet, written only over "proposed"; leave "proposed" on hold;
"cancelled" on cancel with the reason. On bet or cancel, the typedef requires a product
decision record: state in the entry that the record is the PO
role's to make and the PO output check screens it, and that the
entry links it once made. Return the initiative.
```
