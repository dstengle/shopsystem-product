---
type: annex
id: annex-035
brief: brief-035.md
date: 2026-09-04
---

# Annex 035: the request-routing run, in full (optional)

## Artifacts produced or changed this session

- `initiatives/init-request-routing.md` — proposed → planned → active; v5 carries the measure met (0 → 1).
- `decisions/pdr-2026-09-04-bet-request-routing.md` — the bet's record, made by the PO role; checked (3 rounds, cap, no confident finding).
- `decisions/adr-2026-09-04-request-front-end.md` — the design decision: intent reaching the lead shop is recorded as a request on arrival and routed from that record; checked (3 rounds; `intent-provenance` named as not fully satisfied, `lead-4kymc` the pointer; three candidates split out: the register's role, the lane's form, the hinge).
- `backlog/order-2026-09-04.md` — supersedes order-2026-09-03; init-request-routing placed first; checked clean round 1.
- `roadmap.md` v3, v4 — init-request-routing first, then its measure met.
- `features/feat-request-routing.md` — sixteen scenarios; designer criteria U1–U7, A1–A6; architect constraints C1–C10; checked (3 rounds, cap, post-cap repairs disclosed); assigned to shopsystem-product with a disclosed no-send; v8 carries the running-system witness.
- `basis/artifacts/request.md` v3 — the received-ask path: status and route vocabularies, `routed-to`, sections Route and Result.
- `basis/glossary.md` v21 — ask (received sense), request, simple change, small-change lane, intake.
- `basis/processes/discovery-conversation.md` v11 — the hinge: parameter `request`; `frame` writes the initiative's request link and the request's result.
- `basis/artifacts/initiative.md` v10 — optional `request` link; the originator chain begins at it.
- `basis/artifacts/feature.md` v12 — `size` (`standard` | `small`); a small feature framed by its request.
- `basis/artifacts/decision-brief.md` v4 — `relates-to` (made under the example request).
- `basis/tools/lint_basis.py` — check 9 (requests), check 10 (briefs) with `--brief <path>`; check 9's fragment repair.
- `basis/README.md` v7, v8, v9 — §Checks names checks 9 and 10; v9 records the fragment repair.
- `basis/processes/request-intake.md` — approved v4 after three screen rounds; the door.
- `basis/processes/small-change.md` — approved v4 after three screen rounds; the lane.
- `.claude/skills/request-intake/SKILL.md`, `.claude/skills/small-change/SKILL.md` — rendered by skill-rendering; `.claude/skills/discovery-conversation/SKILL.md` re-rendered over the v11 divergence.
- `requests/req-2026-09-04-brief-relates-to.md` — the first request; status done, v6.
- `requests/req-2026-09-04-operational-contract.md` — the second request, recorded after delivery was composed; originator the lead-solutions-architect role (the ask arose inside the ADR's authoring run; the record's closing note was the confirmation); route discovery said by the lead-pm, the authority's answer awaited (brief Ask 5).
- `briefs/brief-034.md` v6 — gains `relates-to`; content unchanged.
- `sessions/sess-2026-09-04-b.md` (the discovery), `sessions/sess-2026-09-04-c.md` (this delivery).
- Work register: lead-1kp6m closed onto the discovery record; lead-16rrj (the lane's item) closed done; lead-4kymc annotated with the exception; filed: lead-1d0eo, lead-izfpk, lead-vx02q, lead-ghulb, lead-g5tu9, lead-2ivie (an objection by the authority as originator is a ruling, not an objection subject to the intake's cap).
- `basis/fitness/initiative.fitness.md` — gap review entry (scenario 4: a no-go naming a structure to exclude it).

## Screen rounds (judge claude-fable-5-1 throughout)

| Artifact | Criteria | Rounds | Outcome |
|---|---|---|---|
| Initiative | initiative fitness (screen prompt v5) | 3 | round 1: two confident (a no-go without its reason; a mechanism in the scope sentence) repaired; round 2: five wobbly repaired, one uncovered answered by the architect on ask; round 3, cap: three wobbly held for the bet; post-cap contract wording repair disclosed |
| PDR | product-decision-record fitness (v6) | 3 | wobbly only, each round's set different; pass at cap |
| ADR | adr fitness (v6) | 3 | round 1 five confident, round 2 six confident, both repaired; cap: one confident (bare identifier) and three wobbly repaired past the cap and disclosed; checked |
| Backlog order | backlog-order fitness (v6) | 1 | clean; pass |
| Feature | feature fitness (v6) | 3 | round 1 one confident (misquotation) repaired; round 2 one confident (a two-branch scenario split) repaired; cap: two confident wording findings repaired past it and disclosed; pass |
| request-intake | process-definition fitness (v6) | 3 | round 1 three confident repaired; round 2 one confident repaired; cap: three confident repaired past it and disclosed (witness lists; the objection-at-cap sentence; discovery on a named topic); approved |
| small-change | process-definition fitness (v6) | 3 | round 1 two confident repaired; round 2 one confident repaired; cap: six wobbly, none confident; five post-cap repairs disclosed; approved |

## The runs

Skill-rendering check, round 1: `diverged discovery-conversation-process` (v11, the hinge), `missing request-intake-process`, `missing small-change-process`. Reconciled by re-render; round 2: `approved-count 21` only. The compilers word-split under the session's shell; the check was re-run under bash.

Request-intake, first run, on the example ask: `record` → `decide-route` (small-change, reason and topic stated) → `observe` (answer: accepted, read from the standing direction) → `land` (work item lead-16rrj opened) → `open-lane` → `land-result` (`routed-to` written as the request's own Result section by fragment; lead-16rrj closed done).

Small-change, first run: `define` (lead-po: six acceptance statements, four paths, maker named, one verifying observation) → `make` (architect, round 1) → `check` (lead-pm: pass, round 1, no finding) → `verify` (runtime: the observation, exit 0) → `record` (done).

Lint check 9, the defect: the first `land-result` wrote `routed-to: requests/req-2026-09-04-brief-relates-to.md#result` and the tree lint reported it as a broken link, resolving the whole string as a path. Repaired by the architect in the same run to resolve the part before any `#` fragment, as check 4 does; README v9. Verified by the lead-pm before this delivery, from the repository root:

```
$ python3 basis/tools/lint_basis.py
PASS: 0 violation(s)
$ python3 basis/tools/lint_basis.py --brief briefs/brief-034.md
PASS: 0 violation(s)
```

Load point: `.claude/skills/` lists `request-intake` and `small-change` among 21 skills; the harness listed both in a session opened on this branch.

## The request's Result section, quoted

From `requests/req-2026-09-04-brief-relates-to.md` §4, "Verified result":

> The verifying observation the Definition named was run by the runtime from the repository root on 2026-09-04, at the small-change process's verify step; its evidence, the output lines and the closing exit:
>
> ```
> PASS: 0 violation(s)
> PASS: 0 violation(s)
> <scratch>/unknown-key.md: unknown front-matter key `bogus-key` — the field set is closed (decision-brief typedef §Required frontmatter)
> FAIL: 1 violation(s)
> <scratch>/dangling-link.md: `relates-to` path `no-such-dir/initiatives/init-roles-availability.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
> <scratch>/dangling-link.md: `relates-to` path `no-such-dir/features/feat-roles-availability.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
> <scratch>/dangling-link.md: `relates-to` path `no-such-dir/decisions/adr-2026-09-03-role-rendering.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
> <scratch>/dangling-link.md: `relates-to` path `no-such-dir/decisions/pdr-2026-09-03-bet-roles-availability.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
> FAIL: 4 violation(s)
> exit 0
> ```
>
> Recorded by the lead-pm role, 2026-09-04. The Definition, the Check's verdict by the lead-pm role, and this result stand; between the request and this result no bet was taken and no check of record was run. The effect in the running system: the lint that every session runs accepts a decision brief that says what it relates to and rejects one with an unknown key or a path that does not resolve.

## Rulings the lead-pm made in the authority's absence, all recorded

- **The bet** (initiative v3, PDR §1): taken at the cap on the standing direction; the contract clause repaired post-cap to the judge's wording; the no-go and route-destination findings held — a no-go must name what it excludes; the three destinations are the authority's own decision from the discovery. The no-go question filed in the initiative fitness set's history for the owner.
- **PDR pass at the cap** (v4): wobbly sets differed each round; the text of record named as the initiative at v2 after its disclosed repair.
- **ADR checked** (v4): `right: escalation` accepted for a decision no architect right covers; the decision sentence made to say the lane is a destination the decision establishes, its form a candidate; the `intent-provenance` exception's home is the ADR and the contract artifact, lead-4kymc a pointer.
- **Backlog order pass** (order-2026-09-04 v2): clean round 1.
- **Feature pass at the cap** (v6): the lead-pm's route is recorded as said and not acted on until the originator answers; the lane's definer is the lead-po role; other roles' passages trimmed with substance unchanged; the verification Whens held as satisfiable.
- **request-intake approval** (v4): recording is any lead-shop role's act and routing the lead-pm's; the lane's not-simple return re-enters `decide-route`; the routing-lane cycle capped at three rounds, the cap row routed to `observe` so the route is said before it is acted on; `land-result` writes `routed-to` from the lane's result; the absent carrier deferred to skill-rendering's check.
- **small-change approval** (v4): the lane closes its own work item (the v1 close-in-parent reversed); the maker fixed in `make`'s run-by so checker-never-maker is mechanical; the definition lives on the request's Result section, not a file of its own.
- **Definition amendments** (request typedef v3, glossary v21, discovery-conversation v11, initiative typedef v10, feature typedef v12, decision-brief typedef v4, lint, README): applied on the standing direction; each history row says the owner's approval is pending.
- **First intake run**: the standing direction read as the originator's yes at `confirm` and the accepted answer at `observe`, disclosed on the request (section 3, history v1–v2).
- **Check 9 repair**: accepted in the same run on the architect's repair and the README row; verified by the lead-pm before delivery (above).
