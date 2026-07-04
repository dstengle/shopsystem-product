@bc:shopsystem-bc-launcher @origin:adr-051
Feature: a launched bc-base BC carries a self-contained VALID fabro loop def (lead-ky63)

  Companion block-only PIN for the self-contained fabro loop def bundle that
  lead-h2bj delivered under src/bc_launcher/assets/fabro-def/ (the 15-file
  def, launch-wired to place at /workspace/.fabro/). Where lead-h2bj's plain
  unit tests guard the DELIVERY (files present, placement wiring, additive),
  this scenario pins the def's VALIDITY as an ADR-051 Implementer->Reviewer
  loop that `fabro validate` accepts with a placeholder-only native vault.

  FIDELITY (test-fidelity-for-image-layer-container-runtime-scenarios + the
  fabro-asset lesson: run the REAL tool, do not reimplement):
  * LEG 1 (`fabro validate` exits zero + zero diagnostics) runs the REAL
    fabro binary (fabro-sh/fabro v0.254.0, target-triple release asset per
    bead 0fz) against the committed def's workflow.fabro and asserts exit 0
    and an EMPTY diagnostics array (`--json`). If the binary genuinely cannot
    be obtained (no network), the leg SKIPs gracefully and says so honestly;
    it does NOT paper a failure over. A real non-zero / non-empty-diagnostics
    result is a real def defect and REDs.
  * LEG 2 (ADR-051 graph invariants) parses the REAL committed workflow.fabro
    (quote-aware, comment-stripped) and asserts, with teeth: the graph file
    is present; every prompt_file node body it references is present in the
    def; on the scenario success path `emit_r` (the reviewer emitter) is the
    SOLE gated work_done(complete) emitter; and every fallible non-terminal
    node carries an unconditional outcome=failed failsafe edge to a halt or
    blocked-emit sink (no fallible node reaches the SUCCEEDED terminal on
    failure). A missing failsafe edge or a second scenario-path emitter REDs.
  * LEG 3 (native vault) asserts vaults/default/secrets.json holds ONLY
    "__PLACEHOLDER__" for every provider-key/token slot (valid JSON, no
    real-credential-shaped literal). A real value REDs (ADR-049).

  @scenario_hash:2dfefe2ba81e418d
  Scenario: a launched bc-base BC has a self-contained valid fabro loop def that "fabro validate" accepts with the native fabro vault holding only placeholders
    Given the shopsystem-bc-launcher BC is installed
    And bc-container launch is run with BC name "shopsystem-messaging"
    And the container "bc-shopsystem-messaging" is running on the pinned bc-base image
    When "fabro validate" is executed against the fabro def present in that running container
    Then it exits zero and reports zero diagnostics
    And the def is a self-contained bc-shop Implementer->Reviewer loop graph per ADR-051: the graph file is present, every node body the graph references is present in the def alongside it so the loop is runnable from the def alone, the Reviewer node is the sole node that can emit a gated work_done on the success path, and every fallible node carries an explicit unconditional failsafe edge to a halt or blocked-emit sink so a failed node never advances to the SUCCEEDED terminal
    And the def's native fabro vault holds only the value "__PLACEHOLDER__" for each of its provider-key and token slots, with no real credential present in the def (ADR-049), so that any real credential the loop uses is sourced from the agent-vault surface baked in S1 and never from the fabro vault
