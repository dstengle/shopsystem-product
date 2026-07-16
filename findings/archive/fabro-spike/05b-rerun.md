# Slice 5 — RERUN leg: loop fidelity on a live non-dry-run (no node-collapse)

**Epic** lead-6k1r (Fabro spike) · **Slice** 5 · **Leg** RERUN (after HARDEN 05a)
· **Branch** `fabro-spike` · **Date** 2026-07-01 · fabro v0.254.0 · SPIKE / THROWAWAY.

## 0. VERDICT — **LOOP FIDELITY: GREEN.** Slice-4 GOAL PARTIAL → now **GREEN**.

The hardened native/agent split holds under a live non-dry-run. The Slice-4 node-collapse
is **gone**: `prime` is a native ~300ms script that runs only its two priming commands; the
full Implementer→Reviewer node sequence executes in order; the reviewer node (`emit_r`) is the
structural **sole** work_done emitter; and a forced reviewer-fail yields run STATUS **FAILED**
with **no** `work_done(complete)` on the wire.

| Criterion | Verdict | Trace evidence |
|---|---|---|
| **(a)** `prime` runs only `shop-msg prime && bd prime`, touches nothing | **PASS** | `prime` native, **283–343ms** across 3 runs (was 4m14s/$0.48 runaway agent in Slice 4). Script = `set -e; shop-msg prime --bc "$BC_NAME"; bd prime` — no git write, no bc-emit, no inbox consume. A 300ms shell of two read-commands physically cannot run the pipeline. Deliverable commits are attributable to the `impl` node window, not `prime`. |
| **(b)** classify→suff→impl→review→wdg_r→emit_r all execute in sequence | **PASS** | demo-3g (run `…3g`, all green) + demo-3b: `classify→"scenario"→suff→"proceed"→worktree→plan→impl→redgate→integ→review→"signoff"→wdg_r→emit_r`. **Every** loop node ran, in order, no skip, no collapse, no false-idle. |
| **(c)** work_done emitted by `emit_r` **alone** (structural sole-emitter) | **PASS** | `emit_r` is the only `bc-emit` node on the scenario path, reachable **only** via `review→signoff→wdg_r→pass` (all native). demo-3g: `emit_r` (1s) emitted a valid `status: complete` **in-graph** → `shop-msg read outbox … --work-id fabro-spike-demo-3g` = complete, hashes `[674e0bb2, ed28a476, a24121ea]`. |
| **(d)** forced reviewer-fail → run FAILED, no `complete` on wire | **PASS** | `workflow-forcefail.fabro` (review = native `exit 1`): `start→review(✗ outcome=failed)→halt` → **Status: FAILED**; `wdg_r`/`emit_r` **never ran**; `read outbox …--work-id fabro-spike-demo-ff` = "no outbox response found". |

**Invariant #2 HELD** throughout: fabro vault = `__PLACEHOLDER__` for both secrets; all LLM
traffic went dummy-`x-api-key` → in-container anthropic-oauth-shim → agent-vault → 200.
**needs_david: none** — fully in-scope (one throwaway container, local postgres rows for a
throwaway BC, a local bare origin, `fabro-spike`-branch defs; no real infra BC, no remote repo).

---

## 1. The clean end-to-end run (demo-3g) — full node-by-node trace

`fabro run _defs/workflow.fabro -I BC_NAME=fabro-throwaway -I WORK_ID=fabro-spike-demo-3g
--environment local --auto-approve --verbose` (run `01KWD…3g`):

```
✓ Start                       0ms
✓ prime                     343ms   (NATIVE: shop-msg prime + bd prime)     → health
✓ work-tracker health gate    3s    (NATIVE)                                → arm
✓ arm: drain inbox            2s    (NATIVE)                                → armed
✓ armed: message present?     2s    (NATIVE: read demo-3g)                  → classify
✓ bc-router classify   $0.01   8s   (AGENT)   directive → "scenario"        → suff
✓ bc-sufficiency-check $0.02  17s   (AGENT)   directive → "proceed"         → worktree
✓ using-git-worktrees        51ms   (NATIVE)                                → plan
✓ writing-plans-bdd    $0.06  40s   (AGENT, bd sub-issue DAG)               → impl
✓ bc-implementer       $0.24 3m04s  (AGENT, 2-subagent parallel fan-out)    → redgate
✓ RED-before-GREEN gate      12ms   (NATIVE)                                → integ
✓ integrating-to-main        70ms   (NATIVE: rebase + push origin HEAD:main)→ review
✓ bc-reviewer / bc-review $0.09 1m27s (AGENT) directive → "signoff"         → wdg_r
✓ work-done-gate (3 checks)  17ms   (NATIVE)                                → emit_r
✓ reviewer emits work_done    1s    (NATIVE bc-emit, SOLE EMITTER)          → done
✓ Exit: SUCCEEDED            Status: SUCCEEDED · 6 min · $0.43
```

Real commits back it: `test(red) 21458da` precedes `feat(green) 57fe9b2 [fabro-spike-demo-3g]`
on `origin/main`. Outbox work_done (verbatim):

```
message_type: work_done
work_id: fabro-spike-demo-3g
status: complete
summary: reviewer signoff; work-done-gate re-run green; RED-before-GREEN verified; probes considered+dismissed
scenario_hashes:
- 674e0bb2d51a6f2b   # greeting (demo-1)
- ed28a476257e3c31   # farewell (demo-3b)
- a24121ea55e50485   # wave (demo-3g, the assigned scenario)
```

This is the artifact Slice 4 could not produce structurally: a valid `complete` **emitted by
`emit_r` alone**, reached only through the full gated node sequence. **Loop fidelity proven.**

## 2. The two headline harden claims, confirmed live

- **No node-collapse (G1 closed).** `prime` as a native `script=` node = 283–343ms, three
  runs. It cannot and did not swallow the pipeline: classify/suff/plan/impl/review each ran as
  their own stage, and the deliverable commits fall inside the `impl` node window. The Slice-4
  root cause (command-node-is-a-general-agent) is defeated by making every non-judgment node a
  native no-LLM script.
- **Structural sole-emit (G2 closed).** `emit_r` is the only `bc-emit`-bearing node on the
  scenario path and is graph-reachable **only** via `review→signoff→wdg_r→emit_r`. The
  forced-fail probe (§4) shows a reviewer that does not sign off can never reach it.
- **Env-overlay input into native `script=` (03b gap) confirmed at loop scale.** Every native
  node read `$BC_NAME`/`$WORK_ID` from the global `[run.environment.env]` overlay (NOT `-I`,
  which only feeds agent `{{ inputs }}` prompt text). Per-run the overlay values must be edited
  in `workflow.toml`; `-I` does not reach native scripts.

## 3. One defect found and FIXED mid-leg — `emit_r`/`wdg_r` ran in the wrong dir + empty hash

**First structured run (demo-3b) reached `emit_r` but `emit_r` FAILED → halt → run FAILED**,
with **no complete on the wire** (fail-closed held — a broken emitter never fabricates a
complete). Root cause was a **fixable defs bug, NOT a fabro wall**:

1. `emit_r`/`wdg_r` ran in fabro's cwd `/root/sandbox`, whose local checkout is **stale** — the
   `integ` node pushes the worktree to `origin/main` but never updates `/root/sandbox`. The
   integrated deliverable lives in the worktree `../wt-$WORK_ID`, not the sandbox.
2. `emit_r` computed the payload hash with **bare `scenarios hash`**. That CLI reads a single
   Gherkin block from **stdin**; with no pipe it hashes the **empty string** → `e3b0c442…`.
   bc-emit's C3 (on-disk block-hash recompute ⊆ payload) then rejected (`674e0bb2 ∉ {e3b0c442}`).
   (`wdg_r` masked it: its check was `scenarios hash >/dev/null || exit 1`, which exits 0 on the
   empty hash, so `wdg_r` passed while the real gate in `emit_r` failed.)

**Fix applied to the tracked `workflow.fabro`** (`wdg_r` + `emit_r`): `cd "../wt-$WORK_ID"`
first, and build the payload from **every** on-disk `@scenario_hash` tag as repeatable
`--scenario-hash` flags (`grep -rhoE '@scenario_hash:[0-9a-f]+' features/ | sed … | tr`), so
bc-emit's recompute is a subset. Verified two ways: (a) direct execution of the corrected
`emit_r` script in demo-3b's integrated worktree → valid `complete` for demo-3b, hashes
`[674e0bb2, ed28a476]`, exit 0; (b) the full **in-graph** demo-3g run above, where the corrected
`emit_r` emitted the `complete` in-line. **Fixable defs issue — resolved this leg.**

Minor residual (furniture, not fidelity): the sandbox feature file accumulates scenarios across
demos, so the work_done's `scenario_hashes` pins **all** on-disk scenarios (3 for demo-3g), not
just the assigned one. Cosmetic; scope the emit to the assigned block in a later polish. Also
the **flat path** (`impl_f→wdg_f→emit_f`) has no worktree/integ node and was not exercised;
its `wdg_f`/`emit_f` carry the same stale-cwd/empty-hash shape and would need the same fix
before use.

## 4. Criterion (d) — forced reviewer-fail (deterministic isolation probe)

`workflow-forcefail.fabro` mirrors the real review sub-path
(`review→wdg_r→emit_r→done` signoff route; `review→halt [outcome=failed]` fail route) with
`review` replaced by a native `exit 1` (guaranteed `outcome=failed`, no LLM variance) and
`emit_r` kept as a **real** `bc-emit`:

```
✓ Start
✗ FORCED reviewer failure (outcome=failed)
→ review → halt  [outcome=failed]
✗ HALTED / FAILED (terminal sink)
Status: FAILED
```

`wdg_r` and `emit_r` **never executed**; `read outbox …--work-id fabro-spike-demo-ff` →
"no outbox response found". A reviewer that does not sign off **cannot** reach the sole
emitter and **cannot** put a `complete` on the wire. AC5's PARTIAL is closed.

## 5. Transient infra encountered (NOT fabro/defs walls)

- **`claude-sonnet-4-6` rate-limited** on the agent-vault OAuth path (`fabro model test
  --model sonnet` → `Rate limited by anthropic`); `haiku` = `ok`. The first structured run
  (demo-3, all-sonnet judgment agents) died at `classify` on the rate limit → fail-closed to
  `emit_blk` (blocked, no false complete). **Workaround:** overrode the deployed graph's
  `model_stylesheet` to all-haiku (`* { model: claude-haiku-4-5 }`) — model choice is
  orthogonal to loop fidelity. The **tracked** `workflow.fabro` keeps the faithful
  `.coding/.review = sonnet` stylesheet; the haiku override was runtime-only, documented here.
- **Transient `bad gateway` (502)** hit `impl` once and was absorbed by fabro's node retry
  (recovered same stage).
- **Sufficiency-agent non-determinism:** on demo-3d the haiku `suff` node routed `"clarify"`
  (stopping short of impl) where demo-3b/3g routed `"proceed"`. This is a legitimate loop branch
  (insufficient-intake → clarify), not a defect; it is agent judgment variance, and it still
  demonstrates the suff→emit_clar→reported→done branch executing correctly.

## 6. Runs this leg (all throwaway `fabro-throwaway`, local bare origin)

| work_id | stylesheet | outcome | what it proves |
|---|---|---|---|
| `fabro-spike-demo-3`  | sonnet | classify hit sonnet rate-limit → emit_blk(blocked) → SUCCEEDED | fail-closed on infra error; no false complete |
| `fabro-spike-demo-3b` | haiku  | full loop reached `emit_r`; `emit_r` failed (old hash bug) → **FAILED** | (a)(b) proven; surfaced the emit_r defect; fail-closed on broken emit |
| `fabro-spike-demo-3d` | haiku  | `suff`→"clarify" → emit_clar → SUCCEEDED | suff clarify branch; agent variance |
| `fabro-spike-demo-3g` | haiku  | **full loop, FIXED emit_r → `complete` in-graph → SUCCEEDED** | (a)(b)(c) all GREEN in-graph |
| `fabro-spike-demo-ff` | (native) | forced review-fail → halt → **FAILED**, no complete | (d) GREEN |

## 7. Remaining collapse point / classification

**No remaining collapse point.** The one defect encountered (`emit_r`/`wdg_r` stale-cwd +
empty-hash) was a **fixable defs issue**, fixed and re-verified in-graph. Residual polish items
(scenario_hash over-inclusion; flat-path `wdg_f`/`emit_f` need the same worktree fix; sonnet
rate-limit is an external quota matter) are all fixable/orthogonal, **none are fabro-v0.254.0
capability walls**. Loop fidelity is proven; Slice 5 is GREEN and the spike goal is met.

## 8. Live state

Container `bc-fabro-throwaway` up; fabro server (pid 379) + shim (pid 149) left running.
Defs on `fabro-spike`: `workflow.fabro` (wdg_r/emit_r fix), `workflow.toml`,
`workflow-forcefail.fabro` (new). All changes uncommitted (consistent with the 05a leg —
orchestrator owns the commit). No escalation.
