---
type: principle-set
id: principles
status: experiment
created: 2026-08-10
updated: 2026-08-19
---

# Founding principles

## What a good principle looks like

A principle is a standing rule about how we work, in four parts: a name, a
statement, a rationale, and implications.

- The **statement** is the rule. It carries the only normative keywords
  (MUST, SHOULD, MAY — interpreted per BCP 14 when, and only when, they
  appear in capitals) and is testable: shown a piece of work, you can
  answer yes or no.
- The **rationale** says why the rule earns its place: the failure it
  prevents, with evidence where we have it.
- The **implications** are the price tag: the concrete changes each named
  actor absorbs to honor the rule. They add no obligations — every
  implication must be derivable from the statement, or it is a misfiled
  rule.

A principle is good when its statement is testable, it rejects something
we would otherwise do, it directs without prescribing method, it is not a
claim every shop would make, and it implies at least one practice and one
check. The fitness screen at the end of this document applies these tests
to the principles above it.

---

## One definition, two seats (`one-definition-two-seats`)

**Statement.** Every activity MUST operate from a stated definition of
what good looks like. That definition MUST drive both the performance of
the activity and its check, and the check MUST sit with a different role
holding different motivations.

**Rationale.** A definition applied only at the check puts the full weight
of quality after implementation, where rework is most frequent and most
expensive. A definition applied only up front invites gaming and closes
off outside perspective. Two roles reading one definition give both
prevention and challenge. (Deming: cease dependence on inspection; build
quality in — and still inspect.)

**Implications.** Authors of new activities ship the definition with the
activity, or the activity does not enter the system. A check that cannot
cite the definition clause it projects has no standing; anyone may remove
it without a new decision. Reviewers compare work to the written
definition; their own taste is not the standard. The same role never both
performs and checks an activity — process definitions name both roles, so
this is checkable mechanically. A failed spot check sends the maintainer
to the definition or the check, not only to the artifact.

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
when an artifact was produced. The router closes any memory channel that
lacks a defined process and a consumer. Tool owners ship each tool's skill
with the tool, in lockstep.

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
not a convenience. Authors have no cost excuse: a process definition is a
header plus a data section and a steps section. Reviewers fail any loop
without a declared exit.

---

## Fitness screen (the intro's tests; sources: TOGAF, Spool, Rumelt, Lencioni)

| Screen | one-definition-two-seats | governed-context | no-orphan-activities |
|---|---|---|---|
| Statement testable (TOGAF: understandable, complete, consistent) | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects definition-less checks and self-checked work | yes: rejects unsanctioned channels | yes: rejects orphan activities |
| Not fluff, not a goal-in-disguise (Rumelt) | directs and constrains without prescribing method | same | same |
| Not permission-to-play (Lencioni) | pass — most systems do NOT work this way | pass | pass |
| Implies ≥1 practice and ≥1 check (shop rule) | shared-definition practice; role-separation check | promotion gate; provenance audit | process-membership lint; loop-exit review |
| Normative keywords in statements only (mechanical) | pass | pass | pass |
| Implications derivable and actor-named (judged) | pass | pass | pass |
