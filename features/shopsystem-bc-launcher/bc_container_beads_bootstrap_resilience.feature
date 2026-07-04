@bc:shopsystem-bc-launcher @origin:lead-5k8c
Feature: bc-container launch bd-bootstrap is bootstrap-resilient and never fatal-strands the container (lead-5k8c)

  The in-container bd-bootstrap step runs AFTER the repo clone but BEFORE the
  tmux/claude agent-start step.  Observed live 2026-06-22 (lead-4qpq fleet
  relaunch): launching shopsystem-bc-launcher reached a healthy cloned
  container with NO agent because bd-bootstrap fatal-failed with
  "dolt clone ...: git remote has no branches: ...; initialize the repository
  with an initial branch/commit first" and the launcher did a FATAL
  early-return BEFORE agent-start, stranding the container.

  This is the SAME strand CLASS as lead-k4k7 (warn-and-continue for the
  shop-templates skill-refresh) but at a DIFFERENT early-return point.  Two
  additive behaviors are pinned here, both authored in this BC's register:

  1. EMPTY-REMOTE PROVISIONING.  When the BC's `<bc>-beads` Dolt remote is
     EMPTY/uninitialized, the bd-bootstrap step must INITIALIZE it
     (init-and-push an initial branch/commit, seeded from the git-tracked
     `.beads/issues.jsonl`) and then provision cleanly, instead of
     fatal-failing the clone.  Additive to the populated-remote pull path
     (lead-held @scenario_hash:f4ebaa3f7559a84a, NOT retired) and strengthens
     the functional-readiness pin (lead-held @scenario_hash:1f1d178bca957fbc)
     on the empty-remote path.

  2. NO PRE-AGENT-START STEP MAY FATAL-STRAND.  Generalizing the lead-k4k7
     warn-and-continue invariant to the bd-bootstrap step: ANY bd-bootstrap
     failure (including an empty remote that could not be seeded) degrades to
     warn-then-proceed-to-agent-start, so a healthy cloned container is NEVER
     left without an agent.  The agent self-heals the tracker via the BC
     session-start beads-health step.

  @scenario_hash:ada742d33c996d34
  Scenario: launch initializes an empty beads dolt remote then provisions beads write-ready
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-bc-launcher" with a valid repo URL is configured
    And the cloned repository's committed beads registry carries the prefix "bclaunch"
    And the BC's beads dolt remote is empty and uninitialized
    When I run bc-container launch with BC name "shopsystem-bc-launcher"
    Then the launch initializes the empty beads dolt remote with an initial branch and commit
    And the launch retries bd bootstrap after seeding the empty remote
    And the container's beads embedded-Dolt working set directory exists
    And bd create run inside the container's workspace directory exits zero and yields a new issue id carrying that prefix
    And the launch still starts the agent

  @scenario_hash:aecde8d40bc5a7d6
  Scenario: a bd-bootstrap failure warns and proceeds to agent-start without fatal-stranding the container
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-bc-launcher" with a valid repo URL is configured
    And the BC's beads dolt remote is empty and uninitialized
    And the launcher's empty-remote seed step fails at runtime
    When I run bc-container launch with BC name "shopsystem-bc-launcher"
    Then the launch warns about the bd bootstrap failure and still starts the agent
    And the launch result is success
