@bc:shopsystem-messaging @origin:adr-017
Feature: BC-side bead creation on inbox observation (PDR-010 ADR-017)

  @scenario_hash:ccffbe96781cd62e
  Scenario: shop-msg pending inbox --bc <name> on FIRST observation of an unprocessed inbox row creates a paired BC-side bead whose title is derived from the inbox payload's subject and whose type is derived from the inbox message_type
  Given a BC "shopsystem-messaging" with its own bd registry
  And a lead shop "shopsystem-product" has dispatched a request_bugfix to shopsystem-messaging via shop-msg send, producing a postgres inbox row at (bc=shopsystem-messaging, direction='inbox', work_id='lead-aaa', message_type='request_bugfix') carrying a payload whose description begins with "Fix the consume-asymmetry recovery for lead-nn5f"
  And NO existing BC-side bead in the shopsystem-messaging bd registry references work_id "lead-aaa"
  When the BC operator runs "shop-msg pending inbox --bc shopsystem-messaging" for the first time after the dispatch landed
  Then the command exits zero and lists the inbox row for work_id="lead-aaa"
  And a new BC-side bead has been created in the shopsystem-messaging bd registry, with id in the BC's local namespace (e.g., "shopsystem-messaging-{nanoid}")
  And the BC-side bead's title is "Fix the consume-asymmetry recovery for lead-nn5f" (or a truncated form thereof if bd's title length constraints apply), derived from the inbox payload's description field per ADR-017 decision 2
  And the BC-side bead's type is "bug" (the ADR-017 message_type→type mapping for request_bugfix), distinguishable from "feature" (assign_scenarios) or "task" (request_maintenance / nudge)
  And the BC-side bead's notes contain the cross-reference line "Lead work_id: lead-aaa" per ADR-017 decision 2
  And the load-bearing property pinned here is bead-creation-as-CLI-side-effect per ADR-017's 2026-05-29 revision and ADR-016 decision 2: the agent did NOT run "bd create" by hand; the shop-msg CLI did it as a side effect of pending-inbox observation

  @scenario_hash:217fb948804b29a3
  Scenario: the BC-side bead's id is in the BC's local bd namespace (NOT keyed on the lead's work_id) and the only cross-reference to the lead is the note "Lead work_id: <lead-X>"
  Given a BC "shopsystem-scenarios" with its own bd registry whose id prefix is "shopsystem-scenarios-"
  And a lead shop "shopsystem-product" has dispatched an assign_scenarios to shopsystem-scenarios producing a postgres inbox row at (bc=shopsystem-scenarios, direction='inbox', work_id='lead-bbb', message_type='assign_scenarios')
  When the BC operator runs "shop-msg pending inbox --bc shopsystem-scenarios" for the first time after the dispatch landed
  Then a new BC-side bead is created with id matching the pattern "shopsystem-scenarios-<nanoid>" (the BC's local namespace), NOT equal to "lead-bbb"
  And the BC-side bead's id is independent of the lead's work_id: a different BC's bead created for a different dispatch with the same work_id "lead-bbb" (impossible in practice since work_ids are unique, but the namespace would tolerate it) would also use the receiving BC's local namespace
  And the BC-side bead's notes contain exactly one line "Lead work_id: lead-bbb" linking back to the lead's dispatch
  And the BC-side bead's notes do NOT contain any other lead-bd field (no dispatched_to_bc, no scenario_hashes_pinned, no bc_origin_main_commit_at_dispatch — those are lead-side projection per ADR-011 and stay in the lead's bd, not mirrored to the BC bead)
  And the load-bearing property pinned here is per ADR-017 decision 3: the cross-reference between shops is by lead's work_id (carried in the BC bead's notes), NOT by BC bd id; the lead never learns the BC bead id and never needs to

  @scenario_hash:a7ec899eea0f970a
  Scenario: re-observation of the same inbox row is idempotent — "shop-msg pending inbox --bc <name>" called multiple times on a row whose BC-side bead has already been created does NOT create a duplicate bead
  Given a BC "shopsystem-messaging" with its own bd registry
  And a postgres inbox row at (bc=shopsystem-messaging, direction='inbox', work_id='lead-ccc', message_type='request_maintenance') has previously been observed by "shop-msg pending inbox --bc shopsystem-messaging", creating a paired BC-side bead with id "shopsystem-messaging-xyz" carrying the cross-reference "Lead work_id: lead-ccc"
  And the inbox row has NOT yet been responded to (the bead is still open in the BC's bd; the postgres inbox row is still unconsumed)
  When the BC operator runs "shop-msg pending inbox --bc shopsystem-messaging" a second time
  Then the command exits zero and lists the inbox row for work_id="lead-ccc" again (the row is still pending, observation does not consume it)
  And the BC-side bead count for cross-reference "Lead work_id: lead-ccc" in the shopsystem-messaging bd registry is exactly one (the pre-existing bead "shopsystem-messaging-xyz", NOT a new bead)
  And the existing bead's state (title, type, status, notes) is byte-for-byte unchanged
  And a third, fourth, fifth observation of the same inbox row similarly leave the bead count and bead state unchanged
  And the load-bearing property pinned here is idempotency on re-observation per ADR-017 decision 1 and ADR-016 decision 2: the CLI's side-effect is bead-creation-on-first-observation-only, with first-observation determined by the presence or absence of an existing BC-side bead carrying the matching "Lead work_id: <work_id>" cross-reference

  @scenario_hash:4dbddc9c5863ebe8
  Scenario: shop-msg respond clarify on the BC side updates the BC-side bead's status to blocked with an appended note summarizing the question raised, as a CLI-layer side effect of the same transactional boundary as the outbound emission
  Given a BC "shopsystem-messaging" with its own bd registry
  And a BC-side bead "shopsystem-messaging-xyz" exists with status="open" and cross-reference "Lead work_id: lead-ddd" (created on first observation of the inbox row for work_id="lead-ddd")
  When the BC operator runs "shop-msg respond clarify --bc shopsystem-messaging --work-id lead-ddd --question 'should the new field default to null or empty-string?'"
  Then the command exits zero
  And the BC-side bead "shopsystem-messaging-xyz" has its status flipped from "open" to "blocked" via bd_facade (per ADR-016 decision 4), as a CLI-layer side effect of the same shop-msg respond invocation
  And a note has been appended to the BC-side bead "shopsystem-messaging-xyz" summarizing the question raised (containing the substring "should the new field default to null or empty-string?")
  And the lead-side postgres inbox row at (bc=shopsystem-product, direction='inbox', work_id='lead-ddd', message_type='clarify') has been deposited carrying the question text
  And both the BC-bead status flip and the lead-inbox deposit are governed by ADR-012's atomicity protocol: a crash mid-respond leaves a recoverable partial state for the sweeper
  When the BC operator runs "shop-msg respond work_done --bc shopsystem-messaging --work-id lead-eee --status complete --summary 'shipped a89bc12'" against a different bead "shopsystem-messaging-www" with cross-reference "Lead work_id: lead-eee"
  Then the command exits zero and the BC-side bead "shopsystem-messaging-www" has its status flipped to "closed" per ADR-017 decision 4's mapping (work_done(complete) → closed)
  When the BC operator runs "shop-msg respond mechanism_observation --bc shopsystem-messaging --work-id lead-fff --note 'observed framework quirk: ...'"
  Then the command exits zero and the BC-side bead with cross-reference "Lead work_id: lead-fff" has its status unchanged but a note appended recording the observation per ADR-017 decision 4's mapping (mechanism_observation → unchanged + note)
  And the load-bearing property pinned here is the status-transition contract from ADR-017 decision 4 realized mechanically via ADR-016: clarify→blocked, work_done(complete)→closed, work_done(blocked)→blocked, mechanism_observation→unchanged-with-note; the agent does not run bd update by hand

  @scenario_hash:ad1054bc18951fec
  Scenario: the lead's bd does NOT acquire any reference to the BC bead's local id; the lead can grep its own bd for "shopsystem-messaging-{nanoid}" and find no matches, because loose cross-shop visibility (PDR-010 decision 4) is preserved
  Given a lead shop "shopsystem-product" with its own bd registry
  And a BC "shopsystem-messaging" with its own bd registry whose id prefix is "shopsystem-messaging-"
  And the lead has dispatched a request_bugfix to shopsystem-messaging producing a lead bd entry "lead-ggg" and a paired BC-side bead "shopsystem-messaging-zzz" (created on the BC's first pending-inbox observation per the scenarios above)
  And the BC has subsequently emitted work_done(complete) via "shop-msg respond work_done", which deposited a row in the lead's inbox AND flipped the BC bead "shopsystem-messaging-zzz" to closed per the status-transition contract
  And the lead has subsequently run "shop-msg consume outbox --bc shopsystem-messaging --work-id lead-ggg --message-type work_done", which flipped the lead bd entry "lead-ggg" to dispatch_state="consumed"
  When the lead architect inspects the lead bd entry "lead-ggg" via "bd show lead-ggg" and greps the lead's entire bd registry for any reference to "shopsystem-messaging-zzz" (the BC bead's local id)
  Then the lead bd entry "lead-ggg" carries no reference to "shopsystem-messaging-zzz" in any metadata field, any note, or any structured cross-reference
  And the lead's bd registry grep for "shopsystem-messaging-zzz" returns zero matches across all lead beads
  And the lead's view of the BC's work on lead-ggg is exactly the set of shop-msg emissions the BC has sent (the work_done row in the lead's inbox), projected into ADR-011's canonical field set on the lead bd entry — NOT a federated view of the BC's bd state
  And per ADR-017 decision 6, the lead does NOT pull BC bd state by any mechanism (no dolt-pull, no direct DB read, no filesystem inspection of .beads/); the BC bead id is invisible to the lead by construction
  And the load-bearing property pinned here is loose cross-shop visibility per PDR-010 decision 4: the shared work_id is the entire cross-shop contract; the BC bead id is a private detail of the BC and never crosses the boundary
