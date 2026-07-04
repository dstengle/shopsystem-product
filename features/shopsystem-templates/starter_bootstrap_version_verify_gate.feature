@bc:shopsystem-templates @origin:pdr-026
Feature: the starter bin/bootstrap verifies the pulled image's baked shop-templates version before the in-image render (lead-b2iz)

  bin/bootstrap pulls the bc-lead/bc-base image on a floating tag and then runs
  the in-image `shop-templates bootstrap` render. A stale or cached :latest (or
  a silent pull/auth fallback to cache) would otherwise render an ANCIENT shop
  (no AGENT_VAULT_CA_PEM, hardcoded product name) with no signal. This bugfix
  TIGHTENS the existing pull->render flow by inserting a baked-version VERIFY
  GATE — read the pulled image's PDR-026 provenance (the OCI label
  "shopsystem.shop-templates.version" or the container ENV
  "SHOP_TEMPLATES_VERSION", NOT `pip show` / python-in-image) and compare it to
  an expected-minimum floor known to bin/bootstrap — BEFORE the render. At or
  above the floor proceeds (current behavior preserved); below the floor
  refuses loudly: no render, non-zero exit, a diagnostic naming the stale
  version, the expected minimum, and an actionable remediation. The gate sits
  BEFORE the render step that scenario 187 pins and does not contradict it.
  (PDR-026, ADR-040; additive to PDR-019 U1/U3.)

  @scenario_hash:4457c8c280d4fbf4
  Scenario: bootstrap reads the pulled image's baked shop-templates version and proceeds when it meets the expected minimum
    Given an adopter fork whose "bin/bootstrap" resolves the bc-lead/bc-base image on a floating tag
    And the pulled image carries baked shop-templates provenance per PDR-026 — the OCI label "shopsystem.shop-templates.version" and the container ENV "SHOP_TEMPLATES_VERSION"
    And that baked shop-templates version is at or above the expected-minimum shop-templates version known to "bin/bootstrap"
    When the adopter runs "bin/bootstrap" and it pulls the image
    Then bootstrap reads the baked shop-templates version from the pulled image's provenance via a "docker image inspect" read of the "shopsystem.shop-templates.version" label (or a "printenv SHOP_TEMPLATES_VERSION" read of a container started from it), without invoking "pip show" or any python in the image
    And because the read version is at or above the expected minimum, bootstrap proceeds to render the shop via the in-image "shop-templates bootstrap"

  @scenario_hash:e9d64a8acc917efb
  Scenario: bootstrap refuses to render and exits loudly when the pulled image's baked shop-templates version is below the expected minimum
    Given an adopter fork whose "bin/bootstrap" resolves the bc-lead/bc-base image on a floating tag
    And the pull resolves a stale or cached image whose baked shop-templates version — read from the PDR-026 "shopsystem.shop-templates.version" label or "SHOP_TEMPLATES_VERSION" ENV — is below the expected-minimum shop-templates version known to "bin/bootstrap"
    When the adopter runs "bin/bootstrap" and it pulls that stale image
    Then bootstrap does not invoke the in-image "shop-templates bootstrap" render step against the stale image, so no shop is rendered from it
    And bootstrap exits non-zero with a diagnostic that names the stale baked shop-templates version it read, the expected-minimum version it required, and an actionable remediation for obtaining the current image
