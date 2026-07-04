@bc:shopsystem-bc-launcher @origin:brief-013 @service:agent-vault-broker
Feature: bc-container launch-time auto-clone is wired through the broker MITM proxy with CA trust

  # bclaunch-5fji (canary-found 2026-06-10, v0.2.4): the built-in launch-time
  # auto-clone FAILED through the broker. Two defects:
  #
  #   DEFECT 1 — the clone's HTTPS_PROXY pointed at the agent-vault CONTROL API
  #   (http://agent-vault:14321, the DEFAULT_AGENT_VAULT_BROKER / the
  #   AGENT_VAULT_ADDR), NOT the credential-substituting MITM HTTPS proxy on
  #   :14322. The MITM proxy requires token:vault basic-auth, so the correct
  #   clone-time proxy URL is http://<token>:<vault>@<host>:14322 — the same
  #   shape `agent-vault run` uses. The agent token already carries its
  #   operator-supplied agent-token prefix; it is used verbatim, NOT re-prefixed.
  #
  #   DEFECT 2 — the clone ran in a NON-LOGIN shell, so it never sourced
  #   /etc/profile.d/agent-vault-ca.sh and lacked GIT_SSL_CAINFO, producing
  #   'unable to get local issuer certificate'. The controller now sets
  #   GIT_SSL_CAINFO explicitly on the clone exec, pointing at the container CA
  #   path the bc-base entrypoint materializes the broker CA to.
  #
  # These scenarios assert on the ACTUAL constructed clone-exec env (the proxy
  # URL value and the trust var), not on a static echoed-back string — avoiding
  # the tautological-pinning failure mode (bclaunch-7ys / bclaunch-5hl). The fix
  # makes the lead-held brokered-launch scenarios (97734ca69a510e37 /
  # 6cb07698a874aa47 / 3b2a81c1bfe2897e) actually function at clone time; none
  # is retired.

  @scenario_hash:877d03638a1b9402
  Scenario: the launch-time clone routes HTTPS through the broker MITM proxy on :14322 with token:vault basic-auth
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_canary_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the launch-time clone exec has HTTPS_PROXY set to "http://av_agt_canary_xyz:shopsystem@agent-vault:14322"

  @scenario_hash:a788be81c699254a
  Scenario: the launch-time clone HTTPS_PROXY does NOT point at the bare control API on :14321
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_canary_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the launch-time clone exec HTTPS_PROXY host is "agent-vault" on port 14322
    And the launch-time clone exec HTTPS_PROXY is not the control API on port 14321
    And the launch-time clone exec HTTPS_PROXY carries basic-auth userinfo "av_agt_canary_xyz:shopsystem"

  @scenario_hash:c90e7a8d31b712b2
  Scenario: the launch-time clone exec carries GIT_SSL_CAINFO so it trusts the broker CA without a login shell
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_canary_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the launch-time clone exec has GIT_SSL_CAINFO set to "/home/vscode/.config/agent-vault/ca.pem"

  @scenario_hash:783fd028693c0c20
  Scenario: the clone proxy userinfo uses the token verbatim (no double prefix) and URL-encodes the vault
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_already_prefixed" and vault "shop/space"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the launch-time clone exec HTTPS_PROXY userinfo username is exactly "av_agt_already_prefixed"
    And the launch-time clone exec has HTTPS_PROXY set to "http://av_agt_already_prefixed:shop%2Fspace@agent-vault:14322"
