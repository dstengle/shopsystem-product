@bc:shopsystem-templates @origin:lead-mrn2 @service:agent-vault-broker
Feature: lead<->broker agent-vault interaction is local-first and the .env lifecycle is scripted
  The lead host runs agent-vault LOCALLY against AGENT_VAULT_ADDR (the in-network
  broker) rather than docker-exec into the broker container, and the .env lifecycle
  is scripted: a generated master password + real broker address before compose up,
  the broker-dependent values completed after provision, and the expiry probe targets
  the credential key provision actually stores.

  @scenario_hash:9018e13b749bec95
  Scenario: a scripted init step writes .env from .env.example with a generated master password and a real broker address before the broker starts
    Given a target lead shop with a rendered ".env.example" carrying placeholder broker values and no ".env" yet
    When the operator runs the scripted ".env" initialization step before "docker compose up agent-vault"
    Then it creates ".env" from ".env.example"
    And the "AGENT_VAULT_MASTER_PASSWORD" value in ".env" is a generated high-entropy secret and is not empty and is not a placeholder
    And the "AGENT_VAULT_ADDR" value in ".env" is a real reachable broker address and is not the placeholder "<changeme-broker-address>"
    And the master password is present in ".env" before the agent-vault broker is started, so the broker can unseal from it

  @scenario_hash:de0a0e7ecf73c382
  Scenario: agent-vault-provision drives the broker locally against AGENT_VAULT_ADDR rather than docker exec into the broker container
    Given a rendered "bin/agent-vault-provision" and a ".env" whose "AGENT_VAULT_ADDR" points at the running broker
    When the provision script issues its auth, vault, credential, service, agent, ca, and proposal commands
    Then each of those "agent-vault" invocations runs locally on the lead host and targets the broker at "AGENT_VAULT_ADDR" read from ".env"
    And none of the auth, vault, credential, service, agent, ca, or proposal verbs is issued as a "docker exec" into the broker container
    And any remaining "docker exec" into the broker is limited to a step that genuinely cannot run locally and carries an inline justification for why it remains

  @scenario_hash:444d63e95c64f4c4
  Scenario: after a successful provision the broker-dependent .env values are completed and no longer placeholders
    Given a running agent-vault broker reachable at the "AGENT_VAULT_ADDR" in ".env" and a ".env" still carrying placeholder broker-token, vault, and CA values
    When the operator runs "bin/agent-vault-provision" to completion successfully
    Then the "AGENT_VAULT_TOKEN" value in ".env" is the minted fleet token beginning with "av_agt_" and is not the placeholder "<changeme-broker-token>"
    And the "AGENT_VAULT_VAULT" value in ".env" is the provisioned vault name and is not the placeholder "<changeme-broker-vault>"
    And the "AGENT_VAULT_CA_PEM" value in ".env" is the fetched broker CA material or its path and is not the placeholder "<changeme-broker-ca-pem>"
    And none of "AGENT_VAULT_TOKEN", "AGENT_VAULT_VAULT", or "AGENT_VAULT_CA_PEM" remains a placeholder after a successful provision

  @scenario_hash:65f3726f31595766
  Scenario: agent-vault-check verifies the provisioned credentials with a single local agent-vault command rather than a docker exec into the broker
    Given a provisioned broker reachable at the "AGENT_VAULT_ADDR" in ".env" and a rendered "bin/agent-vault-check"
    When the operator runs "bin/agent-vault-check"
    Then its "agent-vault" probe runs locally on the lead host and targets the broker at "AGENT_VAULT_ADDR" read from ".env"
    And it does not issue a "docker exec" into the broker container to verify or advise on the credentials
    And a single local "agent-vault" command suffices to confirm the provisioned credentials, so no separate standalone "docker exec" credential-list verification step is required

  @scenario_hash:8b766a2b929af301
  Scenario: the agent-vault-check expiry probe queries the credential key that provision actually stores so the advisory can fire
    Given a broker whose vault holds the GitHub credential under the key "GITHUB_TOKEN" that "bin/agent-vault-provision" stores, and that credential is within the expiry warning threshold
    When the operator runs "bin/agent-vault-check"
    Then its expiry probe targets the credential key "GITHUB_TOKEN" that provision stores
    And it does not probe a non-existent credential named "github-pat"
    And it emits the impending-expiry advisory for the credential that is within the warning threshold
    And it still exits with status 0 because the advisory is non-fatal
