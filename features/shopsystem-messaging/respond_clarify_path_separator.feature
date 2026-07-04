@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg respond — input validation

  @scenario_hash:6ab8e9d72c4732a4
  Scenario: Refuse work_id containing a path separator
    Given an empty BC at a temporary path
    When I run shop-msg respond clarify with work-id "../escape" and question "anything"
    Then the command exits non-zero
    And the BC's outbox is empty
