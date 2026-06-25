# INSTALL — bring up a new shopsystem product

> **Footing is a one-time, deterministic runway.** Run it once, on a **fresh**
> `<product>-lead` fork against a **fresh** broker. Re-running with reused
> credentials or an already-provisioned broker conflicts (owner already
> registered, vault already exists, beads repo already created). For a clean
> test, always start from a fresh fork + fresh broker state.
>
> Status: the footing **provisioning path is verified end-to-end** (scripted
> `.env` → infra up → network self-attach → local-first agent-vault reaches the
> broker). The git/beads/remote-push half and the exact post-footing ergonomics
> are still being shaken out — test and report; this is current best understanding.

Prerequisites: **Docker** (running; your user can use it) and **`gh`**
authenticated to GitHub.

## 1 — Create your lead repo from the starter

Create a new repository from the `shopsystem-starter` template, named
`<product>-lead` (the `-lead` suffix is required — footing derives the product
slug by stripping it). Then clone it and enter it:

```bash
gh repo create <you>/<product>-lead --template dstengle/shopsystem-starter --clone
cd <product>-lead
```

The starter carries only `README.md` + `bin/bootstrap` — all framework code is
pulled from the published image at bootstrap time, so the fork never goes stale.
(If you named the repo without `-lead`, `bin/bootstrap` prints the exact
`gh repo rename <product>-lead` to run, then re-run `./bin/bootstrap`.)

## 2 — Run the footing

```bash
./bin/bootstrap
```

`bin/bootstrap` pulls the published framework image and renders the lead shop
from it (`compose.yaml`, `.env.example`, `bin/footing`, the ops scripts), then
runs `bin/footing` in a container — the deterministic, agent-less runway. At its
**single up-front auth gate** it prompts you once for:

- an agent-vault **owner password** (you choose it), and
- your **GitHub PAT** (`repo` + `delete_repo` scope).

Footing then runs to solid footing without further interaction:

1. scripts `.env` — generates `AGENT_VAULT_MASTER_PASSWORD` and sets the
   in-network `AGENT_VAULT_ADDR=http://<product>-agent-vault:14321` **before**
   the broker starts;
2. `docker compose up -d postgres agent-vault`;
3. **attaches its own container to the `<product>` network** (so the in-network
   broker address resolves from inside footing);
4. provisions the GitHub credential **locally** (`agent-vault` against
   `AGENT_VAULT_ADDR`, not `docker exec`);
5. creates the `<product>-lead-beads` tracker repo and wires the git + beads
   remotes;
6. proves footing with the first `git push` + `bd dolt push`;

then **stops** and prints the Claude-OAuth proposal-approval command.

## 3 — Approve the Claude credential

Supply your Claude token to the approval helper (it attaches `CLAUDE_OAUTH` into
the broker):

```bash
bin/agent-vault-approve-claude <your-claude-token>
```

## 4 — Begin Discovery

```bash
bin/shop-shell
```

`bin/shop-shell` launches the lead agent session as a container on the
`<product>` network (and runs the broker credential advisory on the way in).
Product **Discovery** and BC creation are agent-driven and begin here — they are
downstream of footing, **not part of it** (ADR-040).

## Where details live

- Unified bringup decision: [`pdr/021-unify-product-bringup-on-the-footing-runway.md`](pdr/021-unify-product-bringup-on-the-footing-runway.md)
- Footing vs Discovery split; framework-in-image-only: [`adr/040-adopter-footing-is-a-deterministic-agentless-bootstrap-distinct-from-agent-driven-discovery.md`](adr/040-adopter-footing-is-a-deterministic-agentless-bootstrap-distinct-from-agent-driven-discovery.md)
- Broker model + the one human gate: [`adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md`](adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
- Bootstrap brief: [`briefs/012-adopter-bootstrap-stand-up-product.md`](briefs/012-adopter-bootstrap-stand-up-product.md)
