@bc:shopsystem-templates @origin:pdr-022 @service:agent-vault-broker
Feature: footing delegates credential provisioning to bin/agent-vault-provision (PDR-022 Phase A)
  footing invokes bin/agent-vault-provision instead of inlining vault-create/PAT-store/
  proposal-create; provision owns the full broker-local sequence + the OAuth proposal,
  and footing keeps only the human approve gate.

@scenario_hash:b0d768766fc276dc
Scenario: footing invokes bin/agent-vault-provision for credential provisioning instead of inlining it
  Given footing has reached the point in its runway where the agent-vault broker is up and ready
  And the single up-front auth gate has collected the owner password and the GitHub PAT
  When footing performs credential provisioning
  Then it invokes "bin/agent-vault-provision" as the provisioning step
  And it does not inline its own vault-create, broker-local PAT store, or OAuth proposal-create
  And provision resolves the slug, container, vault, and broker address from the shared ops-coordinates artifact rather than footing passing a divergent set

  @scenario_hash:7985e6b3a173ff7f
  Scenario: provisioning mints the fleet token, writes the vault env back, stores the GitHub credential, and wires the services
    Given a running agent-vault broker with an empty vault
    And footing is bringing up a shop whose slug is acme
    When footing invokes bin/agent-vault-provision
    Then an acme-fleet agent token is minted
    And AGENT_VAULT_TOKEN, AGENT_VAULT, and AGENT_VAULT_CA_PEM are written to .env
    And the GitHub credential is stored in the vault
    And the github-git and github-api services and the claude-api, claude-platform, and claude-mcp-proxy services are wired

@scenario_hash:8c975527b49e98d7
Scenario: provision owns the OAuth proposal-create and footing keeps only the human-gated approve handoff
  Given footing delegates credential provisioning to "bin/agent-vault-provision"
  When footing reaches the Claude OAuth step of its runway
  Then provision is the step that creates the CLAUDE_OAUTH proposal, and footing does not inline a proposal-create
  And footing presents the operator the exact "bin/agent-vault-approve-claude" command and waits for the proposal to be approved before continuing
  And no later footing step re-creates the proposal or re-prompts for the OAuth credential

@scenario_hash:b0d1e5045cf3c01b
Scenario: provision creates the product vault and stores the GitHub PAT broker-locally
  Given a running agent-vault broker reachable broker-locally via docker exec
  And the owner password and the GitHub username and PAT are available to provision
  When "bin/agent-vault-provision" runs
  Then it registers the owner and creates the "<slug>" vault, so the vault exists after provision completes
  And it stores the GitHub PAT in the "<slug>" vault via a broker-local docker-exec credential set, so the stored credential is retrievable broker-locally
  And these credential operations run broker-local docker-exec only, never through the owner remote scoped session or a fleet agent token
