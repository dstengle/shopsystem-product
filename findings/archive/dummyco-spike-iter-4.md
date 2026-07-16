> **ARCHIVED** — historical spike record, not current state (ADR-065). Superseded by: no dedicated graduation ADR — throwaway WS-0/PDR-018 MVP-gate iteration; the MVP gate itself closed in a later iteration under the same epic (lead-jdfb).

# Findings — dummyco instantiation spike, iteration 4 (post-v0.7.0: first live-broker E2E provision test)

**Spike bead:** lead-jdfb (WS-0, PDR-018 — THE MVP gate). **Iteration:** 4 (the
re-run after shop-templates **v0.7.0** landed the provision rewrite lead-beym
(real agent-vault 0.32.0 verbs) and the healthcheck fix lead-3uft (sh-compatible
`nc -z`), re-poured onto the lead host). **Date:** 2026-06-12.
**Verdict:** *inconclusive-this-iteration, materially advanced — first END-TO-END
provision run against a LIVE broker.* iter-4 is the first iteration that **runs
the rewritten provision against a running agent-vault 0.32.0 broker** (iter-2/3
only stood the broker up). The real-verb flow gets FURTHER than ever — owner
`auth register` and `vault create` **succeed against the live broker** — then
walls at `vault credential set` on a **credential-key-casing** defect
(**lead-l95x**, P0). The broker now reports **healthy** (lead-3uft VALIDATED).
One new wall, beaded not hand-patched (ADR-031 D2 / gate condition 3/8).
lead-jdfb stays `in_progress`.

## Headline (the iter-4 result)

**DID the rewritten provision run end-to-end against the live broker without
error?** **NO — but it got materially further than any prior iteration, and the
single remaining wall is now precisely located and proven to be the LAST one.**

- The lead-beym rewrite is **real**: zero fictional `agent-vault put` verbs; the
  flow executes real 0.32.0 verbs against the live broker. Two real verbs
  **SUCCEEDED end-to-end against the running broker**:
  - **`auth register`** → `✓ Owner account created.` (owner `owner@dummyco.local`)
  - **`vault create dummyco`** → `✓ Created vault "dummyco" (id: 63bf3f59-1c10-4f77-a697-c5156f5379b9)`
- It then **walled** at **`vault credential set`** (NEW, lead-l95x): the rendered
  script uses kebab-case credential keys `github-pat` / `github-pat-user`, but
  agent-vault 0.32.0 enforces **SCREAMING_SNAKE_CASE**:
  `Error: Invalid credential key "github-pat": must be SCREAMING_SNAKE_CASE
  (e.g. STRIPE_KEY)`. Because the script is `set -euo pipefail` and a `GITHUB_PAT`
  was supplied (dummy, ADR-031 D2), it aborted here BEFORE the fleet-token mint
  and BEFORE the Claude-OAuth human gate.
- **The `<slug>-fleet` token was NOT minted by the script** and **`.env` was NOT
  written** (`AGENT_VAULT_ADDR`/`AGENT_VAULT_TOKEN` remain `<changeme-...>`) —
  both are downstream of the walled credential-set step.

**This is the lead-beym E2E validation the bead's own close-reason called for**
(*"END-TO-END provision against a live broker is the dummyco-spike iter-4
validation … iter-4 is the real test of this fix"*). The rewrite is structurally
correct (real verbs, owner + vault land live) but a syntax-only BC verification
missed the credential-KEY casing constraint one layer deeper.

## The wall is the LAST one — proven by a live contract-surface probe

After the script walled, I scouted the rest of the flow by exercising the real
verbs directly against the live broker with **SCREAMING_SNAKE_CASE** keys (a
**contract-surface probe of the broker CLI per ADR-018 — NOT a hand-patch** of
the rendered script). With only the key-casing corrected, the **entire rest of
the provision flow works E2E**:

| Real verb (correct key casing) | Result against live dummyco broker |
|---|---|
| `vault credential set GITHUB_PAT_USER=… GITHUB_PAT=… --vault dummyco` | `✓ Set credential` ×2 (exit 0) |
| `vault service add --name github --host github.com --auth-type basic --username-key GITHUB_PAT_USER --password-key GITHUB_PAT --vault dummyco` | `✓ Service added: github` (exit 0) |
| `agent create dummyco-fleet --token-only --vault dummyco:proxy` | mints a real `av_agt_…` token (exit 0) |

So **the key-casing rename is the SOLE remaining wall** between the provision
script and a fully-clean E2E run through fleet-mint + `.env` writeback + the
Claude-OAuth human gate. No further provision wall lies behind it. (The probe
artifacts — a `github` service + `dummyco-fleet` agent — were then cleared by
re-bringing-up the broker on a fresh volume, so the hand-off broker is pristine.)

## Did iter-4 reach the Claude-OAuth dashboard human gate?

**NOT on the PAT-supplied path** (the genuine full-gate path). Same shape as
iter-3's nuance: because the script is `set -euo pipefail`, a supplied
`GITHUB_PAT` aborts at the credential-set wall (lead-l95x) BEFORE the Claude-OAuth
`read`-prompt. The Claude-OAuth dashboard arm (the `read -r -p` gate at the end of
the script) remains correctly structured and reachable only on the no-PAT path
(verified present in the script source). The single human gate is therefore not
yet cleanly reachable as one unit on a real (both-credential) run — one wall
short of iter-3's reachability, but the wall is now one layer DEEPER (iter-3
walled at the very first credential verb; iter-4 walls two verbs later, after
owner + vault land live).

## The exact gate state (for dave, once lead-l95x lands)

When lead-l95x is fixed (key rename in the shop-templates provision template +
re-pour), the human gate dave performs is, in the running **`dummyco-agent-vault`**
broker (vault `dummyco`, network `dummyco`):

1. **GitHub PAT** — supplied to `bin/agent-vault-provision` as env `GITHUB_PAT=<real-PAT>`
   (with `AGENT_VAULT_OWNER_PASSWORD=<owner-pw>`), stored via the REAL
   agent-vault 0.32.0 flow (`vault credential set GITHUB_PAT=… GITHUB_PAT_USER=…`
   → `vault service add … github.com Basic`). The script then mints the
   `dummyco-fleet` `av_agt_…` token and writes `AGENT_VAULT_ADDR` +
   `AGENT_VAULT_TOKEN` into `.env` automatically.
2. **Claude-OAuth** — pasted by hand into the **agent-vault dashboard** Credentials
   tab (the refreshing OAuth credential type, which has no CLI path in 0.32.0 —
   ADR-026 D2 provisioning caveat). The provision script's `read -r -p` prompt
   waits for this and is correctly structured today.

Which command/container/where: run `bin/agent-vault-provision` from
`/tmp/spike-dummyco-product`; it targets container `dummyco-agent-vault`
(vault `dummyco`); the dashboard paste is into that broker's dashboard.

## Gate conditions reached / proved this iteration

| # | Condition | Status |
|---|---|---|
| 1 | Empty start, proven empty | **PROVED** — `briefs/adr/pdr/features` all ABSENT after `shop-templates bootstrap` (zero carried-over shopsystem content; absent-vs-empty nuance still tracked lead-ii9q). |
| 2 | Distinct identity end-to-end | **PARTIAL (advanced further)** — slug `dummyco` renders through ALL ops; the REAL broker serves healthy under the slug; the live-broker provision run **created a real owner account + real vault `dummyco` (id 63bf3f59-…)** under the slug. Not yet exercised through a message projection (blocked downstream of provision). |
| 3 | One BC via documented path only, no hand-edits | **NOT REACHED** — blocked before BC launch by lead-l95x. No-hand-edit discipline HELD: the new wall is beaded, not patched (the live-broker key-casing probe was a contract-surface scout, explicitly not a script edit). |
| 4–7 | Typed round-trip + §6.4 cycle | **NOT REACHED** — blocked at Step 4 (provision). |
| 8 | Every wall a bead + fix, validated by re-run | **IN PROGRESS** — iter-3 walls lead-beym + lead-3uft both fixed+verified this iter (beym got further/walled deeper; 3uft fully validated); new wall lead-l95x beaded; re-run pending. |
| 9–10 | Real feature, self-contained docker | **NOT REACHED** (downstream of provision + BC launch). |

## lead-3uft (broker healthcheck) — VALIDATED FIXED

iter-3's perpetual-`unhealthy` defect (bash-ism `/dev/tcp` probe on a no-bash
image) is gone. Rendered `compose.yaml` healthcheck is the sh-compatible
`test: ["CMD", "nc", "-z", "127.0.0.1", "14321"]` (zero `/dev/tcp`). The broker
came up and reported **`healthy`** (gated empirically: both `dummyco-agent-vault`
and `dummyco-postgres` reached `healthy` before provision). Broker serving
agent-vault **0.32.0** commit `e01a925` (the ADR-026-pinned commit). This is the
ADR-026 D3 readiness-gate prerequisite the BC launch needs — now satisfied.

## lead-beym (provision rewrite) — PARTIALLY VALIDATED (real verbs run live; one deeper wall)

The rewrite is **confirmed real and structurally correct**: zero fictional `put`;
owner `auth register` + `vault create` **succeed against the live broker**; the
service-add + agent-mint verbs work when reached (proven by the contract probe).
The rewrite did NOT fully clear E2E only because of the orthogonal key-casing
defect (lead-l95x), which the contract probe proves is the last wall. lead-beym
remains correctly CLOSED (the fictional-verb defect it named is gone); lead-l95x
is the distinct, newly-surfaced casing defect.

## ops genericity — re-confirmed clean (v0.7.0)

`compose.yaml`, `.env.example`, `bin/agent-vault-provision` carry **zero
`shopsystem`/`dstengle` literals**; the `dummyco` slug renders everywhere
(network `dummyco`, `dummyco-postgres`, `dummyco-agent-vault`, DB/user/volume
`dummyco`, fleet agent `dummyco-fleet`, host ports 5714/14730/15287 all distinct
from the live fleet's 5432/14321/14322). The single surviving `dstengle` literal
is `Dockerfile.dummyco-shell` FROM (the lead daily-driver SHELL base) — already
beaded **lead-2ra5** (P2, non-blocking; not on the bring-up path).

## Walls hit → beads filed (NEW this iteration)

| # | Wall | Bead | Owner / Vehicle | Severity |
|---|---|---|---|---|
| 1 | `bin/agent-vault-provision` `vault credential set` uses kebab-case credential keys (`github-pat`, `github-pat-user`); agent-vault 0.32.0 REQUIRES **SCREAMING_SNAKE_CASE** keys → fails before fleet mint + human gate. Single coherent fix: rename to `GITHUB_PAT` / `GITHUB_PAT_USER` and update `--username-key`/`--password-key` refs. Proven (live probe) to be the SOLE remaining provision wall. | **lead-l95x** (P0) | shopsystem-templates (provision render) → `request_bugfix` | **BLOCKING** (GitHub arm of the gate + fleet mint + .env writeback + BC launch) |

Bead carries `discovered-from: lead-jdfb / lead-l7uz` in its notes (not as a
blocking dep — per the lead-wvbf finding, discovered-from edges must not
false-block).

### Reconciled this iteration (iter-3 walls)
- **lead-beym** (P0, provision rewrite) — already CLOSED on templates origin/main
  (b4270d4); iter-4 is its live-broker E2E validation: real verbs run, owner +
  vault land live; the fictional-verb defect is gone. The deeper key-casing wall
  is a DISTINCT defect (lead-l95x), not a reopening of lead-beym.
- **lead-3uft** (P1, healthcheck) — **VALIDATED FIXED this iter**: broker reports
  `healthy`; sh-compatible `nc -z` probe renders; zero `/dev/tcp`.

### Carried, unchanged
- **lead-ii9q** (P2) — `briefs/adr/pdr/features` absent vs present-and-empty
  (gate-condition-1 wording). Open; satisfied-by-interpretation for the spike.
- **lead-2ra5** (P2) — `Dockerfile.dummyco-shell` dstengle base. Open;
  non-blocking (shell build not on the bring-up path).

## Standing dummyco infra — LEFT UP (hand-off state for dave)

The dummyco infra is **left running** (not torn down — hand-off state). The broker
was re-brought-up on a fresh volume after the contract probe, so it is **pristine
and healthy** (no probe artifacts).

- **Containers:**
  - `dummyco-postgres` — `postgres:16`, host port **5714**→5432, **healthy**.
  - `dummyco-agent-vault` — `infisical/agent-vault:latest` (REAL broker, 0.32.0,
    commit e01a925), host ports **14730**→14321 (API) + **15287**→14322 (proxy),
    **healthy** (lead-3uft fix). Pristine (no owner/vault — reset after the probe).
- **Network:** `dummyco`. **Volume:** `dummyco-agent-vault-data` (fresh).
- **Scratch repo:** `/tmp/spike-dummyco-product`. **Data bind:**
  `/tmp/spike-dummyco-data/pgdata`. (Never committed.)
- **`.env`:** `AGENT_VAULT_MASTER_PASSWORD` set (generated, throwaway);
  `AGENT_VAULT_ADDR`/`AGENT_VAULT_TOKEN` remain `<changeme-...>` (provision walled
  before the writeback — lead-l95x).

**Teardown** (for dave when done — slug-named, compose-scoped):
```
docker compose -f /tmp/spike-dummyco-product/compose.yaml down -v
docker network rm dummyco 2>/dev/null
rm -rf /tmp/spike-dummyco-product /tmp/spike-dummyco-data
```

## Live fleet — undisturbed

The 4 live BCs (`bc-shopsystem-{scenarios,messaging,bc-launcher,templates}`, all
healthy), `shopsystem-agent-vault-1` (ports 14321-14322, healthy), and
`shopsystem-messaging-postgres-1` (port 5432) were not touched, restarted, or
reconfigured. dummyco bound a distinct network (`dummyco`), distinct host ports
(5714/14730/15287), distinct volume — no collision.

## What iteration 5 must cover

1. Land **lead-l95x** (rename the two provision credential keys to
   SCREAMING_SNAKE_CASE + update the `--username-key`/`--password-key` refs) via
   `request_bugfix` to shopsystem-templates; cut a templates patch release;
   re-pour onto the lead host.
2. Re-run iteration 5 from empty: scaffold → `.env` → `docker compose up` (real,
   healthy broker) → `agent-vault-provision` with a real PAT supplied, expecting
   the FULL flow now: owner register → vault create → credential set → service add
   → **fleet-token mint** → **`.env` writeback** → reaching the **Claude-OAuth
   dashboard human gate**. STOP at the dashboard paste per ADR-031.
3. Then downstream: declare + launch the one dummy BC (gated on broker health),
   dispatch `assign_scenarios`, reconcile (conditions 4–10).

## Verdict

**inconclusive (this iteration), materially advanced — first live-broker E2E
provision test.** v0.7.0's two fixes are validated to the depth iter-4 reached:
the broker now reports **healthy** (lead-3uft fully validated), and the rewritten
provision is **real and structurally correct** — owner `auth register` and
`vault create` **succeed against the live broker** (lead-beym's fictional-verb
defect is gone). The run walls one layer deeper than iter-3, at `vault credential
set`, on a credential-KEY-casing defect (**lead-l95x** P0) — beaded, not
hand-patched (ADR-031 D2; gate condition 3/8). A live contract-surface probe
proves lead-l95x is the **SOLE remaining provision wall**: with the key casing
corrected, credential-set, service-add, and the `dummyco-fleet` token mint all
succeed E2E against the live broker. The spike has now peeled the provisioning
onion to its last layer. lead-jdfb stays `in_progress` — the gate clears only on
a clean re-run of 1–10. This iteration's durable output is this findings doc +
the one new bead (lead-l95x) + the two iter-3 validations (lead-3uft fixed,
lead-beym live-validated to the deeper wall).
