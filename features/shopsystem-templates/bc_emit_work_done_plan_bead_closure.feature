@bc_internal
Feature: bc-emit work-done plan-bead-closure carve-out parity
  Pins, at the executable wrapper level, the prose<->wrapper parity that
  the work-done-gate Check 1 carve-out depends on: a working tree whose only
  change is the work_id plan-bead closure in .beads/issues.jsonl is treated
  clean (one clean complete emit, no deadlock), while a real non-carved-out
  source change alongside that closure still blocks, naming only the source.

  @scenario_hash:c4d784eda58d01bc @bc:shopsystem-templates
  Scenario: bc-emit work-done treats a working tree whose only change is the work_id plan-bead closure in .beads/issues.jsonl as clean and proceeds to a single clean emit
    Given a BC that has closed its work_id plan bead, so the only non-empty "git status --porcelain" entry is a modification to ".beads/issues.jsonl" recording that closure
    And every other working-tree path is unmodified and the work_id deliverable is reachable from the BC's "origin/main" HEAD with matching scenario hashes
    When the BC invokes the "bc-emit work-done" wrapper for its dispatched work_id
    Then the wrapper does not refuse on the clean-working-tree precondition, because ".beads/issues.jsonl" is an ambient carve-out and the plan-bead closure is the sole change
    And the wrapper proceeds through its remaining preconditions and invokes "shop-msg respond work_done --status complete" exactly once, with no intervening "--status blocked" emission for the plan-bead closure

  @scenario_hash:e1b33c51cee48db5 @bc:shopsystem-templates
  Scenario: bc-emit work-done still refuses the emit when a non-carved-out source path is modified alongside the plan-bead closure in .beads/issues.jsonl
    Given a BC whose "git status --porcelain" output reports a modification to ".beads/issues.jsonl" recording the work_id plan-bead closure AND a modification to at least one non-carved-out source path
    When the BC invokes the "bc-emit work-done" wrapper for its dispatched work_id
    Then the wrapper exits non-zero and does not invoke "shop-msg respond work_done"
    And the wrapper's error names the clean-working-tree precondition as the cause and lists the non-carved-out source path verbatim as "git status --porcelain" reported it
    And the ".beads/issues.jsonl" entry is not listed as an offending path, so the refusal is attributable solely to the uncommitted source change and not to the plan-bead closure
