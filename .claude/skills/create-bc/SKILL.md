---
name: create-bc
description: Create a new Bounded Context from scratch — scaffold, remote, manifest registration, and brokered launch — as the lead shop
---

# Creating a BC From Scratch

## Overview

This skill is the lead shop's procedure for standing up a **brand-new** Bounded
Context: scaffold the repository, create and push its remote, register it in the
fleet manifest, and launch it onto the shop network with credentials brokered
through agent-vault. The launch leg itself is owned by the `bring-up-bc` skill;
this skill cross-references it rather than duplicating it.

This is the proven create-a-BC procedure distilled from standing up real BCs.
The full scaffold-to-repo-to-launch flow is **experimental and not yet verified
end-to-end** — see the experimental-honesty section. As you run it, **narrate
each step to the user and confirm with them as you proceed.**

## Procedure

### 1. Scaffold the new BC

Scaffold the new BC repository from the canonical templates:

```bash
shop-templates bootstrap --shop-type bc --shop-name <product>-<target> --target <path>
```

`shop-templates bootstrap --shop-type bc` writes the BC's `CLAUDE.md`, the typed
`.claude/` files, the role templates, and pours the canonical BC skill tree into
`.claude/skills/`. The `--shop-name` is the BC's canonical shop-identity slug.

### 2. Create the remote and push

Create the GitHub remote and push the scaffolded repo:

```bash
gh repo create <org>/<bc-name> --source . --remote origin --push
```

**Prompt the user for the GitHub org/owner and for the public/private
visibility** — do **not** hardcode them. Different products live under different
GitHub orgs, and visibility is a per-product policy call. Ask the user which
org/owner to create the repo under and whether it should be public or private,
then pass their answers to `gh repo create` (`--public` or `--private`). After
the repo is created, push the scaffold so the launcher can pull it.

### 3. Register the BC in the fleet manifest

Register the new BC in `bc-manifest.yaml` so the launcher knows about it:

```bash
bc-container manifest add <bc-name> --repo-url <url> ...
```

`bc-container manifest` writes the BC's entry into `bc-manifest.yaml` (the
fleet's source of truth for which BCs exist and how to launch each). Until the BC
is registered here, `bc-container launch` cannot find it.

### 4. Launch the BC (see `bring-up-bc`)

Launch the registered BC with `bc-container launch` and the brokered flags:

```bash
bc-container launch <bc-name> \
  --repo-url <url> \
  --image <registry>/bc-base:v0.3.1 \
  --network <product>-net \
  --agent-vault-broker <product>-agent-vault \
  --env-file .env
```

- `--repo-url` — the GitHub URL the launcher clones the BC from.
- `--image` — pin to **bc-base `v0.3.1+`**, never `:latest`. A floating
  `:latest` tag makes launches non-reproducible and silently drifts the base.
- `--network` — the product's shop network so the BC reaches postgres and the bus.
- `--agent-vault-broker` — the broker that injects real credentials on the wire.
- `--env-file` — the env file carrying the BC's launch-time config.

For the launch mechanics — exporting `BCLAUNCHER_HOST_HOME` for the
bind-mounted-home devcontainer and verifying the BC reaches `online` via
`shop-msg bc-status` — **follow the `bring-up-bc` skill.** This skill hands the
launch leg off to `bring-up-bc`; do not re-implement it here.

## Gotchas

These are the misses that cost the most time when standing up a BC:

- **`AGENT_VAULT_VAULT` is the plain `<product>`, not `<product>:proxy`.** The
  vault name is the bare product slug; appending `:proxy` points the broker at a
  vault that does not exist and every brokered call 401s.
- **Credential keys are SCREAMING_SNAKE.** Every brokered credential key in the
  env file is `SCREAMING_SNAKE_CASE` (e.g. `AGENT_VAULT_TOKEN`,
  `AGENT_VAULT_ADDR`). A lower-cased or hyphenated key is not matched by the
  broker.
- **bc-base is pinned to `v0.3.1+`.** Use a concrete bc-base tag at `v0.3.1` or
  newer for `--image`; never `:latest`.

## Experimental honesty

The full scaffold-to-repo-to-launch flow is **experimental and has not yet been
verified end-to-end.** Treat each leg as something to confirm, not assume:
**narrate what you are about to do, run it, show the user the result, and confirm
with the user before moving to the next leg.** If a leg fails, stop and surface
it rather than pressing on — a half-registered or half-launched BC is harder to
recover than a clean restart.

## Definition of Done

- The BC repo is scaffolded, has a remote under the user-chosen org/visibility,
  and is pushed.
- The BC is registered in `bc-manifest.yaml` via `bc-container manifest`.
- The BC launched via `bc-container launch` and reached `online` per the
  `bring-up-bc` skill's `shop-msg bc-status` check.
- You narrated each leg and confirmed it with the user as you went.
