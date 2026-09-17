---
type: implementation-guidance
id: guidance-feat-implementation-process-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-implementation-process.md
feature: ../features/feat-implementation-process.md
context: shopsystem-product
scenarios: ["@hash:e996f2d086ab", "@hash:afe74d3e9ff5", "@hash:f90002450ad9", "@hash:0e92f2731640"]
owner: lead-solutions-architect
created: 2026-09-17
updated: 2026-09-17
---

# Implementation guidance: feat-implementation-process for shopsystem-product

For the four scenarios of feat-implementation-process (v3) assigned to
shopsystem-product — the lead shop itself — on 2026-09-17 under
init-implementation-process (v4); the hashes are the frontmatter's
`scenarios` list. Historical record; binds nothing after it.

## What changes

No contract; no Decomposition section. Order below.

1. **New process-definition, `basis/processes/`** (a sibling of
   small-change.md, not a change to it): one process covering build
   work outside the simple-change lane, naming a `make` step and a
   `check` step that gates the "done" outcome. Serves
   `@hash:e996f2d086ab`.
2. **That process-definition's `make` and `check` steps**: `run-by`
   fixed to literal role ids, on small-change.md's own precedent
   ("fixing both make's and check's roles is what makes 'the checker
   is never the maker' a mechanical fact"), naming the two
   implementation roles feat-implementation-good's own assignment
   produces — not named here, since they do not yet exist. Serves
   `@hash:afe74d3e9ff5`.
3. **The same process-definition's steps and carrier**: every step
   runs by role prompt or by runtime command, none by `shop-msg` or a
   mailbox call, on small-change.md's carrier as the precedent for a
   dispatch-free process; render the skill via `compile_process.py`.
   Serves `@hash:f90002450ad9`.
4. **No new cost tool.** An execution of the new process is a session
   whose anchor already carries the bead feat-initiative-cost-rollup
   delivered (`@hash:5d23e3458539`); its cost rows write through
   feat-run-measurement's existing session-close mechanism. The new
   process-definition needs no cost step of its own. Serves
   `@hash:0e92f2731640`.
5. **Not in this assignment:** the two implementation roles'
   definitions (feat-implementation-good's own scope, assigned
   separately); a Bounded Context shop executing this process (barred
   while the shop stands frozen); which feature proves the process
   (the initiative's next real feature, at that feature's own
   assignment).

## References

- Initiative: init-implementation-process (v4, active). Feature:
  feat-implementation-process (v3, checked); scenarios per the
  frontmatter list.
- Contracts: none exist on this branch.
- Definitions read: small-change.md (v7), for the maker/checker/no-
  dispatch precedent; feat-implementation-good (v6), which defines the
  two implementation roles this process's steps will name; feat-run-
  measurement (v13) and feat-initiative-cost-rollup (v11), for the
  cost mechanism already in place; adr-2026-09-16-scenario-evidence-
  form (v1), the evidence bar the check step reads; gap lead-ki66p,
  the framing's standing record.
- Tools: `compile_process.py`. No new tool: `write_cost_rows.py` and
  `rollup_cost.py` already serve scenario 4.

## What not to do

- Do not fold this process into small-change.md or widen its scope:
  small-change is fixed to the simple-change lane, feat-request-
  routing's own scenarios (`single-source-of-truth`).
- Do not name the maker or checking role's identity in this process's
  steps yet: that identity is feat-implementation-good's own
  assignment to produce, not this one's to guess (`single-source-of-
  truth`).
- Do not add a `shop-msg` or mailbox step anywhere in the new process:
  the initiative's no-go bars dispatch while the shop stands frozen.
- Do not add a cost-recording field or tool: feat-run-measurement and
  feat-initiative-cost-rollup already deliver what scenario 4 needs
  (`single-source-of-truth`).
- Do not let a Bounded Context shop execute this process before
  cut-over: the initiative's no-go, and `contracts-between-contexts`
  binds nothing here since no contract exists.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-17 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step. Self-check against the implementation-guidance fitness set: scenario 1 pass — every What-changes statement names a process-definition, a step's run-by, or an existing tool, none the lead shop's file internals beyond that; scenario 2 pass — scenarios cited by hash, feat-implementation-good and the cost features cited by name and version, no scenario text reproduced; scenario 3 pass — the shop can start the new process-definition and its two fixed-role steps with this record and the assigned scenarios alone; scenario 4 pass — each What-not-to-do entry carries its reason; scenario 5 pass — frontmatter names the initiative, feature, context, and the four hashes, and every statement is scoped to them; scenario 6 pass — under 600 words. Status written; not sent. |
