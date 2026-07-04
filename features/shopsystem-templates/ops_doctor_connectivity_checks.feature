@bc:shopsystem-templates @origin:lead-q3r1
Feature: rendered bin/doctor operator diagnostic (lead shop, lead-q3r1) — the bootstrap-rendered bin/doctor ops command performs the messaging-DB (SHOPMSG_DSN/postgres), agent-vault broker (reachability + CA trust), and Claude-credential (CLAUDE_OAUTH refreshable) checks, emitting a named pass/fail line with a remediation hint per check, and reports an aggregate pass/fail diagnosis whose exit code is 0 on overall pass and non-zero on any failure

  @scenario_hash:a6f8c0656a9e1cd9
  Scenario: the rendered "bin/doctor" connectivity check for messaging asserts SHOPMSG_DSN is set and the product postgres is reachable, reporting a named pass/fail line with a remediation hint on failure
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops command "bin/doctor"
    When the operator runs "bin/doctor" in a session whose "SHOPMSG_DSN" is set and whose product postgres is reachable at that DSN
    Then "bin/doctor" emits a check line named for the messaging-DB connection (a "SHOPMSG_DSN / postgres" check) whose status is an explicit pass
    And the same check, run in a session where "SHOPMSG_DSN" is unset or points at a postgres that is not reachable, emits that same named check line whose status is an explicit fail
    And the fail line carries a remediation hint naming the corrective action (set "SHOPMSG_DSN" / bring up the product postgres) rather than only reporting that the check failed

  @scenario_hash:f55aa51f4bd138b3
  Scenario: the rendered "bin/doctor" credential check for agent-vault asserts the broker is reachable and its CA is trusted by the leaf, reporting a named pass/fail line with a remediation hint on failure
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops command "bin/doctor"
    When the operator runs "bin/doctor" in a session whose agent-vault broker is reachable and whose broker CA is trusted by the leaf trust store
    Then "bin/doctor" emits a check line named for the agent-vault broker connection (a "agent-vault broker / CA trust" check) whose status is an explicit pass
    And the same check, run in a session where the broker is unreachable or the broker CA is not trusted by the leaf, emits that same named check line whose status is an explicit fail
    And the fail line distinguishes the unreachable-broker cause from the untrusted-CA cause and carries a remediation hint naming the corrective action rather than only reporting that the check failed

  @scenario_hash:5cf88671d3fab25b
  Scenario: the rendered "bin/doctor" credential check for Claude asserts CLAUDE_OAUTH is present and in a refreshable/connected state, reporting a named pass/fail line with a remediation hint on failure
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops command "bin/doctor"
    When the operator runs "bin/doctor" in a session whose "CLAUDE_OAUTH" credential is present and in a refreshable, connected state
    Then "bin/doctor" emits a check line named for the Claude credential (a "CLAUDE_OAUTH" check) whose status is an explicit pass
    And the same check, run in a session where "CLAUDE_OAUTH" is absent, empty, or in a non-refreshable/disconnected state, emits that same named check line whose status is an explicit fail
    And the fail line carries a remediation hint naming the corrective action (re-run the approve-claude provisioning to restore a non-empty refreshable credential) rather than only reporting that the check failed

  @scenario_hash:027a4d836bb1ae43
  Scenario: the rendered "bin/doctor" runs every credential and connection check and reports an aggregate pass/fail diagnosis with a non-zero exit on any failed check
    Given a "lead" shop bootstrapped by "shop-templates" with the rendered ops command "bin/doctor" that performs the messaging-DB, agent-vault, and Claude-credential checks
    When the operator runs "bin/doctor" in a session where every individual check would pass
    Then "bin/doctor" reports each named check line as a pass, reports an aggregate diagnosis of overall pass, and exits with code 0
    And when "bin/doctor" is run in a session where at least one individual check would fail, it reports each check line with its own pass/fail status, reports an aggregate diagnosis of overall fail that names which check(s) failed, and exits non-zero
    And the aggregate diagnosis is derived from the individual check results — overall pass requires every check to pass and any single failed check forces overall fail — so the operator gets one clear pass/fail verdict without ad-hoc diagnosing
