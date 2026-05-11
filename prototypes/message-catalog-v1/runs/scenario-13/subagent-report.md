# Scenario 13 — `shop-msg send request_bugfix` (lead-side CLI for the bugfix message)

## Setup
- Single `assign_scenarios` (work_id: lead-013) carrying three scenarios for the new `shop-msg send request_bugfix` subcommand:
  - hash `ed957587a564b1d8` — happy path: description-only RequestBugfix (no scenarios)
  - hash `1e7881f9232bc0b1` — happy path: description + one tightening scenario, with hash-roundtrip assertion
  - hash `677d20154e364482` — collision-refuse on inbox file
- **First slice deposited via `shop-msg send assign_scenarios` directly, not via harness.** The lead wrote three body files in `/tmp/slice13/` and composed the message with one CLI invocation; harness.py was not involved. The dogfooding loop closed: the tool the prototype produces is now the tool the prototype uses to drive its own slices.
- Vehicle: `assign_scenarios` (capability gap — the CLI did not previously accept `send request_bugfix` at all). Per memory `shop-system-message-type-selection`.
- Pre-state: 14 scenarios passing in shop-msg-bc; 6 unit tests passing in temperature bc-shop. Both remained green throughout.

## Run sequence

1. **Implementer dispatched.** Sufficiency check passed for all three scenarios.
   - **`cli.py`**: added `_cmd_send_request_bugfix`. New `request_bugfix` subparser under `send` with `--bc-root`, `--work-id`, `--description` (all required); `--feature-title`, `--bc-tag` (default None); `--scenario-file` (repeatable, optional). Conditional-required validation enforced post-parse: if any `--scenario-file` is supplied, `--feature-title` and `--bc-tag` must also be present (exit 2 + stderr otherwise). Extracted a shared `_build_scenario_payload` helper used by both `_cmd_send_assign_scenarios` and `_cmd_send_request_bugfix` — same wrap pattern (`Feature: <title>\n\n  {tags}\n  {body}\n`), same subprocess call to `scenarios hash`. Slice 12's three scenarios pass identically after the refactor.
   - **`tests/conftest.py`**: added `RequestBugfix` import; new step defs for description-only When, description+scenario-file When, description-only Then (asserts `scenarios == []`), and a combined Then asserting RequestBugfix shape with one scenario whose hash equals `scenarios hash` of the body. Existing description-only When `$`-anchored to disambiguate from the longer phrasing.
   - **One new feature file** containing all three scenarios.
   - BDD: 17/17 in shop-msg-bc; 6/6 in bc-shop.
   - Outbox: NOT written. Implementer respected the gate.

2. **Reviewer dispatched.** Re-ran BDD; probed adversarially; signed off.

## Reviewer outcome

- **Sign-off** via `shop-msg respond work_done` with all 17 currently-pinned scenario hashes echoed (3 new + 14 pre-existing).
- Probes considered and dismissed:
  - **Shared `_build_scenario_payload` helper** — refactor of `_cmd_send_assign_scenarios` preserves slice-12 behavior (all 14 prior pass). Hash is computed on raw body bytes pre-wrap, so a future format-only change to the `Feature:` wrapping would not perturb hashes. Coupling is benign.
  - **Conditional `--feature-title`/`--bc-tag` validation** — verified: `--scenario-file` without these emits clean stderr and exit 2. Collision-refuse fires first (exit 1, file unchanged) when both conditions trip — correct precedence (don't validate args if we wouldn't write).
  - **Description-only YAML emits `scenarios: []`** — present because `model_dump` without `exclude_defaults` keeps empty lists; the Then step asserts `msg.scenarios == []` which passes either way; lead has not pinned a preference. Out of scope.
  - **Empty `--description ""`** — accepted (RequestBugfix.description has no `min_length`). Catalog-wide deferred safety item.
  - **Regex shadowing** — new When phrasings `$`-anchored and differentiated by literal `send request_bugfix`; no overlap with prior 5 send/respond Whens.

## What this validated

- **The lead now drives the prototype with its own CLI.** S13 was the first slice deposited via `shop-msg send assign_scenarios` directly. No `emit-s13` was added to harness.py; instead three body files in `/tmp` were composed with one CLI invocation. After the slice landed, harness.py's only remaining role was emit-s7/s8 (RequestBugfix builders, now CLI-replaceable) plus `read`/`verify-hashes`. The tool the prototype produces is now the tool the prototype uses to drive its own validation loop. Closing this circularity took 13 slices and was always the dogfooding north star.
- **Catalog message-type CLI coverage is complete.** Lead-side: `send request_maintenance`, `send assign_scenarios`, `send request_bugfix`. BC-side: `respond clarify`, `respond work_done`. All five validated message types now have CLI parity. The remaining two (`request_shop_card`, `request_scenario_register`) are blocked on schema design (P3 issues 6mk, r7u, 5p8), not CLI capability.
- **The shared-helper refactor surfaced only after the second consumer.** Slice 12 wrote `_cmd_send_assign_scenarios` with inline scenario-payload construction. Slice 13's Implementer extracted `_build_scenario_payload` as the second consumer crystallized the abstraction. This is the canonical "extract on second use, not first" rhythm — and the Reviewer probed the coupling, confirmed it's benign because hashes are body-only (the wrap is a downstream cosmetic). The shared helper now sits where it can serve any future `send` subcommand that needs scenario payloads (e.g., a hypothetical `send request_scenario_register` would reuse it).
- **Conditional-required argparse validation is a real prototype-level pattern.** This is the second time we've hit it (the first was S11's `--acceptance-criterion`/`--file-hint` repeatability vs. defaulting). The Implementer's chosen pattern — `default=None`, post-parse validation, `exit 2` + stderr — matches argparse's own usage-error convention. The Reviewer probed precedence (collision-refuse beats validation, validation beats no-op) and confirmed the failure ordering is correct.

## Cumulative state after slice 13

- **shop-msg-bc:** 17 scenarios passing
  - 5 clarify (happy, collision, path-separator, empty work_id, empty question)
  - 2 work_done (happy, collision)
  - 4 send request_maintenance (happy, collision, full-flags, repeatable-criterion)
  - 3 send assign_scenarios (one-scenario+hash-roundtrip, multi-scenario, collision)
  - 3 send request_bugfix (description-only, description+scenario+hash-roundtrip, collision)
- **temperature bc-shop:** 6 tests passing.
- **scenarios:** 4 unit tests passing.
- **shop-msg CLI surface:** complete for the 5 validated message types.
- **harness.py:** down to emit-s7, emit-s8, read, verify-hashes. emit-s7/s8 retirement now possible (separate slice — uses the new `shop-msg send request_bugfix`).
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register` (blocked on schema design — P3 issues).
- **Open deferred items:**
  - harness.py `emit-s7/s8` retirement — possible after this slice; separate slice.
  - `shop-msg inbox-next` / `read` — lead-side response-reading parallel to harness.py's `read`. Once those land, harness.py can retire entirely.
  - Lead-side message-type-selection sufficiency check (`ddd-product-system-sgh`).
  - Schema-level constraints across remaining message types — deferred catalog-wide.
