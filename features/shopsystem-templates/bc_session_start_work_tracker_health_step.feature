@bc_internal
Feature: BC session-start work-tracker health step

  The BC session-start contract (rendered into a product BC shop from the
  canonical bc primer and the bc-router skill body) carries a work-tracker
  health step that runs BEFORE the role loop begins and gates it. The step
  validates the bd tracker (local writability via bd create / bd ready plus a
  test dolt push to the configured remote), heals an unprovisioned-but-
  recoverable tracker by adopting the committed registry's issue_prefix and
  importing its committed issues, and otherwise surfaces an explicit
  work-tracker health failure at session-start — never deferring detection to
  work_done emission time. These scenarios pin that contract against the
  rendered session-start surface (the bc primer body and the bc-router skill
  body) through the package's public template-access surface.

  @scenario_hash:76f65d95be6beece @bc:shopsystem-templates
  Scenario: a BC session starts with a locally-writable tracker whose test dolt push succeeds and the health step reports healthy and proceeds
  Given a BC shop whose bd tracker has a definite issue_prefix configured
  And the tracker's working set is populated from the committed registry
  And the tracker has a configured Dolt remote
  When the BC agent session starts and runs the work-tracker health step
  And bd create run in the BC shop exits zero and yields a new issue id carrying the configured prefix
  And bd ready run in the BC shop exits zero
  And a test dolt push to the configured Dolt remote exits zero
  Then the health step reports the tracker as healthy
  And the BC proceeds to begin its role loop without a startup health failure

  @scenario_hash:450923d3ba50f11d @bc:shopsystem-templates
  Scenario: a BC session starts with an unprovisioned-but-recoverable tracker and the health step heals it, re-validates with a successful test dolt push, then proceeds
  Given a BC shop whose bd tracker working set is empty and has no issue_prefix configured
  And the committed registry names a definite issue_prefix and carries at least one issue
  And the tracker has a configured Dolt remote
  When the BC agent session starts and runs the work-tracker health step
  Then the health step adopts the committed issue_prefix as the tracker's configured prefix
  And the committed registry's issues are imported into the tracker's working set
  And after the heal bd create run in the BC shop exits zero and yields a new issue id carrying the adopted prefix
  And after the heal a test dolt push to the configured Dolt remote exits zero
  And the health step re-validates the tracker as healthy
  And the BC proceeds to begin its role loop without a startup health failure

  @scenario_hash:da331d90ce81f1d4 @bc:shopsystem-templates
  Scenario: a BC session starts with an unhealable tracker and the health step surfaces a startup failure and blocks all role-work from starting
  Given a BC shop whose bd tracker working set is empty and has no issue_prefix configured
  And the committed registry names no issue_prefix to adopt, so the tracker cannot be healed
  When the BC agent session starts and runs the work-tracker health step
  Then the health step reports an explicit work-tracker health failure that names the unhealable condition
  And the BC does not begin its role loop
  And the BC emits no role work
  And the failure is surfaced at session-start rather than at work_done emission

  @scenario_hash:f76f3c221cab42ed @bc:shopsystem-templates
  Scenario: the work-tracker heal adopts the committed prefix and imports committed issues without fabricating or overwriting
  Given a BC shop whose bd tracker working set is empty and has no issue_prefix configured
  And the committed registry names issue_prefix "tmpl" and carries 23 issues under that prefix
  When the BC agent session starts and the work-tracker health step heals the tracker
  Then the tracker's configured issue_prefix equals "tmpl" as named by the committed registry
  And the tracker's configured issue_prefix is not derived from the BC's name
  And the tracker's working set contains the 23 committed issues with their original ids unchanged
  And no committed issue is dropped or overwritten by the heal

  @scenario_hash:43a05feaefc1d046 @bc:shopsystem-templates
  Scenario: a BC session starts with a locally-writable tracker whose test dolt push fails and the health step blocks all role-work from starting
  Given a BC shop whose bd tracker has a definite issue_prefix configured and a populated working set
  And bd create and bd ready run in the BC shop both exit zero
  And the tracker has a configured Dolt remote
  And a test dolt push to the configured Dolt remote exits non-zero
  When the BC agent session starts and runs the work-tracker health step
  Then the health step reports the tracker as unhealthy and names the failed test dolt push as the cause
  And the BC does not begin its role loop
  And the BC emits no role work
  And the failure is surfaced at session-start rather than at work_done emission
