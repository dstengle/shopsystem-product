---
type: annex
id: annex-039
brief: brief-039.md
date: 2026-09-07
---

# Annex 039: the init-process-runner run, in full (optional)

## Artifacts, with versions

- `basis/roles/router.md` v4, approved on the bet; `.claude/agents/router.md` rendered (digest bb223f1836d5); `model: haiku`, tools Read, Bash, Agent.
- `basis/tools/compile_process.py`: the declared-outputs line on every agent step; 22 skills re-rendered; skill-rendering check clean.
- `basis/glossary.md` v25 (router). `features/feat-process-runner.md` v8 (delivery v7, verification v8). `initiatives/init-process-runner.md` v8, active. `decisions/adr-2026-09-07-coordinator-role.md` v3, checked. `decisions/pdr-2026-09-07-bet-process-runner.md` v3, checked. `backlog/order-2026-09-07-b.md` v3, checked.
- Reverted after the run: `basis/artifacts/feature.md`, `basis/guidelines/feature.md`, `basis/fitness/feature.fitness.md` (the lane's make step on the cheap tier had written v15 and compiled renderings); `requests/req-2026-09-07-contributors-body.md` reset to its work-item link (v2).

## The two runs (read with `bd comments <anchor>`)

- **lead-4ppfo** — the small-change lane entered directly: start (parameters and model recorded); name-result (set); read-id; read-anchor exit 1 → held, status and message shown; cancel turn; confirming turn closed the anchor with the reason (the request named no work item; intake opens it).
- **lead-5wzgl** — request-intake on the request: enter branch; decide-route launched as lead-pm, return lacking `form` → held with the missing output named; the answer recorded and resumed; branches route-decided, route-answer, dispatch recorded with their values; land opened lead-ryr33; held at open-lane; on resume the child lane was launched inside the router's session — the child recorded start on lead-ryr33 and stopped at make, after its make step rewrote the feature typedef.

## Router context per segment (harness usage, all claude-haiku-4-5)

| Anchor | Segment | Input | Cache create | Cache read | Output |
|---|---|---|---|---|---|
| lead-4ppfo | 1 | 98 | 27,097 | 250,433 | 4,966 |
| lead-4ppfo | 2 | 74 | 9,176 | 118,282 | 2,337 |
| lead-4ppfo | 3 | 50 | 10,272 | 70,280 | 1,706 |
| lead-4ppfo | 4 | 50 | 8,995 | 75,923 | 1,635 |
| lead-5wzgl | 1 | 26 | 1,880 | 98,100 | 2,014 |
| lead-5wzgl | 2 | 194 | 31,240 | 599,387 | 11,041 |
| lead-5wzgl | 3 | 156 | 40,402 | 476,366 | 4,939 |

Segments 1–3 of lead-5wzgl including the launched steps: 1,115 / 43,175 / 456,741 / 11,109; and with the child lane and its agent steps: 1,634 / 221,635 / 2,291,827 / 55,391.

## The three defects and their lines

1. Cancel taken in the turn that asked for it → the hard-to-reverse act waits for the confirming turn (v2 revise, from the screen).
2. The human step observe answered from the request's record → a human step's answer is the person's turn and comes from no record, file, or earlier value (v4).
3. The sub-process launched inside the router's session → a sub-process step starts a run of its own on its own anchor; the parent holds (v3).

## Scenarios observed (13 of 19)

Start with parameters and model; runtime step as written; non-zero exit held; branch value recorded; agent step launched with declared inputs; return naming outputs; return lacking an output held; answer resumes; router restarted from the anchor restates id, step, awaited; cancel on confirmation; router approved and available; router writes no decision; context recorded per segment.

## Cold read

Recorded in the brief's Document History.
