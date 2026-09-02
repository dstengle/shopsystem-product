---
type: initiative
id: init-skills-availability
name: Skills availability
status: active
version: 6
owner: lead-pm
created: 2026-09-02
updated: 2026-09-02
---

# Initiative: Skills availability

## Framing

Originator (product authority, 2026-09-02, through the operational
contract): "We have a number of processes, guidelines, etc defined in
basis, but they are not placed where an agent would make use of them.
The skills directory is in the wrong place and incomplete." Scope, in
the originator's words: "This is very constrained and limited to
making sure skills are available to the agent. This should itself be a
process." And the stakes: "This session is showing that we are already
drifting away from the principles and need to start implementing
consistency in the process and tools."

Problem: the shop's approved process definitions cannot be loaded by
the agent performing the activity, and making them loadable belongs to
no process. Outcome: an agent performing an
activity operates from the approved definition of that activity,
loaded at its point of work from an approved source that is itself
maintained by a defined process with its own check.

## For whom

The lead shop: every agent activity that operates through a process
definition. Measure: approved processes whose definition the executing
agent can load from an approved source. Now: 1 of 16, and that one
hand-diverged from its source. Target: every approved process, zero
divergence, the gap held closed by a repeatable check. Interaction
types: none — the outcome is consumed inside the executing agent's
context load; no core task carries it.

## Appetite

One working session of the lead shop. No-gos, each with its reason:

- Importing skills from the frozen corpus (brief-030's 38-skill plan)
  — the authority ruled it out; migration stays demand-pull and lands
  through whatever this initiative makes available.
- Delivering guidelines into authoring contexts — the glossary places
  guidelines in the artifact process; the observed gap is filed
  separately (lead-m2o7h).
- Role definitions, beyond any part that is itself skill-shaped — the
  authority excepted them.
- Retrieval, relevance, or knowledge-graph work — parked as premature
  on lead-jwsl1.

## Feasibility and usability

Feasible. The generating channel exists and runs:
`basis/tools/compile_process.py` regenerated the
`stakeholder-presentation` skill cleanly, and its `source-digest` makes
divergence mechanically checkable — the reachable copy's stale digest
confirms the hand-drift. Ten of sixteen approved processes already have
generated renderings in `basis/skills/`; the rest compile from the same
format. What remains is placement and a defined process with its check —
within the appetite. (architect, 2026-09-02)

No usability attachment due: no interaction type named — the outcome
loads inside the executing agent's context; no core task carries it.
(designer, 2026-09-02)

## Decomposition

None — no Bounded Context is touched. Source definitions, the
generator, and the delivery point (`.claude/skills/`) all sit in the
lead shop's tree; no contract on `main` is relied on. Cross-context
flow: none.

## Features

[feat-skills-availability](../features/feat-skills-availability.md) — checked.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence (work item lead-jacwu; session sess-2026-09-02-b). |
| 2 | 2026-09-02 | review | Initiative-check screen round 1 (judge: claude-fable-5 / screen prompt v5): findings — the measure counted 17 against 16 approved processes; "generated" named the production mechanism in the measure; "delivered as a skill" in the outcome. Repaired. |
| 3 | 2026-09-02 | review | Screen round 2 (judge: claude-fable-5 / screen prompt v5): one wobbly finding — whether "skill" in §1–2 is the what or a named form. Repaired solution-free; "skills" confined to the originator's quoted words. |
| 4 | 2026-09-02 | review | Screen round 3, the cap (judge: claude-fable-5 / screen prompt v5): one wobbly finding — scenario 4's scope over the broken-state description in the problem sentence. The authority directed the capability-terms repair; applied post-cap, the structural evidence standing in §4. |
| 4 | 2026-09-02 | state | `proposed` → `planned`: the authority's bet, taken in the initiative-check decide step on the repaired text — the appetite is spent. The product decision record for the go is the PO role's to make and the PO output check screens it; linked here once made. Made: [pdr-2026-09-02-bet-skills-availability](../decisions/pdr-2026-09-02-bet-skills-availability.md). |
| 5 | 2026-09-02 | update | Owner direction, from the feature check's open finding: "through a governed channel" could imply a synchronous or real-time delivery, not the intent — replaced in the §1 outcome with "from an approved source that is itself maintained by a defined process with its own check" and in the §2 measure with "from an approved source". |
| 6 | 2026-09-02 | state | `planned` → `active`: feat-skills-availability's first pass through the PO output check (clean round-2 screen; the PM role's pass) — written by that check's record step through its declared framing input, planned the only status written over. |
