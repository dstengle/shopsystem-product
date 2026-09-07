---
type: data-type
id: tool-description
defines: tool-description
owner: product-authority
status: approved
approved: 2026-09-07
version: 2
created: 2026-09-07
updated: 2026-09-07
---

# Data type: tool-description

## Purpose

A framework tool's answer to the standard question — what the tool
says about itself: its name, what it does and when to use it, and one
use entry per use it supports, each stating what the use does, what it
takes, what it returns, and how it fails. The versioned contract a
tool answers to, written under
[adr-2026-09-07-tool-answer](../../decisions/adr-2026-09-07-tool-answer.md)
§2: the shape is a published language, the answering tool an open host
service. Produced by the tool itself, on the standard flag
`--describe`: the tool writes an instance as JSON to standard output
and exits with status 0 before any other action, its other arguments
ignored; a reply that exits with another status or does not parse
against the schema below is "cannot answer", not an instance. Consumed
by the compiler
[`../tools/compile_tool.py`](../tools/compile_tool.py), which produces
the tool's skill at the agent's load point from the instance and from
nothing else, stamping the skill `source` (the tool asked) and
`source-digest` (`sha256:` and twelve hex digits over the answer's
bytes as written); and by the `check` step of
[`../processes/skill-rendering.md`](../processes/skill-rendering.md),
which asks the tool again and re-produces the skill to find one that
is not current.

A tool that cannot answer is used through a beside-description: an
instance of this same shape written by hand as a JSON file at
`basis/tools/descriptions/<name>.json`, carrying `stands_beside` (the
tool it stands for) and `tool_owner` (the shop that owns that tool), its
skill produced from the file and gated on the file's digest until the
tool answers. The beside-descriptions of the tools the shop runs but
does not own are the second feature of init-tool-skills, not made
here.

## Schema

```yaml
schema:
  type: object
  fields:
    name: {type: string, pattern: "^[a-zA-Z0-9_-]{1,64}$"}   # the tool's identifier, unique among the product's tools; the skill's name
    description: {type: string}     # what the tool does and when to use it, in one or two sentences
    stands_beside: {type: string, optional: true}   # beside-description only: the path of the tool it stands for
    tool_owner: {type: string, optional: true}      # beside-description only: the shop that owns that tool
    uses:
      type: array
      items:
        type: object
        fields:
          name: {type: string, pattern: "^[a-zA-Z0-9_-]{1,64}$"}   # the use's name for the caller
          description: {type: string}   # what it does: the use's effect, and what it does not do
          invocation: {type: string}    # the exact command line, run from the repository root; an input's placeholder in angle brackets
          input_schema: {type: object}  # what it takes: a JSON Schema object over the inputs — each property carries a `description`; an input is in `required` or carries `default`, which is its omitted treatment; no inputs is an empty `properties`
          returns:                      # what it returns: what the use writes to standard output on success
            type: object
            fields:
              form: {type: string, enum: [json, yaml, text]}
              output_schema: {type: object, optional: true}   # when form is json or yaml: a JSON Schema over the output
              text: {type: string, optional: true}            # when form is text: the stated text form
          failures:                     # how it fails: one entry per failure, in man-pages(7) EXIT STATUS form
            type: array
            items:
              type: object
              fields:
                code: {type: string, enum: [usage, unreadable, unparseable, check-failed, unwritable, no-answer]}
                exit_status: {type: integer}
                condition: {type: string}   # what produces the failure, and what the caller sees
                next: {type: string}        # the caller's next step, one step
```

Field notes. The closed set of failure codes, the same on every run
that fails the same way and the same for every tool: `usage` — the
arguments are not an invocation the tool states; `unreadable` — a
named input path does not exist or cannot be read; `unparseable` — a
named input was read but does not parse as its kind requires;
`check-failed` — the check the use runs found what it checks for, the
findings written out; `unwritable` — an output the use writes could
not be written; `no-answer` — a tool this tool asks gave no answer.
A code stands beside its `condition` and `next`, never in place of
them, and the exit status is not the code: a tool's own error output
carries the code in its message on standard error. The form of
`returns` decides which optional field is present: `output_schema`
with `json` or `yaml`, `text` with `text`. `input_schema` and
`output_schema` are JSON Schema (draft 2020-12) objects as the
agent-facing tool definitions give them; they are carried, not
re-defined here. The vocabulary
(`basis/experience/vocabulary.md`) records each field's name for the
caller; where this type's identifier differs from the vocabulary's
proposed one — `returns` wrapping `output_schema` beside `form` and
`text`; `invocation` present in the answer as well as the skill; a
use's own `name` — the designer role records the mapping there.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Authored under adr-2026-09-07-tool-answer (v3, checked) §2 — the contract artifact the record names — as the enabler the solutions architect role recommended at feat-tool-skills' add-constraints step (constraint (2)) and the first item of guidance/feat-tool-skills-shopsystem-product.md (v1). The shape as §2 fixes it: name and description; per use — what it does, what it takes (the command line and a JSON Schema over the inputs, an omitted input's treatment in `required` or `default`), what it returns (a schema where structured, a stated text form where not), how it fails (a stable code from the closed set here, the exit status, the condition, the next step); the flag `--describe` and its behaviour; the relationship kind; the beside-description's home and its two fields. Field names taken from the vocabulary (v4) where it proposes one; the three that differ named in the field notes for the designer role's mapping. Maker's self-check against the data-type typedef (v3) derived checklist, as define-good-up-front asks: `defines` is `tool-description`, the id the ADR and the compiler reference; producer (the tool on the flag) and consumers (compile_tool.py; skill-rendering's check step) named and linked; every field typed, both enums closed, nesting inline as the typedef's v3 admits. Its commitment — a validator checks an instance from the schema block alone — is met by compile_tool.py, which reads this block and validates each answer against it. Status draft: the state change to approved is the owner's, and constraint (2) binds the delivery on it. |
| 1 | 2026-09-07 | review | Field names screened by the lead-product-designer role against the experience vocabulary (v4, now v5) and the patterns record (v4) — the screen the second consequence of adr-2026-09-07-tool-answer (v3) and this type's field notes assign to that role, by the api guideline's rule 1 (each name read without its implementation, against the vocabulary alone) and rule 3 (the error shape). Result: the names stand — every identifier the vocabulary proposed is the one fixed (`uses`, `failures`, `exit_status`, `condition`, `invocation`), every identifier the ADR or the platform fixes is used as fixed (`name`, `description`, `input_schema`, `code`, `next`), and the three the field notes name as differing are recorded in the vocabulary (v5) as the terms' mappings: `returns` with `form`, `output_schema`, and `text`; `invocation` in the answer; a use's own `name`, entered as "name (of a use)". The failure codes as names for the caller: each says its condition from the word and the vocabulary; their hyphenated form beside the field names' snake_case is recorded as one convention per identifier kind, no change asked. One finding, for the owner's decision, not made here: `owner`, in a beside-description, names the shop that owns the tool the file stands beside — while `owner` in every definition's frontmatter names who owns the document, and a beside-description is written by the consuming shop, not the tool's; a person writing the file will meet the field with the frontmatter habit, and the two readings differ exactly when it matters (the gap is recorded to the tool's owner). Proposed: rename to `tool_owner`, which reads with `stands_beside` as the owner of the tool it stands beside; the cost is nil today — `compile_tool.py` reads neither beside-description field yet, and the beside-descriptions are the second feature's. Default if declined: keep `owner`; the vocabulary's beside-description entry already fixes the reading as the tool's owner. One observation, not a finding on a name: `text` under `returns` holds the statement of the text form, not the output; the vocabulary records that reading, and the skill renders it as "Returns (text):", so the name reads correctly with the record — no change asked. Evidence: one observed run of measured task completion (feat-tool-skills v7): an agent in a fresh context completed four uses on the skill's first invocation and read two failures by their codes from the skill alone — the names in use, met once; the field names' fitness for a tool author writing an answer or a beside-description remains a hypothesis until one is observed doing so. This screen clears the second ruling of feat-tool-skills v8 on the designer's side; the state change stays the owner's. |
| 2 | 2026-09-07 | update | The designer's one finding taken before approval: the beside-description's `owner` renamed `tool_owner` — `owner` in every definition's frontmatter names who owns the document, while a beside-description is written by the consuming shop about another shop's tool; `tool_owner` reads with `stands_beside` as the owner of the tool it stands beside. No producer reads the field yet; the beside-descriptions are the second feature's. |
| 2 | 2026-09-07 | state | `draft` → `approved`: under the authority's bet on init-tool-skills and its standing direction on the proof's pass (the initiative's v8 and v11), as the role-offer type was approved under its bet — the field names screened by the designer role (v1 review row), the contract observed in the running tree parsing the lint's answer (feat-tool-skills v8). Constraint (2) of feat-tool-skills now holds. |
