---
name: shop-msg
description: 'The shop''s messaging command: writes lead-to-BC messages into a Bounded
  Context shop''s inbox and marks mailbox entries consumed on the lead side, over
  the messaging context''s mailboxes. Use it where a process step sends a shop its
  scenarios or consumes a shop''s response; while the shop is frozen these uses are
  described, not run. Tool: `shop-msg`, owned by shopsystem-messaging; it does not
  answer the standard question, so this skill is produced from the description beside
  it, `basis/tools/descriptions/shop-msg.json`. Uses, each with its exact invocation
  below: `send`, `consume`.'
type: skill
id: shop-msg-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: shop-msg
source: basis/tools/descriptions/shop-msg.json
source-digest: sha256:f7e23adddc82
stands-beside: shop-msg
tool-owner: shopsystem-messaging
---

# shop-msg (produced from the description beside `shop-msg`, `basis/tools/descriptions/shop-msg.json`)

The shop's messaging command: writes lead-to-BC messages into a Bounded Context shop's inbox and marks mailbox entries consumed on the lead side, over the messaging context's mailboxes. Use it where a process step sends a shop its scenarios or consumes a shop's response; while the shop is frozen these uses are described, not run.

Uses: [send](#send), [consume](#consume).

## send

Writes one assign_scenarios message into the named Bounded Context shop's inbox under a work id, its body the scenarios read from the given files wrapped under one Feature line, or the complete body pinned by a payload file. Sends nothing else; the six other message types this subcommand takes (request_maintenance, clarify_response, request_bugfix, request_completion_journal, request_scenario_register, nudge) carry their own options and are described when a task first calls for one.

Invocation:

```sh
shop-msg send assign_scenarios --bc <bc> --work-id <work_id> --feature-title <feature_title> --bc-tag <bc_tag> --scenario-file <scenario_file> [--payload <payload>] [--depends-on <depends_on>] [--queue-on-dependency]
```

Takes:
- `<bc>` — the canonical Bounded Context shop name, resolved through the registry (required)
- `<work_id>` — the work id identifying this assignment (required)
- `<feature_title>` — the title of the wrapping `Feature:` line for each scenario; required unless <payload> is given (optional)
- `<bc_tag>` — the shop name used in each scenario's @bc:<name> tag; required unless <payload> is given (optional)
- `<scenario_file>` — the path of a file holding one scenario body; repeat the option for each scenario; required unless <payload> is given (optional)
- `<payload>` — the path of a YAML or JSON file pinning the complete message body, with pre-computed hashes; omitted, the body is built from the other inputs (optional)
- `<depends_on>` — the work id of a prior dispatch this one depends on; omitted, no dependency (optional)
- `<queue_on_dependency>` — when the dependency is not yet closed, queue the dispatch instead of refusing it (omitted: `false` is taken)

Returns (text): the tool's report of the message written, on standard output; exit status 0 — not yet observed by this shop on this branch, the use being one the freeze bars

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 2 | the arguments are not an invocation this tool states — a subcommand or message type missing or unknown, a required option missing, an option without its value; the usage sheet and one line `shop-msg <subcommand>: error: ...` on standard error; nothing is sent or marked | run the invocation the use states, as written |

## consume

Marks one row of a Bounded Context shop's outbox — a response the lead has read — as consumed, so it no longer appears among pending outbox entries. Marks that row only; `consume inbox --lead <lead> --work-id <work_id>` does the same for a row in the lead's own inbox.

Invocation:

```sh
shop-msg consume outbox --bc <bc> --work-id <work_id> --message-type <message_type>
```

Takes:
- `<bc>` — the canonical Bounded Context shop name, resolved through the registry (required)
- `<work_id>` — the work id of the outbox row to consume (required)
- `<message_type>` — the row's message type: clarify, work_done, mechanism_observation, request_completion_journal_response, or request_scenario_register_response (required)

Returns (text): the tool's report of the row marked, on standard output; exit status 0 — not yet observed by this shop on this branch, the use being one the freeze bars

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 2 | the arguments are not an invocation this tool states — a subcommand or message type missing or unknown, a required option missing, an option without its value; the usage sheet and one line `shop-msg <subcommand>: error: ...` on standard error; nothing is sent or marked | run the invocation the use states, as written |
