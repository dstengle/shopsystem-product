# Slice 4 — DOGFOOD RE-RUN under fabro v0.3.50 (all-haiku loop + detached engage)

**Date:** 2026-07-02 · **Branch:** `dagger-spike` · **Bead:** lead-6tks2 (parent lead-fzxt) ·
**Dogfood identity:** `shopsystem-bc-launcher-dagger` (throwaway; ADR-020) ·
**Image:** `ghcr.io/dstengle/shopsystem-bc-base:latest` = digest `sha256:444f640c…` (v0.3.50), local id `8fb29e82926e`

Third Slice-4 dogfood pass. `04a` blocked at `classify` (sonnet-4-5 429). `04b` blocked one node later at
`bc-sufficiency-check` (v0.3.49 F1 was too narrow — only `classify` moved to haiku). v0.3.50 moves **all**
`.coding`/`.review` classes to haiku and makes the `--orchestrator fabro` engage **detach** so launch returns.

## Verdict (one line)

v0.3.50 **cleared both prior residuals**: launch RETURNED (R7 fixed) and the loop ran the **FULL length on
haiku** — classify → suff → worktree → plan → **impl (the build ran, 5m43s)** → RED-before-GREEN gate — then
**FAILED at the native `integrating-to-main` node** on a git-push credential error. Two findings: (1) a **NEW
fabro residual** at `integ` (no push credential → `fatal: could not read Username for 'https://github.com'`);
(2) a **DELIVERABLE GAP** — impl authored **BDD test scaffolding only, NOT the `ci/` dagger module + WRAP**,
because the module-shape spec (`03-productionize-spec.md`) rides a companion carrier the loop never consumes.

## R7 — launch RETURNS (FIXED)

`bc-container launch … --orchestrator fabro … --work-id lead-6tks2 --env-file <av.env>` **returned rc=0 in
~4s** (START 20:40:56 → LAUNCH_RETURNED 20:41:00). All provisioning green (clone, `bd bootstrap`, shop-templates
pour, `.fabro` 15-file bundle, shim on 127.0.0.1:8788, settings base_url→shim / no credential per ADR-049),
then the engage started the ephemeral fabro server and ran `fabro run workflow.fabro …` **detached** and the
launch process exited cleanly. Contrast `04a`/`04b` where launch held `fabro server start --foreground` and
never returned. **v0.3.50 R7 (docker-level engage detach) confirmed.** Container `Up, healthy`.
agent-vault `--env-file` = ADDR/TOKEN/VAULT + 10-line double-quoted CA_PEM from `docker inspect
bc-shopsystem-bc-launcher` (04a recipe, round-trips through `_parse_env_file`).

## Loop ran the full length on haiku (F1-extended FIXED)

v0.3.50 stylesheet (in-container `workflow.fabro:84`):
`* { model: claude-haiku-4-5 } .classify {…haiku} .coding { model: claude-haiku-4-5 } .review { model:
claude-haiku-4-5 }` — every judgment class now haiku. Run `01KWJ90G41YP4C2FT05M7BZMBY`, terminal `SUCCEEDED`
(fail-closed terminal), **7 min, $0.81 / 3.7m toks**:

```
✓ Start · ✓ prime · ✓ health · ✓ arm(drain) · ✓ armed(read msg)
✓ bc-router classify              $0.02   5s     -> {"preferred_next_label":"scenario"}   [HAIKU]
✓ bc-sufficiency-check            $0.04   30s                                             [HAIKU — 04b block point CLEARED]
✓ using-git-worktrees             34ms    -> wt-lead-6tks2 @ branch work/lead-6tks2
✓ writing-plans-bdd (plan)        $0.07   54s                                             [HAIKU]
✓ bc-implementer (impl, fan-out)  $0.69   5m43s  -> RED->GREEN commits on work/lead-6tks2 [HAIKU — THE BUILD]
✓ RED-before-GREEN inter-layer gate  19ms
✗ integrating-to-main             Error: fatal: could not read Username for 'https://github.com': No such device or address
✓ report BLOCKED via non-consuming nudge (dispatch stays pending == retriable)
✓ REPORTED · ✓ Exit: SUCCEEDED
```

Both prior block points (`classify` 04a, `suff` 04b) are resolved. `suff` (the exact 04b failure) ran clean on
haiku. The loop reached `impl` and **ran a full 5m43s build** — the first pass ever to author + commit on real work.

## NEW FABRO RESIDUAL (headline, for next `request_bugfix` → shopsystem-bc-launcher)

**The native `integrating-to-main` node pushes the worktree branch to `origin/main` over HTTPS with no git push
credential in the dogfood container → `fatal: could not read Username for 'https://github.com': No such device or
address`.** The container has the agent-vault MITM CA + proxy for *build-time egress*, but no GitHub **push**
credential (correctly — the dogfood must not push to the real bc-launcher). The `integ` node is a NATIVE
non-LLM script node, so this is a loop/launcher residual, not a model/tool gap. It **fail-closed correctly**:
`integ ✗ → report BLOCKED via non-consuming nudge → REPORTED → SUCCEEDED terminal`; no false complete.

- **Guardrail note:** this failure was *protective* — it stopped an unwanted push to the real
  `dstengle/shopsystem-bc-launcher` main. But architecturally the loop's terminal integration step pushing to
  `origin/main` is the wrong shape for a dogfood identity (and arguably for any BC that should emit `work_done`
  as the deliverable rather than self-merge to main). Fix candidates for the loop-def owner: (a) make the
  scenario-path terminal *emit the branch/patch as the `work_done` deliverable* (reviewer emits via `bc-emit`)
  rather than push to origin/main; and/or (b) gate the push node behind a credential-present check that routes to
  emit_blk with a clear reason when absent; and/or (c) for real BCs, provision a scoped push credential. The
  point of the dogfood is the module as a `work_done` deliverable in the clone, not an origin/main push.

## DELIVERABLE GAP — impl built BDD scaffolding, NOT the dagger `ci/` module + WRAP

The impl committed a RED→GREEN pair to `work/lead-6tks2` (`c38272c test(red)`, `ca0526d feat(green)`) whose
`git diff main..work/lead-6tks2` is **only**:

```
features/bc_base_dagger_image_build.feature   | 44 ++   (the 4 scenarios copied into a Feature)
tests/conftest.py                             | 195 ++  (pre-existing bc-launcher manifest/FakeDocker helpers)
tests/test_bc_base_dagger_image_build.py      | 21 ++   (bare `scenarios("../features/…")` binding, NO step defs)
```

**NOT built:** `ci/dagger.json`, `ci/src/bc_launcher_ci/main.py`, `ci/pyproject.toml` (the Python-SDK dagger
module with build / build-and-test / shim_listen_smoke / build-test-and-push + real-image tier), and **no WRAP**
of `.github/workflows/publish-bc-base.yml` (byte-identical to the clone). The `scenarios()` binding has no
implemented step definitions for the dagger scenarios, so the impl's claimed "GREEN" is hollow (collected/undefined
steps, not a real dagger build).

- **Root cause (dispatch-shape, not a model failure):** the `03-productionize-spec.md` module-shape instructions
  ("author a Python-SDK dagger module under `ci/` with these entrypoints; WRAP publish-bc-base.yml") ride the
  **companion `lead-6tks2-spec` `request_maintenance` carrier**, which the fabro loop **never consumes** — the
  `armed` node reads exactly ONE message under `WORK_ID=lead-6tks2` (the `assign_scenarios`). So the implementer's
  context contained only the 4 Gherkin scenarios and, lacking the module-shape brief, haiku read them as
  "author a BDD feature + pytest-bdd binding" (its natural bc-shop scenario-path reflex) instead of "build the
  dagger module." This is the same "two message-types / one carrier not co-processed" limitation flagged in
  `04a` step 2 — now surfacing as a *substance* gap, not just a dispatch mechanics note.
- **To actually get the `ci/` module built,** the module-shape spec must reach the implementer's context.
  Options (router/lead call — do NOT fix here): fold the 03-spec build instructions INTO the assign_scenarios
  carrier (or a per-scenario docstring the loop reads); OR extend the loop to consume the companion carrier into
  impl context; OR author the scenarios so their bodies alone pin the module artifacts (they currently describe
  dagger *behaviors*, which BDD-scaffolding satisfies literally). This is a lead-side authoring/dispatch decision.

## work_done status

**Blocked (no outbox row).** Consistent with `04b`, the "report BLOCKED via non-consuming nudge" node leaves the
dispatch pending and deposits **no** `work_done` in the outbox — `shop-msg pending outbox --lead
shopsystem-product` shows no `lead-6tks2`/dagger row. No false complete. Nothing for the lead to reconcile.
**Dispatch `lead-6tks2` still PENDING in the BC inbox (retriable)** — F2 held a third time; a re-run needs no
re-deposit.

## Residual scorecard vs prior runs

| Residual | 04a | 04b | 04c (v0.3.50) |
|---|---|---|---|
| F1 classify on haiku | BLOCK @classify | FIXED | FIXED |
| F1-extended `.coding`/`.review` on haiku | — | BLOCK @suff | **FIXED** (suff/plan/impl/review all ran on haiku) |
| F2 non-consuming blocked report | consumed | FIXED | FIXED (dispatch still pending) |
| F3 / R7 launch returns after engage | not returned | not returned | **FIXED** (rc=0 in ~4s, detached) |
| NEW: `integ` push to origin/main, no credential | — | — | **NEW residual** (fail-closed correctly) |
| DELIVERABLE: `ci/` module + WRAP built | not reached | not reached | **NOT built** (BDD scaffolding only; dispatch-shape gap) |

## Guardrails honored

- Throwaway/distinct identity only (`shopsystem-bc-launcher-dagger`). **Real infra untouched**:
  bc-shopsystem-bc-launcher (Up 10d, healthy), messaging, scenarios, templates, lead, testproduct3, dagger
  engines/registry — all unchanged. No `--mount-docker-socket`.
- **No push to production GHCR / real bc-launcher origin/main.** The `integ` push failed closed (no credential);
  nothing was pushed. Real LLM calls (haiku) only.
- **No fabro/BC source edited on the lead host.** Residuals captured, not fixed (ADR-018). `main` untouched.

## needs_david / router actions queued

- **Router `request_bugfix` → shopsystem-bc-launcher** for the NEW `integ` residual: the scenario-path terminal
  should emit the branch/patch as the `work_done` deliverable (or credential-gate the push node), not push to
  `origin/main` from a credential-less dogfood container.
- **Lead-side dispatch-shape decision** (PO/Architect) for the DELIVERABLE GAP: get the `03-spec` module-shape
  brief into the implementer's loop-consumed context so the `ci/` module + WRAP are actually built, not just
  BDD-scaffolded. This is authoring/dispatch, not a fabro bug.
- **No account-level needs_david this run** — haiku carried the entire loop; the sonnet-4-5 429 that blocked
  04a/04b is fully routed around.
