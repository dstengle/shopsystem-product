@bc:shopsystem-bc-launcher @origin:lead-k4k7
Feature: bc-container launch skill-refresh uses the correct shop-templates invocation and surfaces failures (lead-q5k7)

  bc-container launch refreshes the launched shop's ".claude/skills/" by
  running shop-templates AFTER the clone, so a launched shop boots with the
  CURRENT package skills (including the lead-80t0 beads-health step) rather
  than the stale ".claude/skills/" committed in its own repo.

  lead-q5k7 bugfix.  The prior invocation execed `shop-templates pour
  --workspace <ws>` — but `shop-templates` has NO `pour` subcommand (valid:
  list/show/bootstrap/update) and the flag is `--target`, not `--workspace`.
  That exec FAILED on every launch, yet the launcher appended a "Poured ..."
  success line WITHOUT checking the result, hiding the failure so the
  refresh silently never ran.  The correct invocation is
  `shop-templates update --target <ws> --shop-type <bc|lead>`, the result
  MUST be checked, and a failed refresh MUST surface a real error instead of
  logging false success.

  @scenario_hash:96a1617dd4586f60
  Scenario: launch runs the VALID shop-templates update invocation with the derived shop-type
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    And the bc-base image carries the shop-templates binary
    And the cloned shop's type marker is "bc"
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then launch runs "shop-templates update" targeting the container's workspace with shop-type "bc"
    And launch never runs the invalid "shop-templates pour" command
    And the launch result is success

  # lead-k4k7 SUPERSEDES the disposition this scenario originally pinned.
  # q5k7 made a failed skill-refresh a FATAL early-return; that early-return
  # (BEFORE the agent-start step) stranded a fully-cloned "Up (healthy)"
  # container with NO agent when the refresh failed transiently (network blip),
  # observed live 2026-06-19 blocking 8 dispatches.  The skill-refresh is a
  # freshness nicety, not a precondition for the agent to run, so a failed
  # refresh now WARNS and PROCEEDS to agent-start instead of aborting.  q5k7's
  # surviving invariants are preserved: the launch still never logs false
  # success and still deposits NO skills on a failed refresh.
  @scenario_hash:db11ca7b46dd12a4
  Scenario: a failed skill-refresh warns and proceeds to agent-start without logging false success
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    And the bc-base image carries the shop-templates binary
    And the shop-templates skill-refresh fails at runtime
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the launch warns about the shop-templates update failure and still starts the agent
    And the launch output never claims the skill-group was refreshed

  @scenario_hash:2cd278b67bb5cd0f
  Scenario: a successful refresh deposits the health-bearing bc-router skill into the workspace
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    And the bc-base image carries the shop-templates binary
    And the cloned shop's type marker is "bc"
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the workspace's ".claude/skills/" carries the health-bearing bc-router skill after launch
