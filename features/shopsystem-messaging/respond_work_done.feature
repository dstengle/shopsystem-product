@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg respond — write a work_done response to the lead inbox

  # Scenario 650e6761d5479ce3 ("Reply to lead with a work_done message")
  # previously asserted that shop-msg respond work_done writes to the BC's
  # outbox directory.  Under lead-e9x the response is routed to the lead's
  # inbox.  That scenario is retired; this file contains the replacement.

  @scenario_hash:e96bb386330bb3fc
  Scenario: BC respond work_done delivers the response to the lead inbox
    Given an empty BC at a temporary path
    When I run shop-msg respond work_done with work-id "lead-001" and status "complete" and scenario-hash "abc123"
    Then the lead's inbox contains a response named "lead-001-work_done.yaml"
    And the file parses as a valid WorkDone with work_id "lead-001" and status "complete"
