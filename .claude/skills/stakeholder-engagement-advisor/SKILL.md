---
name: stakeholder-engagement-advisor
description: Plan engagement for one specific stakeholder — diagnose their profile and power/impact position, then tailor message, medium, cadence, and a named next action, planning both sides of the relationship. Use inside the discovery-dialogue when the intent hinges on a critical or resistant stakeholder whose input you must actually secure.
---

# Stakeholder Engagement Advisor (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted, with permission, from [`deanpeters/Product-Manager-Skills/skills/stakeholder-engagement-advisor`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/stakeholder-engagement-advisor) (MITRE Innovation Toolkit) by [Dean Peters](https://www.linkedin.com/in/deanpeters/) — fetched live 2026-07-10, direct-grant terms per [ADR-066](../../adr/066-direct-grant-from-dean-peters-authorizes-mit-ingestion-of-deanpeters-derived-pm-skills-attribution-required.md). Adaptation rules + experimental status: [`../README.md`](../README.md).*

## When to reach for it

Mapping flagged a stakeholder the intent depends on — a sponsor whose motivation
is unclear, a skeptic who could block it, or a Q1 user whose voice must be brought
in. This lens plans how to actually engage that one person so their real input
reaches the intent record instead of being assumed.

## The lens — Adaptive Decision Ladder (three questions, run live)

PM mode is interactive: work these with the product authority, since they hold the
relationship context.

1. **Profile** — executive sponsor, peer partner, end user, skeptic/blocker, or
   newly identified?
2. **Power/impact position** — where do they sit on the two grids?
3. **Context** — first contact, pre-milestone alignment, resistance, voice
   elevation, or maintenance?

Then synthesize a tailored approach: key **message** and framing, recommended
**medium** and **cadence**, **what you need from them vs. what they need from you**
(plan both sides — the common failure is planning only yours), and one **named
next action** with owner, deadline, and success criteria. Use a **proxy** only if
credible, never merely convenient. For Q1 voices: an open door serves those who
already know they have a seat — go to them.

## Input fork (ladder identical; who the stakeholder is differs)

- **Consumer product (primary):** execs, customer advisory boards, resistant
  buyers, excluded end-user communities.
- **Framework-as-product (bootstrap/meta):** the operator, a BC-shop agent, a
  template maintainer, or dstengle as product authority; "engagement" is often a
  `clarify`/`nudge` round or a discovery turn rather than a meeting.

## Emits into the intent record

Build is ~free, so the gate is the point. This skill secures the *input*, not the
outreach for its own sake:

- The input actually gathered from the stakeholder feeds the record's **goal** or
  a **non-goal**, replacing an assumption with a heard position.
- A critical stakeholder who is not yet aligned rides onto the record as a
  **failure condition** — the intent is not safe to build until their position is
  known.
- The named next action lives on the record (or a bead) so the dependency doesn't
  silently lapse.
