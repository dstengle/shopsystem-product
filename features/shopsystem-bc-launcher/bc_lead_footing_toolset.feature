@bc:shopsystem-bc-launcher @origin:lead-ae4h
Feature: bc-lead image carries footing prerequisites (docker compose plugin + dolt) (lead-ys8x)

  The published shopsystem-bc-lead image is the runway footing bootstraps on
  (lead-ae4h).  Footing runs `docker compose -f compose.yaml up -d` and
  `bd dolt push`, so the bc-lead image must carry BOTH the docker compose
  plugin and the dolt engine binary in addition to the docker CLI it already
  has.  docker is NOT available in this environment, so these scenarios are
  bound to the buildable-artifact source of truth: the committed
  docker/bc-lead/Dockerfile must install docker-compose-plugin and the dolt
  binary onto PATH.  The live `docker compose version` / `dolt version` proof
  on the rebuilt published image is the lead's post-release pull verification.

  @scenario_hash:c5edfa89da00af8a
  Scenario: the published bc-lead image carries the docker compose plugin so docker compose succeeds
    Given the published image "ghcr.io/dstengle/shopsystem-bc-lead:latest"
    When the image is run via "docker run --rm <image> docker compose version"
    Then "docker compose version" exits zero and prints the installed Compose plugin version
    And "docker compose version" does not fail with "docker: unknown command: docker compose"
    And running "docker compose -f compose.yaml up -d postgres agent-vault" inside the image does not fail with "unknown shorthand flag: 'f'" due to a missing compose subcommand

  @scenario_hash:98a0683d0360349e
  Scenario: the published bc-lead image carries the dolt binary so bd dolt operations resolve
    Given the published image "ghcr.io/dstengle/shopsystem-bc-lead:latest"
    When the image is run via "docker run --rm <image> dolt version"
    Then "dolt version" exits zero and prints the installed dolt version
    And "command -v dolt" run inside the image resolves dolt on PATH and exits zero
    And "bd dolt push" run inside the image does not fail because the dolt engine binary is absent from PATH

  @scenario_hash:a0992b2156d132e3
  Scenario: the bc-lead image footing runs on carries both the docker compose plugin and the dolt binary
    Given the published image "ghcr.io/dstengle/shopsystem-bc-lead:latest" that the footing bootstrap runway runs on
    When the image is inspected by running "docker compose version", "dolt version", and "command -v dolt" inside it
    Then "docker compose version" exits zero so the footing step "docker compose -f compose.yaml up -d postgres agent-vault" can run
    And "dolt version" exits zero and "command -v dolt" resolves dolt on PATH so the footing step "bd dolt push" can run
    And neither the docker compose plugin nor the dolt binary is absent from the image footing runs on
