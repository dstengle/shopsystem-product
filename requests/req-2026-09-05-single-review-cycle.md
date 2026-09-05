---
type: request
id: req-2026-09-05-single-review-cycle
status: done
version: 6
date: 2026-09-05
reader: lead-pm
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: "one change to each screening process's round cap — author, review, revise, continue — within the lead shop's own definitions, demonstrable on the next screen, no appetite worth a bet"
routed-to: requests/req-2026-09-05-single-review-cycle.md#result
work-item: lead-6nc6r
---

# Request: every process limited to a single review cycle

## 1. What is requested

The product authority, 2026-09-05, in open conversation with the
lead-pm during the init-typedef-rendering build: "I want all of the
processes limited to a single review cycle, so author -> review ->
revise -> continue to next step. We're spending huge amounts of time
on all of these screening rounds."

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose directly, in conversation.

## 3. Route

Route said by the lead-pm role, 2026-09-05: **the small-change lane**.
What it means: the lead-po role defines the change up front, the
architect makes it through each definition's own rules, the lead-pm
checks it, and the runtime verifies it — no bet, no check of record.
Why: one change to each screening process's round cap (initiative-
check, po-output-check, adr-authoring, principle-set-authoring,
stakeholder-presentation; the rendering processes' reconcile caps are
not review cycles and stay) so that a screen runs once, the maker
revises once, and the decide step follows — within the lead shop's own
definitions, demonstrable on the next screen, spending no appetite
worth a bet. Topic: "every process limited to a single review cycle
(req-2026-09-05-single-review-cycle)".

Originator's answer: **accepted** — "Proceed with the review cycle
definition change only", 2026-09-05. Landed by the lead-pm; work item
lead-6nc6r opened for the lane; it points here and carries nothing of
what was asked. Applied as practice before the definitions changed:
every screen in flight decides after its current round and one
revise.

## 4. Result

### Definition

req-2026-09-05-single-review-cycle — defined by the lead-po role,
2026-09-05, at the small-change process's define step.

**Simplicity.** Judged against the glossary's entry for simple
change: the change stays within the lead shop's own definitions —
five process definitions and their five renderings — touches no
Bounded Context, and its effect is demonstrable in the running
system from the repository root in one session. It is a simple
change; the lane proceeds.

**Scope.** The five screening processes — initiative-check,
po-output-check, adr-authoring, principle-set-authoring,
stakeholder-presentation — each run one review cycle: author, review,
revise, continue. The rendering processes' reconcile loops
(skill-rendering, role-rendering, typedef-rendering) and the repair
loops of request-intake (its objection loop) and small-change are not
review cycles and are not touched.

**Acceptance statements.** Each is decided against the changed
artifacts.

1. Given any of the five screening process definitions, when its
   screen step (the presentation's cold read) returns findings, then
   the maker's step revises once and the flow continues to the
   process's deciding step — decide, or deliver for
   stakeholder-presentation — with no second run of the screen step
   on the path between them.
2. Given any of the five definitions, when the deciding step runs,
   then its inputs are the one review's findings and the revised
   artifact — the deciding step reads no other round.
3. Given any of the five definitions, when its screen loop is read
   in full — steps, branches, inputs, outputs — then no round
   counter, no round cap, and no advance-round step remain in it;
   outside the Document History the text `round_cap` and the text
   `advance-round` (or `advance_round`) do not occur in the
   definition.
4. Given any of the five definitions, when it is read against its
   rendered skill at `.claude/skills/<name>/SKILL.md`, then the
   definition's flow diagram is the diagram the rendering tool
   regenerates from its steps, and the skill equals a fresh render
   of the definition by that tool — the rendering is never edited by
   hand.
5. Given any of the five definitions, when its Document History is
   read, then its last row cites `req-2026-09-05-single-review-cycle`
   and its `version` is one higher than the version that stood
   before the change.
6. Given the definitions of skill-rendering, role-rendering,
   typedef-rendering, request-intake, and small-change, when they are
   read after the change, then they are unchanged — their reconcile
   and repair loops stand as they were.
7. Given the repository after the change, when the basis lint and the
   verifying observation below run, then both exit 0.

**Artifacts touched (paths).** The maker reads these and changes
nothing else.

Definitions (sources):
- basis/processes/initiative-check.md
- basis/processes/po-output-check.md
- basis/processes/adr-authoring.md
- basis/processes/principle-set-authoring.md
- basis/processes/stakeholder-presentation.md

Renderings — each re-rendered from its source by the rendering tool,
never edited by hand:
- .claude/skills/initiative-check/SKILL.md (source
  basis/processes/initiative-check.md; tool
  basis/tools/compile_process.py)
- .claude/skills/po-output-check/SKILL.md (source
  basis/processes/po-output-check.md; tool
  basis/tools/compile_process.py)
- .claude/skills/adr-authoring/SKILL.md (source
  basis/processes/adr-authoring.md; tool
  basis/tools/compile_process.py)
- .claude/skills/principle-set-authoring/SKILL.md (source
  basis/processes/principle-set-authoring.md; tool
  basis/tools/compile_process.py)
- .claude/skills/stakeholder-presentation/SKILL.md (source
  basis/processes/stakeholder-presentation.md; tool
  basis/tools/compile_process.py)

Rendering tool (read, not changed): basis/tools/compile_process.py.

**Maker role.** lead-solutions-architect — the role the make step runs
by.

**Verifying observation.** One command, run from the repository root;
exit 0 shows the effect, its output is the evidence. It runs the
basis lint; for each of the five definitions confirms that outside
the Document History neither `round_cap` nor an advance-round step
occurs, that the definition's diagram is the one the tool regenerates,
and that the skill at the load point equals a fresh render.

```
( python3 basis/tools/lint_basis.py && s=$(mktemp -d) && mkdir -p "$s/defs" && ln -s "$PWD/basis/types" "$s/types" && ln -s "$PWD/basis/artifacts" "$s/artifacts" && for n in initiative-check po-output-check adr-authoring principle-set-authoring stakeholder-presentation; do d="basis/processes/$n.md"; c=$(sed '/^## Document History/,$d' "$d" | grep -c -E 'round[-_]cap|advance[-_]round'); [ "$c" -eq 0 ] || { echo "$n: $c round-cap/advance-round occurrence(s)"; exit 1; }; cp "$d" "$s/defs/$n.md" && python3 basis/tools/compile_process.py "$s/defs/$n.md" --skill "$s/$n/SKILL.md" >/dev/null && diff -q "$s/defs/$n.md" "$d" && diff -q "$s/$n/SKILL.md" ".claude/skills/$n/SKILL.md" && echo "$n: no round cap, diagram current, skill equals fresh render" || exit 1; done )
```

### Change made

**Round 1.** Maker: the lead-solutions-architect role, 2026-09-05, at
the small-change process's make step. Paths changed, with the version
each stood at before and after:

| Path | Before | After |
|---|---|---|
| basis/processes/initiative-check.md | 6 | 7 |
| basis/processes/po-output-check.md | 7 | 8 |
| basis/processes/adr-authoring.md | 1 | 2 |
| basis/processes/principle-set-authoring.md | 7 | 8 |
| basis/processes/stakeholder-presentation.md | 5 | 6 |
| .claude/skills/initiative-check/SKILL.md | rendering of v6 | rendering of v7 |
| .claude/skills/po-output-check/SKILL.md | rendering of v7 | rendering of v8 |
| .claude/skills/adr-authoring/SKILL.md | rendering of v1 | rendering of v2 |
| .claude/skills/principle-set-authoring/SKILL.md | rendering of v7 | rendering of v8 |
| .claude/skills/stakeholder-presentation/SKILL.md | rendering of v5 | rendering of v6 |

In each definition: the screen (cold-read) step stays; `revise`'s
`next` is now the deciding step (`decide`; `authority-approve` for
principle-set-authoring; `deliver` for stakeholder-presentation); the
advance-round step, the `round` and `round_cap` data, and the route
step's failsafe branch are removed; the route step keeps its success
exit, its all-uncovered exit where one existed, and else → revise.
`round_log` stays as a one-element list, so each record step's "one
review entry per round" holds for the one round. Purpose, Outcomes,
Roles, Data, and Derived checks reworded to the single cycle where
they named rounds, caps, or the loop; each definition carries one
Document History row citing this request and the authority's words of
2026-09-05. The Flow diagrams were regenerated and the five skills
re-rendered by basis/tools/compile_process.py; the tool is unchanged.

Two choices the checker should judge against the definition:

- Acceptance statement 2 makes the deciding step's inputs the one
  review and the revised artifact. In po-output-check and adr-authoring
  the artifact had been excluded from `decide`'s inputs by design
  (their former O2/O3 and derived checks). With no second screen, the
  PM role cannot otherwise see whether the one revision repaired what
  the findings quote, so `artifact` was added to `decide`'s inputs in
  both, and those outcomes and derived-check rows reworded to match.
  The other three deciding steps already read their artifact.
- principle-set-authoring had a second loop: the owner's "findings"
  verdict returned the draft to `revise` under a cap of 6. Without the
  round counter that loop would have no exit, so `route-approval`'s
  else now parks the draft with the owner's findings filed (the
  existing `park` step, its title no longer counting rounds); the
  owner's prompt says so. The Sources paragraph's "dual-exit route
  loop" phrase was reworded to the one-revision shape so it stays
  true.

Verifying observation run from the repository root after the change:
exit 0 — lint PASS, and for each of the five, "no round cap, diagram
current, skill equals fresh render".

### Check

**Round 1** — verdict: **pass** — by the lead-pm role, 2026-09-05, at
the small-change process's check step; the maker was the
lead-solutions-architect role. Each statement decided against the
changed definitions: every screening process's revise step continues
to its deciding step, no advance-round step, round counter, or cap
remains in the screen loop, the deciding step reads the one review and
the revised artifact, the diagrams are regenerated and the skills equal
a fresh render, each definition carries its history row citing this
request with its version bumped, the rendering and repair loops of the
other processes are untouched. The maker's two disclosed judgment
calls — the artifact added to the deciding step's inputs in two
processes, and the principle set's owner loop routed to its park step
— are within the definition. Every path in Change made is in the
Definition's list. Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-05; its evidence:

```
PASS: 0 violation(s)
initiative-check: no round cap, diagram current, skill equals fresh render
po-output-check: no round cap, diagram current, skill equals fresh render
adr-authoring: no round cap, diagram current, skill equals fresh render
principle-set-authoring: no round cap, diagram current, skill equals fresh render
stakeholder-presentation: no round cap, diagram current, skill equals fresh render
exit 0
```

Recorded by the lead-pm role, 2026-09-05. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the
request and this result no bet was taken and no check of record was
run. The effect in the running system: the harness lists the five
re-rendered skills, and every screen from now on runs once, the maker
revises once, and the deciding step follows.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded by the lead-pm at the request-intake process's record step, the words read as an ask and the authority's "I want" the confirmation; routed small-change at decide-route, said, awaiting the originator's answer; applied as practice to the screens in flight on the authority's words. |
| 2 | 2026-09-05 | update | The route accepted by the originator; landed at the intake's land step; work item lead-6nc6r opened; dispatched to the small-change lane. |
| 3 | 2026-09-05 | update | Definition written by the lead-po role at the small-change process's define step: judged a simple change by the glossary's entry; seven acceptance statements; paths — the five screening process definitions, their five skill renderings with source and tool, the rendering tool read only; maker lead-solutions-architect; verifying observation as one command from the repository root. |
| 4 | 2026-09-05 | update | Change made by the lead-solutions-architect role at the small-change process's make step, round 1: the five screening process definitions amended to the single review cycle (versions 6→7, 7→8, 1→2, 7→8, 5→6) and their five skills re-rendered by the compiler; observation exit 0, lint PASS; two judgment calls disclosed for the check — the artifact added to decide's inputs in po-output-check and adr-authoring, and principle-set-authoring's owner-rejection loop now parks. |
| 5 | 2026-09-05 | update | Check passed (round 1) by the lead-pm role; the verifying observation run by the runtime, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 6 | 2026-09-05 | update | Where the route led written into routed-to — this request's own Result section — by the lead-pm at the request-intake process's land-result step; the lane's work item lead-6nc6r closed as done. |
