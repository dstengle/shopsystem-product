@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg send assign_scenarios — lead-side CLI for assigning scenarios

  @scenario_hash:42d2d64c4e45ca7d
  Scenario: Send assign_scenarios with one scenario
    Given an empty BC at a temporary path
    And a scenario body file containing the text "Scenario: Boiling water in Fahrenheit\n    Given a temperature of 100 degrees Celsius\n    When I convert it to Fahrenheit\n    Then I get 212 degrees Fahrenheit"
    When I run shop-msg send assign_scenarios with work-id "lead-A" and feature-title "Temperature conversion" and bc-tag "temperature" and that scenario file
    Then the BC's inbox contains a file named "lead-A.yaml"
    And the file parses as a valid AssignScenarios with work_id "lead-A" and one scenario whose hash equals the scenarios-hash of the body

  @scenario_hash:2580fb1745b16844
  Scenario: --scenario-file is repeatable for multi-scenario messages
    Given an empty BC at a temporary path
    And a scenario body file containing the text "Scenario: First\n    Given a\n    When b\n    Then c"
    And another scenario body file containing the text "Scenario: Second\n    Given d\n    When e\n    Then f"
    When I run shop-msg send assign_scenarios with work-id "lead-B" and feature-title "Pair" and bc-tag "test" and both scenario files
    Then the BC's inbox contains a file named "lead-B.yaml"
    And the file parses as a valid AssignScenarios with work_id "lead-B" and two scenarios whose hashes are distinct

  @scenario_hash:e8d8c791ce0e0d49
  Scenario: Refuse to overwrite an existing inbox file for the same work_id
    Given an empty BC at a temporary path
    And the BC's inbox already contains a file named "lead-C.yaml"
    And a scenario body file containing the text "Scenario: Anything\n    Given x\n    When y\n    Then z"
    When I run shop-msg send assign_scenarios with work-id "lead-C" and feature-title "X" and bc-tag "test" and that scenario file
    Then the command exits non-zero
    And the BC's inbox file "lead-C.yaml" is unchanged
