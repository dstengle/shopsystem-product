@bc:shopsystem-messaging @origin:brief-001 @service:postgres
Feature: shop-msg watch — bounded reconnect on LISTEN connection drop

  Background:
    Given the reconnect backoff sleep is stubbed to be instant

  @scenario_hash:2426b67df01d4168
  Scenario Outline: A mid-notifies connection drop emits a LISTEN_DROP line then reconnects and resumes
    Given a <flavor> watcher whose LISTEN connection drops once mid-notifies then recovers
    When the watcher runs
    Then the watcher output includes at least one "LISTEN_DROP attempt=" line
    And the watcher output includes a "LISTEN_RECONNECTED" line
    And the watcher resumes printing notifications after reconnecting

    Examples:
      | flavor |
      | lead   |
      | bc     |

  @scenario_hash:641bae76c069bf5b
  Scenario Outline: When all five reconnect attempts fail the watcher exits code 2 with a stderr failure line
    Given a <flavor> watcher whose LISTEN connection drops and never recovers
    When the watcher runs
    Then the watcher output includes 5 "LISTEN_DROP attempt=" lines
    And the watcher LISTEN_DROP lines report backoffs 1s, 2s, 4s, 8s, 16s in order
    And the watcher stderr contains "could not reconnect after 5 attempts"
    And the watcher exits with code 2

    Examples:
      | flavor |
      | lead   |
      | bc     |

  @scenario_hash:3df3c5993a4f60e5
  Scenario Outline: The post-reconnect path does not re-print already-drained work_ids
    Given a <flavor> inbox pre-seeded with a message for work_id "lead-seed-1"
    And a <flavor> watcher whose LISTEN connection drops once mid-notifies then recovers
    When the watcher runs
    Then the watcher output includes "READY" preceded by a line for work_id "lead-seed-1"
    And the watcher output after the LISTEN_RECONNECTED line does not include work_id "lead-seed-1"

    Examples:
      | flavor |
      | lead   |
      | bc     |
