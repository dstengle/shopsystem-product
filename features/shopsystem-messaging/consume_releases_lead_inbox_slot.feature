@bc:shopsystem-messaging @origin:lead-nn5f @service:postgres
Feature: shop-msg respond --force and consume-outbox-releases-lead-inbox-slot recovery contract

  # lead-nn5f: close the recovery-surface asymmetry between
  # `shop-msg respond --force` and `shop-msg consume outbox`. consume must
  # release the lead-inbox row (scoped to the same (bc, work_id, message_type)
  # triple as the --force DELETE) so the two recovery paths compose. The
  # @scenario_hash tags below are the CANONICAL on-disk (bare-block) hashes
  # computed via `scenarios hash`; they differ from the wire hashes the lead
  # carried (Feature-wrapped canonicalization) per the known lead-ji28
  # wire/disk divergence.

  @scenario_hash:a540ae54e7d58284
  Scenario: shop-msg consume outbox on a BC-emitted response also releases the lead-inbox row for the same (bc, work_id, message_type) triple so the BC can re-emit without --force
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And the BC has previously called "shop-msg respond work_done" for work-id "lead-n01" producing a lead-inbox row at (bc=shopsystem-product, direction='inbox', work_id='lead-n01', message_type='work_done') AND a BC-outbox marker at (bc=shopsystem-messaging, direction='outbox', work_id='lead-n01', message_type='work_done')
    When the lead operator runs "shop-msg consume outbox --bc shopsystem-messaging --work-id lead-n01 --message-type work_done"
    Then the command exits zero
    And the BC-outbox marker for (bc=shopsystem-messaging, work_id='lead-n01', message_type='work_done') is marked consumed (no longer surfaced by "shop-msg pending outbox --lead shopsystem-product")
    And the lead-inbox row for (bc=shopsystem-product, direction='inbox', work_id='lead-n01', message_type='work_done') is ALSO released (no longer surfaced by "shop-msg pending inbox --lead shopsystem-product")
    And a subsequent "shop-msg respond work_done --bc shopsystem-messaging --work-id lead-n01 --status complete" WITHOUT --force exits zero rather than raising CollisionError, because there is no surviving lead-inbox row to collide against
    And the rationale that pins this behavior is single-source-of-truth: a consumed response is no longer authoritative, so the BC may re-emit cleanly under the original verb without escalating to the --force recovery affordance

  @scenario_hash:8c614e845d7b6a01
  Scenario: shop-msg consume outbox releases only the matching (bc, work_id, message_type) triple and leaves other message_types on the same work_id intact on both surfaces
    Given a lead shop "shopsystem-product" and a BC "shopsystem-messaging" registered in the messaging registry
    And the BC has emitted two responses for work-id "lead-n02": one "clarify" and one "work_done"
    And both responses are visible on both surfaces: "shop-msg pending outbox --lead shopsystem-product" lists both, and "shop-msg pending inbox --lead shopsystem-product" lists both
    When the lead operator runs "shop-msg consume outbox --bc shopsystem-messaging --work-id lead-n02 --message-type work_done"
    Then the command exits zero
    And the (work_id='lead-n02', message_type='work_done') BC-outbox marker AND the (work_id='lead-n02', message_type='work_done') lead-inbox row are BOTH released
    And the (work_id='lead-n02', message_type='clarify') BC-outbox marker AND the (work_id='lead-n02', message_type='clarify') lead-inbox row are BOTH intact and still surfaced on their respective pending queries
    And the release scoping rule is identical to the --force scoping rule in respond_force_scoped_per_triple.feature: both DELETEs key on the full (bc, work_id, message_type) triple, so the two recovery paths compose without cross-talk

  @scenario_hash:54553a9c377e5287
  Scenario: shop-msg respond --force on a (bc, work_id, message_type) triple that has NO prior lead-inbox row succeeds and behaves identically to a fresh respond without --force (empty-case idempotency)
    Given a lead shop "shopsystem-product" and a BC "shopsystem-messaging" registered in the messaging registry
    And a request_maintenance inbox message with work-id "lead-n03" has been sent to "shopsystem-messaging"
    And NO prior lead-inbox row exists for (bc=shopsystem-product, direction='inbox', work_id='lead-n03', message_type='work_done')
    When the BC runs "shop-msg respond work_done --force --bc shopsystem-messaging --work-id lead-n03 --status complete --summary first-emit"
    Then the command exits zero
    And a lead-inbox row at (bc=shopsystem-product, direction='inbox', work_id='lead-n03', message_type='work_done') is created carrying the first-emit payload
    And a BC-outbox marker at (bc=shopsystem-messaging, direction='outbox', work_id='lead-n03', message_type='work_done') is created
    And "shop-msg read inbox --lead shopsystem-product --work-id lead-n03" returns the first-emit payload byte-for-byte
    And the load-bearing property pinned here is that --force does NOT become a "respond only if a prior row exists" precondition; --force is the recovery affordance for the collision case AND a no-op DELETE on the empty case, never a guard against the empty case

  @scenario_hash:d0c3fa2ea91e45e9
  Scenario: shop-msg respond --force re-emit by a BC is visible to the lead's next pending-inbox and pending-outbox reads even if the lead has interleaved its own reconciliation work between the original emit and the --force replacement (no silent swap behind reconciliation in progress)
    Given a lead shop "shopsystem-product" and a BC "shopsystem-messaging" registered in the messaging registry
    And the BC has previously called "shop-msg respond work_done --bc shopsystem-messaging --work-id lead-n04 --status complete --summary degraded-original" producing both a lead-inbox row and a BC-outbox marker carrying the degraded-original payload
    And the lead operator has already read the degraded-original payload via "shop-msg read inbox --lead shopsystem-product --work-id lead-n04" but has NOT yet run "shop-msg consume outbox"
    When the BC runs "shop-msg respond work_done --force --bc shopsystem-messaging --work-id lead-n04 --status complete --summary reviewer-approved-real" before the lead's reconciliation completes
    Then the command exits zero
    And a NOTIFY fires on the lead's inbox channel so any "shop-msg watch --lead shopsystem-product" Monitor pipeline emits a fresh notification line for work-id "lead-n04"
    And a fresh "shop-msg pending inbox --lead shopsystem-product" lists the (work_id='lead-n04', message_type='work_done') row as pending (the --force replacement is delivered and visible, not stuck behind the prior in-flight reconciliation)
    And "shop-msg read inbox --lead shopsystem-product --work-id lead-n04" returns the reviewer-approved-real payload (NOT the degraded-original payload)
    And the load-bearing property pinned here is that --force is observable to the lead on its next read regardless of any reconciliation state the lead is carrying in-process; the lead's reconciliation is a per-turn read, not a row-level lease that --force has to wait on

  @scenario_hash:54d23d628d33d9e5
  Scenario: after shop-msg consume outbox releases the lead-inbox slot, a subsequent BC re-emit (without --force) fires a fresh NOTIFY on the lead's inbox channel so the lead's watch Monitor wakes on the re-emit
    Given a lead shop "shopsystem-product" and a BC "shopsystem-messaging" registered in the messaging registry
    And the BC has previously called "shop-msg respond work_done" for work-id "lead-n05" producing a lead-inbox row and a BC-outbox marker
    And the lead operator has run "shop-msg consume outbox --bc shopsystem-messaging --work-id lead-n05 --message-type work_done" successfully, releasing BOTH the BC-outbox marker and the lead-inbox row per the consume-releases-slot contract above
    And the lead has an active "shop-msg watch --lead shopsystem-product" Monitor pipeline subscribed to the lead's inbox channel
    When the BC runs "shop-msg respond work_done --bc shopsystem-messaging --work-id lead-n05 --status complete --summary second-emit" WITHOUT --force
    Then the command exits zero
    And a fresh lead-inbox row at (bc=shopsystem-product, direction='inbox', work_id='lead-n05', message_type='work_done') is created carrying the second-emit payload
    And a NOTIFY fires on the lead's inbox channel and the watcher emits a fresh "lead-n05 work_done" notification line on its stdout, identical in form to the notification that fires on a first emit
    And the load-bearing property pinned here is that consume-then-re-emit is observationally indistinguishable from a first emit on the wake-up channel: the lead's reactive posture (Monitor armed on watch --lead) wakes the same way for a re-emit as it does for a first emit, so reconciliation logic does not need a separate "is this a re-emit?" code path
