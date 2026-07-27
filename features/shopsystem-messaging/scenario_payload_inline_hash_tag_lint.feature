@bc:shopsystem-messaging @origin:lead-xp2nc
Feature: assign_scenarios pre-send lint — a dispatched scenario's gherkin must carry a matching inline @scenario_hash tag

  Scenario-block-only canonicalization strips tag lines before hashing, so the
  envelope "hash" field still matches a scenario block whose gherkin carries NO
  inline "@scenario_hash:<hex>" tag — and the current ScenarioPayload validation
  therefore accepts a tag-less block (lead-xp2nc). This pins a pre-send lint over
  the assign_scenarios ScenarioPayload: the gherkin block must carry an inline
  "@scenario_hash:<hex>" tag whose value equals the scenario's envelope "hash"
  field. Additive to the ScenarioPayload hash-matches-body invariant
  (scenario_payload_hash_matches_body.feature), which checks the envelope hash
  against the canonicalization but does NOT require the inline tag to be present.

  @scenario_hash:99a9d14a8d859642
  Scenario: assign_scenarios ScenarioPayload validation accepts a scenario whose gherkin carries an inline @scenario_hash tag matching the envelope hash
    Given a scenario gherkin block whose text carries an inline "@scenario_hash:<hex>" tag line directly above its "Scenario:" line
    And a ScenarioPayload envelope "hash" field whose value equals that inline "<hex>"
    When the assign_scenarios ScenarioPayload for that scenario is validated before send
    Then validation accepts the payload
    And the scenario is carried into the dispatched AssignScenarios message unchanged

  @scenario_hash:7d10bea41b0a0291
  Scenario: assign_scenarios ScenarioPayload validation rejects a scenario whose gherkin carries no inline @scenario_hash tag, naming that scenario
    Given a scenario gherkin block whose text contains no "@scenario_hash:" tag line
    And a ScenarioPayload envelope "hash" field equal to the scenario-block-only canonical hash of that gherkin, so the strip-then-hash invariant alone would accept the block
    When the assign_scenarios ScenarioPayload for that scenario is validated before send
    Then validation rejects the payload and no AssignScenarios message is written to the BC inbox
    And the rejection error names the scenario whose gherkin block is missing its inline "@scenario_hash" tag

  @scenario_hash:c51c32eea3d60066
  Scenario: assign_scenarios ScenarioPayload validation rejects a scenario whose inline @scenario_hash tag does not match the envelope hash, naming that scenario
    Given a scenario gherkin block whose text carries an inline "@scenario_hash:<hex>" tag line directly above its "Scenario:" line
    And a ScenarioPayload envelope "hash" field whose value differs from that inline "<hex>"
    When the assign_scenarios ScenarioPayload for that scenario is validated before send
    Then validation rejects the payload and no AssignScenarios message is written to the BC inbox
    And the rejection error names the scenario and reports both the inline-tag "<hex>" value and the disagreeing envelope "hash" value
