---
type: implementation-guidance
id: guidance-feat-plain-voice-rest-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-plain-voice.md
feature: ../features/feat-plain-voice-rest.md
context: shopsystem-product
scenarios: ["@hash:7c2f4e9b6a13", "@hash:3d8b1c5f9e24", "@hash:9a4e7c1b2f56", "@hash:5f2b8d4c9a17", "@hash:2c9f3a7e1b48", "@hash:8b1d5c3f9e26"]
owner: lead-solutions-architect
created: 2026-09-08
updated: 2026-09-08
---

# Implementation guidance: feat-plain-voice-rest for shopsystem-product

For the six scenarios of feat-plain-voice-rest (v2) assigned to
shopsystem-product — the lead shop itself — on 2026-09-08 under
init-plain-voice (v5): `@hash:7c2f4e9b6a13`, `@hash:3d8b1c5f9e24`,
`@hash:9a4e7c1b2f56`, `@hash:5f2b8d4c9a17`, `@hash:2c9f3a7e1b48`,
`@hash:8b1d5c3f9e26`. The context is the lead shop building its own
definitions, so this record names the definitions and tools to
change. Historical record of this assignment; binds nothing after it.

## What changes

1. **Feature typedef, contributor brevity** —
   `basis/artifacts/feature.md` (v15), Rules section, gains one rule:
   a Contributors passage names an owning shop, a criterion, or a
   constraint in one short line, no reasoning restated — reasoning
   moves to the Document History row. Serves `@hash:7c2f4e9b6a13`.

2. **Feature typedef becomes the one source** — `basis/artifacts/feature.md`
   gains Writing rules and Fitness scenarios sections, carrying forward
   `basis/guidelines/feature.md` (v9) and `basis/fitness/feature.fitness.md`
   (v9), tightened to the 1,000-word target
   (`basis/guidelines/base-writing-style.md` v3, Word targets). Then
   `basis/tools/compile_typedef.py basis/artifacts/feature.md --write`
   produces both texts, each marked `generated: true` with a source
   digest — the pattern proven on the product-decision-record type
   (feat-typedef-rendering, delivered). Serves `@hash:9a4e7c1b2f56`,
   `@hash:5f2b8d4c9a17`, `@hash:3d8b1c5f9e24`.

3. **Implementation-guidance typedef, record word target** —
   `basis/artifacts/implementation-guidance.md` (v1), Writing rules
   section, gains a rule citing the 600-word guidance-record target;
   then `basis/tools/compile_typedef.py basis/artifacts/implementation-guidance.md --write`
   re-produces `basis/guidelines/implementation-guidance.md` (v1) and
   `basis/fitness/implementation-guidance.fitness.md` (v1) — both
   already generated, content only changes. Serves `@hash:2c9f3a7e1b48`.

4. **Existing guidance records rewritten** to the revised guideline,
   each under 600 words, with a Document History row recording the
   rewrite and no change to scenario hashes or References:
   `guidance/feat-process-runner-shopsystem-product.md`,
   `guidance/feat-role-decisions-shopsystem-product.md`,
   `guidance/feat-run-measurement-shopsystem-product.md`,
   `guidance/feat-tool-skills-rest-shopsystem-product.md`,
   `guidance/feat-tool-skills-shopsystem-product.md`. Serves
   `@hash:8b1d5c3f9e26`.

No guardrail and no cross-context flow apply: the Contributors section
and the initiative's Decomposition ("Not yet") place every scenario in
the lead shop's own tree.

## References

- Initiative: init-plain-voice (v5, active). Feature: feat-plain-voice-rest
  (v2, checked at assignment); scenarios as listed above.
- Rule: `basis/guidelines/base-writing-style.md` (v3), Word targets.
- Definitions read: feature typedef v15, its guideline v9 and fitness
  set v9 (hand-kept); implementation-guidance typedef v1, its
  guideline v1 and fitness set v1 (generated); artifact-typedef
  typedef; typedef-rendering process (v4, delivered proof:
  feat-typedef-rendering v8).
- Tool: `basis/tools/compile_typedef.py`.
- Contracts: none exist on this branch.

## What not to do

- Do not touch the feature typedef's other Required sections or Rules
  while adding the Contributors-brevity rule: the appetite's second
  no-go bars a rewrite that changes what a definition requires beyond
  these six scenarios.
- Do not edit `basis/guidelines/feature.md` or
  `basis/fitness/feature.fitness.md` by hand once produced: the
  typedef's Writing rules and Fitness scenarios sections are the one
  source (`single-source-of-truth`); a hand edit is drift, reconciled
  by re-running the compiler, never by editing the typedef to match it.
- Do not drop a Highlights, Scenarios, or Compile mapping heading, or a
  type key a check or the linter reads at these paths: the
  typedef-rendering process's C3; a production that drops one is a
  defect of the production, not a reason to change the reader.
- Do not remove a recorded decision anywhere touched: the appetite's
  first no-go.
- Do not rewrite a guidance record's References or frontmatter hashes
  when shortening it: only the What-changes and What-not-to-do prose
  is subject to the word target; the record's binding to its one
  assignment (rule 5 of the implementation-guidance guideline) stays.
- Do not extend the guidance-record word target to a Bounded Context's
  own records: none exists on this branch, and no scenario here
  reaches one.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Written by the lead-solutions-architect role at the scenario-assignment process assign step for the six scenarios of feat-plain-voice-rest assigned to shopsystem-product. Self-check against the implementation-guidance fitness set (v1): scenario 1 (architect's level) pass — each of the four What-changes entries names a typedef, a guideline, a fitness set, a tool, or a guidance-record path by version, none a context's internals (none exists); scenario 2 (cited, never restated) pass — scenarios cited by hash, definitions by name and version, no scenario text or typedef clause reproduced; scenario 3 (actionable alone) pass — each entry names the file to change, the tool invocation, and the order (typedef, then compiler, then instances); scenario 4 (reasons) pass — each of the six What-not-to-do entries names a no-go, a principle, or a process constraint as its reason; scenario 5 (one assignment) pass — frontmatter and opening paragraph name the initiative, feature, context, and six hashes; every statement is about those scenarios. Status written; not sent. |
