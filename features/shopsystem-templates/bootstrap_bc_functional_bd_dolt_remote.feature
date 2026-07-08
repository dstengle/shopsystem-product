@bc:shopsystem-templates @origin:lead-sgdt
Feature: bootstrap wires the FUNCTIONAL bd dolt remote for a scaffolded BC to <bc>-beads (lead-sgdt)

  Standing up shopsystem-knowledge via create-bc (David 2026-07-07,
  shop-templates 0.49.2): the prior three naming scenarios pinned only the
  COSMETIC surface. Scenario 0636fba2c1445f9f records that bd does NOT read the
  ".beads/config.yaml" "sync.remote" YAML key for "bd dolt push"; that key is
  the jsonl-sync remote. The FUNCTIONAL bd dolt push remote — the one bd and the
  bootstrap smoke-test actually use — is configured by "_configure_bd_dolt_remote"
  via "bd dolt remote add" using "_product_beads_remote", which returns the
  "<product>-lead-beads" LEAD form. For a "--shop-type bc" scaffold that emits
  "<bc>-lead-beads" (e.g. "shopsystem-knowledge-lead-beads"), proven by the
  bootstrap "bd dolt push" smoke-test targeting ".../shopsystem-knowledge-lead-beads.git".
  So the functional remote — the surface bd USES — was left wrong three times
  while scenarios perfected the surface bd IGNORES.

  Origin/driver: ADR-043 D5 (one canonical beads-naming rule). Per D5 the per-BC
  tracker is "<product>-<bc>-beads"; the BC shop slug "<bc>" already carries the
  product scope (ADR-038 forced-product-scope,
  footing_naming_forced_product_scope @scenario_hash:db2131f49c170bc8), so the
  canonical repo name is "<bc>-beads" — e.g. "shopsystem-knowledge-beads". It is
  NOT the "<bc>-lead-beads" nor the "<product>-lead-beads" lead form. This
  scenario binds fidelity to RUNNING "shop-templates bootstrap --shop-type bc"
  and OBSERVING "bd dolt remote list" (the remote bd actually pushes to), not to
  the "sync.remote" config.yaml text the sibling scenario already covers
  (bootstrap_bc_beads_remote_owner_substitution @scenario_hash:ef4f4d86d3e4d153,
  which stays correct — keep it).

  @scenario_hash:8db8399c92702704
  Scenario: shop-templates bootstrap wires the functional bd dolt remote for a scaffolded BC to the owner's <bc>-beads, not the <bc>-lead-beads lead form
    Given a new BC whose shop-name slug is "<bc>" is scaffolded from a lead whose GitHub owner resolves to "<owner>"
    When I invoke "shop-templates" bootstrap with shop type "bc", shop name "<bc>", and a target directory in that lead's context
    Then "bd dolt remote list" in the target directory lists the functional bd dolt push remote that bd actually uses for "bd dolt push"
    And that functional dolt remote's repository name equals "<bc>-beads" so its URL targets "<owner>/<bc>-beads"
    And that functional dolt remote's repository name is NOT "<bc>-lead-beads" and is NOT the "<product>-lead-beads" lead form returned by "_product_beads_remote"
    And neither "bd dolt remote list" nor the bootstrap "bd dolt push" smoke-test target references "<bc>-lead-beads"
    And the scaffolded ".beads/config.yaml" "sync.remote" repository name also stays "<bc>-beads", consistent with the functional dolt remote
