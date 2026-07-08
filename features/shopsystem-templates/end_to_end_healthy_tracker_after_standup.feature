@bc:shopsystem-templates @origin:lead-pqlx
Feature: create-bc END-TO-END acceptance — a newly stood-up BC's session-start health gate reports healthy and the BC reaches online

  The real bar for the deterministic create-bc beads provisioning is not that
  fabro launches, but that a WORKING BC results: after create-bc standup, the new
  BC's session-start work-tracker HEALTH GATE — the SKILL step that GATES the role
  loop, IDENTICAL in tmux (shop_templates/templates/claude/bc.md) and fabro
  (bc_launcher/assets/fabro-def/nodes/bc-router.md 'health' node, lines 58-85) —
  must report HEALTHY on the FIRST pass and take the "-> arm [label=healthy]" edge,
  NOT the unprovisioned-heal branch and NOT the "block (unhealable)" / "block
  (remote-unwritable)" halt. Per that node the tracker is healthy only when the
  probe spine "bd create <probe> --prefix <issue_prefix> ; bd ready ; bd dolt push
  (TEST)" all exit zero (local writability AND remote writability).

  This is the cross-gap integration acceptance over GAP A (lead-3mez — the
  tracker repo exists because the provisioning exec carried a GH_TOKEN), GAP B
  (lead-r34c — the functional bd dolt remote resolved to the derived
  "<owner>/<bc>-beads", so the test dolt push has a reachable target), and GAP C
  (lead-pqlx — a committed issue_prefix, so bd create yields a prefixed id and the
  gate is not unhealable). Empirically (shopsystem-knowledge under fabro,
  2026-07-07) all three failed and the tmux claude agent had been silently
  papering over them; this scenario pins the healthy-on-first-pass state as the
  acceptance bar. Fidelity binds to the health-gate node body (the probe-spine and
  its healthy/heal/block decision edges) evaluated against the executable
  provisioning that produces the preconditions, NOT a live container run.

  @scenario_hash:195ff0c3d6a61bfe
  Scenario: after create-bc standup the new BC's session-start work-tracker health gate reports healthy on the first pass and the BC begins its role loop
    Given a BC stood up end-to-end via "create-bc" with its beads tracker repo created, its functional bd dolt remote resolved to the derived "<owner>/<bc>-beads", and a committed issue_prefix
    When the new BC's session-start work-tracker health gate runs its probe spine of "bd create" with the configured prefix, then "bd ready", then a test "bd dolt push"
    Then "bd create" exits zero and yields an id carrying the configured issue_prefix
    And "bd ready" exits zero
    And the test "bd dolt push" to the configured Dolt remote exits zero
    And the health gate reports the tracker healthy on the first pass, taking neither the unprovisioned-heal branch nor the unhealable-block branch
    And the BC proceeds past the gate to begin its role loop and reach online
