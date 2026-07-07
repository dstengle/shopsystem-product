---
id: ADR-051
kind: adr
title: "The fabro DOT loop-graph contract: Implementer-to-Reviewer graph with emit_r as the SOLE gated work_done emitter, outcome-conditional fail-closed edges, ENFORCED by native script= scoping"
status: accepted
date: "2026-07-01"
description: "Fabro's .loop graph contract: the reviewer is the sole gated emitter and the loop fails closed."
beads: [lead-6k1r, lead-f6ta]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-012, ADR-016, ADR-018, ADR-042, ADR-048, ADR-049, ADR-050, PDR-011]
  pins: []
  related: []
---
# ADR-051 -- The fabro DOT loop-graph contract: Implementer-to-Reviewer graph with emit_r as the SOLE gated work_done emitter, outcome-conditional fail-closed edges, ENFORCED by native script= scoping

- Status: Accepted (2026-07-01)
- Date: 2026-07-01
- Implements: hard-invariant #4 of the fabro spike (shop-msg protocol
  preserved) as an enforceable contract; graduates the Slice-5 loop-fidelity
  GREEN result (findings/fabro-spike/05-structural-loop.md §0/§1) via the
  odqd iterative-experimentation track. The spike-vehicle product decisions
  (spike → learn → throw away → graduate via ADRs + scenarios) are SETTLED
  under ADR-029/030/032 and are NOT re-litigated here.
- Anchored on (decisions this builds on -- NOT re-decided here):
  - [ADR-048](048-fabro-as-alternable-in-container-bc-orchestration-substrate.md)
    -- the umbrella substrate decision (fabro `provider=local` in-container,
    Seam(a) launch+loop only); this ADR realizes the loop-graph surface of
    that substrate. ADR-049 (credentials) and ADR-050 (launch parity) are the
    sibling realizations.
  - [ADR-042](042-bc-emit-precondition-enforcement-reconciliation-and-the-unfinished-105-116-retirement.md)
    -- `bc-emit` work-done precondition enforcement (the C1/C2/C3 gate); the
    `emit_r` node re-runs this gate, so the loop graph inherits it rather than
    re-inventing the work-done contract.
  - [ADR-012](012-outbox-atomicity-bd-first.md) -- `UNIQUE(work_id, direction,
    shop)` atomicity and the 3-step outbox protocol; the fail-closed
    `emit_r -> halt [outcome=failed]` edge is the backstop for the UNIQUE
    collision / retry-exhaustion case this ADR pins.
  - [ADR-016](016-shop-msg-owns-bd-integration.md) -- `shop-msg` owns the
    bd-first transactional write ordering; the loop graph's per-node fabro
    checkpoint is DEMOTED to resume-only against this authority (ADR-048), so
    the checkpoint never competes with the bd-first write.
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) --
    work_done round-trips over `shop-msg`, NOT fabro structured outputs; the
    lead reconciles by reading the mailbox, never by harvesting fabro child
    output. The loop graph must therefore emit through `bc-emit`/`shop-msg`.
- Bead: lead-6k1r (P2, the fabro spike epic, GREEN 2026-07-01, commit 3e0fd31).
  Realizes hard-invariant #4; sibling of ADR-049/050 under ADR-048; the origin
  spike bead lead-f6ta is superseded by ADR-048.

## Context

The fabro spike (epic lead-6k1r) asked whether fabro can serve as an
alternable in-container substrate for the bc-shop Implementer→Reviewer loop
WITHOUT breaking the four hard invariants. Invariant #4 — the shop-msg
protocol is preserved — is the one this ADR pins as a contract: whatever runs
the loop, a `work_done` must still round-trip over `shop-msg`/`bc-emit`, and
it must be emitted by exactly one gated point that a non-signed-off reviewer
cannot reach.

Slice 4 banked the artifact-level proof (a real fabro-orchestrated non-dry-run
produced a valid `work_done(complete)`) but scored loop fidelity RED: a fabro
*command node is a general LLM agent*, so scope/decomposition/sole-emit were
advisory, and the `prime` agent carried the whole graph goal and collapsed the
pipeline into a single node (the Slice-4 G1 node-collapse). Slice 5 closed
that gap STRUCTURALLY — every non-judgment node became a native `script=` step
with no LLM agency — and re-ran the loop live in-container to GREEN on all four
criteria. This ADR graduates the resulting DOT loop-graph shape and the three
v0.254.0 mechanism facts that make its guarantees *enforced* rather than
advisory, so the contract survives the throwaway spike def.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's
`features/`, `adr/`/`pdr/`, `shop-msg` mailbox state, and scenario hashes via
the installed `scenarios hash` CLI on 2026-07-01. Per spike-vehicle ADR-032,
the spike's `findings/fabro-spike/*.md` are the artifact surface for this
graduation:

1. **The DOT loop graph is FIXED and validates** (reference impl
   `findings/fabro-spike/fabro-defs/workflow.fabro` + `workflow.toml`):
   `fabro validate workflow.fabro` → **OK (23 nodes, 45 edges)**
   (05-structural-loop.md §0). The scenario path is
   `classify → suff → worktree → plan → impl → redgate → integ → review
   → wdg_r → emit_r → done` (the `signoff` label rides the
   `review -> wdg_r` edge). Exactly **6 nodes remain LLM agents** — the
   judgment nodes `classify, suff, plan, impl, review, impl_f`; every other
   node (`prime, health, arm, armed, worktree, redgate, integ, wdg_r, emit_r,
   wdg_f, emit_f, emit_clar, emit_blk, reported, halt`) is a native
   `shape=parallelogram, script=` step with no LLM agency.

2. **`emit_r` is the structural sole gated emitter — PROVEN in-graph**
   (05-structural-loop.md §1(c), run `demo-3g`). `emit_r` is the only
   `bc-emit work-done ... --status complete` node on the scenario path, graph-
   reachable ONLY via `review --signoff--> wdg_r -> emit_r`, both of which are
   native gates. demo-3g's `emit_r` emitted a valid `status: complete`
   in-graph; outbox `fabro-spike-demo-3g` = complete, backed by real
   `test(red) 21458da → feat(green) 57fe9b2 [fabro-spike-demo-3g]` on
   origin/main. `wdg_r` re-runs the ADR-042 C1/C2/C3 work-done gate before
   `emit_r` fires.

3. **Fail-closed is PROVEN** (05-structural-loop.md §1(d),
   `workflow-forcefail.fabro`). With `review` replaced by a native `exit 1`
   (`outcome=failed`) and `emit_r` kept a REAL `bc-emit`:
   `start → review(✗ outcome=failed) → halt` → **run STATUS FAILED**; `wdg_r`
   and `emit_r` **never ran**; `read outbox --work-id fabro-spike-demo-ff`
   returned "no outbox response found". No `complete` reached the wire.

4. **Three v0.254.0 mechanism facts pinned** (05-structural-loop.md §4;
   03b-runtime-mechanics.md). (a) Every non-judgment node is a native
   `script=` step — a native node physically cannot consume the inbox,
   integrate, push, or run `bc-emit` unless its literal script says so, which
   defeats the Slice-4 G1 collapse. (b) Inputs reach the native command
   sandbox ONLY via the global `[run.environment.env]` overlay — proven by
   probe `01KWDVPMCZA2M8N8J5MGRF6KCM` (a native `echo $BC_NAME $WORK_ID`
   printed the overlay values); `[run.inputs]`/`{{ inputs.NAME }}` are agent-
   prompt-only and do NOT reach `script=`, and `-I` overrides only agent
   prompts. (c) Per-node `permissions=` is NOT enforced in v0.254.0 (a
   `permissions="read-only"` agent's shell tool wrote a 2-byte file with
   `is_error=false`) — it is declarative intent only; native `script=` is the
   sole real lever.

5. **All five invariants HELD on live non-dry-run** (05-structural-loop.md §3):
   invariant #4 specifically — the loop consumed the seeded `assign_scenarios`
   and emitted `work_done` via `bc-emit`/`shop-msg` exactly as the current
   bc-shop loop does; `emit_r`/`emit_clar`/`emit_blk` are all native
   shop-msg/bc-emit calls, and `[run.pull_request].enabled = false` disables
   fabro's native PR path so `integ` is the sole integration authority.

6. **@scenario_hash retirement enumeration — EMPTY (nothing retired).**
   `grep -r "@scenario_hash" features/` carries NO scenario pinning a
   fabro loop-graph, sole-emitter, or fail-closed behavior (no fabro-
   orchestration pin exists in `features/` at all). This ADR authors no
   Gherkin and retires no pinned coverage; the four new
   `features/fabro-orchestration/` pins are net-new lead-process contract
   pins authored by lead-po next.

## Decision

### D1 -- The loop graph is a FIXED DOT topology; `emit_r` is the STRUCTURAL sole gated `work_done(complete)` emitter, reachable only via `review → wdg_r → emit_r` (realizes invariant #4; inherits ADR-042 C1/C2/C3)

The canonical fabro-orchestrated bc-shop loop is the FIXED DOT graph pinned in
`workflow.fabro` (23 nodes / 45 edges, `fabro validate` OK). Its scenario path
is `classify → suff → worktree → plan → impl → redgate → integ → review →
[signoff] wdg_r → emit_r → done`. The contract:

- **`emit_r` is the ONLY `bc-emit ... --status complete` node on the scenario
  path**, and it is graph-reachable ONLY through the native gates
  `review --signoff--> wdg_r -> emit_r`. `wdg_r` re-runs the ADR-042 work-done
  gate (C1/C2/C3: on-disk RED-before-GREEN, work_id on origin/main, on-disk
  `@scenario_hash` recompute ⊆ payload) before `emit_r` fires. There is no
  other path from any judgment agent to a `complete` on the wire — two native
  gates stand between any agent and the mailbox (pre-state finding 2).
- **The flat path is separate and parallel:** `classify --flat--> impl_f →
  wdg_f → emit_f → done` carries `request_maintenance` / empty `request_bugfix`
  via its own gated emitter `emit_f`; it is NOT reachable from the scenario
  path and does not touch `emit_r`.
- **The protocol is preserved (invariant #4):** the loop consumes an
  `assign_scenarios` and emits `work_done` via `bc-emit`/`shop-msg` exactly as
  the current bc-shop loop does. `[run.pull_request].enabled = false` so
  `integ` (`git push origin HEAD:main`) is the sole integration authority; the
  lead reconciles by reading the mailbox (ADR-018), never by harvesting fabro
  structured outputs.

### D2 -- Fail-closed is a topological guarantee: outcome-conditional edges route every non-signoff to a non-emitting terminal, and `emit_r -> halt [outcome=failed]` backstops the UNIQUE-collision case (realizes invariant #4; backstops ADR-012)

Fail-closed is enforced by the edge set, not by agent discipline:

- **A reviewer that does not sign off cannot reach `emit_r`.**
  `review -> wdg_r [signoff]` is the only path onward; the alternatives route
  AWAY from the emitter — `review -> emit_clar [scenario_gap]` (clarify to
  lead), `review -> emit_blk [impl_gap]` (work_done blocked), and
  `review -> halt [condition="outcome=failed"]` (genuine stage error → run
  FAILED). Proven: forced `review` failure → run STATUS FAILED, `wdg_r`/`emit_r`
  never ran, no `complete` on the wire (pre-state finding 3).
- **`wdg_r -> emit_blk [outcome=failed]`:** if any of the C1/C2/C3 work-done
  preconditions fail, the graph routes to a BLOCKED report, never to `emit_r`.
- **`emit_r -> halt [outcome=failed]`:** a `UNIQUE(work_id, direction, shop)`
  collision or retry-exhaustion (ADR-012) halts the run rather than retrying
  into a duplicate or silent complete. This is the ADR-012 backstop expressed
  as a graph edge.

Every emitter node (`emit_r, emit_f, emit_clar, emit_blk`) is native and, on
its own send failure, routes to `halt` — there is no edge that lets a failed
send be swallowed silently.

### D3 -- The guarantees in D1/D2 are ENFORCED, not advisory, because every non-judgment node is native `script=`; the ONLY input channel to that native sandbox is `[run.environment.env]`; and per-node `permissions=` is NOT load-bearing in v0.254.0 (pins the pre-state finding-4 mechanism facts)

The D1/D2 topology only *guarantees* anything because of three v0.254.0
mechanism facts, which this ADR pins as part of the contract (a future fabro
version change against any of them reopens the guarantee):

1. **Native `script=` is the sole real enforcement lever.** Every
   non-judgment node is a `shape=parallelogram, script=` step with NO LLM
   agency; only the 6 judgment nodes are agents. A native node physically
   cannot consume the inbox, integrate, push, or run `bc-emit` unless its
   literal script says so — this is what defeats the Slice-4 G1 node-collapse
   where a general-agent command node swallowed the pipeline into node
   index=1. Advisory prose in an agent prompt is NOT a substitute.
2. **Inputs reach the native command sandbox ONLY via the global
   `[run.environment.env]` overlay.** `[run.inputs]` / `{{ inputs.NAME }}`
   are agent-prompt-only (minijinja) and do NOT reach `script=`; `-I`
   overrides only agent prompts. Every `$WORK_ID`/`$BC_NAME`-parameterized
   gate/emit/integ node therefore reads its inputs from the env overlay (the
   same channel that delivers `HTTPS_PROXY`/CA to the shim — ADR-049).
   Per-BC/per-work override is editing those two overlay values, NOT `-I`.
   This closes the 03b `input-into-command-sandbox` gap.
3. **Per-node `permissions=` is NOT enforced in v0.254.0** — a
   `permissions="read-only"` agent's shell tool wrote a file with
   `is_error=false`. `permissions=` is declarative intent only (kept on
   agents for documentation / future enforcement); it carries NONE of the
   fail-closed guarantee. Native `script=` scoping is the enforcement.

Also pinned: native nodes cannot self-route multi-branch via stdout (2
outcomes only), which forced the `arm → arm + armed` split (23 nodes, not 22).

## Consequences

- **The Slice-4 node-collapse failure mode is eliminated, not masked** (D3):
  because state-changing actions are native and agents have no shell that can
  reach them structurally, no agent can consume the inbox, integrate, or
  emit. Loop fidelity is GREEN on all four criteria on a live in-container run.
- **`work_done(complete)` has exactly one gated origin** (D1): reconciliation
  (lead-architect) can trust that a `complete` on a fabro-orchestrated BC's
  outbox passed the ADR-042 C1/C2/C3 gate at `wdg_r`, because that is the only
  path to `emit_r`.
- **Fail-closed is a property of the graph, not of agent behavior** (D2): the
  worst an off-the-rails judgment agent can do is trip a native gate that
  routes to `emit_blk`/`halt`; it cannot talk past a native node into a false
  complete (the persisting no-directive hazard for the 6 agents is
  structurally backstopped).
- **The contract is version-coupled to fabro v0.254.0** (D3): the three
  mechanism facts are the load-bearing enforcement. A future fabro that
  enforces `permissions=`, or that changes the `[run.environment.env]` →
  `script=` channel, changes what "enforced" rests on and must be re-verified
  against this ADR.
- **The four `features/fabro-orchestration/` pins reference this ADR** and
  their block-only `@scenario_hash` values are recorded here
  (defense-in-depth: lead-architect VERIFIES the PO-authored hashes, does not
  introduce them): scenario 03 (`assign_scenarios`→`work_done` loop) →
  `56c0f126447e48d6` and scenario 04 (forced-reviewer-fail fail-closed) →
  `7ddada412f406767` both pin this ADR. No `@scenario_hash`
  is retired (pre-state finding 6).

## Follow-ups / dependencies (named, not designed here)

- **`scenario_hashes` over-include polish** — `emit_r` currently builds the
  payload from EVERY on-disk `@scenario_hash` tag (a correct superset, C3 is
  ⊆-satisfied) rather than only the assigned block. Scoping the emit to the
  assigned block is cosmetic furniture (05-structural-loop.md §5 residual 1);
  a future BC-implementation dispatch item, not designed here.
- **The flat path `impl_f → wdg_f → emit_f` stale-cwd/empty-hash fix** — the
  scenario path's stale-cwd/empty-hash defect was found and fixed in `emit_r`
  (`cd ../wt-$WORK_ID`; build `--scenario-hash` from on-disk tags); the flat
  path carries the same shape and needs the same fix before use (it was not
  exercised this leg). Residual 2.
- **No reactive LISTEN/NOTIFY node primitive** — fabro has no reactive node;
  `shop-msg watch` survives only as a command node, and the session-start
  drain is not robust to upstream consumption (residuals G3/G4). Orthogonal to
  loop fidelity; not a v0.254.0 wall.
- **The real bc-container-launch drop-in** — parity was hand-provisioned in
  the spike (ADR-050 follow-up caveat); wiring the loop graph into the real
  manifest/broker/clone launcher is a P2 follow-up bead, not designed here.

## Alternatives considered

- **Keep loop nodes as fabro command nodes (general agents) with advisory
  scope/sole-emit prose.** Rejected (D3): this is exactly the Slice-4 G1
  failure — a command node is a general LLM agent, so its scope/sole-emit were
  advisory and the `prime` agent swallowed the whole pipeline. Only native
  `script=` makes the guarantee structural.
- **Rely on per-node `permissions=` to constrain state-changing actions.**
  Rejected (D3): `permissions=` is NOT enforced in v0.254.0 (a read-only agent
  wrote a file with `is_error=false`). It is documentation-only; native
  `script=` is the sole real lever.
- **Pass inputs via `[run.inputs]` / `{{ inputs.NAME }}` to the gate/emit
  scripts.** Rejected (D3): those are agent-prompt-only (minijinja) and never
  reach a native `script=` sandbox, so the gate scripts would read empty
  `$WORK_ID`/`$BC_NAME`. The global `[run.environment.env]` overlay is the
  only channel that reaches native nodes (03b gap closure).
- **Let `emit_r` retry indefinitely on a UNIQUE collision.** Rejected (D2):
  `emit_r -> halt [outcome=failed]` halts on a `UNIQUE(work_id, direction,
  shop)` collision / retry-exhaustion (ADR-012) rather than risking a
  duplicate or a silent complete; the loop fails loudly instead.
- **Let the lead harvest `work_done` from fabro structured outputs instead of
  the mailbox.** Rejected (invariant #4 / ADR-018): work_done must round-trip
  over `shop-msg`/`bc-emit`; the lead reconciles by reading the outbox, and
  fabro's native PR path is disabled so `integ` is the sole integration
  authority.
