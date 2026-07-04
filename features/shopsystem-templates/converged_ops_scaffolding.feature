@bc:shopsystem-templates @origin:pdr-020
Feature: converged ops scaffolding (lead shop, PDR-020) — bin/shop-shell is a thin bc-container-delegating wrapper, the ops set is exactly seven shop-owned files (the six converged ops tools plus the single shell-sourceable bin/ops-coordinates artifact) with no dedicated shell Dockerfile, and a non-default render carries zero cross-product literals

  @scenario_hash:0a7e4c29fc7db52b
  Scenario Outline: the ops scaffolding file-set written by bootstrap for a "lead" shop named "<slug>" enumerates exactly seven shop-owned files additively — "compose.yaml", "bin/shop-shell", "bin/shop-scenario-completion", "bin/agent-vault-provision", "bin/agent-vault-check", "bin/agent-vault-approve-claude", and "bin/ops-coordinates" — each at a shop-owned path outside any ".claude/" subdirectory, and writes NO dedicated shell Dockerfile, because per PDR-020 the shell image is retired and "bin/shop-shell" launches an ephemeral bc-lead launcher (which stands up the leaf-BC on bc-base) instead, per lead-9s46 the lead-only "bin/agent-vault-approve-claude" Claude-OAuth proposal approval tool joined the converged ops-tool set, and per ADR-043 Phase 1 (lead-ow4d) the single shell-sourceable "bin/ops-coordinates" coordinate artifact joined the set as its seventh member
    Given an existing git repository at a target directory "/tmp/example-lead-shop"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<slug>", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the target directory contains a top-level file named "compose.yaml" not under any ".claude/" subdirectory
    And after the invocation the target directory contains a file at "bin/shop-shell" not under any ".claude/" subdirectory
    And after the invocation the target directory contains a file at "bin/shop-scenario-completion" not under any ".claude/" subdirectory
    And after the invocation the target directory contains a file at "bin/agent-vault-provision" not under any ".claude/" subdirectory
    And after the invocation the target directory contains a file at "bin/agent-vault-check" not under any ".claude/" subdirectory
    And after the invocation the target directory contains a file at "bin/agent-vault-approve-claude" not under any ".claude/" subdirectory
    And after the invocation the target directory contains a file at "bin/ops-coordinates" not under any ".claude/" subdirectory
    And after the invocation the target directory contains no top-level file named "Dockerfile.<slug>-shell"
    And after the invocation the target directory contains no top-level file named "Dockerfile.shopsystem-shell"
    And the directory at "/tmp/example-lead-shop/.claude/canonical/" does not contain a file named "compose.yaml", "shop-shell", "shop-scenario-completion", "agent-vault-provision", "agent-vault-check", or "agent-vault-approve-claude"
    And the bootstrap-enumerated converged ops-tool set for a "lead" shop contains exactly seven shop-owned entries — "compose.yaml", "bin/shop-shell", "bin/shop-scenario-completion", "bin/agent-vault-provision", "bin/agent-vault-check", "bin/agent-vault-approve-claude", and "bin/ops-coordinates" — and no eighth shop-owned ops file beyond those seven

    Examples:
      | slug       |
      | shopsystem |
      | dummyco    |

  @scenario_hash:82c3a716143014a6
  Scenario: the ops scaffolding files written by bootstrap for a "lead" shop ("compose.yaml", "bin/shop-shell") are shop-owned (in the PDR-003 path F sense) — they are bootstrap-time starter content the operator may freely customize, and they do not sit under ".claude/canonical/" because they are not subject to the canonical-managed re-pour contract that ".claude/canonical/" implies; and no dedicated shell Dockerfile is written, because PDR-020 retires it
    Given an existing git repository at a target directory "/tmp/example-lead-shop"
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the target directory contains a top-level file named "compose.yaml" at the path "/tmp/example-lead-shop/compose.yaml" (not under any ".claude/" subdirectory)
    And after the invocation the target directory contains a file at "/tmp/example-lead-shop/bin/shop-shell" (not under any ".claude/" subdirectory)
    And after the invocation the target directory contains no top-level file named "Dockerfile.shopsystem-shell"
    And after the invocation the directory at "/tmp/example-lead-shop/.claude/canonical/" does not contain a file named "compose.yaml", "shop-shell", or "Dockerfile.shopsystem-shell"
