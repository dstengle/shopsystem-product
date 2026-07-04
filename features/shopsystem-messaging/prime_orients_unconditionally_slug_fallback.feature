@bc:shopsystem-messaging @origin:brief-006 @service:postgres
Feature: messaging registry: shop-msg prime orients unconditionally and supports slug-form fallback (retires scenario 34)

  @scenario_hash:b8828c5e3aecd7d0
  Scenario: bare "shop-msg prime" prints DSN, DB health, pending counts, and CLI catalog even when the CWD-derived shop name is not registered in the registry
  Given a shop directory tree containing ".claude/shop/name.md" with literal content "some-not-registered-form" and ".claude/shop/type.md" with literal content "lead"
  And no shop named "some-not-registered-form" is registered in the messaging registry
  And the messaging registry's database is reachable
  And my current working directory is the shop directory or a descendant
  When I run "shop-msg prime" with no addressing flags
  Then the command exits zero
  And stdout includes the registry's DSN string
  And stdout includes a DB-health line indicating the registry database is reachable
  And stdout includes a CLI-catalog reminder naming at least the subcommands "send", "read", "pending", "watch", "registry"
  And stderr contains a warning naming that the CWD-derived shop name "some-not-registered-form" did not resolve against the registry
  And the warning does not abort prime: the orientation output above is still emitted in full

  @scenario_hash:e344045f0e8a82a0
  Scenario: bare "shop-msg prime" falls back to the slug form (spaces replaced with hyphens) of the CWD-derived name when the literal form does not match a registered canonical name
  Given a lead shop directory tree containing ".claude/shop/name.md" with literal content "shopsystem product" and ".claude/shop/type.md" with literal content "lead"
  And no shop with canonical name "shopsystem product" (with a literal space) is registered in the messaging registry
  And a shop with canonical name "shopsystem-product" (with a hyphen) is registered in the messaging registry as a lead
  And my current working directory is the lead shop directory or a descendant
  When I run "shop-msg prime" with no addressing flags
  Then the command exits zero
  And the command resolves the invoking shop's identity to canonical name "shopsystem-product" and shop type "lead"
  And stdout is the same orientation output that an explicit "shop-msg prime --lead shopsystem-product" invocation from outside the shop directory would produce
  And stderr contains a one-line advisory that the literal CWD-derived name "shopsystem product" was normalized to slug "shopsystem-product" to resolve against the registry
