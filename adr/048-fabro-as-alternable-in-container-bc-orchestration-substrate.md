# ADR-048 — Fabro is an alternable in-container BC-orchestration substrate (provider=local); it replaces only the Seam(a) launch+loop, never the three shop-msg/bd invariant surfaces

- Status: Accepted (2026-07-01)
- Date: 2026-07-01
- Implements: the odqd iterative-experimentation track graduation of the fabro
  spike (epic lead-6k1r, GOAL GREEN 2026-07-01). This ADR SETTLES the substrate
  question the spike opened — is fabro admissible as an alternable BC-orchestration
  substrate, and under what boundary — and is NOT a re-exploration; the spike's
  learning is now durable canon and the throwaway defs are reference-only.
- Anchored on (decisions this builds on — NOT re-decided here):
  - [ADR-029](029-spike-vehicle-extend-pdr014-graduation-no-request-spike.md) /
    [ADR-030](030-spike-isolation-contract-scratch-dummy-teardown-to-findings.md) /
    [ADR-032](032-spikes-execute-via-workflow-return-markdown-findings.md) /
    [PDR-016](../pdr/016-iterative-experimentation-first-class-lead-capability.md)
    — the spike vehicle + iterative-experimentation track this graduates THROUGH
    (spike → learn → throw away → graduate via ADRs + scenarios); the
    `findings/fabro-spike/*.md` markdown is the ADR-032 spike artifact surface.
  - [PDR-014](../pdr/014-lead-skill-group-pour-and-graduation-path.md) — the
    graduation path a spike outcome rides into canonical artifacts.
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) — the
    contract-surface rule: the lead does NOT harvest `work_done` by reading fabro
    child outputs; it keeps `shop-msg read outbox` + `scenarios hash`. Fabro does
    not touch this surface.
  - [PDR-010](../pdr/010-bd-authoritative-shop-msg-transport.md) — bd is the
    authoritative work-state; fabro's SlateDB checkpoint is a competing authority
    demoted to run-resume-only.
  - [ADR-006](006-messaging-name-registry-design.md) /
    [ADR-020](020-routing-identity-is-abstract-system-name-shop-root-eliminated.md)
    — name registry + `<system>/<name>` addressing has no fabro analog; the lead
    still runs `shop-msg registry add`.
- Bead: lead-f6ta (the fabro spike origin bead). This ADR is its graduated
  outcome and **SUPERSEDES** lead-f6ta. Parent epic lead-6k1r (GREEN). UMBRELLA
  substrate: REALIZED BY [ADR-049](049-agent-vault-is-sole-credential-surface-under-fabro-native-secrets-forbidden.md)
  (credentials), [ADR-050](050-fabro-launch-interface-parity-with-bc-container.md)
  (launch parity), [ADR-051](051-fabro-dot-loop-graph-contract-reviewer-sole-gated-emitter-fail-closed.md)
  (loop graph), each Anchored on this ADR.

## Context

Origin bead lead-f6ta explored whether fabro (fabro.sh, a single Rust binary,
v0.254.0) could serve as the BC-orchestration substrate. Its VERDICT was
"directionally right but leaks-materially. Reframe as TWO seams of replacement
bounded by THREE invariant-surfaces fabro must NOT touch." The lead-6k1r epic
narrowed that framing to a single admissible scope — **in-container BC
orchestration only** — and ran it to a GREEN goal across Slices 0–5: a
fabro-orchestrated throwaway BC consumed a seeded `assign_scenarios` and emitted a
valid `work_done`, with the recreated Implementer→Reviewer loop actually running
(loop fidelity GREEN, Slice 5).

The spike settled that fabro is viable as an **alternable substrate for one seam
and one seam only**: the BC-launch → fabro-run and reactive-loop → fabro-loop
seams (Seam a + the partial Seam b). It is NOT a wholesale replacement of the lead
shop's orchestration; three invariant surfaces (four with the epic's credential
addition, ADR-049) must remain untouched. This ADR records that boundary as an
enforceable contract and stands up the umbrella under which ADR-049/050/051 pin
each realized surface.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's `features/`,
`adr/`/`pdr/`, `shop-msg` mailbox state, and scenario hashes via the installed
`scenarios hash` CLI, on 2026-07-01. For a graduating spike ADR the primary
artifact surface is the ADR-032 spike findings under `findings/fabro-spike/`:

1. **Two seams / three invariant surfaces — RECOVERED, not reconstructed**
   (`findings/fabro-spike/00-fabro-recon.md` §b). The framing is stated literally
   in lead-f6ta's VERDICT line and quoted verbatim in
   `findings/substrate-candidate-comparison-vs-fabro.md`. Seam (a) BC-launch →
   fabro-run is CLEAN; Seam (b) Monitor/reactive-loop → fabro-loop is PARTIAL
   (fabro has no native external-async LISTEN/NOTIFY primitive, so `shop-msg watch`
   survives as a command node). The three invariant surfaces fabro must NOT touch:
   bd-authoritative-state (PDR-010/ADR-016), name-registry+addressing
   (ADR-006/ADR-020), empirical-harvest-surface (ADR-018).

2. **Fabro runs as an ephemeral LOCAL in-container server** (00-fabro-recon.md §a;
   04-goal-demo.md §3 row 1). Verified live: fabro ran as `pid 379 @
   127.0.0.1:32276` INSIDE `bc-fabro-throwaway`, executing only that one BC's loop
   — `provider='local'`, no fabro cloud/external orchestration. The lead kept
   shop-msg/Monitor throughout.

3. **All five hard invariants HELD on a live, non-dry-run run** (04-goal-demo.md §3
   table; corroborated 05-structural-loop.md §3). Invariant #1 (in-container scope)
   and the three untouched surfaces were observed intact on the real haiku-LLM run
   `01KWDTN9F1J0MASAPDCE3TAAN8`. Loop fidelity, RED at Slice 4 (node-collapse), was
   closed to GREEN at Slice 5 via native `script=` gating (05-structural-loop.md §0
   and §1), so the overall spike GOAL is GREEN (05 §2).

4. **fabro's SlateDB checkpoint is a competing authority to bd** (00-fabro-recon.md
   §a/§b, §d). Durable run/checkpoint state lives in a SlateDB object store at
   `<storage>/objects/slatedb`; fabro checkpoints on every node. Against the ADR-012
   bd-first fsync'd transactional write this is an ordering hazard at the BC tier —
   demoted here to run-resume-only.

5. **@scenario_hash retirement enumeration — EMPTY (no retirement).** `grep -r
   "@scenario_hash" features/` carries no scenario pinning fabro in-container
   orchestration; no fabro-orchestration behavior is currently pinned anywhere in
   `features/`. This ADR retires nothing. The graduation Gherkin
   (`features/fabro-orchestration/01–04`) is authored fresh by lead-po and
   introduces new pins, not amendments.

## Decision

### D1 — Fabro is admissible ONLY as an ephemeral local in-container orchestration server (provider=local), never as cloud/external orchestration (settles the invariant #1 boundary)

Fabro is admissible as a BC-orchestration substrate under exactly one shape: an
**ephemeral local server** (`provider='local'`, bound to `127.0.0.1`) running
INSIDE a `bc-base` container, orchestrating only that single BC's
Implementer→Reviewer loop. Fabro cloud, external `POST /runs` orchestration, or any
cross-BC/fleet orchestration is OUT OF CONTRACT. This is invariant #1 and it was
observed HELD on the live run (pre-state finding 2). The substrate is per-BC and
per-container; there is no fabro tier above the BC.

### D2 — Fabro is an alternable substrate for the Seam(a) launch+loop ONLY; the lead retains shop-msg + Monitor and the three invariant surfaces (settles the seam boundary from the f6ta VERDICT)

Fabro replaces only the **Seam (a)** BC-launch→fabro-run and the loop-execution
portion of Seam (b); it is *alternable* (a BC's loop may be driven by fabro or by
the current bc-container/tmux furniture — the choice is a substrate swap behind an
unchanged interface). The following surfaces are NOT fabro's and MUST remain
untouched:

- **bd is the authoritative work-state** (PDR-010 / ADR-016). Fabro's SlateDB
  checkpoint (pre-state finding 4) is demoted to **run-resume-only** — it may resume
  an interrupted run but is never the source of truth for work state or `work_done`
  provenance. The competing-authority leak the f6ta VERDICT flagged is closed by
  this demotion.
- **Name registry + `<system>/<name>` addressing** (ADR-006 / ADR-020). Fabro has
  no analog; the lead still runs `shop-msg registry add` and addresses BCs by
  canonical name.
- **Empirical-harvest surface** (ADR-018 / PDR-011). The lead NEVER harvests
  `work_done` by reading fabro child outputs or fabro structured-run JSON; it reads
  the outbox via `shop-msg read outbox` and recomputes hashes via `scenarios hash`.
  Fabro produces the `work_done` on the wire; it does not become a lead-side read
  surface.

Seam (b) remains PARTIAL by contract: fabro has no native external-async primitive
(pre-state finding 1), so `shop-msg watch` survives as a command node inside the
fabro loop and the lead's Monitor/reactive posture is unchanged.

### D3 — The realized invariant surfaces are pinned by ADR-049/050/051; this ADR is the umbrella they anchor on (settles the graduation decomposition)

The three realized surfaces of the substrate are each pinned by a child ADR
Anchored on this one, and are NOT re-decided here:

- **Credentials** — [ADR-049](049-agent-vault-is-sole-credential-surface-under-fabro-native-secrets-forbidden.md):
  agent-vault is the sole credential surface; fabro's native secret system is a
  FORBIDDEN surface (the epic's 4th invariant, David-explicit).
- **Launch parity** — [ADR-050](050-fabro-launch-interface-parity-with-bc-container.md):
  which P1–P20 launch-parity properties fabro KEEPS vs REPLACES (invariant #3).
- **Loop graph** — [ADR-051](051-fabro-dot-loop-graph-contract-reviewer-sole-gated-emitter-fail-closed.md):
  the DOT Implementer→Reviewer graph with `emit_r` the sole gated emitter and
  outcome-conditional fail-closed edges, ENFORCED by native `script=` scoping
  (invariant #4: shop-msg protocol preserved).

## Consequences

- **The fabro substrate question is settled and bounded.** A BC's loop MAY be
  driven by an in-container fabro server; the substrate is alternable behind an
  unchanged lead interface, and the boundary (in-container only, three untouched
  surfaces) is contractual, not advisory.
- **bd remains the single work-state authority.** Fabro's checkpoint is
  resume-only; no reconciliation reads fabro state. The ADR-012/ADR-016
  transactional discipline is untouched (the BC-tier race is addressed in ADR-051).
- **The lead's contract-surface posture is preserved** (ADR-018): the lead still
  reads `work_done` from the outbox and recomputes hashes, whether the BC loop ran
  under fabro or the current furniture. Graduating fabro changes the BC's internal
  loop substrate, not the lead's verification surface.
- **REALIZED BY** ADR-049 (credentials), ADR-050 (launch parity), ADR-051 (loop
  graph). Each is Anchored on this ADR and pins one invariant surface; this ADR is
  the umbrella.
- **No `@scenario_hash` retired** (pre-state finding 5). The graduation scenarios
  `features/fabro-orchestration/01–04` are new pins authored by lead-po; their four
  block-only hashes, verified — not introduced — by lead-architect at graduation
  reconcile via the installed `scenarios hash` CLI (defense-in-depth), are:
  `01-launch-interface-parity-boot` → `1aeace4c593ab14f` (ADR-050),
  `02-agent-vault-only-credential-injection` → `9c7b4e8280665239` (ADR-049),
  `03-assign-scenarios-to-work-done-loop-under-fabro` → `56c0f126447e48d6` (ADR-051),
  `04-forced-reviewer-fail-is-fail-closed-no-complete-emit` → `7ddada412f406767` (ADR-051).
- **These pins are LEAD-PROCESS / contract pins, not immediately dispatchable.**
  fabro in-container orchestration is not yet an owned BC, so the graduation
  scenarios are not `assign_scenarios`-dispatchable today; they document the
  substrate contract, most BC-adjacent should a fabro-orchestration BC ever be
  created (see Follow-ups).

## Follow-ups / dependencies (named, not designed here)

- **Real `bc-container launch` drop-in integration.** Launch parity in the spike was
  hand-provisioned (04-goal-demo.md §4); the real manifest/broker/clone drop-in
  machinery is a follow-up bead (the ADR-050 caveat), not designed here.
- **G3 drain-not-robust-to-upstream-consumption** and **G4 no-reactive-LISTEN/NOTIFY
  node-primitive** (04-goal-demo.md §5; Seam (b) PARTIAL) — both fixable/orthogonal,
  neither is a v0.254.0 wall. Future BC-implementation dispatch items.
- **A fabro-orchestration BC.** Should the substrate be adopted beyond the spike,
  the graduation scenarios become the pins of a new owned BC; that BC's creation is a
  product decision for David, not designed here.

These follow-ups are NOTED, not created; they are flagged for David/router at
reconcile per the spike's own residual list.

## Alternatives considered

- **Rejected (D1): fabro as cloud/external orchestration.** The f6ta VERDICT found
  this "leaks-materially" — external orchestration would subsume the lead's shop-msg
  and Monitor tiers and put a competing state authority above the BC tier. The epic
  narrowed scope to in-container-only precisely to keep the leak closed; only the
  local in-container shape is admissible.
- **Rejected (D2): let fabro's SlateDB checkpoint be a work-state authority.** This
  is the competing-authority leak against bd (PDR-010/ADR-016). Demoting the
  checkpoint to run-resume-only preserves bd as the single source of truth;
  promoting it would reopen the ADR-012 ordering hazard as a first-class authority
  conflict rather than a bounded BC-tier race.
- **Rejected (D2): let the lead harvest `work_done` from fabro structured-run
  outputs.** This violates ADR-018/PDR-011 — the empirical surface is `shop-msg read
  outbox` + `scenarios hash`, not a BC's internal orchestrator output. Fabro
  produces `work_done` on the wire; it never becomes a lead read surface.
- **Rejected (D3): one monolithic graduation ADR.** The substrate has three
  distinct realized invariant surfaces (credentials, launch parity, loop graph),
  each with its own contract, cross-refs, and pinning scenario. Decomposing into an
  umbrella (this ADR) + three realizing ADRs keeps each surface's contract
  independently citable and separately amendable, matching the house one-decision-
  per-ADR convention.
