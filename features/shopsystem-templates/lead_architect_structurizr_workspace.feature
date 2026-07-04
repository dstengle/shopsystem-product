@bc_internal
Feature: lead-architect template develops the Maintain structurizr workspace activity with sufficiency criteria

  @scenario_hash:9fac437e075784fe @bc:shopsystem-templates
  Scenario: lead-architect template develops the Maintain structurizr workspace activity with sufficiency criteria
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content names the activity "Maintain structurizr workspace"
    And the Maintain structurizr workspace block names all three view families — containers, components, and dynamic views — as in scope of the activity, not only the static container view
    And the Maintain structurizr workspace block states the assign-per-structurizr coupling: a BC named in an assign_scenarios dispatch must correspond to a container or component the workspace models, and assigning to a BC the workspace does not model is a structural gap
    And the Maintain structurizr workspace block states the ADR↔workspace traceability gate: every workspace edge traces to an ADR and every structural ADR shows up in the workspace
    And each of these is stated as a sufficiency criterion on the activity OR carries an explicit "guidance pending" marker (case-insensitive), not as bare advisory prose with no criterion
