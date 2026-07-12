@bc_internal @bc:shopsystem-messaging @origin:adr-019
Feature: shop-msg computes scenario-block-only canonical hashes (ADR-019)

  The canonical hash text for a scenario block is scenario-block-only: the
  Feature: header line is NOT part of it. There is exactly one canonical
  hash text per scenario block, identical on the dispatched
  scenarios[].hash wire field and the @scenario_hash: tag the BC writes on
  disk for that block (scenario 117 wire/disk equality). The hash is
  computed in-process via scenarios.hash, not by shelling out to a
  `scenarios` binary on PATH.

  @scenario_hash:5b9a8f19802ae15e
  Scenario: dispatched scenario hash equals the scenario-block-only canonical hash
    Given an empty BC at a temporary path
    And a scenario body file containing the text "Scenario: X\n    Given foo\n    When bar\n    Then baz"
    When I run shop-msg send assign_scenarios with work-id "lead-blk-A" and feature-title "Some Feature Title" and bc-tag "shop-msg" and that scenario file
    Then the dispatched scenario's hash equals the scenarios-hash of the scenario-block-only body for bc-tag "shop-msg"
    And the dispatched scenario's hash is independent of the feature title

  @scenario_hash:a927aab99071a688
  Scenario: dispatched gherkin carries no Feature header line
    Given an empty BC at a temporary path
    And a scenario body file containing the text "Scenario: X\n    Given foo\n    When bar\n    Then baz"
    When I run shop-msg send assign_scenarios with work-id "lead-blk-B" and feature-title "Some Feature Title" and bc-tag "shop-msg" and that scenario file
    Then the dispatched scenario's gherkin contains no line starting with "Feature:"

  @scenario_hash:9e9c9ae67254984f
  Scenario: shop_msg computes scenario hashes in-process with no scenarios subprocess
    Then the shop_msg cli module contains no subprocess call to the scenarios hash binary
    And the shop_msg cli module imports parse_then_block_only_hash from scenarios.hash
