@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg send assign_scenarios produces gherkin with @bc tag

  @scenario_hash:dc1d241fba5d486d
  Scenario: shop-msg send assign_scenarios produces gherkin with @bc tag
    Given an empty BC at a temporary path
    And a scenario body file containing the text "Scenario: X\n    Given foo\n    When bar\n    Then baz"
    When I run shop-msg send assign_scenarios with work-id "lead-tag-A" and feature-title "T" and bc-tag "shop-msg" and that scenario file
    Then the BC's inbox file contains a gherkin string with a line containing "@bc:shop-msg"
