# Brief 020 — Fix fabro OpenRouter provider-registration shape (custom provider → native `openai` + `base_url` override)

**Status:** committed (2026-07-15)
**Authors:** David Stenglein (product authority), Claude (lead-po)
**Lead bead:** `lead-ifye3.2` (P2, CLOSED, shopsystem-bc-launcher) — the already-shipped
work this brief tightens via `request_bugfix`.
**Derives from:** [`brief-017`](017-fabro-llm-provider-model-selection.md) (the
original commitment) and a real, disposable-spike-verified diagnosis
conducted this session. This is a **fully-diagnosed bug fix**, not a new
discovery-stage shaping exercise — it does not re-litigate brief-017's job-to-
be-done, scope, or strategic trace; it corrects one implementation-level shape
decision that brief-017 left underspecified ("a NEW custom fabro provider" was
the PO's own authoring choice in brief-017 §4's vocabulary section, not a
stakeholder requirement) and that a real end-to-end scout proved does not
work.
**Strategic trace:** inherits brief-017 §8 verbatim — this is a tightening of
the SAME strategic bet (fabro-substrate reliability; an operator-controlled
runtime dial instead of a release-gated default), not a new bet. No orphan
feature; no brief update needed to the strategic-intent record itself.

---

## 1. The bug, fully diagnosed

`lead-ifye3.2` shipped a mapping table (`src/bc_launcher/fabro/llm_provider.py`)
that registers a **new custom** fabro provider literally named `"openrouter"`
(`adapter = "openai_compatible"`), supplying OpenRouter-catalog-qualified
model strings such as `"anthropic/claude-sonnet-4.5"`. A real end-to-end
scout (this session, disposable spike containers + reading fabro's own source,
v0.254.0, `fabro-sh/fabro`) proved this registration shape never actually
completes a dispatch, for two independent reasons:

1. **Catalog auto-routing collision.** fabro's `resolve_provider()`
   (`lib/crates/fabro-llm/src/client.rs`) resolves the provider in order:
   explicit `request.provider` field → catalog auto-route by matching the
   model string against fabro's **built-in** model catalog → configured
   default provider. Fabro's built-in catalog maps `claude-sonnet-4-5` →
   provider `anthropic` (confirmed via `fabro model list`). Because the
   mapping table's model string is `"anthropic/claude-sonnet-4.5"`, catalog
   auto-routing matches it to the built-in `anthropic` provider, not the
   custom `openrouter` provider — reproducibly, with every prefix placement
   tried, all failing identically with `Provider 'anthropic' not registered`
   (only `openrouter` was ever registered under the launch-time override).
2. **A second, independent blocker even after bypassing #1** via an explicit
   `--provider openrouter` override: the workflow's startup precondition
   check (`fabro-workflow/src/pipeline/initialize.rs`, `graph_needs_llm` /
   `llm_source.resolve()`) runs inside a sandboxed worker subprocess that
   builds its LLM catalog independently of the full settings-merge pipeline
   fabro's own docs describe (`fabro-config/src/layers/llm.rs`: "default →
   user → server → project → workflow/run"). Debug logging showed
   `LLM client initialized from typed credentials providers=[] default=None`
   — the custom `openrouter` provider entry in `~/.fabro/settings.toml`
   never reaches this precondition check at all, even when the settings.toml
   is byte-for-byte structurally identical to fabro's own documented
   canonical example and its own passing unit test
   (`resolve_registers_custom_env_backed_provider`,
   `fabro-auth/src/env_source.rs`). The hardcoded failure message is the
   tell: `"Set ANTHROPIC_API_KEY or OPENAI_API_KEY"` — this precondition gate
   only recognizes those two specific, built-in-provider env vars, never an
   arbitrary custom provider's.

## 2. The fix that works (spike-proven, isolated container, zero repo footprint)

Do not register a new custom `"openrouter"` fabro provider at all. Instead,
use fabro's **native** `openai` provider identity — already fully recognized
by both the precondition gate and catalog auto-routing, since it IS a
catalog entry — and override **its** `base_url` to OpenRouter's endpoint:

```toml
[llm.providers.openai]
base_url = "https://openrouter.ai/api/v1"
```

with the credential riding the existing `OPENAI_API_KEY` env var
(dummy-on-node, real-on-wire via agent-vault's no-shim substitution — the
same pattern already used for `GITHUB_TOKEN`, just keyed as `OPENAI_API_KEY`
instead of the retired `OPENROUTER_API_KEY`). Proven empirically: this
bypasses BOTH the catalog-collision (provider is now consistently and
unambiguously `openai`, no routing ambiguity) AND the custom-provider
precondition gap (the precondition explicitly recognizes `OPENAI_API_KEY`).
The only remaining error observed in the isolated spike was
`Missing Authentication header` — assessed as an artifact of the spike having
no real agent-vault MITM broker on the wire (the isolated test container has
no `HTTPS_PROXY` at all), not expected to reproduce against the real
bc-launcher-managed launch (which has that broker active) — but this must be
verified for real once implemented, not assumed true.

**What does NOT change:** the mapping table's model *values* (e.g.
`"anthropic/claude-sonnet-4.5"`) — that is the correct, required shape for
OpenRouter's own API and is unrelated to this bug. Only the provider
*identity* the table registers under, and the credential env var name, move.

## 3. The outcome (observable behavior change)

- An operator who relaunches a BC container with `--llm-provider openrouter`
  gets a fabro launch that actually resolves and dispatches real LLM calls
  through OpenRouter — not one that fails at the first substantive node with
  `Provider 'anthropic' not registered` or a missing-credential precondition
  error. This is the SAME outcome brief-017 §3 already committed to
  ("a real `assign_scenarios` dispatch completes end-to-end... resolving at
  least one non-trivial node-class... to a literal OpenRouter model ID");
  this brief is what actually makes that outcome reachable, correcting an
  implementation shape that silently could not deliver it.
- The default (no-override) Anthropic path is unaffected — this bugfix
  touches only the OpenRouter branch's provider-registration and credential
  wiring.

## 4. Scope of this fix

**In scope:**
- Provider registration shape: native `openai` provider identity + `base_url`
  override, replacing the custom `"openrouter"` provider registration.
- Credential env var: `OPENAI_API_KEY` (node-side dummy, wire-side real via
  agent-vault MITM), replacing `OPENROUTER_API_KEY`.
- Re-verification, against the real bc-launcher-managed launch (real
  agent-vault broker, not the spike's brokerless isolation), that the
  `Missing Authentication header` residual is in fact a spike artifact and
  not a real defect.

**Out of scope (unchanged from brief-017, not re-opened here):**
- Everything in brief-017 §5's out-of-scope list (hot-reload, N>2 providers,
  automatic fallback, per-node-class override granularity, cost
  observability).
- The mapping table's model *values* and the tier+effort→model resolution
  mechanism (`-I` inputs) — proven correct and unaffected; see §5 below.

## 5. Scenario-by-scenario disposition against the existing 5 pinned hashes

Existing file:
[`features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`](../features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature).
Each of the 5 pinned hashes evaluated individually against this bug — no
blanket retirement:

| Hash | Scenario (L#) | Disposition | Why |
|---|---|---|---|
| `1d9d3777e3c3d8f5` | L1 — no override ⇒ Anthropic default | **UNAFFECTED, unchanged** | Asserts only the default (no-override) path; never touches the OpenRouter provider-registration shape this bug is in. |
| `b3054f5439369fa8` | L2 — override wins over default | **RETIRED**, superseded by `4c9f5b265c5098b7` | Its `Then` asserted "the active LLM provider set to `openrouter`" — the literal custom-provider identity this bug proves broken. Corrected assertion: the override registers under fabro's native `openai` identity with `base_url` overridden, and catalog auto-routing resolves unambiguously with no collision. |
| `14290420156c5ee0` | L3 — no-shim credential | **RETIRED**, superseded by `98b956adece2b7e0` | Its `Then` asserted the node-side dummy var is `OPENROUTER_API_KEY` — the credential shape this bug proves never reaches fabro's precondition check. Corrected assertion: dummy var is `OPENAI_API_KEY`. |
| `22f2a5bda5c29044` | L4 — placeholder → literal model ID resolution | **UNAFFECTED, unchanged** | Asserts only that `-I MODEL_CODING`/`MODEL_REVIEW`/`MODEL_DEFAULT` resolve to the mapping table's literal model-ID *values* per active provider — never asserts the provider-registration shape or credential env var. The model values it exercises (e.g. an OpenRouter-catalog-qualified string) are exactly what stays correct under the fix. |
| `c99e79ac24f56f5c` | L5 — real end-to-end dispatch proof | **UNAFFECTED, unchanged** | Its assertions (gated `work_done`, a literal OpenRouter model ID resolved) are still the correct acceptance bar — this is the outcome-level scenario this bugfix exists to make actually reachable. Its body needed no textual correction; the previously-reconciled `work_done` for `lead-ifye3.2` explicitly noted this scenario's completion claim was bound to graph-reachability fidelity only, not a live end-to-end run — it remains the honest open acceptance test for the corrected implementation. |

**Net: 2 of 5 scenarios retired and replaced (L2, L3); 3 of 5 stay valid,
unchanged (L1, L4, L5).** The corrected scenario bodies, new hashes
(`4c9f5b265c5098b7`, `98b956adece2b7e0`), and full RETIRED-scenario
provenance (original bodies, retained byte-identical for hash-provenance)
are written on-disk in the feature file per this shop's retirement
convention (precedent: `fabro_def_poured_projection.feature`'s brief-017/
lead-ifye3.1 retirement header).

## 6. OPEN QUESTION — flagged, not resolved here (Architect/BC decision)

`lead-ifye3.3` (CLOSED) registered the agent-vault fleet-vault credential
service as: service name `openrouter`, host `openrouter.ai`, token-key
`OPENROUTER_API_KEY`. This fix's credential-env-var correction
(`OPENAI_API_KEY` is what the BC-side code must read and what the node-side
dummy must be keyed as) raises a real open question this brief does **not**
silently resolve:

- The broker-side **service** registration (host = `openrouter.ai`) is
  almost certainly still correct as a distinct service — OpenRouter is still
  a distinct credential-bearing host separate from `api.openai.com`, and
  agent-vault's MITM substitution is host-scoped (see the corrected scenario
  `98b956adece2b7e0`'s new "scoped to requests directed at the OpenRouter
  host" clause, added precisely because two providers now legitimately share
  the *credential env-var name* `OPENAI_API_KEY` but must NOT share which
  host the real key is substituted onto).
- What is genuinely unresolved: whether the existing token-key
  `OPENROUTER_API_KEY` registration on that service must be **renamed** to
  `OPENAI_API_KEY` (so the BC-side no-shim substitution mechanism reads the
  right key name), or whether the BC-side code can be told to read the
  already-registered `OPENROUTER_API_KEY` key under a *node-side* env var
  that is presented to fabro AS `OPENAI_API_KEY` (i.e., the broker-side
  key-name stays `OPENROUTER_API_KEY`, only the node-side/fabro-facing
  variable name changes). Both are technically viable; which one is correct
  depends on how agent-vault's no-shim substitution binds broker key names to
  node-side env var names — a mechanism question for the Architect to verify
  empirically against agent-vault's actual behavior (ADR-028), not a product
  decision for the PO to guess at. **This brief does not presuppose an
  answer** — the corrected scenario `98b956adece2b7e0`'s `Given` still reads
  "a registered OpenRouter-host credential service is running" (host-scoped,
  name-agnostic), deliberately not asserting a specific broker-side
  service/key name, so the scenario does not need to change again once this
  question is resolved.

## 7. What would NOT satisfy this bugfix

- Reusing the retired custom `"openrouter"` fabro provider under a
  different name — the bug is structural (catalog collision + precondition
  gate), not name-specific; any new custom provider identity reproduces
  both failure modes.
- Silently guessing the agent-vault re-registration answer (§6) rather than
  flagging it for the Architect/BC to resolve empirically.
- Changing the mapping table's model *values* — they are correct and
  untouched by this fix; only the provider-registration and credential-env-
  var shape move.
