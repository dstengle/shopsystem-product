---
id: ADR-026
kind: adr
title: BC credentials are brokered through an agent-vault server on the shopsystem network; host-filesystem credential coupling is eliminated for both Claude OAuth and GitHub
status: accepted
date: "2026-06-09"
description: BC credentials are brokered through an agent-vault server on the shopsystem network; host-filesystem credential coupling is eliminated for both Claude OAuth and GitHub
beads: [lead-architect, lead-jkwo, lead-mdng, lead-odqd, lead-v4ih, lead-vycn]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-004, ADR-018, ADR-019]
  pins: []
  related: []
---
# ADR-026 — BC credentials are brokered through an agent-vault server on the shopsystem network; host-filesystem credential coupling is eliminated for both Claude OAuth and GitHub

**Status:** accepted (2026-06-09); D2 open mechanism question RESOLVED (2026-06-10)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** the locked scope decision recorded on `lead-v4ih` (dave, 2026-06-09)
— *eliminate host-filesystem credential coupling FULLY: the agent-vault broker
brokers BOTH Claude OAuth AND GitHub credentials; no `~/.claude` mount, no
`~/.config/gh` / `~/.gitconfig` mount, no `BCLAUNCHER_HOST_HOME` / ZFS
placeholder. Invariant: zero host-filesystem credential coupling reaches a BC
container.* The seven behavioral scenarios that realize this ADR
(`features/bc-launcher/44–50`) are PO-authored and dispatched, not authored
here.
**Graduates:** [`findings/agent-vault-credential-spike.md`](../findings/agent-vault-credential-spike.md)
(`lead-jkwo`) — the throwaway spike that proved the brokered-credential plumbing
end-to-end (five assertions PASS) and returned a CONFIRM-with-caveats verdict.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule the pre-state findings honor; the
no-`repos/`-BC-source doctrine that makes `controller.py` line contents
un-verifiable from the lead — the spike findings are the admissible surface
here, not BC code read from the lead host);
[ADR-004](004-bc-launcher-as-new-bc.md) (containerized BC execution — the
mechanism the credential model plugs into);
[ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) (scenario-block-only
canonicalization — the hash basis for the dispatched scenarios).
**Related beads:** `lead-v4ih` (this ADR's tracking bead — Phase 2: ADR +
scenarios + dispatch), `lead-jkwo` (the confirmed spike, closed), `lead-vycn`
(the agent-vault design decisions: server topology, zero-bind-mount, two-server
bring-up — closed), `lead-mdng` / `lead-odqd` (the parent initiative:
agent-vault credential substrate for the fleet).

---

## Context

Every BC launch (`shopsystem-bc-launcher`) today builds a **read-write**
bind-mount of host `~/.claude` → `/home/vscode/.claude`, carrying the real
OAuth credential into every BC container, and additionally bind-mounts
`~/.config/gh` and `~/.gitconfig`. Two costs follow:

1. **Exfiltration surface.** A real, long-lived Claude OAuth credential and a
   real GitHub credential are present, readable, inside every BC container. Any
   BC agent — or anything that compromises one — can read them.
2. **Host-filesystem coupling.** The entire `BCLAUNCHER_HOST_HOME` /
   `_resolve_host_path` machinery exists only to make those mount sources
   resolvable on the ZFS-dataset host. The launcher is coupled to host
   filesystem layout, and the coupling is a recurring operational footgun
   (memory: "BC launch needs BCLAUNCHER_HOST_HOME … else docker run exit 125").

The `lead-jkwo` spike proved that an **agent-vault broker** running as a
container on the `shopsystem` network removes the Claude arm of this entirely:
the agent is wrapped as `agent-vault run -- claude`, which passes the child no
token and instead sets `HTTPS_PROXY` to the broker's MITM listener plus a
CA-trust env set; the container holds only a `__PLACEHOLDER__`
`.credentials.json` (read-only); the broker holds the only real token and
substitutes it as the upstream `Authorization: Bearer` header. The spike's
creds-free kill-line (assertion d) demonstrated a request reaching
`api.anthropic.com` through the proxy with the broker substituting the stored
credential.

The spike left one scope decision open: `~/.config/gh` and `~/.gitconfig` were
**still** bind-mounted, so the ZFS coupling persisted for GitHub. The user
locked that decision on 2026-06-09: **add a GitHub credential service to the
broker and eliminate the host-FS coupling fully**, rather than accept a partial
solution. This ADR records that locked decision and the topology/readiness
consequences; it does not re-open scope.

This is a mechanism / security-posture / operations decision with no
product-UX surface change to the framework's outward face — hence an **ADR**,
not a PDR.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD against the contract/artifact surface only — no BC
implementation code read, run, or git-observed. The lead host carries no
`repos/` BC source (ADR-018); the admissible surface here is this repo's
`features/`, the `findings/` spike, the installed `scenarios` CLI, and `shop-msg`
state.

1. **Scenario numbers 44–50 are new — no collision.** `features/bc-launcher/`
   stops at scenario 43 (`43-launch-pours-shop-templates-skills-into-bc-shop.gherkin`)
   before these seven were authored; 44–50 are the first occupants of those
   numbers. **Confirmed** (directory listing).
2. **The credential-mount behavior under change is currently host-FS-coupled,
   on the spike surface.** `findings/agent-vault-credential-spike.md` §"The
   problem being removed" records that `launch()` builds a **read-write**
   `~/.claude` → `/home/vscode/.claude` bind-mount carrying the real OAuth
   credential, that `~/.config/gh` and `~/.gitconfig` are bind-mounted, and that
   the `BCLAUNCHER_HOST_HOME` / `_resolve_host_path` machinery exists to resolve
   those sources on the ZFS host. This is the admissible artifact-surface
   evidence (a confirmed lead-side findings doc), not BC code read from the lead.
   **Confirmed.** The launcher's own mount inventory is not separately pinned by
   any `features/bc-launcher/` scenario today — there is no existing scenario
   asserting a `~/.claude` mount **is** present, which is consistent with this
   being a NEW capability the contract surface does not yet pin (see
   Discriminator below). The nearest existing mount contract is scenario 15
   (no sibling-BC / lead-workspace mounts), which is about *isolation from other
   repos*, not credential mounts.
3. **The `messaging_db_reachable` readiness precedent exists as cited.**
   `features/bc-launcher/33-launch-gates-on-messaging-db-reachability.gherkin`
   pins a launch-time readiness gate on `SHOPMSG_DSN` reachability — exit
   non-zero, name the DSN, withhold the startup prompt — and
   `features/bc-launcher/34` pins the readiness *sequence* as an idempotent
   barrier, `35` pins readiness-not-liveness health. The spike cites the
   in-code precedent as `driver.py:312` (`messaging_db_reachable`); the
   **contract-surface** precedent these new scenarios mirror is scenarios 33/34/35.
   **Confirmed** — scenarios 47 (agent-vault reachability gate) and 48 (compose
   both servers) are authored as direct mirrors of 33 and 34.
4. **The seven new scenarios assert the locked invariant coherently.** 44
   (host-view absence of all three mounts + no `BCLAUNCHER_HOST_HOME`
   requirement), 45 (Claude OAuth brokered, placeholder `.credentials.json`),
   46 (GitHub brokered via a broker GitHub service — the NEW arm), 47
   (agent-vault reachability gate), 48 (both-server readiness composition), 49
   (one-time out-of-band human paste as the only credential-provisioning step),
   50 (inside-container negative pin: no real credential observable). **Confirmed**
   by reading all seven files.

### What could NOT be verified (asserted, not confirmed)

- **`controller.py` / `driver.py` line contents** (the exact mount-build code,
  the `_resolve_host_path` body, the `driver.py:312` readiness call site) are
  **not on the lead host** (ADR-018). This ADR relies on the `lead-jkwo` spike
  findings as the admissible artifact-surface record of current behavior, and
  decides the behavioral contract, not the line contents. The BC realizes the
  line-level change.
- **Whether `agent-vault`'s GitHub template brokers `git`/`gh` over the same
  MITM HTTPS_PROXY path** as the Bearer services, or requires a distinct
  service/transport, was a mechanism question the spike did not exercise (the
  spike used only the three Anthropic Bearer services). **RESOLVED AFFIRMATIVELY
  (2026-06-10)** by the live canary — see the D2 resolution note below. Both the
  GitHub leg (Basic on `github.com`, proven by a brokered `git clone` exit 0) and
  the Claude leg (Bearer/OAuth on `api.anthropic.com`, proven by an authenticated
  200 completion with no client `Authorization` header) substitute over the same
  single MITM `HTTPS_PROXY` listener.

---

## Decision

### D1 — One credential model: an agent-vault broker on the shopsystem network brokers BOTH Claude OAuth AND GitHub; no host credential is mounted

bc-container launch mounts **no** host-filesystem credential material into a BC
container. Specifically:

- **No** `~/.claude` read-write directory mount. The container carries only a
  read-only `__PLACEHOLDER__` `.credentials.json` (`accessToken:"__PLACEHOLDER__"`).
- **No** `~/.config/gh` and **no** `~/.gitconfig` mount.
- **No** `BCLAUNCHER_HOST_HOME` / `_resolve_host_path` dependency for resolving
  any credential mount source — the machinery's only reason to exist is removed.

The agent process is wrapped as `agent-vault run -- claude …` (inside the tmux
`agent` session, preserving the readiness-marker sequence). `agent-vault run`
sets `HTTPS_PROXY` to the broker's MITM proxy listener on the `shopsystem`
network plus the CA-trust env set, and passes the child no token. Both Claude
OAuth (the three Anthropic Bearer services) and GitHub credentials are
substituted by the broker on the outbound request; the container holds neither
real credential. **Invariant (the kill-line):** zero host-filesystem credential
coupling reaches a BC container, and no real credential is observable from
inside it.

### D2 — Topology: TWO supporting servers on the shopsystem network — messaging postgres + the agent-vault broker — both reached by container name

The spike proved (finding 1) that the broker MUST run as a **container on the
`shopsystem` network**, reached by name, not as a host process (a host-process
broker on the dev-container loopback was unreachable from sibling BCs through
the docker gateway). The shopsystem network therefore now carries **two**
supporting servers a BC depends on before it can do useful work:

1. the **messaging postgres** (`SHOPMSG_DSN`) — pre-existing (scenario 33);
2. the **agent-vault broker** — new.

The broker is a long-lived service on the network, provisioned out of band
(D4), not stood up per launch.

**GitHub brokering wire-mechanism (recommendation; OPEN for BC confirmation).**
The spike exercised only the three Anthropic Bearer services over the single
MITM `HTTPS_PROXY` path. agent-vault ships a `github` template. **Recommended:
broker GitHub over the SAME MITM `HTTPS_PROXY` path** as the Bearer services —
one proxy listener, one CA-trust env set, GitHub added as another brokered
service on that listener — because it keeps the container's egress story
singular (one proxy, one trust anchor) and matches what the spike validated for
Anthropic. The alternative — a distinct service/transport for GitHub (e.g. a
git-credential-helper shim or an SSH-layer broker) — is heavier and fragments
the egress path. The BC should confirm at implementation that the `github`
template substitutes on the HTTPS proxy path for `git`/`gh`'s HTTPS traffic to
`github.com`; if it does not, the BC raises a `clarify` rather than silently
adopting a second transport. Scenario 46 pins the *outcome* (an authenticated
GitHub op succeeds through the broker with no mounted credential) and is
transport-agnostic, so it holds under either resolution.

**D2 mechanism question — RESOLVED AFFIRMATIVELY (2026-06-10, live canary).**
The recommendation is confirmed: BOTH legs broker over the SAME single MITM
`HTTPS_PROXY` listener (the `av_agt_<token>:fleet@agent-vault:14322` path), one
CA-trust env set, no second transport. Evidence (recorded in full on bead
`lead-5jbc`, demonstrated from inside `bc-shopsystem-scenarios` relaunched
brokered on `bc-base:latest` with NO host credential mounts):

- **GitHub leg (Basic on `github.com`).** A brokered `git clone` returned exit 0
  with the container holding no GitHub credential — the broker substituted the
  `github-git` Basic credential (`GITHUB_USERNAME`/`GITHUB_TOKEN`) on the
  outbound HTTPS request to `github.com`. This is the spike's SB-2.
- **Claude leg (Bearer on `api.anthropic.com`).** A request to
  `https://api.anthropic.com/v1/messages` with **no client `Authorization`
  header** returned a real authenticated **200** completion (model
  `claude-haiku-4-5-20251001`, content "Pong!", usage input=8/output=4). The
  broker intercepted over the MITM proxy and substituted `Authorization: Bearer
  CLAUDE_OAUTH`; Anthropic accepted. This is strictly stronger than the spike's
  SB-3 (which only reached an app-layer 404 = transport/TLS/substitution OK
  without an auth round-trip): here both substitution AND the credential type
  are proven by a successful authenticated completion.

Both legs traverse one egress path (one proxy, one trust anchor), confirming the
"keep the egress story singular" rationale. The Claude credential is the
**refreshing OAuth credential type** (Token URL
`https://console.anthropic.com/v1/oauth/token`, Client ID
`9d1c250a-e61b-44d9-88ed-5944d1962f5e`, access + refresh token), so caveat (b)
"the static accessToken expires" is solved natively: the running broker
(`agent-vault 0.32.0`, commit `e01a925` = the pinned commit in agent-vault's
`docs/guides/oauth-claude-code.mdx`) auto-refreshes the access token within 5 min
of expiry via the stored refresh token. The static `CLAUDE_CODE_OAUTH_TOKEN`
credential the throwaway spike used is retired; the vault now holds `CLAUDE_OAUTH`
of the OAuth type. **Provisioning caveat (D4):** the refreshing OAuth credential
TYPE is NOT expressible through any agent-vault 0.32.0 CLI surface (`credential
set` / `proposal create --credential` are flat KEY=value / KEY=description only,
with no Token-URL / Client-ID / refresh-token / auth-method fields); it is created
via the dashboard Credentials tab. The *services* that reference it remain fully
scriptable (`service add --auth-type bearer --token-key CLAUDE_OAUTH`) — the
OAuth-refresh behavior lives in the credential object, not the service. This
provisioning split is recorded in `bin/agent-vault-provision`'s Claude step.

#### D2 addendum — the EXACT agent-vault 0.32.0 provisioning CLI surface (clarification, 2026-06-13, validated end-to-end by dummyco spike iter-5)

The D2 decision and the provisioning split above were originally written in
generic terms ("credential set" / "service add" / "agent create"). That
generic phrasing plausibly seeded `bin/agent-vault-provision` being first
authored against a **fictional** agent-vault CLI (the `agent-vault put` verb,
`lead-beym`) and against **kebab-case** credential keys (`lead-l95x`) — costing
the dummyco spike its iter-2→iter-5 grind. This addendum records the **exact,
validated** agent-vault 0.32.0 (commit `e01a925`) verb structure so the next
BC dispatch authors against the real surface, not a generic gloss. The full
flow ran **clean end-to-end against a live agent-vault 0.32.0 broker** in
dummyco spike iter-5 (`findings/dummyco-spike-iter-5.md`); iter-4
(`findings/dummyco-spike-iter-4.md`) located the casing wall and proved it the
last one via a live contract-surface probe (ADR-018).

The decision intent is unchanged: provisioning is scriptable down to the single
Claude-OAuth dashboard paste (D4). What is sharpened is *which verbs, nested
how, with what value-format rules*.

1. **Owner bootstrap = `agent-vault auth register --email <e> --password-stdin`.**
   The FIRST registrant against a fresh broker becomes the **instance owner**;
   on re-run against an already-owned broker the idempotent path is
   `agent-vault auth login --email <e> --password-stdin`. There is **no**
   `owner …` sub-verb — owner identity is established through `auth`.
2. **Vault = `agent-vault vault create <vault>`.** Top-level `vault` group;
   creates the named vault all subsequent credential/service objects live under.
3. **Credential = `agent-vault vault credential set <KEY>=<value> [<KEY>=<value> …] --vault <vault>`** —
   a sub-verb **UNDER `vault`** (`vault credential set`, not a top-level
   `credential`). Credential **KEYS must be SCREAMING_SNAKE_CASE**
   (e.g. `GITHUB_PAT`, `GITHUB_PAT_USER`); kebab-case is **rejected at runtime**
   with `Invalid credential key "…": must be SCREAMING_SNAKE_CASE`. **This
   casing rule is NOT discoverable from `--help`** — it surfaces only at the
   live broker. (This was the iter-4 wall, `lead-l95x`.)
4. **Service = `agent-vault vault service add --name <n> --host <host> --auth-type basic --username-key <KEY> --password-key <KEY> --vault <vault>`** —
   a sub-verb **UNDER `vault`** (`vault service add`). The GitHub leg is
   `--host github.com --auth-type basic` referencing the SCREAMING_SNAKE
   credential keys; it brokers `github.com` Basic over the same MITM proxy.
5. **Fleet agent token = `agent-vault agent create <slug>-fleet --token-only --vault <vault>:proxy`** —
   a **TOP-LEVEL `agent create`** that mints AND prints the `av_agt_` token.
   The `vault agent` sub-group only **ADDS an existing** agent to a vault; it
   does **NOT** mint. Use top-level `agent create` to mint.
6. **The one human-gated step (D4) is unchanged:** the refreshing Claude-OAuth
   credential TYPE has no CLI path in 0.32.0 (`vault credential set` is flat
   `KEY=value` only, with no Token-URL / Client-ID / refresh-token / auth-method
   fields), so it is pasted once into the broker dashboard's Credentials tab.
   The *service* that references it stays scriptable
   (`vault service add --auth-type bearer --token-key CLAUDE_OAUTH`).

**Methodology note (cross-ref the live-broker-probe discipline).** A
brokered-CLI provision contract must be validated against a **live broker**,
not authored from `--help` syntax alone: value-format constraints such as the
SCREAMING_SNAKE_CASE credential-key rule are **not `--help`-discoverable** and
surface only at runtime against the real broker (ADR-018 contract-surface
probe). The iter-2→iter-5 grind is the cost of skipping that validation; this
addendum is its payoff.

### D3 — Readiness composition: launch gates on the COHERENT readiness of both servers; the startup prompt is withheld if EITHER is down

Mirroring scenario 33 (`messaging_db_reachable`) for the second server, launch
adds an `agent_vault_reachable` readiness check, and the readiness barrier
(scenario 34's idempotent sequence) **composes both**: the barrier passes — and
the startup prompt is injected, the agent engages — only when BOTH the messaging
postgres AND the agent-vault broker are reachable. If either is unreachable,
launch exits non-zero, names the failing server's configured address, and
withholds the startup prompt (scenarios 47, 48). Health follows
readiness-not-liveness (scenario 35 extended): a container whose broker is
unreachable reports `unhealthy` despite a live process (scenario 47, second
scenario). Rationale: under this model the broker holds the only copy of every
credential the agent needs, so launching against an unreachable broker presents
an engaged-but-broken agent that discovers the breakage mid-work on every
brokered request — exactly the failure class scenario 33 was authored to
prevent, now generalized to two servers.

### D4 — The only out-of-band step: a one-time human paste of the real credentials into the broker vault

The single unavoidable human-gated step is that a human, once, reads the real
Claude OAuth tokens (`accessToken`/`refreshToken` from a logged-in
`~/.claude/.credentials.json`) and — under the locked scope — the real GitHub
credential, and stores them in the broker vault (the proxy auto-refreshes the
OAuth tokens thereafter). This is an explicit **precondition** of brokered
launch, never an automated launch step: no part of bc-container launch reads,
writes, or transports a real credential, and no real credential is ever placed
inside a container (scenario 49). The spike corrected two predicted human walls
— owner registration, service/agent/token mint, and `ca fetch` are all
CLI-doable, NOT dashboard-only (spike finding 3) — so provisioning is scriptable
down to the single token-paste secret.

**Posture note.** The `AGENT_VAULT_TOKEN` (the proxy-role agent token) is
secret-ish but is **revocable/rotatable** and grants **only proxy
substitution** — it cannot itself yield the brokered credentials. This is
strictly better than shipping the raw, long-lived OAuth credential into every
container (scenario 50's third scenario pins this as the only credential-bearing
secret reachable inside the container).

### D5 — `agent-vault run --isolation container` vs bc-launcher's own `docker run` (recommendation; OPEN, deferred)

The spike noted (finding 2) that `agent-vault run --isolation container` can
itself launch the container (`--image`, `--mount`, `--share-agent-dir`, iptables
firewall) — an architectural *alternative* to bc-launcher building its own
`docker run`. **Recommended: KEEP bc-launcher's own `docker run` and use
`agent-vault run` only as the in-tmux agent wrapper** (`agent-vault run --
claude`), NOT `--isolation container`, for this slice. Rationale: bc-launcher's
`docker run` path already owns the network attach, the readiness barrier (D3),
the tmux session, the beads/messaging bring-up, and the mount inventory the
scenarios assert (scenario 44 inspects via `docker inspect` the mounts
bc-launcher itself controls); handing container creation to
`agent-vault --isolation container` would move that control surface and its
iptables firewall outside bc-launcher's owned launch path, a larger
re-architecture than the locked scope requires. The seven scenarios are written
against bc-launcher-owned `docker run` + `agent-vault run` *wrapping the agent*
(scenario 45: "invokes `agent-vault run -- claude`"; scenario 44: bc-launcher's
mount inventory). Re-homing container creation into agent-vault is recorded as
**deferred** future work, not adopted now; it does not block this slice.

---

## Cross-BC ownership / decomposition

All seven behavioral scenarios land on **`shopsystem-bc-launcher`** — the BC
that owns `launch()`, the mount inventory, the readiness barrier, and the tmux
agent invocation. There is no second BC in this slice: the broker is an external
service (provisioned out of band, D4), not a shopsystem BC, and the GitHub-arm
change is realized inside bc-launcher's launch path + broker configuration, not
in another BC's repo.

The message-type vehicle is decided against the discriminator at dispatch time.
**Pre-state finding 2** establishes that the agent-vault credential model does
not exist on the contract surface: no `features/bc-launcher/` scenario pins a
brokered-credential launch, an `agent_vault_reachable` readiness check, a
broker GitHub service, or the placeholder-credential / no-host-mount invariant.
The capability is genuinely **new** → **`assign_scenarios`** to
`shopsystem-bc-launcher`, work_id `lead-v4ih`. This is NOT a tightening of
existing behavior (the brokered model is absent, not unpinned) and NOT a flat
change (it introduces new behavioral scenarios), so neither `request_bugfix`
nor `request_maintenance` applies. No prior BC-side `@scenario_hash` is retired,
superseded, or contradicted by this dispatch — the scenarios add a new
credential model alongside the existing launch contract (33/34/35 remain in
force and are *composed with*, not replaced), so the conflicting-hash
enumeration returns empty.

---

## Alternatives considered

**Option A — Accept the persisting GitHub coupling (broker Claude only).** The
spike's default: broker Claude OAuth, keep `~/.config/gh` / `~/.gitconfig`
bind-mounted. Rejected by the user's locked scope decision (2026-06-09): a
partial solution leaves a real GitHub credential exfiltrable from every
container and keeps the ZFS host-FS coupling alive for the GitHub arm, so the
"zero host-FS credential coupling" invariant would be false. Full elimination is
the decision.

**Option B — Host-process broker instead of a network container.** Rejected —
the spike proved it the hard way (finding 1): a host-process broker on the
dev-container loopback was unreachable from sibling BCs through the docker
gateway. The broker must be a `shopsystem`-network container reached by name.

**Option C — `agent-vault run --isolation container` owns container creation.**
Considered (D5). Deferred, not adopted: it relocates the launch control surface
(network attach, readiness barrier, mount inventory, tmux, iptables firewall)
out of bc-launcher's owned `docker run` path — a larger re-architecture than the
locked scope needs. Recorded as future work.

**Option D — Bake real credentials into bc-base instead of brokering.**
Rejected outright: it makes the exfiltration surface permanent and image-wide
(every BC carries the real credential baked in), the exact opposite of the
invariant. `.claude.json` (config, not secret) MAY be baked/copied; real
credentials never are.

---

## Consequences

- A PO-authored `assign_scenarios` to **`shopsystem-bc-launcher`** (work_id
  `lead-v4ih`) carries scenarios 44–50: drop all three host credential mounts +
  the `BCLAUNCHER_HOST_HOME` credential dependency; add the brokered Claude
  OAuth wrap + placeholder credential; add the broker GitHub service brokering;
  add the `agent_vault_reachable` readiness check composed with
  `messaging_db_reachable`; pin the one-time-human-paste precondition; pin the
  inside-container negative invariant.
- The `BCLAUNCHER_HOST_HOME` / ZFS-coupling operational footgun is structurally
  removed once 44 lands green (launch no longer resolves any host credential
  path).
- Of the two mechanism questions that rode to the BC with a recommendation and a
  transport-agnostic scenario: **(D2) the GitHub/Claude brokering wire-mechanism
  is now RESOLVED AFFIRMATIVELY** (2026-06-10 live canary — both legs broker over
  the same MITM `HTTPS_PROXY` listener; see the D2 resolution note), so scenario
  46's outcome is demonstrated, not merely recommended. **(D5)** `agent-vault run
  --isolation container` vs bc-launcher `docker run` (recommend: keep bc-launcher
  `docker run`, defer `--isolation container`) remains the deferred future-work
  question, not blocking this slice.
- The agent-vault broker becomes a standing piece of fleet infrastructure on the
  `shopsystem` network, provisioned out of band (D4). Standing up and
  provisioning the broker is an operational precondition of brokered launch,
  tracked under the parent initiative (`lead-mdng` / `lead-odqd`), not inside
  this scenario slice.

---

## Cross-references

- [`findings/agent-vault-credential-spike.md`](../findings/agent-vault-credential-spike.md)
  — the confirmed spike (`lead-jkwo`); the admissible artifact-surface record of
  current launch behavior and the proven brokered plumbing.
- [`findings/dummyco-spike-iter-4.md`](../findings/dummyco-spike-iter-4.md) /
  [`findings/dummyco-spike-iter-5.md`](../findings/dummyco-spike-iter-5.md) —
  the live-broker end-to-end validation of the exact agent-vault 0.32.0
  provisioning verb surface recorded in the D2 addendum (`lead-g19j`,
  `lead-beym`, `lead-l95x`); iter-4 located the credential-key-casing wall and
  proved it the last one, iter-5 ran the full provision clean to the human gate.
- `features/bc-launcher/33,34,35` — the `messaging_db_reachable` readiness
  precedent (gate / idempotent barrier / readiness-not-liveness health) that
  scenarios 47/48 mirror and compose with.
- `features/bc-launcher/15` — the nearest existing mount contract
  (isolation from sibling/lead repos), distinct from the credential-mount
  absence scenario 44 adds.
- `features/bc-launcher/44–50` — the seven scenarios this ADR backs.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface evidence rule; why the spike findings (not `controller.py`)
  are the admissible pre-state surface.
- [ADR-019](019-canonicalization-ownership-in-scenarios-bc.md) — the
  scenario-block-only canonicalization the dispatched `@scenario_hash` values use.
- [lead-v4ih](beads:lead-v4ih) — this ADR's tracking bead (Phase 2).
- [lead-jkwo](beads:lead-jkwo) — the confirmed spike.
- [lead-vycn](beads:lead-vycn) — the agent-vault design decisions (topology,
  zero-bind-mount, two-server bring-up).
- [lead-mdng](beads:lead-mdng) / [lead-odqd](beads:lead-odqd) — the parent
  initiative (agent-vault credential substrate for the fleet).
