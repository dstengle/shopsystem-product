@bc:shopsystem-messaging @origin:lead-e9x
Feature: BC responses route to the lead inbox — Brief 006 scope C, D, E (lead-e9x)

  @scenario_hash:f182b6f7d5de6662
  Scenario: BC respond work_done delivers the response to the lead inbox
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-901" has been sent to "shopsystem-messaging"
    When shop-msg respond work_done is run by "shopsystem-messaging" for work-id "lead-901"
    Then the command exits zero
    And shop-msg pending inbox --lead shopsystem-product includes work-id "lead-901"

  @scenario_hash:1de11038b968b967
  Scenario: BC respond work_done response appears in the lead inbox via read inbox --lead
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-902" has been sent to "shopsystem-messaging"
    And shop-msg respond work_done has been run by "shopsystem-messaging" for work-id "lead-902"
    When I run shop-msg read inbox --lead shopsystem-product for work-id "lead-902"
    Then the command exits zero
    And stdout includes message_type "work_done" and work_id "lead-902"

  @scenario_hash:58af16b95c5fd8f8
  Scenario: shop-msg watch --lead fires when a BC executes shop-msg respond
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-903" has been sent to "shopsystem-messaging"
    And shop-msg watch --lead shopsystem-product is running and has completed its startup drain
    When shop-msg respond work_done is run by "shopsystem-messaging" for work-id "lead-903"
    Then shop-msg watch --lead outputs exactly one line to stdout for work_id "lead-903"
    And no additional output line arrives within 2 seconds
