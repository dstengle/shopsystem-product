---
name: bring-up-bc
description: Launch an already-scaffolded Bounded Context as a running, online container and verify it reaches the online state
---

# Bringing Up a BC

## Overview

This skill is the **launch leg** of standing up a Bounded Context. It assumes
the BC repository already exists (scaffolded and pushed to a remote) and is
registered in the fleet manifest. Its job is to launch that BC as a running
container and confirm it has come online and is reachable on the shop's
inbox/outbox bus.

The companion `create-bc` skill owns the from-scratch path (scaffold → remote →
manifest) and cross-references this skill for the launch leg. When you are only
re-launching an existing, already-registered BC, you start here.

This is lead-shop work: only the lead operates `bc-container` and reads the
fleet-wide `shop-msg bc-status` view.

## Protocol

### 1. Launch the BC container

Launch the BC with `bc-container launch`. The launcher pulls the BC's repo into
a fresh container built from the pinned bc-base image, wires it onto the shop
network, and points it at the agent-vault broker so the BC's outbound calls get
real credentials injected on the wire.

```bash
bc-container launch <bc-name>
```

`bc-container` reads the BC's entry from `bc-manifest.yaml` — the registration
the `create-bc` flow wrote — for the repo URL, image pin, network, broker, and
env-file. If you are launching a BC that `create-bc` just registered, those
flags are already recorded; you do not re-pass them here.

### 2. The `BCLAUNCHER_HOST_HOME` devcontainer fact (bind-mounted-home case only)

`BCLAUNCHER_HOST_HOME` is required **only** for the **workspace-mount /
bind-mounted-home devcontainer** launch case — it is *not* a universal
launch-time setting. When the BC runs inside a **devcontainer with a
bind-mounted home directory**, the launcher needs the *host* path of that home
so it can bind-mount it into the container at the same location the in-container
tooling expects. That host path is supplied through the `BCLAUNCHER_HOST_HOME`
environment variable:

```bash
# workspace-mount / bind-mounted-home devcontainer case only:
export BCLAUNCHER_HOST_HOME="$HOME"
bc-container launch <bc-name>
```

In that bind-mounted-home case, without `BCLAUNCHER_HOST_HOME` set the launcher
cannot resolve the host side of the bind mount and the container comes up with a
home that is missing the credential-helper config, the git identity, and the
agent-vault client material the BC needs.

A **clone-path BC launch does not require `BCLAUNCHER_HOST_HOME`.** On the
clone path the launcher pulls the BC's repo into a fresh container and the
container's credentials arrive on the wire through the agent-vault broker — there
is no bind-mounted host home to resolve, so there is nothing for
`BCLAUNCHER_HOST_HOME` to point at. Do **not** treat `BCLAUNCHER_HOST_HOME` as
universally required for every launch; set it only for the bind-mounted-home
devcontainer case above.

### 3. Verify the BC reaches `online`

A launch that returns exit 0 only means the container *started*; it does not
mean the BC has registered on the bus and is ready to receive dispatches. Verify
the BC reaches **`online`** through the fleet status view:

```bash
shop-msg bc-status
```

`shop-msg bc-status` reports each registered BC and its current state. Watch the
target BC's row transition to `online`. A BC that is stuck in a starting or
errored state has not come up cleanly — read its container logs before
dispatching any work to it. Do not consider the bring-up complete until
`shop-msg bc-status` shows the BC `online`.

## Definition of Done

- For the workspace-mount / bind-mounted-home devcontainer case,
  `bc-container launch <bc-name>` ran with `BCLAUNCHER_HOST_HOME` exported to the
  host home directory; a clone-path launch does not require it.
- `shop-msg bc-status` shows the BC in the `online` state.
- The BC accepts a `shop-msg` ping/dispatch (it is reachable on the bus, not
  merely "container running").

## Experimental honesty

The end-to-end launch path is still being hardened. Narrate each step to the
user as you go and confirm the `online` transition with them before treating the
BC as ready for real dispatches — a green container is not yet a proven online
BC.
