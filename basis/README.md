---
type: experiment-index
id: basis
status: experiment
created: 2026-08-10
updated: 2026-08-22
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

## Where decisions are recorded

The numbered-decision ledger this index once carried is removed by
owner direction (2026-08-23): decisions live as the changes they
produced, recorded in each changed artifact's Document History on the
`rebaseline` branch. The repository history retains the removed
entries.

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
eleven rulings (R1–R11), and **approved the refined exemplar formats the
same day**. Every exemplar now carries `status: approved`,
`approved: 2026-08-19`, and an `owner` in its front-matter.

## The seed layer (drafted on approval — awaiting review)

The definition regress terminates at a hand-approved seed: the
[principle set](principles.md) plus one artifact-typedef per definition
document type, each drafted in the approved typedef format itself. This
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

## The full approval surface (every file on this branch)

What approving means per group: an **approved** file is the standard work
is checked against; a **rendering** is generated and carries its
source's status; **apparatus** is not approved — it exists to prove the
formats and its production home is a BC. Nothing on this branch remains
in draft.

**Approved 2026-08-22 (the seed layer, R23):** the nine seed typedefs
listed above; [`principles.md`](principles.md) (nine working
principles); the
[`definition-chain-migration`](processes/definition-chain-migration.md)
and [`session-handoff`](processes/session-handoff.md) processes;
[`types/definition-chain.md`](types/definition-chain.md) (derived, never
hand-written), [`types/correction.md`](types/correction.md), and
[`types/validation-report.md`](types/validation-report.md).

**Approved 2026-08-22 (the conversation model, R20 + R21):** all three
conversation types —
[`processes/discovery-conversation.md`](processes/discovery-conversation.md)
(interlocutor dialogue; closes onto a session record via the
session-handoff sub-process),
[`processes/work-conversation.md`](processes/work-conversation.md)
(scoped to one work item; exchanges land on the item),
[`artifacts/review-record.md`](artifacts/review-record.md) (anchor type:
material, append-only ruling ledger, State for hold/resume),
[`processes/review-conversation.md`](processes/review-conversation.md)
(observe → route → apply, authority-only exits, `hold-after` auto-park).
Its first instance is this conversation's own record,
[`records/review-new-basis.md`](records/review-new-basis.md) (work item
`lead-kmrd4`, ledger from R19).

**Approved 2026-08-19 (the exemplar set):** `principles`' four original
principles (superseded by the amended draft above), `glossary.md` (since
extended by rulings), both original processes, `types/frame|review|verification`,
`artifacts/decision-brief|request`, `roles/cold-reviewer.md`, both
guidelines, `fitness/decision-brief.fitness.md`.

**Renderings (generated, never edited):** the flow diagrams inside every
process definition;
[`skills/stakeholder-presentation/SKILL.md`](skills/stakeholder-presentation/SKILL.md);
`.claude/shop/principles.md` on `main`.

**Apparatus:** [`tools/compile_process.py`](tools/compile_process.py)
(diagrams + skills), [`tools/compile_principles.py`](tools/compile_principles.py)
(the prompt rendering), [`tools/lint_basis.py`](tools/lint_basis.py)
(structure, references, vocabulary — and `--derive-chain`). The linter
runs clean on this branch; production homes are BC deliverables.

**Reference sources:** every `$ref` in a process data block now carries
an explicit `from:` — a relative link to the defining file, or
`pkg:<package>/<type>` for a type owned by another package; the linter
and compiler verify local sources actually define the referenced type.

After the seed is approved: migration into the live corpus — the PDR-032
registry amendment (open, versioned type set), the ADR-059 wording
alignment ("projection" → "rendering"), generated-file banners to
front-matter (R2), and system-wide application of the base writing style
(R5).
