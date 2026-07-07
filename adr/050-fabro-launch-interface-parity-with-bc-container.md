---
id: ADR-050
kind: adr
title: "Fabro launch-interface parity with bc-container: which of the P1–P20 launch properties are KEPT vs REPLACED, the readiness-barrier seam, and the engage-tier replacement"
status: accepted
date: "2026-07-01"
description: Pins which P1-P20 launch properties fabro KEEPS vs REPLACES, the readiness-barrier seam, and the engage-tier replacement.
beads: [lead-6k1r, lead-capability, lead-f6ta, lead-shell]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018, ADR-020, ADR-021, ADR-029, ADR-032, ADR-048, PDR-011, PDR-016, PDR-020]
  pins: []
  related: []
invariants:
  - id: launch-interface-parity-pin
    statement: The Slice-1 launch-interface-parity boot scenario is pinned as a fabro-orchestration feature.
    predicate:
      kind: path-present
      path: features/fabro-orchestration/01-launch-interface-parity-boot.gherkin
    hash: "6609cf101f8c982e"
    status: unverified
---
# ADR-050 -- Fabro launch-interface parity with bc-container: which of the P1–P20 launch properties are KEPT vs REPLACED, the readiness-barrier seam, and the engage-tier replacement

- Status: Accepted (2026-07-01)
- Date: 2026-07-01
- Implements: hard-invariant #3 of the fabro spike (epic
  [`lead-6k1r`](#)) — *launch-interface parity with `bc-container`* — as an
  enforceable contract. The product-level decision that fabro is an
  alternable in-container orchestration substrate is SETTLED in
  [ADR-048](048-fabro-as-alternable-in-container-bc-orchestration-substrate.md)
  and is NOT re-litigated here; this ADR records only the launch-parity
  half (which of the Slice-1 P1–P20 properties fabro keeps vs replaces).
- Anchored on (decisions this builds on — NOT re-decided here):
  - [ADR-048](048-fabro-as-alternable-in-container-bc-orchestration-substrate.md)
    — the umbrella substrate decision: fabro replaces only the Seam(a)
    launch+loop under `provider='local'`, never the three shop-msg/bd
    invariant surfaces. This ADR realizes its launch-parity surface.
  - [ADR-020](020-routing-identity-is-abstract-system-name-shop-root-eliminated.md)
    / [PDR-020](../pdr/020-lead-shell-is-a-bc-container-launched-bc-base-session.md)
    — the lead shell is itself a `bc-container`-launched `bc-base` session;
    the P19 LEAD-profile capabilities (`workspace-mount`, `docker-socket`
    opt-in) and the launch contract fabro must match are the parity
    baseline.
  - [ADR-021](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
    — `bc-base` is bc-launcher-owned and auto-rebuilds on utility release;
    the pinned/pulled `:latest` provenance is the exact image fabro must
    boot from to keep parity (P1).
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) —
    the lead carries no BC source; verify-online (P18) is asserted over
    `shop-msg`, never by reading fabro run outputs. This constrains which
    engage-tier property is REPLACED vs held invariant.
  - [PDR-016](../pdr/016-iterative-experimentation-first-class-lead-capability.md)
    / ADR-029/030/032 — the spike vehicle and iterative-experimentation
    track this parity finding graduates through; the P1–P20 table is a
    spike artifact per the spike-vehicle ADR-032.
- Bead: lead-6k1r (P2, the fabro spike epic — GREEN 2026-07-01). Realizes
  invariant #3 under ADR-048; peers ADR-049 (credentials) and ADR-051
  (loop graph). No bead superseded here (ADR-048 supersedes the origin
  bead lead-f6ta).

## Context

The fabro spike (epic lead-6k1r, odqd iterative-experimentation track)
asked whether the fabro workflow engine can serve as an alternable
in-container BC-orchestration substrate. ADR-048 settles that it can, and
scopes it: fabro replaces only the Seam(a) launch+loop and rides inside an
already-booted container under `[environments.<slug>] provider='local'`.
That scoping raises a concrete contract question this ADR answers: what
does "launch-interface parity with `bc-container`" *mean* when fabro is not
the container booter?

Slice 1 (`findings/fabro-spike/01-targets-spec.md` +
`01a-target-launch-parity.md`) enumerated the `bc-container launch`
contract as **20 observable properties P1–P20 across three tiers**
(container, engage, credential) plus network/coordinates and
contract-surface groups, and mapped each to a concrete fabro construct or a
"no analog — keep the existing launcher" verdict. Slice 4
(`04-goal-demo.md` §3, invariant #3) then live-verified parity on a real
non-dry-run boot. This ADR converts that mapping into the durable
drop-in-launcher contract: which properties fabro KEEPS unchanged, which
its run-graph REPLACES, and the one load-bearing seam (the readiness
barrier) that carries the replacement.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's
`features/`, `adr/`/`pdr/`, `shop-msg` mailbox state, and scenario hashes
via the installed `scenarios hash` CLI on 2026-07-01. For a fabro-spike
graduation ADR the admissible artifact surface additionally includes the
spike findings `findings/fabro-spike/*.md` (per the spike-vehicle ADR-032):

1. **The P1–P20 launch contract is enumerated and tiered**
   (`findings/fabro-spike/01a-target-launch-parity.md` §1). Twenty
   observable properties of `bc-container launch` (owned by
   `shopsystem-bc-launcher`, ADR-004/PDR-004; subcommand surface
   `launch/attach/inject/monitor/stop/status/list`, P20) are grouped into a
   **container tier** (P1–P4, P7, P10–P17), an **engage tier** (P5, P6, P8,
   P9, P18), and a **credential tier** (P11–P13), each row citing the
   bc-launcher scenario/ADR that asserts it. This is the property table
   this ADR keeps/replaces against.

2. **The KEEP/REPLACE mapping is worked per property**
   (`01a-target-launch-parity.md` §2). Under `provider='local'` fabro is
   NOT the container booter, so the container tier and the
   network/coordinates group are KEPT (bc-container's docker invocation
   rides unchanged; fabro rides inside). The engage tier is what fabro
   REPLACES: the tmux `agent` send-keys session (P5/P8/P9) becomes a
   headless `fabro run`, and the readiness barrier (P6) becomes a fabro
   barrier node with outcome-conditional edges. P18 (verify-online) is
   explicitly held INVARIANT — asserted over `shop-msg bc-status`+ping, never
   over fabro run outputs (ADR-018).

3. **Parity HELD on the live non-dry-run boot** (`04-goal-demo.md` §3,
   invariant #3, corroborated on rerun in `05-structural-loop.md` §3). The
   throwaway BC "booted from the same `shopsystem-bc-base:latest` the 3
   healthy infra BCs run; launch-parity (agent-vault proxy + MITM CA +
   `SSL_CERT_FILE` + postgres DSN) provisioned by hand to match what
   `bc-container launch` injects; the BC presented a real, registered, EMPTY
   postgres mailbox — the exact starting posture of a launched BC. Entry
   path `prime→health→arm→classify` traversed clean under `--dry-run` and
   non-dry-run." This is the empirical KEEP-set (same image, same
   provisioning, same empty-mailbox posture) and the REPLACE-path (the
   `prime→health→arm→classify` run-graph entry standing in for tmux engage).

4. **The parity was HAND-PROVISIONED, not run via `bc-container launch`**
   (`04-goal-demo.md` §4 throwaway-scope caveats). Launch-parity was
   achieved by hand-replicating the `bc-container launch` provisioning onto
   a plain `docker run` bc-base container; the real drop-in-launcher
   integration (manifest/broker/clone machinery) was deliberately
   side-stepped. This bounds the contract below to *which observables must
   match*, and defers the *how it is wired* to a follow-up bead (not
   designed here).

5. **The bc-launcher launch scenarios this parity is measured against are
   present in this repo's `features/bc-launcher/`:** `33` (launch gates on
   messaging-DB reachability), `34` (idempotent readiness barrier before
   engage), `35` (container health reflects readiness not liveness), `48`
   (readiness barrier composes both supporting servers), `43` (launch pours
   shop-templates skills), `44` (launch mounts no host-filesystem
   credentials). These are the concrete pins P6/P7/P4/P11 cite and that the
   REPLACED readiness-barrier seam must reproduce fail-for-fail.

6. **@scenario_hash retirement enumeration — EMPTY (nothing retired).**
   `grep -r "@scenario_hash" features/` carries NO scenario pinning fabro
   in-container launch orchestration; the `features/fabro-orchestration/`
   scenarios that graduate alongside this ADR (01 launch-parity boot, …)
   are NET-NEW pins, not supersessions. The bc-launcher `33/34/35/43/44/48`
   pins describe the `bc-container` launch path and remain valid — this ADR
   RELATES to them (fabro must reproduce their observables) and retires
   none. This ADR authors no Gherkin and retires no pinned coverage.

## Decision

### D1 -- Parity is a drop-in alternate launch PATH, not a new launch contract; it is measured against the P1–P20 properties, tier by tier (realizes invariant #3, under ADR-048)

A fabro launcher presents the existing `bc-container launch` contract as a
**drop-in alternate path, not a new contract** (`01a` §0). Parity is
defined property-by-property against the Slice-1 P1–P20 enumeration, split
by tier:

- **Container tier (P1–P4, P7, P10–P17) — KEPT.** Because ADR-048 scopes
  fabro to `provider='local'`, fabro runs *inside* an already-booted
  container and does NOT create it. The container's name (`bc-<bc>`, P1),
  its `bc-base` image, the in-container clone (P2), beads pull (P3), skills
  pour (P4), Docker HEALTHCHECK (P7), mount isolation (P10/P11), and the
  network/coordinates facts (P14–P17) are all produced by the unchanged
  outer `bc-container` docker invocation. Fabro touches none of them.
- **Engage tier (P5, P6, P8, P9, P18) — REPLACED (except P18, invariant).**
  This is the ONLY tier fabro replaces (D3).
- **Credential tier (P11–P13) — KEPT, brokered per ADR-049.** The
  agent-vault vault-`__PLACEHOLDER__` + `HTTPS_PROXY` path is the credential
  surface; its contract is settled in ADR-049 and inherited here for free
  under `provider='local'` (the node execution env inherits the parent
  container's `HTTPS_PROXY`). This ADR does not re-decide credentials.
- **Contract-surface tier (P19, P20) — KEPT via thin shims.** The LEAD
  profile (P19) and the subcommand surface (P20,
  `launch/attach/inject/monitor/stop/status/list`) are preserved as thin
  shims over `fabro attach/events/steer` + `shop-msg`/`docker`; the CLI
  shape does not change.

### D2 -- The KEPT surface is exactly: same `shopsystem-bc-base:latest` image, the same agent-vault proxy + MITM CA + `SSL_CERT_FILE` + postgres DSN provisioning, and a real registered EMPTY mailbox starting posture (evidence: 04-goal-demo §3)

The observables a fabro-launched BC MUST reproduce byte-for-parity, drawn
from the live invariant-#3 verification (pre-state finding 3):

1. **Same image.** The BC boots from the same `shopsystem-bc-base:latest`
   that the healthy infra BCs run — the ADR-021 auto-rebuilt/pulled
   `:latest` provenance, not a fabro-specific image.
2. **Same credential/transport provisioning.** agent-vault proxy +
   MITM CA + `SSL_CERT_FILE` + postgres `SHOPMSG_DSN`, matching exactly what
   `bc-container launch` injects (the concrete credential contract is
   ADR-049).
3. **Same starting posture.** A real, registered, EMPTY postgres mailbox —
   the exact posture of a freshly launched BC, so the reactive drain/seed
   behaves identically.

These are held invariant regardless of orchestration substrate; a fabro
launcher that diverges on any of them is not at parity.

### D3 -- The engage tier is REPLACED: the tmux `agent` send-keys session becomes the fabro run-graph entry path `prime→health→arm→classify`; P8/P9 are parity-by-obsolescence; P18 stays invariant over shop-msg (never fabro outputs)

The engage tier is the sole REPLACED surface:

- **P5 (tmux `agent` session + inject/monitor) → the fabro run-graph entry
  path.** The tmux `agent` session existed to host a single `claude` TUI and
  feed it keystrokes. Under fabro the in-container agent loop is a headless
  `fabro run` (`fabro server start --foreground --no-web --bind
  <unix-socket>`) whose entry path is `prime→health→arm→classify`
  (verified traversing clean, pre-state finding 3). No send-keys engage is
  needed — a `fabro run` begins autonomously by construction. `attach`/
  `monitor`/`inject` (P20) map to `fabro attach`/`events`/`steer` behind
  thin shims (D1).
- **P8 (two-send-keys autonomous commit) and P9 (Escape auto-dismiss) →
  parity-by-obsolescence.** Both are TUI-paste/interactive-screen
  workarounds for a `claude` TUI that does not exist in a headless `fabro
  run`. The observable they protected — "the agent begins work autonomously
  after the barrier passes, with no human follow-up" — is satisfied by fabro
  run semantics (verified: autonomous start, AC10). They are recorded as
  parity-by-obsolescence, not reproduced.
- **P18 (verify-online) — INVARIANT, NOT replaced.** `launch` exit 0 still
  means "container started", not "online". Online is asserted via
  `shop-msg bc-status` reaching `online` (ADR-014 heartbeat) AND the BC
  accepting a `shop-msg` ping — established WITHOUT reading `fabro
  events`/run outputs. Fabro run-success is explicitly NOT evidence of
  online (ADR-018 harvest invariant; pre-state finding 2). This property
  crosses into the engage tier but is held invariant by construction.

### D4 -- The readiness-barrier seam is the load-bearing REPLACED point: a fabro barrier node with outcome-conditional edges, fail-closed naming `SHOPMSG_DSN` / the broker address, idempotent as a no-op-reporting-ready (reproduces bc-launcher 33/34/48)

P6 — the idempotent readiness barrier composing BOTH supporting servers —
is the single most load-bearing parity point (`01a` §2, "most load-bearing
parity point"). Its fabro replacement is a barrier command node run BEFORE
the first agent node, wired with **outcome-conditional edges**, that MUST
reproduce the bc-launcher `33/34/48` observables fail-for-fail:

1. **postgres/`SHOPMSG_DSN` unreachable → barrier FAILs**, the run does NOT
   reach the router/agent node, and the failure names `SHOPMSG_DSN`
   (scenario 33 parity).
2. **agent-vault broker unreachable → barrier FAILs** naming the configured
   broker address (scenario 48 parity — the barrier composes BOTH servers;
   engagement is withheld if either is down).
3. **both up → barrier PASSes** and the classify/router node runs.
4. **re-run against an already-ready run → a no-op reporting ready**
   (scenario 34 idempotence parity), satisfied natively by fabro
   checkpoint/resume replaying a completed prepare step.

The fail-CLOSED direction (barrier failure blocks engagement, never a
silent proceed) is the property this seam exists to preserve; it is
structurally enforced by the loop-graph contract in ADR-051 (native
`script=` barrier node + outcome-conditional edges), which lands alongside
this ADR.

## Consequences

- **The drop-in-launcher contract is now explicit** (D1–D4): a fabro
  launcher is at parity iff it KEEPS the container/credential/network tiers
  unchanged, reproduces the D2 KEEP-set observables, and REPLACES only the
  engage tier with the `prime→health→arm→classify` run-graph entry and a
  fail-closed readiness-barrier node. Any other divergence is a parity
  break, testable against the P1–P20 enumeration.
- **The engage-tier replacement retires two TUI workarounds** (D3): P8/P9
  become parity-by-obsolescence, simplifying the engage surface without
  losing the autonomous-start observable.
- **P18 stays the online oracle** (D3): the ADR-018 no-harvest invariant is
  preserved — fabro run-success never substitutes for the shop-msg
  heartbeat. This keeps the lead's verify-online path unchanged whether a BC
  is bc-container- or fabro-launched.
- **The readiness barrier's fail-closed guarantee is inherited, not
  reinvented** (D4): it reproduces the proven bc-launcher `33/34/48`
  behavior, and its structural enforcement is carried by ADR-051's native
  `script=` node contract.
- **Realizes invariant #3 of ADR-048** as a named, checkable contract, and
  peers ADR-049 (credential tier) and ADR-051 (loop-graph tier); the new
  `features/fabro-orchestration/01-launch-interface-parity-boot.gherkin`
  pins this ADR (its block-only `@scenario_hash` is authored by lead-po via
  the calibrated `scenarios hash` recipe and verified — not introduced — by
  the Architect at dispatch, defense-in-depth per ADR-018 D2); that verified
  hash is `1aeace4c593ab14f`.

## Follow-ups / dependencies (named, not designed here)

- **Real `bc-container launch` drop-in integration (P2 bead — NOT created
  here).** Parity in the spike was HAND-PROVISIONED onto a plain `docker
  run` bc-base container (pre-state finding 4). Wiring the fabro run-graph
  entry into the actual `bc-container launch` machinery — the
  manifest/broker/clone drop-in so `launch` itself selects the fabro
  substrate — is a future BC-implementation dispatch item, flagged for
  David/router at reconcile per the spike residual list. This ADR pins
  *which observables must match*, not *how the launcher wires them*.
- **Contract-surface shim fidelity (P19/P20).** Whether the thin
  `attach/monitor/inject` shims over `fabro attach/events/steer` reproduce
  the bc-container CLI byte-for-byte is a shim-authoring follow-up, not
  decided here.
- **Loop-graph enforcement (ADR-051).** The fail-closed guarantee of the D4
  barrier is only ENFORCED (not advisory) given ADR-051's native `script=`
  node contract; that ADR is the dependency that makes D4 structural.

## Alternatives considered

- **Fabro as the outer container launcher (`provider='docker'`/sandbox owns
  the boot).** Rejected (D1): it contradicts ADR-048's in-container-only
  scope and re-introduces fabro-as-outer-launcher, forcing fabro's
  `[environments.<slug>]` mount spec to reproduce the entire container/
  isolation/network tier (P1/P10/P11/P14–P17) — exactly the invariant
  surfaces ADR-048 keeps out of fabro. Keeping `provider='local'` inherits
  those tiers from the unchanged outer launcher for free.
- **Reproduce the tmux `agent` send-keys engage under fabro (keep P5/P8/P9
  literally).** Rejected (D3): the two-send-keys and Escape disciplines are
  workarounds for a `claude` TUI that a headless `fabro run` does not have;
  reproducing them would re-create the paste/interactive-screen hazards with
  no benefit. Parity-by-obsolescence preserves the real observable
  (autonomous start) without the workaround.
- **Accept fabro run-success as evidence of "online" (fold P18 into the run
  outcome).** Rejected (D3): it violates the ADR-018 no-harvest invariant —
  the lead must assert online over `shop-msg`/heartbeat, never by reading
  fabro run outputs. P18 stays invariant.
- **A single "barrier passed" boolean instead of a fail-closed
  outcome-conditional barrier node.** Rejected (D4): it loses the
  server-specific diagnostics (`SHOPMSG_DSN` vs broker address) and the
  fail-CLOSED direction that bc-launcher `33/48` assert; a barrier that
  cannot name which server is down, or that a soft-failure could route past,
  is not at parity.
