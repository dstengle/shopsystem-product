# Findings — dummyco instantiation spike, iteration 5 (post-v0.8.0: FULL provision E2E to the human gate)

**Spike bead:** lead-jdfb (WS-0, PDR-018 — THE MVP gate). **Iteration:** 5 (the
re-run after shop-templates **v0.8.0** landed the lead-l95x credential-key-casing
fix — kebab `github-pat` → SCREAMING_SNAKE `GITHUB_PAT` — and was re-poured onto
the lead host). **Date:** 2026-06-13.
**Verdict:** *materially advanced — THE PROVISION NOW COMPLETES END-TO-END.* For
the first time the rewritten `bin/agent-vault-provision` runs CLEAN through every
scripted credential verb against the live broker, mints the `dummyco-fleet`
`av_agt_` token, writes `AGENT_VAULT_ADDR`/`AGENT_VAULT_TOKEN` into `.env` (zero
`<changeme>` survives for those), and reaches the Claude-OAuth dashboard human
gate — the genuine ADR-031 wall. The single remaining step is the one-time human
Claude-OAuth paste; the GitHub-arm provisioning is genuinely done. lead-jdfb
stays `in_progress` (downstream conditions 4–10 — BC launch + §6.4 cycle — not
yet reached this iteration).

## Headline (the iter-5 result)

**DID the full provision run end-to-end this time? YES.** Every scripted step ran
clean against the live `dummyco-agent-vault` broker (agent-vault 0.32.0 commit
e01a925), in order, with a DUMMY GitHub PAT + dummy owner password (ADR-031 D2):

| Step (real 0.32.0 verb) | Result against the live dummyco broker |
|---|---|
| `auth register --email owner@dummyco.local` | `✓ Owner account created.` |
| `vault create dummyco` | `✓ Created vault "dummyco" (id: a42159c3-464a-4c40-b68a-08b6a34c5a76)` |
| `vault credential set GITHUB_PAT=… GITHUB_PAT_USER=… --vault dummyco` | `✓ Set credential "GITHUB_PAT"` + `✓ Set credential "GITHUB_PAT_USER"` |
| `vault service add --name github --host github.com --auth-type basic …` | `✓ Service added: github (1 services total)` |
| `agent create dummyco-fleet --token-only --vault dummyco:proxy` | minted a real `av_agt_…` token (71 chars, prefix `av_agt_0`) |
| `.env` writeback | `AGENT_VAULT_ADDR=http://dummyco-agent-vault:14321`, `AGENT_VAULT_TOKEN=av_agt_…`; **0** `<changeme>` for ADDR/TOKEN |
| Claude-OAuth dashboard prompt | **REACHED** — the `read -r -p` human gate displayed; STOPPED here (ADR-031 D4) |

**The `credential set` wall (lead-l95x) is GONE.** iter-4 walled here on kebab
keys; iter-5's rendered v0.8.0 script uses SCREAMING_SNAKE keys (verified: 0
`github-pat`, 9 `GITHUB_PAT`/`GITHUB_PAT_USER` in `bin/agent-vault-provision`
lines 75/120/121/126/127/139/140) and the broker accepts them. **No provision
wall lies behind it** — exactly as iter-4's contract-surface probe forecast. The
provisioning onion is fully peeled; the GitHub arm is complete.

> **On the exit code:** the provision run exited 1 ONLY because I fed `/dev/null`
> (EOF) to its final `read -r -p` human-gate prompt, so `read` returned non-zero
> under `set -euo pipefail`. That is by-design "reach the gate without pasting,"
> NOT a provision failure — every credential verb above returned exit 0 and the
> `.env` writeback completed BEFORE the prompt. The dummy Claude-OAuth credential
> was deliberately NOT pasted (ADR-031 D2: prove plumbing, never fake the secret).

## Broker hand-off state — confirmed on the contract surface (post-run)

- `vault credential list --vault dummyco` → `GITHUB_PAT`, `GITHUB_PAT_USER`
  (the dummy GitHub credential is stored).
- `agent list` → `dummyco-fleet` · role `no-access` · status `active` · vaults
  `dummyco:proxy` · created 2026-06-13T00:11:42Z (the fleet token is minted).
- `.env` carries the real broker addr + the minted `av_agt_` fleet token.

## Did iter-5 reach the Claude-OAuth dashboard human gate? YES.

For the first time on the credential-supplied path, the provision script ran the
ENTIRE scripted flow and reached its `read -r -p` Claude-OAuth dashboard prompt
(line 218) — the single genuine human wall (ADR-031 D1/D4, ADR-026 D2/D4). Per
ADR-031 D2 I STOPPED here: no real Claude-OAuth credential pasted, no dummy faked
into a green result. The wall is now cleanly reachable as one unit on a real
(both-credential) run — the reachability iter-3/iter-4 fell one/two verbs short of.

## The USABLE hand-off for dave (this is finally usable)

The dummyco infra is **LEFT UP**, provisioned through the GitHub arm. The broker
currently holds a **DUMMY** GitHub PAT (ADR-031 D2). To make this a real,
working second product, dave performs exactly two things, once:

**(A) Re-run provision with the REAL GitHub PAT** (overwrites the dummy cred;
`auth register`/`vault create` are idempotent on the existing owner/vault):

```bash
cd /tmp/spike-dummyco-product
export DUMMYCO_DATA=/tmp/spike-dummyco-data
export AGENT_VAULT_OWNER_PASSWORD='<the owner password from .env-adjacent / re-generate>'
export GITHUB_PAT='<dave-real-github-PAT>'
export GITHUB_PAT_USER='<dave-github-login>'   # or leave default x-access-token
bin/agent-vault-provision
```
This re-mints/re-stores cleanly and then **pauses at the Claude-OAuth prompt**.

**(B) Paste the Claude-OAuth credential into the agent-vault dashboard** — the
one human gate (ADR-026 D2: the refreshing-OAuth type has no CLI path in 0.32.0):

- **Container:** `dummyco-agent-vault` (vault `dummyco`, network `dummyco`).
- **Where:** the broker's dashboard, reachable on host port **14730** (API) —
  the dashboard Credentials tab → add a credential of type `claude-oauth` →
  paste the value the Claude dashboard provides → save into vault `dummyco`.
- The value dave pastes is the genuine Claude-OAuth credential from the Claude
  dashboard (the real secret — this is the ONE thing the spike could not supply).
- Then press ENTER at the script's prompt to acknowledge; provision completes.

After (A)+(B) the broker holds dave's real GitHub PAT + the refreshing
Claude-OAuth credential and the minted `dummyco-fleet` token in `.env`. From
there Brief 011 Steps 5–6 (declare + launch the one BC, dispatch
`assign_scenarios`, reconcile) take the spike through conditions 4–10.

**Teardown** (slug-named, compose-scoped, when dave is done):
```bash
docker compose -f /tmp/spike-dummyco-product/compose.yaml down -v
docker network rm dummyco 2>/dev/null
rm -rf /tmp/spike-dummyco-product /tmp/spike-dummyco-data
```

## Gate conditions reached / proved this iteration

| # | Condition | Status |
|---|---|---|
| 1 | Empty start, proven empty | **PROVED** — `briefs/adr/pdr/features` all ABSENT after bootstrap (zero carried-over shopsystem content; absent-vs-empty nuance lead-ii9q still open, satisfied-by-interpretation). |
| 2 | Distinct identity end-to-end | **ADVANCED FURTHER** — slug `dummyco` (org NOT dstengle) renders through ALL ops (network `dummyco`, `dummyco-postgres`/`dummyco-agent-vault`, vault `dummyco`, agent `dummyco-fleet`, ports 5714/14730/15287); the live-broker provision created a real owner + vault `dummyco` (id a42159c3-…) + minted the `dummyco-fleet` token, all under the slug. Not yet exercised through a message projection (downstream, blocked on BC launch). |
| 3 | One BC via documented path only, no hand-edits | **NOT YET REACHED** — provision now clears fully; BC launch (Step 5) is the next leg, gated on the human Claude-OAuth paste. No-hand-edit discipline HELD: zero edits to rendered ops/templates; the credential casing fix landed in shop-templates (lead-l95x/v0.8.0) and re-poured, not patched here. |
| 4–7 | Typed round-trip + §6.4 cycle | **NOT YET REACHED** — downstream of BC launch. |
| 8 | Every wall a bead + fix, validated by re-run | **ADVANCED** — iter-4's lead-l95x (P0 credential casing) is **VALIDATED FIXED this iter** by the clean E2E provision run; no NEW wall surfaced this iteration. |
| 9–10 | Real feature, self-contained docker | **NOT YET REACHED** (downstream of BC launch + dispatch). |

## lead-l95x (credential key casing) — VALIDATED FIXED

iter-4's `vault credential set` kebab-key wall is gone. The rendered v0.8.0
`bin/agent-vault-provision` uses SCREAMING_SNAKE keys end-to-end and the live
0.32.0 broker accepted `vault credential set GITHUB_PAT=… GITHUB_PAT_USER=…`
(`✓ Set credential` ×2, exit 0). This is the live-broker validation lead-l95x's
close-reason called for. No reopening; the fix is real.

## Walls hit → beads filed (NEW this iteration)

**NONE.** No new wall surfaced. The provision ran clean to the genuine human gate
(ADR-031), which is a documented Phase-2 operational step, not a wall/bead.

### Carried, unchanged (non-blocking, not on the bring-up path)
- **lead-2ra5** (P2) — `Dockerfile.dummyco-shell` FROM is dstengle-namespaced
  (the shell base, not on the bring-up path).
- **lead-ii9q** (P2) — `briefs/adr/pdr/features` absent vs present-and-empty
  (gate-condition-1 wording); satisfied-by-interpretation for the spike.

## Standing dummyco infra — LEFT UP (usable hand-off state for dave)

- **Containers:**
  - `dummyco-postgres` — `postgres:16`, host port **5714**→5432, **healthy**.
  - `dummyco-agent-vault` — `infisical/agent-vault:latest` (REAL broker, 0.32.0,
    commit e01a925), host ports **14730**→14321 (API) + **15287**→14322 (proxy),
    **healthy**. **Provisioned** through the GitHub arm: owner account, vault
    `dummyco` (id a42159c3-…), DUMMY GitHub PAT credential, `github` service,
    minted `dummyco-fleet` agent token.
- **Network:** `dummyco`. **Volume:** `dummyco-agent-vault-data`.
- **Scratch repo:** `/tmp/spike-dummyco-product`. **Data bind:**
  `/tmp/spike-dummyco-data/pgdata` (DUMMYCO_DATA). Never committed.
- **`.env`:** `AGENT_VAULT_MASTER_PASSWORD` set (generated throwaway);
  `AGENT_VAULT_ADDR=http://dummyco-agent-vault:14321`;
  `AGENT_VAULT_TOKEN=av_agt_…` (the real minted fleet token — no `<changeme>`).
  Broker holds a DUMMY GitHub PAT — dave re-runs provision with his real PAT.

## Live fleet — undisturbed

The 4 live BCs (`bc-shopsystem-{scenarios,messaging,bc-launcher,templates}`, all
healthy, uptimes 33h/12h/8h/34h), `shopsystem-agent-vault-1` (ports 14321-14322,
healthy, 2d), and `shopsystem-messaging-postgres-1` (port 5432, 2d) were not
touched, restarted, or reconfigured. dummyco bound a distinct network
(`dummyco`), distinct host ports (5714/14730/15287), distinct volume — no
collision.

## What iteration 6 must cover

1. **Human gate (dave, one-time):** re-run provision with the real GitHub PAT +
   paste the real Claude-OAuth credential into the `dummyco-agent-vault`
   dashboard (port 14730). After this, the broker is fully provisioned.
2. **BC launch (Step 5, conditions 2/3):** declare the one dummy BC in
   `bc-manifest.yaml` (`product: dummyco`), `bc-container launch <bc> --image
   <image>`, gated on broker health — surfacing WS-1.2 (`BC_IMAGE` override),
   WS-1.3 (manifest `product:` routing), WS-1.4 (`bring-up-bc` re-template) as
   walls if they bite.
3. **§6.4 cycle (Step 6, conditions 4–7, 9–10):** lead-po authors one trivial
   real-feature scenario; `assign_scenarios` under the dummy slug (WS-1.1
   `SYSTEM_SLUG` projection); `work_done` with `scenario_hashes`; reconcile +
   hash-match (WS-1.5 / lead-ji28 canonicalization adjacency).

## Verdict

**materially advanced — the provision now completes end-to-end.** v0.8.0's
lead-l95x fix is VALIDATED: `bin/agent-vault-provision` runs CLEAN through
`auth register` → `vault create` → `vault credential set` (SCREAMING_SNAKE) →
`vault service add` → `agent create dummyco-fleet --token-only` → `.env`
writeback, against the live broker, and reaches the Claude-OAuth dashboard human
gate. The GitHub-arm provisioning is genuinely complete; the `dummyco-fleet`
`av_agt_` token is minted and written to `.env` (no `<changeme>`). No new wall
surfaced. The single remaining step is the one-time human Claude-OAuth paste
(ADR-031 D4 Phase-2 operational step), which makes this the first **usable**
hand-off: dave re-runs provision with his real PAT and pastes the OAuth
credential into the dashboard, then Brief 011 Steps 5–6 carry the spike through
conditions 4–10. lead-jdfb stays `in_progress` — the gate clears only on a clean
run of all of 1–10. This iteration's durable output is this findings doc + the
lead-l95x live-broker validation; no new bead was needed.
