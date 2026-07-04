@bc:shopsystem-messaging @origin:lead-e9x @service:postgres
Feature: shop-msg watch — lead and BC inbox watching

  # Scenarios 2c21b60536c8f493 and 72c3cf64c7463208 previously asserted that
  # shop-msg respond fires a NOTIFY on the BC outbox channel and that
  # shop-msg watch --lead listens on BC outbox channels.  Under lead-e9x,
  # shop-msg respond fires a NOTIFY on the LEAD's inbox channel and
  # shop-msg watch --lead listens on the lead's inbox channel.
  # These two scenarios are retired; see
  # features/respond_routes_to_lead_inbox.feature for the replacement.

  @scenario_hash:ea19b835157f8a69
Scenario: shop-msg watch --bc behavior is unchanged after outbox routing change
  Given an empty BC at a temporary path with no unprocessed inbox messages
  And shop-msg watch --bc is running in the background and has completed its startup drain
  When a new assign_scenarios message with work-id "lead-302" is inserted into the inbox
  Then shop-msg watch --bc outputs exactly one line to stdout for work_id "lead-302"
  And no additional output line arrives within 2 seconds
