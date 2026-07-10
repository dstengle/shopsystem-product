---
name: discovery-dialogue
description: Run the open, interactive discovery conversation that turns a directional or ambiguous prompt into a written, grounded intent record
---

# Discovery Dialogue

## Overview

This is the **discovery** mode of the lead-pm main session. You run it when the
product authority arrives with something directional, exploratory, ambiguous, or
multi-option — an itch, a frustration, a "could we…", a half-formed goal — and
the outcome that is needed is *understanding*, not yet a commitment or a
dispatch.

Discovery is a live conversation, and it is yours alone: the lead-pm is the only
interactive seat, so the probing, the follow-up questions, and the reframing all
happen here in the main session rather than in a non-interactive subagent. You
open wide before you narrow.

**Terminal artifact:** a discovery session terminates in an **intent record** —
the durable capture of what problem was surfaced, whose problem it is, and why it
matters now. A discovery session that produces no intent record has not closed;
it was idle chat.

## When to use

- The input is directional, exploratory, ambiguous, or multi-option.
- No validated problem statement exists yet for what the authority is raising.
- You are unsure whether there is even a real problem underneath the request.

If the input is a committed contract that only needs specifying, that is lead-po
work, not discovery. If it is technical or a dispatch, it routes elsewhere.

## Protocol

### 1. Ground before you probe

Read the current-state doc and the completion journal first. Every problem you
surface must cite the current-state entry or gap it addresses — discovery
ungrounded in what already exists drifts into fantasy.

### 2. Open wide

Probe the problem, not the proposed solution:

- **What** is the problem, stated as a behavior or a friction, not a feature?
- **Whose** problem is it — who feels it, how often, how much?
- **Why now** — what changed, what is the cost of leaving it?

Resist the pull to converge on the authority's first-proposed solution. A
proposed solution is a clue about the problem, not the problem itself.

### 3. Reflect and reframe

Play the problem back in your own words. Name the assumptions you heard. Surface
adjacent problems the authority did not state. The goal is a problem the
authority recognizes as *theirs*, sharpened past the opening phrasing.

### 4. Close on an intent record

When the conversation has surfaced a problem worth carrying forward, write the
**intent record**: the problem, whose it is, why now, the evidence you have, and
the open questions that remain. Declare the mode (`discovery`) in the session
record and list the intent record as the produced artifact.

## Altitude

Stay in the problem space. No env var names, no schemas, no CLI flags. A
technical claim that surfaces in discovery is a question for the Architect's
pre-state verification, not a fact you write into the intent record.

## Hand-off

The intent record feeds the **shaping** mode, where a candidate is driven to
shaped. Discovery does not write briefs or scenarios — that is the lead-po's
commitment work, downstream of a shaped candidate.
