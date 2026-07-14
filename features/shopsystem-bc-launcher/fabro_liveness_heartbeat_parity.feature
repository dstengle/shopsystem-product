@bc:shopsystem-bc-launcher @origin:lead-8hpz
Feature: an idle-but-live fabro-engaged BC reports bc-status online and healthcheck healthy — liveness parity with the tmux runtime — because the always-resident watcher maintains the shop-msg heartbeat on a bounded cadence (lead-8hpz)

  ROOT CAUSE (lead-8hpz, P2, empirical 2026-07-12): a fabro-engaged BC that was
  functionally HEALTHY — container Up, beads usable, the engage actively serving
  its inbox — nonetheless reported "shop-msg bc-status" = offline (heartbeat
  ~2525s stale) and docker healthcheck = unhealthy. The shop-msg online
  heartbeat and the container healthcheck were maintained by the tmux
  claude-agent session-start loop, which the fabro engage REPLACES (ADR-050 D3),
  so a fabro BC was live-and-working yet reported dead. The operator cannot
  trust liveness signals that go stale on a healthy BC.

  RELATION TO THE EXISTING STRUCTURAL PIN: the external watcher feature already
  pins, by STRUCTURAL inspection, that the always-resident "shop-msg watch"
  process UPSERTs the bc_presence heartbeat on a cadence inside the staleness
  window so bc-status reports online and the healthcheck reports healthy
  (bc_container_fabro_engage_external_watcher, @scenario_hash:e94a01b26ed6a4cc).
  These scenarios EXTEND that structural pin to the DEMONSTRATED behavior it
  does not yet state: that an IDLE-BUT-LIVE fabro BC (supervisor resident, no
  message in flight) is NOT reported offline, that the heartbeat cadence is
  BOUNDED strictly inside the staleness window, and that the liveness interface
  is CONSISTENT across the tmux and fabro runtimes. They do NOT contradict
  e94a01b: the heartbeat is maintained by the always-resident supervisor
  independent of message arrival — not "per poll tick" and not only when work is
  in flight — which is exactly what keeps the IDLE case live.

  COHERENCE NOTE: the durable fabro engage is the LISTEN/NOTIFY external watcher
  (bc_container_fabro_engage_external_watcher, lead-01jw), NOT the superseded
  infinite "fabro run dispatcher.toml" 5s-poll loop that lead-8hpz first
  observed. These scenarios are authored against the durable engage: the
  heartbeat is maintained by the always-resident supervisor on a bounded
  cadence, mechanism-agnostic as to how that cadence is driven.

  FIDELITY (ADR-018): bc-status classification and the container healthcheck are
  DYNAMIC runtime outcomes surfaced via the shop-msg bc-status surface and
  docker inspect, not lead-side reads of BC source. These are BC-DEMONSTRATED
  in-container — a real idle-but-live fabro-engaged BC observed across longer
  than the bc-status staleness window — and asserted against the real bc-status
  and healthcheck surfaces, never against BC source and never against a model.

  @scenario_hash:a5ce1af45ade7444
  Scenario: an idle-but-live fabro-engaged BC — supervisor resident, no message in flight — reports bc-status online and healthcheck healthy, not offline and not unhealthy
    Given the container "bc-shopsystem-messaging" is running the "--orchestrator fabro" watcher engage with its always-resident supervisor process running
    And NO inbound message is in flight, so the BC is idle-but-live with zero resident finite runs
    When the BC runs idle for longer than the bc-status staleness window with no dispatched work arriving
    Then "shop-msg bc-status" classifies "shopsystem-messaging" as ONLINE because its last_seen_at heartbeat is within the staleness window, NOT offline with a stale heartbeat
    And the container healthcheck reports healthy, NOT unhealthy, for the idle-but-live BC
    And this closes the lead-8hpz regression where a functionally healthy fabro BC reported offline and unhealthy because the fabro engage maintained no shop-msg heartbeat after replacing the tmux session-start loop

  @scenario_hash:81eee7115a2457f4
  Scenario: the fabro-engaged BC's liveness signals match the tmux-engaged BC's, so the operator cannot distinguish runtime from the liveness surface
    Given a tmux-engaged idle-but-live BC maintains its shop-msg heartbeat via the claude-agent session-start loop and so reports bc-status online and healthcheck healthy
    And a fabro-engaged idle-but-live BC maintains its shop-msg heartbeat via the always-resident watcher supervisor
    When an operator reads "shop-msg bc-status" and the container healthcheck for each runtime while both are idle-but-live
    Then both runtimes report the SAME liveness signals — bc-status online and healthcheck healthy — so a live BC is reported live on either runtime
    And the operator cannot tell from the liveness surface alone which runtime a healthy idle BC is engaged under, because the fabro liveness interface mirrors the tmux one rather than diverging from it
    And a genuinely dead BC on either runtime reports offline and unhealthy identically, so the liveness signal remains a true liveness signal on both runtimes

  @scenario_hash:90e6b9fae7a63eb8
  Scenario: the fabro heartbeat cadence is bounded strictly inside the bc-status staleness window, so a live BC's last_seen_at never goes stale
    Given the container "bc-shopsystem-messaging" is running the "--orchestrator fabro" watcher engage with its always-resident supervisor maintaining the shop-msg heartbeat
    When the supervisor runs continuously for several multiples of the bc-status staleness window while the BC stays live
    Then the supervisor UPSERTs the bc_presence (bc_name, last_seen_at) heartbeat on a cadence whose interval is BOUNDED strictly below the bc-status staleness window, independent of whether any message arrives
    And because the cadence interval is below the staleness window, the last_seen_at never ages past the staleness threshold while the supervisor is alive, so a live BC never flaps to offline between heartbeats
    And as the negative control, the superseded infinite "fabro run dispatcher.toml" engage maintained NO shop-msg heartbeat on any cadence, so its last_seen_at aged unboundedly and a live BC reported offline (lead-8hpz), which this bounded cadence fixes
