@bc:shopsystem-messaging @origin:brief-001
Feature: shop-msg CLI surface — pending enumeration and inbox read

  @scenario_hash:dbba6458a21b3484
  Scenario: Listing pending messages reports an empty result when no unprocessed inbox messages exist
    Given an empty BC at a temporary path
    When I run the shop-msg subcommand that enumerates pending unprocessed inbox messages, with no filter
    Then the command exits zero
    And stdout contains no work_id entries
    And the command did not require the caller to inspect the inbox or outbox directories

  @scenario_hash:d246eef56684a871
  Scenario: Listing pending messages reports each unprocessed inbox message's work_id and message_type
    Given an empty BC at a temporary path
    And shop-msg send assign_scenarios was previously used to write an inbox message with work-id "lead-100"
    And shop-msg send request_bugfix was previously used to write an inbox message with work-id "lead-101"
    When I run the shop-msg subcommand that enumerates pending unprocessed inbox messages, with no filter
    Then the command exits zero
    And stdout includes an entry for work_id "lead-100" with message_type "assign_scenarios"
    And stdout includes an entry for work_id "lead-101" with message_type "request_bugfix"

  @scenario_hash:ab7c5029713969e4
  Scenario: An inbox message whose work_id already has a matching outbox response is not reported as pending
    Given an empty BC at a temporary path
    And shop-msg send request_maintenance was previously used to write an inbox message with work-id "lead-200"
    And shop-msg respond work_done was previously used to write an outbox response with work-id "lead-200" and status "complete"
    When I run the shop-msg subcommand that enumerates pending unprocessed inbox messages, with no filter
    Then the command exits zero
    And stdout contains no entry for work_id "lead-200"

  @scenario_hash:5571b71a82cbd6b8
  Scenario: The lead side enumerates pending outbox responses for a single BC via a --bc filter
    Given a lead shop at a temporary path with BC clones "bc-alpha" and "bc-beta" present as sibling directories
    And shop-msg respond work_done was previously used inside "bc-alpha" to write an outbox response with work-id "lead-301" and status "complete"
    And shop-msg respond clarify was previously used inside "bc-beta" to write an outbox response with work-id "lead-302" and question "what does X mean?"
    When I run the shop-msg subcommand that enumerates pending unprocessed outbox responses, filtered to BC "bc-alpha"
    Then the command exits zero
    And stdout includes an entry for work_id "lead-301" with message_type "work_done" originating from BC "bc-alpha"
    And stdout contains no entry for work_id "lead-302"

  @scenario_hash:d9543de2855e544c
  Scenario: Reading an inbox message by work_id returns the message contents without the caller inspecting storage
    Given an empty BC at a temporary path
    And shop-msg send assign_scenarios was previously used to write an inbox message with work-id "lead-400" containing one ScenarioPayload tagged "@bc:shopsystem-messaging"
    When I run shop-msg read inbox with work-id "lead-400"
    Then the command exits zero
    And stdout includes message_type "assign_scenarios" and work_id "lead-400"
    And stdout includes the gherkin body of the ScenarioPayload that was sent

  @scenario_hash:a199948703bbaebe
  Scenario: Reading an inbox message by an unknown work_id fails with a stderr explanation
    Given an empty BC at a temporary path
    When I run shop-msg read inbox with work-id "lead-nonexistent"
    Then the command exits non-zero
    And stderr explains no inbox message was found for that work_id

  @scenario_hash:a7bca94eea82b87f
  Scenario: Reading an inbox message whose stored content fails schema validation fails with a stderr explanation
    Given an empty BC at a temporary path
    And the BC's inbox already contains a file for work-id "lead-499" whose content is valid YAML but does not match any LeadMessage schema
    When I run shop-msg read inbox with work-id "lead-499"
    Then the command exits non-zero
    And stderr explains schema validation failed
