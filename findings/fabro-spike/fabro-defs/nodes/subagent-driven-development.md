# node port: `subagent-driven-development` → `impl` (parallel agent) + `redgate` (command)

**Source:** `subagent-driven-development/SKILL.md` · **Realizes 01b nodes:** `impl`
(`class="coding"`, `parallel=true`, `permissions="read-write"`) and the `redgate`
inter-layer command node. Outcome edges: `impl -> redgate [label="ok"]` /
`impl -> emit_blk [label="failed"]`; `redgate -> integ [label="pass"]` /
`redgate -> emit_blk [label="fail"]`.

**Translation note (the load-bearing one):** the SKILL's "dispatch ALL ready sub-issues
in parallel to bc-implementer subagents via Task/Agent" maps to fabro's **native
subagent fan-out** — a `parallel=true` node whose branches converge at `parallel.fan_in`
(the binary exposes Spawn/Wait/Send/Close subagent tools + `max_turns`). The
**inter-layer gate** ("verify each closed AND `test(red)` precedes `feat(green)` before
unblocking the next layer") is extracted to its OWN deterministic command node
(`redgate`) so a failed gate CANNOT silently fall through to `integ` — this is the
outcome-conditional-edge discipline (01b §4). GATE preserved: the implementer executing
this loop NEVER emits work_done for scenario work.

---

## `impl` — parallel agent node (the router dispatch loop)

```
parallel=true
prompt="You are the bc-implementer fan-out for BC <name>, work_id <work_id>. Execute the
bd DAG (built by the plan node) one dependency LAYER at a time until drained.

LOOP:
  1. DISCOVER: `bd ready` -> all sub-issues with no open blockers. First iteration = all
     RED ('write the failing test for <behavior>') sub-issues with no cross-behavior dep.
  2. DISPATCH IN PARALLEL: spawn ONE bc-implementer subagent per ready sub-issue,
     SIMULTANEOUSLY. Independent sub-issues run concurrently — do NOT serialize work the
     DAG says can proceed in parallel. Each subagent receives: the work_id, its ONE
     sub-issue id, and the BC root path. Each runs the test-driven-development inner loop
     (RED->GREEN->REFACTOR) for its single behavior. CONTEXT ISOLATION: each subagent
     reads only its sub-issue's minimal file set; do not load the full codebase
     speculatively.
  3. WAIT for all dispatched subagents to complete.
  4. GATE BETWEEN LAYERS (emit outcome 'failed' if it does not hold — do NOT advance):
       - every dispatched sub-issue is CLOSED (`bd show <sub_id>` status closed), and
       - RED sub-issue: a `test(red): <behavior>` commit exists in the work-branch
         history; GREEN sub-issue: a `feat(green): <behavior>` commit FOLLOWS the
         corresponding `test(red)` commit (`git log --oneline bc/<work_id>`).
       If any `test(red)` does not precede its `feat(green)`, the gate FAILS.
  5. REPEAT from 1. When `bd ready` returns empty (all sub-issues closed), the DAG is
     drained.

OUTER LOOP CHECK before finishing: run the assigned Gherkin scenario(s) explicitly
(`pytest features/ --tags='@scenario_hash:<hash>'` or the BC's runner). If any assigned
scenario FAILS: reopen the relevant sub-issue, return to the inner loop, do NOT finish.

YOU NEVER EMIT work_done FOR SCENARIO WORK — that is the reviewer's gate, and the
reviewer's ALONE. For assign_scenarios and request_bugfix with non-empty scenarios your
job ENDS at: all sub-issues closed, outer Gherkin scenario(s) pass, working tree clean,
hand off (the graph routes -> redgate -> integ -> review). If implementation reveals a
behavior not captured in the decomposition, `bd create '<behavior>' --parent <work_id>`
rather than silently expanding an existing sub-issue.

Outcome 'ok' = DAG drained, outer loop passes, tree clean. Outcome 'failed' = an
inter-layer gate failed, a subagent could not complete, or the outer loop will not pass."
```

## `redgate` — command node (inter-layer / RED-before-GREEN structural assertion)

- **cmd:** for each behavior under `<work_id>`: verify the sub-issue is **closed** AND
  the `test(red): <behavior>` commit was **committed and watched-fail** and **precedes**
  its `feat(green): <behavior>` in the work-branch history (`git log --oneline
  bc/<work_id>`).
- **outcome edges:** `-> integ [label="pass"]` · `-> emit_blk [label="fail"]` (RED not
  before GREEN → BLOCK; MUST NOT proceed to integrate).
- **agent-node realization:** `class="command"`, `permissions="read-write"`, prompt that
  runs the `git log` / `bd show` checks and emits `pass`/`fail` from the observed
  commit order — no judgment, no latitude.
- **Note:** this is the emit-time-cheap structural precursor to `work-done-gate` Check 5
  (which additionally re-runs the red commit's newly-added tests to reject a *tautological*
  red). `redgate` asserts ORDER; Check 5 asserts GENUINE red.
