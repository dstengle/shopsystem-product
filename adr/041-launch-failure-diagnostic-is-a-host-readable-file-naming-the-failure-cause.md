---
id: ADR-041
kind: adr
title: A launch/engage failure writes a host-readable diagnostic file naming the specific failure cause, on the same host-visible per-BC surface the mailbox uses; not stderr-only and not `docker logs`-dependent
status: accepted
date: "2026-06-23"
description: A launch/engage failure writes a host-readable diagnostic file naming the specific failure cause, on the same host-visible per-BC surface the mailbox uses; not stderr-only and n...
beads: [lead-2qta, lead-63em, lead-architect, lead-held, lead-q3uy, lead-repo]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018]
  pins: []
  related: []
---
# ADR-041 — A launch/engage failure writes a host-readable diagnostic file naming the specific failure cause, on the same host-visible per-BC surface the mailbox uses; not stderr-only and not `docker logs`-dependent

**Status:** accepted (2026-06-23)
**Tier:** system-global (per [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md) — this is a cross-cutting operability decision about *how a host operator diagnoses a failed BC bring-up*; it touches the bc-launcher `bc-container` CLI's failure surface and the host-readability convention shared with the mailbox. It is not framework-doctrine (§1–6) and not one BC's purely-internal detail.)
**Authors:** dstengle (intent — the 2026-06-23 launch-robustness gap report on `lead-2qta`), Claude (lead-architect)
**Pins:** [scenario 56](../features/bc-launcher/56-launch-failure-writes-host-discoverable-diagnostic.gherkin) — *a launch/engage failure writes a host-discoverable diagnostic naming the specific failure cause, readable from the host without attaching into a tmux session that may not exist.*
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md) (the lead carries no BC source; this ADR's pre-state is verified against the lead-held `features/bc-launcher/` surface only). The host-readability shape this ADR reuses is the one pinned by [scenario 13](../features/bc-launcher/13-mailbox-readable-from-host.gherkin) and [scenario 14](../features/bc-launcher/14-mailbox-response-readable-from-host.gherkin): a container-side artifact is made readable from the host. The failure causes the diagnostic distinguishes are the same readiness gates already pinned by [scenario 33](../features/bc-launcher/33-launch-gates-on-messaging-db-reachability.gherkin) (messaging-db), [scenario 47](../features/bc-launcher/47-launch-gates-on-agent-vault-reachability.gherkin) (agent-vault), and [scenario 34](../features/bc-launcher/34-launch-runs-idempotent-readiness-barrier-before-engage.gherkin) / [scenario 48](../features/bc-launcher/48-readiness-barrier-composes-both-supporting-servers.gherkin) (readiness barrier).
**Related beads:** `lead-2qta` (the launch-failure-diagnostic gap this pins the resolution for; closed by answer-by-redispatch), `lead-63em` (re-issue of `lead-2qta`: the scenario now conveys the seam by observable property IN-TEXT rather than by "per ADR-041" cross-reference, because the BC cannot read the lead repo — mirror of ADR-018), `lead-q3uy` (the sibling engage-robustness gap from the same report).

---

## Context

The 2026-06-23 operator report (launching the lead via `bin/shop-shell`)
named two engage-robustness gaps. The second: when the in-container agent
never comes up, there are **no tmux sessions to attach to**, so the
operator — who is on the HOST while the failure is inside or around the
container — has no surface to diagnose or repair against.

The existing failure surfaces do not cover this case:

- **Scenarios 33 / 47** report a readiness failure on **stderr** of the
  synchronous `bc-container launch` invocation. That is sufficient when the
  operator is watching the foreground launch, but it is *lost* when launch
  is run detached (the `shop-shell` / launcher-TUI path), and stderr is not
  a persisted, re-readable surface.
- **Scenario 35** surfaces readiness as container **health** via
  `docker inspect`, but health reports a STATE (`unhealthy`), not a
  human-readable WHY, and presumes the container is up enough to run its
  healthcheck — which is exactly not guaranteed when claude/tmux never
  started.
- **`docker logs`** is a candidate, but it is unreliable as *the* contract:
  if the container exits early (or never starts), log retention and content
  are entrypoint-dependent and not a stable, documented operator contract.

What the operator already trusts as a read-without-attach surface is the
**host-visible per-BC location the mailbox uses** (scenarios 13/14): a
container-side artifact made readable from the host. A launch-failure
diagnostic belongs on that same surface.

## Decision

**D1.** On any launch/engage failure that prevents a usable session from
coming up, `bc-container` MUST write a **persisted, host-readable
diagnostic** stating WHY the session failed to come up. The diagnostic is
readable from the host **without attaching into a tmux session** (which by
definition may not exist).

**D2.** The diagnostic lives at a **known, documented host-discoverable
location on the same host-visible per-BC surface the mailbox uses**
(the scenario-13/14 read-without-attach shape) — NOT stderr-only, and NOT
contingent on `docker logs`. The BC owns the concrete path; the BC MUST
document it and echo the concrete path in its `work_done` so the lead can
reconcile the property → concrete mapping.

**D3.** The diagnostic MUST DISTINGUISH the failure cause wherever the
launcher already knows it, via a literal **cause marker** the operator can
grep for. The lead pins these as the REQUIRED literal tokens the diagnostic
must carry (one per known cause):

| failure cause (already-pinned gate)                          | required cause marker |
| ------------------------------------------------------------ | --------------------- |
| messaging database at `SHOPMSG_DSN` unreachable (cf 33)       | `messaging-db`        |
| agent-vault broker unreachable (cf 47)                        | `agent-vault`         |
| readiness barrier never satisfied (cf 34/48)                  | `readiness`           |
| claude or its tmux session never started inside the container | `agent-startup`       |

These tokens are the lead-pinned contract; the BC must emit exactly these
literals so the pin is concrete and checkable from the host.

## Alternatives considered and rejected

- **stderr-only (extend 33/47).** Rejected per D2 rationale: stderr is lost
  on a detached launch and is not a persisted, re-readable surface — the
  exact failure mode the operator reported.
- **`docker logs` as the contract.** Rejected: retention and content are
  entrypoint-dependent and undefined when the container exits early or
  never starts; not a stable operator contract.
- **A new bespoke diagnostic directory.** Rejected as gratuitous: the
  mailbox host-readability surface (13/14) already establishes a trusted
  read-without-attach location; reusing it composes, a new path forks the
  operator's mental model.

## Consequences

- Scenario 56 pins the property (host-readable, names the cause via the
  required markers) and defers the concrete path to the BC, which documents
  and echoes it in `work_done`. The lead reconciles the concrete path on
  receipt.
- The cause markers become a checkable contract: a host operator (or test)
  can grep the diagnostic for `messaging-db` / `agent-vault` / `readiness`
  / `agent-startup` to confirm the right repair is pointed at.

## Amendment (2026-06-23, `lead-63em`) — the seam travels in the scenario, not by ADR number

The initial dispatch of scenario 56 (`lead-2qta`) referenced this ADR by
number and told the BC to "reuse the per-BC mailbox/observability surface
that `bc-container monitor` reads." The BC correctly blocked: (a) the
monitor tmux pane (`capture_pane`, requires a live `agent` session) and the
engage WARNING stderr surface are TWO DIFFERENT mechanisms, and NEITHER is a
persisted, re-discoverable surface; (b) this ADR does not exist in the BC
repo — the lead carries no BC source and the BC carries no lead source
(ADR-018), so a bare "per ADR-041" reference inside a BC-bound scenario
conveys nothing the BC can resolve.

Resolution: the architectural decision is unchanged (D1–D3 stand), but the
SCENARIO now pins the seam by **observable property entirely in its own
steps** — a persisted host-readable diagnostic FILE at a known, documented
host-discoverable location on the same host-visible per-BC surface the
mailbox is read from, found by a host lookup that does NOT attach and does
NOT depend on the launch command's stderr or the monitor tmux pane. The
"per ADR-041" citation is demoted to a non-load-bearing aside. This is the
canonical re-discoverable surface; stderr/monitor may additionally carry the
text but are NOT the pinned contract (resolves the BC's ambiguity (a)). The
re-authored scenario blocks pin hashes `0d010cf8f3175226` (Scenario Outline)
and `7084bbbfdef94f81` (the host-discovery Scenario), superseding the
originally-dispatched `23606a56d6c376b4` / `0578c14c4419d169`.
