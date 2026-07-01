# Slice 3 — SHIM leg: U5 CLOSED (PASS)

Epic lead-6k1r. Branch `fabro-spike`. fabro v0.254.0. Date 2026-07-01.
Real (non-dry-run) LLM + tool calls through agent-vault, authorized for this spike.

Builds on `03a-proxycred-recon.md` (root cause) — this leg delivers the fix.

---

## VERDICT

**U5 = PASS.** A fabro agent node's OWN LLM call now succeeds through agent-vault,
AND the node's outbound authenticated tool call (`gh api user`) succeeds through
the same proxy — with fabro's vault holding only `__PLACEHOLDER__`.

Clean `fabro run` output (final probe):

```
Workflow: U5Probe (4 nodes, 3 edges)
    Run: 01KWDQNE9ZKQNTJSQ7KCYJ5CEK
    Sandbox: local (ready in 0ms)
    ✓ Start  0ms
    ✓ u5-proxy-probe  $0.01   4s
    ✓ Exit: SUCCEEDED  0ms
=== Output ===
**Outcome: ok**
**Login value: `dstengle`**
The dummy token ghp_dummy_proxy_injects_real was transparently replaced by
agent-vault with the real GitHub token on the wire, and `gh api user` succeeded.
```

Before (stock fabro, 03a): `✗ u5-proxy-probe  Error: LLM error: Authentication
error for anthropic: invalid x-api-key`. The LLM call is now `✓`.

---

## The fix — anthropic-oauth-shim

Durable artifact: `fabro-defs/anthropic-oauth-shim/` (shim.py, launch-shim.sh,
README.md, settings.toml.snippet, u5probe.fabro).

A ~180-line Python-stdlib reverse proxy. Per request it STRIPS `x-api-key`, ADDS
`Authorization: Bearer <dummy>` + `anthropic-beta: oauth-2025-04-20` (keeping
`anthropic-version`), and FORWARDS to `https://api.anthropic.com` through the
environment `HTTPS_PROXY` — where agent-vault injects the REAL OAuth credential.
`urllib` inherits `HTTPS_PROXY` + `SSL_CERT_FILE` (MITM CA) from the env; the shim
stores no secret, only rewrites header shape.

### Step-1 confirmation (direct curl through the shim)

Dummy `x-api-key` → shim → real 200 completion (both non-streaming and SSE):

```
curl http://127.0.0.1:8788/v1/messages -H "x-api-key: sk-ant-DUMMY" \
  -H "anthropic-version: 2023-06-01" -H "content-type: application/json" \
  -d '{"model":"claude-haiku-4-5","max_tokens":16,"messages":[{"role":"user","content":"say SHIM-OK"}]}'
  -> {"model":"claude-haiku-4-5-20251001", ... "content":[{"type":"text","text":"SHIM-OK"}] ...}  HTTP 200
# stream:true -> event: message_start / content_block_delta ... STREAM-OK   (SSE relayed live)
```

---

## fabro config mechanism — PREFERRED path (anthropic base_url), NO translation

Empirically, the `anthropic` adapter **accepts a `base_url` override** (fabro
exposes it as an "Operator-set base URL override" in the provider catalog; the
OpenAPI `ProviderCatalogEntry` schema carries `adapter ∈ {anthropic, openai,
gemini, openai_compatible}` + `base_url`). Docs
(`docs.fabro.sh/core-concepts/models`) confirm the `[llm.providers.<id>]` table
with `adapter` + `base_url`. So we override the built-in provider:

```toml
[llm.providers.anthropic]
base_url = "http://127.0.0.1:8788/v1"
```

Because the adapter stays `anthropic`, the shim speaks **native Anthropic Messages**
format in both directions — **format translation was NOT needed** (the
`openai_compatible` fallback was avoided entirely).

Verification:
- `GET /api/v1/providers` → `anthropic … base_url=http://127.0.0.1:8788/v1`.
- `fabro model test --model haiku` → `ok` (was `invalid x-api-key`).

---

## Outbound tool-call env — the harder half

A node's tool call runs inside fabro's sandbox, which starts with a **cleaned
9-var env** (only `FABRO_CONFIG, FABRO_LOG_DESTINATION, HOME=/home/vscode, PATH,
PWD=/workspace, SHLVL, TERM, USER, _`). No `HTTPS_PROXY`, no CA → `gh`/`curl` can't
reach agent-vault. Two empirical traps found and cleared:

1. **`[env]` in the environment FILE (`~/.fabro/environments/local.toml`) is
   silently dropped** for the local ACP sandbox (effective `run.environment.env`
   stayed `{}`). Also, **`[environments.<slug>]` in settings.toml AUTO-MIGRATES**
   into that file — so it appears to work exactly once (pre-migration read) then
   breaks. The reliable lever is the **global** overlay, which does not migrate:

   ```toml
   [run.environment.env]
   HTTPS_PROXY = "…agent-vault…"
   HTTP_PROXY  = "…agent-vault…"
   NO_PROXY    = "localhost,127.0.0.1,agent-vault"
   SSL_CERT_FILE       = "/home/vscode/.agent-vault/mitm-ca.pem"
   NODE_EXTRA_CA_CERTS = "/home/vscode/.agent-vault/mitm-ca.pem"
   ```
   Run with `--environment local` (one-line `provider = "local"` file selects the
   provider; the overlay layers on top). Confirmed via the run's own
   `run.created` event: `run.environment.env` now carries all keys, and the raw
   shell tool output shows `HTTPS_PROXY=http://…@agent-vault:14322`.

2. **The ACP coding agent STRIPS credential-shaped env vars** (`GH_TOKEN`,
   `GITHUB_TOKEN`, `ANTHROPIC_API_KEY`, …) from the shell tool — proven: with
   `GH_TOKEN` set in the overlay, the shell still saw `GH_TOKEN=` empty while
   `HTTPS_PROXY`/`FOO_SPIKE` passed through. So a git token must be supplied
   **inline in the command**; the proxy injects the real one:

   ```
   GH_TOKEN=ghp_dummy_proxy_injects_real gh api user   -> {"login":"dstengle", ...}
   ```
   (In the run event the agent logs the command as `REDACTED gh api user` — it
   redacts the inline dummy but executes it; exit 0, real identity returned.)

This env-plumbing is orthogonal to the credential-shape shim, and note: in the
actual Slice-4 target, BCs run inside **bc-launcher containers** that already
carry `HTTPS_PROXY` — so this local-sandbox env gap is specific to fabro's
`provider=local` and does not necessarily bind the in-container orchestration.

---

## Invariant #2 — PRESERVED (verified)

- fabro's own vault `fabro-defs/vaults/default/secrets.json` = `__PLACEHOLDER__`
  only, for both `ANTHROPIC_API_KEY` and `GITHUB_TOKEN` (unchanged).
- Server `ANTHROPIC_API_KEY` env = dummy `sk-ant-DUMMY-placeholder-proxy-injects`;
  the shim discards it and never forwards it.
- The `gh` token handed to the node is a dummy; agent-vault substitutes the real
  one on the wire.

No real secret is written to or read from fabro. The real credential lives only
in agent-vault and is injected on the wire.

---

## Reproduction

1. `fabro-defs/anthropic-oauth-shim/launch-shim.sh`  → shim on 127.0.0.1:8788.
2. Append `fabro-defs/anthropic-oauth-shim/settings.toml.snippet` to
   `~/.fabro/settings.toml`; `provider = "local"` in `~/.fabro/environments/local.toml`.
3. `fabro server restart` (with `SESSION_SECRET` + `FABRO_DEV_TOKEN` +
   dummy `ANTHROPIC_API_KEY`; see `scratchpad/fabro-env.sh`).
4. `fabro run fabro-defs/anthropic-oauth-shim/u5probe.fabro --environment local --auto-approve`
   → `✓ u5-proxy-probe`, outcome ok, login `dstengle`.

Passing runs: 01KWDQMQR0E4DR9851RJKFXHFN, 01KWDQNE9ZKQNTJSQ7KCYJ5CEK.
