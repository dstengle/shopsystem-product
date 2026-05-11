# Scenario 2c — subagent report (bad acceptance criteria)

## Setup
- New message (`work_id: lead-002c`): `description: "Add a kelvin conversion to the Temperature class."` plus three deliberately bad acceptance criteria:
  - "Works correctly."
  - "Doesn't break existing tests."
  - "Follows the existing code style."
- Tightened role prompt (same as S2b)

## Outcome
- **Expected:** `clarify` (criteria are present but vague/process-shaped, failing conditions 2 and 3 of the success test)
- **Actual:** `clarify` ✓
- Outbox: `bc-shop/outbox/lead-002c-clarify.yaml`
- Harness validation: parsed cleanly against `Clarify` schema

## Subagent's reasoning (verbatim)
> lead-002c fails three of the four success-test conditions:
> - Condition 2 (measurable): "Works correctly" and "Follows the existing code style" are exactly the vague phrasings the role prompt calls out as not measurable.
> - Condition 3 (defines new behavior, not just constraints): "Doesn't break existing tests" is a constraint. None of the three criteria say what the new kelvin behavior should produce.
> - Condition 4 (description specifies "the thing"): "Add a kelvin conversion to the Temperature class" does not pin a method name, signature, or expected outputs. `to_kelvin()` is a guess from BC code (`to_celsius`, `to_fahrenheit`); the role prompt explicitly rejects pattern-matching from BC code as a substitute for lead intent.

## Notable
The implementer evaluated criterion *quality*, not just criterion *presence*. Three vague platitudes did not satisfy "acceptance criteria are present" in the way the lead might have hoped. This validates that the success test discriminates between compliance-by-presence and compliance-by-substance.

## Stray-state note
At the time of this run, the inbox also contained a leftover `lead-002.yaml` from scenario 2b and the outbox contained the matching `lead-002-clarify.yaml`. The subagent correctly identified that lead-002 was already responded to and addressed only lead-002c. (A symptom of cleanup-between-scenarios discipline, not of the catalog.)
