---
name: compile-typedef
description: 'Produces an artifact typedef''s two texts — its guideline from the `##
  Writing rules` section and its fitness set from the `## Fitness scenarios` section
  — at the paths the checks read, each stamped `generated`, `source`, and `source-digest`,
  and checks whether the texts that stand are current with the typedef. Only an approved
  typedef compiles. Use it after such a typedef changes, and to confirm that its guideline
  and fitness set are current. Tool: `basis/tools/compile_typedef.py`. Uses, each
  with its exact invocation below: `produce`, `check`.'
type: skill
id: compile-typedef-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: compile-typedef
source: basis/tools/compile_typedef.py
source-digest: sha256:a1b478fb7c70
---

# compile-typedef (produced from the answer of `basis/tools/compile_typedef.py`)

Produces an artifact typedef's two texts — its guideline from the `## Writing rules` section and its fitness set from the `## Fitness scenarios` section — at the paths the checks read, each stamped `generated`, `source`, and `source-digest`, and checks whether the texts that stand are current with the typedef. Only an approved typedef compiles. Use it after such a typedef changes, and to confirm that its guideline and fitness set are current.

Uses: [produce](#produce), [check](#check).

## produce

Renders both texts from the typedef and writes them, creating directories, overwriting what stands at each path — a hand edit included. The typedef itself is not changed.

Invocation:

```sh
python3 basis/tools/compile_typedef.py <typedef> [--guideline <guideline>] [--fitness <fitness>]
```

Takes:
- `<typedef>` — the path of the artifact typedef, for example basis/artifacts/feature.md; it must stand approved and carry `## Writing rules` and `## Fitness scenarios` (required)
- `<guideline>` — the guideline's path (omitted: `"basis/guidelines/<type>.md, <type> the typedef's `defines`"` is taken)
- `<fitness>` — the fitness set's path (omitted: `"basis/fitness/<type>.fitness.md, <type> the typedef's `defines`"` is taken)

Returns (text): two lines on standard output, `<guideline>: produced from basis/artifacts/<file>` then `<fitness>: produced from basis/artifacts/<file>`; exit status 0; both texts written

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 1 | no file exists at <typedef>, or it cannot be read: one row on standard output, `will-not-compile <typedef> <code>: <reason>`, exit status 1; nothing is written | give the path of an existing typedef and run the invocation again |
| `unparseable` | 1 | the typedef has no front-matter, or its front-matter does not parse or is not a mapping: one row on standard output, `will-not-compile <typedef> <code>: <reason>`, exit status 1; nothing is written | repair the typedef's front-matter and run the invocation again |
| `check-failed` | 1 | the typedef does not qualify or does not render: its `type` is not artifact-typedef, its `status` is not approved (refused), it lacks an identity key, a `## Writing rules` or `## Fitness scenarios` section, or a `**Judged by:**` line, or a produced text lacks a mark its reader requires: one row on standard output, `will-not-compile <typedef> <code>: <reason>`, exit status 1; nothing is written | repair the typedef at the named defect (the artifact-typedef typedef states the sections) and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states — no typedef, more than one, an option without its path, or an unknown option; the usage sheet on standard error; nothing is written | run the invocation the use states, as written |

## check

Renders both texts afresh to memory and compares each with what stands at its path; prints one row per text that is not current and nothing when both are. Writes nothing.

Invocation:

```sh
python3 basis/tools/compile_typedef.py <typedef> --check [--guideline <guideline>] [--fitness <fitness>]
```

Takes:
- `<typedef>` — the path of the artifact typedef, for example basis/artifacts/feature.md; it must stand approved and carry `## Writing rules` and `## Fitness scenarios` (required)
- `<guideline>` — the guideline's path (omitted: `"basis/guidelines/<type>.md, <type> the typedef's `defines`"` is taken)
- `<fitness>` — the fitness set's path (omitted: `"basis/fitness/<type>.fitness.md, <type> the typedef's `defines`"` is taken)

Returns (text): on standard output, zero, one, or two rows, one per line: `missing <type>-guideline` or `missing <type>-fitness` when nothing stands at the text's path, `diverged <type>-guideline` or `diverged <type>-fitness` when what stands differs from a fresh render; nothing printed when both are current; exit status 0 in each of these outcomes — a missing or diverged row is a result, not a failure

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 1 | no file exists at <typedef>, or it cannot be read: one row on standard output, `will-not-compile <typedef> <code>: <reason>`, exit status 1; nothing is written | give the path of an existing typedef and run the invocation again |
| `unparseable` | 1 | the typedef has no front-matter, or its front-matter does not parse or is not a mapping: one row on standard output, `will-not-compile <typedef> <code>: <reason>`, exit status 1; nothing is written | repair the typedef's front-matter and run the invocation again |
| `check-failed` | 1 | the typedef does not qualify or does not render: its `type` is not artifact-typedef, its `status` is not approved (refused), it lacks an identity key, a `## Writing rules` or `## Fitness scenarios` section, or a `**Judged by:**` line, or a produced text lacks a mark its reader requires: one row on standard output, `will-not-compile <typedef> <code>: <reason>`, exit status 1; nothing is written | repair the typedef at the named defect (the artifact-typedef typedef states the sections) and run the invocation again |
| `usage` | 2 | the arguments are not one of the two invocations this tool states — no typedef, more than one, an option without its path, or an unknown option; the usage sheet on standard error; nothing is written | run the invocation the use states, as written |
