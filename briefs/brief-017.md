---
type: brief
id: brief-017
title: Operator-configurable fabro LLM provider/model selection, proven via OpenRouter
status: draft
created: 2026-07-14
updated: 2026-07-17
authors: [David Stenglein (product authority), Claude (lead-po)]
description: 'fabro''s LLM provider/model choice is baked into release-gated artifacts today:'
derives-from: [adr-057, adr-049, adr-028, adr-056]
candidate: cand-002
---

## Summary

fabro's LLM provider/model choice is baked into release-gated artifacts today:
a poured, verbatim `model_stylesheet` skeleton in shopsystem-templates'
`workflow.fabro` (per adr-057), and shopsystem-bc-launcher's engage-time
provider wiring. The fleet's only working LLM path — Anthropic, via the
subscription OAuth — is gated in a way that is fast-moving and unlikely to
improve: the proven root cause is that Anthropic rejects premium-model calls
lacking the interactive Claude Code system-prompt identity, which fabro's node
requests never carry. The already-realized cost of the release-gating is
`lead-txhou`: a wrong `claude-haiku-4-5` default got stuck in the poured
skeleton and stayed wrong until noticed, fixable only by a template release.
The full stakeholder record is intent-002.

The job-to-be-done: when Anthropic's OAuth gating blocks or degrades fabro's
substantive LLM work, an operator wants to point a BC's fabro workflow at a
different provider/model by relaunching the container with an operator-set
value, so as not to be stuck waiting on a template/launcher software release
to react to a gating shift.

This brief argues for converting that release-gated surface into an
operator-controlled runtime dial, proven via a second real provider
(OpenRouter) rather than merely reshuffling defaults on the existing
single-provider path. The observable behavior change — not the output (a new
CLI flag, a new env var) — is the measure:

- An operator can relaunch a BC container with an explicit provider override
  (`--llm-provider openrouter` / `BCLAUNCHER_LLM_PROVIDER=openrouter`) and that
  BC's fabro work runs against OpenRouter instead of Anthropic, with **no
  template release, no bc-launcher release, and no image rebuild** — only the
  launch-time value and a container relaunch are required.
- With no override, a BC continues to run against the existing Anthropic
  subscription path, unchanged — this adds a dial, it does not flip the fleet
  default.
- A real `assign_scenarios` (or equivalent substantive-work) dispatch completes
  end-to-end on a BC launched with the OpenRouter override, resolving at least
  one non-trivial node-class (e.g. `.coding`) to a literal OpenRouter model ID.
  This is the proof bar cand-002 sets, pinned by scenario L5.

The pinned solution shape (from cand-002, not re-decided here) is two elements
split across the two BCs that already own the relevant surfaces (adr-057's
pin-ownership table, confirmed not newly decomposed):

- **shopsystem-templates** authors/pours `model_stylesheet` using one fabro
  `{{ inputs.<NAME> }}` placeholder per pinned node-class instead of a literal
  model ID: `.coding` → `MODEL_CODING`, `.review` → `MODEL_REVIEW`, `*` →
  `MODEL_DEFAULT`. The pour stays static and verbatim (adr-057 D4 unaffected) —
  templates does not resolve placeholders, does not own the mapping table, and
  does not know about providers.
- **shopsystem-bc-launcher** (a) selects Anthropic (default) or OpenRouter as
  the active provider via a launch-time operator value, riding a NEW
  agent-vault-brokered OpenRouter credential (no-shim, adr-049 D3 shape); (b)
  resolves the three poured placeholders into literal, provider-specific model
  IDs by supplying them as fabro run `-I KEY=VALUE` inputs, looked up from a
  fleet-wide, provider-keyed mapping table (tier+effort → model ID per
  provider). This resolution mechanism (`-I KEY=VALUE` reaching and resolving
  `model_stylesheet`) was directly, empirically proven in cand-002's Evidence
  section (isolated disposable-container probe) — settled, not open.

Load-bearing vocabulary this brief introduces: `--llm-provider` /
`BCLAUNCHER_LLM_PROVIDER` — the launch-time operator-facing control naming the
active LLM provider, values `anthropic` (default, unset-equivalent) |
`openrouter`, named by the PO following the existing
`--agent-vault-broker`/`BCLAUNCHER_AGENT_VAULT_BROKER` convention
(`bc_container_runtime_proxy.feature`); `MODEL_CODING` / `MODEL_REVIEW` /
`MODEL_DEFAULT` — the three fabro input keys the poured skeleton's
`{{ inputs.<NAME> }}` placeholders bind to, one per pinned node-class, the
addressable contract bc-launcher resolves against, fixed by this brief;
**the fleet-wide provider-keyed model mapping table** — the (tier+effort ×
provider) → literal-model-ID lookup bc-launcher consults (whose concrete
storage location/ownership is an open question for the Architect at dispatch);
**agent-vault OpenRouter credential service** — the new agent-vault credential
key/service (analogous to the existing `github` service) brokering the real
OpenRouter API key onto the wire, node-side dummy `OPENROUTER_API_KEY=__PLACEHOLDER__`.

Strategic trace: this serves the fabro-substrate reliability bet recorded in
intent-002 and shaped by cand-002 — the fleet's only working LLM path is gated
in a way "happening really fast and unlikely to be minimized" (stakeholder,
2026-07-14), and the AI-fleet build economics make a stuck substantive-work
pipeline pure waste; `lead-txhou` is the concrete, already-realized cost of
release-gated model configuration.

What would NOT satisfy the stakeholder: shipping "OpenRouter support" as
another baked, release-gated default (satisfies the literal ask while missing
the release-gating problem); a provider override requiring a template or
launcher release to take effect; literal per-provider model IDs baked into
`model_stylesheet` (would defeat the candidate's own purpose — provider
switches would still require hand-rewriting every node-class mapping);
automatic/self-reactive fallback or any mechanism taking the dial away from the
operator; N>2 provider machinery, per-node-class override matrices, or cost
observability folded into this brief.

## Scope

**In scope** (pinned by the scenarios below):

- Launch-time provider selection (Anthropic default / OpenRouter override) on
  shopsystem-bc-launcher.
- The new agent-vault-brokered OpenRouter credential path, no-shim shape.
- Abstract per-node-class placeholders in the poured `model_stylesheet`
  (shopsystem-templates).
- bc-launcher's resolution of those placeholders to literal model IDs via fabro
  run `-I` inputs, sourced from the mapping table, keyed by active provider.
- One end-to-end proof: a real substantive dispatch completing on an
  OpenRouter-launched BC.

**Out of scope / explicit non-goals** (cand-002 Rabbit holes / No-gos):

- True hot-reload / in-flight config mutation without a relaunch. Does not exist
  anywhere in the fleet today; a relaunch satisfies "no release."
- N>2 provider abstraction / a provider registry framework. Only Anthropic and
  OpenRouter must work; a third provider is not built or proven now.
- Automatic/self-reactive provider fallback. The dial stays operator-controlled
  only.
- Per-node-class override granularity *within a single launch*. The operator
  override is whole-BC-repoint (which provider), not a per-node-class override
  matrix — the fleet default already varies per node-class via the tier+effort
  skeleton, but the testing override does not add a second axis.
- Cost/spend observability and cross-provider cost comparison — tracked
  separately as intent-003, sequenced after this brief.
- **Where the tier+effort→model mapping table is authored/pinned** — named as
  open; the Architect decides at dispatch, not the PO here.

**Named risk — flagged, not resolved** (cand-002): whether registering the new
OpenRouter agent-vault credential key is lead-dispatchable (per adr-028, the
broker is a lead-shop supporting service with its own lead-owned
integration-check surface, which suggests it may be) or requires a one-time
operator action outside the `shop-msg` model. This is a legitimate Architect
pre-state verification question, not a PO decision — the scenarios presuppose
the credential service already exists (`Given ... a registered OpenRouter
credential service is running`); provisioning that service is explicitly out of
scope for the scenario bodies themselves. Even in the worst case this is a
scoped one-time bootstrap step, not ongoing complexity, per cand-002.

**Two-BC dispatch split** (explicit, not left implicit): scenarios are
pre-split into the conventional per-BC feature directories so the Architect's
assignment step is a tag flip, not a re-sort:

- `features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature` —
  2 scenarios, targets **shopsystem-templates**.
- `features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`
  — 5 scenarios, targets **shopsystem-bc-launcher**.

Both files currently carry `@bc:unassigned @origin:brief-017` at the feature
level (the adr-056 D8 transitional marker) — the Architect assigns the real
`@bc:<name>` tag at dispatch, per this shop's PO/Architect boundary. Directory
placement already signals the intended target; the tag flip is mechanical.
Sequencing note for the Architect: the bc-launcher scenarios (L4, L5) reference
the templates-poured `MODEL_CODING`/`MODEL_REVIEW`/`MODEL_DEFAULT` placeholder
contract as a precondition; whether that makes templates a hard dispatch
dependency for bc-launcher's scenarios, or whether the two can proceed
independently against a stubbed/assumed contract, is a dispatch-ordering call
for the Architect (`bd dep`), not decided here.

**Pinned scenarios** (authored, hashed via the installed `scenarios hash` CLI
with block-only canonicalization, written on-disk directly above each
`Scenario:` line):

- `features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature`:
  `@scenario_hash:7653d06bddda72ed` — the poured skeleton expresses each pinned
  node-class as a fabro input placeholder, not a literal model ID;
  `@scenario_hash:8aab2c5c071e349f` — the abstract-labeled skeleton still pours
  as a static, verbatim artifact, no per-provider/per-model resolution at pour
  time.
- `features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`:
  `@scenario_hash:1d9d3777e3c3d8f5` (L1) — no override ⇒ Anthropic stays active
  (regression / default-preserving baseline); `@scenario_hash:b3054f5439369fa8`
  (L2) — explicit override ⇒ OpenRouter wins over the Anthropic default
  (precedence); `@scenario_hash:14290420156c5ee0` (L3) — the OpenRouter
  credential is brokered no-shim (dummy on node, real on wire);
  `@scenario_hash:22f2a5bda5c29044` (L4) — placeholder → literal model ID
  resolution via `-I` inputs, sourced from the provider-keyed mapping table;
  `@scenario_hash:c99e79ac24f56f5c` (L5) — end-to-end proof: a real dispatch
  completes on an OpenRouter-launched BC, no release required.

## Source (pre-modernization)

#### 1. The problem

fabro's LLM provider/model choice is baked into release-gated artifacts today:
a poured, verbatim `model_stylesheet` skeleton in shopsystem-templates'
`workflow.fabro` (ADR-057), and shopsystem-bc-launcher's engage-time provider
wiring. The fleet's only working LLM path — Anthropic, via the subscription
OAuth — is gated in a way that is fast-moving and unlikely to improve: proven
root cause, Anthropic rejects premium-model calls that lack the interactive
Claude Code system-prompt identity, which fabro's node requests never carry.
Concrete, already-realized cost of the release-gating: `lead-txhou` — a wrong
`claude-haiku-4-5` default got stuck in the poured skeleton and stayed wrong
until noticed, fixable only by a template release. See `intent-002` for the
full stakeholder record.

#### 2. The job-to-be-done

*When Anthropic's OAuth gating blocks or degrades fabro's substantive LLM
work, I want to point a BC's fabro workflow at a different provider/model by
relaunching the container with an operator-set value, so that I am not stuck
waiting on a template/launcher software release to react to a gating shift.*

#### 3. The outcome (observable behavior change)

- An operator can relaunch a BC container with an explicit provider override
  (`--llm-provider openrouter` / `BCLAUNCHER_LLM_PROVIDER=openrouter`) and
  that BC's fabro work runs against OpenRouter instead of Anthropic — with
  **no template release, no bc-launcher release, and no image rebuild.**
  Only the launch-time value and a container relaunch are required.
- With no override, a BC continues to run against the existing Anthropic
  subscription path, unchanged — this brief adds a dial, it does not flip the
  fleet default.
- A real `assign_scenarios` (or equivalent substantive-work) dispatch
  completes end-to-end on a BC launched with the OpenRouter override,
  resolving at least one non-trivial node-class (e.g. `.coding`) to a literal
  OpenRouter model ID. This is the proof bar cand-002 sets; §7 scenario
  L5 pins it.

Output (a new CLI flag, a new env var) is not the measure; the behavior
change — an operator can react to a provider-gating shift with a relaunch,
not a release — is.

#### 4. The pinned solution shape (from cand-002, not re-decided here)

Two elements, split across the two BCs that already own the relevant
surfaces (ADR-057's pin-ownership table, confirmed not newly decomposed):

- **shopsystem-templates** authors/pours `model_stylesheet` using one fabro
  `{{ inputs.<NAME> }}` placeholder per pinned node-class instead of a
  literal model ID: `.coding` → `MODEL_CODING`, `.review` → `MODEL_REVIEW`,
  `*` → `MODEL_DEFAULT`. The pour stays static and verbatim (ADR-057 D4
  unaffected) — templates does not resolve placeholders, does not own the
  mapping table, and does not know about providers.
- **shopsystem-bc-launcher** (a) selects Anthropic (default) or OpenRouter as
  the active provider via a launch-time operator value, riding a NEW
  agent-vault-brokered OpenRouter credential (no-shim, ADR-049 D3 shape); (b)
  resolves the three poured placeholders into literal, provider-specific
  model IDs by supplying them as fabro run `-I KEY=VALUE` inputs, looked up
  from a fleet-wide, provider-keyed mapping table (tier+effort → model ID per
  provider).

This resolution mechanism (`-I KEY=VALUE` reaching and resolving
`model_stylesheet`) was directly, empirically proven in cand-002's Evidence
section (isolated disposable-container probe) — cited here as settled, not
open.

##### Vocabulary (load-bearing)

- **`--llm-provider` / `BCLAUNCHER_LLM_PROVIDER`** — the launch-time
  operator-facing control naming the active LLM provider. Values: `anthropic`
  (default, unset-equivalent) | `openrouter`. New vocabulary this brief
  introduces, named by the PO following the existing
  `--agent-vault-broker`/`BCLAUNCHER_AGENT_VAULT_BROKER` naming convention
  (`bc_container_runtime_proxy.feature`). Naming is a procedural authoring
  choice, not a re-opened product decision.
- **`MODEL_CODING` / `MODEL_REVIEW` / `MODEL_DEFAULT`** — the three fabro
  input keys the poured `model_stylesheet` skeleton's `{{ inputs.<NAME> }}`
  placeholders bind to, one per pinned node-class (`.coding`, `.review`,
  `*`). This is the addressable contract shopsystem-bc-launcher resolves
  against; it is fixed by this brief, not left to the BC's naming discretion.
- **the fleet-wide provider-keyed model mapping table** — the (tier+effort ×
  provider) → literal-model-ID lookup shopsystem-bc-launcher consults to
  resolve `MODEL_CODING`/`MODEL_REVIEW`/`MODEL_DEFAULT`. Its concrete storage
  location/ownership is an **open question for the Architect** at dispatch
  time (cand-002 Rabbit holes) — not settled here. The scenarios below pin
  only that such a table exists and is consulted, not where it lives.
- **agent-vault OpenRouter credential service** — the new agent-vault
  credential key/service (analogous to the existing `github` service) that
  brokers the real OpenRouter API key onto the wire. Node-side dummy value:
  `OPENROUTER_API_KEY=__PLACEHOLDER__`.

#### 5. Scope

**In scope** (pinned by §7's scenarios):

- Launch-time provider selection (Anthropic default / OpenRouter override) on
  shopsystem-bc-launcher.
- The new agent-vault-brokered OpenRouter credential path, no-shim shape.
- Abstract per-node-class placeholders in the poured `model_stylesheet`
  (shopsystem-templates).
- bc-launcher's resolution of those placeholders to literal model IDs via
  fabro run `-I` inputs, sourced from the mapping table, keyed by active
  provider.
- One end-to-end proof: a real substantive dispatch completing on an
  OpenRouter-launched BC.

**Out of scope / explicit non-goals (do not scope these in — cand-002
Rabbit holes / No-gos):**

- True hot-reload / in-flight config mutation without a relaunch. Does not
  exist anywhere in the fleet today; a relaunch satisfies "no release."
- N>2 provider abstraction / a provider registry framework. Only Anthropic
  and OpenRouter must work; a third provider is not built or proven now.
- Automatic/self-reactive provider fallback. The dial stays
  operator-controlled only.
- Per-node-class override granularity *within a single launch*. The operator
  override is whole-BC-repoint (which provider), not a per-node-class
  override matrix — the fleet default already varies per node-class via the
  tier+effort skeleton, but the testing override does not add a second axis.
- Cost/spend observability and cross-provider cost comparison — tracked
  separately as `intent-003`, sequenced after this brief.
- **Where the tier+effort→model mapping table is authored/pinned.** Named
  above as open; the Architect decides at dispatch, not the PO here.

**Named risk — flagged, not resolved (cand-002):** whether registering the
new OpenRouter agent-vault credential key is lead-dispatchable (per ADR-028,
the broker is a lead-shop supporting service with its own lead-owned
integration-check surface, which suggests it may be) or requires a one-time
operator action outside the `shop-msg` model. This is a **legitimate
Architect pre-state verification question**, not a PO decision — the
scenarios in §7 presuppose the credential service already exists
(`Given ... a registered OpenRouter credential service is running`);
provisioning that service is explicitly out of scope for the scenario bodies
themselves. Even in the worst case this is a scoped one-time bootstrap step,
not ongoing complexity, per cand-002.

#### 6. Two-BC dispatch split (explicit, not left implicit)

This is a two-BC dispatch. Scenarios are pre-split into the conventional
per-BC feature directories so the Architect's assignment step is a tag flip,
not a re-sort:

- **`features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature`**
  — 2 scenarios, targets **shopsystem-templates**.
- **`features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`**
  — 5 scenarios, targets **shopsystem-bc-launcher**.

Both files currently carry `@bc:unassigned @origin:brief-017` at the feature
level (the ADR-056 D8 transitional marker) — the Architect assigns the real
`@bc:<name>` tag at dispatch, per this shop's PO/Architect boundary. The
directory placement already signals the intended target; the tag flip is
mechanical, not a re-derivation.

**Sequencing note for the Architect:** the bc-launcher scenarios (L4, L5)
reference the templates-poured `MODEL_CODING`/`MODEL_REVIEW`/`MODEL_DEFAULT`
placeholder contract as a precondition (`Given the poured
"/workspace/.fabro/workflow.fabro" model_stylesheet carries the node-class
input placeholders ...`). Whether that makes templates a hard dispatch
dependency for bc-launcher's scenarios, or whether the two can proceed
independently against a stubbed/assumed contract, is a dispatch-ordering call
for the Architect (`bd dep`), not decided here.

#### 7. Pinned scenarios

Authored, hashed, and written to disk at:

- [`features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature`](../features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature)
  - `@scenario_hash:7653d06bddda72ed` — the poured skeleton expresses each
    pinned node-class as a fabro input placeholder, not a literal model ID.
  - `@scenario_hash:8aab2c5c071e349f` — the abstract-labeled skeleton still
    pours as a static, verbatim artifact; no per-provider/per-model
    resolution happens at pour time.
- [`features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`](../features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature)
  - `@scenario_hash:1d9d3777e3c3d8f5` (L1) — no override ⇒ Anthropic stays
    active (regression / default-preserving baseline).
  - `@scenario_hash:b3054f5439369fa8` (L2) — explicit override ⇒ OpenRouter
    wins over the Anthropic default (precedence).
  - `@scenario_hash:14290420156c5ee0` (L3) — the OpenRouter credential is
    brokered no-shim (dummy on node, real on wire).
  - `@scenario_hash:22f2a5bda5c29044` (L4) — placeholder → literal model ID
    resolution via `-I` inputs, sourced from the provider-keyed mapping
    table.
  - `@scenario_hash:c99e79ac24f56f5c` (L5) — end-to-end proof: a real
    dispatch completes on an OpenRouter-launched BC, no release required.

`@scenario_hash` values above were computed by the PO via the installed
`scenarios hash` CLI (block-only canonicalization) and are written on-disk
directly above each `Scenario:` line, per this shop's authoring convention.

#### 8. Strategic trace

Serves the fabro-substrate reliability bet this session's `intent-002`
records and cand-002 shapes: the fleet's only working LLM path is gated in a
way that is "happening really fast and unlikely to be minimized" (stakeholder,
2026-07-14), and the AI-fleet build economics make a stuck substantive-work
pipeline pure waste. `lead-txhou` is the concrete, already-realized cost of
release-gated model configuration. This brief converts that release-gated
surface into an operator-controlled runtime dial, proven via a second real
provider (OpenRouter) rather than merely reshuffling defaults on the existing
single-provider path.

#### 9. What would NOT satisfy the stakeholder

- Shipping "OpenRouter support" as another baked, release-gated default —
  satisfies the literal ask while missing the actual problem
  (release-gating itself).
- A provider override that requires a template or launcher release to take
  effect (defeats "without requiring a software release").
- Literal per-provider model IDs baked into `model_stylesheet` (the
  2026-07-14 candidate revision this brief inherits: literal IDs would defeat
  the candidate's own purpose — provider switches would still require
  hand-rewriting every node-class mapping).
- Automatic/self-reactive fallback, or any mechanism that takes the dial away
  from the operator.
- N>2 provider machinery, per-node-class override matrices, or cost
  observability folded into this brief — all explicitly out of appetite here.
