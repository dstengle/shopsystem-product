---
type: implementation-guidance
id: guidance-feat-run-measurement-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-run-measurement.md
feature: ../features/feat-run-measurement.md
context: shopsystem-product
scenarios: ["@hash:2eda37f33645", "@hash:475294f4bb30", "@hash:a156efde14c9", "@hash:b1e89524a00d", "@hash:ca187608df17"]
owner: lead-solutions-architect
created: 2026-09-08
updated: 2026-09-08
---

# Implementation guidance: feat-run-measurement for shopsystem-product

For the five scenarios of feat-run-measurement (v7) assigned to
shopsystem-product — the lead shop itself — on 2026-09-08 under
init-run-measurement (v6): `@hash:2eda37f33645`, `@hash:475294f4bb30`,
`@hash:a156efde14c9`, `@hash:b1e89524a00d`, `@hash:ca187608df17`. The
context is the lead shop building its own definitions, so this record
names the definitions and tools to change. Historical record; binds
nothing after it.

## What changes

Guardrail: adr-2026-09-08-run-cost-artifact (v3, checked) — a runtime
step only, never inside `collect`; a field the harness does not expose
stays blank. No contract, no cross-context flow.

1. **New artifact typedef, lead shop's tree:** one run-cost record per
   session record, fields step, role, minutes, context tokens, output
   tokens, tool uses (nullable), referencing the session record's own
   id, not restating its frontmatter. Serves `@hash:ca187608df17`,
   `@hash:a156efde14c9`, `@hash:475294f4bb30`.
2. **session-handoff-process (v3) gains one runtime step**, after
   `collect`, before `validate`: reads only the anchor (step, role,
   start/end timestamps) and the usage report; writes one row per
   agent run and top-level turn, none for a runtime step. Re-render:
   `basis/tools/compile_process.py basis/processes/session-handoff.md --skill .claude/skills/session-handoff/SKILL.md`.
   Serves `@hash:2eda37f33645`, `@hash:475294f4bb30`,
   `@hash:a156efde14c9`, `@hash:b1e89524a00d`.
3. **Not in this assignment:** reconcile-and-close and a review
   conversation's anchor (D2 bounds the target to the session-record
   anchor).
4. **Done:** typedef stands with a history row, the process carries
   the step, the re-rendered skill is byte-equal, the lint is clean,
   one row demonstrated at a router-moved session's close.

## References

- Initiative: init-run-measurement (v6, active). Feature:
  feat-run-measurement (v7, checked at assignment); scenarios
  `@hash:2eda37f33645`, `@hash:475294f4bb30`, `@hash:a156efde14c9`,
  `@hash:b1e89524a00d`, `@hash:ca187608df17`.
- Design decisions: adr-2026-09-08-run-cost-artifact (v3, checked);
  adr-2026-09-08-run-cost-initiative-scope (D2, cited in
  init-run-measurement's Document History v2).
- Contracts: none exist on this branch.
- Definitions, at the versions read: session-handoff-process v3;
  feat-process-runner v9, its context-at-end scenario
  (`@hash:96124cdccf45`) and its Document History v7 and v9;
  basis/glossary.md's `anchor` and `session record` entries.
- Tools, by path: `basis/tools/compile_process.py`,
  `basis/tools/lint_basis.py`.
- Touch-points swept for conflict: feat-flow-simplification (v2)
  `@hash:5b7bcafea6e1` — a quality sweep on request, not at close; no
  conflict.

## What not to do

- Do not write the cost row from an agent step, `collect` included: D1
  requires a runtime, deterministic read.
- Do not estimate or compute with a model a field the usage report
  omits: leave it blank (D1's blank-field rule).
- Do not amend `pkg:shopsystem-knowledge`'s schema to carry the row:
  not this shop's package (`single-source-of-truth`).
- Do not write a row for a runtime step: `@hash:b1e89524a00d` scopes
  rows to agent, human, and top-level turns.
- Do not restate the session record's frontmatter: reference its id
  (`single-source-of-truth`; `@hash:ca187608df17`).
- Do not add the step to reconcile-and-close or a review anchor here:
  D2 bounds the target to the session-record anchor.
- Do not analyze, filter, or present the rows here: the appetite's
  first no-go.
- Do not record any measure but wall-clock minutes (U1).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step for the five scenarios assigned to shopsystem-product; repository swept, one touch-point, no conflict. Self-check against fitness set v1: all five scenarios pass. Status written; not sent. |
| 2 | 2026-09-08 | update | Rewritten to the plain-voice rule under feat-plain-voice-rest (`@hash:8b1d5c3f9e26`): prose cut to what rules 1–5 require; v1 condensed; References and frontmatter unchanged. Self-check against fitness set v2: scenarios 1–5 hold; scenario 6 pass — 586 words against the 600 target. Made by the lead-solutions-architect role. |
