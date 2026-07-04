@bc:shopsystem-bc-launcher @origin:adr-021
Feature: bc-base image build and publish artifacts (lead-yy30 / lead-yk3o)

  The shopsystem-bc-base image is built from a committed Dockerfile and
  published to ghcr by committed GitHub Actions workflows.  Per the architect
  ruling on lead-yk3o (grounded in ADR-021 + ADR-018 + the scenario-40
  declarative-shape precedent), live registry / live Actions / credential
  state is OUT-OF-BAND and is NOT asserted in-suite: these scenarios pin the
  committed Dockerfile and workflow YAML as DECLARATIVE ARTIFACTS via
  structural file-tree and YAML inspection.

  @scenario_hash:d9909f38abea83b5
  Scenario: the bc-launcher repository contains the Dockerfile that builds the bc-base image
    Given the shopsystem-bc-launcher BC repository
    When the repository file tree is inspected
    Then a Dockerfile that builds the shopsystem-bc-base image exists at a tracked path within the bc-launcher repository
    And that Dockerfile installs the framework utility CLIs from their VCS or published-package version pins in the "github.com/dstengle/<utility> @ vMAJOR.MINOR.PATCH" shape rather than from an editable clone

  @scenario_hash:b688a5feaf1cf34a
  Scenario: when a "vMAJOR.MINOR.PATCH" tag is pushed to the bc-launcher repository, the bc-base image is built and published to ghcr with that version tag and "latest", public
    Given a tag named "v0.2.0" is pushed to the "main" branch of the shopsystem-bc-launcher source repository
    When the bc-launcher publish workflow associated with that tag push completes successfully
    Then the registry "ghcr.io" exposes an image manifest at the repository path "dstengle/shopsystem-bc-base" reachable by the image tag "v0.2.0"
    And the registry "ghcr.io" exposes an image manifest at the repository path "dstengle/shopsystem-bc-base" reachable by the image tag "latest" pointing to the same digest as the "v0.2.0" tag
    And both image tags can be pulled by an unauthenticated "docker pull" client because the package is published with public visibility

  @scenario_hash:4e470f7584650a2d
  Scenario: an inbound repository_dispatch event to the bc-launcher repository rebuilds bc-base and republishes the latest tag to the new digest
    Given the shopsystem-bc-launcher BC repository
    And the image tag "latest" at "ghcr.io/dstengle/shopsystem-bc-base" currently points to a digest "D_old"
    When a "repository_dispatch" event is delivered to the bc-launcher repository and the bc-launcher build workflow runs to successful completion in response to that event
    Then a new bc-base image is built that installs the current framework utility versions producing a digest "D_new" distinct from "D_old"
    And the registry "ghcr.io" exposes the image tag "latest" at the repository path "dstengle/shopsystem-bc-base" pointing to "D_new"

  @scenario_hash:be11d615375564e1
  Scenario: republishing a prior known-good digest as the latest tag makes latest resolve to that earlier digest
    Given the registry "ghcr.io/dstengle/shopsystem-bc-base" holds a prior known-good build pullable by its digest "D_good"
    And the "latest" tag currently points to a later digest "D_bad"
    When the "latest" tag is republished to point at the existing digest "D_good"
    Then the registry exposes the image tag "latest" at the repository path "dstengle/shopsystem-bc-base" pointing to "D_good"
    And no new image build is required because "D_good" is an already-published digest re-tagged in place
