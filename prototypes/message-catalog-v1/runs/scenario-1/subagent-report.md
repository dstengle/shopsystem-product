# Scenario 1 — subagent report

## Outcome
- Emitted: `work_done` with `status: complete`
- Outbox: `bc-shop/outbox/lead-001-work_done.yaml`
- Tests after run: 5 passed (3 pre-existing + 2 new Kelvin tests)
- Harness validation: outbox YAML parsed cleanly against `WorkDone` schema

## Fields used (from inbox `request_maintenance`)
- `description` — gave method name and formula
- `acceptance_criteria` — drove the two test cases verbatim and the regression expectation
- `file_hints` — pointed to the exact files to edit
- `work_id` — used for outbox filename and response correlation

## Wished it had
Nothing material. Acceptance criteria pinned the values, so no guesswork about float precision.

## Ignored
Nothing.
