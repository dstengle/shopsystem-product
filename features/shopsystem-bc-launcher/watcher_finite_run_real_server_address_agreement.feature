@origin:lead-01jw.1
Feature: the one-per-container fabro watcher engage binds its ONE shared server to the SAME address it exports as FABRO_SERVER, and each finite run is DEMONSTRATED connecting to that REAL running server and reaching a Reviewer-gated work_done — a stubbed/faked server CANNOT satisfy these scenarios (iteration-3 durable fix for the recurring lead-01jw.1 "Server already running" defect)

  RECURRING ROOT CAUSE (iteration 3, empirical 2026-07-13 on v0.3.68, knowledge
  container): the one-per-container watcher engage starts its ONE shared fabro
  server bound to TCP "127.0.0.1:32276" (observed process
  "fabro server tcp:127.0.0.1:32276"), while every finite-run child targets
  "FABRO_SERVER=/workspace/.fabro/.watch/fabro-server.sock" — a unix socket that
  NO server listens on (".watch/" holds no ".sock"). So "fabro run --server
  $FABRO_SERVER" cannot connect, falls back to starting its OWN server, and
  fails "× Failed to start fabro server ... ╰─▶ Server already running (pid 867)
  on 127.0.0.1:32276". Every finite child "exited 1"; lead-mfnt / lead-5oih
  stuck unprocessed. The prior fix (lead-oqaw, "--server $FABRO_SERVER") was
  right in spirit but the server BIND address and the client TARGET address DO
  NOT AGREE.

  WHY THE PRIOR TWO FIXES PASSED ANYWAY (the cycle to break): iterations 1-2
  (features watcher_finite_runs_process_dispatched_work_on_shared_server, hashes
  9f785e78ed55da4b message-driven and 32009f85a099be62 startup-drain) pinned the
  correct functional-success OUTCOME — each finite child "runs SUCCESSFULLY against the
  already-running shared server", resident server count stays EXACTLY 1, no
  "Server already running", Reviewer-gated work_done. Those Then steps, run
  against a REAL server, WOULD have caught this defect. They passed regardless
  because the tests STUBBED the fabro server: the docker-driver was faked, so
  "runs successfully" was satisfied without any real server ever accepting a
  real finite-run connection at the agreed address. The bug class — bind address
  vs. client target DISAGREEING — is structurally invisible to a stubbed server,
  because a stub returns canned success no matter what address the client aims
  at. These scenarios SHARPEN 9f785e78 / 32009f85 from stub-satisfiable to
  REAL-server-required, and re-pin the same behavior at a fidelity a stub cannot
  meet.

  BEHAVIOR ALTITUDE (address agreement, mechanism-agnostic): the deciding pin is
  AGREEMENT, not a transport choice. The address the engage binds the ONE shared
  server to is EXACTLY the address it exports as FABRO_SERVER and passes to every
  finite "fabro run --server". These scenarios do NOT prescribe unix-socket vs.
  TCP — the BC owns that choice; they pin that the bind address and the client
  target are the SAME address whichever the BC picks, and pin the OBSERVABLE
  CONSEQUENCE: a finite run started for an inbound work_id CONNECTS to the
  already-running shared server (no new "fabro server start", no "Server already
  running") and reaches its terminal Reviewer-gated work_done.

  THE CYCLE-BREAKER — REAL-server integration coverage is the defining
  requirement: these scenarios are satisfiable ONLY if an ACTUAL running fabro
  server accepts an ACTUAL finite-run connection and the run advances to
  terminal. Each Then binds to real-only evidence — a live socket ACCEPT at the
  agreed address, a real work_done row landing via the real shop-msg / bc-emit
  path, and the real server's own telemetry (the scenario edc035fdde4062df
  telemetry surface) recording the run transition active->completed for that
  work_id. A stubbed / faked docker-driver server has
  no bound socket at the agreed address, emits no real work_done, and exposes no
  such telemetry, so it CANNOT satisfy these Then steps — it would instead
  reproduce the v0.3.68 "Server already running" / "exited 1" failure. This is
  the functional-success coverage that @scenario_hash:4d2411e2050345bc's
  deferral left uncovered; these scenarios UN-DEFER the functional half of 4d2411
  (its >=50-run memory-soak half stays deferred per the lead-01jw sequencing).

  FIDELITY (ADR-018): these are DYNAMIC functional-success outcomes, BC-
  DEMONSTRATED IN-CONTAINER against the REAL single shared per-container server
  and REAL finite "fabro run workflow.fabro" children driven to terminal, and
  surfaced via the BC's work_done demonstration (the "shop-msg pending" /
  "work_done" mailbox state, the child exit outcomes, and the shared server's
  scrapeable run telemetry). They are explicitly NOT lead-side structural reads
  of the static engage command and explicitly NOT satisfiable by a stubbed
  server — a real server accepting a real connection is the load-bearing
  evidence.

  @scenario_hash:ab9b2be40558cfc2
  Scenario: the shared server's bind address and the exported FABRO_SERVER client target AGREE, so a message-driven finite run CONNECTS to the running shared server with no second server-start
    Given the container "bc-shopsystem-messaging" is running the "--orchestrator fabro" watcher engage with EXACTLY ONE long-lived shared per-container fabro server already started and bound to a single container-scoped address
    And the address that one shared server is bound to is EXACTLY the address the engage exports as "FABRO_SERVER" and passes to each finite "fabro run --server", whether that address is a unix socket or a TCP endpoint
    And an inbound message carrying a work_id on a scenario path is delivered so the watcher fires one finite "fabro run workflow.fabro --server $FABRO_SERVER" child
    When the finite child runs against the real running shared server
    Then the finite child's connection to "$FABRO_SERVER" is ACCEPTED by the already-running shared server — a real client-to-server connection is established at the agreed address — so the child does NOT run "fabro server start", does NOT fall back to starting its own server, and NO child fails with "Server already running (pid <n>)"
    And the count of resident fabro servers stays EXACTLY 1 throughout, because the finite run connected to the existing server rather than binding a second one at a different address
    And the finite child advances on the real server to a Reviewer-gated "work_done" emitted on that message's scenario path via the real shop-msg / bc-emit path, so the dispatched work_id lands a real "work_done" in the BC outbox and is no longer stuck pending — an outcome unreachable if bind and target addresses disagreed
  @scenario_hash:33488b7e1657b7c7
  Scenario: a startup-drain finite run CONNECTS to the same real shared server at the agreed address and reaches a Reviewer-gated work_done
    Given the container "bc-shopsystem-messaging" starts the "--orchestrator fabro" watcher engage with its single long-lived shared per-container fabro server bound to a container-scoped address that EQUALS the exported "FABRO_SERVER"
    And "shop-msg pending inbox --bc shopsystem-messaging" already lists a work_id that arrived before the watcher started, so the startup drain fires a finite "fabro run workflow.fabro --server $FABRO_SERVER" child for it
    When the startup-drain finite child runs against the real running shared server
    Then the drained child's connection to "$FABRO_SERVER" is ACCEPTED by the single running shared server at the agreed address, so it does NOT start its own server and does NOT fail with "Server already running (pid <n>)", and the resident fabro-server count stays EXACTLY 1
    And the drained child advances on the real server to a Reviewer-gated "work_done" on its scenario path via the real shop-msg / bc-emit path, so once the drain completes that pre-existing work_id is processed to terminal and no longer appears in the pending inbox
  @scenario_hash:89e975a7a38fdcaf
  Scenario: the finite-run success is DEMONSTRATED against a real running server such that a stubbed or faked server cannot satisfy it — the real server's telemetry records the run active->completed for the work_id
    Given the container "bc-shopsystem-messaging" is running the watcher engage with its single REAL long-lived shared per-container fabro server exposing scrapeable run telemetry (the @scenario_hash:edc035fdde4062df surface)
    And a baseline scrape of that telemetry shows ZERO active finite runs and the completed-run count for a new work_id is zero
    When an inbound message fires a finite "fabro run workflow.fabro --server $FABRO_SERVER" child that connects to the real running shared server and is driven to its terminal
    Then the REAL shared server's own telemetry records that finite run transitioning ACTIVE while it executes and then COMPLETED for that work_id — evidence that only a real server accepting a real finite-run connection can produce, and that a stubbed / faked docker-driver server (which binds no socket at the agreed address and exposes no such telemetry) CANNOT produce
    And a real "work_done" for that work_id lands in the BC outbox via the real shop-msg / bc-emit path, so the terminal is proven by the real messaging surface rather than by a canned driver return
    And as the negative control, were the server stubbed or its bind address to disagree with the exported "FABRO_SERVER", the finite run would find no server to connect to at the agreed address and would reproduce the v0.3.68 failure — "Server already running (pid <n>)" with the child "exited 1", no telemetry-observed completed run, and no real "work_done" — so this scenario is RED against any stubbed or address-disagreeing server and GREEN only against the real running shared server
