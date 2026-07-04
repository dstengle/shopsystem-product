@bc:shopsystem-bc-launcher @origin:brief-004
Feature: bc-container commands

  @scenario_hash:f8be355d65de7374
  Scenario: bc-container launch starts a Docker container for the named BC
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container launch with BC name "shopsystem-messaging" and a valid repo URL
    Then the command exits zero
    And a Docker container named "bc-shopsystem-messaging" is running

  @scenario_hash:d9dc0a051d536c3b
  Scenario: bc-container launch clones the BC repository inside the container
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    When I run bc-container launch with BC name "shopsystem-messaging"
    And the container starts
    Then the repository is cloned into the container's workspace directory
    And the cloned directory contains a git repository for "shopsystem-messaging"

  # lead-ezzr SUPERSEDES the prior `bd dolt pull` mechanism (old
  # @scenario_hash dee72338aaa9b96c).  The launcher must provision the
  # in-container beads tracker via `bd bootstrap` (which imports the
  # git-tracked .beads/issues.jsonl and creates the embedded-Dolt working
  # set) and must NOT run `bd dolt pull` first — a pre-`bd dolt pull` empty
  # DB wedges bootstrap into a no-op (the self-inflicted lead-vlsu deadlock).
  @scenario_hash:de59d9569c928ac2
  Scenario: bc-container launch provisions beads via bd bootstrap inside the container
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    When I run bc-container launch with BC name "shopsystem-messaging"
    And the container has cloned the repository
    Then bd bootstrap has been run inside the container's workspace directory
    And bd dolt pull has NOT been run inside the container's workspace directory
    And a .beads directory exists inside the container at the workspace root

  @scenario_hash:04236074a60ffcd7
  Scenario: bc-container launch starts a named tmux session inside the container
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container launch with BC name "shopsystem-messaging"
    And the container starts
    Then a tmux session named "agent" exists inside the container "bc-shopsystem-messaging"

  @scenario_hash:f79d1838ca9dbd89
  Scenario: bc-container launch reports state instead of starting a second container when the BC is already running
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is already running
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the command exits zero
    And stdout reports that "bc-shopsystem-messaging" is already running
    And exactly one Docker container named "bc-shopsystem-messaging" is running

  @scenario_hash:7b53b8d069db187b
  Scenario: bc-container attach connects to the running BC container's tmux session
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running
    And a tmux session named "agent" exists inside the container
    When I run bc-container attach with BC name "shopsystem-messaging"
    Then the command executes docker exec -it bc-shopsystem-messaging tmux attach-session -t agent

  @scenario_hash:09d09f7d3bf3495d
  Scenario: bc-container monitor streams the BC container's tmux session output to host stdout
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running
    And a tmux session named "agent" exists inside the container containing the text "beads primed"
    When I run bc-container monitor with BC name "shopsystem-messaging"
    Then the command exits zero
    And stdout includes the text "beads primed"

  @scenario_hash:05b93eda8268ee7c
  Scenario: bc-container stop stops the named BC container
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container stop with BC name "shopsystem-messaging"
    Then the command exits zero
    And no Docker container named "bc-shopsystem-messaging" is running

  @scenario_hash:19cc8ce4a71b5ce1
  Scenario: bc-container status reports running state for a running BC container
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running
    And a tmux session named "agent" exists inside the container
    When I run bc-container status with BC name "shopsystem-messaging"
    Then the command exits zero
    And stdout includes the BC name "shopsystem-messaging"
    And stdout includes the container state "running"
    And stdout includes the tmux session state "active"

  @scenario_hash:4b931832ce83b2f8
  Scenario: bc-container status reports stopped state for a stopped BC container
    Given the shopsystem-bc-launcher BC is installed
    And no Docker container named "bc-shopsystem-messaging" is running
    When I run bc-container status with BC name "shopsystem-messaging"
    Then the command exits zero
    And stdout includes the BC name "shopsystem-messaging"
    And stdout includes the container state "stopped"

  @scenario_hash:43fae05b4ad39eb3
  Scenario: bc-container list shows all known BC containers with their states
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running
    And a Docker container named "bc-shopsystem-scenarios" is stopped
    When I run bc-container list
    Then the command exits zero
    And stdout includes an entry for "shopsystem-messaging" with state "running"
    And stdout includes an entry for "shopsystem-scenarios" with state "stopped"

  @scenario_hash:e4c8b28ab3985200
  Scenario: bc-container launch propagates SHOPMSG_DSN to the container via the docker run -e flag
    Given the shopsystem-bc-launcher BC is installed
    And SHOPMSG_DSN is set to "postgresql://postgres:postgres@localhost:5432/shopsystem"
    And the FakeDockerDriver is active
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "-e SHOPMSG_DSN=postgresql://postgres:postgres@localhost:5432/shopsystem"
    And the command exits zero

  @scenario_hash:a06225046b2828c0
  Scenario: bc-container launch forwards the exact SHOPMSG_DSN value from the host environment to the container
    Given the shopsystem-bc-launcher BC is installed
    And SHOPMSG_DSN is set to "postgresql://customhost:5432/mydb"
    And the FakeDockerDriver is active
    When I run bc-container launch with BC name "shopsystem-messaging"
    Then the FakeDockerDriver records that the docker run command for "bc-shopsystem-messaging" includes the flag "-e SHOPMSG_DSN=postgresql://customhost:5432/mydb"
    And the command exits zero

  @scenario_hash:a876c34e9c93ee43
  Scenario: bc-container is available on PATH after installing the shopsystem-bc-launcher package
    Given the shopsystem-bc-launcher BC package is installed in a Python environment
    When bc-container --help is executed in that environment
    Then the command exits zero
    And stdout includes the top-level subcommand names launch, attach, inject, monitor, stop, status, and list

  @scenario_hash:d43c07318eba1402
  Scenario: shop-msg sent from the host is receivable by the BC agent inside the container
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running on the shared Docker network
    And the container has SHOPMSG_DSN set to the shared PostgreSQL instance
    When I run shop-msg send assign_scenarios on the host with work-id "lead-500" targeting the "shopsystem-messaging" BC
    Then the command exits zero
    And running shop-msg pending inside the container reports work-id "lead-500" as pending

  @scenario_hash:0d573c8426c8ced7
  Scenario: shop-msg response written inside the BC container is readable from the host
    Given the shopsystem-bc-launcher BC is installed
    And a Docker container named "bc-shopsystem-messaging" is running on the shared Docker network
    And the container has SHOPMSG_DSN set to the shared PostgreSQL instance
    And an inbox message with work-id "lead-500" exists in the shared PostgreSQL backend
    When shop-msg respond work_done is run inside the container with work-id "lead-500"
    Then running shop-msg read outbox on the host with work-id "lead-500" exits zero
    And stdout includes message_type "work_done"

  @scenario_hash:6bdb4802f57c1afb
  Scenario: The BC container does not have access to sibling BC source trees or the lead shop workspace
    Given the shopsystem-bc-launcher BC is installed
    And a temporary directory is created on the host as a candidate sibling mount
    And bc-container launch is run with BC name "shopsystem-messaging"
    And the container "bc-shopsystem-messaging" is running
    When the container's filesystem mounts are inspected
    Then the only bind mounts inside the container are the BC's own repository mount
    And no bind mount inside the container has the candidate directory as its source
