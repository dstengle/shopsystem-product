---
type: adr
id: adr-2026-09-05-typedef-rendering
title: An artifact type's typedef is its one hand-edited standard; its guideline and fitness set are renderings of it
status: checked
version: 4
date: 2026-09-05
decided-by: product-authority
right: escalation
owner: lead-solutions-architect
created: 2026-09-05
updated: 2026-09-05
---

# ADR: An artifact type's typedef is its one hand-edited standard; its guideline and fitness set are renderings of it

## 1. Context

This repository is the lead shop: the coordinating shop of the product,
owning the product-level definitions under `basis/` (the definition
corpus) and no Bounded Context — a region of the product with its own
model, built by a shop of its own, a BC shop. An artifact type is a kind
of document the shop produces. Three definitions carry a type's standard
of good. The *typedef* (type key `artifact-typedef`) defines the type:
identity, required frontmatter, required sections, commitment, sources,
a derived review checklist. The *guideline* (type key
`quality-guideline`) holds the writing rules as prose, each with a test,
a criterion, a yes/no decision, and the fitness scenario it feeds; its
Highlights block is the layer loaded into an author's context. The
*fitness set* (type key `fitness-set`) holds Given/When/Then scenarios a
judge — the cold-reviewer role — scores an instance against, with a
Compile mapping table taking each scenario into one judge assertion;
judged, never run by a test runner.

Pre-state, 2026-09-05, as the request — the record of an ask on arrival
— states it
([req-2026-09-05-typedef-rendering](../requests/req-2026-09-05-typedef-rendering.md)):
22 typedefs, 17 guidelines, 11 fitness sets, all hand-written, none
generated, no compiler. Of those, 10 guidelines and 10 fitness sets have
an artifact type with a typedef behind them, and they belong to the same
ten types, so 12 of the 22 typedefs have neither; the other 7 guidelines
(the base writing style and the six experience guidelines) and 1
fitness set (interaction) have no artifact type behind them. The proof
slice — the first feature, one type converted and used by a whole
process run — is the product decision record, written by the PO role,
the lead shop's product owner ("Okay, use the pdr"). Its typedef (v6),
[guideline](../basis/guidelines/product-decision-record.md) (v2), and
[fitness set](../basis/fitness/product-decision-record.fitness.md) (v3)
carry the same five rules, each with its own history. The
[artifact-typedef typedef](../basis/artifacts/artifact-typedef.md) (v2)
already rules: "Templates, schema fragments, and validators are its
renderings; the typedef is the only hand-edited form." The rule says one
hand-edited form; the practice keeps three.

Forces. The authority, in the request and in the discovery conversation
that framed the initiative
([sess-2026-09-05-a](../sessions/sess-2026-09-05-a.md)): "the typdef
[sic] included everything including guidelines and fitness checks and those
were just renderings"; "The tests should stay as is, executable by the
author and a check if necessary … rendered out to whatever format works
well for inclusion in prompts" — "executable" meaning applied by a
reader, the scenarios staying judged. `single-source-of-truth`, from the
[working principle set](../basis/principles.md): one home per fact,
every other appearance a reference or a generated rendering; today the
standard has three homes.

Evidence that the checks read by path: the PO output check — run by the
lead-pm role, the lead shop's product manager — takes `criteria_path`,
"the approved fitness set or guideline for the artifact's type"
([po-output-check](../basis/processes/po-output-check.md), Data).
Evidence for the pattern:
[`compile_process.py`](../basis/tools/compile_process.py) renders a
process definition into its skill (the file an agent loads to run it)
stamped `source-digest: sha256:` plus twelve hex digits of the source
text's hash — the stamp tying a rendering to its exact source — and
`compile_role.py` adds `--check`, a fresh render compared with the
committed file, a difference being drift. Each compiler runs under a
rendering process: skill-rendering runs compile_process.py,
role-rendering runs compile_role.py, and this decision adds a third
process for its compiler. The lead shop's compilers are interim
tooling, kept only while the shop renders its own definitions.

**The escalation that settled it.** The decision is the authority's,
so it records under `right: escalation`: none of the five rights the
solutions architect role holds — stack, guardrail (a bound on BC
shops), decomposition, contract between Bounded Contexts,
non-functional requirement — covers which document of the shop's own
corpus is hand-edited and which are produced from it. The
authority ruled on 2026-09-05 — "The typedef rendering should go
first. It should be made into a request and follow that process" —
and in the discovery conversation on that request said "Converged".
The initiative
[init-typedef-rendering](../initiatives/init-typedef-rendering.md)
carries the framing; its feasibility attachment, the architect's,
named this decision as the one the bet — the authority's go or no-go
on it — rests on.

Options that were real:

- **Keep three hand-written documents; add a consistency check.**
  Declined: three homes remain, and drift is found after the fact.
- **Point the checks at the typedef; retire the two documents.**
  Declined: the judge reads the criteria set and nothing else, and the
  typedef carries identity, sources, and history it does not need
  (`least-context`, the working principle of loading the minimum); and
  every check's parameter changes — the initiative's first no-go
  condition, what it will not do: "any change to the checking
  processes themselves".
- **Make the fitness set the source.** Declined: scenarios do not yield
  identity, sections, commitment, or sources, and the artifact-typedef
  typedef already names the typedef the only hand-edited form.
- **Render at check time, commit nothing.** Declined: text made inside a
  step is context from a source the process does not name
  (`least-context`); the linter — `basis/tools/lint_basis.py`, the
  check the tree runs on every definition — reads files on disk; the
  first no-go condition again.

Not decided here: four follow-on questions are listed in this record's
Document History (v4).

## 2. Decision

An artifact type's typedef is the one hand-edited document of that
type's standard: it carries the type's writing rules and its fitness
scenarios as sections, and the type's guideline and fitness set are
produced from it by a compiler on the compile_process.py pattern,
written at the paths the checks already read, each stamped with the
source-digest of the typedef it was produced from.

## Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on five; `intent-provenance` rests on the exception
[adr-2026-09-04-request-front-end](adr-2026-09-04-request-front-end.md)
carries, escalated to the authority (work item lead-4kymc).
`knowable-shape` — which document is authored and which produced is
readable from the typedefs and the renderings' frontmatter.
`contracts-between-contexts` — no Bounded Context is touched.
`actor-neutral-discipline` — the compiler yields the same text whoever
runs it; a hand edit of a rendering is drift whoever made it.
`local-comprehension` — maker and judge read the rendering for their
step, the definition author the typedef. `bidirectional-conformance` —
this record precedes the compiler; forward, the initiative's measure
(1 of 22, then 22 of 22); reverse, a rendering whose digest does not
match its source is regenerated or removed. `intent-provenance` — the
request, its route, the initiative, and this record are each recorded;
the entry contract the request names has no artifact yet — the cited
exception.

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
  typedef amendments; the past history of the 10 guidelines and 10
  fitness sets converted stops at the conversion and stays readable only in
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
  every typedef change. Forecloses: nothing — the script is interim
  tooling, retired when the shop stops rendering its own definitions.
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
reconstruction from source control, and any process or role that has
come to cite a typedef's rules section by number must re-point. Review triggers: the shop stops rendering
its own definitions, so the compiler has no source to read; a check needs a criteria set the typedef cannot carry as
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
| 1 | 2026-09-05 | review | Screen round 1 (judge: claude-fable-5-1 / screen prompt v6): three confident — the guideline and fitness-set counts unsplit against the pre-state's 17 and 11; the type key `quality-guideline` not introduced where the guideline is defined; "six linked definitions" with three unnamed — and two wobbly, ruled by the lead-pm — the `intent-provenance` result to be one rest-on-exception sentence; Context over half the record. |
| 2 | 2026-09-05 | update | Round 1 repairs: the counts split once at the pre-state (10 and 10 typedef-backed; 7 and 1 not) and the consequence aligned; the three type keys introduced; the six-definition count dropped; `intent-provenance` stated as one result, "has no gap" removed; Context compressed to under half — the evidence paragraphs to one cited sentence each, glosses kept only for terms the Decision and Consequences use. |
| 2 | 2026-09-05 | review | Screen round 2 (judge: claude-fable-5-1 / screen prompt v6): one confident — the history convention (review at the version reviewed, update at the next; `version` matches the last row) — and five wobbly, ruled by the lead-pm — the principles screen to follow §2 as its own part; the 10-and-10 to be said as the same ten types so "12 of 22" derives; "no-go" and "candidates" glossed; "experiment apparatus" dropped from Context; Context still over half. |
| 3 | 2026-09-05 | update | Round 2 repairs: history re-formed to the convention, version 3; the screen moved to a "Principles screen" part after §2; the same-ten-types statement added; "no-go condition" and "candidates for later records" glossed; the apparatus clause dropped from Context, §3 carrying it; the evidence paragraphs cut to one cited sentence each, Context under half without moving the options. |
| 3 | 2026-09-05 | review | Screen round 3, the cap (judge: claude-fable-5-1 / screen prompt v6): six confident, all wording and unintroduced terms — "the production compiler" unintroduced; the rendering processes unnamed where compile_process.py is cited; "the linter" unintroduced; "Compile mapping" used in §3 without its gloss; "typdef" unmarked in the quotation; a fragment in §4 — and two wobbly, ruled by the lead-pm: the three method commitments in §2 stay as part of the one decision; the candidates paragraph becomes a pointer with the list moved to history. |
| 4 | 2026-09-05 | update | Post-cap repairs, disclosed and not re-screened: the production-compiler premise dropped (no record of it exists to cite) — the compilers are interim tooling, retired when the shop stops rendering its own definitions, in Context, §3, and §4's trigger; the three rendering processes named (skill-rendering, role-rendering, and the one this decision adds); the linter introduced; Compile mapping added to the fitness-set gloss; [sic] on "typdef"; the §4 fragment made a sentence; the candidates moved here. The four follow-on questions not decided by this record: (1) the form of the two sections, how an overlapping rule and scenario fold, and what a typedef with no guideline or fitness set today (12 of 22) renders; (2) whether the typedef's derived review checklist, a third statement of the rules inside the one source, becomes a compiled section written back into the typedef; (3) whether the rendering processes generalize into one (open since role-rendering, trigger work item lead-sx9xj); (4) a source for the 7 guidelines and 1 fitness set with no artifact type behind them. |
| 4 | 2026-09-05 | state | `draft` → `checked`: the PM role's pass at the cap. The decider is the authority; the record is checked for form; `right: escalation` accepted as the typedef admits for a decision no architect right covers. Round 3's findings repaired past the cap and disclosed in the v4 update row, not re-screened. |
