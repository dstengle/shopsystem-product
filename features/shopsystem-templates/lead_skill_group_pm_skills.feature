@bc:shopsystem-templates @origin:lead-moo4
Feature: canonical lead skill-group graduates the six PDR-033 PM skills LOCAL -> CANONICAL

  PDR-033 (P02) defines the lead-pm main-session mode by a poured skill group.
  The six PM skills — discovery-dialogue, shaping, option-tradeoff,
  prioritization, problem-space-mapping, and product-narrative — graduate from
  LOCAL to CANONICAL and become members of the canonical lead skill-group that
  "shop-templates" ships and pours. The canonical membership scenario
  (c207853320920de7) is non-exhaustive and additive — it asserts "at least one
  member" and pins "bring-up-bc"; this scenario pins the additional PM-skill
  graduation without altering that block.

  @scenario_hash:ebc6436bdbeea485
  Scenario Outline: each graduated PM skill is a member of the canonical lead skill-group and its "SKILL.md" is returned as package data
    Given the installed "shop-templates" distribution
    When I query the "shop-templates" public template-access surface for the canonical "lead" skill-group
    Then the access surface reports the skill-group has the member "<skill>"
    And for the member "<skill>" the access surface returns package-data "SKILL.md" contents byte-for-byte

    Examples:
      | skill                 |
      | discovery-dialogue    |
      | shaping               |
      | option-tradeoff       |
      | prioritization        |
      | problem-space-mapping |
      | product-narrative     |

  @scenario_hash:fd2e4444df9913e2
  Scenario Outline: the bootstrap pour writes each graduated PM skill into the target ".claude/skills/" tree
    Given an existing git repository at a target directory "<target>" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/<skill>/SKILL.md"
    And the content of ".claude/skills/<skill>/SKILL.md" names its terminal artifact for the lead-pm mode

    Examples:
      | skill                 | target                 |
      | discovery-dialogue    | /tmp/example-lead-shop |
      | shaping               | /tmp/example-lead-shop |
      | option-tradeoff       | /tmp/example-lead-shop |
      | prioritization        | /tmp/example-lead-shop |
      | problem-space-mapping | /tmp/example-lead-shop |
      | product-narrative     | /tmp/example-lead-shop |
