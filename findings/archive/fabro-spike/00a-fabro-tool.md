# Slice 0 — Leg A: The fabro tool, characterized empirically

Epic **lead-6k1r**. Branch `fabro-spike`. All work done in scratchpad
(`/tmp/claude-1000/.../scratchpad`); nothing installed into the repo. Date 2026-07-01.

## TL;DR

- **fabro is a real, closed-ish tool: a single Rust binary shipped via GitHub
  Releases at `fabro-sh/fabro`** ("⚒️ the open source dark software factory for
  expert engineers", site https://fabro.sh, docs https://docs.fabro.sh). It is
  **NOT a pip/npm package** — `pip install fabro` 404s on PyPI. That is why the
  earlier attempts to "find fabro" turn up nothing installed.
- **Latest release = `v0.254.0` (2026-06-04)** — exactly the version the prior
  f6ta spike (ADR-030) reported using. Nightlies run up to `v0.278.0-nightly.0`.
  The prior spike's detailed claims (dev-token auth, checkpoint-on-node,
  `completed_nodes`) are corroborated by this release.
- I **installed 0.254.0, stood up an ephemeral local server, and ran a trivial
  workflow end-to-end (`--dry-run`, SUCCEEDED)**.
- **Secret seam is now precisely located** (see §4) — and the agent-vault bypass
  pattern is already demonstrated working (§4.3).

## 1. Discovery — what fabro is in THIS environment

Nothing named fabro was pre-installed:

```
which fabro            -> (nothing)
pip show fabro         -> WARNING: Package(s) not found: fabro
pip install fabro -vvv -> GET https://pypi.org/simple/fabro/  => 404  (genuinely not on PyPI)
find / -iname '*fabro*' -> only this repo's findings/notes + the workflow script
```

Runtimes present: **Python 3.11.15**, pip 24.0, `gh` 2.95.0, pipx. No node/npm/go/cargo.

The environment routes all egress through an **agent-vault proxy**
(`HTTPS_PROXY=http://av_agt_...:fleet@agent-vault:14322`). PyPI works through it
(downloaded `requests` fine) — fabro simply isn't published there.

**How the shop's own packages install (the clue that cracked it):** the installed
`shop-templates`, `shopsystem-bc-launcher`, `shopsystem-messaging` come from
`git+https://github.com/dstengle/...` (per their `dist-info/direct_url.json`) — a
GitHub-source model, not a private PyPI. There is no private package index.

**What fabro actually is** (confirmed via web search + fetching the real docs):
`fabro-sh/fabro`, installed from GitHub Releases. Official install methods
(https://fabro.sh/install.sh): Homebrew tap, or a bash script that shells out to
`gh release download`. Requires `gh`.

## 2. Install — exact steps that worked

`gh` was present but unauthenticated. The agent-vault proxy injects GitHub creds
**on the wire**, so setting a dummy `GH_TOKEN` and letting the proxy handle auth
works:

```
export GH_TOKEN=dummy_token_proxy_injects      # proxy injects the real token
gh release list --repo fabro-sh/fabro          # -> v0.254.0 (Latest), nightlies to v0.278.0
gh release download v0.254.0 --repo fabro-sh/fabro \
   --pattern "fabro-x86_64-unknown-linux-gnu.tar.gz" --dir <scratch>
tar xzf fabro-x86_64-unknown-linux-gnu.tar.gz
mv fabro-x86_64-unknown-linux-gnu/fabro ~/.fabro/bin/fabro && chmod +x ~/.fabro/bin/fabro
export PATH="$HOME/.fabro/bin:$PATH"
fabro --version    # -> fabro 0.254.0 (497aaba 2026-06-04)
```

Release assets (per `gh release view`): `fabro-{aarch64-apple-darwin,
x86_64-unknown-linux-gnu, aarch64-unknown-linux-gnu, *-linux-musl}.tar.gz` (+ .sha256).
Binary is ~47 MB compressed. Single self-contained executable.

> For the in-container BC spike: bake this `gh release download` step (or vendor
> the tarball) into the fabro-launcher image. Auth for the download rides
> agent-vault's on-wire injection, same as everything else.

## 3. Standing up an ephemeral LOCAL server + running a workflow

### 3.1 CLI shape (top-level `fabro --help`)

Rich CLI. Relevant commands: `run | create | start | attach | events | logs |
resume | rewind | fork | wait | steer | validate | graph | server | install |
secret | variable | provider | workflow | repo | mcp | doctor | settings`.
Notable: `run` takes `--dry-run` (**simulated LLM backend** — runs with no creds),
`--auto-approve` (auto-passes human gates), `--server <url|unix-socket>`, `-I KEY=VALUE`
inputs, `--goal` override, `-d/--detach`, `--environment`.

### 3.2 Bootstrap the server (non-interactive)

`fabro server start` alone fails: *"no settings.toml configured."* Bootstrap it with
the hidden non-interactive install flags (avoids the browser wizard):

```
export FABRO_STORAGE_DIR=<scratch>/fabro-storage
export GH_TOKEN=dummy_proxy GITHUB_TOKEN=dummy_proxy
fabro install --non-interactive --skip-llm \
   --github-strategy token --github-username spike-dummy \
   --overwrite-settings --storage-dir "$FABRO_STORAGE_DIR"
```

Output (verbatim, load-bearing):
```
✔ Session secret generated
✔ Development token generated
✔ Saved 2 runtime secrets to <storage>/server.env
✔ Saved 1 workflow-visible secrets to <storage>/vaults/default/secrets.json
✔ Wrote ~/.fabro/settings.toml
✔ Server running at http://127.0.0.1:32276
✔ Auth (Dev Token): fabro_dev_fb62f24675f4b3859d1eac77a4a0f97797ff6c1d4dfeb09ea58de880205632e1
```

`--skip-llm` works (LLM only needed for real, non-dry-run agent nodes). The
`--github-*` flags are **mandatory even with `--skip-llm`**; the token strategy
calls `gh auth token` internally, so `GH_TOKEN`/`GITHUB_TOKEN` in the env is what
satisfies it. `fabro server start` also accepts `--foreground`, `--bind
<IP:port|unix-socket-path>`, `--no-web`, `--storage-dir`, `--max-concurrent-runs`,
`--config <settings.toml>` for a fully headless ephemeral server.

### 3.3 Dotfile / config formats (all TOML + DOT)

**`~/.fabro/settings.toml`** (server + CLI target — generated):
```toml
_version = 1
[cli.target]
type = "http"
url = "http://127.0.0.1:32276"
[server.api]
url = "http://127.0.0.1:32276/api/v1"
[server.auth]
methods = ["dev-token"]
[server.integrations.github]
strategy = "token"
[server.listen]
address = "127.0.0.1:32276"
type = "tcp"                 # <- also supports unix socket
[server.web]
enabled = true
url = "http://127.0.0.1:32276"
```

**Per-project `.fabro/` tree** (from `fabro repo init`):
```
.fabro/project.toml
.fabro/workflows/<name>/workflow.fabro   # the graph (Graphviz DOT)
.fabro/workflows/<name>/workflow.toml    # run/environment config
```

`.fabro/project.toml`:
```toml
_version = 1
[run.pull_request]
enabled = true
draft = true
# auto_merge = true
```

`workflow.toml` — **this is where the execution environment/sandbox is chosen**
(directly relevant to launch-interface parity, Leg C):
```toml
_version = 1
[workflow]
graph = "workflow.fabro"
[run.environment]
id = "local"
[environments.local]
provider = "local"           # <- provider = local | (docker/sandbox providers exist)
```

**`workflow.fabro`** — the workflow itself, **Graphviz DOT**:
```dot
digraph Hello {
    graph [goal="Say hello and demonstrate a basic Fabro workflow"]
    rankdir=LR
    start [shape=Mdiamond, label="Start"]
    exit  [shape=Msquare, label="Exit"]
    greet [label="Greet", prompt="Say hello! ... test of the Fabro workflow engine."]
    start -> greet -> exit
}
```
Node vocabulary (from README + template): `shape=Mdiamond`=Start, `shape=Msquare`=Exit,
`shape=hexagon`=human-approval gate, plain node with `prompt="..."`=**agent** node
(multi-turn LLM w/ tools), `class="coding"`=CSS-like class routed to a model via a
**model_stylesheet** graph attr (e.g. `"* { model: claude-haiku-4-5; } .coding { model:
claude-sonnet-4-5; }"`). Edges carry outcome labels (`[label="[A] Approve"]`) →
**outcome-conditional edges** (the fix the f6ta 2PC spike said is mandatory to avoid
silent pass-through on node failure). `parallel` nodes fan out.

### 3.4 Trivial workflow run — end to end, SUCCEEDED

```
cd <scratch>/proj                      # git repo + fabro repo init done
export FABRO_STORAGE_DIR=<scratch>/fabro-storage
fabro validate hello                   # -> Validation: OK (3 nodes, 2 edges)
fabro run hello --dry-run --auto-approve
```
Output:
```
Run: 01KWDM1S2B57TRF9250GQBTTRY  (Web UI: .../runs/01KWDM...)
Sandbox: local (ready in 0ms)
✓ Start 0ms   ✓ Greet 0ms   ✓ Exit 0ms
Status: SUCCEEDED   Duration: 0 seconds
Output: [Simulated] Response for stage: greet
```
`--dry-run` uses the **simulated LLM backend** — so the loop mechanics can be
proven without any provider credential at all. This is the ideal harness for
Slices 2–4 mechanics before wiring real agents.

### Server storage layout (`FABRO_STORAGE_DIR`)
```
<storage>/server.env                       # bootstrap/runtime secrets (see §4.1)
<storage>/server.dev-token  server.json  server.lock
<storage>/vaults/default/secrets.json      # workflow-visible vault (see §4.2)
<storage>/objects/slatedb/{wal,compactions,manifest}   # durable run state (SlateDB)
<storage>/objects/artifacts                # run artifacts
<storage>/logs/server.log
```
Run state is a **SlateDB** object store — this is fabro's durable-checkpoint
authority (the "competing authority vs. bd" leak the substrate eval flagged).

## 4. Secrets / credentials — native store + the exact seam to bypass

Fabro has a **two-tier native secret system**, both plaintext-on-disk under
`FABRO_STORAGE_DIR`. Confirmed empirically:

### 4.1 Tier 1 — runtime/bootstrap secrets: `<storage>/server.env`
```
FABRO_DEV_TOKEN=fabro_dev_fb62f24675f4b3859d1eac77a4a0f97797ff6c1d4dfeb09ea58de880205632e1
SESSION_SECRET=926d210daf8a3c971deec5cd19258f76b7d264bee3bdf610f90176bb6c599f84
```
Plain `KEY=value`. Resolution precedence: **process env → server.env**. These are
the server's own auth secrets (dev token for `Authorization: Bearer fabro_dev_...`,
session signing), not workflow creds.

### 4.2 Tier 2 — workflow-visible vault: `<storage>/vaults/default/secrets.json`
Managed by `fabro secret set|list|rm` (and `fabro variable` for non-secret values).
**"Anything stored in the vault may be used by workflows."** Provider keys land here:
`fabro secret set ANTHROPIC_API_KEY sk-ant-...`. Confirmed `fabro secret set DEMO_KEY
demo_value` writes **plaintext**:
```json
{
  "GITHUB_TOKEN": { "value": "dummy_proxy", "type": "token", "created_at": "...", "updated_at": "..." },
  "DEMO_KEY":     { "value": "demo_value",  "type": "token", ... }
}
```
`--type` can be `token` or `file`. **Workflow agent/command nodes resolve
credentials from this vault by EXACT NAME** ("Server-backed workflows resolve
built-in provider credentials from exact-name vault tokens or OAuth entries").
Providers can also be OAuth'd via `fabro provider login`.

**THE SEAM to replace with agent-vault** = tier 2, the exact-name vault lookup that
feeds credentials into a node's execution environment. In fabro's native model the
real secret value sits in `vaults/default/secrets.json` and is injected into the
agent/command node env at run time.

### 4.3 The agent-vault bypass — already demonstrated working
The bypass pattern falls out naturally and I proved it end-to-end during install:
I set `GH_TOKEN=dummy_proxy`; fabro stored the literal string `"dummy_proxy"` in its
vault as `GITHUB_TOKEN`; **yet every GitHub call succeeded** — because agent-vault's
egress proxy injects the *real* token on the wire. So:

> **Bypass = keep fabro's vault populated only with DUMMY placeholders (or empty),
> ensure the workflow's agent/command nodes inherit `HTTPS_PROXY/HTTP_PROXY` →
> agent-vault, and let the proxy inject real credentials on outbound requests.**
> Fabro never holds a real secret; its "exact-name vault lookup" hands the agent a
> throwaway value that only has to be non-empty so the client sends *a* header.

Two things to verify in later slices:
1. That fabro's agent/command **nodes actually propagate `HTTPS_PROXY` into the
   node execution environment** (sandbox provider dependent — `provider="local"`
   inherits the parent env; a `docker`/sandbox provider may need explicit env
   passthrough). This is the concrete integration risk.
2. That any credential fabro consumes for **its own** operation (e.g. the GitHub
   integration / PR creation in `project.toml [run.pull_request]`) also rides the
   proxy rather than needing a real vault entry. GitHub auth already proven to ride
   the proxy (§2), so this looks clear.

## 5. Facts that matter for later slices

- `[environments.<id>] provider = "local"|...` in `workflow.toml` is the **launch /
  sandbox seam** (Leg C: bc-container parity). `local` = run in the current
  process/cwd; other providers (docker/sandbox — `fabro sandbox` subcommands exist)
  are how you'd containerize. This is where "same launch interface as bc-container"
  will actually be negotiated.
- `--dry-run` (simulated LLM) lets us build/validate the Implementer→Reviewer graph
  mechanics with zero credentials before wiring real agents.
- Outcome-labeled edges + `fabro validate`/`preflight` give static checking of the
  graph. `fabro events|logs|inspect|attach|wait` give programmatic run observation
  (relevant to harvesting `work_done` — though ADR-018 says harvest via shop-msg,
  NOT fabro outputs).
- Durable state = **SlateDB** under `<storage>/objects/slatedb` — this is the
  checkpoint authority the substrate eval flagged as competing with bd. Confirmed
  present.

## Open questions (for synthesis / Slice 1)
1. Does a fabro **agent/command node inherit `HTTPS_PROXY`** so agent-vault injection
   reaches the agent's own tool calls (not just fabro's GitHub ops)? Provider-dependent.
2. Under a non-`local` sandbox provider (docker), how are env/creds passed in — and is
   that the drop-in point for the bc-container launch interface?
3. Can fabro run **fully headless with `--no-web` on a unix socket** for an in-container
   ephemeral server (looks yes from flags; not yet exercised)?
4. Can the LLM provider itself be pointed at agent-vault (i.e. dummy `ANTHROPIC_API_KEY`
   in vault + proxy injection) so even the model key never lives in fabro? (Same pattern
   as §4.3; needs a non-dry-run confirmation.)
5. How does fabro's SlateDB checkpoint authority reconcile with bd-as-authority
   (ADR-012 2PC) — carried over from the f6ta findings, still the sharpest risk.
