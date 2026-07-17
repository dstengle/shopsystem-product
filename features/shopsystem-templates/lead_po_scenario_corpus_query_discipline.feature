@bc_internal
Feature: lead-po template directs scenario-corpus retrieval through the installed scenarios CLI's own query commands, not ad-hoc grep

  @scenario_hash:6161fd393e4662c6 @bc:shopsystem-templates
  Scenario: lead-po template directs the PO to check scenario existence and ownership via the installed scenarios CLI before authoring or sharpening a scenario, not via ad-hoc grep
    When I read the lead-po template via "shop-templates show lead-po"
    Then the content directs the PO that, before authoring or sharpening a scenario, it establishes whether an equivalent or conflicting scenario already exists in the "features/" corpus by invoking the installed "scenarios" CLI's own corpus-wide commands (such as "scenarios journal rebuild" over the full "features/" tree, or "scenarios validate --aggregate"), not by a hand-scoped "Grep" invocation against a single assumed file or directory
    And the content names a hand-scoped single-file "Grep" search as insufficient to establish what exists corpus-wide
    And the content permits plain "Grep" or "Read" for reading the full text of a specific, already-identified scenario, distinguishing that use from corpus-wide discovery
    And the content directs the PO to treat a hand-scoped grep that misses a sibling scenario file as a defect in the retrieval method, not an acceptable outcome
