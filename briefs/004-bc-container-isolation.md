# Brief 004 — BC container isolation

**Status:** draft (2026-05-20)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** user-driver observation 2026-05-20:
*"BC shops should be able to be started in their own Docker containers.
There should be a command that uses Docker and a shop image to start a
container, clone a repository, init beads, and start an agent, with the
agent running in tmux or something similar so it can be connected to or
injected with a startup prompt and also monitored during operation, and
also allow direct interaction with the BC. The goal is isolation between
the BCs and having work proceed through contracts and not reading code."*

---

## Interview notes (PO capture)

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

## Point of intent

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

## The invariant

### Isolation is technical, not just instructed

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

## Four scope items

### A — `bc-container launch` command

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

### B — Attachment and injection surface

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

### C — Shared network connectivity

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

### D — Container lifecycle commands

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

## Out of scope — named explicitly

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

## Sequencing

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

## Vehicle hints (Architect's call)

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

## Grounding artifacts

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

## What this leaves open

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
