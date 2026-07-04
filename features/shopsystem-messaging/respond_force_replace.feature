@bc:shopsystem-messaging @origin:lead-2id
Feature: shop-msg respond --force replaces an existing lead-inbox response (lead-2id recovery path)

  # lead-2id: a BC that emitted a degraded response and tried to recover via
  # `consume outbox` + re-`respond` was rejected with CollisionError because the
  # lead-inbox row survives. --force is the opt-in recovery affordance: it DELETEs
  # the existing (bc=lead_root, direction='inbox', work_id, message_type) row in
  # the same transaction as the replacement INSERT.

  @scenario_hash:608873365b92b50d
  Scenario: respond work_done --force succeeds when a prior work_done lead-inbox row exists
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-f01" has been sent to "shopsystem-messaging"
    And shop-msg respond work_done has been run by "shopsystem-messaging" for work-id "lead-f01"
    When shop-msg respond work_done --force is run by "shopsystem-messaging" for work-id "lead-f01" with summary "forced-replacement"
    Then the command exits zero

  @scenario_hash:399c36167e10f471
  Scenario: respond clarify --force succeeds when a prior clarify lead-inbox row exists
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-f02" has been sent to "shopsystem-messaging"
    And shop-msg respond clarify has been run by "shopsystem-messaging" for work-id "lead-f02" with question "first question"
    When shop-msg respond clarify --force is run by "shopsystem-messaging" for work-id "lead-f02" with question "second question"
    Then the command exits zero

  @scenario_hash:3d85417a21ba4db0
  Scenario: respond mechanism_observation --force succeeds when a prior mechanism_observation lead-inbox row exists
    Given "shopsystem-product" is registered as the lead shop
    And "shopsystem-messaging" is registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-f03" has been sent to "shopsystem-messaging"
    And shop-msg respond mechanism_observation has been run by "shopsystem-messaging" for work-id "lead-f03" with subject "first subject"
    When shop-msg respond mechanism_observation --force is run by "shopsystem-messaging" for work-id "lead-f03" with subject "second subject"
    Then the command exits zero
