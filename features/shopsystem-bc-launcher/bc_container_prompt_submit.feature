@bc:shopsystem-bc-launcher @origin:lead-lez1
Feature: bc-container --startup-prompt and inject commit prompts to the agent (lead-xsmn / lead-hyee)

  # Scenarios 27 (0e733774844ed9f3) and 28 (17518db1dc1c9001) were RETIRED
  # under ADR-010 by lead-lez1: they pinned the single-invocation
  # `send-keys <text> Enter` shape, which lead-9q0f empirically refuted as the
  # paste-absorption root cause.  Their successors are scenarios 30
  # (6477b2ab3720ac53) and 31 (ad68aaf60377706e) in
  # features/bc_container_prompt_submit_two_call.feature, which pin the
  # two-discrete-invocation shape that actually commits.

  @scenario_hash:90ceb2b7f9979d69
  Scenario: bc-container monitor surfaces an agent-working state-marker within a bounded interval of bc-container launch --startup-prompt exiting, with no human or host-side follow-up keystroke
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command exits zero
    And I run "bc-container monitor shopsystem-messaging" and read its streamed output without issuing any further "bc-container inject" or other host-side keystroke
    Then within 30 seconds of the launch command exiting, the streamed monitor output contains an agent-working state-marker line that is produced only when the agent has committed input and is actively processing it (and not produced when the agent is idle at an unsubmitted input buffer)
    And the agent-working state-marker appears as a direct consequence of the launch's --startup-prompt being submitted, with no intervening "bc-container inject" invocation

  # lead-j351: TIGHTENING of the readiness-wait TERMINATION CONDITION.  The
  # legacy wait abandoned injection at a fixed 60s wall-clock deadline; a
  # brokered boot that reaches its input-ready marker only after >60s was
  # therefore dropped ("startup prompt NOT injected").  The wait must key on
  # the observable input-ready marker (progress-based / generous headroom)
  # rather than a fixed deadline that fires before a slow brokered boot
  # completes.  The markers and the inject-after-ready ordering
  # (5ef728039884a9a2) are UNCHANGED.
  @scenario_hash:d227ccbcc9bdfa87
  Scenario: a brokered boot that becomes ready after the legacy 60s deadline still has its startup prompt injected
    Given the shopsystem-bc-launcher BC is installed
    And a brokered BC container whose Claude agent reaches its input-ready marker only after more than 60 seconds
    When bc-container launch waits for the agent to become ready before injecting the startup prompt
    Then launch does not abandon prompt injection at a fixed 60-second deadline while the agent is still progressing toward readiness
    And once the agent's input-ready marker is observed the startup prompt is injected into the tmux session named "agent"
    And the readiness wait keys on the observable input-ready marker rather than a fixed deadline that fires before a slow brokered boot completes
