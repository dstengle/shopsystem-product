@bc:shopsystem-scenarios @origin:lead-cfx
Feature: shopsystem-scenarios — canonicalization and CLI contracts

  @scenario_hash:f39fa801c31d827b
  Scenario: canonicalization is insensitive to per-line surrounding whitespace
  Given a Gherkin body A
  And a Gherkin body B that is A with extra leading and trailing whitespace on every step line
  When I compute the canonical hash of A and of B
  Then both hashes are identical

  @scenario_hash:1302096a3cafc590
  Scenario: canonicalization is insensitive to blank lines between steps
  Given a Gherkin body A
  And a Gherkin body B that is A with one or more blank lines inserted between steps
  When I compute the canonical hash of A and of B
  Then both hashes are identical

  @scenario_hash:fdb2431ecd1584ef
  Scenario: canonicalization drops lines that start with the @scenario_hash tag
  Given a Gherkin body A
  And a Gherkin body B that is A with one extra line "@scenario_hash:abcdef0123456789" prepended
  When I compute the canonical hash of A and of B
  Then both hashes are identical
  And embedding the resulting hash back into the body as a "@scenario_hash:" tag line does not change the hash on the next computation

  @scenario_hash:5834e7392c0aa935
  Scenario: canonicalization drops @scenario_hash only when it starts the line, not when it appears mid-step as substring
  Given a Gherkin body A containing a step whose text includes the substring "@scenario_hash:" but does not start with it after trimming
  And a Gherkin body B that is A with that step deleted
  When I compute the canonical hash of A and of B
  Then the hashes are different
