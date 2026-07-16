# Slice 5 — Structural loop, no collapse (synthesis)

**Epic** lead-6k1r (Fabro spike) · **Slice** 5 · **Branch** `fabro-spike`
· **Date** 2026-07-01 · fabro v0.254.0 · SPIKE / THROWAWAY.
Legs: **05a HARDEN** (`05a-harden.md`) → **05b RERUN** (`05b-rerun.md`).

---

## 0. LOOP-FIDELITY VERDICT — **GREEN**

The structured Implementer→Reviewer loop runs **end-to-end** in-graph, `emit_r`
is the **structural sole** work_done emitter, and a forced reviewer-fail is
**fail-closed** (run FAILED, no `complete` on the wire). The Slice-4 node-collapse
failure mode is **eliminated**, not merely masked.

Root cause of the Slice-4 PARTIAL was G1: a fabro command node is a *general LLM
agent* whose scope/decomposition/sole-emit were advisory, so the `prime` agent
carried the graph goal and swallowed the whole pipeline into node index=1. The
HARDEN leg's structural fix — **every non-judgment node is now a native `script=`
step (no LLM agency), and only 6 genuine judgment nodes remain agents** — was
proven under a live, non-dry-run, in-container run on the RERUN leg. A native node
physically cannot consume the inbox, integrate, push, or run `bc-emit` unless its
literal script says so; every state-changing action (inbox drain, integrate,
work-done gate, bc-emit) is now native, so no agent can perform one.

`fabro validate workflow.fabro` → **OK (23 nodes, 45 edges)** (was 22/44; +1 node
`armed` from the native-routing constraint that forced the `arm` split).

---

## 1. The four criteria — each PASS/FAIL with trace evidence

All verdicts from live, non-dry-run runs in the throwaway container
`bc-fabro-throwaway`, fabro v0.254.0.

### (a) `prime` runs only `shop-msg prime && bd prime`, touches nothing — **PASS**

`prime` is a native `script=` node timed at **283–343ms across 3 runs** (was
4m14s / $0.48 runaway agent in Slice 4). Script is exactly
`set -e; shop-msg prime --bc "$BC_NAME"; bd prime` — no git write, no bc-emit, no
inbox consume. A ~300ms two-read-command shell **physically cannot** run the
pipeline; deliverable commits are attributable to the `impl` node window, not
`prime`. The Slice-4 root cause (command-node-is-a-general-agent) is defeated.

### (b) Full loop sequence executes in order — **PASS**

demo-3g (run `01KWD…3g`, all green) ran, node by node:
`classify→"scenario"→suff→"proceed"→worktree→plan→impl→redgate→integ→review→"signoff"→wdg_r→emit_r→done`.
**Every** loop node executed, in order — no skip, no collapse, no false-idle. Full
node-by-node trace with per-node timings/costs in `05b-rerun.md` §1
(6 min / $0.43 total).

### (c) work_done emitted by `emit_r` alone (structural sole-emitter) — **PASS (in-graph)**

`emit_r` is the **only** `bc-emit` node on the scenario path, graph-reachable
**only** via `review→signoff→wdg_r→emit_r` (all native gates; the bc-emit wrapper
re-runs the gate). demo-3g's `emit_r` (1s) emitted a valid `status: complete`
**in-graph**; outbox `fabro-spike-demo-3g` = complete, scenario hashes
`[674e0bb2, ed28a476, a24121ea]`, backed by real
`test(red) 21458da` → `feat(green) 57fe9b2 [fabro-spike-demo-3g]` on origin/main.
This is the exact artifact Slice 4 could not produce structurally. AC5's Slice-4
PARTIAL (reviewer-sole-emitter not enforced) is now **closed structurally**: two
native gates stand between any agent and the mailbox.

### (d) Forced reviewer-fail → run FAILED, no `complete` on wire — **PASS**

`workflow-forcefail.fabro` mirrors the real review sub-path
(`review→wdg_r→emit_r→done` signoff route / `review→halt [outcome=failed]` fail
route) with `review` replaced by a native `exit 1` and `emit_r` kept as a **real**
`bc-emit`: `start→review(✗ outcome=failed)→halt` → **Status FAILED**; `wdg_r` and
`emit_r` **never ran**; `read outbox …--work-id fabro-spike-demo-ff` = "no outbox
response found". A reviewer that does not sign off cannot reach the sole emitter
and cannot put a `complete` on the wire.

**One defect found and FIXED mid-leg (fixable defs, NOT a fabro wall):** the first
structured run (demo-3b) reached `emit_r` but it FAILED → run FAILED — fail-closed
held, no false complete. Root cause: `emit_r`/`wdg_r` ran in the stale cwd
`/root/sandbox` (integ pushes the worktree to origin/main but never updates the
sandbox), and `emit_r` computed its payload with bare `scenarios hash`, which reads
a Gherkin block from stdin — with no pipe it hashes the empty string
(`e3b0c442…`), so bc-emit's C3 (on-disk recompute ⊆ payload) rejected. Fix applied
to tracked `workflow.fabro`: `cd "../wt-$WORK_ID"` and build the payload from every
on-disk `@scenario_hash` tag as repeatable `--scenario-hash` flags. Verified twice
(direct execution in demo-3b's worktree + the full in-graph demo-3g run).

---

## 2. Does this upgrade the overall spike GOAL from PARTIAL to GREEN? — **YES**

Slice 4 banked the artifact-level proof (a valid `work_done(complete)` produced by
a real fabro-orchestrated non-dry-run) but scored the overall goal **PARTIAL**
because loop fidelity was RED — the loop collapsed into one node and the
sole-emitter was not enforced. Slice 5 closes exactly that gap: loop fidelity is
now **GREEN** on all four criteria, on a live in-container run, with the
sole-emitter and fail-closed behavior enforced *structurally* rather than
advisory. The goal defined in the plan ("dispatch `assign_scenarios` to a
fabro-orchestrated BC and observe a valid `work_done` produced by the recreated
Implementer→Reviewer loop") is now met with the loop actually recreated.

**Overall spike GOAL: GREEN.**

---

## 3. How the invariants held

All five hard invariants HELD across both legs (throwaway-scoped throughout):

1. **Fabro = in-container BC orchestration only** — every run was inside
   `bc-fabro-throwaway`; no fabro cloud/external orchestration; the lead keeps
   shop-msg / Monitor.
2. **Credentials via agent-vault, NOT fabro secrets** — **HELD (verified).** fabro
   vault = `__PLACEHOLDER__` for both secrets; all LLM traffic went dummy
   `x-api-key` → in-container anthropic-oauth-shim → agent-vault → 200. This is the
   load-bearing invariant #2 and it was intact on every run.
3. **Launch-interface parity** — the graph ran under `provider='local'` inside an
   already-booted bc-launcher-parity container (unchanged from Slice 3/4).
4. **shop-msg protocol preserved** — the loop consumed the seeded
   `assign_scenarios` and emitted `work_done` via `bc-emit`/`shop-msg` exactly as
   the current bc-shop loop does; `emit_r`/`emit_clar`/`emit_blk` are all native
   shop-msg/bc-emit calls.
5. **Rollback / main untouched** — all work on `fabro-spike`; the only writes were
   to a local bare origin and local postgres rows for the throwaway BC. No real
   infra BC, no remote repo, no message to a real BC.

**needs_david: none for the spike work itself** — fully in-scope. (Graduation is a
separate product decision; see §5.)

---

## 4. Two fabro-v0.254.0 mechanism facts pinned this slice (feed the ADRs)

- **Inputs into native `script=` via the `[run.environment.env]` overlay: WORKS.**
  Unlike `[run.inputs]`/`{{ inputs }}` (agent-prompt-only, Slice 3), the **global
  env overlay** reaches the native command sandbox as real shell env vars, so all
  WORK_ID/BC_NAME-parameterized gate/emit/integ nodes could be native. This closes
  the 03b `input-into-command-sandbox` gap and was the key enabler for the whole
  harden. `-I` overrides only agent prompts, NOT `script=`; per-run overrides edit
  the two overlay values in `workflow.toml`.
- **Per-node `permissions=` scoping is NOT enforced** in v0.254.0 (a
  `permissions="read-only"` agent's shell tool wrote a 2-byte file with
  `is_error=false`). So `permissions=` is declarative intent only; **native
  `script=` is the sole real lever** — set permissions on agents anyway for
  documentation/future enforcement. Also: native nodes cannot self-route multi-branch
  via stdout directives (2 outcomes only), which forced the `arm`→`arm`+`armed`
  split.

---

## 5. Graduation readiness — **spike is DONE; recommend graduation (product decision for David)**

Slice 5 is GREEN and the overall goal is GREEN, so per 04-goal-demo.md §6 the spike
is complete and ready to graduate via the **odqd** iterative-experimentation track
(spike → learn → throw away → graduate via ADRs + scenarios; spike vehicle
ADR-029/030/032). **Graduation itself is a product decision reserved to David** —
this synthesis recommends it and stages the inputs.

**Four ADRs to draft on graduation (from 04-goal-demo.md §6):**

1. **fabro as an alternable in-container BC-orchestration substrate** — records the
   Seam(a) launch-parity contract + the `provider='local'` in-container model;
   supersedes origin bead lead-f6ta.
2. **agent-vault as the sole credential surface under fabro** — the
   vault-`__PLACEHOLDER__` + `HTTPS_PROXY` + anthropic-oauth-shim path; formalizes
   invariant #2 as a contract and names fabro's native secret system as a forbidden
   surface.
3. **fabro launch-interface parity with `bc-container`** — the drop-in-launcher
   contract: which P1–P20 properties (Slice 1) are KEPT/REPLACED, and the
   readiness-barrier seam.
4. **the fabro DOT loop-graph contract** — the Implementer→Reviewer graph with the
   reviewer as sole gated emitter + outcome-conditional fail-closed edges; lands
   *with* the Slice-5 native-`script=` fix that makes those guarantees **enforced**
   (native gates), plus the two mechanism facts in §4 (env-overlay is the only input
   channel to native scripts; `permissions=` is not load-bearing).

**Graduation scenarios pin:** launch-parity boot; agent-vault-only credential
injection; the `assign_scenarios`→`work_done` loop; and fail-closed behavior
(forced reviewer-fail ⇒ no `complete` emit).

**No fabro capability walls remain.** Residuals are all fixable/orthogonal, none are
v0.254.0 walls: (1) `scenario_hashes` over-includes all on-disk scenarios (cosmetic
furniture — scope the emit to the assigned block on polish); (2) the flat path
`impl_f→wdg_f→emit_f` carries the same stale-cwd/empty-hash shape and needs the same
worktree fix before use (not exercised this leg); (3) `claude-sonnet-4-6` was
rate-limited on the agent-vault OAuth path so judgment agents ran on a runtime-only
all-haiku override — model choice is orthogonal to fidelity, and the tracked def
keeps the faithful sonnet stylesheet; (4) the agent no-directive hazard persists for
the 6 judgment agents but is now structurally backstopped (the next state-changing
node after any agent is a native gate that re-verifies and cannot be talked past).

**Uncommitted artifacts** (both legs, orchestrator owns the commit):
`findings/fabro-spike/fabro-defs/workflow.fabro` (harden split + wdg_r/emit_r fix),
`fabro-defs/workflow.toml` (env overlay), `fabro-defs/workflow-forcefail.fabro`
(new). Container `bc-fabro-throwaway` + fabro server + shim left running.
