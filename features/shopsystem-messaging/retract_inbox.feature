@bc:shopsystem-messaging @origin:lead-9xrd
Feature: shop-msg retract inbox

  @scenario_hash:79bc74e7e730bb67
Scenario: Retracting a still-pending inbox dispatch removes it so the BC will not process it
  Given "shopsystem-product" is registered in the messaging registry as the lead shop
  And a BC "shopsystem-messaging" is registered in the messaging registry
  And shop-msg send request_maintenance was previously used to write an inbox message addressed to "shopsystem-messaging" with work-id "lead-r01" and message-type "request_maintenance"
  And shop-msg pending inbox --bc shopsystem-messaging includes work-id "lead-r01"
  And no outbox response for work-id "lead-r01" has been emitted by "shopsystem-messaging"
  When the lead operator runs shop-msg retract inbox --bc shopsystem-messaging --work-id lead-r01 --message-type request_maintenance
  Then the command exits zero
  And shop-msg pending inbox --bc shopsystem-messaging does not include work-id "lead-r01"
  And shop-msg read inbox --bc shopsystem-messaging --work-id lead-r01 exits non-zero reporting no inbox message was found for that work_id
  And a re-run of shop-msg retract inbox --bc shopsystem-messaging --work-id lead-r01 --message-type request_maintenance exits zero leaving "lead-r01" absent from shop-msg pending inbox --bc shopsystem-messaging
  And the retraction is recorded against the (bc=shopsystem-messaging, work_id=lead-r01, message_type=request_maintenance) triple in the messaging audit trail

  @scenario_hash:bbe6bda4dacb9633
Scenario: Retracting an inbox dispatch the BC has already consumed is refused and leaves the consumed deposit intact
  Given "shopsystem-product" is registered in the messaging registry as the lead shop
  And a BC "shopsystem-messaging" is registered in the messaging registry
  And shop-msg send assign_scenarios was previously used to write an inbox message addressed to "shopsystem-messaging" with work-id "lead-r02" and message-type "assign_scenarios"
  And the BC ran shop-msg consume inbox --work-id lead-r02 so work-id "lead-r02" is no longer surfaced by shop-msg pending inbox --bc shopsystem-messaging
  When the lead operator runs shop-msg retract inbox --bc shopsystem-messaging --work-id lead-r02 --message-type assign_scenarios
  Then the command exits non-zero
  And stderr reports that work-id "lead-r02" was already consumed and cannot be retracted
  And the consumed deposit for the (bc=shopsystem-messaging, work_id=lead-r02, message_type=assign_scenarios) triple is unchanged
  And the refused retraction attempt is recorded against the (bc=shopsystem-messaging, work_id=lead-r02, message_type=assign_scenarios) triple in the messaging audit trail
