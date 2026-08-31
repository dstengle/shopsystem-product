---
name: scenario-assignment
description: 'Turn a checked feature into work the Bounded Context shops can take
  up: the solutions architect role tags each scenario with the context that owns its
  behavior, reads each tagged context''s pre-state, sweeps the feature repository
  for conflicts, records the feature as assigned, and sends each shop its scenarios
  as an `assign_scenarios` message. Use when a feature has passed the PO output check
  and its scenarios must each be assigned to the Bounded Context that owns the behavior
  and sent to that shop.'
type: skill
id: scenario-assignment-skill
status: draft
created: 2026-08-28
updated: 2026-08-31
generated: true
generated-by: basis/tools/compile_process.py
derived-from: scenario-assignment-process
source: basis/processes/scenario-assignment.md
source-digest: sha256:e5cc7441808e
activation: model-judged
promotion: experiment-local
---

# Scenario assignment (compiled from `scenario-assignment-process`)

Turn a checked feature into work the Bounded Context shops can take up: the solutions architect role tags each scenario with the context that owns its behavior, reads each tagged context's pre-state, sweeps the feature repository for conflicts, records the feature as assigned, and sends each shop its scenarios as an `assign_scenarios` message.

**The decomposition decides, not the wording. Which context owns a behavior is read from the decomposition and the contexts' contracts; a scenario no context can own is the architect's finding, not a guess.**

Result of a run: `feature` (string).

```mermaid
flowchart TD
  assign(["Tag each scenario with its owning context — agent: lead-solutions-architect<br/>in — feature: string, decomposition: string, contracts: string, repository: string, ask: ask<br/>out — feature: string, unowned: string[], assignment: assignment"])
  route{"Route on ownership<br/>in — unowned: string[]"}
  return(["Return the feature with the unowned scenarios named — agent: lead-solutions-architect<br/>in — feature: string, unowned: string[]<br/>out — feature: string"])
  dispatch["Send each shop its scenarios — runtime<br/>in — feature: string, assignment: assignment<br/>out — sent: string[]"]
  record(["Record the assignment — agent: lead-solutions-architect<br/>in — feature: string, assignment: assignment, sent: string[]<br/>out — feature: string"])
  __end(("end<br/>result — feature: string"))
  __start(("start")) --> assign
  assign --> route
  route -->|success exit: every scenario owned| dispatch
  route -->|else| return
  return --> __end
  dispatch --> record
  record --> __end
```

## assign — Tag each scenario with its owning context

Run by an agent in role `lead-solutions-architect`. reads: feature, decomposition, contracts, repository, ask · writes: feature, unowned, assignment.
- may ask: `lead-pm` — return an `ask` (with default and checkpoint) in place of outputs; at most one per run.
- then: `route`

Prompt:

```text
Read the decomposition and the feature. For each scenario, decide
which Bounded Context owns the behavior it states — from the
decomposition and that context's contract at contracts, never
from the scenario's wording alone — and write a single
@bounded-context:<name> tag on it. A scenario whose behavior no
context owns, that two contexts would each have to own, or whose
owning context differs from the shop Contributors names as its
owner, goes to unowned with the reason; do not guess. Then, for each context
tagged, read its pre-state — the state of the design: its contract
at contracts and the feature repository at repository — and
sweep the repository for conflicts: a scenario that contradicts
one already specified there goes to unowned with the conflict
as its reason. Write one assignment entry per context with
the @hash: values of its scenarios and the pre-state read. If deciding needs what the decomposition
cannot say — whether a behavior is meant to be in the product at
all — return an ask to lead-pm (kind: scope) with the question,
the default you will apply, and a checkpoint of the tags written
so far; on the first pass ask is absent, and if it carries an
answer or resolved defaulted, act on it. Return the tagged
feature.
```

## route — Route on ownership

Run by the runtime — no agent, no prose. reads: unowned · writes: —.

```yaml
branches:
- label: 'success exit: every scenario owned'
  when: size(unowned) == 0
  next: dispatch
- else: return
```

## return — Return the feature with the unowned scenarios named

Run by an agent in role `lead-solutions-architect`. reads: feature, unowned · writes: feature.
- then: `end`

Prompt:

```text
Write a review entry into the feature's Document History naming
each unowned scenario and its reason and set the feature's
status to "returned" — the returned feature is the handoff to
the PO role, which reads its status. The decomposition may need
a change, which this role raises as an architecture decision
record; the scenario may need a split, which is the PO role's;
or the feature's Contributors must be corrected to name the
owning shop the decomposition places the behavior in, which is
the PO role's; or the scenario contradicts one already specified
in the feature repository, which the PO role resolves against
the framing — the reason in unowned names which case.
```

## dispatch — Send each shop its scenarios

Run by the runtime — no agent, no prose. reads: feature, assignment · writes: sent.

```yaml
run: "for ctx in ${assignment.entries[].context}; do\n  shop-msg send --bc \"$ctx\"\
  \ --type assign_scenarios \\\n    --feature \"${feature}\" --tag \"@bounded-context:$ctx\"\
  \ndone\n"
next: record
```

## record — Record the assignment

Run by an agent in role `lead-solutions-architect`. reads: feature, assignment, sent · writes: feature.
- then: `end`

Prompt:

```text
Set the feature's status to "assigned" and write a state entry
into its Document History listing, from assignment, each
context's scenario hashes, and, from sent (the tool's
standard output, one line per message — its output contract is
pinned when the messaging package is imported), the message sent to each. Return
the feature.
```
