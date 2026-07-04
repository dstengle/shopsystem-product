@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg consume outbox

  @scenario_hash:7b34c54426a566e1
Scenario: Consuming a specific outbox row removes it from pending outbox output
  Given a lead shop at a temporary path with BC clone "bc-alpha" present as a sibling directory
  And shop-msg respond work_done was previously used inside "bc-alpha" to write an outbox response with work-id "lead-500" and status "complete"
  When I run shop-msg consume outbox with --bc bc-alpha, --work-id "lead-500", and --message-type "work_done"
  Then the command exits zero
  And running shop-msg pending outbox --lead at the lead path contains no entry for work_id "lead-500"

  @scenario_hash:3865a2f6bbf460f9
Scenario: Consuming one message_type on a work_id that has multiple outbox rows leaves the other message_types visible in pending outbox
  Given a lead shop at a temporary path with BC clone "bc-alpha" present as a sibling directory
  And shop-msg respond clarify was previously used inside "bc-alpha" to write an outbox response with work-id "lead-501" and question "which acceptance criterion applies?"
  And shop-msg respond work_done was previously used inside "bc-alpha" to write an outbox response with work-id "lead-501" and status "complete"
  When I run shop-msg consume outbox with --bc bc-alpha, --work-id "lead-501", and --message-type "work_done"
  Then the command exits zero
  And running shop-msg pending outbox --lead at the lead path includes an entry for work_id "lead-501" with message_type "clarify" originating from BC "bc-alpha"
  And running shop-msg pending outbox --lead at the lead path contains no entry for work_id "lead-501" with message_type "work_done"

  @scenario_hash:7ee6f13b3378e594
Scenario: pending outbox returns empty output when all outbox rows for all BCs have been consumed
  Given a lead shop at a temporary path with BC clone "bc-alpha" present as a sibling directory
  And shop-msg respond work_done was previously used inside "bc-alpha" to write an outbox response with work-id "lead-502" and status "complete"
  And shop-msg consume outbox has been run with --bc bc-alpha, --work-id "lead-502", and --message-type "work_done"
  When I run the shop-msg subcommand that enumerates pending unprocessed outbox responses, with no filter
  Then the command exits zero
  And stdout contains no work_id entries

  @scenario_hash:6bbb5877c405263a
Scenario: Attempting to consume an outbox row that does not exist produces a clear error and exits non-zero
  Given a lead shop at a temporary path with BC clone "bc-alpha" present as a sibling directory
  And no outbox message exists for work-id "lead-503" in "bc-alpha"
  When I run shop-msg consume outbox with --bc bc-alpha, --work-id "lead-503", and --message-type "work_done"
  Then the command exits non-zero
  And stderr includes work_id "lead-503" and message_type "work_done"
