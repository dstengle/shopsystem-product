@bc:shopsystem-bc-launcher @origin:lead-dqje
Feature: the centralized bc-base poll treats the bc-launcher self-pin as a polled dependency (lead-dqje / lead-5yql)

  @scenario_hash:493bbbb7dcb61d7e
  Scenario: the centralized poll treats the bc-launcher self-pin as a polled dependency and bumps it when stale then rebuilds
    Given the bc-base Dockerfile in shopsystem-bc-launcher pins shopsystem-bc-launcher itself at "@v0.3.9" in a "git+https://github.com/dstengle/shopsystem-bc-launcher" VCS pin
    And the centralized scheduled workflow resolves shopsystem-bc-launcher's own latest release tag against its canonical repository "dstengle/shopsystem-bc-launcher" using the workflow's own "GITHUB_TOKEN"
    And the resolved latest release tag for shopsystem-bc-launcher is "@v0.4.0", newer than the self-pin "@v0.3.9"
    When the workflow runs its check-bump-rebuild cycle
    Then the workflow's executable body, with YAML comment lines excluded, enumerates shopsystem-bc-launcher mapped to canonical repository "dstengle/shopsystem-bc-launcher" alongside the existing baked dependencies
    And a shopsystem-bc-launcher self-pin enumerated only in a descriptive YAML comment, absent from the executable body, does not satisfy this lookup
    And the lookup does not reference a "BC_LAUNCHER_DISPATCH_TOKEN" or any other cross-repo dispatch credential
    And the workflow first mutates "docker/bc-base/Dockerfile" so the shopsystem-bc-launcher self-pin reads "@v0.4.0" rather than "@v0.3.9"
    And only after the self-pin is bumped does the workflow run the bc-base image build
    And the workflow commits the bumped "docker/bc-base/Dockerfile" recording the shopsystem-bc-launcher version "@v0.4.0" before the build
    And the workflow republishes "ghcr.io/dstengle/shopsystem-bc-base:latest" at the new digest built from the bumped Dockerfile
    And this self-pin handling composes with the existing baked-dependency checks rather than replacing them

  @scenario_hash:e28886c34b0d4c65
  Scenario: when the bc-launcher self-pin already equals bc-launcher's latest release the poll makes no change for it
    Given the bc-base Dockerfile in shopsystem-bc-launcher pins shopsystem-bc-launcher itself at "@v0.4.0" in a "git+https://github.com/dstengle/shopsystem-bc-launcher" VCS pin
    And the centralized scheduled workflow resolves shopsystem-bc-launcher's own latest release tag against "dstengle/shopsystem-bc-launcher" as "@v0.4.0"
    And the resolved latest release tag for shopsystem-bc-launcher equals the self-pin already in the Dockerfile
    When the workflow runs its check-bump-rebuild cycle and no other baked dependency is stale
    Then the workflow leaves the shopsystem-bc-launcher self-pin in "docker/bc-base/Dockerfile" unchanged at "@v0.4.0"
    And the workflow does not run a bc-base image build on account of the self-pin
    And the workflow does not republish "ghcr.io/dstengle/shopsystem-bc-base:latest" with a new digest on account of the self-pin
