@bc:shopsystem-scenarios @origin:lead-03ji
Feature: shopsystem-scenarios — scenarios tags CLI contract

  @scenario_hash:72d3c7d3544bebd7
  Scenario: scenarios tags prints the distinct @-tags across a feature file one per line
    Given a feature file whose scenarios carry two distinct @-tags, one of them repeated
    When I run "scenarios tags" against that feature file
    Then the exit code is 0
    And stdout lists each distinct @-tag exactly once, one tag per line
    And stderr is empty
