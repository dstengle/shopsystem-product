---
name: bring-up-bc
description: Bring a Bounded-Context shop online as a running container via bc-container, so the lead can dispatch work to it. Use when a BC is offline (shop-msg bc-status), when a dispatch is held waiting for a BC, or when standing up the BC fleet at session start.
---

# Bring up a BC with `bc-container` (lead skill)

The lead shop **instantiates** a BC by launching its container with
`bc-container` (the `shopsystem-bc-launcher` CLI). The container clones the BC
repo *inside itself* (ADR-018 — no BC source on the lead host), starts a Claude
agent in tmux, and the agent arms `shop-msg watch --bc <name>` so the BC becomes
reachable and heartbeats `online`.

## Preconditions (verify first)

1. **Postgres mailbox up** — `docker ps | grep shopsystem-messaging-postgres-1`.
   The shared mailbox is the substrate of every dispatch.
2. **`bc-base` image present** — `docker images | grep shopsystem-bc-base`.
   Pull if missing: `docker pull ghcr.io/dstengle/shopsystem-bc-base:latest`.
3. **`bc-container` installed, v0.2.5+** — `which bc-container` and
   `pip show shopsystem-bc-launcher | grep Version`. The brokered auto-clone fix
   (lead-5fji: runtime proxy derived as `:14322` + `<token>:<vault>`) landed in
   **v0.2.5**; a pre-v0.2.5 CLI wires `HTTPS_PROXY` to the bare `:14321` control
   port and the clone fails `CONNECT tunnel failed, response 405`. Install/upgrade:
   `pip install -U "shopsystem-bc-launcher @ git+https://github.com/dstengle/shopsystem-bc-launcher@v0.2.8"`
   (bc-launcher is not yet a declared lead dependency; this installs its CLI).
4. **BC manifest present** — `bc-container manifest validate`. The manifest
   (`bc-manifest.yaml`, repo root, ADR-005) lists each BC's `name`/`remote`/`role`.
5. **agent-vault broker up + operator broker creds in hand** — the fleet is
   brokered (ADR-026): every in-container clone and every Claude API call routes
   through the broker, so a launch with no/garbled broker creds fails at the clone
   (405) before the agent ever boots. Verify:
   - **Broker healthy:** `docker ps --filter name=agent-vault` shows
     `shopsystem-agent-vault-1` `Up ... (healthy)` with ports `14321-14322` mapped.
   - **Operator creds available** as `AGENT_VAULT_ADDR` / `AGENT_VAULT_TOKEN`
     (`av_agt_…`) / `AGENT_VAULT_VAULT` (`fleet`) / `AGENT_VAULT_CA_PEM` — supplied
     to the launch via `--env-file` or exported into the launch shell (see Launch).
     There is **no persisted operator env-file** by default; the live token is the
     one minted by `bin/agent-vault-provision`. If you don't have it but another BC
     is already online, source it from that container (it carries the working set):
     `docker inspect bc-shopsystem-templates --format '{{json .Config.Env}}'`
     → reuse its `AGENT_VAULT_ADDR/TOKEN/VAULT/CA_PEM`.

## The three environment facts a launch needs

- **DSN + network.** BC containers reach the mailbox on the docker network
  `shopsystem` via the `postgres` alias:
  `--shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem --network shopsystem`.
  (Confirm the lead's own DSN with `shop-msg prime`.)
- **agent-vault broker creds (`AGENT_VAULT_*`).** The launcher derives the
  in-container `HTTPS_PROXY` as `http://<token>:<vault>@agent-vault:14322` from
  `AGENT_VAULT_ADDR` / `AGENT_VAULT_TOKEN` / `AGENT_VAULT_VAULT`, and materializes
  the broker TLS trust from `AGENT_VAULT_CA_PEM` (so the clone trusts the MITM
  proxy). Supply them one of two ways:
  - **`--env-file <path>`** — a `KEY=VALUE` file. NOTE the parser is **single-line
    per key** (`key.partition("=")`), so `AGENT_VAULT_CA_PEM` must be a **one-line**
    value; a multi-line PEM silently loses every line after the first.
  - **Exported into the launch shell** — the CLI does `os.environ.setdefault` for
    every `AGENT_VAULT_*` key and the controller forwards them, so
    `export AGENT_VAULT_ADDR=… TOKEN=… VAULT=… CA_PEM=…` before the launch works
    too, and sidesteps the single-line CA limitation (a real-newline PEM in a shell
    var is fine). This is the robust path when sourcing creds from a live container.
- **`BCLAUNCHER_HOST_HOME` — the devcontainer credential-mount gotcha.** The
  launcher bind-mounts the host's `~/.claude`, `~/.config/gh`, `~/.gitconfig`
  into the container so the BC agent can authenticate. When the lead runs inside
  a **devcontainer with a bind-mounted home** (here: a ZFS host), `/proc/self/
  mountinfo` reports a *dataset-relative* source root (e.g. `/dstengle/.claude`)
  that the host docker daemon cannot resolve, and launch fails with
  `bind source path does not exist`. Fix: set `BCLAUNCHER_HOST_HOME` to the real
  host home so the launcher substitutes `/home/vscode` → that path.
  - **Find the real host home:** the devcontainer's `/home/vscode/.claude` is the
    bind target; its host source is the launch error path with the dataset prefix
    corrected — verify with
    `docker run --rm --mount type=bind,source=<candidate>/.claude,target=/p,readonly ghcr.io/dstengle/shopsystem-bc-base:latest ls /p`
    (use `--mount`, **not** `-v` — `-v` auto-creates an empty source dir on the host).
  - **On this host the value is `/home/dstengle`.**

## Launch

If a previous attempt left a stopped container of the same name, remove it first
(`docker rm -f bc-<bc-name>`) or the launch aborts with a name conflict.

Export the broker creds (here, sourced from a live BC) and launch:

```bash
# Source the working broker creds from any already-online BC container:
eval "$(docker inspect bc-shopsystem-templates --format '{{json .Config.Env}}' \
  | python3 -c 'import json,sys,shlex
for kv in json.load(sys.stdin):
    k,_,v=kv.partition("=")
    if k.startswith("AGENT_VAULT_"): print(f"export {k}={shlex.quote(v)}")')"

BCLAUNCHER_HOST_HOME=/home/dstengle bc-container launch <bc-name> \
  --repo-url <remote-from-manifest> \
  --shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem \
  --network shopsystem
```

A clean launch reports: container started → host gitconfig + `.claude.json`
copied → repo **cloned brokered** into `/workspace` → beads materialized +
bootstrapped → skill-group poured → tmux `agent` session → startup prompt injected
(the agent arms Monitor on `shop-msg watch --bc <name>`, drains its inbox, then
awaits). A `CONNECT tunnel failed, response 405` at the clone step means the broker
creds were missing/garbled (precondition 5) — the launcher fell back to the bare
`:14321` control port.

## Verify it came online

```bash
bc-container status <bc-name>      # container_state: running, tmux_session: active
bc-container monitor <bc-name>     # watch the agent boot + arm its watch
shop-msg bc-status                 # <bc-name> flips to 'online' once the watch arms
```

The agent takes ~30–90s to boot Claude Code and arm the watch; `bc-status` stays
`offline` (stale tick) until it does. If it never arms, `bc-container monitor`
shows why (API retry, clone failure, etc.).

**Slow-boot re-inject (common).** The launcher waits only ~60s for the Claude
readiness marker (`Accessing workspace:`) before giving up and printing
`Claude Code did not become ready within 60s … startup prompt NOT injected`. On a
brokered boot Claude often takes longer, so the container + tmux are healthy and
Claude sits at an idle REPL, but **no session-start prompt was sent** — so it never
arms its watch and stays `offline`. This is not a failure; just re-inject the
canonical prompt:

```bash
bc-container monitor <bc-name>   # confirm Claude is at the REPL (❯ prompt)
bc-container inject <bc-name> "Run your session-start sequence per /workspace/CLAUDE.md: arm Monitor on shop-msg watch --bc <bc-name>, then drain pending inbox via shop-msg pending inbox --bc <bc-name>, then await user direction."
```

It flips `online` within ~30s of the inject.

## Operating a live BC

- `bc-container monitor <name>` — stream the agent's tmux output.
- `bc-container inject <name> "<text>"` — send keys to the agent (steering).
- `bc-container attach <name>` — attach to the tmux session.
- `bc-container stop <name>` — stop and remove the container.

## Status

EXPERIMENTAL, lead-side (this slice, `lead-ir9m`/Track-C lineage). The intent is
to **bake this into the canonical lead template** (delivered by
`shopsystem-templates`) so every lead shop ships it — pinned by a
`features/` scenario and dispatched via `assign_scenarios`. See
[`../README.md`](../README.md).
