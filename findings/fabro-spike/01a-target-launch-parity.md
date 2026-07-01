# Slice 1 — Target A: launch-interface-parity spec

**Epic:** lead-6k1r (Fabro spike). **Leg:** A (launch parity). **Date:** 2026-07-01.
**Branch:** `fabro-spike`. **Surface:** artifact/contract only — no BC source, no live
BC boot (`bc-base` un-rebuildable, ADR-022). **This spec is design-only**; every
"PROVEN" claim is inherited from Slice 0 legs, and every acceptance criterion is a
Slice 3 observation, not a Slice 1 one.

Grounding (facts taken as given, NOT re-derived):
[00-fabro-recon.md](00-fabro-recon.md) · [00a-fabro-tool.md](00a-fabro-tool.md) ·
[00b-f6ta-seams.md](00b-f6ta-seams.md) · [00c-bcshop-loop.md](00c-bcshop-loop.md).

---

## 0. What "launch-interface parity" means under the in-container-only scope

The parity target is the **`bc-container` `launch` contract** (owned by
`shopsystem-bc-launcher`, ADR-004 / PDR-004; subcommand surface
`launch/attach/inject/monitor/stop/status/list`, scenario 17). A fabro launcher must
present this as a **drop-in alternate launch path, not a new contract** (plan.md §
"Launch-interface parity").

The epic narrows fabro to **in-container BC orchestration only** with
`[environments.<slug>] provider='local'` (00a §5; 00b "scope shift"). That narrowing
splits the contract into three tiers, and fabro touches only the third:

- **Container tier (P1–P4, P7, P10–P17):** booting `bc-<bc>`, the in-container clone,
  beads pull, skills pour, isolation, network/coordinates. `provider='local'` means
  fabro runs *inside* an already-booted container — so fabro does **not** replace this
  tier. Parity here = the outer launcher (bc-container itself, or a thin fabro-launcher
  that reuses the same docker invocation) still produces these observables byte-for-byte.
- **Engage tier (P5, P6, P8, P9, P18):** the readiness barrier and the tmux-`agent`
  send-keys engage that today starts a single `claude` TUI. **This is what fabro
  replaces:** the in-container ephemeral fabro server + a `fabro run` of the
  Implementer→Reviewer graph (Target B) stands in for the tmux `agent` session.
- **Credential tier (P11–P13):** the proven agent-vault vault-placeholder + `HTTPS_PROXY`
  path. Parity = fabro's node execution env inherits `HTTPS_PROXY`; fabro's own vault
  holds only `__PLACEHOLDER__`/dummy values (00a §4.3, PROVEN for GitHub).

Hard invariants this spec must not violate (plan.md §2; 00b): fabro in-container ONLY;
credentials via **agent-vault, not fabro secrets**; **shop-msg protocol preserved**;
lead harvests `work_done` only via `shop-msg read outbox` + `scenarios hash` (ADR-018),
never from fabro run outputs.

---

## 1. Enumerated observable properties of the `bc-container launch` contract

Each row is a property the bc-launcher scenarios/ADRs **assert** about launch, with its
citation. IDs (P1…) are referenced by the fabro mapping in §2 and the acceptance
criteria in §3.

### Container tier

| ID | Observable property | Citation |
|----|---------------------|----------|
| **P1** | Starts a Docker container **named `bc-<bc>`** (e.g. `bc-shopsystem-messaging`) from the pinned **`bc-base`** image (bc-launcher-owned/published). | scenario 01; `bring-up-bc` §1; ADR-021/022 |
| **P2** | Clones the BC repo **inside the container** at `/workspace`; URL resolved from `bc-manifest.yaml`. | scenario 02; `bring-up-bc` §1; `bc-manifest.yaml` |
| **P3** | Runs `bd dolt pull` inside the workspace; `.beads/` exists at workspace root and beads is left **functional**, not merely pulled. | scenarios 03, 32 |
| **P4** | Pours the `shop-templates` skill-group into `<workspace>/.claude/skills/` (bc-base carries the `shop-templates` binary; a fresh clone has no skills). | scenarios 42, 43 |
| **P7** | Docker **HEALTHCHECK reflects readiness, not liveness**: healthy only when beads usable AND messaging DB reachable; **unhealthy** when broker unreachable despite a live process. | scenarios 35, 47 |

### Engage tier

| ID | Observable property | Citation |
|----|---------------------|----------|
| **P5** | Starts a named **tmux session `agent`** inside the container; `inject` sends prompt text to it via `tmux send-keys`; `monitor` streams the tmux pane to host stdout (host-discoverable engage-observability surface). | scenarios 04, 07, 08 |
| **P6** | **Idempotent readiness barrier**: a single defined re-runnable sequence gating container-up→agent-engage. Composes **both** supporting servers — messaging postgres (`SHOPMSG_DSN`) reachable **AND** agent-vault broker reachable; engagement withheld if **either** is down. Postgres-down → launch exits non-zero, stderr names `SHOPMSG_DSN`, no prompt sent. Broker-down → exits non-zero, stderr names the configured broker address, no prompt sent. Re-run against an already-ready container is a **no-op reporting ready**. | scenarios 34, 48, 33, 47 |
| **P8** | Startup prompt must **autonomously commit** (agent processes with no follow-up keystroke) and be issued as **two discrete `send-keys` invocations** — text alone, then Enter alone; no single invocation carries both (single-write payloads get absorbed as paste by the TUI). | scenarios 27, 30 |
| **P9** | Engage **auto-dismisses** a blocking escape-able interactive option screen by sending a discrete **Escape** key (not Enter) as a separate send-keys invocation, then submits the real prompt; the dismissal is logged as a host-discoverable WARNING on `monitor`. | scenario 55 |
| **P18** | **Verify-online contract:** `launch` exit 0 means "container started", NOT "online". Online is verified via `shop-msg bc-status` reaching `online` (heartbeat table, ADR-014) AND the BC accepting a `shop-msg` ping/dispatch. | `bring-up-bc` §3 + DoD; ADR-014 |

### Isolation / credential tier

| ID | Observable property | Citation |
|----|---------------------|----------|
| **P10** | **No sibling-BC / lead-workspace mounts:** the only bind mount is the BC's own repo; no candidate sibling directory appears as a mount source. | scenario 15 |
| **P11** | **No host-filesystem credential mounts:** no host `~/.claude` mount, no RW mount at `/home/vscode/.claude`, no `~/.config/gh`, no `~/.gitconfig`. Launch must **not** require `BCLAUNCHER_HOST_HOME` to resolve a credential path (that var is for the bind-mounted-home devcontainer case only, never clone-path). | scenario 44; `bring-up-bc` §2 |
| **P12** | **Credentials brokered, not mounted:** the agent is launched wrapped as **`agent-vault run -- claude`**; the agent process env sets **`HTTPS_PROXY`** to the broker's proxy listener on the shop network; the container's `.credentials.json` is a **read-only `__PLACEHOLDER__`** (real OAuth never in the container). The ONLY credential-bearing secret in the container is the revocable agent-vault proxy token granting only proxy substitution. | scenarios 45, 50 |
| **P13** | `bc-base` carries `gh` **and** `agent-vault` on PATH; an interactive bootstrap entrypoint **mode** exists for the one-time human claude+gh auth beat that produces the broker credential. | scenarios 64, 51; ADR-040 / PDR-019 |

### Network / coordinates tier

| ID | Observable property | Citation |
|----|---------------------|----------|
| **P14** | `SHOPMSG_DSN` is set **inside** the container so in-container `shop-msg` reaches the same postgres as the host. | ADR-004 Decision |
| **P15** | Shop docker **network resolves from on-disk config with NO `--network` flag** (when `bc-manifest.yaml` carries no shop-level network field); resolved value = the product slug **`shopsystem`**. | scenario 63; `bc-manifest.yaml` `product:`; `compose.yaml`; ADR-043/PDR-030 |
| **P16** | Canonical coordinates are declared once in **`ops/ops-coordinates`** (sourced, not executed), all derived from the slug: `OPS_NETWORK`, `OPS_AGENT_VAULT_CONTAINER={{slug}}-agent-vault`, `OPS_POSTGRES_CONTAINER={{slug}}-postgres`, broker `:14321` (API) / `:14322` (HTTPS proxy). | ADR-043 Phase 1 / PDR-030; `ops/ops-coordinates` |
| **P17** | Supporting servers must exist on the network for the barrier to pass: `shopsystem-postgres` (postgres:16, `SHOPMSG_DSN`) and `shopsystem-agent-vault` (`infisical/agent-vault:latest`). | `compose.yaml` |

### Contract-surface tier (subcommands + lead profile)

| ID | Observable property | Citation |
|----|---------------------|----------|
| **P19** | **LEAD profile** additive capabilities (a normal BC does not need): **workspace-mount** (bind an existing host tree as `/workspace`, SKIP clone + skip clone-path provisioning — no `bd bootstrap`, no skills re-pour; mounted `.beads`/`.claude/skills` byte-unchanged) and **docker-socket opt-in** (mount `/var/run/docker.sock` only under the lead-only flag; default = no socket). | scenario 54; PDR-020 |
| **P20** | Subcommand surface the launcher exposes: `launch, attach, inject, monitor, stop, status, list`. | ADR-004; scenario 17 |

---

## 2. Fabro mapping — each property → concrete fabro construct

Fabro vocabulary used below (all from 00a): `workflow.toml [environments.<slug>]
provider='local'`; `[run.clone]` / `[run.prepare]` init hooks; `.fabro/project.toml`;
`workflow.fabro` DOT graph with agent nodes (`prompt=`), **command nodes**, human gates
(`shape=hexagon`), `Start`/`Exit`, and **outcome-conditional edges**; the proven
**vault-placeholder + `HTTPS_PROXY`** credential path; headless `fabro server start
--foreground --no-web --bind <unix-socket>`; SlateDB checkpoint (demoted to
resume-only). "Bridge" = no native analog; thinnest fix is a **command node shelling to
the existing tool**.

### Container tier — KEEP the existing launcher; `provider='local'` rides inside

Because scope pins `provider='local'` (fabro runs in the current process/cwd, 00a §5),
fabro is **not** the container booter. The thinnest architecture is: the existing
`bc-container launch` (or a fabro-launcher that reuses its exact docker invocation)
boots `bc-<bc>` and does clone/pull/pour as today; the **only substitution inside** is
that the tmux-`agent` claude session is replaced by an ephemeral fabro server running
Target B's graph.

- **P1 (container name / bc-base image):** No fabro analog under `provider='local'`; fabro
  does not create the container. **Keep** bc-container's docker `run --name bc-<bc>`.
  (A `provider='docker'`/sandbox environment *could* own the container, but that
  contradicts in-container-only scope and re-introduces fabro-as-outer-launcher — out
  of scope this epic.) **Bridge (if a pure fabro-launcher is wanted):** a `[run.prepare]`
  / command node that shells `bc-container launch` unchanged, then execs `fabro run`
  inside — i.e. fabro wraps, does not replace, the docker boot.
- **P2 (in-container clone):** `[run.clone]` node (the f6ta Seam-a analog for
  container-init, 00b Seam (a)). Under `provider='local'` the repo is already the cwd;
  parity is satisfied by KEEPING bc-container's in-container clone before the fabro
  server starts. `[run.clone]` is the native slot **iff** a fabro-owned environment does
  the boot; otherwise it is a no-op and clone stays with the outer launcher.
- **P3 (beads pull, functional):** `[run.prepare]` command node running `bd dolt pull`
  and a `bd ready` smoke check. Note the invariant (00b Invariant 1 / PDR-010): **bd is
  authoritative; fabro's SlateDB checkpoint is demoted to run-resume-only** and must NOT
  become a competing beads authority.
- **P4 (skills pour):** `[run.prepare]` command node that pours `shop-templates` skills
  into `.claude/skills/` — identical to today, since Target B's fabro graph still invokes
  those skills via command/agent nodes (00c §3.5). No fabro-native analog; keep the tool.
- **P7 (health = readiness):** No fabro analog for a Docker HEALTHCHECK. **Bridge:** keep
  bc-base's HEALTHCHECK; additionally the fabro readiness barrier (P6) gates the
  `fabro run` start so the two agree.

### Engage tier — fabro `run` replaces the tmux `agent` session

- **P5 (tmux `agent` + inject/monitor):** The tmux `agent` session existed to host a
  single `claude` TUI and feed it keystrokes. Under fabro the in-container agent loop is
  a **`fabro run`** of Target B's graph, launched headless (`fabro server start
  --foreground --no-web --bind <unix-socket>`, 00a §3.2/§5). **No send-keys engage is
  needed** — a `fabro run` begins autonomously by construction. Parity for `attach`/
  `monitor`/`inject` (P20) maps to `fabro attach` / `fabro events|logs` / `fabro steer`
  (00a §3.1). **Bridge:** if the host-side `bc-container monitor/inject/attach` CLI
  surface must stay byte-identical, wrap those subcommands as thin shims over
  `fabro attach`/`events`/`steer`.
- **P6 (idempotent readiness barrier over postgres + agent-vault):** A **command node**
  (or `[run.prepare]` step) that runs the reachability checks — `shop-msg prime`
  (postgres/`SHOPMSG_DSN`) and an `agent-vault`/broker reachability probe — **before**
  the first agent node. Wire it with **outcome-conditional edges** (00a §3.3; the
  mandatory fix from 00c §(d)): PASS → proceed to the router node; FAIL → an
  Exit-blocked node whose message names `SHOPMSG_DSN` (postgres down) or the broker
  address (broker down). **Idempotence** is native: fabro checkpoint/resume replays a
  completed prepare step as a no-op (00b Seam (b): "checkpoint/resume subsumes the
  session-start drain"). **This barrier is the single most load-bearing parity point** —
  it must fail-closed exactly as scenarios 33/47 assert.
- **P8 (two-send-keys autonomous commit):** **No analog needed / obsolete.** The
  two-send-keys discipline is a TUI-paste workaround (scenario 30 root cause); a
  `fabro run` commits its first agent turn autonomously with no keystroke. The
  *observable* the property protects — "the agent begins work autonomously after the
  barrier passes, with no human follow-up" — is satisfied by fabro run semantics. Record
  as parity-by-obsolescence, verified at AC10.
- **P9 (Escape auto-dismiss + WARNING):** Same obsolescence — no interactive TUI option
  screen exists in a headless `fabro run`, so nothing to Escape. **Bridge (only if a
  claude *agent node* still surfaces an interactive prompt):** a command node preceding
  the agent node, or the agent node's own headless flags, suppresses it; log the
  suppression to `fabro events` to preserve the host-discoverable WARNING observable.
- **P18 (verify-online):** **Unchanged — invariant surface.** Online is still asserted
  via `shop-msg bc-status` + a `shop-msg` ping (ADR-014), NEVER by reading `fabro
  events`/run outputs (ADR-018 harvest invariant, 00b Invariant 3). Fabro's run-success
  is not evidence of online; the shop-msg heartbeat is.

### Credential tier — the PROVEN vault-placeholder + `HTTPS_PROXY` path

- **P10 (no sibling/lead mounts) & P11 (no host-cred mounts):** No fabro analog; these
  are docker-invocation properties. **Keep** bc-container's mount discipline. If a
  fabro-owned `provider='docker'`/sandbox environment ever boots the container, its
  `[environments.<slug>]` mount spec MUST reproduce "BC repo mount only, no host
  `~/.claude`/`~/.config/gh`/`~/.gitconfig`, no `BCLAUNCHER_HOST_HOME`" — otherwise it
  breaks the no-host-cred invariant. Under `provider='local'` this is inherited from the
  outer launcher for free.
- **P12 (agent-vault brokering):** **The core fabro-credential mapping, PROVEN in 00a
  §4.3.** Recipe: (1) fabro's own vault (`vaults/default/secrets.json`) holds ONLY
  dummy/`__PLACEHOLDER__` values — never a real secret (this satisfies the 4th epic
  invariant: creds via agent-vault, NOT fabro secrets, 00b); (2) every fabro **agent /
  command node execution env inherits `HTTPS_PROXY`** → the agent-vault proxy injects
  the real credential on the wire. Under `provider='local'` the node inherits the parent
  env, so `HTTPS_PROXY` propagation is free; the agent itself is still wrapped
  `agent-vault run -- claude` inside the run, and `.credentials.json` stays a read-only
  `__PLACEHOLDER__`. **OPEN (AC6):** confirm — with a *non-dry-run* agent node — that the
  proxy injection reaches the *agent's own* LLM/tool calls, not just fabro's GitHub ops
  (00a open-Q 1; 00-recon §(d)).
- **P13 (`gh`+`agent-vault` on PATH; bootstrap mode):** Provided by `bc-base` (kept). The
  one-time interactive human-auth beat (ADR-040/PDR-019) is orthogonal to fabro and
  stays in bc-base's entrypoint mode.

### Network / coordinates tier — invariant, no fabro analog

- **P14 (`SHOPMSG_DSN` in-container):** Set in the container env by the outer launcher;
  fabro nodes inherit it (`provider='local'`). No fabro analog; keep.
- **P15 (network from on-disk config, `shopsystem`) & P16 (`ops/ops-coordinates`) & P17
  (supporting servers):** **Invariant surface (00b Invariant 2, ADR-006/020; ADR-043).**
  Fabro has **no addressing/coordinate analog** and must not invent one. `ops-coordinates`
  remains the single source; `compose.yaml` still stands up postgres + agent-vault. If a
  fabro environment boots the container it must attach it to network `shopsystem` (its
  environment spec supplies the docker network), but the *value* is still sourced from
  `ops-coordinates`, never a fabro setting.

### Contract-surface tier

- **P19 (LEAD profile):** No fabro analog. **Keep** bc-container's `workspace-mount` and
  `docker-socket` opt-ins; a fabro-launcher wrapper forwards the flags. workspace-mount's
  "skip clone + skip provisioning" maps to skipping the `[run.clone]`/`[run.prepare]`
  nodes when the mount flag is set.
- **P20 (subcommand surface):** Parity map — `launch`→(outer launcher boot + `fabro run`
  start); `attach`→`fabro attach`; `monitor`→`fabro events`/`logs`; `inject`→`fabro
  steer`; `stop`→`fabro` stop/`server stop`; `status`→`shop-msg bc-status` (NOT fabro
  run status — ADR-018); `list`→`docker ps` (unchanged). Thin shims preserve the CLI
  shape.

### Where fabro has NO analog (summary of bridges)

| Property | No-analog reason | Thinnest bridge |
|----------|------------------|-----------------|
| P1, P10, P11, P14, P17 | Docker-invocation / supporting-server facts; `provider='local'` fabro doesn't boot the container | **Keep** bc-container docker invocation unchanged; fabro rides inside |
| P4 (skills pour), P3 (beads pull) | fabro has no skill-pour / beads primitive | `[run.prepare]` command node shelling `shop-templates` pour / `bd dolt pull` |
| P7 (Docker HEALTHCHECK) | fabro has no container-health concept | Keep bc-base HEALTHCHECK; fabro barrier (P6) agrees with it |
| P15, P16 (addressing/coordinates) | **Invariant** — no fabro analog by design (00b Inv 2) | `ops-coordinates` stays single source; fabro never sets these |
| P18 (verify-online) | **Invariant** — must not harvest fabro outputs (00b Inv 3) | `shop-msg bc-status` + ping, unchanged |
| P8, P9 (send-keys / Escape) | Obsolete — no TUI in headless `fabro run` | Parity-by-obsolescence; verify autonomous start at AC10 |
| P19, P20 | fabro CLI differs from bc-container CLI | Thin shim subcommands over `fabro attach/events/steer` + `shop-msg`/`docker` |

---

## 3. Acceptance criteria — what Slice 3 must OBSERVE to prove parity

Slice 3 boots the in-container fabro server and brings a BC up "with the same launch
interface as bc-container" (plan.md Slice 3). Parity is proven when ALL of the following
are observed. (Gated on the standing blocker: `bc-base` must first be made rebuildable —
ADR-022, 00-recon §(d).)

**AC1 — container (P1):** `docker ps` shows a container named `bc-<bc>` from the pinned
`bc-base`.

**AC2 — workspace (P2/P3):** inside the container, `/workspace` holds the cloned repo and
`bd ready` exits 0 (beads functional, not just pulled).

**AC3 — skills (P4):** `<workspace>/.claude/skills/` contains the poured `shop-templates`
skill-group (bc-router, work-done-gate, …).

**AC4 — fabro server (engage tier):** an ephemeral fabro server is running headless
in-container (`fabro server start --foreground --no-web --bind <unix-socket>`), and a
`fabro run` of Target B's graph is startable against it.

**AC5 — readiness barrier fail-closed + idempotent (P6):**
- postgres unreachable → the barrier node FAILs, the run does NOT reach the router/agent
  node, and the failure message names `SHOPMSG_DSN` (scenario 33 parity);
- broker unreachable → barrier FAILs naming the broker address (scenario 47 parity);
- both up → barrier PASSes and the router node runs;
- re-running the prepare/barrier against an already-ready run is a **no-op reporting
  ready** (scenario 34 parity) — confirm via fabro checkpoint/resume replay.
This is the make-or-break parity observation.

**AC6 — agent-vault credential path, non-dry-run (P12; the OPEN risk):** fabro's vault
(`vaults/default/secrets.json`) contains ONLY dummy/`__PLACEHOLDER__` values, and a
**non-dry-run** in-container agent node makes an outbound call (LLM and/or `gh`) that
**succeeds via `HTTPS_PROXY` proxy injection** — proving the node execution env inherits
`HTTPS_PROXY` and the proxy reaches the *agent's own* calls, not just fabro's GitHub ops.
(Extends the GitHub bypass PROVEN in 00a §4.3 to the agent's LLM key; 00a open-Q 1/4.)

**AC7 — isolation (P10/P11/P12):** `docker inspect` shows the BC repo as the only bind
mount — no host `~/.claude`, no `/home/vscode/.claude` RW mount, no `~/.config/gh`, no
`~/.gitconfig`, no sibling-BC mount; and `.credentials.json` inside the container is a
read-only `__PLACEHOLDER__`. No real Claude/GitHub token is present in the container.

**AC8 — network/coordinates (P14/P15/P16):** the container is on network `shopsystem`
resolved WITHOUT a `--network` flag; `SHOPMSG_DSN` is set in-container and in-container
`shop-msg` reaches the host's postgres; all coordinates trace to `ops/ops-coordinates`.

**AC9 — verify-online via shop-msg, NOT fabro (P18; ADR-018 invariant):** `shop-msg
bc-status` shows the BC row reaching `online` (ADR-014 heartbeat) AND the BC accepts a
`shop-msg` ping/dispatch — established WITHOUT reading `fabro events`/run outputs. Fabro
run-success alone is explicitly NOT accepted as evidence of online.

**AC10 — autonomous engage parity (P8/P9 obsolescence):** after the barrier passes, the
`fabro run` begins autonomous BC work with **no human keystroke** and no interactive
option screen blocking it — the observable the two-send-keys / Escape discipline existed
to guarantee.

**AC11 — end-to-end shop-msg emission (invariant, ties to Target B):** the fabro loop
terminates in a `work_done`/`clarify` emitted through `shop-msg`/`bc-emit` (pydantic-
validated wire contract, 00c §1.7), and the lead harvests it via `shop-msg read outbox`
+ `scenarios hash` only.

---

## 4. Out of artifact-surface scope (launcher-internal — cannot spec here)

Per ADR-018 the lead host carries no bc-launcher source; these are pinned as observable
behavior but their concrete values are unknown here and are Slice 3 empirical inputs
(00c "Flagged UNRESOLVED"):

- Exact `bc-base` image tag/digest currently pinned by `launch` (scenarios pin the
  *behavior* — pull current `latest`, not stale cache, scenario 39; rollback by
  republishing prior digest, scenario 41 — not the literal digest).
- The concrete `docker run` argv / full env set / mount list the launcher emits (exact
  `--network`, `-e SHOPMSG_DSN=…`, `.credentials.json` mount path, socket path).
- Internal shape of the readiness-barrier implementation (`driver.py` `messaging_db_
  reachable`).
- The concrete tmux key-name token the launcher maps "Escape" to (P9; BC-owned, echoed
  in `work_done`).
- Whether `shop-msg bc-status` `online`, the ADR-014 heartbeat cadence, and the E2E
  launch path are currently GREEN — `bring-up-bc` flags the path as "still being
  hardened".

## 5. Carried risks (record; resolve in Slices 3–4)

- **Standing blocker:** `bc-base` is un-rebuildable (ADR-022) — must be resolved before
  any AC that boots a real container.
- **HTTPS_PROXY-into-node-env (AC6):** provider-dependent; `provider='local'` inherits
  parent env (should be free), but a non-dry-run confirmation is required (00a open-Q 1).
- **SlateDB vs bd authority at the BC tier:** fabro checkpoints on every node; the BC has
  a git repo; the node running `shop-msg respond` collides with a checkpoint-commit →
  ADR-012 ordering hazard. Mitigation is a Target B / Slice 4 concern (outcome-conditional
  edges + ADR-012 `UNIQUE` + bd-first sweeper remain mandatory, 00b/00-recon §(d)); this
  spec only notes it does not weaken P18/AC9's shop-msg-authoritative stance.
