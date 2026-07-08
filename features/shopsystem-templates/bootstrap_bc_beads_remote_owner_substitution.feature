@bc:shopsystem-templates @origin:lead-7jc2
Feature: bootstrap substitutes the real derived owner into a new BC's beads sync.remote (lead-7jc2)

  Standing up shopsystem-knowledge via create-bc (David 2026-07-07): `shop-templates
  bootstrap --shop-type bc` scaffolded ".beads/config.yaml" with
  sync.remote="git+https://github.com/ORIGIN_OWNER/<bc>-beads.git" — the literal
  "ORIGIN_OWNER" placeholder was never substituted, so `bd bootstrap` targeted a
  nonexistent owner and failed. The create-bc path runs no footing reconcile step
  (footing_host_port_and_beads_sync @scenario_hash:c1b769fb49c6ebfb is the LEAD-only
  fill), so the placeholder survives to launch. Root fix (lead-2nf1): bootstrap derives
  the owner from the lead and writes it. Deriving the owner is NOT baking a hardcoded
  org, so this holds with the single-source pin @scenario_hash:cb8fca2c0eb2b920.

  Origin/driver: ADR-043 D5 (single canonical beads-naming rule). Per D5 the per-BC
  tracker is "<product>-<bc>-beads"; the BC shop slug "<bc>" already carries the
  product scope (ADR-038 forced-product-scope,
  footing_naming_forced_product_scope @scenario_hash:db2131f49c170bc8), so the
  canonical repo name is "<bc>-beads" — e.g. "shopsystem-knowledge-beads". It is NOT
  "<bc>-lead-beads": the "-lead-beads" form is the LEAD's own "<product>-lead-beads"
  and must not be reused for a BC's tracker.

  @scenario_hash:ef4f4d86d3e4d153
  Scenario: shop-templates bootstrap writes the derived GitHub owner into the scaffolded beads sync.remote instead of the ORIGIN_OWNER placeholder
    Given a new BC whose shop-name slug is "<bc>" is scaffolded from a lead whose GitHub owner resolves to "<owner>"
    When I invoke "shop-templates bootstrap" with shop type "bc", shop name "<bc>", and a target directory in that lead's context
    Then the scaffolded ".beads/config.yaml" "sync.remote" contains no literal "ORIGIN_OWNER" placeholder
    And the "sync.remote" owner segment equals the derived GitHub owner "<owner>"
    And the "sync.remote" repository name equals "<bc>-beads" so the URL targets "<owner>/<bc>-beads"
