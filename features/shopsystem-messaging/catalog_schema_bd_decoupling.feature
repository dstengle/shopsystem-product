@bc:shopsystem-messaging @origin:brief-001
Feature: Catalog schema bd-decoupling — minimal valid messages need no bd field

  # The shop-system spec separates lead-side work-registry concerns (beads
  # is the lead's choice of tracker, per §6) from the inter-shop wire
  # message catalog. A BC consuming a shop-msg catalog schema must not
  # need to participate in beads to construct a valid message. These six
  # scenarios pin that invariant across the six currently-implemented
  # LeadMessage/BCResponse schemas: each must be constructible from its
  # required fields alone without supplying any beads identifier.

  @scenario_hash:fa20269bf3561196
  Scenario: A minimal valid assign_scenarios message can be constructed without supplying any bd-related field
  Given the AssignScenarios schema from the shop-msg catalog
  When I construct an AssignScenarios instance supplying only the fields the schema marks as required, with no field whose name begins with "bd_" or otherwise references a beads issue identifier
  Then construction succeeds
  And no schema validation error is raised
  And no required field of the schema names a beads identifier in its name, type, or validation pattern

  @scenario_hash:7e474d4fd5c5f4db
  Scenario: A minimal valid request_bugfix message can be constructed without supplying any bd-related field
  Given the RequestBugfix schema from the shop-msg catalog
  When I construct a RequestBugfix instance supplying only the fields the schema marks as required, with no field whose name begins with "bd_" or otherwise references a beads issue identifier
  Then construction succeeds
  And no schema validation error is raised
  And no required field of the schema names a beads identifier in its name, type, or validation pattern

  @scenario_hash:825be146ecab1ecd
  Scenario: A minimal valid request_maintenance message can be constructed without supplying any bd-related field
  Given the RequestMaintenance schema from the shop-msg catalog
  When I construct a RequestMaintenance instance supplying only the fields the schema marks as required, with no field whose name begins with "bd_" or otherwise references a beads issue identifier
  Then construction succeeds
  And no schema validation error is raised
  And no required field of the schema names a beads identifier in its name, type, or validation pattern

  @scenario_hash:4f2329f26a8de9c5
  Scenario: A minimal valid clarify message can be constructed without supplying any bd-related field
  Given the Clarify schema from the shop-msg catalog
  When I construct a Clarify instance supplying only the fields the schema marks as required, with no field whose name begins with "bd_" or otherwise references a beads issue identifier
  Then construction succeeds
  And no schema validation error is raised
  And no required field of the schema names a beads identifier in its name, type, or validation pattern

  @scenario_hash:a2f68ba6fde4159c
  Scenario: A minimal valid work_done message can be constructed without supplying any bd-related field
  Given the WorkDone schema from the shop-msg catalog
  When I construct a WorkDone instance supplying only the fields the schema marks as required, with no field whose name begins with "bd_" or otherwise references a beads issue identifier
  Then construction succeeds
  And no schema validation error is raised
  And no required field of the schema names a beads identifier in its name, type, or validation pattern

  @scenario_hash:680af00e7ee3362d
  Scenario: A minimal valid mechanism_observation message can be constructed without supplying any bd-related field
  Given the MechanismObservation schema from the shop-msg catalog
  When I construct a MechanismObservation instance supplying only the fields the schema marks as required, with no field whose name begins with "bd_" or otherwise references a beads issue identifier
  Then construction succeeds
  And no schema validation error is raised
  And no required field of the schema names a beads identifier in its name, type, or validation pattern
