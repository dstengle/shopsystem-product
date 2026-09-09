---
type: request
id: req-2026-09-09-rollup-reads-typedef
status: done
version: 6
date: 2026-09-09
reader: lead-pm
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
originator: lead-pm
received-through: operational-contract
arose-in: req-2026-09-09-usage-report-shape
route: small-change
route-reason: "the rollup tool and the cost-row tool are the lead shop's own; the rollup reads the run-cost artifact's columns by the names the run-cost typedef (v5) gives them, not by position under the retired names, and the cost row's minutes is the span the run-measurement contract states — from the step's own start to its completion on the anchor; demonstrable on a real anchor in one session"
routed-to: "requests/req-2026-09-09-rollup-reads-typedef.md#result"
work-item: lead-d0er0
---

# Request: the rollup reads the run-cost typedef's columns

## 1. What is requested

Found at the verified result of req-2026-09-09-usage-report-shape,
2026-09-09, by the lead-pm running the rollup on init-plain-voice
over the first populated cost artifact (sessions/sess-2026-09-09-a-cost.md):
`rollup_cost.py` reads the Rows table by column position under the
retired names, so it reports the `Tokens` column as context_tokens,
the `Tool uses` column as output_tokens (47, the tool-use count), and
tool_uses blank. And `write_cost_rows.py` writes a step's minutes as
the span from the event before the step's launch to the launch, not
from the step's start to its completion: the draft step of
lead-lv37s, which ran 2.7 minutes by the anchor's own timestamps, has
0.3 on its row. The run-measurement contract states minutes as "the
wall-clock span between those two timestamps", the step's start and
end.

## 2. From whom

Reader: the lead-pm role. Originator: the lead-pm role, from the
first initiative-level reading after the usage-report-shape change.
Received through the lead shop's operational contract (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-09: **the small-change lane**.
Why: two readers of one definition brought to read it — the rollup by
the run-cost typedef's column names, the cost-row tool's minutes by
the step's own start and completion events as the router definition
names them — each with its skill re-produced; the proof a rollup line
for init-plain-voice whose tokens and tool_uses figures equal the
sums of its artifact's rows. Accepted by the product authority's
direction of 2026-09-09 to follow the cost chain through; run now.

Originator's answer: **accepted** — the lead-pm role, 2026-09-09.
The register item the lane runs on is lead-d0er0; it points at this
request and carries nothing of what was asked.

## 4. Result

### Definition

req-2026-09-09-rollup-reads-typedef: when done, `rollup_cost.py`
reads a run-cost artifact's Rows table by the column names the
run-cost typedef (v5) gives them — one `tokens` figure and one `tool
uses` figure per row — never by position under the retired
context/output quad; and `write_cost_rows.py` writes a step's
minutes as the wall-clock span between that step's own start and
completion events, the run-measurement contract's own words, never
from the event before the step's launch to the launch.

- Given a run-cost artifact whose Rows table follows the run-cost
  typedef (v5) — one `tokens` figure and one `tool uses` figure per
  row, by column name — when `rollup_cost.py` sums the initiative
  that artifact's session belongs to, then the printed line's
  `tokens` and `tool_uses` figures each equal the sum of the column
  bearing that name across the artifact's rows, read by name — never
  the `Tokens` column read into a `context_tokens` figure or the
  `Tool uses` column read into an `output_tokens` figure by position.
- Given the real leaf initiative init-plain-voice and its populated
  cost artifact sessions/sess-2026-09-09-a-cost.md, when
  `rollup_cost.py init-plain-voice` is run, then the printed line
  carries non-blank `tokens` and `tool_uses` figures equal to the
  sums of that artifact's `tokens` and `tool uses` columns.
- Given a step recorded on the anchor with its own start and
  completion events, when `write_cost_rows.py` writes that step's
  row, then the row's minutes equal the wall-clock span between
  those two timestamps, per the run-measurement contract — never the
  span from the event before the step's launch to the launch.
- Given the real, already-closed anchor lead-lv37s (session
  sess-2026-09-09-a), whose `draft` step ran 2.7 minutes by the
  anchor's own start and completion timestamps, when
  `write_cost_rows.py sess-2026-09-09-a --anchor lead-lv37s` is run,
  then the `draft` row's minutes read 2.7 — not 0.3, the span the
  retired reading produced.

Artifacts touched, by path: basis/tools/rollup_cost.py (unversioned
tool script; the reader of the run-cost typedef's Rows table — sums
by column name per v5, one `tokens` figure and one `tool_uses`
figure, never the retired `context_tokens`/`output_tokens` split
read by position); its rendering .claude/skills/rollup-cost/SKILL.md,
source basis/tools/rollup_cost.py, rendering tool
basis/tools/compile_tool.py; basis/tools/write_cost_rows.py
(unversioned tool script; writes a step's minutes as the wall-clock
span from the step's own start to its completion, per the
run-measurement contract — never from the event before the step's
launch to the launch); its rendering
.claude/skills/write-cost-rows/SKILL.md, source
basis/tools/write_cost_rows.py, rendering tool
basis/tools/compile_tool.py.

Maker role: lead-solutions-architect.

Verifying observation: `python3 basis/tools/write_cost_rows.py
sess-2026-09-09-a --anchor lead-lv37s && grep -E '^\| draft \|
lead-po \| 2\.7' sessions/sess-2026-09-09-a-cost.md && python3
basis/tools/rollup_cost.py init-plain-voice`, exit 0.

Defined by the lead-po role at the define step, against the
glossary's simple-change entry and the request's Route: the change
stays within the lead shop's own definitions — the run-cost
typedef's already-stated column names and the run-measurement
contract's already-stated minutes definition, and the two tools that
read them, each with its rendering re-produced, never hand-edited —
touches no Bounded Context, and its effect is demonstrable in one
session on the real anchor lead-lv37s and the real initiative
init-plain-voice; simple.

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-09, at
the small-change lane's make step.

Paths changed this round:

- `basis/tools/rollup_cost.py` — no version field (unversioned tool
  script). `FIELDS` narrowed from the retired
  `["minutes", "context_tokens", "output_tokens", "tool_uses"]` to
  `["minutes", "tokens", "tool_uses"]`, matching the run-cost typedef
  (v5); `parse_rows` rewritten to read the Rows table's header row and
  index each of `Minutes`, `Tokens`, `Tool uses` by name (a
  `COLUMNS` map), never by position — a header missing a named column
  now fails `unparseable` rather than silently reading the wrong
  column; `DESCRIPTION`'s `returns.text` restated to the new field
  set.
- `.claude/skills/rollup-cost/SKILL.md` — re-produced via `python3
  basis/tools/compile_tool.py basis/tools/rollup_cost.py --load-point
  .claude/skills`; `source-digest` sha256:725d92865af5 →
  sha256:c8e25e33e0c2, `Returns` line now reads
  `minutes=<n> tokens=<n> tool_uses=<n> sources=<n>`.
- `basis/tools/write_cost_rows.py` — no version field (unversioned
  tool script). A step's row minutes now the wall-clock span between
  that step's own `step` comment (its start) and its own completion
  event — the first following anchor event that is not a `usage`
  comment — read through a new `completion_ts` helper, never the span
  from the event before the step's launch to the launch; a step with
  no following event leaves minutes blank (`blank(minutes)` now wraps
  the Rows-table cell) rather than computing a wrong number. The
  router-turn row's own minutes (previous event to its `usage`
  comment) is unchanged — already the turn's own start-to-completion
  span. The module docstring's minutes paragraph restated to name both
  spans; `DESCRIPTION`'s own wording (already correct from an earlier,
  uncommitted round) untouched.
- `.claude/skills/write-cost-rows/SKILL.md` — re-produced via `python3
  basis/tools/compile_tool.py basis/tools/write_cost_rows.py
  --load-point .claude/skills`; `source-digest` unchanged at
  sha256:effe9dbf9c42 — the `--describe` answer's shape is untouched
  by this round's code change (minutes computation, not the tool's
  described contract).

Verifying observation run: `python3 basis/tools/write_cost_rows.py
sess-2026-09-09-a --anchor lead-lv37s && grep -E '^\| draft \|
lead-po \| 2\.7' sessions/sess-2026-09-09-a-cost.md && python3
basis/tools/rollup_cost.py init-plain-voice` — exit 0; the `draft` row
reads `2.7`; `init-plain-voice (leaf): minutes=9.6 tokens=192791
tool_uses=47 sources=1`, `tokens` and `tool_uses` equal to the sum of
sessions/sess-2026-09-09-a-cost.md's four step rows (62398+25332+35996+69065=192791;
19+4+11+13=47).

Self-check against the Definition's four acceptance statements:
statement 1 and 2 hold — `rollup_cost.py` now indexes `Tokens` and
`Tool uses` by header name, and the observed line's `tokens` and
`tool_uses` figures are non-blank and equal the column sums;
statement 3 and 4 hold — `write_cost_rows.py`'s step rows now carry
the span between the step's own start and completion events, and the
real `draft` row on lead-lv37s reads `2.7`, not `0.3`. "Make nothing
the definition does not cover": no other field, column, or step kind
touched; the router-turn row's minutes formula, the `report`-line
matching, and the typedef itself (basis/artifacts/run-cost.md, not
among the named paths) left as they stood.

### Check

**Round 1** — verdict: **pass**. Checker: the lead-pm role, 2026-09-09,
at the small-change lane's check step, against the Definition alone.

Statement 1 holds: `parse_rows` reads the Rows table's header and
indexes `Minutes`, `Tokens`, and `Tool uses` by name through
`COLUMNS`, failing `unparseable` when a named column is absent; no
positional unpack remains. Statement 2 holds: `python3
basis/tools/rollup_cost.py init-plain-voice` prints
`init-plain-voice (leaf): minutes=9.6 tokens=192791 tool_uses=47
sources=1`, and sessions/sess-2026-09-09-a-cost.md's rows sum to
62398+25332+35996+69065 = 192791 and 19+4+11+13 = 47. Statement 3
holds: `completion_ts` returns the first non-`usage` event after the
step's own `step` comment, and minutes is that span. Statement 4
holds: on lead-lv37s the anchor's own events put `step: draft` at
12:47:18Z and `draft complete` at 12:49:58Z, 160 s = 2.7 min, and the
`draft` row reads `2.7`; the other three step rows (0.8, 1.3, 3.8)
match their own start-to-completion spans the same way.

Producing rules: both renderings recompile byte-identical from their
sources through basis/tools/compile_tool.py — neither hand-edited;
rollup-cost's `source-digest` moved to sha256:c8e25e33e0c2,
write-cost-rows' stayed at sha256:effe9dbf9c42 because its
`--describe` answer is unchanged, as the Change made entry states;
the two tool scripts carry no version field; `changed` equals the
Definition's paths; the run-cost typedef and the router-turn minutes
formula stand untouched. Finding: none.

### Verified result

Verifying observation, as the Definition named it: `python3
basis/tools/write_cost_rows.py sess-2026-09-09-a --anchor lead-lv37s
&& grep -E '^\| draft \| lead-po \| 2\.7'
sessions/sess-2026-09-09-a-cost.md && python3
basis/tools/rollup_cost.py init-plain-voice`.

Evidence — the output lines and the closing exit:

```
sessions/sess-2026-09-09-a-cost.md
| draft | lead-po | 2.7 | 62398 | 19 |  |
init-plain-voice (leaf): minutes=9.6 tokens=192791 tool_uses=47 sources=1
exit 0
```

The `draft` row of the real, already-closed anchor lead-lv37s carries
2.7 minutes — the span between that step's own start and completion
events on the anchor, not the 0.3 the retired reading produced — and
the rollup line for the real leaf initiative init-plain-voice carries
`tokens=192791` and `tool_uses=47`, each the sum of the column bearing
that name across the artifact's four step rows, read by name. The
effect is shown in the running system, on the repository's own anchor
and initiative, not by a check passing.

Date: 2026-09-09. Role: lead-pm.

The Definition, the Check's verdict by the lead-pm role (round 1 pass,
finding none), and this result stand. Between the request and this
result no bet was taken and no check of record was run.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the request-intake process's record step from the first rollup over a populated cost artifact; routed to the lane, accepted, run now. |
| 2 | 2026-09-09 | update | Originator's answer recorded by the lead-pm at the request-intake process's answer step: accepted; work item lead-d0er0 opened for the small-change lane. |
| 3 | 2026-09-09 | update | Defined by the lead-po role at the define step: judged simple against the glossary's simple-change entry — two lead-shop tools, no Bounded Context, demonstrable in one session; Definition added to the Result section, naming four acceptance statements, the four artifacts touched (the two tools and their skill renderings, with the rendering tool), the maker role, and the verifying observation on the real anchor lead-lv37s and the real initiative init-plain-voice. |
| 4 | 2026-09-09 | update | Checked by the lead-pm role at the check step, round 1: pass — all four acceptance statements hold on the real anchor lead-lv37s and the real initiative init-plain-voice; both renderings recompile identical from their sources; no finding. |
| 5 | 2026-09-09 | update | Verified result recorded by the lead-pm role at the small-change process's record step: the Definition's verifying observation run on lead-lv37s and init-plain-voice, the `draft` row's minutes 2.7 and the rollup line tokens=192791 tool_uses=47 equal to the artifact's column sums, exit 0; status set to done; no bet taken and no check of record run between the request and this result. |
| 6 | 2026-09-09 | update | Result landed by the lead-pm role at the request-intake process's land-result step: `routed-to` written from the lane's `change` — this request's own Result section, where the Definition, the Check (round 1 pass, no finding), and the verified result stand; the lane's status `done` and its rows 3–5 left as written, nothing written twice. |
