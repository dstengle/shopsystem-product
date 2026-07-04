@bc:shopsystem-bc-launcher @origin:lead-q3uy
Feature: engage handles blocking interactive option screens by Escape-dismiss (lead-q3uy)

  # lead-q3uy — when the in-container agent runtime presents a blocking
  # interactive option screen during engage (after the input-ready marker, before
  # the startup prompt is submitted), the launcher must:
  #   * recognize the blocking option screen;
  #   * if it exposes a dismiss/escape affordance, send a DISCRETE tmux send-keys
  #     carrying ONLY the Escape key (NEVER Enter) to dismiss it, capture the
  #     rendered screen content, log it as a host-discoverable WARNING, then
  #     submit the startup prompt directly (no host-side `bc-container inject`);
  #   * if it exposes NO escape affordance, NOT send Enter / NOT auto-confirm a
  #     default, and surface a WARNING naming the un-escapable screen.

  @scenario_hash:f68d8199fef70fa7
  Scenario: engage recognizes a blocking escape-able option screen, sends Escape (not Enter) to dismiss it, then submits the startup prompt
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And on engage the in-container agent runtime presents an interactive option screen that blocks the input prompt and exposes a dismiss/escape affordance
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command exits zero
    Then the launcher issues a discrete tmux send-keys invocation against the container driver carrying the Escape key as its key payload, targeting the tmux session named "agent" in container "bc-shopsystem-messaging", to dismiss the blocking option screen
    And that Escape-bearing invocation does not carry the Enter key in the same invocation
    And the launcher does not send an Enter keystroke to select a default on that blocking option screen
    And after the option screen is dismissed the startup prompt "bd prime" is submitted to the tmux session named "agent" with no host-side follow-up "bc-container inject" invocation required
    And the in-container agent transitions from the blocked option screen to actively processing the prompt "bd prime"

  @scenario_hash:f17f0fc747e44e47
  Scenario: an auto-dismissed option screen's content is captured and logged as a host-discoverable warning
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And on engage the in-container agent runtime presents an interactive option screen that blocks the input prompt and exposes a dismiss/escape affordance
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command exits zero
    And I read the engage observability surface for the launch via "bc-container monitor shopsystem-messaging" from the host
    Then the launch surfaces a WARNING that an interactive option screen was auto-dismissed during engage
    And that warning captures the rendered content of the dismissed option screen so a human can review what was auto-dismissed
    And the warning is discoverable from the host without attaching into the container

  @scenario_hash:9d38d505fc8b5432
  Scenario: an interactive screen with no escape affordance is not auto-confirmed with Enter
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And on engage the in-container agent runtime presents an interactive screen that blocks the input prompt and exposes no dismiss or escape affordance
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command runs the engage path
    Then the launcher does not send an Enter keystroke to advance the screen that has no escape affordance
    And between detecting the un-escapable option screen and returning from launch the launcher issues ZERO tmux send-keys invocations carrying the Enter key — and no keystroke of any kind — targeting the tmux session named "agent" in container "bc-shopsystem-messaging" while the un-escapable screen is present, as recorded by the container driver's send-keys recorder
    And the launcher does not auto-confirm a default on a screen that exposes no escape affordance
    And the launch surfaces a WARNING naming the un-escapable screen so a human can review it from the host
