---
name: bd
description: 'The work register: the shop''s issue database, opened, commented, and
  closed one work item at a time by the command `bd`, its Dolt history pushed to the
  register''s remote at session close. Use it wherever a process step opens, comments
  on, or closes a work item, and to push the register when a session closes. Tool:
  `bd`, owned by no shop named — the tool''s provenance as shown whoever runs it (`bd
  version 1.1.0 (8e4e59d39)` and its help) names none; the lead shop holds the gap
  as its own until an owner is found; it does not answer the standard question, so
  this skill is produced from the description beside it, `basis/tools/descriptions/bd.json`.
  Uses, each with its exact invocation below: `create`, `comment`, `close`, `dolt-push`.'
type: skill
id: bd-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: bd
source: basis/tools/descriptions/bd.json
source-digest: sha256:770e50fadb57
stands-beside: bd
tool-owner: no shop named — the tool's provenance as shown whoever runs it (`bd version
  1.1.0 (8e4e59d39)` and its help) names none; the lead shop holds the gap as its
  own until an owner is found
---

# bd (produced from the description beside `bd`, `basis/tools/descriptions/bd.json`)

The work register: the shop's issue database, opened, commented, and closed one work item at a time by the command `bd`, its Dolt history pushed to the register's remote at session close. Use it wherever a process step opens, comments on, or closes a work item, and to push the register when a session closes.

Uses: [create](#create), [comment](#comment), [close](#close), [dolt-push](#dolt-push).

## create

Opens one work item in the register with the given title and prints its id. Does not close, assign, or link anything; with <dry_run> it prints what would be created and creates nothing.

Invocation:

```sh
bd create --title <title> [--type <type>] [--priority <priority>] [--description <description>] [--dry-run]
```

Takes:
- `<title>` — the work item's title, one line (required)
- `<type>` — the issue type: bug, feature, task, epic, chore, or decision (omitted: `"task"` is taken)
- `<priority>` — the priority, 0 (highest) to 4, or P0 to P4 (omitted: `"2"` is taken)
- `<description>` — the work item's description; omitted, the item has none (optional)
- `<dry_run>` — preview only: print what would be created and create nothing (omitted: `false` is taken)

Returns (text): on standard output, `✓ Created issue: <id> — <title>` then ` Priority: P<n>` and ` Status: open`, <id> the new item's id, `lead-` and five characters; with <dry_run>, `⚠ [DRY RUN] Would create issue:` and the fields, nothing created; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 1 | no title was given; one line on standard error, `Error: title required (or use --file to create from markdown)`; nothing is created | give `--title <title>` and run the invocation again |
| `usage` | 1 | the arguments are not an invocation this tool states — an unknown command or flag, a flag without its value; one line on standard error beginning `Error:` says which, then the tool's usage sheet | run the invocation the use states, as written |

## comment

Appends one comment to the work item <id>, open or closed. Changes nothing else on the item.

Invocation:

```sh
bd comment <id> <text>
```

Takes:
- `<id>` — the work item's id, for example lead-176ti (required)
- `<text>` — the comment's text, quoted as one argument (required)

Returns (text): one line on standard output, `✓ Comment added to <id> — <title>`; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 1 | no work item with <id> exists in the register; one line on standard error, `Error: resolving ID <id>: no issue found matching "<id>"` (`Error: resolving <id>: ...` for comment); nothing changes | give the id of an existing work item (`lead-` and five characters, as `bd create` returned it) and run the invocation again |
| `usage` | 1 | no text was given; one line on standard error, `Error: no comment text provided (use positional args, --stdin, or --file)`; nothing is added | give the comment's text after the id and run the invocation again |
| `usage` | 1 | the arguments are not an invocation this tool states — an unknown command or flag, a flag without its value; one line on standard error beginning `Error:` says which, then the tool's usage sheet | run the invocation the use states, as written |

## close

Closes the work item <id> with the given reason, which the item keeps as its close reason. Closing an item already closed records the new reason and exits 0 as well.

Invocation:

```sh
bd close <id> --reason <reason>
```

Takes:
- `<id>` — the work item's id, for example lead-176ti (required)
- `<reason>` — why the item closes, one line, kept on the item as its close reason (required)

Returns (text): one line on standard output, `✓ Closed <id> — <title>: <reason>`; exit status 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 1 | no work item with <id> exists in the register; one line on standard error, `Error: resolving ID <id>: no issue found matching "<id>"` (`Error: resolving <id>: ...` for comment); nothing changes | give the id of an existing work item (`lead-` and five characters, as `bd create` returned it) and run the invocation again |
| `usage` | 1 | the arguments are not an invocation this tool states — an unknown command or flag, a flag without its value; one line on standard error beginning `Error:` says which, then the tool's usage sheet | run the invocation the use states, as written |

## dolt-push

Pushes the register's local Dolt commits to its configured remote (`origin`, per `bd dolt remote list`), as the session-handoff process's land step does. Pushes nothing but the register; needs a remote configured and, for a hosted remote, DOLT_REMOTE_USER and DOLT_REMOTE_PASSWORD in the environment.

Invocation:

```sh
bd dolt push
```

Takes: nothing — the use has no input.

Returns (text): the push's report on standard output; exit status 0 — the form of the report is what the tool's help states for the push, not yet observed by this shop on this branch

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unwritable` | 1 | the remote could not be written: none is configured, the credentials are missing, or the remote refuses the push; the reason on standard error — the tool's help names `--force` for a remote whose working set has uncommitted changes | configure the remote (`bd dolt remote add <name> <url>`) or set the credentials, then run the invocation again; do not force without the lead-pm's say |
| `usage` | 1 | the arguments are not an invocation this tool states — an unknown command or flag, a flag without its value; one line on standard error beginning `Error:` says which, then the tool's usage sheet | run the invocation the use states, as written |
