@bc:shopsystem-templates @origin:lead-5mr5
Feature: shop-templates ships and pours the canonical lead skill-group

  @scenario_hash:c207853320920de7
  Scenario Outline: the canonical lead skill-group is shipped as package data and exposed through the "shop-templates" public template-access surface, parallel to the role templates and primer
    Given the installed "shop-templates" distribution
    When I query the "shop-templates" public template-access surface for the canonical "<shop_type>" skill-group
    Then the access surface reports the skill-group has at least one member
    And the member named "bring-up-bc" is present in the reported skill-group
    And for each reported member the access surface returns package-data "SKILL.md" contents byte-for-byte

    Examples:
      | shop_type |
      | lead      |

  @scenario_hash:cc52003444ea63f7
  Scenario Outline: the poured "bring-up-bc" skill is a member of the canonical lead skill-group and its body names launching via bc-container, the BCLAUNCHER_HOST_HOME devcontainer fact, and the shop-msg bc-status online check
    Given an existing git repository at a target directory "<target>" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/bring-up-bc/SKILL.md"
    And the content of ".claude/skills/bring-up-bc/SKILL.md" names launching a BC via "bc-container launch"
    And the content of ".claude/skills/bring-up-bc/SKILL.md" names setting "BCLAUNCHER_HOST_HOME" for a devcontainer with a bind-mounted home
    And the content of ".claude/skills/bring-up-bc/SKILL.md" names verifying the BC reaches "online" via "shop-msg bc-status"

    Examples:
      | shop_type | shop_name          | target                 |
      | lead      | shopsystem-product | /tmp/example-lead-shop |

  @scenario_hash:7df4006ce0d43d8b
  Scenario Outline: the poured "bring-up-bc" skill scopes the BCLAUNCHER_HOST_HOME requirement to the workspace-mount / bind-mounted-home launch case and does not present it as required for a clone-path launch or universally
    Given an existing git repository at a target directory "<target>" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/bring-up-bc/SKILL.md"
    And the content of ".claude/skills/bring-up-bc/SKILL.md" presents setting "BCLAUNCHER_HOST_HOME" as required for the workspace-mount / bind-mounted-home devcontainer launch case
    And the content of ".claude/skills/bring-up-bc/SKILL.md" names that a clone-path BC launch does NOT require "BCLAUNCHER_HOST_HOME"
    And the content of ".claude/skills/bring-up-bc/SKILL.md" does not present "BCLAUNCHER_HOST_HOME" as universally required for every launch

    Examples:
      | shop_type | shop_name          | target                 |
      | lead      | shopsystem-product | /tmp/example-lead-shop |

  @scenario_hash:f75eb04e359f4833
  Scenario Outline: the poured "create-bc" skill is a member of the canonical lead skill-group and its body names the scaffold, remote, manifest, launch, gotcha, and experimental-honesty elements of the proven create-a-BC-from-scratch procedure
    Given an existing git repository at a target directory "<target>" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/create-bc/SKILL.md"
    And the content of ".claude/skills/create-bc/SKILL.md" names scaffolding a new BC via "shop-templates bootstrap --shop-type bc"
    And the content of ".claude/skills/create-bc/SKILL.md" names creating the remote via "gh repo create" and pushing, and names prompting the user for the GitHub org/owner and the public/private visibility rather than hardcoding them
    And the content of ".claude/skills/create-bc/SKILL.md" names registering the BC in "bc-manifest.yaml" via "bc-container manifest"
    And the content of ".claude/skills/create-bc/SKILL.md" names launching via "bc-container launch" with the brokered flags "--repo-url", "--image" at bc-base "v0.3.1+" rather than ":latest", "--network", "--agent-vault-broker", and "--env-file", and cross-references the "bring-up-bc" skill for the launch leg
    And the content of ".claude/skills/create-bc/SKILL.md" names the gotchas that "AGENT_VAULT_VAULT" is the plain "<product>" not "<product>:proxy", that credential keys are SCREAMING_SNAKE, and that bc-base is pinned to "v0.3.1+"
    And the content of ".claude/skills/create-bc/SKILL.md" names that the full scaffold-to-repo-to-launch flow is experimental and not yet verified end-to-end, so the lead narrates and confirms with the user as it proceeds

    Examples:
      | shop_type | shop_name          | target                 |
      | lead      | shopsystem-product | /tmp/example-lead-shop |
