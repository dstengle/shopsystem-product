@bc:shopsystem-messaging @origin:lead-e9x
Feature: shop-msg respond work_done — refuse on lead-inbox collision

  @scenario_hash:c222c26d9ea4ac2b
  Scenario: Refuse to overwrite an existing work_done for the same work_id
    Given an empty BC at a temporary path
    And the lead's inbox already contains a response named "lead-col1-work_done.yaml"
    When I run shop-msg respond work_done with work-id "lead-col1" and status "complete"
    Then the command exits non-zero
    And the lead's inbox response "lead-col1-work_done.yaml" is unchanged
