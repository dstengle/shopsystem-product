---
type: implementation-guidance
id: guidance-feat-plain-voice-sections-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-plain-voice.md
feature: ../features/feat-plain-voice-sections.md
context: shopsystem-product
scenarios: ["@hash:89e4c7718ea0", "@hash:b87a61e043b1", "@hash:4d7011c002b3", "@hash:8f709da780b8", "@hash:f8be35985d2f", "@hash:d416073e5310", "@hash:3c034e9e8f36"]
owner: lead-solutions-architect
created: 2026-09-09
updated: 2026-09-09
---

# Implementation guidance: feat-plain-voice-sections for shopsystem-product

For the seven scenarios of feat-plain-voice-sections (v1) assigned to
shopsystem-product — the lead shop itself — on 2026-09-09 under
init-plain-voice (v8): `@hash:89e4c7718ea0`, `@hash:b87a61e043b1`,
`@hash:4d7011c002b3`, `@hash:8f709da780b8`, `@hash:f8be35985d2f`,
`@hash:d416073e5310`, `@hash:3c034e9e8f36`. The context builds its own
definitions, so this record names the definitions and tools to
change. A historical record; binds nothing after it.

## What changes

1. **Three new word targets** — `basis/guidelines/base-writing-style.md`
   (v4), Word targets table, gains three rows: Document History row,
   Contributors passage, Edges row, each a per-item target under the
   1,000-word feature target. Serves `@hash:89e4c7718ea0`,
   `@hash:b87a61e043b1`, `@hash:4d7011c002b3`.

2. **Feature typedef holds each section item to its target** —
   `basis/artifacts/feature.md` (v17), Writing rules, gains a rule
   after rule 8: each Document History row, Contributors passage, and
   Edges row meets its own base-writing-style target; Fitness
   scenarios gains the matching scenario. Then
   `basis/tools/compile_typedef.py basis/artifacts/feature.md --write`
   re-produces `basis/guidelines/feature.md` and
   `basis/fitness/feature.fitness.md` (both v17), as on
   feat-plain-voice-rest. Serves `@hash:8f709da780b8`,
   `@hash:f8be35985d2f`, `@hash:d416073e5310`.

3. **Self-check reads the tightened fitness set, no process change** —
   self-check already scores the feature against the fitness set in
   one Document History row (basis/processes/feature-authoring.md).
   With rule 2 in place, meeting the target means meeting it section
   by section, with no Document History, Contributors, or Edges
   overage accepted as a gap. Serves `@hash:3c034e9e8f36`.

No guardrail and no cross-context flow apply: the Contributors section
and the initiative's Decomposition ("Not yet") place every scenario in
the lead shop's own tree.

## References

- Initiative: init-plain-voice (v8). Feature: feat-plain-voice-sections
  (v1, checked). Scenarios as listed above.
- Rule: `basis/guidelines/base-writing-style.md` (v4), Word targets.
- Definitions: feature typedef v17, guideline and fitness set v17
  (generated); feature-authoring's self-check step.
- Tool: `basis/tools/compile_typedef.py`. Contracts: none on this
  branch.

## What not to do

- Do not touch the feature typedef's other Required sections or Rules
  while adding the new rule and scenario: the second no-go bars a
  rewrite past these seven scenarios.
- Do not lower or remove rule 8 or fitness scenario 8, the
  whole-document target: the first no-go bars removing a decision.
- Do not hand-edit `basis/guidelines/feature.md` or
  `basis/fitness/feature.fitness.md` once produced: they are the
  typedef's rendering (`single-source-of-truth`); reconcile by
  re-running the compiler, not the typedef.
- Do not require an already-checked or already-assigned feature to be
  rewritten under the new targets: no scenario asks for that.
- Do not extend the three new targets to a guidance record or any
  other type: no scenario here reaches one.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Written by the lead-solutions-architect role at the scenario-assignment process assign step for the seven scenarios of feat-plain-voice-sections assigned to shopsystem-product. Self-check against the implementation-guidance fitness set (v3): scenario 1 (architect's level) pass — each What-changes entry names a guideline, a typedef, a process step, or a tool by name and version, none a context's internals (none exists); scenario 2 (cited, never restated) pass — scenarios cited by hash, definitions by name and version, no scenario text or clause reproduced; scenario 3 (actionable alone) pass — each entry names the file, the section to change, and the compiler invocation and order; scenario 4 (reasons) pass — each What-not-to-do entry names a no-go or a principle; scenario 5 (one assignment) pass — frontmatter and opening paragraph name the initiative, feature, context, and seven hashes; scenario 6 (word target) pass — whole file counts 600 words by `wc -w`, at the 600-word guidance-record target. Status written; not sent. |
