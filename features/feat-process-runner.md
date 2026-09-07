---
type: feature
id: feat-process-runner
name: Process runner
status: draft
version: 1
initiative: ../initiatives/init-process-runner.md
owner: lead-po
created: 2026-09-07
updated: 2026-09-07
---

# Feature: Process runner

## Feature

Feature: Process runner
  The lead-pm, who stops coordinating, and every role, which receives
  only its inputs,
  can have a process definition run itself — runtime steps as written,
  agent steps with their declared inputs only, human steps waiting for
  the human — moved from step to step by the router from the run's
  anchor, started, held, resumed, answered, and cancelled at the
  command line,
  so that whoever moves the run carries only the step it is on, in
  place of the lead-pm running the definitions by hand in one long
  context.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: the runner role, its
rendering, and any compiler change sit in the lead shop's tree; no
contract exists on this branch; cross-context flow none. Every
scenario is owned by shopsystem-product (the lead shop):

- *a run starts against a work item from an approved process definition* — shopsystem-product (the lead shop)
- *a runtime step runs as its definition writes it* — shopsystem-product (the lead shop)
- *a branch records the value it was taken on* — shopsystem-product (the lead shop)
- *a condition the router cannot read holds the run and is asked* — shopsystem-product (the lead shop)
- *an agent step is launched with its declared inputs alone* — shopsystem-product (the lead shop)
- *an agent step's return names its declared outputs* — shopsystem-product (the lead shop)
- *a return lacking a declared output holds the run* — shopsystem-product (the lead shop)
- *a human step holds the run for the person* — shopsystem-product (the lead shop)
- *an answer at the command line resumes the held run* — shopsystem-product (the lead shop)
- *an ask returned by an agent step holds the run for the role it names* — shopsystem-product (the lead shop)
- *a person holds a running run* — shopsystem-product (the lead shop)
- *a router started from the anchor resumes the held run* — shopsystem-product (the lead shop)
- *a run is cancelled with a reason* — shopsystem-product (the lead shop)
- *a sub-process step runs from its own definition and returns its result* — shopsystem-product (the lead shop)
- *the router is an approved role available at the point of work* — shopsystem-product (the lead shop)
- *the router writes no decision to the run* — shopsystem-product (the lead shop)
- *an approved process runs end to end with the lead-pm at its own steps alone* — shopsystem-product (the lead shop)

Vocabulary, one clause each to read the scenarios by; the definitions
stay where they are cited: **process definition**, **step**,
**rendering**, **run**, **hold**, **ask** — the glossary's; a run is
anchored to a **work item**, its **anchor**, which holds the current
step and every data value while the run is held (process-definition
typedef, §Run lifecycle). **Runtime step** — a step that carries `set`
assignments or a `run` command template and no prose; **agent step** —
a step run by a role from its prompt; **human step** — a step a person
answers; **sub-process step** — a step that runs another process
definition as a run of its own (the same typedef, its steps section).
**Declared inputs**, **declared outputs** — the values a step's
definition reads and writes, by name. **The router** — the role that
moves one run from step to step, named by the session-handoff and
reconcile-and-close processes; its definition is the first thing this
feature produces (the backlog order's first placed enabler); not the
word's use in feat-request-routing, where it is the lead-pm reading a
request's route. **The person** — whoever fills the role a human step
or an ask names, at the command line. **The point of work** — where
the agent runtime loads roles and skills from (feat-roles-availability,
feat-skills-availability). **The lead-pm's own steps** — the agent and
human steps a process definition assigns to the lead-pm role.

Provenance outside the ownership list: *an agent step's return names
its declared outputs* and *a return lacking a declared output holds
the run* — the order's second placed enabler (the architect's third
risk, the initiative's history v3); *the router is an approved role
available at the point of work* and *the router writes no decision to
the run* — the first placed enabler (the architect's fifth risk); *a
condition the router cannot read holds the run and is asked* — the
architect's second risk and the designer's criterion (d) (history v4);
the five scenarios on start, hold, answer, resume, and cancel — the
three core tasks the For whom section's interaction type carries and
the designer's criteria (a)–(c). What criteria are due, the designer's
and the architect's passages below record.

## Interaction types

Command line — the For whom section's word: the person starts, holds,
resumes, cancels, and answers a run there. The initiative's usability
section reads it as the assistant type for the router's own turns and
the command-line type for the shell commands its runtime steps run;
that reading, and the criteria under it, are the product designer
role's to state at the add-usability step.

## Scenarios

```gherkin
Feature: Process runner
  The lead-pm, who stops coordinating, and every role, which receives
  only its inputs,
  can have a process definition run itself — runtime steps as written,
  agent steps with their declared inputs only, human steps waiting for
  the human — moved from step to step by the router from the run's
  anchor, started, held, resumed, answered, and cancelled at the
  command line,
  so that whoever moves the run carries only the step it is on, in
  place of the lead-pm running the definitions by hand in one long
  context.

  @feature:feat-process-runner @hash:434b63c16ea6
  Scenario: a run starts against a work item from an approved process definition
    Given an approved process definition and a work item
    When the person starts a run of the process against the work item at the command line
    Then the run is recorded on the work item as running at the definition's first step, with its parameters, and the person is shown the run's id

  @feature:feat-process-runner @hash:21a0a96524fb
  Scenario: a runtime step runs as its definition writes it
    Given a run at a runtime step
    When the router moves the run through the step
    Then the step's assignments are applied and its command run exactly as the definition writes them, and the values they yield are recorded on the anchor before the next step

  @feature:feat-process-runner @hash:4353a5e45d00
  Scenario: a branch records the value it was taken on
    Given a run at a step whose next step depends on a condition
    When the router evaluates the condition
    Then the value it read and the branch it took are recorded on the anchor beside each other

  @feature:feat-process-runner @hash:c32dd5b8b474
  Scenario: a condition the router cannot read holds the run and is asked
    Given a run at a step whose condition the router cannot evaluate from the values it has
    When the router reaches the condition
    Then no branch is taken, the run holds at that step, and the person is shown the condition and asked which branch holds

  @feature:feat-process-runner @hash:de2fcc71392f
  Scenario: an agent step is launched with its declared inputs alone
    Given a run at an agent step
    When the router launches the step
    Then the agent receives the step's prompt and the values of the step's declared inputs and nothing else of the run, and what it returns is recorded on the anchor as the step's declared outputs

  @feature:feat-process-runner @hash:b112175a187c
  Scenario: an agent step's return names its declared outputs
    Given an agent step of any approved process definition, whose definition declares outputs
    When the agent completes the step
    Then its return states each declared output by name with its value, and the router records each on the anchor from that statement without interpreting the return's prose

  @feature:feat-process-runner @hash:c0234aab4a26
  Scenario: a return lacking a declared output holds the run
    Given an agent step whose return lacks one of its declared outputs
    When the router reads the return
    Then no value is recorded for that output, the run holds at that step, and the person is shown the step and the output that is missing

  @feature:feat-process-runner @hash:6bcebb4e0073
  Scenario: a human step holds the run for the person
    Given a run at a human step
    When the router reaches the step
    Then the run holds with the step and every value on the anchor, the person the step names is shown the run's id, the step, and its question with the question's kind and default, and no agent waits for the answer

  @feature:feat-process-runner @hash:be93a233eee2
  Scenario: an answer at the command line resumes the held run
    Given a run held at a human step
    When the person answers the question or accepts its default at the command line
    Then the answer is recorded on the anchor, the run resumes at that step with the answer in its inputs, and the router says what it took

  @feature:feat-process-runner @hash:91306c8a2c4f
  Scenario: an ask returned by an agent step holds the run for the role it names
    Given a run at an agent step whose agent returns an ask in place of its outputs
    When the router receives the ask
    Then the run holds with the ask recorded on the anchor for the role the ask names, and on the answer the run resumes at the asking step with the ask in its inputs

  @feature:feat-process-runner @hash:4d31a463c42e
  Scenario: a person holds a running run
    Given a run that is running
    When the person holds it at the command line
    Then the run is recorded held at its current step with every value on the anchor, and nothing further runs until it is resumed or cancelled

  @feature:feat-process-runner @hash:4d401977556c
  Scenario: a router started from the anchor resumes the held run
    Given a run held at a step, whether by the person, by an ask, or by its router stopping, and no router that remembers it
    When a router is started from the run's anchor
    Then it first restates the run's id, the step, and what the run awaits, and continues from that step with the anchor and the definition's rendering as its only sources

  @feature:feat-process-runner @hash:b6591f138dd3
  Scenario: a run is cancelled with a reason
    Given a run that is running or held
    When the person cancels it with a reason at the command line
    Then the run is recorded cancelled with the reason on its anchor, any open ask on it is marked cancelled, and nothing further runs

  @feature:feat-process-runner @hash:28b4f5a6d5dc
  Scenario: a sub-process step runs from its own definition and returns its result
    Given a run at a sub-process step
    When the router reaches the step
    Then the sub-process runs from its own definition as a run of its own, recording the parent it branched from, and its result is recorded on the parent's anchor as the step's output

  @feature:feat-process-runner @hash:06a0e40f2325
  Scenario: the router is an approved role available at the point of work
    Given the router role's definition standing approved
    When the check over the roles at the point of work runs
    Then the router is available to the agent runtime, current with its definition, and the check reports it so

  @feature:feat-process-runner @hash:d2f51245aa9a
  Scenario: the router writes no decision to the run
    Given a run the router has moved to its end
    When the anchor is read
    Then every value the router wrote is a step's declared output, a condition's read value, or the run's state, and no verdict, route, or bet on the anchor is the router's

  @feature:feat-process-runner @hash:fe0399304a46
  Scenario: an approved process runs end to end with the lead-pm at its own steps alone
    Given an approved process definition with runtime, agent, and human steps, and a run of it started against a work item
    When the router moves the run to its end
    Then every step ran as the definition writes it, in the definition's order, the result is recorded on the anchor, and the lead-pm acted at its own steps and nowhere between them
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| Nothing runs a process definition; the lead-pm runs it by hand in one long context | the framing (Problem) | Scenario: an approved process runs end to end with the lead-pm at its own steps alone |
| A runtime step run other than as written — a command changed, an assignment skipped | the framing (outcome: "runtime steps as written") | Scenario: a runtime step runs as its definition writes it |
| An agent step that sees the run — a value it did not declare | the framing (outcome: "agent steps with their declared inputs only"); the For whom section ("every role, which receives only its inputs") | Scenario: an agent step is launched with its declared inputs alone. A step that needs an undeclared value is a definition gap the process owner files (the process-definition typedef, §Run lifecycle), not a behavior of the run — the agent returns an ask, Scenario: an ask returned by an agent step holds the run for the role it names |
| A human step answered inside an agent, or an agent turn spent waiting | the framing (outcome: "human steps waiting for the human"); the architect's third unknown (history v3) | Scenario: a human step holds the run for the person — "no agent waits" |
| Whoever moves the run carrying more than the step it is on — a router that keeps the run in its own context | the framing (outcome); the architect's verdict (history v3: the target holds only if restarted from the anchor) | Scenario: a router started from the anchor resumes the held run — the anchor and the rendering its only sources; Scenario: a runtime step runs as its definition writes it — values on the anchor before the next step |
| The measure — the router's context tokens per delivered feature, 32M to under 1M | the For whom section | Out of scope of a scenario: the count is the PM role's to read at the delivery, and how it is counted is the sibling init-run-measurement's, not yet bet on; the behavior that makes it reachable is Scenario: a router started from the anchor resumes the held run |
| The lead-pm's own agent and human steps keep their cost | the architect's fourth risk (history v3); the decision the bet rests on (§3) | Scenario: an approved process runs end to end with the lead-pm at its own steps alone — the lead-pm's steps stay its own; their cost is the parent initiative's measure, the PM role's to read |
| A code runner | the initiative's Appetite (first no-go) | Out of scope: no scenario names a program that moves a run; the router is a role, and whether an engine replaces it is the migration review's question |
| A process definition changed for the run's sake | the initiative's Appetite (second no-go) | Scenario: an approved process runs end to end with the lead-pm at its own steps alone — "as the definition writes it"; a run that departs from its definition is the run's defect; the one compiler change the order places (the return's form) changes no definition |
| The router cannot launch an agent step | the architect's first risk and first unknown (history v3) | Scenario: an agent step is launched with its declared inputs alone — met in whichever form the launch takes; the form is the maker's, with the decision the bet rests on naming the session's top-level agent as the default until a run shows otherwise |
| A cheap model mis-reading a condition — a wrong branch | the architect's second risk and fourth unknown (history v3); the designer's second risk (history v4) | Scenario: a branch records the value it was taken on — checkable, not made correct; Scenario: a condition the router cannot read holds the run and is asked — asked, never guessed. A wrong branch with a recorded value is a review trigger of the decision the bet rests on, and a CEL evaluator enters a superseding order if it fires (the backlog order, §2) |
| Outputs returned as prose the router must interpret | the architect's third risk (history v3); the order's second placed enabler | Scenario: an agent step's return names its declared outputs; Scenario: a return lacking a declared output holds the run |
| The router with no definition — an undefined actor | the architect's fifth risk (history v3); the order's first placed enabler | Scenario: the router is an approved role available at the point of work |
| The router deciding — a verdict, a route, a bet | the decision the bet rests on (an option declined: the lead-pm on a cheap model) | Scenario: the router writes no decision to the run |
| The router's tool list and model tier | the backlog order (§2, declined as a how) | Out of scope: the maker's, within the router's definition; no scenario names a model or a tool |
| Where the run's state lives; a value too large for the anchor | the architect's second unknown (history v3) | Scenario: a runtime step runs as its definition writes it and Scenario: a human step holds the run for the person — on the anchor; a value too large for it is recorded there as a path, the architect's default, the maker's within it |
| A second turn to get the run's id at start | the designer's criterion (a) (history v4) | Scenario: a run starts against a work item from an approved process definition — the id shown; the one-turn reading is the designer's to state |
| The question shown without its kind or default; several questions unnumbered; the router asking again after an answer | the designer's criterion (b) and D2 (history v4) | Scenario: a human step holds the run for the person — kind and default shown; Scenario: an answer at the command line resumes the held run — "the router says what it took"; the form of the turn is the designer's pattern |
| A resumed router that does not first restate the run's id, step, and what it awaits | the designer's criterion (c) and third unknown (history v4) | Scenario: a router started from the anchor resumes the held run |
| Cancel, or a default taken, without confirmation | the designer's criterion (c) and the hard-to-reverse record (history v4) | Scenario: a run is cancelled with a reason and Scenario: an answer at the command line resumes the held run state what is recorded; the confirmation before either is the designer's criterion riding on them |
| An ask unanswered past the process's ask-cap | the process-definition typedef (§Run lifecycle: resolves to its default at the cap) | Out of scope: a runtime clock that takes the default unattended is a code runner's, barred by the first no-go; the ask stays held until the person answers or accepts the default — Scenario: an answer at the command line resumes the held run. Proposed default, for the PM role: a router started from the anchor after the cap shows the ask as past its cap and offers the default, taken only on the person's confirmation |
| A run held by inactivity (`hold-after`) | the process-definition typedef (§Run lifecycle) | Scenario: a router started from the anchor resumes the held run — a router that stops leaves the run held at the step last recorded; the window itself is a runtime's, out of scope with the first no-go |
| A start on a process definition that does not stand approved | the feature repository (feat-skills-availability: a definition that does not stand approved yields no loadable skill) | Out of scope here: specified there — no rendering, so nothing for the router to run from; Scenario: a run starts against a work item from an approved process definition holds for an approved one only |
| Which process the first run runs | the initiative's Appetite ("one process run end to end") | Scenario: an approved process runs end to end with the lead-pm at its own steps alone, read of any approved process; the choice is the PM role's at the delivery. Proposed default: the next run the lead shop has to make whose definition holds all three step kinds and a branch on a declared output |
| A Bounded Context shop's process definitions | the initiative's Decomposition section; the decision the bet rests on (its bound on Bounded Context shops) | Out of scope: no context is touched; what runs a BC shop's definitions is the migration review's decision, and until then a shop chooses |
| The fabro rendering target and the six `fabro:` annotations | the decision the bet rests on (§2.1, the carried exception) | Out of scope: parked until the migration review; no scenario reads them |
| The word "router" already used for the lead-pm reading a request's route | the feature repository (feat-request-routing, v8) | Recorded in the vocabulary: two uses, the role here and the lead-pm's activity there; the glossary entry for the role is a consequence of the decision the bet rests on, due at the delivery |
| The router's turns before init-plain-voice frames their voice | the designer's fifth unknown (history v4) | Out of scope: the sibling init-plain-voice's, not bet on; the router's turn carries the step it is on, what it needs, and nothing else — the designer's default, riding as the designer's criterion |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored by the PO role alone at feature-authoring's draft step, from init-process-runner's Framing and For whom sections (v6, planned; the order order-2026-09-07-b v3, its two enablers placed inside the item); the decision the bet rests on, adr-2026-09-07-coordinator-role (v3, checked), read for what must hold and named in no scenario; seventeen scenarios, all owned by the lead shop per the Decomposition; `@hash:pending` on each, for the lead-pm to fill. The repository read in full: seven features; touch-points feat-roles-availability (the check over the roles, in the Given of the router's availability scenario), feat-skills-availability (a definition not approved yields no rendering — an Edges row), feat-request-routing (the word "router" — the vocabulary and an Edges row); no conflict. Declined or held, with the reason in Edges: the measure's counting (the sibling init-run-measurement's); the ask-cap's unattended default, hold-after, the model tier, and the tool list (the first no-go, or a how); the router's voice (init-plain-voice's). Two proposed defaults for the PM role, in Edges: an ask past its cap; which process the first run runs. Resulting action outside this step's writes: the glossary entry for `router`, due at the delivery per the decision's first consequence. Self-check against the feature fitness set (v8): 1 pass — each When one action (a start, a move, an evaluation, a launch, a completion, a read, an answer, a hold, a cancel, a check run), each Then observable on the anchor, at the command line, or in the check's report, no step naming a model, a tool, a file path, or a launch mechanism; 2 pass — an owning shop per scenario; the interaction type named, so the designer's criteria are due at the next step and the section says so; 3 pass on presence — both tags on all seventeen, hashes disclosed pending; 4 pass — twenty-eight rows from the framing, For whom, both no-gos, the architect's five risks and five unknowns, the designer's (a)–(d), D2, and two unknowns, the Decomposition, the order's enablers and declines, the typedef's run lifecycle, and three repository touch-points, each covered by Scenario name or out of scope with a reason; 5 pass — command line, the For whom's word, with the designer's reading deferred to that role's step; 6 pass — who (the lead-pm; every role), what (a definition runs itself, moved by the router, started, held, resumed, answered, cancelled at the command line), the outcome the framing's ("whoever moves the run carries only the step it is on"). No shell in this session: the lint's checks applied by hand — no banned term, history last, version 1. Not committed. |
