@bc:unassigned @origin:brief-017
Feature: shop-templates pours model_stylesheet using abstract per-node-class fabro input placeholders instead of literal provider-bound model IDs (brief-017)

  cand-002 / intent-002: fabro's LLM provider/model choice is release-gated
  today — a poured, verbatim model_stylesheet skeleton (ADR-057) baking
  literal model IDs per node-class. This feature narrows shopsystem-templates'
  slice to authoring the ABSTRACT-LABELED skeleton only: each pinned
  node-class selector (".coding", ".review", "*") carries a fabro
  "{{ inputs.<NAME> }}" placeholder instead of a literal model ID. Resolving
  a placeholder into a literal, provider-specific model ID is explicitly NOT
  a templates-BC behavior — that is shopsystem-bc-launcher's slice (see the
  companion feature on shopsystem-bc-launcher). The pour stays a static,
  verbatim pour: ADR-057 D4 (the skeleton's authoring cadence) is unaffected
  by this change — only what the skeleton is allowed to SAY changes, not how
  or when it is poured.

  The input-name contract pinned here — MODEL_CODING (".coding"),
  MODEL_REVIEW (".review"), MODEL_DEFAULT ("*") — is the concrete, addressable
  surface shopsystem-bc-launcher supplies literal model IDs against via fabro
  run "-I KEY=VALUE" inputs, the same proven mechanism the empirical probe
  (cand-002 Evidence) confirmed fabro's templating genuinely resolves inside
  the graph-level model_stylesheet attribute.

  @scenario_hash:7653d06bddda72ed
  Scenario: the poured model_stylesheet skeleton expresses each pinned node-class as a fabro input placeholder, not a literal provider-bound model ID
    Given the shopsystem-templates BC is installed
    And the canonical model_stylesheet skeleton asset is authored with one fabro "{{ inputs.<NAME> }}" placeholder per pinned node-class selector ".coding", ".review", and "*", using the input names "MODEL_CODING", "MODEL_REVIEW", and "MODEL_DEFAULT" respectively
    When a shop-templates pour is run in a workspace
    Then the poured "/workspace/.fabro/workflow.fabro" carries a model_stylesheet attribute reading ".coding { model: {{ inputs.MODEL_CODING }} } .review { model: {{ inputs.MODEL_REVIEW }} } * { model: {{ inputs.MODEL_DEFAULT }} }"
    And no node-class selector in the poured model_stylesheet resolves to a literal provider-bound model ID string such as "claude-sonnet-4-5" or "claude-haiku-4-5"

  @scenario_hash:8aab2c5c071e349f
  Scenario: the abstract-labeled model_stylesheet still pours as a static, verbatim skeleton — no per-provider or per-model resolution happens at pour time
    Given the shopsystem-templates BC is installed
    And the canonical model_stylesheet skeleton asset carries the abstract-labeled node-class placeholders
    When a shop-templates pour is run twice over the identical skeleton asset into two separate workspaces
    Then the poured "/workspace/.fabro/workflow.fabro" model_stylesheet attribute is byte-identical across both pours
    And the templates BC's pour mechanism performs no substitution of any placeholder into a literal model ID at pour time — every placeholder is poured verbatim, exactly as authored, unresolved
    And the tier+effort-to-model mapping table and the active-provider dial are both absent from the templates BC's pour surface — resolving a placeholder to a literal model ID is not a templates-BC behavior
