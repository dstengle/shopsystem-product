---
name: agent-vault
description: 'The credential proxy''s command: starts a process with an Agent Vault
  session so that its HTTP and HTTPS requests route through the vault''s proxy, which
  attaches the credentials the process never sees. Use it to run a command that needs
  a credential the shop holds in the vault — the session-handoff process''s push among
  them. Tool: `agent-vault`, owned by no shop named — the tool''s provenance as shown
  whoever runs it (`agent-vault 0.32.0`, commit e01a925, and its help) names none;
  the lead shop holds the gap as its own until an owner is found; it does not answer
  the standard question, so this skill is produced from the description beside it,
  `basis/tools/descriptions/agent-vault.json`. Uses, each with its exact invocation
  below: `run`.'
type: skill
id: agent-vault-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: agent-vault
source: basis/tools/descriptions/agent-vault.json
source-digest: sha256:41e1a0c58ef3
stands-beside: agent-vault
tool-owner: no shop named — the tool's provenance as shown whoever runs it (`agent-vault
  0.32.0`, commit e01a925, and its help) names none; the lead shop holds the gap as
  its own until an owner is found
---

# agent-vault (produced from the description beside `agent-vault`, `basis/tools/descriptions/agent-vault.json`)

The credential proxy's command: starts a process with an Agent Vault session so that its HTTP and HTTPS requests route through the vault's proxy, which attaches the credentials the process never sees. Use it to run a command that needs a credential the shop holds in the vault — the session-handoff process's push among them.

Uses: [run](#run).

## run

Starts <command> with a vault-scoped session: sets the proxy and root-CA variables on the child so its HTTP and HTTPS clients route through the vault, mints the session token from the on-disk login (or takes it from AGENT_VAULT_TOKEN, AGENT_VAULT_ADDR, and AGENT_VAULT_VAULT in agent mode), then runs the command; everything after `--` is the command. Runs nothing else; the child's exit status is the use's.

Invocation:

```sh
agent-vault run [--vault <vault>] -- <command>
```

Takes:
- `<command>` — the command and its arguments to run under the session, written after `--` (required)
- `<vault>` — the vault the session is scoped to; omitted, the active context's vault (optional)

Returns (text): two lines on standard error, `agent-vault: routing HTTP/HTTPS through MITM proxy (<host>:<port>)` and `agent-vault: agent-vault connected. Starting <command>...`, then the command's own output on its own streams; exit status the command's — 0 when the command exits 0

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 1 | no command follows `--`: on standard error `Error: requires at least 1 arg(s), only received 0` and the usage sheet; nothing is started | write the command after `--` and run the invocation again |
