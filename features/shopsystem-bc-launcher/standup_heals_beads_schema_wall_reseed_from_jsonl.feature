@bc:shopsystem-bc-launcher @origin:lead-4qqi
Feature: BC standup self-heals the bd remote-backed schema wall by reseeding a fresh current-schema dolt DB from the committed issues.jsonl, then durably reseeds the remote through the brokered credential path (lead-4qqi)

  A BC standup clones its remote-backed beads DB whose Dolt data sits at an
  OLD schema (e.g. v32) while bc-base bakes a bd whose target schema is AHEAD
  (e.g. v53). bd REFUSES to auto-apply schema migrations to a remote-backed DB
  (fork hazard, bd upstream #4259: migrating independently on >1 clone forks the
  schema so `bd dolt pull` can no longer merge), so `bd bootstrap` fails and the
  BC never reaches `online`. This hits EVERY BC (spec §6: one shop = one beads
  instance). migrate-in-place is NOT a viable fallback (lead-065a): under
  BD_ALLOW_REMOTE_MIGRATE=1 `bd migrate` HARD-FAILS on knowledge-beads at
  migration 0047_recompute_mixed_is_blocked ("Error 1146: table not found:
  wisps") even though the SAME bd 1.1.0 migrated the lead cleanly — nominally-
  "v32" BC DBs carry divergent actual schemas, so the migration chain's table
  prerequisites are not met fleet-wide.

  THIS PRECONDITION IS DISTINCT from the empty-remote provisioning family
  (bc_container_beads_bootstrap_resilience @scenario_hash:ada742d33c996d34,
  lead-5k8c; GAP D/E/G/H/I). Those fire when the tracker remote carries NO Dolt
  data. Here the remote DOES carry Dolt data — just at a skewed old schema — so
  the empty-remote seed path never fires; the clone succeeds and bd bootstrap
  fails on the #4259 migration refusal instead. This family is ADDITIVE to the
  bootstrap-resilience register, not a replacement.

  The PROVEN working mechanism (lead-yy1q, validated end-to-end: knowledge
  relaunched broken v32 under both tmux and fabro, one-shot heal -> online, bd
  ready OK, 46 issues, schema v53; reference implementation
  bin/heal-bc-beads-schema in the lead repo) is a REBUILD, not a migrate: rebuild
  a fresh local dolt DB at the baked bd's CURRENT schema from the schema-
  independent committed ".beads/issues.jsonl" via `bd init --from-jsonl`. This is
  SAFE for a BC because the container is the sole clone of its beads remote and
  the committed JSONL is the source of truth; it is UNSAFE for the lead (not
  sole-clone), so the reseed is refused for a lead-role beads.

  The durable REMOTE reseed (force-push the rebuilt DB back to the BC's beads
  remote so future launches bootstrap-adopt the current schema with no re-heal)
  runs through the agent-vault broker's MITM-CA / non-interactive dolt-push
  credential path — the SAME create-bc seed credential gap pinned for the seed
  push at lead-tc38 (GAP H, @scenario_hash:5351a4a8071b594f) and lead-vb6j
  (GAP G, @scenario_hash:e3a0ec19298e7ce7). Until that push lands the remote
  stays behind and every relaunch re-breaks and re-heals; the negative row below
  pins today's SSL/cred failure turning positive once the brokered path is wired.

  Fidelity binds to the standup's executable beads-provisioning orchestration —
  the schema-skew detection, the from-JSONL rebuild ordering, the export-before-
  destructive safety net, the lead-role refusal, and the brokered reseed-push —
  read against the create-bc / bc-container standup definition and the reference
  heal in bin/heal-bc-beads-schema, NOT a live container or GitHub run.

  @scenario_hash:dc9a29a746921a14
  Scenario: standup reseeds a fresh current-schema dolt DB from the committed issues.jsonl when the remote-backed DB is behind the baked bd's target schema, so the BC onlines with full issue parity
    Given a BC standup clones a remote-backed beads DB whose Dolt data sits at an OLD schema behind the baked bd's CURRENT target schema
    And the baked bd REFUSES to auto-apply schema migrations to that remote-backed DB per fork-hazard bd upstream #4259, so "bd bootstrap" fails and the BC does not reach online
    And the committed ".beads/issues.jsonl" carries a definite issue prefix and a known count of issues
    When the standup's beads-provisioning orchestration runs its schema-skew heal
    Then the heal REBUILDS a fresh local dolt database at the baked bd's CURRENT schema from the committed ".beads/issues.jsonl" via "bd init --from-jsonl", rather than attempting an in-place "bd migrate" that #4259 refuses and lead-065a proved hard-fails at migration 0047
    And after the rebuild "bd ready" exits zero so the BC reaches online WITHOUT manual intervention
    And the rebuilt database's issue count equals the count committed in ".beads/issues.jsonl" so every committed issue is preserved
    And the rebuilt database's schema version equals the baked bd's current target schema version rather than the old remote-backed version

  @scenario_hash:47b74cae983effba
  Scenario: the schema-skew heal is a no-op when bd is already healthy at the current schema, so re-running the standup makes no destructive change
    Given a BC whose local beads database already reports "bd ready" exit zero at the baked bd's CURRENT target schema, with no #4259 migration-refusal signal present
    When the standup's beads-provisioning schema-skew heal step runs again
    Then the heal detects that bd is already healthy and performs NO rebuild and NO reseed force-push
    And the heal makes no destructive change to the existing local dolt database and leaves its issue count and schema version unchanged
    And the heal step exits zero as an idempotent no-op

  @scenario_hash:df748234563bdedb
  Scenario Outline: after the local rebuild the standup force-pushes the rebuilt DB to the BC's beads remote through the agent-vault brokered non-interactive dolt-push path, so a subsequent launch bootstrap-adopts the current schema with no re-heal
    Given the standup has locally rebuilt a fresh current-schema dolt database from the committed ".beads/issues.jsonl" and the BC is already online locally
    And the reseed force-push to the BC's beads remote is a history-replacing push that runs "bd dolt push" through the agent-vault broker's MITM-CA / non-interactive dolt-push credential path
    And the brokered dolt-push credential path is "<broker_cred_state>", the same create-bc seed credential gap pinned at lead-tc38 (@scenario_hash:5351a4a8071b594f) and lead-vb6j (@scenario_hash:e3a0ec19298e7ce7) applied to the reseed push
    When the standup runs its remote reseed force-push after the local rebuild
    Then the reseed force-push result is "<push_result>"
    And the BC's beads remote now serves schema "<remote_schema_after>"
    And a SUBSEQUENT launch's "bd bootstrap" adopts the remote schema with re-heal-required "<subsequent_reheal>", so the reseed is durable only once the brokered path is wired

    Examples:
      | broker_cred_state                         | push_result                          | remote_schema_after | subsequent_reheal |
      | wired via agent-vault MITM-CA broker      | push complete                        | current             | no                |
      | unwired, raw dolt push hits the MITM SSL/cred gap | fails on SSL/non-interactive-credential | behind              | yes               |

  @scenario_hash:fbf7480ef25f766c
  Scenario: the schema-skew heal takes a full pre-heal export before any destructive step and rebuilds from the committed issues.jsonl as the source of truth
    Given the standup's schema-skew heal has detected the remote-backed DB is behind the baked bd's target and is about to rebuild the local database
    When the heal runs its rebuild ordering
    Then the heal FIRST takes a full "bd export --all" capture to a backup path BEFORE any destructive step such as moving aside or removing the broken embedded-Dolt working set
    And the rebuild's authoritative data SOURCE OF TRUTH is the committed ".beads/issues.jsonl", not the pre-heal export, which is retained only as a forensic safety net
    And if the pre-heal export fails because the old database is unreadable, the heal still proceeds from the committed ".beads/issues.jsonl" rather than aborting

  @scenario_hash:5765dd7d175901e3
  Scenario Outline: the reseed heal refuses a lead-role beads because the sole-clone invariant holds only for BCs, and proceeds for a BC
    Given a beads database exhibiting the #4259 remote-backed schema-skew refusal whose shop type is "<shop_type>"
    And the reseed heal's force-push is history-replacing and safe only when the container is the SOLE clone of its beads remote, which holds for a BC but NOT for the lead
    When the reseed heal is invoked against that beads database with no lead-override in effect
    Then the heal's action is "<heal_action>" because a history-replacing reseed force-push would discard Dolt history that is not reconstructable from a sole clone when the beads is not sole-clone
    And the heal exit is "<heal_exit>"

    Examples:
      | shop_type | heal_action                                              | heal_exit |
      | bc        | proceeds with the from-JSONL rebuild and reseed          | zero      |
      | lead      | refuses the rebuild and reseed, directing manual migrate | nonzero   |
