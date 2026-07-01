# Slice 3 — Leg A: bc-base availability recon + U5 / AC-proxy-cred

Epic lead-6k1r. Branch `fabro-spike`. fabro v0.254.0. Date 2026-07-01.
All commands run on the lead host; real (non-dry-run) LLM calls authorized for this spike.

---

## JOB 1 — bc-base / container availability recon

**VERDICT: YES — a bootable AND an already-booted BC container are available.**

### Evidence

`docker images` — multiple bc-base images already built locally (contra a strict
reading of "un-rebuildable" ADR-022: the *artifacts already exist*, no rebuild needed):

```
ghcr.io/dstengle/shopsystem-bc-base:latest            2.1GB
ghcr.io/dstengle/shopsystem-bc-base:v0.2.2 .. v0.3.6  (v0.2.2,2.3,2.5,2.6,2.7,2.8,3.1,3.5,3.6)
ghcr.io/dstengle/shopsystem-bc-base:interim-claude-adr020
ghcr.io/dstengle/shopsystem-bc-base:prev-pathkeyed
bc-base-v022-test:local
ghcr.io/dstengle/shopsystem-bc-lead:latest / :v0.3.7
```

`docker manifest inspect ghcr.io/dstengle/shopsystem-bc-base:latest` → **PULLABLE**
from the registry (returns a manifest), so even a fresh host can obtain it.

`docker ps -a` — BC containers **already running**:

```
bc-shopsystem-bc-launcher   159ea9eed6e7   Up 8 days (healthy)
bc-shopsystem-messaging     159ea9eed6e7   Up 8 days (healthy)
bc-shopsystem-scenarios     159ea9eed6e7   Up 8 days (healthy)
bc-shopsystem-lead          96116d38f37a   Up 3 days (unhealthy)
bc-shopsystem-templates     6bab48d27a39   Up 2 days (unhealthy)
bc-testproduct3-lead        shopsystem-bc-lead:latest  Up 8 hours (unhealthy)
```

Launch tooling present on PATH: `bc-container` (subcommands
launch|attach|inject|monitor|stop|status|start-agent|list|manifest), plus
`bc-emit`, `shop-msg`, `shop-templates`. Supporting infra up: `shopsystem-postgres`,
`shopsystem-agent-vault` (both Up 8 days healthy).

**Conclusion:** Slice-4 e2e is NOT blocked on bc-base. Three healthy `159ea…`
BC containers are already online; the `:latest` image is both present locally and
pullable; `bc-container launch` is available to boot a fresh one. Some named
containers report `unhealthy` (bc-shopsystem-lead/templates, bc-testproduct3-lead)
— usable-or-recoverable via `bc-container start-agent`, but the three healthy
`bc-launcher/messaging/scenarios` are the safe target.

---

## JOB 2 — U5 / AC-proxy-cred (the load-bearing unknown)

**VERDICT: SPLIT / BLOCKED.**
- Outbound authenticated **TOOL** call through the proxy: **PASS** at the
  environment/raw-proxy tier (github). But **NOT** exercised through a fabro agent
  node, because…
- Agent node's **OWN LLM** call through the proxy: **FAIL** with stock fabro.
  The LLM call is the prerequisite for everything the node does, and it fails
  first, so the node never reaches its tool call.

**Root cause:** header-shape mismatch. The fleet agent-vault injects the Anthropic
credential as an **OAuth Bearer** (`CLAUDE_OAUTH`), and only rewrites
**OAuth-shaped** requests. fabro's Anthropic adapter authenticates with
**`x-api-key`** (`ANTHROPIC_API_KEY`) and has **no** Anthropic-OAuth mode. The
proxy leaves `x-api-key` untouched, so Anthropic sees the dummy and rejects it.

### Server bring-up (live local fabro server)

```
# ~/.fabro/settings.toml auth = dev-token; server refuses to start without secrets:
export SESSION_SECRET="$(head -c32 /dev/urandom | base64)"
export FABRO_DEV_TOKEN=<token from ~/.fabro/auth.json servers[...].token>
fabro --no-upgrade-check server start
# -> Server started (pid …) on 127.0.0.1:32276 ; curl /health -> {"status":"ok"}
```
(The pre-existing `fabro-fabro-1` docker container, v0.227.0, was NOT listening on
32276 — `curl` connection-refused — so a fresh CLI-managed server was stood up.)
Server process inherits `HTTPS_PROXY=http://…@agent-vault:14322` from parent env
(verified via `/proc/<pid>/environ`). No real API key present.

### What the fleet agent-vault actually injects (`agent-vault vault discover`)

```
Services:  github-git (github.com), github-api (api.github.com),
           claude-api (api.anthropic.com), claude-platform, claude-mcp-proxy
Available Credentials:  CLAUDE_OAUTH, GITHUB_TOKEN, GITHUB_USERNAME
```

### Proxy injection — direct probes (dummy creds only)

GitHub — proxy injects `GITHUB_TOKEN`, **all succeed**:
```
GH_TOKEN=ghp_DUMMY gh api user                 -> {"login":"dstengle", ...}   OK
git ls-remote https://github.com/dstengle/shopsystem-templates -> refs listed  OK
curl https://api.github.com/user -H "Authorization: Bearer ghp_DUMMY" -> login OK
```

Anthropic — **x-api-key is NOT rewritten** (dummy passes through, rejected):
```
curl https://api.anthropic.com/v1/models -H "x-api-key: sk-ant-DUMMY-not-real" \
     -H "anthropic-version: 2023-06-01"
  -> {"type":"error","error":{"type":"authentication_error","message":"invalid x-api-key"}}
```

Anthropic — **OAuth-shaped request IS rewritten** (dummy Bearer → real, 200):
```
curl https://api.anthropic.com/v1/messages \
     -H "authorization: Bearer dummy-oauth-token" \
     -H "anthropic-version: 2023-06-01" \
     -H "anthropic-beta: oauth-2025-04-20" \
     -H "content-type: application/json" \
     -d '{"model":"claude-haiku-4-5","max_tokens":16,"messages":[{"role":"user","content":"say OK"}]}'
  -> {"model":"claude-haiku-4-5-20251001", ... "content":[{"type":"text","text":"OK"}] ...}   200 OK
```
=> The proxy CAN authenticate Anthropic, but ONLY for `Authorization: Bearer` +
`anthropic-beta: oauth-2025-04-20`. Not for `x-api-key`.

openai / gemini — **no credential in fleet vault**, dummies rejected
(`curl api.openai.com/v1/models` → invalid_api_key; gemini → API key not valid).
So Anthropic is the only viable LLM provider here, and only via OAuth shape.

### fabro adapter capability (binary `strings ~/.local/bin/fabro`)

- Anthropic auth material: only `ANTHROPIC_API_KEY`, hardcoded
  `https://api.anthropic.com/v1`. No `ANTHROPIC_AUTH_TOKEN`, no
  `ANTHROPIC_BASE_URL`, no anthropic-oauth env var.
- Auth enum: `LegacyAuthDetails::ApiKey`, `LegacyAuthDetails::CodexOauth`
  (`codex_oauth`). OAuth exists **only for OpenAI Codex**, NOT Anthropic.
- Adapters: `anthropic | openai | gemini | openai_compatible`. A `base_url`
  field exists (used by `openai_compatible`, `GITHUB_BASE_URL`, `SLACK_BASE_URL`)
  — this is the remediation lever (below).

### fabro model test (through the proxy, server has dummy key)

```
fabro provider login --provider anthropic --api-key-stdin   # DUMMY key
  -> Validating API key... Authentication error for anthropic: invalid x-api-key   (rejected, not stored)
# restart server with a placeholder ANTHROPIC_API_KEY so "configured" passes:
export ANTHROPIC_API_KEY="sk-ant-DUMMY-placeholder-proxy-injects"; fabro server restart
fabro model test --model haiku
  -> claude-haiku-4-5 … RESULT: error: Authentication error for anthropic: invalid x-api-key
```

### fabro run — REAL non-dry-run agent node (the actual U5 test)

Minimal workflow `u5probe.fabro` (start → 1 real `class="coding"` node → done/fail).
The coding node's prompt: run `gh api user` once and report the `login`. This is
designed to exercise BOTH the node's own LLM call AND an outbound authenticated
tool call.

```
fabro run u5probe.fabro --environment local --auto-approve
    Run: 01KWDP7WHCBENHZ8CXY8K7JZRJ
    ✓ Start  0ms
    ✗ u5-proxy-probe
    Error: LLM error: Authentication error for anthropic: invalid x-api-key
```

Variant explicitly requested — `agent-vault run -- fabro run` (wrap the CLI):
```
agent-vault run -- fabro run u5probe.fabro --environment local --auto-approve
  agent-vault: routing HTTP/HTTPS through MITM proxy (agent-vault:14322)
    ✗ u5-proxy-probe
    Error: LLM error: Authentication error for anthropic: invalid x-api-key
```
**The wrapper does NOT help.** Reason: the LLM call is made by the fabro SERVER
process (provider='local', already has HTTPS_PROXY), not by the wrapped CLI; and
the failure is the header shape (x-api-key), which no amount of proxy-wrapping
changes. The agent node never reached its `gh api user` tool call — the model call
gates it and fails first — so the agent-node tool-call tier is UNPROVEN through
fabro (proven only at the raw curl/gh/git tier).

> NOTE on run status: the run reports `Status: SUCCEEDED` despite the node failing,
> because the minimal graph's single Msquare terminal is marked regardless — the
> known U1 terminal-status quirk (see fabro-defs/README). Node outcome (`✗`,
> "LLM error") is the ground truth, not the run banner.

### Invariant #2 verdict

Invariant #2 ("credentials via agent-vault, fabro vault stays __PLACEHOLDER__")
**HOLDS at the tool-call tier** (github injection proven with placeholders) but
**does NOT hold at the agent-node LLM tier as-is**, because stock fabro speaks
`x-api-key` to Anthropic and the fleet vault only injects OAuth-Bearer.

---

## BLOCKER + remediation candidates (for Slice 4)

**Blocker:** fabro agent nodes cannot make their own LLM call through the fleet
agent-vault, because fabro's Anthropic adapter uses `x-api-key` and the vault
injects `CLAUDE_OAUTH` (Bearer + `anthropic-beta: oauth-2025-04-20`) only.

Candidate fixes, cheapest first:
1. **base_url shim (most promising, self-contained):** stand up a tiny local
   reverse proxy; point fabro's Anthropic (or an `openai_compatible`) provider at
   it via `base_url`. The shim strips `x-api-key`, adds `Authorization: Bearer
   <dummy>` + `anthropic-beta: oauth-2025-04-20`, and forwards to
   `api.anthropic.com` through `HTTPS_PROXY` (which injects the real OAuth). Proven
   viable by the curl OAuth probe above. Need to confirm fabro exposes an
   Anthropic `base_url` override (only `openai_compatible` base_url is confirmed in
   strings; may require running Anthropic-behind-openai_compatible).
2. **Vault-side (owner action):** add an `x-api-key` injection rule / an
   `ANTHROPIC_API_KEY` credential to the fleet `claude-api` service so x-api-key
   requests are rewritten. Out of this leg's scope (owner-level vault change) and
   changes the credential shape the fleet standardized on.
3. **fabro-side:** an Anthropic-OAuth auth mode in fabro (does not exist in
   v0.254.0; upstream feature).

Recommendation: pursue (1) for Slice 4; it keeps the fabro vault at
`__PLACEHOLDER__` and routes the real credential through agent-vault, preserving
invariant #2.

## Reproduction furniture
- Env restore: `/tmp/claude-1000/-workspace/<sess>/scratchpad/fabro-env.sh`
  (SESSION_SECRET, FABRO_DEV_TOKEN, dummy ANTHROPIC_API_KEY).
- Probe workflow: `/tmp/claude-1000/-workspace/<sess>/scratchpad/u5probe.fabro`.
- Server: `fabro server start` on 127.0.0.1:32276 (left running; `fabro server stop`
  to tear down).
