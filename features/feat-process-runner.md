---
type: feature
id: feat-process-runner
name: Process runner
status: assigned
version: 7
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
  the human — moved from step to step by a role of the lead shop, the
  router, from the run's anchor, started, held, resumed, answered, and
  cancelled at the command line,
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
- *a runtime command that exits non-zero holds the run* — shopsystem-product (the lead shop)
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
- *the run's context is recorded on the anchor at its end* — shopsystem-product (the lead shop)

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
feature produces (order-2026-09-07-b's first placed enabler); not the
word's use in feat-request-routing, where it is the lead-pm reading a
request's route. **The person** — whoever fills the role a human step
or an ask names, at the command line. **The point of work** — where
the agent runtime loads roles and skills from (feat-roles-availability,
feat-skills-availability). **The lead-pm's own steps** — the agent and
human steps a process definition assigns to the lead-pm role.

Provenance outside the ownership list: *an agent step's return names
its declared outputs* and *a return lacking a declared output holds
the run* — order-2026-09-07-b's second placed enabler (the architect's
third risk, the initiative's history v3); *the router is an approved
role available at the point of work* and *the router writes no
decision to the run* — its first placed enabler (the architect's fifth
risk); *a condition the router cannot read holds the run and is asked*
— the architect's second risk and the designer's criterion (g) below;
*a runtime command that exits non-zero holds the run* — the designer's
criterion (h); *the run's context is recorded on the anchor at its end*
— the For whom section's measure, the PM role's ruling at the check;
the five scenarios on start, hold, answer, resume, and cancel — the
three core tasks the For whom section's interaction type carries and
the designer's criteria (a), (c)–(f). What criteria are due, the
designer's and the architect's passages below record.

The product designer role's criteria (feature-authoring's
add-usability step, 2026-09-07):

*Due: yes.* The Interaction types section names the command line. Read
against the corpus (the initiative's usability section; its history
v4): the router's own turns at the harness prompt are the `assistant`
type, the assistant guideline (v3) governing them; the shell commands
its runtime steps run are the `cli` type, the cli guideline (v3)
governing them; the common guideline (v3) governs both. Three core
tasks (core-tasks v4) are this interaction, each with its options:
*start a run* — choose the process, supply parameters, see the run's
id; *hold, resume, or cancel a run* — name the run, a reason on cancel;
*answer an ask* — see the question, kind, and default; answer or
accept the default. Each criterion is a hypothesis under
`evidence-not-opinion` bullet 1 until the first run end to end is
observed; the evidence form is measured task completion — every human
turn recorded with the router's turn before it and whether it acted on
the answer.

Usability acceptance criteria, riding on the scenarios by name, no
scenario text changed:

- (a) *start in one turn* — rides on *a run starts against a work item
  from an approved process definition*. Met when the person's one turn
  names the process, the work item, and any parameters, and the
  router's next turn shows the run's id. Invalidated by a second turn
  from the person before the id is shown.
- (b) *the question's form* — rides on *a human step holds the run for
  the person*, *a condition the router cannot read holds the run and
  is asked*, and *a return lacking a declared output holds the run*.
  Met when the router's turn carries the run's id, the step, and one
  question with its kind and its default — numbered when several.
  Invalidated by a question without its kind or default, several
  questions unnumbered, or two questions under one number.
- (c) *the answer acted on* — rides on *an answer at the command line
  resumes the held run*. Met when a number, a line, or "defaults" is
  acted on and the router's next turn says what it took. Invalidated
  by the router asking the same question again after an answer in that
  form, or acting on other than the answer.
- (d) *hold and cancel by name* — rides on *a person holds a running
  run* and *a run is cancelled with a reason*. Met when the person
  names the run in one turn — and, on cancel, the reason — and the
  router's next turn states the run's state. Invalidated by a run the
  router picks unasked, a reason it supplies, or a second turn to
  identify the run.
- (e) *stated and confirmed before the hard-to-reverse* — rides on *a
  run is cancelled with a reason* and, for a default accepted, *an
  answer at the command line resumes the held run* (hard-to-reverse
  v3: cancel a run; resolve an ask by default). Met when the router
  states the run, its state, and that it will not resume — or the
  question, the default, and that the run resumes on it — and acts
  only on the person's confirming turn. Invalidated by either taken in
  the turn that asked for it.
- (f) *a resumed router restates first* — rides on *a router started
  from the anchor resumes the held run*. Met when its first turn
  carries the run's id, the step, and what the run awaits, before
  anything else. Invalidated by any other content first, or the person
  asked for any of the three.
- (g) *failure hands back* — rides on *a condition the router cannot
  read holds the run and is asked*, *a return lacking a declared
  output holds the run*, and *an ask returned by an agent step holds
  the run for the role it names*. Met when the router's turn says what
  happened in the vocabulary's words — the condition, or the step and
  the missing output, or the ask and the role — and what the person
  can do next, and the router does nothing further. Invalidated by a
  branch with no recorded value, an output the router supplies, or an
  ask the router answers.
- (h) *a runtime step's command as a `cli` interaction* — rides on *a
  runtime step runs as its definition writes it*. Met when the command
  runs as written and unattended — no prompt answered by the router —
  and a non-zero exit status is recorded on the anchor as a value the
  step yielded, the run held at that step, the person shown the step,
  the exit status, and the command's own message alongside.
  Invalidated by a command re-run, altered, or continued past on
  failure, or a prompt the router answers.
- (i) *the vocabulary's words* — rides on the scenarios whose Then
  shows the person something: *a run starts against a work item from
  an approved process definition*, *a runtime command that exits
  non-zero holds the run*, *a condition the router cannot read holds
  the run and is asked*, *a return lacking a declared output holds the
  run*, *a human step holds the run for the person*, *an answer at the
  command line resumes the held run*, and *a router started from the
  anchor resumes the held run*. Met when every thing and action the
  router names is the vocabulary's word or this feature's vocabulary
  above (run, hold, resume, cancel, ask, step, anchor, work item,
  process definition). Invalidated by a second word for one thing
  across turns.

Accessibility criteria — `accessible-by-standard` bullet 2, WCAG 2.2
AA applied as WCAG2ICT describes for non-web software, to the
`assistant` and `cli` types:

- (A1) *text in reading order* — rides on the scenarios (a), (b), and
  (f) name. Met when every turn is plain text whose meaning is
  complete in its reading order (success criteria 1.3.1, 1.3.2), no
  meaning resting on colour, glyph, or position alone (1.4.1).
  Invalidated by a question, a default, or a run's state carried only
  by colour, layout, or a character-drawn table.
- (A2) *every option by typed text* — rides on *an answer at the
  command line resumes the held run* and *a run is cancelled with a
  reason*. Met when every option — each numbered choice, "defaults",
  the confirmation, hold, cancel — is reachable by a typed line
  (2.1.1). Invalidated by an option reachable only by a pointer, a key
  chord, or a form the prompt does not carry.
- (A3) *labels and errors in text* — rides on the scenarios (b) and
  (g) name. Met when each question carries its kind and default as
  text (3.3.2) and each hold names its cause and a next step as text
  (3.3.1, 3.3.3). Invalidated as (b) and (g) are.
- The applicability record — which success criteria do not apply to a
  text prompt, and why — is this role's, written at the delivery
  screen; the delivery attaches the result (common guideline rule 5).
  A delivery gate in Edges, not a criterion.

Until *an approved process runs end to end with the lead-pm at its own
steps alone* is observed with every human turn recorded, "usable" is
a hypothesis and the delivery says so. The delivered router
(`assistant`) and its runtime commands (`cli`) are screened by this
role at delivery under the interaction-conformance-check process;
findings to the solutions architect role, undecidables to the corpus —
the entries Edges names.

The solutions architect role's constraints (feature-authoring's
add-constraints step, 2026-09-07):

*Due: none.* The decomposition names no non-functional constraint for
this feature. It reads "None": no Bounded Context touched, cross-context
flow none; what it bounds is placement — the runner role, its rendering,
and any compiler change in the lead shop's tree — and the ownership
list above carries that (every scenario the lead shop's). No criterion
rides on any scenario. The one boundary it names — no cross-context
flow — is an Edges row.

## Interaction types

Command line — the For whom section's word: the person starts, holds,
resumes, cancels, and answers a run there. The initiative's usability
section reads it as the assistant type for the router's own turns and
the command-line type for the shell commands its runtime steps run;
that reading, and the criteria under it, are stated in Contributors at
the add-usability step (v2).

## Scenarios

```gherkin
Feature: Process runner
  The lead-pm, who stops coordinating, and every role, which receives
  only its inputs,
  can have a process definition run itself — runtime steps as written,
  agent steps with their declared inputs only, human steps waiting for
  the human — moved from step to step by a role of the lead shop, the
  router, from the run's anchor, started, held, resumed, answered, and
  cancelled at the command line,
  so that whoever moves the run carries only the step it is on, in
  place of the lead-pm running the definitions by hand in one long
  context.

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:7f991d005cc5
  Scenario: a run starts against a work item from an approved process definition
    Given an approved process definition and a work item
    When the person starts a run of the process against the work item at the command line
    Then the run is recorded on the work item as running at the definition's first step, with its parameters and the router's model as the router's definition names it, and the person is shown the run's id

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:21a0a96524fb
  Scenario: a runtime step runs as its definition writes it
    Given a run at a runtime step
    When the router moves the run through the step
    Then the step's assignments are applied and its command run exactly as the definition writes them, and the values they yield are recorded on the anchor before the next step

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:dfb80114f737
  Scenario: a runtime command that exits non-zero holds the run
    Given a run at a runtime step whose command exits non-zero
    When the router runs the command as written
    Then the exit status and the command's own message are recorded on the anchor as values the step yielded, the run holds at that step, and the person is shown the step, the exit status, and the message

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:4353a5e45d00
  Scenario: a branch records the value it was taken on
    Given a run at a step whose next step depends on a condition
    When the router evaluates the condition
    Then the value it read and the branch it took are recorded on the anchor beside each other

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:c32dd5b8b474
  Scenario: a condition the router cannot read holds the run and is asked
    Given a run at a step whose condition the router cannot evaluate from the values it has
    When the router reaches the condition
    Then no branch is taken, the run holds at that step, and the person is shown the condition and asked which branch holds

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:6c3bd78771bc
  Scenario: an agent step is launched with its declared inputs alone
    Given a run at an agent step
    When the router launches the step
    Then the agent receives the step's prompt and the values of the step's declared inputs and nothing else of the run

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:3a9dc4428ded
  Scenario: an agent step's return names its declared outputs
    Given an agent step of any approved process definition, whose definition declares outputs
    When the agent completes the step
    Then its return states each declared output by name with its value, and the value recorded on the anchor for each output equals the value the return names

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:c0234aab4a26
  Scenario: a return lacking a declared output holds the run
    Given an agent step whose return lacks one of its declared outputs
    When the router reads the return
    Then no value is recorded for that output, the run holds at that step, and the person is shown the step and the output that is missing

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:6bcebb4e0073
  Scenario: a human step holds the run for the person
    Given a run at a human step
    When the router reaches the step
    Then the run holds with the step and every value on the anchor, the person the step names is shown the run's id, the step, and its question with the question's kind and default, and no agent waits for the answer

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:6c35e3f87cd0
  Scenario: an answer at the command line resumes the held run
    Given a run held at a human step or by an ask
    When the person the step or the ask names answers the question or accepts its default at the command line
    Then the answer is recorded on the anchor, the run resumes at the step that asked with the answer in its inputs, and the router says what it took

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:767b608029a3
  Scenario: an ask returned by an agent step holds the run for the role it names
    Given a run at an agent step whose agent returns an ask in place of its outputs
    When the router receives the ask
    Then the run holds at that step with the ask recorded on the anchor for the role the ask names, and nothing further runs until it is answered

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:4d31a463c42e
  Scenario: a person holds a running run
    Given a run that is running
    When the person holds it at the command line
    Then the run is recorded held at its current step with every value on the anchor, and nothing further runs until it is resumed or cancelled

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:8f5b65dca426
  Scenario: a router started from the anchor resumes the held run
    Given a run held at a step, whether by the person, by an ask, or by its router stopping
    When a router is started from the run's anchor
    Then its first turn cites only the anchor's values and the step — the run's id, the step, and what the run awaits — and it continues from that step with the anchor and the definition's rendering as its only sources

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:1809e3236eca
  Scenario: a run is cancelled with a reason
    Given a run that is running or held
    When the person cancels it with a reason and confirms at the command line
    Then the run is recorded cancelled with the reason on its anchor, any open ask on it is marked cancelled, and nothing further runs

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:28b4f5a6d5dc
  Scenario: a sub-process step runs from its own definition and returns its result
    Given a run at a sub-process step
    When the router reaches the step
    Then the sub-process runs from its own definition as a run of its own, recording the parent it branched from, and its result is recorded on the parent's anchor as the step's output

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:06a0e40f2325
  Scenario: the router is an approved role available at the point of work
    Given the router role's definition standing approved
    When the check over the roles at the point of work runs
    Then the router is available to the agent runtime, current with its definition, and the check reports it so

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:d2f51245aa9a
  Scenario: the router writes no decision to the run
    Given a run the router has moved to its end
    When the anchor is read
    Then every value the router wrote is a step's declared output, a condition's read value, or the run's state, and no verdict, route, or bet on the anchor is the router's

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:fe0399304a46
  Scenario: an approved process runs end to end with the lead-pm at its own steps alone
    Given an approved process definition with runtime, agent, and human steps, and a run of it started against a work item
    When the router moves the run to its end
    Then every step ran as the definition writes it, in the definition's order, the result is recorded on the anchor, and the lead-pm acted at its own steps and nowhere between them

  @bounded-context:shopsystem-product @feature:feat-process-runner @hash:96124cdccf45
  Scenario: the run's context is recorded on the anchor at its end
    Given a run the router is moving
    When the run ends
    Then the context tokens the router processed for the run, as the harness reports them, are recorded on the anchor beside the run's result
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| Nothing runs a process definition; the lead-pm runs it by hand in one long context | the framing (Problem) | Scenario: an approved process runs end to end with the lead-pm at its own steps alone |
| A runtime step run other than as written — a command changed, an assignment skipped | the framing (outcome: "runtime steps as written") | Scenario: a runtime step runs as its definition writes it |
| An agent step that sees the run — a value it did not declare | the framing (outcome: "agent steps with their declared inputs only"); the For whom section ("every role, which receives only its inputs") | Scenario: an agent step is launched with its declared inputs alone; Scenario: an ask returned by an agent step holds the run for the role it names — a step that needs an undeclared value is a definition gap the process owner files |
| A human step answered inside an agent, or an agent turn spent waiting | the framing (outcome: "human steps waiting for the human"); the architect's third unknown (history v3) | Scenario: a human step holds the run for the person — "no agent waits" |
| Whoever moves the run carrying more than the step it is on — a router that keeps the run in its own context | the framing (outcome); the architect's verdict (history v3: the target holds only if restarted from the anchor) | Scenario: a router started from the anchor resumes the held run; Scenario: a runtime step runs as its definition writes it |
| The measure — the router's context tokens per delivered feature, 32M to under 1M | the For whom section; the PM role's ruling at the check | Scenario: the run's context is recorded on the anchor at its end — the count per run; how the count is read across runs per delivered feature is the sibling init-run-measurement's, and the target is the PM role's to read at the delivery |
| The lead-pm's own agent and human steps keep their cost | the architect's fourth risk (history v3); the decision the bet rests on (§3) | Scenario: an approved process runs end to end with the lead-pm at its own steps alone — the lead-pm's steps stay its own; their cost is the parent initiative's measure, the PM role's to read |
| A code runner | the initiative's Appetite (first no-go) | Out of scope: no scenario names a program that moves a run; the router is a role, and whether an engine replaces it is the migration review's question |
| A process definition changed for the run's sake | the initiative's Appetite (second no-go) | Scenario: an approved process runs end to end with the lead-pm at its own steps alone — "as the definition writes it"; a run that departs from its definition is the run's defect; the one compiler change the order places (the return's form) changes no definition |
| The router cannot launch an agent step | the architect's first risk and first unknown (history v3) | Scenario: an agent step is launched with its declared inputs alone — in whichever form the launch takes, the maker's |
| A cheap model mis-reading a condition — a wrong branch | the architect's second risk and fourth unknown (history v3); the designer's second risk (history v4) | Scenario: a branch records the value it was taken on; Scenario: a condition the router cannot read holds the run and is asked. An evaluator for CEL (the condition language the definitions use) is the enabler order-2026-09-07-b §2 declines until a run mis-reads |
| Outputs returned as prose the router must interpret | the architect's third risk (history v3); order-2026-09-07-b's second placed enabler | Scenario: an agent step's return names its declared outputs; Scenario: a return lacking a declared output holds the run |
| The router with no definition — an undefined actor | the architect's fifth risk (history v3); order-2026-09-07-b's first placed enabler | Scenario: the router is an approved role available at the point of work |
| The router deciding — a verdict, a route, a bet | the decision the bet rests on (an option declined: the lead-pm on a cheap model) | Scenario: the router writes no decision to the run |
| The router's tool list and model tier | order-2026-09-07-b (§2, declined as a how) | Out of scope: the maker's, within the router's definition; no scenario names a model or a tool — the run records the model as the definition names it, Scenario: a run starts against a work item from an approved process definition |
| Where the run's state lives; a value too large for the anchor | the architect's second unknown (history v3) | Scenario: a runtime step runs as its definition writes it and Scenario: a human step holds the run for the person — on the anchor; a value too large for it is recorded there as a path, the architect's default, the maker's within it |
| A second turn to get the run's id at start | the designer's criterion (a) | Scenario: a run starts against a work item from an approved process definition |
| The question shown without its kind or default; several questions unnumbered; the router asking again after an answer | the designer's criteria (b), (c); the initiative's D2 (history v4) | Scenario: a human step holds the run for the person; Scenario: an answer at the command line resumes the held run |
| A resumed router that does not first restate the run's id, step, and what it awaits | the designer's criterion (f); the initiative's third designer unknown (history v4) | Scenario: a router started from the anchor resumes the held run |
| Cancel, or a default taken, without confirmation | the designer's criterion (e); the hard-to-reverse record (v3) | Scenario: a run is cancelled with a reason — confirmed in the When; Scenario: an answer at the command line resumes the held run, with (e) riding for the default |
| An ask unanswered past the process's ask-cap | the process-definition typedef (§Run lifecycle: resolves to its default at the cap) | Out of scope: a runtime clock that takes the default unattended is a code runner's, barred by the first no-go; the ask stays held until the person answers or accepts the default — Scenario: an answer at the command line resumes the held run. Proposed default, for the PM role: a router started from the anchor after the cap shows the ask as past its cap and offers the default, taken only on the person's confirmation |
| A run held by inactivity (`hold-after`) | the process-definition typedef (§Run lifecycle) | Scenario: a router started from the anchor resumes the held run — a router that stops leaves the run held at the step last recorded; the window itself is a runtime's, out of scope with the first no-go |
| A start on a process definition that does not stand approved | the feature repository (feat-skills-availability: a definition that does not stand approved yields no loadable skill) | Out of scope here: specified there — no rendering, so nothing for the router to run from; Scenario: a run starts against a work item from an approved process definition holds for an approved one only |
| Which process the first run runs | the initiative's Appetite ("one process run end to end") | Scenario: an approved process runs end to end with the lead-pm at its own steps alone, read of any approved process; the choice is the PM role's at the delivery. Proposed default: the next run the lead shop has to make whose definition holds all three step kinds and a branch on a declared output |
| A Bounded Context shop's process definitions | the initiative's Decomposition section; the decision the bet rests on (its bound on Bounded Context shops) | Out of scope: no context is touched; what runs a BC shop's definitions is the migration review's decision, and until then a shop chooses |
| The rendering target fabro (a rendering target the process-definition typedef names, parked) and the six `fabro:` annotations | the decision the bet rests on (§2.1, the carried exception) | Out of scope: parked until the migration review; no scenario reads them |
| The word "router" already used for the lead-pm reading a request's route | the feature repository (feat-request-routing, v8) | Out of scope: not a behavior of the run — two uses of one word, this feature's vocabulary telling them apart; the glossary entry for the role is due at the delivery |
| A step that runs another process — the composition the first run passes through | the process-definition typedef (the steps section: the sub-process step); product-flow, whose sub-processes initiative-check and the small-change lane the first run is a run of | Scenario: a sub-process step runs from its own definition and returns its result — "one process run end to end" is a run through that composition |
| The router's turns before init-plain-voice frames their voice | the initiative's fifth designer unknown (history v4) | Out of scope: the sibling init-plain-voice's, not bet on; the router's turn carries the step it is on, what it needs, and nothing else — the designer's default, riding as criterion (i) |
| A runtime step's command exits non-zero | the designer's criterion (h); `control-stays-with-the-person` bullet 4 | Scenario: a runtime command that exits non-zero holds the run |
| A runtime step's command that waits on a prompt | the designer's criterion (h); the cli guideline rule 2 | Out of scope: the router answers no command's prompt; a command that needs one is a definition gap the process owner files (the second no-go — the definition is not changed for the run) |
| A hold or cancel naming no run; a cancel with no reason | the designer's criterion (d) | Scenario: a person holds a running run; Scenario: a run is cancelled with a reason — the router asks for the run or the reason, never picks one (criterion (g)) |
| The router answering a question a human step or an ask puts to a person or role | the designer's criterion (g) | Scenario: an ask returned by an agent step holds the run for the role it names; Scenario: the router writes no decision to the run |
| A turn whose question, default, or state is carried by colour, layout, or a table alone; an option reachable only by other than a typed line | the designer's accessibility criteria (A1), (A2) | Scenario: a human step holds the run for the person; Scenario: an answer at the command line resumes the held run; Scenario: a router started from the anchor resumes the held run — text, as the criteria read them |
| A turn naming a thing by other than the vocabulary's word — a second word for the run, the step, the ask | the designer's criterion (i); `consistent-not-uniform` bullet 1 | Scenario: a run starts against a work item from an approved process definition; Scenario: a runtime command that exits non-zero holds the run; Scenario: a condition the router cannot read holds the run and is asked; Scenario: a return lacking a declared output holds the run; Scenario: a human step holds the run for the person; Scenario: an answer at the command line resumes the held run; Scenario: a router started from the anchor resumes the held run — each read with (i); the entries the vocabulary lacks are a row below |
| The core tasks beyond the three this interaction carries — submit output for a check, read a decision, raise a clarify, deliver work for reconciliation | `core-task-parity` bullet 1; the common guideline rule 4 | Out of scope of a scenario: the parity screen at delivery reads the router against the whole list. Proposed default, this role's to record in the core-task list: the first two complete through a run (a check is a process the person starts; a decision is the run's result on the anchor); the last two are a Bounded Context shop's tasks, removed from this interaction with that reason |
| The corpus entries the delivery screen reads and lacks — the vocabulary's step, anchor, work item, process definition, router; the patterns record's assistant entry (the initiative's D2, history v4); the WCAG2ICT applicability record for the assistant and cli types | the designer's fourth and fifth risks (history v4); the common guideline's Layers | Out of scope of a scenario: this role's own action before the delivery screen, which returns "undecidable" against the corpus until each is entered |
| A step of a lead-shop process run by a role a Bounded Context shop fills, or a run reaching a shop's internals | the initiative's Decomposition section (cross-context flow: none) | Out of scope: no approved process definition assigns a step to a Bounded Context shop's role; a run reaches a shop only through that shop's contract (the decision the bet rests on, §2.1), and a step that would cross is a contract question for the solutions architect role, not a behavior of the run |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored by the PO role alone at feature-authoring's draft step, from init-process-runner's Framing and For whom sections (v6, planned; the order order-2026-09-07-b v3, its two enablers placed inside the item); the decision the bet rests on, adr-2026-09-07-coordinator-role (v3, checked), read for what must hold and named in no scenario; seventeen scenarios, all owned by the lead shop per the Decomposition; `@hash:pending` on each, for the lead-pm to fill. The repository read in full: seven features; touch-points feat-roles-availability (the check over the roles, in the Given of the router's availability scenario), feat-skills-availability (a definition not approved yields no rendering — an Edges row), feat-request-routing (the word "router" — the vocabulary and an Edges row); no conflict. Declined or held, with the reason in Edges: the measure's counting (the sibling init-run-measurement's); the ask-cap's unattended default, hold-after, the model tier, and the tool list (the first no-go, or a how); the router's voice (init-plain-voice's). Two proposed defaults for the PM role, in Edges: an ask past its cap; which process the first run runs. Resulting action outside this step's writes: the glossary entry for `router`, due at the delivery per the decision's first consequence. Self-check against the feature fitness set (v8): 1 pass — each When one action (a start, a move, an evaluation, a launch, a completion, a read, an answer, a hold, a cancel, a check run), each Then observable on the anchor, at the command line, or in the check's report, no step naming a model, a tool, a file path, or a launch mechanism; 2 pass — an owning shop per scenario; the interaction type named, so the designer's criteria are due at the next step and the section says so; 3 pass on presence — both tags on all seventeen, hashes disclosed pending; 4 pass — twenty-eight rows from the framing, For whom, both no-gos, the architect's five risks and five unknowns, the designer's (a)–(d), D2, and two unknowns, the Decomposition, the order's enablers and declines, the typedef's run lifecycle, and three repository touch-points, each covered by Scenario name or out of scope with a reason; 5 pass — command line, the For whom's word, with the designer's reading deferred to that role's step; 6 pass — who (the lead-pm; every role), what (a definition runs itself, moved by the router, started, held, resumed, answered, cancelled at the command line), the outcome the framing's ("whoever moves the run carries only the step it is on"). No shell in this session: the lint's checks applied by hand — no banned term, history last, version 1. Not committed. |
| 2 | 2026-09-07 | update | The product designer role's criteria added to the Contributors section at feature-authoring's add-usability step: the type's reading (`assistant` for the router's turns, `cli` for its runtime commands — the initiative's history v4), the three core tasks with their options, nine usability criteria (a)–(i) and three accessibility criteria (A1)–(A3), each a ride-on with met and invalidated, each a hypothesis until the first end-to-end run is observed as measured task completion; eight Edges rows added for the cases the criteria name, two carrying proposed defaults (a scenario for a failing command, the PO role's; the four other core tasks, this role's in the core-task list); the WCAG2ICT applicability record and the corpus entries named as this role's actions before the delivery screen. No scenario text changed; the Interaction types section untouched. Self-check, as verdicts — feature fitness set (v8): 1 pass, no step changed; 2 pass, both criteria present for the named type; 3 pass, tags untouched; 4 pass, every case the criteria name in the table, each covered by Scenario name or out of scope with a reason; 5 pass, unchanged; 6 pass, unchanged. Experience principles (v2): consistent-not-uniform pass — the two guidelines named, the vocabulary's words, no variation; core-task-parity pass with one row — the three tasks with every option, the other four recorded for the delivery screen; agent-is-a-user not applicable — the agent step's prompt is the definition's rendering, screened with the role definition, not here; evidence-not-opinion pass — hypothesis labeled, the evidence form named; accessible-by-standard pass — bullet 2's criteria riding, the record due at delivery; errors-guide-recovery pass — (g), (h); control-stays-with-the-person pass — (e), (f), (g). Mechanical, by hand (no shell): no banned term, Document History last, version 2. Not committed. |
| 3 | 2026-09-07 | update | The solutions architect role's record added to the Contributors section at feature-authoring's add-constraints step: the decomposition (init-process-runner v7, §Decomposition) names no non-functional constraint for this feature — "None", placement in the lead shop's tree, cross-context flow none — so no criterion rides; one Edges row for the boundary it names, out of scope with its reason. Pre-state, from lead-shop-held records: the decomposition; adr-2026-09-07-coordinator-role v3 — bound on Bounded Context shops none new, and the one non-functional requirement the initiative carries, the measure, is the For whom section's, standing in Edges as the PM role's count; the process-definition typedef v7 (§Run lifecycle, already carried by the scenarios) and the role-definition typedef v4 (the harness keys the router's definition must carry — the maker's, within the role chain); compile_process.py and compile_role.py read through their skills, the renderings of their describe answers (uses compile, compile-skill; validate, render, check); the approved process definitions read for the roles their steps name — lead-shop roles, cold-reviewer, researcher, the authority, the originator, the router; none a Bounded Context shop's. No scenario text changed; the designer's passage and the Interaction types section untouched. Principles screen: knowable-shape pass — nothing added names an actor without a definition; contracts-between-contexts pass — the row keeps a shop reachable through its contract only; actor-neutral-discipline pass — no rule forked by who fills a step; local-comprehension pass — the record reads the decomposition alone; bidirectional-conformance pass — no definition changed; intent-provenance pass — the step and its source named. Self-check, as verdicts — feature fitness set (v8): 1 pass, no step changed; 2 pass, owning shop per scenario, designer criteria present, the architect's constraints recorded as none named; 3 pass, tags untouched; 4 pass, the new row out of scope with a reason, no case the record names left out; 5 pass, unchanged; 6 pass, unchanged. Mechanical: no banned term (grep of the lint's list); Document History last; version 3. Not committed. |
| 4 | 2026-09-07 | update | The one revise, by the PO role, on the fifteen findings as ruled. F1 the narrative introduces the router as a role of the lead shop, in §1 and the block. F2 the launch scenario's Then ends at "nothing else of the run". F3 the return scenario's Then states the recorded value equals the value the return names. F4 the ask scenario's Then ends at the hold; the answer scenario widened to a run held at a human step or by an ask. F5 the resume scenario's Given drops the router that remembers; its Then states the first turn cites only the anchor's values and the step. F6 the cancel scenario's When names the confirmation. F7 *a runtime command that exits non-zero holds the run* added; the (h) row cites it, its proposed default closed. F8 the Edges rows cite the feature's own labels — (a), (b), (c), (e), (f), (h), (i) — and the initiative's unknowns as the initiative's. F9 the router-word row out of scope with its reason. F10 criterion (i) and its row list the seven scenarios by name. F11 *the run's context is recorded on the anchor at its end* added; the measure row cites it, the reading across runs init-run-measurement's. F12 the start scenario's Then records the router's model as the definition names it; the tool-list row cites it. F13 the sub-process scenario kept; a row names its source — the typedef's steps section and product-flow's composition. F14 order-2026-09-07-b cited by id in the vocabulary, provenance, and four rows; CEL and fabro each glossed in one clause. F15 the Interaction types section points at Contributors v2. Overload: rows 3, 5, 10, 11, 17, 18 cut to the Scenario names, the CEL clause kept on row 11 for F14; both proposed defaults for the PM role kept (an ask past its cap; which process the first run runs). Nine scenarios `@hash:pending` for the lead-pm: the start, launch, return, answer, ask, resume, and cancel scenarios changed; the non-zero-exit and context scenarios new — nineteen in all; the other ten hashes unchanged. The designer's criteria (a)–(h) and (A1)–(A3) untouched but (i)'s ride-on list; the architect's record untouched. Self-check, as verdicts — feature fitness set (v8): 1 pass — each changed Then one observable outcome, no step naming a model tier, a tool, or a launch form; 2 pass — an owning shop for all nineteen, the two new scenarios in the list; 3 pass on presence — both tags on all nineteen, nine hashes pending; 4 pass — thirty-nine rows, the new row and the two new scenarios in the table, every case covered by Scenario name or out of scope with a reason, no argument left where a name answers; 5 pass — command line, the reading placed at v2; 6 pass — who, what, and the framing's outcome, the router now introduced. Mechanical, by hand (no shell): no banned term; Document History last; version 4. Not committed. |
| 5 | 2026-09-07 | state | `draft` → `checked`: the PM role's pass after the one screen (fifteen findings) and the one revise; every named finding repaired, the wobbly and uncovered ones ruled with the review — two scenarios added (a non-zero exit holds the run; the run's context recorded at its end), the router's model recorded at the start. The nine hashes filled by the lead-pm after the revise. |
| 6 | 2026-09-07 | state | `checked` → `assigned`: the scenario-assignment process (v12) record step, by the lead-solutions-architect role. Assignment — one context, shopsystem-product (the lead shop): the decomposition (init-process-runner v8, Decomposition: none — the runner role, its rendering, and any compiler change in the lead shop's tree; no contract on this branch; cross-context flow none) and the Contributors section agree on all nineteen, and no scenario asks another shop to act (the person at the command line fills a lead-shop role; the harness is the environment); scenarios @hash:7f991d005cc5, @hash:21a0a96524fb, @hash:dfb80114f737, @hash:4353a5e45d00, @hash:c32dd5b8b474, @hash:6c3bd78771bc, @hash:3a9dc4428ded, @hash:c0234aab4a26, @hash:6bcebb4e0073, @hash:6c35e3f87cd0, @hash:767b608029a3, @hash:4d31a463c42e, @hash:8f5b65dca426, @hash:1809e3236eca, @hash:28b4f5a6d5dc, @hash:06a0e40f2325, @hash:d2f51245aa9a, @hash:fe0399304a46, @hash:96124cdccf45, each tagged @bounded-context:shopsystem-product on the line above its Scenario, no hash changed. Pre-state read from lead-shop-held records, none from a context's internals: contracts — none exist on this branch; the guardrail adr-2026-09-07-coordinator-role at v3 (checked), read for §2, §2.1, §3, §4; the role-definition typedef at v4 with its guideline v2 and fitness set v3 — the chain the router's definition goes through; basis/roles/ holding six definitions and no router, .claude/agents/ their six renderings; the process-definition typedef at v7 (§The steps section, §Run lifecycle, §Rendering contract); role-rendering at v7 and skill-rendering at v9; compile_role.py, compile_process.py, bd, and the lint read through their skills alone — compile_role.py admitting `model` among the harness keys its skill's check-failed row names; the ask data type at v2; the glossary at v24, `ask` in two senses and no `router` entry; the backlog order order-2026-09-07-b at v3 (§2, the two enablers placed inside the item); the working principle set v11 and the architecture principle set v6. The feature repository swept in full — eight artifacts, this feature and the seven assigned — no conflict: feat-roles-availability (v6) @hash:ce98da2b6467 and @hash:219547cc8cb5 bind the check @hash:06a0e40f2325 passes through, and @hash:c69e5a0eef5d agrees with its Given (approved); feat-skills-availability (v8) @hash:4899d4bba6ad and @hash:26f78a3ca4a6 bind the re-render the compiler change forces, the loadable form being the compiler's, as banned-words-inlined already showed; feat-role-decisions (v7) @hash:d24c8e22069d asks the router's definition for its Decisions owned section, which @hash:d2f51245aa9a fills with no verdict, route, or bet — consistent; feat-request-routing (v8) @hash:eec1236a2a09 (an ask outside a process's scope becomes a request and the run continues) against @hash:767b608029a3 (an in-process ask holds the run) — the glossary's two senses of `ask`, no contradiction; feat-tool-skills (v8), feat-tool-skills-rest (v8), and feat-typedef-rendering (v8) name no run, router, or step. Unowned: none. Ask: none — the two open questions the feature carries (an ask past its cap; which process the first run runs) are the PM role's at delivery, in Edges with proposed defaults, and no scenario's ownership turns on them. Implementation guidance written: guidance/feat-process-runner-shopsystem-product.md (v1, status written, not sent); maker's evaluation against the implementation-guidance fitness set (v1) — scenario 1 pass: each of the five items in What changes names a lead-shop definition by path and version, a tool by path through its skill, a process by id and version, or the guardrail's section, none a context's internals; scenario 2 pass: scenarios by hash, the guardrail and definitions by id, version, and section, no scenario, criterion, or contract text reproduced; scenario 3 pass: every definition and tool named with path or version, the three invocations given, the order fixed with its reason, the one choice left to the PM role named with what must hold, the maker's choices named as the maker's; scenario 4 pass: each of the fifteen entries in What not to do carries its reason in the guardrail, a no-go, a typedef, a principle, a designer criterion, the decomposition, or the freeze; scenario 5 pass: frontmatter and opening paragraph name the initiative, feature, context, and the nineteen hashes, and item 5 names another role's action at delivery rather than binding a later assignment. Sent: none — the dispatch step is barred under the freeze, no Bounded Context existing on this branch to receive (work item lead-ki66p); the lead shop's own scenarios stand assigned to itself and are taken up in its tree, as the previous assignments recorded. The initiative's Features section still reads checked; its update is the lead-pm's with the commit. |
| 7 | 2026-09-07 | update | Delivery by the lead shop as the owning context, under guidance/feat-process-runner-shopsystem-product.md (v1): basis/roles/router.md (v4, `model: haiku`, tools Read, Bash, Agent) through the role chain — one cold-reviewer screen, one revise — rendered to .claude/agents/router.md, the role check clean; the glossary's `router` (v25); compile_process.py closes each agent step's prompt with the line naming its declared outputs and carries `ask-cap` and `hold-after` into the skill, its skill re-produced and the 22 process skills re-rendered, the skill-rendering check clean. Observed in the running tree as headless sessions `claude --agent router` (the harness lists no agent added mid-session): run lead-4ppfo (small-change, direct) — three runtime steps as written, the non-zero exit of read-anchor held and shown, the cancel taken and the anchor closed on the confirming turn after two defects (the cancel taken unconfirmed; the reason asked again); run lead-5wzgl (request-intake on the request) — the branch on `enter` recorded, the lead-pm's decide-route launched and its return lacking `form` held and shown, the answer recorded and resumed, four branches recorded, land run, then two defects — the human step observe answered by the router from the record, and at open-lane the child lead-ryr33 launched inside the router's own session, recording nothing after `start`; the lane's define and make ran on haiku (every role inherits the router's tier, no rendering naming a model) and make went outside the Definition (feature typedef v13–v15, the two texts overwritten as renderings); the child stands held, the parent held at open-lane, for the lead-pm's decision. Router context per segment recorded on each anchor from the harness's usage report; the end-to-end scenario and the context-at-end scenario stand unobserved. Not committed. |
