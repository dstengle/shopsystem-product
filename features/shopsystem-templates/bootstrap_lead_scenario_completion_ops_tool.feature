@bc:shopsystem-templates @origin:lead-csas
Feature: bootstrap renders the lead-side scenario-completion reconciliation ops tool (lead-shop only): bin/shop-scenario-completion

  @scenario_hash:5c0a34a0b9ad1be7
  Scenario: bootstrap of a "lead" shop writes the lead-side scenario-completion ops tool as shop-owned starter content (in the PDR-003 path F sense) at a top-level "bin/" path — not under ".claude/canonical/" — so every newly-instantiated product lead shop is born with the cross-BC "is-X-done" / "outstanding" reconciliation view and the operator may freely customize it without colliding with the canonical-managed re-pour contract
    Given an existing git repository at a target directory "/tmp/example-lead-shop"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the target directory contains an executable file at "/tmp/example-lead-shop/bin/shop-scenario-completion" (not under any ".claude/" subdirectory)
    And the file at "/tmp/example-lead-shop/bin/shop-scenario-completion" has its owner-execute permission bit set
    And after the invocation the directory at "/tmp/example-lead-shop/.claude/canonical/" does not contain a file named "shop-scenario-completion", because the scenario-completion ops tool is shop-owned bootstrap-time starter content rather than a canonical-managed file subject to the re-pour contract

  @scenario_hash:e430bb96e91b89ab
  Scenario: bootstrap of a "bc" shop does not write the lead-side scenario-completion ops tool (no "bin/shop-scenario-completion") because the cross-BC "is-X-done" / "outstanding" aggregate view composes the lead's own bead ledger, which a BC running inside a bc-launcher container cannot see
    Given an existing git repository at a target directory "/tmp/example-bc-shop" with no "bin/" subdirectory
    When I invoke the "shop-templates" bootstrap entry point with shop type "bc", shop name "shopsystem-messaging", and target directory "/tmp/example-bc-shop"
    Then the exit code is 0
    And after the invocation the target directory contains no file at "bin/shop-scenario-completion"
