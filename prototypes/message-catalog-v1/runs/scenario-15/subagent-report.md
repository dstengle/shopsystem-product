# Scenario 15 — schema-level `@bc:` tag enforcement on ScenarioPayload (with full §4.4 loop)

## Setup
- `request_bugfix` (work_id: lead-016) carrying three scenarios for schema-level `@bc:` tag enforcement on ScenarioPayload:
  - hash `e02b6616fafa3258` — happy path: payload with `@bc:` tag accepted
  - hash `80db3cb3ff18911e` — error path: payload without `@bc:` tag rejected
  - hash `dc1d241fba5d486d` — integration: shop-msg send produces gherkin with the tag
- Vehicle: `request_bugfix` (tightening unpinned existing behavior — every payload already has `@bc:` tags by convention; this slice pins what was implicit). Per memory `shop-system-message-type-selection`. Same shape as S8 (Clarify input validation).
- This slice was the answer to a process-level observation after S14: a number of patterns drifting at slice-level were catalog-message concerns, not role-template concerns. Schema-level enforcement is the right home; the role templates should stay focused on role discipline.
- Pre-state: 21 shop-msg-bc + 6 bc-shop + 6 scenarios. Catalog had no test suite yet.

## Run sequence — first leg

1. **Implementer dispatched against lead-016.** Sufficiency check passed.
   - **`catalog/src/catalog/schemas.py`**: added `@model_validator(mode="after")` on ScenarioPayload using `re.compile(r"@bc:\S+").search(self.gherkin)`. Raises `ValueError` (Pydantic wraps to `ValidationError`) when no match.
   - **NEW: `catalog/tests/test_scenario_payload.py`** — first test suite for the catalog package. Four direct unit tests: tag-anywhere-accepted, missing-tag-rejected, anywhere-in-text-also-accepted (loose), empty-name-after-`@bc:`-rejected (via `\S+`).
   - **`shop-msg-bc/features/send_assign_scenarios_bc_tag.feature`** — integration scenario 3, with new step def `inbox_file_gherkin_contains` (splits gherkin on lines, substring-checks each).
   - All four suites green: 22 shop-msg-bc + 4 catalog + 6 scenarios + 6 bc-shop.

2. **Reviewer dispatched against lead-016.** Re-ran all four suites; probed adversarially; **escalated `clarify`** to lead.

## Reviewer outcome (lead-016) — scenario gap

The validator regex `r'@bc:\S+'` with `.search()` accepts any substring match in the gherkin string — including `@bc:fake` inside a step's quoted content (e.g., `Given the file mentions "@bc:fake" in passing`). Reviewer demonstrated empirically. Scenario 2 only pins the no-`@bc:`-anywhere case; the in-step-text false-acceptance case is unpinned, so a future relaxation could silently change behavior.

Reviewer proposed: a scenario where `@bc:foo` appears only inside a step's quoted content (no real tag line) → ValidationError.

## Run sequence — second leg (§4.4 closure)

3. **Lead emitted `request_bugfix`** (work_id: lead-017) carrying the Reviewer's proposed tightening. Sent via `shop-msg send request_bugfix`.

4. **Implementer dispatched against lead-017.** Sufficiency met. Replaced the regex-search validator with a line-by-line scan: `gherkin.splitlines()` → for each line, `line.split()` (splits on any whitespace) → check whether any token matches anchored `^@bc:\S+$`. Quote characters in step text bind to the token (yielding `"@bc:fake"` which fails the anchor). Choice rationale: most explicit encoding of "tag-line carries `@bc:<name>` as a whitespace-bounded token"; mirrors how pytest-bdd tag lines are actually shaped.
   - **NEW test in `catalog/tests/test_scenario_payload.py`** — `test_bc_tag_inside_step_quoted_content_is_rejected` (hash `b3d95e2ac7a722e2`).
   - All four suites green: 22 + 5 + 6 + 6.
   - Spot-checked all 17 historical `runs/scenario-*/inbox.yaml` files — all valid under tightened schema.

5. **Reviewer dispatched against lead-017.** Re-ran all four suites; probed counterfactually; signed off.

## Reviewer outcome (lead-017)

- **Sign-off** via `shop-msg respond work_done` with all 22 currently-pinned shop-msg-bc scenario hashes echoed (1 new + 21 pre-existing). The catalog tests are not BDD scenarios with hashes; not echoed.
- Probes:
  - **Counterfactual**: pre-fix `.search` would match the new fixture's quoted `@bc:fake"` token; post-fix tokenization rejects it. Real tightening, not a no-op.
  - **Tabs / CRLF / unicode whitespace**: `splitlines()` + bare `str.split()` handle all.
  - **Trailing punctuation** (`@bc:foo,`): would be rejected. Surveyed every historical YAML/feature file — every `@bc:` appears as a bare token. No regression.
  - **Gherkin comment line** (`# ... @bc:fake`): would be ACCEPTED because `#` and `@bc:fake` tokenize separately. Real loosening, but no historical scenario uses gherkin comments AND a prior `test_bc_tag_anywhere_in_gherkin_is_sufficient` deliberately pins the "any line" looseness. Defensible deferral, not escalated.

## What this validated

- **The prototype's third full §4.4 loop closure** (S6→S7, S14, S15). Three closures is enough to call it a reproducible mechanism — the role-template architecture produces this loop without bespoke handling for any of the rounds. Each closure's specifics differ (collision-refuse on respond clarify, schema-validation tightening on read outbox, regex line-anchor tightening on schema validator), but the SHAPE is uniform: assign_scenarios/request_bugfix → Implementer → Reviewer probe → either sign-off OR clarify with proposed tightening → request_bugfix → Implementer → Reviewer signs-off.
- **The catalog package gets its first test suite.** Until S15 the catalog had no tests — its schemas were exercised indirectly through shop-msg-bc's BDD. The schema-level constraint added here changes that calculus: the SUT for two of the three new scenarios is the schema itself, not the CLI. Tests where they belong (Implementer's call: `catalog/tests/`).
- **Schema-level enforcement is the right home for tag-discipline invariants.** This was the slice's process-level proposition — many of the patterns I'd been considering for role-template promotion were catalog/scenarios-package concerns. Now demonstrated: schema constraint on ScenarioPayload catches every construction site for free; no template language needed.
- **The Reviewer's adversarial probe is doing real work, twice over.** Lead-016's Reviewer found a regex-search gap that no scenario pinned. The same Reviewer-class (separate dispatch instance) on lead-017 then probed the tightened version, found another loosening (gherkin-comment lines), and chose to defer it explicitly with reasoning. This is exactly the role-template's anti-rationalization in both directions: ask when the gap is real (lead-016 escalation), don't ask when the deferral is defensible (lead-017 sign-off).

## Cumulative state after slice 15

- **shop-msg-bc:** 22 scenarios passing (+1 from S15 first leg integration check; the lead-017 follow-up's new test went into catalog, not shop-msg-bc).
- **catalog:** 5 tests passing (NEW package test suite this slice — 4 from first leg + 1 from §4.4 follow-up).
- **scenarios:** 6 tests passing.
- **bc-shop:** 6 tests passing.
- **shop-msg CLI surface:** unchanged from S14.
- **scenarios CLI surface:** unchanged from earlier.
- **Catalog message types exercised end-to-end:** `request_maintenance`, `assign_scenarios`, `request_bugfix`, `clarify`, `work_done`.
- **Catalog message types still unexercised:** `request_shop_card`, `request_scenario_register` (closed-as-deferred during P3 triage on 2026-05-10).
- **Open deferred items** (post-P3-triage):
  - Hash↔body invariant constraint on ScenarioPayload (S15 dispatch noted as deferred — needs scenarios-as-Pydantic-time-dependency or callable-validator).
  - Cross-shop @bc:tag ↔ dispatch-target consistency (the @bc: tag could disagree with the BC the message is being sent to; orthogonal invariant).
  - `shop-msg read inbox` (BC-side counterpart) — separate slice if/when needed.
  - Two P4: transport choice (`ddd-product-system-2tf`), audit-beyond-scenario-register (`ddd-product-system-udi`).
