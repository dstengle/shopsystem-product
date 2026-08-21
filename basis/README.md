---
type: experiment-index
id: basis
status: experiment
created: 2026-08-10
updated: 2026-08-20
---

# The new-basis experiment — a walkthrough

This branch (`experiment/new-basis`, worktree-isolated — nothing touches
`main` or the live corpus) holds one experimental slice per foundational
format from the decision brief's Ask 0. The slices are not seven samples:
they all come from **one real domain** — making a presentation the product
authority can decide from — so you can read them as a story, in the order
the files come into play. That story is below; each stop says what the file
is, why it exists, when it gets used — and which established forms it is
built from, because per ruling R4 the documents themselves no longer carry
that provenance: they read exactly as they would in the final system, and
this index is where the show-and-tell lives.

## The story: one run, seven formats

**It starts with rules about how we work — [`principles.md`](principles.md).**
The document opens by defining what a good principle looks like — the
statement carries the rules and the only normative keywords; the rationale
carries the why; the implications are the price tag, derivable and
actor-named — and then holds four principles in that TOGAF four-part
form. The first — *Define what good looks like up front* — is why every other file
on this tour exists before any output does, and why the cold reviewer is
never the author; the newest — *Use defined terms* — is why the next stop
exists. At the bottom, the fitness screen applies the intro's
own tests to the principles above it, so the definition and its derived
check are shown together. *Comes into play:* whenever a definition is
written or judged, and at every review where someone asks "does this rule
earn its place?"

**The words themselves are governed — [`glossary.md`](glossary.md).**
The defined-term list is the glossary combined with every schema element
name; when a defined term fits, writers use it instead of coining one.
The restricted language is the `use-defined-terms` principle in practice,
and its first conviction happened during this review: the data format
had coined "kind" beside the already-defined "artifact type", and the
synonym was removed everywhere. *Comes into play:* before any term is
coined, and at review whenever two words might mean one thing.

**The work is defined once, in one place —
[`processes/stakeholder-presentation.md`](processes/stakeholder-presentation.md).**
The source of truth for the whole run, and per ruling R6 it compiles: after
the ISO 24774 header (purpose, outcomes, roles), the definition is a typed
data section and a steps section, both plain YAML. Every step names its
inputs and outputs against the declared types; branch conditions are CEL
(Common Expression Language, the expression standard Kubernetes uses)
expressions a runtime can execute directly; the only prose inside the
steps is the prompt each agent step feeds its agent. The step shape
composes GitHub Actions' step/typed-io form with CNCF Serverless
Workflow's data-condition transitions — deliberately between loose prose
and full BPMN. The dual-exit loop is now two labeled branch rows on
`route-verdict`: a success condition and a `round >= 4` failsafe. The
first compiled output sits in the document itself: the "Flow (compiled)"
Mermaid diagram, generated from the steps by
[`tools/compile_process.py`](tools/compile_process.py). Per-step
`annotations` carry the fabro/Claude-Code metadata the definition itself
ignores. *Comes into play:* whenever anyone asks "what is this step
supposed to do, and when is it done?" — and as the compile source for the
renderings below.

**A small compiler proves the format carries enough data —
[`tools/compile_process.py`](tools/compile_process.py).**
Experiment apparatus (the production compiler is a BC deliverable): it
parses a definition's front-matter, data, and steps, regenerates the
in-document flow diagram, and generates the skill below outright. If the
compile fails or the outputs are wrong, the format is missing data — that
is the test. *Comes into play:* on every change to a process definition.

**An agent actually runs it through the compiled skill —
[`skills/stakeholder-presentation/SKILL.md`](skills/stakeholder-presentation/SKILL.md).**
This is what Claude Code loads at runtime, and nobody wrote it: the
compiler generated it, front-matter (`generated: true`, `source-digest`)
and body alike. The body is the diagram plus one section per step —
run-by, typed reads/writes, checks, routing, and the prompt copied
verbatim; runtime steps appear as their raw `set`/`run`/`branches`
records. Conformance checking is now mechanical: re-run the compiler and
diff. *Comes into play:* at runtime, every time the process runs; and at
release time, when the digest is re-checked against the definition.

**A second seat verifies the output —
[`roles/cold-reviewer.md`](roles/cold-reviewer.md).**
The reviewer role in the role-definition format: front-matter is the
capability contract (read-only tools, a turn cap), the body is 4–6
accountability bullets plus one exclusive domain (the round's verdict).
Deliberately absent: any sequencing text — *when* the reviewer acts belongs
to the process definition, not the role. *Comes into play:* once per
`cold-read` round, always as a fresh instance — the value is the cold
read, and the step's typed inputs enforce it: the reviewer receives the
brief and nothing else.

**The output itself has a schema —
[`artifacts/decision-brief.md`](artifacts/decision-brief.md).**
What the produced document must be: its ancestry (`request →
decision-brief`, so a validator that only knows the generic type can still
check it), required front-matter and sections, and a Definition-of-Done
commitment with a stated consequence — a brief that fails it returns to the
author and is not deliverable. (Format: ISO 15289's generic-type scheme,
DITA-style ancestry declaration, Scrum's artifact-commitment pairing.)
*Comes into play:* at `compose` while the author writes, and at review as
the source of the derived checklist.

**Not every value is a document — [`types/`](types/).**
Data types: named, schema-defined structures that pass between process
steps but are not human-readable artifacts — `review`, `frame`,
`verification`. Each lives in its own file, so a process
`data` block never defines a structured shape inline: simple types
(JSON Schema primitives) inline, everything else a `$ref` to a defined
type. In the live system these resolve through the schema registry
(shopsystem-knowledge's typedef system, the shop-msg catalog); the files
here stand in for that registry. *Comes into play:* whenever a step
declares what it reads and writes, and whenever a condition dereferences
a field.

**"Well-written" is defined, not vibed —
[`guidelines/stakeholder-communication.md`](guidelines/stakeholder-communication.md).**
Five rules in the Google/Microsoft style-guide anatomy (voice principle →
compiled highlights → rules with before/after pairs → precedence), each rule
carrying Deming's three elements: a test, a criterion, a yes/no decision —
plus the derived check each rule feeds. It layers on the authority-authored
[`guidelines/base-writing-style.md`](guidelines/base-writing-style.md) —
the rules for *all* human-readable prose (conclusion first at every scale,
one idea per sentence, active voice with named actors, no metaphors as
technical terms, insider references explained or cut) — and adds only what
is specific to decision documents. *Comes into play:* while writing (its
Highlights block is the layer compiled into the author's context) and
whenever a mechanical style check needs a rule to cite.

**Quality gets judged against written scenarios —
[`fitness/decision-brief.fitness.md`](fitness/decision-brief.fitness.md).**
Your Gherkin proposal, live: four Given/When/Then scenarios the cold
reviewer scores. The front-matter is the schema-level guardrail
(`judged: true`, `executable: false`), the tree is segregated from
`features/`, and the closing table compiles each `Then` one-for-one into a
judge-rubric assertion — proving the tests rest on established evaluation
practice, not a bespoke engine. *Comes into play:* at every `cold-read`
round, and any time a delivered brief is re-verified later.

**And a second process proves the format generalizes —
[`processes/reconcile-and-close.md`](processes/reconcile-and-close.md).**
Loop-free, mechanical — the finite per-message shape fabro runs. Same
header, same data and steps sections, no loop machinery needed; its
runtime steps show the other half of the format: `run` command templates
with `${...}` interpolation from typed inputs, and an `atomic: true` flag
binding consume+close into one act. *Comes into play:* every time a BC's
`work_done` returns; here, it is the control case showing the format
isn't shaped around one example.

## How the files point at each other

Process → role (who verifies), skill (what runs it), and every type its
steps read and write (`$ref` into `artifacts/` and `types/`). Artifact
type → guideline (what good prose is) and fitness set (how quality is
judged). Every term → the glossary or a schema element. Everything →
principles. Every arrow above is a real link inside the files — follow
any of them and you land where the tour just took you.

## Review rulings (accumulated as the review proceeds)

- **R1 (2026-08-10): all markdown MUST have front-matter.** Applied
  everywhere; moved governance declarations (judged/non-executable,
  derived-from, promotion state) out of comments into checkable fields.
- **R2 (2026-08-11): no HTML comments in markdown.** Comments load into
  agent context while staying invisible when rendered — an ungoverned
  channel — and are dead to checks. Bodies contain only rendered-visible
  text; meta-commentary lives here in the index. Rollout consequence: the
  live corpus's generated-file banners become front-matter fields
  (`generated: true`, `read-only: true`).
- **R3 (2026-08-11): front-matter is identity plus data — never prose.**
  Uniform base (`type`, `id`, `status`, `created`, `updated`) plus per-type
  data fields; no titles or descriptions duplicating the body, no
  sentence-valued fields. Runnable files (roles, skills) keep their
  functional contract keys (`name`, `tools`, `maxTurns`) first.
- **R4 (2026-08-14): exemplar documents carry no experiment commentary.**
  The "format slice" openers explaining which format a file demonstrates
  were experiment commentary inside documents meant to read as real. An
  exemplar reads
  exactly as it would in the final system; format provenance belongs to the
  format's specification (carried by this index until the seed layer's
  format spec exists), and show-and-tell lives only here. Applied: openers
  stripped from the principles, both processes, the artifact schema, the
  guideline, and the fitness set's body; citations remain only where they
  are real content (an ask's evidence, a rule's cited source).
- **R5 (2026-08-14): the authority's base writing style governs all
  human-readable prose.** Landed verbatim as
  [`guidelines/base-writing-style.md`](guidelines/base-writing-style.md);
  every document type is a format layer on top of it and never overrides
  it. Applied across `basis/`: banned metaphor-terms removed ("scar
  tissue", "load-bearing", "surface" as a noun for inputs), insider
  references now explained in one plain sentence each, passive
  constructions given named actors.
- **R6 (2026-08-18): process definitions compile.** The ETVX prose cells
  were too loose to construct a workflow from; full BPMN would cost too
  much processing. The middle: every step is a YAML record with named,
  typed inputs and outputs; branch conditions are CEL expressions a
  runtime can translate to code mechanically; the only prose in a step is
  the prompt an agent step feeds its agent; runtime steps carry `set`
  assignments or `run` command templates instead of prose. The first
  compiled output is the flow diagram in the definition itself, and the
  skill is now genuinely generated by `tools/compile_process.py` — not
  hand-written to look derived. Applied to both processes; the old
  hand-written skill is replaced by compiler output.
- **R7 (2026-08-19): a process definition may carry a guiding statement.**
  R6's compile dropped the old skill's opener ("Lead with the answer…"),
  and that loss was a defect: a directional statement belongs in the
  definition, not only in a rendering. Home: a **Guiding statement**
  element in the definition header, beside Purpose — the prose zone, since
  it directs judgment rather than executes. The compiler copies it into
  every generated rendering right after the purpose, so it always lands
  in the generating context. Optional per process: the loop-free
  reconcile-and-close carries none.
- **R8 (2026-08-19): the first principle is reoriented, and principles
  now define themselves before the reader meets one.** Named *Define what
  good looks like up front* (`define-good-up-front`; the review's first
  pass tried "one definition, two seats" and the authority renamed it):
  one definition of good MUST drive both the
  performing and the checking of every activity, with the check in a
  different role holding different motivations — definition only on
  checks buys expensive rework after implementation; definition only up
  front invites gaming and loses outside perspective. The document now
  opens with "What a good principle looks like": normative keywords live
  in statements only, implications are the derived price tag (every one
  traceable to a statement clause and named to the actor who absorbs it),
  and the fitness screen gained the two matching rows. Misfiled
  implications were refiled — enforcement norms out of implications,
  actors named ("Reviewers compare work to the written definition; their
  own taste is not the standard").
- **R9 (2026-08-19): schemas live apart from processes and are
  referenced; terms come from the defined list.** New authority-authored
  principle `use-defined-terms`: important terms MUST be defined in the
  system — the term list is the glossary plus every schema element name —
  and a defined term MUST be used when one is available. Its first
  conviction was this review's own data format: "kind", coined beside the
  already-defined "artifact type", is removed everywhere; JSON Schema's
  own `$ref` replaces it as the reference word. Process `data` blocks now
  define no structured shapes: simple types (JSON Schema primitives)
  inline, everything else a `$ref` to a defined type — artifact types in
  `artifacts/`, and data types in `types/` for structures that are not
  human-readable documents (a `review`, a `verification`). This replaces
  the rejected promotion-on-second-use idea: "no inline structured types"
  is a one-line mechanical check, enforceable at compile. The live-system
  home is the registry that already exists — shopsystem-knowledge's
  typedef system (PDR-032, ADR-059) plus the shop-msg catalog schemas —
  not a new one. Rollout consequences: PDR-032's fixed set of eight
  artifact types must open into an evolving, versioned registry (existing
  types' schemas will change as processes evolve, and new types will be
  added); the glossary lands as a governed artifact; the compiler grows
  the resolver check (`$ref` must name a defined type).
- **R10 (2026-08-19): the process result is the artifact, not a status
  record.** The `deliver` step had returned a `delivery` structure of two
  booleans, hiding the decision-brief's continuity through the run. Now
  the steps declare `result: brief`; `deliver` outputs the brief itself —
  status set to "delivered", the round log attached as its `verified-by`
  record — and the `delivery` data type is deleted. The compiler
  validates that `result` names a declared data value, prints it on the
  diagram's end node, and states it in the compiled skill, so the
  artifact's path from `compose` to the reader is visible start to end.
- **R11 (2026-08-19): typedefs carry no pinned example links.** The
  decision-brief typedef pointed at a worked sample that stopped
  conforming shortly after it was written — a pinned example is a copy of
  the schema's intent that drifts as the artifact collection changes. The
  section is removed. Examples are found, not pinned: the validator can
  list conforming instances of a type on demand, so the registry always
  shows current examples and never a stale one.
- **R12 (2026-08-20): proposals obey the principles they propose under.**
  The authority audited the migration proposal against the principle set:
  it failed three of four — chat prose instead of a defined process, no
  exits or failure paths, ungoverned context, coined terms. Remediation,
  applied: the migration now exists as a draft process definition
  (`processes/definition-chain-migration.md`) with failsafe and park
  paths, compiled; a new implication on `define-good-up-front` makes the
  rule standing (a proposal for an activity is written as a draft
  instance of the activity's type, so its checks run before review); the
  four working principles converged in dialogue but never drafted —
  external-standards-first, single-source-of-truth,
  feedback-loops-with-consumers, delivery-verified — are now in the set;
  the principle set therefore returns to `status: draft` for
  re-ratification; coined terms are in the glossary; step seats now
  include `execution: human` for authority sittings; and the
  principle-set typedef gains `scope` (working | architecture) plus the
  rule that undefined-format content enters a set only by rewrite, never
  as-is.
- **R14 (2026-08-21): memory writes frozen; handoff is a defined
  process; the second seat runs on everything.** Rulings from the
  principles validation: all memory writes frozen (recorded in the shop
  primer, loaded every session) pending the disposition ruling; session
  handoff standardized as
  [`processes/session-handoff.md`](processes/session-handoff.md) — the
  session record is the only cross-session carrier, durable corrections
  amend the definitions they correct, and the validate loop has dual
  exits with a filed-defect failsafe. Three fresh-context cold reviews of
  the fifteen basis documents returned zero clean; the repair pass
  landed: section identity defined (a section is a heading), the
  frontmatter identity base made additive, the keyword check's
  mentions-versus-uses hole closed, "different motivations" replaced with
  the checkable "different accountability", process `parameters` and the
  `end` terminator and `initial` added to the typedef, the schema
  dialect declared (compact `fields`, required-by-default,
  `optional: true`), precedence unified (principle beats typedef beats
  guideline; base style never overridden by guidelines), the fitness
  compile-mapping made one-for-one with numbered scenarios, and the
  glossary brought up to its own Definition of Done.
- **R13 (2026-08-20): the principles load into every prompt, not only
  into documents.** A working-scope principle set is compiled into the
  session prompt chain: `tools/compile_principles.py` renders the
  statements (name, slug, statement — norms only; rationales stay in the
  source) into a generated file with source digest, placed at
  `.claude/shop/principles.md` on `main` and included by `CLAUDE.md`
  ahead of the primers. Single source holds: the rendering is generated,
  never edited; the source document wins on conflict. Regeneration is
  part of any principle amendment landing.

## Review asks (all default-free — this is the experiment)

Per slice: does the format hold on a real example — anything missing,
anything over-engineered? Across slices: does the linking model read as one
system? Standing from the pilot: does the composed format read as one
format; annotation shape for
the fabro source-of-truth requirement; the dual-exit loop rule; the
derived-carrier rule for process-shaped skills. New with R6: is CEL the
right condition language; is the step record (GitHub-Actions-shaped io +
Serverless-Workflow-shaped transitions) the right weight; should the
header's purpose and outcomes stay prose or structure too; is the
compiled SKILL.md the right runtime carrier shape for Claude Code.

## After review

The authority declared this review stage complete on 2026-08-19, after
eleven rulings (R1–R11), and **ratified the refined exemplar formats the
same day**. Every exemplar now carries `status: ratified`,
`ratified: 2026-08-19`, and an `owner` in its front-matter.

## The seed layer (drafted on ratification — awaiting review)

The definition regress terminates at a hand-ratified seed: the
[principle set](principles.md) plus one artifact-typedef per definition
document type, each drafted in the ratified typedef format itself. This
closes R4's open loop — format provenance now lives in each typedef's
Sources section, not in this index (the story above keeps narrative
copies only). All are `status: draft` until the authority reviews them:

- [`artifacts/definition.md`](artifacts/definition.md) — the generic root
  every definition type specializes.
- [`artifacts/artifact-typedef.md`](artifacts/artifact-typedef.md) — the
  typedef of typedefs; conforms to itself; where the regress stops.
- [`artifacts/process-definition.md`](artifacts/process-definition.md) —
  the compiled-process format (R6–R10) as a spec: step records, CEL
  conditions, dual exits, result, rendering contract.
- [`artifacts/principle-set.md`](artifacts/principle-set.md) — the
  four-part principle format plus the screen (R8).
- [`artifacts/data-type.md`](artifacts/data-type.md) — registered
  non-document structures (R9).
- [`artifacts/role-definition.md`](artifacts/role-definition.md) —
  capability contract + accountabilities, no sequencing.
- [`artifacts/quality-guideline.md`](artifacts/quality-guideline.md) —
  voice, highlights, layered rules with Deming's three elements.
- [`artifacts/fitness-set.md`](artifacts/fitness-set.md) — judged G/W/T
  with the guardrail front-matter and compile mapping.
- [`artifacts/glossary-typedef.md`](artifacts/glossary-typedef.md) — the
  restricted-language list (R9).

After the seed is ratified: migration into the live corpus — the PDR-032
registry amendment (open, versioned type set), the ADR-059 wording
alignment ("projection" → "rendering"), generated-file banners to
front-matter (R2), and system-wide application of the base writing style
(R5).
