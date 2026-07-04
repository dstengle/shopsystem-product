@bc:shopsystem-templates @origin:lead-g72o
Feature: the pyproject version at a release-tagged commit equals the tag's version

  @scenario_hash:88a5418db371a12a
  Scenario Outline: the pyproject version at a release-tagged commit equals the tag's version, so an install from that tag reports the tag version in its dist metadata
    Given the shopsystem-templates repository has a release tag named "<tag>"
    And the commit that "<tag>" points at is checked out
    When I read the "version" field of "[project]" in "pyproject.toml" at that tagged commit
    And I "pip install" the shopsystem-templates distribution from that "<tag>" into a fresh environment
    Then the "pyproject.toml" "version" field at the tagged commit is exactly "<version>"
    And "<version>" equals "<tag>" with its leading "v" prefix removed
    And "importlib.metadata.version(\"shop-templates\")" in that environment returns exactly "<version>"
    And the "pip show shop-templates" output in that environment reports "Version: <version>"
    And the dist-metadata version does NOT lag the tag — the version field at the tagged commit is not an earlier release than "<version>"

    Examples:
      | tag     | version |
      | v0.21.0 | 0.21.0  |
      | v0.22.0 | 0.22.0  |
