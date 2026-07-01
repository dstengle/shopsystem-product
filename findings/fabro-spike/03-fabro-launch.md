# Slice 3 — Fabro-orchestrated launch (SYNTHESIS)

Epic **lead-6k1r**. Branch `fabro-spike`. fabro v0.254.0. Date 2026-07-01.
Product authority: David. Real (non-dry-run) LLM + tool calls through agent-vault,
authorized for this spike.

This synthesizes three legs (detail files):
- `03a-proxycred-recon.md` — bc-base availability recon + U5 root cause.
- `03c-shim-u5-close.md` — the anthropic-oauth-shim that CLOSES U5.
- `03b-runtime-mechanics.md` — graph-execution mechanics (AC2/AC4/AC6/AC7).

**Slice-3 bottom line: the launch path works.** The first live `fabro run` of the
graph inside `provider='local'` succeeds; a fabro agent node's own LLM call and its
outbound authenticated tool call both go through agent-vault with fabro's vault
holding only `__PLACEHOLDER__` (invariant #2 preserved); and bc-base is AVAILABLE, so
the full Slice-4 real end-to-end is reachable. The two ACs that genuinely need a real
BC container + live mailbox (AC5 gated-emit, AC8 reactive-seam) are correctly deferred
to Slice 4.

---

## (a) The 8 Slice-3 ACs — verdicts with evidence

Source of the AC list: §7 of `02-translation.md`.

| # | AC | Unit | Verdict | Evidence |
|---|----|------|---------|----------|
| 1 | AC-launch | launch-parity | **PASS** | Headless `fabro run … --environment local --auto-approve` starts under `[environments.local] provider='local'`; no native PR (`[run.pull_request] enabled=false`). Confirmed across every probe run this slice (e.g. run `01KWDQNE9ZKQNTJSQ7KCYJ5CEK`, `Sandbox: local (ready in 0ms)`). |
| 2 | AC-command-node | U2 | **PASS** | Run-preflight does NOT reject command nodes. TWO realities: NATIVE `shape=parallelogram, script="…"` (no LLM; exit 0=succeeded / nonzero=failed, proven by direct run) and AGENT `shape=box, class="command"` (templated prompt via LLM shell tool). No `.toml` execution layer needed — the execution layer IS the DOT `script=` attribute. |
| 3 | AC-proxy-cred | **U5** | **PASS** (via shim) | anthropic-oauth-shim: dummy `x-api-key` → shim adds `Authorization: Bearer` + `anthropic-beta: oauth-2025-04-20` → `HTTPS_PROXY`→agent-vault injects real OAuth → 200. `fabro model test --model haiku` → `ok` (was `invalid x-api-key`). Node's own LLM call `✓` and node's `gh api user` → `{"login":"dstengle"}`, both through the proxy, vault = `__PLACEHOLDER__`. Passing runs `01KWDQMQR0E4DR9851RJKFXHFN`, `01KWDQNE9ZKQNTJSQ7KCYJ5CEK`. |
| 4 | AC-failclosed-runtime | U1 | **PASS** (quirk resolved) | Root cause: agent-emulated `exit 1` COMPLETES (stage succeeded) → advanced to SUCCEEDED. Fix: `halt` = NATIVE `script="…; exit 1"` SINK (no outgoing edge) → run **FAILED** ("stage failed with no outgoing fail edge"); failures caught with `condition="outcome=failed"`. Proven-safe catch = unconditional success edge + `condition="outcome=failed"` failure edge. Proven that `label=` alone and `goal_gate=true` do NOT reliably fail. |
| 5 | AC-gated-emit | (needs BC) | **DEFERRED → Slice 4** | Requires the real `bc-emit` wrapper + messaging DB (UNIQUE(work_id,direction,shop) collision path, pydantic WorkDone, work-done-gate re-run). The graph wires `emit_r`/`emit_f` + the collision→`halt` failsafe, but the emit itself needs a live BC + mailbox. |
| 6 | AC-input-injection | U3 | **PASS** | Syntax is `{{ inputs.NAME }}` (minijinja 2.19, namespaced) in `prompt=`/`goal=` only, declared in `[run.inputs]`, overridden by `-I NAME=VALUE`. Proven: `-I BC_NAME=shopsystem-messaging` rendered `[shopsystem-messaging]`. Old shell `${BC_NAME}` NOT honored. Constraint: inputs are NOT in `script=` nor as sandbox env vars — BC_NAME/WORK_ID gates must stay agent nodes. |
| 7 | AC-fan-in | U4 | **PASS** | `impl` is a single stage (`parallel=true`, accepted node attr; fans out to subagents internally), converging to `redgate` via one edge — NO `parallel.fan_in` join required. True graph-level fan-out would use `shape=component` + `shape=tripleoctagon` (handler `parallel.fan_in`, `join_policy`/`max_parallel`), confirmed in the binary. |
| 8 | AC-reactive-seam | Seam(b) | **DEFERRED → Slice 4 (PARTIAL)** | `arm`/`shop-msg watch` LISTEN/NOTIFY + live inbox drain need the live mailbox; the `arm` node models the poll but Seam(b) stays PARTIAL until a BC container drives it. |

**Tally: 6 PASS, 2 DEFERRED (need a real BC + live mailbox).** No FAIL. No hard
blocker to Slice 4.

---

## (b) U5 verdict — CLOSED by the shim; invariant #2 preserved

**U5 = PASS.** It was the load-bearing unknown (03a found it initially BLOCKED) and it
is now closed by the **anthropic-oauth-shim**, not by touching fabro's secrets or the
fleet vault.

**Root cause (03a):** header-shape mismatch. The fleet agent-vault injects the
Anthropic credential as an **OAuth Bearer** (`CLAUDE_OAUTH`, rewrites only
`Authorization: Bearer` + `anthropic-beta: oauth-2025-04-20`). fabro's Anthropic
adapter authenticates with **`x-api-key`** and has no Anthropic-OAuth mode, so the
proxy leaves it untouched and Anthropic rejects the dummy. GitHub tool calls already
worked (proxy injects `GITHUB_TOKEN` for dummy Bearer).

**The fix:** a ~180-line Python-stdlib reverse proxy at `127.0.0.1:8788`. Per request
it STRIPS `x-api-key`, ADDS `Authorization: Bearer <dummy>` + `anthropic-beta:
oauth-2025-04-20`, and FORWARDS to `api.anthropic.com` through the environment
`HTTPS_PROXY` — where agent-vault injects the REAL OAuth credential. fabro points at
it via the **`anthropic` adapter's `base_url` override** (the adapter accepts it, so
the shim speaks native Anthropic Messages format both directions — **NO format
translation**, the `openai_compatible` fallback was avoided):

```toml
[llm.providers.anthropic]
base_url = "http://127.0.0.1:8788/v1"
```

**How invariant #2 ("credentials via agent-vault, fabro vault stays
`__PLACEHOLDER__`") is preserved — verified:**
- `fabro-defs/vaults/default/secrets.json` = `__PLACEHOLDER__` for BOTH
  `ANTHROPIC_API_KEY` and `GITHUB_TOKEN` (unchanged).
- Server `ANTHROPIC_API_KEY` env = dummy `sk-ant-DUMMY-placeholder-proxy-injects`; the
  shim **discards** it and never forwards it.
- The `gh` token handed to the node is a dummy; agent-vault substitutes the real one
  on the wire.
- The shim stores no secret — it only rewrites header *shape*. The real credential
  lives only in agent-vault and is injected on the wire.

No real secret is written to or read from fabro. The credential shape is normalized so
the existing agent-vault substrate does the injection it already does for every other
BC — which is exactly the spirit of invariant #2.

**Two orthogonal env-plumbing findings** were needed to make the node's `gh` call pass
under `provider=local` (and note: **specific to the local sandbox** — Slice-4 BCs run
inside bc-launcher containers that already carry `HTTPS_PROXY`, so this gap does not
necessarily bind the in-container orchestration):
1. Deliver proxy/CA via the **global** `[run.environment.env]` overlay + `--environment
   local` — NOT `[environments.<slug>]` (fabro auto-migrates that into a file whose
   `[env]` is silently dropped; a one-time-only apparent success trap).
2. The ACP coding agent **strips credential-shaped env vars** (GH_TOKEN/GITHUB_TOKEN/
   ANTHROPIC_API_KEY) from the shell tool — supply the git token **inline** in the
   command (`GH_TOKEN=ghp_dummy gh api user`); the proxy injects the real one.

---

## (c) bc-base verdict = AVAILABLE → Slice-4 real e2e is reachable

**VERDICT: AVAILABLE.** Slice-4 e2e is NOT blocked on bc-base (contra the carried
"un-rebuildable ADR-022" risk — the *artifacts already exist*, no rebuild needed):

- `docker images`: multiple `ghcr.io/dstengle/shopsystem-bc-base` tags present locally
  (`:latest` 2.1GB, plus v0.2.2..v0.3.6); `docker manifest inspect …:latest` →
  **PULLABLE** from the registry (a fresh host can obtain it too).
- **Three healthy BC containers already running** (Up 8 days, healthy):
  `bc-shopsystem-bc-launcher`, `bc-shopsystem-messaging`, `bc-shopsystem-scenarios`.
  (Some others report `unhealthy` — recoverable via `bc-container start-agent` — but
  the three healthy ones are the safe target.)
- Launch tooling on PATH: `bc-container` (launch|attach|inject|monitor|stop|status|
  start-agent|list|manifest), plus `bc-emit`, `shop-msg`, `shop-templates`. Supporting
  infra up: `shopsystem-postgres`, `shopsystem-agent-vault` (both Up 8 days healthy).

So Slice 4 can run against an already-booted healthy container OR a fresh
`bc-container launch` — the hard Slice-1 prereq is satisfied.

---

## (d) Defs/shim changes + launch procedure

### Files changed / added (uncommitted, matching subagent scope)

New — the shim (`findings/fabro-spike/fabro-defs/anthropic-oauth-shim/`):
- `shim.py` — ~180-line stdlib reverse proxy (strip x-api-key → add OAuth Bearer +
  `anthropic-beta` → forward via `HTTPS_PROXY`; relays JSON and SSE streaming).
- `launch-shim.sh` — launches the shim on `127.0.0.1:8788`.
- `settings.toml.snippet` — the `[llm.providers.anthropic] base_url` override +
  `[run.environment.env]` proxy/CA overlay.
- `README.md`, `u5probe.fabro` — repro furniture.

Modified defs:
- `workflow.toml` — added `[run.inputs] BC_NAME/WORK_ID` (+ the templating/native-
  sandbox constraint note).
- `workflow.fabro` — full runtime correction: templating `${…}` → `{{ inputs.… }}`
  (goal + all prompts); `halt` → native `script exit 1` SINK; `reported` → native
  `script exit 0` → `done`; `done` unchanged (single Msquare); every fallible node
  rewired to the proven-safe pattern (uncond success + `condition="outcome=failed"`
  catch); prompts instruct emitting `{"preferred_next_label":"…"}`; header rewritten to
  pin all four mechanics + routing cascade + the agent no-directive hazard.
  `fabro validate workflow.fabro` → **OK (22 nodes / 44 edges)**.
- `README.md` — marked U1–U5 RESOLVED + open risk.

### Launch procedure (to reproduce the passing run)

1. `findings/fabro-spike/fabro-defs/anthropic-oauth-shim/launch-shim.sh` → shim on
   `127.0.0.1:8788`.
2. Append `settings.toml.snippet` to `~/.fabro/settings.toml`; set `provider =
   "local"` in `~/.fabro/environments/local.toml`.
3. `fabro server restart` with `SESSION_SECRET` + `FABRO_DEV_TOKEN` + dummy
   `ANTHROPIC_API_KEY` (see `scratchpad/fabro-env.sh`).
4. `fabro run fabro-defs/anthropic-oauth-shim/u5probe.fabro --environment local
   --auto-approve` → `✓ u5-proxy-probe`, outcome ok, login `dstengle`.

**Currently live for the follow-on leg:** shim (pid 286891, listening
`127.0.0.1:8788`) and fabro server (pid 287406, `127.0.0.1:32276`) — both verified
alive at synthesis time.

---

## (e) Concrete Slice-4 plan (reach the goal)

Goal (from plan.md): dispatch `assign_scenarios` to a fabro-orchestrated BC and observe
a valid `work_done` from the recreated Implementer→Reviewer loop.

**Target host:** run the graph INSIDE one of the three healthy bc-launcher containers
(`bc-shopsystem-messaging` or `bc-shopsystem-scenarios`, or a fresh throwaway
`bc-container launch`). In-container is the correct home per invariant #1 (in-container
BC orchestration only) AND it side-steps the two local-sandbox env-plumbing traps —
the container already carries `HTTPS_PROXY` + CA, so the node's tool calls reach
agent-vault without the overlay/inline-token workarounds.

**Steps:**
1. **Install fabro + defs into the target container.** Copy `fabro-defs/` (workflow +
   nodes + vault `__PLACEHOLDER__` scaffold + anthropic-oauth-shim) in; install the
   fabro binary; launch the shim inside the container; start the ephemeral local fabro
   server with the `base_url` override. Verify `fabro model test --model haiku` → `ok`
   in-container (confirms the shim path works with the container's own HTTPS_PROXY).
2. **Seed a real `assign_scenarios` dispatch** into the container's inbox via
   `shop-msg` (a throwaway scenario, e.g. against `shopsystem-messaging`), so the graph
   has real work to consume.
3. **Run the graph:** `fabro run workflow.fabro -I BC_NAME=<bc> -I WORK_ID=<id>
   --environment local --auto-approve`. This exercises the deferred ACs live:
   - **AC5 (gated-emit):** watch that the reviewer is the SOLE `bc-emit work-done …
     --status complete`, its `@scenario_hash` a subset of committed tags; force the
     UNIQUE(work_id,direction,shop) collision path once to confirm it routes to `halt`
     → run FAILED with NO second emit.
   - **AC8 (reactive-seam):** drive the `arm`/`shop-msg watch` node against the live
     mailbox to confirm LISTEN/NOTIFY drain (upgrade Seam(b) from PARTIAL).
4. **Close the AGENT NO-DIRECTIVE HAZARD** (the #1 carried correctness item): an agent
   that completes but emits no routing directive slips to a labelled success edge —
   `condition="outcome=failed"` only catches genuine stage errors. Slice-4 clean fix =
   make the must-fail-closed gates NATIVE `script=` command nodes; that needs the
   input-into-command-sandbox gap closed (options: fabro exposing inputs as sandbox
   env; an agent writes WORK_ID to a context file a native gate reads; or
   `context_updates` + `condition="context.X=…"` edges). Backstops already in place:
   native gates + the `halt` sink.
5. **Observe + record:** a valid `work_done` produced by the loop = goal green. Write
   `findings/fabro-spike/04-goal-demo.md`.

**Safety note (carried from 03b):** a full real run mutates state (`bd dolt push`,
`git worktree`, `bc-emit`) — do it against a **throwaway** BC/scenario inside a
container, never the lead host, never a real BC's real work.

**Reachability: YES.** Every Slice-4 prerequisite is satisfied — bc-base AVAILABLE +
healthy containers running; U5 closed (LLM path proven); all four runtime mechanics
pinned; invariant #2 preserved. The remaining work is exercising AC5/AC8 against a live
mailbox and hardening the no-directive hazard — no blocker.
