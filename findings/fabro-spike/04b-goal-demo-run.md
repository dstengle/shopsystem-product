# Slice 4 — DEMO leg: fabro-orchestrated throwaway BC consumes assign_scenarios, emits work_done

**Epic** lead-6k1r (Fabro spike) · **Slice** 4 · **Leg** DEMO/GOAL · **Branch** `fabro-spike`
· **Date** 2026-07-01 · fabro v0.254.0 · SPIKE / THROWAWAY.

## Bottom line

**GOAL: GREEN on the artifact, but via NODE-COLLAPSE, not the structured loop.** A
fabro-orchestrated run consumed the seeded `assign_scenarios` end-to-end and a **valid,
`status: complete` work_done landed in the outbox** (correct WorkDone shape, correct
block-only `scenario_hash`, substantive summary), visible via
`shop-msg read outbox --bc fabro-throwaway --work-id fabro-spike-demo-1`. **However**, the
work_done was produced by the `prime` node's **runaway agent**, which — being a general
read-write agent carrying the graph goal — executed the *entire* Implementer→Reviewer
pipeline (read message, RED test, GREEN impl, test-first commits, push to origin/main,
`bc-emit work-done`) **inside node index=1**, consumed the inbox, and only then emitted its
routing directive. The graph's own downstream nodes (`arm`/`classify`/`suff`/`impl`/
`review`/`wdg_r`/`emit_r`) therefore **never ran**: `arm` drained an already-empty inbox
and idled to a **FALSE `Exit: SUCCEEDED`**. So the *loop artifact* was produced under
fabro orchestration, but the graph's **structural guarantees were bypassed**.

- **AC5 (gated-emit): PARTIAL.** The emit mechanics are all CONFIRMED — the `bc-emit`
  gate re-ran (C1/C2/C3 passed), exactly ONE work_done exists, and a second emit for the
  same `work_id` is **refused** (`refusing to overwrite existing work_done ... use --force`,
  exit 1 → in-graph routes `emit_r → halt` via `condition="outcome=failed"`, no second
  emit). But the **"reviewer is the SOLE emitter" structural guarantee was NOT exercised**:
  `emit_r` never ran; the emit came from the `prime`-collapsed agent. The graph does not
  *enforce* sole-emit — any node with `bc-emit` on PATH + read-write can emit.
- **AC8 (reactive-seam): GREEN on mechanism, with caveats.** Both the poll/drain
  (`shop-msg pending inbox` → `read inbox`) and the reactive LISTEN/NOTIFY watcher
  (`shop-msg watch --bc`) were shown to observe a freshly-seeded arrival. Caveats: (1)
  Seam(b) is PARTIAL — `shop-msg watch` is **not a fabro node primitive**; the `arm` node
  is a poll/drain. (2) In the live run `arm` observed **empty** because `prime` had already
  consumed the message — the seam is **not robust to upstream over-consumption**.
- **No-directive hazard:** the routing directives themselves WORKED (prime→health→arm→done
  all routed correctly). The hazard that actually bit is a **worse, distinct variant —
  agent SCOPE OVERRUN / node-collapse** (see §4). This is the headline finding of the leg.
- **Invariant #2 HELD:** the whole run's real LLM traffic went through the
  anthropic-oauth-shim (`POST /v1/messages → 200`) with fabro's vault = `__PLACEHOLDER__`.
- **needs_david: none.** Entirely in-scope: local docker throwaway container, local
  postgres rows for a throwaway BC, a local bare git origin, `fabro-spike`-branch defs. No
  real infra BC touched, no remote repo, no message seeded to a real BC.

---

## 1. LEAD dispatch — the seeded assign_scenarios (AC8 input)

As the lead shop, seeded a MINIMAL single trivial scenario into the throwaway BC's inbox:

```
shop-msg send assign_scenarios \
  --bc fabro-throwaway \
  --work-id fabro-spike-demo-1 \
  --feature-title "Fabro throwaway demo" \
  --bc-tag fabro-throwaway \
  --scenario-file demo-scenario.feature
```
where `demo-scenario.feature` is the single scenario body:
```
Scenario: fabro throwaway demo trivial greeting
  Given the fabro-orchestrated throwaway BC is running
  When the demo greeting behavior is exercised
  Then it returns the fixed string "hello-fabro"
```
Landed as `fabro-spike-demo-1 assign_scenarios`, scenarios `hash: 674e0bb2d51a6f2b`
(the canonical **block-only** hash — `Scenario:`→EOF; verified reproducible in-container
via `printf '<block>' | scenarios hash` → `674e0bb2d51a6f2b`). `shop-msg read`/`pending`
are non-destructive (confirmed: repeated host reads left it pending).

## 2. Sandbox substrate (so the loop's git/gate nodes have real ground)

Built inside the container at `/root/sandbox` (fabro `provider=local` runs in-place at
cwd, "Sandbox: local (ready in 0ms)"):
- `git init` + a **local bare origin** at `/root/origin.git` with a `main` branch (keeps
  the `integ` node's origin/main landing fully local + in-scope; no remote).
- `features/demo.feature` carrying the exact scenario block + `@scenario_hash:674e0bb2d51a6f2b`.
- `bd init` (embedded dolt, no server). **Health substrate is satisfiable:** `bd ready`
  → exit 0; `bd dolt push` → exit 0 (solo mode: "no remote configured — skipping ...
  pushing is optional"). So `prime`+`health` can pass.
- `_defs/` = the `fabro-defs` copied in (gitignored) so the workflow config resolves while
  cwd stays on the sandbox. `fabro run ... --dry-run` from this cwd preflights clean.

**`bc-emit`'s ENFORCED gate is Checks 1–3** (read from
`shop_templates/bc_emit.py`): C1 clean tree (whole-tree minus carve-outs `.specstory`,
`.claude/scheduled_tasks.lock`, `.beads/issues.jsonl`), C2 `work_id` reachable from
`origin/main` as a whole token (after `git fetch`), C3 scenario-hash recompute
(block-only, in-process `scenarios.hash.compute_scenario_hash`) ⊆ payload. Checks 4/5
(bd sub-issues, genuine-red execution) are furniture prose, **not** run by the wrapper —
so `behave` being absent in `bc-base` did **not** block a green emit (env gap, did not
bite).

## 3. The live run — `fabro run` non-dry-run

`fabro run _defs/workflow.fabro -I BC_NAME=fabro-throwaway -I WORK_ID=fabro-spike-demo-1
--environment local --auto-approve --verbose` (run `01KWDTN9F1J0MASAPDCE3TAAN8`).
Real LLM + real tools throughout — server.log shows `claude-haiku-4-5` completions and
`shell`/`bash`/`read_file` tool calls, every LLM hop `200` via the shim.

Node-by-node (fabro's own summary lines):
```
✓ prime                     $0.48   4m14s  (83 turns, 84 tools, 44.9k toks)   → health (unconditional)
✓ work-tracker health gate  $0.05   34s    (15 turns, 15 tools, 10.7k toks)   → arm
✓ arm watch + drain inbox   $0.01   3s     ( 2 turns,  1 tools,  987 toks)    → done  "empty"
✓ Exit: SUCCEEDED   ·   Run total: 5 min, $0.54, 2.4m toks
```
arm's final output: *"The inbox is empty. Since no pending message exists, I'll route to
idle state."* → `{"preferred_next_label":"empty"}`.

## 4. HEADLINE FINDING — command-as-agent node SCOPE OVERRUN / node-collapse

The `prime` node is authored as a *tool-restricted agent* told to *"Run EXACTLY, no
judgment: `shop-msg prime --bc <bc> && bd prime`"* (v0.254.0 DOT has no native templated
command handler, so every parameterized "command" node is a **general agent** with
`permissions="read-write"` and the graph `goal` in context). Under `claude-haiku-4-5`
this node **did not stay in its lane**. In its single stage (index=1, window
03:13:16–03:17:30Z, 83 turns) it:
1. consumed the pending `assign_scenarios` (a `shop-msg consume`/`watch`-class action —
   `shop-msg prime`/`read` alone are non-destructive, verified),
2. authored `test(red)` (commit `8eec830`, 03:14:50Z) and `feat(green) [fabro-spike-demo-1]`
   (commit `a2abb16`, 03:16:02Z) + a gitignore chore, **pushed all to `origin/main`**,
3. ran `bc-emit work-done` → deposited the **`status: complete` work_done** to the outbox,
4. *then* emitted its succeeded directive → routed `prime → health` (unconditional).

All deliverable commits fall INSIDE prime's window — attribution is unambiguous. The
consequence: the graph's decomposition was rendered moot. `health` (34s) re-probed a
healthy tracker; `arm` (3s) drained an **already-empty** inbox and idled to a **false
`SUCCEEDED`** — a run that looks green but whose graph never executed
`classify/suff/worktree/plan/impl/redgate/integ/review/wdg_r/emit_r`.

**Why this matters (fabro-integration gap, not environment):** in fabro v0.254.0 a
node's decomposition is *advisory* when the node is a general agent carrying the global
goal + broad tools. There is no structural enclosure keeping a "command" node to its
command, nor keeping the reviewer the sole emitter. This is a strictly WORSE variant of
the Slice-3 "agent no-directive hazard": there the risk was *slipping a gate*; here the
node **swallows the entire pipeline and shared state**. Directive routing worked fine —
scope did not. Clean fixes require native `script=`-gated command nodes (blocked by the
input-into-command-sandbox gap, 03b) and/or per-node tool/permission scoping and a
prompt-enclosure that hard-stops the agent after its two commands.

Secondary observation: even setting scope aside, the command-as-agent nodes are
**expensive/slow** under haiku — `prime` burned 83 turns / 4m14s / $0.48 for two
commands. `retry=3` authored on `prime` showed as `max_attempts=1` in the stage event
(retry attribute may not be wired at the stage layer in v0.254.0; low-priority).

## 5. AC5 — gated-emit, probed live

**The produced work_done (GOAL artifact), verbatim from the outbox:**
```
message_type: work_done
work_id: fabro-spike-demo-1
status: complete
summary: 'BDD scenario passes. Faithful realization via straightforward implementation.
  Step definitions sound (no regexes, no state leakage). Test-first artifacts verified:
  test(red) 8eec830 precedes feat(green) a2abb16. All 5 work-done-gate checks pass: clean
  tree, work_id reachable from main, scenario hash found in features/, plan sub-issues
  closed with RED marker, test-first sequence verified.'
scenario_hashes:
- 674e0bb2d51a6f2b
```
Valid WorkDone shape: `work_id`, `status`, `summary` (substantive), `scenario_hashes` a
subset of `features/`. **Gate ran** (the summary's claims are backed by real commits).

**UNIQUE-collision backstop (probed):** re-running the exact `emit_r` furniture command
```
bc-emit work-done --bc fabro-throwaway --work-id fabro-spike-demo-1 \
  --scenario-hash 674e0bb2d51a6f2b --summary "second emit attempt — collision probe" \
  --status complete
```
→ `shop-msg respond work_done: refusing to overwrite existing work_done response for
work_id='fabro-spike-demo-1' (use --force to replace)`, **exit 1**. The wrapper's C1/C2/C3
gate PASSED on the re-run (it reached the respond layer); the **UNIQUE(work_id,direction,
shop)** constraint (ADR-012) is what refused. Outbox still holds **exactly one** demo-1
work_done. In-graph a nonzero `emit_r` → `halt [condition="outcome=failed"]` → run FAILED,
never a silent second success. **CONFIRMED.**

**What AC5 did NOT get to demonstrate structurally:** `emit_r` as the *sole* emitter,
reached only via `review → signoff → wdg_r → pass`. Because `prime` collapsed the loop,
`review`/`wdg_r`/`emit_r` never executed; the emit came from the runaway node. The
sole-emitter property is therefore **unproven at the graph level and, per §4, not
enforced by fabro**.

## 6. AC8 — reactive seam, probed live (fresh `fabro-spike-demo-2`)

Re-seeded `fabro-spike-demo-2` (identical trivial scenario) and exercised both seam forms:
- **Drain (the `arm` node's mechanism):** `shop-msg pending inbox --bc fabro-throwaway`
  → `fabro-spike-demo-2 assign_scenarios` (non-empty ⇒ arm emits
  `{"preferred_next_label":"message"}` → `classify`); `shop-msg read inbox --work-id
  fabro-spike-demo-2` returns the message for classify. **Observed.**
- **Reactive LISTEN/NOTIFY (`shop-msg watch`):** `timeout 6 shop-msg watch --bc
  fabro-throwaway` printed `fabro-spike-demo-2 assign_scenarios` then `READY` (drained the
  arrival, then LISTENing) before the bounded timeout. The reactive watcher **observes the
  seeded arrival** and emits the `<work_id> <message_type>` line. **Observed.**

Caveats restated: `shop-msg watch` is not a fabro node primitive (Seam(b) PARTIAL — `arm`
is a poll/drain), and the live run proved the drain is not robust to an upstream node
consuming the message first.

## 7. Verdicts + classification

| Item | Verdict | Note |
|---|---|---|
| GOAL (valid work_done from a fabro run consuming assign_scenarios) | **GREEN (artifact)** | valid `complete` work_done in outbox; but produced by prime-collapse, NOT the structured node loop |
| Loop-fidelity (Implementer→Reviewer node sequence actually runs) | **RED** | graph collapsed into `prime`; 9 downstream nodes never ran; false-SUCCEEDED idle |
| AC5 gated-emit | **PARTIAL** | gate re-ran + single emit + UNIQUE-collision→fail-closed all CONFIRMED; reviewer-sole-emitter NOT exercised / not enforced |
| AC8 reactive-seam | **GREEN (mechanism)** | drain + `shop-msg watch` both observe arrival; Seam(b) PARTIAL; not robust to upstream consume |
| No-directive hazard | **directives OK; SCOPE hazard REALIZED** | §4 node-collapse is the deepest finding |
| Invariant #2 (vault placeholder) | **HELD** | all LLM via shim, vault `__PLACEHOLDER__` |
| needs_david | **none** | fully in-scope |

**fabro-integration gaps** (the spike's real signal): (a) command-as-agent nodes are not
scope-bounded → node-collapse / swallowed pipeline + destructive shared-state side effects;
(b) the graph does not enforce reviewer-sole-emit; (c) the drain seam is not robust to
upstream consumption; (d) reactive LISTEN/NOTIFY is not a fabro primitive; (e) minor:
`retry=N` not observed at the stage layer. **Environment gaps that did NOT bite:** `behave`
absent (the enforced gate is C1–C3, and the agent used python tests). All are addressable
by native `script=` command nodes + per-node tool/permission scoping — the same
`input-into-command-sandbox` blocker noted in 03b gates the clean fix.

## 8. Live state / cleanup

Run complete (not left running). Throwaway container `bc-fabro-throwaway`, its local
postgres rows (`fabro-spike-demo-1` inbox consumed + one outbox work_done; `demo-2`
consumed by the AC8 `watch` probe), the local bare origin, and the sandbox repo are all
local + throwaway. Server + shim left up in-container for any follow-up. Nothing to
escalate.
