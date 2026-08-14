---
type: experiment-index
id: basis
status: experiment
created: 2026-08-10
updated: 2026-08-14
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
Three principles in the TOGAF four-part form (Name / Statement / Rationale /
Implications, MUST/SHOULD per BCP 14). The first one — *Define before you
build* — is why every other file on this tour exists before any output
does. At the bottom, the composed fitness screen is applied to the
principles themselves, so the format and its own quality check are shown
together. *Comes into play:* whenever a definition is written or judged,
and at every review where someone asks "does this rule earn its place?"

**The work is defined once, in one place —
[`processes/stakeholder-presentation.md`](processes/stakeholder-presentation.md).**
The source of truth for the whole run: a purpose, four observable outcomes
(O1–O4), and four activities (A1 Frame → A2 Compose → A3 cold-read loop →
A4 Deliver), each written as an entry / tasks / validation / exit cell. The
format composes named parts, each taken unchanged from its source: ISO
24774's name/purpose/outcomes header, IBM ETVX's activity cells,
Essence-style state exits. The
A3 loop shows the dual-exit rule you asked for: a reached-state success
exit *and* a 4-round failsafe cap. The `runtime.*` annotation lines are the
translation layer — metadata that fabro or Claude Code projections consume
and the definition itself ignores. *Comes into play:* whenever anyone asks
"what is this activity supposed to do, and when is it done?" — and as the
compile source for the two projections below.

**An agent actually runs it through the compiled skill —
[`skills/stakeholder-presentation/SKILL.md`](skills/stakeholder-presentation/SKILL.md).**
This is what Claude Code loads at runtime. It is a *derived projection* of
the process definition — its front-matter records `derived-from` and
`conformance-checked`, and that conformance check earned its keep on day
one: the pre-experiment skill on `main` lacks the round cap the definition
requires. *Comes into play:* at runtime, every time the process runs; and
at release time, when conformance against its definition is re-checked.

**A second seat verifies the output —
[`roles/cold-reviewer.md`](roles/cold-reviewer.md).**
The reviewer role in the role-definition format: front-matter is the
capability contract (read-only tools, a turn cap), the body is 4–6
accountability bullets plus one exclusive domain (the round's verdict).
Deliberately absent: any sequencing text — *when* the reviewer acts belongs
to the process definition, not the role. *Comes into play:* once per A3
review round, always as a fresh instance — the value is the cold read.

**The output itself has a schema —
[`artifacts/decision-brief.md`](artifacts/decision-brief.md).**
What the produced document must be: its ancestry (`request →
decision-brief`, so a validator that only knows the generic type can still
check it), required front-matter and sections, and a Definition-of-Done
commitment with a stated consequence — a brief that fails it returns to the
author and is not deliverable. (Format: ISO 15289's generic-type scheme,
DITA-style ancestry declaration, Scrum's artifact-commitment pairing.) *Comes into play:* at A2 while the author
writes, and at review as the source of the derived checklist.

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
practice, not a bespoke engine. *Comes into play:* at every A3a round, and
any time a delivered brief is re-verified later.

**And a second process proves the format generalizes —
[`processes/reconcile-and-close.md`](processes/reconcile-and-close.md).**
Loop-free, mechanical, three activities with an atomicity rule
(consume+close as one act) — the finite per-message shape fabro runs. Same
header, same cells, no loop machinery needed. *Comes into play:* every time
a BC's `work_done` returns; here, it is the control case showing the format
isn't shaped around one example.

## How the files point at each other

Process → role (who verifies), skill (what runs it), artifact kind (what it
produces). Artifact kind → guideline (what good prose is) and fitness set
(how quality is judged). Everything → principles. Every arrow above is a
real link inside the files — follow any of them and you land where the tour
just took you.

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
  Uniform base (`type`, `id`, `status`, `created`, `updated`) plus per-kind
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

## Review asks (all default-free — this is the experiment)

Per slice: does the format hold on a real example — anything missing,
anything over-engineered? Across slices: does the linking model read as one
system? Standing from the pilot: does the composed format read as one
format; annotation shape for
the fabro source-of-truth requirement; the dual-exit loop rule; the
derived-carrier rule for process-shaped skills.

## After review

Refine here, on this branch, until the formats settle. Ratification happens
on the refined exemplars; only then does anything migrate into the live
corpus or roll out across the system.
