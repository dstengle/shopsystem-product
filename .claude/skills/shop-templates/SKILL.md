---
name: shop-templates
description: 'The templates context''s command over the role-prompt templates it ships
  as package data: lists the template names and prints one template''s text. Use it
  to read a canonical role template rather than a copy. Its other subcommands — bootstrap,
  update, check-writing-skills — scaffold or check a shop''s repository and are described
  when a task first calls for one. Tool: `shop-templates`, owned by shopsystem-templates;
  it does not answer the standard question, so this skill is produced from the description
  beside it, `basis/tools/descriptions/shop-templates.json`. Uses, each with its exact
  invocation below: `list`, `show`.'
type: skill
id: shop-templates-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: shop-templates
source: basis/tools/descriptions/shop-templates.json
source-digest: sha256:66641bd47172
stands-beside: shop-templates
tool-owner: shopsystem-templates
---

# shop-templates (produced from the description beside `shop-templates`, `basis/tools/descriptions/shop-templates.json`)

The templates context's command over the role-prompt templates it ships as package data: lists the template names and prints one template's text. Use it to read a canonical role template rather than a copy. Its other subcommands — bootstrap, update, check-writing-skills — scaffold or check a shop's repository and are described when a task first calls for one.

Uses: [list](#list), [show](#show).

## list

Prints the names of the templates the installed package carries, one per line. Reads only.

Invocation:

```sh
shop-templates list
```

Takes: nothing — the use has no input.

Returns (text): one template name per line on standard output — today bc-implementer, bc-reviewer, lead-architect, lead-pm, lead-po; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 2 | the arguments are not an invocation this tool states — no subcommand, an unknown one, or a required argument missing; the usage sheet and one line `shop-templates <subcommand>: error: ...` on standard error; nothing is printed | run the invocation the use states, as written |

## show

Prints the named template's text, byte-recoverable from the installed package data. Reads only.

Invocation:

```sh
shop-templates show <name>
```

Takes:
- `<name>` — the template's name, one of those `list` prints, for example lead-pm (required)

Returns (text): the template's markdown text on standard output; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 1 | no template of that name: one line on standard error, `shop-templates show: no template named '<name>'. Available: <names>`; nothing on standard output | give one of the names `list` prints and run the invocation again |
| `usage` | 2 | the arguments are not an invocation this tool states — no subcommand, an unknown one, or a required argument missing; the usage sheet and one line `shop-templates <subcommand>: error: ...` on standard error; nothing is printed | run the invocation the use states, as written |
