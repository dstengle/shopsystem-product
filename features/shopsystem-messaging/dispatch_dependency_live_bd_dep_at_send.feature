@bc:shopsystem-messaging @origin:lead-r8di @service:postgres
Feature: shop-msg send consults the LIVE bd depends-on graph at send time (PDR-010 / ADR-013 / ADR-018 — lead-r8di regression teeth)

  @scenario_hash:d57229bc3d2de283
  Scenario: shop-msg send consults the LIVE bd depends-on graph at send time, so a removed or reclassified edge no longer gates even while the predecessor bead is still open
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry "lead-pred" exists and is NOT at dispatch_state="closed" (the predecessor is still open / in-flight)
    And the lead architect previously recorded a depends-on edge with "bd dep add lead-dep lead-pred" so lead-dep depended on lead-pred
    And the lead architect has since either removed that edge with "bd dep remove lead-dep lead-pred" OR reclassified it to a non-blocking type (e.g. relates-to) so that "bd dep list lead-dep" shows NO depends-on edge to lead-pred and "bd ready" reports lead-dep as unblocked
    And a payload file at "/tmp/payload-dep.yaml" pinning a valid request_bugfix
    When the lead architect runs "shop-msg send request_bugfix --bc shopsystem-messaging --work-id lead-dep --payload /tmp/payload-dep.yaml" (no --queue-on-dependency flag)
    Then shop-msg send consults the CURRENT bd depends-on edges for lead-dep at send time (not a snapshot persisted at an earlier send/queue time) and finds no blocking predecessor
    And the command exits zero and deposits the postgres outbox row at (bc=shopsystem-messaging, direction='outbox', work_id='lead-dep', message_type='request_bugfix')
    And the command does NOT refuse citing lead-pred, even though lead-pred is still open, because the live depends-on edge that would have gated the send no longer exists
    And the load-bearing property pinned here is that the gate is a function of the LIVE bd dep graph at send time, never a stale persisted dependency snapshot — this is the behavior already required by scenario 48ade065ce073a54 (strict-mode consults bd depends-on edges) extended to the edge-removal / reclassification path

  @scenario_hash:2bb889fc1fe2e4bb
  Scenario: the documented bd dep remove cure works end-to-end — removing the depends-on edge then sending deposits the postgres row even though the predecessor bead is never closed
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry "lead-blkr" exists and remains OPEN throughout this scenario (it is never closed)
    And the lead architect recorded a depends-on edge with "bd dep add lead-gated lead-blkr" so lead-gated depended on lead-blkr
    And an earlier "shop-msg send ... --work-id lead-gated" was refused in strict mode naming lead-blkr as the unmet predecessor
    And a payload file at "/tmp/payload-gated.yaml" pinning a valid request_bugfix
    When the lead architect runs "bd dep remove lead-gated lead-blkr" and then runs "shop-msg send request_bugfix --bc shopsystem-messaging --work-id lead-gated --payload /tmp/payload-gated.yaml"
    Then the command exits zero and deposits the postgres outbox row at (bc=shopsystem-messaging, direction='outbox', work_id='lead-gated', message_type='request_bugfix')
    And no separate predecessor-close step (bd close lead-blkr) and no promote scan is required for the deposit to occur — removing the live edge is itself sufficient because the gate re-reads live bd dep state at send time
    And the load-bearing property pinned here is that "bd dep remove" is a complete, self-sufficient cure for an over-recorded dispatch dependency: the operator-facing contract that "remove the edge to unblock the send" actually holds, with no reliance on a snapshot-clear step the operator cannot reach
