# anthropic-oauth-shim — closes Fabro spike U5

A ~180-line Python-stdlib reverse proxy that lets a **fabro** agent node make its
**own** LLM call through the fleet **agent-vault** proxy, with **nothing real**
stored in fabro's vault. This is the durable artifact that closes **U5**
(epic lead-6k1r, Slice 3, SHIM leg).

## The problem it solves

- fabro's `anthropic` adapter authenticates with `x-api-key: <ANTHROPIC_API_KEY>`
  against a hardcoded `https://api.anthropic.com/v1`.
- The fleet agent-vault MITM proxy injects the **real** Anthropic credential
  **only** for OAuth-Bearer-shaped requests
  (`Authorization: Bearer <dummy>` + `anthropic-beta: oauth-2025-04-20`).
  It leaves `x-api-key` untouched.
- Result: stock fabro's LLM call is rejected → `401 invalid x-api-key`, and the
  agent node never reaches its outbound tool call. (See `../../03a-proxycred-recon.md`.)

## How the shim fixes it

`shim.py` is a local reverse proxy. On each request it:

1. **STRIPS** the incoming `x-api-key` (the dummy placeholder fabro holds never
   leaves the process) and any incoming `authorization`.
2. **ADDS** `Authorization: Bearer <dummy>` and `anthropic-beta: oauth-2025-04-20`
   (merged with any existing `anthropic-beta`), keeping `anthropic-version` +
   `content-type`.
3. **FORWARDS** to `https://api.anthropic.com` through the environment
   `HTTPS_PROXY`, so agent-vault injects the **real** OAuth credential on the wire.
4. **STREAMS** the response (SSE or JSON) straight back.

Python's `urllib` picks up `HTTPS_PROXY` and `SSL_CERT_FILE` (the agent-vault
MITM CA) from the environment automatically — no code config, no secrets.

## fabro config mechanism used — PREFERRED path

The `anthropic` adapter **accepts a `base_url` override**, so we take the
simplest route: point the built-in provider at the shim. The adapter still speaks
**native Anthropic Messages** format in both directions, so **NO OpenAI<->Anthropic
translation is needed** (the `openai_compatible` fallback was not required).

Append to `~/.fabro/settings.toml` (full copy in `settings.toml.snippet`):

```toml
[llm.providers.anthropic]
base_url = "http://127.0.0.1:8788/v1"
```

`GET /api/v1/providers` then reports `anthropic … base_url=http://127.0.0.1:8788/v1`,
and `fabro model test --model haiku` returns `ok`.

## Outbound tool-call env (for `gh`/`curl` inside a node)

A node's own **tool** call (e.g. `gh api user`) runs inside fabro's sandbox,
which starts with a **cleaned 9-var environment** (no `HTTPS_PROXY`, no CA).
Deliver the proxy env via the **global** `[run.environment.env]` overlay — **not**
`[environments.<slug>]`, which fabro auto-migrates into a file whose `[env]`
table is silently dropped for the local ACP sandbox:

```toml
[run.environment.env]
HTTPS_PROXY = "http://<agent-vault-proxy>"
HTTP_PROXY  = "http://<agent-vault-proxy>"
NO_PROXY    = "localhost,127.0.0.1,agent-vault"
SSL_CERT_FILE       = "/home/vscode/.agent-vault/mitm-ca.pem"
NODE_EXTRA_CA_CERTS = "/home/vscode/.agent-vault/mitm-ca.pem"
```

Run with `--environment local` (a one-line `~/.fabro/environments/local.toml`
containing `provider = "local"` selects the provider; the overlay layers on top).

The ACP coding agent **strips credential-shaped env vars** (`GH_TOKEN`,
`GITHUB_TOKEN`, `ANTHROPIC_API_KEY`, …) from the shell tool's environment, so a
git token cannot be delivered via env. Supply a **dummy token inline** in the
command — the proxy injects the real one on the wire:

```
GH_TOKEN=ghp_dummy_proxy_injects_real gh api user   # -> {"login":"dstengle", ...}
```

## Invariant #2 — preserved

Credentials flow via agent-vault, never fabro's secrets:

- fabro's own vault (`../vaults/default/secrets.json`) stays `__PLACEHOLDER__`
  only for both `ANTHROPIC_API_KEY` and `GITHUB_TOKEN`.
- The server's `ANTHROPIC_API_KEY` env is a dummy
  (`sk-ant-DUMMY-placeholder-proxy-injects`); the shim discards it and never
  forwards it.
- The `gh` token supplied to the node is a dummy; agent-vault substitutes the
  real one on the wire.

Nothing real is ever written into or read from fabro. The shim holds no secret —
it only rewrites header *shape*.

## Run it

```bash
# 1. Start the shim inside an agent-vault-enabled shell:
./launch-shim.sh                       # 127.0.0.1:8788

# 2. Confirm the shim (dummy x-api-key -> real 200 completion):
curl -sS http://127.0.0.1:8788/v1/messages \
  -H "x-api-key: sk-ant-DUMMY" -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-haiku-4-5","max_tokens":16,"messages":[{"role":"user","content":"say OK"}]}'

# 3. Apply settings.toml.snippet, restart the fabro server, then:
fabro model test --model haiku                                   # -> ok
fabro run u5probe.fabro --environment local --auto-approve       # -> ✓ u5-proxy-probe, login=dstengle
```

## Files

- `shim.py` — the reverse proxy (stdlib only).
- `launch-shim.sh` — starts the shim (warns if `HTTPS_PROXY` is unset).
- `settings.toml.snippet` — exact `~/.fabro/settings.toml` additions (proxy redacted).
- `u5probe.fabro` — the U5 probe workflow (LLM via shim + `gh` via proxy).
