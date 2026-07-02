# Slice 4 — DOGFOOD RE-RUN under HARDENED fabro (bc-base v0.3.49)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Bead:** lead-6tks (parent lead-fzxt) ·
**Dogfood identity:** `shopsystem-bc-launcher-dagger` (throwaway; ADR-020) ·
**Image:** `ghcr.io/dstengle/shopsystem-bc-base:latest` = `sha256:d72c1199…` (id `b528166add30`, v0.3.49)

Re-runs the Slice-4 dogfood after v0.3.49 shipped the three fixes from `04a`. The first run (`04a`)
booted+engaged+drained but blocked at `classify` on a sonnet-4-5 429. This run confirms **F1 and F2 are
fixed** and surfaces the **residual that now blocks one node later**.

## Verdict (one line)

Fabro booted on v0.3.49, engaged, drained, and **ran PAST `classify` on haiku** (F1 fixed) — but blocked
at the **NEXT** agent node `bc-sufficiency-check`, which is still pinned to the **persistently-429'd
sonnet-4-5**. The dispatch was **NOT consumed** (F2 fixed — retriable). **F3 NOT fixed**: the
`--orchestrator fabro` launch still holds the server foreground and never returned. Module **NOT built**;
blocked at index 6 (`suff`) instead of index 5 (`classify`).

## Step 1 — Re-deposit (DONE, hashes verified)

- **work_id used = `lead-6tks2`.** `lead-6tks` was REFUSED ("refusing to overwrite existing inbox entry
  for work_id='lead-6tks'") — the original row lingers on `(bc, lead-6tks)`; used `lead-6tks2` per the
  fallback instruction.
- **(A) `assign_scenarios` on `lead-6tks2`** — four `dagger-ci` scenario BODIES (Scenario:→EOF, Feature +
  `@scenario_hash`/`@bc` tag lines stripped), `--bc-tag shopsystem-bc-launcher-dagger`. **Read-back hashes
  verified EXACTLY:** `2c66a1b1d1b6f092` / `c7b2c587be09770b` / `514d075dbe616f02` / `2c13b47417b86d09`
  (pre-computed via `scenarios hash` over each staged body — all four MATCH; read-back confirms).
- **(B) `request_maintenance` carrier on `lead-6tks2-spec`** — full `03-productionize-spec.md` as
  `--description` + 7 file-hints (`ci/dagger.json`, `ci/src/bc_launcher_ci/main.py`, `ci/pyproject.toml`,
  `docker/bc-base/Dockerfile`, `docker/bc-lead/Dockerfile`, `.github/workflows/publish-bc-base.yml`,
  `tests/`). Verified present. In-band reference only (fabro's `armed` node reads ONE message = the
  routed `assign_scenarios`; the spec is not loop-consumed).

## Step 2 — Stop + relaunch from v0.3.49 (DONE, booted first try)

`docker rm -f bc-shopsystem-bc-launcher-dagger` (old container was on the pre-v0.3.49 image), then
`bc-container launch shopsystem-bc-launcher-dagger --orchestrator fabro --repo-url …/shopsystem-bc-launcher
--network shopsystem --shopmsg-dsn postgresql://…/shopsystem --work-id lead-6tks2 --env-file <av.env>`.
agent-vault `--env-file` rebuilt from `docker inspect bc-shopsystem-bc-launcher` (ADDR/TOKEN/VAULT +
multi-line double-quoted CA_PEM, 10 lines). Provisioning all green: clone, `bd bootstrap`, shop-templates
pour, `.fabro` loop-def bundle (15 files), shim on `127.0.0.1:8788`, fabro settings (base_url→shim, no
credential — ADR-049), server started, `fabro run workflow.fabro -I …WORK_ID=lead-6tks2`. Container
**Up, healthy** on `b528166add30` (v0.3.49).

## Step 3 — Monitor: how far it got

Fabro run **`01KWJ5ZQP42M9WB6ZG6R57G1YY`** — terminal `SUCCEEDED` (the graph's fail-closed terminal),
25s, $0.02 / 20.5k toks. Node timeline (from `/workspace/.fabro/fabro-run.log` + `fabro inspect`):

```
✓ Start · ✓ prime · ✓ health · ✓ arm(drain) · ✓ armed(read msg)
✓ bc-router classify           $0.02  5s   -> {"preferred_next_label":"scenario"}   [HAIKU — F1 FIXED]
✗ bc-sufficiency-check                      Error: LLM error: Rate limited by anthropic  [SONNET-4-5 429]
✓ report BLOCKED via non-consuming nudge (dispatch stays pending == retriable)          [F2 FIXED]
✓ REPORTED · ✓ Exit: SUCCEEDED
```

- **F1 (classify on haiku) — FIXED.** `classify` is now `class="classify"` → `claude-haiku-4-5`, `retry=4`
  (workflow.fabro:84,128; lead-i0wi). It ran clean and correctly emitted `scenario`. The exact block point
  from `04a` is resolved.
- **The loop ran PAST classify** — reached `bc-sufficiency-check` (index 6), one node further than `04a`.

## Step 4 — BLOCKED again: exactly where + why (NEW residual for `request_bugfix`)

**NEW RESIDUAL (headline) — the v0.3.49 F1 fix was too NARROW: it moved only `classify` to haiku; every
downstream judgment node is still pinned to the persistently-429'd `sonnet-4-5`, so the deliverable now
blocks at the FIRST of them (`bc-sufficiency-check`) instead of at `classify`.**

- `workflow.fabro:84` stylesheet: `* { model: claude-haiku-4-5 } .classify { model: claude-haiku-4-5 }
  .coding { model: claude-sonnet-4-5 } .review { model: claude-sonnet-4-5 }`.
- `suff`, `plan`, `impl`, `impl_f` are `class="coding"`; `review` is `class="review"` → all resolve to
  **sonnet-4-5**. `suff` carries `retry=3` but **all 3 retries exhausted** — the throttle is PERSISTENT,
  not transient, so retry cannot clear it. There is **no model fallback chain** (sonnet→haiku);
  `fallback_retry_target="halt"` is a NODE failsafe, not a model fallback.
- **Empirically pinned RIGHT NOW through the same shim→agent-vault→api wire (in-container
  `fabro model test`):** `claude-haiku-4-5` → **ok**; `claude-sonnet-4-5` → **error: Rate limited by
  anthropic**. The fleet OAuth account is still rate-limited on sonnet-4-5; haiku is available. Same
  condition as `04a`, unchanged.
- **Effect:** the loop can never reach `plan`/`impl`/`review`/`emit_r` while the account's sonnet-4-5 is
  429'd; it fails closed at the first `.coding` node. Module NOT built. No `work_done` in the outbox
  (correct — no false complete). No nudge landed in the outbox pending list (the "non-consuming nudge"
  report node ran but did not deposit an outbox row for `lead-6tks2`).
- **Fix candidates for the next `request_bugfix` → shopsystem-bc-launcher (owner of the ADR-051 defs):**
  (a) route the `.coding`/`.review` classes off sonnet-4-5 (e.g. onto haiku, matching what already
  unblocked classify) — OR make it a per-node capability decision; and/or (b) add a model **fallback
  chain** (sonnet-4-5 → haiku-4-5) so a persistent 429 falls back instead of exhausting retry; and/or
  (c) **resolve the fleet OAuth account's sonnet-4-5 rate limit** (account-level — a different account,
  a quota increase, or waiting for reset). (a)/(b) live in the loop-def (bc-launcher); (c) is infra/account.

**F2 (non-consuming report) — FIXED.** The `report BLOCKED via non-consuming nudge` node explicitly leaves
the dispatch pending ("dispatch stays pending == retriable; consume deferred to terminal complete"). The
BC inbox row `lead-6tks2` is **still readable/unconsumed** — a re-run after the next fix would find it
without re-deposit. (Contrast `04a` F2: a blocked run there consumed the dispatch.)

**F3 (launch returns after engage) — NOT FIXED / REGRESSED.** The `bc-container launch` process was still
ALIVE long after the fabro run reached its terminal (SUCCEEDED at 25s). The launcher still holds
`fabro server start --foreground` as the launch process's foreground and never returns after the engage —
exactly the `04a` F3 symptom. Had to background the launch and inspect run state directly. Cosmetic for
the deliverable but the claimed F3 fix did not take on this path. (Left the process alive so the server
keeps the container healthy for inspection; killing it would drop the server + health.)

## Guardrails honored

- Throwaway/distinct identity only (`shopsystem-bc-launcher-dagger`). **Real infra untouched**:
  bc-shopsystem-bc-launcher (Up 10d, healthy), messaging, scenarios, templates, lead, testproduct3 — all
  unchanged. No `--mount-docker-socket`.
- No push to production GHCR / real bc-launcher origin (blocked before any build/commit — nothing to push).
- **No fabro/BC source edited on the lead host.** Residual captured, not fixed (ADR-018). `main` untouched.

## needs_david

- **Likely yes (account-level):** the fleet OAuth account is **persistently rate-limited on
  claude-sonnet-4-5** (haiku ok) through the agent-vault wire. Loop-def changes (route `.coding`/`.review`
  off sonnet, or a sonnet→haiku fallback) can route AROUND it, but the underlying sonnet quota is a David /
  fleet-account decision if sonnet-quality coding is wanted for `plan`/`impl`/`review`.

## Router action queued

Dispatch **`request_bugfix`** → `shopsystem-bc-launcher` for the NEW residual: the F1 haiku re-route
must extend to the `.coding`/`.review` classes (or a model fallback chain), because a persistent sonnet-4-5
429 blocks `bc-sufficiency-check` and every downstream authoring node. Include F3 (launch still holds the
server foreground / never returns). The dispatch `lead-6tks2` stays pending (retriable) for the re-run.
The blocked run left no outbox `work_done`; nothing to reconcile.
