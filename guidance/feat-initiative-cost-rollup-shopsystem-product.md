---
type: implementation-guidance
id: guidance-feat-initiative-cost-rollup-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-run-measurement.md
feature: ../features/feat-initiative-cost-rollup.md
context: shopsystem-product
scenarios: ["@hash:pending (bead names its initiative)", "@hash:pending (leaf rollup sums sessions)", "@hash:pending (parent rollup sums children)", "@hash:pending (rollup only on request)"]
owner: lead-solutions-architect
created: 2026-09-09
updated: 2026-09-09
---

# Implementation guidance: feat-initiative-cost-rollup for shopsystem-product

For the four scenarios of feat-initiative-cost-rollup assigned to
shopsystem-product — the lead shop — on 2026-09-09 under
init-run-measurement (v8): a bead names its initiative; a leaf's
rollup sums its sessions; a parent's rollup sums its children; the
rollup runs only on request. The lead shop builds its own
definitions, so this record names the definitions and tools to
change. Historical record; binds nothing after it.

## What changes

Guardrails: adr-2026-09-08-run-cost-artifact (D1) and
adr-2026-09-08-run-cost-initiative-scope (D2) — the session-handoff
session-record anchor only, no model computes a figure, the same
bound as feat-run-measurement. No contract, no cross-context flow.

1. Wherever a bead opens for work under an initiative, it records
   that initiative on itself, beside the process id
   `write_cost_rows.py` already reads there — never on run-cost's own
   frontmatter (`single-source-of-truth`); the bead is the one place
   an execution's initiative is read from.
2. A rollup tool, sibling to `write_cost_rows.py`, invoked only on
   request, never a process step: for a leaf, reads every session's
   run-cost artifact whose bead (its `anchor` field) names it and sums
   the rows, no model; for a parent, sums its children's own
   already-computed rollups, via the initiative typedef's `parent`
   field, never re-reading a child's raw rows.
3. No runtime or agent step triggers a rollup: request only.
4. Bounded exactly as feat-run-measurement: a session no approved
   process definition moved through the router has no bead to key on;
   a review or work-item anchor is out of scope (D2).

## References

- init-run-measurement (v8); feat-initiative-cost-rollup (v10 at
  assignment); the four scenarios named above.
- Decisions: adr-2026-09-08-run-cost-artifact (D1, v3);
  adr-2026-09-08-run-cost-initiative-scope (D2, v3).
- Contracts: none on this branch.
- Definitions: run-cost-typedef v2 (`anchor`); basis/artifacts/initiative.md
  v12 (`parent`); glossary `bead`, `execution`, `anchor` (v26).
- Tool: `basis/tools/write_cost_rows.py`, its sibling to build.
- Swept: feat-execution-vocabulary (v16, delivered), its vocabulary
  matching this feature's own; no other feature names an
  initiative-bead link or a rollup; no conflict.

## What not to do

- Do not write the initiative onto run-cost's own frontmatter: the
  bead is the one home (`single-source-of-truth`).
- Do not compute or estimate a rollup with a model: the second no-go.
- Do not wire the rollup into any process step: scenario 4 scopes it
  to a request only.
- Do not extend it to reconcile-and-close or a review anchor: D2's
  bound.
- Do not have a parent's rollup re-read its children's raw rows: it
  sums their own rollups only ("without a model").

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step for the four scenarios assigned to shopsystem-product, feat-initiative-cost-rollup (v10); repository swept, thirteen other features, one touch-point (feat-execution-vocabulary v16, delivered, no conflict). Self-check against implementation-guidance fitness set (v2): scenario 1 pass — each What-changes item names a guardrail, a definition, or a tool, never a context's internals; scenario 2 pass — scenarios cited by hash and name, decisions and definitions by id and version, nothing restated; scenario 3 pass — the bead-recording point, the two sum rules, and the request-only bound are named, actionable alone; scenario 4 pass — every What-not-to-do entry names its reason; scenario 5 pass — frontmatter and opening paragraph name the initiative, feature, context, and all four scenarios; scenario 6 pass — `wc -w`, under target. Status written; not sent. |
