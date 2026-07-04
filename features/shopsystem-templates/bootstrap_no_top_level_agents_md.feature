@bc:shopsystem-templates @origin:brief-002
Feature: Bootstrap leaves no top-level AGENTS.md in the target directory

  @scenario_hash:17ec6c96c28e0f67
  Scenario Outline: bootstrap leaves no top-level "AGENTS.md" in the target directory, regardless of shop type, because the shop's canonical agent surface is ".claude/agents/*.md" alone and bootstrap invokes "bd init" with "--skip-agents"
    Given an existing git repository at a target directory "<target>" containing no top-level "AGENTS.md"
    When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains no top-level file named "AGENTS.md"

    Examples:
      | shop_type | shop_name               | target                       |
      | bc        | shopsystem-messaging    | /tmp/example-bc-shop         |
      | lead      | shopsystem-product      | /tmp/example-lead-shop       |
