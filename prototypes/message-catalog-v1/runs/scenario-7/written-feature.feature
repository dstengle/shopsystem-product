Feature: shop-msg respond — refuse on outbox collision

  @scenario_hash:b6973413b7bfdd12 @bc:shop-msg
  Scenario: Refuse to overwrite an existing clarify for the same work_id
    Given an empty BC at a temporary path
    And the BC's outbox already contains a file named "lead-001-clarify.yaml"
    When I run shop-msg respond clarify with work-id "lead-001" and question "second"
    Then the command exits non-zero
    And the BC's outbox file "lead-001-clarify.yaml" is unchanged
