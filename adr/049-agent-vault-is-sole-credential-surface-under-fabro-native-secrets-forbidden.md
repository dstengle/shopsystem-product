# ADR-049 — Agent-vault is the SOLE credential surface under fabro; fabro's native secret system is a FORBIDDEN surface (vault-`__PLACEHOLDER__` + `HTTPS_PROXY` + anthropic-oauth-shim path)

- Status: Accepted (2026-07-01)
- Date: 2026-07-01
- Implements: hard-invariant #2 of the fabro spike (epic
  [`lead-6k1r`](#), GREEN 2026-07-01) — "credentials via agent-vault, NOT
  fabro secrets" — formalized here as an enforceable contract. This is a
  David-explicit invariant; it is SETTLED and not re-litigated, only pinned.
- Anchored on (decisions this builds on — NOT re-decided here):
  - [ADR-048](048-fabro-as-alternable-in-container-bc-orchestration-substrate.md)
    — the umbrella substrate decision: fabro is an alternable in-container
    BC-orchestration substrate replacing only the Seam(a) launch+loop. This
    ADR realizes ONE of the three invariant surfaces that substrate must not
    touch (the credential surface); it does not re-decide the substrate.
  - [ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
    — agent-vault is a lead-shop supporting service that brokers real
    credentials on the wire; the existing injection substrate this ADR
    routes fabro traffic through, unchanged.
  - [ADR-045](045-agent-vault-ca-pem-is-inline-pem-content-not-a-path.md)
    — `AGENT_VAULT_CA_PEM` carries inline PEM content (real newlines); the
    MITM trust material the shim's `urllib`/`SSL_CERT_FILE` chain validates
    against so the brokered TLS to `api.anthropic.com` verifies.
  - [PDR-017](../pdr/017-agent-vault-broker-standup-and-fleet-credential-flip.md)
    — agent-vault broker stand-up + the fleet credential flip (dummy on the
    node, real on the wire); the fleet posture fabro is brought into parity
    with rather than diverging from.
  - [ADR-018](018-empirical-verification-is-contract-surface.md) /
    [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) —
    empirical verification is the contract/artifact surface; the lead never
    harvests credentials (or anything) by reading fabro child outputs. This
    ADR is grounded on the spike findings artifact surface, per the
    spike-vehicle track (ADR-029/030/032).
- Bead: `lead-6k1r` (P2, the fabro spike epic — graduation output). Realizes
  hard-invariant #2 as durable canon. Anchored on ADR-048; sibling to
  ADR-050 (launch parity) and ADR-051 (loop graph). Origin bead
  [`lead-f6ta`](#) is superseded by ADR-048 (the umbrella), not by this ADR.

## Context

The fabro spike (epic `lead-6k1r`, ADR-029/030/032 spike vehicle, graduated
via PDR-014) evaluated fabro v0.254.0 as an in-container BC-orchestration
substrate. The single load-bearing unknown of the whole spike was
credential-shape: fabro ships its own native secret system (a file-backed
vault, `vaults/default/secrets.json`), but hard-invariant #2 — set by David —
requires that credentials flow through the fleet's existing **agent-vault**
broker (ADR-028) and that fabro's native secret store never hold or move a
real credential.

The blocker surfaced in Slice 3: the fleet agent-vault injects the Anthropic
credential as an **OAuth Bearer** (rewrites `Authorization: Bearer` +
`anthropic-beta: oauth-2025-04-20`), whereas fabro's Anthropic adapter
authenticates with **`x-api-key`** and has no Anthropic-OAuth mode. The proxy
therefore left fabro's dummy `x-api-key` untouched and Anthropic rejected it
(`invalid x-api-key`). GitHub already worked (the proxy injects `GITHUB_TOKEN`
for a dummy Bearer). The spike closed this with a small header-shape shim, and
proved invariant #2 HELD under real (non-dry-run) LLM load. This ADR pins that
mechanism as a contract so the credential surface is a settled boundary for
any future fabro-orchestration BC, not a per-run improvisation.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

No BC source read, run, or git-observed. Verified against this repo's
`features/`, `adr/`/`pdr/`, `shop-msg` mailbox state, and scenario hashes via
the installed `scenarios hash` CLI on 2026-07-01. Per spike-vehicle ADR-032,
the spike artifact surface is `findings/fabro-spike/*.md` (the returned
findings), cited as the grounding evidence:

1. **The credential-shape root cause is recorded**
   (`findings/fabro-spike/03-fabro-launch.md` §(b), `03c-shim-u5-close.md`):
   header-shape mismatch — agent-vault injects Anthropic as OAuth `Bearer` +
   `anthropic-beta: oauth-2025-04-20`; fabro's `anthropic` adapter speaks
   `x-api-key`; the proxy leaves `x-api-key` untouched, so Anthropic rejects
   the dummy. GitHub tool calls already worked (proxy injects `GITHUB_TOKEN`
   for a dummy Bearer).

2. **The fix — anthropic-oauth-shim — is a durable artifact**
   (`findings/fabro-spike/fabro-defs/anthropic-oauth-shim/`, described in
   `03c` and `03-fabro-launch.md` §(d)): a ~180-line Python-stdlib reverse
   proxy at `127.0.0.1:8788` that per-request STRIPS `x-api-key`, ADDS
   `Authorization: Bearer <dummy>` + `anthropic-beta: oauth-2025-04-20`
   (keeping `anthropic-version`), and FORWARDS to `api.anthropic.com` through
   the environment `HTTPS_PROXY` — where agent-vault injects the REAL OAuth
   credential. `urllib` inherits `HTTPS_PROXY` + `SSL_CERT_FILE` (the ADR-045
   MITM CA) from the env; the shim stores no secret, only rewrites header
   shape. fabro points at it via the `[llm.providers.anthropic] base_url =
   "http://127.0.0.1:8788/v1"` override — the adapter stays `anthropic`, so
   the shim speaks native Anthropic Messages format both directions and NO
   format translation was needed (the `openai_compatible` fallback was
   avoided).

3. **Invariant #2 PROVEN preserved on the wire**
   (`03c-shim-u5-close.md` §"Invariant #2 — PRESERVED",
   `03-fabro-launch.md` §(b)): fabro's own vault
   `fabro-defs/vaults/default/secrets.json` = `__PLACEHOLDER__` for BOTH
   `ANTHROPIC_API_KEY` and `GITHUB_TOKEN` (unchanged); the server's
   `ANTHROPIC_API_KEY` env is a dummy (`sk-ant-DUMMY-placeholder-proxy-injects`)
   that the shim discards and never forwards; the `gh` token handed to a node
   is a dummy and agent-vault substitutes the real one on the wire. `fabro
   model test --model haiku` → `ok` (was `invalid x-api-key`); a node's own
   LLM call `✓` and its `gh api user` → `{"login":"dstengle"}`, both through
   the proxy with the vault at `__PLACEHOLDER__` (passing runs
   `01KWDQMQR0E4DR9851RJKFXHFN`, `01KWDQNE9ZKQNTJSQ7KCYJ5CEK`).

4. **HELD under real LLM load across the whole spike**
   (`04-goal-demo.md` §3 invariant #2 row: "All real LLM traffic went
   dummy-`x-api-key` → in-container anthropic-oauth-shim → container
   `HTTPS_PROXY` → agent-vault (real OAuth) → `POST /v1/messages 200`. Real
   GitHub token only on the wire … Nothing real ever written to/read from
   fabro's vault"; `05-structural-loop.md` §3.2: "the load-bearing invariant
   #2 and it was intact on every run"). This is the ONE invariant the spike
   flags as load-bearing, and it held on every run including the structural
   Slice-5 re-run.

5. **@scenario_hash retirement enumeration — EMPTY (nothing retired).**
   `grep -r "@scenario_hash" features/` carries NO pin for fabro credential
   orchestration; the existing credential pins live under
   `features/bc-launcher/` (45 claude-oauth-brokered, 46 github-brokered, 47
   agent-vault-reachability gate, 50 no-real-credential-observable) and
   `features/launcher-credentials/`, and they pin the **bc-container** launch
   path, NOT fabro. This ADR DISTINGUISHES from, and does not duplicate or
   retire, any of those. No pinned coverage is superseded; the graduation
   authors a NEW `features/fabro-orchestration/02-…` scenario (below).

## Decision

### D1 — Agent-vault is the SOLE credential surface under fabro; the fabro native secret system is a FORBIDDEN surface (realizes hard-invariant #2; anchored on ADR-048, ADR-028)

Under fabro in-container orchestration, **every real credential is brokered by
agent-vault (ADR-028) and only appears on the wire.** fabro's native secret
system (its file-backed vault) is a FORBIDDEN surface: it MUST hold only the
literal sentinel `__PLACEHOLDER__` for every credential key it declares
(`ANTHROPIC_API_KEY`, `GITHUB_TOKEN`), and no real credential is ever written
to it or read from it. A fabro definition that stores or reads a real secret
from the native vault violates this contract. This is the credential-surface
analog of ADR-048's rule that the substrate replaces the Seam(a) launch+loop
ONLY and never the three invariant surfaces.

### D2 — The Anthropic credential path is the anthropic-oauth-shim bridge: dummy `x-api-key` → shim → `HTTPS_PROXY` → agent-vault (real OAuth) → 200 (implements the invariant #2 mechanism; anchored on ADR-045)

The load-bearing header-shape mismatch (fabro `x-api-key` vs fleet OAuth
`Bearer`) is bridged by the **anthropic-oauth-shim**, a small stdlib reverse
proxy that per-request strips the dummy `x-api-key`, adds
`Authorization: Bearer <dummy>` + `anthropic-beta: oauth-2025-04-20`, and
forwards to `api.anthropic.com` via the environment `HTTPS_PROXY`, where
agent-vault injects the real OAuth credential. fabro is pointed at the shim
with `[llm.providers.anthropic] base_url` so the adapter stays `anthropic`
and no format translation is introduced. The shim STORES NO SECRET — it only
normalizes header shape so the existing agent-vault substrate performs the
injection it already does for every other BC. TLS to the shim's upstream
verifies against the ADR-045 inline-PEM MITM CA (`SSL_CERT_FILE`).

### D3 — The GitHub credential path needs no shim: a dummy token on the node, the real token only on the wire (implements the invariant #2 mechanism; anchored on ADR-028)

GitHub already conforms: fabro nodes carry a DUMMY `GITHUB_TOKEN`/`GH_TOKEN`
and agent-vault substitutes the real token on the wire (proxy injects
`GITHUB_TOKEN` for a dummy Bearer). The real GitHub token appears ONLY on the
wire and never in fabro's native vault. (Env-plumbing note, scoped, not part
of the contract: the `provider=local` sandbox additionally requires the git
token to be supplied inline in the command because the ACP coding agent
strips credential-shaped env vars — this is a local-sandbox detail, not the
in-container drop-in target, per `03c` §"Outbound tool-call env".)

## Consequences

- **The credential surface is a settled boundary.** Any future
  fabro-orchestration BC inherits a fixed contract: native vault =
  `__PLACEHOLDER__` only, real creds via agent-vault on the wire. This is the
  credential leg of the ADR-048 umbrella (which names this ADR as one of its
  three realizing decisions, alongside ADR-050 launch parity and ADR-051 loop
  graph).
- **No new credential-injection machinery is introduced.** fabro is brought
  into parity with the existing fleet agent-vault posture (ADR-028, PDR-017);
  the shim is a ~180-line shape-normalizer, not a new broker or secret store.
- **The last load-bearing spike blocker is closed durably.** U5 (the
  `x-api-key` vs OAuth-Bearer mismatch) was the single unknown that gated the
  spike; pinning the shim path as contract means graduation does not re-open
  it.
- **The graduation scenario `features/fabro-orchestration/02-agent-vault-only-credential-injection.gherkin`
  pins this ADR.** It asserts: fabro native vault holds only `__PLACEHOLDER__`;
  a dummy `x-api-key` request flows through the in-container anthropic-oauth-shim
  → `HTTPS_PROXY` → agent-vault → real OAuth 200; the real credential appears
  ONLY on the wire, never in fabro's secret store. It DISTINGUISHES from
  bc-launcher 45/46/50 (which pin the bc-container path) and does not
  duplicate them. Per defense-in-depth, the Architect VERIFIES its
  block-only `@scenario_hash` (via the installed `scenarios hash` CLI) rather
  than introducing it; that hash — verified to reproduce at graduation
  reconcile — is `9c7b4e8280665239`.
- **No `@scenario_hash` retired** (pre-state finding 5): the bc-launcher
  credential pins remain valid; this ADR pins the fabro-native path
  additively.

## Follow-ups / dependencies (named, not designed here)

- **The `provider=local` env-plumbing workarounds are NOT the in-container
  contract.** The `[run.environment.env]` proxy/CA overlay and the inline git
  token (03b/03c) are local-sandbox specific; in the real bc-launcher
  in-container target the container already carries `HTTPS_PROXY` + CA, so
  those workarounds fall away. The real drop-in on `bc-container launch`
  (manifest/broker/clone machinery, which provisions the proxy/CA the shim
  needs) is a follow-up bead — flagged with the ADR-050 launch-parity caveat,
  not designed here.
- **Shim packaging / co-location.** The anthropic-oauth-shim currently lives
  as spike-defs furniture (`fabro-defs/anthropic-oauth-shim/`). Whether it is
  packaged into the bc-base image, rendered by shop-templates, or shipped with
  a fabro-orchestration BC is a packaging follow-up (bead, not designed here).

## Alternatives considered

- **Use fabro's native secret system for real credentials.** Rejected (D1):
  it violates David-explicit hard-invariant #2 and would fork credential
  authority away from agent-vault (ADR-028) — two credential surfaces, one of
  them outside the fleet broker. The whole spike was scoped to prove this is
  avoidable, and it is.
- **Translate to the `openai_compatible` adapter to reach the OAuth path.**
  Rejected (D2): the `anthropic` adapter accepts a `base_url` override, so
  keeping the adapter `anthropic` lets the shim speak native Anthropic
  Messages format both directions with NO translation layer
  (`03c-shim-u5-close.md` §"PREFERRED path"). Translation is strictly more
  surface and a lossy-format risk for no benefit.
- **Teach agent-vault to inject Anthropic as `x-api-key` (change the broker).**
  Rejected (D2): the fleet OAuth-`Bearer` posture is shared by every other BC
  (PDR-017); changing the broker to accommodate fabro's adapter shape would
  regress the fleet. Normalizing at a tiny per-fabro shim keeps the broker and
  every other BC untouched — fabro conforms to the fleet, not the reverse.
- **Bake a real credential into the container env and skip the broker.**
  Rejected (D1/D3): that re-introduces exactly the host-filesystem /
  static-credential coupling ADR-026/ADR-028 eliminated, and would leave a
  real secret at rest inside the fabro process. The dummy-on-node,
  real-on-wire posture keeps the credential out of every at-rest surface.
