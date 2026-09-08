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
names the definitions and tools to change. It is a historical record of
this assignment and binds nothing after it.

## What changes

Contracts: none exist on this branch, so none is versioned. Guardrails:
adr-2026-09-08-run-cost-artifact (v3, checked) — the row is written
only by a runtime step, never an agent step, added to
session-handoff-process immediately after `collect`, never inside it;
a field the harness's usage report does not expose for a run is left
blank, never estimated and never computed by a model. Cross-context
flow: none — `pkg:shopsystem-knowledge`, itself a Bounded Context per
its own published metadata but external to this product's own
decomposition, is read only through its existing contract tool,
unchanged and gains no field. The changes:

1. **One new artifact typedef, in the lead shop's own tree**, for the
   run-cost artifact D1 places beside the session record: one file per
   session record, paired with it (U2's default, the maker's choice of
   exact name and location — no scenario binds a path). Its schema
   carries step, role, minutes, context tokens, output tokens, and
   tool uses as fields, each nullable except where the harness always
   supplies it; it references the session record's own identifying
   field rather than restating its frontmatter. Serves
   `@hash:ca187608df17`, `@hash:a156efde14c9`, `@hash:475294f4bb30`.

2. **session-handoff-process (`basis/processes/session-handoff.md`,
   v3) gains one new runtime step**, placed immediately after
   `collect` and before `validate` — never inside `collect`, which
   stays agent-run (execution `agent`, run-by the router) and keeps
   writing only the session record. The new step reads two sources
   only: the run's anchor, where the run passed through the router and
   which records each agent run's step and role and its start and end
   timestamps (feat-process-runner v9, the context-at-end scenario,
   `@hash:96124cdccf45`), and the harness's own usage report, which the
   delivered router already reads per resumed segment and per launched
   role (feat-process-runner Document History v7 and v9). From those
   two sources alone it writes one row per agent run naming step,
   role, minutes read as the wall-clock span between the anchor's own
   two timestamps, context tokens, output tokens, and tool uses; it
   counts an agent run only for each step run by an agent or a human
   and for each top-level router or lead-pm turn, writing no row for a
   runtime step in the process. The process definition's version
   advances and its skill re-renders via
   `basis/tools/compile_process.py basis/processes/session-handoff.md --skill .claude/skills/session-handoff/SKILL.md`
   under the skill-rendering process. Serves `@hash:2eda37f33645`,
   `@hash:475294f4bb30`, `@hash:a156efde14c9`, `@hash:b1e89524a00d`.

3. **Reconcile-and-close and a review conversation's anchor are not in
   this assignment.** D2 (adr-2026-09-08-run-cost-initiative-scope)
   bounds the target to the session-record anchor alone; whether either
   of those two anchors needs the same step is a separate request
   against reconcile-and-close and the review-conversation anchor
   process — not yet defined on this branch — not decided here.

4. **Done means** (`delivery-verified`): the artifact typedef stands
   with a Document History row, `session-handoff-process` carries the
   new runtime step at its version bump, the re-rendered skill is
   byte-equal to a fresh render, `python3 basis/tools/lint_basis.py`
   reads clean, and a row is demonstrated written at one router-moved
   session's close, referencing that session's own record — what the
   reconcile-and-close process reads when the work returns.

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
- Touch-points in the repository swept for conflict: feat-flow-simplification
  (v2) `@hash:5b7bcafea6e1` — a quality sweep runs on request rather
  than at session close; a different subject (a quality check, not a
  cost row) at the same close step, no conflict.

## What not to do

- Do not write the cost row from an agent step, including from inside
  `collect` itself: D1 requires a runtime step, never an agent step —
  assembling the row needs no judgment, only a deterministic read of
  the anchor and the harness's usage report.
- Do not estimate or compute with a model any field the harness's
  usage report does not expose for a run: leave it blank. The
  initiative's own no-go against a model-computed measure, and D1's
  blank-field rule, both bind this.
- Do not amend the `pkg:shopsystem-knowledge` session-record schema to
  carry the row: it is a package this shop does not own; D1 places the
  row in a new lead-shop artifact instead (`single-source-of-truth`).
- Do not write a row for a runtime step in session-handoff-process:
  `@hash:b1e89524a00d` scopes rows to agent steps, human steps, and
  top-level router or lead-pm turns only.
- Do not restate the session record's own frontmatter fields on the
  new artifact: reference its identifying field instead
  (`single-source-of-truth`; `@hash:ca187608df17`).
- Do not add the same step to reconcile-and-close's close step or to a
  review conversation's anchor under this assignment: D2 bounds the
  target to the session-record anchor alone; either is a separate
  request, not decided here.
- Do not analyze, filter, or present the rows in this step: the
  appetite's first no-go places analysis in a separate orchestration
  step, not this one.
- Do not record any measure of minutes besides wall-clock time (no
  agent-minutes column): U1's default — wall-clock only, read off the
  anchor's own timestamps, since the anchor does not yet keep turns
  summed separately.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Written by the lead-solutions-architect role at the scenario-assignment process's assign step for the five scenarios of feat-run-measurement assigned to shopsystem-product, from the implementation-guidance guideline (v1) and the decomposition read from init-run-measurement (v6, Decomposition section: "None: no Bounded Context is touched ... sit in the lead shop's own tree"), matching the Contributors section's own owning-shop finding for all five scenarios. Repository swept for conflict across all eleven current features (the nine the initiative's own attach-time sweep already read, plus feat-flow-simplification and feat-plain-voice, added since): only feat-flow-simplification names a session-close step (`@hash:5b7bcafea6e1`, a quality sweep run on request rather than at close), a different subject than a cost row at the same close step — no conflict, no scenario sent to unowned. Maker's self-check against the implementation-guidance fitness set (v1): scenario 1 (the architect's level) pass — each statement in What changes names a guardrail (D1, D2), a definition by path and version, or a tool by path, and none names a Bounded Context's internals (none exists); scenario 2 (cited, never restated) pass — every scenario cited by hash, the ADRs and definitions by id and version, and no Given/When/Then text or contract clause reproduced; scenario 3 (actionable alone) pass — the artifact typedef's fields, the new step's placement and its two read sources, the render command, and the two things left to other owners (reconcile-and-close, the review-conversation anchor) are all named, so the shop can begin with the scenarios beside it; scenario 4 (reasons) pass — each of the eight entries in What not to do names a decision (D1, D2), a principle (`single-source-of-truth`), or the appetite's own no-go or default (U1) as its reason; scenario 5 (one assignment) pass — the frontmatter and opening paragraph name the initiative, the feature, the context, and the five hashes, and every statement is about those scenarios; item 3 states what is not in this assignment rather than binding a later one. Status written; not sent. |
