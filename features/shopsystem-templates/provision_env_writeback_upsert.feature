@bc:shopsystem-templates @origin:lead-qswi @service:agent-vault-broker
Feature: agent-vault-provision upserts the broker coordinates into a pre-created .env
  provision's .env writeback appends AGENT_VAULT_ADDR/TOKEN/VAULT/CA_PEM when absent
  (the bin/bootstrap pre-created state), not only rewriting existing placeholder lines.

  @scenario_hash:657968ae75698fbd
  Scenario: agent-vault-provision upserts broker coordinates into a pre-created .env lacking placeholder lines
    Given a repo whose .env was pre-created by bin/bootstrap and exists
    And that .env contains no AGENT_VAULT_ADDR, AGENT_VAULT_TOKEN, AGENT_VAULT_VAULT, or AGENT_VAULT_CA_PEM line
    And the broker minted a real fleet token, vault name, and CA pem path
    When bin/agent-vault-provision performs its .env writeback against that file
    Then the .env afterward contains an AGENT_VAULT_ADDR line set to the real broker address
    And the .env contains an AGENT_VAULT_TOKEN line set to the real minted fleet token
    And the .env contains an AGENT_VAULT_VAULT line set to the real vault name
    And the .env contains an AGENT_VAULT_CA_PEM line set to the real CA pem path
    And none of those four values is the literal <changeme> placeholder text
    And each key appears exactly once in the .env
