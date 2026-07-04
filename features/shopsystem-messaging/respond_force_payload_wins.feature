@bc:shopsystem-messaging @origin:lead-2id
Feature: shop-msg respond --force makes the new payload the surviving response (lead-2id fidelity)

  # The defect that motivated lead-2id was that the degraded response stayed
  # delivered and the real one never landed. --force must invert that: after
  # --force, `shop-msg read inbox --lead` returns the NEW payload, not the old.

  @scenario_hash:33663625b12f56fd
  Scenario: respond work_done --force replacement is what read inbox --lead returns
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-f10" has been sent to "shopsystem-messaging"
    And shop-msg respond work_done has been run by "shopsystem-messaging" for work-id "lead-f10" with summary "degraded-original"
    When shop-msg respond work_done --force is run by "shopsystem-messaging" for work-id "lead-f10" with summary "reviewer-approved-real"
    And I run shop-msg read inbox --lead shopsystem-product for work-id "lead-f10"
    Then the command exits zero
    And stdout includes summary "reviewer-approved-real"
    And stdout does not include summary "degraded-original"
