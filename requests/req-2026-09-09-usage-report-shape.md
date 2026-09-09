---
type: request
id: req-2026-09-09-usage-report-shape
status: done
version: 7
date: 2026-09-09
reader: lead-pm
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
originator: lead-pm
received-through: operational-contract
arose-in: init-run-measurement
route: small-change
route-reason: "the shop's own definitions and tool, no Bounded Context; the lane's definition settles four things: the usage report as a data type — the fields the harness gives, and to whom (one tokens figure with tool uses and duration per agent, to the starter; nothing per turn to the router); the exact comment forms the router writes on the bead for a step and for usage, in the router definition, and the form of a starter's report of what the harness gave it; the tool as a reader of those two definitions and nothing else; and a verifying observation that is a row with a figure on it, produced from a real anchor of this repository, not a check passing"
routed-to: "requests/req-2026-09-09-usage-report-shape.md#result"
work-item: lead-ctl8c
---

# Request: the cost rows read what the harness now reports

## 1. What is requested

Found on the first cost reading after the run-efficiency work
(2026-09-09, anchors lead-lv37s, lead-ipi60, lead-jsqmr, lead-r86dp):
`write_cost_rows.py` reads a `context` comment carrying an
input/cache-creation/cache-read/output quad; the router (v10) writes a
`usage` comment, and the harness now reports to the starter one
figure per agent step — `subagent_tokens`, with `tool_uses` and
`duration_ms` — and reports nothing per turn to the router itself,
which once wrote the remaining budget as if it were consumption
(lead-lv37s) and otherwise leaves the field blank. So the rows carry
no token figure for any step, and the initiative rollup sums blanks.
The figures the harness does report reach only the starter, who
records them on the anchor by hand.

The product authority, 2026-09-09, on why the information was lost:
"The detail of execution cost changed between tool implementations,
so there was not a good contract in place." The feature contract
(feat-run-measurement) names "the harness's usage report" and defines
it nowhere; the form lived only in the tool's parser, copied from one
haiku run (lead-5wzgl); the router-usage change (v10) named no form
and was verified as a rendering check, not a row; the harness's
report changed shape between 2026-09-08 and 09-09 with no description
beside it. Today's anchors carry what stands to be read: the router's
`step: <id>` and `usage | context tokens: | output tokens: | model:`
comments, and the starter's `report` comments naming
subagent_tokens, tool_uses, and duration_ms per step, as received
(lead-lv37s, lead-r86dp, lead-ipi60, lead-o0bkh, lead-6p8xu,
lead-lgkmh, lead-jynwa).
Run on lead-lv37s, the tool also writes no step row at all: it reads
a step event as `step <id>` and the router writes `step: <id>`, so
the rows table came out empty (sessions/sess-2026-09-09-a-cost.md).

## 2. From whom

Reader: the lead-pm role. Originator: the lead-pm role, as the starter
of the four executions. Received through the lead shop's operational
contract (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-09: **the small-change lane**.
Why: the tool, the router definition, and the run-cost typedef are the
lead shop's own. The definition settles the four things the
route-reason names — the usage report as a data type, the router's
comment forms and the starter's report form, the tool as their
reader, and a row with a figure from a real anchor as the proof — so
that the next change to any one of them has a contract to be checked
against; no figure is computed by a model. Accepted by the
product authority, 2026-09-09, with the words above; run now.

Originator's answer: **accepted** — the lead-pm role, 2026-09-09.
The register item the lane runs on is lead-ctl8c; it points at this
request and carries nothing of what was asked.

## 4. Result

### Definition

req-2026-09-09-usage-report-shape: when done, the cost-row tool reads
the anchor comment forms the router and the starter actually write
today — not the retired context-comment quad — and a session close on
a real anchor produces a populated row for each agent step, its
tokens, tool-uses, and duration read from the harness's own report to
the starter, never estimated; a router turn, for which the harness
reports no per-turn usage to the router itself, carries a blank
tokens field, never a computed or remembered value.

- Given an anchor whose comments record an agent or human step in the
  router's own written form, when write_cost_rows.py reads that
  anchor, then a cost row is opened for every such step — none
  silently dropped for not matching the tool's step pattern.
- Given an agent step for which the starter recorded, on the anchor,
  the harness's own report of that step's tokens, tool uses, and
  duration, in the form the router's definition names for it, when
  the cost row for that step is written, then the row carries that
  tokens figure, that tool-uses figure, and that duration, each read
  from the report and none of them estimated or computed by a model.
- Given a router's own top-level turn, for which the harness reports
  no usage figure to the router, when the cost row for that turn is
  written, then its tokens field is blank — never the router's own
  remaining budget or any other value the harness did not report for
  that turn.
- Given the run-cost typedef's Required sections, when a row is
  written, then its fields match exactly what the router's comment
  forms and the starter's report make available for that step — no
  field invented, no field silently dropped.
- Given the real, already-closed anchor lead-lv37s (the
  feature-authoring execution of feat-plain-voice-sections,
  sessions/sess-2026-09-09-a.md), when `write_cost_rows.py
  sess-2026-09-09-a --anchor lead-lv37s` is run, then the cost row
  for step `draft` carries a non-blank tokens figure — the row the
  first reading of this anchor could not produce
  (sessions/sess-2026-09-09-a-cost.md's Rows table, empty).

Artifacts touched, by path: basis/roles/router.md (the exact comment
forms the router writes for a step and for usage; the usage report's
shape as a data type — what reaches the router itself, and what
reaches the starter, one tokens figure with tool uses and duration
per agent step; and the form in which the starter records that
report on the anchor); its rendering .claude/agents/router.md,
source basis/roles/router.md, rendering tool
basis/tools/compile_role.py; basis/artifacts/run-cost.md (the row's
Required sections, brought to name only the fields the router's
comment forms and the starter's report actually make available);
basis/tools/write_cost_rows.py (the reader of the two definitions
above — parses the router's actual step and usage comment forms and
the starter's report form, and writes rows matching the run-cost
typedef's fields, nothing estimated); its rendering
.claude/skills/write-cost-rows/SKILL.md, source
basis/tools/write_cost_rows.py, rendering tool
basis/tools/compile_tool.py.

Maker role: lead-solutions-architect.

Verifying observation: `python3 basis/tools/write_cost_rows.py
sess-2026-09-09-a --anchor lead-lv37s && grep -E '^\| draft \|.*[0-9]'
sessions/sess-2026-09-09-a-cost.md`, exit 0.

Defined by the lead-po role at the define step, against the
glossary's simple-change entry and the request's Route: the change
stays within the lead shop's own definitions — the router role, the
run-cost typedef, and the tool that reads them, each with its
rendering re-produced, never hand-edited — touches no Bounded
Context, and its effect is demonstrable in one session by a populated
row read from a real anchor; simple.

### Change made

Round 1. Maker: lead-solutions-architect.

- `basis/roles/router.md` — v10 → v11: the `usage` comment's exact
  form fixed to `usage: tokens=<value>; model=<model>` with `tokens`
  always blank (the harness reports no per-turn usage to the router
  itself — no more the remaining budget lead-lv37s carried); the
  `step` comment's exact form named; the harness's usage report
  defined as a data type — nothing per turn to the router, one
  `subagent_tokens`/`tool_uses`/`duration_ms` figure per agent step
  and for the router's own whole execution, to the starter — and the
  starter's `report` comment form named; the Interfaces entry for the
  starter pointed at it.
- `.claude/agents/router.md` — re-rendered from `basis/roles/router.md`
  v11 by `basis/tools/compile_role.py`, never hand-edited;
  source-digest sha256:c7d991fc0953 → sha256:97ee6fcd765f.
- `basis/artifacts/run-cost.md` — v4 → v5: the Identity bullet and
  Required sections item 1 brought to name only the fields the
  router's `usage` comment and the starter's `report` comment actually
  make available — `tokens` and `tool uses` replacing the retired
  input/cache-creation/cache-read/output quad, `duration` added for
  `duration_ms` where the harness gives one, "and one per router turn"
  added so the router's own blank-tokens rows are named; the Derived
  review checklist's field list updated to match; the blank-field rule
  unchanged.
- `basis/tools/write_cost_rows.py` — unversioned tool script, edited
  directly (it carries no Document History of its own): `STEP_RE`
  fixed to match the router's actual `step: <id>` form (the retired
  `step <id>` form matched nothing, so the rows table came out empty
  on lead-lv37s); the retired `QUAD_RE`/`context`-comment reading
  dropped; a `usage` comment now opens a blank-tokens router-turn row;
  a `report` comment's lines (`<label>: subagent_tokens <n>, tool_uses
  <n>[, duration_ms <n>]`) fill the matching step's row or, for
  `router (whole execution)`, open a new one — every figure read from
  the report, none estimated or computed; the docstring, `DESCRIPTION`
  dict, and the Rows table's header and writer brought to the same
  fields.
- `.claude/skills/write-cost-rows/SKILL.md` — re-rendered from
  `basis/tools/write_cost_rows.py` by `basis/tools/compile_tool.py`,
  never hand-edited; source-digest sha256:d32b2af40cc8 →
  sha256:08adf3c8b85b.

Verifying observation run: `python3 basis/tools/write_cost_rows.py
sess-2026-09-09-a --anchor lead-lv37s && grep -E '^\| draft \|.*[0-9]'
sessions/sess-2026-09-09-a-cost.md` — exit 0; the `draft` row reads
`| draft | lead-po | 0.3 | 62398 | 19 |  |`, its tokens and tool-uses
figures read from the starter's `report` comment on lead-lv37s, none
estimated. The full table also shows the fix's other two edges on the
same anchor: a `router turn` row for each `usage` comment, tokens
blank throughout (the anchor's remaining-budget figures never read as
consumption), and a `router (whole execution)` row carrying the
report's totals (tokens 42107, tool uses 34, duration 554493).

Round 2. Maker: lead-solutions-architect. Repair of the round-1
check's finding: the Definition names one tokens figure with tool
uses and duration per agent step to the starter, and no figure for
the router's own whole execution; the run-cost typedef v5 (unchanged
this round) names a row as one per step and one per router turn, no
other kind — so the clause `basis/roles/router.md` v11 added, and the
row `basis/tools/write_cost_rows.py` opened from it, are dropped
rather than the typedef widened to cover them.

- `basis/roles/router.md` — v11 → v12: the "plus the same three for
  the router's own whole execution, labeled `router (whole
  execution)`" clause removed from the harness's-usage-report data
  type; the `report` comment form now one line per step only, with a
  sentence that a total the harness gives the starter for something
  other than a step is not part of this form; a Document History row
  added citing this request and round.
- `.claude/agents/router.md` — re-rendered from `basis/roles/router.md`
  v12 by `basis/tools/compile_role.py`, never hand-edited;
  source-digest sha256:97ee6fcd765f → sha256:5df79b349662;
  `compile_role.py --check` reads `ok router`.
- `basis/tools/write_cost_rows.py` — unversioned tool script, edited
  directly: the docstring's and `DESCRIPTION`'s "(or the router's own
  whole execution)" phrasing dropped; the `report`-comment loop's
  `else` branch, which opened a new row for any label not already
  matching a step's row, replaced with `continue` — a label naming no
  step the anchor recorded (the `router (whole execution)` line the
  real anchor's `report` comment carries) is read and not written, so
  it opens no row the run-cost typedef does not name; the dead
  `role = "router" if label.startswith("router") else label` line
  removed with it.
- `.claude/skills/write-cost-rows/SKILL.md` — re-rendered from
  `basis/tools/write_cost_rows.py` by `basis/tools/compile_tool.py`,
  never hand-edited; source-digest sha256:08adf3c8b85b →
  sha256:effe9dbf9c42.

Verifying observation run: `python3 basis/tools/write_cost_rows.py
sess-2026-09-09-a --anchor lead-lv37s && grep -E '^\| draft \|.*[0-9]'
sessions/sess-2026-09-09-a-cost.md` — exit 0; the `draft` row reads
`| draft | lead-po | 0.3 | 62398 | 19 |  |`, unchanged from round 1.
The full table now carries only the two row kinds the Definition and
the run-cost typedef name — four agent-step rows, each with a
non-blank tokens and tool-uses figure, and five `router turn` rows,
tokens blank throughout; no `router (whole execution)` row.

### Check

Round 1. Verdict: **fail**. Checker: lead-pm.

Finding — the producing rule "nothing made that the definition does not
cover" fails. The Definition names the harness's report to the starter
as "one tokens figure with tool uses and duration per agent step" and
names no figure for the router's own whole execution; the run-cost
typedef v5, changed in this round, names a row as "one table row per
step the anchor records, and one per router turn" and no other kind.
Yet `basis/roles/router.md` v11 adds to the data type "the same three
for the router's own whole execution, labeled `router (whole
execution)`", and `basis/tools/write_cost_rows.py` opens a row for it
— the verifying observation's instance carries `| router (whole
execution) | router | 11.5 | 42107 | 34 | 554493 |`, a row the typedef
it is an instance of does not name. Two changed definitions and the
tool disagree on what a row is, the gap this request exists to close.

What holds, so round 2 is narrow: statements 1–3 and 5 pass on
lead-lv37s (`| draft | lead-po | 0.3 | 62398 | 19 |  |`, exit 0; four
agent-step rows opened; every `router turn` row's tokens blank);
statement 4 passes for the row fields; `basis/roles/router.md` v10 →
v11 and `basis/artifacts/run-cost.md` v4 → v5 each carry a history row
citing this request; `.claude/agents/router.md` checks `ok` through
`compile_role.py --check`; `.claude/skills/write-cost-rows/SKILL.md`
is byte-equal to a fresh `compile_tool.py` render (digest
08adf3c8b85b); every path in `changed` is in the Definition's paths.

Round 2. Verdict: **pass**. Checker: lead-pm. Finding: none.

The round-1 finding is closed: `basis/roles/router.md` v12's data type
names one figure per agent step to the starter and states that a total
for anything other than a step is not part of the `report` form; the
run-cost typedef v5 stands unchanged, one row per step and one per
router turn; `basis/tools/write_cost_rows.py` reads the anchor's
`router (whole execution)` line and writes no row for it. The three
definitions and the tool now agree on what a row is.

Statements re-checked fresh on lead-lv37s, the verifying observation
run by the checker (exit 0): 1 — all four steps in the router's
`step: <id>` form open rows (draft, add-usability, add-constraints,
self-check), none dropped; 2 — each carries the tokens and tool-uses
figures the starter's `report` comment gives it (62398/19, 25332/4,
35996/11, 69065/13), duration blank where the report gives none; 3 —
five `router turn` rows, tokens blank throughout, the anchor's
`~14975000 remaining` figures never read; 4 — the table's six fields
are exactly the typedef's Required sections 1, no other; 5 — `| draft
| lead-po | 0.3 | 62398 | 19 |  |`. Producing rules: router v10 → v12
with history rows 11 and 12 citing this request, rendering
byte-equal to a fresh `compile_role.py` render (`ok router`, digest
5df79b349662); run-cost v4 → v5 with its history row citing this
request; the skill byte-equal to a fresh `compile_tool.py` render
(digest effe9dbf9c42); the tool script unversioned, as the Definition
lists it; every path in `changed` is in `paths`; the cost file's
rewrite is the Definition's own verifying observation. The six `stale`
rows `compile_role.py --check` printed beside `ok router` are the
tool's answer for renderings whose source was not among the one
definition the check was given, not a finding about those roles; none
is in `paths`, none is modified in the working tree.

### Verified result

Verifying observation, as the Definition named it: `python3
basis/tools/write_cost_rows.py sess-2026-09-09-a --anchor lead-lv37s
&& grep -E '^\| draft \|.*[0-9]' sessions/sess-2026-09-09-a-cost.md`.

Evidence — the output lines and the closing exit:

```
sessions/sess-2026-09-09-a-cost.md
| draft | lead-po | 0.3 | 62398 | 19 |  |
exit 0
```

The `draft` row of the real, already-closed anchor lead-lv37s carries
a non-blank tokens figure (62398) and tool-uses figure (19), each read
from the starter's `report` comment on the anchor, none estimated —
the row the first reading of this anchor could not produce. The effect
is shown in the running system, on the repository's own anchor, not by
a check passing.

Date: 2026-09-09. Role: lead-pm.

The Definition, the Check's verdict by the lead-pm role (round 1 fail,
round 2 pass, finding none), and this result stand. Between the
request and this result no bet was taken and no check of record was
run.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the request-intake process's record step from the starter's reading of the four anchors; routed to the lane, accepted, not started. |
| 2 | 2026-09-09 | update | Second finding added: the tool's step-line form differs from the router's, so the rows table is empty on a real anchor. |
| 3 | 2026-09-09 | update | The authority's words recorded; the route-reason widened to the four things the lane's definition settles and to a row with a figure as the proof; accepted, run now. |
| 4 | 2026-09-09 | update | Originator's answer recorded at the request-intake process's record-answer step: accepted; work item lead-ctl8c opened for the small-change lane and written in `work-item`. |
| 5 | 2026-09-09 | update | Defined by the lead-po role at the define step: judged simple against the glossary's simple-change entry; Definition added to the Result section, naming five acceptance statements, the seven artifacts touched (the router role and its rendering with its rendering tool, the run-cost typedef, the cost-row tool and its skill rendering with its rendering tool), the maker role, and the verifying observation — a populated row read from the real anchor lead-lv37s. |
| 6 | 2026-09-09 | update | Verified result recorded by the lead-pm role at the small-change process's record step: the Definition's verifying observation run on lead-lv37s, the `draft` row populated from the starter's report (tokens 62398, tool uses 19), exit 0; status set to done; no bet taken and no check of record run between the request and this result. |
| 7 | 2026-09-09 | update | Where the route led recorded by the lead-pm role at the request-intake process's land-result step: `routed-to` written from the lane's returned `change` — this request's own Result section by fragment, where the Definition, the Check (round 1 fail, round 2 pass), and the verified result stand. Nothing the lane wrote is written twice; status done stands as the lane left it. |
