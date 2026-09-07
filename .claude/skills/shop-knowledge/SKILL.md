---
name: shop-knowledge
description: 'The knowledge context''s command over the shop''s record kinds: validates
  one document against the schema of its declared artifact type, and prints the schema
  of one of the eight recognized types (intent-record, candidate, session-record,
  prioritization-record, brief, pdr, adr, current-state). Use it where a process step
  validates a session record, and to read what a record kind requires before writing
  one. Tool: `shop-knowledge`, owned by shopsystem-knowledge; it does not answer the
  standard question, so this skill is produced from the description beside it, `basis/tools/descriptions/shop-knowledge.json`.
  Uses, each with its exact invocation below: `validate`, `schema`.'
type: skill
id: shop-knowledge-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: shop-knowledge
source: basis/tools/descriptions/shop-knowledge.json
source-digest: sha256:50ebfe1fc07e
stands-beside: shop-knowledge
tool-owner: shopsystem-knowledge
---

# shop-knowledge (produced from the description beside `shop-knowledge`, `basis/tools/descriptions/shop-knowledge.json`)

The knowledge context's command over the shop's record kinds: validates one document against the schema of its declared artifact type, and prints the schema of one of the eight recognized types (intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state). Use it where a process step validates a session record, and to read what a record kind requires before writing one.

Uses: [validate](#validate), [schema](#schema).

## validate

Reads the document at <path> and checks its frontmatter and sections against the schema of the artifact type its `type` field names. Reads only; changes nothing.

Invocation:

```sh
shop-knowledge validate <path>
```

Takes:
- `<path>` — the path of the document to validate, relative to the current directory or absolute (required)

Returns (text): one line on standard output, `conforming: <path>`; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `check-failed` | 1 | the document does not conform: on standard output `non-conforming: <path>` then one line ` - <finding>` per finding — a type not among the eight, a required field missing, a required section missing | repair the document at each finding and run the same invocation again until it reads `conforming: <path>` |
| `unreadable` | 1 | no file exists at <path>: a Python traceback on standard error whose last line is `FileNotFoundError: [Errno 2] No such file or directory: '<path>'`; nothing on standard output | give the path of an existing document and run the invocation again |
| `usage` | 2 | the arguments are not an invocation this tool states — no subcommand, an unknown one, or the wrong number of arguments; one line on standard error beginning `error:` says which; nothing is read | run the invocation the use states, as written |

## schema

Prints the schema of one recognized artifact type as JSON: its id pattern, required fields (shared and type-specific), required sections, and statuses. Reads only.

Invocation:

```sh
shop-knowledge schema <artifact_type>
```

Takes:
- `<artifact_type>` — one of the eight recognized artifact types: intent-record, candidate, session-record, prioritization-record, brief, pdr, adr, current-state (required)

Returns (json on standard output), the shape:

```yaml
type: object
description: the type's schema as the tool prints it
properties:
  document_shape:
    type: string
  generated:
    type: boolean
  id_example:
    type: string
  id_pattern:
    type: string
  non_empty_fields:
    type: array
    items:
      type: string
  read_only:
    type: boolean
  required_sections:
    type: array
    items:
      type: string
  shared_required_fields:
    type: array
    items:
      type: string
  statuses:
    type: array
    items:
      type: string
  type:
    type: string
  type_required_fields:
    type: array
    items:
      type: string
required:
- document_shape
- id_example
- id_pattern
- required_sections
- shared_required_fields
- statuses
- type
- type_required_fields
```

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 2 | <artifact_type> is not one of the eight, or is missing: on standard error `error: '<artifact_type>' is not a recognized artifact type` and a line naming the eight, or `error: 'schema' takes exactly one artifact type` | give one of the eight recognized artifact types and run the invocation again |
