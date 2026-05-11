# Scenario 4 — subagent report (assign_scenarios + hash roundtrip + BDD)

## Setup
- New message type: `assign_scenarios` carrying one scenario
- Scenario: "Boiling water in Fahrenheit" — Given/When/Then over the existing `to_fahrenheit` capability
- Hash: `3f123ba774758ff2` (computed lead-side over normalized scenario text, embedded as `@scenario_hash:...` tag)
- BDD layer: pytest-bdd, with a `tests/test_features.py` one-liner that auto-discovers `.feature` files in `bc-shop/features/`. Step definitions for the BC's existing capabilities (Temperature creation, Celsius/Fahrenheit conversions) pre-wired in `tests/conftest.py`.
- Tightened role prompt extended with an `assign_scenarios`-specific sufficiency check (well-formed Gherkin / concrete steps / hash tag present) and a "doing the work" section.

## Outcome
- **Expected:** `work_done` with `status: complete` and `scenario_hashes: [3f123ba774758ff2]`
- **Actual:** `work_done` with `status: complete` and `scenario_hashes: [3f123ba774758ff2]` ✓
- BDD: 6 tests pass (1 new BDD scenario + 5 pre-existing unit tests)
- Harness validation: `read` parses cleanly; `verify-hashes` confirms the hash sent matches the hash received

## Sufficiency-check application (verbatim)
> 1. Well-formed Gherkin: 1 Given, 1 When, 1 Then.
> 2. Concrete steps: every step has specific numeric values (100, 212).
> 3. Carries `@scenario_hash:3f123ba774758ff2` tag (in `tags[]` and inside the gherkin text).

## What the implementer did
- Wrote `features/boiling_water_fahrenheit.feature` preserving both tags exactly (including the hash).
- Ran `python3 -m pytest tests/` — pytest-bdd discovered the new feature; all 6 tests pass.
- Existing step definitions covered the phrasings; no new step defs or BC source changes required.

## What was *not* exercised by this probe (deferred)
- Implementer writing new step definitions for novel Given/When phrasings.
- Implementer implementing new BC capability when scenario fails because capability is missing.
- Reviewer gate (§4.4) before `work_done` emission.
- Multi-scenario assign_scenarios with partial pass.
- Ambiguous-Gherkin probe (vague step text → expected `clarify`).
