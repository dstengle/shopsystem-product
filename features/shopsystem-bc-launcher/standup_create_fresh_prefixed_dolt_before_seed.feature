@bc:shopsystem-bc-launcher @origin:lead-vb6j
Feature: create-bc standup establishes a prefixed local dolt DB create-fresh from committed metadata.json BEFORE seeding the tracker (GAP G, lead-vb6j)

  Traced in-container under bc-launcher v0.3.55 with GAP A/B/D/E all fixed
  (David, 2026-07-08): standing up a NEW BC still leaves it offline. ROOT: with
  the beads "sync.remote" configured to the derived "<owner>/<bc>-beads"
  (GAP B, lead-r34c), the in-container "bd bootstrap" does a dolt CLONE of the
  empty tracker remote and HARD-FAILS ("contains no Dolt data") — it does NOT
  create-fresh from the committed ".beads/metadata.json" (which already carries
  the prefix). The templates reviewer showed "bd bootstrap" DOES "Created fresh
  database with prefix" when NO remote is configured (lead-pqlx). Consequence
  chain: at seed time there is no PREFIXED local dolt DB, so the seed's
  "bd dolt push" seeds nothing / a prefix-less DB; the retried "bd bootstrap"
  still finds no dolt data; and the local bd is left with no issue_prefix, so
  "bd create" fails "issue_prefix config is missing" -> the session-start
  work-tracker health gate is red -> the BC never comes online.

  This pins the standup's create-fresh-THEN-seed provisioning ORDERING as the
  fix, versus the current clone-then-hard-fail: on an empty configured remote
  the standup must first ESTABLISH a prefixed local dolt DB from the committed
  ".beads/metadata.json" (adopting the committed issue_prefix, NOT one derived
  from the BC name) BEFORE the seed's "bd dolt push", so the tracker ends up
  carrying Dolt data and the retried "bd bootstrap" exits zero leaving a local
  bd whose "bd create" yields a prefixed id. This is the ROOT fix that makes the
  existing end-to-end acceptance
  (end_to_end_healthy_tracker_after_standup @scenario_hash:195ff0c3d6a61bfe)
  pass — that scenario's Given ("a committed issue_prefix" that makes
  "bd create" yield a prefixed id) is exactly the postcondition GAP G currently
  blocks. Fidelity binds to the standup's executable provisioning orchestration
  — the bootstrap/seed ordering and the metadata.json-derived prefix — read
  against the create-bc standup definition, NOT a live container run. Owner:
  shopsystem-bc-launcher (standup ordering).

  @scenario_hash:e3a0ec19298e7ce7
  Scenario: standing up a new BC with an empty tracker remote establishes a prefixed local dolt DB from the committed metadata.json before seeding, so the retried bootstrap exits zero and bd create yields a prefixed id
    Given a new BC is stood up via "create-bc" whose beads tracker remote at "<owner>/<bc>-beads" exists but is empty of Dolt data, and whose committed ".beads/metadata.json" names a definite issue_prefix
    When the standup's beads provisioning orchestration runs its bootstrap-and-seed ordering
    Then the standup first establishes a PREFIXED local dolt database create-fresh from the committed ".beads/metadata.json", adopting that committed issue_prefix rather than one derived from the BC name, BEFORE it seeds the remote
    And the standup then seeds that prefixed local database to the tracker remote with "bd dolt push", so the tracker remote carries Dolt data with "refs/dolt/*" refs present
    And the retried "bd bootstrap" exits zero rather than hard-failing the empty-remote clone with "contains no Dolt data"
    And after standup "bd create" run in the new BC's workspace exits zero and yields an id of the form "<prefix>-<n>" carrying the committed issue_prefix rather than failing "issue_prefix config is missing"
