@bc:shopsystem-scenarios @origin:brief-009
Feature: scenarios journal-rebuild CLI writes a journal from a features tree's @scenario_hash tags

  The scenarios journal-rebuild CLI walks a features tree, harvests the
  as-committed @scenario_hash tag values, and writes them as a journal file in
  the established one-block-only-hash-per-line format. It requires no work_done
  or message-bus event, and re-running it over the same features tree leaves an
  identical entry set hash-for-hash — neither duplicating nor dropping entries.

  @scenario_hash:60ff847fac2a4be5
  Scenario: the scenarios journal-rebuild CLI writes a journal file whose entries are the @scenario_hash tags present in a features tree
    Given a features tree containing scenario blocks tagged with the @scenario_hash tags "h8a" and "h8b", each tag equal to its block's block-only canonical hash
    When the "scenarios journal rebuild" CLI command is run against that features tree to write a journal file on disk
    Then the journal file written under the shopsystem-scenarios bounded context contains exactly the block-only canonical hashes "h8a" and "h8b" as its entries, derived from the as-committed @scenario_hash tags alone with no work_done or message-bus event required
    And running the rebuild CLI a second time over the same features tree leaves the journal file with an entry set identical hash-for-hash, neither duplicating nor dropping any entry
