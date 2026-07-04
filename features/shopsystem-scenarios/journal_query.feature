@bc:shopsystem-scenarios @origin:brief-009
Feature: scenarios journal-query CLI answers a definite yes/no keyed on the block-only canonical hash

  The scenarios journal-query CLI answers whether a block-only canonical hash
  is recorded in an on-disk journal file. The answer is a definite yes/no on
  stdout (exit status is success in both cases), keyed solely on the block-only
  canonical hash — not on any bead id, scenario title, dispatch record, or
  message-bus row.

  @scenario_hash:2f98b0bb8380af42
  Scenario: the scenarios journal-query CLI answers a definite yes for a block-only hash present in the journal file
    Given a scenario journal stored as a file on disk under the shopsystem-scenarios bounded context
    And the journal file records the block-only canonical hash "h1" as a present entry
    When the "scenarios journal query" CLI command is run against that journal file for the block-only canonical hash "h1"
    Then the command exits with a success status and reports a definite "yes" for "h1"
    And the answer is keyed solely on the block-only canonical hash "h1", not on any bead id, scenario title, dispatch record, or message-bus row

  @scenario_hash:cc4c8fcd07b5587c
  Scenario: the scenarios journal-query CLI answers a definite no for a block-only hash absent from the journal file
    Given a scenario journal stored as a file on disk under the shopsystem-scenarios bounded context
    And the journal file contains no entry for the block-only canonical hash "h2"
    When the "scenarios journal query" CLI command is run against that journal file for the block-only canonical hash "h2"
    Then the command exits with a success status and reports a definite "no" for "h2"
    And the answer is keyed solely on the block-only canonical hash "h2", not on any bead id, scenario title, dispatch record, or message-bus row
