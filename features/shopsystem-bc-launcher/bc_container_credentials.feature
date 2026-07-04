@bc:shopsystem-bc-launcher @origin:brief-013 @service:agent-vault-broker
Feature: bc-container launch brokers BC-container credentials through agent-vault

  # ADR-026 (accepted 2026-06-09) supersedes the host-credential-mount model.
  # Zero host-filesystem credential coupling reaches a BC container, for BOTH
  # Claude OAuth and GitHub.  The agent-vault broker is the SOLE credential
  # path; there is no launch-mode flag and no host-mount fallback.  Dispatched
  # on lead-v4ih, unblocked by lead-hxb8.

  @scenario_hash:6952248a419ca56b
  Scenario: a launched BC container has no host ~/.claude credential directory mount
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run with BC name "shopsystem-messaging"
    And the container "bc-shopsystem-messaging" is running
    When the container's bind mounts are inspected via docker inspect
    Then no bind mount inside the container has the host "~/.claude" directory as its source
    And no bind mount inside the container targets "/home/vscode/.claude" as a read-write directory mount

  @scenario_hash:f838de07a80749f9
  Scenario: a launched BC container has no host gh or gitconfig credential mount
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run with BC name "shopsystem-messaging"
    And the container "bc-shopsystem-messaging" is running
    When the container's bind mounts are inspected via docker inspect
    Then no bind mount inside the container has the host "~/.config/gh" directory as its source
    And no bind mount inside the container has the host "~/.gitconfig" file as its source

  @scenario_hash:95b02da48a6f08a9
  Scenario: bc-container launch does not require BCLAUNCHER_HOST_HOME to resolve a credential mount source
    Given the shopsystem-bc-launcher BC is installed
    And the environment variable BCLAUNCHER_HOST_HOME is unset
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero and the container "bc-shopsystem-messaging" is running
    And launch did not fail resolving any host credential path

  # bclaunch-3q12 (canary-found v0.2.5, fixed v0.2.6): TIGHTENED. The runtime
  # HTTPS_PROXY the launched agent inherits must be the credential-substituting
  # MITM HTTPS proxy on :14322 with token:vault basic-auth — NOT the bare
  # :14321 control API. Pre-3q12 the controller set the runtime proxy to the
  # bare control-API broker_address, so claude's brokered Anthropic calls failed
  # (CONNECT tunnel failed / 405). The Then now names the :14322 MITM listener
  # explicitly so a future bare-:14321 regression is caught. Asserts on the
  # ACTUAL runtime HTTPS_PROXY value injected into `docker run`, not an echoed
  # string (bclaunch-7ys / 5hl tautology guard).
  @scenario_hash:694a2c13042a29b8
  Scenario: the launched Claude agent is invoked wrapped in agent-vault run with its runtime proxy at the broker MITM listener
    Given the shopsystem-bc-launcher BC is installed
    And an agent-vault broker is running on the shopsystem network and is reachable
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_canary_xyz" and vault "shopsystem"
    When bc-container launch starts the agent for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then the command line that launches the agent inside the tmux session named "agent" invokes "agent-vault run -- claude"
    And the agent process environment sets HTTPS_PROXY to the agent-vault broker's MITM proxy listener on port 14322 with token:vault basic-auth

  # bclaunch-2s6y (canary-found v0.2.5, fixed v0.2.6): SUPERSEDES the bare
  # {"accessToken":...} shape (old @scenario_hash 3931e43e01824a3c). The bare
  # shape was wrong: claude wants the NESTED claudeAiOauth stanza, so with the
  # bare file claude never recognized itself as logged in and sat at its
  # first-run login-method picker instead of becoming the agent. Re-pinned
  # against the nested shape: the accessToken INSIDE claudeAiOauth is still the
  # literal "__PLACEHOLDER__" (no real OAuth token anywhere — the broker
  # substitutes the real Authorization on the wire). The delivery mechanism
  # (baked into the bc-base image, no controller mount) is unchanged.
  @scenario_hash:8dfad9acd7503b3f
  Scenario: the container's Claude credential file is a nested-claudeAiOauth placeholder baked into the image, never the real OAuth credential
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run with BC name "shopsystem-messaging"
    And the container "bc-shopsystem-messaging" is running
    When the placeholder ".credentials.json" baked into the bc-base image is read
    Then the baked .credentials.json has a top-level "claudeAiOauth" object
    And the accessToken inside claudeAiOauth has the literal value "__PLACEHOLDER__"
    And the refreshToken inside claudeAiOauth has the literal value "__PLACEHOLDER__"
    And the baked .credentials.json has no top-level "accessToken" field
    And the placeholder credentials file is baked into the image at "/home/vscode/.claude/.credentials.json"
    And the controller builds no credential bind-mount into the container
    And the real host OAuth accessToken value does not appear anywhere in the container's filesystem

  @scenario_hash:97734ca69a510e37
  Scenario: an authenticated GitHub operation from inside the container succeeds via the broker with no mounted GitHub credential
    Given the shopsystem-bc-launcher BC is installed
    And an agent-vault broker with a GitHub credential service is running on the shopsystem network and is reachable
    And the container "bc-shopsystem-messaging" is running with no host gh or gitconfig credential mounted
    When an authenticated GitHub operation is run from inside the container through the agent-vault broker
    Then the operation completes successfully against GitHub
    And no GitHub token value is present in the container's environment or filesystem

  @scenario_hash:f23dfbe84c899968
  Scenario: the broker substitutes the GitHub credential on the outbound request rather than the container holding it
    Given an agent-vault broker with a GitHub credential service is running on the shopsystem network
    And the container "bc-shopsystem-messaging" routes its GitHub-bound traffic through the broker's proxy listener
    When a git operation inside the container makes an authenticated request to github.com
    Then the request the broker forwards to github.com carries the broker-stored GitHub credential
    And the request as it leaves the container carries no GitHub credential

  @scenario_hash:4160c3e00ed0997e
  Scenario: bc-container launch surfaces a readiness failure when the agent-vault broker is unreachable, before the agent engages
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And the agent-vault broker address configured for the container points at an address where no reachable broker is listening
    When I run bc-container launch with BC name "shopsystem-messaging" and an agent-vault startup prompt
    Then the command exits non-zero
    And stderr reports an agent-vault readiness failure that names the configured agent-vault broker address
    And no startup prompt has been sent to the tmux session named "agent" in container "bc-shopsystem-messaging"

  @scenario_hash:3b2a81c1bfe2897e
  Scenario: a BC container whose agent-vault broker is unreachable reports unhealthy despite the process being alive
    Given a BC container named "bc-shopsystem-messaging" is running with its agent process alive
    And the agent-vault broker configured for the container is not reachable
    When I inspect the container's health status via docker inspect
    Then the container's reported health status is "unhealthy"

  @scenario_hash:c1e8bd6646b6bc69
  Scenario: the readiness barrier passes and engages the agent only when both the messaging database and the agent-vault broker are reachable
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And the messaging database at SHOPMSG_DSN is reachable for the agent-vault launch
    And the agent-vault broker on the shopsystem network is reachable
    When I run bc-container launch with BC name "shopsystem-messaging" and a brokered startup prompt
    Then the readiness barrier reports both messaging-database and agent-vault checks passed
    And the startup prompt is sent to the tmux session named "agent" in container "bc-shopsystem-messaging"

  @scenario_hash:916581b93d85df47
  Scenario: the readiness barrier withholds engagement when the messaging database is reachable but the agent-vault broker is not
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And the messaging database at SHOPMSG_DSN is reachable for the agent-vault launch
    And the agent-vault broker on the shopsystem network is not reachable
    When I run bc-container launch with BC name "shopsystem-messaging" and a brokered startup prompt
    Then the command exits non-zero
    And no startup prompt has been sent to the tmux session named "agent" in container "bc-shopsystem-messaging"

  @scenario_hash:2a4e9889c141c790
  Scenario: brokered launch presupposes the broker vault already holds the real credentials, provisioned out of band
    Given the agent-vault broker has been provisioned out of band with the real Claude OAuth credential and the real GitHub credential
    And the shopsystem-bc-launcher BC is installed
    When bc-container launch is run with BC name "shopsystem-messaging" against the provisioned broker
    Then the brokered Claude OAuth substitution and the brokered GitHub substitution both succeed
    And bc-container launch performed no step that read a real credential from any host file

  @scenario_hash:ff04ee22410fd866
  Scenario: bc-container launch never writes a real credential into the broker vault or into a container
    Given the shopsystem-bc-launcher BC is installed
    When bc-container launch is run with BC name "shopsystem-messaging"
    Then launch executes no step that stores a real credential into the broker vault
    And launch executes no step that places a real credential inside the container

  # bclaunch-2s6y: SUPERSEDES the bare-shape assertion (old @scenario_hash
  # e4348b11e0b38d4f). Re-pinned against the NESTED claudeAiOauth shape; the
  # no-real-credential invariant SURVIVES (every baked value is "__PLACEHOLDER__"
  # or synthetic), only the JSON shape changes mount-of-bare -> baked-nested.
  @scenario_hash:0c90e2234954ccc4
  Scenario: no real Claude OAuth credential is observable from inside the container under the nested-claudeAiOauth shape
    Given the container "bc-shopsystem-messaging" is running under the agent-vault model
    When the container's filesystem and process environment are searched from inside the container
    Then the real Claude OAuth accessToken value is not present in any file or environment variable
    And the only .credentials.json present has its claudeAiOauth accessToken equal to "__PLACEHOLDER__"

  @scenario_hash:b8f2e121a5fd77ba
  Scenario: no real GitHub credential and no host gh or gitconfig path is observable from inside the container
    Given the container "bc-shopsystem-messaging" is running under the agent-vault model
    When the container's filesystem and process environment are searched from inside the container
    Then no real GitHub token value is present in any file or environment variable
    And no path mounted from the host's "~/.config/gh" or "~/.gitconfig" is present inside the container

  @scenario_hash:ff1ee370a4462e7d
  Scenario: the only credential-bearing secret reachable from inside the container is the revocable agent-vault proxy token
    Given the container "bc-shopsystem-messaging" is running under the agent-vault model
    When the credential-bearing secrets reachable from inside the container are enumerated
    Then the only such secret is the agent-vault proxy token used to authenticate to the broker
    And that token grants only proxy substitution and is independently revocable without exposing any brokered credential
