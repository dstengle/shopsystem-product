@bc:shopsystem-bc-launcher @origin:lead-372r
Feature: create-bc empty-remote seed clears any partial ".beads/embeddeddolt" before "bd init -p" so the create-fresh is not aborted (GAP I, ROOT, lead-372r)

  CONFIRMED by the lead's in-container empirical verification (lead-372r,
  bc-launcher v0.3.57, 2026-07-08): GAP H's seed runs "bd init -p <prefix> ||
  true" after unconfiguring "sync.remote", but at launch time the PRECEDING
  failed "bd bootstrap" (the empty-remote clone) LEAVES a PARTIAL
  ".beads/embeddeddolt". "bd init -p" then ABORTS ("database already exists;
  use bd init --force") — a failure MASKED by the "|| true" — so the
  create-fresh never happens, "bd dolt push" seeds nothing, and the fatal
  verify ("git ls-remote refs/dolt") fails, driving the seed to exit 1 and the
  BC offline. The lead's manual test worked ONLY because it removed the partial
  DB first ("rm -rf .beads/embeddeddolt"); the launch does not. This is the LAST
  beads-flow gap (A/B/D/E/G/H all fixed).

  FIDELITY: the step defs bind to the create-bc standup's "_empty_remote_seed_
  script" ORDERING — that it clears the partial ".beads/embeddeddolt" (via
  "rm -rf .beads/embeddeddolt" or equivalently "bd init --force") BEFORE
  "bd init -p", and the negative control that leaving the partial DB in place
  aborts the create-fresh under the "|| true" mask — read against the create-bc
  standup definition, NOT a live container run.

  @scenario_hash:7c245031122e41bb
  Scenario: the empty-remote seed clears any partial ".beads/embeddeddolt" left by the failed bootstrap before "bd init -p" so the create-fresh runs, with a negative control that leaving it aborts the create-fresh under the "|| true" mask
    Given a new BC is stood up via "create-bc" whose beads tracker remote is EMPTY of Dolt data, so the standup's preceding "bd bootstrap" empty-remote clone FAILS and leaves a PARTIAL ".beads/embeddeddolt" on disk
    And the standup has unconfigured "sync.remote" ahead of its create-fresh "bd init -p <prefix>" per GAP H (lead-tc38, @scenario_hash:5351a4a8071b594f)
    When the create-bc standup's empty-remote seed orchestration runs its create-fresh ordering
    Then the seed FIRST clears the partial state by removing ".beads/embeddeddolt" (via "rm -rf .beads/embeddeddolt", or equivalently by running "bd init --force") BEFORE it runs "bd init -p <prefix>"
    And "bd init -p <prefix>" then CREATE-FRESHES a prefixed local dolt database adopting the committed issue_prefix rather than aborting "database already exists; use bd init --force"
    And the standup then seeds that prefixed local database with "bd dolt push" so the tracker remote carries Dolt data with "refs/dolt/*" refs present and the fatal "git ls-remote refs/dolt" verify passes rather than driving the seed to exit 1
    And as the negative control, had the seed left the partial ".beads/embeddeddolt" in place, "bd init -p" would ABORT "database already exists" — a failure MASKED by the "|| true" — so the create-fresh would never run, "bd dolt push" would seed nothing, and the fatal verify would fail, which is the exact pre-fix offline failure this clear-before-init ordering exists to avoid
