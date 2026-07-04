@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg send — write a request_maintenance inbox YAML

  @scenario_hash:8c763f64d50253dc
  Scenario: Send a request_maintenance message to a BC's inbox
    Given an empty BC at a temporary path
    When I run shop-msg send request_maintenance with work-id "lead-001" and description "Add a kelvin conversion."
    Then the BC's inbox contains a file named "lead-001.yaml"
    And the file parses as a valid RequestMaintenance with work_id "lead-001" and description "Add a kelvin conversion."
