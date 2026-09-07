---
type: adr
id: adr-2026-09-07-coordinator-role
title: A running process is run by the lead shop's router role from its definition's rendering and the run's anchor, not by a code runner
status: draft
version: 1
date: 2026-09-07
decided-by: lead-solutions-architect
right: guardrail
owner: lead-solutions-architect
created: 2026-09-07
updated: 2026-09-07
derives-from: [adr-2026-09-03-role-rendering, adr-2026-09-02-cel-condition-language]
---

# ADR: A running process is run by the lead shop's router role from its definition's rendering and the run's anchor, not by a code runner

## 1. Context

Terms. A *process definition* is the lead shop's statement of one
process, every step typed: a runtime step (a `set` of CEL assignments
or a `run` command template), an agent step run by a role, a human
step, or a sub-process. A *run* is one execution of a process,
anchored to a work item — its *anchor* — that holds the current step
and every data value when the run is held. A *rendering* is a
generated output of a definition: a process's is its skill, a role's
is its agent file at `.claude/agents/<name>.md`. The *harness* is the
agent runtime that loads both. A *coordinator* is whoever moves a run
from step to step. A *code runner* is a program that does so; fabro,
the frozen corpus's workflow orchestrator, is one.

Pre-state, 2026-09-07, read from lead-shop-held records. Nothing runs
a process definition. The lead-pm runs each by hand from its skill, in
one session that carries every step: 64M of the 85M tokens
init-tool-skills cost (req-2026-09-07-run-efficiency v3, the cost
table). The initiative's measure: 32M of context for the coordinator
per delivered feature, target under 1M. The process-definition typedef
(v7) already defines a run: anchored to a work item; states running,
held, done, cancelled; a held run keeps its step and values in the
anchor and resumes at the recorded step; an ask holds a run the same
way. It names fabro as one rendering target and admits per-step
`fabro:` annotations the definition ignores; six definitions carry
them. Conditions are CEL
([adr-2026-09-02-cel-condition-language](adr-2026-09-02-cel-condition-language.md));
`run` templates are shell and yield on standard output. A role reaches
the harness only as its rendering
([adr-2026-09-03-role-rendering](adr-2026-09-03-role-rendering.md)),
and `compile_role.py` passes `model` through, so a role's model is one
line in its definition. Two approved processes name a role `router` —
session-handoff (Accountable: runs the handoff) and reconcile-and-close
(Accountable: executes) — and the review-record typedef names "the
router resuming a held run"; `basis/roles/` holds six definitions and
no router. The role-definition typedef gives a role's authoring to the
first process that needs it. The feature repository, seven features
read in full: none specifies a coordinator or a run;
feat-request-routing (v8) uses "router" for the lead-pm role reading a
request's route — a second meaning of the word. No rendered role's tool
list names a tool that launches an agent; whether a role at the load
point can launch agent steps is recorded nowhere. No contract exists on
this branch.

Forces. The authority, 2026-09-07: "The lead-pm should not be
coordinating a running graph at all, not just the bookkeeping. This
should be a deterministic process that can be run by a very cheap and
fast model." And: "I would like to avoid the expense of a code
implementation for now and just get a cheap model to do what the
lead-pm has been doing to coordinate and do bookkeeping." The
initiative's no-gos: no code runner now; no change to a process
definition's shape that a run does not need; whether a code runner is
a lead-shop tool or the shopsystem engine is the migration review's
question (req-2026-09-06-migration-review). `local-comprehension`: the
coordinator reads the step it is on, not the run. A session's context
only grows, so the target holds only if the coordinator restarts from
the anchor at least once per sub-process.

Decided by the solutions architect role. The role's rights list
integration strategy; the adr typedef's `right` values carry no such
name, so the record uses `guardrail`, the typedef's name for a platform
bound. Whether the role held it is the PM role's ruling at the check.

Options that were real:

- **A code runner now** — fabro, or one written in the lead shop.
  Declined by the authority's direction: a code implementation is the
  expense to avoid; the definitions and the anchor a runner would read
  are the ones the role reads, so the option stays open for the
  migration review.
- **The lead-pm keeps coordinating, on a cheap model.** Declined: the
  lead-pm's definition holds decisions — the route, the check verdict —
  a cheap model must not take; the coordinator must be a role that
  decides nothing, so the decision rights stay where they are.
- **A new role name.** Declined: two approved processes and one typedef
  already name `router`; a second name is a second home for one role.
- **The coordinator holds the run's state in its own context.**
  Declined: a session's context only grows; the anchor is where a held
  run already lives, and restart from it is what makes the measure
  reachable.
- **Conditions evaluated by a CEL tool from the first run.** Not chosen
  now: a tool is enabler work, kept within the no-go only as something
  a runtime step calls; a mis-read condition in the first run is the
  trigger (§4).

## 2. Decision

A running process is run by the lead shop's `router` role — a defined
role, rendered like every role, its model in its definition — from the
definition's rendered skill and the run's anchor, and by no code
runner.

The decision's parts, one guardrail together. *The role:* `router` is
written as a role definition and reaches the harness as its rendering;
its `model` value names the cheap model. *The program:* the router runs
a definition through its rendered skill and nothing else — no summary
of it, no memory of earlier runs. *State:* the current step and every
data value live in the run's anchor; the router can be started at any
step from the anchor alone, and is restarted at least at each
sub-process boundary. *Agent steps:* each is launched with the step's
prompt and its declared inputs' values, nothing else; what returns is
taken as the step's declared outputs. *Runtime steps:* a `run`
template is run under the shell as written; a `set` is applied as
written. *Conditions:* the router evaluates each condition and records
the value it read beside the branch taken. *Human steps:* the router
asks at the prompt and holds the run; no wait inside an agent. *No
code runner:* no program moves a run; a runner is the migration
review's question.

### 2.1 Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on five; `intent-provenance` rests on the exception
[adr-2026-09-04-request-front-end](adr-2026-09-04-request-front-end.md)
carries, escalated to the authority (work item lead-4kymc).
`knowable-shape` — the coordinator's description is the router's role
definition; until it exists the actor is undefined, so the definition
is the first thing the feature makes. `contracts-between-contexts` —
no context is touched; the router reaches a BC shop only through that
shop's contract. `actor-neutral-discipline` — each step records what
its definition records, whoever runs it; a cheap model earns no lighter
record, and the router gains no decision by running the step that holds
one. `local-comprehension` — the router reads the step it is on; each
agent step reads its inputs. `bidirectional-conformance` — the
definition is authoritative; a run that departs from it is the run's
defect, and the router changes no definition. `intent-provenance` —
the request, the discovery, the initiative, and this record are each
recorded; the operational contract the request entered through has no
artifact yet — the cited exception.

## 3. Consequences

- The router gets a definition. What changes: `basis/roles/router.md`
  is written through the role-definition chain — tools, `maxTurns`,
  `model`, its accountabilities, an exclusive domain that is the run's
  next step and nothing decided in one — and rendered to
  `.claude/agents/router.md`; the glossary gains `router`, and
  feat-request-routing's use of the word for the lead-pm's route
  reading stands as that role's activity, not this role. For whom: the
  lead-po, who defines the feature; the authority, who approves the
  definition. Cost: one definition and its approval. Forecloses: a
  coordinator with no description; a coordinator that decides.
- The lead-pm stops coordinating. What changes: the lead-pm keeps its
  agent steps (record, revise) and its human steps; the reading between
  steps moves to the router. For whom: the lead-pm; every role, which
  now receives only its inputs. Cost: the agent steps keep their cost,
  so the parent initiative's measure falls less than this one.
  Forecloses: nothing.
- Agent outputs become parseable. What changes: the router branches on
  typed outputs (`review.verdict`), so every agent step returns its
  outputs in a form the router can read — a line the compiler appends
  to each agent prompt is the least change. For whom: the process
  owner, as enabler work this role recommends to the PO's backlog.
  Cost: one compiler change; every skill re-rendered. Forecloses:
  outputs as prose alone.
- A run's state has one home. What changes: the anchor carries every
  value, or a path to a value too large for it; nothing lives in the
  router's context between steps. For whom: the router; the lead-pm
  reading a held run. Cost: a write to the anchor per step.
  Forecloses: a run resumable only by whoever ran it.
- Launch is settled by evidence. What changes: if a rendered role
  cannot launch an agent step, the router is the session's top-level
  agent, started at the prompt on its model; if it can, the launch tool
  joins the router's `tools`. For whom: the feature's maker. Cost: one
  observed run.

Bound on Bounded Context shops: none new. This decision runs the lead
shop's processes; what runs a BC shop's process definitions — this
role or an engine — is the migration review's decision, and until it
is taken a BC shop chooses. The standing rule is unchanged: a process
runs as its definition says.

## 4. Reversibility

Reversible at low cost: the router's definition and rendering are
removed, or replaced by a code runner that reads the same definitions
and the same anchor — neither changes shape for the role. Nothing a BC
shop builds depends on it. Review triggers: the migration review
decides a runner is the shopsystem's engine; the first run mis-reads a
condition, so a CEL evaluator is called from a runtime step; the
coordinator's context per delivered feature stays above 1M after a
restart per sub-process; a rendered role proves unable to launch agent
steps and the top-level form costs more than the measure allows.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored at adr-authoring's author step, reached through initiative-check's pre-bet route on init-process-runner, from the offer in that initiative's history (v3); right `guardrail`, the typedef's name for the integration-strategy right the offer named. Not decided here, candidates for their own runs: the router's tool list and model tier (the feature's make), the parseable-output line (the process owner's), a CEL evaluator tool (on §4's trigger), a runner as the shopsystem's engine (the migration review). |
