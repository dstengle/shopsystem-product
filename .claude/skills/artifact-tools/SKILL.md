---
name: artifact-tools
description: 'Reads and writes an artifact by the part it needs (a frontmatter field
  or a level-2 section), renders a parent''s children and what references an artifact
  fresh from the corpus on every call, and fills a scenario''s `@hash:` and a bead''s
  initiative from what the corpus already states. Use it instead of loading or quoting
  a whole artifact, and wherever a calculated field or a filled value would otherwise
  be typed by hand. Tool: `basis/tools/artifact_tools.py`. Uses, each with its exact
  invocation below: `read`, `write`, `children`, `references`, `fill-hash`, `fill-initiative`.'
type: skill
id: artifact-tools-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: artifact-tools
source: basis/tools/artifact_tools.py
source-digest: sha256:ef7d6984f64e
---

# artifact-tools (produced from the answer of `basis/tools/artifact_tools.py`)

Reads and writes an artifact by the part it needs (a frontmatter field or a level-2 section), renders a parent's children and what references an artifact fresh from the corpus on every call, and fills a scenario's `@hash:` and a bead's initiative from what the corpus already states. Use it instead of loading or quoting a whole artifact, and wherever a calculated field or a filled value would otherwise be typed by hand.

Uses: [read](#read), [write](#write), [children](#children), [references](#references), [fill-hash](#fill-hash), [fill-initiative](#fill-initiative).

## read

Returns the text of one named part of an artifact — a frontmatter field or a level-2 section — and nothing else: the artifact's other sections and its history are left out unless that part is the one asked for.

Invocation:

```sh
python3 basis/tools/artifact_tools.py read <path> --section <section>
```

Takes:
- `<path>` — the artifact's path, repository-relative or absolute (required)
- `<section>` — the frontmatter field name, or the section's heading (a step's name before ` — `, where its heading carries one) (required)

Returns (text): the named part's text on standard output, unmodified; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | the path does not exist, or names no frontmatter field or section matching <section>; one line on standard error beginning `unreadable:` names the artifact, the section asked for, and the section and field names that do exist; nothing is returned | give an existing path and one of the names listed, then run again |
| `usage` | 2 | the arguments are not one of the six invocations this tool states — no path, a missing required flag, an unknown flag, or a flag without its value; one line on standard error beginning `usage:` names the invocations; nothing is read or written | run the invocation the use states, as written |

## write

Replaces one existing part's text — a frontmatter field or a level-2 section's body — with the given content, in place; every other part of the artifact is left unchanged and unread by the caller.

Invocation:

```sh
python3 basis/tools/artifact_tools.py write <path> --part <part> --content <content>
```

Takes:
- `<path>` — the artifact's path, repository-relative or absolute (required)
- `<part>` — the frontmatter field name, or the section's heading key, to replace (required)
- `<content>` — the part's new text — the whole replacement, never a diff against the old (required)

Returns (text): one line on standard output, `<path>: \`<part>\` written`; exit status 0; the part written in place

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | the path does not exist, or names no frontmatter field or section matching <part>; one line on standard error beginning `unreadable:` names the artifact, the part, and the part names that do exist; nothing is written | give an existing path and one of the part names listed, then run again |
| `unparseable` | 1 | <content> is empty, or does not fit the named part's shape (for example, `version` is not an integer); one line on standard error beginning `unparseable:` names the artifact, the part, and what to supply instead; nothing is written | supply content of the shape the part takes and run again |
| `usage` | 2 | the arguments are not one of the six invocations this tool states — no path, a missing required flag, an unknown flag, or a flag without its value; one line on standard error beginning `usage:` names the invocations; nothing is read or written | run the invocation the use states, as written |
| `unwritable` | 1 | the artifact could not be written; one line on standard error beginning `unwritable:` names the path and the reason | make the path writable, or give one that is, and run the invocation again |

## children

Renders the list of artifacts whose `parent` names this artifact's `id`, read fresh from every file in the corpus on this call — never a field stored on the parent.

Invocation:

```sh
python3 basis/tools/artifact_tools.py children <path>
```

Takes:
- `<path>` — the artifact's path, repository-relative or absolute (required)

Returns (json on standard output), the shape:

```yaml
type: array
items:
  type: string
```

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | the path does not exist, or its frontmatter carries no `id`; one line on standard error beginning `unreadable:` names the artifact; nothing is returned | give the path of an artifact whose frontmatter carries an `id` and run again |
| `usage` | 2 | the arguments are not one of the six invocations this tool states — no path, a missing required flag, an unknown flag, or a flag without its value; one line on standard error beginning `usage:` names the invocations; nothing is read or written | run the invocation the use states, as written |

## references

Renders the list of artifacts that link to this artifact's path or name it in a frontmatter field, read fresh from every file in the corpus on this call — never a field stored on the artifact.

Invocation:

```sh
python3 basis/tools/artifact_tools.py references <path>
```

Takes:
- `<path>` — the artifact's path, repository-relative or absolute (required)

Returns (json on standard output), the shape:

```yaml
type: array
items:
  type: string
```

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | the path does not exist; one line on standard error beginning `unreadable:` names it; nothing is returned | give an existing path and run again |
| `usage` | 2 | the arguments are not one of the six invocations this tool states — no path, a missing required flag, an unknown flag, or a flag without its value; one line on standard error beginning `usage:` names the invocations; nothing is read or written | run the invocation the use states, as written |

## fill-hash

Computes a scenario's `@hash:` — sha256 of its `Scenario:`/`Given`/`When`/`Then` (and `And`/`But`) lines, trimmed and newline-joined, first twelve hex digits — and writes it onto the scenario's tag line; the caller never supplies the hash.

Invocation:

```sh
python3 basis/tools/artifact_tools.py fill-hash <feature> --scenario <name>
```

Takes:
- `<feature>` — the feature file's path (required)
- `<scenario>` — the scenario's name, exactly as its `Scenario:` line reads (required)

Returns (text): one line on standard output, `<feature>: scenario \`<name>\` @hash: <12 hex>`; exit status 0; the tag line written in place

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | the feature does not exist, or names no scenario matching <scenario>; one line on standard error beginning `unreadable:` names the feature, the scenario asked for, and the scenario names that do exist; nothing is written | give an existing feature path and one of the scenario names listed, then run again |
| `unparseable` | 1 | the feature has no gherkin block, the named scenario has no Given/When/Then text, or its tag line carries no `@hash:` to fill; one line on standard error beginning `unparseable:` names the feature and the scenario, and what is wrong with its text; nothing is written | repair the scenario's text or tag line and run again |
| `usage` | 2 | the arguments are not one of the six invocations this tool states — no path, a missing required flag, an unknown flag, or a flag without its value; one line on standard error beginning `usage:` names the invocations; nothing is read or written | run the invocation the use states, as written |
| `unwritable` | 1 | the feature could not be written; one line on standard error beginning `unwritable:` names the path and the reason | make the path writable, or give one that is, and run the invocation again |

## fill-initiative

Reads the initiative an anchor artifact already names in its `initiative` frontmatter field, resolved fresh from the corpus, and writes it onto the bead through `bd comment` — `bd`'s only narrative-write action; the caller never supplies the initiative value.

Invocation:

```sh
python3 basis/tools/artifact_tools.py fill-initiative <bead> --anchor <path>
```

Takes:
- `<bead>` — the work item's id, for example lead-176ti (required)
- `<anchor>` — the path of the artifact the execution is anchored to, carrying the `initiative` field to read (required)

Returns (text): one line on standard output, `<bead>: initiative <path> written`; exit status 0; a comment added to the bead through `bd comment`

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | the anchor does not exist, carries no `initiative` field, that field does not resolve to a file, or no bead with <bead> exists in the register; one line on standard error names which one and what to check; nothing is written | give an anchor whose `initiative` field resolves, and the id of an existing bead, then run again |
| `usage` | 2 | the arguments are not one of the six invocations this tool states — no path, a missing required flag, an unknown flag, or a flag without its value; one line on standard error beginning `usage:` names the invocations; nothing is read or written | run the invocation the use states, as written |
| `unwritable` | 1 | `bd comment` failed for a reason other than the bead not being found; one line on standard error beginning `unwritable:` carries `bd`'s own message | act on `bd`'s message and run the invocation again |
