@bc:shopsystem-bc-launcher @origin:lead-7jc2
Feature: BC standup provisions the new BC's absent beads tracker repo so bd bootstrap succeeds (lead-7jc2)

  Standing up shopsystem-knowledge via create-bc (David 2026-07-07): even with the
  sync.remote owner correct, nothing creates the "<owner>/<bc>-beads" GitHub
  tracker repo the config points at, so `bd bootstrap` fails "Repository not found";
  and a freshly created empty repo is not cloneable until its bd dolt remote is added
  and seeded with an initial push. This is the BC's OWN beads tracker
  ("<bc>-beads", e.g. "shopsystem-knowledge-beads"), distinct from the lead's
  own "<product>-lead-beads". Extends the empty-remote seed
  pin @scenario_hash:ada742d33c996d34 (which assumes the remote already exists) to the
  absent-repo case. Fidelity: gh/docker may be unavailable in-test, so the pin binds to
  the recorded standup behavior, not a live GitHub call.

  Origin/driver: ADR-043 D5 (single canonical beads-naming rule). Per D5 the per-BC
  tracker is "<product>-<bc>-beads"; the BC shop slug "<bc>" already carries the product
  scope (ADR-038 forced-product-scope,
  footing_naming_forced_product_scope @scenario_hash:db2131f49c170bc8), so the
  canonical repo name is "<bc>-beads" — NOT
  "<bc>-lead-beads" ("-lead-beads" is the LEAD's own "<product>-lead-beads"). Only the
  name form changes here; the no-main-branch fix (initial branch/commit + seed-so-not-
  empty) stands.

  @scenario_hash:90caf5523e7d5ce0
  Scenario: standing up a new BC creates its absent beads tracker repo and seeds the dolt remote so bd bootstrap succeeds
    Given a new BC whose shop-name slug is "<bc>" is being stood up under GitHub owner "<owner>"
    And its scaffolded ".beads/config.yaml" "sync.remote" points at "<owner>/<bc>-beads", distinct from the lead's own "<product>-lead-beads"
    And the "<owner>/<bc>-beads" tracker repository does not yet exist
    When the BC-standup flow provisions the new BC's beads tracker and runs "bd bootstrap"
    Then the standup flow creates the absent "<owner>/<bc>-beads" tracker repository with an initial branch and commit
    And the standup flow adds the "<owner>/<bc>-beads" bd dolt remote and seeds it with an initial push so it is not an empty repository with no branches
    And the subsequent "bd bootstrap" for the new BC exits zero instead of failing with "Repository not found" or "git remote has no branches"
    And "bd create" run in the stood-up BC's workspace exits zero and yields a new issue id so its beads tracker is usable for bd-backed gated work
