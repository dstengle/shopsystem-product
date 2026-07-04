@bc:shopsystem-templates @origin:lead-bk5g
Feature: footing aborts on an empty GitHub PAT after the single auth gate
  The PAT-only empty-credential guard (the surviving arm of the retired S4): if
  GITHUB_TOKEN is empty after the gate, footing aborts non-zero before the push.

@scenario_hash:5b8a81498c410971
Scenario: footing aborts when the GitHub PAT is empty after the single auth gate
  Given footing has passed its single up-front auth gate
  And the owner password was generated (never prompted) so it is not part of this guard
  When the GitHub PAT credential (GITHUB_TOKEN) is empty after the gate
  Then footing aborts before the authenticated git push with a non-zero exit
  And footing emits the diagnostic "footing: the GitHub PAT is EMPTY after the auth gate — aborting (set GITHUB_TOKEN or supply it at the gate)." on stderr
  And no blank credential propagates into the authenticated push
