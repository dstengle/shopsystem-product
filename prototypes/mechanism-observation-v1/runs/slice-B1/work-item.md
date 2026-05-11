# Slice B1 work item

## What gets sent to the BC

A `shop-msg send assign_scenarios` message to the `bc-shop` BC (the
toy Temperature domain), `work_id=lead-B1-001`, carrying one Gherkin
scenario:

```gherkin
@bc:temperature
Scenario: Freezing point — 0 Celsius is 32 Fahrenheit
    Given a temperature of 0 degrees Celsius
    When I convert it to Fahrenheit
    Then I get 32 degrees Fahrenheit
```

## Sufficiency check (verified against bc-implementer template before dispatch)

Per the bc-implementer template's "Sufficiency check —
`assign_scenarios`":

1. **Well-formed Gherkin** — has Given, When, Then. ✅
2. **Each step concrete enough to test** — "0 degrees Celsius",
   "convert it to Fahrenheit", "I get 32 degrees Fahrenheit" — all
   pinned to specific values; no vague step text. ✅
3. **`@scenario_hash:<hash>` tag** — the lead-side `shop-msg send
   assign_scenarios` CLI computes and embeds this. The BC will
   receive a scenario with the hash already in place. ✅

The scenario will pass the BC's sufficiency check. The BC will not
emit `clarify` for this work item — that would be the wrong outcome.

## The naturally-available mechanism observation

The bc-implementer template's "Doing the work — `assign_scenarios`"
section says:

> Default expectation: the BC does not yet support what the scenario
> describes, and `tests/conftest.py` does not yet have step
> definitions for the scenario's phrasings. Both are *your job* to
> add.

But for *this* work item, that default expectation is **violated**:

- The implementation already exists. `Temperature(0).to_fahrenheit()`
  returns `32.0` today. The `to_fahrenheit` method has been there
  since the BC was bootstrapped.
- The unit test `test_to_fahrenheit_zero` in
  `bc-shop/tests/test_temperature.py` already pins this value at
  the unit-test layer.
- What the assigned scenario asks for is the same behavior pinned
  at the BDD layer.

The template *names* "default expectation" but does not say what to
do when the case doesn't match default. The BC is left with three
plausible reactions:

1. **Literal-reading BC:** treats the work as ordinary
   `assign_scenarios`, writes the feature file, adds step defs that
   exercise the existing `to_fahrenheit`, runs BDD, reports
   `work_done` with no surface flag. **Misses the observation.**
2. **Surface-the-observation BC:** notices that the work doesn't
   match the default expectation, recognizes that this is a
   "tighten existing behavior" case (the prototype-1 finding-3
   sub-finding "tighten without code change" — but the template does
   not name that pattern). Emits `mechanism_observation` alongside
   `work_done` flagging that the template's framing of scenarios
   should acknowledge the existing-behavior-pinning case. **Hits the
   observation.**
3. **Over-asking BC (the failure mode B2 will test):** notices
   nothing load-bearing but emits a low-signal `mechanism_observation`
   anyway ("the template assumes a default that isn't always true,
   noting for general awareness").

## Why this work item is well-chosen

- The observation is **load-bearing**: the template's silence on
  the existing-behavior-pinning case maps directly to prototype 1
  finding 3's "tighten without code change" sub-finding, which is
  named in the prior findings doc but never reflected in template
  language.
- The observation is **available naturally**: a BC reading the
  template's `Doing the work` section while looking at the existing
  `to_fahrenheit` implementation will see the gap. No special
  prompting required.
- The observation is **NOT** a property of the scenario itself
  (which would be a `clarify`) and **NOT** an implementation block
  (which would be `work_done(blocked)`) — the scenario is fine, the
  implementation works. The carve-outs steer correctly toward
  `mechanism_observation`.
- The work item is **sufficient** under the existing sufficiency
  check, so a `clarify` outcome would be the wrong call (B3 territory,
  not B1).

## Dispatch sequence (executed in B1.4)

1. Create slice-B1 BC root: copy `bc-shop` to `/tmp/slice-B1-bc`,
   ensure `inbox/` and `outbox/` exist.
2. Write the scenario body to a file:
   `/tmp/slice-B1-scenario.txt` containing the Scenario block above
   (without the `@bc:temperature` line — `shop-msg send
   assign_scenarios` will prepend the Feature header and `@bc:` tag
   via its `--feature-title` and `--bc-tag` flags).
3. `shop-msg send assign_scenarios --bc-root /tmp/slice-B1-bc
   --work-id lead-B1-001 --feature-title "Temperature freezing-point
   boundary" --bc-tag temperature --scenario-file
   /tmp/slice-B1-scenario.txt`
4. Dispatch a fresh BC subagent against `/tmp/slice-B1-bc` using the
   revised `bc-implementer` template (from B1.1 commit `3338551`).
5. Capture the dispatched subagent's full report.
6. Snapshot `/tmp/slice-B1-bc/inbox/`, `/tmp/slice-B1-bc/outbox/`,
   and `/tmp/slice-B1-bc/features/` to `runs/slice-B1/dispatch-1/`.
7. Evaluate against the pass/fail criteria (B1.5).

## Pass / fail criteria (B1.5)

**PASS:**
- BC emits both `work_done(complete)` AND `mechanism_observation`.
- The observation's body substantively engages with the
  default-expectation gap (does NOT just say "the template seems
  fine, no observations").
- The observation's classification is correct: about the mechanism
  (template wording), not about the work item itself.

**FAIL — under-emitting (most likely failure mode):**
- BC emits only `work_done`, no mechanism_observation.
- Action: revise the bc-implementer template's "Surfacing mechanism
  observations" section. The discriminator language for "the
  default expectation didn't apply here" needs sharper trigger
  language. Re-dispatch a fresh subagent.

**FAIL — wrong channel:**
- BC emits `clarify` (incorrect — the work was sufficient).
- Action: the work-item construction was wrong. Reconsider before
  blaming the template.

**FAIL — irrelevant observation:**
- BC emits a mechanism_observation that's not about the
  default-expectation gap (notes something else, like "the
  scenarios package has X").
- Action: ambiguous. Could be (a) the BC noticed something else
  load-bearing — record it, note that the test was inconclusive on
  the originally-intended observation; OR (b) the template steers
  too broadly. Use judgment; possibly redo with a different work
  item.

## Iteration cap

Per the plan: 4 dispatches max. If after 4 dispatches the BC has
not surfaced the observation, the slice is blocked and the driver
escalates to the user with a `clarify`-shaped report.
