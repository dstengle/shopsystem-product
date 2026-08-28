---
type: artifact-typedef
id: process-definition-typedef
defines: process-definition
owner: product-authority
status: approved
approved: 2026-08-22
version: 6
created: 2026-08-19
updated: 2026-08-28
ancestry: [definition, process-definition]
---

# Artifact type: process-definition

## Identity and ancestry

- **Type:** `process-definition` — the single source of truth for a
  process: what it is for, what a run produces, and every step in a form
  a runtime can construct a workflow from. Skills, flow
  diagrams, and fabro graphs (fabro is the fleet's workflow-orchestrator
  runtime) are its renderings.
- **Produced by:** seed drafting or governed evolution. **Consumed by:**
  the compiler (renderings), agents (via the rendered skill), reviewers
  (conformance and loop-exit review), fabro (via annotations).

## Required frontmatter

`type: process-definition`, `id`, `owner`, `status`, `created`,
`updated`; `produces` (artifact
types a run creates; the generic root `definition` covers runs creating
definition documents; empty when the run's value is state change);
`condition-language: cel`; optional: `carried-by` (the rendered skill's
id), `condition-functions` (declared extensions, name and signature),
`annotations` (process-level rendering metadata, keyed by rendering
target); `hold-after` (ISO 8601 duration — the inactivity window after
which the runtime holds a run; required for any process that carries a
conversation); `ask-cap` (ISO 8601 duration — how long an ask may stand
unanswered before its default applies; required for any process whose
steps carry `asks`).

## Required sections

1. **Purpose** — one short paragraph.
2. **Guiding statement** (optional) — directs judgment across the whole
   process; the compiler copies it into every rendering.
3. **Outcomes** — each names the step or check that witnesses it.
4. **Roles** — roles and their accountability; role files carry identity,
   never sequencing.
5. **Flow (compiled)** — the diagram generated from the steps; never
   edited by hand.
6. **Data** — process-local value names. Simple types (JSON Schema
   primitives) inline; every structured shape is a `$ref` to a defined
   type with an explicit source: `from:` is a relative link to the
   defining file, or `pkg:<package>/<type>` when the type lives in
   another package and is fetched through that package's contract tool
   (e.g. `shop-knowledge schema session-record`). Every distinct `$ref`
   carries `from:` at least once; the linter verifies local sources
   define the referenced type. No structured shape is ever defined here.
   A value may declare `initial` — its value at run start.
7. **Steps** — the executable part (shape below).
8. **Derived checks** — a table: outcome, check, kind, where; every row
   cites its clause or is deleted.

Header elements 1–4 are bolded labels before the first heading; 5–8 are
markdown headings in order (a section is a heading, per the
artifact-typedef rule).

## The steps section

Top-level keys: `start` (first step id); optional `parameters` (data
values supplied at instantiation rather than produced by any step);
optional `result` (the data value a run returns — the artifact, not a
status record; omit only when the outcomes pin the run's value). `end`
is the reserved terminator id for `next`. Each step:

- `id`, `name`; `run-by` — `{role, execution: agent}`,
  `{role, execution: human}` (a role a person holds, e.g. an authority review), or `{execution: runtime}`; `fresh-context: true` where a role
  must not carry memory between runs.
- `inputs` / `outputs` — lists of declared data names; the typed contract
  is the isolation mechanism (a step reads only what it lists).
- Agent and human steps carry `prompt` — **the only prose allowed in a
  step** (for a human step it is the question the review puts).
- Runtime steps carry `set` (CEL assignments to data values or their
  fields), `run` (command templates
  with `${...}` interpolation from typed inputs — a scalar interpolates
  as its value, an array as one shell word per element, a field of an
  array's items as `${name[].field}` yielding one word per item in
  item order, so a template may run a shell `for` over it or pair two
  such fields positionally; `name` may be a data name or a field path
  into one. A `run` step yields at most one output: the template's
  standard output — split by line for an array value; `atomic: true`
  binds the lines into one all-or-nothing act), or `branches`.
- `checks` — CEL expressions over declared data.
- Routing: `next`, or `branches` of `{label, when (CEL), next}` rows plus
  one `else`. **Every loop declares its exits as labeled branch rows** —
  a reached-state success exit, a round or budget cap, or both.
- `asks` — optional list of role ids the step may put an ask to (the
  [`ask`](../types/ask.md) data type). An agent or human step listed
  with `asks` may return an ask in place of its outputs; a step without
  `asks` may not ask. A process with asking steps declares an `ask` data
  value (`$ref: ask`) and lists it in each asking step's inputs. Every
  ask names a `default` and a `checkpoint`; the step's prompt states
  what kind of information it may ask for — never a judgment the step's
  role owes. A step returns at most one ask per run — the loop's exit —
  and a second resolves `defaulted` at once. Early steps ask cheaply;
  an ask from a late step wastes the work not in its checkpoint.
- `annotations` — per-step rendering metadata keyed by target (e.g.
  `fabro: {model, max_attempts}`); the definition itself ignores them.
- `run-by: {execution: sub-process, process: <process-id>, from: <source>}`
  runs another process definition as one step: the step's inputs map to
  the child's parameters and its outputs receive the child's result. A
  conversation invoked this way is a branched conversation: the child's
  anchor records the parent run.

## Run lifecycle

A run is one execution of a process, anchored to a work item in the
registry. Run states: `running`, `held`, `done`, `cancelled`.

- **Hold** pauses a run: the current step and every data value persist in
  the run's anchor, and the work item records the state. A held run is
  resumed at its recorded step or cancelled with a reason — never
  silently dropped.
- The `hold-after` window makes parking automatic: a run with no activity
  inside the window is held by the runtime. Unfinished work parks itself
  with a named resume point; nothing dangles in the lead repo.
- **Ask** holds a run the same way, with the ask recorded on the anchor
  and routed to whoever fills the role it names — a person or an agent;
  the answer is written to the ask and the run resumes at the asking
  step with the ask in its inputs, in a fresh context loaded from the
  step's declared inputs and the checkpoint. There is no synchronous
  form: no step waits in place for an answer. An unanswered ask resolves
  to its `default` at the process's `ask-cap` (an ISO 8601 duration,
  required for any process whose steps carry `asks`), and the run
  resumes on the default with the ask marked `defaulted`; cancelling a
  held run marks its ask `cancelled`. Answering is an activity of the
  answering role: a human step for a human-held role, or a step the
  answering role's process names — those steps are defined in the
  processes that answer, not here. The registry that anchors runs
  records every ask; asks per run, per role, and per kind are read from
  it. An ask that recurs across runs is a gap in a definition; the
  answering role files the definition change, and the ask stops.
- **Cancel** closes the run's work item with a reason and files the
  resulting actions the outcomes demand.

## Rendering contract

The compiler generates: the in-document flow diagram (typed inputs and
outputs on every node; the result on the end node) and the skill —
front-matter (`generated: true`, `generated-by`, `derived-from`,
`source`, `source-digest`) and body (purpose, guiding statement, result,
diagram, one section per step with the prompt verbatim). Conformance
check: re-run the compiler and diff.

## Commitment (Definition of Done)

A process definition is done when it compiles — every `$ref` resolves,
the diagram and renderings generate, `result` (if declared) names a data
value — and every loop declares its exit. **Consequence on failure:** it
cannot be dispatched, carried by a skill, or cited by a check.

## Sources

ISO/IEC/IEEE 24774 (name/purpose/outcomes header); GitHub Actions (step
records with typed inputs/outputs); CNCF Serverless Workflow
(data-condition transitions); CEL — Common Expression Language
(mechanically translatable conditions); Essence-style state exits plus a
round cap (the dual-exit rule).

## Derived review checklist

- Compiles clean: refs resolve, diagram and renderings regenerate
  byte-stable. *(Commitment)*
- No prose inside step records outside `prompt` fields; section
  introduction prose is body text, not step content. *(§The steps section)*
- Every loop has labeled success and/or cap exits. *(§The steps section)*
- Every step with `asks` belongs to a process with `ask-cap` and lists
  the `ask` value in its inputs; every ask names a default and a
  checkpoint, and its `to` is in the step's `asks`; one ask per step per
  run. *(§The steps section, §Run lifecycle)*
- Outcomes each name a witness. *(§Required sections 3)*
- `result`, if absent, is justified by outcomes that pin the run's value.
  *(§The steps section)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
| 4 | 2026-08-25 | update | Owner decision: the ask mechanism defined, held-and-resumed only — a step may carry `asks` (role ids) and return an `ask` data value in place of its outputs; the run holds, the role answers, the step resumes in a fresh context from its inputs and the ask's checkpoint; `ask-cap` bounds an unanswered ask with its default; a recurring ask is a definition gap. No synchronous form. |
| 4 | 2026-08-25 | review | Screened with the ask data type: findings — the ask loop lacked an exit; the resumed ask had no data name; answering had no named activity; the recurrence measure had no channel; an old use of "ask" collided. Repaired in place: one ask per step per run, the `ask` value declared and listed, answering placed in the answering role's process, the registry named as the count's home, wording fixed. |
| 5 | 2026-08-28 | update | Owner direction, from the scenario-assignment screen: how arrays and item fields interpolate into a `run` template defined, so a fan-out over contexts is a defined form. |
| 6 | 2026-08-28 | update | From the scenario-assignment screen: how a `run` step yields its output (standard output, line-split for arrays) and that interpolation names may be field paths — both were silent conventions. |
