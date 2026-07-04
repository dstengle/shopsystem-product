@bc:shopsystem-templates @origin:lead-5mr5
Feature: shop-templates bootstrap pours canonical skills into a BC

  @scenario_hash:81667c04c3ca4590
  Scenario: bootstrapping a bc shop pours every skill file under .claude/skills byte-for-byte
    Given an existing git repository at a target directory "/tmp/skills-bc-shop"
    When I bootstrap a "bc" shop named "skills-bc-shop" at "/tmp/skills-bc-shop"
    Then the exit code of the bootstrap invocation is 0
    And every shipped skill file appears under ".claude/skills/" in the target byte-for-byte

