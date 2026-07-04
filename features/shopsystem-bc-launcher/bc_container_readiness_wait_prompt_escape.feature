@bc:shopsystem-bc-launcher @origin:lead-cw7m
Feature: readiness wait auto-dismisses unexpected interactive prompts by Escape (lead-cw7m)

  @scenario_hash:048607861da16ff4
  Scenario: Launcher auto-dismisses an unexpected interactive prompt blocking readiness
    Given a BC container whose agent has been started with "claude --dangerously-skip-permissions"
    And the launcher has accepted the workspace-trust prompt and is waiting for the input-ready marker "bypass permissions on"
    When the agent pane presents an unexpected interactive prompt that is not the workspace-trust prompt and blocks reaching input-ready
    Then the launcher dismisses the unexpected prompt with the safe non-committal default by sending Esc
    And the launcher emits a warning naming the unexpected interactive prompt it auto-dismissed
    And the launcher continues the readiness loop and observes the input-ready marker "bypass permissions on"
    And the launcher injects the startup prompt with no human interaction so the BC comes online

  @scenario_hash:815f8e470163f669
  Scenario: Fullscreen-renderer onboarding prompt is auto-dismissed so launch proceeds
    Given a BC container whose agent presents the "Try the new fullscreen renderer?" onboarding prompt before the workspace-trust banner appears
    And the launcher is running the readiness sequence waiting for the input-ready marker "bypass permissions on"
    When the readiness loop detects the fullscreen-renderer prompt blocking progress to input-ready
    Then the launcher dismisses it by sending Esc without enabling the new renderer
    And the launcher emits a warning naming the fullscreen-renderer prompt it auto-dismissed
    And the readiness loop proceeds and observes the input-ready marker "bypass permissions on"
    And the startup prompt is injected and the BC comes online

  @scenario_hash:acf59eb2e265fde7
  Scenario: Readiness is bounded when auto-dismissal does not reach input-ready
    Given a BC container whose agent keeps presenting an unexpected interactive prompt that the launcher auto-dismisses with Esc
    And the input-ready marker "bypass permissions on" is never observed
    When the readiness timeout of 60 seconds elapses across the auto-dismissal attempts
    Then the launcher stops attempting dismissals rather than looping indefinitely
    And the launcher emits a warning that the main input did not become ready within 60 seconds
    And the launcher proceeds without injecting the startup prompt
