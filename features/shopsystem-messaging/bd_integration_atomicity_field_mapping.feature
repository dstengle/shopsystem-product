@bc:shopsystem-messaging @origin:pdr-010
Feature: shop-msg owns bd integration with atomicity and field mapping (PDR-010 foundation, ADR-011 + ADR-012 + ADR-016)

  # lead-tuu5: shop-msg owns the bd integration (field mapping, atomicity,
  # sweep recovery) per PDR-010 / ADR-011 / ADR-012 / ADR-016. The
  # @scenario_hash tags below are the CANONICAL on-disk (bare-block) hashes
  # computed via `scenarios hash`; they differ from the WIRE hashes the lead
  # carried (Feature-wrapped canonicalization) per the known lead-ji28
  # wire/disk divergence. Scenario bodies are reproduced verbatim from the
  # lead-tuu5 dispatch.

  @scenario_hash:e73037244a92b1a4
  Scenario: shop-msg send creates a lead bd entry carrying the canonical field set encoded as bd structured metadata, not as free-form notes
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry with a clone at "repos/shopsystem-messaging/" whose origin/main HEAD SHA is "b14b0ba"
    And a payload file at "/tmp/dispatch-payload.yaml" pinning a request_bugfix carrying two scenario hashes "9457dfff7e3f9e90" and "2b5d558d548b0606"
    When the lead architect runs "shop-msg send request_bugfix --bc shopsystem-messaging --work-id lead-abc --payload /tmp/dispatch-payload.yaml --depends-on lead-767"
    Then the command exits zero
    And a lead bd entry with id "lead-abc" exists carrying bd structured metadata with all of the following keys at the values shown: dispatched_to_bc="shopsystem-messaging", dispatch_message_type="request_bugfix", dispatch_state="dispatched", scenario_hashes_pinned="9457dfff7e3f9e90,2b5d558d548b0606", depends_on_dispatch="lead-767", bc_origin_main_commit_at_dispatch="b14b0ba"
    And the bd metadata is queryable via "bd show lead-abc" returning the keys above in a structured (JSON or key=value) form, NOT embedded in the bead's free-form notes prose
    And no "## Dispatch state" prose block has been written to the bead's notes (ADR-011 explicitly removes this prose fallback)
    And the load-bearing property pinned here is that strategic queries against the lead bd ("what is in-flight to shopsystem-messaging right now") read structured metadata and do NOT need to parse prose

  @scenario_hash:8edfb82fc6a07184
  Scenario: shop-msg send follows the bd-first 3-step protocol — bd entry written at outbox_pending with fsync, then postgres deposit, then bd flip to dispatched
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a payload file at "/tmp/dispatch-payload.yaml" pinning a valid request_maintenance with no scenario hashes
    When the lead architect runs "shop-msg send request_maintenance --bc shopsystem-messaging --work-id lead-def --payload /tmp/dispatch-payload.yaml" and the run is observed step-by-step
    Then Step 1 fires first: for an absent work_id bead a lead bd entry with id "lead-def" is created via "bd create --metadata <json>", while for a pre-existing work_id bead Step 1 instead additively patches it via "bd update --set-metadata"/"--append-notes" (never re-creating it); either way the Step-1 write carries dispatch_state="outbox_pending" and is fsynced to disk before Step 2 begins
    And Step 2 fires next: a postgres outbox row at (bc=shopsystem-messaging, direction='outbox', work_id='lead-def', message_type='request_maintenance') is inserted, carrying lead-def as the correlation key
    And Step 3 fires last: the lead bd entry "lead-def" has its dispatch_state flipped from "outbox_pending" to "dispatched" via "bd update --set-metadata dispatch_state=dispatched"
    And the command exits zero only after Step 3 succeeds; observable to the caller as the report-complete signal
    And the load-bearing property pinned here is that the bd intent at Step 1 is durable on disk (via fsync) BEFORE any postgres write happens, so a crash between Steps 1 and 2 leaves a recoverable bd record of intent — the recovery premise the sweeper depends on

  @scenario_hash:ea2d453f88110e82
  Scenario: shop-msg send records dispatch state onto an already-existing work_id bead as a strict additive metadata-and-notes-only patch, never overwriting the bead's title, type, priority, or description
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry with id "lead-xyz" ALREADY EXISTS before any dispatch, carrying identity fields title="bd dispatch upsert clobbers pre-existing work_id bead identity fields", type="bug", priority="P1", and description="when shop-msg send targets a pre-existing work_id bead, Step-1 bd create upserts and overwrites the bead's identity fields"
    And a payload file at "/tmp/dispatch-payload.yaml" pinning a valid request_bugfix carrying one scenario hash "abc123def456abcd"
    When the lead architect runs "shop-msg send request_bugfix --bc shopsystem-messaging --work-id lead-xyz --payload /tmp/dispatch-payload.yaml"
    Then the command exits zero
    And the lead bd entry "lead-xyz" retains every pre-existing identity field byte-for-byte: title is still "bd dispatch upsert clobbers pre-existing work_id bead identity fields" (NOT replaced by a synthesized "dispatch request_bugfix -> ..." stub), type is still "bug" (NOT downgraded to "task"), priority is still "P1" (NOT downgraded to "P2"), and description is still "when shop-msg send targets a pre-existing work_id bead, Step-1 bd create upserts and overwrites the bead's identity fields" (NOT replaced)
    And the only changes applied to "lead-xyz" are additive: dispatch metadata keys dispatched_to_bc="shopsystem-messaging", dispatch_message_type="request_bugfix", dispatch_state="dispatched", and scenario_hashes_pinned="abc123def456abcd" are added or updated, and dispatch notes are appended, with no other field mutated
    And the load-bearing property pinned here is that when the work_id bead pre-exists (the normal lead-shop case, since the work_id is a pre-existing lead bead), the shop-msg bd write is a strict additive metadata/notes-only patch — the Step-1 write detects the existing bead and patches it rather than clobbering identity fields via an upserting "bd create --metadata"

  @scenario_hash:9b96bf9183d8e899
  Scenario: shop-msg sweep recovers a lead bd entry stuck at dispatch_state=outbox_pending by reconciling against the actual postgres state (deposit-already-landed case becomes a bd-flip-only recovery)
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry "lead-ghi" exists at dispatch_state="outbox_pending" with bd metadata indicating dispatched_to_bc="shopsystem-messaging" and dispatch_message_type="assign_scenarios"
    And a postgres outbox row at (bc=shopsystem-messaging, direction='outbox', work_id='lead-ghi', message_type='assign_scenarios') already exists (Step 2 landed; Step 3 was lost to a process crash before the bd flip)
    And the lead bd entry's outbox_pending timestamp is older than the sweep threshold (default 60 seconds)
    When the lead operator runs "shop-msg sweep --shop shopsystem-product"
    Then the command exits zero
    And the lead bd entry "lead-ghi" is observed: dispatch_state has been flipped from "outbox_pending" to "dispatched" via "bd update --set-metadata dispatch_state=dispatched"
    And NO duplicate postgres outbox row has been inserted (the existing (bc, direction, work_id, message_type) row is preserved; the sweep recognized the row already exists and skipped the deposit retry)
    And a second invocation of "shop-msg sweep --shop shopsystem-product" leaves the bd state and the postgres state byte-for-byte unchanged (idempotency)
    And the load-bearing property pinned here is that the sweeper's reconciliation rule is shop-msg-wins for "was the message sent" (per PDR-010 decision 3): the postgres row's existence is the authoritative answer, and bd is corrected to match

  @scenario_hash:e357dd49f591da22
  Scenario: shop-msg sweep recovers a lead bd entry stuck at dispatch_state=outbox_pending by retrying the postgres deposit (deposit-never-landed case becomes a re-deposit recovery)
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry "lead-jkl" exists at dispatch_state="outbox_pending" with bd metadata indicating dispatched_to_bc="shopsystem-messaging", dispatch_message_type="request_bugfix", and a payload reference carried on the bd entry sufficient to reconstruct the postgres row
    And NO postgres outbox row exists for (bc=shopsystem-messaging, direction='outbox', work_id='lead-jkl', message_type='request_bugfix') (Step 2 never landed; the process crashed between Steps 1 and 2)
    And the lead bd entry's outbox_pending timestamp is older than the sweep threshold (default 60 seconds)
    When the lead operator runs "shop-msg sweep --shop shopsystem-product"
    Then the command exits zero
    And a postgres outbox row at (bc=shopsystem-messaging, direction='outbox', work_id='lead-jkl', message_type='request_bugfix') is inserted carrying the payload reconstructed from the bd entry
    And the lead bd entry "lead-jkl" has its dispatch_state flipped from "outbox_pending" to "dispatched"
    And the deposit retry is guarded against double-write by the postgres schema's uniqueness constraint on (work_id, direction, shop): if a concurrent sweep had already deposited, the second deposit fails the uniqueness check and the sweeper proceeds to the bd flip without error
    And the load-bearing property pinned here is that bd intent at Step 1 carries enough information to reconstruct the postgres deposit, so a crash before Step 2 is fully recoverable

  @scenario_hash:fcdd854bfba8f2a2
  Scenario: shop-msg consume outbox transitions the lead bd entry's dispatch_state to consumed as a CLI-layer side effect, with no separate agent step required
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a lead bd entry "lead-mno" exists at dispatch_state="bc_emitted" (the BC has emitted work_done; the lead has not yet consumed)
    And a BC-outbox marker at (bc=shopsystem-messaging, direction='outbox', work_id='lead-mno', message_type='work_done') exists and is surfaced by "shop-msg pending outbox --lead shopsystem-product"
    When the lead operator runs "shop-msg consume outbox --bc shopsystem-messaging --work-id lead-mno --message-type work_done"
    Then the command exits zero
    And the lead bd entry "lead-mno" has its dispatch_state flipped from "bc_emitted" to "consumed" via "bd update --set-metadata dispatch_state=consumed" called from the consume CLI itself (via the bd_facade module), NOT as a separate agent-run "bd update" command
    And the BC-outbox marker is released per the lead-nn5f contract (no longer surfaced by "shop-msg pending outbox --lead shopsystem-product")
    And the agent who ran "shop-msg consume outbox" did NOT need to also run "bd update --set-metadata dispatch_state=consumed lead-mno" as a follow-up: the CLI handled both the messaging-layer release and the bd-layer status flip under a single atomicity boundary
    And the load-bearing property pinned here is the ADR-016 principle: integration logic lives in the shop-msg CLI, not in agent procedure; the agent invokes one command and the CLI performs both the messaging action and the paired bd update

  @scenario_hash:ae6de8a9b312aada
  Scenario: when shop-msg send's postgres deposit fails after the bd write at Step 1 succeeds, the lead bd entry remains at dispatch_state=outbox_pending (NOT silently flipped to dispatched) so the sweeper can recover (adversarial — atomicity protocol enforcement)
    Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
    And a BC "shopsystem-messaging" registered in the messaging registry
    And a payload file at "/tmp/dispatch-payload.yaml" pinning a valid request_bugfix
    And the postgres connection is configured to fail the next outbox insert (simulating a network drop or DB-side rejection between Steps 1 and 3)
    When the lead architect runs "shop-msg send request_bugfix --bc shopsystem-messaging --work-id lead-pqr --payload /tmp/dispatch-payload.yaml"
    Then Step 1 fires and a lead bd entry "lead-pqr" is created at dispatch_state="outbox_pending"
    And Step 2 fires and fails (the postgres outbox insert raises)
    And Step 3 does NOT fire: the lead bd entry "lead-pqr" remains at dispatch_state="outbox_pending"; it is NOT flipped to "dispatched"
    And the command exits non-zero with an error message naming the postgres failure
    And a subsequent "shop-msg sweep --shop shopsystem-product" (after the postgres connection recovers) is able to retry the Step 2 deposit using the payload reference on the bd entry and complete the flip to "dispatched" per the deposit-never-landed recovery scenario above
    And the load-bearing property pinned here is that the bd flip from outbox_pending to dispatched is GUARDED by Step 2 success: there is no path in the CLI by which the bd flip happens without postgres acknowledging the deposit, so bd never lies about transmission state
