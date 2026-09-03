---
type: annex
id: annex-034
brief: brief-034.md
date: 2026-09-03
---

# Annex 034: the roles-availability run, in full (optional)

## Artifacts produced this session

- `initiatives/init-roles-availability.md` — proposed → planned → active; v6.
- `decisions/pdr-2026-09-03-bet-roles-availability.md` — the bet's record, checked (3 rounds, cap, no confident finding).
- `backlog/order-2026-09-03.md` — supersedes order-2026-09-02; checked clean round 1.
- `roadmap.md` v2 — roles first, skills active, later rendering work third, ADR item delivered.
- `features/feat-roles-availability.md` — eight scenarios; checked (3 rounds; round 2's confident gap in scenario 8 repaired; two post-cap Edges edits disclosed); assigned to shopsystem-product with a disclosed no-send; v6 carries the running-system witness.
- `basis/processes/role-rendering.md` — approved v5 after three screen rounds; first run recorded.
- `basis/tools/compile_role.py` — the role compiler: render, refuse non-approved, check with five finding kinds (diverged, missing, will-not-compile, stale, unrecognized).
- `.claude/skills/role-rendering/SKILL.md` — the carrier, rendered by skill-rendering; `.claude/skills/skill-rendering/SKILL.md` re-rendered over a digest-only divergence.
- `.claude/agents/` — six rendered roles.
- `sessions/sess-2026-09-03-a.md` — the session record.
- Beads: lead-sx9xj (later comprehensive rendering work), lead-xmuft (failed step reads clean); lead-wm8n5 closed onto the session record.
- `basis/fitness/initiative.fitness.md` — gap review entry (scenario 4 quote exemption).

## Screen rounds (judge claude-fable-5-1 throughout)

| Artifact | Criteria | Rounds | Outcome |
|---|---|---|---|
| Initiative | initiative fitness (v5 prompt) | 3 | cap; two wobbly, both on prior rulings; bet on standing direction |
| Backlog order | backlog-order fitness (v6) | 1 | clean |
| PDR | product-decision-record fitness (v6) | 3 | cap; wobbly only, sets differed each round; pass |
| Feature | feature fitness (v6) | 3 | round 2 confident gap repaired; cap with wobbly only; pass with two disclosed post-cap Edges edits |
| Process definition | process-definition fitness (v6) | 3 | confident findings each round repaired (route on open rows; kind vocabulary; filter quoting); post-cap repairs disclosed; approved |

## The runs

Skill-rendering check, round 1: `missing role-rendering-process`, `diverged skill-rendering-process` (digest only). Reconciled by re-render; round 2: `approved-count 19` only. The run-record row then re-diverged the new carrier once; re-rendered; clean.

Role-rendering, round 1: six `missing` rows, one per approved role. Reconciled by render into `.claude/agents/`. Round 2: no rows; first success exit. Final: `ok` for all six.

## Running-system demonstration

Before: a fresh headless session in this tree listed `lead-architect` and `lead-po` (the frozen corpus's descriptions) and none of the six approved roles. After: it listed cold-reviewer, lead-pm, lead-po, lead-product-designer, lead-solutions-architect, researcher, and no `lead-architect`. Asked to instantiate `lead-po` and quote its instructions' opening, the subagent returned the compiler's header ("Generated from `basis/roles/lead-po.md` by `basis/tools/compile_role.py`") and "You hold the role that makes the requirements."

## Rulings the lead-pm made in the authority's absence, all recorded

Initiative: two wobbly findings held on the skills precedent. PDR: pass at cap. Feature: narrative duplication ruled typedef-mandated; two post-cap edits. Process: scenario 2 witnessed at delivery not by the process; carrier deferral stands; writes to paths in `approved` are writes to a declared input; post-cap repairs directed. Roadmap re-recorded v2.
