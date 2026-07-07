---
id: PDR-004
kind: pdr
title: BC container command ownership
status: draft
date: "2026-05-20"
description: BC container command ownership
beads: [lead-po]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: []
  pins: []
  related: []
---
# PDR-004 — BC container command ownership

**Status:** draft (2026-05-20)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** brief 004 (BC container isolation); stakeholder intent
2026-05-20: *"The goal is isolation between the BCs and having work
proceed through contracts and not reading code."*

## The question

Which bounded context owns the `bc-container` command surface —
the CLI that launches, attaches to, and lifecycle-manages per-BC Docker
containers?

The answer determines which BC receives the `assign_scenarios` dispatch
for brief 004's scope items, which repo the implementation lives in,
and what the command's install path is.

## Context

Brief 004 commits a `bc-container launch` command (and companion attach,
inject, monitor, stop, status, list) that:

1. Takes a BC name (or repo URL + branch).
2. Starts a Docker container from the `shopsystem-devcontainer` image.
3. Runs a container-init sequence (clone, `bd init`, venv install, arm
   Monitor).
4. Starts a named tmux session with the Claude Code agent.
5. Returns control to the host with the container running in background.

This is a distinct capability from the devcontainer image itself
(devcontainer is the *image*; this command is the *launcher*).
It is also distinct from inter-shop messaging (`shop-msg` routes
messages; this command routes *containers*).

## Options considered

### Option A — New BC: `shopsystem-bc-launcher`

A new BC is created whose sole product is the `bc-container` CLI.
Rationale: the command's concern (Docker container lifecycle for BC
shops) is a fresh subdomain not owned by any existing BC. A fresh BC
means no existing BC takes on an out-of-domain concern; the dependency
graph is clean.

**Pros:**
- Clean separation of concerns; no existing BC broadens scope.
- A new BC gets its own scenario register, its own inbox/outbox, its
  own CI pipeline.
- Extension (e.g., a `bc-container ps` or `bc-container logs`) lands
  in the right place without negotiating scope with an existing BC.

**Cons:**
- More repos to manage. Today the product already has five BC repos;
  a sixth adds operational overhead.
- The launcher is thin. If the bulk of its implementation is
  shell-calling `docker run` with the right flags, a new BC may be
  under-weight for its own repo.
- A new BC needs bootstrapping (brief 002 work), its own
  `shopsystem-templates` role templates, its own beads remote.

### Option B — Existing BC: `shopsystem-devcontainer`

The devcontainer BC already owns the image; it also owns the launch
command. Rationale: "image + launcher" is a common pattern (Dockerfile
+ `docker-compose.yml` live together).

**Pros:**
- The team that builds the image knows the image's runtime requirements
  best.
- No new BC, no new repo.
- The launcher's integration tests can run against the image built in
  the same repo's CI.

**Cons:**
- Scope broadens. The devcontainer BC's current contract is "build and
  publish an image"; "launch per-BC containers" is a separate
  operational concern. A BC whose name is `devcontainer` owning a
  `bc-container launch` CLI is a naming mismatch.
- The devcontainer BC is in flight (active scenarios). Adding
  `bc-container` scope before that work closes risks collision.
- The launcher has host-side orchestration concerns (e.g., tracking
  which containers are running, mailbox volume management) that are
  not image-build concerns.

### Option C — Existing BC: `shopsystem-templates`

The templates BC already owns the bootstrap CLI (`shop-templates`).
The launcher could be a new subcommand on that CLI:
`shop-templates bc-container launch ...`. Rationale: bootstrap is about
standing up shops; launching containers is standing up shops in a new
medium.

**Pros:**
- No new BC, no new repo.
- A natural extension of the bootstrap surface (brief 002), which
  already commits "standing up a BC shop in a given environment."
- `shop-templates update` and `shop-templates bc-container launch` are
  thematically related: both are about getting a BC into a known good
  state.

**Cons:**
- The templates BC is already under heavy load: PDR-001 restructure
  (lead-kq0), CLAUDE.md propagation (PDR-003), bootstrap surface
  (brief 002), event-driven settings (brief 003). Folding in
  `bc-container` before that work closes risks priority dilution.
- Naming: `shop-templates bc-container launch` is verbose and hides
  the "container" concern behind the "templates" name.
- Docker/container concerns are not obviously a templates domain.

### Option D — Existing BC: `shopsystem-messaging`

The messaging BC owns the inter-shop surface. The launcher could
include mailbox volume management as a first-class concern.

**Pros:**
- The messaging BC is the right owner of any concern about how mailboxes
  are reachable across a container boundary.

**Cons:**
- The messaging BC's domain is *message schemas and routing*, not
  *container lifecycle*. Adding Docker orchestration to `shop-msg` is a
  large scope increase.
- The CLI naming (`shop-msg container launch`) is a category error.
- Mailbox volume management is a configuration concern for the launcher,
  not a core messaging concern.

## Session manager: tmux vs screen vs background process

The question of which process manager to use inside the container:

- **tmux** — named sessions, scriptable attach/send-keys/capture-pane,
  widely available, familiar to developers. The shopsystem devcontainer
  already includes it (per brief 002 / devcontainer scenarios in
  flight). Supports: human attach, automated inject (send-keys),
  monitoring (capture-pane streamed to host). **PO recommends.**
- **screen** — older, similar primitives. Less ergonomic for scripted
  inject. No advantage over tmux on a controlled image. **Rejected.**
- **Background process (no session manager)** — start Claude Code with
  stdout/stderr redirected to a log file; no interactive attach; no
  inject. Fails the "allow direct interaction" requirement.
  **Rejected.**
- **nohup + socat** — run Claude Code in background, attach via socat
  socket. More complex, less standard than tmux. **Rejected.**

tmux is the committed choice. The PO does not defer this to the
Architect because the requirement (attach, inject, monitor) is directly
satisfiable by tmux primitives already verified to exist on the image.

## Docker invocation style: `docker run` vs Compose vs Kubernetes

- **`docker run` with flags** — direct, minimal dependencies, no
  compose file to maintain. Scriptable. The launcher wraps `docker run`
  with the right flags (volumes, env, network, name). **PO recommends
  for the initial implementation.**
- **Docker Compose** — adds a `docker-compose.yml` as a new artifact
  per-BC or per-product. Useful when multi-container orchestration is
  needed. The current brief is single-container-per-BC; Compose adds
  overhead without benefit until multi-container shapes emerge.
  **Deferred — viable follow-on.**
- **Kubernetes / similar** — out of scope for this brief. Cloud
  orchestration is a future capability driver, not a present one.
  **Rejected.**

## Decision

**Option A — New BC: `shopsystem-bc-launcher`**

Rationale:

1. **Domain cleanliness.** Container lifecycle for BC shops is a
   distinct subdomain from image-building (devcontainer), message
   routing (messaging), template management (templates), and scenario
   registration (scenarios). None of the existing BCs is the natural
   home; a new BC draws the right boundary.

2. **Weight justification.** While the launcher's MVP is thin (mainly
   `docker run` orchestration + tmux session management), the scope
   items in brief 004 — including mailbox volume management, lifecycle
   status tracking, inject/monitor surface, and eventual multi-BC
   orchestration — give the BC enough long-term surface to justify its
   own repo.

3. **Avoids adding to already-loaded BCs.** Templates, devcontainer,
   and messaging are all under active load. A new BC starts clean.

4. **Name.** `shopsystem-bc-launcher` is self-documenting: it launches
   BC containers. The CLI it exports is `bc-container` (short, tab-
   completable, distinct from existing CLIs).

**tmux** is the committed session manager. `docker run` (not Compose)
is the committed invocation style for the initial implementation.

## What this leaves open

1. **Bootstrapping `shopsystem-bc-launcher` itself.** Before the first
   `assign_scenarios` dispatch can land, the new BC's repo must exist,
   be bootstrapped with `shop-templates` (brief 002), and be cloned
   into the lead shop's `repos/` directory. The Architect's pre-state
   work must include creating the repo.

2. **Mailbox volume mechanism (brief 004 scope item C).** The PDR
   commits that the launcher owns the volume-mounting decision; it does
   not commit the mechanism. The Architect picks bind-mount vs. named
   volume after verifying what `shop-msg --bc-root` accepts and what
   the devcontainer image expects.

3. **CLI name final form.** The PDR commits `bc-container` as the CLI
   name and `bc-container launch / attach / inject / monitor / stop /
   status / list` as the subcommand surface. Exact flag shapes are
   scenario-level.

4. **Image tag source.** How `bc-container launch` knows which image
   tag to pull — a config file in the launcher BC, a flag, an env
   var, `latest` hardcoded — is the Architect's call at pre-state.

## Cross-references

- [brief 004](../briefs/004-bc-container-isolation.md) — the intent
  this PDR is decided against.
- [brief 002](../briefs/002-shop-bootstrap-cli-surface.md) — the
  bootstrap surface the launcher BC will itself use to be bootstrapped.
- [brief 003](../briefs/003-event-driven-shop-activation.md) — the
  Monitor-arming hook the container init sequence must activate inside
  the container.
- [features/devcontainer/](../features/devcontainer/) — the image the
  launcher consumes.
