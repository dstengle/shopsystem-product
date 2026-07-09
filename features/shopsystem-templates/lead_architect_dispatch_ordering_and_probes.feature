@bc_internal
Feature: lead-architect template — PDR-033 dispatch ordering and PM feasibility probes

  # PDR-033 (P02) role-deltas add two lead-architect responsibilities alongside
  # the existing empirical pre-state and @scenario_hash enumeration pins
  # (7c174f4e / 5f7fbf04 and the ADR-018 surface): the Architect answers
  # dispatch ordering to the latest ratified prioritization record, and may be
  # asked by the lead-pm mode for a bounded pre-shape feasibility probe whose
  # output is a finding linked to the requesting candidate. These pins are
  # additive and do not alter existing architect scenarios.

  @scenario_hash:aae38de4789bdbcd @bc:shopsystem-templates
  Scenario: lead-architect template answers dispatch ordering to the latest ratified prioritization record, recording deviations with a reason
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content directs the architect to order dispatches according to the latest "ratified" prioritization record produced by the lead-pm mode
    And the content directs the architect that any deviation from that ratified order is recorded in the dispatch bead with a reason
    And the content states the ratified prioritization record is what dispatch order answers to until it is superseded

  @scenario_hash:079dcd64367f5b61 @bc:shopsystem-templates
  Scenario: lead-architect template accepts a bounded pre-shape feasibility probe from the lead-pm mode whose output is a finding linked to the candidate
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content states the lead-pm mode may request a bounded pre-shape feasibility probe from the architect
    And the content states the probe output is a finding produced through the existing pre-state verification machinery, not BC-code execution
    And the content directs the architect to link that finding back to the requesting candidate's Evidence section
    And the content states the probe is time-boxed by the candidate's appetite framing and is not a spike-sized implementation
