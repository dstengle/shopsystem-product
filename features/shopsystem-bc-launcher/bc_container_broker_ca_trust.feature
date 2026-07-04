@bc:shopsystem-bc-launcher @origin:brief-013 @service:agent-vault-broker
Feature: bc-container launch passes the broker CA as an env var, builds no CA bind-mount

  # bclaunch-7pf (REVISED under operator design directive — supersedes the
  # 9ca2e05 CA bind-mount model): the broker substitutes credentials by
  # intercepting outbound HTTPS (HTTPS_PROXY -> TLS MITM). The broker CA is a
  # PUBLIC ~574-byte cert (NOT secret). A controller-side bind-mount of the CA
  # is UNSAFE under nested-docker / host-path mismatch and the design goal is
  # to eliminate controller bind mounts entirely. So the CA now travels as the
  # container env var AGENT_VAULT_CA_PEM (operator-supplied via --env-file) and
  # is materialized to a file + trust env vars by the bc-base entrypoint
  # (bclaunch-9rr). The controller does NO CA handling: it injects the env var
  # and builds NO CA bind-mount.

  @scenario_hash:0b1f6badad2c9e58
  Scenario: the operator-supplied broker CA travels as the AGENT_VAULT_CA_PEM container env var
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies the broker CA PEM via AGENT_VAULT_CA_PEM
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator broker CA and agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the container env has AGENT_VAULT_CA_PEM set to the operator-supplied broker CA PEM

  @scenario_hash:4d3e32aa1cc299e5
  Scenario: the controller builds no CA bind-mount and sets no controller-side TLS-trust env
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies the broker CA PEM via AGENT_VAULT_CA_PEM
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator broker CA and agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And no bind mount inside the container targets "/etc/agent-vault/broker-ca.pem"
    And the container env has no NODE_EXTRA_CA_CERTS key set by the controller
    And the container env has no SSL_CERT_FILE key set by the controller
    And the container env has no GIT_SSL_CAINFO key set by the controller

  # lead-b14a: the operator-supplied broker CA PEM is multi-line (~574 bytes,
  # spanning several physical lines). A --env-file value carrying that PEM must
  # survive parsing intact — NOT truncated at the first physical newline by the
  # KEY=VALUE line splitter. The convention: a quoted value left open on its
  # first physical line continues accumulating subsequent physical lines (with
  # their real newlines preserved) until the closing quote. The parsed value is
  # a real-newline string, which the bc-base entrypoint's `printf '%s\n'`
  # materializer reproduces byte-for-byte — both ends agree on real newlines,
  # no \n-escape convention is introduced. Single-line env-file values and the
  # AGENT_VAULT_CA_PEM-travels-as-env-var contract (7c3e1a9f5d8b2640) are
  # unchanged; this is additive.
  @scenario_hash:eb92b4a40939973f
  Scenario: bc-container --env-file preserves a multi-line AGENT_VAULT_CA_PEM value intact through to the container env
    Given the shopsystem-bc-launcher BC is installed
    And an env file supplies AGENT_VAULT_CA_PEM as a multi-line PEM block spanning several physical lines
    When bc-container launch parses that env file and injects AGENT_VAULT_CA_PEM into the launched container env
    Then the AGENT_VAULT_CA_PEM value injected into the container is the complete multi-line PEM, not truncated at the first newline
    And the value materialized inside the container reproduces the original PEM byte-for-byte including its internal newlines
    And a brokered HTTPS request from inside the container trusts the broker CA using the materialized PEM
