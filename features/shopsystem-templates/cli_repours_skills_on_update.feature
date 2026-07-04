@bc:shopsystem-templates @origin:lead-1e8d
Feature: shop-templates update mirrors canonical skills into a BC

  @scenario_hash:c4e8177b65e2bcd4
  Scenario: update re-pours a drifted skill file to canonical bytes
    Given a bootstrapped "bc" shop at a target directory "/tmp/upd-skills-bc"
    And the skill file ".claude/skills/test-driven-development/SKILL.md" has drifted to "STALE"
    When I run update for shop type "bc" at "/tmp/upd-skills-bc"
    Then the exit code of the update invocation is 0
    And every shipped skill file appears under ".claude/skills/" in the target byte-for-byte

  @scenario_hash:056aef812b3e46ae
  Scenario: update leaves an already-current skill file byte-and-mtime unchanged
    Given a bootstrapped "bc" shop at a target directory "/tmp/upd-skills-idem"
    When I record the mtime of ".claude/skills/test-driven-development/SKILL.md"
    And I run update for shop type "bc" at "/tmp/upd-skills-idem"
    Then the exit code of the update invocation is 0
    And the mtime of ".claude/skills/test-driven-development/SKILL.md" is unchanged

  @scenario_hash:d8bebf440a3b3f59
  Scenario: update scopes pruning to canonical-managed members and leaves an unmanaged skill directory intact
    # lead-1e8d (architect option b, supersedes scenario 159): pruning under
    # .claude/skills/ is scoped to canonical-managed members ONLY. A directory
    # whose name is not a canonical-managed member (an experimentally-adopted
    # or otherwise unmanaged skill dir) is NEVER pruned by update — it survives
    # byte-for-byte. This supersedes the prior "remove any non-shipped file"
    # behavior, which over-pruned legitimate experimental PM skill dirs.
    Given a bootstrapped "bc" shop at a target directory "/tmp/upd-skills-orphan"
    And an extra file ".claude/skills/removed-skill/SKILL.md" exists in the target
    When I run update for shop type "bc" at "/tmp/upd-skills-orphan"
    Then the exit code of the update invocation is 0
    And the target directory still contains the file ".claude/skills/removed-skill/SKILL.md"
