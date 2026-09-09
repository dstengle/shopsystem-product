---
name: lint-basis
description: 'The lint over the lead shop''s definition corpus: checks the basis tree
  and the request, brief, and guidance records at the repository root against their
  typedefs'' rules, derives an artifact type''s definition chain from the references
  its documents carry, and checks one decision brief or one process definition alone.
  Use it before reporting any change to the tree, after editing a definition, brief,
  request, or guidance record, when a process definition names a tool, and when an
  artifact type''s chain is wanted; it changes no file. Tool: `basis/tools/lint_basis.py`.
  Uses, each with its exact invocation below: `lint`, `check-brief`, `check-process`,
  `derive-chain`.'
type: skill
id: lint-basis-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: lint-basis
source: basis/tools/lint_basis.py
source-digest: sha256:ff33022b8dbc
---

# lint-basis (produced from the answer of `basis/tools/lint_basis.py`)

The lint over the lead shop's definition corpus: checks the basis tree and the request, brief, and guidance records at the repository root against their typedefs' rules, derives an artifact type's definition chain from the references its documents carry, and checks one decision brief or one process definition alone. Use it before reporting any change to the tree, after editing a definition, brief, request, or guidance record, when a process definition names a tool, and when an artifact type's chain is wanted; it changes no file.

Uses: [lint](#lint), [check-brief](#check-brief), [check-process](#check-process), [derive-chain](#derive-chain).

## lint

Runs checks 1-14 over every markdown file under basis/ and over requests/, briefs/, guidance/, and initiatives/ at the repository root: frontmatter identity, unique `defines`, `$ref` sources, resolvable links, required headings, banned vocabulary, version and Document History, no numbered-decision reference, request frontmatter, brief frontmatter, tools named by process definitions, guidance frontmatter, each parent initiative's Sub-initiatives list held to its children's `parent` fields, and the old-term vocabulary measure (run as a noun, anchor for the identifier) outside the superseded set. Reads only; writes and changes nothing. The tree is found from the tool's own location, so the current directory does not matter.

Invocation:

```sh
python3 basis/tools/lint_basis.py
```

Takes: nothing — the use has no input.

Returns (text): the last line `PASS: 0 violation(s)` on standard output, nothing before it; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `check-failed` | 1 | the check found violations: one line per violation on standard output, `<path>[:<line>]: <what> (<clause>)`, then the last line `FAIL: <n> violation(s)` | repair each named file at the named clause, then run the same invocation again until its last line reads `PASS: 0 violation(s)` |
| `usage` | 2 | the arguments are not one of the four invocations this tool states; one line on standard error beginning `usage:` names them; nothing is checked | run the invocation the use states, as written |

## check-brief

Checks one decision brief alone by check 10's rules: the decision-brief typedef's closed frontmatter field set, its status vocabulary, and that every `relates-to` path resolves from the repository root. Reads only; the rest of the tree is not checked.

Invocation:

```sh
python3 basis/tools/lint_basis.py --brief <path>
```

Takes:
- `<path>` — the path of the decision brief to check, relative to the current directory or absolute (required)

Returns (text): the last line `PASS: 0 violation(s)` on standard output, nothing before it; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `check-failed` | 1 | the check found violations: one line per violation on standard output, `<path>[:<line>]: <what> (<clause>)`, then the last line `FAIL: <n> violation(s)` | repair each named file at the named clause, then run the same invocation again until its last line reads `PASS: 0 violation(s)` |
| `unreadable` | 2 | no file exists at <path>, or it cannot be read; one line on standard error beginning `unreadable:` names the path | give the path of an existing file, relative to the current directory or absolute, and run the invocation again |
| `usage` | 2 | the arguments are not one of the four invocations this tool states; one line on standard error beginning `usage:` names them; nothing is checked | run the invocation the use states, as written |

## check-process

Checks one process definition alone by check 11's rule: every repository tool path it names — `basis/tools/<name>.py` in a step's `run:` template or an `initial:` value — exists in the repository. Reads only; the rest of the tree is not checked.

Invocation:

```sh
python3 basis/tools/lint_basis.py --process <path>
```

Takes:
- `<path>` — the path of the process definition to check, relative to the current directory or absolute (required)

Returns (text): the last line `PASS: 0 violation(s)` on standard output, nothing before it; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `check-failed` | 1 | the check found violations: one line per violation on standard output, `<path>[:<line>]: <what> (<clause>)`, then the last line `FAIL: <n> violation(s)` | repair each named file at the named clause, then run the same invocation again until its last line reads `PASS: 0 violation(s)` |
| `unreadable` | 2 | no file exists at <path>, or it cannot be read; one line on standard error beginning `unreadable:` names the path | give the path of an existing file, relative to the current directory or absolute, and run the invocation again |
| `usage` | 2 | the arguments are not one of the four invocations this tool states; one line on standard error beginning `usage:` names them; nothing is checked | run the invocation the use states, as written |

## derive-chain

Derives the definition chain of one artifact type from the references the documents under basis/ and the skills at .claude/skills/ carry — the typedef by `defines`, the guideline and fitness set by `target-type`, the process by `produces`, its roles from the steps, the skill by `derived-from` — and prints it. Never hand-written. An artifact type no typedef defines yields a chain with every link empty and status draft: that is a result, not a failure. Reads only.

Invocation:

```sh
python3 basis/tools/lint_basis.py --derive-chain <artifact_type>
```

Takes:
- `<artifact_type>` — the artifact type whose chain to derive: the `defines` value of its typedef, for example `feature` (required)

Returns (yaml on standard output), the shape:

```yaml
type: object
description: 'the definition-chain data type, basis/types/definition-chain.md: each
  link is the id of the document found, or empty when none is; status is approved
  only when every link is found and approved'
properties:
  artifact_type:
    type: string
  typedef:
    type: string
  guideline:
    type: string
  fitness:
    type: string
  process:
    type: string
  roles:
    type: array
    items:
      type: string
  skill:
    type: string
  status:
    type: string
    enum:
    - draft
    - approved
required:
- artifact_type
- typedef
- guideline
- fitness
- process
- roles
- skill
- status
```

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 2 | the arguments are not one of the four invocations this tool states; one line on standard error beginning `usage:` names them; nothing is checked | run the invocation the use states, as written |
