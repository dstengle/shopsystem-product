@bc:shopsystem-messaging @origin:lead-e9x
Feature: shop-msg respond mechanism_observation — refuse on lead-inbox collision

  @scenario_hash:16806a4d609d021a
  Scenario: Refuse to overwrite an existing mechanism_observation for the same work_id
    Given an empty BC at a temporary path
    And the lead's inbox already contains a response named "lead-col3-mechanism_observation.yaml"
    When I run shop-msg respond mechanism_observation with work-id "lead-col3" and subject "second subject" and body "Body content of at least fifty characters to satisfy the schema's minimum length constraint."
    Then the command exits non-zero
    And the lead's inbox response "lead-col3-mechanism_observation.yaml" is unchanged
