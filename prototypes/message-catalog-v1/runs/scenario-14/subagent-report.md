# Scenario 14 — `shop-msg read outbox` + harness.py retires entirely (with full §4.4 loop closure)

## Setup
- Single `assign_scenarios` (work_id: lead-014) carrying three scenarios for the new `shop-msg read outbox` subcommand:
  - hash `81e8af96807f33f4` — read a work_done from a BC's outbox
  - hash `d3e94f098d60143f` — read a clarify from a BC's outbox
  - hash `2cac6d6dba471090` — error path: read fails when no outbox file matches
- Vehicle: `assign_scenarios` (capability gap — `shop-msg read` did not exist at all). Per memory `shop-system-message-type-selection`.
- Deposited via `shop-msg send assign_scenarios` directly (second slice in a row to do so; S13 was the first). Three body files in `/tmp/slice14/` + one CLI invocation produced lead-014.yaml.
- Pre-state: 17 scenarios passing in shop-msg-bc; 6 in bc-shop; 6 in scenarios.

## Run sequence — first leg

1. **Implementer dispatched.** Sufficiency check passed.
   - **`cli.py`**: added top-level `read` subparser with `outbox` sub-subcommand. Logic mirrors the now-retired `harness.read_response`: glob `<bc>/outbox/<work-id>-*.yaml`, take last (sorted), validate via `TypeAdapter(BCResponse)`, print `valid <type> from <name>:` header + YAML dump on success; on miss-or-invalid prints to stderr and exits 1. Subparser tree leaves room for future `read inbox`.
   - **`tests/conftest.py`**: added Givens that subprocess-call `shop-msg respond work_done` / `respond clarify` for setup (so test setup uses the same CLI surface as production); new When `$`-anchored to disambiguate from existing send/respond Whens; `command exits zero` Then; two stdout-substring-includes Thens; stderr-explains-no-outbox Then. `check=True` on the setup subprocess so misconfigured Givens fail loud.
   - **One new feature file** containing all three scenarios.
   - BDD: 20/20 in shop-msg-bc; 6/6 in bc-shop.
   - Outbox: NOT written. Implementer respected the gate.

2. **Reviewer dispatched.** Re-ran BDD; probed adversarially; **escalated `clarify`** to lead.

## Reviewer outcome (lead-014)

- **Scenario gap → `clarify` to lead.** Validated by counterfactual reasoning: cli.py's try/except around `_response_adapter.validate_python(...)` handles ValidationError, but no scenario locks the contract. A future "simplification" removing the try/except would let an unhandled traceback escape, and all 3 assigned scenarios would still pass. The Reviewer proposed a 4th scenario (file exists, valid YAML, fails BCResponse schema → command exits non-zero, stderr explains schema-validation failed).
- Other probes dismissed: multi-match preference (sorted picks work_done over clarify — defensible; work_done semantically newer in §4.4 loop); stdout substring stability; subprocess-respond Givens defensibly couple slice-14 setup to slices 9-12; header-line format not pinned but lower stakes than validation-path gap.

## Run sequence — second leg (§4.4 loop continuation)

3. **Lead emitted `request_bugfix`** (work_id: lead-015) carrying the Reviewer's proposed tightening verbatim. Vehicle: `request_bugfix` (the validation-failure behavior already exists in cli.py — this is *tightening unpinned existing behavior*, the canonical request_bugfix discriminator from memory `shop-system-message-type-selection`). Sent via `shop-msg send request_bugfix` (the CLI from S13 — second use, first §4.4 use).

4. **Implementer dispatched against lead-015.** Sufficiency check passed (description concrete + references prior context + ADDITIVE framing; embedded scenario well-formed with hash present).
   - **`cli.py` UNTOUCHED.** The validation handling already exists; this slice only pins the contract under BDD.
   - **`features/read_outbox.feature`**: appended the new scenario (hash `c039ab184dd1bbb8`).
   - **`tests/conftest.py`**: two new step defs — Given for the malformed-YAML fixture (writes `message_type: not_a_real_type` plus benign fields; parses as YAML, fails BCResponse discriminated union); Then for `stderr explains schema validation failed` (substring "validation failed" matching cli.py's message).
   - BDD: 21/21. No regressions.

5. **Reviewer dispatched against lead-015.** Re-ran BDD; probed; signed off.

## Reviewer outcome (lead-015)

- **Sign-off** via `shop-msg respond work_done` with all 21 currently-pinned scenario hashes echoed (1 new + 20 pre-existing).
- Probes:
  - **Counterfactual: would removing cli.py's try/except cause the new scenario to fail?** Verified — without the except branch, ValidationError would propagate as an unhandled traceback. The traceback contains pydantic field-level diagnostics but NOT the substring "validation failed". The Then asserts that exact substring; scenario locks the contract.
  - **Fixture choice** (`message_type: not_a_real_type` vs missing-required-field): both route through the same except branch; chosen fixture is more discoverable.
  - **Substring stability**: "validation failed" is generic but no spurious source on this CLI surface today.
  - **Cumulative-hash echo**: all 21 `@scenario_hash:` tags across `features/*.feature` echoed.

## What this validated

- **The §4.4 loop's second full closure in the prototype.** The first was S6→S7 (collision-refuse on respond clarify). This is the second: clarify on missing schema-validation scenario for read outbox → request_bugfix with tightened scenario → Implementer adds scenario without touching code → Reviewer re-gates → sign-off. Every step used existing message types flowing through the existing role-template architecture. The §4.4 loop is reproducible mechanism, not aspiration — confirmed twice now.
- **Tightening-without-code-change is a real outcome category.** The Implementer's report was telling: "cli.py UNTOUCHED. The validation handling already exists; this slice only pins the contract under BDD." Sometimes the right outcome of a §4.4 round trip is to lock down behavior the implementation already has but the scenarios don't yet pin. This is exactly what the role-template anti-rationalization is meant to enable: a Reviewer who sees "implementation already does this" doesn't dismiss the gap, because future implementations might NOT.
- **The lead's full surface is now CLI-driven.** This slice was the first to also use `shop-msg send request_bugfix` (the CLI from S13) — second consumer of that CLI, first §4.4 use. And the lead validated the final sign-off using `shop-msg read outbox` — the CLI we just built. The lead now drives every step of a §4.4 round trip via the dogfooded CLI surface; harness.py is not involved at any point.
- **harness.py retires entirely.** With `read outbox` migrated, the harness has no remaining responsibilities. Deleted in this slice. The prototype's lead-side toolchain is now `shop-msg send/read` + `scenarios hash/verify`, all installed packages with proper CLIs.

## Cumulative state after slice 14

- **shop-msg-bc:** 21 scenarios passing
  - 5 clarify, 2 work_done, 4 send request_maintenance, 3 send assign_scenarios, 3 send request_bugfix, 4 read outbox (3 from S14 + 1 from S14's bugfix tightening)
- **temperature bc-shop:** 6 tests passing.
- **scenarios:** 6 unit tests passing (4 hash + 2 verify).
- **shop-msg CLI surface:** complete for the 5 validated message types in both directions, plus read outbox. Lead-side: `send {request_maintenance, assign_scenarios, request_bugfix}`; `read outbox`. BC-side: `respond {clarify, work_done}`.
- **scenarios CLI surface:** `hash`, `verify`.
- **harness.py:** deleted.
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register` (blocked on schema design — P3 issues).
- **Open deferred items:**
  - `shop-msg read inbox` (BC-side counterpart) — separate slice if/when needed.
  - Lead-side message-type-selection sufficiency check (`ddd-product-system-sgh`).
  - Schema-level constraints across remaining message types — deferred catalog-wide.
  - `request_shop_card` / `request_scenario_register` schema design + validation — P3 (`ddd-product-system-{6mk, r7u, 5p8}`).
