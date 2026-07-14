---
type: candidate
id: cand-002
title: Operator-configurable fabro LLM provider/model selection, proven via OpenRouter
status: shaped
created: 2026-07-14
updated: 2026-07-14
authors: ["Claude (acting lead-pm)", dstengle]
description: Shaped candidate for a launch-time, operator-overridable fabro provider/model config surface, proven end-to-end with OpenRouter as a second provider alongside the existing Anthropic path.
derives-from: [intent-002]
session: sess-2026-07-14-a
experiments: []
brief:
parked-until:
beads: [lead-obfub, lead-txhou]
---

# cand-002 — Operator-configurable fabro LLM provider/model selection, proven via OpenRouter

## Problem

fabro's LLM provider/model choice is baked into release-gated
artifacts — a shell-script-appended provider block at
shopsystem-bc-launcher's container-engage time, and a poured, verbatim
`model_stylesheet` skeleton in shopsystem-templates' `workflow.fabro`
(ADR-057). The fleet's only working LLM path (Anthropic, via the
subscription OAuth) is gated in a way that's fast-moving and unlikely
to improve (proven root cause: Anthropic rejects premium-model calls
lacking the interactive Claude Code system-prompt identity). Concrete
cost of the current release-gating: `lead-txhou` — a wrong haiku
default got stuck in the poured skeleton and stayed wrong until
noticed, fixable only by a template release. See intent-002 for the
full record.

## Appetite

**Small batch** — a handful of dispatch/release cycles, not a
multi-week epic. Bounded explicitly to: one new provider working
end-to-end through a non-release-gated override surface. Not a
provider-abstraction framework, not a self-healing/auto-fallback
system.

## Solution sketch

An operator-settable, **launch-time** provider/model override,
following the fleet's already-solved pattern (confirmed by Architect
feasibility probe, not invented here): explicit launch-time
value wins over a rendered/poured default, the same shape as
`bc_container_runtime_proxy.feature`'s `--agent-vault-broker`
precedence rule and ADR-043's ops-coordinates
rendered-default-with-environment-override pattern. "Without requiring
a software release" is satisfied by a **BC relaunch** (no rebuild, no
code change) picking up a new operator-set value — not by inventing
in-flight hot-reload, which does not exist anywhere in this fleet
today and is out of appetite to build.

Two elements, split across the two BCs that already own the relevant
surfaces (confirmed, not newly decomposed here) — **revised 2026-07-14
to add a tier/effort abstraction layer, see Changelog**:

- **shopsystem-templates**: authors/pours `model_stylesheet` using
  **abstract model-tier + thinking-amount labels per node-class**
  (e.g. a `.coding`/`.review`/`*` skeleton expressed as "capable tier,
  high effort" rather than a literal `claude-sonnet-4-5`), not literal
  provider-bound model IDs. This stays a static, verbatim pour
  (consistent with ADR-057 D4 — the skeleton's authoring cadence
  doesn't change, only what it's allowed to say changes).
- **shopsystem-bc-launcher**: extends its engage-time provider/
  credential wiring to (a) select OpenRouter or Anthropic as the active
  provider via a launch-time operator value, riding a NEW
  agent-vault-brokered credential (an OpenRouter-key analog to the
  existing `GITHUB_TOKEN` pattern — dummy-on-node, real-on-wire, no
  header-reshaping shim needed, unlike the Anthropic OAuth path), and
  (b) **resolve the poured abstract tier+effort labels into literal,
  provider-specific model IDs by supplying them as fabro run inputs
  (`-I KEY=VALUE`), the same proven mechanism `BC_NAME` already uses**.
  `model_stylesheet` is authored with `{{ inputs.X }}` placeholders per
  node-class (e.g. `.coding { model: {{ inputs.MODEL_CODING }} }`);
  bc-launcher supplies the resolved literal model ID for each such
  input at engage/dispatch time from the fleet-wide, provider-keyed
  mapping table. Confirmed by direct empirical probe — see Evidence —
  that fabro's templating genuinely reaches and resolves the
  graph-level `model_stylesheet` attribute; no novel file-patching
  mechanism is needed after all.

The mapping table (tier+effort → concrete model ID, per provider) is
the fleet-wide artifact your instinct named: it changes at the cadence
of "providers add/deprecate models," independent of both the
node-class→tier+effort assignments (stable, product-authored) and the
active-provider dial (fast-moving, operator-authored). Where exactly
this table itself is authored/pinned is an open ownership question,
not settled in this candidate — see Rabbit holes.

Proven end-to-end by one real `assign_scenarios` (or equivalent
substantive work) dispatch completing on a BC launched with the
OpenRouter override, resolving through at least one non-trivial
tier+effort node-class.

## Rabbit holes

- **True hot-reload / in-flight config mutation without relaunch.**
  Does not exist in this fleet today; building it is explicitly out —
  a relaunch satisfies "no release."
- **N>2 provider abstraction / provider registry framework.** Only
  Anthropic and OpenRouter need to work. The shape shouldn't preclude
  a third provider later, but a third is not built or proven now.
- **Per-node-class override granularity within a single BC.** The
  fleet default can already vary per node-class via the tier+effort
  skeleton, but the operator *override* for testing is whole-BC-
  repoint (which provider, and by extension which mapping table
  applies), not a per-node-class override matrix. Finer-grained
  override is a later slice if needed.
- **Tier/effort taxonomy depth.** Cut for appetite: MVP needs only
  enough tiers and effort levels to express the node-classes that
  exist today (e.g. a "capable" vs. "fast/cheap" tier, a small number
  of effort levels) — not a fully general N×M taxonomy mirroring every
  dimension a provider might expose. Grow it later if a real node-class
  need shows up.
- **RESOLVED 2026-07-14 by direct empirical probe (see Evidence) —
  templating DOES reach `model_stylesheet`.** Earlier drafts of this
  candidate claimed bc-launcher had a "proven precedent" for
  text-patching poured fabro def files, citing `BC_NAME`/`WORK_ID`
  delivery; that citation was wrong (see prior correction below) and
  left the resolution mechanism as a genuine go/no-go unknown. A
  disposable, isolated container probe (bc-base:latest image, `docker
  run --rm`, torn down after — no repo footprint) settled it directly:
  `fabro validate`/`preflight`/`run --dry-run` all confirm `{{ inputs.X
  }}` templating is evaluated inside the graph-level `model_stylesheet`
  attribute, resolving to a concrete model + provider. No novel
  mechanism is needed — this closes what was the candidate's single
  biggest risk.
- **New agent-vault credential-key registration path is not fully
  resolved.** The feasibility probe found ADR-028 frames the broker as
  a lead-shop supporting service with its own lead-owned
  integration-check surface (suggesting this may be lead-pinnable),
  but could not independently confirm whether registering a new
  credential key is lead-dispatchable or requires an operator action
  outside the shop-msg model (medium confidence either way). This is a
  **named risk, not a blocker**: even in the worst case it's a scoped
  one-time bootstrap step, not ongoing complexity — but the lead-po/
  architect should resolve it explicitly at brief/dispatch time rather
  than discover it mid-implementation.
- **Where the tier+effort→model mapping table itself is authored/
  pinned** (a new ADR-057-sibling artifact, most likely) is an open
  ownership question — Architect's call at dispatch time, not settled
  here.

## No-gos

Automatic/self-reactive provider fallback (operator-controlled dial
only, per intent-002). Cost/spend observability (tracked separately,
[[intent-003]] / a future candidate). Cross-provider cost comparison.

## Evidence / experiments

**2026-07-14 — Architect feasibility probe** (bounded, artifact-surface
only, ADR-018-conformant, no BC source read): three findings, all
high-to-medium confidence —

1. The fleet already has a solved, pinned pattern for operator
   override without a release (`bc_container_runtime_proxy.feature`
   `@scenario_hash:8a30298f2afde4c4`; ADR-043 D2 ops-coordinates
   rendered-default-with-override) — launch-time granularity, not
   hot-reload. No existing mechanism mutates a running container's
   config without relaunch.
2. OpenRouter's `Authorization: Bearer <key>` shape matches ADR-049
   D3's no-shim GitHub pattern, not D2's Anthropic OAuth-shim pattern —
   structurally simpler than the existing Anthropic credential path.
   New credential-key registration is needed; whether that's
   lead-dispatchable or operator-only is the one open risk above
   (medium confidence).
3. No existing `features/` scenario pins provider-selection or
   `model_stylesheet` mechanics either way (clean field, no
   `@scenario_hash` retirement needed); the assumed shopsystem-
   bc-launcher / shopsystem-templates split matches ADR-057's actual
   pin-ownership table and `structurizr/workspace.dsl` container
   boundaries exactly.

**2026-07-14 — second Architect feasibility probe** (tier+effort
indirection question, raised by product authority after initial
shaping): every observed `model_stylesheet` occurrence across the
artifact surface — including inside the canonical ADR-058 text itself
— is a literal CSS-like selector → literal-model-ID string, with no
variable/alias/template syntax observed (medium-high confidence "not
observed," not "confirmed absent" — fabro's own parser isn't
lead-readable per ADR-018). ADR-057 D4 pins the topology skeleton as
poured verbatim from a static hand-authored asset, which is
content-compatible with abstract-label authoring but cuts against a
provider-aware pour-time resolution step.

**CORRECTION (2026-07-14, same session, product-authority catch):**
this probe's original finding also claimed bc-launcher had "proven
precedent" for text-patching poured fabro def files, citing
`BC_NAME`/`WORK_ID` rewrite — sourced from `findings/fabro-spike/*`
material. That citation is WRONG and has been removed from the
solution sketch above. Direct verification against the canonical
ADR-058 (not spike material — this is exactly the failure mode this
shop's spike-precedence rule exists to prevent) and
`features/shopsystem-templates/fabro-dispatcher-ref/*` shows `BC_NAME`
is delivered as a fabro run **input** (`-I BC_NAME=<bc>`, templated via
`{{ inputs.BC_NAME }}`) and `WORK_ID` is delivered by the dispatcher's
ACP agent **materializing a fresh per-child wrapper `.toml`** at spawn
time — neither patches the graph `.fabro` file's content. There is no
existing precedent anywhere in this fleet for parameterizing a poured
graph definition's embedded text.

**2026-07-14 — direct empirical probe (resolves the above), run
isolated with zero repo footprint.** A disposable container
(`docker run --rm` from the fleet's own `ghcr.io/dstengle/
shopsystem-bc-base:latest` image, `fabro install --skip-llm` bootstrap,
no real credentials) was used to test a minimal scaffolded workflow
(`fabro workflow create`) with `model_stylesheet="* { model: {{
inputs.MODEL_DEFAULT }} }"` added to its graph header. Three
independent checks, all consistent:
1. `fabro validate` with no input bound: fails with fabro's own error
   `"undefined template variable inputs.MODEL_DEFAULT in graph
   attribute model_stylesheet"` — proving fabro parses and evaluates
   `{{ }}` templating inside `model_stylesheet` itself (not just agent
   `prompt=`/`goal=` text).
2. `fabro preflight … -I MODEL_DEFAULT=claude-haiku-4-5`: resolves
   cleanly to `LLM (claude-haiku-4-5) · Provider: anthropic` (the only
   warning is "provider not configured," expected — no real credentials
   were provisioned in the throwaway container).
3. `fabro run … -I MODEL_DEFAULT=claude-haiku-4-5 --dry-run
   --auto-approve`: SUCCEEDED end-to-end through the simulated LLM
   backend.

Container torn down immediately after (`docker rm -f`); `git status`
confirms no artifact landed in this repo beyond the typed candidate/
intent/session files already tracked here. **Conclusion: `-I
KEY=VALUE` fabro-run inputs + templating is a proven, sufficient
mechanism for resolving `model_stylesheet` — the same class of
mechanism `BC_NAME` already uses (this time correctly characterized).
No novel file-patching mechanism needs to be invented.** This resolves
the Rabbit hole below from "genuine go/no-go unknown" to closed.

## Resolution

**Committed 2026-07-14** by product authority (dstengle), after the
central open unknown (`model_stylesheet` templating reach) was closed
by direct empirical probe. Routed to lead-po for brief + Gherkin
scenario authoring.

## Changelog

- 2026-07-14 opened and shaped in sess-2026-07-14-a, deriving from
  intent-002, following a discovery session (sess-2026-07-14-a) that
  also produced intent-003 (cost observability, sequenced after this
  candidate as the structural blocker).
- 2026-07-14 revised (same session): product authority flagged that
  literal per-provider model IDs in `model_stylesheet` would defeat
  the candidate's own purpose (provider switches would still require
  hand-rewriting every node-class mapping). Added a fleet-wide
  tier+effort→model mapping table as a core element (not a later
  slice), shifting bc-launcher's slice to own both provider/credential
  wiring AND the mapping/resolution logic, and narrowing templates'
  slice to authoring the abstract-labeled skeleton only. This is a
  genuine, bounded scope addition versus the original sketch, not a
  cosmetic edit — logged plainly rather than folded in silently.
- 2026-07-14 corrected (same session): product authority caught that
  the "`BC_NAME`/`WORK_ID` rewrite" precedent cited for the resolution
  mechanism was factually wrong — sourced from stale
  `findings/fabro-spike/*` material rather than the canonical,
  current ADR-058. Verified directly against ADR-058 and
  `features/shopsystem-templates/fabro-dispatcher-ref/*`: neither value
  is delivered by file text-patching; both use fabro's input/overlay
  mechanisms instead. Removed the false precedent, elevated "does
  templating reach `model_stylesheet`" from a light-validation
  footnote to the candidate's central open unknown, pending a bounded
  empirical probe before commitment.
- 2026-07-14 resolved (same session): ran the bounded empirical probe
  directly (isolated disposable container, zero repo footprint, torn
  down after — see Evidence). Confirmed fabro's templating genuinely
  reaches and resolves `model_stylesheet`; the resolution mechanism
  needs no novel invention, just fabro-run `-I` inputs, the same class
  of mechanism `BC_NAME` already proves out. Candidate's central open
  unknown is closed.
- 2026-07-14 committed by product authority; routed to lead-po for
  brief + Gherkin scenario authoring.
