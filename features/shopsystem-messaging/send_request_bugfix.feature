@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg send request_bugfix — lead-side CLI for the bugfix message

  @scenario_hash:ed957587a564b1d8
  Scenario: Send request_bugfix with description only
    Given an empty BC at a temporary path
    When I run shop-msg send request_bugfix with work-id "lead-A" and description "Fix the thing."
    Then the BC's inbox contains a file named "lead-A.yaml"
    And the file parses as a valid RequestBugfix with work_id "lead-A", description "Fix the thing.", and no scenarios

  @scenario_hash:1e7881f9232bc0b1
  Scenario: Send request_bugfix with one tightening scenario
    Given an empty BC at a temporary path
    And a scenario body file containing the text "Scenario: Tightened\n    Given a\n    When b\n    Then c"
    When I run shop-msg send request_bugfix with work-id "lead-B", description "Tighten case.", feature-title "Tightening", bc-tag "test", and that scenario file
    Then the BC's inbox file "lead-B.yaml" parses as a valid RequestBugfix with description "Tighten case." and one scenario whose hash equals the scenarios-hash of the body

  @scenario_hash:677d20154e364482
  Scenario: Refuse to overwrite an existing inbox file for the same work_id
    Given an empty BC at a temporary path
    And the BC's inbox already contains a file named "lead-C.yaml"
    When I run shop-msg send request_bugfix with work-id "lead-C" and description "second"
    Then the command exits non-zero
    And the BC's inbox file "lead-C.yaml" is unchanged
