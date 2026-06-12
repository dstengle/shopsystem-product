# Findings — dummyco instantiation spike, iteration 2 (post-v0.5.0 re-run)

**Spike bead:** lead-jdfb (WS-0, PDR-018 — THE MVP gate). **Iteration:** 2 (the
re-run after shop-templates v0.5.0 ops genericity landed via lead-clpx).
**Date:** 2026-06-12. **Verdict:** *inconclusive-this-iteration* — a
template-defect wall (lead-llc1) blocks the documented path **upstream of the
human credential gate**, so the spike could not reach the ADR-026 D4 human
paste this iteration. The wall is beaded, not hand-patched (ADR-031 D2 / gate
condition 3/8).

## What was executed (the autonomous leg, from EMPTY)

Product slug **dummyco**, org intended **dummyco-org** (not dstengle). Scratch
location `/tmp/spike-dummyco-product` (isolation per ADR-030; `/tmp`, never
committed). Data root `/tmp/spike-dummyco-data` (scratch, not the host default).

1. **Tore down the stale iter-1 scratch** (`/tmp/spike-dummyco-lead`) — it was
   the pre-v0.5.0 pour carrying shopsystem-hardcoded `compose.yaml` +
   `Dockerfile.shopsystem-shell` (the very defects lead-6n8l/lead-we29 were
   filed-and-closed for). Clean slate confirmed: no dummyco containers/
   networks/volumes before start.

2. **Step 1 — Scaffold** via
   `shop-templates bootstrap --shop-type lead --shop-name dummyco-product
   --target /tmp/spike-dummyco-product`. Exit 0.

3. **Step 2/3 — Bring up services** via `docker compose up -d postgres
   agent-vault` (the documented compose-direct path). Network `dummyco`,
   volume `dummyco-agent-vault-data` created; both containers started.

4. **Probed the broker contract** and **ran provision with a dummy PAT**
   (ADR-031 D2 — dummy data, prove the plumbing, do not fake the real secret).
   This surfaced the blocking wall (below).

## Gate conditions reached / proved this iteration

| # | Condition | Status |
|---|---|---|
| 1 | Empty start, proven empty | **PROVED** (with a noted nuance, lead-ii9q): `briefs/adr/pdr/features` are *absent*, not present-and-empty; zero carried-over shopsystem product content — inheritance boundary satisfied. |
| 2 | Distinct identity end-to-end | **PARTIAL** — slug `dummyco` rendered through all ops (network/containers/DB/volume/ports). Not yet exercised through a message projection (blocked downstream). |
| 3 | One BC via documented path only, no hand-edits | **NOT REACHED** — blocked before BC launch. But the *no-hand-edit discipline held*: the broker wall was beaded, not patched. |
| 4–7 | Typed round-trip + §6.4 cycle | **NOT REACHED** — blocked at Step 3/4 (broker). |
| 8 | Every wall a bead + fix, validated by re-run | **IN PROGRESS** — walls beaded (lead-llc1/pwl8/ii9q/2ra5); fixes not yet landed; re-run pending. |
| 9–10 | Real feature, self-contained docker | **NOT REACHED**. |

**ops genericity (the v0.5.0 deliverable) — independently PROVED clean:**
`compose.yaml`, `bin/{shop-shell,agent-vault-provision,agent-vault-check}`,
`Dockerfile.dummyco-shell` carry **zero `shopsystem` literals**; the `dummyco`
slug is rendered correctly everywhere (network `dummyco`, `dummyco-postgres`,
`dummyco-agent-vault`, DB/user/volume `dummyco`, host postgres port **5714** =
5432 + crc32(slug)%1000, distinct from the live fleet's 5432). The WS-2 ops
wall that blocked iter-1 (lead-6n8l/lead-we29) is closed and verified here.

## Where it STOPPED — and why it is NOT the human gate

The documented path **did not reach the ADR-026 D4 human credential gate** this
iteration. It stopped earlier, at a **template-defect wall**: the rendered
`agent-vault` compose service uses image `hashicorp/vault:latest` (HashiCorp
Vault) instead of the actual broker `infisical/agent-vault:latest`. The
provision script's `docker exec dummyco-agent-vault agent-vault put …` fails:

```
OCI runtime exec failed: exec: "agent-vault": executable file not found in $PATH
```

This failure occurs at the **GitHub-PAT store step — before** the
Claude-OAuth dashboard paste the human gate consists of. So the human gate
(what dave would paste: the GitHub PAT, then the Claude-OAuth credential into
the agent-vault dashboard for broker `dummyco-agent-vault`/vault `dummyco`) is
**not yet reachable**: the rendered broker is the wrong image and could not
hold either credential nor proxy traffic. Per ADR-031, a template-defect wall
is **not** a human wall — it must be fixed and re-run, not deferred to a
Phase-2 operator step.

## Walls hit → beads filed

| Wall | Bead | Owner / Vehicle | Severity |
|---|---|---|---|
| Rendered `agent-vault` compose service = `hashicorp/vault:latest`, not `infisical/agent-vault:latest`; also missing `AGENT_VAULT_MASTER_PASSWORD` env + broker ports 14321/14322. `agent-vault put/get` fail → provision + proxy impossible. | **lead-llc1** (P0) | shopsystem-templates ops render → `request_bugfix` | **BLOCKING** |
| Bootstrap renders no `.env.example`, but Brief 011 Step 2 says `cp .env.example .env`. | **lead-pwl8** (P1) | shopsystem-templates (render `.env.example`) / or WS-2 Brief 011 amend → `request_bugfix` | path gap |
| `briefs/adr/pdr/features` absent (not present-and-empty) — gate-condition-1 wording nuance. | **lead-ii9q** (P2) | lead-po (gate wording) / shopsystem-templates (placeholders) | note |
| `Dockerfile.dummyco-shell` `FROM ghcr.io/dstengle/devcontainer-python-node-claude` — dstengle base image. Non-blocking (shell build not on the bring-up path). | **lead-2ra5** (P2) | shopsystem-templates → `request_bugfix` | note |

All four carry `discovered-from:lead-jdfb`; lead-llc1/pwl8 also
`discovered-from:lead-l7uz` (WS-2). lead-llc1 is the one that must land before
iteration 3 can reach the human gate.

## Standing dummyco infra (for router verify / teardown)

- Containers: `dummyco-postgres` (host port **5714**→5432, healthy),
  `dummyco-agent-vault` (image `hashicorp/vault:latest` — the wrong image;
  no published host ports).
- Network: `dummyco`. Volume: `dummyco-agent-vault-data`. Data bind:
  `/tmp/spike-dummyco-data/pgdata`.
- Scratch repo: `/tmp/spike-dummyco-product` (never committed).
- **Teardown** (per ADR-030 — these are NOT `spike-` prefixed; named by slug
  for compose-scoping, so teardown is by the `dummyco` filter):
  ```
  docker compose -f /tmp/spike-dummyco-product/compose.yaml down -v
  docker network rm dummyco 2>/dev/null
  rm -rf /tmp/spike-dummyco-product /tmp/spike-dummyco-data
  ```

## Live fleet — undisturbed

The 4 live BCs (`bc-shopsystem-{scenarios,messaging,bc-launcher,templates}`),
`shopsystem-agent-vault-1` (ports 14321-14322), and
`shopsystem-messaging-postgres-1` (port 5432) were not touched, restarted, or
reconfigured. The in-flight `lead-m56e` dispatch to shopsystem-templates was
not disturbed. dummyco bound a distinct network, distinct host port (5714),
distinct volume — no collision.

## What iteration 3 must cover

1. Land **lead-llc1** (broker image + master-password env + ports in the
   rendered ops compose) via `request_bugfix` to shopsystem-templates; cut a
   templates release; re-pour onto the lead host (the v0.5.0→vNext cadence).
2. Land **lead-pwl8** (`.env.example`) so Step 2 is executable as written.
3. Re-run iteration 3 from empty: scaffold → `.env` master-password →
   `docker compose up` (now a real broker) → `agent-vault-provision`, which
   should this time reach **the genuine human gate** (Claude-OAuth dashboard
   paste). STOP there per ADR-031; that is the legitimate confirm-with-wall
   stop. Then downstream: declare+launch the one dummy BC, dispatch
   `assign_scenarios`, reconcile (conditions 4–10).

## Verdict

**inconclusive (this iteration).** The v0.5.0 ops *genericity* is proven clean
(zero shopsystem literals, correct slug projection, distinct net/ports). But
the rendered ops carries a **broker-image defect (lead-llc1)** that blocks the
documented path before the human gate. The spike correctly **beaded the wall
rather than hand-patching it** (ADR-031 D2; gate condition 3/8). lead-jdfb
stays `in_progress` — the gate is cleared only by a clean re-run of 1–10.
This iteration's durable output is this findings doc + the bead trail.
