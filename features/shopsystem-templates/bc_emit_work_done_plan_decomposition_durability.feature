@bc_internal
Feature: bc-emit work-done plan-decomposition closure + bd-dolt durability
  Tightens the executable "bc-emit work-done" wrapper's bd-plan-decomposition
  preconditions (work-done-gate Check 4 + durability, ADR-036 D1/D2). The gate
  enumerates EVERY sub-issue reachable under the work_id umbrella bead from the
  BC's own bd registry — refusing on any still-OPEN sub-issue including an
  orphan from an abandoned earlier decomposition the implementer never closed —
  and verifies the decomposition-and-closure state is reachable from the pushed
  tracker remote (the configured bd-dolt remote), naming the
  bd-decomposition-non-durable precondition specifically rather than a generic
  dirty working tree. Additive to scenarios 176-181, 154, and beads-health 05;
  nothing retired.

  @scenario_hash:0b48508e40fdde18 @bc:shopsystem-templates
  Scenario: bc-emit work-done refuses the emit when any sub-issue reachable under the work_id umbrella bead is still OPEN — including an orphaned sub-issue from an abandoned earlier decomposition the implementer never closed — naming each offending OPEN sub-issue
    Given a dispatched work_id whose umbrella bead carries TDD sub-issues, at least one of which is a RED sub-issue, and the implementer's real decomposition pass closed every sub-issue that pass created
    And a separate earlier abandoned decomposition left at least one orphaned sub-issue still OPEN under the same work_id umbrella bead, which the implementer never closed
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then the wrapper exits non-zero and does not invoke "shop-msg respond work_done"
    And the wrapper's error names the all-sub-issues-under-the-work_id-umbrella-closed precondition as the cause and lists each still-OPEN sub-issue, including the orphaned one, by its bd id
    And the precondition is evaluated by enumerating EVERY sub-issue reachable under the work_id umbrella bead — not only the set the implementer reports or itself closed — so an OPEN sub-issue the implementer did not create still blocks the emit and the prior "at least one RED sub-issue exists and all sub-issues the implementer closed are closed" check alone does NOT pass the gate

  @scenario_hash:7bcfc89161c0b2ee @bc:shopsystem-templates
  Scenario: bc-emit work-done refuses the emit when the work_id's sub-issue closures exist only in an uncommitted or locally-staged .beads registry that is not reachable from the pushed tracker remote, naming the bd-decomposition-non-durable precondition specifically rather than a generic dirty working tree
    Given a dispatched work_id whose umbrella bead's TDD sub-issues are all closed in the BC's local bd state
    And those sub-issue creations and closures exist only in an uncommitted or locally-staged ".beads" registry that is NOT yet committed and reachable from the BC's pushed tracker remote — the configured bd-dolt remote / "origin/main"
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then the wrapper exits non-zero and does not invoke "shop-msg respond work_done"
    And the wrapper's error names the bd-decomposition-durability precondition specifically — that the work_id's sub-issue decomposition and closures are not reachable from the pushed tracker remote — and names the work_id, rather than reporting a generic dirty-working-tree cause
    And the durability precondition is satisfied by the decomposition-and-closure state being reachable from the pushed tracker remote, NOT by the ".beads/issues.jsonl" working-tree bytes being clean — consistent with that path being a carved-out non-idempotent ambient artifact under the clean-working-tree precondition, so the carve-out cannot by itself establish that the closures are durable
