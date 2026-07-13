@bc:shopsystem-bc-launcher @origin:lead-01jw.1
Feature: on the one-per-container fabro watcher engage each message-driven finite run — and each startup-drain finite run — actually PROCESSES its dispatched work against the single shared server, reaching a Reviewer-gated work_done with NO second server-start (durable P0 regression fix for lead-01jw.1)

  ROOT CAUSE (lead-01jw.1, P0, empirical 2026-07-13, knowledge on the v0.3.67
  canonical one-per-container watcher engage): the engage correctly starts
  EXACTLY ONE long-lived shared per-container fabro server (observed pid 791 on
  127.0.0.1:32276), but each inbound message's finite "fabro run workflow.fabro"
  child then tries to START ITS OWN server at
  "/workspace/.fabro/.watch/fabro-server.sock". fabro enforces a single server
  and REFUSES: "× Failed to start fabro server ... ╰─▶ Server already running
  (pid 791) on 127.0.0.1:32276". Every drained child (lead-mfnt / lead-5oih /
  lead-4mzu) "exited 1 (non-fatal)", NO work_done was emitted, and the
  dispatches stayed stuck pending. The fleet is now LEAK-FREE (server RSS
  63-149MB, down from 28GiB) but CANNOT PROCESS ANY DISPATCHED WORK on the new
  engage.

  WHY THIS WAS UNTESTED: the structural sibling scenario
  bc_container_fabro_engage_external_watcher @scenario_hash:728871aca27b0d8f
  pins, by STRUCTURAL inspection, that "each inbound message fires a finite
  child against that ONE shared server (the child's FABRO_SERVER targets the
  shared container socket)". That structural pin was satisfied by stubs — the
  394 passing tests never ran a REAL finite run against a REAL shared server.
  The one scenario that would have exercised it, the real shared-server multi-
  run soak @scenario_hash:4d2411e2050345bc, was DEFERRED. These scenarios close
  that gap at the FUNCTIONAL-SUCCESS altitude: real finite runs, real shared
  server, work actually processed end-to-end. They realize the "real shared-
  server multi-run actually executes" portion of what 4d2411 deferred, leaving
  4d2411's memory-boundedness-across-50-runs soak as its own remaining pin.

  BEHAVIOR ALTITUDE: these scenarios pin the OBSERVABLE OUTCOME — each finite
  child runs to a gated work_done against the already-running shared server, the
  resident fabro-server count stays exactly 1, and no child fails with "Server
  already running" — WITHOUT prescribing the code fix (e.g. how the child is
  pointed at the shared server rather than starting its own). The BC owns the
  mechanism; the contract is that dispatched work gets processed.

  FIDELITY (ADR-018): these are DYNAMIC functional-success outcomes, so they are
  BC-DEMONSTRATED in-container against the real shared per-container server and
  real finite "fabro run workflow.fabro" children driven to terminal, and
  surfaced via the BC's work_done demonstration (the "shop-msg pending" /
  "work_done" mailbox state and the child exit outcomes). They are NOT lead-side
  structural reads of a static engage command — the structural shape is already
  pinned by 728871; what these add is proof the shape actually WORKS.

  @scenario_hash:9f785e78ed55da4b
  Scenario: with the single shared per-container fabro server already running, each of N>=2 message-driven finite runs executes to a Reviewer-gated work_done against that shared server with NO second server-start
    Given the container "bc-shopsystem-messaging" is running the "--orchestrator fabro" watcher engage with EXACTLY ONE long-lived shared per-container fabro server already started
    And two or more inbound messages, each carrying a distinct work_id on a scenario path, are delivered to the BC inbox so the watcher fires one finite "fabro run workflow.fabro" child per message
    When the finite children run
    Then EACH finite child runs SUCCESSFULLY against the already-running shared server rather than attempting to start its own server, so NO child fails with "Server already running (pid <n>)" and the count of resident fabro servers stays EXACTLY 1 throughout
    And EACH finite child reaches its terminal by driving the workflow to a Reviewer-gated "work_done" emitted on that message's scenario path, rather than exiting 1 with no work_done
    And after the finite runs complete every dispatched work_id has a corresponding "work_done" in the BC outbox and NONE of those dispatches remains stuck pending in the BC inbox
  @scenario_hash:32009f85a099be62
  Scenario: the startup inbox drain fires one finite run per pre-existing pending work_id and each runs to a Reviewer-gated work_done against the single shared server
    Given the container "bc-shopsystem-messaging" starts the "--orchestrator fabro" watcher engage with its single long-lived shared per-container fabro server
    And "shop-msg pending inbox --bc shopsystem-messaging" already lists two or more work_ids that arrived before the watcher started, so the startup drain fires one finite "fabro run workflow.fabro" child per pending work_id
    When the startup drain runs its finite children
    Then EACH drained finite child runs SUCCESSFULLY against the single shared server with the resident fabro-server count staying EXACTLY 1 and NO child failing with "Server already running (pid <n>)"
    And EACH drained finite child reaches a Reviewer-gated "work_done" on its scenario path, so every pre-existing pending work_id is processed to terminal rather than left stuck pending
    And once the drain completes the pending-inbox set for those drained work_ids is empty because each produced a terminal "work_done"
