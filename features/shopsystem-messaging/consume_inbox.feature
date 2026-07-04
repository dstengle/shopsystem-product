@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg consume inbox

  @scenario_hash:c4dbfe1cd31d0aea
Scenario: Consuming a lead inbox message removes it from the pending list
  Given "shopsystem-product" is registered in the messaging registry as the lead shop
  And a message addressed to "shopsystem-product" with work-id "lead-204" is present in the lead inbox
  When I run shop-msg consume inbox --lead shopsystem-product with work-id "lead-204"
  Then the command exits zero
  And shop-msg pending inbox --lead shopsystem-product does not include work-id "lead-204"
