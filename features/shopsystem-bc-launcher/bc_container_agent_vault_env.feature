@bc:shopsystem-bc-launcher @origin:brief-013 @service:agent-vault-broker
Feature: bc-container launch injects operator-supplied agent-vault credentials into the container env

  # bclaunch-5hi (critical path): controller.launch() injected ONLY
  # HTTPS_PROXY into the container env.  The in-container `agent-vault run`
  # client also needs AGENT_VAULT_ADDR, AGENT_VAULT_TOKEN and AGENT_VAULT_VAULT
  # to authenticate to the broker.  These are OPERATOR-SUPPLIED at launch
  # (from --env-file / process env / launch() params) and the token value is
  # NEVER a literal baked into source — the only credential literal in src/ is
  # the existing "__PLACEHOLDER__" for .credentials.json.

  @scenario_hash:3d853e20c0baafc4
  Scenario: a launched BC container carries the operator-supplied AGENT_VAULT_ADDR, token and vault in its env
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_operator_supplied_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the container env has AGENT_VAULT_ADDR set to "https://agent-vault:14321"
    And the container env has AGENT_VAULT_TOKEN set to "av_agt_operator_supplied_xyz"
    And the container env has AGENT_VAULT_VAULT set to "shopsystem"

  @scenario_hash:b958e0e9f558b714
  Scenario: no real agent-vault token literal is baked into the launcher source
    Given the shopsystem-bc-launcher BC is installed
    When the launcher source tree under src/ is scanned for credential literals
    Then no AGENT_VAULT_TOKEN value is hard-coded in src/
    And the only credential literal present in src/ is the placeholder "__PLACEHOLDER__"
