# RETIREMENT (brief-021 SS8, architect resolution, 2026-07-15, work_id lead-ifye3.6
# -- NOT dispatched as a live request_bugfix, retired lead-side only pending BC-side
# follow-up; see note below): BOTH scenarios below are RETIRED WITH NO SUCCESSOR.
#
# brief-021 SS8 left open whether this templates-side abstract-placeholder-pour
# mechanism should be retired or scoped down, contingent on an unresolved question:
# does the Anthropic default path ALSO move to fabro >= v0.267.0-nightly.0 (losing
# model_stylesheet templating fleet-wide), or does it stay on v0.254.0 (keeping the
# mechanism load-bearing there)? Resolved empirically against the artifact surface,
# not guessed at:
#
#   ADR-021 D1/D3 ("shopsystem-bc-base image owned by shopsystem-bc-launcher"):
#   "bc-container launch (the shopsystem-bc-launcher BC) runs EVERY BC container
#   from a SINGLE base image" -- shopsystem-bc-base, published once to
#   ghcr.io/dstengle/shopsystem-bc-base with a SINGLE ARG FABRO_VERSION baked in
#   at publish time (findings/dagger-spike/00-dagger-recon.md, 00b-bclauncher-ci.md:
#   "ARG FABRO_VERSION=v0.254.0 ... ARG bumped by poll workflow"). ADR-021 D4 names
#   "controlled/pinned propagation (a BC or the lead pinning a specific bc-base
#   digest/version rather than floating :latest)" as EXPLICITLY DEFERRED, NOT
#   DESIGNED future work -- there is no per-BC or per-path FABRO_VERSION override
#   mechanism today. Every BC container, on every launch, floats to whatever
#   FABRO_VERSION the current bc-base:latest was built with, regardless of which
#   LLM provider (Anthropic default or OpenRouter override) that launch selects.
#
#   Therefore: once shopsystem-bc-launcher's brief-021 OpenRouter fix (lead-ifye3.5)
#   lands its precondition FABRO_VERSION bump to >= v0.267.0-nightly.0, BOTH paths
#   converge on that fabro version -- there is no way for the Anthropic default path
#   to stay on v0.254.0 while OpenRouter uses the newer nightly, because both run in
#   containers built from the SAME bc-base image with a SINGLE fabro binary. Per
#   brief-021 SS3 / fabro's own commit 911e080f3 ("Limit DOT templates to prompt +
#   goal"), "{{ inputs.X }}" inside model_stylesheet becomes literal, unparseable
#   text -- a hard parse error, not a silent no-op -- on that fabro version, for
#   ANY BC pouring this skeleton, not merely OpenRouter-path launches.
#
#   This resolves brief-021 SS8's own stated branch: "If both paths converge on the
#   newer fabro version, the templates-side placeholder mechanism has no remaining
#   consumer anywhere in the fleet and is a candidate for retirement." Both paths
#   converge (confirmed above); the mechanism has NO remaining consumer anywhere in
#   the fleet, and continuing to pour it would plant a fleet-wide landmine (a hard
#   fabro-validate/fabro-run parse failure for every BC) once the precondition bump
#   lands -- so this is a retirement, not merely a documentation correction.
#
#   @scenario_hash:7653d06bddda72ed RETIRED WITH NO SUCCESSOR (brief-021 SS8)
#   Asserted the poured model_stylesheet skeleton expresses each pinned node-class
#   as a fabro input placeholder ("{{ inputs.MODEL_CODING }}" etc.) rather than a
#   literal provider-bound model ID. No longer viable on the fabro version the
#   fleet is converging on (see above) -- pouring this shape becomes a hard parse
#   error, not a template that resolves.
#   Original body:
#     Given the shopsystem-templates BC is installed
#     And the canonical model_stylesheet skeleton asset is authored with one fabro "{{ inputs.<NAME> }}" placeholder per pinned node-class selector ".coding", ".review", and "*", using the input names "MODEL_CODING", "MODEL_REVIEW", and "MODEL_DEFAULT" respectively
#     When a shop-templates pour is run in a workspace
#     Then the poured "/workspace/.fabro/workflow.fabro" carries a model_stylesheet attribute reading ".coding { model: {{ inputs.MODEL_CODING }} } .review { model: {{ inputs.MODEL_REVIEW }} } * { model: {{ inputs.MODEL_DEFAULT }} }"
#     And no node-class selector in the poured model_stylesheet resolves to a literal provider-bound model ID string such as "claude-sonnet-4-5" or "claude-haiku-4-5"
#   @scenario_hash:8aab2c5c071e349f RETIRED WITH NO SUCCESSOR (brief-021 SS8)
#   Asserted the abstract-labeled model_stylesheet pours as a static, verbatim
#   skeleton with no per-provider/per-model resolution at pour time. Moot once the
#   skeleton it describes has no remaining consumer anywhere in the fleet (see
#   above) -- there is nothing left to pour verbatim.
#   Original body:
#     Given the shopsystem-templates BC is installed
#     And the canonical model_stylesheet skeleton asset carries the abstract-labeled node-class placeholders
#     When a shop-templates pour is run twice over the identical skeleton asset into two separate workspaces
#     Then the poured "/workspace/.fabro/workflow.fabro" model_stylesheet attribute is byte-identical across both pours
#     And the templates BC's pour mechanism performs no substitution of any placeholder into a literal model ID at pour time -- every placeholder is poured verbatim, exactly as authored, unresolved
#     And the tier+effort-to-model mapping table and the active-provider dial are both absent from the templates BC's pour surface -- resolving a placeholder to a literal model ID is not a templates-BC behavior
#
# NOTE ON DISPATCH: this retirement is recorded lead-side now, ahead of the
# FABRO_VERSION bump actually landing (v0.254.0 remains unaffected until then --
# not an active break yet, but a known landmine). A live request_bugfix dispatch
# to shopsystem-templates instructing its own scenario-register retirement (and any
# BC-side pour-behavior change, undecided here -- brief-021 SS6 explicitly places
# "what replaces model_stylesheet" out of scope) is tracked as lead-ifye3.6, to be
# sequenced no later than shopsystem-bc-launcher's FABRO_VERSION bump landing, so
# the BC's own register never asserts a commitment the fleet-wide precondition has
# already invalidated.
@bc:unassigned @origin:brief-017
Feature: shop-templates pours model_stylesheet using abstract per-node-class fabro input placeholders instead of literal provider-bound model IDs (brief-017) -- RETIRED (brief-021 SS8): no remaining consumer anywhere in the fleet

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

  Both of this feature's scenarios (7653d06bddda72ed, 8aab2c5c071e349f) are
  RETIRED WITH NO SUCCESSOR per brief-021 SS8 — see the retirement provenance
  header at the top of this file. No live scenario remains in this file.
