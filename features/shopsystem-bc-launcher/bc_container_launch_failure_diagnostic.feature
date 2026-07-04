@bc:shopsystem-bc-launcher @origin:lead-63em
Feature: bc-container launch persists a host-readable diagnostic file naming the failure cause when a launch fails to bring up a usable session

  # lead-63em (re-issue of lead-2qta, resolving this BC's surface-ambiguity
  # clarify): a launch that fails to bring up a usable agent session writes a
  # PERSISTED diagnostic FILE — NOT stderr, NOT the bc-container monitor tmux
  # pane — to a documented per-BC host-discoverable location on the same
  # host-visible per-BC surface the mailbox is read from. The file carries the
  # literal cause-marker token so the operator is pointed at the right repair,
  # and is readable from the host with no tmux attach and independent of the
  # (ephemeral) launch stderr. Documented location (see controller.py
  # launch_diagnostic_path / BCLAUNCHER_HOST_STATE_DIR):
  #   <BCLAUNCHER_HOST_STATE_DIR|/var/lib/bc-launcher>/<container>/launch-diagnostic.txt

  @scenario_hash:0d010cf8f3175226
  Scenario Outline: a launch that fails to bring up a usable session writes a persisted host-readable diagnostic file naming the specific failure cause
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And the launch will fail to bring up a usable session because <fault>
    When I run bc-container launch with BC name "shopsystem-messaging" and a startup prompt
    Then the command exits non-zero
    And no usable tmux session named "agent" is available to attach to in container "bc-shopsystem-messaging"
    And bc-container writes the diagnostic to a persisted file at a known, documented host-discoverable location on the same host-visible per-BC surface the mailbox is read from, stating why the session failed to come up
    And that persisted diagnostic file is readable from the host without attaching into any tmux session and without relying on the launch command's stderr or the bc-container monitor tmux pane
    And the diagnostic names the failure cause by carrying the literal cause-marker token "<cause_marker>" exactly, so the operator is pointed at the right repair

    Examples:
      | fault                                                            | cause_marker  |
      | the messaging database at SHOPMSG_DSN is unreachable              | messaging-db  |
      | the agent-vault broker on the shopsystem network is unreachable   | agent-vault   |
      | the readiness barrier never reports both supporting servers ready | readiness     |
      | claude or its tmux session never started inside the container     | agent-startup |

  @scenario_hash:7084bbbfdef94f81
  Scenario: the persisted diagnostic file is discoverable from the host even when no tmux session ever came up
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    And a launch of BC name "shopsystem-messaging" failed before any usable tmux session named "agent" came up
    When I look for the launch diagnostic from the host without attaching into any tmux session
    Then bc-container exposes the diagnostic as a persisted file at a known, documented host-discoverable location on the same host-visible per-BC surface the mailbox is read from
    And that persisted diagnostic file is readable from the host even though no tmux session named "agent" ever came up and the launch command's stderr is no longer available
    And the diagnostic states why the session failed to come up
