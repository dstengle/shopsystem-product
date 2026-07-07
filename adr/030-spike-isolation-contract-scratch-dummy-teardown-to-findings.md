---
id: ADR-030
kind: adr
title: "Spike isolation contract: `spike-`-prefixed scratch, dummy data, throwaway worktree, teardown-to-findings"
status: accepted
date: "2026-06-10"
description: "Spike isolation contract: `spike-`-prefixed scratch, dummy data, throwaway worktree, teardown-to-findings"
beads: [lead-8mho, lead-architect, lead-capability, lead-f6ta, lead-host, lead-jkwo]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-004, ADR-018, ADR-029]
  pins: [PDR-016]
  related: []
---
# ADR-030 — Spike isolation contract: `spike-`-prefixed scratch, dummy data, throwaway worktree, teardown-to-findings

**Status:** accepted (2026-06-10)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** [PDR-016](../pdr/016-iterative-experimentation-first-class-lead-capability.md)
— capability point 3: a spike's artifacts are isolated and disposable; only the
`findings/` doc (+ ADR on graduation) survives.
**Anchored to:** [ADR-029](029-spike-vehicle-extend-pdr014-graduation-no-request-spike.md)
(lifecycle stages 3 *Throwaway execution* and 6 *Teardown* this ADR governs);
the standing "no implementation code in the lead repo" rule
(`.claude/shop/primer.md`); [ADR-004](004-bc-launcher-as-new-bc.md) /
[ADR-018](018-empirical-verification-is-contract-surface.md) (no `repos/` BC
source on the lead host — the carve-out here is lead-host *scratch* infra, not
kept lead source).
**Related beads:** `lead-jkwo` (agent-vault, `spike-bc-av` container),
`lead-f6ta` (fabro, local throwaway server), `lead-8mho` (research-only, no
live infra).

## Context

A spike's whole point is that its code and infra are *thrown away* — only the
finding is kept. Without an isolation contract, "throwaway" risks leaking:
scratch infra committed to source, real credentials or real fleet touched, or
ambiguity about what survives teardown. The three proving cases each handled
this well by convention; this ADR makes the convention a contract.

### Pre-state empirical findings (against the artifact/contract surface, ADR-018)

No BC code read or run; no `repos/` on this host. Established from the three
findings docs, ADR-004, ADR-018, and the lead primers:

- **agent-vault (lead-jkwo)** stood up a throwaway broker + a `spike-bc-av`
  container on the real `shopsystem` network with a **dummy** placeholder
  credential — the real fleet and real creds were never touched, and nothing
  was committed.
- **fabro (lead-f6ta)** installed fabro and ran a local throwaway server +
  kill/resume harness in scratch — refining a hypothesis and surfacing a new
  hazard — with nothing committed to lead or BC source.
- **substrate eval (lead-8mho)** ran research-only, no live infra — confirming
  the contract degrades gracefully to "no scratch to isolate."
- **ADR-004 / ADR-018** establish there is **no `repos/` BC source on the lead
  host** at all. The carve-out this ADR makes is narrow: a spike may stand up
  *lead-host scratch* infra (not kept lead source, not BC source) for the
  duration of the experiment.

## Decision

### D1 — `spike-` prefix is the teardown contract

Any infra a spike stands up is named with a **`spike-` prefix** (containers,
volumes, networks-of-its-own where applicable). The prefix *is* the teardown
contract: anything `spike-` is disposable by definition and is torn down at
verdict time. Teardown removes all `spike-`-named infra; a leftover `spike-`
artifact after teardown is a contract violation.

### D2 — Real network, dummy data only

Infra spikes run **on the real network** (e.g. `shopsystem`) so the experiment
exercises real topology, but with **dummy/placeholder data only**. The live
fleet and real credentials are **never** touched. (Human-gated real secrets are
governed by ADR-031: the spike proves everything creds-free up to the wall.)

### D3 — Code spikes use throwaway scratch, never committed

Code spikes use a **throwaway git worktree branch (never merged)** or `/tmp`
working dirs. **Nothing from scratch is ever committed to lead or BC source.**
The standing "no implementation code in the lead repo" rule holds without
exception; the only carve-out is that these are *lead-host* infra experiments in
scratch, not kept lead source.

### D4 — Teardown keeps only the finding

At stage 6, all scratch is torn down: `spike-` containers/volumes removed,
`/tmp` dirs cleaned, the worktree branch deleted. **The only durable artifacts
are the `findings/<spike>.md` document (+ the ADR if the spike graduated).**
Nothing throwaway leaks into lead or BC source.

### D5 — Convention for code spikes (worktree vs `/tmp`) is author's choice for now

None of the three proving cases used a throwaway worktree branch yet (all used
`/tmp` + `spike-` containers). This ADR pins the *invariants* (D1–D4: prefix,
dummy data, never committed, teardown-to-findings) but **leaves worktree-vs-
`/tmp` to the spike author** until a code spike proves a reason to pin one.
(Synthesis §(e).3 open question — deferred, not resolved here.)

## Alternatives considered

**Option A — Allow spike infra to be committed behind a `spike/` directory and
git-ignored.** Rejected. A committed (even ignored) scratch tree erodes the
"throwaway" property, invites reuse, and risks the next spike building on stale
scratch instead of standing up fresh. The `spike-` runtime prefix + teardown
keeps the disposal contract crisp and observable.

**Option B — Run spikes on an isolated throwaway network only, never the real
one.** Rejected. Two of the three cases needed the *real* network topology to
make the experiment meaningful (agent-vault on `shopsystem`, fabro against the
real loop seam). Isolation is achieved by **dummy data + `spike-` naming +
teardown** (D1/D2), not by hiding from the real topology — which would test the
wrong thing.

**Option C — Pin worktree as the mandatory code-spike convention now.**
Rejected (deferred). Zero code spikes have used it; pinning a convention with no
proving case is the same build-trap ADR-029 D5 guards against. D5 leaves it to
author choice until proven.

## Consequences

- **Teardown is auditable by the prefix:** "are there any `spike-` artifacts
  left?" is a mechanical post-spike check. A scenario can pin it (synthesis
  §(d) outline 2/3).
- **The findings doc is load-bearing** — it is the *only* thing that survives a
  spike, so its quality is the spike's quality. House style (synthesis §(b)):
  problem → what was executed → assertions → findings-beyond-plan → new hazards
  → "what Phase 2 must cover" → verdict.
- **Open (deferred):** the findings-doc *post-graduation* lifecycle (synthesis
  §(e).4) — once a spike graduates to an ADR, is the findings doc frozen as
  historical, or does it get a "superseded by ADR-NNN" header to avoid stale
  findings masquerading as current? Named here, not resolved; recommend the
  supersession-header pattern when PO authoring or a follow-up ADR closes it.

## Cross-references

- [PDR-016](../pdr/016-iterative-experimentation-first-class-lead-capability.md)
  — the intent (capability point 3).
- [ADR-029](029-spike-vehicle-extend-pdr014-graduation-no-request-spike.md) —
  the lifecycle whose stages 3 and 6 this ADR governs.
- [ADR-031](031-human-in-the-loop-wall-protocol-for-autonomous-spikes.md) — the
  human-wall handling for real secrets (D2's "creds never touched" complement).
- [ADR-004](004-bc-launcher-as-new-bc.md),
  [ADR-018](018-empirical-verification-is-contract-surface.md) — no `repos/` BC
  source on the lead host; the carve-out here is lead-host scratch.
- `findings/iterative-experimentation-capability.md` §(b) "bd / findings /
  worktree conventions" — the source convention; §(e).3/.4 the open questions.
- Scenarios (synthesis §(d) outlines 2 & 3) are **lead-po's Phase-2 job**.
