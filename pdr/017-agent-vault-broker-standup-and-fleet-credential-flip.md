# PDR-017 — Agent-vault broker standup + fleet credential flip: problem framing (intent, decomposition-deferred)

**Status:** draft (2026-06-10)
**Authors:** dstengle (stakeholder), Claude (lead-po)
**Anchored to:** initiative bead **`lead-mdng`** (agent-vault credential
substrate — eliminate host-filesystem credential coupling for the fleet, P1).
Design decisions LOCKED on **`lead-vycn`** (2026-06-09, dave). Credential model
accepted in [ADR-026](../adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md).
Plumbing proven in [`findings/agent-vault-credential-spike.md`](../findings/agent-vault-credential-spike.md)
(spike `lead-jkwo`, CONFIRM). Launcher-side scenarios LANDED:
[`features/bc-launcher/44–50`](../features/bc-launcher/).

This PDR is **intent and problem framing — NOT implementation, NOT a
decomposition decision, and NOT an ADR.** Per the lead-shop division of labor
(PDR-001/PDR-002), the Architect verifies BC pre-state empirically against the
contract/artifact surface (ADR-018), makes the BC-decomposition decision this
PDR explicitly hands off in §4, and applies the message-type discriminator.
This PDR frames the gap and the success behaviors so that decision is made
within a framed problem rather than re-opening it. No Gherkin is authored here:
the success behaviors below become scenarios only *after* the Architect decides
where they land.

---

## 1. Why a PDR now

ADR-026 records the *accepted credential model* and pins the launcher-side
behavioral end-state (scenarios 44–50, dispatched and landed via `lead-v4ih`).
But ADR-026 §Consequences explicitly defers one thing: "Standing up and
provisioning the broker is an operational precondition of brokered launch,
tracked under the parent initiative (`lead-mdng`), not inside this scenario
slice."

That deferral is now the live gap, and it is a *decision* gap, not just a
to-do: the question "where does the broker server live and who owns its
lifecycle?" was LOCKED on `lead-vycn` for the design-intent purposes of the
launcher slice, but it has consequences (a new supporting-services topology, a
second readiness barrier, a re-homing of broker-own behaviors out of the
launcher boundary) whose "why" will be re-asked the first time an Architect or
Implementer touches them. A PDR is warranted for this scenario *family* — it
frames the problem and bounds the Architect's structural call without
pre-empting it.

---

## 2. Problem — the elimination is pinned but not real

Scenarios 44–50 pin the *desired* end-state: no host-filesystem credential
mounts, Claude OAuth and GitHub brokered through agent-vault, an
`agent_vault_reachable` readiness gate, the one-time human paste as the only
out-of-band step. ADR-026 accepts that model.

**But in practice the fleet still authenticates via host-mounted credentials.**
Verified this session: BCs push to GitHub today using the mounted host
`~/.config/gh` token (this is the live mechanism — see `lead-ym1b`, where the
push-auth gap was closed precisely by baking `gh` into `bc-base` and mounting
the host `~/.config/gh` token). The agent-vault **broker server is not yet
stood up as a real fleet service.** No BC currently routes a real credential
*through* the broker.

So the host-filesystem credential coupling that ADR-026 exists to eliminate is
**NOT actually eliminated yet.** The desired contract is pinned; the running
reality contradicts it. Concretely, three things are still missing:

1. **The broker is not a deployed, managed fleet service.** ADR-026 D2 requires
   it to run as a container on the `shopsystem` network reached by name, as a
   *second* supporting server alongside the messaging postgres. It is not
   running.
2. **The real credentials still live on the host filesystem, mounted in.** Claude
   OAuth and the GitHub token reach BCs via host mounts / baked image + mount,
   not via the broker vault.
3. **`BCLAUNCHER_HOST_HOME` / `_resolve_host_path` coupling is still load-bearing**
   in the running fleet, because the host-mount path is still the live one.

This PDR's intent is to **close that gap**: deploy the broker for real and flip
the fleet off the host-mounted credential, so the pinned invariant becomes the
running reality.

---

## 3. Outcome / success behaviors (what scenarios will later pin)

Framed as **observable outcomes**, not implementation. Each is a candidate
behavior the Architect's decomposition will assign to a BC (or supporting-service
contract) and the PO will then author as Gherkin.

- **SB-1 — The broker runs as a managed fleet supporting-service, brought up
  coherently with postgres.** Bringing the fleet up brings up *both* supporting
  servers (messaging postgres + agent-vault broker) on the `shopsystem` network,
  reached by name, with persistent state and restart behavior. Neither is
  per-launch and neither is brought up by hand as a separate manual step.

- **SB-2 — A BC's git push authenticates THROUGH the broker, with no host
  credential mount and no `BCLAUNCHER_HOST_HOME`.** A BC performs an
  authenticated GitHub operation (push to origin) that succeeds while the
  container has no `~/.config/gh` / `~/.gitconfig` mount and the launch required
  no `BCLAUNCHER_HOST_HOME` to resolve a credential path. (This is the live-fleet
  realization of scenario 46, currently pinned-but-not-real.)

- **SB-3 — A BC's Claude OAuth authenticates THROUGH the broker, with no
  `~/.claude` mount.** The agent operates (a real Claude request succeeds) while
  the container holds only the placeholder `.credentials.json` and no real OAuth
  credential is mounted. (Live-fleet realization of scenario 45.)

- **SB-4 — The real credentials live ONLY in the broker vault.** From inside any
  running BC container, no real Claude OAuth credential and no real GitHub
  credential is observable; the only credential-bearing secret reachable is the
  revocable `AGENT_VAULT_TOKEN` (proxy substitution only). (Live-fleet
  realization of scenario 50.)

- **SB-5 — bc-launcher gates on `agent_vault_reachable`, composed with
  `messaging_db_reachable`.** A launch against an unreachable broker exits
  non-zero, names the broker's configured address, and withholds the startup
  prompt; the readiness barrier passes only when BOTH supporting servers are
  reachable. (Live-fleet realization of scenarios 47/48 against a *real* broker.)

- **SB-6 — The one-time human secret-load is the ONLY out-of-band step.**
  Provisioning the broker vault with the real credentials is a single, explicit,
  human-gated paste performed once; no part of fleet bring-up or BC launch reads,
  writes, or transports a real credential. (Live-fleet realization of scenario 49.)

- **SB-7 — The broker survives restart.** After a broker container restart, the
  fleet re-authenticates without re-pasting secrets out of band — the master
  password is handled per the locked MVP decision (auto-unlock from a lead `.env`
  file) so restart is not a human-gated re-provisioning event.

The success criterion for the whole family: **the host-mounted credential path
is no longer the live authentication mechanism for the fleet** — pulling the
host mounts does not break BC auth, because auth flows through the deployed
broker.

---

## 4. The open DECOMPOSITION DECISION — handed to the Architect (NOT resolved here)

Per ADR-018 / PDR-002, the structural calls below are the Architect's. This PDR
states them as open questions and does **not** answer them.

**Q1 — Where does the broker live, and who owns its lifecycle?** Candidate shapes:
(a) a **lead-shop supporting-services compose** service, extending the existing
`compose.yaml` that runs the messaging postgres (the shape `lead-vycn` recorded
as the locked *intent*, on the rationale that the launcher is a tool to start
BCs, not a service owner); (b) a **new BC shop** that owns the broker as a
deliverable with its own contract surface; or (c) **bc-launcher-managed**. The
Architect verifies pre-state against the artifact surface and decides — including
whether the `lead-vycn` locked intent (a) survives the empirical pre-state check
or warrants revisiting. Whichever owner is chosen also owns *where the
two-supporting-server coherent bring-up* lives (`bin/shop-shell` /
`compose.yaml` per the locked intent) and how `bc-launcher`'s
`agent_vault_reachable` gate is wired to it.

**Q2 — Where do the broker's OWN behaviors get pinned and tested?** The broker's
behaviors — most pointedly the **GitHub-credential-substitution** that ADR-026
D2 marks OPEN (does the `github` template broker over the same MITM `HTTPS_PROXY`
path?) — are broker/network behavior **outside the bc-launcher boundary**. Today
the only scenario touching this is launcher-side and effectively tautological
(it asserts the launcher *configures* the broker arm, not that the broker
*substitutes* correctly — the substitution is the broker's behavior, not the
launcher's). The Architect decides which BC/contract surface owns and tests the
broker's substitution behaviors, and whether re-homing them off the launcher
boundary changes any of scenarios 44–50's ownership. This is a genuine
decomposition question, not a wording fix: the behavior currently has no honest
owner.

These two questions are *coupled* — the answer to Q1 (broker owner) strongly
conditions the answer to Q2 (where broker behaviors are pinned). The Architect
should resolve them together, then the PO authors SB-1…SB-7 as Gherkin against
the chosen decomposition.

---

## 5. Scope guard

**In scope:** standing up the agent-vault broker as a real fleet
supporting-service, and flipping the fleet off the host-mounted credential so the
ADR-026 invariant becomes the running reality (SB-1…SB-7).

**Explicitly OUT of scope:**

- **The broader experiment-discipline / iterative-experimentation capability**
  (`lead-odqd`, and its Phase-2 authoring `lead-95q5` which reserves **PDR-016**
  and ADRs 026–029-for-that-track). agent-vault was merely a *proving case* for
  that meta-capability; this PDR is about the agent-vault deliverable itself, a
  SEPARATE track per `lead-mdng`.
- **fabro / alternable orchestration substrate** (`lead-f6ta`) — a separate
  back-burner track, untouched here.
- **Re-opening the locked design decisions** on `lead-vycn` (zero-bind-mount
  invariant, `AGENT_VAULT_TOKEN` as launch env, master-password auto-unlock from
  `.env`, BCs-only scope, bc-base baking prerequisite) — those are settled
  inputs, not re-decided here.
- **`agent-vault run --isolation container` owning container creation** — ADR-026
  D5 deferred it; not in this slice.

---

## 6. Cross-references

- [ADR-026](../adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
  — the accepted brokered-credential model this PDR makes real.
- [`findings/agent-vault-credential-spike.md`](../findings/agent-vault-credential-spike.md)
  — the confirmed spike (`lead-jkwo`): broker self-bootstraps CA, no mount.
- `features/bc-launcher/44–50` — the launched launcher-side scenarios pinning the
  desired end-state these success behaviors make real.
- [lead-mdng](beads:lead-mdng) — the parent initiative (this PDR's umbrella).
- [lead-vycn](beads:lead-vycn) — the locked design decisions (closed).
- [lead-ym1b](beads:lead-ym1b) — the closed push-auth bug; evidence the live
  mechanism is still the host-mounted `~/.config/gh` token.
- [lead-odqd](beads:lead-odqd) / [lead-95q5](beads:lead-95q5) — the
  experiment-discipline track (PDR-016 reserved there); OUT of scope here.
