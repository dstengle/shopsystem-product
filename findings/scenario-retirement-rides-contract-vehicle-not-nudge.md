# Finding: scenario retirements must ride a contract vehicle, never a nudge; the architect owes a full-affected-pin enumeration up front

Recorded 2026-07-16, from `lead-a1u1` (durable learning surfaced during Round-1/Round-2
ingestion, epic `lead-ac1f`).

## 1. Retirements ride `request_bugfix` (or the retiring `assign_scenarios`), never `ADR-015` nudge

**Root cause.** `assign_scenarios` carries no `description` field (`shop_msg`
Pydantic model), so it cannot carry an in-contract retirement statement.
Retirements conveyed via an `ADR-015` nudge are operational-liveness only,
**not contract-bearing** — a BC correctly refuses to retire a lead-owned
`@scenario_hash` pin on a nudge's say-so. Observed twice: `shopsystem-templates`
clarified on both the `lead-63lp` `cli_surface` gap and the `lead-vfg9` Group-B
retirement; `shopsystem-knowledge` proactively self-corrected via `lead-92oy` +
`lead-ykan` retract rather than accept a bare nudge.

**Decision.** When a dispatch supersedes or retires prior BC-side pins, the
retirement is named in a **contract-bearing vehicle** — `request_bugfix`'s
required `description` field names old-hash → terminal-replacement (or "no
successor"). The single exception is a **self-evident same-file
self-referential supersession**, where the new scenario body's own text
already makes the retirement legible without a separate contract statement.

## 2. Completeness sweep: enumerate the FULL affected-pin set up front, not pin-by-pin

Evidence: `shopsystem-templates` clarified **three times** on one dispatch
sequence — the `cli_surface` gap, then the Group-B 3-pin sweep, then a 4th pin
(`32537a54…`) that the Group-B sweep itself missed. The BC's own completeness
sweep did QA work the dispatching architect should have done up front.

**Decision.** Before composing a dispatch that retires/supersedes prior
BC-side coverage, the architect enumerates the **full** set of pins in the
touched role/feature area carrying the superseded framing — not just the
pins the immediate task names — via `grep -r "@scenario_hash" features/`
reconciled against the BC's mailbox-reported register, same discipline as
the `@scenario_hash` enumeration step. Reacting pin-by-pin as each clarify
surfaces a miss is the failure mode, not the fix.

## Disposition

- **(a) findings/ record** — this document.
- **(b) update lead-architect discriminator guidance** — already substantially
  realized in the current canonical `lead-architect` template's "Sufficiency
  check — message-type selection" item 5 (the `@scenario_hash` enumeration
  requirement, including the clarify-correction-chain re-enumeration rule) and
  the retirement-vehicle discipline embedded in the anti-rationalization
  section. `ADR-064` separately codifies the mechanical hash-unreachability
  convention for `bc-emit work-done --retire-hash`. No further template
  change identified as missing; if product authority wants this promoted to
  a dedicated ADR (D1/D2 above as formal decisions rather than template
  prose), that remains an open option, not exercised here.

## Cross-references

- `lead-a1u1` (origin bead), `lead-ac1f` (parent epic).
- [ADR-015](../adrs/adr-015.md) (nudge is transmission-layer/liveness only).
- [ADR-064](../adrs/adr-064.md) — the mechanical retirement-satisfaction convention this finding's D1 composes with.
