@bc:shopsystem-bc-launcher @origin:lead-16zo
Feature: the baked BC standup beads self-heal produces a WORKING local current-schema beads DB at the remote-backed schema-skew wall WITHOUT the --discard-remote path, so relaunched BCs come up with live beads (durable P1 regression fix for lead-16zo)

  ROOT CAUSE (lead-16zo, P1, empirical 2026-07-13, messaging relaunch on
  bc-base v0.3.67): the baked lead-915f standup self-heal attempted its
  rebuild-from-jsonl but FAILED exit 10 — "remote has Dolt history and you
  selected local history without --discard-remote" — because it drove the
  "--discard-remote" branch of the remote-history guard. It left NO
  embeddeddolt, sync.remote still configured, and bd BROKEN. IMPACT: EVERY
  fleet BC relaunched on v0.3.67 came up with DEAD beads until manually healed.

  PROVEN WORKING APPROACH (the retired lead-side reference heal): TEMPORARILY
  STRIP sync.remote from ".beads/config.yaml" BEFORE "bd init --from-jsonl
  --reinit-local", which sidesteps the remote-history guard ENTIRELY — no
  "--discard-remote", no remote divergence — then RESTORE config. The self-heal
  rebuilds a purely LOCAL current-schema DB; the durable REMOTE reseed
  (scenario df748234563bdedb / lead-mv16 in
  standup_heals_beads_schema_wall_reseed_from_jsonl) stays DEFERRED on
  lead-tc38 behind the brokered-credential push.

  RELATIONSHIP TO THE EXISTING STANDUP-HEAL REGISTER: this SHARPENS scenario
  dc9a29a746921a14 in standup_heals_beads_schema_wall_reseed_from_jsonl,
  which pins THAT the heal rebuilds from
  ".beads/issues.jsonl" via "bd init --from-jsonl" and onlines with issue
  parity, but does NOT pin HOW the rebuild avoids the remote-history guard —
  the exact gap that regressed to exit 10. It is CONSISTENT WITH the lead-role
  refusal @scenario_hash:5765dd7d175901e3 (sole-clone invariant) and with the
  deferred-remote-reseed negative row of @scenario_hash:df748234563bdedb (the
  remote stays behind until the brokered path is wired). It ADDS the guard-
  avoidance behavior; it does not retire any existing pin.

  BEHAVIOR ALTITUDE: this pins the OBSERVABLE OUTCOME — a working local current-
  schema beads DB, "bd ready" green, committed-JSONL issue count preserved, no
  exit-10 guard failure, no remote divergence — WITHOUT prescribing the exact
  strip-then-restore code sequence (named above only as the proven reference).

  FIDELITY (ADR-018): binds to the standup's executable beads-provisioning
  self-heal orchestration — schema-skew detection, the guard-avoiding local
  rebuild ordering, and the post-heal "bd ready" green outcome — read against
  the create-bc / bc-container standup definition and the proven reference heal,
  NOT a live container or GitHub run.

  @scenario_hash:fdfaaa78dc322bbc
  Scenario: when the standup self-heal hits the remote-backed schema-skew wall it rebuilds a WORKING local current-schema beads DB WITHOUT the --discard-remote path and WITHOUT diverging the remote
    Given a BC standup clones a remote-backed beads DB whose Dolt data sits at an OLD schema behind the baked bd's CURRENT target schema, so "bd bootstrap" fails on the bd upstream #4259 migration refusal
    And the committed ".beads/issues.jsonl" carries a known issue count that is the schema-independent source of truth
    When the standup's beads self-heal runs against that remote-backed schema-skew wall
    Then the self-heal rebuilds a fresh local current-schema dolt DB from the committed ".beads/issues.jsonl" WITHOUT driving the "--discard-remote" branch, so it does NOT fail exit 10 on the "remote has Dolt history and you selected local history without --discard-remote" guard
    And after the heal "bd ready" exits zero so the BC comes up with LIVE beads rather than dead beads, and the rebuilt DB's issue count equals the count committed in ".beads/issues.jsonl" at the baked bd's CURRENT target schema
    And the heal reaches this working local state WITHOUT diverging the BC's beads remote — no history-replacing push and no "--discard-remote" — so the durable remote reseed (@scenario_hash:df748234563bdedb / lead-mv16) remains DEFERRED on lead-tc38 and every relaunch heals locally rather than re-breaking on the remote-history guard
