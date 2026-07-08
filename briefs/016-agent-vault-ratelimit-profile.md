# Brief 016 — agent-vault rate limiting is disabled by default fleet-wide; an operator opts back in

**Status:** draft (2026-07-08)
**Authors:** David Stenglein (stakeholder / product authority), Claude (lead-po)
**Lead bead:** [`lead-1xh8`](#) (P1, FEATURE) — new `RATELIMIT_PROFILE`
capability on the **agent-vault-broker** BC.

**Anchored to** the product-authority decision (2026-07-08), authoritative for
this brief's scope, vocabulary, and the security tradeoff it accepts:

> "Rate limiting on the agent-vault credential proxy is blocking legitimate
> agent traffic. Make it disabled by default, fleet-wide; an operator opts back
> in to re-enable it."

**Cross-links (decisions this builds on — NOT re-decided here):**

- [ADR-028](../adr/028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
  — the agent-vault broker is a lead-shop supporting service whose own
  behaviors are pinned by the lead-owned integration surface
  (`features/agent-vault-broker/agent_vault_broker_integration.feature`). This
  brief adds one such broker-owned behavior to that surface.
- [ADR-026](../adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
  — the broker is the credential-injection proxy: it substitutes real
  credentials onto outbound requests. Rate limiting is a guardrail *on that
  proxy path*.

---

## 1. The problem — the credential-proxy throttle blocks legitimate agent traffic

The agent-vault broker (the credential-injection proxy that substitutes real
API keys/tokens onto outbound requests) rate-limits the traffic passing through
it. In practice that throttle is firing on **legitimate** fleet traffic: the
operator (David) hit rate limiting during normal work and had to apply a local
unblock (`AGENT_VAULT_RATELIMIT_PROFILE=off` in
`.claude/settings.local.json`) to get moving again.

The local unblock is a stopgap on one host. The problem is fleet-wide: every BC
container's outbound Claude/GitHub traffic passes through a broker whose default
throttle can stall legitimate work, and there is today **no configuration
surface at all** to change that posture. There is no rate-limit / rate-limit-
profile concept anywhere in the broker's pinned contract surface.

## 2. The job-to-be-done

*When my fleet does normal agent work through the agent-vault broker, I want the
credential proxy to not throttle legitimate traffic by default, so that agents
are not stalled by a guardrail I did not ask for — while retaining an explicit
switch to turn throttling back on when I decide I want it.*

## 3. The outcome (observable behavior change)

- With **no** `AGENT_VAULT_RATELIMIT_PROFILE` configured, brokered traffic
  across the fleet **is not throttled** — an operator no longer has to discover
  and apply a per-host unblock to do normal work.
- An operator who *wants* throttling **opts back in explicitly** by setting
  `AGENT_VAULT_RATELIMIT_PROFILE` to a non-`off` value, and the broker enforces
  a rate limit again.

Output (an env var, a config knob) is not the measure; the behavior change —
legitimate fleet traffic stops being stalled by a default guardrail nobody
asked for, and re-enabling is a deliberate operator act — is.

## 4. The pinned product decision (made explicitly by the product authority)

**Posture: rate limiting DISABLED BY DEFAULT, fleet-wide, opt-in to re-enable.**

- With no configuration, the broker does **not** throttle.
- `AGENT_VAULT_RATELIMIT_PROFILE=off` is the **explicit form of that default** —
  no throttling.
- Any non-`off` (opt-in) value re-enables a rate limit; the broker enforces a
  limit again.

This posture was chosen explicitly by the product authority (David) on
2026-07-08. It is **not** open for the Architect or BC to re-litigate — the
scenarios below pin it.

### Vocabulary (load-bearing)

- **`AGENT_VAULT_RATELIMIT_PROFILE`** — the control-surface environment variable
  governing the broker's rate-limit posture. New vocabulary introduced by this
  brief; it joins the existing pinned agent-vault env set
  (`AGENT_VAULT_{CA_PEM,TOKEN,ADDR,VAULT,MASTER_PASSWORD}`).
- **`off`** — the profile value that disables throttling. Also the semantic
  default when the variable is unset.
- **opt-in / re-enable value** — any non-`off` profile value, under which the
  broker enforces a rate limit on brokered traffic.
- **throttle / rate-limit** — the broker refusing or delaying brokered outbound
  requests once a request-rate ceiling is reached (the guardrail this brief
  turns off by default).

## 5. Security tradeoff (deliberate authority decision)

Rate limiting on a credential-injection proxy is a **guardrail**: it bounds how
fast a compromised or runaway agent can drive credential-bearing outbound
requests. **This brief removes that guardrail by default, fleet-wide.** With no
configuration, nothing throttles brokered traffic on any container.

This tradeoff was weighed and accepted **explicitly by the product authority**
(David, 2026-07-08) as the correct posture for this fleet: the throttle was
blocking legitimate work more than it was bounding abuse, and the opt-in path
preserves the ability to restore the guardrail when wanted. It is recorded here
as a deliberate decision, not an oversight, so the "why" is not re-asked later.

## 6. Scope

**In scope.**

- A new broker-owned behavior on the lead integration surface: the broker's
  rate-limit posture is governed by `AGENT_VAULT_RATELIMIT_PROFILE`, defaulting
  to off. Pinned by the scenarios in §7.

**Out of scope / deferred (named, not decided):**

- **The concrete limit values / algorithm** of the re-enabled profile (requests
  per interval, burst, token-bucket vs. fixed-window). The opt-in scenario pins
  *that* a limit is enforced when opted in; the specific ceiling is the
  Architect's/BC's call. Additional named profile values (beyond `off` vs.
  opt-in) are additive scenarios, not this brief.
- **Per-BC or per-credential profile differentiation.** This brief pins a
  single fleet-wide posture via one env var; finer-grained profiles are a
  separate intent.
- **Auto-tuning / adaptive throttling.** Out of scope entirely.

## 7. Pinned scenarios

Added to the lead-owned broker integration surface,
[`features/agent-vault-broker/agent_vault_broker_integration.feature`](../features/agent-vault-broker/agent_vault_broker_integration.feature):

- **default-off** — no `AGENT_VAULT_RATELIMIT_PROFILE` set ⇒ broker does not
  throttle legitimate brokered traffic.
- **explicit off** — `AGENT_VAULT_RATELIMIT_PROFILE=off` ⇒ no throttling (the
  explicit form of the default).
- **opt-in re-enable** — a non-`off` profile value ⇒ the broker enforces a rate
  limit on brokered traffic again.

`@scenario_hash` tags are computed by the `scenarios hash` contract tool at
dispatch time (per ADR-018 D2 / the lead authoring convention); they are left
to the Architect/tooling and are **not** hand-computed in this brief.

## 8. Strategic trace

Serves the agent-vault credential-broker bet recorded in ADR-026 / ADR-028: the
broker is the sole credential surface for the fleet, so its operational
behaviors must serve the fleet's real work rather than obstruct it. A guardrail
that stalls legitimate agent traffic by default undercuts that bet — brokered
traffic is the fleet's normal path, and the build economics make stalled agent
turns pure waste. This brief tunes the broker's default posture to the fleet's
actual traffic while keeping the guardrail one deliberate opt-in away.

## 9. What would NOT satisfy the stakeholder

- A default posture that still throttles (leaves the operator applying per-host
  unblocks — the problem stays open).
- Making `off` a non-default that must be set to get unthrottled behavior
  (the decision is default-off, not opt-out).
- No re-enable path (the guardrail must remain reachable by explicit opt-in).
- A per-host-only fix rather than the fleet-wide broker default.
