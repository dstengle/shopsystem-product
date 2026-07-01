# 02 — Translation: bc-shop loop as a fabro workflow (Slice 2)

Epic **lead-6k1r**, branch **fabro-spike**. SPIKE / THROWAWAY.

This is the Slice-2 translation writeup: the concrete fabro workflow defs that
recreate the bc-shop Implementer→Reviewer loop + GATED `work_done` (01b §2), the
furniture-port table, the `fabro validate` result and the now-pinned command-node
attribute, the fail-closed static-check result, unresolved items, and the acceptance
criteria carried into Slice 3.

Assembled and validated with **fabro 0.254.0 (497aaba 2026-06-04)**, binary at
`/home/vscode/.fabro/bin/fabro` (symlinked onto PATH via `~/.local/bin/fabro`).

---

## 1. What was authored — file tree

All under `/workspace/findings/fabro-spike/fabro-defs/`:

```
fabro-defs/
├── workflow.fabro          # DOT graph — 22 nodes / 39 edges (the loop)
├── workflow.toml           # [environments.local] provider='local'; [run.pull_request] enabled=false
├── project.toml            # .fabro/project.toml equivalent; disables native PR creation
├── README.md               # node→furniture map + translation decisions (Leg 2) + Leg 1 addendum
├── vaults/
│   └── default/
│       ├── secrets.json    # scaffold — __PLACEHOLDER__ dummies only (GITHUB_TOKEN, ANTHROPIC_API_KEY)
│       └── README.md       # agent-vault + HTTPS_PROXY bypass doc
└── nodes/                  # ported furniture bodies (inlined into prompt= at assemble time)
    ├── bc-router.md
    ├── bc-sufficiency-check.md
    ├── writing-plans-bdd.md
    ├── test-driven-development.md
    ├── subagent-driven-development.md
    ├── using-git-worktrees.md
    ├── integrating-to-main.md
    ├── bc-review.md
    ├── work-done-gate.md
    ├── bc-implementer.md
    └── bc-reviewer.md
```

**Reconciliation (Leg 1 graph × Leg 2 node files):** every `prompt_file="nodes/*.md"`
pointer in `workflow.fabro` resolves to a real file in `nodes/` (10 distinct targets,
one referenced up to 4× for `bc-router.md`/`work-done-gate.md`). The only apparent
miss — `nodes/<furniture>.md` — is the literal placeholder inside the DOT header
COMMENT (line 22), not a live reference. `test-driven-development.md` and
`bc-reviewer.md` are present and pulled in by cross-reference from their host node
prompts (`impl`→TDD+implementer, `review`→reviewer) rather than by a top-level
`prompt_file=`; both files exist. Every command node carries a concrete inline command
in `prompt=`. **No mismatches required fixing** — the two legs' node-id and `class`
taxonomies already agreed.

---

## 2. Furniture-port table (piece → node file → node kind)

| Furniture piece | Node file | Node(s) → kind |
|---|---|---|
| `bc-router` | `nodes/bc-router.md` | `classify`=agent (`coding`); `prime`/`health`/`arm`=command |
| `bc-sufficiency-check` | `nodes/bc-sufficiency-check.md` | `suff`=agent (`coding`) |
| `writing-plans-bdd` | `nodes/writing-plans-bdd.md` | `plan`=agent (`coding`) |
| `subagent-driven-development` | `nodes/subagent-driven-development.md` | `impl`=parallel agent; `redgate`=command |
| `test-driven-development` | `nodes/test-driven-development.md` | agent sub-prompt module inside `impl`/`impl_f` |
| `using-git-worktrees` | `nodes/using-git-worktrees.md` | `worktree`=command |
| `integrating-to-main` | `nodes/integrating-to-main.md` | `integ`=command |
| `bc-review` | `nodes/bc-review.md` | `review`=agent (`review`) |
| `work-done-gate` | `nodes/work-done-gate.md` | `wdg_r`/`wdg_f`/`emit_r`/`emit_f`=command (all **5** checks ported) |
| `bc-implementer` (role shim) | `nodes/bc-implementer.md` | `impl`/`impl_f` bias, `class="coding"` |
| `bc-reviewer` (role shim) | `nodes/bc-reviewer.md` | `review` bias, `class="review"` |

Shared report emitters (`emit_clar`, `emit_blk`) carry their command inline (no
prompt_file — pure `shop-msg respond`). Terminals `reported`/`halt` are deterministic
command sinks.

**Translation calls preserved (nothing dropped):**
- Every command-furniture piece → **tool-restricted agent node** (see §4).
- `Task`/`Agent` subagent fan-out → fabro `parallel=true` on `impl`.
- `Monitor` LISTEN/NOTIFY → command-node poll (`shop-msg watch`/`pending inbox`) — Seam(b) PARTIAL.
- `Skill` tool → prose inlined.
- `work-done-gate` fidelity: authoritative skill defines **5** checks (adds Check 4
  bd-plan durability/orphan, Check 5 genuine-red); all five ported, not just 01b's C1–C3.

---

## 3. `fabro validate` result

Exact command (from `fabro-defs/`) and output:

```
$ fabro validate workflow.fabro
Workflow: BcShopLoop (22 nodes, 39 edges)
Graph: workflow.fabro
Validation: OK

$ fabro validate workflow.fabro --json
{
  "workflow_name": "BcShopLoop",
  "nodes": 22,
  "edges": 39,
  "valid": true,
  "diagnostics": []
}
```

**PASS** — 22 nodes / 39 edges, `valid: true`, 0 diagnostics. No structural fixes
were needed; the graph validated as delivered by Leg 1.

---

## 4. Pinned command-node attribute

**Result: there is NO native command StageHandler on the fabro v0.254.0 DOT surface.**
A command step is realized as a **tool-restricted agent node** carrying the concrete
command inline in `prompt=`, with these attributes:

```
class="command", deterministic=true, permissions="read-write"   [+ retry=N where guarded]
```

Empirical basis this slice:
- `deterministic` and `backend` are **genuine binary-recognized node tokens** (confirmed
  via `strings` on the fabro binary — both present as exact tokens).
- `fabro validate` is **permissive on attribute names**: a probe node with
  `command="echo hi"` (no prompt) and even a `totallyBogusAttr=xyz` node both validate
  `OK`. So validate alone does **not** prove a `command=` attribute is honored — it
  only proves structural well-formedness (single Msquare terminal, edge/label
  resolution, single connected graph).
- The handler-classification proof (a `command=`/`cmd=` box is classified an LLM node
  at run — `"LLM node '<id>' has no prompt or label attribute"` / `prompt_on_llm_nodes`
  warning) lives at `fabro preflight`/`fabro run`, which require a **live server**
  (`preflight` → `Connection refused` here, no server up). This matches both legs'
  earlier empirical pin; it could not be re-exercised this slice without a server, and
  is carried as U-native-command (below).

Net: the delivered graph already uses the correct realization (deterministic agent
nodes), so no change was required. `deterministic=true` is the pinned attribute; the
`.toml` `execution` layer remains the documented fallback (U2) if a live preflight ever
rejects the inline-command agent nodes.

---

## 5. Fail-closed static check (Slice-0 hazard)

**Result: PASS — no fallible node can reach `Exit:SUCCEEDED`.**

Proven by static edge-enumeration over `workflow.fabro` (grep + reasoning; fabro
validate does NOT prove this property — it is not a structural check fabro runs):

**(a) `done` (Msquare / Exit:SUCCEEDED) has exactly three in-edges, all labeled:**
```
arm    -> done  [label="empty"]    # legitimate idle-empty (nothing pending)
emit_r -> done  [label="ok"]       # reviewer's gated emit succeeded (scenario path)
emit_f -> done  [label="ok"]       # implementer's gated emit succeeded (flat path)
```
No deliverable/gate node routes directly to `done`; SUCCEEDED is reachable ONLY through
the two gated `bc-emit work-done` nodes or the idle-empty branch.

**(b) Every fallible node carries an explicit failure-labeled edge** (18/18):
`prime`(ok/failed) · `health`(healthy/unhealthy) · `arm`(message/empty) ·
`classify`(scenario/flat) · `suff`(proceed/clarify) · `worktree`(ok/failed) ·
`plan`(ok/failed) · `impl`(ok/failed) · `redgate`(pass/fail) · `integ`(ok/failed) ·
`review`(signoff/scenario_gap/impl_gap) · `wdg_r`(pass/fail) · `emit_r`(ok/failed) ·
`impl_f`(ok/clarify/failed) · `wdg_f`(pass/fail) · `emit_f`(ok/failed) ·
`emit_clar`(ok/failed) · `emit_blk`(ok/failed).
The only unlabeled edge in the whole graph is `start -> prime` (Start is not fallible).

**(c) Three DISTINCT terminals exist and failure never masks as success:**
- `done` — Msquare, Exit:SUCCEEDED (gated emit or idle-empty).
- `reported` — box sink; the CORRECT non-failure end after a clarify/blocked report
  was emitted (`emit_clar→reported`, `emit_blk→reported`).
- `halt` — box sink; FAILED (`exit 1`). Reached by `prime→failed`, `health→unhealthy`,
  and by `emit_*→failed` / `emit_clar→failed` / `emit_blk→failed` (collision /
  retry-exhausted / report-send failure). Even an emit COLLISION fails closed to `halt`,
  never to `done`.

The Slice-0 silent-failure-masking hazard (an unconditional edge advancing a FAILED
node to SUCCEEDED) is structurally eliminated.

> Caveat carried to Slice 3 (U1): topology alone now distinguishes the three ends, but
> whether a run that ENDS at a box sink (`reported`/`halt`) reports run-STATUS
> FAILED vs SUCCEEDED is a fabro-runtime behavior confirmable only at first `fabro run`.
> `halt` runs `exit 1` to force FAILED; if fabro maps sink-ended paths to SUCCEEDED
> regardless, fold `halt` into a native fail-terminal and let the emitted shop-msg carry
> the block distinction (the ADR-018 surface). This does not weaken the static property
> above (no FAILED node reaches the SUCCEEDED *node*); it only concerns run exit-status
> mapping.

---

## 6. Unresolved items (carried, most load-bearing first)

- **U5 / AC-proxy** — `HTTPS_PROXY` reaching a non-dry-run agent node's OWN LLM + tool
  calls (agent-vault injection on the wire). Sharpest risk; needs a live `fabro run`.
- **U1 / run-status** — box-sink (`reported`/`halt`) → run STATUS mapping (see §5 caveat).
- **U-native-command** — the `command=`-becomes-LLM-node classification (and thus the
  need to keep deterministic-agent command nodes vs. porting to the `.toml` `execution`
  layer, U2) is only re-provable with a live server; `preflight` refused (connection
  refused) this slice.
- **U3 / input injection** — `${BC_NAME}`/`${WORK_ID}` run-input templating
  (`fabro run -I KEY=VALUE`; `{{ goal }}` exposed) unconfirmed against a live run.
- **U4 / fan-in** — whether `impl` `parallel=true`→`redgate` needs an explicit
  `parallel.fan_in` join was not forced at validate time.
- **`shop-templates show`** serves only the 4 role templates; the 9 skill sources were
  read from package data (`.../shop_templates/templates/skills/<name>/SKILL.md`) — fine
  for authoring, noted so Slice 3 doesn't expect `shop-templates show <skill>` to work.

---

## 7. Acceptance criteria carried into Slice 3 (fabro-orchestrated launch)

Slice 3 is the FIRST live `fabro run` of this graph inside an already-booted BC
container (`provider='local'`), the seam being the readiness barrier = first prepare
node. The static work above becomes these live ACs:

1. **AC-launch** — `fabro run workflow.fabro -I BC_NAME=<bc> -I WORK_ID=<id>` starts a
   headless run inside the container under `[environments.local] provider='local'`
   without a native PR being created (`[run.pull_request] enabled=false`). (U3, launch-parity)
2. **AC-command-node** — the deterministic-agent command nodes execute their inline
   command and emit the outcome label from exit status; if run-preflight rejects them,
   port the commands into `.toml` `execution` (U2/U-native-command) — graph shape
   unchanged.
3. **AC-proxy-cred** — a non-dry-run agent node's own LLM + `gh`/`git`/`shop-msg` calls
   succeed via `HTTPS_PROXY`→agent-vault with only `__PLACEHOLDER__` in the vault (U5).
4. **AC-failclosed-runtime** — a forced failure (e.g. `health→unhealthy`, or an emit
   collision) yields run STATUS FAILED and NO `work_done(complete)` on the wire;
   confirm `halt`'s `exit 1` maps to FAILED and box-sink status behavior (U1).
5. **AC-gated-emit** — on the happy scenario path the reviewer is the SOLE emitter:
   exactly one `bc-emit work-done ... --status complete` reaches the mailbox, its
   `@scenario_hash` a subset of committed tags (work-done-gate re-run inside `bc-emit`).
6. **AC-input-injection** — `${BC_NAME}`/`${WORK_ID}` resolve correctly in node prompts
   from `-I` inputs (U3).
7. **AC-fan-in** — `impl` parallel fan-out converges into `redgate` correctly, with an
   explicit `parallel.fan_in` join added if the live run requires it (U4).
8. **AC-reactive-seam** — `arm`/`shop-msg watch` command-node drain behaves as the
   Seam(b) PARTIAL substitute for native LISTEN/NOTIFY (block-wait unconfirmed).

Hard prerequisite unchanged from Slice 1: **bc-base is un-rebuildable** (ADR-022) — a
live boot for Slice 3 depends on an already-booted container being available.
