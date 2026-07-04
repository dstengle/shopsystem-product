@bc:shopsystem-templates @origin:lead-j9u3
Feature: footing creates the lead-beads repo with an initial branch so bd dolt push succeeds
  A bare gh repo create makes an empty repo with no branch; the dolt-over-git push then
  fails 'git remote has no branches'. footing seeds an initial commit (--add-readme).

@scenario_hash:01edf8947730788d
Scenario: footing creates the lead-beads repository with an initial branch so the subsequent bd dolt push succeeds instead of failing on an empty remote
  Given footing is reaching solid footing for product slug "<product>" and the "<product>-lead-beads" repository does not yet exist
  When footing creates the "<product>-lead-beads" repository via "gh repo create" and then runs "bd dolt push" against the wired dolt-over-git remote
  Then footing creates the "<product>-lead-beads" repository with an initial branch and commit so the remote is not an empty repository with no branches
  And the subsequent "bd dolt push" to the "<product>-lead-beads" remote completes successfully and exits zero
  And it does not fail with "git remote has no branches: cannot push" or "initialize the repository with an initial branch/commit first"
