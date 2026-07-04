@bc:shopsystem-messaging @origin:brief-001 @service:postgres
Feature: shop-msg prime --lead — lead shop context priming

  @scenario_hash:bfe9b4175596ef4b
  Scenario: shop-msg prime --lead exits zero and reports DB reachability when the database is reachable
  Given a registered lead shop at a temporary path
  And the environment variable SHOPMSG_DSN is set to a reachable Postgres instance
  When I run shop-msg prime --lead <name> for the registered lead shop
  Then the command exits zero
  And stdout contains "DB reachable: yes"

  @scenario_hash:289567739ad4bd02
  Scenario: shop-msg prime --lead output includes pending outbox count
  Given a registered lead shop at a temporary path
  And two BC outbox rows are present in Postgres for that lead shop, both unconsumed
  When I run shop-msg prime --lead <name> for the registered lead shop
  Then the command exits zero
  And stdout contains "Pending outbox responses: 2"

  @scenario_hash:0c1ecd9b9127edfa
  Scenario: prime --lead directs the lead to send/nudge/consume and does not advertise lead-side respond
    Given a lead shop named "shopsystem-product"
    When the operator runs "shop-msg prime --lead"
    Then the key commands section lists "shop-msg send" for assign_scenarios, request_bugfix, request_maintenance, request_scenario_register, and request_shop_card
    And the key commands section lists "shop-msg nudge" and "shop-msg consume"
    And the output does not advertise "shop-msg respond clarify", "shop-msg respond work_done", or "shop-msg respond mechanism_observation" as lead-side commands
    And the output states that the lead answers a BC clarify by re-dispatch on a fresh lead bead, not by respond

  @scenario_hash:148a803126ad2fd0
  Scenario: shop-msg prime --lead exits non-zero with an error message when the lead name is not registered
  Given no lead shop named "ghost-lead" is registered in the shop registry
  When I run shop-msg prime --lead ghost-lead
  Then the command exits non-zero
  And stderr contains "ghost-lead"
