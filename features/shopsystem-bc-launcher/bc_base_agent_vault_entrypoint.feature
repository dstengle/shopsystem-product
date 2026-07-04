@bc_internal
Feature: bc-base installs agent-vault, materializes the broker CA from AGENT_VAULT_CA_PEM, and bakes the placeholder credential (bclaunch-9rr)

  This is a BC-INTERNAL structural hardening (bead bclaunch-9rr). It is NOT a
  lead-assigned scenario: the @bc_internal tag below is a BC-owned marker, NOT
  a lead @scenario_hash. docker build is NOT run (docker is unavailable in this
  environment); these scenarios parse the COMMITTED Dockerfile / entrypoint
  CONTENT, the same structural-inspection idiom as the bc-base CLI-pin tests.

  Under the operator no-bind-mount design directive (bclaunch-7pf REVISED):
  the controller injects AGENT_VAULT_CA_PEM (the PUBLIC ~574-byte broker CA) as
  a container env var and builds NO CA bind-mount. The bc-base image is the
  side that materializes trust: its entrypoint / profile script, WHEN
  AGENT_VAULT_CA_PEM is set, writes the CA to
  /home/vscode/.config/agent-vault/ca.pem and exports the five trust vars
  (GIT_SSL_CAINFO, SSL_CERT_FILE, NODE_EXTRA_CA_CERTS, REQUESTS_CA_BUNDLE,
  CURL_CA_BUNDLE) pointing at that path. Because the agent runs via
  `docker exec ... tmux ... agent-vault run -- claude` (which does NOT inherit
  the entrypoint's process-local exports), the trust vars are ALSO made durable
  for exec/login shells via /etc/profile.d. The placeholder .credentials.json
  is BAKED into the image (no controller mount).

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the bc-base Dockerfile installs agent-vault with a version pin present
    Given the shopsystem-bc-launcher BC repository
    When the bc-base Dockerfile in that repository is inspected
    Then the Dockerfile installs the agent-vault binary with a version pin present

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the bc-base entrypoint materializes the CA from AGENT_VAULT_CA_PEM and exports the five trust vars
    Given the shopsystem-bc-launcher BC repository
    When the bc-base CA-trust script content is inspected
    Then the script is conditional on AGENT_VAULT_CA_PEM being set
    And the script writes the CA to "/home/vscode/.config/agent-vault/ca.pem"
    And the script exports GIT_SSL_CAINFO pointing at the container CA path
    And the script exports SSL_CERT_FILE pointing at the container CA path
    And the script exports NODE_EXTRA_CA_CERTS pointing at the container CA path
    And the script exports REQUESTS_CA_BUNDLE pointing at the container CA path
    And the script exports CURL_CA_BUNDLE pointing at the container CA path

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the trust vars are durable for exec and login shells via /etc/profile.d
    Given the shopsystem-bc-launcher BC repository
    When the bc-base CA-trust script content is inspected
    Then a /etc/profile.d agent-vault CA script is installed that materializes the CA if missing and exports the five trust vars

  # bclaunch-2s6y: the bake is the SYNTHETIC logged-in state (nested
  # claudeAiOauth .credentials.json + ~/.claude.json wizard-skip seed) so claude
  # boots straight to the agent. All values placeholder/synthetic; broker
  # supplies the real token on the wire.
  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the bc-base Dockerfile bakes the synthetic logged-in Claude state
    Given the shopsystem-bc-launcher BC repository
    When the bc-base Dockerfile in that repository is inspected
    Then the Dockerfile bakes a nested-claudeAiOauth .credentials.json at "/home/vscode/.claude/.credentials.json" whose claudeAiOauth accessToken is "__PLACEHOLDER__"
    And the baked .credentials.json claudeAiOauth expiresAt is far in the future
    And the Dockerfile seeds a ~/.claude.json at "/home/vscode/.claude.json" with hasCompletedOnboarding true and bypassPermissionsModeAccepted true
    And the seeded ~/.claude.json pre-trusts the "/workspace" project
    And the seeded ~/.claude.json bakes no real Claude OAuth token

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: an ENTRYPOINT is wired so the CA-materialization runs on container start
    Given the shopsystem-bc-launcher BC repository
    When the bc-base Dockerfile in that repository is inspected
    Then the Dockerfile declares an ENTRYPOINT that runs the agent-vault CA entrypoint script
