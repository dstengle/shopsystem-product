> **ARCHIVED** — historical spike record, not current state (ADR-065). Superseded by: no dedicated graduation ADR — throwaway WS-0/PDR-018 MVP-gate iteration; the MVP gate itself closed in a later iteration under the same epic (lead-jdfb).

# Findings — dummyco instantiation spike, iteration 3 (post-v0.6.0 re-run)

**Spike bead:** lead-jdfb (WS-0, PDR-018 — THE MVP gate). **Iteration:** 3 (the
re-run after shop-templates **v0.6.0** landed the broker-image fix lead-llc1 and
the `.env.example` fix lead-pwl8/c8096df3, re-poured onto the lead host).
**Date:** 2026-06-12. **Verdict:** *inconclusive-this-iteration, but materially
advanced* — iter-3 reached **the Claude-OAuth human gate on the no-PAT path**
(iter-2 could not reach any human gate), and **stands the REAL broker up serving**.
But a **new, deeper template-defect wall** (lead-beym) blocks the GitHub-PAT arm
of the one human gate, and a healthcheck-definition wall (lead-3uft) leaves the
broker perpetually `unhealthy`. Both are beaded, not hand-patched (ADR-031 D2 /
gate condition 3/8). lead-jdfb stays `in_progress`.

## What changed since iter-2 — both iter-2 blocking walls are FIXED and verified

iter-2 stopped at a wrong-image wall (lead-llc1: `hashicorp/vault:latest` instead
of the real broker) and a `.env.example` render gap (lead-pwl8). Both landed in
**shop-templates v0.6.0**, re-poured here. iter-3 verifies both empirically:

- **lead-llc1 (broker image) — VERIFIED FIXED.** Rendered `compose.yaml`
  `agent-vault.image = infisical/agent-vault:latest`; hashicorp count **0**;
  `AGENT_VAULT_MASTER_PASSWORD` env present; broker host ports published
  (14730→14321 API, 15287→14322 proxy). The container comes up and the real
  `agent-vault` CLI is present (`/usr/local/bin/agent-vault`, version **0.32.0**)
  — the exact thing that failed in iter-2 with the wrong image now works.
- **lead-pwl8 (`.env.example`) — VERIFIED FIXED, CLOSED.** Bootstrap now renders
  a top-level `.env.example` (1073 bytes) carrying `AGENT_VAULT_MASTER_PASSWORD`
  + `AGENT_VAULT_ADDR`/`AGENT_VAULT_TOKEN` placeholders. Brief 011 Step 2
  `cp .env.example .env` executes as written; iter-3 used it. **Closed
  reconciled-complete** (`--force`; only remaining edge was the parent epic
  lead-l7uz).

## What was executed (the autonomous leg, from EMPTY)

Product slug **dummyco** (org not dstengle). Scratch repo
`/tmp/spike-dummyco-product`; scratch data root `/tmp/spike-dummyco-data`
(isolation per ADR-030; `/tmp`, never committed). Clean slate confirmed before
start: no dummyco containers/networks/volumes/scratch existed.

1. **Step 1 — Scaffold** via `shop-templates bootstrap --shop-type lead
   --shop-name dummyco-product --target /tmp/spike-dummyco-product`. Exit 0.
   `briefs/adr/pdr/features` all **absent** (zero carried-over shopsystem
   content — inheritance boundary satisfied). `compose.yaml`, `.env.example`,
   `bin/{shop-shell,agent-vault-provision,agent-vault-check,shop-scenario-completion}`,
   `Dockerfile.dummyco-shell` rendered.
2. **Step 2 — Instance secret** via `cp .env.example .env`; set
   `AGENT_VAULT_MASTER_PASSWORD` to a generated `openssl rand -base64 32` (the
   broker's own auto-unseal password — a throwaway broker secret, NOT a human-gate
   credential); pointed `DUMMYCO_DATA` at the scratch data root.
3. **Step 3 — Supporting services** via `docker compose up -d postgres
   agent-vault`. Network `dummyco` + volume `dummyco-agent-vault-data` created;
   both containers started. **The REAL broker now serves** (logs: "Agent Vault
   server listening on http://0.0.0.0:14321" + "transparent proxy listening on
   0.0.0.0:14322"). postgres healthy on host port 5714.
4. **Step 4 — Provision (the human gate)** via `bin/agent-vault-provision`. This
   surfaced the two new walls below (ADR-031 D2: ran with a DUMMY PAT to prove
   plumbing up to the wall; did NOT paste any real credential). STOPPED here.

## Where it STOPPED — and the human-gate reachability nuance

The provision script has two arms (Brief 011 Step 4 / ADR-026 D4 = two pastes):
the **GitHub PAT** (scripted) and the **Claude-OAuth dashboard paste** (the
manual `read`-prompt gate). iter-3 establishes:

- **GitHub-PAT arm — WALLED (lead-beym).** The script runs
  `docker exec dummyco-agent-vault agent-vault put --vault dummyco --name
  github-pat --value $GITHUB_PAT`, which fails `unknown command "put"` (exit 1).
  agent-vault 0.32.0 has **no `put` verb** — its real surface is
  `account/agent/auth/ca/catalog/owner/run/server/master-password` and the
  credential model is the owner→vault→agent/service/credential flow **ADR-026 D2
  already documents** (`credential set`, `service add`, `agent create`). The
  provision script was written against an **invented** CLI surface. Because the
  script is `set -euo pipefail`, a supplied `GITHUB_PAT` aborts here BEFORE the
  Claude-OAuth prompt.
- **Claude-OAuth arm — REACHED (on the no-PAT path).** With `GITHUB_PAT` unset,
  the script skips the broken `put` cleanly and **reaches the Claude-OAuth
  dashboard human-gate prompt** (verified, the prompt renders and the script
  `read`-waits). This is the legitimate ADR-031 confirm-with-wall stop — but only
  the Claude arm; the GitHub arm is unprovisioned.

**Did iter-3 reach the human credential gate?** PARTIALLY — yes for the
**Claude-OAuth dashboard arm** (reachable, correctly structured), no for the
**GitHub-PAT arm** (walled by the stale `put` verb). So the *single human gate*
is not yet cleanly reachable as one unit: a real run that supplies both
credentials walls at the GitHub `put` before the dashboard prompt. iter-2 reached
**neither**; iter-3 reaches **one of two**. Material progress, not a clean gate.

## The exact gate state (for dave, once lead-beym lands)

When lead-beym is fixed, the human gate dave performs is, in the running
**`dummyco-agent-vault`** broker (vault `dummyco`, network `dummyco`):

1. **GitHub PAT** — provided to `bin/agent-vault-provision` (env `GITHUB_PAT=...`),
   stored via the REAL agent-vault 0.32.0 flow (`credential set` / `service add`,
   per ADR-026 D2) — NOT `agent-vault put`.
2. **Claude-OAuth** — pasted by hand into the **agent-vault dashboard**
   Credentials tab (the refreshing OAuth credential type, which has no CLI path
   in 0.32.0 — ADR-026 D2 provisioning caveat). The provision script's
   `read`-prompt waits for this and is correctly structured today.

Note also (folded into lead-beym): provision currently never mints the
`dummyco-fleet` agent token nor writes `AGENT_VAULT_ADDR`/`AGENT_VAULT_TOKEN`
back to `.env` (they stay `<changeme-...>`), so even past the human gate the
bootstrap is not yet complete through to BC launch.

## Gate conditions reached / proved this iteration

| # | Condition | Status |
|---|---|---|
| 1 | Empty start, proven empty | **PROVED** — `briefs/adr/pdr/features` absent; zero carried-over shopsystem content (nuance tracked lead-ii9q). |
| 2 | Distinct identity end-to-end | **PARTIAL (advanced)** — slug `dummyco` rendered through ALL ops (network/containers/DB/volume/ports/provision script: container `dummyco-agent-vault`, vault `dummyco`, network `dummyco`). The REAL broker now serves under the slug. Not yet exercised through a message projection (blocked downstream of provision). |
| 3 | One BC via documented path only, no hand-edits | **NOT REACHED** — blocked before BC launch by lead-beym (+lead-3uft for the health gate). No-hand-edit discipline HELD: both new walls beaded, not patched. |
| 4–7 | Typed round-trip + §6.4 cycle | **NOT REACHED** — blocked at Step 4 (provision). |
| 8 | Every wall a bead + fix, validated by re-run | **IN PROGRESS** — iter-2 walls lead-llc1/pwl8 fixed+verified this iter; new walls lead-beym/lead-3uft beaded; re-run pending. |
| 9–10 | Real feature, self-contained docker | **NOT REACHED** (downstream of provision + BC launch). |

**ops genericity — re-confirmed clean (v0.6.0):** `compose.yaml`, `.env.example`,
`bin/*` carry **zero `shopsystem`/`dstengle` literals**; the `dummyco` slug renders
everywhere (network `dummyco`, `dummyco-postgres`, `dummyco-agent-vault`,
DB/user/volume `dummyco`, host ports 5714/14730/15287 all distinct from the live
fleet's 5432/14321/14322). The single surviving `dstengle` literal is
`Dockerfile.dummyco-shell` FROM (the lead daily-driver SHELL base) — already
beaded **lead-2ra5** (P2, non-blocking; not on the bring-up path).

## Walls hit → beads filed (NEW this iteration), in execution order

| # | Wall | Bead | Owner / Vehicle | Severity |
|---|---|---|---|---|
| 1 | `bin/agent-vault-provision` GitHub-PAT step calls `agent-vault put --vault --name --value` — a **fictional verb**; agent-vault 0.32.0 has no `put`. Fails exit 1 before the human gate when a PAT is supplied. ALSO never mints the `<slug>-fleet` agent token nor writes `AGENT_VAULT_ADDR/TOKEN` to `.env` (folded in). | **lead-beym** (P0) | shopsystem-templates (provision script) → `request_bugfix` | **BLOCKING** (GitHub arm of the gate + BC launch) |
| 2 | `compose.yaml` agent-vault healthcheck uses bash-ism `exec 3<>/dev/tcp/...`; the broker image has **no bash** → probe fails every interval → broker reports `unhealthy` despite serving (`nc -z 14321` = OK from inside). | **lead-3uft** (P1) | shopsystem-templates (compose render) → `request_bugfix` | non-blocking for bare bring-up; **BLOCKING** for ADR-026 D3 broker-health readiness gate / BC launch |

Both carry `discovered-from:lead-jdfb` and `discovered-from:lead-l7uz` (WS-2).
**lead-beym is the one that must land before iteration 4 can clear the full human
gate;** lead-3uft must land before the gated BC launch downstream.

### Reconciled this iteration (iter-2 walls now fixed)
- **lead-llc1** (P0, broker image) — already CLOSED on templates origin/main;
  iter-3 verifies the fix renders + the broker serves + the `agent-vault` CLI is
  present. Confirmed.
- **lead-pwl8** (P1, `.env.example`) — **CLOSED reconciled-complete this iter**;
  `.env.example` renders and was used for Step 2.

### Missing-doc / interpretation gaps (carried, unchanged)
- **lead-ii9q** (P2) — `briefs/adr/pdr/features` absent vs present-and-empty
  (gate-condition-1 wording). Still open; satisfied-by-interpretation for the spike.
- **lead-2ra5** (P2) — `Dockerfile.dummyco-shell` dstengle base image. Still open;
  non-blocking (shell build not on the bring-up path).

## Standing dummyco infra — LEFT UP (successful hand-off state for dave)

Per the task: the dummyco infra is **left running** at the gate (not torn down —
this is the hand-off state, unlike a wall-hit teardown), so dave can paste into
the running broker once lead-beym lands.

- **Containers:**
  - `dummyco-postgres` — `postgres:16`, host port **5714**→5432, **healthy**.
  - `dummyco-agent-vault` — `infisical/agent-vault:latest` (the REAL broker, 0.32.0),
    host ports **14730**→14321 (API) + **15287**→14322 (proxy). Reports
    `unhealthy` due to lead-3uft (bash-ism healthcheck) but **is serving** —
    `agent-vault version` responds, both listeners up, `nc -z 14321` OK.
- **Network:** `dummyco`. **Volume:** `dummyco-agent-vault-data`.
- **Scratch repo:** `/tmp/spike-dummyco-product`. **Data bind:**
  `/tmp/spike-dummyco-data/pgdata`. (Never committed.)
- **Broker master password:** set in `/tmp/spike-dummyco-product/.env`
  (`AGENT_VAULT_MASTER_PASSWORD`, generated, throwaway). `AGENT_VAULT_ADDR`/
  `AGENT_VAULT_TOKEN` remain placeholders (provision does not yet populate them —
  lead-beym).

**Teardown** (for dave when done — named by slug, compose-scoped):
```
docker compose -f /tmp/spike-dummyco-product/compose.yaml down -v
docker network rm dummyco 2>/dev/null
rm -rf /tmp/spike-dummyco-product /tmp/spike-dummyco-data
```

## Live fleet — undisturbed

The 4 live BCs (`bc-shopsystem-{scenarios,messaging,bc-launcher,templates}`, all
healthy), `shopsystem-agent-vault-1` (ports 14321-14322, healthy), and
`shopsystem-messaging-postgres-1` (port 5432) were not touched, restarted, or
reconfigured. dummyco bound a distinct network, distinct host ports
(5714/14730/15287), distinct volume — no collision.

## What iteration 4 must cover

1. Land **lead-beym** (rewrite `bin/agent-vault-provision` GitHub-PAT step to the
   real agent-vault 0.32.0 owner/agent/service/credential flow per ADR-026 D2 +
   mint the `<slug>-fleet` token + write back `AGENT_VAULT_ADDR/TOKEN`) via
   `request_bugfix` to shopsystem-templates; cut a templates release; re-pour.
2. Land **lead-3uft** (sh-compatible broker healthcheck, e.g. `nc -z 127.0.0.1
   14321`) so the broker reports healthy and the ADR-026 D3 readiness gate / BC
   launch can proceed.
3. Re-run iteration 4 from empty: scaffold → `.env` → `docker compose up` (real,
   healthy broker) → `agent-vault-provision` reaching **the full human gate**
   (GitHub PAT scripted + Claude-OAuth dashboard paste). STOP at the dashboard
   paste per ADR-031. Then downstream: declare+launch the one dummy BC (gated on
   broker health), dispatch `assign_scenarios`, reconcile (conditions 4–10).

## Verdict

**inconclusive (this iteration), materially advanced.** v0.6.0 cleared both
iter-2 walls (verified): the REAL broker now stands up and serves under the
`dummyco` slug with distinct net/ports, and the documented path now reaches the
**Claude-OAuth human gate** on the no-PAT path — neither was true in iter-2. But
two NEW template-defect walls surfaced one layer deeper, in the provision script
and the compose healthcheck (lead-beym P0 / lead-3uft P1), both beaded rather
than hand-patched (ADR-031 D2; gate condition 3/8). The spike has now peeled the
bring-up onion to the provisioning layer. lead-jdfb stays `in_progress` — the
gate is cleared only by a clean re-run of 1–10. This iteration's durable output
is this findings doc + the two new beads + the two iter-2 reconciliations.
