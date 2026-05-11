# Scenario 16 — first lead-architect dispatch + ScenarioPayload hash↔body invariant

## Setup
- **First slice where the Architect role was a dispatched subagent** rather than driver-orchestrator. The lead-architect subagent fetched its role prompt via `shop-templates show lead-architect`, applied the message-type-selection discriminator, composed via `shop-msg send`, and reported. Same trajectory the BC templates traveled.
- Stakeholder/PO intent supplied to the Architect: catalog's ScenarioPayload accepts mismatched (hash, gherkin) pairs without verification; we want this consistency guaranteed at the catalog layer.
- The Architect, NOT the driver-orchestrator, picked the vehicle: `request_bugfix` (work_id lead-018) per Q1+Q2 of the discriminator (capability exists in the loose sense; no scenario pins the consistency).
- Pre-state: shop-msg-bc 22 + catalog 5 + scenarios 6 + bc-shop 6 + shop-templates 36 = 75 tests across five packages.

## Run sequence

1. **Lead-architect dispatched.** Fetched role prompt via `shop-templates show lead-architect`. Applied the discriminator question-by-question, picked `request_bugfix` (Q1: capability exists in loose sense; Q2: no scenario pins the consistency at the schema layer). Wrote three scenario body files to `/tmp/slice16/`, composed via `shop-msg send request_bugfix --bc-root shop-msg-bc --work-id lead-018 --description "..." --feature-title "..." --bc-tag shop-msg --scenario-file ... --scenario-file ... --scenario-file ...`. Reported per the template's Reporting back section, citing the Q1+Q2 combined answer that selected the vehicle.
   - Hashes deposited: `4a43ba52eaa6f4f6` (accept-matching), `fa67a12b4a820e29` (reject-mismatched), `75e928d92ecf14ef` (CLI round-trip).

2. **BC Implementer dispatched** via `shop-templates show bc-implementer`. Sufficiency check passed.
   - **Package-boundary resolution**: chose option (b) — duplicate the small canonicalization rule inside catalog as `catalog.schemas._canonical_scenario_hash`. Cross-package agreement pin: `test_canonical_hash_matches_scenarios_package` asserts the same recorded hashes (S4 `3f123ba774758ff2`, S6 `b9ed9c63b8ccb208`) that `scenarios/tests/test_hash.py` pins on the other side.
   - **Integration adaptation (Implementer agency)**: the dispatch description claimed today's `shop-msg send` payloads were internally consistent. They were NOT — the CLI stored `hash=canonical(body)` but `gherkin=wrapped(body)`, and `canonical(wrapped) ≠ canonical(body)`. The Implementer rewrote `_build_scenario_payload` to hash the wrapped gherkin using a sentinel `@scenario_hash:0...0` line that the canonicalization rule drops (placeholder/final swap doesn't perturb the hash). Two existing BDD step defs that asserted `hash == canonical(body)` were updated to `hash == canonical(gherkin)`. Same kind of integration judgment seen in S7 (When-step refactor), S8 (parsers.parse→parsers.re), S11 (`$`-anchoring), and S15 (line-by-line tokenization).
   - **Tests**: catalog 5→8 (+3), shop-msg-bc 22→25 (+3). All five suites green: 25+8+6+6+36 = 81.

3. **BC Reviewer dispatched** via `shop-templates show bc-reviewer`. Re-ran all five suites; probed adversarially; signed off.

## Reviewer outcome (lead-018)

- **Sign-off** via `shop-msg respond work_done` with all 25 currently-pinned shop-msg-bc scenario hashes echoed.
- Probes:
  - **Sentinel-and-swap correctness**: verified end-to-end with a fresh `shop-msg send` — the emitted YAML carries `hash == canonical(gherkin)`; the placeholder/final tag swap doesn't perturb the canonical hash because the canonicalization rule strips every `@scenario_hash:` line unconditionally. Sound.
  - **Historical round-trippability**: 14 of 18 historical `runs/scenario-N/inbox.yaml` files fail the new validator. Root cause: pre-lead-018 CLI stored `hash=canonical(body)` while `gherkin=wrapped(body)` — the exact inconsistency lead-018 closes. **Accepted as a non-regression**: lead-018 is an additive schema tightening; the Implementer correctly adapted the CLI rather than weakening the validator. Historical YAMLs were valid under the prior contract; they are frozen artifacts and don't need to round-trip under the new contract.
  - **Feature-file English drift**: "scenarios-hash of the body" still reads correctly under new semantics; "the body" = the gherkin field. Conftest comments document the interpretation.
  - **Cross-package drift counterfactual**: both `scenarios/tests/test_hash.py` and `catalog/tests::test_canonical_hash_matches_scenarios_package` literal-pin to the same known hashes. Drift in either rule surfaces in both suites.
  - **Step-def quality**: target_fixture scoping clean; explicit `validation_error=None` sentinel; exact CLI-phrase pin; non-brittle substring error-message check.

- **Process finding** (flagged by Reviewer in summary, not as a clarify): the lead-architect's dispatch claim that today's payloads were "internally consistent" was false; the Implementer caught and adapted. Lead-side BC pre-state claims need verification, not assertion.

## What this validated

- **The lead-architect template's discipline works end-to-end on first dispatch.** The discriminator did its job: the Architect ran Q1+Q2 question-by-question and selected `request_bugfix` correctly. Reported which question selected the vehicle, per the template's Reporting back section. This is the role-template version of the memory-mitigated discriminator that's held since S11.
- **The package-boundary tension was a real Implementer-side design call.** The dispatch description listed four resolution options and explicitly delegated to the Implementer ("Resolution is the Implementer's call"). The Implementer picked option (b) with reasoning, added a cross-package agreement pin so drift surfaces in both suites, and the Reviewer probed and confirmed adequacy. This is the right shape for a design tension that crosses package boundaries — the lead names the tension; the BC resolves it.
- **The "lead-side claim about pre-state" failure mode surfaced.** The Architect's dispatch said today's payloads were internally consistent. They weren't. The Architect was running the discriminator template-correctly (Q1+Q2) but hadn't VERIFIED the claim it made about Q1's "loose sense" of capability. This is a real lead-side gap the prototype hasn't surfaced before: discriminator discipline doesn't substitute for empirical verification of the BC's pre-state. The Reviewer flagged this as a process finding. Worth iterating the lead-architect template to require pre-state verification as part of Q1 — e.g., "before answering Q1, demonstrate the failure mode the bugfix would close OR confirm the current behavior empirically."
- **The Implementer's integration agency held.** The dispatch's wrong claim about pre-existing consistency would have made the ADDITIVE constraint un-satisfiable as written. The Implementer modified the CLI to make it satisfiable, rather than weakening the validator. Same pattern of judgment-without-escalation seen in S7, S8, S11, S15. The role-template architecture continues to produce these adaptations.

## Cumulative state after slice 16

- **shop-msg-bc:** 25 scenarios passing (+3 from S16).
- **catalog:** 8 tests passing (+3 from S16).
- **scenarios:** 6 tests passing.
- **bc-shop:** 6 tests passing.
- **shop-templates:** 36 tests passing.
- **TOTAL: 81 tests across 5 packages.**
- **shop-msg CLI surface**: unchanged from S14, plus internal change to `_build_scenario_payload` (hash now matches wrapped gherkin, not body).
- **Lead dispatch**: first slice with Architect as dispatched subagent (rather than driver-orchestrator).
- **Open deferred items**:
  - First dispatch of lead-po template.
  - Iteration to lead-architect template based on S16's process finding: pre-state verification step.
  - Cross-shop @bc:-tag ↔ dispatch-target consistency.
  - shop-msg read inbox (BC-side counterpart).
  - shop-templates render <name> (parameterization).
