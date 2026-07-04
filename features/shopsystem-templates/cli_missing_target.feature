@bc:shopsystem-templates @origin:brief-002
Feature: shop-templates CLI rejects missing --target with argparse-style error (consistency pass)

  @scenario_hash:8bb999408f08414b
  Scenario: the bootstrap entry point exits with an argparse-style usage error when invoked without --target, with no Python traceback emitted
    Given an existing empty directory "/tmp/example-shop-no-target-witness" that contains no ".claude/agents/" directory, no ".beads/" directory, no top-level "CLAUDE.md", and no top-level ".gitignore"
    When I invoke the "shop-templates" bootstrap entry point with --shop-type "bc" and --shop-name "shopsystem-example" but with no --target argument
    Then the exit code is 2
    And stderr names "--target" as a missing required argument
    And stderr does not contain a Python traceback or the substring "TypeError"
    And the witness directory "/tmp/example-shop-no-target-witness" still contains no ".claude/agents/" directory and no ".beads/" directory and no top-level "CLAUDE.md" and no top-level ".gitignore"

  @scenario_hash:1690580456d6efe6
  Scenario: the update entry point exits with an argparse-style usage error when invoked without --target, with no Python traceback emitted and no modification to any pre-existing shop scaffold
    Given a previously-bootstrapped shop at "/tmp/example-shop-update-no-target" of shop type "bc" whose ".claude/agents/" directory contains exactly the canonical "bc" role files
    And a recorded snapshot of the byte contents and mtimes of every file under "/tmp/example-shop-update-no-target/.claude/agents/"
    When I invoke the "shop-templates" update entry point with --shop-type "bc" but with no --target argument
    Then the exit code is 2
    And stderr names "--target" as a missing required argument
    And stderr does not contain a Python traceback or the substring "TypeError"
    And every file under "/tmp/example-shop-update-no-target/.claude/agents/" has the same byte contents and mtime as the recorded snapshot
    And the top-level "CLAUDE.md", top-level ".gitignore", and ".beads/" directory under "/tmp/example-shop-update-no-target" are unchanged from before the invocation
