---
type: initiative
id: init-roles-availability
name: Roles availability
status: active
version: 8
owner: lead-pm
created: 2026-09-03
updated: 2026-09-04
---

# Initiative: Roles availability

## Framing

Originator (product authority, 2026-09-04, through the operational
contract, restating the problem behind the 2026-09-03 request): "The
agent is not populated with the approved role definitions, just as it
was not populated with the approved process definitions before." And
on the risk (2026-09-03): "run this through to the end since it is
low-risk."

Problem: the shop's approved role definitions cannot be instantiated
by the agent runtime; what it instantiates instead comes from the
frozen corpus, and making a role available belongs to no process.
Outcome: an agent filling a role operates from the approved definition
of that role, loaded at its point of work from an approved source that
is itself maintained by a defined process with its own check.

## For whom

The lead shop: every process step run by an agent in a named role.
Measure: approved roles the agent runtime instantiates from an
approved source that is current with the definition. Now: 0 of 6 —
the two roles the runtime does instantiate come from the frozen
corpus, unapproved on this branch. Target: 6 of 6.
Interaction types: none — the outcome is consumed inside the agent
runtime's instantiation of the role; no core task carries it.

## Appetite

One working session of the lead shop. No-gos, each with its reason:

- Deepening the role definitions (brief-030 ask 1) — availability
  does not depend on depth; the roles stand approved as they are.
- Using the frozen corpus's role material as source — the approved
  definitions are the only source; the authority ruled the corpus
  import out on 2026-09-02 and migration stays demand-pull.
- Touching what the frozen corpus loads before cut-over — the corpus
  is frozen; this branch never publishes to it.
- Widening beyond roles in this session — the authority's "more
  comprehensive work later"; the wider work is filed as a backlog item
  in those words.

## Feasibility and usability

Feasible. The six approved role definitions already carry the
runtime's subagent keys — `name`, `description`, `tools`, `maxTurns` —
in their frontmatter, alongside shop keys the runtime does not read;
the render is a strip, a `source-digest`, and placement, the pattern
`basis/tools/compile_process.py` already implements. The load point
`.claude/agents/` does not exist on this branch, so nothing there
conflicts. Within the appetite. (architect, 2026-09-03)

No usability attachment due: no interaction type named; the outcome
loads in the runtime's role instantiation, no core task carries it, and
the render is outside `agent-is-a-user`'s closed set. (designer,
2026-09-03)

## Decomposition

None — no Bounded Context is touched. Source definitions, the
render, and the load point all sit in the lead shop's tree; no contract
exists on this branch to rely on. Cross-context flow: none.

## Features

[feat-roles-availability](../features/feat-roles-availability.md) — checked.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-03 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence (work item lead-wm8n5; session sess-2026-09-03-a). The authority's shape ruling, in its words, under which the architect attached: "Render the role rather than use verbatim, sibling process for now, more comprehensive work later." |
| 2 | 2026-09-03 | review | Initiative-check screen round 1 (judge: claude-fable-5-1 / screen prompt v5): findings — no-go 4 named the solution structure (confident); the shape-ruling quote in §1 carried structure (wobbly; moved to the history entry above, the problem quote kept); the §2 target carried quantities beyond the measure (wobbly; measure now carries "current with the definition", target 6 of 6); no-go 3 named the `main` checkout (wobbly; reworded); the two instantiated roles' origin unstated (uncovered; the corpus's own checkout named). Repaired. |
| 3 | 2026-09-03 | review | Screen round 2 (judge: claude-fable-5-1 / screen prompt v5): five wobbly findings, none confident. Repaired: "checkout" in §2 (the corpus named plainly); no-gos 1 and 2 reworded to what they exclude without naming forms. Held for the authority, on the skills-availability precedent: the originator's quoted "claude" and "skills" (round 3 of that screen confined solution words to the originator's quote); the §1 outcome clause "maintained by a defined process with its own check" (the owner's own wording of 2026-09-02); the history's form (repairs recorded in the review row, as every initiative on this branch does). |
| 4 | 2026-09-03 | review | Screen round 3, the cap (judge: claude-fable-5-1 / screen prompt v5): two wobbly findings, none confident, no uncovered defect — the originator's quoted "claude" and "skills" against scenario 4, and the §1 outcome's maintenance clause. Both passages stand on the authority's prior rulings (skills-availability rounds 3 and v5); no repair. The judge's proposal that scenario 4 exempt the originator's quoted words, recurring on both initiatives, is filed as a review entry in the initiative fitness set's Document History for the owner. |
| 4 | 2026-09-03 | state | `proposed` → `planned`: the authority's bet, taken in the initiative-check decide step on its standing direction of this session — "run this through to the end since it is low-risk" — the lead-pm recording it; the two open findings are each settled by the authority's own earlier ruling, so no new decision is taken here. The product decision record for the go is the PO role's to make and the PO output check screens it; linked here once made. Made: [pdr-2026-09-03-bet-roles-availability](../decisions/pdr-2026-09-03-bet-roles-availability.md). |
| 5 | 2026-09-03 | state | `planned` → `active`: feat-roles-availability's first pass through the PO output check (round 3, the cap; the PM role's pass) — written by that check's record step through its declared framing input, planned the only status written over. |
| 6 | 2026-09-03 | update | Measure met in the running system: 6 of 6 approved roles instantiated by the agent runtime from the load point, current with their definitions (role-rendering first run, check clean round 2; the instantiation recorded in feat-roles-availability v6). The `completed` state is a pending reconcile-side amendment; the PO role judges the features done. |
| 7 | 2026-09-04 | update | Authority's ruling on brief-034 ask 4: the false-clean gap (lead-xmuft) is a direct risk to this initiative and "should be handled within the same run" — applied as a decision to the affected definitions (skill-rendering v6, role-rendering v6, both compilers) past the spent appetite, the overrun recorded here as the authority's; the mechanism for such extensions is filed as lead-m6m2b. Ask 3 ruled: the criterion stands, the framer's wording changes — the authority's restatement of the Framing quote is pending (lead-4bm7q carries the discovery-side reinforcement). |
| 8 | 2026-09-04 | update | Framing quote restated on the authority's ruling (brief-034 ask 3: the wording changes, not the criterion). Original words of 2026-09-03, moved here from §Framing: "Next initiative: make roles available to agents. We've made skills available to claude and need to do similar with roles." The authority's first restatement carried "compiled" and "just as the skills"; the lead-pm proposed the recorded form and the authority accepted it: "go with your version." |
