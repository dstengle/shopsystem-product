@bc:shopsystem-bc-launcher @origin:lead-lez1
Feature: bc-container launch and inject commit prompts via two discrete tmux send-keys invocations

  @scenario_hash:456266b23b11fefe
    Scenario: bc-container launch --startup-prompt issues two discrete tmux send-keys invocations against the container driver — first the prompt text alone, then the Enter key alone — and no single invocation carries both
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run "bc-container launch shopsystem-messaging --startup-prompt 'bd prime'" and the launch command exits zero
    Then the BC has issued exactly two tmux send-keys invocations against the container driver targeting the tmux session named "agent" in container "bc-shopsystem-messaging" as a direct consequence of the --startup-prompt being honored
    And the first of those two invocations carries the prompt text "bd prime" as its key payload and does not carry the Enter key in the same invocation
    And the second of those two invocations carries the Enter key as its key payload and does not carry the prompt text "bd prime" in the same invocation
    And no single tmux send-keys invocation issued by the launch command's --startup-prompt handling carries both the prompt text "bd prime" and the Enter key together
    And the two invocations are issued in order: the text-only invocation first, the Enter-only invocation second

  @scenario_hash:76cdee3bb4a8026c
    Scenario: bc-container inject issues two discrete tmux send-keys invocations against the container driver — first the prompt text alone, then the Enter key alone — and no single invocation carries both
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running with a tmux session named "agent"
    When I run "bc-container inject shopsystem-messaging 'bd prime'" and the command exits zero
    Then the BC has issued exactly two tmux send-keys invocations against the container driver targeting the tmux session named "agent" in container "bc-shopsystem-messaging" as a direct consequence of the inject command
    And the first of those two invocations carries the prompt text "bd prime" as its key payload and does not carry the Enter key in the same invocation
    And the second of those two invocations carries the Enter key as its key payload and does not carry the prompt text "bd prime" in the same invocation
    And no single tmux send-keys invocation issued by the inject command carries both the prompt text "bd prime" and the Enter key together
    And the two invocations are issued in order: the text-only invocation first, the Enter-only invocation second
