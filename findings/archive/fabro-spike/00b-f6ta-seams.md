# Slice 0 Leg B — f6ta "2 seams / 3 invariant surfaces" recovered

**Epic:** lead-6k1r · **Origin bead:** lead-f6ta · **Date:** 2026-07-01 · READ-ONLY recon

> **This is NOT a reconstruction.** The "TWO seams … bounded by THREE
> invariant-surfaces" framing is stated *literally* in the origin bead
> `lead-f6ta` (its VERDICT line) and is quoted verbatim in
> `findings/substrate-candidate-comparison-vs-fabro.md`. Both are cited below.
> Origin of the framing: the initial f6ta workflow analysis (11 agents, task
> `wzcm397gc` / run `wf_ce7f1f1d-3e2`), verdict "directionally right but
> leaks-materially → reframe as 2 seams bounded by 3 invariant-surfaces."

---

## THE 2 SEAMS — where fabro attaches (replaces)

A "seam" = a point in the shopsystem execution contract where fabro is allowed
to substitute *how* something runs without changing *what* the contract is.

### Seam (a) — BC launch → fabro run.  Verdict: **CLEAN**
Fabro cleanly substitutes the launch path. The correspondence (per lead-f6ta):

- `bc-container` launch → `POST /api/v1/runs` (RunManifest) + `/start`
- `BC_IMAGE` → `[environments.<slug>]`
- container-init → `[run.prepare]` + `[run.clone]`
- lead→BC dispatch → parent/child runs via `fabro_run_create`
- PO-authors / Architect-verifies discriminator → child `approval_required` gate

Source: lead-f6ta DESCRIPTION, "SEAM (a) … CLEAN".
Corroboration: `substrate-candidate-comparison-vs-fabro.md` scorecard row
"fabro … Seam-a (BC launch) = CLEAN".

### Seam (b) — Monitor (reactive loop) → fabro loop.  Verdict: **PARTIAL / refuted as drop-in**
Fabro can wrap the loop but cannot BE the event source.

- All 15 fabro hook events are **INTERNAL lifecycle points**. Fabro has **NO
  native primitive for an EXTERNAL async arrival** (the postgres LISTEN/NOTIFY
  inbound BC response that `shop-msg watch` delivers).
- Fabro supplies loop / retry / checkpoint **rails AROUND** the event source but
  **cannot be** it. `shop-msg watch` survives as a *command node inside* a fabro
  loop.
- What fabro DOES subsume: checkpoint/resume subsumes the **session-start drain**.
- Open unknown (flagged, not yet resolved): can a node block-and-wait on an
  external signal vs. only poll? `fabro_run_events` ordering/delivery guarantees?

Source: lead-f6ta DESCRIPTION, "SEAM (b) … PARTIAL / refuted as drop-in".
Corroboration: `substrate-candidate-comparison-vs-fabro.md`, "the reactive
Monitor/loop" seam; fabro row "Seam-b = PARTIAL".

---

## THE 3 INVARIANT SURFACES — what fabro must NOT touch (preserve)

In lead-f6ta these are called the **"THREE LEAKS (stay shop-msg/bd-owned)."**
`substrate-candidate-comparison-vs-fabro.md` names the same three as the
**"three invariant-surfaces."** They are identical; the "leak" is the failure
mode when fabro is allowed to touch the surface.

### Invariant 1 — bd is the authoritative state store
fabro's checkpoint (durable store + `fabro/run/{id}`, `fabro/meta/{id}` branches)
is a **COMPETING authority**; it MUST be **demoted to run-resume-only**. bd stays
the single state authority.
- **Source citation:** PDR-010 — *"bd is authoritative for system state; shop-msg
  is transport + wakeup + liveness"* (accepted 2026-05-29). Reinforced by ADR-016
  (*shop-msg owns bd integration; state changes via CLI, not agent*).
- Comparison-doc label: "Leak 1: bd authority."

### Invariant 2 — name registry + from/to addressing
The messaging name registry and `<system>/<name>` addressing has **NO fabro
analog**; the lead **still runs `shop-msg registry add`**. Fabro must not invent
or replace addressing identity.
- **Source citation:** ADR-006 (*Messaging name registry design*) + ADR-020
  (*Routing identity is an abstract `<system>/<name>` address; `shop_root`
  eliminated*).
- Comparison-doc label: "Leak 2: addressing (Absent — no analog)."

### Invariant 3 — empirical-verification-is-contract-surface (harvest surface)
The lead must **NOT harvest `work_done` by reading fabro child outputs**. Keep
`shop-msg read outbox` + `scenarios hash` as the ONLY harvest path. Reading fabro
run outputs to learn a BC's result is an ADR-018 violation.
- **Source citation:** ADR-018 — *"Verify pre-state empirically" means the
  contract/artifact surface; the lead carries no BC code* (accepted 2026-05-30;
  pins PDR-011).
- Comparison-doc label: "Leak 3: ADR-018 harvest (must not harvest outputs)."

---

## Sharpest risk carried by the seams (adversary finding — record, don't lose)

`shop-msg respond` is a bd-first fsync'd transactional bd write (ADR-016) under
ADR-012's 3-step protocol. Fabro checkpoints on EVERY node, and the BC tier HAS a
git repo, so fabro will checkpoint-commit the BC worktree on the SAME node that
runs `shop-msg respond` → **active ordering hazard against ADR-012 at the BC
tier** (phantom postgres row / bd-postgres divergence on retry).

**Status — partially resolved** (`findings/fabro-2pc-as-steps-spike.md`, verdict
go-with-caveats, fabro 0.254.0):
- Kill BETWEEN nodes: CONFIRMED safe (resume from `next_node_id`, no re-deposit).
- Micro-window kill INSIDE a node after DB-commit-before-checkpoint: NOT
  eliminated — rejected only by ADR-012's `UNIQUE(work_id,direction,shop)`
  backstop. So **ADR-012 UNIQUE + bd-first sweeper REMAIN MANDATORY.**
- NEW hazard: fabro default **unconditional edges advance past a FAILED node and
  mark the run SUCCEEDED** (silent failure-masking) → need outcome-conditional
  edges / node retry.

---

## Relation to the ACTIVE epic (lead-6k1r) — scope shift to note for Slice 1+

lead-f6ta's 2-seams/3-surfaces analysis was framed for fabro as an **EXTERNAL**
substrate (fabro orchestrating the whole shop / lead↔BC). The ACTIVE epic
**lead-6k1r narrows fabro to IN-CONTAINER BC orchestration ONLY** (ephemeral
local fabro server inside the BC container). Under that narrower scope:

- **Only Seam (b)-inside-the-BC is in play** — fabro recreates the in-container
  Implementer→Reviewer loop. Seam (a) collapses to "launch-interface parity with
  `bc-container`" (epic invariant 3), NOT a fabro `POST /runs` external launch.
- The epic adds a **4th hard invariant not in f6ta's three: credentials via
  AGENT-VAULT, NOT fabro secret-management** (David explicit; plan.md §2). This
  is a *new* invariant surface introduced by the in-container scope — f6ta's
  three did not enumerate a credential surface because it predates the
  agent-vault substrate decision (PDR-017).
- f6ta's Invariant 3 (ADR-018 harvest) and the shop-msg protocol (epic invariant
  4) still hold: the fabro loop must emit `work_done` via shop-msg, and the lead
  harvests only via `shop-msg read outbox` + `scenarios hash`.
- f6ta's Invariant 1 (bd authority) still bites INSIDE the container: the fabro
  checkpoint vs. ADR-012 bd-first race is exactly the sharpest-risk above, now
  living entirely at the BC tier — which is precisely where the epic runs fabro.
- f6ta's Invariant 2 (addressing / `shop-msg registry add`) is a LEAD-side
  concern; under in-container scope it stays lead-owned and untouched.

**Net for the spike:** the 3 f6ta invariant surfaces remain valid preservation
targets; the epic adds agent-vault-credentials as a 4th, and reduces the seam
surface to the in-container loop + launch-interface parity.

---

## Blockers still standing (from lead-f6ta)
- **bc-base un-rebuildable** (ADR-022: scenarios CLI not baked, pdr/002 pin
  404s) — must resolve before any full e2e leans on it.
- Key empirical unknowns unresolved: does fabro pull current `:latest` digest vs
  stale cache (ADR-021 D3)? node block-and-wait on external signal? one node
  emitting multiple shop-msg messages (only final JSON validated)?

## Sources
- `bd show lead-f6ta` (DESCRIPTION + NOTES) — primary, holds the framing verbatim.
- `bd show lead-6k1r` — active epic, in-container scope + 5 hard invariants.
- `findings/fabro-spike/plan.md` — plan + hard constraints (esp. §2 agent-vault).
- `findings/substrate-candidate-comparison-vs-fabro.md` — names "two seams" +
  "three invariant-surfaces" verbatim; scorecard confirms fabro CLEAN/PARTIAL.
- `findings/fabro-2pc-as-steps-spike.md` — sharpest-risk partial resolution.
- ADRs: 006, 012, 016, 018, 020, 021, 022 · PDRs: 010, 011, 017.
