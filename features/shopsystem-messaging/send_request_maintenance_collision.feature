@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg send — write a request_maintenance inbox YAML

  @scenario_hash:6f37b1ccd3826bad
  Scenario: Refuse to overwrite an existing inbox file for the same work_id
    Given an empty BC at a temporary path
    And the BC's inbox already contains a file named "lead-001.yaml"
    When I run shop-msg send request_maintenance with work-id "lead-001" and description "second message"
    Then the command exits non-zero
    And the BC's inbox file "lead-001.yaml" is unchanged
