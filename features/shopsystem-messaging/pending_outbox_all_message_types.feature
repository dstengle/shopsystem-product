@bc:shopsystem-messaging @origin:lead-e9x
Feature: shop-msg pending outbox — superseded under lead-e9x

  # Scenarios b98f9d7c3f61435f and e6be1372adadc5e3 asserted that
  # shop-msg respond work_done writes a BC-outbox row visible via
  # pending outbox --lead.  Under lead-e9x, BC responses are routed to
  # the lead inbox (not the BC outbox).  These scenarios are retired.
  # See features/respond_routes_to_lead_inbox.feature for the replacement.
