@bc:shopsystem-bc-launcher @origin:lead-tc38
Feature: create-bc standup unconfigures the empty sync.remote before bd init so the prefixed local dolt DB create-freshes instead of clone-hard-failing (GAP H, ROOT, lead-tc38)

  Decisive in-container test (bc-launcher v0.3.56, David 2026-07-08): GAP G's
  create-fresh ("bd init -p <prefix>") HARD-FAILS ("Error 1105: clone failed;
  remote at that url contains no Dolt data") because the scaffolded
  ".beads/config.yaml" already carries a configured "sync.remote" (GAP B,
  lead-r34c) pointing at the derived "<owner>/<bc>-beads" remote, which exists
  but is EMPTY of Dolt data. With that remote configured, BOTH "bd init -p" and
  "bd bootstrap" try to CLONE the empty remote and hard-fail instead of
  create-freshing a fresh local DB from the committed prefix. GAP G's scenario
  (standup_create_fresh_prefixed_dolt_before_seed @scenario_hash:e3a0ec19298e7ce7)
  and the reviewer's fixtures MISSED this configured-empty-remote precondition —
  a false-green, because the fixture did not replicate the real launch state in
  which sync.remote is already configured at bd-init time.

  This pins the CONFIRMED working ordering as the fix: the standup must run its
  "bd init -p" create-fresh with "sync.remote" UNCONFIGURED (the sync.remote line
  temporarily removed from ".beads/config.yaml"), so "bd init" adopts the
  committed metadata.json prefix and create-freshes a PREFIXED local dolt DB
  rather than attempting the empty-remote clone; only THEN does the standup
  restore "sync.remote", add the git+https origin, and "bd dolt push" to seed
  "refs/dolt/*". Fidelity binds to the standup's executable provisioning
  orchestration — specifically the unconfigure -> bd-init-create-fresh ->
  reconfigure -> seed ORDERING — read against the create-bc standup definition,
  NOT a live container run. This is the ROOT enabler of the whole A/B/D/E/G chain
  and of the end-to-end acceptance (@scenario_hash:195ff0c3d6a61bfe). Owner:
  shopsystem-bc-launcher (standup provisioning ordering).

  @scenario_hash:5351a4a8071b594f
  Scenario: standing up a new BC whose sync.remote is configured to an empty tracker remote unconfigures sync.remote before bd init so the prefixed local dolt DB create-freshes, then restores sync.remote and seeds, so bd create yields a prefixed id
    Given a scaffolded BC whose ".beads/config.yaml" has "sync.remote" CONFIGURED to the derived "<owner>/<bc>-beads" remote that exists but is EMPTY of Dolt data, and whose committed ".beads/metadata.json" names a definite issue_prefix in its "dolt_database" field
    When the standup's beads provisioning orchestration runs
    Then the standup FIRST unconfigures "sync.remote" by removing the "sync.remote" line from ".beads/config.yaml", so that "bd init -p <prefix>" adopting the committed metadata.json issue_prefix create-freshes a PREFIXED local dolt database rather than attempting to CLONE the configured empty remote and hard-failing
    And the standup THEN restores the "sync.remote" line, runs "bd dolt remote add origin" against the git+https url, and "bd dolt push" so the tracker remote carries Dolt data with "refs/dolt/*" refs present
    And after standup "bd create" run in the new BC's workspace exits zero and yields an id of the form "<prefix>-<n>" carrying the committed issue_prefix rather than failing "issue_prefix config is missing"
    And as the negative control, had "bd init -p" instead been run WHILE "sync.remote" was still configured to the empty remote, it would attempt a dolt clone and hard-fail "contains no Dolt data" — the exact pre-fix real-launch failure this unconfigure-before-init ordering exists to avoid
