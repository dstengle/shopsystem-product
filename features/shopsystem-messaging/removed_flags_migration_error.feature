@bc:shopsystem-messaging @origin:brief-006
Feature: Brief 006 scope A+B: name registry and name-based addressing

  @scenario_hash:9536b845a335b1b3
  Scenario: Using the removed --bc-root flag exits non-zero with a migration error message
    Given the shop-msg CLI has shipped name-based addressing
    When I run any shop-msg subcommand with a --bc-root flag
    Then the command exits non-zero
    And stderr contains a message indicating --bc-root is no longer supported and instructs the caller to use --bc <name>

  @scenario_hash:cd8233902d200648
  Scenario: Using the removed --lead-root flag exits non-zero with a migration error message
    Given the shop-msg CLI has shipped name-based addressing
    When I run any shop-msg subcommand with a --lead-root flag
    Then the command exits non-zero
    And stderr contains a message indicating --lead-root is no longer supported and instructs the caller to use --lead <name>
