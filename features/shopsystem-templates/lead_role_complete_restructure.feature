@bc_internal
Feature: Lead-shop role templates: role-complete restructure (lead-po and lead-architect)

  @scenario_hash:bcedb488ecc57d8d @bc:shopsystem-templates
  Scenario: lead-po template leads with role identity and posture before any procedural CLI content
    When I read the lead-po template via "shop-templates show lead-po"
    Then a "# Lead PO — role prompt" identity header appears in the output
    And a "## Your default posture: COMMIT TO SPECIFICS" posture header appears in the output
    And the byte offset of the identity header is less than the byte offset of the first occurrence of the string "shop-msg"
    And the byte offset of the posture header is less than the byte offset of the first occurrence of the string "shop-msg"

  # PDR-033 amendment-a removes the "Interview stakeholder" activity from the
  # lead-po: interview/discovery re-homes to the lead-pm main-session mode.
  # The lead-po activity set is now the four convergent-commitment activities.
  @scenario_hash:3cb958e1572e9532 @bc:shopsystem-templates
  Scenario: lead-po template names every post-PDR-033 PO activity by name, without the re-homed Interview-stakeholder activity
    When I read the lead-po template via "shop-templates show lead-po"
    Then the content names the activity "Maintain product brief"
    And the content names the activity "Write PDR for new functionality"
    And the content names the activity "Write Gherkin scenarios"
    And the content names the activity "Respond to BC `clarify`" with the qualifier "scope" or "vocabulary"
    And the content does not present "Interview stakeholder" as a lead-po activity, instead attributing interview and discovery to the lead-pm main-session mode

  @scenario_hash:eaa4fc5b6bc7ed75 @bc:shopsystem-templates
  Scenario: every post-PDR-033 PO activity named in the lead-po template carries either one-line guidance or an explicit "guidance pending" marker
    Given the post-PDR-033 PO activities "Maintain product brief", "Write PDR for new functionality", "Write Gherkin scenarios as requirements", and "Respond to BC `clarify` (scope, vocabulary)"
    When I read the lead-po template via "shop-templates show lead-po"
    Then for each activity in that list, the content has a contiguous block — either a subsection that names the activity or a line that names the activity — that contains at minimum one sentence of guidance OR an explicit marker of the form "guidance pending" (case-insensitive)
    And no post-PDR-033 PO activity appears as a bare list item with neither guidance nor a "guidance pending" marker

  @scenario_hash:c7febeb6c2e30325 @bc:shopsystem-templates
  Scenario: procedural shop-msg CLI content in the lead-po template is subordinate to role identity, posture, and activity coverage
    When I read the lead-po template via "shop-templates show lead-po"
    Then every heading whose text mentions "shop-msg" appears at heading depth three (###) or deeper, never at depth two (##) or depth one (#)
    And the first occurrence of the substring "shop-msg" in the content appears after the "## Your default posture: COMMIT TO SPECIFICS" header
    And the first occurrence of the substring "shop-msg" in the content appears after every §3.2 PO activity name from scenario 10 has appeared at least once

  @scenario_hash:0584713623f506bb @bc:shopsystem-templates
  Scenario: lead-architect template leads with role identity and posture before any procedural CLI content
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then a "# Lead Architect — role prompt" identity header appears in the output
    And a "## Your default posture: PRE-STATE DETERMINES VEHICLE — VERIFIED EMPIRICALLY" posture header appears in the output
    And the byte offset of the identity header is less than the byte offset of the first occurrence of the string "shop-msg"
    And the byte offset of the posture header is less than the byte offset of the first occurrence of the string "shop-msg"

  @scenario_hash:7c174f4ec2023f7d @bc:shopsystem-templates
  Scenario: lead-architect template names every §3.2 Architect activity by name
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content names the activity "Write ADRs"
    And the content names the activity "Maintain structurizr workspace"
    And the content names the activity "Collaborate with PO on BC decomposition" with the qualifier "turn-limited"
    And the content names the activity "Assign scenarios to BCs"
    And the content names the activity "Reconcile scenario registers"
    And the content names the activity "Send `request_bugfix`" or equivalently mentions both "request_bugfix" and "request_maintenance" as dispatch vehicles
    And the content names the activity "Read a BC-shop's card via `request_shop_card`"
    And the content names the activity "Respond to BC `clarify`" with the qualifier "architecture"

  @scenario_hash:5f7fbf041af86628 @bc:shopsystem-templates
  Scenario: every §3.2 Architect activity named in the lead-architect template carries either one-line guidance or an explicit "guidance pending" marker
    Given the §3.2 Architect activities "Write ADRs", "Maintain structurizr workspace", "Collaborate with PO on BC decomposition (turn-limited)", "Assign scenarios to BCs per structurizr", "Reconcile scenario registers against assigned work", "Send `request_bugfix` / `request_maintenance`", "Read a BC-shop's card via `request_shop_card`", and "Respond to BC `clarify` (architecture)"
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then for each activity in that list, the content has a contiguous block — either a subsection that names the activity or a line that names the activity — that contains at minimum one sentence of guidance OR an explicit marker of the form "guidance pending" (case-insensitive)
    And no §3.2 Architect activity appears as a bare list item with neither guidance nor a "guidance pending" marker

  @scenario_hash:9d15481aa23059ea @bc:shopsystem-templates
  Scenario: procedural shop-msg CLI content in the lead-architect template is subordinate to role identity, posture, and activity coverage
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then every heading whose text mentions "shop-msg" appears at heading depth three (###) or deeper, never at depth two (##) or depth one (#)
    And the first occurrence of the substring "shop-msg" in the content appears after the "## Your default posture: PRE-STATE DETERMINES VEHICLE — VERIFIED EMPIRICALLY" header
    And the first occurrence of the substring "shop-msg" in the content appears after every §3.2 Architect activity name from scenario 14 has appeared at least once
