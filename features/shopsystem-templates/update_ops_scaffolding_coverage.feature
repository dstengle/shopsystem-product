@bc:shopsystem-templates @origin:adr-043
Feature: shop-templates update — ops scaffolding coverage

  @scenario_hash:3c496f8858b6b033
  Scenario: "shop-templates update" against a "lead" shop does not modify the ops scaffolding files ("compose.yaml", "bin/shop-shell") under any circumstances on the success path, because per PDR-003 path F's two-bucket model those files are shop-owned (not canonical-managed) — this is the ops-scaffolding analogue of scenarios 86, 87, and 88 (".claude/shop/" non-touch invariants)
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "shopsystem-product"
    And the file at "compose.yaml" in the target directory has been hand-edited so that its byte contents are not equal to the canonical "compose.yaml" template body for shop type "lead"
    And the file at "bin/shop-shell" in the target directory has been hand-edited so that its byte contents are not equal to the canonical "bin/shop-shell" template body for shop type "lead"
    And I record the byte contents of those two files before the invocation
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the byte contents of the file at "compose.yaml" in the target directory equal the recorded byte contents
    And after the invocation the byte contents of the file at "bin/shop-shell" in the target directory equal the recorded byte contents

  @scenario_hash:29caed838aebe9f7
  Scenario Outline: "shop-templates update" against a "lead" shop emits an advisory on stderr (naming the file, the drift, and the canonical refresh path) for each ops scaffolding file whose on-disk content differs from the current canonical template — surfacing canonical evolution to the operator without violating the shop-owned-file rule from scenario 139; this is the ops-scaffolding analogue of scenario 132's "name.md" advisory pattern
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "shopsystem-product"
    And the file at "<path>" in the target directory has byte contents that differ from the current canonical "<path>" template body for shop type "lead"
    And I record the byte contents of the file at "<path>" in the target directory before the invocation
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the file at "<path>" in the target directory has byte-for-byte the same on-disk contents as before the invocation
    And stderr contains an advisory naming the file path "<path>" and noting that the file has drifted from canonical
    And the advisory explicitly notes that "shop-templates update" did not modify the shop-owned file
    And the advisory names a means for the operator to view the canonical body (e.g., the literal substring "shop-templates show" or an equivalent operator-visible path the canonical body can be read from)

    Examples:
      | path                          |
      | compose.yaml                  |
      | bin/shop-shell                |

  @scenario_hash:953b2102a6924c28
  Scenario Outline: "shop-templates update" against a "lead" shop whose ops scaffolding files match the current canonical template body byte-for-byte exits zero, emits no advisory for those files on stderr, and leaves on-disk byte contents and mtimes unchanged — the same idempotence guarantee scenario 89 pins for the canonical-managed surface, extended to the shop-owned ops scaffolding for the "already up to date" case
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "shopsystem-product"
    And the file at "<path>" in the target directory has byte contents equal to the current canonical "<path>" template body for shop type "lead"
    And I record the byte contents and mtime of the file at "<path>" in the target directory before the invocation
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the byte contents of the file at "<path>" in the target directory equal the recorded byte contents
    And after the invocation the mtime of the file at "<path>" in the target directory equals the recorded mtime
    And stderr does not contain any advisory naming the file path "<path>"

    Examples:
      | path                          |
      | compose.yaml                  |
      | bin/shop-shell                |

  @scenario_hash:8e5955d5fb5bb9c8
  Scenario: "shop-templates update" against an existing "lead" shop whose "bin/ops-coordinates" has drifted from the current canonical render refreshes it in place — overwriting the stale on-disk body with the current canonical render-tokens body for that shop type and name (the same ADR-043 D2 content contract pinned by the bootstrap render, scenario 211 @scenario_hash:0a3a8267109b5792, and by the create-if-absent update path, scenario 213 @scenario_hash:dd82193e56e52d95) — because ops-coordinates is a derived single-source managed-render artifact whose only customization path is environment override, so update OWNS its refresh exactly as it re-pours the managed agent files (scenarios 35/36) and the managed lead skill group (scenarios 162-164), and does NOT apply the shop-owned drift-advisory contract it uses for "compose.yaml" and "bin/shop-shell" (scenarios 139/140); so an already-bootstrapped repo carrying a pre-current ops-coordinates adopts the canonical artifact via update without a re-bootstrap
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "shopsystem-product"
    And the target directory contains a file at "bin/ops-coordinates" whose byte contents differ from the current canonical "bin/ops-coordinates" render-tokens body for shop type "lead" and shop name "shopsystem-product" (the stale/drifted adoption state of a repo bootstrapped before the current canonical artifact existed)
    And I record the byte contents of the file at "bin/ops-coordinates" before the invocation
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the target directory contains a file at "bin/ops-coordinates" not under any ".claude/" subdirectory
    And after the invocation the byte contents of "bin/ops-coordinates" are not equal to the recorded byte contents, so the stale on-disk body was replaced rather than preserved or merely advised on
    And after the invocation the byte contents of "bin/ops-coordinates" equal what the "shop-templates" bootstrap render-tokens path writes to "bin/ops-coordinates" for shop type "lead" and shop name "shopsystem-product" — the same ADR-043 D2 content contract pinned by scenario 211 (@scenario_hash:0a3a8267109b5792)
    And sourcing "bin/ops-coordinates" in a bash shell succeeds with exit code 0 and defines the shell variables OPS_SLUG, OPS_NETWORK, OPS_POSTGRES_CONTAINER, OPS_VAULT_CONTAINER, OPS_VAULT_NAME, OPS_BROKER_ADDR, OPS_POSTGRES_PORT, OPS_VAULT_API_PORT, OPS_VAULT_PROXY_PORT, OPS_DATA_ROOT, OPS_LEAD_BEADS_REPO, OPS_BC_BEADS_REPO_FMT, OPS_ORG, and OPS_FRAMEWORK_IMAGE
    And after sourcing the refreshed artifact with no override environment set, OPS_BC_BEADS_REPO_FMT resolves to "shopsystem-{bc}-beads" with the literal "{bc}" placeholder intact (the _ops_slug strips the trailing "-product" per the 211 slug contract @scenario_hash:0a3a8267109b5792, so the rendered-and-sourced value is byte-equal-consistent with the bootstrap render contract asserted above), and OPS_FRAMEWORK_IMAGE resolves to a non-empty value, so the canonical "bin/shop-shell" that sources this refreshed artifact with no literal fallback resolves neither an empty launch image nor a placeholder-destroyed beads-repo format

  @scenario_hash:4c646ae20a1540e3
  Scenario: "shop-templates update" against an existing "lead" shop that has no "bin/ops-coordinates" renders the single shell-sourceable ops-coordinates artifact for it — derived from the manifest "product:" root and carrying the same ADR-043 D2 content contract the bootstrap render-tokens path produces (scenario 211, @scenario_hash:0a3a8267109b5792) — so that after "update" an existing repo (past its first bootstrap) has a sourceable "bin/ops-coordinates" matching what "bootstrap" would write, and the canonical "bin/shop-shell" that sources it with no literal fallback no longer resolves OPS_FRAMEWORK_IMAGE or the other coordinate keys empty; ops-coordinates is a derived single-source artifact that update RENDERS, not a hand-edited shop-owned script it only advises on (contrast scenarios 139 and 140)
    Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "shopsystem-product"
    And the target directory contains no file at "bin/ops-coordinates" (the pre-artifact adoption state of a repo bootstrapped before the artifact existed)
    When I invoke the "shop-templates" update entry point against the target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And after the invocation the target directory contains a file at "bin/ops-coordinates" not under any ".claude/" subdirectory
    And the byte contents of "bin/ops-coordinates" equal what the "shop-templates" bootstrap render-tokens path writes to "bin/ops-coordinates" for shop type "lead" and shop name "shopsystem-product" — the same ADR-043 D2 content contract pinned by scenario 211 (@scenario_hash:0a3a8267109b5792)
    And sourcing "bin/ops-coordinates" in a bash shell succeeds with exit code 0 and defines the shell variables OPS_SLUG, OPS_NETWORK, OPS_POSTGRES_CONTAINER, OPS_VAULT_CONTAINER, OPS_VAULT_NAME, OPS_BROKER_ADDR, OPS_POSTGRES_PORT, OPS_VAULT_API_PORT, OPS_VAULT_PROXY_PORT, OPS_DATA_ROOT, OPS_LEAD_BEADS_REPO, OPS_BC_BEADS_REPO_FMT, OPS_ORG, and OPS_FRAMEWORK_IMAGE
    And after sourcing with no override environment set, OPS_BC_BEADS_REPO_FMT resolves to "shopsystem-{bc}-beads" (the slug-strip contract of scenario 211, @scenario_hash:0a3a8267109b5792, applies "_ops_slug" to the shop name "shopsystem-product" yielding slug "shopsystem") with the literal "{bc}" placeholder intact, and OPS_FRAMEWORK_IMAGE resolves to a non-empty value, so the canonical "bin/shop-shell" that sources this artifact with no literal fallback resolves neither an empty launch image nor a placeholder-destroyed beads-repo format
