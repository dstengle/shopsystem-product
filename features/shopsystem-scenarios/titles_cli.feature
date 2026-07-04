@bc:shopsystem-scenarios @origin:lead-af8a
Feature: shopsystem-scenarios — canonicalization and CLI contracts

  @scenario_hash:1e720a791cb52538
  Scenario: scenarios titles prints each scenario's title one per line for a feature file
    Given a feature file containing two scenarios with distinct titles
    When I run "scenarios titles" against that feature file
    Then the exit code is 0
    And stdout's first line is the first scenario's title
    And stdout's second line is the second scenario's title
    And stderr is empty
