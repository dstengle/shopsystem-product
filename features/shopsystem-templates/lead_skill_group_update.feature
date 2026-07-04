@bc:shopsystem-templates @origin:pdr-023
Feature: shop-templates update mirrors the canonical lead skill-group into a lead shop

  @scenario_hash:e803b4c9cdf36c21
  Scenario: shop-templates update re-pours every bootstrap-managed skill in the lead skill-group in the target directory from the current canonical package data
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "example-lead-shop"
    And the file at ".claude/skills/bring-up-bc/SKILL.md" in the target directory equals the current canonical "bring-up-bc" lead-skill template package-data file contents byte-for-byte
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the file at ".claude/skills/bring-up-bc/SKILL.md" in the target directory still equals the current canonical "bring-up-bc" lead-skill template package-data file contents byte-for-byte

  @scenario_hash:4a008549dafc905c
  Scenario: update replaces a stale bootstrap-managed lead skill file with the current canonical content when the package-data template has changed since the shop was bootstrapped
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "example-lead-shop"
    And the file at ".claude/skills/bring-up-bc/SKILL.md" in the target directory holds an older version of the "bring-up-bc" canonical lead-skill template content
    And the current canonical "bring-up-bc" lead-skill template package-data file contents differ from that older version
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the file at ".claude/skills/bring-up-bc/SKILL.md" in the target directory equals the current canonical "bring-up-bc" lead-skill template package-data file contents byte-for-byte

  @scenario_hash:a14e5a0aacb58285
  Scenario: update is idempotent for the managed lead skill-group when the poured skills already match the current canonical package data
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "example-lead-shop"
    And every skill in the ".claude/skills/" directory equals its current canonical lead-skill template package-data file contents byte-for-byte
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation every skill in the ".claude/skills/" directory still equals its current canonical lead-skill template package-data file contents byte-for-byte
    And the set of skill directories under ".claude/skills/" in the target directory is unchanged

