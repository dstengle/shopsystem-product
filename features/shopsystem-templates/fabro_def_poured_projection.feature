@bc:shopsystem-templates @origin:adr-057
Feature: the shop-templates pour projects the BC work-loop to a NEW /workspace/.fabro/ surface — static ADR-051 skeleton poured verbatim + node bodies generated from the single source (lead-xinb)

  ADR-057 single-sources the BC work-loop CONTENT from the EXISTING
  shopsystem-templates role prompts + vendored skills (unchanged authoring
  surface) and projects it onto TWO poured surfaces out of ONE pour:
  ".claude/" (tmux engage, unchanged) and a NEW "/workspace/.fabro/" (fabro
  engage). The fabro def is GENERATED DETERMINISTICALLY at pour time, NEVER
  baked into bc-base. The ADR-051 topology skeleton + native gate "script="
  nodes are poured VERBATIM from a static asset (authored once); only the
  agent-node bodies are generated, by DIRECT inlining of the unchanged
  role/skill Markdown (no restructuring). This is the DE-RISKED scope: direct
  translation only, gate/claude-prompt unification DEFERRED, no x7bp coupling,
  no source-unit "kind" taxonomy, no obligation metadata (ADR-057 D3/D4 + OUT
  OF SCOPE). The VALIDITY half of the retired bc-launcher pin
  @scenario_hash:2dfefe2ba81e418d RE-HOMES here (last scenario), where the
  generation now lives, its delivery premise moving baked -> poured while every
  validity assertion holds on the poured def.

  FIDELITY (test-fidelity-for-image-layer-container-runtime-scenarios + the
  fabro-asset lesson: run the REAL tool, do not reimplement):
  * The DETERMINISM legs pour twice over an identical single source and compare
    sha256 per artifact (byte-identical); the generator is deterministic by
    construction (sorted iteration, no timestamps, no randomness) so a committed
    "/workspace/.fabro/" provably equals a fresh re-pour (ADR-019 + the
    progressive-disclosure byte-identical precedent).
  * The "fabro validate" leg runs the REAL fabro binary (fabro-sh/fabro
    v0.254.0) against the POURED workflow.fabro and asserts exit 0 + an EMPTY
    diagnostics array ("--json"); if the binary genuinely cannot be obtained the
    leg SKIPs honestly and does NOT paper a failure over. A real non-zero /
    non-empty-diagnostics result is a real def defect and REDs.
  * The ADR-051-invariant leg parses the REAL poured workflow.fabro
    (quote-aware, comment-stripped): "emit_r" is the SOLE gated
    work_done(complete) emitter on the success path, every fallible node carries
    an unconditional outcome=failed failsafe edge to a halt/blocked-emit sink,
    and vaults/default/secrets.json holds ONLY "__PLACEHOLDER__" (ADR-049). A
    missing failsafe edge, a second success-path emitter, or a real-credential
    literal REDs.
  * Where feasible a live "fabro run" preflight exercises the poured def to
    assert the agent-vs-native classification authoritatively, because "fabro
    validate" is permissive on node attrs (spike R2).

  @scenario_hash:e7668df366a93a60
  Scenario: a shop-templates pour emits the "/workspace/.fabro/" fabro-engage projection — a static ADR-051 skeleton poured verbatim plus generated node bodies — alongside "/workspace/.claude/"
    Given the shopsystem-templates BC is installed
    And the single canonical source of the BC work-loop content is the shopsystem-templates role prompts "bc-implementer", "bc-reviewer", "bc-router", "bc-review", "bc-sufficiency-check" and "work-done-gate" plus the vendored skills, unchanged as the authoring surface
    When a shop-templates pour is run in a workspace
    Then a "/workspace/.fabro/" fabro-engage projection is emitted alongside the existing "/workspace/.claude/" projection, both out of the same pour
    And "/workspace/.fabro/" carries the ADR-051 topology skeleton — the "workflow.fabro" graph, the native-gate "script=" nodes, and the "workflow.toml", "project.toml" and "vaults/default" scaffold — poured VERBATIM from a static asset, not generated from prose
    And "/workspace/.fabro/nodes/" carries the agent-node bodies GENERATED at pour time by inlining the unchanged role-prompt and skill Markdown from the single canonical source, so that a role-prompt or skill edit changes only that one source and re-pours into both the "/workspace/.claude/" and "/workspace/.fabro/" projections

  @scenario_hash:941d1df69c9b62dd
  Scenario: running the shop-templates pour twice over the identical single source yields a byte-identical "/workspace/.fabro/" projection
    Given the shopsystem-templates BC is installed
    And a fixed single canonical source of the BC work-loop role prompts and vendored skills
    When a shop-templates pour is run twice over that identical single source into two separate workspaces
    Then every artifact under "/workspace/.fabro/" has the same sha256 across the two pours, so the two projections are byte-identical
    And a "/workspace/.fabro/" committed from one pour is provably equal to a fresh pour of the same source, the no-drift property that makes a committed projection equal a re-pour (the ADR-019 scenarios single-source doctrine and the progressive-disclosure byte-identical precedent)
    And the generation is deterministic by construction — sorted iteration, no timestamps, no randomness — so the byte-identity holds on every re-pour

  @scenario_hash:eb8e74495f124e64
  Scenario: the poured "/workspace/.fabro/" def passes "fabro validate" on the real binary, satisfies the ADR-051 invariants, and is preflighted with a live "fabro run" where feasible
    Given the shopsystem-templates BC is installed
    And a shop-templates pour has emitted the fabro def into "/workspace/.fabro/"
    When "fabro validate" is executed against the poured def using the REAL fabro binary
    Then it exits zero and reports zero diagnostics, its "--json" output carrying an empty diagnostics array, and if the real binary genuinely cannot be obtained the leg SKIPs honestly rather than papering a failure over
    And the poured def satisfies the ADR-051 graph invariants: "emit_r", the Reviewer emitter, is the SOLE gated work_done(complete) emitter on the success path, every fallible non-terminal node carries an unconditional "outcome=failed" failsafe edge to a halt or blocked-emit sink so no failed node reaches the SUCCEEDED terminal, and "vaults/default/secrets.json" holds only "__PLACEHOLDER__" for every provider-key and token slot (ADR-049)
    And where feasible a live "fabro run" preflight exercises the poured def to assert the agent-vs-native node classification authoritatively, because "fabro validate" is permissive on node attrs and confirms graph shape rather than handler classification (spike R2)

  @scenario_hash:d08bac49e20111f2
  Scenario: the fabro loop def whose validity is pinned is the one POURED by shop-templates into "/workspace/.fabro/", and the "fabro validate" plus ADR-051 plus placeholder-vault assertions hold on the poured def
    Given the shopsystem-templates BC is installed
    And a shop-templates pour has emitted the self-contained fabro loop def into "/workspace/.fabro/", not baked into bc-base
    When "fabro validate" is executed against the poured fabro def at "/workspace/.fabro/"
    Then it exits zero and reports zero diagnostics
    And the poured def is a self-contained bc-shop Implementer->Reviewer loop graph per ADR-051: the graph file is present, every node body the graph references is present in the def alongside it so the loop is runnable from the def alone, the Reviewer node is the sole node that can emit a gated work_done on the success path, and every fallible node carries an explicit unconditional failsafe edge to a halt or blocked-emit sink so a failed node never advances to the SUCCEEDED terminal
    And the poured def's native fabro vault holds only the value "__PLACEHOLDER__" for each of its provider-key and token slots, with no real credential present in the def (ADR-049), so that any real credential the loop uses is sourced from the agent-vault surface baked in S1 and never from the fabro vault
