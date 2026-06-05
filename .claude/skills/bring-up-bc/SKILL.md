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
3. **`bc-container` installed** — `which bc-container`. If missing:
   `pip install "shopsystem-bc-launcher @ git+https://github.com/dstengle/shopsystem-bc-launcher@v0.2.0"`
   (bc-launcher is not yet a declared lead dependency; this installs its CLI).
4. **BC manifest present** — `bc-container manifest validate`. The manifest
   (`bc-manifest.yaml`, repo root, ADR-005) lists each BC's `name`/`remote`/`role`.

## The two environment facts a launch needs

- **DSN + network.** BC containers reach the mailbox on the docker network
  `shopsystem` via the `postgres` alias:
  `--shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem --network shopsystem`.
  (Confirm the lead's own DSN with `shop-msg prime`.)
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

```bash
BCLAUNCHER_HOST_HOME=/home/dstengle bc-container launch <bc-name> \
  --repo-url <remote-from-manifest> \
  --shopmsg-dsn postgresql://postgres:postgres@postgres:5432/shopsystem \
  --network shopsystem
```

A clean launch reports: container started → host gitconfig + `.claude.json`
copied → repo cloned into `/workspace` → `bd dolt pull` → beads prefix set →
skill-group poured → tmux `agent` session → startup prompt injected (the agent
arms Monitor on `shop-msg watch --bc <name>`, drains its inbox, then awaits).

## Verify it came online

```bash
bc-container status <bc-name>      # container_state: running, tmux_session: active
bc-container monitor <bc-name>     # watch the agent boot + arm its watch
shop-msg bc-status                 # <bc-name> flips to 'online' once the watch arms
```

The agent takes ~30–90s to boot Claude Code and arm the watch; `bc-status` stays
`offline` (stale tick) until it does. If it never arms, `bc-container monitor`
shows why (API retry, clone failure, etc.).

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
