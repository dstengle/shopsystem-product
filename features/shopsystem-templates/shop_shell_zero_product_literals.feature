@bc:shopsystem-templates @origin:adr-043
Feature: bin/shop-shell carries zero product-specific literals — every product value is a single-sourced env-overridable reference (ADR-043 Phase 1 / ADR-046)
  The 2026-06-27 product-authority decision tightens ADR-043 Phase 1: the rendered
  bin/shop-shell spells NO product-specific literal. Every product coordinate — the
  container names, the docker network, the persistent data root, the agent-vault
  env-file path, the beads repo names, AND the framework launcher/leaf runtime image
  (ADR-046 amends the ADR-028 product-neutral-image exemption) — is a shell-variable
  reference whose default is read from the single bootstrap-rendered ops-coordinates
  artifact and is environment-overridable.

@scenario_hash:1885dea2b4550fde
Scenario: the rendered "bin/shop-shell" references the framework launcher/leaf-BC runtime image as an env-overridable shell variable whose default is sourced from the single ADR-043 ops-coordinates artifact — NOT as the fixed literal "ghcr.io/dstengle/shopsystem-bc-lead:latest" — overriding ADR-028's product-neutral-framework-image exemption per the 2026-06-27 product-authority decision
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no "bin/" subdirectory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "dummyco", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And the body of "bin/shop-shell" passes the framework image to "docker run" and to the inner "bc-container launch --image" as a shell variable expansion, a "$"-prefixed reference, not as the fixed literal substring "ghcr.io/dstengle/shopsystem-bc-lead:latest"
  And that framework-image variable's default value is sourced from the single bootstrap-rendered ops-coordinates artifact (the ADR-043 D2 derivation root), not hardcoded in "bin/shop-shell"
  And that framework-image variable is environment-overridable, so an operator can point shop-shell at a different image reference without editing the script
  And the byte contents of "bin/shop-shell" for shop name "dummyco" contain no occurrence of the literal substring "ghcr.io/dstengle/shopsystem-bc-lead", confirming the framework image is no longer a baked product-neutral literal


@scenario_hash:b7ea0de32ef49854
Scenario: the rendered "bin/shop-shell" obtains every slug-derived coordinate and the org from the SINGLE bootstrap-rendered ops-coordinates artifact (ADR-043 D2 derivation root) as env-overridable variable references rather than spelling any literal — for shop name "dummyco" the container-name check, the docker network (outer launcher AND inner "bc-container launch"), the persistent data root, the agent-vault env-file path, and the beads repo names are shell-variable expansions whose defaults are read from that one artifact and overridable by environment
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no "bin/" subdirectory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "dummyco", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And the body of "bin/shop-shell" loads the single bootstrap-rendered ops-coordinates artifact (the ADR-043 D2 derivation root) by a shell source directive — it contains the literal substring "source " or the literal substring ". " applied to that artifact — rather than re-spelling the product coordinates
  And the body of "bin/shop-shell" references the product container names, the docker network for both the outer launcher and the inner "bc-container launch", the persistent data root, the agent-vault env-file path, and the beads repo names as shell variable expansions, each a "$"-prefixed reference, not as baked product literals
  And every such variable reference is environment-overridable — its default value resolves from the sourced ops-coordinates artifact and an explicit environment assignment takes precedence
  And no default value of any such variable as it appears in "bin/shop-shell" contains a case-insensitive occurrence of the literal substring "shopsystem" or the literal substring "dstengle", confirming the literal lives only in the single ops-coordinates artifact and shop-shell carries only references


@scenario_hash:827dec9656d97a38
Scenario: bootstrap of a "lead" shop with a non-default slug renders "bin/shop-shell" with ZERO product-specific literals — for shop name "dummyco" the rendered "bin/shop-shell" contains no case-insensitive occurrence of the default-product slug "shopsystem" (INCLUDING inside the framework launcher/leaf image references, which are no longer exempt under the ADR-028 amendment), no case-insensitive occurrence of "fleet", and no occurrence of the hardcoded org literal "dstengle"
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no "bin/" subdirectory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "dummyco", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation the target directory contains a file at "bin/shop-shell"
  And the byte contents of "bin/shop-shell" in the target directory contain no case-insensitive occurrence of the literal substring "shopsystem"
  And the byte contents of "bin/shop-shell" in the target directory contain no case-insensitive occurrence of the literal substring "fleet"
  And the byte contents of "bin/shop-shell" in the target directory contain no occurrence of the literal substring "dstengle"
  And the byte contents of "bin/shop-shell" in the target directory contain no occurrence of the literal substring "ghcr.io/dstengle/shopsystem-bc-lead", confirming the framework launcher/leaf image reference previously exempt under ADR-028 is no longer baked as a product literal

