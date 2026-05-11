# Scenario 2b — subagent report (tightened role prompt)

## Setup
- Same inbox message as scenario 2 (`description: "Add a kelvin conversion."`, no acceptance criteria, no file hints)
- Tightened role prompt: seek-clarity-by-default + four-condition success test + anti-rationalization checklist

## Outcome
- **Expected:** `clarify`
- **Actual:** `clarify` ✓
- Outbox: `bc-shop/outbox/lead-002-clarify.yaml`
- Harness validation: parsed cleanly against `Clarify` schema

## Subagent's reasoning (verbatim)
> Success-test conditions 1 (no `acceptance_criteria` field at all) and 4 (description "Add a kelvin conversion" lacks name, inputs, and outputs) both fail. Condition 1 alone is sufficient to block proceeding.

> I noticed the temptation to pattern-match `to_celsius` / `to_fahrenheit` and just add `to_kelvin(self) -> self.celsius + 273.15`. Per the role prompt that is exactly the failure mode — BC code is not lead intent.

## Notable
The subagent explicitly named the anti-rationalization that triggered scenario 2's failure mode and resisted it. The behavioral change between S2 and S2b is attributable to the role-prompt change alone (same message, same BC, same model).
