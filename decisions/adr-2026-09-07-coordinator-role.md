---
type: adr
id: adr-2026-09-07-coordinator-role
title: A running process is run by the lead shop's router role from the process definition's rendering and the run's anchor, not by a code runner
status: checked
version: 4
date: 2026-09-07
decided-by: lead-solutions-architect
right: guardrail
owner: lead-solutions-architect
created: 2026-09-07
updated: 2026-09-07
derives-from: [adr-2026-09-03-role-rendering, adr-2026-09-02-cel-condition-language]
---

# ADR: A running process is run by the lead shop's router role from the process definition's rendering and the run's anchor, not by a code runner

## 1. Context

Terms. A *process definition* is the lead shop's statement of one
process, every step typed: a runtime step (a `set` of CEL assignments
or a `run` command template), an agent step run by a role, a human
step, or a sub-process. A *run* is one execution of a process,
anchored to a work item — its *anchor* — that holds the current step
and every data value when the run is held. A *rendering* is a
generated output of a definition: a process's is its skill, a role's
is its agent file at `.claude/agents/<name>.md`. The *harness* is the
agent runtime that loads both; the agent it starts at the prompt is
the *session's top-level agent*. The *router* is the role that moves
one run from step to step. A *code runner* is a program that does so;
fabro, the frozen corpus's workflow orchestrator, is one.

Pre-state, 2026-09-07, read from lead-shop-held records. Nothing runs
a process definition. The lead-pm runs each by hand from its skill, in
one session that carries every step: 64M of the 85M tokens
init-tool-skills cost (req-2026-09-07-run-efficiency v3, the cost
table). The initiative's measure: the router's context per delivered
feature, now 32M, target under 1M. The process-definition typedef
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
line in its definition. The harness loads a rendered skill whole; a
rendering of one step is not yet defined (init-artifact-tools is where
that work is framed). Two approved processes name a role `router` —
session-handoff (Accountable: runs the handoff) and reconcile-and-close
(Accountable: executes) — and the review-record typedef names "the
router resuming a held run"; `basis/roles/` holds six definitions and
no router. The role-definition typedef gives a role's authoring to the
first process that needs it. The feature repository, seven features
read in full: none specifies a router or a run; feat-request-routing
(v8) uses "router" for the lead-pm role reading a request's route — a
second meaning of the word. No rendered role's tool list names a tool
that launches an agent; whether an agent the harness loaded from a
rendering can launch agent steps is recorded nowhere. No contract
exists on this branch.

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
router reads the step it is on, not the run. A session's context only
grows, so the target holds only if the router restarts from the anchor
at least once per sub-process.

Decided by the solutions architect role under its integration-strategy
right. The adr typedef's `right` values carry no such name, so the
record uses `guardrail` — a platform bound. Whether the role held the
right is the PM role's ruling at the check.

Options that were real:

- **A code runner now** — fabro, or one written in the lead shop.
  Declined by the authority's direction: a code implementation is the
  expense to avoid; the definitions and the anchor a runner would read
  are the ones the role reads, so the option stays open for the
  migration review.
- **The lead-pm keeps coordinating, on a cheap model.** Declined: the
  lead-pm's definition holds decisions — the route, the check verdict —
  that a cheap model must not take; the router must be a role that
  decides nothing, so the decision rights stay where they are.
- **A new role name.** Declined: two approved processes and one typedef
  already name `router`; a second name is a second home for one role.
- **The router holds the run's state in its own context.** Declined: a
  session's context only grows; the anchor is where a held run already
  lives, and restart from it is what makes the measure reachable.
- **Conditions evaluated by a CEL tool from the first run.** Not chosen
  now: a tool is enabler work, kept within the no-go only as something
  a runtime step calls; a mis-read condition in the first run is the
  trigger (§4).

## 2. Decision

A running process is run by the lead shop's `router` role — a defined
role, rendered like every role, its model in its definition — from the
process definition's rendered skill and the run's anchor, and by no
code runner.

### 2.1 Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on four; two exceptions carried. `knowable-shape` — the
router's description is its role definition; until it exists the actor
is undefined, so the definition is the first thing the feature makes.
`contracts-between-contexts` — no context is touched; the router
reaches a BC shop only through that shop's contract.
`actor-neutral-discipline` — the coordinating activity carries no
decision right, whatever fills it; each step records what its
definition records, whoever runs it, and a cheap model earns no
lighter record. `local-comprehension` — the router reads the step it
is on and each agent step reads its declared inputs alone; today the
router loads the whole rendered skill of the process at each start,
a rendering of one step being later work (init-artifact-tools), so the
measure rests on restart per sub-process and on declared inputs alone,
not on a smaller load. `bidirectional-conformance` — exception
carried: the fabro rendering target and the six `fabro:` annotations
are design elements with no implementation under this decision; they
stand parked until the migration review
(req-2026-09-06-migration-review) decides the runner, and that request
is the escalation that carries the exception. Otherwise the definition
is authoritative: a run that departs from it is the run's defect, and
the router changes no definition. `intent-provenance` — exception
carried: the request, the discovery, the initiative, and this record
are each recorded; the operational contract the request entered
through has no artifact yet — the exception
[adr-2026-09-04-request-front-end](adr-2026-09-04-request-front-end.md)
carries, escalated to the authority (work item lead-4kymc).

## 3. Consequences

- The router gets a definition. What changes: the feature
  init-process-runner's bet produces writes `basis/roles/router.md`
  through the role-definition chain — tools, `maxTurns`, `model` set to
  the cheap model, its accountabilities, an exclusive domain that is
  the run's next step and nothing decided in one — rendered to
  `.claude/agents/router.md`; the glossary gains `router`, and
  feat-request-routing's use of the word for the lead-pm's route
  reading stands as that role's activity, not this role. For whom: the
  lead-po, who defines the feature; the authority, who approves the
  definition. Cost: one definition and its approval. Forecloses: a
  router with no description; a router that decides.
- The router runs from the rendering and the anchor. What changes: the
  router runs a process through its rendered skill and nothing else —
  no summary of it, no memory of earlier runs; the current step and
  every data value live in the anchor, or a path to a value too large
  for it; the router can be started at any step from the anchor alone
  and is restarted at least at each sub-process boundary. For whom:
  the router; the lead-pm reading a held run. Cost: a write to the
  anchor per step; the whole skill loaded at each start until a
  rendering of one step exists. Forecloses: a run resumable only by
  whoever ran it.
- Agent steps get their inputs alone. What changes: each agent step is
  launched with the step's prompt and its declared inputs' values,
  nothing else; what returns is taken as the step's declared outputs.
  For whom: every role. Cost: a value not declared as an input is not
  seen; a step that needs one is a definition gap. Forecloses: an
  agent step reading the run.
- Runtime steps run as written and conditions leave a record. What
  changes: a `run` template runs under the shell as written, a `set`
  is applied as written, and the router evaluates each condition and
  records the value it read beside the branch taken. For whom: the
  router; whoever audits a run. Cost: one record per branch; a
  mis-read value is a wrong run, made checkable, not correct.
  Forecloses: a branch with no recorded reason.
- Human steps hold the run. What changes: the router asks at the
  prompt and holds the run; no wait inside an agent. For whom: the
  lead-pm and the authority, at their human steps. Cost: a hold and a
  restart per human step. Forecloses: an agent turn spent waiting.
- No code runner. What changes: no program moves a run; the fabro
  rendering target and the six annotations stay parked. For whom: the
  migration review, which decides the runner. Cost: the parked
  elements are design without implementation until then. Forecloses:
  nothing — the review may replace the role with an engine.
- Agent outputs become parseable. What changes: the router branches on
  typed outputs (`review.verdict`), so every agent step returns its
  outputs in a form the router can read — a line the compiler appends
  to each agent prompt is the least change. For whom: the process
  owner, as enabler work this role recommends to the PO's backlog.
  Cost: one compiler change; every skill re-rendered. Forecloses:
  outputs as prose alone.
- The lead-pm stops coordinating. What changes: the lead-pm keeps its
  agent steps (record, revise) and its human steps; the reading between
  steps moves to the router. For whom: the lead-pm; every role, which
  now receives only its inputs. Cost: the agent steps' context stays
  in init-run-efficiency's measure (context tokens per delivered
  feature), so it falls less than init-process-runner's (the router's
  context per delivered feature). Forecloses: nothing.
- The router starts at the prompt. What changes: until a run shows
  that an agent the harness loaded from a rendering can launch agent
  steps, the router is the session's top-level agent on the cheap
  model; if a run shows it can, the launch tool joins the router's
  `tools`. For whom: the feature's maker. Cost: one observed run.

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
router's context per delivered feature stays above 1M after a restart
per sub-process; the top-level form costs more than the measure
allows.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored at adr-authoring's author step, reached through initiative-check's pre-bet route on init-process-runner, from the offer in that initiative's history (v3). Not decided here, candidates for their own runs: the router's tool list and model tier (the feature's make), the parseable-output line (the process owner's), a CEL evaluator tool (on §4's trigger), a runner as the shopsystem's engine (the migration review), and an `integration-strategy` value for the adr typedef's `right` — a typedef gap. |
| 2 | 2026-09-07 | update | The one revise from the screen and the PM role's rulings: the title names the process definition's rendering; "load point" and "coordinator" replaced by the harness loading the rendering, the session's top-level agent, and the router; the right carried as `guardrail` with one gloss and the missing value named as a typedef gap; §2 cut to the one sentence and its parts moved to §3 as priced consequences; the whole-skill load at each start said in §2.1 and §3; `bidirectional-conformance` carried as an exception with req-2026-09-06-migration-review as the escalation, the screen now conforms on four with two exceptions; the actor-neutral line restated; both measures named; the feature's authoring placed after the bet; the top-level agent set as the default until observed. Self-check: criterion 1 pass, 2 pass, 3 pass, 4 pass, 5 pass, 6 pass, principles pass as two carried exceptions. |
| 2 | 2026-09-07 | review | The one screen (judge: claude-fable-5-1 / adr-authoring screen prompt v3): eleven findings — four confident (the title's referent, two terms, the unnamed feature), seven wobbly ruled by the PM role (one right with one gloss; the parts as consequences; the whole skill loaded per start; bidirectional-conformance carried as an exception until the migration review; the option's reason role-attached; the measures named; the top-level agent as default). |
| 3 | 2026-09-07 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise; every finding repaired or ruled; the right ruled held. |
| 4 | 2026-09-08 | review | The tier trigger fired: on the initiative-check run lead-fresb the router (haiku) launched an ADR revise step as a bare agent on its own tier instead of from the architect's rendering; that agent committed and changed the repository's remote. Under the authority's ruling (brief-039 Ask 3) the router moves to sonnet (req-2026-09-08-router-sonnet; router v5). The decision stands. |
