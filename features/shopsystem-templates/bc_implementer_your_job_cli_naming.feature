@bc_internal
Feature: bc-implementer 'Your job' subsection names shop-msg read inbox per step

  @scenario_hash:1ecaec86e267de47 @bc:shopsystem-templates
  Scenario: bc-implementer template's "Your job" subsection names "shop-msg read inbox" on every step whose action is reading the inbox message, never relying on a surrounding clause
  When I read the bc-implementer template via "shop-templates show bc-implementer"
  And I locate the subsection that begins with the heading "## Your job" and ends at the next heading of depth two (##) or depth three (###), whichever comes first
  Then within that subsection, every numbered step whose action is reading the inbox message names the literal substring "shop-msg read inbox" on the same step
  And within that subsection, no numbered step describes reading the inbox message using a bare action verb — "open", "cat", "ls", "grep", "inspect", "view", "edit", "tail", "head", or a bare "Read" — without naming the literal substring "shop-msg read inbox" on the same step
  And within that subsection, no numbered step refers to the inbox message by a path-shaped reference such as "inbox/", "<BC root>/inbox/", or "the inbox file" without naming the literal substring "shop-msg read inbox" on the same step
