---
type: brief
id: brief-004
title: BC container isolation
status: draft
created: 2026-05-20
updated: 2026-07-17
authors: [dstengle, Claude (lead-po)]
description: 'The stakeholder''s expressed desire, in PO''s own words:'
derives-from: [pdr-004]
---

## Summary

The shopsystem today runs all BC agents on the same host, typically in a single
devcontainer. Isolation between BCs is **social, not technical**: the spec (§4)
says a BC-shop agent must not read sibling source trees, but nothing prevents
it. When a BC agent is curious or confused, the most convenient path is the
wrong one — reading another BC's code instead of emitting a `clarify`.

This brief commits the framework to **container-level isolation per BC shop**:
each BC agent runs in its own Docker container, started from the canonical
devcontainer image, with an agent session accessible via tmux. The behavioral
goal — work proceeds through `shop-msg` contracts, not code reads — becomes
enforced at the OS boundary, not just by instruction.

**Stakeholder-satisfying behavior (interview capture):** a single command starts
a container for one BC shop — pulls/uses a shop image, clones the BC's repo,
initializes beads, and starts a Claude Code agent session inside; the session
runs under a named tmux so the container keeps running after the initiating
terminal exits, a human can attach to observe or type, and an automated driver
can inject text (the "startup prompt" use case); the container can be directly
interacted with, not just observed; and work between BCs proceeds through
`shop-msg` contracts, not source reads. **What would NOT satisfy:** running all
BCs in one container without process isolation; an agent that reads the lead
shop's or another BC's source directly (isolation is not just technical but
behavioral — contracts only); or an opaque container with no attach/observe/inject
mechanism.

The brief carries **one invariant — isolation is technical, not just
instructed:** a BC's agent container has no access to the lead shop's working
directory or to sibling BC source trees; the host may map the BC's own
repository in, nothing else from the host workspace is mounted, and any
inter-shop communication goes through `shop-msg` via the shared Docker network
connecting both sides to the same PostgreSQL backend. This makes the §4
"no cross-BC code reads" constraint **unenforced-by-instruction →
enforced-by-mount**: an agent that physically cannot read sibling source is not
relying on role discipline alone; the architecture does the work.

The brief commits **intent**, not scenarios. It flags PDR-004 (command
ownership) as the blocker for Architect BC decomposition — until it resolves,
the scenarios cannot be assigned.

## Scope

**In scope — four scope items.** Each is named in product terms; command names
and flag shapes are the Architect's call after pre-state and PDR-004.

- **A — `bc-container launch` command.** Takes a BC name (or repo URL + branch)
  and: (1) pulls or reuses the canonical devcontainer image; (2) starts a
  container with the BC's repo (or a volume) mounted as workspace; (3) runs the
  init sequence inside — clone the repo if absent, `bd init`, install the shop's
  Python packages (`pip install -e .` or equivalent), arm the Monitor watcher
  per the canonical `.claude/settings.json` hook (brief 003); (4) starts a
  **named tmux session** with the Claude Code agent as the foreground process;
  (5) returns to the host with the container running in the background and the
  tmux session active. It is **scriptable** (machine-friendly arguments, no
  interactive prompts, deterministic exit codes), called once per BC per launch
  (containers are stopped and restarted; the init sequence re-runs on each fresh
  start), and **idempotent on a running container** (if a container for the named
  BC is already running, it reports state rather than starting a second).

- **B — Attachment and injection surface.** Three **separate** operations
  (separate flags or subcommands) targeting an already-running container by BC
  name: **Attach** (connects a terminal to the named tmux session, full
  interactive access); **Inject** (sends a string — a startup or follow-up
  prompt — to the tmux session's active pane without a human attaching; the text
  lands as if typed); **Monitor** (streams the tmux session's output to stdout
  on the host without attaching, so a driver or human observes without
  interfering).

- **C — Shared network connectivity.** The container-side `shop-msg` CLI and the
  host-side `shop-msg` CLI talk to the **same PostgreSQL instance**, achieved by
  placing the BC container and the host (or its devcontainer) on a **shared
  Docker network with a well-known name** (e.g. `shopsystem` — exact name the
  Architect's call). The BC agent configures its DB connection via an environment
  variable (e.g. `SHOP_MSG_DB_URL` or equivalent) set at container start,
  pointing to the PostgreSQL service reachable over the shared network. The
  committed property is both sides reaching the same DB via a named Docker
  network; **filesystem mounts and mailbox volume sharing are not part of this
  scope item.** This must not violate brief 001 invariant 1 — both sides
  communicate through the `shop-msg` CLI, not direct PostgreSQL access or
  filesystem inspection; the Docker-network model satisfies this (both call the
  same CLI, which connects to the same backend), introducing no new
  filesystem-inspection mechanism.

- **D — Container lifecycle commands.** Alongside `launch`: **Stop** (stop a
  named BC's container cleanly — flush in-flight tmux activity, then
  `docker stop`); **Status** (report running/stopped state including tmux session
  state — active, exited, no session); **List** (report all BC containers this
  surface knows about, with states). These are operational hygiene so the lead
  shop or a human operator knows what is running without parsing raw `docker ps`.

**Boundaries the PO commits.** One container **per BC shop** (the unit of
isolation is one BC, not one product; the command is per-BC); the container is
started from the shopsystem **devcontainer image** (built/published by
`shopsystem-devcontainer`); **tmux** is the session manager (human and automated
access via `attach-session` / `send-keys`); the clone-and-init sequence happens
**at container start** (ephemeral from the outside; init re-runs on every fresh
launch); and **work isolation is behavioral, not just technical** (no read access
to the lead shop's workspace or sibling BC source; all inter-shop traffic through
`shop-msg`).

**Out of scope — named explicitly.** **Agent session persistence across container
restarts** (a restarted container starts a fresh session; no conversation history
is preserved — acceptable because committed repo state persists in the mounted
volume and the agent recovers context from `bd` and repo state). **Orchestration
of all BCs at once** (the command launches one BC at a time; a product-level
bootstrap starting all N BCs is a follow-on — this brief is the per-BC building
block). **Building the devcontainer image** (built/published by
`shopsystem-devcontainer`; this brief consumes it, does not extend its build
pipeline). **Network isolation between containers** (containers on the same bridge
can reach each other; the committed property is behavioral isolation via no shared
mounts — network-level isolation, custom bridge-per-BC or `--network none`, is a
follow-on if the invariant needs strengthening). **Lead shop containerization**
(the lead shop runs on the host or its own devcontainer; this brief is
BC-container-only).

**Open questions the PO cannot close without stakeholder clarification or
Architect pre-state.** The **Docker network name** (stakeholder committed to a
well-known name; exact name e.g. `shopsystem` is the Architect's call). The
**DB connection environment variable** (whether `shop-msg` already honours a
`SHOP_MSG_DB_URL` or equivalent, or whether that support must be added under
scope C — pre-state determines vehicle). **Message ordering across container
restarts** (because shop-msg persists to PostgreSQL, not a filesystem volume,
messages sent by the lead before a BC container launches are already present in
the DB when it starts; the PO commits this expected behavior, the Architect
verifies it holds). **Image tag pinning** (always `latest`, pinned semver from a
config file, or a flag — deferred to the Architect). **Which repo owns the
`bc-container launch` command** (PO stance: a new BC like `shopsystem-bc-launcher`,
OR a new subcommand on an existing BC — the Architect's pre-state determines
whether `shopsystem-templates`, `shopsystem-devcontainer`, or
`shopsystem-messaging` is the natural owner, or a new BC is warranted; PDR-004
names the options and the decision). **tmux session naming convention** (the
brief commits tmux-as-manager; the Architect picks the name, e.g. `bc-<name>-agent`
or `agent`).

**Sequencing.** **Scope item A** requires the devcontainer image to be built and
accessible (`shopsystem-devcontainer` work in flight); A's scenarios should not
be dispatched until that BC's image-build/publish work is closed and a tag is
pullable. **Scope item B** (attach/inject/monitor) is a pure addition depending
on A landing first. **Scope item C** (shared network) is the key cross-brief
dependency: brief 001 invariant 1 still applies — both sides communicate through
`shop-msg`, satisfied by the Docker-network model. **Scope item D** (lifecycle)
is independent of B and C and depends only on A (a container must exist to
stop/inspect).

**Vehicle hints (Architect's call).** `bc-container launch` is **net-new
capability** (no existing BC owns it today; PDR-004 resolves ownership) →
`assign_scenarios`; even if it lives in an existing BC, the new subcommand
surface may still be `assign_scenarios`. Scope C depends on what `shop-msg`
already supports for its PostgreSQL connection — if it already accepts the DB URL
via an env var, C may be zero-BC-work (just network placement and a documented env
var); if it hard-codes the connection and needs a new env-var flag, C lands as
`assign_scenarios` against `shopsystem-messaging`. The `PRE-STATE DETERMINES
VEHICLE — VERIFIED EMPIRICALLY` posture stands.

## Source (pre-modernization)

#### Interview notes (PO capture)

The stakeholder's expressed desire, in PO's own words:

**What behavior would satisfy the stakeholder:**

- A single command starts a container for one BC shop: pulls/uses a
  shop image, clones the BC's repository, initializes beads inside the
  container, and starts a Claude Code agent session inside that
  container.
- The agent session runs under a terminal multiplexer (tmux named) so
  that (a) the container keeps running even after the initiating terminal
  exits, (b) a human can attach to the session to observe or type, and
  (c) an automated driver can inject text into the session (the "startup
  prompt" use case).
- The container can be directly interacted with — not just observed —
  after launch.
- Work between BCs proceeds through `shop-msg` contracts, not through
  reading each other's source code.

**What would NOT satisfy the stakeholder:**

- Running all BCs in the same container or on the same host without
  process isolation (no container boundary).
- An agent that reads the lead shop's source files or another BC's
  source files directly; the isolation is not just technical (separate
  container) but behavioral (contracts only).
- A container that is opaque — no mechanism to attach, observe, or
  inject a prompt.

**Boundaries the PO commits to:**

1. **One container per BC shop.** The unit of isolation is one BC,
   not one product. The command is per-BC.
2. **The container is started from the shopsystem devcontainer image.**
   The devcontainer image (built and published by
   `shopsystem-devcontainer`) is the base; `bc-container launch` (or
   equivalent) is the command that runs it appropriately.
3. **tmux is the session manager.** The agent runs inside a named tmux
   session inside the container. Human and automated access go through
   tmux (`attach-session` to observe/interact; `send-keys` to inject).
4. **The clone-and-init sequence happens at container start.** The
   container is ephemeral from the outside; the initialization sequence
   (clone, `bd init`, venv sync, arm Monitor) runs on every fresh
   container launch.
5. **Work isolation is behavioral, not just technical.** A BC agent
   in its container has no read access to the lead shop's workspace or
   to sibling BC source trees. All inter-shop traffic goes through
   `shop-msg`.

**Open questions the PO cannot close without stakeholder clarification
or Architect pre-state verification:**

- **Docker network name.** The stakeholder has committed that the
  shared network uses a well-known name. The exact name (e.g.
  `shopsystem`) is the Architect's call on pre-state verification.
- **DB connection environment variable.** The Architect determines
  whether `shop-msg` already honours a `SHOP_MSG_DB_URL` or equivalent
  env var for its PostgreSQL connection, or whether that support must
  be added as part of scope item C. Pre-state determines vehicle.
- **Message ordering across container restarts.** Because shop-msg
  persists to PostgreSQL (not a filesystem volume), messages sent by
  the lead before a BC container launches are already present in the
  DB when the container starts. The PO commits this is the expected
  behavior; the Architect verifies it holds.
- **Image tag pinning.** The `bc-container launch` command needs to
  know which image tag to use. Whether this is always `latest`, a
  pinned semver from a config file, or a flag — the PO defers to the
  Architect.
- **Which repo owns the `bc-container launch` command.** The PO's
  stance: this is a new capability whose home is a new BC
  (`shopsystem-bc-launcher` or similar), OR it is a new subcommand on
  an existing BC's CLI. The Architect's pre-state determines whether
  any existing BC (`shopsystem-templates`, `shopsystem-devcontainer`,
  or `shopsystem-messaging`) is the natural owner, or whether a new BC
  is warranted. PDR-004 names the options and the decision.

---

#### Point of intent

The shopsystem today runs all BC agents on the same host, typically in
a single devcontainer. Isolation between BCs is **social, not technical**:
the spec (§4) says a BC-shop agent must not read sibling source trees,
but nothing prevents it. When a BC agent is curious or confused, the
most convenient path is the wrong one: reading another BC's code instead
of emitting a `clarify`.

This brief commits the framework to **container-level isolation per BC
shop**: each BC agent runs in its own Docker container, started from the
canonical devcontainer image, with an agent session accessible via tmux.
The behavioral goal — work proceeds through `shop-msg` contracts, not
code reads — becomes enforced at the OS boundary, not just by instruction.

The brief carries **one invariant**, **four scope items**, and an
**explicit out-of-scope boundary**.

---

#### The invariant

##### Isolation is technical, not just instructed

A BC shop's agent container has no access to the lead shop's working
directory or to sibling BC source trees. The host may map the BC's own
repository into the container; nothing else from the host workspace is
mounted. Any communication between shops goes through `shop-msg` —
emitting messages on one side, reading them on the other — via the
shared Docker network that connects both sides to the same PostgreSQL
backend.

This invariant makes the §4 "no cross-BC code reads" constraint
**unenforced-by-instruction → enforced-by-mount**. An agent that
physically cannot read sibling source is not relying on role discipline
alone; the architecture does the work.

---

#### Four scope items

##### A — `bc-container launch` command

A command (exact name the Architect picks after pre-state; herein called
`bc-container launch`) takes a BC name (or repo URL + branch) and:

1. Pulls or reuses the canonical devcontainer image.
2. Starts a container with the BC's repo (or a volume where the repo
   will be cloned) mounted as the workspace.
3. Inside the container, runs the initialization sequence:
   - Clone the BC's repository (if not already present in the workspace
     volume).
   - Run `bd init` to initialize beads.
   - Install the shop's Python packages (`pip install -e .` or
     equivalent).
   - Arm the Monitor watcher per the canonical `.claude/settings.json`
     hook (brief 003).
4. Starts a **named tmux session** inside the container with the Claude
   Code agent as the foreground process.
5. Returns to the host with the container running in the background, the
   tmux session active.

The command is **scriptable**: machine-friendly arguments, no
interactive prompts, deterministic exit codes. It is called once per
BC per launch, not once per session (containers are stopped and
restarted; the init sequence re-runs on each fresh container start).

The command is **idempotent on a running container**: if a container
for the named BC is already running, the command reports its state
rather than starting a second container.

##### B — Attachment and injection surface

The surface for human and automated interaction with a running BC
container:

- **Attach:** a command that connects a terminal to the named tmux
  session inside the container, giving full interactive access to the
  agent session.
- **Inject:** a command that sends a string of text (a startup prompt
  or a follow-up prompt) to the tmux session's active pane without
  requiring a human to attach. The injected text lands as if the human
  typed it.
- **Monitor:** a command that streams the tmux session's output to
  stdout on the host, without attaching interactively, so an automated
  driver or a human can observe without interfering.

All three are separate operations (separate flags or subcommands) that
target an already-running container by BC name.

##### C — Shared network connectivity

The BC agent running inside its container must be able to reach the
same `shop-msg` PostgreSQL backend as the host-side `shop-msg` CLI.
The committed property:

- Both the host-side `shop-msg` CLI (used by the lead shop to drop
  messages and read responses) and the BC agent's container-side
  `shop-msg` CLI talk to the **same PostgreSQL instance**.
- This is achieved by placing the BC container and the host (or its
  devcontainer) on a **shared Docker network with a well-known name**.
  The exact network name (e.g. `shopsystem`) is the Architect's call;
  the property (same network, well-known name) is committed by the PO.
- The BC agent configures its database connection via an environment
  variable (e.g. `SHOP_MSG_DB_URL` or equivalent) set at container
  start; the value points to the PostgreSQL service reachable over the
  shared network.

**Realization is still the Architect's call** on the exact network
name and environment-variable convention. The brief commits the
property (both sides reach the same DB via a named Docker network);
filesystem mounts and mailbox volume sharing are not part of this
scope item.

##### D — Container lifecycle commands

Alongside `launch`, the surface includes:

- **Stop:** stop a named BC's container cleanly (flush any in-flight
  tmux activity, then `docker stop`).
- **Status:** report the running/stopped state of a named BC's
  container, including the tmux session state (active, exited, no
  session).
- **List:** report all BC containers this command surface knows about,
  with their states.

These are operational hygiene: the lead shop (or a human operator)
needs to know what is running without calling `docker ps` and
interpreting raw output.

---

#### Out of scope — named explicitly

**Agent session persistence across container restarts.** When a
container is stopped and restarted, the Claude Code session starts
fresh. No conversation history is preserved across container restarts.
This is acceptable: the BC's repository state (committed work) is
persisted in the mounted volume; the agent recovers context from `bd`
and the repo state, not from the conversation history.

**Orchestration of all BCs at once.** The command launches one BC at a
time. A product-level bootstrap that starts all N BCs for a product
(parallel `bc-container launch` calls) is a follow-on. This brief is
the per-BC building block; composition is adjacent future work.

**Building the devcontainer image.** The image is built and published by
`shopsystem-devcontainer` (briefs/features already in flight). This
brief consumes that image; it does not extend its build pipeline.

**Network isolation between containers.** Containers on the same Docker
bridge network can reach each other. This brief does not commit to
network-level isolation between BC containers — the behavioral isolation
(no shared mounts) is the committed property. Network-level isolation
(custom bridge-per-BC or `--network none`) is a follow-on if the
invariant needs strengthening.

**Lead shop containerization.** The lead shop runs on the host (or in
its own existing devcontainer). This brief is BC-container-only.

---

#### Sequencing

- **Scope item A** requires the devcontainer image to be built and
  accessible (`shopsystem-devcontainer` work in flight). Scenarios for
  A should not be dispatched until the devcontainer BC's image-build
  and publish work is closed and an image tag is available to pull.
- **Scope item B** (attach/inject/monitor) is a pure addition to the
  `bc-container` surface; it depends on A landing first but not on any
  other brief.
- **Scope item C** (shared network connectivity) is the key cross-brief
  dependency: brief 001's invariant 1 (shop-msg as sole messaging
  surface) still applies — both sides must communicate through the
  `shop-msg` CLI, not by direct PostgreSQL access or filesystem
  inspection. The Docker-network model satisfies this: both sides call
  the same CLI, which connects to the same PostgreSQL backend via the
  shared network. No new filesystem-inspection mechanism is introduced.
- **Scope item D** (lifecycle commands) is independent of B and C; it
  depends only on A (a container must exist to stop/inspect).

#### Vehicle hints (Architect's call)

- The `bc-container launch` command is **net-new capability**. No
  existing BC owns it today (PDR-004 resolves ownership). Net-new
  capability points to `assign_scenarios`.
- If the Architect determines the command lives in an existing BC
  (e.g., `shopsystem-templates` or `shopsystem-devcontainer`), the
  vehicle may remain `assign_scenarios` for the new subcommand surface
  even if the BC already exists.
- Scope item C (shared network connectivity) depends on what `shop-msg`
  already supports for configuring its PostgreSQL connection. If
  `shop-msg` already accepts the DB URL via an environment variable,
  C may be zero-BC-work (just network placement and a documented env
  var). If `shop-msg` hard-codes its DB connection and needs a new
  env-var flag, C lands as `assign_scenarios` against
  `shopsystem-messaging`. Pre-state determines vehicle.

These are hints. The Architect's `PRE-STATE DETERMINES VEHICLE —
VERIFIED EMPIRICALLY` posture stands.

#### Grounding artifacts

- [brief 001](001-inter-shop-messaging-encapsulation.md) — invariant 1
  (shop-msg as sole surface); scope item C must not violate it.
- [brief 002](002-shop-bootstrap-cli-surface.md) — the per-shop bootstrap
  sequence (clone, `bd init`, managed files) that the container init
  sequence replicates inside Docker.
- [brief 003](003-event-driven-shop-activation.md) — the Monitor-arm
  hook that the container init sequence must also activate.
- [features/devcontainer/](../features/devcontainer/) — scenarios
  pinning the devcontainer image that `bc-container launch` consumes.
- [PDR-004](../pdr/004-bc-container-command-ownership.md) — decision on
  which BC owns the `bc-container` command surface.

#### What this leaves open

The brief commits **intent**, not scenarios. Scenarios come after the
Architect verifies BC pre-state and picks vehicles per the discriminator.

- **Exact command name and flag shape for A.** Whether the surface is
  `bc-container launch <bc-name>`, `shop-bc start <bc-name>`,
  `shop-templates bc-launch`, or something else is the Architect's call
  after PDR-004 resolves ownership and pre-state is verified.
- **Docker network name for C.** The brief commits that a well-known
  Docker network name is used; the Architect picks the name after
  pre-state verification.
- **DB connection env var for C.** Whether `shop-msg` already supports
  a `SHOP_MSG_DB_URL` or equivalent; the Architect verifies and names
  the convention in the dispatched scenarios.
- **tmux session naming convention.** The brief commits tmux-as-manager;
  the Architect picks the session name (e.g., `bc-<name>-agent` or
  `agent`) in the dispatched scenarios.
- **Which BC owns the command (PDR-004).** Until that PDR resolves, the
  scenarios cannot be assigned. The PO flags PDR-004 as the blocker
  for Architect BC decomposition.
