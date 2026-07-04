@bc:shopsystem-product @origin:adr-047
Feature: system-manifest coherence gate

  @scenario_hash:b0f74cd354ef7169
  Scenario: the lead repo root carries a committed "system-manifest.yaml" sibling to "bc-manifest.yaml" whose shape is a "releases:" history list plus a "current:" pointer, each release entry pinning a standard-semver "system_version:" on its own line and a "components:" map keyed by canonical "shopsystem-<id>" names
    Given a "lead" shop whose repo root carries the committed "bc-manifest.yaml" fleet registry
    When the lead system-version BOM at the repo root is consulted
    Then a committed file "system-manifest.yaml" exists at the repo root, a sibling of "bc-manifest.yaml" and not under any ".claude/" subdirectory
    And "system-manifest.yaml" carries a top-level "releases:" list and a top-level "current:" pointer whose value names exactly one of the "releases[]" entries by its "system_version:"
    And each "releases[]" entry carries a "system_version:" value that is a standard "MAJOR.MINOR.PATCH" semver recorded on its own line as an independent product-authored line, and a "components:" map whose keys are the canonical "shopsystem-<id>" identity form that "bc-manifest.yaml" uses
    And each release entry's "components:" map pins at minimum the four released component lines "shopsystem-templates", "shopsystem-bc-launcher", "shopsystem-messaging", and "shopsystem-scenarios", each mapped to an explicit version string

  @scenario_hash:c9aff70e92ef409f
  Scenario: "bin/system-manifest assemble" captures a new "releases[]" entry pinning the product-chosen "system_version:" verbatim against the already-released component versions it reads from the lead-5xnd baked image provenance
    Given a "lead" shop with the rendered ops command "bin/system-manifest" and a pulled bc-lead/bc-base image carrying lead-5xnd baked provenance — the OCI labels "org.opencontainers.image.version" (the bc-launcher release) and "shopsystem.shop-templates.version" (the baked shop-templates version)
    And a product-chosen system semver "1.4.0" supplied to the assemble step
    When the operator runs "bin/system-manifest assemble" with the product-chosen system version "1.4.0"
    Then "bin/system-manifest" reads the already-released component versions from the pulled image's baked provenance via a "docker image inspect" read of the "org.opencontainers.image.version" and "shopsystem.shop-templates.version" labels (or a "printenv" read of the container ENV "SHOPSYSTEM_BC_LAUNCHER_VERSION" / "SHOP_TEMPLATES_VERSION"), without invoking "pip show" or any python in the image
    And it appends a new "releases[]" entry to "system-manifest.yaml" whose "system_version:" is the supplied "1.4.0" recorded verbatim as authored and never computed from the component versions, and whose "components:" map pins "shopsystem-bc-launcher" and "shopsystem-templates" to the exact versions it read from the baked provenance
    And the exit code is 0

  @scenario_hash:16a03e7e76772ad8
  Scenario: "bin/system-manifest validate" warns on published-coherence drift between the manifest-pinned tuple and the lead-5xnd baked image versions but exits 0 at authoring/dev-time so a deliberately-ahead-of-the-view pin is not blocked
    Given a "lead" shop with the rendered ops command "bin/system-manifest" and a "system-manifest.yaml" whose "current:" release pins a "shopsystem-bc-launcher" version that differs from the "org.opencontainers.image.version" baked into the pulled bc-lead/bc-base image's lead-5xnd provenance
    When the operator runs "bin/system-manifest validate" at authoring/dev-time
    Then "bin/system-manifest validate" reports a published-coherence drift warning that names the incoherent component "shopsystem-bc-launcher", the manifest-pinned version, and the observed baked version it read from the image provenance
    And despite the reported drift the command exits with code 0, so the advisory warns loudly without blocking a deliberately-ahead-of-the-published-view pin

  @scenario_hash:8a653d96a2b14ca3
  Scenario: at adopter bootstrap/stand-up an incoherent manifest tuple is refused — bootstrap does not stand up the shop and exits non-zero with a diagnostic naming the incoherent component, the manifest-pinned version, the observed baked version, and a remediation
    Given an adopter fork whose deterministic agent-less "bin/bootstrap" runs the system-manifest published-coherence check as a stand-up step
    And the manifest's "current:" release pins a "shopsystem-bc-launcher" version that does not match the version baked into the pulled image's lead-5xnd provenance — the "org.opencontainers.image.version" label or the "SHOPSYSTEM_BC_LAUNCHER_VERSION" ENV
    When the adopter runs "bin/bootstrap" and it pulls the image and runs the stand-up coherence check against the manifest's "current:" tuple
    Then bootstrap does not stand up the shop — it does not invoke the render step against the incoherent tuple, so no shop is stood up from it
    And bootstrap exits non-zero with a diagnostic that names the incoherent component "shopsystem-bc-launcher", the manifest-pinned version, the observed baked version it read from the image provenance, and an actionable remediation for obtaining a coherent tuple

  @scenario_hash:c1e62eef25ad9484
  Scenario: at adopter bootstrap/stand-up a coherent manifest tuple passes the published-coherence stand-up gate and bootstrap proceeds to stand up the shop
    Given an adopter fork whose deterministic agent-less "bin/bootstrap" runs the system-manifest published-coherence check as a stand-up step
    And every component in the manifest's "current:" release that carries lead-5xnd baked provenance — "shopsystem-bc-launcher" and "shopsystem-templates" — pins a version that matches the version baked into the pulled image ("org.opencontainers.image.version" and "shopsystem.shop-templates.version")
    When the adopter runs "bin/bootstrap" and it pulls the image and runs the stand-up coherence check against the manifest's "current:" tuple
    Then the published-coherence stand-up check passes because every baked-provenance component the manifest pins matches the observed baked version read from the image provenance
    And bootstrap proceeds to stand up the shop by invoking the render step against the coherent tuple

  @scenario_hash:0462a55392e2f5b8
  Scenario: "bin/doctor" runs an additive system-manifest published-coherence check on the PDR-024 D3 diagnosis surface that reports the published-coherence drift result as a non-fatal advisory line at dev-time
    Given a "lead" shop with the rendered ops command "bin/doctor" carrying an additive system-manifest published-coherence check alongside the existing messaging-DB, agent-vault, and Claude checks
    And the manifest's "current:" release pins a "shopsystem-bc-launcher" version that differs from the version baked into the pulled image's lead-5xnd provenance
    When the operator runs "bin/doctor" at dev-time
    Then "bin/doctor" reports a named "system-manifest coherence" check line on the PDR-024 D3 diagnosis surface — a name, a status, and a remediation hint — that reports the published-coherence drift result naming the incoherent component "shopsystem-bc-launcher" and the manifest-pinned and observed baked versions
    And the coherence line is folded into doctor's aggregate as a non-fatal advisory at dev-time, so a coherence drift warning does not by itself force a non-zero aggregate exit (consistent with scenario 218, @scenario_hash:027a4d836bb1ae43, whose aggregate rule over the hard credential and connection checks is unchanged)
