@bc:shopsystem-messaging @origin:brief-001 @service:postgres
Feature: shop-msg watch — Monitor-compatible inbox watcher

  @scenario_hash:6608b5930d786134
Scenario: shop-msg watch drains unprocessed inbox messages on startup before entering the live listen loop
  Given an empty BC at a temporary path
  And shop-msg send assign_scenarios was previously used to write an inbox message with work-id "lead-100"
  And shop-msg send request_bugfix was previously used to write an inbox message with work-id "lead-101"
  When I run shop-msg watch in the background
  Then before the process enters the LISTEN loop, it outputs one line for work_id "lead-100"
  And it outputs one line for work_id "lead-101"

  @scenario_hash:cf3b43277fa2f513
Scenario: shop-msg watch outputs one line to stdout when a new message is inserted into the inbox after startup drain
  Given an empty BC at a temporary path with no unprocessed inbox messages
  And shop-msg watch is running in the background and has completed its startup drain
  When a new assign_scenarios message with work-id "lead-200" is inserted into the inbox
  Then shop-msg watch outputs exactly one line to stdout for work_id "lead-200"
  And no additional output line arrives within 2 seconds

  @scenario_hash:026511527a9c6f50
Scenario: Each line output by shop-msg watch contains the work_id and message_type of the event
  Given an empty BC at a temporary path
  And shop-msg send request_maintenance was previously used to write an inbox message with work-id "lead-300"
  When I run shop-msg watch in the background and it outputs the startup drain line for "lead-300"
  Then that output line contains the text "lead-300"
  And that output line contains the text "request_maintenance"
  And the entire event is contained on a single line of stdout

  @scenario_hash:04b5c993cd179d9c
Scenario: shop-msg watch remains running when there are no pending messages and no new notifications arrive
  Given an empty BC at a temporary path with no unprocessed inbox messages
  When I run shop-msg watch in the background and wait for startup drain to complete
  Then the process has not exited after 2 seconds of inactivity
  And no output lines have been written to stdout during that idle period

  @scenario_hash:f5384d7de261fba6
Scenario: shop-msg watch exits non-zero with a message naming the DSN when the database is unreachable at startup
  Given a BC at a temporary path
  And the environment variable SHOPMSG_DSN is set to an address where no Postgres instance is listening
  When I run shop-msg watch
  Then the command exits non-zero
  And stderr contains the DSN value from SHOPMSG_DSN
