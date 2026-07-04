@bc_internal
Feature: lead-po template — PM skill catalogue experimental adoption framing

  @scenario_hash:32537a54388dd716 @bc:shopsystem-templates
  Scenario: lead-po template frames the PM skill catalogue as experimentally adopted and re-mapped onto the four disciplines
    When I read the lead-po template via "shop-templates show lead-po"
    Then the content states that the external PM skills are adapted to the shopsystem process rather than imported wholesale
    And the content presents the candidate PM skills mapped onto the four durable disciplines rather than onto the retired "four research flavors"
    And the content states that the PM artifacts collapse onto the §3.3 artifacts the PO already owns — interview notes, brief, PDR, and scenarios — rather than introducing new lead-shop artifact types
    And the content states that a PM skill's human-checkpoint maps onto the COMMIT TO SPECIFICS posture — the PO commits the specific or records explicitly that it cannot commit yet, rather than stalling on a stakeholder round-trip the shopsystem loop does not already have
