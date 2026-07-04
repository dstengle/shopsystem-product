@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg respond — input validation

  @scenario_hash:564632ae9310058c
  Scenario: Refuse empty work_id
    Given an empty BC at a temporary path
    When I run shop-msg respond clarify with work-id "" and question "real question"
    Then the command exits non-zero
    And the BC's outbox is empty
