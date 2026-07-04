@bc:shopsystem-bc-launcher @origin:brief-005
Feature: bc-container manifest commands

  @scenario_hash:fa53883f96aa86ad
  Scenario: the manifest file exists at bc-manifest.yaml in the lead repo root
    Given a manifest file exists at the path "bc-manifest.yaml" relative to the lead repo root
    When I look for the file at that path
    Then the file is present
    And the file is not gitignored
    And the file is committed in version control

  @scenario_hash:d417aa401482ab1e
  Scenario: the manifest file is syntactically valid
    Given a manifest file exists at the path "bc-manifest.yaml" relative to the lead repo root
    When I run "bc-container manifest validate" against that path
    Then the command exits zero
    And the output reports the manifest as syntactically valid

  @scenario_hash:c1ab30c61382f5ca
  Scenario: the manifest file contains entries for all current product BCs
    Given a manifest file exists at the path "bc-manifest.yaml" relative to the lead repo root
    When a script parses the manifest file using a standard library YAML parser
    Then the parsed result contains an entry for "shopsystem-messaging"
    And the parsed result contains an entry for "shopsystem-scenarios"
    And the parsed result contains an entry for "shopsystem-templates"
    And the parsed result contains an entry for "shopsystem-test-harness"
    And the parsed result contains an entry for "shopsystem-devcontainer"
    And the parsed result contains an entry for "shopsystem-bc-launcher"

  @scenario_hash:3538c352be34f1bf
  Scenario: each BC entry in the manifest has a canonical name field
    Given a manifest file exists at the path "bc-manifest.yaml" relative to the lead repo root
    When a script parses the manifest file using a standard library YAML parser
    Then every BC entry has a non-empty canonical name field
    And every canonical name follows the "shopsystem-<identifier>" pattern

  @scenario_hash:c873191be19442f6
  Scenario: each BC entry in the manifest has a GitHub remote URL field
    Given a manifest file exists at the path "bc-manifest.yaml" relative to the lead repo root
    When a script parses the manifest file using a standard library YAML parser
    Then every BC entry has a non-empty GitHub remote URL field
    And every remote URL is a valid GitHub HTTPS or SSH URL

  @scenario_hash:64fc803688c37e43
  Scenario: each BC entry in the manifest has a role label field
    Given a manifest file exists at the path "bc-manifest.yaml" relative to the lead repo root
    When a script parses the manifest file using a standard library YAML parser
    Then every BC entry has a non-empty role label field
    And the role label for each current product BC is "bc"

  @scenario_hash:577a8998029fbb2f
  Scenario: the validate command rejects a manifest entry missing a required field
    Given a manifest file where one BC entry is missing its GitHub remote URL field
    When I run "bc-container manifest validate" against that manifest
    Then the command exits non-zero
    And the output names the BC entry that is missing the required field
    And the output names the missing field

  @scenario_hash:3de986a7ce6d7471
  Scenario: adding a BC to the manifest makes it visible to the list command
    Given a manifest file contains five BC entries
    When I add a new BC entry with canonical name "shopsystem-new-bc", a valid GitHub remote URL, and role label "bc"
    And I run "bc-container manifest list" against that manifest
    Then the output includes "shopsystem-new-bc"
    And the output includes the GitHub remote URL for "shopsystem-new-bc"

  @scenario_hash:9d6c4f90e4596c72
  Scenario: the validate command accepts a manifest with a newly added BC entry
    Given a manifest file contains a new BC entry with all required fields present
    And a FakeGitHubDriver is configured to report the declared remote URL as reachable
    When I run "bc-container manifest validate" against that manifest
    Then the command exits zero
    And the output reports the new BC entry as valid

  @scenario_hash:b0ec81fc3bb74b87
  Scenario: removing a BC from the manifest makes it absent from the list command
    Given a manifest file contains an entry for "shopsystem-decommissioned-bc"
    When I remove the entry for "shopsystem-decommissioned-bc" from the manifest file
    And I run "bc-container manifest list" against that manifest
    Then the output does not include "shopsystem-decommissioned-bc"

  @scenario_hash:ead00bbc23185040
  Scenario: the sync command reports a repos directory entry that is not in the manifest
    Given a manifest file does not contain an entry for "shopsystem-decommissioned-bc"
    And a directory named "shopsystem-decommissioned-bc" is present under the repos directory
    When I run "bc-container manifest validate" against that manifest
    Then the command exits non-zero
    And the output reports "shopsystem-decommissioned-bc" as an unexpected entry in the repos directory
    And the command does not delete the unexpected directory

  @scenario_hash:67394ebfa93c3074
  Scenario: the list command emits one line per BC declared in the manifest
    Given a manifest file contains entries for six BCs
    When I run "bc-container manifest list" against that manifest
    Then the output contains exactly six lines
    And each line contains the canonical name of one declared BC

  @scenario_hash:5f563bd975d1039e
  Scenario: the list command output is machine-parseable
    Given a manifest file contains entries for six BCs
    When I run "bc-container manifest list" against that manifest
    Then a script can extract all six canonical BC names from stdout using only standard text processing tools

  @scenario_hash:4dee38f3588eae24
  Scenario: the list command exits zero when the manifest is valid
    Given a manifest file is syntactically valid and contains at least one BC entry
    When I run "bc-container manifest list" against that manifest
    Then the command exits zero

  @scenario_hash:60ef00fc036b1353
  Scenario: the sync command clones a missing BC repository into the repos directory
    Given a manifest file declares "shopsystem-messaging" with a valid GitHub remote URL
    And no directory named "shopsystem-messaging" is present under the repos directory
    When I run "bc-container manifest sync" against that manifest
    Then a directory named "shopsystem-messaging" is present under the repos directory
    And the directory is a git repository cloned from the declared remote URL
    And the command exits zero

  @scenario_hash:523a8c1d967409f4
  Scenario: the sync command skips a BC whose clone already exists with a matching remote
    Given a manifest file declares "shopsystem-messaging" with a valid GitHub remote URL
    And a directory named "shopsystem-messaging" is present under the repos directory
    And its git remote URL matches the remote declared in the manifest
    When I run "bc-container manifest sync" against that manifest
    Then the "shopsystem-messaging" directory is unchanged
    And the command exits zero
    And the output indicates that "shopsystem-messaging" was already present and skipped

  @scenario_hash:5c79a11e3751ab21
  Scenario: the clone-sync operation is idempotent
    Given a manifest file is present at "bc-manifest.yaml" in the lead repo root
    And "bc-container manifest sync" has already run once successfully against that manifest
    When I run "bc-container manifest sync" against that manifest a second time
    Then the command exits zero
    And no new clones are created
    And no existing clones are modified

  @scenario_hash:fc9d93a98e1bf34f
  Scenario: the sync command warns about a repos directory that is not in the manifest
    Given a manifest file does not contain an entry for "ddd-product-system"
    And a directory named "ddd-product-system" is present under the repos directory
    When I run "bc-container manifest sync" against that manifest
    Then the command exits zero
    And the output reports "ddd-product-system" as an entry not declared in the manifest
    And the "ddd-product-system" directory is unchanged

  @scenario_hash:767e2d2d57617764
  Scenario: the validate command passes when GitHub repos exist for all manifest entries
    Given a manifest file declares six BCs each with a declared GitHub remote URL
    And a FakeGitHubDriver is configured to report all six declared remote URLs as reachable
    When I run "bc-container manifest validate" against that manifest
    Then the command exits zero
    And the output reports all six BCs as validated

  @scenario_hash:c951bafde5f09fcc
  Scenario: the validate command fails when a declared GitHub remote is unreachable
    Given a manifest file contains a BC entry with a declared GitHub remote URL
    And a FakeGitHubDriver is configured to report that declared remote URL as unreachable
    When I run "bc-container manifest validate" against that manifest
    Then the command exits non-zero
    And the output names the BC whose remote URL could not be reached
    And the output describes the failure (repository not found or connection refused)

  @scenario_hash:527063066d765a7c
  Scenario: the validate command reports a missing repos clone as a warning
    Given a manifest file declares "shopsystem-scenarios"
    And no directory named "shopsystem-scenarios" is present under the repos directory
    When I run "bc-container manifest validate" against that manifest
    Then the command exits non-zero
    And the output reports "shopsystem-scenarios" as a declared BC with no local clone

  @scenario_hash:427bcb4e1ee61f27
  Scenario: the validate command reports a remote mismatch between manifest and local clone
    Given a manifest file declares "shopsystem-templates" with remote URL "https://github.com/dstengle/shopsystem-templates.git"
    And a directory named "shopsystem-templates" is present under the repos directory
    And its configured git remote URL is a different URL
    When I run "bc-container manifest validate" against that manifest
    Then the command exits non-zero
    And the output reports a remote URL mismatch for "shopsystem-templates"
    And the output shows both the manifest-declared URL and the clone's actual URL

  @scenario_hash:c731e839276c8870
  Scenario: a standard library parser can read the manifest without custom code
    Given a manifest file exists at the path "bc-manifest.yaml" relative to the lead repo root
    When a script imports only a standard format parsing library (no custom manifest module)
    And the script reads the manifest file using that library
    Then the script can extract the canonical name of every declared BC without parse errors

  @scenario_hash:397b16021a84d728
  Scenario: a pipeline script can extract all GitHub remote URLs from the manifest
    Given a manifest file contains entries for all six product BCs
    When a shell or Python script reads the manifest file and extracts all GitHub remote URLs
    Then the script produces exactly six URLs, one per declared BC
    And each URL is the full GitHub remote URL for that BC's repository
