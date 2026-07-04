@bc:shopsystem-templates @origin:lead-n7dq
Feature: footing/bootstrap script hardening (7 experienced-dev review fixes)
  Net-new tightenings to the footing path scripts: non-interactive authenticated
  git push (credential + author identity), gh repo create without the removed
  --confirm, broker-readiness wait before the first agent-vault call, empty-credential
  abort, a non-placeholder master password in the footing process env, and a
  host-runnable OAuth approve path that blocks until approved.

@scenario_hash:41769b5c79cf2e7b
Scenario: footing authenticates the git push non-interactively without a credential prompt
  Given a footing run that has reached Step 5 with "origin" wired to "https://github.com/<org>/<product>-lead.git" and "GITHUB_TOKEN" exported but no terminal attached to standard input
  When footing reaches its "git push -u origin HEAD" to the HTTPS origin remote
  Then footing has wired git HTTPS authentication from the exported "GITHUB_TOKEN" before that push, either by running "gh auth setup-git" or by tokenizing the remote URL as "https://x-access-token:<token>@github.com/<org>/<product>-lead.git"
  And the "git push -u origin HEAD" completes the authenticated push without emitting an interactive credential prompt for a username or password

@scenario_hash:cb13576263e7fd25
Scenario: footing creates the lead beads repository without passing the removed "--confirm" flag
  Given a footing run on the shipped gh 2.95.0 where the lead beads repository "<org>/<product>-lead-beads" does not yet exist
  When footing reaches Step 3 and invokes "gh repo create" for "<org>/<product>-lead-beads" as a private repository
  Then the "gh repo create" invocation does not pass the "--confirm" flag that gh 2.95.0 removed
  And the beads-repo creation completes successfully under "set -e" rather than aborting on an unknown "--confirm" flag

@scenario_hash:f42957a430752404
Scenario: footing waits for broker readiness before its first agent-vault call
  Given a footing run that has issued "docker compose up -d postgres agent-vault" and self-attached its container to the "<product>" network
  And the agent-vault broker container has started but is not yet listening and unsealed on port 14321
  When footing proceeds toward its first agent-vault call "agent-vault auth login --address http://<product>-agent-vault:14321"
  Then footing polls the broker for readiness on the in-network address with a bounded retry budget after the network self-attach and before that first agent-vault call
  And footing does not issue the first agent-vault call until the broker reports ready, so the call does not fail with a connection-refused race
  And when the readiness budget is exhausted without the broker becoming ready, footing aborts with a diagnostic naming the unready broker

@scenario_hash:0761c8febe333f50
Scenario: footing configures a git author identity before its footing commit
  Given a footing run reaching Step 5 in an environment where git "user.email" and "user.name" are not already configured
  When footing reaches its "git commit" of the poured lead structure
  Then footing has configured a git author identity by setting "user.email" and "user.name" before that commit, derived from the owner email or a deterministic default
  And the "git commit" produces a real commit on HEAD rather than failing for a missing author identity and being swallowed by "|| true"
  And the subsequent "git push -u origin HEAD" pushes that commit rather than running against an unborn or empty HEAD

@scenario_hash:3bd11111684f7874
Scenario: the footing container's process environment does not carry a placeholder master password
  Given a bootstrap run where the run ".env" still holds the "<changeme-...>" placeholder value for "AGENT_VAULT_MASTER_PASSWORD" before footing materializes real values
  When bin/bootstrap launches the footing container that runs "bash ./bin/footing"
  Then the footing container's process environment does not carry a "<changeme>" placeholder value for "AGENT_VAULT_MASTER_PASSWORD"
  And the broker and compose read the master password from the env file the footing run materializes rather than from a placeholder injected into the footing process environment

@scenario_hash:891b8a50343199c3
Scenario: footing presents an operator-runnable approve path and blocks until the CLAUDE_OAUTH proposal is approved
  Given a footing run that has created the oauth-typed CLAUDE_OAUTH credential-slot proposal on the product vault and that proposal is still pending approval
  When footing presents the approve path for that proposal to the operator and continues toward declaring solid footing
  Then the approve path footing presents is runnable from the operator's context, with an address that resolves from where the operator runs it rather than only the in-network "http://<product>-agent-vault:14321" address that does not resolve from the host
  And footing waits for the CLAUDE_OAUTH proposal to reach approved state before it declares solid footing
  And footing does not reach solid footing while the CLAUDE_OAUTH proposal is still unapproved
