@bc:shopsystem-messaging @origin:adr-019
Feature: ScenarioPayload hash-matches-body schema constraint

  @scenario_hash:4a43ba52eaa6f4f6
  Scenario: ScenarioPayload with hash matching the gherkin canonicalization is accepted
    Given a gherkin body that contains a "@bc:test" tag line
    And a hash value equal to the canonical scenario-hash of that gherkin
    When I construct a ScenarioPayload with that hash and that gherkin
    Then construction succeeds and the parsed model has the gherkin and hash intact

  @scenario_hash:fa67a12b4a820e29
  Scenario: ScenarioPayload with hash not matching the gherkin canonicalization is rejected
    Given a gherkin body that contains a "@bc:test" tag line
    And a hash value that does not equal the canonical scenario-hash of that gherkin
    When I construct a ScenarioPayload with that hash and that gherkin via Pydantic
    Then Pydantic raises ValidationError
    And the error message identifies that the hash does not match the gherkin body

  @scenario_hash:75e928d92ecf14ef
  Scenario: shop-msg send assign_scenarios continues to produce ScenarioPayloads whose hash matches the body
    Given a scenario body file containing well-formed Gherkin steps
    When I invoke "shop-msg send assign_scenarios" with that scenario file
    Then the resulting inbox YAML deserializes into an AssignScenarios message
    And each ScenarioPayload in that message satisfies the schema-level hash-matches-body invariant
