---
type: adr
id: adr-2026-09-05-typedef-rendering
title: An artifact type's typedef is its one hand-edited standard; its guideline and fitness set are renderings of it
status: draft
version: 1
date: 2026-09-05
decided-by: product-authority
right: escalation
owner: lead-solutions-architect
created: 2026-09-05
updated: 2026-09-05
---

# ADR: An artifact type's typedef is its one hand-edited standard; its guideline and fitness set are renderings of it

## 1. Context

This repository is the lead shop: the coordinating shop of the
product, owning the product-level definitions and no Bounded Context
(a region of the product with its own model, built by a shop of its
own — a BC shop). The lead shop's definitions live under `basis/`, the
definition corpus. An artifact type is a kind of document the shop
produces — an initiative, a feature, a decision record. Each type's
standard of good is a definition chain: six linked definitions. Three
of them carry the standard a maker writes to and a checker judges by.
The *typedef* defines the type: its identity, required frontmatter,
required sections, commitment, sources, and a derived review
checklist. The *guideline* holds the type's writing rules as prose,
each rule with a test, a criterion, a yes/no decision, and the fitness
scenario it feeds; its Highlights block is the layer loaded into an
author's working context. The *fitness set* holds Given/When/Then
scenarios that a judge scores an instance against — the cold-reviewer
role, a reader with a fresh context each round; the scenarios are
judged by that reader, never run by a test runner.

The pre-state on 2026-09-05, as the request records it — a request
is the record the lead shop writes for an ask on arrival, before any
work on it: 22 typedefs, 17 guidelines, and 11 fitness sets, every one
hand-written, none generated, and no compiler for any of them
([req-2026-09-05-typedef-rendering](../requests/req-2026-09-05-typedef-rendering.md),
its Document History v1). Take the product decision record — the
record of one product-level decision, written by the PO role, the
lead shop's product owner, who authors its features and its product
decisions. It is the slice the authority chose for the proof — the
first feature of the work, one type converted end to end and used by a
whole process run ("Okay, use the pdr"). Its
[typedef](../basis/artifacts/product-decision-record.md) (v6, 97
lines), its [guideline](../basis/guidelines/product-decision-record.md)
(v2, 100 lines), and its
[fitness set](../basis/fitness/product-decision-record.fitness.md) (v3,
90 lines) each carry the same five rules: one decision, a real
alternative, decider and right, priced consequences, reversibility.
The guideline's rule N names fitness scenario N as its derived check;
the typedef's checklist item N cites fitness N. Each of the three has
its own frontmatter, version, and Document History, and their
versions have moved at different paces — v6, v2, v3 — each change to
one recorded in that one's history alone. The
[artifact-typedef typedef](../basis/artifacts/artifact-typedef.md) —
the typedef that defines typedefs, v2 — already rules: "Templates,
schema fragments, and validators are its renderings; the typedef is
the only hand-edited form." The guideline and the fitness set are not
on that list, and each has a typedef of its own naming a human
producer. The rule says one hand-edited form; the practice keeps
three.

Forces bearing. The authority's words, in the request and in the
discovery conversation — the process that explores an ask with the
authority and frames an initiative, the unit of work the authority
bets on — recorded in the session record
[sess-2026-09-05-a](../sessions/sess-2026-09-05-a.md): "My
impression was that the typdef included everything including
guidelines and fitness checks and those were just renderings. We need
to get that in place (if not already) since it will be easier to
evaluate everything for consistency for an artifact." "It should be
possible to evaluate the fitness of artifact definitions in one place.
For instance, the definition of good may change over time and
re-evaluating artifacts will be easier if everything is in one place."
"The tests should stay as is, executable by the author and a check if
necessary. These should be rendered out to whatever format works well
for inclusion in prompts." (The tests are the fitness scenarios;
"executable" here means applied by a reader — the author to their own
draft, the judge at the check — not run by a tool: the fitness-set
typedef keeps them judged, never executed.) Working principles
bearing, from the [working principle set](../basis/principles.md):
`single-source-of-truth` — every fact has one authoritative home and
every other appearance is a reference or a generated rendering; today
the standard has three homes. `define-good-up-front` — one stated
definition of good drives the work and its check; today the maker and
the checker read different words for the same standard.
`governed-context` — everything loaded into an agent's context traces
to an approved definition; a rendering stamped with its source's
digest traces by construction.

What the checks read, as evidence for the clause "the paths the checks
already read". The checks name their criteria by path. The
[PO output check](../basis/processes/po-output-check.md) — the check
the lead-pm role, the lead shop's product manager and the decider of
every check's verdict, runs on the PO role's output — takes a
parameter `criteria_path`, "the approved fitness set or guideline for
the artifact's type", and its judge reads "the criteria set at
criteria_path, the framing at framing, and the artifact — nothing
else" (the framing: the initiative's statement of the problem and
the outcome). The [adr-authoring](../basis/processes/adr-authoring.md)
process's `criteria_path` names the adr fitness set; the
[feature-authoring](../basis/processes/feature-authoring.md) process's
names `basis/fitness/feature.fitness.md`. The linter —
[`basis/tools/lint_basis.py`](../basis/tools/lint_basis.py), the
mechanical check of the corpus — finds a type's guideline and fitness
set by their frontmatter `type` and `target-type`, requires a fitness
set to carry the headings Scenarios and Compile mapping, and already
exempts a document marked `generated: true` from carrying a version
and a Document History (its check 7). A rendering written at the same
path with the same type keys and headings is therefore read by every
check as it stands.

The pattern, as evidence that it exists.
[`basis/tools/compile_process.py`](../basis/tools/compile_process.py)
renders an approved process definition into its skill — the file an
agent loads to run the process — at `.claude/skills/<name>/SKILL.md`.
The rendering's frontmatter carries `generated: true`, `generated-by`,
`derived-from`, `source`, and `source-digest: sha256:` followed by
twelve hex digits of the source text's hash — the stamp that ties a
rendering to the exact source it was produced from.
[`basis/tools/compile_role.py`](../basis/tools/compile_role.py) does
the same for role definitions and adds `--check`: a fresh render
compared byte for byte with the file at the load point — the path the
agent runtime reads the rendering from — a difference reported as
drift. Each compiler is run by a rendering process with a
check step — [skill-rendering](../basis/processes/skill-rendering.md)
and [role-rendering](../basis/processes/role-rendering.md). Both
scripts call themselves experiment apparatus: "the production compiler
is a BC deliverable and does not live in the lead repo." The compiler
this decision adds is apparatus of the same standing.

**The escalation that settled it.** The decision is the authority's,
so it records under `right: escalation`. None of the five rights the
solutions architect role holds — stack (which technologies the product
is built on), guardrail (a bound on Bounded Context shops),
decomposition, contract between Bounded Contexts, non-functional
requirement — covers which document of the lead shop's own definition
corpus is hand-edited and which are produced from it. The question
reached the authority twice on 2026-09-05: in the authority's review
of how an earlier initiative's run had gone (init-request-routing),
where the authority stated the position quoted above and directed "The typedef rendering should go first. It
should be made into a request and follow that process"; and in the
discovery conversation opened on that request — interview form, work
item lead-kda8l in the work register (`bd`, the tracker of work in
motion) — where the authority chose the slice, kept the tests as they
are, struck a consistency check of typedefs against each other, and
said "Converged". The initiative
[init-typedef-rendering](../initiatives/init-typedef-rendering.md)
(v3) carries the framing; its feasibility attachment, the architect's,
named this decision as the one the bet rests on. This record is
authored before the bet — the authority's go, hold, or no-go on the
initiative — on the lead-pm's routing, so the bet is taken on a
recorded decision.

Options that were real:

- **Keep the three hand-written documents and add a consistency check
  across them** — a linter check that guideline rule N, fitness
  scenario N, and checklist item N agree. Declined: three homes
  remain, so `single-source-of-truth` stays unmet; the check finds
  drift after it has happened instead of making it impossible; and
  the check itself must be rewritten each time either form changes.
  The authority's ask was one place, not three places kept in step.
- **Make the typedef the source and point the checks at it directly**
  — no renderings; the guideline and fitness set retired; each
  process's `criteria_path` names the typedef. Declined: the judge is
  bound to read the criteria set and nothing else, and the typedef
  carries identity, sources, rules, and history the judge does not
  need — `least-context`, the working principle that an activity
  loads the minimum it needs; the guideline's Highlights block exists
  because a prompt wants a compressed layer, and the authority asked
  for the tests "rendered out to whatever format works well for
  inclusion in prompts"; and retiring the two documents changes every
  check's parameter and the linter's chain derivation — the
  initiative's first no-go is "any change to the checking processes
  themselves".
- **Make the fitness set the source and generate the typedef's
  checklist and the guideline from it.** Declined: the fitness set
  carries only the scenarios; the typedef carries identity,
  frontmatter, sections, commitment, and sources — the larger part of
  the standard, which no scenario yields. And the direction is already
  set by an approved definition: the artifact-typedef typedef names the
  typedef the only hand-edited form; reversing it would amend the root
  typedef against its own reasons.
- **Render at check time instead of committing renderings** — the
  check step runs the compiler and reads its output, nothing written
  at the guideline and fitness paths. Declined: a text produced inside
  the step is context from a source the process definition does not
  name, which `least-context` rules out; the linter's chain derivation
  reads files on disk; and it changes the checking processes, the
  first no-go again. A committed rendering is reviewable in source
  control with its digest, and its drift is checkable by the
  `--check` pattern already in use.

Not decided here, each a candidate for the feature or for a record of
its own:

- *The form of the two sections inside the typedef* — headings,
  whether a rule keeps its before/after pair, and how a rule and a
  scenario that say the same thing are folded ("In the case of
  guidelines, there may be overlap"), and what a typedef renders when
  its type has no guideline or fitness set today — twelve of the 22.
  This record fixes only that they are sections a compiler can parse.
- *The typedef's derived review checklist* — its required section 6,
  after this decision a third statement of the same rules inside the
  one source. Whether it becomes a compiled section written back into
  the typedef, the way compile_process.py writes "Flow (compiled)"
  into a process definition, is not decided here.
- *The rendering process and its check* — the third sibling of
  skill-rendering and role-rendering. Whether the three generalize into
  one is the open question the role-rendering record left with work
  item lead-sx9xj as its trigger; this record adds a sibling, not a
  generalization.
- *The guidelines and the fitness set with no artifact type behind
  them* — the base writing style (no target type; the authority's own
  text, stored verbatim), the six experience guidelines and the
  interaction fitness set (target `interaction`, an interaction type,
  not an artifact type). They stay hand-written under their own
  typedefs; a source for them is a decision of its own.

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on all six.

- `knowable-shape` — the lead shop's description of what it is for and
  produces is unchanged; the corpus gains a stated rule of which
  document is authored and which are produced, readable from the
  typedefs and the renderings' frontmatter, not from the compiler's
  code.
- `contracts-between-contexts` — no Bounded Context is touched (the
  initiative's Decomposition: none); no contract exists on this
  branch to rely on, and none is created.
- `actor-neutral-discipline` — the compiler produces the same text
  whoever runs it; the rendering process, when authored, attaches its
  records and its check to the activity; a hand edit of a rendering is
  drift whoever made it.
- `local-comprehension` — a maker or a judge at the coordinating level
  reads the rendering designated for its step and never the typedef;
  the definition author reads the typedef and never the renderings.
  One place carries the whole standard, which is the authority's
  "in one place".
- `bidirectional-conformance` — this record is the design change,
  recorded before the compiler is written. Forward, the initiative's
  measure demonstrates it: types whose standard has one home with
  current renderings, 1 of 22 at the proof, then 22 of 22. Reverse, a
  rendering whose digest does not match its source is called for by
  nothing and is regenerated or removed; the `--check` pattern is the
  reverse check.
- `intent-provenance` — the intent was recorded as a request on
  arrival, routed to discovery, framed an initiative, and reaches this
  record; each step is recorded and the chain back to the authority's
  words has no gap. The contract the request names as its entry
  (`received-through: operational-contract`) has no artifact yet. That
  is the exception
  [adr-2026-09-04-request-front-end](adr-2026-09-04-request-front-end.md)
  carries, escalated to the authority and held there and in work item
  lead-4kymc; this record cites it and does not carry it a second
  time. Nothing this decision adds enters or delegates intent.

## 2. Decision

An artifact type's typedef is the one hand-edited document of that
type's standard: it carries the type's writing rules and its fitness
scenarios as sections, and the type's guideline and fitness set are
produced from it by a compiler on the compile_process.py pattern,
written at the paths the checks already read, each stamped with the
source-digest of the typedef it was produced from.

## 3. Consequences

- The typedef is the only document a definition author edits. What
  changes: each typedef gains two sections, the writing rules and the
  fitness scenarios, and the artifact-typedef typedef amends to require
  them. For whom: the product authority, who owns and approves every
  typedef; definition authors. Cost: the amendment; one typedef
  converted for the proof, then twenty-one as one batch; a longer
  typedef to read. Forecloses: a hand edit of a guideline or a fitness
  set — it is drift, and the next render overwrites it.
- The guideline and the fitness set become renderings. What changes:
  each carries `generated: true`, `generated-by`, `derived-from`,
  `source`, and `source-digest`, and no version or Document History of
  its own; the quality-guideline and fitness-set typedefs amend to name
  the compiler as producer while keeping the shape the checks read —
  a rendering is still a `quality-guideline` or a `fitness-set` with
  its `target-type`, its Highlights, its Scenarios and Compile
  mapping. For whom: the cold-reviewer role, which reads the fitness
  set at `criteria_path`; makers, who read the guideline's Highlights;
  the linter, which derives the chain from the frontmatter. Cost: two
  typedef amendments; the past history of ten guidelines and ten
  fitness sets stops at the conversion and stays readable only in
  source control, the typedef's Document History carrying the
  standard's changes from then on. Forecloses: a guideline or fitness
  set that says something its typedef does not.
- A compiler joins the lead shop's tools. What changes: a script on
  the compile_process.py pattern parses a typedef, writes the two
  texts, stamps each with the source-digest, and offers a check that
  compares the committed renderings with a fresh render. For whom:
  whoever runs the rendering process; the architect role, which
  maintains the shop's tools. Cost: one script; one rendering process
  definition with its check step and its own skill; a render after
  every typedef change. Forecloses: nothing — the script is apparatus,
  retired when a Bounded Context delivers the production compiler.
- The checks stay as they are. What changes: nothing in the PO output
  check, adr-authoring, feature-authoring, or the linter — each reads
  the path it reads today and finds a rendering there. For whom: the
  cold-reviewer role; the lead-pm role, which decides from the review.
  Cost: the rendering must keep the type keys and headings the checks
  and the linter require; a renderer that drops one breaks a check
  without changing it.
- A change to a standard is one edit and one render. What changes: the
  authority or a definition author changes the typedef, the render
  runs, and maker and judge read the same words. For whom: the
  authority, evaluating a type's standard in one place; every maker
  and checker of the type. Cost: a rendering behind its source is
  drift until the next render, and the check step is what finds it.

Bound on Bounded Context shops: none — the definition corpus is the
lead shop's; a BC shop's own definitions stand under its own
operational contract. Extending this rule to BC shops would be a
guardrail decision, the architect role's.

## 4. Reversibility

Reversible at low cost while one type is converted: the two renderings
are still documents of their types, so reverting is removing the two
sections from the typedef, restoring the guideline's and fitness set's
frontmatter and history from source control, and deleting the
compiler. Hard after the batch: twenty-two typedefs carry the rules
and scenarios, the renderings — two per converted type — carry no
history of their own, and each reversal is a per-document
reconstruction from source control,
with any process or role that has come to cite a typedef's rules
section by number to re-point. Review triggers: a Bounded Context
delivers the production compiler, so the apparatus in the lead shop
is redundant; a check needs a criteria set the typedef cannot carry as
a section; the three rendering processes' shared shape makes a
generalization cheaper than a third sibling (lead-sx9xj); the base
writing style or the experience guidelines need a source of their own;
a converted typedef grows past what its author reads in one sitting —
under `local-comprehension`, a design defect to repair, not a reader's
burden.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Authored through the adr-authoring process at its author step, on the lead-pm's routing before the bet on init-typedef-rendering, for the authority's direction of 2026-09-05 in req-2026-09-05-typedef-rendering and the discovery conversation that framed the initiative (lead-kda8l; sess-2026-09-05-a). Right: `escalation` — the decider is the authority, and none of the five rights the solutions architect role holds covers which document of the lead shop's own definition corpus is hand-edited and which are produced from it; the adr typedef sends a decision no listed right covers to `right: escalation` in the type whose deciding side raised it, and the architect side raised this one in the initiative's feasibility attachment. The precedent records of an authority decision (adr-2026-09-03-role-rendering, adr-2026-09-04-request-front-end) took the same value for the same reason. Recorded as an adr rather than a product decision record because the decision is about the shape of the definition corpus and its tooling, not about product value or order. Four candidates named in §1 as not decided here. Status draft pending the screen. |
