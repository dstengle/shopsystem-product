---
name: incoming-request-advisor
description: Decode an incoming request before responding — separate the literal ask from the job-behind-it, read the sender's power and stake, and surface hidden assumptions — so a request is classified by its real outcome, not its surface wording. Use at PM-mode entry, at the router's classification boundary, to decide whether a request needs a discovery-dialogue at all.
---

# Incoming Request Advisor (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** discovery-dialogue (at its ENTRY boundary) · **Emits into:** intent record (`intent/intent-NNN.md`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `discovery-dialogue` PM session; its output lands in the intent record. It has no terminal artifact of its own.

*Adapted from [`deanpeters/Product-Manager-Skills/skills/incoming-request-advisor`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/incoming-request-advisor) — fetched live 2026-07-10. Adaptation rules + experimental status: [`../README.md`](../README.md).*

## Special role: wired to PM-mode ENTRY

Unlike the other technique skills, this one lives at the **classification
boundary** — the moment a request arrives and the router decides what it is.
PDR-033 retired the router-level discovery-dialogue gate in favor of PM-mode entry;
this skill absorbs part of that retired gate's job. It is the router's first move on
an ambiguous, directional, exploratory, or solution-shaped request: decode the
message, and let the decoded outcome — not the literal wording — decide whether the
request enters a `discovery-dialogue`, routes straight to the PO as an already-shaped
commitment, or is a simple operational action needing no PM mode at all.

## The lens (12-section decode — run it, then keep the turn open)

PM mode is interactive: the decode is the opening move, and any gap it exposes is
the next question to the sender, not a silent assumption.

1. **Classify** — message type and channel. 2. **Sender read** — role, power,
stake relative to the work. 3. **Literal ask** — what they explicitly said.
4. **Underlying problem space** — the job-to-be-done beneath the words (the crux).
5. **Sentiment & subtext** — tone, urgency. 6. **Must-haves vs. nice-to-haves.**
7. **Hard negatives** — what to avoid. 8. **Success criteria** — how they'll judge
it worked. 9. **Hard constraints** — dates, budget, non-negotiables. 10. **Gaps &
ambiguities.** 11. **Risks** — scope, political, timeline. 12. **Recommended next
steps** — 2–4 concrete moves.

Keep **success criteria** (how they measure results) separate from **must-haves**
(what goes in the deliverable) — conflating them is a classic PM failure.

## Input fork (decode identical; who the sender is differs)

- **Consumer product (primary):** an exec escalation, a sales-driven feature
  demand, a support-surfaced complaint.
- **Framework-as-product (bootstrap/meta):** dstengle as product authority, a
  BC-shop `clarify`, an operator ask; the "sender read" reads the framework role
  and its stake, and section 4 is where "add X to the framework" gets pulled back
  to the adopter/operator job behind it.

## Emits into the intent record

Build is ~free, so the gate is the point. The decode is what makes the entry
decision honest:

- If the literal ask and the underlying problem diverge, that divergence opens the
  `discovery-dialogue` and seeds the record's **goal** with the real outcome.
- Must-haves, hard-negatives, and success criteria map onto the record's **goal /
  non-goals / failure conditions**.
- Gaps and ambiguities become the record's open questions and the sender-facing
  turns to run before any dispatch. If the decode shows the request is already a
  shaped, unambiguous commitment, say so and route past PM mode — do not
  manufacture a discovery it doesn't need.
