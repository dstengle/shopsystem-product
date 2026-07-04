@bc:shopsystem-templates @origin:lead-mzvp
Feature: Lead primer pins the product-authority discovery gate standing rule

  The canonical lead primer (shop-templates package data, shop type "lead",
  served through read_claude_md_primer("lead")) already ships the
  idle-detection and choice-suppression standing rules. What was UNPINNED is
  the product-authority discovery gate: before the router dispatches a
  DISCOVERY subagent (problem discovery/selection, or a skill carrying an
  interactive/workshop loop such as jobs-to-be-done, problem-framing-canvas,
  opportunity-solution-tree, customer-journey-map), it must first conduct the
  product-authority discovery dialogue at the main-agent level (because the
  subagent is non-interactive and cannot conduct it) OR record a citation to
  an existing brief/PDR that already pins scope + product vocabulary. This
  scenario pins that standing rule against the rendered lead primer body
  through the package's public template-access surface, alongside the
  existing standing rules which it must not alter.

  @scenario_hash:21c07707c418c6ed
  Scenario: the canonical lead primer carries the product-authority discovery gate standing rule alongside the existing standing rules
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "lead" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "lead"
    Then a non-empty template body is returned
    And the returned body carries a standing rule named for the product-authority discovery gate
    And that standing rule names the dispatch of a discovery subagent as the trigger and states the gate fires on the dispatch boundary because the subagent is non-interactive and cannot conduct the dialogue
    And that standing rule requires the router to either conduct the product-authority discovery dialogue at the main-agent level capturing the answers as interview-notes on the bead or brief the subagent receives, or cite an existing brief or PDR that already pins scope and product vocabulary as the recorded reason the dialogue is not required, before the discovery subagent may be dispatched
    And that standing rule distinguishes itself from the choice-suppression rule as the mandatory genuine product-judgment round-trip rather than an operational question
    And that standing rule adds a named discovery-dispatch item to the router's pre-dispatch path requiring the dialogue conducted or a cited reason recorded before dispatch
    And the returned body still carries the idle-detection and choice-suppression standing rules unaltered
