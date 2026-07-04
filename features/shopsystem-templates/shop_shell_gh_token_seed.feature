@bc:shopsystem-templates @origin:lead-b6f2
Feature: shop-shell seeds a non-empty placeholder GH_TOKEN into the launched leaf-BC session (lead-b6f2)
  The rendered bin/shop-shell carries a non-empty placeholder GH_TOKEN into the
  launched leaf so a freshly-launched leaf agent can invoke `gh` against the
  agent-vault broker out of the box, without the operator first running
  `export GH_TOKEN=...` by hand. The seeded value is a PLACEHOLDER literal, never
  the real PAT — the broker substitutes the real GitHub credential on the wire.
  Additive to scenario 172 (725562869d9df919): a placeholder GH_TOKEN env value
  is NOT a host credential mount, so 172's prohibitions are not weakened.

@scenario_hash:0789db8bb7f3bc73
Scenario: the rendered shop-owned bringup path seeds a non-empty placeholder GH_TOKEN into the launched leaf-BC session so gh attempts the brokered call out of the box without a manual operator export
  Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops script "bin/shop-shell"
  And an agent-vault broker that injects the REAL GitHub credential on the wire for github.com / api.github.com requests, so a leaf agent never needs the real PAT in its own environment
  When the operator runs the rendered "bin/shop-shell" to launch the leaf-BC session
  Then the rendered "bin/shop-shell" delivers a non-empty "GH_TOKEN" into the launched leaf-BC session environment — its body passes "GH_TOKEN" set to a non-empty placeholder literal into the launch (the body contains the literal substring "GH_TOKEN=" assigned a non-empty value) rather than leaving "GH_TOKEN" unset
  And the "GH_TOKEN" value reaching the launched leaf-BC session is a non-empty placeholder token, NOT the real GitHub PAT — the broker substitutes the real credential on the wire
  And a freshly-launched leaf agent can therefore invoke "gh" against the broker without the operator first running "export GH_TOKEN=..." by hand
