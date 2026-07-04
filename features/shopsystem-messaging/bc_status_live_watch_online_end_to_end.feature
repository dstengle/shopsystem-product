@bc:shopsystem-messaging @origin:lead-bppa @service:postgres
Feature: bc-status reads a live heartbeating watch as online end-to-end

  @scenario_hash:e7c14f54c3100ce5
  Scenario: a live connected shop-msg watch whose heartbeat tick is current is reported online by shop-msg bc-status end-to-end, and offline only when no current heartbeat exists
  Given a messaging postgres database with a bc_presence table at schema (bc_name TEXT PRIMARY KEY, last_seen_at TIMESTAMPTZ NOT NULL, watch_session_id UUID NOT NULL)
  And NO existing bc_presence row for bc_name "shopsystem-live"
  And a "shop-msg watch --bc shopsystem-live" process that is connected with its postgres LISTEN established and its 30-second heartbeat tick loop actively running
  When the watch process has completed at least one heartbeat tick within the last 30 seconds and the lead operator runs "shop-msg bc-status --bc shopsystem-live" while that watch process is still live and connected
  Then the command exits zero and emits exactly one row for "shopsystem-live" classified as "online" with a seconds-since-last-seen value under 90
  And the online classification is derived solely from the age of the bc_presence row's last_seen_at written by the live watch process, not from any separate liveness probe, so a watch that is connected and heartbeating within the last 90 seconds is ALWAYS reported online and is NEVER reported offline
  And when that same watch process is then stopped so that no heartbeat tick fires for more than 5 minutes, a subsequent "shop-msg bc-status --bc shopsystem-live" reclassifies "shopsystem-live" as "offline" with a seconds-since-last-seen value over 300
  And the load-bearing property pinned here is the end-to-end coupling that closes the false-offline defect: an actually-live, connected, heartbeating watch yields an online bc-status reading, and the offline reading is emitted only in the absence of a current heartbeat, never while a live watch is heartbeating
