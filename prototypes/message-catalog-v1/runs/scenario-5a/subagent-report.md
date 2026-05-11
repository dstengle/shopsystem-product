# Scenario 5a — Implementer-found sufficiency gap (no When step)

## Setup
- Slice 4 first cut: `assign_scenarios` for new behavior, with the BC's
  pre-wired step definitions stripped from `tests/conftest.py` so the
  Implementer would have to write them.
- Initial scenario was a pure predicate (Given/And → Then), no `When` step.
- Tightened role prompt with `assign_scenarios` sufficiency check
  (well-formed Gherkin = at least one G/W/T).

## Outcome
- **Implementer emitted `clarify`** without doing any work.
- Outbox: `bc-shop/outbox/lead-005-clarify.yaml`
- No work performed; Reviewer was never dispatched (per role prompt:
  "the Reviewer is only dispatched when the Implementer has done work").

## Implementer's reasoning (verbatim)
> The single scenario `0737ea3908cdee30` has Given/And/Then but no When step.
> Without it, the action under test is not pinned by the lead — I'd have to
> invent one (e.g. "compared", "queried", "asked which is hotter"), each of
> which steers the BC's API surface differently.

## Finding
The role prompt's well-formed-Gherkin condition ("at least one Given, at
least one When, at least one Then") is *stricter* than Gherkin itself
(which permits Given/Then for state predicates). The Implementer correctly
applied the stricter rule.

This is a real choice the role-template author makes. The strict version
forces the lead to articulate the action explicitly, which makes step-def
writing cleaner and pins the API surface earlier; the relaxed version
admits more natural-Gherkin scenarios at the cost of step-def ambiguity.
For this prototype we kept the strict version and re-emitted the scenario
with an explicit `When` (see scenario-5b).
