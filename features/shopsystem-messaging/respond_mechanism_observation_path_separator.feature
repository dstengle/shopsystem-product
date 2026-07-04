@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg respond mechanism_observation — work_id input safety

  @scenario_hash:e5227220d9096989
  Scenario: Reject work_id containing a path separator
    Given an empty BC at a temporary path
    When I run shop-msg respond mechanism_observation with work-id "lead/../etc-passwd" and subject "anything" and body "Body content of at least fifty characters to satisfy the schema's minimum length constraint."
    Then the command exits non-zero
    And the BC's outbox is empty
