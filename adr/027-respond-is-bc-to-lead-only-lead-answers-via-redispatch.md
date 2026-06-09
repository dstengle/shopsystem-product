# ADR-027 — `shop-msg respond` is BC→lead only; the lead answers clarifies via re-dispatch; `prime --lead` realigned

**Status:** accepted (2026-06-09)
**Authors:** dstengle, Claude (lead-architect)
**Anchored to:** [§5.3 message catalogue](../05-inter-shop-protocol.md)
(direction model: `clarify` is BC → lead; the lead→BC vehicles are
`assign_scenarios`, `request_bugfix`, `request_maintenance`,
`request_scenario_register`, `request_shop_card` — there is no lead→BC
`respond` row); [ADR-009](009-clarify-resolution-vehicle.md)
(clarify-resolution = re-dispatch via existing catalog types, layer b in
effect now; native `clarify_response` primitive deferred to `lead-ox8`).
**Related beads:** `lead-rl0f` (the `shop-msg respond` direction-guard
bugfix that surfaced the contradiction via clarify), `lead-mcps` (the
re-dispatch carrying this authorization to shopsystem-messaging),
`lead-uhd2` (lead supersession-blindness — this is the second instance
this session), `lead-8z1` / `lead-ox8` (the deferred multi-row / native
primitive work).
**Amends:** does not supersede ADR-009; this ADR pins the *direction*
consequence ADR-009 already implied.

## Context

The `lead-rl0f` bugfix asked `shop-msg respond` to refuse when invoked
from a lead-shop context — `respond` is a BC→lead verb, and a lead using
it silently mis-routes. The BC (shopsystem-messaging) surfaced a genuine
contract contradiction via `clarify`: messaging's own committed
`features/prime_lead.feature` advertises lead-side `respond clarify` as
the legitimate "lead answers BC questions" vehicle, pinned by two
scenarios it cannot retire without explicit authorization:

- `@scenario_hash:998dc8df4b103a22` — "prime --lead output includes
  shop-msg respond clarify in the key commands section"
- `@scenario_hash:d16569f25194d6bc` — "prime --lead annotates respond
  clarify to show the lead is the caller"

and actively printed by `_print_prime_lead_reminder()` in
`src/shop_msg/cli.py` (~L1975). A guard added only to `respond` would
leave both prime_lead scenarios green while making `prime --lead`
advertise a command that now refuses the lead — incoherent. The BC's role
correctly refused to ship that narrow incoherent fix, and correctly
refused to retire the scenarios without explicit description authorization.

These prime_lead scenarios live in the **BC's own repo**, outside the
lead's ADR-018 artifact surface — the lead could not see them at dispatch
time. This is the second supersession-blindness instance this session
(cf. `lead-uhd2`, the agent-vault case); it strengthens that bead.

## Decision

`shop-msg respond` is a **BC→lead verb only.** The direction guard refuses
**all** lead-side `respond` invocations — `respond clarify`,
`respond work_done`, and `respond mechanism_observation` alike — not a
narrowed subset.

The lead answers a BC `clarify` by **re-dispatch** on a fresh lead bead
via the standard catalog vehicle (per ADR-009 layer b), never by
`respond`. The resolution of `lead-rl0f` is itself an instance: a fresh
`request_bugfix` on `lead-mcps`.

Consequently `_print_prime_lead_reminder()` is realigned to stop
advertising lead-side `respond` and to point the lead to `shop-msg send`,
`shop-msg nudge`, and `shop-msg consume`. Scenarios
`998dc8df4b103a22` and `d16569f25194d6bc` are **superseded and retired**,
replaced by prime-lead scenario(s) asserting that `prime --lead` directs
the lead to send/nudge/consume and does not advertise lead-side `respond`.
This supersession is explicitly authorized in the `lead-mcps` dispatch
description so the BC may act on it.

## Alternatives considered

**Worldview B — keep lead-side `respond clarify` legitimate; scope the
guard to refuse only `respond work_done` / `respond mechanism_observation`.**
Rejected. It contradicts the §5.3 direction model (`clarify` is BC→lead;
no lead→BC `respond` row exists) and ADR-009 (which characterizes
`shop-msg respond clarify` as BC-side direction and canonizes re-dispatch
as the lead's clarify-resolution vehicle). It would also preserve a
command the lead is told to use but that mis-routes in practice — every
clarify this session was in fact resolved by re-dispatch, never by
`respond`. Keeping it legitimate would entrench the incoherence the
bugfix exists to remove.

## Consequences

- The `lead-rl0f` guard refuses all lead-side `respond`; the prime_lead
  realignment and the two-scenario retirement ship in the same coherent
  change, authorized via `lead-mcps`.
- Supersession-blindness (`lead-uhd2`) is reconfirmed: a lead dispatch can
  contradict BC-committed scenarios the lead cannot see. The two options
  on `lead-uhd2` (pre-dispatch scenario-register reconciliation;
  `@supersedes:<hash>` tooling, `lead-yug`) remain the durable fixes.
- The native `clarify_response` primitive (ADR-009 path a, `lead-ox8`) is
  unaffected and still deferred; if it lands, it is a `send`-side lead→BC
  vehicle, not a `respond`-side one — consistent with this direction pin.
