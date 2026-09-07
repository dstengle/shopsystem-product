---
name: compile-role
description: 'Compiles an approved role definition into its loadable form — the subagent
  file at the agent''s load point, `.claude/agents/<name>.md`: the runtime keys the
  harness honors, `source` and `source-digest`, and the definition''s body with its
  Document History stripped, its links resolved for the load point, and the banned-words
  line from the lint appended — and checks a load point against a fresh render of
  each approved definition. Use it after a role definition changes, to place its rendering,
  and to confirm every approved role is available. Tool: `basis/tools/compile_role.py`.
  Uses, each with its exact invocation below: `validate`, `render`, `check`.'
type: skill
id: compile-role-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: compile-role
source: basis/tools/compile_role.py
source-digest: sha256:917389653512
---

# compile-role (produced from the answer of `basis/tools/compile_role.py`)

Compiles an approved role definition into its loadable form — the subagent file at the agent's load point, `.claude/agents/<name>.md`: the runtime keys the harness honors, `source` and `source-digest`, and the definition's body with its Document History stripped, its links resolved for the load point, and the banned-words line from the lint appended — and checks a load point against a fresh render of each approved definition. Use it after a role definition changes, to place its rendering, and to confirm every approved role is available.

Uses: [validate](#validate), [render](#render), [check](#check).

## validate

Renders the definition to memory and prints the subagent name and the path the rendering would take; writes nothing. Exit 0 means the definition compiles.

Invocation:

```sh
python3 basis/tools/compile_role.py <definition> [--load-point <load_point>] [--roles <roles>]
```

Takes:
- `<definition>` — the path of the role definition, for example basis/roles/lead-pm.md; it must stand approved (required)
- `<load_point>` — the load point the rendering's links resolve for, repository-root-relative (omitted: `".claude/agents"` is taken)
- `<roles>` — the directory of the role definitions, repository-root-relative (omitted: `"basis/roles"` is taken)

Returns (text): one line on standard output, `<definition>: compiles as \`<name>\` for <load_point>/<name>.md (digest <12 hex>)`; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | no file exists at <definition>, or it cannot be read; one line on standard error beginning `unreadable:` names the path; nothing is written | give the path of an existing role definition and run the invocation again |
| `unparseable` | 1 | the definition has no front-matter, or its front-matter does not parse or is not a mapping; one line on standard error beginning `unparseable:` names the path and the defect; nothing is written | repair the definition's front-matter and run the invocation again |
| `check-failed` | 1 | the definition does not render: its `type` is not role-definition, its `status` is not approved (refused), it lacks `name`, `description`, `tools`, or `maxTurns`, carries a front-matter key that is neither a runtime key the harness honors nor an identity key, or its `name` is not a subagent name; one line on standard error beginning `check-failed:` names the path and the defect; nothing is written | repair the definition at the named defect (the role-definition typedef states the keys) and run the invocation again |
| `usage` | 2 | the arguments are not one of the three invocations this tool states — no definition or more than one outside check mode, `--agent` together with `--check`, `--findings` without `--check`, an option without its value, or an unknown option; the usage sheet on standard error; nothing is checked or written | run the invocation the use states, as written |

## render

Renders the definition and writes the subagent file to <out>, creating directories, overwriting what stands there — a hand edit included. The content is a function of the definition and the declared load point alone, so a render into a scratch path is byte-equal to the one that would stand at the load point.

Invocation:

```sh
python3 basis/tools/compile_role.py <definition> --agent <out> [--load-point <load_point>] [--roles <roles>]
```

Takes:
- `<definition>` — the path of the role definition, for example basis/roles/lead-pm.md; it must stand approved (required)
- `<out>` — the path the subagent file is written to: <load_point>/<name>.md to place it, or a scratch path (required)
- `<load_point>` — the load point the rendering's links resolve for, repository-root-relative (omitted: `".claude/agents"` is taken)
- `<roles>` — the directory of the role definitions, repository-root-relative (omitted: `"basis/roles"` is taken)

Returns (text): one line on standard output, `<out>: generated from <name> (digest <12 hex>)`; exit status 0; the file written at <out>

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | no file exists at <definition>, or it cannot be read; one line on standard error beginning `unreadable:` names the path; nothing is written | give the path of an existing role definition and run the invocation again |
| `unparseable` | 1 | the definition has no front-matter, or its front-matter does not parse or is not a mapping; one line on standard error beginning `unparseable:` names the path and the defect; nothing is written | repair the definition's front-matter and run the invocation again |
| `check-failed` | 1 | the definition does not render: its `type` is not role-definition, its `status` is not approved (refused), it lacks `name`, `description`, `tools`, or `maxTurns`, carries a front-matter key that is neither a runtime key the harness honors nor an identity key, or its `name` is not a subagent name; one line on standard error beginning `check-failed:` names the path and the defect; nothing is written | repair the definition at the named defect (the role-definition typedef states the keys) and run the invocation again |
| `unwritable` | 1 | <out> could not be written; one line on standard error beginning `unwritable:` names the path and the reason | give a writable <out> path and run the invocation again |
| `usage` | 2 | the arguments are not one of the three invocations this tool states — no definition or more than one outside check mode, `--agent` together with `--check`, `--findings` without `--check`, an option without its value, or an unknown option; the usage sheet on standard error; nothing is checked or written | run the invocation the use states, as written |

## check

Checks a load point against a fresh render of each given definition — or, when none is given, of every approved definition under <roles> — and scans every file at the load point for one that is no rendering of an approved definition. Prints one row per line, kind first: `ok <name> <definition>`, `missing <name> <definition>`, `diverged <name> <definition>`, `will-not-compile <definition> <reason>`, `stale <source> <file>`, `unrecognized <file>`. Writes nothing; no failure escapes as a traceback — whatever cannot be checked is a row.

Invocation:

```sh
python3 basis/tools/compile_role.py --check [<dir>] [--roles <roles>] [--findings] [<definition>...]
```

Takes:
- `<dir>` — the load point directory to check (omitted: `".claude/agents"` is taken)
- `<roles>` — the directory of the role definitions, repository-root-relative (omitted: `"basis/roles"` is taken)
- `<findings>` — suppress the `ok` rows so only findings are printed (omitted: `false` is taken)
- `<definition>` — the definitions to check against, each a path; a given definition that does not stand approved is a will-not-compile row (omitted: `[]` is taken)

Returns (text): the rows on standard output, one per line, kind first, every row `ok` (none printed with `--findings`); exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `check-failed` | 1 | at least one row is a finding — `missing`, `diverged`, `will-not-compile`, `stale`, or `unrecognized` — or no definition was checked; the rows on standard output name each finding by kind, name, and path | act on each row by kind through the role-rendering process: re-render a missing or diverged one with the `render` use, remove a stale one, escalate an unrecognized or will-not-compile one; then run the same invocation again until every row is `ok` |
| `usage` | 2 | the arguments are not one of the three invocations this tool states — no definition or more than one outside check mode, `--agent` together with `--check`, `--findings` without `--check`, an option without its value, or an unknown option; the usage sheet on standard error; nothing is checked or written | run the invocation the use states, as written |
