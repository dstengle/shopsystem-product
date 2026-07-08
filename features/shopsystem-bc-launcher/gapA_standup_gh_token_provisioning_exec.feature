@bc:shopsystem-bc-launcher @origin:lead-3mez
Feature: BC-standup beads-tracker provisioning exec carries a GitHub token so gh reaches the agent-vault proxy (GAP A, lead-3mez)

  Standing up shopsystem-knowledge via create-bc under fabro (David 2026-07-07):
  the in-container standup computed the CORRECT tracker target
  "dstengle/shopsystem-knowledge-beads" yet the "gh repo create" step FAILED
  with exit 4 ("To get started with GitHub CLI run gh auth login / populate
  GH_TOKEN"), so the "<owner>/<bc>-beads" tracker repo was never created
  (confirmed: dstengle/shopsystem-knowledge-beads returned 404). CONFIRMED ROOT:
  bc_launcher/controller.py:231 runs "gh repo create {slug} --private
  --add-readme" via docker exec, but that exec's env carries NO GH_TOKEN, so gh
  cannot fire a request through the agent-vault proxy. PROVEN: running the EXACT
  script in-container with GH_TOKEN=dummy created dstengle/shopsystem-knowledge-beads
  successfully — the proxy is fully wired (HTTPS_PROXY, broker CA, AGENT_VAULT_*),
  gh just needs a placeholder token set (the proxy substitutes the real
  GITHUB_TOKEN). Neither --env-file nor host-env GH_TOKEN reaches this exec.

  This pins the CREDENTIAL WIRING, distinct from the existing repo-creation
  behavioral pin (bc_standup_creates_beads_tracker_repo,
  scenario_hash 90caf5523e7d5ce0, which assumes gh can reach GitHub and hedges
  "gh/docker may be unavailable in-test"). Fidelity binds to the executable
  provisioning-exec surface — the controller.py:231 docker-exec env that runs
  "gh repo create" must set a non-empty GH_TOKEN placeholder — the same
  structural-inspection idiom the bc-base CLI-pin tests use, NOT a live gh/GitHub
  call.

  @scenario_hash:c1abb192dd2a5eae
  Scenario: the BC-standup beads-tracker provisioning exec carries a GitHub token so gh repo create reaches the agent-vault proxy and the tracker repo is created
    Given a new BC whose shop-name slug is "<bc>" is being stood up under GitHub owner "<owner>"
    And the BC container's agent-vault proxy is wired with HTTPS_PROXY, the broker CA, and the AGENT_VAULT credentials, but no GitHub token is otherwise present in the provisioning exec environment
    When the standup runs its beads-tracker provisioning exec that invokes "gh repo create <owner>/<bc>-beads --private --add-readme"
    Then that provisioning exec's environment sets a non-empty GH_TOKEN placeholder so gh authenticates through the agent-vault proxy instead of exiting non-zero with a "gh auth login" or "populate GH_TOKEN" error
    And the "gh repo create" invocation exits zero and the "<owner>/<bc>-beads" tracker repository exists and is viewable
