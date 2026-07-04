@bc:shopsystem-bc-launcher @origin:lead-gw9v
Feature: readiness wait treats a self-advanced agent as up, skips the trust-accept Enter, and still aborts when neither marker is reached (lead-gw9v)

  @scenario_hash:e30b15363815abed
  Scenario: claude self-advances past workspace-trust to input-ready, so the launcher detects input-ready, skips the trust-accept Enter, does not abort waiting for the transient trust banner, and injects the startup prompt unattended
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And during the initial readiness wait the in-container agent runtime self-advances past the workspace-trust prompt so the agent pane shows the input-ready marker "bypass permissions on" without the transient workspace-trust banner "Accessing workspace:" ever being caught by the launcher's polling
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command runs the agent-readiness sequence
    Then the launcher detects that the agent pane is already at the input-ready marker "bypass permissions on" and treats the agent as up
    And the launcher does not abort the readiness sequence with an "agent-startup failure" warning for the transient trust banner "Accessing workspace:" not being seen
    And the launcher does not keep hard-waiting for the transient trust banner "Accessing workspace:" until the readiness timeout
    And the launcher skips the trust-accept Enter keystroke that would otherwise be sent to accept the workspace-trust prompt
    And the launcher submits the startup prompt "bd prime" to the tmux session named "agent" in container "bc-shopsystem-messaging" with no host-side follow-up "bc-container inject" invocation required
    And the launch command exits zero with the BC online unattended

  @scenario_hash:f3784811e04a224d
  Scenario: the pre-trust path still works, so when the transient trust banner is observed first the launcher accepts trust with Enter, waits for input-ready, then injects the startup prompt
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And during the initial readiness wait the in-container agent runtime first renders the transient workspace-trust banner "Accessing workspace:" before reaching the input-ready marker "bypass permissions on"
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command runs the agent-readiness sequence
    Then the launcher observes the transient workspace-trust banner "Accessing workspace:" and sends a trust-accept Enter keystroke to the tmux session named "agent" in container "bc-shopsystem-messaging"
    And after accepting trust the launcher waits for and observes the input-ready marker "bypass permissions on"
    And the launcher submits the startup prompt "bd prime" to the tmux session named "agent" in container "bc-shopsystem-messaging" with no host-side follow-up "bc-container inject" invocation required
    And the launch command exits zero with the BC online unattended

  @scenario_hash:9fa36102d756a8fb
  Scenario: neither readiness marker is reached within the timeout, so the launcher warns and aborts without injecting the startup prompt
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And during the initial readiness wait the agent pane never shows the transient workspace-trust banner "Accessing workspace:" and never shows the input-ready marker "bypass permissions on" within the readiness timeout
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command runs the agent-readiness sequence
    Then the launcher does not submit the startup prompt "bd prime" to the tmux session named "agent" in container "bc-shopsystem-messaging"
    And the launcher surfaces a host-discoverable WARNING that the agent never reached input-ready within the readiness timeout
    And the launch command exits non-zero
