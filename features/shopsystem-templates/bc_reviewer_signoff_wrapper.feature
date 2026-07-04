@bc_internal
Feature: bc-reviewer sign-off work_done emit is directed through the bc-emit work-done wrapper

  @scenario_hash:35d3af0c79b55fbf @bc:shopsystem-templates
  Scenario: the rendered bc-reviewer template directs the sign-off work_done emit through the "bc-emit work-done" wrapper and names bare "shop-msg respond work_done --force" only as the forced-recovery escape valve
    When I read the bc-reviewer template via "shop-templates show bc-reviewer"
    Then the sign-off "work_done complete" outcome names "bc-emit work-done" as the concrete command the reviewer runs to emit the sign-off
    And that sign-off outcome does NOT instruct a bare "shop-msg respond work_done" invocation as the command the reviewer runs to emit the sign-off
    And the bare "shop-msg respond work_done --force" path is named only as the forced-recovery escape valve, never as the routine sign-off emit
