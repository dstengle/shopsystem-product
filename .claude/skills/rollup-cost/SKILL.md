---
name: rollup-cost
description: 'Sums one initiative''s run cost on request: a leaf initiative from the
  run-cost rows of every session whose bead names it, a parent initiative from its
  children''s own rollups. No model computes a figure; never runs as a process step.
  Tool: `basis/tools/rollup_cost.py`. Uses, each with its exact invocation below:
  `sum`.'
type: skill
id: rollup-cost-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: rollup-cost
source: basis/tools/rollup_cost.py
source-digest: sha256:725d92865af5
---

# rollup-cost (produced from the answer of `basis/tools/rollup_cost.py`)

Sums one initiative's run cost on request: a leaf initiative from the run-cost rows of every session whose bead names it, a parent initiative from its children's own rollups. No model computes a figure; never runs as a process step.

Uses: [sum](#sum).

## sum

Reads the named initiative's children from every initiative's `parent` field (a parent), or every run-cost artifact under sessions/ whose bead's start comment names it (a leaf), and prints the sum. Writes nothing; a column no contributing row supplied is left blank.

Invocation:

```sh
python3 basis/tools/rollup_cost.py <initiative_id>
```

Takes:
- `<initiative_id>` — the initiative's own id, e.g. init-run-measurement; its file is initiatives/<initiative_id>.md (required)

Returns (text): one line, `<id> (<kind>): minutes=<n> context_tokens=<n> output_tokens=<n> tool_uses=<n> sources=<n>` — <kind> is leaf or parent, <n> for a field blank when no contributing row supplied it, sources the session count (leaf) or child count (parent); exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | no initiatives/<initiative_id>.md exists, or a run-cost artifact's bead could not be read (`bd comments <anchor> --json` failed); one line on standard error beginning `unreadable:` names what could not be read; nothing is printed | give the id of an initiative under initiatives/, or repair the named bead, and run the invocation again |
| `unparseable` | 1 | an initiative's frontmatter, a run-cost artifact's Rows table, or a bead's answer does not parse; one line on standard error beginning `unparseable:` names the file and the defect; nothing is printed | repair the named file and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states; one line on standard error beginning `usage:` names them; nothing is printed | run the invocation the use states, as written |
