---
type: annex
id: annex-038
brief: brief-038.md
date: 2026-09-07
---

# Annex 038: the init-tool-skills run, in full (optional)

## Artifacts produced or changed, with versions

Under the initiative, made by the implementer from the scenarios and each feature's guidance record, the owner's (the product authority's) approval pending on each definition:

- `basis/types/tool-description.md` — v2, approved 2026-09-07 under the bet; the designer's screen of its field names at v1 (vocabulary v5), the one finding taken (`owner` → `tool_owner` in a beside-description).
- `basis/tools/lint_basis.py` — answers `--describe` (uses: lint, check-brief, check-process, derive-chain); strict arguments; `unreadable` for a missing path.
- `basis/tools/compile_tool.py` — new, the producer (uses: ask, produce); reads an answer or a description; digest over the source's bytes; skill stamped `source`, `source-digest`, and for a description `stands-beside`, `tool-owner`.
- `basis/tools/compile_principles.py`, `compile_process.py`, `compile_role.py`, `compile_typedef.py` — each answers `--describe` before any other action; failures coded from the closed set.
- `basis/tools/descriptions/{bd,shop-msg,shop-knowledge,agent-vault,bc-emit,shop-templates}.json` — new; written from each tool's help and observed behaviour, never its source.
- `basis/processes/skill-rendering.md` — v8 (tool skills: `tools`, `tool_compiler`; rows `tool-missing`, `tool-diverged`, `no-answer`; O6) and v9 (descriptions: `descriptions`; rows `description-missing`, `description-diverged`, `description-invalid`, `tool-answers`, `no-description`; O7); the amend-or-sibling choice taken by default (amend) and raised to the owner in its history; skill re-rendered.
- `.claude/skills/` — twelve tool skills: lint-basis, compile-principles, compile-process, compile-role, compile-typedef, compile-tool, bd, shop-msg, shop-knowledge, agent-vault, bc-emit, shop-templates; 22 process skills unchanged; 34 in all.
- `basis/README.md` — v13, v14. `basis/experience/vocabulary.md` — v4 (21 tool terms), v5 (the type's field names as identifiers; digest; producer), v6 (`tool_owner`). `basis/experience/patterns.md` — v4.

Around the initiative:

- `initiatives/init-tool-skills.md` — v14, active; v8 the bet on the standing direction, v10 active on the first feature's pass, v11 the proof's delivery (measure 1 of 12), v14 the second feature's delivery (measure 6 of 12).
- `decisions/adr-2026-09-07-tool-answer.md` — v4, checked: the flag; the answer as the skill's sole source; the data type as the contract; descriptions beside tools that cannot answer; relationship kind conformist while a tool does not answer.
- `decisions/pdr-2026-09-07-bet-tool-skills.md` — v3, checked. `backlog/order-2026-09-07.md` — v3, checked: the proof first.
- `features/feat-tool-skills.md` — v8, assigned: ten scenarios; drafted v1, designer criteria (a)–(c) v2, architect constraints (1)–(6) v3, one screen (eight findings) v3, one revise v4, checked v5, assigned v6, delivered v7, verified v8.
- `features/feat-tool-skills-rest.md` — v8, assigned: sixteen scenarios; drafted v1, designer criteria (a)–(e) v2, architect constraints (1)–(9) v3, one screen (nine findings) v3, one revise v4, checked v5, assigned v6, delivered v7, verified v8.
- `guidance/feat-tool-skills-shopsystem-product.md` v1; `guidance/feat-tool-skills-rest-shopsystem-product.md` v1.
- `requests/req-2026-09-07-<tool>-answer.md` — six gap records, recorded, route awaiting, held under the freeze; `req-2026-09-07-contributors-body.md` — routed to the lane, accepted, runs after this initiative; `req-2026-09-07-messaging-invocations.md` — routed to the lane, accepted, held until the freeze lifts.
- Research: `research:research/tool-self-description-2026-09.md` v3 (index v9). Work register: lead-176ti (the bd proof item, closed).

## The twelve tools and their sources

| Tool | Owner | Source of its skill | Uses |
|---|---|---|---|
| lint_basis.py | lead shop | its answer | lint, check-brief, check-process, derive-chain |
| compile_tool.py | lead shop | its answer | ask, produce |
| compile_process.py | lead shop | its answer | compile, compile-skill |
| compile_role.py | lead shop | its answer | validate, render, check |
| compile_typedef.py | lead shop | its answer | produce, check |
| compile_principles.py | lead shop | its answer | render |
| bd | none named | description | create, comment, close, dolt-push |
| agent-vault | none named | description | run |
| shop-knowledge | shopsystem-knowledge | description | validate, schema |
| shop-msg | shopsystem-messaging | description | send, consume |
| shop-templates | shopsystem-templates | description | list, show |
| bc-emit | shopsystem-templates | description | work-done |

## The proof runs

- First feature: one fresh-context agent, five tasks over the lint's four uses and one failing run; loaded `lint-basis` before its first command; every first invocation the skill's; the two failures (`check-failed`, `unreadable`) read from the skill's entries with the next step; no file read (feat-tool-skills v7).
- Second feature: nine fresh-context agents over the other tools; each loaded the skill first, first invocation the skill's, no retry; 9 of 11 observed. shop-msg and bc-emit not run — every described use is one the freeze bars — a labeled hypothesis (feat-tool-skills-rest v7).
- Change cases run through the check step as written: a compiler's answer changed → `tool-diverged`, re-produced, clean; a description changed → `description-diverged`, re-produced, clean; a description-sourced skill hand-edited → `description-diverged`, re-produced, clean; a scratch tool with a description that began to answer → `tool-answers`, produced from the answer, description retired, clean.

## Screens, with counts

Every screen once, one revise, under the single-cycle rule: adr-2026-09-07-tool-answer (one screen, one revise); the initiative check (one, one); the bet record (one, one); the backlog order (one, one); feat-tool-skills (one screen, eight findings — five named repaired, three uncovered ruled; one revise); feat-tool-skills-rest (one screen, nine findings — six named repaired with the PM role's rulings on the wobbly ones, three uncovered ruled; one revise); this brief (one cold read, one revise).

## Rulings taken by default under the standing direction

- Amend skill-rendering rather than define a sibling process (one load point, one check).
- The tool-description type approved after the designer's screen, as the role-offer type was approved under its bet.
- The lint's and the compilers' arguments strict; `--help` yields `usage`, exit 2 — the open scope call the brief's Ask 2 carries.
- The gap for a tool that cannot answer: one request record per tool, held while frozen (the architect's default).
- A description states at least every use a shop definition or a load-point skill names and every use the shop runs by hand (the designer's default).
- The measure counts skills produced from the tool's own answer: 6 of 12; the six described stand outside the count until their owners answer.
- A skill whose source is a bare command is read by the tool kind at the check (the maker's how under constraint (4)).
- The gap request's closing is escalated to the lead-pm, the request typedef naming the status writers.

## Timeline (commit times, 2026-09-07)

16:10 initiative recorded and the standing direction · 16:15–16:25 attachments, the ADR through its pre-bet route · 16:29 bet · 16:32–16:35 bet record and order · 16:39–16:55 first feature drafted, criteria, constraints, screened, checked · 17:00 assigned · 17:14 proof delivered and verified · 17:19 type approved · 17:20–17:44 second feature drafted, criteria, constraints, screened, checked · 17:52 assigned · 18:17 delivered and verified. Total 2 h 7 min for two features end to end.

## Cold read

Recorded in the brief's Document History.
