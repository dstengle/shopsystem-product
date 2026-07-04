@bc:shopsystem-templates @origin:lead-7s4k
Feature: footing upserts the generated .env credentials into a pre-existing .env
  footing GENERATES the master password, broker address, owner password, and owner
  email and UPSERTS them directly into .env (append-when-absent, not rewrite-existing-
  only), so the real values reach 'docker compose up' even when bin/bootstrap
  pre-created .env — fixing the blank-broker 'variable is not set'. The owner password
  is generated, not prompted.

@scenario_hash:bd3bd4e0989e1ac2
Scenario: footing upserts a generated master password into a pre-existing .env so compose reads a real value
  Given bin/bootstrap has pre-created .env containing only a BC_BASE_IMAGE_RESOLVED line and no AGENT_VAULT_MASTER_PASSWORD line
  And .env therefore carries none of the .env.example placeholder keys
  When footing runs its .env initialization
  Then .env contains exactly one AGENT_VAULT_MASTER_PASSWORD line
  And that line's value is a generated secret that is neither empty nor a <changeme> placeholder
  And the pre-existing BC_BASE_IMAGE_RESOLVED line is preserved unchanged
  And docker compose up interpolates ${AGENT_VAULT_MASTER_PASSWORD} to that same non-empty generated value with no "variable is not set" warning

@scenario_hash:82e50776dec1bdd5
Scenario: footing upserts the constructed AGENT_VAULT_ADDR into a pre-existing .env that lacks the key
  Given bin/bootstrap has pre-created .env containing only a BC_BASE_IMAGE_RESOLVED line and no AGENT_VAULT_ADDR line
  When footing runs its .env initialization
  Then .env contains exactly one AGENT_VAULT_ADDR line
  And that line's value is the constructed in-network broker address and is neither empty nor a <changeme> placeholder
  And docker compose up interpolates ${AGENT_VAULT_ADDR} to that same constructed address with no "variable is not set" warning

@scenario_hash:2ea8e65a67972bd9
Scenario: footing generates the agent-vault owner password instead of prompting and upserts it into a pre-existing .env
  Given bin/bootstrap has pre-created .env containing only a BC_BASE_IMAGE_RESOLVED line and no AGENT_VAULT_OWNER_PASSWORD line
  And no AGENT_VAULT_OWNER_PASSWORD value is pre-exported in the environment
  When footing runs its auth gate
  Then footing does not prompt the operator for an owner password
  And .env contains exactly one AGENT_VAULT_OWNER_PASSWORD line
  And that line's value is a generated secret that is neither empty nor a <changeme> placeholder
  And the pre-existing BC_BASE_IMAGE_RESOLVED line is preserved unchanged
  And footing registers the agent-vault owner account using that same generated owner password

@scenario_hash:3509dc40a5e5c3a0
Scenario: footing captures the agent-vault owner identity in .env by upserting AGENT_VAULT_OWNER_EMAIL
  Given bin/bootstrap has pre-created .env containing only a BC_BASE_IMAGE_RESOLVED line and no AGENT_VAULT_OWNER_EMAIL line
  When footing runs its auth gate
  Then .env contains exactly one AGENT_VAULT_OWNER_EMAIL line
  And that line's value is the owner account identity and is neither empty nor a <changeme> placeholder
  And footing registers the agent-vault owner account under that same recorded identity
