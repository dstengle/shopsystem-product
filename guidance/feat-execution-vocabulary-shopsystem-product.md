---
type: implementation-guidance
id: guidance-feat-execution-vocabulary-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-execution-vocabulary.md
feature: ../features/feat-execution-vocabulary.md
context: shopsystem-product
scenarios: ["@hash:4a19c7e2f6b3", "@hash:8d2f61a9c470", "@hash:1c7b45de930f", "@hash:e35a08f61c94", "@hash:96b2d4f70ae1", "@hash:3f70c9a1e625", "@hash:c81ef056a2b9", "@hash:7d4b19f0836c"]
owner: lead-solutions-architect
created: 2026-09-09
updated: 2026-09-09
---

# Implementation guidance: feat-execution-vocabulary for shopsystem-product

For the eight scenarios of feat-execution-vocabulary (v14) assigned to
shopsystem-product — the lead shop itself — on 2026-09-09 under
init-execution-vocabulary (v5): `@hash:4a19c7e2f6b3`,
`@hash:8d2f61a9c470`, `@hash:1c7b45de930f`, `@hash:e35a08f61c94`,
`@hash:96b2d4f70ae1`, `@hash:3f70c9a1e625`, `@hash:c81ef056a2b9`,
`@hash:7d4b19f0836c`. The context is the lead shop building its own
definitions, so this record names the definitions and tools to
change. Historical record of this assignment; binds nothing after it.

## What changes

1. **Glossary, the instance term** — `basis/glossary.md` (v25): add an
   `execution` entry defining it as the instance term
   (`execution:<process>:<bead>`); revise the `run` entry to carry no
   instance sense, verb only. Serves `@hash:8d2f61a9c470`,
   `@hash:1c7b45de930f`, `@hash:e35a08f61c94`, `@hash:c81ef056a2b9`.

2. **Glossary, the identifier term** — `basis/glossary.md`: add a
   `bead` entry for the work register's identifier; the existing
   `anchor` entry keeps its own sense (the governed record a
   conversation attaches to) and drops any use as the identifier's
   name. Serves `@hash:96b2d4f70ae1`, `@hash:c81ef056a2b9`.

3. **Reference convention** — wherever a definition states how a
   process definition is referenced (`basis/artifacts/process-definition.md`
   and its guideline), the convention is the full id, never a bare or
   shortened form. Serves `@hash:4a19c7e2f6b3`.

4. **Corpus propagation** — every basis and delivered-feature file
   outside the superseded set gets `run`-as-noun replaced by
   `execution`, in its field form where an instance is written, and
   `anchor`-for-identifier replaced by `bead`; `runner` left standing
   only inside `process-runner`. The superseded set an edit must not
   touch: any scenario already specified in the feature repository,
   whatever its status, that this feature's scenarios restate —
   `feat-process-runner.md`, `feat-request-routing.md`,
   `feat-initiative-cost-rollup.md`, `feat-flow-simplification.md`,
   `feat-plain-voice.md`, `feat-run-measurement.md`. Serves
   `@hash:8d2f61a9c470`, `@hash:1c7b45de930f`, `@hash:e35a08f61c94`,
   `@hash:96b2d4f70ae1`, `@hash:3f70c9a1e625`.

5. **Corpus measure** — `basis/tools/lint_basis.py` gains a check, or a
   sibling tool, counting basis, delivered-feature, and glossary files
   still using `run` as a noun or `anchor` for the identifier, outside
   the superseded set; run after propagation, the count is 0. Serves
   `@hash:7d4b19f0836c`.

No guardrail and no cross-context flow apply: no `basis/contexts/`
directory and no decomposition record exist for this initiative;
Contributors places every scenario in the lead shop's own tree.

## References

- Initiative: init-execution-vocabulary (v5, active). Feature:
  feat-execution-vocabulary (v14, checked at assignment); scenarios as
  listed above.
- Definitions read: `basis/glossary.md` (v25, `anchor` and `run`
  entries; no `execution` or `bead` entry present);
  `basis/artifacts/process-definition.md`; `basis/tools/lint_basis.py`.
- Repository swept: thirteen other features in `features/`; conflicts
  found and resolved as supersession under the framing's widened
  clause (init-execution-vocabulary v5) — none block this assignment.
- Contracts: none exist on this branch.

## What not to do

- Do not edit a delivered artifact's scenario text in place — the
  appetite's first no-go; `feat-flow-simplification.md`,
  `feat-plain-voice.md`, and `feat-run-measurement.md` stand
  superseded, not rewritten.
- Do not hand-edit `feat-process-runner.md`'s, `feat-request-routing.md`'s,
  or `feat-initiative-cost-rollup.md`'s scenario text under this
  assignment: each is undelivered and stands as its own feature's
  specification; `feat-initiative-cost-rollup.md` already returned
  once on this exact conflict and its own resolution is the PO role's.
- Do not change what any definition requires while propagating the
  term — the appetite's second no-go; this is a vocabulary change
  only.
- Do not let `runner` stand outside `process-runner` anywhere touched.
- Do not use `anchor` for the work register's identifier in any
  changed text; the `anchor` entry keeps its existing sense.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Written by the lead-solutions-architect role at the scenario-assignment process assign step for the eight scenarios of feat-execution-vocabulary assigned to shopsystem-product. Self-check against the implementation-guidance fitness set (v2): scenario 1 (architect's level) pass — each What-changes entry names a glossary entry, a typedef, or a tool, none a context's internals (none exists); scenario 2 (cited, never restated) pass — scenarios cited by hash, definitions by name and version, no scenario text reproduced; scenario 3 (actionable alone) pass — each entry names the file to change and, for the measure, the tool to extend; scenario 4 (reasons) pass — each What-not-to-do entry names a no-go, a prior return, or the feature's own boundary as its reason; scenario 5 (one assignment) pass — frontmatter and opening paragraph name the initiative, feature, context, and eight hashes; scenario 6 (word target) pass — the whole record counts under the 600-word guidance-record target. Status written; not sent. |
