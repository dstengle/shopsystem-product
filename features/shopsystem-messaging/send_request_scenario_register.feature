@bc:shopsystem-messaging @origin:brief-014
Feature: shop-msg send request_scenario_register — deposit a scenario-register request into a target BC's inbox

  The send-vehicle family already deposits lead->BC dispatches into a target
  BC's inbox; this pins the request_scenario_register send subcommand. It names
  the target bounded context whose register is sought, accepts an optional
  narrowing selector (a feature-area surface or an explicit set of block-only
  canonical hashes), and deposits exactly one well-formed
  request_scenario_register validating against the RequestScenarioRegister
  schema — carrying no register entry of its own, and treating omitted
  narrowing as the target BC's full register.

  @scenario_hash:7bc14b8a649e1868
  Scenario: shop-msg send request_scenario_register deposits a well-formed request naming the target bounded context with optional narrowing
    Given an empty BC at a temporary path with no unprocessed inbox messages
    When shop-msg send request_scenario_register is run for work-id "lead-400" naming target bounded context "shopsystem-templates" and supplying a narrowing selector confining the request to feature-area surface "approve-claude"
    Then the inbox holds exactly one unprocessed request_scenario_register message for work_id "lead-400"
    And that deposited message validates against the RequestScenarioRegister request schema and names target bounded context "shopsystem-templates"
    And the deposited message carries the supplied narrowing selector and no register entry of its own
    And shop-msg send request_scenario_register run with no narrowing selector instead deposits a valid request denoting the target bounded context's full register

  @scenario_hash:da255854d5d933f5
  Scenario: shop-msg send request_scenario_register deposits a well-formed JSON-serializable request when narrowed to an explicit set of block-only canonical hashes
    Given an empty BC at a temporary path with no unprocessed inbox messages
    When shop-msg send request_scenario_register is run for work-id "lead-401" naming target bounded context "shopsystem-templates" and supplying a narrowing selector confining the request to an explicit set of three block-only canonical hashes "d8422606299d8819", "74d0086b73d4e477" and "e59b29a6fc34f60a"
    Then the inbox holds exactly one unprocessed request_scenario_register message for work_id "lead-401"
    And that deposited message serialized without error and validates against the RequestScenarioRegister request schema and names target bounded context "shopsystem-templates"
    And the deposited message carries the supplied narrowing selector as a JSON-serializable list of exactly those three block-only canonical hashes and no register entry of its own
