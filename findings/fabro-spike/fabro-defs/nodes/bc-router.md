# node port: `bc-router` → `classify` (agent) + `prime`/`health`/`arm` (command)

**Source:** `bc-router/SKILL.md` · **Realizes 01b nodes:** `prime`, `health`, `arm`,
`classify`. The router SKILL is the graph's own spine; in fabro it decomposes into the
three session-start command nodes plus the one `classify` agent node.

**Translation notes:** the SKILL assumes a claude-TUI router that *invokes skills via
the Skill tool* and *dispatches subagents via Task/Agent*. In fabro that orchestration
IS the DOT graph — the router does not run as one agent. `classify` below is a pure
LLM-agent node that only reads + classifies; every downstream skill it names is its own
node/edge. Monitor (LISTEN/NOTIFY) does not survive as a fabro primitive — `arm` is a
command-node drain (Seam(b) PARTIAL).

---

## `classify` — agent node (`class="coding"`, `permissions="read-only"`)

```
prompt="You are the bc-router CLASSIFIER for BC <name>. You do NOT implement, do NOT
write files under src/ tests/ features/, do NOT run tests, and do NOT emit work_done —
for ANY message type. Your ONLY job: read one inbound message and emit its routing
outcome label.

INTAKE BOUNDARY (strict): all message discovery goes through shop-msg. Never inspect
filesystem paths, DB tables, or mailbox storage. Read the message already drained by the
`arm` node via:  shop-msg read inbox --bc <name> --work-id <work_id>.

CLASSIFICATION TABLE (apply exactly):
  | message_type          | scenarios?  | outcome label |
  | assign_scenarios      | yes (req'd) | scenario      |  (reviewer emits work_done)
  | request_bugfix        | non-empty   | scenario      |  (reviewer emits work_done)
  | request_bugfix        | empty       | flat          |  (implementer emits work_done)
  | request_maintenance   | n/a         | flat          |  (implementer emits work_done)

Emit outcome 'scenario' for the implementer->reviewer gated path; emit 'flat' for the
implementer-only path. The mechanism_observation channel is available on every path (any
role may surface one) but is NOT a routing outcome — never emit it as the classify
result.

You do NOT grant yourself exceptions to the sufficiency check (that is the `suff` node's
job on the scenario path, and the implementer's first step on the flat path). Output only
the single outcome label."
```
Outcome edges (01b §2): `classify -> suff [label="scenario"]`, `classify -> impl_f
[label="flat"]`.

---

## `prime` — command node  (SKILL step 1 "Orient")

- **cmd:** `shop-msg prime --bc <name> ; bd prime`
- **outcome edges:** `-> health [label="ok"]` · `-> halt [label="failed"]` (DSN
  unreachable at prime → HALT, no role work emitted).
- **agent-node realization:** `prompt="Run EXACTLY: shop-msg prime --bc <name> && bd
  prime. Use no judgment. If both exit 0 emit outcome 'ok'; if either exits non-zero emit
  outcome 'failed'. Do nothing else."` (`class="command"`, `permissions="read-write"`).

## `health` — command node — **SESSION-START WORK-TRACKER HEALTH GATE (preserved literally)**

This is the SKILL's "work-tracker health step" — it GATES the role loop; the role loop
does NOT begin until the tracker reports healthy. The tracker is **healthy** only when
`bd create` and `bd ready` exit 0 (local writability) AND a **test dolt push** to the
configured Dolt remote exits 0 (remote writability).

- **cmd (spine):** `bd create <probe> --prefix <issue_prefix> ; bd ready ; bd dolt push
  (TEST)` — then classify the result into one of:
  - **healthy** → `-> arm [label="healthy"]`.
  - **heal (unprovisioned-but-recoverable):** empty working set + no configured
    `issue_prefix`, BUT the committed registry names a definite `issue_prefix` and carries
    ≥1 issue → **adopt** the committed `issue_prefix` (taken from the committed registry,
    **NOT derived from the BC name**) and **import** the committed registry's issues
    preserving each **original id unchanged** (drop/overwrite nothing). Re-validate:
    after heal, `bd create` exits 0 and a test dolt push exits 0 → healthy → `-> arm`.
  - **block (unhealable):** empty working set + no `issue_prefix` + committed registry
    names no prefix to adopt → surface an explicit work-tracker health FAILURE naming the
    unhealable condition; **the BC does not begin its role loop and emits no role work** →
    `-> halt [label="unhealthy"]`.
  - **block (remote-unwritable):** locally writable but the test dolt push exits non-zero
    → report tracker **unhealthy** naming the failed test dolt push as the cause; **no
    role loop, no role work** → `-> halt [label="unhealthy"]`.
- **Why session-start, not emit-time:** failure is pulled forward so a wedged tracker
  never surfaces mid-work.
- **agent-node realization:** `class="command"`, `permissions="read-write"`, prompt that
  runs the probe commands, applies the heal-vs-block decision table above deterministically
  (no creative latitude), and emits `healthy` | `unhealthy`.

## `arm` — command node  (SKILL steps "Arm Monitor" + "Read")

- **cmd:** `shop-msg watch --bc <name>  (LISTEN/NOTIFY; PARTIAL — drain, not live block)
  ; shop-msg pending inbox --bc <name> ; shop-msg read inbox --bc <name> --work-id <id>`
- **outcome edges:** `-> classify [label="message"]` (a pending message exists) · `->
  done [label="empty"]` (nothing pending — legitimate idle-empty SUCCEEDED).
- **Translation note:** the claude Monitor's live LISTEN/NOTIFY block-and-wait does NOT
  survive as a fabro node primitive; `arm` models a **drain** of `shop-msg pending`, then
  routes. Seam(b) stays outside fabro (00b).
- **agent-node realization:** `class="command"`, `permissions="read-write"`, prompt runs
  the drain commands; emits `message` if `pending inbox` is non-empty else `empty`.

## What the router does NOT do (preserved)
Does NOT write under `src/`/`tests/`/`features/`; does NOT run tests; does NOT emit
`work_done` for any message type; does NOT modify inbox/outbox by hand (all via
`shop-msg`); does NOT grant itself sufficiency exceptions.
