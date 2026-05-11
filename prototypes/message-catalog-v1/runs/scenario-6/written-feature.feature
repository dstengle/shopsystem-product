Feature: shop-msg respond — write a clarify outbox YAML

  @scenario_hash:b9ed9c63b8ccb208 @bc:shop-msg
  Scenario: Reply to lead with a clarify message
    Given an empty BC at a temporary path
    When I run shop-msg respond clarify with work-id "lead-001" and question "What about equality?"
    Then the BC's outbox contains a file named "lead-001-clarify.yaml"
    And the file parses as a valid Clarify with work_id "lead-001" and question "What about equality?"
