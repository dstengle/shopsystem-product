@bc:shopsystem-bc-launcher @origin:lead-3zzu
Feature: the ACP-backed dispatch node is idempotent per work_id — it re-dispatches only work ids with no live child, so a still-in-flight work_id is not duplicated across poll cycles (lead-3zzu, Scenario B)

  DRIVER (lead-3zzu, observed 2026-07-08 on shopsystem-knowledge v1,
  lead-ots3): the pre-fix native command "dispatch" node re-fires for any
  still-pending work_id every ~6s poll cycle. A slow child (minutes) stays
  pending until it emits work_done, so each cycle spawns a NEW child keyed the
  same WORK_ID, and the duplicate children collide on the same per-WORK_ID git
  worktree — the work may never converge and duplicate LLM tokens burn. The
  ACP-backed dispatch node (Scenario A) closes this because it tracks in-flight
  work_ids from the run-state context and re-dispatches only those with no live
  child.

  FIDELITY: the step defs inspect the poured "dispatcher.fabro" def's
  ACP-backed "dispatch" node decision contract — that its in-flight-tracking
  input yields a decision to spawn ONLY for a work id with no live child, and
  to SKIP a work id whose prior child is still running — plus the negative
  control that the pre-fix native command node carried no such skip and
  re-dispatched every cycle. Read against the fabro-def artifact surface, NOT a
  live container run; the observed duplicate-collision is BC-witnessed
  (lead-ots3) and the def-contract idempotency shape is what this scenario pins.

  @scenario_hash:713d01c4f4dfd107
  Scenario: for a work id whose prior child is still in flight the ACP dispatch node's decision is to SKIP re-dispatch and for a work id with no live child its decision is to SPAWN, with a negative control that the pre-fix native command node re-dispatched every cycle
    Given the shopsystem-bc-launcher BC is installed
    And the container "bc-shopsystem-messaging" is running with the self-contained fabro def set POURED by shop-templates into "/workspace/.fabro/", including the "dispatcher.fabro" graph def whose "dispatch" node is the ACP-backed agent node
    And the incoming context carries a pending work id "W" AND the in-flight run state records that a prior child for "W" is still running and has not yet emitted work_done
    When the ACP-backed "dispatch" node's decision contract is inspected structurally against that context, without a live docker daemon, a running fabro server, or a reachable agent-vault
    Then the decision returned for the still-in-flight work id "W" is to SKIP re-dispatch, so NO second child is spawned for "W" while its prior child is live, and the two children cannot collide on the shared per-"W" git worktree
    And when the in-flight run state records NO live child for a pending work id "V", the decision returned for "V" is to SPAWN a child, so a genuinely unstarted work id is still dispatched exactly once
    And as the negative control, the pre-fix native command "dispatch" node carried NO in-flight skip and re-dispatched every still-pending work id each ~6s cycle — the exact duplicate-spawn the ACP node's in-flight tracking exists to eliminate
