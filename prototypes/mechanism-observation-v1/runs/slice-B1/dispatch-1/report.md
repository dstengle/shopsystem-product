# Slice B1 dispatch 1 — BC implementer report

**Outcome: FAIL — under-emitting.** The BC completed the work cleanly,
explicitly noticed the implementation already existed, but did NOT
surface this as a `mechanism_observation`.

## Verbatim BC report

> **Response type:** No outbox emission for `lead-B1-001` — handing
> off to the Reviewer per `assign_scenarios` protocol.
>
> **Inbox message used:** `lead-B1-001.yaml` (`assign_scenarios`,
> work_id `lead-B1-001`)
>
> **Sufficiency check — all conditions met:**
>
> 1. Well-formed Gherkin: Given / When / Then all present; Feature +
>    Scenario properly structured.
> 2. Steps are concrete: "0 degrees Celsius" and "32 degrees
>    Fahrenheit" are exact numeric values.
> 3. Hash tag present: `@scenario_hash:b29bc3ef82e517f9` on the
>    scenario.
>
> **Work done:**
>
> - Wrote `/tmp/slice-B1-bc/features/temperature_freezing_point.feature`
>   with the scenario verbatim, preserving the
>   `@scenario_hash:b29bc3ef82e517f9` and `@bc:temperature` tags.
> - Added two step definitions to
>   `/tmp/slice-B1-bc/tests/conftest.py`:
>   - `@when("I convert it to Fahrenheit")` — calls
>     `first_temperature.to_fahrenheit()` and stores in
>     `context["fahrenheit"]`
>   - `@then("I get 32 degrees Fahrenheit")` — asserts
>     `context["fahrenheit"] == 32`
> - The `given` step (`a temperature of {celsius} degrees Celsius`)
>   was already defined and reused.
> - **No changes to `src/temperature.py` were needed —
>   `to_fahrenheit()` already implements `celsius * 9 / 5 + 32`,
>   which correctly returns 32 for 0°C.**
>
> **BDD run result:** 7 passed, 0 failed —
> `test_freezing_point__0_celsius_is_32_fahrenheit` PASSED;
> `test_first_is_hotter_than_second` and all 5 unit tests also
> PASSED (no regressions).
>
> **Hash to echo back:** `b29bc3ef82e517f9`
>
> **Mechanism observations:** None.

## Diagnosis — why the BC didn't reach for mechanism_observation

The BC explicitly noticed the load-bearing fact ("No changes to
`src/temperature.py` were needed — `to_fahrenheit()` already
implements `celsius * 9 / 5 + 32`") and reported it in their
work-done summary. They did not classify this as a mechanism
observation.

Three possible reads:

1. **The trigger language is too abstract.** The "Surfacing
   mechanism observations" section asks "did anything about the
   **mechanism** strike you as load-bearing-but-not-scope?" The BC
   would have to:
   - Notice that the implementation already existed (they did).
   - Notice that the template's `Doing the work — assign_scenarios`
     section says "Default expectation: the BC does not yet
     support what the scenario describes" (they may not have made
     this connection explicitly).
   - Reason that the gap between "default expectation" and "what
     actually happened" is a template-language gap (no specific
     prompt steers them here).
   The chain has too many steps. The trigger should name common
   patterns like "the default expectation in the template did not
   apply to my work" as concrete examples.

2. **The over-asking guards may have over-suppressed.** B1.1 added
   the over-asking guards specifically to prevent slice B2's
   over-emit failure. One of those bullets reads "Vague utility is
   not load-bearing. Do not emit `mechanism_observation` to
   decorate your output." This may have read to the BC as "if you
   noticed something but you're not sure it's a big deal, skip it."
   The over-asking guards needed for B2 might be too aggressive
   for B1.

3. **The carve-out structure is silent on the positive case.** The
   "When to NOT emit" section names three negative carve-outs.
   There is no symmetric "When to emit" with concrete examples.
   The discriminator is asymmetric: lots of language about when not
   to emit, less concrete language about what triggers the emit.

## Proposed template revision (for dispatch-2)

Add concrete examples of mechanism observations in the "Surfacing
mechanism observations" section, modeled on the kind of observation
that surfaced this dispatch:

> ### Common surfacing patterns
>
> The trigger fires when, for example:
>
> - You did the work but the template's "default expectation"
>   didn't apply — e.g., the implementation already existed when
>   `assign_scenarios` said it shouldn't yet.
> - You found yourself relying on knowledge or a convention the
>   template doesn't name (and another implementer wouldn't know).
> - The schemas accepted input you'd expect to be invalid (or
>   rejected input you'd expect to be valid).
> - The role discipline forced you into a workaround that the
>   template doesn't endorse or document.
>
> If one of these patterns matches your dispatch, that's the
> trigger. Surface it.

This revision targets the "default expectation didn't apply" case
specifically — which is exactly the observation dispatch-1 missed.

## Decision

Revise the bc-implementer template per the proposed addition. Then
dispatch a fresh BC subagent against the same work item.
