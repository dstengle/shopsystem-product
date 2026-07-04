@bc_internal
Feature: lead-po template — identity-precedes-procedure structural integrity

  @scenario_hash:662c5822dbc6a896 @bc:shopsystem-templates
  Scenario: the empowered-PM expansion preserves identity-precedes-procedure in the lead-po template
    When I read the lead-po template via "shop-templates show lead-po"
    Then a "# Lead PO — role prompt" identity header appears in the output
    And a "## Your default posture: COMMIT TO SPECIFICS" posture header appears in the output
    And the byte offset of the identity header is less than the byte offset of the first occurrence of the string "shop-msg"
    And the byte offset of the posture header is less than the byte offset of the first occurrence of the string "shop-msg"
    And every heading whose text mentions a PM discipline appears at heading depth three (###) or deeper, never at depth one (#)
    And the first occurrence of the substring "shop-msg" in the content appears after every PM discipline name has appeared at least once
