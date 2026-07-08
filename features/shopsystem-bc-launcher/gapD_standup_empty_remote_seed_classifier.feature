@bc:shopsystem-bc-launcher @origin:lead-ypnz
Feature: BC-standup empty-remote-seed classifier recognizes the current bc-base dolt "contains no Dolt data" error so a freshly-created tracker gets seeded (GAP D, lead-ypnz)

  Re-running create-bc for shopsystem-knowledge under fabro (bc-launcher v0.3.53,
  2026-07-08) with GAP A (gh-token, lead-3mez) and GAP B (owner, lead-r34c)
  already fixed: "bd bootstrap" now reaches the correct
  "dstengle/shopsystem-knowledge-beads" tracker but fails
  "Error 1105: clone failed; remote at that url contains no Dolt data". The
  standup's empty-remote-seed step (controller.py:2655, lead-5k8c) — which
  git-init-and-seeds the tracker's initial Dolt data then retries bootstrap — is
  gated on "_is_empty_remote_failure" (controller.py:185), which matches ONLY the
  LEGACY dolt error ("git remote has no branches", or "no branches" AND
  "initialize"). After create-absent's "gh repo create --add-readme" the tracker
  exists WITH a git README branch but NO Dolt refs, and the CURRENT bc-base dolt
  emits "contains no Dolt data" for that state — a string the classifier MISSES —
  so the seed never fires, the tracker stays unseeded, "bd bootstrap" never
  succeeds, and the standup defers to a session-start heal fabro's deterministic
  dispatcher never runs → BC offline.

  This pins a VERSION-ROBUST classifier match, additive to the empty-remote
  seed-then-retry behavior already authored in this register
  (@scenario_hash:ada742d33c996d34, lead-5k8c): the bar here is that
  "_is_empty_remote_failure" recognizes the current-dolt "contains no Dolt data"
  string in addition to the legacy "no branches" one, so the seed fires for a
  freshly --add-readme'd tracker. Fidelity binds to the controller's executable
  classifier (the "_is_empty_remote_failure" predicate) plus the seed-then-retry
  block it gates, exercised on the real error text — NOT a live standup/GitHub
  run. Negative control is Examples-driven: the "contains no Dolt data" row is RED
  against the pre-fix legacy-only classifier (seed unfired) and GREEN post-fix.

  Left for the Architect to finalize the @bc owner tag at dispatch (target:
  shopsystem-bc-launcher).

  @scenario_hash:6fc82a7375ed8aa9
  Scenario Outline: the standup's empty-remote-seed step fires for an unseeded freshly-created tracker because the empty-remote classifier recognizes the current bc-base dolt "contains no Dolt data" error as well as the legacy "no branches" error
    Given the standup's create-absent orchestration has created the tracker repo "<owner>/<bc>-beads" with "gh repo create --add-readme", so it exists with a git README branch but carries no Dolt refs
    And in that state the in-container "bd bootstrap" fails its Dolt clone with the error text "<bootstrap_error>"
    And the classification under observation is the standup's executable "_is_empty_remote_failure" predicate exercised on that error text, and the seed step under observation is the controller's seed-then-retry block that predicate gates, not a live standup run
    When the standup evaluates whether that "bd bootstrap" failure is an empty/unseeded-remote failure and runs its empty-remote-seed step
    Then the "_is_empty_remote_failure" predicate classifies "<bootstrap_error>" as an empty-remote failure, recognizing the current bc-base dolt "contains no Dolt data" text in addition to the legacy "git remote has no branches" text
    And because the failure is classified as empty-remote, the seed step fires, git-init-and-seeds the tracker's initial Dolt data, and the retried "bd bootstrap" exits zero instead of leaving the tracker unseeded
    And the seed firing is caused specifically by recognizing the current-dolt string, so a legacy-only classifier matching solely "git remote has no branches" would leave the seed unfired on the "contains no Dolt data" error rather than retrying unconditionally

    Examples:
      | owner    | bc                    | bootstrap_error                                                                                 |
      | dstengle | shopsystem-knowledge  | clone failed; remote at that url contains no Dolt data                                           |
      | dstengle | shopsystem-knowledge  | git remote has no branches: ...; initialize the repository with an initial branch/commit first  |
