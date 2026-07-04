@bc:shopsystem-templates @origin:lead-8vxy @service:agent-vault-broker
Feature: ops provision lead-driveable — the non-OAuth-secret inputs (owner password, GitHub username/PAT) arrive via env/args with NO interactive prompt, and the ONE genuine human step (approving the CLAUDE_OAUTH proposal) is isolated into a clean lead-presentable handoff that reports the proposal number plus the exact approve command, while the real Claude OAuth secret is supplied ONLY at approve-time and no automated step transports it

  @scenario_hash:1d08c456af08d577
  Scenario: provision takes non-OAuth inputs via env/args and isolates the OAuth approval into a lead-presentable handoff
    Given a running agent-vault broker with an empty vault
    And the owner password and the GitHub username and PAT are supplied via environment variables or arguments
    When the lead runs bin/agent-vault-provision
    Then it consumes the owner password and the GitHub username and PAT from the environment or arguments without any interactive prompt
    And it stores the GitHub credential in the vault without the lead handling any real Claude OAuth secret
    And it creates a CLAUDE_OAUTH proposal and reports the proposal number together with the exact "proposal approve <num> CLAUDE_OAUTH=<value> --yes" command for the user to run
    And the real Claude OAuth secret is supplied only at approve-time and no automated step transports it
