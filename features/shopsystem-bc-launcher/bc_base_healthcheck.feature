@bc_internal
Feature: bc-base image carries a real HEALTHCHECK probing broker + messaging-db reachability (bclaunch-wuo)

  This is a BC-INTERNAL structural hardening (bead bclaunch-wuo). It is NOT a
  lead-assigned scenario: the @bc_internal tag below is a BC-owned marker, NOT
  a lead @scenario_hash. docker build is NOT run (docker is unavailable in this
  environment); these scenarios parse the COMMITTED Dockerfile + probe-script
  CONTENT, the same structural-inspection idiom as the bc-base CLI-pin and
  agent-vault-entrypoint tests.

  THE GAP this closes: lead-held scenario 3b2a81c1bfe2897e (a container reports
  unhealthy when the broker is unreachable) and the messaging-db health
  scenarios passed ONLY under the fake driver, because the real bc-base image
  carried NO HEALTHCHECK instruction. RealDockerDriver.health_status reads
  docker-inspect .State.Health.Status, which on a HEALTHCHECK-less image is
  always "none" — so the unhealthy-when-broker-down behavior was fake-only.

  These scenarios assert on the ACTUAL HEALTHCHECK directive and the ACTUAL
  probe targets (the broker host:port the container routes through, and the
  messaging DSN), NOT on a static echoed string — a no-op HEALTHCHECK (e.g.
  `CMD true`) or one probing the wrong target would FAIL them.

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the bc-base Dockerfile declares a HEALTHCHECK that runs the broker/db probe script
    Given the shopsystem-bc-launcher BC repository
    When the bc-base Dockerfile in that repository is inspected
    Then the Dockerfile declares a HEALTHCHECK instruction
    And the HEALTHCHECK command runs the in-container bc-healthcheck probe script
    And the HEALTHCHECK is not a no-op that always reports healthy

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the bc-base healthcheck probe targets the agent-vault broker the container routes through
    Given the shopsystem-bc-launcher BC repository
    When the bc-base healthcheck probe script content is inspected
    Then the probe derives the agent-vault broker address from the in-container HTTPS_PROXY env var
    And the probe attempts a TCP connect against the broker host and port
    And the probe exits non-zero when the broker is unreachable

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the bc-base healthcheck probe targets the messaging database at SHOPMSG_DSN
    Given the shopsystem-bc-launcher BC repository
    When the bc-base healthcheck probe script content is inspected
    Then the probe derives the messaging database address from the SHOPMSG_DSN env var
    And the probe exits non-zero when the messaging database is unreachable
