@bc:shopsystem-messaging @origin:lead-fnj5
Feature: depends-on dispatch gate reads bd-native issue status as authoritative (lead-fnj5)

  The depends-on dispatch gate (PDR-010 / ADR-013) decides whether a
  predecessor is satisfied. The terminal close runs via "bd close"
  (PDR-010 / ADR-017 reconciliation), which the facade has no hook on, so a
  genuinely CLOSED bd issue (bd-native status=closed) is left at
  dispatch_state=consumed: the metadata projection and bd-native status
  disagree. The gate keying on dispatch_state metadata alone therefore
  REFUSED against actually-closed predecessors, and --queue-on-dependency
  would queue forever. Cure (a): a predecessor is SATISFIED when its
  bd-native status is "closed", independent of its dispatch_state value.

  @scenario_hash:201cdde6d7a904f8
  Scenario: strict-mode send PASSES against a predecessor that is a closed bd issue but whose dispatch_state was never advanced past consumed
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry "lead-rst" exists at dispatch_state="consumed" then closed via "bd close" so its bd-native status is "closed" while its dispatch_state metadata remains "consumed"
    And the lead architect has recorded a depends-on edge with "bd dep add lead-uvw lead-rst" so lead-uvw depends on lead-rst
    And a payload file at "/tmp/payload-uvw.yaml" pinning a valid request_bugfix
    When the lead architect runs "shop-msg send request_bugfix --bc shopsystem-messaging --work-id lead-uvw --payload /tmp/payload-uvw.yaml" (no --queue-on-dependency flag)
    Then the command exits zero
    And a postgres outbox row at (bc=shopsystem-messaging, direction='outbox', work_id='lead-uvw', message_type='request_bugfix') is deposited
    And NO queued lead bd entry "lead-uvw" carrying pending_dependency is created
    And the load-bearing property pinned here is that bd-native status=closed is the authoritative satisfaction signal for the depends-on gate, independent of the dispatch_state metadata projection

  @scenario_hash:633d89099ae58022
  Scenario: --queue-on-dependency does NOT queue against a closed bd issue predecessor whose dispatch_state was never advanced past consumed; it dispatches normally
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry "lead-xyz" exists at dispatch_state="consumed" then closed via "bd close" so its bd-native status is "closed" while its dispatch_state metadata remains "consumed"
    And the lead architect has recorded a depends-on edge with "bd dep add lead-zab lead-xyz" so lead-zab depends on lead-xyz
    And a payload file at "/tmp/payload-zab.yaml" pinning a valid request_bugfix
    When the lead architect runs "shop-msg send request_bugfix --bc shopsystem-messaging --work-id lead-zab --payload /tmp/payload-zab.yaml --queue-on-dependency"
    Then the command exits zero
    And a postgres outbox row at (bc=shopsystem-messaging, direction='outbox', work_id='lead-zab', message_type='request_bugfix') is deposited
    And NO queued lead bd entry "lead-zab" carrying pending_dependency is created
    And the load-bearing property pinned here is that --queue-on-dependency MUST NOT queue behind an already-closed predecessor: a closed bd issue satisfies the gate so the dispatch proceeds normally rather than deferring forever
