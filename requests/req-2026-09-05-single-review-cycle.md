---
type: request
id: req-2026-09-05-single-review-cycle
status: routed
version: 3
date: 2026-09-05
reader: lead-pm
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: "one change to each screening process's round cap — author, review, revise, continue — within the lead shop's own definitions, demonstrable on the next screen, no appetite worth a bet"
routed-to: ""
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

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded by the lead-pm at the request-intake process's record step, the words read as an ask and the authority's "I want" the confirmation; routed small-change at decide-route, said, awaiting the originator's answer; applied as practice to the screens in flight on the authority's words. |
| 2 | 2026-09-05 | update | The route accepted by the originator; landed at the intake's land step; work item lead-6nc6r opened; dispatched to the small-change lane. |
| 3 | 2026-09-05 | update | Definition written by the lead-po role at the small-change process's define step: judged a simple change by the glossary's entry; seven acceptance statements; paths — the five screening process definitions, their five skill renderings with source and tool, the rendering tool read only; maker lead-solutions-architect; verifying observation as one command from the repository root. |
