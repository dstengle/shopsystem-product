# RETIRED-scenario provenance (relocated to file header on lead-import so the
# canonical block-only hash of the preceding scenario is unaffected; bodies and
# @scenario_hash pins are byte-identical to the shopsystem-templates canonical):
#   @scenario_hash:2afb5cba3ea3de25 RETIRED (lead-3c6)
#   Asserted CLAUDE.md body contains "bd prime". Under PDR-003 alt F, CLAUDE.md
#   is a pure @-import file; the "bd prime" invariant relocated to
#   .claude/canonical/<shop_type>-primer.md, pinned by lead-shop scenarios 52 + 53.
@bc:shopsystem-templates @origin:pdr-003
Feature: Bootstrap CLI surface — bd-init side-effect closure (lead-k8v round 2)

  @scenario_hash:31a044e7d2eceaf4
  Scenario Outline: bootstrap invokes "bd init" with the "--skip-agents" flag so bd's own AGENTS.md and Claude settings generation is suppressed and the shop's canonical agent surface is the sole source of agent-prompt content
    Given an existing git repository at a target directory "<target>" with no ".beads/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
    Then the exit code is 0
    And the target directory contains a ".beads/" directory
    And during the invocation a subprocess named "bd" was executed with first argument "init"
    And the argument list passed to that "bd" subprocess contains the exact token "--skip-agents"

    Examples:
      | shop_type | shop_name               | target                       |
      | bc        | shopsystem-messaging    | /tmp/example-bc-shop         |
      | lead      | shopsystem-product      | /tmp/example-lead-shop       |

  @scenario_hash:e768db7eae3d6dfe
  Scenario Outline: the canonical "CLAUDE.md" primer template for each shop type references the bd (beads) discipline that the shop is expected to follow, naming "bd prime" as the entry point a reader runs to learn the workflow
    When I ask the "shop-templates" package for the canonical "CLAUDE.md" primer template for shop type "<shop_type>" through its public template-access surface
    Then a non-empty template body is returned
    And the returned body contains the literal substring "bd prime"
    And the returned body contains at least one instruction directing the reader to run a "bd" subcommand as part of the shop's working discipline

    Examples:
      | shop_type |
      | bc        |
      | lead      |
