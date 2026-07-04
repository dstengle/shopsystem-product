@bc_internal
Feature: lead-architect 'Responding to a BC clarify' subsection names shop-msg read inbox per step

  # @scenario_hash:e6bdf2f33bfae0d1 RETIRED (lead-eqn)
  # Asserted lead-architect "Responding to a BC clarify" subsection names "shop-msg read outbox" per step.
  # Superseded by lead-eqn: Brief 006 replaced read outbox with read inbox --lead;
  # lead-architect CLI mechanics now uses "shop-msg read inbox --lead <name>" to read BC responses.

  @scenario_hash:7b76a7be624235ef @bc:shopsystem-templates
  Scenario: lead-architect template's "Responding to a BC clarify" subsection names "shop-msg read inbox" on every step whose action is reading the BC's clarify, never relying on a surrounding clause
  When I read the lead-architect template via "shop-templates show lead-architect"
  And I locate the subsection that begins with the heading "### Responding to a BC clarify via shop-msg respond" and ends at the next heading of depth two (##) or depth three (###), whichever comes first
  Then within that subsection, every numbered step whose action is reading the inbox message names the literal substring "shop-msg read inbox" on the same step
  And within that subsection, no numbered step describes reading the inbox message using a bare action verb — "open", "cat", "ls", "grep", "inspect", "view", "edit", "tail", "head", or a bare "Read" — without naming the literal substring "shop-msg read inbox" on the same step
  And within that subsection, no numbered step refers to the inbox message by a path-shaped reference such as "inbox/", "<BC root>/inbox/", or "the inbox file" without naming the literal substring "shop-msg read inbox" on the same step
