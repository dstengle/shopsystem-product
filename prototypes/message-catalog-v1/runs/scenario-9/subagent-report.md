# Scenario 9 — additive symmetric capability extension (`shop-msg respond work_done`)

## Setup
- Single `assign_scenarios` (work_id: lead-009) carrying two scenarios for a new CLI subcommand parallel to `respond clarify`:
  - hash `650e6761d5479ce3` — happy path: write a valid WorkDone outbox file
  - hash `35fece8e1f96e074` — collision-refuse: refuse to overwrite an existing outbox file for the same work_id
- Pattern: mirrors S6's `assign_scenarios for new capability` shape, not S7/S8's `request_bugfix for tightening`. The lead pre-anticipated the collision-refuse contract from S6→S7 learning rather than letting the Reviewer rediscover it.
- Pre-state: 5 scenarios passing in shop-msg-bc; 6 unit tests passing in temperature bc-shop. Both remained green throughout.

## Run sequence

1. **Implementer dispatched.** Sufficiency check passed for both scenarios (well-formed Gherkin, concrete steps, hash tags present).
   - **`cli.py`**: added `_cmd_respond_work_done` mirroring `_cmd_respond_clarify` shape — collision short-circuit, then build a `WorkDone(...)` and `yaml.safe_dump`. New `work_done` subparser with `--bc-root`, `--work-id`, `--status` (argparse `choices=["complete","partial","blocked"]`), repeatable `--scenario-hash`, optional `--summary`.
   - **`tests/conftest.py`**: added `WorkDone` import, two new When step defs (one with `--scenario-hash`, one without — anchored with `$` to disambiguate), and the `Then ... valid WorkDone ...` step. Did NOT modify the existing clarify When step.
   - **Two new feature files** (one per scenario), tags preserved.
   - BDD: 7/7 in shop-msg-bc; 6/6 in bc-shop (cross-BC regression check).
   - Outbox: NOT written. Implementer respected the gate.

2. **Reviewer dispatched.** Re-ran BDD, probed adversarially.

## Reviewer outcome

- **Sign-off.** `work_done(complete)` with both hashes echoed in `scenario_hashes`.
- Probes considered and dismissed:
  - **Hard-coded shortcut on happy path** — dismissed; CLI builds a real `WorkDone(...)` via Pydantic and round-trips through `yaml.safe_dump`. No literal string templating.
  - **Collision byte-fidelity** — dismissed; the `Then ... is unchanged` step compares `read_bytes()` to captured original bytes, not just existence; would fail a partial-overwrite-then-rollback bug.
  - **When-step regex ambiguity** between with-hash and no-hash variants — dismissed; the no-hash pattern is anchored with `$`, the with-hash pattern requires the literal `and scenario-hash "..."` suffix. Pytest-bdd cannot mis-route.
  - **`--scenario-hash` zero/many behavior** — unpinned but reasonable (`list(args.scenario_hash or [])` → `[]` on omit, accumulates on repeat). Not a gap that would change a reasonable implementation.
  - **Status enum double-enforcement** — argparse `choices` and `Literal[...]` agree; both reject invalid values.
  - **Fixture state leakage** — `context` is function-scoped; `bc_root` is per-test via `tmp_path`. No cross-test bleed.
  - **WorkDone schema-level constraints** (work_id pattern; summary/status further validation) — scope-defensible deferral. The S8 pattern (request_bugfix carrying constraint scenarios) is the right vehicle, not S9 (assign_scenarios for new capability). Deferral creates no behavioral risk for the two pinned scenarios.
  - **Per-message-type work_id constraint divergence** (Clarify pinned, WorkDone not yet) — tracked in beads, deferred catalog-wide.

## What this validated

- **Additive symmetric capability extension works.** The Implementer added a parallel subcommand to a CLI that already had `respond clarify`. The existing 5 scenarios all continued to pass; the existing clarify When step was NOT touched. The new step defs lived alongside the old ones without conflict. This is the structural complement of S8: there, scope-tight schema tightening; here, scope-tight CLI surface extension. Both stay narrow on purpose.
- **The collision-refuse contract is now a default.** S6 discovered the gap; S7 closed it for clarify; S9 baked it into the work_done sibling at the moment of introduction. The lead committed to the pattern rather than letting the Reviewer rediscover it. Reviewer confirmed the pattern was faithfully realized (short-circuit before any write, mirroring clarify's collision check).
- **The Reviewer respects scope-defensible deferrals across multiple slices.** S7 deferred path-traversal/empty-input safety to S8; S9 defers WorkDone schema constraints to a future request_bugfix slice. In both cases the Reviewer named the deferral, reasoned about behavioral risk to pinned scenarios, and explicitly declined to escalate. This is the same anti-rationalization principle the role-template enforces in the other direction (don't proceed when you should ask).

## Cumulative state after slice 9

- **shop-msg-bc:** 7 scenarios passing
  - happy-path respond clarify (b9ed9c63b8ccb208)
  - refuse-on-collision clarify (b6973413b7bfdd12)
  - refuse path-separator work_id on clarify (6ab8e9d72c4732a4)
  - refuse empty work_id on clarify (564632ae9310058c)
  - refuse empty question on clarify (9563c33a653afed7)
  - happy-path respond work_done (650e6761d5479ce3)
  - refuse-on-collision work_done (35fece8e1f96e074)
- **temperature bc-shop:** 6 tests passing (5 unit + 1 BDD scenario from S5b).
- **shop-msg CLI surface:** `respond clarify` + `respond work_done`. Both safe to adopt in the temperature BC's role templates.
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register`.
- **Open deferred items:** WorkDone schema-level constraints (parallel to Clarify's S8 work, deferred to a future request_bugfix); other message types' work_id constraints; other shop-msg subcommands (`send`, `inbox-next`, `hash`); replacing hardcoded paths in temperature BC's role templates (now possible since the work_done CLI half is also safe).
