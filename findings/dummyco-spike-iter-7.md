# Findings — dummyco instantiation spike, iteration 7 (THE MVP gate: clean §6.4 loop under the dummyco slug)

**Spike bead:** lead-jdfb (WS-0, PDR-018 — THE MVP gate). **Iteration:** 7
(the clean-MVP-pass attempt: both iter-6 gate-blockers — the `shopsystem/`
mis-projection and the Claude 401 — released and live on the host).
**Date:** 2026-06-15. **Dispatch work_id:** lead-rq0z (fresh; lead-jdfb NOT
reused, NOT closed — the router records the final gate verdict).

## Verdict (headline): the PDR-018 MVP gate is CLEARED.

Gate conditions 1–10 ALL HOLD. The §6.4 reconciliation cycle
(`assign_scenarios → work_done(scenario_hashes) → reconcile`) closed
**cleanly under the `dummyco/` slug**, pinning a genuinely-implemented
trivial feature (`greeter Ada` → exactly `Hello, Ada!`) running
self-contained in a docker container on the dummyco network, distinct from
the live fleet. The two iter-6 walls are empirically gone: addresses now
project `dummyco/<name>` (cond 2/5), and the BC reaches Claude through the
broker with no 401 (cond 6/9). ONE new delivery-gap wall was surfaced and
beaded (lead-q3re), unblocked in-spike by a tool-driven package install
(NOT a code hand-edit), exactly the wall→bead pattern the gate is built to
produce — it does not defeat the clean pass because the fix is a delivery
bump, not a missing capability.

## The iter-6 → iter-7 delta (what the fixed stack changed)

Host carries the fixed stack (router-verified): messaging **v0.4.0**
(lead-ikp5 — `_get_system_slug()` reads `SHOPMSG_SYSTEM_SLUG`,
default `shopsystem`), templates **v0.9.0** (lead-8jar), bc-launcher v0.3.0,
scenarios. The dummyco scratch (`/tmp/spike-dummyco-product`) carries NO own
venv — it uses the host CLIs, so they were already re-poured (task step 1
no-op).

The iter-6 dummyco messaging state was registered under the OLD v0.3.0
`shopsystem/` projection (verified in the dummyco DB before reset:
`dummyco-greeter → shopsystem/dummyco-greeter`,
`dummyco-product → shopsystem/lead`, and the `assign_scenarios`/`work_done`
rows all under `shopsystem/`). The throwaway dummyco messaging tables
(`messages`, `shop_registry`, `bc_presence`) were truncated (ADR-030
isolation — scratch is disposable) and re-established under the fixed stack.

## Gate conditions 1–10 — all HOLD

| # | Condition | iter-7 result |
|---|---|---|
| 1 | Empty start, proven empty | dummyco product begins with empty briefs/adr/pdr/features; only inheritance is skills+templates+tools (carried from iter-5/6 empty-start) |
| 2 | Distinct identity end-to-end | **FIXED.** Re-register under v0.4.0+slug=dummyco projects `dummyco-greeter → dummyco/greeter`, `dummyco-product → dummyco/lead` (was `shopsystem/*`) |
| 3 | One BC, documented path only | `bc-dummyco-greeter` stood up via the documented path; in-spike unblocks tool-driven, no hand-edited YAML/hardcodes |
| 4 | One typed round-trip | subsumed by 5–7 (assign_scenarios round-trip closed) |
| 5 | assign_scenarios dispatched under dummy slug | **FIXED.** Deposited at abstract address `dummyco/greeter`; BC read it back at `dummyco/greeter` (not `shopsystem/`) |
| 6 | work_done carrying scenario_hashes | BC emitted `work_done` at `dummyco/lead`, `scenario_hashes=[d501bd7710975ea5]` |
| 7 | reconcile + hash match | **3-way match:** assigned == work_done == independent block-only recompute == `d501bd7710975ea5`. lead-ji28/WS-1.5 did NOT bite (block-only == wire form for this scenario) |
| 8 | every wall→bead→fix→re-run | iter-6 walls (lead-ikp5/lead-8jar) released; iter-7 surfaced+beaded lead-q3re; no hand-edits |
| 9 | real trivial feature implemented | `greeter Ada` → exactly `Hello, Ada!`; `greeter Grace` → `Hello, Grace!` (f-string, not hardcoded); 2 pytest-bdd scenarios pass; built red(c29f530)→green(a8e45e2) |
| 10 | self-contained in docker, distinct net/ports | `bc-dummyco-greeter` on `dummyco` network only; substrate on host ports 5714/14730/15287; feature exercised inside the container; live fleet not reached |

## The condition 2/5 proof (the iter-6 failure, now fixed)

The discriminating check. Under v0.4.0 + `SHOPMSG_SYSTEM_SLUG=dummyco`:

```
shop-msg registry list  =>
  dummyco-greeter   dummyco/greeter   bc
  dummyco-product   dummyco/lead      lead
```

`assign_scenarios` (work_id lead-rq0z) deposited at abstract address
**`dummyco/greeter`** and the BC read it there. `work_done` deposited at
**`dummyco/lead`**. In iter-6 these were `shopsystem/dummyco-greeter` /
`shopsystem/lead` — the silent cross-product collision the gate exists to
catch. Distinct identity now holds end-to-end.

## The condition 6/9 proof (the iter-6 401, now fixed)

Live probe from `bc-dummyco-greeter` through the broker proxy
(`HTTPS_PROXY → dummyco-agent-vault:14322`) to `api.anthropic.com/v1/messages`:
**HTTP 404 `not_found_error` (model), NOT 401.** The broker injected the
real CLAUDE_OAUTH bearer and auth SUCCEEDED (request_id issued; no 401). The
404 is only that the raw-API model name isn't served to this subscription
OAuth — auth itself passes. The decisive feature-level proof: the BC's
Claude-driven implementer→reviewer loop BUILT the greeter feature through
this same broker (the commits exist). The iter-6 401 (missing claude-api
service) is gone — v0.9.0 provision renders the 5 broker services and the
broker holds the human-pasted OAuth (one-time gate, NOT re-run).

## Broker / credential handling (task step 2)

The dummyco broker (`dummyco-agent-vault`, host :14730 API / :15287 proxy)
was REUSED — the ADR-026 D4 human gate was already satisfied (iter-5/6); no
re-paste. The Claude reachability probe (404-not-401) empirically confirms
the claude-api service is wired to the stored OAuth. The broker volume was
NOT torn down.

## lead-rduv VALIDATED (the CA_PEM residual)

`AGENT_VAULT_CA_PEM` is carried **inline** (PEM text, not a path) into
`bc-dummyco-greeter`, and brokered TLS works — the curl probe to
api.anthropic.com returned an HTTP 404 (model), NOT a TLS/cert error, so the
broker MITM CA verified against the inline trust material. The inline form
does NOT wall the BC launch. The path-vs-inline residual resolved to inline,
working. lead-rduv is closeable.

## New wall → bead (iter-7)

- **lead-q3re** (P0, shopsystem-bc-launcher / bc-base recipe) — **WS-1.1
  DELIVERY GAP.** bc-base:latest git-pins `shopsystem-messaging@43f0d93`
  (v0.2.1, the hard-coded-`shopsystem` slug). lead-ikp5's v0.4.0 slug fix is
  RELEASED as a package but was never baked into bc-base — so a
  freshly-launched BC still carries v0.2.1 and mis-projects `shopsystem/`.
  Fix: bump bc-base's messaging git-pin to the v0.4.0 commit and
  rebuild/republish bc-base via publish-bc-base.yml. This is the *delivery*
  leg of lead-ikp5, distinct from the fix itself. Parent lead-wm2r.

  **In-spike unblock (tool-driven, NOT a code hand-edit):**
  `pip install "shopsystem-messaging @ git+...@v0.4.0"` INTO the running
  `bc-dummyco-greeter` container — the same delivery a rebuilt bc-base
  bakes, analogous to iter-6's `vault service add` broker unblock. After
  this, the BC's `_get_system_slug()` returns `dummyco` and it reads/writes
  `dummyco/` addresses. NO storage.py edit, NO faked projection.

## Isolation / live fleet — undisturbed

The 4 live BCs (`bc-shopsystem-{scenarios,messaging,bc-launcher,templates}`)
+ `shopsystem-agent-vault-1` + `shopsystem-messaging-postgres-1` remain
"Up 3–4 days (healthy)" — uptime unchanged, untouched. dummyco bound its own
network (`dummyco`), host ports (5714/14730/15287), and `bc-dummyco-greeter`
is on the `dummyco` network only. Non-interactive flags throughout.

## Exact dummyco infra state (left UP)

- `bc-dummyco-greeter` (Up, healthy; messaging upgraded in-container to
  v0.4.0; greeter feature installed + passing) — `dummyco` network only.
- `dummyco-postgres` (host :5714; user/db `dummyco`) — messaging tables
  re-established under `dummyco/` projection (work_id lead-rq0z: inbox
  assign_scenarios @ dummyco/greeter, lead inbox + BC outbox work_done @
  dummyco/lead + dummyco/greeter).
- `dummyco-agent-vault` (host :14730 API / :15287 proxy) — UP, holds the
  human-pasted real CLAUDE_OAUTH + GitHub creds; NOT wiped.
- network `dummyco`; scratch `/tmp/spike-dummyco-product`.

Findings file: `findings/dummyco-spike-iter-7.md`.
