@bc:shopsystem-bc-launcher @origin:lead-ktl0
Feature: BC-standup empty-remote-seed git-pushes to the plain https tracker URL and never fatally aborts the bd dolt seed (GAP E, lead-ktl0)

  Re-running create-bc under fabro (bc-launcher v0.3.54, 2026-07-08) with GAP
  A/B/D fixed: the standup's empty-remote-seed step now FIRES (GAP D, lead-ypnz),
  but "_empty_remote_seed_script" (controller.py:257) exits 1. ROOT (proven
  in-container): the seed runs 'git push "{beads_remote_url}" main' where
  "beads_remote_url" is the "git+https://" DOLT url; raw git rejects that scheme —
  "git: 'remote-git+https' is not a git command; fatal: remote helper 'git+https'
  aborted session" (exit 128). Under "set -e" the seed ABORTS on that error
  BEFORE the "bd dolt remote add" + "bd dolt push" steps that actually seed the
  Dolt data, so the tracker never gets its refs/dolt/* and the retried
  "bd bootstrap" never succeeds. PROVEN in-container: 'git push git+https://...'
  -> 128; 'bd dolt push' -> "Push complete". The git-side push is ALSO redundant:
  create-absent already 'gh repo create --add-readme'd the initial branch/commit,
  so pushing an unrelated seed commit to "main" would conflict regardless.

  This pins TWO coupled properties of the seed's git-side push: (a) it targets the
  plain "https://" tracker URL — the "git+" dolt prefix STRIPPED — not the raw
  "git+https://" dolt url git's remote-helper rejects; AND (b) it is NON-FATAL, so
  a redundant/no-op git-side push does NOT abort the seed before the subsequent
  "bd dolt push" (the actual Dolt seed "bd bootstrap" needs) runs and completes.
  Fidelity binds to the executable seed script "_empty_remote_seed_script" — the
  URL string it passes to "git push" and the non-fatal ordering of that push
  relative to "bd dolt push" — NOT a live standup/GitHub run. The observable is
  Examples-driven: the plain-https row seeds refs/dolt/* and the retried bootstrap
  exits zero; the git+https negative-control row aborts with the remote-helper
  error and (pre-fix) strands the seed before "bd dolt push", leaving the tracker
  unseeded.

  Left for the Architect to finalize the @bc owner tag at dispatch (target:
  shopsystem-bc-launcher).

  @scenario_hash:fa1bb9d7e6653b35
  Scenario Outline: the empty-remote-seed's git-side push targets the plain https tracker URL and is non-fatal, so the subsequent bd dolt push seeds refs/dolt/* and the retried bd bootstrap exits zero
    Given the standup's create-absent orchestration already created the tracker repo "<owner>/<bc>-beads" with "gh repo create --add-readme", so it exists with an initial git branch/commit but carries no refs/dolt/*
    And the surface under observation is the executable "_empty_remote_seed_script" — the URL string it passes to "git push" and the ordering of that push relative to its "bd dolt push" step — not a live standup or GitHub run
    And the seed script's git-side push targets the URL "<git_push_url>" for the tracker whose configured dolt remote is "git+https://github.com/<owner>/<bc>-beads.git"
    When the empty-remote-seed step runs its git-side push and then its "bd dolt push" seed step under "set -e"
    Then the git-side push resolves as "<git_push_result>" without raising the "remote helper 'git+https' aborted session" fatal that a raw "git+https://" scheme would raise
    And because the git-side push is non-fatal, the seed reaches and runs its "bd dolt push" step, which is recorded as "<reaches_dolt_push>"
    And after the seed the tracker's refs/dolt/* presence is "<dolt_refs_seeded>" and the retried "bd bootstrap" exit is "<bootstrap_exit>"

    Examples:
      | owner    | bc                    | git_push_url                                           | git_push_result             | reaches_dolt_push | dolt_refs_seeded | bootstrap_exit |
      | dstengle | shopsystem-knowledge  | https://github.com/dstengle/shopsystem-knowledge-beads.git | redundant-noop-non-fatal    | reached-and-run   | present          | zero           |
      | dstengle | shopsystem-knowledge  | git+https://github.com/dstengle/shopsystem-knowledge-beads.git | remote-helper-aborted-exit-128 | never-reached     | absent           | nonzero        |
