@bc:shopsystem-messaging @origin:lead-b3z
Feature: shop-msg respond collision error names the existing message_type and mentions --force (lead-b3z)

  # lead-b3z: the prior collision error named only the work_id. A BC seeing it
  # could not tell which message_type the surviving row was, nor that --force is
  # the recovery path. The upgraded error names the existing row's message_type
  # and references --force.

  @scenario_hash:bebe85d1da935657
  Scenario: collision without --force names the existing message_type and mentions --force
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-f20" has been sent to "shopsystem-messaging"
    And shop-msg respond work_done has been run by "shopsystem-messaging" for work-id "lead-f20"
    When shop-msg respond work_done is run by "shopsystem-messaging" for work-id "lead-f20"
    Then the command exits non-zero
    And stderr includes "work_done"
    And stderr includes "--force"
