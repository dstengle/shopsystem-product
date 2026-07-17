# RETIRED-scenario provenance (brief-017 / lead-ifye3.1, 2026-07-14 —
# request_bugfix dispatch; bodies below are byte-identical to what was
# retired, for hash-provenance only):
#   @scenario_hash:eb8e74495f124e64 RETIRED (lead-ifye3.1)
#   Asserted an UNBOUND "fabro validate" against the poured def exits zero
#   with zero diagnostics. Once model_stylesheet carries live per-node-class
#   "{{ inputs.MODEL_* }}" placeholders (brief-017), this no longer holds —
#   cand-002's empirical probe proved an unbound validate fails with
#   "undefined template variable". Superseded jointly by
#   @scenario_hash:610455d3a0f4e373 (the new unbound-fails-loud behavior) and
#   @scenario_hash:0435d261be5031fd (the same ADR-051/live-run assertions,
#   re-anchored to representative-inputs-bound validate), both below.
#   Original body:
#     Given the shopsystem-templates BC is installed
#     And a shop-templates pour has emitted the fabro def into "/workspace/.fabro/"
#     When "fabro validate" is executed against the poured def using the REAL fabro binary
#     Then it exits zero and reports zero diagnostics, its "--json" output carrying an empty diagnostics array, and if the real binary genuinely cannot be obtained the leg SKIPs honestly rather than papering a failure over
#     And the poured def satisfies the ADR-051 graph invariants: "emit_r", the Reviewer emitter, is the SOLE gated work_done(complete) emitter on the success path, every fallible non-terminal node carries an unconditional "outcome=failed" failsafe edge to a halt or blocked-emit sink so no failed node reaches the SUCCEEDED terminal, and "vaults/default/secrets.json" holds only "__PLACEHOLDER__" for every provider-key and token slot (ADR-049)
#     And where feasible a live "fabro run" preflight exercises the poured def to assert the agent-vs-native node classification authoritatively, because "fabro validate" is permissive on node attrs and confirms graph shape rather than handler classification (spike R2)
#   @scenario_hash:d08bac49e20111f2 RETIRED (lead-ifye3.1)
#   Same unbound-zero-diagnostics assertion, framed around the pinned-validity
#   home rather than the "fabro validate" leg directly. Same contradiction,
#   same probe. Superseded by @scenario_hash:0bc0fb71534cc0d6 below.
#   Original body:
#     Given the shopsystem-templates BC is installed
#     And a shop-templates pour has emitted the self-contained fabro loop def into "/workspace/.fabro/", not baked into bc-base
#     When "fabro validate" is executed against the poured fabro def at "/workspace/.fabro/"
#     Then it exits zero and reports zero diagnostics
#     And the poured def is a self-contained bc-shop Implementer->Reviewer loop graph per ADR-051: the graph file is present, every node body the graph references is present in the def alongside it so the loop is runnable from the def alone, the Reviewer node is the sole node that can emit a gated work_done on the success path, and every fallible node carries an explicit unconditional failsafe edge to a halt or blocked-emit sink so a failed node never advances to the SUCCEEDED terminal
#     And the poured def's native fabro vault holds only the value "__PLACEHOLDER__" for each of its provider-key and token slots, with no real credential present in the def (ADR-049), so that any real credential the loop uses is sourced from the agent-vault surface baked in S1 and never from the fabro vault
# RETIREMENT (work_id lead-ifye3.6, 2026-07-15, ADR-064 D1/D2, clarify-resolved
# scope): 3 additional hashes RETIRED WITH NO SUCCESSOR, mirroring the BC's own
# scenario-register retirement reported via work_done. The dispatch's original
# @scenario_hash enumeration (scoped to fabro_model_stylesheet_tier_labels.feature,
# hashes 7653d06bddda72ed/8aab2c5c071e349f only) missed that removing the
# "{{ inputs.MODEL_* }}" placeholder shape from the poured model_stylesheet also
# falsifies three scenarios pinned in THIS file, whose Givens literally require
# the placeholders to be present. The BC flagged this via clarify; the lead
# authorized retiring all 5 in the clarify_response (2026-07-15 21:53:23 UTC),
# citing this as one fact (fabro >= v0.267.0-nightly.0 hard-parse-errors "{{ }}"
# in model_stylesheet) applied 5 times, not 5 separate judgment calls.
#
#   @scenario_hash:610455d3a0f4e373 RETIRED WITH NO SUCCESSOR (lead-ifye3.6)
#   Placeholder-mechanism-specific end to end (unbound-validate-fails-loud
#   BECAUSE of the placeholders) -- clean bare retirement, nothing survives it.
#   Original body:
#     Given the shopsystem-templates BC is installed
#     And a shop-templates pour has emitted the fabro def into "/workspace/.fabro/", whose model_stylesheet carries the "MODEL_CODING", "MODEL_REVIEW", and "MODEL_DEFAULT" fabro input placeholders (brief-017)
#     When "fabro validate" is executed against the poured def using the REAL fabro binary with no "-I" input bound for any of the three node-class placeholders
#     Then it exits non-zero and reports a diagnostic naming an undefined template variable for the unbound node-class placeholder in the model_stylesheet attribute
#     And this confirms the live "{{ inputs.<NAME> }}" templating is genuinely evaluated by "fabro validate" rather than silently ignored, the same mechanism the cand-002 empirical probe directly proved, and replaces the retired assertion that an unbound "fabro validate" exits zero with zero diagnostics — that assertion no longer holds once model_stylesheet carries live per-node-class placeholders instead of literal model IDs
#   @scenario_hash:0435d261be5031fd RETIRED WITH NO SUCCESSOR (lead-ifye3.6)
#   NOT purely placeholder-specific: also carried the real-binary zero-diagnostics
#   assertion, the ADR-051 graph invariants (emit_r sole gated success-path
#   emitter, unconditional failsafe edges), and the ADR-049 vault-placeholder-only
#   assertion. Bare-retiring this leaves a genuine coverage gap on those
#   non-placeholder invariants (not a moot check) -- tracked as a follow-up,
#   PO-authored successor at lead-008o8 (model_stylesheet-shape-agnostic; not
#   gating this retirement).
#   Original body:
#     Given the shopsystem-templates BC is installed
#     And a shop-templates pour has emitted the fabro def into "/workspace/.fabro/", whose model_stylesheet carries the "MODEL_CODING", "MODEL_REVIEW", and "MODEL_DEFAULT" fabro input placeholders (brief-017)
#     When "fabro validate" is executed against the poured def using the REAL fabro binary with representative literal model IDs bound via "-I MODEL_CODING", "-I MODEL_REVIEW", and "-I MODEL_DEFAULT"
#     Then it exits zero and reports zero diagnostics, its "--json" output carrying an empty diagnostics array, and if the real binary genuinely cannot be obtained the leg SKIPs honestly rather than papering a failure over
#     And the poured def satisfies the ADR-051 graph invariants: "emit_r", the Reviewer emitter, is the SOLE gated work_done(complete) emitter on the success path, every fallible non-terminal node carries an unconditional "outcome=failed" failsafe edge to a halt or blocked-emit sink so no failed node reaches the SUCCEEDED terminal, and "vaults/default/secrets.json" holds only "__PLACEHOLDER__" for every provider-key and token slot (ADR-049)
#     And where feasible a live "fabro run" preflight, with the same representative model IDs bound, exercises the poured def to assert the agent-vs-native node classification authoritatively, because "fabro validate" is permissive on node attrs and confirms graph shape rather than handler classification (spike R2)
#   @scenario_hash:0bc0fb71534cc0d6 RETIRED WITH NO SUCCESSOR (lead-ifye3.6)
#   Same non-placeholder-specific coverage-gap caveat as 0435d261be5031fd above
#   (real-validate + ADR-051 + ADR-049 assertions against the POURED def) --
#   same lead-008o8 follow-up tracks the successor. BC's own register also
#   retains @scenario_hash:2786d8415362757b (ADR-062 bounded-retry), which is
#   BC-authored, was never part of this lead-held file, and stays live/verifies
#   unaffected by this retirement (per lead-ifye3.6 work_done).
#   Original body:
#     Given the shopsystem-templates BC is installed
#     And a shop-templates pour has emitted the self-contained fabro loop def into "/workspace/.fabro/", not baked into bc-base, whose model_stylesheet carries the "MODEL_CODING", "MODEL_REVIEW", and "MODEL_DEFAULT" fabro input placeholders (brief-017)
#     When "fabro validate" is executed against the poured fabro def at "/workspace/.fabro/" with representative literal model IDs bound via "-I MODEL_CODING", "-I MODEL_REVIEW", and "-I MODEL_DEFAULT"
#     Then it exits zero and reports zero diagnostics
#     And the poured def is a self-contained bc-shop Implementer->Reviewer loop graph per ADR-051: the graph file is present, every node body the graph references is present in the def alongside it so the loop is runnable from the def alone, the Reviewer node is the sole node that can emit a gated work_done on the success path, and every fallible node carries an explicit unconditional failsafe edge to a halt or blocked-emit sink so a failed node never advances to the SUCCEEDED terminal
#     And the poured def's native fabro vault holds only the value "__PLACEHOLDER__" for each of its provider-key and token slots, with no real credential present in the def (ADR-049), so that any real credential the loop uses is sourced from the agent-vault surface baked in S1 and never from the fabro vault
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

  Scenarios 610455d3a0f4e373, 0435d261be5031fd, and 0bc0fb71534cc0d6 are
  RETIRED WITH NO SUCCESSOR (work_id lead-ifye3.6) — see the retirement
  provenance header at the top of this file. 0435d261be5031fd and
  0bc0fb71534cc0d6 leave a genuine, tracked coverage gap on the real-validate
  / ADR-051 / ADR-049 invariants against the poured def; a PO-authored
  successor restoring that coverage (model_stylesheet-shape-agnostic) is
  tracked as lead-008o8, not yet authored.
