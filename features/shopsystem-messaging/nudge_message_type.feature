@bc:shopsystem-messaging @origin:lead-1w7r
Feature: nudge message type for operational liveness (lead-1w7r clarify-resolution rewrite)

  @scenario_hash:1ff42687c2fe97c2
  Scenario: shop-msg nudge accepts each of the four reason enum values — stuck-on-you, status-check, predecessor-landed, general — and rejects any other reason value
  Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
  And a BC "shopsystem-messaging" registered in the messaging registry
  When the BC operator runs "shop-msg nudge --bc shopsystem-messaging --reason stuck-on-you --note 'waiting on lead to clarify scope'"
  Then the command exits zero and a nudge row is stored at (bc=shopsystem-product, direction='nudge') carrying reason="stuck-on-you"
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason status-check"
  Then the command exits zero and a nudge row is stored at (bc=shopsystem-messaging, direction='nudge') carrying reason="status-check"
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason predecessor-landed --work-id lead-001 --note 'lead-000 landed on origin/main'"
  Then the command exits zero and a nudge row is stored at (bc=shopsystem-messaging, direction='nudge') carrying reason="predecessor-landed" and work_id="lead-001"
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason general --note 'heads-up — see lead-xyz'"
  Then the command exits zero and a nudge row is stored at (bc=shopsystem-messaging, direction='nudge') carrying reason="general" and the note
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason wakeup-call --note 'please respond'"
  Then the command exits non-zero with an error message naming the invalid reason "wakeup-call" and listing the four valid reason enum values
  And the load-bearing property pinned here is that the reason enum is closed at exactly four values per ADR-015 decision 2; the CLI is the enforcement point

  @scenario_hash:4abbd813c588af06
  Scenario: shop-msg nudge with reason general REQUIRES --note; reasons stuck-on-you, status-check, and predecessor-landed accept but do not require --note
  Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
  And a BC "shopsystem-messaging" registered in the messaging registry
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason general" (with NO --note flag)
  Then the command exits non-zero with an error message naming --note as required when --reason=general
  And NO nudge row has been stored at (bc=shopsystem-messaging, direction='nudge')
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason status-check" (with NO --note flag)
  Then the command exits zero and a nudge row is stored at (bc=shopsystem-messaging, direction='nudge') carrying reason="status-check" with an empty/absent note field
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason stuck-on-you" (with NO --note flag)
  Then the command exits zero and a nudge row is stored at (bc=shopsystem-messaging, direction='nudge') carrying reason="stuck-on-you" with an empty/absent note field
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason predecessor-landed --work-id lead-002" (with NO --note flag)
  Then the command exits zero and a nudge row is stored at (bc=shopsystem-messaging, direction='nudge') carrying reason="predecessor-landed", work_id="lead-002", and an empty/absent note field
  And the load-bearing property pinned here is that --note is mandatory only for the catchall reason "general" (where the reason itself communicates no semantics), and is opportunistic for the three semantic reasons (where the reason itself communicates the meaning)

  @scenario_hash:9d0aee49dc348092
  Scenario: a nudge sent against an existing work_id does NOT change the lead bd entry's dispatch_state — the bd record receives only an appended note via bd_facade.append_note (per ADR-015 decision 6, ADR-016 decision 2, and lead-1w7r clarify-resolution)
  Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
  And a BC "shopsystem-messaging" registered in the messaging registry
  And a lead bd entry "lead-003" exists at dispatch_state="dispatched" (the original dispatch is in-flight; BC has not yet emitted)
  And no inbox row exists for (bc=shopsystem-messaging, work_id="lead-003", direction='inbox') beyond the original assign_scenarios dispatch row
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --work-id lead-003 --reason status-check"
  Then the command exits zero
  And a nudge row is stored at (bc=shopsystem-messaging, work_id="lead-003", direction='nudge', message_type='nudge') carrying reason="status-check"
  And the original direction='inbox' assign_scenarios row for (bc=shopsystem-messaging, work_id="lead-003") is unchanged — its message_type, payload, and created_at are byte-identical to its pre-nudge state
  And the lead bd entry "lead-003" has dispatch_state STILL equal to "dispatched" (no transition has occurred; nudge does NOT touch this field)
  And bd_facade.append_note has been invoked exactly once against work_id="lead-003" with a text payload containing the substring "nudge: reason=status-check work_id=lead-003 at=" followed by an ISO-8601 UTC timestamp
  And no other ADR-011 canonical field has been mutated by the nudge (dispatched_to_bc, dispatch_message_type, scenario_hashes_pinned, etc. are all unchanged)
  And the load-bearing property pinned here is the dispatch-lifecycle invariance from ADR-015 decision 6 plus the lead-1w7r keying decision: nudge storage at direction='nudge' is orthogonal to the direction='inbox' dispatch-row invariants; the lifecycle remains driven by assign_scenarios / request_bugfix / request_maintenance → work_done per §6 of the spec

  @scenario_hash:eab77aec3540e2bf
  Scenario: shop-msg nudge rejects a payload carrying a scenario_hashes field; the nudge message type is transmission-layer only, not scenario state (adversarial — payload schema enforcement)
  Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
  And a BC "shopsystem-messaging" registered in the messaging registry
  And a payload file at "/tmp/bad-nudge-payload.yaml" containing reason="general", note="see scenarios", AND a scenario_hashes field with one or more hex values
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason general --note 'see scenarios' --payload /tmp/bad-nudge-payload.yaml"
  Then the command exits non-zero with an error message naming the rejected field "scenario_hashes" and explaining that nudge MUST NOT carry scenario state per ADR-015 decision 7
  And NO nudge row has been stored at (bc=shopsystem-messaging, direction='nudge')
  And NO lead bd entry has been mutated as a result of this attempted send
  And the load-bearing property pinned here is that nudges are purely transmission-layer per ADR-015 decision 7: a nudge that references a work_id references the dispatch lifecycle by ID only and makes no claim about scenario coverage; the payload schema validation enforces this at the CLI surface

  @scenario_hash:e236edb2eee6101c
  Scenario: a second status-check nudge against the same (bc, work_id) is storable — direction='nudge' admits multiple nudges to the same (bc, work_id) without collision; this is the load-bearing property pinned by lead-1w7r clarify-resolution decision 1
  Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
  And a BC "shopsystem-messaging" registered in the messaging registry whose pipeline is currently against work_id "lead-004"
  And a lead bd entry "lead-004" exists at dispatch_state="dispatched"
  And the lead operator has previously sent a status-check nudge: "shop-msg send nudge --bc shopsystem-messaging --reason status-check --work-id lead-004" producing a stored nudge row at (bc=shopsystem-messaging, work_id="lead-004", direction='nudge', message_type='nudge', reason='status-check')
  When the lead operator runs "shop-msg send nudge --bc shopsystem-messaging --reason status-check --work-id lead-004" a SECOND time
  Then the command exits zero
  And a second nudge row is stored at (bc=shopsystem-messaging, work_id="lead-004", direction='nudge', message_type='nudge', reason='status-check') distinguished from the first by its keying discriminator (created_at, sequence, uuid — implementation choice)
  And the original direction='inbox' dispatch row for (bc=shopsystem-messaging, work_id="lead-004") is unchanged across both nudge sends
  And bd_facade.append_note has been invoked twice against work_id="lead-004" — once per nudge — each carrying a text payload of the canonical form "nudge: reason=status-check work_id=lead-004 at=<iso8601_utc>"
  And the load-bearing property pinned here is the lead-1w7r decision 1 keying invariant: direction='nudge' storage admits multiple nudges per (bc, work_id) without colliding against the dispatch-row one-message-per-(bc,work_id,direction='inbox') invariant; receiver-reply behavior (whether and how the BC responds) is NOT pinned by this scenario — it is primer-prose territory per lead-1w7r decision 3

  @scenario_hash:4cc30de340d8f3ac
  Scenario: a nudge whose note contains a structured architectural question is accepted, deposited, and recorded via bd_facade.append_note with the canonical nudge note format — no channel-misuse classifier is invoked at the CLI surface
  Given a lead shop "shopsystem-product" registered as the lead in the messaging registry
  And a BC "shopsystem-messaging" registered in the messaging registry
  And a lead bd entry "lead-005" exists at dispatch_state="dispatched"
  When the BC operator runs "shop-msg nudge --bc shopsystem-messaging --work-id lead-005 --reason general --note 'should the new field default to null or to empty-string? this is architecturally load-bearing for downstream consumers and i need a decision before i can proceed'"
  Then the command exits zero
  And a nudge row is stored at (bc=shopsystem-product, work_id="lead-005", direction='nudge', message_type='nudge', reason='general') carrying the note text byte-for-byte
  And bd_facade.append_note has been invoked exactly once against work_id="lead-005" with a text payload containing the substring "nudge: reason=general work_id=lead-005 at=" followed by an ISO-8601 UTC timestamp
  And the appended note text does NOT contain any channel-misuse advisory clause — per lead-1w7r clarify-resolution decision 2 the channel-misuse classifier is dropped entirely from the CLI surface (operator-discipline territory, not pinned by scenario)
  And the lead bd entry "lead-005" has dispatch_state STILL equal to "dispatched"
  And the load-bearing property pinned here is that the messaging BC's responsibility ends at delivery + bd note appending in the canonical format; no prose-detection heuristic is invoked at the CLI surface
