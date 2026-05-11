# Scenario 12 — `shop-msg send assign_scenarios` (lead-side CLI for assigning scenarios)

## Setup
- Single `assign_scenarios` (work_id: lead-012) carrying three scenarios for the new `shop-msg send assign_scenarios` subcommand:
  - hash `42d2d64c4e45ca7d` — happy-path one-scenario send with hash-roundtrip assertion
  - hash `2580fb1745b16844` — multi-scenario via repeatable `--scenario-file`
  - hash `e8d8c791ce0e0d49` — collision-refuse on inbox file
- Vehicle: `assign_scenarios` (capability gap, not tightening — the CLI did not previously accept `send assign_scenarios` at all). Per memory `shop-system-message-type-selection`.
- This is the first slice that integrates the `scenarios` package (Slice A, `ddd-product-system-fzs`) with the CLI: `cli.py` shells out to `scenarios hash` to compute the canonicalization. Package boundary preserved — no `from scenarios.hash import ...` in production code.
- Pre-state: 11 scenarios passing in shop-msg-bc; 6 unit tests passing in temperature bc-shop. Both remained green throughout.

## Run sequence

1. **Implementer dispatched.** Sufficiency check passed for all three scenarios.
   - **`cli.py`**: added `_cmd_send_assign_scenarios`. New `assign_scenarios` subparser under `send` with `--bc-root`, `--work-id`, `--feature-title`, `--bc-tag`, `--scenario-file` (repeatable, required). For each `--scenario-file`: read body, `subprocess.run(["scenarios", "hash"], input=body)` to compute hash, build tags `[@scenario_hash:<hash>, @bc:<tag>]`, wrap as `Feature: <title>\n\n  {tags}\n  {body}\n`, build `ScenarioPayload`. Constructs `AssignScenarios`, dumps to `<bc-root>/inbox/<work_id>.yaml`. Collision-refuse mirrors `send request_maintenance`.
   - **`tests/conftest.py`**: added body-file Given(s) (one for "a scenario body file ..." and one for "another scenario body file ..." — accumulates into `context["scenario_body_files"]`; `\n` literals in step text converted to real newlines before writing). Two new When defs `$`-anchored on disjoint tails (`that scenario file` vs `both scenario files`). Two new Then defs: hash-equality (subprocesses `scenarios hash` to verify the hash in the YAML matches what the canonicalization would produce for the body) and distinct-hashes (asserts the two ScenarioPayload entries have different hashes).
   - **One new feature file** containing all three scenarios.
   - BDD: 14/14 in shop-msg-bc; 6/6 in bc-shop.
   - Outbox: NOT written. Implementer respected the gate.

2. **Reviewer dispatched.** Re-ran BDD; probed adversarially; signed off.

## Reviewer outcome

- **Sign-off** via `shop-msg respond work_done` with all 14 currently-pinned scenario hashes echoed (3 new + 11 pre-existing).
- Probes considered and dismissed:
  - **Subprocess vs import for scenario hashing** — `cli.py` shells out to `scenarios hash`; `conftest.py`'s hash-equality Then also goes through subprocess. Defensible: both production and test traverse the same boundary; a future regression where `cli.py` started importing `compute_scenario_hash` directly would still produce the same output unless the package's internal API drifted from the CLI — at which point the boundary itself would be the bug, not this work.
  - **`\n` → newline conversion in the body-file Given** — Gherkin step text encodes embedded newlines as a literal `\n`; conftest converts to real newlines before writing. The on-disk file matches what a user would author by hand; `cli.py` reads via `Path.read_text()` unaware of the conversion. Faithful.
  - **Regex anchoring** on the two new Whens — both `$`-anchored on disjoint tails ("that scenario file" vs "both scenario files"). Pre-existing `send request_maintenance` Whens are also `$`-anchored on different tails. No collision; 14/14 confirms.
  - **Wrapped-Gherkin template parity** — `cli.py`'s `f"Feature: {title}\n\n  {tags}\n  {body}\n"` is byte-identical to harness.py emit-s4..s12 f-string. Round-trippable: a hash computed from the body goes the same place wherever the wrap happens.
  - **Defensible deferrals** — `AssignScenarios.work_id` has no pattern constraint (Clarify has one; deferred catalog-wide); behavior on nonexistent/empty `--scenario-file` not pinned; multi-`Scenario:` blocks in one file collapse to one ScenarioPayload (S12 pinned one-file-one-body). All out of scope.

## What this validated

- **Slice A's package boundary holds end-to-end through a real consumer.** The `scenarios` package was extracted in `ddd-product-system-fzs` with the rule "production code shells out to the CLI; only tests may import." S12 was the first production code (`shop-msg send assign_scenarios`) to use the boundary. The Reviewer probed it explicitly: cli.py uses subprocess, the prototype's package-boundaries discipline (saved as `shop-system-package-boundaries`) holds. The catalog has no idea hashing exists; the scenarios package has no idea about messages.
- **The CLI is now full-coverage for both lead-side and BC-side messaging surfaces.** Lead can `send` `request_maintenance` (with all four schema fields exposed via flags after S11) and `assign_scenarios` (multi-scenario with hash discipline). BC can `respond` `clarify` and `work_done`. The remaining message types (`request_bugfix`, `request_shop_card`, `request_scenario_register`) are scope decisions, not capability gaps — the CLI patterns are reproducible.
- **Hash-roundtrip is now CLI-testable.** The S12 happy-path Then asserts that the hash in the emitted YAML equals what `scenarios hash` produces for the body. Previously this was an implicit invariant of `harness.py`'s inline construction. Now it's pinned by an explicit scenario; the only way for cli.py to regress on hash discipline is to silently break the canonicalization, which the test would catch.
- **The role-template's "echo cumulative passing set" instruction held on its third exercise.** S10, S11, S12 — three slices, three Reviewer dispatches, three full hash-set echoes. Two slices was a coincidence; three is a pattern.

## Cumulative state after slice 12

- **shop-msg-bc:** 14 scenarios passing
  - 5 clarify (happy, collision, path-separator, empty work_id, empty question)
  - 2 work_done (happy, collision)
  - 4 send request_maintenance (happy, collision, full-flags, repeatable-criterion)
  - 3 send assign_scenarios (one-scenario happy, multi-scenario, collision)
- **temperature bc-shop:** 6 tests passing.
- **scenarios:** 4 unit tests passing.
- **shop-msg CLI surface:** `respond clarify`, `respond work_done`, `send request_maintenance`, `send assign_scenarios`. Bidirectional + nearly complete (the remaining `request_bugfix` is the same pattern as `assign_scenarios`).
- **harness.py:** still has emit-s4..s12 inline. Now structurally retirable since `shop-msg send assign_scenarios` is a CLI replacement.
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register`.
- **Open deferred items:**
  - `shop-msg send request_bugfix` — same pattern as `send assign_scenarios`, separate slice.
  - `shop-msg inbox-next` / `read` — lead-side response-reading parallel to harness.py's `read`.
  - harness.py emit-s4..s12 retirement — possible after this; separate slice.
  - Lead-side message-type-selection sufficiency check (`ddd-product-system-sgh`).
  - Schema-level `work_id` constraints across remaining message types — deferred catalog-wide.
