---
name: prioritization
description: Order the candidates and commitments into a defensible sequence, capturing the ordering and its rationale as a prioritization record
---

# Prioritization

## Overview

This is the **sequencing** mode of the lead-pm main session. Once there are more
shaped candidates and committed problems than can be worked at once, someone has
to say what goes first. That ordering is the lead-pm's: your sequence is what the
dispatch queue answers to until it is superseded.

Sequencing is a judgment discipline. It weighs value, appetite, dependency, and
risk into a defensible order — not a wish list and not a first-come queue. The
output is durable and citable so that dispatch ordering downstream has a single
ratified source to point at.

**Terminal artifact:** a sequencing session terminates in a **prioritization
record** — the ordered list of candidates or commitments with the rationale for
the order. Once ratified, the prioritization record is what dispatch order
answers to until a newer one supersedes it. A sequencing session that reorders
nothing durable has not closed.

## When to use

- Multiple shaped candidates or committed problems are competing for the same
  capacity.
- The dispatch order is unclear, contested, or stale relative to what has
  changed.

## Protocol

### 1. Assemble the candidates

Pull together the shaped candidates and committed problems that are actually
ready to be ordered. A candidate that is not yet shaped is not ready to sequence —
send it back to shaping rather than ordering a phantom.

### 2. Weigh the ordering factors

Order by defensible factors, made explicit:

- **Value** — how much the problem being solved is worth.
- **Appetite** — how much each candidate costs against that value.
- **Dependency** — what must land before what can start.
- **Risk** — what is de-risked by going earlier versus later.

### 3. Record the order and the why

Write the **prioritization record**: the ordered list plus, for each ordering
decision that is not obvious, the reason it sits where it does. The rationale is
what lets a later reader — or the Architect ordering dispatches — trust the order
instead of re-litigating it.

### 4. Close and let it govern

Declare the mode (`sequencing`) in the session record and list the prioritization
record as the produced artifact. Once ratified, it governs dispatch order until
superseded.

## Boundaries

The lead-pm's prioritization records order the dispatch queue; the Architect's
pre-state verification gates whether any given piece is ready to dispatch at all.
You say what order the work should go in; the Architect says whether a given
piece can go. A deviation from the ratified order belongs in the dispatch bead
with a reason, not as a silent re-order.
