---
type: brief
id: brief-021
title: 'Second correction to fabro OpenRouter integration: a local egress shim replaces direct sandboxed-node routing, and run-wide `--model`/`--provider` flags replace per-node-class placeholder inputs'
status: ready
created: 2026-07-15
updated: 2026-07-17
authors: [David Stenglein (product authority), Claude (lead-po)]
description: Brief-020 corrected the provider-registration shape (native `openai` identity
derives-from: [adr-058, adr-063, adr-049, adr-010, adr-064]
---

## Summary

## Scope

## Source (pre-modernization)

#### 1. The bug brief-020 missed, fully diagnosed

Brief-020 corrected the provider-registration shape (native `openai` identity
+ `base_url` override, replacing a custom `"openrouter"` provider) and the
credential env var (`OPENAI_API_KEY`, replacing `OPENROUTER_API_KEY`) — but
assumed the sandboxed node's own outbound LLM call would reach agent-vault's
MITM broker via `HTTPS_PROXY`, the same way the already-shipped
`GITHUB_TOKEN` no-shim pattern works for a shell tool's outbound call. A real
scout this session, with a **live** agent-vault broker and a **real**
credential (not the brief-020 spike's brokerless isolation), reproduced
`Missing Authentication header` — not the "spike artifact" brief-020 §2
hoped for.

**Root cause, verified directly in fabro's own source**
(`lib/crates/fabro-sandbox/src/local.rs`): fabro's sandboxed agent-node
execution path calls `.env_clear()` before spawning the node subprocess.
Even where `[run.environment.env]` explicitly supplies values,
`ExplicitEnvPolicy::FilterSensitive` strips anything matching
`should_filter_env_var()` — any var ending in `_api_key` / `_secret` /
`_token` / `_password` / `_credential`. This is fabro's own **deliberate
security boundary**, not a config mistake it happened to trip.

**Confirmed independently, ruling out a credential-shape explanation
entirely:** with a deliberately-broken, unreachable proxy hostname
substituted for the real one, the sandboxed agent's error was **byte-
identical** to using the real proxy. The sandboxed LLM call never routes
through `HTTPS_PROXY` at all, regardless of configuration. No
credential-source trick — env var, fabro's own vault, custom provider,
native provider — fixes this from inside the sandbox: the request
structurally never reaches agent-vault.

#### 2. The fix that works: a local reverse-proxy shim, `openrouter-shim`

Architecturally identical in role to the already-shipped
`anthropic-oauth-shim` (`findings/fabro-spike/fabro-defs/anthropic-oauth-shim/`),
for the same underlying reason: the sandboxed agent talks to
`127.0.0.1:<port>` over **plain loopback** (no proxy needed for that hop),
and the shim itself — an **unsandboxed**, container-level process — makes
the real outbound call through the real `HTTPS_PROXY`, where agent-vault
substitutes the real credential on that hop instead.

**Unlike `anthropic-oauth-shim`, no header reshaping is needed.** OpenRouter
already speaks plain Bearer auth, matching what agent-vault substitutes; the
shim is a transparent forward proxy — strictly simpler than the Anthropic
shim, which must rewrite `x-api-key` into an OAuth-Bearer shape.

**Reference implementation** (a proven-working spike, ~70 lines,
stdlib-only `http.server` + `urllib`, attach verbatim as a BC-implementation
starting point — do not copy its contents into this brief, read it
directly):
`/tmp/claude-1000/-workspace/c1244c1b-b994-4143-9d07-59150e562cd5/scratchpad/openrouter-shim.py`

Two implementation gotchas, both bugs hit and fixed this session — the BC
must get both right:

1. **Upstream path is `https://openrouter.ai/api`, not bare
   `https://openrouter.ai`.** Getting this wrong hits OpenRouter's own
   website 404 page instead of their API (`curl` diagnosis caught this
   precisely).
2. **Client fingerprint matters — flag as an explicit verification step,
   do not assume it away.** Bare Python `urllib` got Cloudflare-blocked
   (`403`, an "Access denied... Cloudflare" HTML page) even with a correct
   real credential; `curl`'s TLS/HTTP fingerprint was not blocked. The
   reference shim uses `urllib` and hit this once. **Before considering the
   shim done, the BC must verify its actual implementation's client library
   does not trip Cloudflare bot detection** — check what
   `anthropic-oauth-shim` already uses successfully and match it, or use a
   library with a more standard fingerprint. Do not assume `urllib` is fine
   just because the reference spike eventually got a passing run with it.

#### 3. A real, named tradeoff: the fabro version requirement

Native `[llm.providers.openai].base_url` override support (what both
brief-020's fix and this shim-based correction depend on) **does not exist**
in the currently-pinned `v0.254.0` — confirmed: no `openrouter.toml` in its
built-in catalog, and (more importantly for this brief) no working
`base_url`-override path at all on that version. It requires fabro
**`>= v0.267.0-nightly.0`** — a **nightly pre-release**, not a stable
release. `v0.254.0` is fabro's own current "Latest" stable tag; there is no
newer stable release carrying this.

This is a real infrastructure decision
(`docker/bc-base/Dockerfile`'s `ARG FABRO_VERSION`) with real risk (nightly
builds, not stable releases) — named explicitly here as an **accepted
tradeoff, confirmed accepted by the product authority this session**, not
buried in scenario prose.

**This upgrade also removes `model_stylesheet` templating outright.**
Confirmed via fabro's own commit `911e080f3` ("Limit DOT templates to prompt
+ goal"): on `>= v0.267.0-nightly.0`, `{{ inputs.X }}` inside
`model_stylesheet` becomes literal, unparseable text — a hard parse error,
not a silent no-op. This directly invalidates `lead-ifye3.1`'s entire
abstract-placeholder-pour mechanism (the `MODEL_CODING` / `MODEL_REVIEW` /
`MODEL_DEFAULT` placeholders resolved via `-I` inputs, pinned by brief-017
and shipped to shopsystem-templates) — that mechanism cannot work on the
fabro version this fix requires. See §5 (open question) — this brief does
not retire or scope down that templates-side work; it only names that its
OpenRouter-path consumer no longer exists.

#### 4. The resolution: run-wide `--model`/`--provider` flags replace per-node-class `-I MODEL_*` inputs

Per **explicit product-authority direction this session**: per-node-class
model differentiation is being **dropped for now** — not permanently ruled
out, just deprioritized. Proven mechanism: `fabro run` already accepts
run-wide `--model <id> --provider <name>` flags (confirmed via
`fabro run --help`; this is not new fabro surface, just previously unused by
this integration). Tested with **zero `model_stylesheet` in the graph at
all** — a workflow with `.coding` / `.review`-classed nodes, run with
`--model anthropic/claude-sonnet-4-6 --provider openrouter`, and both nodes
correctly resolved to that model (confirmed in the agent session logs) and
completed for real: **$0.03, 10.3k tokens, both nodes, real OpenRouter
response.**

This is a **direct drop-in** to the dispatcher's existing per-child spawn
command — the ADR-058 dispatcher's per-child construction of
`fabro run --server "$FABRO_SERVER" "child-$W.toml" -I MODEL_CODING=...
-I MODEL_REVIEW=... -I MODEL_DEFAULT=... --auto-approve` becomes
`fabro run --server "$FABRO_SERVER" "child-$W.toml" --model <resolved>
--provider <active> --auto-approve`. The fleet-wide provider-keyed model
mapping table (ADR-063 — a shopsystem-bc-launcher-owned artifact) is
UNCHANGED as a lookup structure; only what bc-launcher does with the
resolved value changes (a CLI flag pair, not three `-I` inputs).

**Non-goal, named explicitly:** per-node-class model differentiation is
deprioritized, not removed forever. If a future need re-opens it (e.g. a
`.review` node genuinely needing a different, cheaper model than `.coding`),
that is a new candidate/brief, not implied or half-built by this one.

#### 5. One more precise, proven gotcha: only `base_url` may be touched

The sandboxed worker's precondition check (the "No LLM providers configured,
set ANTHROPIC_API_KEY or OPENAI_API_KEY" gate brief-020 first diagnosed) is
fragile in a specific, empirically-isolated way: overriding the native
`openai` provider's `base_url` alone (`[llm.providers.openai] base_url =
"..."`, nothing else) passes the precondition cleanly. Adding **any**
explicit `adapter` or `auth` override on top of that — even values that
should logically merge with the built-in catalog default — breaks the
precondition's recognition, and the run fails immediately with the "no
providers configured" error, before ever reaching a node. Pinned as its own
scenario (§7): only `base_url` gets touched, nothing else.

#### 6. Scope of this fix

**In scope:**
- Egress mechanism: a new `openrouter-shim` process (unsandboxed,
  container-level, loopback-listening) that the `openai`-identity
  `base_url` override points at, replacing brief-020's assumption that the
  sandboxed node could reach OpenRouter's real host directly.
- Credential substitution moves one hop out: dummy-on-node (unchanged from
  brief-020, `OPENAI_API_KEY=__PLACEHOLDER__`), real-on-wire on the shim's
  own outbound hop (not the sandboxed node's).
- Model-resolution mechanism: run-wide `fabro run --model/--provider` flags
  on the dispatcher's per-child spawn, replacing the retired per-node-class
  `-I MODEL_CODING`/`MODEL_REVIEW`/`MODEL_DEFAULT` inputs.
- The `FABRO_VERSION` bump this fix depends on, named as an explicit,
  accepted infrastructure tradeoff (§3) — the Dockerfile `ARG` change itself
  is an **Architect-level infra action**, not scenario content (see §7 —
  deliberately not pinned as a BDD scenario, only named here).
- Re-verification that the "only `base_url`, nothing else" precondition
  fragility (§5) is pinned as its own scenario.

**Out of scope (unchanged from brief-017/brief-020, not re-opened here):**
- Everything in brief-017 §5's out-of-scope list (hot-reload, N>2 providers,
  automatic fallback, per-node-class override granularity as a going-forward
  capability, cost observability).
- The mapping table's model *values* and its ownership (ADR-063) — untouched
  and unaffected by this fix; only how bc-launcher supplies the resolved
  value to `fabro run` changes.
- Deciding the disposition of `lead-ifye3.1`'s templates-side
  `model_stylesheet` placeholder work — see §8, named as an open question,
  not resolved here.

#### 7. Scenario-by-scenario disposition against the existing (brief-020-corrected) 5 pinned hashes

Existing file:
[`features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature`](../features/shopsystem-bc-launcher/fabro_llm_provider_openrouter_override.feature).
Each of the 5 hashes brief-020 left standing is evaluated individually
against this bug — no blanket retirement:

| Hash | Scenario | Disposition | Why |
|---|---|---|---|
| `1d9d3777e3c3d8f5` | L1 — no override ⇒ Anthropic default | **UNAFFECTED, unchanged** | Never touches the OpenRouter egress path or resolution mechanism this bug is in. |
| `4c9f5b265c5098b7` | brief-020's L2 — native `openai` identity, `base_url` set DIRECTLY to `https://openrouter.ai/api/v1` | **RETIRED**, superseded by `af07c326a031fafe` | `base_url` now points at the LOCAL `openrouter-shim`'s loopback endpoint, not OpenRouter's own host — the sandboxed node never reaches OpenRouter's host directly (§1). |
| `98b956adece2b7e0` | brief-020's L3 — `OPENAI_API_KEY` no-shim credential, MITM substitution on the sandboxed node's own wire hop | **RETIRED**, superseded by `05638241a033ef0c` | There is no sandboxed-node outbound wire hop a MITM proxy can intercept at all (§1) — substitution moves to the shim's own, unsandboxed outbound hop. |
| `22f2a5bda5c29044` | brief-017's L4 — per-node-class `-I MODEL_CODING`/`MODEL_REVIEW`/`MODEL_DEFAULT` resolution | **RETIRED**, superseded by `a3b2b6bebcee78f5` | The fabro version this fix requires removes `model_stylesheet` templating outright (§3); per-node-class differentiation is deprioritized (§4) in favor of run-wide `--model`/`--provider` flags. |
| `c99e79ac24f56f5c` | brief-017's L5 — end-to-end proof, asserting "no software release, BC-base image rebuild ... required" | **RETIRED**, superseded by `76badc67216f0d91` | This fix genuinely DOES require a one-time bc-base image rebuild (`FABRO_VERSION` bump, §3) — the original unconditional "no image rebuild" clause is no longer accurate. The superseding scenario scopes the "no further release" claim correctly: to the operator's per-launch provider-override action, given the one-time image-level precondition already satisfied beforehand. |

**Net: all 4 of the brief-020-surviving OpenRouter-specific hashes are
retired and replaced; L1 (the no-override default path) stays valid,
unchanged.** Two brand-new scenarios are also added with no prior hash to
supersede: the shim's own forwarding behavior (`7f55b8ee9e092692`) and the
`base_url`-only precondition fragility (`a28018af66182e33`) — both were
folded implicitly into brief-020's retired scenarios' prose but never had
their own dedicated pin. Full RETIRED-scenario provenance (original bodies,
retained byte-identical for hash-provenance, plus the brief-020-era
provenance already on disk) is written on-disk in the feature file per this
shop's retirement convention.

#### 8. OPEN QUESTION — flagged, not resolved here (Architect decision)

Whether `lead-ifye3.1`'s templates-side `model_stylesheet` abstract-
placeholder-pour work
(`features/shopsystem-templates/fabro_model_stylesheet_tier_labels.feature`,
`@scenario_hash:7653d06bddda72ed` and `8aab2c5c071e349f`) should be
**retired or scoped down**, now that the OpenRouter path no longer consumes
it (§3, §4), is genuinely open and **not decided here**:

- It may still be relevant for the Anthropic default path — brief-020/021
  never verified whether the Anthropic-subscription path is also moving to
  `>= v0.267.0-nightly.0` (in which case it loses `model_stylesheet`
  templating too, fleet-wide) or stays pinned to `v0.254.0` (in which case
  the placeholder mechanism keeps working there, just not for OpenRouter).
  This brief does not decide which fabro version the Anthropic default path
  runs on — that is itself part of the open question.
- If both paths converge on the newer fabro version, the templates-side
  placeholder mechanism has no remaining consumer anywhere in the fleet and
  is a candidate for retirement; if the Anthropic path stays on `v0.254.0`,
  the mechanism stays load-bearing for that one path only, and only the
  OpenRouter-path documentation/expectation needs correcting.
- This is an architecture/decomposition/fabro-version-pinning question, not
  a product-scope or vocabulary question — it is named for the Architect to
  resolve empirically against the artifact surface, not guessed at here.

Do not silently retire, scope down, or leave untouched the templates feature
file based on an assumption — resolve this explicitly before touching that
file.

#### 9. Bead disposition — `lead-y9o9y.1` (Architect action, named explicitly)

`lead-y9o9y.1` ("fix OpenRouter provider settings.toml missing
auth.credentials block", P1, parent `lead-y9o9y`) should be **closed as
superseded by this dispatch**, with a pointer to this brief and to
`lead-ifye3.2`'s corrected `request_bugfix`, not left open or routed as a
separate, smaller bugfix. Its diagnosis (a missing `auth.credentials` block)
is not wrong on its own terms, but it is not a sufficient fix on its own:
even a fully-correct `auth.credentials` block cannot work, for the same
root cause §1 diagnoses — the sandboxed agent-node LLM call never routes
through `HTTPS_PROXY` at all, so no credential-source shape reaches
agent-vault for substitution regardless of how complete the credentials
block is. Shipping `lead-y9o9y.1`'s narrower fix in isolation would ship a
fix already proven not to work this session. The shim-based correction (§2)
subsumes it: once the `openai` provider's `base_url` points at the local
`openrouter-shim` (not OpenRouter's host directly, per the corrected
scenario `af07c326a031fafe`), the question of what `auth.credentials` shape
belongs on the direct-to-OpenRouter registration is moot — that
registration shape is retired outright, not patched.

#### 10. What would NOT satisfy this bugfix

- Reusing brief-020's direct-to-OpenRouter `base_url` shape under a
  different provider identity name — the bug is structural (the sandboxed
  node's LLM call never routes through `HTTPS_PROXY`, full stop), not
  identity-name-specific; any shape that skips the local shim reproduces the
  same "Missing Authentication header" failure.
- Reusing per-node-class `-I MODEL_*` inputs on the fabro version this fix
  requires — `model_stylesheet` templating is structurally gone on that
  version, not merely deprioritized as a matter of taste.
- Silently deciding the §8 open question (retiring or leaving untouched the
  templates-side placeholder work) rather than flagging it for the Architect
  to resolve empirically.
- Assuming the reference shim's `urllib` client is fine without verifying
  the BC's actual implementation doesn't trip Cloudflare bot detection (§2
  gotcha 2) — this must be an explicit verification step, not an assumption.
- Treating the `FABRO_VERSION` bump as scenario content to pin in Gherkin —
  it is an Architect-level infra action (Dockerfile `ARG` change), named
  here as a precondition this dispatch depends on, not encoded as a BDD
  scenario.

#### 11. Addendum (lead-ifye3.7, 2026-07-15) — a pre-existing feature DID pin the baked fabro version literally, and had to move in lockstep

§10's last bullet says the `FABRO_VERSION` bump is deliberately not encoded
as scenario content in *this* brief's own feature
(`fabro_llm_provider_openrouter_override.feature`). That held. It did not,
however, account for a **separate, pre-existing** feature that already
pinned the baked fabro version as a literal Gherkin assertion:
[`bc_base_fabro_and_oauth_shim.feature`](../features/shopsystem-bc-launcher/bc_base_fabro_and_oauth_shim.feature)
(ADR-049 origin, predates brief-017) asserts, as product behavior, that a
launched bc-base container's `fabro --version` reports a specific literal
string, and that the centralized bump-rebuild poll compares against that
same literal as its baked pin.

Discovered when `lead-ifye3.7` (dispatched to bump
`docker/bc-base/Dockerfile`'s `ARG FABRO_VERSION` to `>= v0.267.0-nightly.0`
per §3) came back `status: blocked`: the BC did the bump correctly, then
found `test_bc_base_fabro_and_oauth_shim` red — 2 failures — because both of
that feature's scenarios hardcode the literal `v0.254.0`. The BC correctly
declined to rewrite scenarios it has no Gherkin-authoring authority over
(ADR-010 pin authority) and did not push the change, avoiding a fleet-wide
rebuild while red. It independently re-verified against `fabro-sh/fabro`'s
own source at tag `v0.267.0-nightly.0` that both capabilities this brief
depends on are present there and absent on `v0.254.0` — matching §3 exactly.

**Resolution:** `@scenario_hash:a3512aedb8763150` and
`@scenario_hash:4fc67c610cba6227` are RETIRED (byte-identical bodies kept
on-disk for hash provenance) and superseded by
`@scenario_hash:acc72693771d8c6b` and `@scenario_hash:ea139400f8efb546`,
identical in every respect except the pinned literal moving from
`"v0.254.0"` to `"v0.267.0-nightly.0"`. This is not new scope — it is the
same single fleet-wide `FABRO_VERSION` pin this brief already named as an
accepted tradeoff (§3), now confirmed to have a second, pre-existing
consumer that also had to move. No other live scenario in this repo pins
`v0.254.0` as an assertion (checked by grep across `features/`); the
remaining literal mentions are either historical/narrative prose (never
part of a `@scenario_hash` block) or retirement-provenance comments
correctly preserved byte-identical.

#### 12. Addendum (lead-85s41, 2026-07-15) — the L5 end-to-end scenario's own "no further image rebuild" claim was itself proven false by a live proof attempt

§7's disposition table already retired brief-017's original L5 end-to-end
scenario (`c99e79ac24f56f5c`) once, for asserting zero image rebuild when a
`FABRO_VERSION` bump was in fact required, and pinned its replacement,
`76badc67216f0d91`, which scoped the "no further release" claim to *only*
the launch-time provider override and a container relaunch, given that one
`FABRO_VERSION` precondition already satisfied. **That replacement's own
claim has now also been proven false** by a live end-to-end proof attempt of
this exact scenario, `lead-85s41` — the same "a sibling pinned scenario
needed a lockstep correction" shape as §11, one layer deeper.

**What was found.** `76badc67216f0d91`'s own When-clause — "bc-container
launch is run for a BC with the OpenRouter provider override and a
substantive `assign_scenarios` dispatch is delivered to it" — requires the
shopsystem-bc-launcher BC's own running container to perform a **nested**
`bc-container launch` of a target BC as part of executing that dispatched
work (this is literally what shopsystem-bc-launcher's job is: launching BC
containers). `lead-85s41` hit this directly: `FileNotFoundError: 'docker'`.
A router-run Architect dispatch (`lead-6tu6o`) then inspected the bc-base
image empirically — a throwaway `docker run --entrypoint /bin/bash` against
the same confirmed image digest used for the live relaunch — and confirmed:
no docker binary is baked into the image at all; on this image's Debian
trixie base, the `docker.io` apt package installs only the daemon
(`dockerd`), never the client; the separate `docker-cli` apt package
(client-only) is what actually produces a working `/usr/bin/docker` client,
and it is not currently baked into `docker/bc-base/Dockerfile`. A live
`--mount-docker-socket` relaunch was also confirmed necessary (an existing
opt-in, lead-only launch flag, off by default) so the baked client has a
socket to reach once it exists.

**Why this is not over-specification of the test.** The nested-launch
requirement is not incidental to the scenario — it is literally what the
When-clause names as the trigger under test, matching sibling scenario L1's
convention of naming a downstream target BC by name. The capability gap is
real (confirmed twice: once by the BC's own exhausted-every-route report,
once independently by the Architect's direct image inspection), not an
artifact of an over-built verification harness. The scenario's premise
needed correcting, not the test redesigning — the same posture §11 already
established for this brief's addendum pattern.

**Resolution:** `@scenario_hash:76badc67216f0d91` is RETIRED (byte-identical
body kept on-disk for hash provenance) and superseded by
`@scenario_hash:1cee6978cbf9ac53`, which keeps the same behavioral shape (a
real dispatch reaches a gated `work_done` through a launched BC with the
OpenRouter override, node-class model resolution confirmed via the
`openrouter-shim`) but corrects the false "no further ... image rebuild"
claim: **one** additional bc-base image-build change (baking `docker-cli`
into `docker/bc-base/Dockerfile`, alongside the already-satisfied
`FABRO_VERSION` precondition) is required before this scenario is
achievable, not zero. The corrected scenario also names the
`--mount-docker-socket` launch-time flag as a precondition Given, consistent
with §10's convention that the image-level `Dockerfile` change itself stays
an Architect-level infra action rather than scenario content — only the
*existence* of the precondition is pinned, not the `ARG` edit. The
underlying acceptance bar (gated `work_done`, real OpenRouter model
resolved via the shim) is unchanged. Full RETIRED-scenario provenance
(original body, retained byte-identical) is written on-disk in
`fabro_llm_provider_openrouter_override.feature`, following the same
retirement convention used twice already in that file.

**Follow-up (Architect action, named explicitly, not decided here):**
`lead-6tu6o` (bake `docker-cli` into `bc-base`, then relaunch with
`--mount-docker-socket` and retry `lead-85s41`'s live proof) is the
concrete infra + retry action this correction implies. This addendum does
not itself dispatch that work — it corrects the scenario the retry will be
measured against.

#### 13. Addendum (lead-lp4us, 2026-07-15) — the L5 scenario's "no further release" claim, corrected once already by §12, was proven false a second time by the FIRST retry with both §12 preconditions genuinely satisfied

§12 corrected `76badc67216f0d91` to `1cee6978cbf9ac53`, naming the
`docker-cli` bc-base image precondition explicitly instead of asserting
zero further release. **That corrected claim has now also been proven
false**, discovered by `lead-lp4us` — the first live retry run with BOTH
the `FABRO_VERSION` and `docker-cli` preconditions genuinely satisfied at
once (real nested `bc-container launch` succeeded; real HTTP-200 traffic
reached OpenRouter through the `openrouter-shim` for the first time this
lineage) — the same "a prior correction's own claim needed a further
lockstep correction" shape as §11 and §12, now one layer deeper still.

**What was found.** With the image-level preconditions satisfied, TWO
further software-level fixes — not zero — are required before a real
dispatch reaches gated `work_done`:

- **Defect A** (`shopsystem-templates`): its pour of
  `templates/fabro/workflow.fabro` still ships the retired
  `{{ inputs.X }}` `model_stylesheet` placeholder shape (the mechanism §7
  already retired lead-side as `22f2a5bda5c29044`/`a3b2b6bebcee78f5`, but
  whose templates-side pour was left an open question for the Architect).
  fabro `>= v0.267.0-nightly.0` hard-parse-errors on this shape
  (`fabro-workflow`'s own commit `911e080f3`, "Limit DOT templates to
  prompt + goal"), confirmed live: `Model stylesheet parse error /
  stylesheet_syntax / Validation failed` at
  `templates/fabro/workflow.fabro:84`, on the real binary, on any BC
  launched with `--orchestrator fabro`. Dispatched as `lead-ifye3.6`
  (`request_bugfix` to `shopsystem-templates`, retirement-only, no
  replacement shape specified per §6/§8 of this brief).
- **Defect B** (`shopsystem-bc-launcher`, own code): `engage.py:183`
  passes the active-provider NAME (`"openrouter"`) to `fabro run
  --provider`, but fabro is registered under the native identity
  `"openai"` (`constants.py:267`,
  `FABRO_OPENROUTER_PROVIDER_IDENTITY = "openai"` — the exact
  native-identity architecture this brief's §2 committed to and
  `af07c326a031fafe` already pins). `fabro run --provider openrouter`
  looks up a provider literally named `"openrouter"`, finds none, and
  fails the startup precondition before any node executes. Proven live: an
  identical run with `--provider openai` substituted cleared the
  precondition immediately and executed real nodes against real
  OpenRouter (11 real HTTP-200 calls, model
  `anthropic/claude-sonnet-4.5`). Dispatched as `lead-ifye3.10`
  (`request_bugfix` to `shopsystem-bc-launcher`).

**Why this is not over-specification of the test.** Same posture as §11
and §12: the nested-launch-to-real-completion requirement is not
incidental — it is literally the L5 scenario's own When/Then under test.
Both defects are proven with direct, non-simulated evidence (a real
nested launch, a real parse error at a cited file:line, a real
precondition failure and its real fix both observed on the wire) — not
speculative extrapolation. The scenario's premise needed correcting a
second time, not the test redesigned.

**Timing decision (PO judgment, not deferred).** Per this file's own
established §11/§12 precedent — correct a disproven claim immediately on
disproof rather than let it stand until the eventual successful retry
happens to reconcile it — this correction is made now, not deferred.
Both `lead-ifye3.6` and `lead-ifye3.10` are already dispatched and in
flight; the corrected scenario names both as explicit preconditions
rather than waiting to learn their exact final shape, matching how §12
itself named the `docker-cli` precondition before its own dispatch
(`lead-6tu6o`) had landed. If a third wrinkle surfaces once both fixes
report `work_done`, it gets the same treatment: a further immediate
correction, not silence.

**Resolution:** `@scenario_hash:1cee6978cbf9ac53` is RETIRED (body
deleted from the live scenario block per ADR-064 D2; the original text is
preserved byte-identical in an out-of-block provenance comment) and
superseded by `@scenario_hash:5d49031bab379ba6`, which keeps the same
behavioral shape (a real dispatch reaches a gated `work_done` through a
launched BC with the OpenRouter override, node-class model resolution
confirmed via the `openrouter-shim`) but names BOTH additional software
preconditions (the `shopsystem-templates` pour fix and the
`shopsystem-bc-launcher` provider-identity call-site fix) explicitly in
its Given clauses and in the corrected "no further release" Then clause,
instead of asserting zero further release. Full RETIRED-scenario
provenance is written on-disk in
`fabro_llm_provider_openrouter_override.feature`, following the ADR-064
D1/D2 convention (delete the retired body from the live block; record
provenance, including the original body text for audit, in a comment
block outside any canonical scenario region) — the same convention this
file has now used four times.

**Follow-up (Architect action, named explicitly, not decided here):**
once `lead-ifye3.6` and `lead-ifye3.10` both report `work_done`, retry
the live end-to-end proof against `@scenario_hash:5d49031bab379ba6`. This
addendum does not itself dispatch that retry — it corrects the scenario
the retry will be measured against, consistent with §12's own framing.

#### 14. Addendum (lead-ifye3.10, 2026-07-15) — L4's own scenario, not just L5's, needed a lockstep correction once the provider-identity call-site fix landed

§13 dispatched `lead-ifye3.10` (`request_bugfix` to `shopsystem-bc-launcher`)
to fix `engage.py:183`'s active-provider-NAME call-site bug: passing
`"openrouter"` (the operator-facing provider name) to `fabro run --provider`
instead of `"openai"` (fabro's registered native identity, per
`constants.py`'s `FABRO_OPENROUTER_PROVIDER_IDENTITY = "openai"`, the same
identity `af07c326a031fafe` already pins). `lead-ifye3.10` came back
`status: blocked` — correctly. Its own fix, already proven correct live this
session (an identical run with `--provider openai` substituted cleared the
sandboxed worker's startup precondition and executed real nodes against real
OpenRouter, 11 real HTTP-200 completions), turns this feature's own L4
scenario (`a3b2b6bebcee78f5`, "run-wide `--model`/`--provider` flags,"
pinned by §7's disposition table) RED: L4's own Then-clause still asserted
the pre-fix, buggy value — `--provider openrouter` — a value that
independently contradicts two OTHER live pins in the same file:
`af07c326a031fafe` (no custom `"openrouter"` fabro provider is ever
registered — fabro's provider lookup is literal, so `--provider openrouter`
names something that, by that pin's own text, cannot exist) and
`5d49031bab379ba6` (L5's current live scenario, which already assumes the
provider-identity call-site fix as a satisfied Given precondition — no
reading of L4 as still asserting `--provider openrouter` is consistent with
that). The BC correctly declined to push a change that would silently break
a live pin on a false premise, and instead proposed a specific replacement
wording with a pre-computed successor hash, computed via the canonical
`scenarios hash` CLI.

**PO ratification.** The BC's proposed wording is adopted verbatim, on the
merits: it correctly separates model-sourcing (still the mapping table) from
provider-sourcing (now correctly fabro's registered native identity, never
the operator-facing provider name) — the original clause's conflated
"sourced from the mapping table" phrasing, covering both model and provider
under one description, was itself part of the imprecision that let this bug
ship unpinned. The wording also matches the terminology already established
in §13's own defect-B description (`constants.py:267`,
`FABRO_OPENROUTER_PROVIDER_IDENTITY = "openai"`) rather than introducing new
vocabulary.

**Resolution:** `@scenario_hash:a3b2b6bebcee78f5` is RETIRED (body deleted
from the live scenario block per ADR-064 D2; original text preserved
byte-identical in an out-of-block provenance comment) and superseded by
`@scenario_hash:bb4f75cea78091c0` — independently reproduced via the
installed `scenarios hash` CLI against the committed text, not merely
trusted from the BC's own pre-computed value (which it also correctly
matched). Full RETIRED-scenario provenance is written on-disk in
`fabro_llm_provider_openrouter_override.feature`, following the same
ADR-064 D1/D2 convention this file has now used five times.

**Follow-up (Architect action, named explicitly, not decided here):** once
`lead-ifye3.10` reports `work_done` against the corrected wording, retry
the live end-to-end proof for L5 (`5d49031bab379ba6`), alongside
`lead-ifye3.6`, per §13's own follow-up. This addendum does not itself
dispatch that retry.
