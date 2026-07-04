@bc:shopsystem-messaging @origin:lead-2id
Feature: shop-msg respond --force is scoped per (bc, work_id, message_type) triple (lead-2id default)

  # Criterion 6(iv): --force replaces only the matching message_type's row. A
  # different message_type on the same work_id is untouched, because the SELECT
  # gate and the --force DELETE both key on the full triple.

  @scenario_hash:1fb957942f332206
  Scenario: respond work_done --force leaves a different-message_type lead-inbox row intact
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-f30" has been sent to "shopsystem-messaging"
    And shop-msg respond clarify has been run by "shopsystem-messaging" for work-id "lead-f30" with question "pending clarify"
    And shop-msg respond work_done has been run by "shopsystem-messaging" for work-id "lead-f30"
    When shop-msg respond work_done --force is run by "shopsystem-messaging" for work-id "lead-f30" with summary "forced-work-done"
    Then the command exits zero
    And the lead-inbox clarify response for work-id "lead-f30" still exists
