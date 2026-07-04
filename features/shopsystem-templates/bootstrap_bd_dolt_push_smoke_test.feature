@bc:shopsystem-templates @origin:lead-wnps
Feature: bootstrap runs a bd dolt push smoke-test that fails loud on a missing dolt remote

  After configuring the bd dolt push remote via `bd dolt remote add` (behavior A,
  scenario 0636fba2c1445f9f), bootstrap proves the freshly-wired tracker can
  actually reach its configured dolt remote by running a `bd dolt push`
  smoke-test. On success it reports success and exits 0. Crucially, a real
  `bd dolt push` against a target with NO dolt remote configured is a no-op —
  it prints "No remote is configured — skipping" and EXITS 0 — so a bare push
  could silently pass on a misconfigured tracker. The smoke-test therefore
  guards the push: when no dolt remote is configured it exits non-zero with a
  diagnostic that NAMES the missing dolt remote, so a misconfigured remote is
  caught at bootstrap time, not at the first mid-work work_done emission.
  (tmpl-am6 / PDR-019 U5 / ADR-040. Supersedes the retired scenario
  62eb2a8b9b617f4b, whose bare-push assertion could not catch a missing remote.)

  @scenario_hash:5ae67969a7f205d5
  Scenario: shop-templates bootstrap runs a bd dolt push smoke-test that fails on a missing or misconfigured remote
    Given an existing git repository at a target directory "<target>" with the beads config rendered by bootstrap and the dolt push remote configured
    When the bootstrap smoke-test step runs "bd dolt push" against the configured dolt remote
    Then the smoke-test reports success and the bootstrap exit code is 0
    And given the same target directory with no dolt push remote configured, when the bootstrap smoke-test step runs "bd dolt push", then it exits non-zero with a diagnostic naming the missing dolt remote
