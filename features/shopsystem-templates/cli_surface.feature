# RETIRED-scenario provenance & narrative:
#   @scenario_hash:fd6c7f023ca4f7f0 RETIRED (lead-63lp, superseded by the 5-name
#   list below on resolution of the lead-kz33 shopsystem-templates clarify).
#   Asserted "shop-templates list" outputs exactly four role-template names
#   (bc-implementer, bc-reviewer, lead-architect, lead-po). Under PDR-033 the
#   templates BC gains the lead-pm template (main-session mode; showable, so it
#   counts in `list`), making the list a 5-name set. lead-pm sorts BEFORE lead-po
#   (LC_ALL=C: "lead-pm" < "lead-po"). New pin computed by `scenarios hash` over
#   the block-only body = 82c9306989c49724; carried @scenario_hash:pending here
#   until reconciliation confirms it against the BC's landed register.
@bc_internal
Feature: shopsystem-templates — CLI surface and role-discipline structure

  @scenario_hash:pending @bc:shopsystem-templates
  Scenario: shop-templates list outputs the five expected role-template names, one per line, sorted
    When I run "shop-templates list"
    Then the exit code is 0
    And stdout is exactly the five names "bc-implementer", "bc-reviewer", "lead-architect", "lead-pm", "lead-po", one per line in that sorted order
    And stderr is empty

  @scenario_hash:799a07345977a399 @bc:shopsystem-templates
  Scenario: shop-templates show writes the named template's content to stdout with no extra leading or trailing data
    Given a template name "bc-implementer" that is in the list output by "shop-templates list"
    When I run "shop-templates show bc-implementer"
    Then the exit code is 0
    And stdout equals the package-data file contents for that template, byte-for-byte (no extra trailing newline beyond what the file itself carries)
    And stderr is empty

  @scenario_hash:df49974a68a1616c @bc:shopsystem-templates
  Scenario: shop-templates show with an unknown template name exits non-zero and names both the bad input and the available list on stderr
    Given a template name "no-such-template" that is not in the list output by "shop-templates list"
    When I run "shop-templates show no-such-template"
    Then the exit code is non-zero
    And stdout is empty
    And stderr names the offending input "no-such-template"
    And stderr cites the list of available templates so the caller can recover
