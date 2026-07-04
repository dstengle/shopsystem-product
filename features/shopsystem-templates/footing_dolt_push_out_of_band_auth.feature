@bc:shopsystem-templates @origin:lead-tncd
Feature: footing configures out-of-band git auth for the dolt-over-git remote
  bd dolt push to <product>-lead-beads authenticates non-interactively via a global
  git insteadOf rewrite, with no PAT embedded in the dolt remote URL or any committed file.

@scenario_hash:513c7a7e642541dd
Scenario: footing configures out-of-band git auth so bd dolt push to the lead-beads remote succeeds non-interactively
  Given the footing has tokenized the git origin so "git push" to "<product>-lead" authenticates non-interactively
  And the bd dolt push remote is configured as "git+https://github.com/<org>/<product>-lead-beads.git" with no embedded token
  And "GIT_TERMINAL_PROMPT" is set to "0" so interactive credential prompting is disabled
  When the footing runs "bd dolt push" against the configured dolt remote
  Then git authenticates to github.com for the dolt-over-git remote using credentials supplied out-of-band, not from the dolt remote URL
  And "bd dolt push" completes successfully and exits zero
  And it does not fail with "could not read Username for 'https://github.com'" or any prompt-disabled error

@scenario_hash:fe555cca50e19bfe
Scenario: footing supplies the dolt-remote github token out-of-band so no committed file embeds the PAT
  Given the footing authenticates "bd dolt push" to github.com for the "<product>-lead-beads" dolt-over-git remote
  When the footing has finished wiring the beads remote and authentication
  Then the github token is supplied through a git credential mechanism outside the repository, such as a global git "insteadOf" rewrite or a credential helper, not by tokenizing the dolt remote URL
  And ".beads/config.yaml" "sync.remote" contains only the clean "git+https://github.com/<org>/<product>-lead-beads.git" URL with no PAT or token substring
  And the bd dolt remote configuration contains only the clean "git+https://github.com/<org>/<product>-lead-beads.git" URL with no PAT or token substring
  And no file that footing commits and pushes embeds the github token
