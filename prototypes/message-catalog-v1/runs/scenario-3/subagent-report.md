# Scenario 3 — subagent report (good acceptance criteria)

## Setup
- New task (`work_id: lead-003`): add `from_fahrenheit` classmethod
- Description names the method, kind (classmethod on Temperature), input type, output type, and gives the exact formula
- Acceptance criteria: two equality assertions plus "all existing tests still pass"
- File hints: src/temperature.py, tests/test_temperature.py
- Tightened role prompt (same as S2b/S2c)

## Outcome
- **Expected:** `work_done` (regression check that the tightened prompt doesn't suppress legitimate work)
- **Actual:** `work_done` with `status: complete` ✓
- Outbox: `bc-shop/outbox/lead-003-work_done.yaml`
- Tests after run: 5 passed (3 pre-existing + 2 new from_fahrenheit tests)
- Harness validation: parsed cleanly against `WorkDone` schema

## Subagent's reasoning (verbatim, condensed)
> 1. Acceptance criteria present — three items listed.
> 2. Measurable — `Temperature.from_fahrenheit(32).to_celsius() == 0` and `... 212 ... == 100` are concrete equality assertions; "All existing tests still pass" is itself a runnable check.
> 3. Outcome, not just constraints — the two equality criteria specify the new behavior of `from_fahrenheit`; only the third is a pure constraint.
> 4. Description specifies "the thing" — name, kind (classmethod on Temperature), input, output, and the exact formula.

## Fields used
All four optional/required fields: `work_id`, `description`, `acceptance_criteria` (turned into tests), `file_hints` (used to locate files).

## Notable
The tightened prompt did not produce pedantic clarify traffic. Well-specified work passed all four conditions cleanly and was executed without back-and-forth.
