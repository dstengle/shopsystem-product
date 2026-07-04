@bc:shopsystem-bc-launcher @origin:lead-cs7k @service:postgres
Feature: bc-container launch gates the startup prompt behind a messaging readiness barrier

  @scenario_hash:e6543853e4333506
  Scenario: bc-container launch surfaces a readiness failure when the messaging database is unreachable, before the agent engages
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And SHOPMSG_DSN for the container points at an address where no reachable database is listening
    When I run bc-container launch with BC name "shopsystem-messaging" and a startup prompt
    Then the command exits non-zero
    And stderr reports a messaging readiness failure that names the SHOPMSG_DSN value
    And no startup prompt has been sent to the tmux session named "agent" in container "bc-shopsystem-messaging"

  @scenario_hash:c946bc6d8a05e44a
  Scenario: bc-container launch does not inject the startup prompt until the readiness barrier passes
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container launch with BC name "shopsystem-messaging" and a startup prompt
    And the container is up but the readiness sequence has not yet completed
    Then no startup prompt has been sent to the tmux session named "agent" in container "bc-shopsystem-messaging"
    And once the readiness sequence completes successfully, the startup prompt is sent to the tmux session named "agent"

  @scenario_hash:52f7731c440a86bf
  Scenario: re-running the readiness sequence against an already-ready container is a no-op that reports ready
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running and has already passed its readiness sequence
    When I run the readiness sequence against container "bc-shopsystem-messaging" a second time
    Then the command exits zero
    And it reports that "bc-shopsystem-messaging" is already ready
    And no startup prompt has been re-sent to the tmux session named "agent" in container "bc-shopsystem-messaging"

  # lead-cs7k (dummyco iter-6): TIGHTENING of the already-pinned readiness
  # barrier. The bug: for a SECOND product the launcher HOST is not attached to
  # the product's docker network, so a launcher-host socket.create_connection
  # to "dummyco-postgres:5432" or the broker host false-fails BOTH probes ->
  # startup prompt withheld -> Claude never starts, even though the CONTAINER
  # reaches both fine. Fix: run each readiness probe from INSIDE the launched
  # container's network context (docker exec) so probe reachability matches the
  # container's reachability. The pass/withhold semantics (both-reachable ->
  # inject, either-unreachable -> withhold) are UNCHANGED.
  @scenario_hash:de07d649ed1bb22b
  Scenario: the readiness probes run from inside the container network, not from the launcher host
    Given the shopsystem-bc-launcher BC is installed
    And a BC container "bc-dummyco-messaging" is launched on the docker network "dummyco" for a product whose slug is "dummyco"
    And the launcher host process is NOT attached to the "dummyco" docker network
    And the messaging database is reachable as "dummyco-postgres:5432" from inside the "dummyco" network and the agent-vault broker is reachable from inside that network
    When bc-container launch runs its messaging-database and agent-vault readiness probes
    Then each readiness probe is executed from inside the launched container's network context rather than from the launcher host process
    And both probes report reachable even though the launcher host cannot itself resolve "dummyco-postgres" or the broker host
    And the startup prompt is sent to the tmux session named "agent" in container "bc-dummyco-messaging"

  # lead-cs7k (dummyco iter-6): the readiness PROBE broker host must derive from
  # the resolved product slug (SHOPMSG_SYSTEM_SLUG / manifest product:), not the
  # hardcoded "agent-vault:14321" — for a second product the broker is
  # "dummyco-agent-vault". The probe broker host is DECOUPLED from the value
  # used verbatim as the runtime HTTPS_PROXY (controller _build_runtime_proxy_url)
  # so pointing the probe at dummyco-agent-vault does not clobber the
  # token:vault@host:14322 derived runtime proxy.
  @scenario_hash:fa08c5496de9e401
  Scenario: the readiness probe broker host is derived from the product slug and is decoupled from the verbatim runtime-proxy override
    Given the shopsystem-bc-launcher BC is installed
    And a bc-manifest.yaml whose product field is "dummyco"
    And no agent-vault broker override is supplied on the launcher invocation
    When bc-container launch resolves the agent-vault broker address used for the readiness probe
    Then the probe broker host is derived from the product slug "dummyco" rather than the hardcoded "agent-vault:14321"
    And supplying a probe broker host does not clobber the token:vault basic-auth runtime HTTPS_PROXY value derived for the launched agent
