---
type: principle-set
id: principles
status: experiment
created: 2026-08-10
updated: 2026-08-14
---

# Founding principles

The key words MUST, SHOULD, and MAY are to be interpreted as described in
BCP 14 (RFC 2119, RFC 8174) when, and only when, they appear in capitals.

---

## Define before you build (`construction-precedes-inspection`)

**Statement.** Every activity MUST operate from an explicit definition of
good construction before it runs; checks and review rubrics MUST be derived
from that definition and MUST NOT be invented independently of it.

**Rationale.** A check written without a stated definition encodes a
fragment of a standard no one wrote down. Agents find the gaps between
fragments and pass bad work through them. Rejecting bad output after
generation also costs several times more than defining good output before
generation. (Deming: cease dependence on inspection; build quality in.)

**Implications.** New activities enter the system with their definition, or
not at all. A check that cannot cite the definition clause it projects is
deleted. Review seats audit conformance to a known standard instead of
supplying taste of last resort. Spot-check failures obligate a
definition-or-check fix, not only an artifact fix.

## Govern the generating context (`governed-context`)

**Statement.** Everything loaded into an agent's generating context —
prompts, skills, memories, primers — MUST trace to a ratified definition or
a governed record; unsanctioned context channels MUST NOT accumulate.

**Rationale.** What an agent reads determines what it produces, so an
ungoverned context input is an ungoverned generator. This shop observed the
failure directly: agents accumulated 67 notes in a memory tool no process
governed, and session handoffs came to depend on those notes even though no
one had ever reviewed them.

**Implications.** Maintainers version every context input, promote changes
through a gated step, and can audit which definition version was in force
when an artifact was produced. Memory channels get a defined process with a
consumer, or they are closed. Tool owners ship each tool's skill with the
tool, in lockstep.

## Every activity belongs to a process (`no-orphan-activities`)

**Statement.** Every activity in the system MUST be part of a defined
process with stated expected outcomes, expected outputs, and possible
resulting actions; every long-running loop MUST declare its exit — a
reached-state success exit, a round or budget cap, or both.

**Rationale.** An activity outside a process has no consumer for its
output, so the output piles up unread or is thrown away. This shop saw
both: agents stopped sending a feedback message type (mechanism_observation)
because nothing consumed it, and instead accumulated unreviewed notes in an
ungoverned memory tool. Any runtime can follow a process defined at this
level — the requirement is a definition, not a workflow engine.

**Implications.** Reviewers treat an activity with no process as a defect,
not a convenience. Process definitions are cheap to write (a header plus
activity cells), so cost is no excuse. A loop without a declared exit does
not pass review.

---

## Fitness screen (TOGAF; Spool; Rumelt; Lencioni)

| Screen | construction-precedes-inspection | governed-context | no-orphan-activities |
|---|---|---|---|
| Understandable / Robust / Complete / Consistent / Stable (TOGAF) | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects definition-less checks | yes: rejects unsanctioned channels | yes: rejects orphan activities |
| Not fluff, not a goal-in-disguise (Rumelt) | directs and constrains without prescribing method | same | same |
| Not permission-to-play (Lencioni) | pass — most systems do NOT work this way | pass | pass |
| Implies ≥1 practice and ≥1 check (shop rule) | derivation practice; check-citation audit | promotion gate; provenance audit | process-membership lint; loop-exit review |
