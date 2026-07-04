@bc_internal
Feature: work-done-gate check refinements (deliverable-scope, idempotent-no-op, genuine-red)
  Pins three prose refinements to the work-done-gate skill: Check 1 is
  deliverable-scoped (one coherent model that subsumes the lead-20bt ambient
  carve-out list), Check 2 has an idempotent-no-op branch for flat maintenance
  whose end-state already holds, and Check 5 requires a genuine (non-tautological)
  red. The lead-20bt wrapper-parity scenarios stay green as instances of Check 1.

  @scenario_hash:cb6c9d2c0102bee4 @bc:shopsystem-templates
  Scenario: work-done-gate Check 1 treats the tree as clean when all deliverable paths are clean even though non-deliverable harness or config paths are dirty, and still blocks when a deliverable path is dirty
    Given a BC at work_done time whose "git status --porcelain -uall" reports no modified, staged, untracked, or deleted path under any deliverable directory "features/", "src/", or "tests/"
    And the only non-empty entries are non-deliverable harness or configuration paths such as ".claude/settings.json" or ".claude/canonical/bc-primer.md", alongside the ambient carve-outs ".beads/issues.jsonl", ".specstory", and ".claude/scheduled_tasks.lock"
    When the BC runs Check 1 of the work-done-gate before emitting "work_done --status complete"
    Then Check 1 passes and does not convert the emission to "work_done --status blocked", because no deliverable path under "features/", "src/", or "tests/" is dirty
    And when instead at least one path under a deliverable directory "features/", "src/", or "tests/" is dirty, Check 1 fails and converts the emission to "work_done --status blocked" naming each dirty deliverable path verbatim as "git status --porcelain -uall" reported it

  @scenario_hash:eff263fdba0681ac @bc:shopsystem-templates
  Scenario: work-done-gate Check 2 is satisfied by an idempotent no-op convergence when the dispatch is flat maintenance whose intended end-state already holds with no delta needed
    Given a dispatched work_id whose vehicle is flat maintenance and whose intended end-state already holds in the BC repository, so a verifiably-correct convergence requires no change and produces no new commit naming the work_id
    And a "git fetch origin" followed by "git log origin/main -E --grep" for the work_id whole token finds no commit, because none was needed
    When the BC runs Check 2 of the work-done-gate before emitting "work_done --status complete"
    Then Check 2 passes via its idempotent-no-op branch and does not convert the emission to "work_done --status blocked", because the maintenance end-state already holds and no work_id commit is required
    And when instead the flat-maintenance end-state does NOT already hold so a delta is needed, the idempotent-no-op branch does not apply and Check 2 still requires a work_id commit reachable from "origin/main", failing to blocked when none exists

  @scenario_hash:488175f45c00bdc9 @bc:shopsystem-templates
  Scenario: work-done-gate Check 5 requires the red commit's newly-added tests to demonstrably fail at the red commit, not merely that the red commit precedes the green commit
    Given a behavior whose work-branch history has a "test(red)" commit preceding its "feat(green)" commit so the commit order alone would satisfy an order-only check
    And the newly-added tests introduced by that "test(red)" commit are run against the tree at the "test(red)" commit
    When the BC runs Check 5 of the work-done-gate before emitting "work_done --status complete"
    Then Check 5 passes only when those newly-added tests demonstrably FAIL at the "test(red)" commit, establishing a genuine red rather than a tautological one
    And when the newly-added tests instead PASS at the "test(red)" commit, Check 5 fails and converts the emission to "work_done --status blocked" naming the behavior and the tautological-red "test(red)" commit even though the red-before-green commit order holds
