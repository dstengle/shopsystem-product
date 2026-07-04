@bc:shopsystem-messaging @origin:lead-e9x
Feature: shop-msg read outbox — superseded under lead-e9x

  # Scenarios 81e8af96807f33f4, d3e94f098d60143f, 2cac6d6dba471090, and
  # c039ab184dd1bbb8 asserted lead-side read of BC outbox rows.  Under
  # lead-e9x, BC responses are routed to the lead inbox.  The lead reads
  # them via shop-msg read inbox --lead.  These scenarios are retired.
  # See features/respond_routes_to_lead_inbox.feature for the replacement.
