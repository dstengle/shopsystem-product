---
name: compile-tool
description: 'The producer of tool skills: asks a framework tool the standard question
  — runs it with `--describe` — or reads the description beside a tool that cannot
  answer, validates what it got against the tool-description data type, and produces
  the tool''s skill at the agent''s load point from that and from nothing else, stamped
  with a digest of the source''s bytes. Use it to place or refresh a tool''s skill,
  to check whether a tool answers or a description is in the shape, and — from the
  check over the load point — to ask a tool the question with the flag alone. Tool:
  `basis/tools/compile_tool.py`. Uses, each with its exact invocation below: `ask`,
  `produce`.'
type: skill
id: compile-tool-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: compile-tool
source: basis/tools/compile_tool.py
source-digest: sha256:49037d0ce814
---

# compile-tool (produced from the answer of `basis/tools/compile_tool.py`)

The producer of tool skills: asks a framework tool the standard question — runs it with `--describe` — or reads the description beside a tool that cannot answer, validates what it got against the tool-description data type, and produces the tool's skill at the agent's load point from that and from nothing else, stamped with a digest of the source's bytes. Use it to place or refresh a tool's skill, to check whether a tool answers or a description is in the shape, and — from the check over the load point — to ask a tool the question with the flag alone.

Uses: [ask](#ask), [produce](#produce).

## ask

Asks the tool `--describe` and nothing else — or reads the description file — and validates the result against the data type; prints the skill's name, the path it would take at the default load point, and the digest. Writes nothing; the tool is run for nothing but the question. Exit 0 means the tool answers, or the description is in the shape.

Invocation:

```sh
python3 basis/tools/compile_tool.py <source>
```

Takes:
- `<source>` — the tool to ask — the path of a tool under basis/tools/, or the name of a command on PATH — or the path of a description beside a tool that cannot answer, basis/tools/descriptions/<name>.json (required)

Returns (text): one line on standard output: for a tool, `<source>: answers as \`<name>\` for .claude/skills/<name>/SKILL.md (digest <12 hex>)`; for a description, `<source>: describes \`<name>\` beside \`<tool>\` for .claude/skills/<name>/SKILL.md (digest <12 hex>)`; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `no-answer` | 1 | the tool gave no answer to `--describe`: it exited with a status other than 0, did not finish within 60 seconds, wrote output that is not JSON, or wrote JSON that does not parse against the tool-description data type; one line on standard error beginning `no-answer:` names the tool and the reason — for a shape lack, the field and the part it carries; no skill is written | a tool of the lead shop: make its answer parse against basis/types/tool-description.md and run the invocation again; a tool of another shop: use it through a description beside it at basis/tools/descriptions/<name>.json and record the gap to its owner |
| `unparseable` | 1 | the description is not in the answer's shape: the file is not JSON, its `name` is not the file's stem, it lacks `stands_beside` or `tool_owner`, or a use entry lacks a part; one line on standard error beginning `unparseable:` names the file, the tool it stands beside where the file names one, the place (`uses[<i>]` and the field), and the part that field carries; no skill is written | add or repair the named part in the description — never in a skill — and run the same invocation again |
| `unreadable` | 2 | the source does not exist: no file at the tool's path, no command of that name on PATH, or no description file at the path; one line on standard error beginning `unreadable:` names it | give the tool's path or command name, or the description's path under basis/tools/descriptions/, and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states — no source, more than one, an unknown option, `--load-point` without a directory, or a description path outside basis/tools/descriptions/; one line on standard error beginning `usage:` names the invocations; nothing is asked and nothing is written | run the invocation the use states, as written |

## produce

Does what `ask` does, then writes the skill to <dir>/<name>/SKILL.md, creating the directories, overwriting whatever stands there — a hand edit included. The skill is a rendering of the answer or the description alone: front-matter with `source` and `source-digest` (and `stands-beside`, `tool-owner` for a description), then one section per use with its invocation, inputs, return, and failure table.

Invocation:

```sh
python3 basis/tools/compile_tool.py <source> --load-point <dir>
```

Takes:
- `<source>` — the tool to ask — the path of a tool under basis/tools/, or the name of a command on PATH — or the path of a description beside a tool that cannot answer, basis/tools/descriptions/<name>.json (required)
- `<dir>` — the load point to write under: .claude/skills for the agent's load point, or a scratch directory to produce without placing (required)

Returns (text): one line on standard output, `<dir>/<name>/SKILL.md: generated from <name> (digest <12 hex>)`; exit status 0; the skill written at that path

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `no-answer` | 1 | the tool gave no answer to `--describe`: it exited with a status other than 0, did not finish within 60 seconds, wrote output that is not JSON, or wrote JSON that does not parse against the tool-description data type; one line on standard error beginning `no-answer:` names the tool and the reason — for a shape lack, the field and the part it carries; no skill is written | a tool of the lead shop: make its answer parse against basis/types/tool-description.md and run the invocation again; a tool of another shop: use it through a description beside it at basis/tools/descriptions/<name>.json and record the gap to its owner |
| `unparseable` | 1 | the description is not in the answer's shape: the file is not JSON, its `name` is not the file's stem, it lacks `stands_beside` or `tool_owner`, or a use entry lacks a part; one line on standard error beginning `unparseable:` names the file, the tool it stands beside where the file names one, the place (`uses[<i>]` and the field), and the part that field carries; no skill is written | add or repair the named part in the description — never in a skill — and run the same invocation again |
| `unreadable` | 2 | the source does not exist: no file at the tool's path, no command of that name on PATH, or no description file at the path; one line on standard error beginning `unreadable:` names it | give the tool's path or command name, or the description's path under basis/tools/descriptions/, and run the invocation again |
| `unwritable` | 1 | the skill's directory or file under the load point could not be created or written; one line on standard error beginning `unwritable:` names the path and the reason | make the load point writable, or give one that is, and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states — no source, more than one, an unknown option, `--load-point` without a directory, or a description path outside basis/tools/descriptions/; one line on standard error beginning `usage:` names the invocations; nothing is asked and nothing is written | run the invocation the use states, as written |
