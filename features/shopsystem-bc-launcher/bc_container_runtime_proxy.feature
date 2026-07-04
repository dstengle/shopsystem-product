@bc:shopsystem-bc-launcher @origin:brief-013 @service:agent-vault-broker
Feature: bc-container launch points the container RUNTIME HTTPS_PROXY at the broker MITM proxy

  # bclaunch-3q12 (canary-found v0.2.5, fixed v0.2.6): the container's persistent
  # runtime HTTPS_PROXY — the proxy claude-the-agent inherits and routes its
  # brokered Anthropic calls through — pointed at the agent-vault CONTROL API
  # (http://agent-vault:14321, the DEFAULT_AGENT_VAULT_BROKER) whenever the
  # operator did not hand-build an explicit --agent-vault-broker full URL. The
  # control API is not an HTTPS-CONNECT MITM proxy, so the agent's brokered calls
  # failed (CONNECT tunnel failed / response 405).
  #
  # lead-5fji added _build_clone_proxy_url / _mitm_proxy_host (:14322 MITM +
  # av_agt_<token>:<vault> basic-auth) but applied it ONLY to the launch-time
  # clone exec env, NOT to the container's runtime HTTPS_PROXY. This is the
  # runtime-half completion: the launcher now DERIVES the runtime proxy at the
  # :14322 MITM listener from the AGENT_VAULT_ADDR/TOKEN/VAULT triple, using the
  # SAME derivation the clone uses, so a plain `bc-container launch` with NO
  # hand-built --agent-vault-broker URL sets the runtime proxy correctly.
  #
  # PRECEDENCE (decided cleanly): an explicit --agent-vault-broker (or
  # BCLAUNCHER_AGENT_VAULT_BROKER) full URL WINS verbatim; otherwise the proxy is
  # DERIVED from the env-file triple. The pre-existing override path therefore
  # continues to work.
  #
  # These scenarios assert on the ACTUAL HTTPS_PROXY value injected into the
  # container's `docker run` env (recorded from the real env dict passed to the
  # driver), not on a static echoed-back string — avoiding the tautological
  # pinning failure mode (bclaunch-7ys / bclaunch-5hl). A bare-:14321 runtime
  # proxy fails these scenarios.

  @scenario_hash:de8a75abba9c38ee
  Scenario: a plain brokered launch derives the runtime HTTPS_PROXY at the broker MITM proxy on :14322 with token:vault basic-auth
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_canary_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the container runtime HTTPS_PROXY is set to "http://av_agt_canary_xyz:shopsystem@agent-vault:14322"

  @scenario_hash:580bb72558328694
  Scenario: the plain brokered runtime HTTPS_PROXY does NOT point at the bare control API on :14321
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_canary_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the container runtime HTTPS_PROXY host is "agent-vault" on port 14322
    And the container runtime HTTPS_PROXY is not the control API on port 14321
    And the container runtime HTTPS_PROXY carries basic-auth userinfo "av_agt_canary_xyz:shopsystem"

  @scenario_hash:8a30298f2afde4c4
  Scenario: an explicit --agent-vault-broker full URL wins verbatim over the derived MITM proxy
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_canary_xyz" and vault "shopsystem"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials and an explicit agent-vault broker URL "http://av_agt_override:other@broker.example:14399"
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the container runtime HTTPS_PROXY is set to "http://av_agt_override:other@broker.example:14399"

  @scenario_hash:df5389b11bf85598
  Scenario: the derived runtime proxy uses the token verbatim (no double prefix) and URL-encodes the vault
    Given the shopsystem-bc-launcher BC is installed
    And the operator supplies agent-vault addr "https://agent-vault:14321" token "av_agt_already_prefixed" and vault "shop/space"
    When bc-container launch is run for BC name "shopsystem-messaging" with the operator-supplied agent-vault credentials
    Then a Docker container named "bc-shopsystem-messaging" is running
    And the container runtime HTTPS_PROXY is set to "http://av_agt_already_prefixed:shop%2Fspace@agent-vault:14322"
