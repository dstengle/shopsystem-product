@bc:shopsystem-messaging @origin:brief-009
Feature: request_completion_journal — request and response message types

  A request_completion_journal asks a target bounded context for the set of
  block-only canonical scenario hashes it has completed. The request names
  the target BC and carries no completion entries of its own; the response
  carries the completed entries back as a bare set of hashes.

  @scenario_hash:65c85ffce8f88507
  Scenario: A minimal valid request_completion_journal request message can be constructed carrying only the target bounded context
    Given the RequestCompletionJournal request schema from the shop-msg catalog
    When I construct a RequestCompletionJournal request instance supplying only the fields the schema marks as required, naming the target bounded context whose completed scenarios are sought
    Then construction succeeds
    And no schema validation error is raised
    And the constructed request carries the named target bounded context and no scenario-completion entry of its own

  @scenario_hash:7afa72ede6099ee1
  Scenario: A request_completion_journal response message validates with a bare set of completed block-only canonical hashes
    Given the RequestCompletionJournal response schema from the shop-msg catalog
    When I construct a RequestCompletionJournal response instance whose completed-entries field is a set of block-only canonical hashes "h1" and "h2"
    Then construction succeeds
    And no schema validation error is raised
    And the constructed response carries exactly the completed block-only canonical hashes "h1" and "h2" as a bare set, with no per-entry record beyond the hash

  @scenario_hash:79dd275d8584c8fc
  Scenario: shop-msg send request_completion_journal deposits a well-formed request naming the target bounded context
    Given an empty BC at a temporary path with no unprocessed inbox messages
    When shop-msg send request_completion_journal is run for work-id "lead-300" naming target bounded context "shopsystem-scenarios"
    Then the inbox holds exactly one unprocessed request_completion_journal message for work_id "lead-300"
    And that deposited message validates against the RequestCompletionJournal request schema and names target bounded context "shopsystem-scenarios"

  @scenario_hash:5138b2335150db4c
  Scenario: responding to a request_completion_journal carries the completed-entries set back over the wire to the requester
    Given an inbox holding an unprocessed request_completion_journal request for work_id "lead-301" naming target bounded context "shopsystem-scenarios"
    When shop-msg responds to request_completion_journal for work_id "lead-301" with the completed block-only canonical hashes "h1" and "h2"
    Then the requester can read a request_completion_journal response for work_id "lead-301" whose completed-entries set is exactly the block-only canonical hashes "h1" and "h2"
    And that response validates against the RequestCompletionJournal response schema
