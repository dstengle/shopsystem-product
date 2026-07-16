# fabro-defs — Slice 2 Leg 2: shop-templates furniture ported into fabro node bodies

**Epic:** lead-6k1r (Fabro spike) · **Slice:** 2 · **Leg:** 2 · **Branch:** `fabro-spike`
· **Date:** 2026-07-01 · Spike/throwaway.

This directory holds the **per-node ports** of the 11 `shop-templates` furniture
pieces named in `../01b-target-loop-workdone.md` §5 (furniture-port table). Each
`nodes/<piece>.md` is the drop-in body — either an **inlined agent `prompt=`** or a
**precise command-node spec** — that makes the corresponding node in the 01b
`workflow.fabro` DOT graph real, with every GATE preserved literally.

The DOT graph shell itself (`workflow.fabro` + `workflow.toml`) is specified in
`../01b-target-loop-workdone.md` §2. This leg fills its nodes.

## Node-id → file → furniture map (01b §2 graph)

| 01b node id | file | kind (as authored here) | furniture source |
|---|---|---|---|
| `prime`,`health`,`arm`,`classify` | `nodes/bc-router.md` | `classify`=agent; `prime`/`health`/`arm`=command | `bc-router/SKILL.md` |
| `suff` | `nodes/bc-sufficiency-check.md` | agent | `bc-sufficiency-check/SKILL.md` |
| `plan` | `nodes/writing-plans-bdd.md` | agent | `writing-plans-bdd/SKILL.md` |
| `impl` + `redgate` | `nodes/subagent-driven-development.md` | `impl`=parallel agent; `redgate`=command | `subagent-driven-development/SKILL.md` |
| (inside `impl`) | `nodes/test-driven-development.md` | agent sub-prompt module | `test-driven-development/SKILL.md` |
| `worktree` | `nodes/using-git-worktrees.md` | command | `using-git-worktrees/SKILL.md` |
| `integ` | `nodes/integrating-to-main.md` | command | `integrating-to-main/SKILL.md` |
| `review` | `nodes/bc-review.md` | agent | `bc-review/SKILL.md` |
| `wdg_r`,`wdg_f` (+ `emit_blk` edge) | `nodes/work-done-gate.md` | command | `work-done-gate/SKILL.md` |
| `impl`,`impl_f` (bias) | `nodes/bc-implementer.md` | agent role shim (`class="coding"`) | `bc-implementer.md` |
| `review` (bias) | `nodes/bc-reviewer.md` | agent role shim (`class="review"`) | `bc-reviewer.md` |

## Empirical findings that shaped the ports (fabro v0.254.0, verified this leg)

1. **`command` is a native `StageHandler`** — the binary's OpenAPI schema pins the
   handler enum: `start, exit, agent, prompt, command, human, conditional,
   parallel, parallel.fan_in, stack.manager_loop, wait`.
2. **…but the DOT (`.fabro`) authoring surface in v0.254.0 does NOT expose the
   `command` handler.** A node authored as `shape=box, handler="command",
   command="…"` is still classified as an **LLM node** — `fabro run` preflight
   emits `warning … LLM node 'runit' has no prompt or label attribute
   (prompt_on_llm_nodes)`. `fabro validate` ignores unknown node attributes (a bare
   node with neither `prompt` nor `command` validates OK), so validate cannot
   confirm handler kind; the run-preflight classification is authoritative. Native
   `command`/`script` execution lives in the **`.toml` task-config** `execution`
   layer (schema layers `RunExecutionLayer` / `script` / `command` / `steps`), not
   as a DOT node.
3. **Decision (matches 01b §1 + §7 OQ1 fallback):** every command node in this graph
   is authored as a **tool-restricted agent node** — a plain agent node carrying a
   deterministic `prompt=` that says *run EXACTLY these commands, use no judgment,
   emit the outcome label from the exit status* — with `class="command"` (routed to
   the cheap `claude-haiku-4-5` tier via the graph `model_stylesheet`) and
   `permissions="read-write"`. The graph shape, outcome-conditional edges, and
   furniture mapping are **unchanged**; only the node-attribute spelling differs.
   Each command-node file gives BOTH the exact command sequence + outcome/exit
   handling AND this agent-node realization.
4. **`AgentPermissions` enum** = `read-only | read-write | full`. Command nodes and
   implementer/reviewer agents get `read-write`; pure-classifier `classify` gets
   `read-only`.
5. **Agents carry `skills_dir`** (schema: `AgentToolSourceSkill`, `skills_dir`
   CLI/agent arg). ALTERNATIVE authoring path (not taken here, noted per file): pour
   the original `shop-templates` skills into the fabro sandbox `skills_dir` and let
   each agent node activate them by name instead of inlining. This leg **inlines** so
   each node is self-contained and does not depend on skill-pouring parity.

## Standing translation rules (claude-TUI furniture → fabro model)

- **`Skill` tool invocation** ("invoke `<skill>` via the Skill tool") → the skill's
  gate-bearing prose is **inlined into the node `prompt=`** (or activated from
  `skills_dir`). No `Skill` tool exists in a fabro agent node.
- **`Task`/`Agent` subagent fan-out** ("dispatch bc-implementer subagents in
  parallel") → fabro **`parallel=true`** node fanning out to `parallel.fan_in`
  (fabro's native subagent primitive; the binary exposes Spawn/Wait/Send/Close
  subagent tools). See `nodes/subagent-driven-development.md`.
- **`Monitor` (postgres LISTEN/NOTIFY watcher)** → stays a **command node poll/drain**
  (`arm`), NOT a fabro primitive. Seam(b) is PARTIAL (01b §5 / 00b): fabro wraps the
  loop but cannot BE the event source.
- **`TodoWrite` forbidden / bd is the only tracker** → unchanged; carried verbatim
  into the ported prompts.

---

# Leg 1 addendum — the workflow shell (`workflow.fabro` + config + vault)

**Leg 1 (epic lead-6k1r, Slice 2)** authored the DOT graph shell and run config that
Leg 2's node bodies fill. All files validated against **fabro v0.254.0**.

## Files written (Leg 1)

| File | What it is |
|---|---|
| `workflow.fabro` | The DOT graph: 22 nodes / 39 edges realizing 01b §2. `fabro validate` → **OK** (0 diagnostics). |
| `workflow.toml` | Run/env config: `[environments.local] provider='local'`; `[run.pull_request] enabled=false`. Retry is NOT here (see below). |
| `project.toml` | `.fabro/project.toml` equivalent; also disables native PR creation. |
| `vaults/default/secrets.json` | Tier-2 vault scaffold — **only `__PLACEHOLDER__` dummies**. |
| `vaults/default/README.md` | Documents the agent-vault + `HTTPS_PROXY` bypass (real creds never in fabro). |

## Node → prompt-file convention (as authored in the graph)

Each agent node carries **`prompt_file="nodes/<furniture>.md"`** pointing at Leg 2's
furniture-named body, PLUS an inline `prompt=` runtime directive ("load and follow
nodes/<file>.md, then <one-line role>"). fabro has **no native prompt-file honoring**
(pinned below), so the inline `prompt=` is what actually runs; the ASSEMBLER inlines
each file body into `prompt=` for a self-contained graph. File names match Leg 2's
`Node-id → file → furniture` map above exactly:

`prime`/`health`/`arm`/`classify`→`bc-router.md` · `suff`→`bc-sufficiency-check.md` ·
`plan`→`writing-plans-bdd.md` · `impl`/`redgate`→`subagent-driven-development.md`
(+`test-driven-development.md`,`bc-implementer.md`) · `worktree`→`using-git-worktrees.md` ·
`integ`→`integrating-to-main.md` · `review`→`bc-review.md`(+`bc-reviewer.md`) ·
`wdg_r`/`emit_r`/`wdg_f`/`emit_f`→`work-done-gate.md` · `impl_f`→`bc-implementer.md`.
`emit_clar`/`emit_blk` are trivial inline `shop-msg respond` one-liners (no file).

## Leg 1 empirical findings (fabro v0.254.0, verified via `fabro validate` + binary)

1. **Command nodes are tool-restricted agent nodes** — CONFIRMS Leg 2 finding #2/#3.
   DOT `cmd=`/`command=` is not a native handler (`preflight.rs` warns *"LLM node
   '<id>' has no prompt or label attribute"*). So every command step is
   `class="command", deterministic=true, permissions="read-write"` with the concrete
   command written inline in `prompt=`. (`deterministic` is a genuine fabro node
   attribute, alongside `backend`, `timeout`, `goal_gate`, `selection`.)
2. **Exactly ONE Msquare terminal** — `terminal_node` rule: *"Pipeline must have
   exactly one terminal node."* `done` is the single Msquare (SUCCEEDED). `reported`
   and `halt` are `shape=box` **SINK** nodes (no outgoing edge) — validated as allowed
   alongside the single Msquare — giving the three distinct 01b ends.
3. **Retry is DOT-graph-native, NOT a toml key** — nodes carry `retry=N`; the graph
   carries `fallback_retry_target` (validated: a bad target yields the
   `retry_target_exists` warning). `retry=3` on `prime`, `2` on `health`/`integ`/all
   `emit_*`; graph `fallback_retry_target="halt"`. The 01b `[run.retry.nodes]` draft is
   superseded.
4. **Outcome routing = `label=` edges** (as 01b): no fallback edge required for
   `label=` edges. `condition=` is a *separate* expression mechanism that DOES require
   an unconditional fallback (`all_conditional_edges` rule) — not used here.
5. **`fabro validate` is permissive on node attrs** — unknown attrs (`prompt_file`,
   `parallel`, `class`) don't fail validation; handler classification is only
   authoritative at `fabro run` **preflight**. So validate = OK is necessary, not
   sufficient; a live `fabro run` preflight is the next gate (Slice 4).

## On-PATH CLIs the command nodes need (all PRESENT this host)

`bc-emit work-done` ✓ · `shop-msg` (prime/watch/pending/read/respond/send/bc-status) ✓
· `scenarios hash` ✓ (also verify/list/count/titles/tags) · `bd` ✓ · `git` ✓ ·
`agent-vault` ✓ · `shop-templates` ✓. (Inside a real BC sandbox these must be baked
into `bc-base`; `scenarios hash` absence is the ADR-022 gap — hard Slice-4 prereq.)

## Uncertainties — U1–U5 RESOLVED (Slice 3). See findings for detail.

U1–U4 were closed by the RUNTIME leg via live `fabro run`
(`findings/fabro-spike/03b-runtime-mechanics.md`); U5 by the SHIM leg
(`03c-shim-u5-close.md`). The graph/toml here were corrected accordingly
(`fabro validate` OK, 22 nodes / 44 edges).

- **U1 — sink-terminal run status. RESOLVED.** A NATIVE command node
  (`shape=parallelogram, script="…; exit 1"`) with **no outgoing edge** yields
  run=**FAILED** ("stage failed with no outgoing fail edge"). `halt` is now that
  sink. `reported` is a native `script exit 0` node → `done` (SUCCEEDED).
  Failures are caught with `condition="outcome=failed"` (an unlabeled failsafe or
  `goal_gate=true` do NOT reliably catch — proven). An agent running `exit 1`
  does NOT fail the run (that was the Leg-A quirk).
- **U2 — command-node execution surface. RESOLVED.** Native command execution is
  the DOT `script=` attribute on `shape=parallelogram` (no LLM; exit code =
  outcome). `script=` is literal (no templating / no input env), so
  BC_NAME/WORK_ID-bearing gates stay AGENT command nodes (templated `prompt=`).
- **U3 — run-input injection. RESOLVED.** `{{ inputs.NAME }}` in `prompt=`/`goal=`
  only, declared in `[run.inputs]`, overridden by `-I NAME=VALUE`. Shell-style
  `${NAME}` is NOT honored. Not available in `script=` or sandbox env.
- **U4 — `parallel=true` fan-in. RESOLVED.** `impl` is one stage (in-node subagent
  fan-out) converging to `redgate` via one edge — no `parallel.fan_in` needed.
  True graph-level fan-out would use `shape=component` + `shape=tripleoctagon`
  (handler `parallel.fan_in`, `join_policy`/`max_parallel`).
- **U5 — HTTPS_PROXY into a non-dry-run agent node's OWN calls. RESOLVED (PASS)**
  via the `anthropic-oauth-shim` (03c) — LLM + outbound tool call both succeed
  through agent-vault with only placeholders in fabro's vault.

**Remaining open risk (Slice 4):** the *agent no-directive hazard* — a
non-compliant agent that COMPLETES but emits no `{"preferred_next_label":…}`
directive slips to a labelled success edge and is NOT hard-fail-closed
(`condition="outcome=failed"` only catches genuine stage errors). Backstops: the
native gates + the `halt` sink. Clean fix needs native `script=` gates, blocked
by the input-into-command-sandbox gap. See 03b.
