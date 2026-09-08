---
name: feature-authoring
description: 'Author one feature from a planned initiative and take it through its
  check: the PO role writes it alone from the initiative''s framing, the product designer
  and solutions architect roles add the criteria that ride on its scenarios, and the
  PO output check sets its status. Use when a planned initiative needs one more feature
  authored, the designer''s and architect''s criteria added, and the check run.'
type: skill
id: feature-authoring-skill
status: approved
created: 2026-08-31
updated: 2026-09-08
generated: true
generated-by: basis/tools/compile_process.py
derived-from: feature-authoring-process
source: basis/processes/feature-authoring.md
source-digest: sha256:115b9f647309
activation: model-judged
promotion: experiment-local
hold-after: P7D
---

# Feature authoring (compiled from `feature-authoring-process`)

Author one feature from a planned initiative and take it through its check: the PO role writes it alone from the initiative's framing, the product designer and solutions architect roles add the criteria that ride on its scenarios, and the PO output check sets its status.

**One feature per run, authored alone: scope and wording are the PO role's; the criteria ride on the scenarios; the check, not the author, sets the status. Conflicts with behavior already specified are the repository sweep's to catch at assignment, never a question to a shop during authoring.**

Result of a run: `artifact` (string).

```mermaid
flowchart TD
  draft(["Draft the feature — agent: lead-po<br/>in — initiative: string, repository: string<br/>out — artifact: string, initiative: string"])
  add_usability(["Add the designer's criteria — agent: lead-product-designer<br/>in — artifact: string, initiative: string, experience_principles: string, core_tasks: string<br/>out — artifact: string"])
  add_constraints(["Add the architect's constraints — agent: lead-solutions-architect<br/>in — artifact: string, decomposition: string<br/>out — artifact: string"])
  prepare["Name the framing for the check — runtime<br/>in — initiative: string<br/>sets — framing: string"]
  check{{"Check the feature — sub-process: po-output-check-process<br/>in — artifact: string, framing: string, criteria_path: string<br/>out — decision: check-decision"}}
  __end(("end<br/>result — artifact: string"))
  __start(("start")) --> draft
  draft --> add_usability
  add_usability --> add_constraints
  add_constraints --> prepare
  prepare --> check
  check --> __end
```

## draft — Draft the feature

Run by an agent in role `lead-po`. reads: initiative, repository · writes: artifact, initiative.
- then: `add-usability`

Prompt:

```text
From the initiative's Framing and For whom, write one feature
into repository, per its typedef. Feature line and narrative:
the framing's words. Scenarios: at most ten, steps included,
one line each, tagged @feature: and @hash:. Contributors:
owning shop per scenario from the Decomposition; each
contributor's criteria one line. Interaction types: For whom's
types, or "none" with reason. Edges: at most ten rows, from
the framing's cases, covered or excluded with reason. One
Document History row. Author alone, no shop asked. Status
draft; link the initiative; add the id to its Features
section. A returned feature already listed: revise in place —
id stays, a changed scenario is a new hash, no duplicate.
Return the feature's path.

Return each declared output on its own line as `<name>: <value>` — artifact, initiative — a list as a JSON array, a value with line breaks as a JSON string; these lines close your reply.

Do not use these words: ratif, disposition, rebaseline bill, surface, seat
```

## add-usability — Add the designer's criteria

Run by an agent in role `lead-product-designer`. reads: artifact, initiative, experience_principles, core_tasks · writes: artifact.
- then: `add-constraints`

Prompt:

```text
Where For whom names an interaction type, write the usability
and accessibility criteria for the feature's scenarios into
Contributors, one line each, judged against
experience_principles and core_tasks. Add to Edges any failure
or boundary case those criteria name. Where For whom says
"none", record that no criteria are due, with the reason.
Return the feature.

Return each declared output on its own line as `<name>: <value>` — artifact — a list as a JSON array, a value with line breaks as a JSON string; these lines close your reply.

Do not use these words: ratif, disposition, rebaseline bill, surface, seat
```

## add-constraints — Add the architect's constraints

Run by an agent in role `lead-solutions-architect`. reads: artifact, decomposition · writes: artifact.
- then: `prepare`

Prompt:

```text
Read decomposition. Where it names non-functional constraints
on this feature's scenarios, write them into Contributors as
criteria, one line each, riding by name on the scenarios they
bound. Add to Edges any failure or boundary case those
constraints name. Where none apply, record that decomposition
names none for this feature. Return the feature.

Return each declared output on its own line as `<name>: <value>` — artifact — a list as a JSON array, a value with line breaks as a JSON string; these lines close your reply.

Do not use these words: ratif, disposition, rebaseline bill, surface, seat
```

## prepare — Name the framing for the check

Run by the runtime — no agent, no prose. reads: initiative · writes: framing.

```yaml
set:
  framing: initiative + "#framing"
next: check
```

## check — Check the feature

Run by the runtime — no agent, no prose. reads: artifact, framing, criteria_path · writes: decision.

```yaml
next: end
```
