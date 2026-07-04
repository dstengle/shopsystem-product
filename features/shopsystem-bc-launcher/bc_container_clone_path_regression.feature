@bc:shopsystem-bc-launcher @origin:lead-uiwu @service:agent-vault-broker
Feature: bc-container launch clone-path regression guards (lead-uiwu)

  @scenario_hash:bdec2754d9135086
    Scenario: bc-container launch with no --repo-url and no --workspace-mount resolves the BC remote from bc-manifest.yaml and clones it into the container's /workspace
      Given the shopsystem-bc-launcher BC is installed
      And the bc-manifest.yaml registers the BC "shopsystem-templates" with a valid git remote URL, and is the declared source of remote URLs when launching BCs
      And no "--repo-url" flag and no "--workspace-mount" flag are provided
      And no Docker container named "bc-shopsystem-templates" is running
      When I run bc-container launch with BC name "shopsystem-templates"
      And the container starts
      Then the command exits zero
      And the "/workspace" directory inside the running container "bc-shopsystem-templates" is a git repository cloned from the remote URL registered for "shopsystem-templates" in bc-manifest.yaml

  @scenario_hash:0b50d090c9cc3c45
    Scenario: bc-container launch fails loudly when no repo source is resolvable instead of silently launching an empty /workspace
      Given the shopsystem-bc-launcher BC is installed
      And no "--repo-url" flag and no "--workspace-mount" flag are provided
      And bc-manifest.yaml carries no resolvable git remote URL for the BC "shopsystem-norepo"
      When I run bc-container launch with BC name "shopsystem-norepo"
      Then the command exits non-zero
      And the error output explicitly states that no repo source — neither "--repo-url", "--workspace-mount", nor a bc-manifest.yaml remote — could be resolved for "shopsystem-norepo"
      And the launch does not silently succeed leaving an empty, non-git "/workspace"

  @scenario_hash:4154b0ea63d0516b
    Scenario: a launched BC's /workspace is owned by the agent user so the in-container clone performed as that user succeeds without Permission denied
      Given the shopsystem-bc-launcher BC is installed
      And bc-container launch is run with BC name "shopsystem-templates" with a valid repo URL
      And the container "bc-shopsystem-templates" is running
      When the ownership of the "/workspace" directory inside the running container is inspected
      Then "/workspace" is owned by the agent user "vscode" (uid 1000), not by root
      And the clone performed into "/workspace" as the agent user completes without a "/workspace/.git: Permission denied" error

  @scenario_hash:09f871cf8b99a34b
  Scenario: a launched BC materializes the agent-vault MITM root CA as a non-empty certificate file at the path git is configured to trust, so a clone routed through HTTPS_PROXY passes TLS verification
    Given the shopsystem-bc-launcher BC is installed
    And the launched BC routes outbound HTTPS through the agent-vault MITM proxy via "HTTPS_PROXY", so the clone's TLS is terminated by the broker MITM and requires the broker root CA to verify
    When bc-container launch is run with BC name "shopsystem-test-harness" via the no-flag manifest-resolution clone path and the running container is inspected before the in-container clone runs
    Then a regular file exists inside the running container at the exact path git is configured to use as its CA bundle, and that file is non-empty and its first line is "-----BEGIN CERTIFICATE-----"
    And "git config --global http.sslCAInfo" inside the container names that existing CA file (or, equivalently, the agent-vault broker root CA is installed into the system trust store git uses by default), so git is never pointed at a CA path that does not exist
    And the in-container clone of "shopsystem-test-harness" routed through "HTTPS_PROXY" completes its TLS handshake with neither an "error setting certificate file" error nor an "SSL certificate problem: unable to get local issuer certificate" error

