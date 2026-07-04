@bc:shopsystem-scenarios @origin:lead-xn9
Feature: shopsystem-scenarios — canonicalization and CLI contracts

  @scenario_hash:fb0d9cb3f8384a32
  Scenario: the canonical hash for a known reference scenario does not drift
  Given the reference Gherkin body "Scenario: Boiling water in Fahrenheit\n    Given a temperature of 100 degrees Celsius\n    When I convert it to Fahrenheit\n    Then I get 212 degrees Fahrenheit"
  When I compute the canonical hash of that body
  Then the hash is "3f123ba774758ff2"
