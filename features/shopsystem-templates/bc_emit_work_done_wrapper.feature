@bc_internal
Feature: bc-emit work-done wrapper — executable pre-emit preconditions over the work-done-gate

  @scenario_hash:461d6066ef7dca0a @bc:shopsystem-templates
  Scenario: bc-emit work-done refuses the emit when the COMMIT deliverable for the work_id is not reachable from the BC's origin/main HEAD, naming the work_id and the current origin/main HEAD
    Given a dispatched work_id whose deliverable is a COMMIT attributable to that work_id
    And no commit attributable to the work_id is reachable from the BC's "origin/main" HEAD after a "git fetch origin"
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then the wrapper exits non-zero and does not invoke "shop-msg respond work_done"
    And the wrapper's error names the work_id-commit-on-origin-main precondition as the cause and names both the dispatched work_id and the current "origin/main" HEAD short SHA
    And a commit attributable to the work_id that exists only on a branch other than the BC's main branch (e.g. an un-merged or un-pushed local branch) does NOT satisfy the precondition; only reachability from "origin/main" HEAD satisfies it

  @scenario_hash:12c98d2f7e5259a9 @bc:shopsystem-templates
  Scenario: bc-emit work-done satisfies reachability for a TAG deliverable when the named tag exists and points at the expected commit lineage, even though origin/main HEAD has advanced past that commit
    Given a dispatched work_id whose deliverable is a release TAG that names an expected commit lineage
    And the named tag exists on "origin" after a "git fetch origin --tags" and points at the expected commit lineage
    And the BC's "origin/main" HEAD has legitimately advanced to a later commit that does NOT carry the work_id
    When the BC invokes the "bc-emit work-done" wrapper for that work_id in the TAG/release-deliverable mode
    Then the wrapper treats the reachability precondition as satisfied and does NOT refuse on the ground that the work_id is absent from "origin/main" HEAD
    And the satisfaction is established by the tag pointing at the expected commit lineage, not by the work_id being reachable from "origin/main" HEAD

  @scenario_hash:6d95d409dd527be6 @bc:shopsystem-templates
  Scenario: bc-emit work-done REFUSES for a TAG deliverable when the named tag exists but points at a commit lineage that does NOT carry/anchor the dispatched work_id, naming both the tag and the work_id
    Given a dispatched work_id whose deliverable is a release TAG that names an expected commit lineage
    And the named tag exists on "origin" after a "git fetch origin --tags" and its "git rev-list" is non-empty
    But the commit lineage the tag points at does NOT carry or anchor the dispatched work_id — for example the tag points at the repository's unrelated seed commit that bears no relationship to the work_id
    When the BC invokes the "bc-emit work-done" wrapper for that work_id in the TAG/release-deliverable mode
    Then the wrapper exits non-zero and does not invoke "shop-msg respond work_done"
    And the wrapper's error names the tag-lineage-anchors-work_id precondition as the cause and names both the offending tag and the dispatched work_id
    And mere tag existence with a non-empty "git rev-list" does NOT satisfy the precondition; only a tag whose commit lineage carries/anchors the dispatched work_id satisfies it, so the positive arm above and this refusal differ solely on whether the tag's lineage anchors the work_id

  @scenario_hash:ea9c1bbd9be87d72 @bc:shopsystem-templates
  Scenario: bc-emit work-done refuses the emit when a recomputed scenario-block-only canonical hash diverges from the carried hash, names the divergence as stale, missing, or orphan, and uses the block-only delegate rather than the Feature-line-included wire form
    Given a dispatched work_id whose deliverable includes one or more scenario blocks committed under "features/" each carrying an "@scenario_hash:<hex>" tag
    And the wrapper recomputes each candidate scenario hash by delegating in-process to "scenarios.hash.compute_scenario_hash" using scenario-block-only canonicalization, with the enclosing "Feature:" header line NOT part of the hashed text
    When the recomputed set and the payload's "--scenario-hash" set diverge by at least one member — a carried hash whose recompute differs (stale), a features/-present dispatched scenario block with no carried hash (missing), or a carried hash matching no scenario block under "features/" (orphan)
    Then the wrapper exits non-zero and does not invoke "shop-msg respond work_done"
    And the wrapper's error names the scenario_hashes-match precondition as the cause, classifies the offending member as stale, missing, or orphan, and names the affected hash value and scenario
    And the recompute that produced the refusal used the scenario-block-only canonical hash from "scenarios.hash.compute_scenario_hash", never the Feature-line-included canonicalization carried on the wire "scenarios[].hash"

  @scenario_hash:4a6133f7b5f061a2 @bc:shopsystem-templates
  Scenario: on any bc-emit work-done precondition refusal the named-cause error directs the BC to self-resolve its own state and re-emit, and never names the lead or router as the actor for BC-repo state
    Given the "bc-emit work-done" wrapper refuses an emit on any of its preconditions — clean-working-tree, work_id-commit-on-origin-main, tag-deliverable reachability, or scenario_hashes-match
    When the BC reads the wrapper's named-cause error text
    Then the error directs the BC to self-resolve its OWN bead, commit, and working-tree state — committing its own changes or correcting its own hashes — and then to re-invoke "bc-emit work-done"
    And the error text does NOT instruct, request, or imply that the lead, the router, or any non-BC actor should commit, push, or reconcile the BC's repository state

  @scenario_hash:f81ee56bc163934b @bc:shopsystem-templates
  Scenario: bare shop-msg respond work_done --force deposits the work_done without running any bc-emit wrapper precondition, even when those preconditions would otherwise refuse the emit
    Given a BC whose state would cause the "bc-emit work-done" wrapper to refuse — for instance a dirty non-carved-out working tree, an unreachable work_id commit, or a scenario-hash mismatch
    When the BC invokes the bare messaging primitive "shop-msg respond work_done --force" directly rather than the "bc-emit work-done" wrapper
    Then the work_done message is deposited to the lead's inbox without any clean-working-tree, commit-or-tag-reachability, or scenario_hashes-match precondition being run by "shop-msg respond"
    And the availability of this bare forced-recovery path is independent of the wrapper, so landing the wrapper and retiring the prose preconditions does not remove the "--force" escape valve

  @scenario_hash:cba037e97c6a8325 @bc:shopsystem-templates
  Scenario: bc-emit work-done's clean-working-tree precondition is deliverable-scoped — it refuses the emit only when a path under features/, src/, or tests/ is dirty, and does NOT refuse when the only dirty paths are non-deliverable harness or config paths
    Given a BC repository whose "git status --porcelain -uall" output reports modified, staged, or untracked paths ONLY under non-deliverable harness or config paths — for example ".claude/canonical/bc-primer.md", ".claude/settings.json", or the ambient carve-outs ".specstory", ".claude/scheduled_tasks.lock", and ".beads/issues.jsonl" — and reports NO modified, staged, untracked, or deleted path under any deliverable directory "features/", "src/", or "tests/"
    When the BC invokes the "bc-emit work-done" wrapper for its dispatched work_id
    Then the wrapper does NOT refuse on the clean-working-tree precondition and proceeds to the remaining preconditions, treating the tree as clean because no deliverable path is dirty
    And the same wrapper, run against a tree whose "git status --porcelain -uall" reports a dirty path under any deliverable directory "features/", "src/", or "tests/", exits non-zero, does not invoke "shop-msg respond work_done", and names the clean-working-tree precondition as the cause while listing each offending deliverable path verbatim as "git status --porcelain" reported it

  @scenario_hash:aabbc009bad6fe86 @bc:shopsystem-templates
  Scenario: bc-emit work-done's scenario-hash staleness check is scoped to the dispatch's own assigned scenario set — an otherwise-clean emit passes Check 3 even when an unrelated stale "@scenario_hash" tag exists elsewhere under features/, while a stale tag WITHIN the dispatch's own scope still refuses
    Given a dispatched work_id whose assigned scenario set is exactly the scenario blocks committed under "features/" that the dispatch named, each carrying an "@scenario_hash:<hex>" tag whose value the "bc-emit work-done" wrapper recomputes via scenario-block-only canonicalization
    And every scenario block in the dispatch's own assigned set is clean — for each, the recomputed scenario-block-only canonical hash equals the on-disk "@scenario_hash:<hex>" tag
    And a DIFFERENT scenario block elsewhere under "features/", owned by a separate work item and never named by this dispatch, carries a stale "@scenario_hash:<hex>" tag whose on-disk value no longer equals the hash "scenarios hash" recomputes against its as-committed body
    When the BC invokes the "bc-emit work-done" wrapper for its dispatched work_id
    Then the wrapper's scenario-hash staleness check (Check 3) evaluates ONLY the scenario blocks in the dispatch's own assigned set, does NOT scan the unrelated scenario block elsewhere under "features/", does not refuse on the staleness check, and proceeds to the remaining preconditions
    And the same wrapper, run for a dispatch one of whose OWN assigned scenario blocks carries a stale "@scenario_hash:<hex>" tag — the recomputed scenario-block-only canonical hash differs from the on-disk value — exits non-zero, does not invoke "shop-msg respond work_done", names the scenario-hash staleness check as the cause, and names the in-scope work_id, the stale hash value, and the recomputed value

  @scenario_hash:613ddd886f6dc431 @bc:shopsystem-templates
  Scenario: bc-emit work-done's scenario-hash staleness check is evaluated against the fetched origin/main tree — a lagging local checkout does NOT false-refuse on a scenario that is consistent on origin/main, any unavoidable refusal names local-main-behind-origin/main and "sync local main" as the cause, and a scenario genuinely stale on origin/main still refuses
    Given a dispatched work_id whose own assigned scenario set is committed and reconciled on the BC's "origin/main" — each block's on-disk "@scenario_hash:<hex>" tag reproduces against its as-committed body on "origin/main" via scenario-block-only canonicalization
    And the BC's primary checkout local main is behind "origin/main" — its HEAD is an ancestor of "origin/main" HEAD — so the local working tree carries a STALE version of one or more of those scenario blocks whose on-disk "@scenario_hash:<hex>" tag does not reproduce against the stale local body
    When the BC invokes the "bc-emit work-done" wrapper for that work_id
    Then the wrapper performs a "git fetch origin" and evaluates the scenario-hash staleness check (Check 3) against the fetched "origin/main" tree — mirroring the Check 2 reachability posture (scenario 177) — and does NOT refuse on a scenario block that is consistent on "origin/main" but stale only in the lagging local checkout
    And if the wrapper instead refuses, its named-cause error identifies local-main-behind-origin/main as the primary cause and directs the BC to fast-forward (sync) its OWN local main to "origin/main" and re-emit — it does NOT name the scenario-hash recompute-mismatch as the cause, and does NOT direct the BC toward "--force" or toward editing the already-reconciled scenario
    And a scenario block in the dispatch's own assigned set that is genuinely stale on "origin/main" — its on-disk "@scenario_hash:<hex>" tag does not reproduce against its as-committed body on "origin/main" HEAD — still exits non-zero, does not invoke "shop-msg respond work_done", and names the scenario-hash staleness check as the cause, not masked by the local-staleness handling
