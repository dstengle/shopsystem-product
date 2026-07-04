@bc:shopsystem-messaging @origin:lead-e9x
Feature: BC emits cross-type multi-response for same work_id

  @scenario_hash:6a248f3acc515bb3
  Scenario: A BC emitting both work_done and mechanism_observation for the same work_id delivers both responses to the lead inbox
  Given "shopsystem-product" is registered as the lead shop
  And "shopsystem-messaging" is registered in the messaging registry
  And a request_maintenance inbox message with work-id "lead-dual-1" has been sent to "shopsystem-messaging"
  When shop-msg respond work_done is run by "shopsystem-messaging" for work-id "lead-dual-1"
  And shop-msg respond mechanism_observation is run by "shopsystem-messaging" for work-id "lead-dual-1" with subject "cross-cutting finding" and a body of at least 50 characters
  Then both commands exit zero
  And shop-msg pending inbox --lead shopsystem-product includes "lead-dual-1 work_done"
  And shop-msg pending inbox --lead shopsystem-product includes "lead-dual-1 mechanism_observation"

