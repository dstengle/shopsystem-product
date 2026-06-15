# INSTALL.md cold-doc walkthrough — slug `acme` (2026-06-15)

Slice-1 empirical proof for **lead-l7uz** (WS-2, finding 3): can a NEW ADOPTER,
following ONLY `INSTALL.md`, get from an empty directory to a working product?

- **Slug:** `acme` (fresh, non-dstengle org) — proves the path is not
  dummyco/shopsystem-specific.
- **Host versions:** shop-templates **0.10.0**, shopsystem-messaging **0.4.0**,
  bc-launcher **0.3.0**, agent-vault **0.32.0**, bc-base **v0.3.1** (pulled).
- **Isolation (ADR-030):** all `acme`-named (network/ports/volumes), scratch at
  `/tmp/acme-product`. Live `shopsystem` fleet (4 BCs + agent-vault Up 5 days)
  untouched throughout. Rendered acme ports: postgres **6246**, broker API
  **14908**, broker proxy **15211** — distinct from live 5432/14321/14322.

## Verdict: **YES, with caveats.**

A cold adopter following only `INSTALL.md` reaches a working, isolated product
stack (lead shop + postgres + broker provisioned with the Claude-OAuth proposal
gate + a BC online projecting `acme/<bc>` + a scenario dispatched and read) —
**but** would hit three real walls the doc-as-written did not warn about, two of
which are template/code bugs (now beaded) and one of which is a stale Step-5
narrative (now fixed inline). The full §6.4 feature *build* (red→green→work_done)
is a boundary under the dummy Claude token (already proven in iter-7 with real
creds).

## Step-by-step cold-run log

| Step | Result |
|---|---|
| 1 Scaffold (`shop-templates bootstrap`) | PASS. Flags match doc. Renders fully slug-projected `ops/` (no `shopsystem`/`dummyco` literals). `briefs/adr/pdr/features` absent (matches lead-ii9q note). `.env.example` present (lead-pwl8 resolved). |
| 2 Set instance secret (`cp .env.example .env`) | PASS for the copy + master-password edit. **GAP-1**: rendered `.gitignore` does NOT ignore `.env` (`git check-ignore -v .env` → not ignored), contradicting Step 2's "gitignored — never commit it." |
| 3 Bring up services (`docker compose up -d`) | PASS. `acme-postgres` (6246) + `acme-agent-vault` (14908/15211) healthy, isolated. `bin/agent-vault-check` exits 0 silently pre-provision (it is a soft expiry advisory, not the reachability gate the doc implies — minor wording nit). |
| 4 Declare identity (`bc-manifest.yaml`) | PASS (manifest authored). GH-repo creation is a boundary (fictional `acme-org` + dummy token). |
| 5 Provision broker (`bin/agent-vault-provision`) | **WALL-2** then PASS once worked around. See below. |
| 6a Launch BC | PASS (with corrected flags). **GAP-3**: doc's `bc-container launch <bc> --image <image>` is incomplete; real launch needs `--network/--repo-url/--shopmsg-dsn/--agent-vault-broker/--env-file`. Image must be pinned `:v0.3.1` (`:latest` lags). |
| 6b §6.4 loop | PARTIAL — assign→deposit→BC-read PASS; build→work_done→reconcile is a **boundary** (dummy Claude token). |

## Step 5 — proposal gate E2E result (the headline)

INSTALL.md Step 5 prose was **known-stale** (old dashboard hand-create). The
rendered v0.10.0 `bin/agent-vault-provision` uses the **proposal** flow. I ran
the real script (dummy GitHub token; ADR-031 D2) and validated the gate
end-to-end against the live `acme` throwaway broker:

- Owner register → `vault create acme` → GitHub `credential set` → `github-git`
  / `github-api` / `claude-api` / `claude-platform` / `claude-mcp-proxy` service
  adds → `acme-fleet` agent-token mint → CA fetch → `.env` writeback: **ALL
  PASS** (verified: `.env` carries `av_agt_…` token, `AGENT_VAULT_ADDR/VAULT`,
  `agent-vault-ca.pem` is a 579-byte valid cert).
- **WALL-2:** `vault proposal create -f - --json --vault acme` died with
  `Error: Session requires vault scope`. The owner session that authorized
  `credential set`/`service add` is **not** sufficient for `proposal create` —
  it runs in *agent mode* and needs a **vault-scoped session**.
  - **Root cause / proven fix:** mint `agent-vault vault token --vault acme`
    (`av_sess_…`) and run proposal create/approve with
    `AGENT_VAULT_TOKEN=<that>` + `AGENT_VAULT_ADDR=http://localhost:14321`
    + `AGENT_VAULT_VAULT=acme`. With that scope, create returned
    `{"id":1,"status":"pending","vault":"acme",...}`.
- **Proposal-number capture watch-item (lead-yrex):** the script's tolerant
  `"(number|id)":[0-9]+` parse captured **`id=1` correctly** from the real
  `--json` output. The fallback was not needed. **Capture WORKS — no bead.**
- **Approve with DUMMY token (ADR-031 D2):**
  `vault proposal approve 1 CLAUDE_OAUTH=<dummy> --yes` (under the scoped
  session) → "Proposal #1 approved and applied." Post-gate
  `vault credential list --vault acme` shows **`CLAUDE_OAUTH`** alongside the
  GitHub keys — the create→approve→oauth-credential plumbing is **proven**.
  (Did not — and must not — supply a real secret.)

## bc-base v0.3.1 delivery validation

- Local `:latest` == `v0.2.8` bakes messaging **0.2.1** (pre-slug-projection).
  A cold adopter using the documented default image would get the stale image.
- Pulled `ghcr.io/dstengle/shopsystem-bc-base:v0.3.1` → bakes messaging
  **0.4.0**. Launched `bc-greeter` from v0.3.1 on the `acme` net: container
  **Up (healthy)**, in-container `shopsystem-messaging` is **0.4.0 with NO pip
  upgrade**. Registered `greeter` → projects **`acme/greeter`** (and lead →
  `acme/lead`), NOT `shopsystem/`. **bc-base v0.3.1 slug-projection delivery
  CONFIRMED.**

## Transport / dispatch validation (Step 6b, as far as dummy creds allow)

- Dispatched `assign_scenarios` (work_id `acme-walkthrough-1`, trivial greeter
  scenario, `scenarios hash` = `28dba34bcaa61874`) from an in-network sender
  context (the lead devcontainer cannot reach `acme-postgres` via localhost; the
  published host port maps to the docker *host*, not this devcontainer — a
  testbed artifact, not a doc gap).
- BC read it: `shop-msg pending inbox --bc greeter` → `acme-walkthrough-1
  assign_scenarios`; `read inbox` shows the message deposited at the
  **`acme/greeter`** address, hash `28dba34bcaa61874` (matches independent
  recompute), tagged `@scenario_hash:28dba34bcaa61874 @bc:greeter`.
- **Boundary:** with the dummy Claude-OAuth token the BC agent cannot reach
  Claude to build the feature (red→green→work_done→reconcile). That full §6.4
  cycle was already proven in iter-7 with real creds. Not retried here.
- Side-observation during launch: the brokered clone failed on a CA-path lookup
  (`/home/vscode/.config/agent-vault/ca.pem`) and the fictional `acme-org/greeter`
  repo — expected under dummy creds; not pursued (no real repo, no real token).

## Doc-gap ledger

1. **`.gitignore` omits `.env`** — `[beaded: lead-7if5]` (template fix in
   shop-templates). INSTALL Step 2 already asserts it is gitignored; the gap is
   the rendered artifact, not the prose.
2. **`bin/agent-vault-provision` proposal-create misses vault scope** —
   `[beaded: lead-9qdn]` (template fix; proven workaround documented). INSTALL
   Step 5 + Troubleshooting patched inline to document the vault-scope
   requirement so an operator approving by hand is not blocked.
3. **bc-base `:latest` lags `v0.3.1`** — `[beaded: lead-2xi3]` (image-tag /
   launcher-default fix) + `[fixed-inline]` (Step 6a pins `:v0.3.1`).
4. **Step 5 narrative stale (dashboard → proposal)** — `[fixed-inline]`
   (rewrote the human-gate subsection to the approve-the-proposal flow).
5. **Step 6a launch command incomplete** — `[fixed-inline]` (added
   `--network/--repo-url/--shopmsg-dsn/--agent-vault-broker/--env-file`).
6. **`bin/agent-vault-check` "reachable and provisioned" overstates** (it is a
   soft expiry advisory, exits 0 silently pre-provision) — minor; left as-is
   (non-blocking, not worth churn).

## What changed in INSTALL.md (inline)

- Step 5: replaced the stale "one human paste into the dashboard" subsection
  with the **approve-the-proposal** flow (create is scripted; human approves
  with the real token at approve time; documented the **vault-scope** requirement
  for `proposal create`/`approve`).
- Step 6a: corrected the launch command to the real flag set and added an
  **IMAGE** callout to pin `:v0.3.1` (messaging 0.4.0) rather than `:latest`.
- Troubleshooting: added the vault-scope gotcha and the `:latest`-vs-`v0.3.1`
  gotcha; recast the casing gotcha to drop the dashboard framing.

## Teardown

`acme` stack (`bc-greeter`, `acme-agent-vault`, `acme-postgres`, network `acme`,
volume `acme-agent-vault-data`, scratch `/tmp/acme-product`) torn down at end of
run. Live `shopsystem` fleet confirmed untouched.
