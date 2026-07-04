@bc:shopsystem-bc-launcher @origin:adr-041
Feature: bc-container launch-diagnostic write is best-effort/non-fatal and targets a user-writable default location

  # lead-bnhn (P1 bugfix, additive tightening of currently-UNPINNED robustness
  # behavior). Operator E2E (fresh adopter "testproduct3", 2026-06-30):
  # `bc-container launch` CRASHED with
  #   PermissionError: [Errno 13] Permission denied: '/var/lib/bc-launcher'
  # at driver.write_launch_diagnostic's p.parent.mkdir(parents=True), because
  # the lead-63em DEFAULT diagnostic root /var/lib/bc-launcher is root-owned
  # and NOT writable by the invoking (shop-shell) user. The very mechanism
  # ADR-041 / scenario 56 added to make launch FAILURES legible was, here, the
  # cause of a fatal, illegible failure — and because the mkdir died, NO
  # diagnostic was produced.
  #
  # This feature pins the two robustness properties scenario 56
  # (@scenario_hash:0d010cf8f3175226, @scenario_hash:7084bbbfdef94f81) did NOT
  # pin, WITHOUT retiring or superseding scenario 56 (a diagnostic is still
  # written on the normal failure path, still host-readable, still carries the
  # cause markers):
  #   (a) NON-FATAL — a diagnostic-write failure (mkdir/file write raising
  #       PermissionError/OSError) MUST NOT abort the launch; it is caught, a
  #       host-discoverable warning is surfaced, and the launch continues. A
  #       diagnostic-write failure is strictly less severe than the launch
  #       failure it describes — degrade gracefully, never escalate.
  #   (b) USER-WRITABLE DEFAULT — with no BCLAUNCHER_HOST_STATE_DIR override the
  #       default diagnostic location is a per-USER state dir
  #       ($XDG_STATE_HOME/bc-launcher, default ~/.local/state/bc-launcher),
  #       NOT the root-owned /var/lib/bc-launcher, while preserving the ADR-041
  #       D2 host-discoverability contract (a documented per-BC path found by a
  #       host lookup that does not attach into a session).

  @scenario_hash:fe76a2f67262f665
  Scenario: a launch whose diagnostic write fails is NOT aborted by the write failure and surfaces a host-discoverable warning
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And the launch will fail to bring up a usable session because the messaging database at SHOPMSG_DSN is unreachable
    And writing the launch diagnostic file will fail because the diagnostic target directory is not writable
    When I run bc-container launch with BC name "shopsystem-messaging" and a startup prompt
    Then the launch is not aborted by the diagnostic-write failure and runs to its own failure result
    And bc-container surfaces a host-discoverable warning that the launch diagnostic could not be written, naming the target path and the write-failure cause
    And the underlying launch-failure cause is still reported on the host-discoverable warning surface

  @scenario_hash:aae4e5470f5c55cb
  Scenario: with no BCLAUNCHER_HOST_STATE_DIR override the default diagnostic location is under a user-writable per-user state directory and remains host-discoverable
    Given the shopsystem-bc-launcher BC is installed
    And no BCLAUNCHER_HOST_STATE_DIR override is set in the environment
    When I resolve the documented launch-diagnostic location for BC name "shopsystem-messaging"
    Then the resolved diagnostic location is under a user-writable per-user state directory rooted at XDG_STATE_HOME or its default ~/.local/state
    And the resolved diagnostic location is NOT under the root-owned /var/lib/bc-launcher
    And the resolved diagnostic location is the known, documented per-BC host-discoverable path found by a host lookup that does not attach into any tmux session
