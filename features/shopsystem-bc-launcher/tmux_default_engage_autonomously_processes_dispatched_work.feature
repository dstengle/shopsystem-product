@bc:shopsystem-bc-launcher @origin:lead-ew86
Feature: the tmux-DEFAULT engage autonomously PROCESSES pending inbox dispatches to a gated work_done — restoring the long-standing autonomous tmux engage the --orchestrator split regressed

  PRODUCT-AUTHORITY FINDING (dstengle, 2026-07-13, lead-ew86): the tmux engage
  was ALWAYS autonomous — for months the default tmux launch processed
  dispatched inbox work end-to-end. The "--orchestrator {tmux|fabro}" engage-
  tier split (ADR-050) regressed the DEFAULT tmux startup to: arm the watcher +
  drain (LIST) the inbox, then AWAIT USER DIRECTION. A tmux-engaged BC now PARKS
  real dispatches (assign_scenarios / request_bugfix / request_maintenance)
  waiting for a human "go" instead of processing them. OBSERVED: knowledge
  relaunched under tmux LISTED lead-mfnt / lead-5oih and HELD ("holding here for
  your direction rather than auto-dispatching"), requiring a manually injected
  "go". This was an over-specification from the lead side; the operator did not
  intend or ratify a behavior change at the split.

  WHAT THIS CORRECTS: the tmux-default engage tier is currently pinned only at
  the MECHANISM altitude — bc_container_orchestrator_flag_engage_tier
  @scenario_hash:ee8f4803eb5342f0 pins that the default engages via the existing
  tmux "agent" send-keys path "unchanged", and ADR-050 D3 records that the tmux
  tier's P8 protected the observable "the agent begins work autonomously after
  the barrier passes, with no human follow-up". Neither pin states the BEHAVIOR
  these scenarios restore: that the default tmux engage must DRAIN AND PROCESS
  dispatched inbox work, not merely list-and-await. The fabro tier already pins
  the autonomous drain-and-process analogue (watcher_finite_runs_process_
  dispatched_work_on_shared_server @scenario_hash:32009f85a099be62 and
  @scenario_hash:9f785e78ed55da4b); these scenarios bring the tmux DEFAULT tier
  to parity with that autonomous-processing contract and unwind the await-
  direction regression.

  BEHAVIOR ALTITUDE: these scenarios pin the OBSERVABLE OUTCOME — pending
  dispatched work reaches a Reviewer-gated work_done on the tmux default with NO
  human input between drain and work_done — WITHOUT prescribing the default
  startup-prompt string, the send-keys shape, or any code/prompt fix. The BC
  owns the mechanism (e.g. what the default engage instructs the agent to do);
  the contract is that dispatched work gets PROCESSED autonomously on the tmux
  default, that autonomy is bounded to dispatched work, and that the operator-
  driven interactive session is a distinct, explicitly-selected non-default mode.

  GROUNDING (ADR-018): this finding rests on OPERATOR AUTHORITY plus OBSERVED
  runtime behavior (the parked lead-mfnt / lead-5oih dispatches), NOT on any
  inspection of BC source. FIDELITY: these are DYNAMIC functional-success
  outcomes, so they are BC-DEMONSTRATED in-container — a real tmux-default engage
  with real pending inbox dispatches driven to terminal — and surfaced via the
  BC's work_done demonstration (the "shop-msg pending" / "work_done" mailbox
  state), NOT via lead-side reads of a static engage command.

  @scenario_hash:e811193fc061e1e8
  Scenario: a tmux-default engaged BC with pending inbox dispatches processes them autonomously through the Implementer->Reviewer loop to a gated work_done, with no human "go"
    Given the container "bc-shopsystem-messaging" is launched on the DEFAULT "--orchestrator tmux" engage with no explicit interactive-startup override supplied
    And "shop-msg pending inbox --bc shopsystem-messaging" already lists one or more dispatched work_ids (for example an "assign_scenarios" or a "request_maintenance") that arrived before the engage started
    When the tmux-default engage arms its watcher and drains the pending inbox
    Then the engage does NOT merely LIST the pending dispatches and then hold awaiting a human "go", but proceeds to PROCESS each pending dispatch through the normal Implementer->Reviewer loop
    And each processed dispatch reaches a Reviewer-gated "work_done" emitted on its scenario path, with NO human-injected "go" keystroke required between the drain and the work_done
    And after the engage settles every pending dispatched work_id has a corresponding "work_done" in the BC outbox and NONE of those dispatches remains stuck pending in the BC inbox

  @scenario_hash:f65d43b1d8704f28
  Scenario: the tmux-default autonomous engage processes only DISPATCHED inbox work and synthesizes no unrequested follow-on work
    Given the container "bc-shopsystem-messaging" is launched on the DEFAULT "--orchestrator tmux" engage
    And the BC inbox lists exactly the dispatched work_ids present at engage and no others
    When the tmux-default engage drains and processes its pending inbox work autonomously to work_done
    Then every "work_done" the engage emits corresponds to a work_id that was dispatched into the inbox, so the autonomy is bounded to dispatched work
    And the engage emits NO "work_done" for any work_id that was not dispatched into the inbox, synthesizing no unrequested follow-on work beyond what was dispatched

  @scenario_hash:cdaaf8d986398b36
  Scenario: autonomous drain-and-process is the tmux DEFAULT while the operator-driven interactive session is a distinct, explicitly-selected non-default mode
    Given the shopsystem-bc-launcher BC is installed
    When the container "bc-shopsystem-messaging" is launched on the DEFAULT "--orchestrator tmux" engage with no explicit interactive-startup override supplied
    Then the autonomous drain-and-process behavior is the DEFAULT for the tmux engage, beginning to process dispatched inbox work with no operator "go" required
    And the await-direction / operator-driven interactive behavior is NOT the tmux default and is reached ONLY by an explicit interactive-startup override (for example an explicit startup-prompt that selects an operator-driven session)
    And when that explicit interactive override IS supplied the engage runs the operator-driven interactive session instead of autonomously processing the inbox, confirming the two modes are distinct and separately selected
