---
type: annex
id: annex-036
brief: brief-036.md
date: 2026-09-05
---

# Annex 036: the typedef-rendering run, in full (optional)

## Artifacts produced or changed this session

- `requests/req-2026-09-05-typedef-rendering.md` — the authority's ask, recorded and routed to discovery; the route accepted ("I accept"); done, v4.
- `initiatives/init-typedef-rendering.md` — proposed → planned → active; v12 carries the measure met (0 → 1 of 22). The Framing quote restated on the authority's acceptance ("Go with your version"), the original words moved to its history (v7).
- `decisions/adr-2026-09-05-typedef-rendering.md` — the design decision, recorded before the bet: an artifact type's typedef is its one hand-edited standard; its guideline and fitness set are produced from it. Checked, v4; decider the authority, `right: escalation`.
- `decisions/pdr-2026-09-05-bet-typedef-rendering.md` — the bet's record and the proof; made by the PO role from the produced guideline; checked, v4.
- `backlog/order-2026-09-05.md` — supersedes order-2026-09-04; init-typedef-rendering first; checked, v2.
- `roadmap.md` v5 — init-typedef-rendering first; the six routed requests noted as awaiting the authority's answer.
- `features/feat-typedef-rendering.md` — seven scenarios (nine drafted; the two batch cases moved to the second bet's feature); designer criteria none due; architect constraints C1–C6; checked at the cap (v6); assigned to shopsystem-product with a disclosed no-send (v7); v8 carries the delivery record.
- `basis/artifacts/artifact-typedef.md` v3 — admits the sections Writing rules and Fitness scenarios; for a type carrying them the guideline and fitness set are renderings, produced by the compiler, never hand-edited.
- `basis/artifacts/quality-guideline.md` v5 — Produced by admits a guideline produced from the typedef, marked `generated`, `generated-by`, `source`, `source-digest`; no version or history of its own.
- `basis/artifacts/fitness-set.md` v3 — the same for a fitness set; `judged-by` from the typedef's Fitness scenarios section.
- `basis/artifacts/product-decision-record.md` v7 — the guideline (v2) and fitness set (v3) folded in as the two sections, verbatim in substance; their own histories end there.
- `basis/guidelines/product-decision-record.md`, `basis/fitness/product-decision-record.fitness.md` — now produced by the compiler; `source-digest: sha256:d2e74320dabb`.
- `basis/tools/compile_typedef.py` — write mode (both texts from one typedef) and `--check` (fresh render diffed against what stands); `will-not-compile` rows for a typedef it cannot read; byte-stable.
- `basis/processes/typedef-rendering.md` — approved v4 after three screen rounds; a sibling of skill-rendering and role-rendering.
- `.claude/skills/typedef-rendering/SKILL.md` — rendered by skill-rendering (check clean, 22 approved); the runtime lists it.
- `basis/README.md` v10.
- `requests/req-2026-09-05-step-communication.md`, `-feasibility-defined.md`, `-no-tools-mid-process.md`, `-banned-words-inlined.md`, `-maker-self-check.md` — recorded through intake from the run review; each routed and said; awaiting the authority's answer.
- `requests/req-2026-09-05-single-review-cycle.md` — the authority's ruling recorded, routed to the lane, accepted ("Proceed with the review cycle definition change only"); defined by the PO role at the lane's define step (v3); work item `lead-6nc6r`.
- `initiatives/init-request-routing.md` — Features line corrected to assigned.
- `sessions/sess-2026-09-05-a.md` (the run review and the discovery), `sessions/sess-2026-09-05-b.md` (this delivery).

## Screen rounds per artifact (judge claude-fable-5-1 throughout)

Confident: a finding the judge is sure of. Wobbly: one the judge could not settle either way. Self-check: the maker applied the criteria to its own draft before round 1.

| Artifact | Criteria (prompt) | Self-check | Rounds | Confident per round | Outcome |
|---|---|---|---|---|---|
| Initiative | initiative fitness (screen v5) | no — framed at the discovery | 3 (cap) | 5, 3, 1 | round 1 all scenario 4 (mechanism words), repaired; the cap's one gloss and three wobbly repaired past it and disclosed; two wobbly held for the authority at the bet |
| ADR | adr fitness (screen v6) | yes | 3 (cap) | 3, 1, 6 | the cap's six all wording and unintroduced terms, repaired past it and disclosed; checked |
| Backlog order | backlog-order fitness (screen v6) | yes | 1 | 0 | three wobbly glossed at the record step; pass |
| Feature | feature fitness (screen v6) | yes — fixed three defects before submission | 3 (cap) | 1, 0, 2 | round 2 eight wobbly, the two batch scenarios moved out; the cap's two (an Edges row's coverage; "the compiler" unglossed) repaired past it and disclosed; pass |
| PDR (the proof) | produced product-decision-record fitness set, `sha256:d2e74320dabb` (screen v6) | yes — five of five, re-run after each revise | 3 (cap) | 1, 0, 0 | the cap's two wobbly glossed and repriced at the record step, disclosed; checked |
| typedef-rendering process | process-definition fitness (screen v6) | yes | 3 (cap) | 1, 0, 1 | the cap's one (the hand-written sweep after a refused render) repaired in the one revise the single-cycle ruling allows; approved |

Totals: 16 rounds on 6 artifacts; 25 confident findings, 19 of them on the initiative and the ADR; 5 of 6 artifacts ran to the cap.

## The proof's evidence, quoted

The maker's line — `decisions/pdr-2026-09-05-bet-typedef-rendering.md`, Document History v1:

> Made by the PO role for the authority's go of 2026-09-05 on init-typedef-rendering […] from the maker's text `basis/guidelines/product-decision-record.md` (v7; `generated: true`, produced by `basis/tools/compile_typedef.py` from `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`) […] Before any check ran, the author applied the checker's text `basis/fitness/product-decision-record.fitness.md` (produced from the same source, the same digest) to this draft, each scenario read as Given/When/Then: scenario 1 (one decision) pass […] scenario 5 (reversibility) pass.

The checker's lines — the same file, review rows v2, v3, v4:

> PO output check round 1 (judge: claude-fable-5-1 / screen prompt v6; criteria the rendered fitness set `basis/fitness/product-decision-record.fitness.md`, source-digest `sha256:d2e74320dabb`): one confident — §4's "the two sections" unnamed — and four wobbly […]

> PO output check round 2 (judge: claude-fable-5-1 / screen prompt v6; criteria the rendered fitness set at `sha256:d2e74320dabb`): no confident finding; three wobbly […]

> Round 3, the cap (judge: claude-fable-5-1 / screen prompt v6; criteria the rendered fitness set at sha256:d2e74320dabb): two wobbly, none confident […]

The pass — the same file, state row v4:

> `draft` → `checked`: the PM role's pass. No confident finding in any of three rounds; the criteria read by the judge were the fitness set produced from the typedef, the same source and digest the maker's text names — the proof feat-typedef-rendering's scenario 7 reads from.

The produced files' frontmatter, both: `generated: true`, `generated-by: basis/tools/compile_typedef.py`, `source: basis/artifacts/product-decision-record.md`, `source-digest: sha256:d2e74320dabb`, followed by the line "Generated from `basis/artifacts/product-decision-record.md` […] do not edit by hand — edit the typedef and re-render."

## The process run, and today's re-checks

The typedef-rendering process's first run (recorded in the initiative v12 and the feature v8; a clean run writes no entry into the process, as its `report` step runs only on escalations): `enumerate` admitted one qualifying typedef, product-decision-record; `check` produced no rows; `route` took the success exit — "check clean, nothing escalated — every qualifying typedef's two texts current".

Re-run by the lead-pm role's assisting agent before this delivery, from the repository root, 2026-09-05:

```
$ python3 basis/tools/compile_typedef.py basis/artifacts/product-decision-record.md --check
exit 0
$ <the process's enumerate test, over basis/artifacts/*.md>
qualifies basis/artifacts/product-decision-record.md        (1 of 22)
$ sha256sum basis/artifacts/product-decision-record.md | cut -c1-12
d2e74320dabb
$ ls .claude/skills | wc -l
22                                                          (typedef-rendering among them)
$ python3 basis/tools/lint_basis.py
PASS: 0 violation(s)
```

## This run against the last, measured

| | Last run (init-request-routing, 2026-09-04) | This run (init-typedef-rendering, 2026-09-05) |
|---|---|---|
| Screen rounds / artifacts screened | 20 / 8 | 16 / 6 |
| Rounds per artifact | 2.5 | 2.7 |
| Artifacts run to the cap | 7 of 8 | 5 of 6 |
| Makers' self-check before the screen | none | 5 of 6 |
| Agent time | 136 min (66 first implementation, 70 review cycles), the authority's figure | not measured the same way; commits span 16:47 (the request recorded) to 19:19 (measure met), 152 min wall clock, containing the run review's recording and five other requests' intake; from the bet (18:22) to the measure met, 57 min |

Reading: the self-check cut confident findings — the PO's three artifacts stood 4 across 7 rounds, none on the order — but wobbly findings drove the rounds, as the run review had found. The authority's single-review-cycle ruling arrived during the last screen (the process's round 3) and changed no figure here; it is in the lane as `req-2026-09-05-single-review-cycle`, defined, the architect's make step next.

## Rulings the lead-pm role made in the authority's absence, all recorded

- **Framing restatement** (initiative v7): proposed by the lead-pm on the framer's-wording ruling; the authority accepted it ("Go with your version"); the original words moved to history.
- **Initiative repairs and holds** (v4, v5, v8): mechanism words removed from the framing sections; the batch made a second bet; the form-only run counted in the measure; at the cap, two wobbly held for the authority — the first no-go naming the checking processes (the initiative fitness set's scenario 4 gap, filed 2026-09-04) and "the fitness set's scenarios" as the gloss a prior round had asked for. The bet was the authority's, in person ("Bet"), with both before it.
- **ADR checked** (v4): `right: escalation` accepted for a decision no architect right covers; the production-compiler premise dropped as uncitable; the compilers stated as interim tooling; the cap's six wording findings repaired past it and disclosed.
- **Backlog order pass** (v2): no confident finding round 1; three glosses made at the record step, disclosed.
- **Feature pass at the cap** (v6): the two batch-case scenarios moved to the second bet's feature; "current with" defined once; the architect's passages edited with substance kept (C2 requires the text, not only the digest, to match; the operational-contract clause dropped from C6); the proof scenario's Given holds the record it screens.
- **PDR pass at the cap** (v4): the screen for form only, the decider being the authority; the cap's two wobbly glossed and repriced at the record step.
- **Process approval at the cap** (v4): the guiding statement narrowed to what the check reports; `check` writes its own `will-not-compile` row on an empty `defines`; the absent carrier deferred to skill-rendering's check, as for the siblings; the cap's one confident finding repaired in the one revise the single-cycle ruling allows.
- **Typedef amendments and the compiler**: made by the architect role under the feature's assignment, on the authority's standing direction; each history row names the initiative, the feature, and the ADR. Ask 1 of the brief.
- **Single-review-cycle**: the authority's words recorded as a request and routed to the lane; applied as practice to every screen in flight — decide after the current round and one revise.
- **Maker self-check as practice**: applied before the principle change the request `maker-self-check` asks for, awaiting the authority's answer.

## The six requests awaiting the authority's answer

| Request | Route said | Reason in one line | State |
|---|---|---|---|
| `req-2026-09-05-step-communication` | discovery | a design decision across every process: what an agent's instruction is assembled from and in what form | routed, awaiting |
| `req-2026-09-05-feasibility-defined` | discovery | what a feasibility verdict is changes the initiative typedef and the initiative check; adds a data type | routed, awaiting |
| `req-2026-09-05-no-tools-mid-process` | small-change | one rule in the process-definition typedef, lint-checked | routed, awaiting |
| `req-2026-09-05-banned-words-inlined` | small-change | the compiler already inlines the guiding statement; the banned list is the same mechanism | routed, awaiting |
| `req-2026-09-05-maker-self-check` | small-change | one sentence in the define-good-up-front principle, through principle-set-authoring | routed, awaiting |
| `req-2026-09-05-single-review-cycle` | small-change | one change to each of five screening processes' round cap | accepted; defined (v3); `lead-6nc6r` |

Also parked: the discovery on `req-2026-09-04-operational-contract` (`lead-bmmzh`), held on inactivity.

## The ADR's four open questions (its Document History v4)

1. The form of the two typedef sections, how an overlapping rule and scenario fold, and what a typedef with no guideline or fitness set today (12 of 22) renders.
2. Whether the typedef's derived review checklist — a third statement of the rules inside the one source — becomes a compiled section written back into the typedef.
3. Whether the three rendering processes (skill, role, typedef) generalize into one (open since role-rendering; work item `lead-sx9xj`).
4. A source for the 7 guidelines and 1 fitness set with no artifact type behind them.

Follow-on from the build, not in the ADR: the produced guideline and fitness set carry the typedef's `version` and dates in their frontmatter without saying they are the typedef's.

## The brief's cold reads

Recorded at the deliver step, one row per round, in the brief's Document History.
