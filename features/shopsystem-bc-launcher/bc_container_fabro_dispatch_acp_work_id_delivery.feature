@bc:shopsystem-bc-launcher @origin:lead-3zzu
Feature: the ACP-backed dispatch node still delivers each spawned child its concrete WORK_ID, preserving the lead-b3f0 delivery guarantee through the ACP agent's context and per-child config (lead-3zzu, Scenario C)

  DRIVER (lead-3zzu, David 2026-07-08): moving dispatch to an ACP-backed script
  agent must NOT regress the lead-b3f0 delivery guarantee — each child must
  still receive its own concrete WORK_ID. The ACP agent carries the concrete
  work id from its context into the per-child config it materializes, so the
  work id reaches the child's native "script=" node env exactly as the native
  overlay did (lead-b3f0, Scenario C), just now sourced from the ACP decision
  rather than a context-blind command node.

  FIDELITY: the step defs inspect the poured "dispatcher.fabro" def's
  ACP-backed "dispatch" node decision contract and the per-child config it
  materializes — the concrete "WORK_ID=W" carried into the child's
  "[run.environment.env]" overlay, and the detached spawn per decided work id —
  read against the fabro-def artifact surface, NOT a live container run. The
  concrete-work-id delivery is BC-proven in-container (lead-b3f0,
  child-ran-WORK_ID); this scenario pins that the ACP dispatch PRESERVES that
  delivery on the artifact surface. The ACP wire-protocol internals are NOT
  pinned here.

  @scenario_hash:f38ab66672151669
  Scenario: for each work id the ACP dispatch node decides to spawn, the spawned child receives its concrete WORK_ID via a per-child "[run.environment.env] WORK_ID" overlay carried from the ACP agent's context, preserving the lead-b3f0 delivery guarantee
    Given the shopsystem-bc-launcher BC is installed
    And the container "bc-shopsystem-messaging" is running with the self-contained fabro def set POURED by shop-templates into "/workspace/.fabro/", including the "dispatcher.fabro" graph def whose "dispatch" node is the ACP-backed agent node and the UNCHANGED ADR-051 child def
    And the ACP dispatch node's decision for a pending work id "W" with no live child is to SPAWN a child
    When the ACP-backed "dispatch" node's decision contract and the per-child config it materializes for "W" are inspected structurally, without a live docker daemon, a running fabro server, or a reachable agent-vault
    Then the per-child config the ACP node materializes for "W" carries the CONCRETE work id in a "[run.environment.env]" overlay as "WORK_ID=W", so the child receives its own work id through the child config env overlay
    And the ACP node spawns that child DETACHED, so decided children run in PARALLEL isolated per WORK_ID and the dispatch step does not block on them before the loop's "wait -> poll" back-edge
    And the spawned child runs the UNCHANGED ADR-051 child def, and the concrete "WORK_ID=W" from the "[run.environment.env]" overlay REACHES that child's native "script=" node env so the child acts on its own work id, preserving the lead-b3f0 delivery guarantee under the ACP dispatch
