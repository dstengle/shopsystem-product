# Slice 3 — RUNTIME leg: graph execution mechanics (AC2/AC4/AC6/AC7)

Epic lead-6k1r. Branch `fabro-spike`. fabro v0.254.0. Date 2026-07-01.
Runs after the SHIM leg (`03c-shim-u5-close.md`) established the LLM path.
Real (non-dry-run) LLM + command execution through agent-vault, authorized.

All verdicts are from live `fabro run` against the `anthropic-oauth-shim`
(shim pid 286891 on 127.0.0.1:8788; fabro server pid 287406 on 127.0.0.1:32276).
Isolated probes live in scratchpad; the fixes are applied to
`fabro-defs/workflow.fabro` + `fabro-defs/workflow.toml` (re-validated OK,
22 nodes / 44 edges).

---

## Per-AC verdicts

| AC | Unit | Verdict | How |
|----|------|---------|-----|
| AC2 | U2 command-node exec | **PASS** | Both node kinds execute; native `script=` is the deterministic one |
| AC6 | U3 input injection | **PASS** | `{{ inputs.NAME }}` + `[run.inputs]` + `-I` |
| AC4 | U1 fail-closed | **PASS** (resolved the quirk) | native exit-1 `halt` sink + `condition="outcome=failed"` |
| AC7 | U4 fan-in | **PASS** | single `impl` stage converges via one edge; no `parallel.fan_in` needed |

---

## AC6 / U3 — input injection (PASS)

fabro embeds **minijinja 2.19**. Placeholders resolve as `{{ inputs.NAME }}`
(namespaced) in **`prompt=` and graph `goal=` ONLY** — `label=` / `script=` are
literal text. Inputs are declared in `workflow.toml [run.inputs]` and overridden
by `fabro run -I NAME=VALUE`.

- PROVEN: a command node whose prompt was `echo SENTINEL_A=[{{ inputs.BC_NAME }}]
  SENTINEL_B=[{{ inputs.WORK_ID }}]`, run with `-I BC_NAME=shopsystem-messaging
  -I WORK_ID=lead-abc1`, printed `SENTINEL_A=[shopsystem-messaging]
  SENTINEL_B=[lead-abc1]`.
- The graph's old shell-style `${BC_NAME}` is **NOT honored** — minijinja leaves
  it literal, it reaches the shell, bash expands it to empty. (Un-namespaced
  `{{ BC_NAME }}` is an *undefined-variable* error at run; must be `inputs.`.)
- Dry-run of the full corrected graph rendered the goal as "for BC
  shopsystem-messaging / work lead-smoke1" — templating confirmed end-to-end.

**FIX applied:** `workflow.toml` now declares `[run.inputs] BC_NAME/WORK_ID`;
every `${BC_NAME}`/`${WORK_ID}` in `workflow.fabro` prompts became
`{{ inputs.BC_NAME }}`/`{{ inputs.WORK_ID }}`.

**Constraint discovered:** inputs are **not** available in `script=` and **not**
exposed as env vars in a native command sandbox (probe: `$BC_NAME` → empty).
Any node that must parameterize on BC_NAME/WORK_ID therefore MUST remain an
**agent** command node (templated `prompt=`), never a native `script=` node.

---

## AC2 / U2 — command-node execution (PASS)

Run-preflight does **not** reject command nodes. TWO deterministic-command
realities exist (the graph's original "no native command StageHandler" claim was
wrong — it had only tried `cmd=`/`command=` attrs, not the real ones):

1. **NATIVE command node** — `shape=parallelogram, script="<cmd>"`, handler
   `command`. **No LLM.** Exit 0 ⇒ outcome `succeeded`; nonzero ⇒ `failed`
   (the only two outcomes). PROVEN: `script="echo running-health-check; exit 0"`
   ran and produced outcome succeeded; `exit 1` produced failed. `language` may
   be `shell` (default) or `python`. `script=` is literal (no templating/env).
2. **AGENT command node** — `shape=box, class="command"` with a templated
   `prompt=`. Runs the command via the LLM shell tool. Its stage outcome is the
   AGENT's (it "succeeds" at reporting), **not** the shell exit code.

**Mechanism for the pattern:** the AC's "port ONE command node to the .toml
execution layer" is unnecessary — the execution layer is the DOT `script=`
attribute (`shape=parallelogram`), confirmed by direct run. Deterministic,
parameter-free gates/terminals use native `script=`; parameterized ones stay
agent nodes.

---

## AC4 / U1 — fail-closed at RUNTIME (PASS; the Leg-A quirk is resolved)

**Root cause of the Leg-A "single-Msquare graph SUCCEEDED despite a node
failing":** the old graph modelled command nodes as AGENT nodes whose prompt
said "run `exit 1`". An agent running `exit 1` in its shell tool **completes
successfully** (stage outcome `succeeded`) — it did its job of running the
command — so the run advanced to the SUCCEEDED terminal. Fail-closed was
structurally impossible with agent-emulated commands.

**Empirical ladder (native command nodes):**

| Probe | Wiring | Result |
|-------|--------|--------|
| `u1_fail` | health exit1; `health -> done [label="failed"]` | **SUCCEEDED** — `label=` did NOT route the failure; dead-ended to Msquare |
| `u1_clean` | health exit1; `-> done` (uncond) + `-> halt [condition="outcome=failed"]`; halt = `script exit1` sink | **FAILED** — "stage halt failed with no outgoing fail edge" |
| `u1_ggclean` | health exit1 `goal_gate=true` → clean-exit terminal | **SUCCEEDED** — `goal_gate` did NOT force failure |
| `failsafe` | cmd exit1; `-> done [label="ok"]` + `-> halt` (UNLABELED) | **SUCCEEDED** — labelled edge won the fallback; unlabeled failsafe did NOT catch |

**Terminal-status resolution (the correct config):**

- `halt` = **native command SINK**: `shape=parallelogram, script="…; exit 1"`,
  **no outgoing edge**. Any failure routed here ⇒ run **FAILED** ("stage failed
  with no outgoing fail edge"). No work_done is emitted because the emit nodes
  are never reached on the halt path.
- The **only PROVEN-safe catch** is on a native command node:
  `node -> success (UNCONDITIONAL)` + `node -> fail [condition="outcome=failed"]`.
- `goal_gate=true` is **not** a reliable fail-closed primitive (it did not fail
  the run when the node routed onward to a clean terminal).
- `reported` = native `script exit 0` node → `done` (a clarify/blocked report is
  a correct non-failure end ⇒ SUCCEEDED).

**FIX applied:** `halt`/`reported` are now native command nodes; `halt` is a
sink; every fallible node routes its failure via `condition="outcome=failed"` to
`halt` (infra/emit) or `emit_blk` (deliverable). `done` stays the single Msquare.

### ROUTING — the load-bearing sub-finding

The transitions cascade is: (1) `condition=` edges; (2) an agent's
`{"preferred_next_label":"<L>"}` directive matched against edge `label=`;
(3) `suggested_next_ids`; (4) unconditional fallback (a **labelled** edge is
eligible and is preferred over an unlabeled one). Therefore:

- **`label=` alone does NOT route** — the agent prompt must emit the directive.
  PROVEN: `classify` emitting `{"preferred_next_label":"flat"}` routed to the
  `label="flat"` edge → command node → SUCCEEDED (`routeprobe`).
- **Agent no-directive HAZARD (open risk).** An agent that COMPLETES
  (outcome=succeeded) but emits no directive slips to a labelled success edge —
  proven in `nodirective` (took `label="ok"` → SUCCEEDED even with both a
  `condition="outcome=failed"` edge and an unlabeled failsafe present). So a
  non-compliant agent is **not** hard-fail-closed. Structural backstops: the
  native gates + the `halt` sink. **This is the #1 Slice-4 correctness item.**
  The clean resolution is to make the gates that MUST be fail-closed into native
  `script=` command nodes — blocked today by the templating/env constraint
  (they need WORK_ID). Options for Slice 4: (i) fabro exposing inputs as sandbox
  env; (ii) an agent writes WORK_ID to a context file a native gate reads;
  (iii) `context_updates` in the directive + `condition="context.X=…"` edges.

---

## AC7 / U4 — fan-in (PASS)

fabro's genuine graph-level parallelism (confirmed in the binary + dot-language
ref) is **`shape=component`** fan-out → branch nodes → **`shape=tripleoctagon`**
join (handler `parallel.fan_in`, with `join_policy=wait_all|first_success`,
`max_parallel`). Real tokens present: `parallel.fan_in`, `join_policy`,
`max_parallel`, `wait_all`, `first_success`, `parallel_group`.

`impl` is **not** that: it is a **single stage** carrying `parallel=true` (an
accepted node attribute — appears as `parallel:{Boolean:true}` in `run.created`)
that fans out to bc-implementer subagents **internally**. It emits one outcome
and converges to `redgate` via **one edge**. So **no explicit `parallel.fan_in`
join is required** for this in-node model. (A `parallel=true` single-node run
executed as one stage — `✓ impl … 1s` — then routed on its single outcome.)

**FIX applied:** `impl -> redgate` is the single-branch proven pattern
(unconditional success + `condition="outcome=failed"` → `emit_blk`). Documented
that TRUE multi-branch parallel fan-out would need component+tripleoctagon.

---

## Files edited (Slice-4-ready)

- `fabro-defs/workflow.toml` — added `[run.inputs] BC_NAME/WORK_ID` (+ the
  templating/native-sandbox constraint note).
- `fabro-defs/workflow.fabro` — full runtime correction:
  - templating `${…}` → `{{ inputs.… }}` (goal + all prompts);
  - `halt` → native `script exit 1` SINK; `reported` → native `script exit 0`
    → `done`; `done` unchanged (single Msquare);
  - every fallible node re-wired to the PROVEN-safe pattern (uncond success +
    `condition="outcome=failed"` catch; multi-branch = directive labels +
    failure catch);
  - each agent/command prompt instructs emitting the
    `{"preferred_next_label":"…"}` routing directive;
  - header rewritten to pin all four mechanics + the routing cascade + the
    agent no-directive hazard.
  - `fabro validate workflow.fabro` → **OK** (22 nodes, 44 edges).

Artifacts left uncommitted (matching the shim leg's subagent scope). Shim (pid
286891) and fabro server (pid 287406) left running for follow-on work.

---

## Deferred to Slice 4 (need real BC container + mailbox)

- **AC5 — gated `work_done` emit.** Requires the real `bc-emit` wrapper +
  messaging DB (UNIQUE(work_id,direction,shop) collision path, pydantic
  WorkDone, gate re-run). The graph wires `emit_r`/`emit_f` and the collision→
  `halt` failsafe, but the emit itself needs the BC.
- **AC8 — reactive seam.** `shop-msg watch` LISTEN/NOTIFY + inbox drain need the
  live mailbox; the `arm` node models the poll, but Seam(b) stays PARTIAL until
  a BC container drives it.
- Full end-to-end real run of `workflow.fabro` is a Slice-4 activity — running it
  on the lead host is unsafe (real `bd dolt push` / `git worktree` / `bc-emit`
  side effects past `prime`/`health`); Leg B validated each mechanic in isolation
  + via dry-run traversal instead.

## Blockers / open risks

- **Agent no-directive hazard** (above) — the one correctness gap; a
  non-compliant agent is not hard-fail-closed. Recommended Slice-4 fix: native
  `script=` gates, which needs the input-injection-into-command-sandbox gap
  closed. No hard blocker for proceeding to Slice 4.
