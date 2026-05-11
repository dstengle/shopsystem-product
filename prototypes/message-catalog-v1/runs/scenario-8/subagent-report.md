# Scenario 8 — deferred safety items closed (input validation on Clarify)

## Setup
- Single `request_bugfix` (work_id: lead-008) carrying three additive scenarios closing the safety items the Reviewer flagged in S6 (parenthetically) and S7 (explicitly deferred):
  - hash `6ab8e9d72c4732a4` — refuse work_id with path separator
  - hash `564632ae9310058c` — refuse empty work_id
  - hash `9563c33a653afed7` — refuse empty question
- Description recommended schema-level Pydantic Field constraints (so all callers, including future CLIs, get validation for free).
- Pre-state: 2 scenarios passing in shop-msg-bc, 6 unit tests passing in temperature bc-shop. Both remained green throughout.

## Run sequence

1. **Implementer dispatched.** Sufficiency check passed (description concrete + all three embedded scenarios pass `assign_scenarios` check).
   - **Schema change** (`schemas.py`, cross-BC shared file):
     - `Clarify.work_id` → `Field(min_length=1, pattern=r"^[a-zA-Z0-9-]+$")`
     - `Clarify.question` → `Field(min_length=1)`
     - Scope kept tight per dispatch — other message types' `work_id` left unconstrained.
   - **Three new feature files** (one per scenario), tags preserved.
   - **Step defs** (`tests/conftest.py`):
     - New: `Then the BC's outbox is empty` (uses `iterdir()` against the Given-created outbox).
     - Adapted: switched the existing `respond clarify` When step from `parsers.parse` to `parsers.re` so empty-string captures match — `parsers.parse` does not match empty strings. Necessary integration step.
   - **`cli.py` UNMODIFIED.** The CLI calls `Clarify(...)`, Pydantic raises `ValidationError` on bad input, default Python exception handling produces non-zero exit. The scenarios assert exit non-zero + outbox empty; both hold.
   - BDD: 5/5 in shop-msg-bc; 6/6 in bc-shop (cross-BC regression check).

2. **Reviewer dispatched.** Re-ran both BDD suites, probed.

## Reviewer outcome

- **Sign-off.** `work_done(complete)` with all 5 hashes echoed in `scenario_hashes`.
- Probes:
  - **Path computation before validation in `cli.py`.** Traced — `out_path` is built from raw `args.work_id`, `out_path.exists()` is checked, then `Clarify(...)` runs. With `work_id="../escape"`, Pydantic raises `ValidationError` before `out_path.open("w")` — no file leaks outside the outbox. Schema-level enforcement is sufficient. Defense-in-depth in `cli.py` would be nice but isn't pinned and isn't needed for the pinned cases. Dismissed.
  - **Scope to Clarify only.** Defensible — `shop-msg` CLI only writes `Clarify` today. Other message types' `work_id` will be tightened when (e.g.) the lead grows its own CLI. Not a behavioral gap for this slice. Dismissed with explicit deferral note.
  - **Forward-slash-only `lead/001`.** Not pinned distinctly, but the `^[a-zA-Z0-9-]+$` pattern rejects `/` and `.` jointly. The "path separator" family is covered. Dismissed.
  - **Whitespace-only question.** Passes `min_length=1`. Out of scope for the "weaponization" framing; bugfix description pinned empty only. Dismissed.
  - **Step-def switch parsers.parse → parsers.re.** Necessary for empty-string capture; no regression. Clean.
  - **New "outbox is empty" Then step.** Uses `iterdir()`; no state leakage, no exception swallowing. Clean.

## What this validated

- **Schema-level enforcement is the right place for input safety.** A single Pydantic constraint on `Clarify.work_id` rejects path traversal, emptiness, and any other unsafe-as-path-component value in one rule. The CLI inherits the validation by virtue of calling the schema constructor — no defensive code in `cli.py` was needed.
- **Cross-BC schema changes are safe when additive.** Adding constraints to `Clarify` did not regress the temperature BC's 6 tests (which never construct `Clarify` instances). Confirms the shared-schemas pattern works under additive evolution.
- **Implementer's scope discipline.** Dispatch said "Clarify scope; broader rollout deferred unless strictly cleaner." Implementer kept the change tight. The Reviewer agreed and called out the scope choice as a probe, found it defensible, and explicitly deferred broader rollout with reasoning. Two layers of considered restraint — exactly the kind of principled deferral the role-template anti-rationalization is meant to enable.
- **Step-definition adapter discipline.** Switching `parsers.parse` to `parsers.re` was a quiet but necessary integration step — without it the new empty-string scenarios would never have matched. The Implementer noticed this from a failing run, not from the dispatch, and resolved it without escalation.

## Cumulative state after slice 7

- shop-msg-bc: 5 scenarios passing
  - happy-path respond clarify (b9ed9c63b8ccb208)
  - refuse-on-collision (b6973413b7bfdd12)
  - refuse path-separator work_id (6ab8e9d72c4732a4)
  - refuse empty work_id (564632ae9310058c)
  - refuse empty question (9563c33a653afed7)
- temperature bc-shop: 6 tests passing (5 unit + 1 BDD scenario from S5b)
- `shop-msg respond clarify` is now safe to adopt in the temperature BC's role templates
- Catalog message types exercised end-to-end: `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`
- Catalog message types still unexercised: `request_shop_card`, `request_scenario_register`
