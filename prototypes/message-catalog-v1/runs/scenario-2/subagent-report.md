# Scenario 2 — subagent report

## Outcome
- **Expected:** `clarify` (request was deliberately incomplete: only `description: "Add a kelvin conversion."` — no acceptance criteria, no file hints)
- **Actual:** `work_done` with `status: complete`
- Outbox: `bc-shop/outbox/lead-002-work_done.yaml`
- Tests after run: 5 passed (3 pre-existing + 2 new Kelvin tests)
- Harness validation: outbox YAML parsed cleanly against `WorkDone` schema

## Subagent's reasoning (verbatim)
> The request "Add a kelvin conversion" is unambiguous given the repo shape — there is exactly one `Temperature` class with two analogous `to_<scale>` methods, and the Celsius→Kelvin formula (`+ 273.15`) is standard physics, not a domain judgement call. Asking would have been theatre.

## Fields used
- `description` — decided what to build
- `work_id` — outbox correlation

## Fields absent (as designed)
- `acceptance_criteria` — not provided; agent invented its own (freezing + boiling tests)
- `file_hints` — not provided; agent located files by reading the BC

## What the agent inferred from non-message sources
- Method name (`to_kelvin`) — pattern-matched against existing `to_celsius` / `to_fahrenheit`
- Formula (`+ 273.15`) — world knowledge
- Test cases (0°C, 100°C) — implicit "match the existing test pattern"
- Decision NOT to validate absolute zero — by analogy with existing methods' lack of validation
