@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg respond — input validation

  @scenario_hash:9563c33a653afed7
  Scenario: Refuse empty question
    Given an empty BC at a temporary path
    When I run shop-msg respond clarify with work-id "lead-001" and question ""
    Then the command exits non-zero
    And the BC's outbox is empty
