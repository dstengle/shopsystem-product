# Slice 5 — HARDEN leg: structural no-node-collapse enforcement

Epic lead-6k1r. Branch `fabro-spike`. fabro v0.254.0. Date 2026-07-01.
Reworks `fabro-defs/` so the bc-shop loop **cannot collapse into one node**
(the Slice-4 PARTIAL failure mode, findings 04-goal-demo.md). Real LLM + native
command execution against the live host fabro server (127.0.0.1:32276) + shim
(127.0.0.1:8788), authorized. Isolated probes in scratchpad; the fixes are
applied to `fabro-defs/workflow.fabro` + `workflow.toml` (re-validated OK).

---

## Headline result

The Slice-4 collapse root cause (G1) was that a fabro command node is a **general
LLM agent** whose scope/decomposition/sole-emit are ADVISORY. The `prime` agent
carried the graph goal and ran the whole pipeline in one stage. **Fix applied:
every NON-JUDGMENT node is now a NATIVE `script=` deterministic step (`shape=
parallelogram`, no LLM), and only 6 genuine judgment steps remain agents.** A
native node has no LLM agency — it physically cannot consume the inbox, write
code out of lane, push, or run bc-emit unless its literal script says so. Every
state-changing action in the loop (inbox drain, integrate, work-done gate,
bc-emit) is now native, so no agent can perform one.

`fabro validate workflow.fabro` → **OK (23 nodes, 45 edges)** (was 22/44; +1 node
`armed` + its edge, from the `arm` split forced by the native-routing constraint).

---

## Node classification after HARDEN

### NATIVE `script=` — 15 nodes (no LLM, exit 0=succeeded / nonzero=failed)

| node | script does | reads env |
|---|---|---|
| `prime` | `shop-msg prime --bc $BC_NAME && bd prime` | BC_NAME |
| `health` | `bd ready` reachable AND `shop-msg pending inbox` reachable (non-mutating) | BC_NAME |
| `arm` | drain: `shop-msg pending inbox --bc $BC_NAME` (proves DB reachable) | BC_NAME/WORK_ID |
| `armed` | message-present? `grep -c $WORK_ID` ≥1 → `shop-msg read` + exit 0; empty → exit 1 (idle) | BC_NAME/WORK_ID |
| `worktree` | `git worktree add ../wt-$WORK_ID -b work/$WORK_ID origin/main` | WORK_ID |
| `redgate` | RED-before-GREEN: `test(red)` commit index < `feat(green)` index in work branch | WORK_ID |
| `integ` | `git fetch; git rebase origin/main; git push HEAD:main` in the worktree | WORK_ID |
| `wdg_r` | 3 checks C1 clean tree / C2 `$WORK_ID` whole-token in origin/main / C3 `scenarios hash` | WORK_ID |
| `emit_r` | **SOLE work_done emitter**: `bc-emit work-done --bc $BC_NAME --work-id $WORK_ID --scenario-hash $(scenarios hash) --status complete` | BC_NAME/WORK_ID |
| `wdg_f` | same 3 checks (flat path) | WORK_ID |
| `emit_f` | `bc-emit work-done --status complete` (flat-path implementer emits) | BC_NAME/WORK_ID |
| `emit_clar` | `shop-msg respond clarify --bc $BC_NAME --work-id $WORK_ID` | BC_NAME/WORK_ID |
| `emit_blk` | `shop-msg respond work_done --status blocked` | BC_NAME/WORK_ID |
| `reported` | `exit 0` — correct non-failure reporting end → `done` | — |
| `halt` | `exit 1` SINK (no outgoing edge) → run FAILED | — |

Plus the two structural terminals `start` (Mdiamond) and `done` (Msquare) = 17
non-agent nodes.

### AGENT (judgment only) — 6 nodes

`classify`, `suff`, `plan`, `impl`, `impl_f`, `review`. Each may ONLY judge +
emit a `{"preferred_next_label":...}` routing directive (or write strictly within
its lane: `plan`→bd issues only, `impl`/`impl_f`→code in the worktree only). Each
prompt was **scope-stripped**: explicit "MUST NOT re-read/consume the inbox, MUST
NOT write code out of lane, MUST NOT push, MUST NOT integrate, MUST NOT run
bc-emit or shop-msg respond." `plan` stays an agent (BDD decomposition into a
RED+GREEN sub-issue DAG is genuine judgment — it cannot be deterministically
scripted); everything downstream of it that CHANGES state is native.

**Structural sole-emitter guarantee:** `emit_r` (the only bc-emit
status=complete on the scenario path) is native and reachable ONLY via
`review→signoff→wdg_r→pass`, where `wdg_r` is a native gate and the `bc-emit`
wrapper re-runs the gate again. So even a mis-signalling reviewer agent cannot
produce a false complete — two native gates stand between any agent and the
mailbox.

---

## Empirical tests (the three the task asked for)

### 1. Input-into-`script=` via the `[run.environment.env]` overlay → **WORKS (PASS)**

Slice 3 pinned that `[run.inputs]` / `{{ inputs.NAME }}` is invisible to `script=`
and to the native sandbox env. Slice 5 tested the DIFFERENT channel — the GLOBAL
`[run.environment.env]` overlay (the same one that delivers HTTPS_PROXY/CA to the
shim). **It reaches the native command sandbox as real shell env vars.**

- Probe `envprobe.fabro` (run `01KWDVPMCZA2M8N8J5MGRF6KCM`): a
  `shape=parallelogram` node with
  `script="echo PROBE_FOO=[$FOO_SPIKE] PROBE_BC=[$BC_NAME] PROBE_WID=[$WORK_ID]; test -n \"$FOO_SPIKE\" && exit 0 || exit 1"`,
  with `BC_NAME`/`WORK_ID`/`FOO_SPIKE` declared under `[run.environment.env]`,
  ran → **SUCCEEDED**, stage `output.log`:
  `PROBE_FOO=[BAR123] PROBE_BC=[shopsystem-example] PROBE_WID=[lead-envprobe1]`.

CONSEQUENCE: every WORK_ID/BC_NAME-parameterized gate/emit/integ node is now
NATIVE `script=` reading `$BC_NAME`/`$WORK_ID` from env. **No node needs to stay
an agent merely to interpolate a run input** — the fallback in task item 2 was
NOT needed. `workflow.toml` now declares `[run.environment.env] BC_NAME/WORK_ID`
alongside `[run.inputs]` (kept in sync; inputs still feed agent `prompt=` text).
Per-BC/per-work override = edit those two overlay values (`-I` overrides only
`[run.inputs]`, i.e. agent prompts, NOT `script=`).

### 2. Native-node multi-branch routing → **NOT possible (constraint, drove arm split)**

Probe `dirprobe.fabro`: a native node echoing `{"preferred_next_label":"message"}`
on stdout, with `label="message"` and `label="empty"` edges. The run **ignored
the directive and took the `empty` edge**. A native command node has EXACTLY two
outcomes (exit 0=succeeded, nonzero=failed) and cannot self-route among success
labels — the directive cascade honors directives only from AGENT nodes.

CONSEQUENCE: the old `arm` (3-way message/empty/error agent) was split into two
native nodes — `arm` (drain; shop-msg error → `halt`) then `armed`
(message-present → succeeded → `classify`; empty inbox → `failed` →
`done` idle). All deterministic 2-way forks use `uncond success + condition=
"outcome=failed"`.

### 3. `permissions="read-only"` enforcement → **NOT enforced (agent wrote to disk)**

Probe `perm1.fabro` (run `01KWDW25X8RDC41K8W589AR2JW`): an agent node with
`permissions="read-only"` instructed to run `printf hi > ro_write_marker.txt`.
Server log: `Tool call ... tool="shell" ... is_error=false`; the file
`ro_write_marker.txt` (2 bytes) **was created**. So fabro v0.254.0 does **NOT**
enforce `permissions="read-only"` against an agent's shell tool.

CONSEQUENCE: `permissions=` is declarative INTENT only — it is set on the agents
(read-only on `classify`/`suff`; read-write on `plan`/`impl`/`impl_f`/`review`)
for documentation and for the day fabro enforces it, but it is **NOT a load-bearing
lever**. The load-bearing lever is native `script=`: the actions we must prevent
agents from taking (emit, integrate, bypass a gate, consume the inbox) are simply
not reachable from any agent node because those nodes are native. (First attempt
at this probe was blocked by transient Anthropic **rate-limiting** on the sonnet
tier — inconclusive — and incidentally re-confirmed the *agent no-directive/
failure hazard*: a hard-failed agent stage with no `condition="outcome=failed"`
catch still advanced to the next node and the run ended SUCCEEDED. Every agent in
the hardened graph carries that catch.)

---

## Validate output

```
$ fabro validate workflow.fabro
Workflow: BcShopLoop (23 nodes, 45 edges)
Graph: workflow.fabro
Validation: OK
```

Edge pattern per the proven fail-closed rule: single-success native/agent node =
`-> success` (uncond) + `-> failsafe [condition="outcome=failed"]`; multi-branch
agent = labelled directive-routed branches + one `condition="outcome=failed"`
catch. `halt` = native exit-1 sink (FAILED); `reported` → `done` (SUCCEEDED).

---

## Residual gaps / notes

- **Dynamic evidence into native emit nodes.** `emit_r`/`emit_clar`/`emit_blk`
  use deterministic/static summaries (native `script=` cannot interpolate the
  reviewer's prose findings). `emit_r` recomputes the scenario-hash via
  `scenarios hash` (deterministic, ADR-019 block-only) — arguably more
  trustworthy than agent prose. Passing a reviewer's dynamic summary into a
  native emitter would need a fabro artifact/context channel (the static env
  overlay can't carry per-run node output); out of spike scope, and the WorkDone
  is still well-formed and gate-verified.
- **Agent no-directive hazard (unchanged residual).** For the 6 judgment agents,
  an agent that COMPLETES but emits no directive still slips to a labelled
  success edge; only genuine stage errors are caught by `condition="outcome=
  failed"`. This is now BACKSTOPPED structurally: the very next state-changing
  node after any agent is native (gate/emit/integ), which re-verifies and cannot
  be talked past. Collapse-into-one-node is eliminated regardless.
- **Not yet run end-to-end.** These are isolated-mechanic proofs on the host
  server (side-effect-free echoes + one file write). The full hardened graph must
  run INSIDE the throwaway container (bc-fabro-throwaway) against its seeded
  assign_scenarios — that is the Slice-5 GOAL re-demo leg, not this HARDEN leg.
- **Host settings.toml probe vars.** `BC_NAME`/`WORK_ID` were added to the host
  `~/.fabro/settings.toml [run.environment.env]` for the probes (benign,
  non-secret); the canonical per-workflow overlay lives in `fabro-defs/
  workflow.toml`. Credentials still ride agent-vault; fabro's vault stays
  `__PLACEHOLDER__` (invariant #2 intact).
- Artifacts left uncommitted (matching prior-leg subagent scope). Shim
  (pid 286891) + host fabro server (pid 287406) left running for the re-demo leg.
```
