---
name: write-cost-rows
description: 'Reads one execution''s anchor (a `bd` work item) — the router''s own
  `step` and `usage` comments and the starter''s `report` comment, in the forms basis/roles/router.md
  names — and writes the cost rows for that session''s close beside the session record:
  one row per agent or human step and per top-level router turn, naming its step,
  role, wall-clock minutes, tokens, tool uses, and duration — a field the report does
  not carry left blank, a router turn''s tokens always blank, never estimated. No
  model computes a row. Use it from session-handoff-process''s write-cost-rows step;
  an empty anchor writes nothing. Tool: `basis/tools/write_cost_rows.py`. Uses, each
  with its exact invocation below: `produce`.'
type: skill
id: write-cost-rows-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: write-cost-rows
source: basis/tools/write_cost_rows.py
source-digest: sha256:effe9dbf9c42
---

# write-cost-rows (produced from the answer of `basis/tools/write_cost_rows.py`)

Reads one execution's anchor (a `bd` work item) — the router's own `step` and `usage` comments and the starter's `report` comment, in the forms basis/roles/router.md names — and writes the cost rows for that session's close beside the session record: one row per agent or human step and per top-level router turn, naming its step, role, wall-clock minutes, tokens, tool uses, and duration — a field the report does not carry left blank, a router turn's tokens always blank, never estimated. No model computes a row. Use it from session-handoff-process's write-cost-rows step; an empty anchor writes nothing.

Uses: [produce](#produce).

## produce

Reads the anchor's comments and, for each step they record, the role and execution the named process definition gives that step, then the tokens, tool uses, and duration the starter's `report` comment gives that step; writes sessions/<session_id>-cost.md, creating the directory, overwriting what stands there. An empty or absent anchor writes nothing and prints nothing.

Invocation:

```sh
python3 basis/tools/write_cost_rows.py <session_id> --anchor <anchor_id>
```

Takes:
- `<session_id>` — the session record's own id, e.g. sess-2026-09-08-a; the cost file pairs with sessions/<session_id>.md (required)
- `<anchor_id>` — the bd work item id the execution passed through the router on; empty (the default) means no anchor exists for this session (omitted: `""` is taken)

Returns (text): one line, the path written (sessions/<session_id>-cost.md), on a non-empty anchor; nothing on an empty one; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | `bd comments <anchor_id> --json` failed — no such work item, or bd itself errored; one line on standard error beginning `unreadable:` names the anchor and bd's own message; nothing is written | give the id of an anchor bd holds, or omit --anchor, and run the invocation again |
| `unparseable` | 1 | the anchor's first comment names no process id ending `-process`, or no file under basis/processes/ carries that id, or that definition's Steps yaml block does not parse; one line on standard error beginning `unparseable:` names the anchor and the defect; nothing is written | repair the anchor's start comment or the named process definition, and run the invocation again |
| `unwritable` | 1 | sessions/<session_id>-cost.md could not be written; one line on standard error beginning `unwritable:` names the path and the reason | make the path writable and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states; one line on standard error beginning `usage:` names them; nothing is written | run the invocation the use states, as written |
