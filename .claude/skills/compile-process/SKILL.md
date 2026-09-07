---
name: compile-process
description: 'Compiles a process definition: checks that every `$ref` in its data
  block has a source that defines the type, regenerates the Mermaid flow diagram in
  the definition''s `## Flow (compiled)` section, and — on request — renders the definition''s
  loadable skill, whose only prose is the step prompts, verbatim, each agent-run step
  closing with the banned-words line read from the lint. Use it after a process definition
  changes, and to place or refresh the definition''s skill at the agent''s load point.
  Tool: `basis/tools/compile_process.py`. Uses, each with its exact invocation below:
  `compile`, `compile-skill`.'
type: skill
id: compile-process-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: compile-process
source: basis/tools/compile_process.py
source-digest: sha256:a1b0583fc8a9
---

# compile-process (produced from the answer of `basis/tools/compile_process.py`)

Compiles a process definition: checks that every `$ref` in its data block has a source that defines the type, regenerates the Mermaid flow diagram in the definition's `## Flow (compiled)` section, and — on request — renders the definition's loadable skill, whose only prose is the step prompts, verbatim, each agent-run step closing with the banned-words line read from the lint. Use it after a process definition changes, and to place or refresh the definition's skill at the agent's load point.

Uses: [compile](#compile), [compile-skill](#compile-skill).

## compile

Checks the definition's `$ref` sources and `result`, regenerates the flow diagram, and writes it back into the definition's `## Flow (compiled)` section in place — the one write; nothing else in the definition changes and no skill is written.

Invocation:

```sh
python3 basis/tools/compile_process.py <definition>
```

Takes:
- `<definition>` — the path of the process definition, for example basis/processes/skill-rendering.md; its `$ref` sources resolve relative to that path (required)

Returns (text): one line on standard output, `<definition>: flow diagram regenerated (<n> steps)`; exit status 0; the diagram written into the definition

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | no file exists at <definition>, or it cannot be read; one line on standard error beginning `unreadable:` names the path; nothing is written | give the path of an existing process definition and run the invocation again |
| `unparseable` | 1 | the definition has no front-matter, its front-matter or a yaml block does not parse, or no yaml block carries `steps` and `start`; one line on standard error beginning `unparseable:` names the path and the defect; nothing is written | repair the definition at the named defect and run the invocation again |
| `check-failed` | 1 | the definition does not compile: a `$ref` without a `from:` source, a source that does not exist or does not define the type, a `result` that is not a declared data value, no `## Flow (compiled)` section to fill, or a step the renderer cannot render; one line on standard error beginning `check-failed:` names the path and the defect; nothing is written | repair the definition at the named defect (the process-definition typedef states the rules) and run the invocation again |
| `unwritable` | 1 | the definition, or the skill at <out>, could not be written; one line on standard error beginning `unwritable:` names the path and the reason | make the path writable, or give one that is, and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states — no definition, more than one, `--skill` without a path, or an unknown option; one line on standard error beginning `usage:` names them; nothing is written | run the invocation the use states, as written |

## compile-skill

Does what `compile` does, then renders the definition's skill — front-matter with `generated: true`, `source`, and `source-digest` over the definition's text, the purpose, guiding statement, diagram, and every step with its prompt verbatim — and writes it to <out>, creating the directories, overwriting what stands there, a hand edit included.

Invocation:

```sh
python3 basis/tools/compile_process.py <definition> --skill <out>
```

Takes:
- `<definition>` — the path of the process definition, for example basis/processes/skill-rendering.md; its `$ref` sources resolve relative to that path (required)
- `<out>` — the path the skill is written to: .claude/skills/<name>/SKILL.md at the agent's load point, <name> the definition's carried-by id without `-skill`; or a scratch path to render without placing (required)

Returns (text): two lines on standard output, `<definition>: flow diagram regenerated (<n> steps)` then `<out>: generated from <id> (digest <12 hex>)`; exit status 0; the diagram written into the definition and the skill at <out>

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | no file exists at <definition>, or it cannot be read; one line on standard error beginning `unreadable:` names the path; nothing is written | give the path of an existing process definition and run the invocation again |
| `unparseable` | 1 | the definition has no front-matter, its front-matter or a yaml block does not parse, or no yaml block carries `steps` and `start`; one line on standard error beginning `unparseable:` names the path and the defect; nothing is written | repair the definition at the named defect and run the invocation again |
| `check-failed` | 1 | the definition does not compile: a `$ref` without a `from:` source, a source that does not exist or does not define the type, a `result` that is not a declared data value, no `## Flow (compiled)` section to fill, or a step the renderer cannot render; one line on standard error beginning `check-failed:` names the path and the defect; nothing is written | repair the definition at the named defect (the process-definition typedef states the rules) and run the invocation again |
| `unwritable` | 1 | the definition, or the skill at <out>, could not be written; one line on standard error beginning `unwritable:` names the path and the reason | make the path writable, or give one that is, and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states — no definition, more than one, `--skill` without a path, or an unknown option; one line on standard error beginning `usage:` names them; nothing is written | run the invocation the use states, as written |
