@bc:shopsystem-templates @origin:lead-mzvp
Feature: Lead primer pins the PM-mode-entry classification standing rule

  PDR-033 (P02) retires the router-level product-authority discovery gate in
  favor of PM-mode entry: interactivity is a position in the execution
  topology, and only the main session holds it. The router no longer conducts
  discovery itself nor gates a discovery subagent — it CLASSIFIES input and,
  when the input is directional, exploratory, ambiguous, or multi-option,
  ENTERS the lead-pm main-session mode. The router holds no product judgment.
  This scenario pins that reframed standing rule against the rendered lead
  primer body through the package's public template-access surface, alongside
  the existing standing rules which it must not alter.

  @scenario_hash:e813a6f3a3b575ea
  Scenario: the canonical lead primer carries the PM-mode-entry classification standing rule in place of the retired discovery gate
    Given the "shop-templates" package ships a canonical "CLAUDE.md" primer template for shop type "lead" through its public template-access surface
    When I ask the package for that canonical primer body for shop type "lead"
    Then a non-empty template body is returned
    And the returned body carries a standing rule that classifies input which is directional, exploratory, ambiguous, or multi-option as PM-mode entry — the router enters the lead-pm main-session mode rather than dispatching a discovery subagent
    And that standing rule directs input that is a committed contract task to the lead-po and technical or dispatch work to the existing routes
    And that standing rule states that when the router is unsure between PM and PO it prefers PM, because a mis-route to PM costs one session while a mis-route to PO produces an unanchored brief
    And that standing rule requires the router, on PM-mode entry, to ensure a session record is opened and, on exit, to verify it is closed with a non-empty produced or revised list before releasing the turn flow
    And that standing rule states the router holds no product judgment — option framing, brainstorm facilitation, and intent probing live in the lead-pm mode, not at the router
    And the returned body no longer carries the retired router-level product-authority discovery gate that required the router to conduct the discovery dialogue itself or cite a brief before dispatching a discovery subagent
    And the returned body still carries the idle-detection and choice-suppression standing rules unaltered
