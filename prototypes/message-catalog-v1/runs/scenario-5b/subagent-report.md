# Scenario 5b — Implementer + Reviewer for new capability

## Setup
- Same slice 4 setup as 5a, with the scenario corrected to include an
  explicit `When` step.
- Scenario: "First is hotter than second" — Given temp 100°C, And another
  50°C, When I compare the first to the second, Then the first is hotter.
- Hash: `2b0a32d9d2d7c63d`.
- BC starts with stripped `conftest.py` (no step defs) and no `is_hotter_than`
  capability.

## Run sequence
1. Lead emits `assign_scenarios` (work_id: lead-005).
2. **Implementer dispatched.** Sufficiency check passed. Implementer:
   - Wrote `features/temperature_comparison.feature` preserving tags.
   - Added step definitions to `tests/conftest.py` (parameterized Givens
     for first/second temperature, When for compare, Then for hotter).
   - Implemented `Temperature.is_hotter_than(other) -> bool` as
     `self.celsius > other.celsius`.
   - Ran BDD: 6 passed, 0 failed.
   - Did NOT write to outbox (as instructed; Reviewer holds gate).
3. **Reviewer dispatched.** Re-ran BDD (6/0). Adversarially probed.

## Reviewer outcome
- **Emitted `clarify`** to lead with a proposed scenario tightening.
- Outbox: `bc-shop/outbox/lead-005-clarify.yaml`
- Probes considered:
  - *Hard-coded shortcut?* No — `>` generalizes properly. Dismissed.
  - *Equality boundary (a == b).* **Real gap.** Both `>` and `>=` pass the
    assigned scenario; lead has not pinned which contract `is_hotter_than`
    encodes (strict vs at-least-as). Escalated.
  - *Reverse case (50 vs 100).* Worth pinning but partially constrained by
    the method name. Mentioned as secondary in the clarify.
  - *Step-def hygiene.* Distinct phrasings, distinct fixtures, no exception
    swallowing, no state leakage. Clean.

## Reviewer's clarify (excerpt)
> The assigned scenario pins only the strictly-hotter case. The current
> implementation (`self.celsius > other.celsius`) returns False at equality;
> `>=` would return True. Both pass the assigned scenario but encode
> different contracts. A future refactor could flip the operator without
> any test failing.
>
> Proposed scenario tightening:
>
>     Scenario: Equal temperatures — neither is hotter
>       Given a temperature of 50 degrees Celsius
>       And another temperature of 50 degrees Celsius
>       When I compare the first to the second
>       Then the first is not hotter than the second

## What this validated
- The Implementer + Reviewer split is operationalizable: Implementer does
  work + holds back from the outbox; Reviewer is the sole writer.
- The §4.4 loop is real: Reviewer found a scenario gap not covered by the
  assigned Gherkin and escalated as `clarify` with a concrete proposed
  tightening — exactly the spec's "Reviewer finds gap → `clarify` → PO
  decides → `request_bugfix` with tightened scenario" path.
- The Implementer correctly wrote both step definitions and new BC
  capability from scratch (no pre-wiring this time).
- The BDD run was a real gate, not a claim — both Implementer and Reviewer
  ran it, and the Reviewer's re-run was a meaningful verification of the
  Implementer's claim.

## Open items surfaced
- **Outbox naming convention** was implicit. Reviewer wrote `lead-005.yaml`
  rather than `lead-005-clarify.yaml`. Fixed by adding explicit naming
  guidance to `bc_reviewer_prompt.md`.
- **Multi-pass review loop** was deferred. The Reviewer's outcome here was
  a scenario gap (clarify path), so no implementer iteration was needed.
  The implementation-gap path remains untested in this slice.
- **Sufficiency-check strictness for Gherkin** (Given/When/Then required vs
  Given/Then optional) — see scenario-5a finding. Worth revisiting if the
  catalog is intended to admit pure-predicate scenarios.
