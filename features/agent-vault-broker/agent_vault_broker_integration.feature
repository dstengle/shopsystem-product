@bc:shopsystem-product @origin:adr-028 @service:agent-vault-broker
Feature: agent-vault broker lead-owned integration surface

  @scenario_hash:a2d185d636d8ea50
    Scenario: compose.yaml declares the agent-vault broker as a service on the shopsystem network with a persistent vault volume and restart policy
      Given the lead shop's compose.yaml
      When the compose service definitions are inspected
      Then compose.yaml declares an agent-vault broker service distinct from the postgres service
      And the broker service is attached to the shopsystem network with a name alias reachable by sibling containers
      And the broker service mounts a persistent vault volume under the SHOPSYSTEM_DATA convention, outside the repo
      And the broker service is declared with restart policy "unless-stopped"

  @scenario_hash:c33658fddacd00c2
    Scenario: the fleet bring-up entrypoint brings up both the messaging postgres and the agent-vault broker
      Given the agent-vault broker is declared as a supporting service in compose.yaml
      And neither the messaging postgres nor the agent-vault broker container is currently running
      When the single fleet bring-up entrypoint is run
      Then the messaging postgres container is running on the shopsystem network
      And the agent-vault broker container is running on the shopsystem network
      And neither supporting server required a separate manual bring-up step

  @scenario_hash:b97896d59c33e9ce
    Scenario: bringing up the broker via the fleet entrypoint does not remove the lead shell's host credential mounts
      Given the fleet bring-up entrypoint has been extended to bring up the agent-vault broker
      When bin/shop-shell's lead-shell container invocation is inspected
      Then the lead-shell container still bind-mounts the host "~/.claude" directory
      And the lead-shell container still bind-mounts the host "~/.gitconfig" file read-only

  @scenario_hash:1b077fab23d3baaa
    Scenario: a BC's authenticated GitHub push succeeds through the broker with no host credential mount and no BCLAUNCHER_HOST_HOME
      Given the agent-vault broker is running on the shopsystem network provisioned with the real GitHub credential
      And a BC container is running with no host gh or gitconfig credential mount and the launch required no BCLAUNCHER_HOST_HOME
      When the BC performs an authenticated GitHub push to origin through the broker
      Then the push completes successfully against GitHub
      And the request the broker forwards to github.com carries the broker-stored GitHub credential
      And the request as it leaves the container carries no GitHub credential

  @scenario_hash:9a4b07ab772838bd
    Scenario: a BC's Claude request succeeds through the broker with only a placeholder credential in the container
      Given the agent-vault broker is running on the shopsystem network provisioned with the real Claude OAuth credential
      And a BC container is running with no host "~/.claude" mount and only a read-only __PLACEHOLDER__ .credentials.json
      When the BC agent makes a real Claude request through the broker
      Then the Claude request completes successfully
      And the request the broker forwards to api.anthropic.com carries the broker-stored Anthropic Bearer credential
      And the request as it leaves the container carries no real Claude OAuth credential

  @scenario_hash:09ed63d18fe507a7
    Scenario: from inside a running BC container the only credential-bearing secret reachable is the revocable proxy token
      Given a BC container is running under the agent-vault model against the real broker
      When the credential-bearing secrets reachable from inside the container are enumerated
      Then no real Claude OAuth credential value is present in any file or environment variable
      And no real GitHub credential value is present in any file or environment variable
      And the only credential-bearing secret reachable is the revocable AGENT_VAULT_TOKEN, which grants only proxy substitution

  @scenario_hash:9eb97a15c63f81f5
    Scenario: with the host credential mounts absent, the fleet still authenticates because the broker vault holds the credentials
      Given the agent-vault broker vault holds the real Claude OAuth credential and the real GitHub credential
      And no BC container has any host credential mount
      When a BC performs a brokered Claude request and a brokered GitHub operation
      Then both operations authenticate successfully through the broker
      And the host-mounted credential path was not the authentication mechanism for either operation

  @scenario_hash:d52464c2ac9b91c4
    Scenario: launch passes the readiness barrier and sends the startup prompt when both the messaging database and the real broker are reachable
      Given the messaging postgres and the real agent-vault broker are both running and reachable on the shopsystem network
      And no BC container named "bc-shopsystem-messaging" is running
      When bc-container launch is run with BC name "shopsystem-messaging" and a startup prompt
      Then the readiness barrier reports both the messaging-database check and the agent-vault check passed
      And the startup prompt is sent to the tmux session named "agent" in container "bc-shopsystem-messaging"

  @scenario_hash:2264ddea33fe67d4
    Scenario: launch exits non-zero and withholds the startup prompt when the broker is unreachable
      Given the messaging postgres is reachable on the shopsystem network
      And the agent-vault broker on the shopsystem network is not reachable
      And no BC container named "bc-shopsystem-messaging" is running
      When bc-container launch is run with BC name "shopsystem-messaging" and a startup prompt
      Then the command exits non-zero
      And the failure names the broker's configured address on the shopsystem network
      And no startup prompt has been sent to the tmux session named "agent" in container "bc-shopsystem-messaging"

  @scenario_hash:4ecd3b661ddf4713
    Scenario: the broker vault is provisioned by exactly one human-gated paste of the real credentials
      Given a running agent-vault broker with an empty vault
      When the real Claude OAuth credential and the real GitHub credential are loaded into the vault
      Then the only human-gated step performed was a single out-of-band paste of the real credentials
      And after that paste the vault holds the real Claude OAuth credential and the real GitHub credential

  @scenario_hash:72af524bca85f59c
    Scenario: fleet bring-up and BC launch perform no step that reads, writes, or transports a real credential
      Given the broker vault has already been provisioned out of band with the real credentials
      When the fleet is brought up and a BC container is launched against the provisioned broker
      Then no automated step read a real credential from any host file
      And no automated step wrote a real credential into the broker vault
      And no automated step placed a real credential inside the BC container

  @scenario_hash:9bf7669e98c01448
    Scenario: after a broker restart the vault re-opens from the .env master password and brokered auth resumes with no re-paste
      Given a provisioned, running agent-vault broker whose master password is set in the lead .env file
      And a BC's brokered Claude and GitHub operations succeed before the restart
      When the broker container is restarted
      Then the broker re-opens its vault using the master password from the lead .env file
      And the BC's brokered Claude and GitHub operations succeed again after the restart
      And no human re-paste of any real credential was required to restore brokered auth
