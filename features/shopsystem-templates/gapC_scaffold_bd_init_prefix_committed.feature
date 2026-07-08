@bc:shopsystem-templates @origin:lead-pqlx
Feature: BC scaffold runs bd init with a prefix and commits a registry naming issue_prefix so a new BC's tracker is healable (GAP C, lead-pqlx)

  Standing up shopsystem-knowledge via create-bc under fabro (David 2026-07-07):
  "bd create" failed "database not initialized: issue_prefix config is missing".
  ROOT: the shop-templates bootstrap's "bd init" does NOT pass "--prefix", so the
  scaffolded/committed ".beads/issues.jsonl" carries no issue_prefix ("Exported 0
  issues"). The session-start work-tracker HEALTH GATE — IDENTICAL in tmux
  (shop_templates/templates/claude/bc.md) and fabro
  (bc_launcher/assets/fabro-def/nodes/bc-router.md 'health' node, lines 58-85) —
  heals ONLY by ADOPTING a committed issue_prefix "taken from the committed
  registry, NOT derived from the BC name"; with none committed it hits
  "block (unhealable): empty working set + no issue_prefix + committed registry
  names no prefix to adopt" and halts, so the BC never begins its role loop and
  stays offline. A truly-NEW BC is unhealable under BOTH engages; existing tmux
  BCs work only because their prefixed registries already exist.

  This pins the SCAFFOLD-COMMITTED prefix as the input the health gate's adopt
  branch requires — distinct from bootstrap_beads_remote_and_prefix
  scenario_hash 0636fba2c1445f9f (which checks the LIVE "bd config get
  issue-prefix" for shop-type lead, not the committed registry a fresh BC ships)
  and from bootstrap_bd_init_side_effects @scenario_hash:31a044e7d2eceaf4 (which
  pins "--skip-agents", not "--prefix"). Fidelity binds to the executable scaffold
  provisioning ("bd init --prefix") and the committed ".beads" registry content,
  read against the health-gate node body's adopt/unhealable decision table, NOT a
  live container run. Owner: shopsystem-templates.

  @scenario_hash:bf4caf0a470dcaa3
  Scenario: the BC scaffold runs bd init with a prefix and commits a registry naming that issue_prefix so a newly stood-up BC's tracker is not unhealable
    Given a new BC whose shop-name slug is "<bc>" is scaffolded and provisioned via "shop-templates" bootstrap with shop type "bc"
    When the scaffold initializes the beads tracker and commits the ".beads" registry
    Then the scaffold "bd init" invocation passes a "--prefix <prefix>" argument that sets a definite issue_prefix
    And the committed ".beads" registry names that definite issue_prefix rather than carrying no issue_prefix
    And "bd create" run in the stood-up BC's workspace exits zero and yields an id carrying that prefix instead of failing "issue_prefix config is missing"
    And the session-start work-tracker health gate can adopt the committed issue_prefix so it does not classify the tracker "unhealable"
