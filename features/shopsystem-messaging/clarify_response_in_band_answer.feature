@bc:shopsystem-messaging @origin:lead-ox8
Feature: clarify_response — in-band answer that re-opens the original dispatch (lead-ox8)

  @scenario_hash:f5819af74da50561
  Scenario: shop-msg send clarify_response delivers an in-band answer that re-opens the original dispatch on the SAME work_id for the BC's gated loop to consume
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And the lead previously dispatched assign_scenarios for work_id "lead-700", stored as an inbox row at (bc=shopsystem-messaging, work_id="lead-700", direction='inbox', message_type='assign_scenarios')
    And the BC previously emitted a clarify on that work_id, stored as an outbox row at (bc=shopsystem-messaging, work_id="lead-700", direction='outbox', message_type='clarify') asking "which environment variable names the broker host?"
    When the lead operator runs "shop-msg send clarify_response --bc shopsystem-messaging --work-id lead-700 --resolution 'use BROKER_HOST'"
    Then the command exits zero
    And a clarify_response row is stored at (bc=shopsystem-messaging, work_id="lead-700", direction='inbox', message_type='clarify_response') whose payload validates against the ClarifyResponse schema and carries resolution text "use BROKER_HOST"
    And the original assign_scenarios dispatch for work_id "lead-700" is RE-OPENED for the BC's gated loop to resume on the SAME work_id "lead-700" — no new work_id and no new bead are created
    And the resolution text "use BROKER_HOST" is readable by the BC via "shop-msg pending inbox" against work_id "lead-700"

  @scenario_hash:eb96e352471ffd35
  Scenario: the clarify_response row COEXISTS with the original dispatch row on the same (bc, work_id) and does NOT overwrite it (allow_multi_type)
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And the lead previously dispatched request_bugfix for work_id "lead-701", stored as an inbox row at (bc=shopsystem-messaging, work_id="lead-701", direction='inbox', message_type='request_bugfix') with a recorded payload and created_at
    And the BC previously emitted a clarify on work_id "lead-701" stored at (bc=shopsystem-messaging, work_id="lead-701", direction='outbox', message_type='clarify')
    When the lead operator runs "shop-msg send clarify_response --bc shopsystem-messaging --work-id lead-701 --resolution 'the socket path, not the network address'"
    Then the command exits zero
    And a clarify_response row now exists at (bc=shopsystem-messaging, work_id="lead-701", direction='inbox', message_type='clarify_response') carrying the resolution text
    And the original request_bugfix inbox row for (bc=shopsystem-messaging, work_id="lead-701") is unchanged — its message_type, payload, and created_at are byte-identical to their pre-clarify_response state
    And both the request_bugfix row and the clarify_response row are independently present at direction='inbox' for the same (bc=shopsystem-messaging, work_id="lead-701"), distinguished by their message_type discriminator
    And the load-bearing property pinned here is that clarify_response opts into allow_multi_type so it COEXISTS with the dispatch row rather than colliding against the one-row-per-(bc,work_id,message_type) invariant

  @scenario_hash:6c23bb777bab93df
  Scenario: shop-msg send clarify_response is REFUSED when no prior BC clarify exists on that (bc, work_id) — a clarify_response with nothing to answer is operator error
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And the lead previously dispatched assign_scenarios for work_id "lead-702", stored as an inbox row at (bc=shopsystem-messaging, work_id="lead-702", direction='inbox', message_type='assign_scenarios')
    And NO outbox clarify row exists for (bc=shopsystem-messaging, work_id="lead-702") — the BC has not asked anything on this work_id
    When the lead operator runs "shop-msg send clarify_response --bc shopsystem-messaging --work-id lead-702 --resolution 'answer to nothing'"
    Then the command exits non-zero with an error message explaining that clarify_response requires a prior BC clarify on that (bc, work_id) and none exists
    And NO clarify_response row has been stored at (bc=shopsystem-messaging, work_id="lead-702", direction='inbox', message_type='clarify_response')
    And the original assign_scenarios dispatch for work_id "lead-702" is unchanged and is NOT re-opened
    And the load-bearing property pinned here is that clarify_response is valid ONLY as the answer to an outstanding clarify; the precondition is enforced at the CLI surface

  @scenario_hash:460c5e0cc666fef8
  Scenario: shop-msg send clarify_response carries NO scenario payload — the absence of scenario state mechanically forces scope-changing answers to re-dispatch (the bounding constraint)
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And the BC previously emitted a clarify on work_id "lead-703" stored at (bc=shopsystem-messaging, work_id="lead-703", direction='outbox', message_type='clarify')
    When the lead operator inspects "shop-msg send clarify_response --help"
    Then the help text shows the flags --bc, --work-id, and --resolution and shows NO --scenario-file or any flag that carries scenario state
    And the ClarifyResponse schema accepts a resolution text and a work_id but has NO scenario_hashes field — construction supplying a scenario_hashes field raises a schema validation error
    When the lead operator runs "shop-msg send clarify_response --bc shopsystem-messaging --work-id lead-703 --resolution 'use BROKER_HOST'"
    Then the command exits zero and the stored clarify_response payload carries no scenario_hashes field and asserts no scenario coverage
    And the load-bearing property pinned here is that, because clarify_response cannot carry scenarios, an answer that would change the contract or add or tighten scenarios CANNOT be sent as a clarify_response — it MUST route to re-dispatch (assign_scenarios or request_bugfix) per ADR-009 layer (b) and ADR-027, mirroring the nudge no-scenario-state constraint of ADR-015 decision 7
