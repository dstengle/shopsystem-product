# Slice 4 — DOGFOOD dispatch: dagger CI work under fabro-orchestrated bc-launcher

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Bead:** lead-6tks (parent lead-fzxt) ·
**Dogfood identity:** `shopsystem-bc-launcher-dagger` (throwaway, distinct mailbox; ADR-020)

Executes Slice 4 of the dagger effort: dispatch the dagger CI deliverable (03-productionize-spec.md +
`features/dagger-ci/01-04`) to a NEW fabro-orchestrated bc-launcher instance and shake out fabro on
real work. Deliverable spec = `findings/dagger-spike/03-productionize-spec.md`.

## Verdict (one line)

Fabro **BOOTED, engaged the loop, drained + READ the assign_scenarios, and emitted a GATED
`status: blocked` work_done (NOT a false complete)** — but the module was **NOT built**: the first
agent node (`classify`) hit a **sonnet-4-5 429 rate-limit** and fail-closed. The loop machinery is
GREEN on real work; the deliverable is blocked on a single, precise, fixable model-selection residual.

## What was done (steps 1–4)

### 1. Registration — DONE
`shop-msg registry add shopsystem-bc-launcher-dagger` → `shopsystem-bc-launcher-dagger
shopsystem/bc-launcher-dagger bc`. Distinct identity; the running real `bc-shopsystem-bc-launcher`
(drains `shopsystem-bc-launcher`) untouched.

### 2. Dispatch — DONE (hashes verified) + one contract finding
- **Message A = `assign_scenarios` on work_id `lead-6tks`** — the four `dagger-ci` scenario BODIES
  (Scenario:→EOF, Feature + tag lines stripped), `--feature-title` + `--bc-tag
  shopsystem-bc-launcher-dagger`. **Read-back hashes verified EXACTLY:**
  `2c66a1b1d1b6f092` / `c7b2c587be09770b` / `514d075dbe616f02` / `2c13b47417b86d09` (re-computed by
  the `scenarios hash` CLI over each staged body before dispatch — all four MATCH).
- **Message B = `request_maintenance` carrying `03-productionize-spec.md`** + 7 file-hints
  (`ci/dagger.json`, `ci/src/bc_launcher_ci/main.py`, `ci/pyproject.toml`, `docker/bc-base/Dockerfile`,
  `docker/bc-lead/Dockerfile`, `.github/workflows/publish-bc-base.yml`, `tests/`).
  **FINDING (shop-msg contract, NOT a fabro residual): the plan's "two message-types under ONE
  work_id" premise is not dispatchable.** `shop-msg send` (lead→BC) enforces one inbox row per
  `(bc, work_id)` via `allow_multi_type=False` (storage.py:559-572); the second send under
  `lead-6tks` was refused ("refusing to overwrite existing inbox entry for work_id='lead-6tks'").
  Deposited Message B under sibling work_id **`lead-6tks-spec`** instead (verified: full spec
  description + hints present). **Deeper reason it wouldn't have mattered anyway:** the fabro loop's
  `armed` node reads exactly ONE message per run via `shop-msg read inbox --work-id "$WORK_ID"` and
  `classify` routes it down ONE lane (assign_scenarios→scenario lane; request_maintenance→FLAT lane,
  no reviewer). So a co-work_id carrier could never be co-processed. `assign_scenarios` is the
  CORRECT single routed dispatch for scenario-pinned module authoring; the spec rides `lead-6tks-spec`
  as an in-band reference (never loop-consumed — dangling pending inbox row + dispatch bead; router's
  reconciliation call whether to retract).

### 3. Launch (dogfood) — DONE, booted first try
`bc-container launch shopsystem-bc-launcher-dagger --orchestrator fabro --repo-url
https://github.com/dstengle/shopsystem-bc-launcher --network shopsystem --shopmsg-dsn
postgresql://postgres:postgres@postgres:5432/shopsystem --work-id lead-6tks --env-file <av.env>`.
- **agent-vault:** built `--env-file` from `docker inspect bc-shopsystem-bc-launcher`
  (AGENT_VAULT_ADDR/TOKEN/VAULT + **multi-line** CA_PEM as a double-quoted value; the launcher's
  `_parse_env_file` supports multi-line quoted values — round-trip verified). Booted on the FIRST
  attempt, no iteration needed. **No `--mount-docker-socket`** (per guardrail; authoring deliverable).
- Provisioning all green: clone, `bd bootstrap`, shop-templates pour, **`.fabro` loop-def bundle
  (15 files, lead-h2bj/ADR-051) placed**, shim started on `127.0.0.1:8788`, fabro settings written
  (`base_url=http://127.0.0.1:8788/v1`, adapter=anthropic, **no credential** — ADR-049), fabro server
  started + `fabro run workflow.fabro -I BC_NAME=shopsystem-bc-launcher-dagger -I WORK_ID=lead-6tks`.

### 4. Verify + monitor — DONE (bounded)
- **Container:** `bc-shopsystem-bc-launcher-dagger` Up, **healthy**.
- **Fabro engaged:** run `01KWJ2XQCJXD76X67HRCV2PF0P`, status **succeeded/completed**, model
  `claude-sonnet-4-6` (run default); shim on :8788; fabro server pid 1559.
- **RK-1 (loop drains + sees the dispatch): CONFIRMED.** Native node path
  `start→prime→health→arm→armed` all succeeded; `armed` read the `lead-6tks` assign_scenarios from the
  inbox into context (the inbox `lead-6tks` row is now **consumed**).
- **RK-2 (sees BOTH rows): N/A by design** — the loop reads only `WORK_ID=lead-6tks`; the
  `lead-6tks-spec` carrier is not loop-visible (see step 2 finding).
- **Fail-closed on real work: VERIFIED.** `classify` (first agent node) failed →
  `emit_blk`→`reported`→`done`; a **`status: blocked`** work_done landed in the outbox
  (`scenario_hashes: []`, summary "a deliverable-side gate or step failed … reporting blocked, never
  a silent complete"). No silent complete despite total LLM failure — the ADR-051 fail-closed contract
  held on live work.
- **Module NOT built:** the loop never reached `impl`/`review`/`emit_r`. Blocked at `classify` (index 5).

## FABRO RESIDUALS (for `request_bugfix` → shopsystem-bc-launcher)

**F1 (HEADLINE) — the loop model-stylesheet pins routing/coding/review agents to a rate-limited
sonnet; a 429 deterministically blocks the whole deliverable at the first agent node.**
- `workflow.fabro` line 84: `model_stylesheet="* { model: claude-haiku-4-5 } .coding { model:
  claude-sonnet-4-5 } .review { model: claude-sonnet-4-5 }"`. `classify` is `class="coding"` →
  resolves to **sonnet-4-5**.
- The node has **no `retry=`/`retry_target`** and the run has **`fallbacks: []`**. classify's LLM call
  returned **429** (`failure.signature = api_transient|anthropic|rate_limited`, category
  `transient_infra`, `will_retry: false`, wall 8.4s) → no directive → fail-closed to `emit_blk`.
- **Empirically pinned RIGHT NOW through the same shim→agent-vault→api.anthropic.com wire:**
  `fabro model test claude-haiku-4-5` → **ok**; `claude-sonnet-4-5` → **error: Rate limited by
  anthropic**. The fleet OAuth account is rate-limited on sonnet-4-5 but haiku is available.
- **Effect:** ANY sonnet 429 blocks the entire deliverable at `classify` before any authoring — the
  loop cannot reach impl/review/emit. This is exactly the predicted "sonnet 429 → should use haiku."
- **Fix (bc-launcher owns the shipped ADR-051 defs):** (a) route the light `classify`/routing judgment
  off `.coding` (default `*`→haiku is enough for a 4-row message-type classification); and/or
  (b) add `retry=`/`retry_target` with backoff on the agent nodes so a `transient_infra` 429 retries
  instead of fail-closing; and/or (c) configure a model `fallbacks=[…]` chain (sonnet→haiku).

**F2 (mechanism note) — a blocked/failed run still CONSUMES the inbox dispatch.** The native `arm`
node drains the inbox before the agent processes it, so the `lead-6tks` assign_scenarios is now
consumed even though the deliverable is blocked. A re-run after an F1 fix would find `lead-6tks`
empty (`armed`→idle) and needs the dispatch **re-deposited**. (Matches the Slice-4 "drain not robust
to upstream consume" observation; surfaces here on real work.)

**F3 (non-fatal) — the `--orchestrator fabro` launch process does not return.** The launcher holds
`fabro server start --foreground` as the launch process's foreground even after the `fabro run` engage
terminates; the container is healthy and the run is terminal, but the `bc-container launch` invocation
never exits (had to background it and inspect run state directly). Cosmetic for automation, but worth
a bugfix note (background the server, return after engage) so callers get a clean exit + run id.

## Guardrails honored

- Throwaway/distinct identity only (`shopsystem-bc-launcher-dagger`). **Real infra untouched**:
  bc-shopsystem-bc-launcher (Up 10 days, healthy), messaging, scenarios, templates, lead, testproduct3
  all unchanged.
- No push to production GHCR / real bc-launcher origin (the dogfood blocked before any build/commit;
  nothing to push).
- **No fabro/BC source edited on the lead host.** Residuals captured, not fixed (ADR-018). main untouched.

## needs_david

**None operationally.** One router action queued: dispatch **`request_bugfix`** to
`shopsystem-bc-launcher` for **F1** (loop model-stylesheet / retry / fallback so a sonnet 429 does not
block the deliverable) — the loop is otherwise GREEN and re-runnable once F1 lands (re-deposit the
`lead-6tks` assign_scenarios per F2). The blocked `work_done` on `lead-6tks` is in the outbox for the
lead's reconciliation.
