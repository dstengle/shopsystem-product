@bc:shopsystem-scenarios @origin:lead-vy9b
Feature: shopsystem-scenarios — canonicalization and CLI contracts

  @scenario_hash:343d40afab7f3382
  Scenario: scenarios count prints the number of scenarios in a feature file
    Given a feature file containing two scenarios
    When I run "scenarios count" against that feature file
    Then the exit code is 0
    And stdout is the single line "2"
    And stderr is empty
