---
type: principle-set
id: principles
scope: working
owner: product-authority
status: approved
approved: 2026-08-22
created: 2026-08-10
updated: 2026-08-21
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
we would otherwise do (Spool), it directs without prescribing method
(Rumelt), it is not a claim every shop would make (Lencioni), and it implies at least one practice and one
check. The fitness screen at the end of this document applies these tests
to the principles above it.

---

## Define what good looks like up front (`define-good-up-front`)

**Statement.** Every activity MUST operate from a stated definition of
what good looks like. That definition MUST drive both the performance of
the activity and its check, and the check MUST sit with a different role
holding a different accountability.

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
to the definition or the check, not only to the artifact. Whoever
proposes a new activity writes the proposal as a draft instance of the
activity's type, so the type's derived checks run on the proposal before
any reviewer reads it.

## Govern the generating context (`governed-context`)

**Statement.** Everything loaded into an agent's generating context —
prompts, skills, memories, primers — MUST trace to a approved definition or
a governed record; an unsanctioned context channel MUST NOT
be created or retained.

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

## Use defined terms (`use-defined-terms`)

**Statement.** Important terms MUST be defined in the system, in the
glossary or as a schema element. When more than one term could carry a
statement, the writer MUST use a defined term if one is available.

**Rationale.** The defined-term list — glossary entries plus schema
element names — restricts the available language, and a restricted
language aids clarity and reduces drift. The failure is cheap to reach
and this review reached it: the process format introduced "kind" beside
the already-defined "artifact type" — two words for one thing inside a
week, and every reader of both had to learn they were the same.
(Controlled-vocabulary practice: ASD-STE100, ISO 704.)

**Implications.** Writers check the glossary and the schemas before
coining a term; an undefined important term is a defect the author
repairs by defining it or replacing it with a defined one. Schema authors
are vocabulary authors: naming a field adds a term to the restricted
language. Reviewers flag near-synonym pairs as drift; the losing term is
removed everywhere, not deprecated in place. A term is important when a
reader must know it to perform or check the work; when in doubt, the
writer defines it.

## Use external standards first (`external-standards-first`)

**Statement.** A definition MUST adopt an established external form where
one fits; bespoke structure MUST be justified by a recorded gap in the
form it rejects.

**Rationale.** Established forms carry decades of failure-tested
decisions no fresh invention can match, and readers arrive already
knowing them. The format research proved the point here: every element of
the definition system had an established form, and the only bespokeness
that survived review was the composition of adopted parts.

**Implications.** Authors search prior art before drafting and name every
adopted form in the definition's Sources section. Reviewers ask "what
standard is this from" and treat unjustified invention as a defect.

## Single source of truth (`single-source-of-truth`)

**Statement.** Every fact, rule, or definition MUST have exactly one
authoritative home; every other appearance MUST be a reference or a
generated rendering.

**Rationale.** Copies drift and each drifting copy trains a different
behavior. This shop measured it: consuming repos copied schema files
instead of referencing the registry and drifted from the real schemas,
and a typedef's pinned example link stopped conforming within days of
being written.

**Implications.** Writers link or `$ref` instead of restating. Only the
compiler touches renderings; a hand edit to a rendering is reverted, not
merged. Reviewers treat a second authoritative statement of one rule as a
defect and remove the losing copy everywhere.

## Feedback loops have consumers (`feedback-loops-with-consumers`)

**Statement.** Every feedback channel MUST name its consumer and the
resulting action; the effectiveness of processes, tools, and prompts MUST
be measured, and their definitions MUST be updated from what is measured.

**Rationale.** A channel without a consumer dies silently and takes its
signal with it: this shop's agents stopped sending mechanism_observation
because nothing consumed it, and the improvement signal moved into an
ungoverned memory tool. Judged checks decay the same way when no one
grades the judge.

**Implications.** Whoever opens a channel names its consumer and resulting
action at creation, or the router closes it. Owners of judged checks
grade a sample of verdicts on a standing calibration schedule. Definition
owners treat measured ineffectiveness as an obligation to update the
definition, not as background noise.

## Delivery is verified in the running system (`delivery-verified`)

**Statement.** Work MUST be counted done only when its effect is
demonstrated in the running system; artifacts existing, checks passing,
or reviews approving MUST NOT count as done on their own.

**Rationale.** The gap between green artifacts and working systems is
where this fleet's worst defects lived: six fabro-launcher defects
surfaced only at live end-to-end because CI built and published without
ever running the image, and the 2026-08-03 trust break traced to checks
green while decisions were unrealized.

**Implications.** Definition authors name the runtime demonstration in
every Definition of Done. Reviewers reject completion claims that cite
only artifacts. Whoever closes work cites the demonstration evidence in
the close reason — the reconcile process already enforces this shape.

## Load the least context (`least-context`)

**Statement.** An activity MUST load the minimum context necessary to
accomplish its task. The activity's process MUST name what loads into
context and the source each input comes from; context from an unapproved
source MUST NOT be loaded.

**Rationale.** Extraneous context costs twice: tokens spent carrying it,
and drift when the agent follows something it was never meant to read.
This shop's evidence: 67 unreviewed memories loaded into every session
regardless of task, and unscoped conversations no one could associate
with specific work. (Least privilege, applied to context.)

**Implications.** Process authors declare a step's context inputs the way
they declare data inputs — the declared list is the load list. The router
loads a conversation's anchor and its definition chain, nothing ambient.
Maintainers keep the journal and the archive out of ambient context;
reading either is a deliberate, declared act. Reviewers treat an
undeclared context load as a defect.

---

## Fitness screen (the intro's tests; sources: TOGAF, Spool, Rumelt, Lencioni)

| Screen | define-good-up-front | governed-context | no-orphan-activities | use-defined-terms | external-standards-first | single-source-of-truth | feedback-loops-with-consumers | delivery-verified | least-context |
|---|---|---|---|---|---|---|---|---|---|
| Statement testable (TOGAF: understandable, complete, consistent) | pass | pass | pass | pass | pass | pass | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects definition-less checks and self-checked work | yes: rejects unsanctioned channels | yes: rejects orphan activities | yes: rejects undefined coinages and synonym pairs | yes: rejects unjustified invention | yes: rejects duplicate authorities | yes: rejects consumer-less channels | yes: rejects artifact-only done claims | yes: rejects ambient loads and unapproved sources |
| Not fluff, not a goal-in-disguise (Rumelt) | pass — directs without prescribing method | pass | pass | pass | pass | pass | pass | pass | pass |
| Not permission-to-play (Lencioni) | pass — most systems do NOT work this way | pass | pass | pass | pass | pass | pass | pass | pass |
| Implies ≥1 practice and ≥1 check (shop rule) | shared-definition practice; role-separation check | promotion gate; provenance audit | process-membership lint; loop-exit review | term lookup before writing; undefined-term and near-synonym lint | prior-art search; Sources-section audit | link-or-ref practice; duplicate-statement review | consumer named at creation; calibration schedule | demonstration named in DoD; close-reason citation check | per-step context declaration; undeclared-load audit |
| Normative keywords used in statements only; capitals elsewhere only as the opening's mentions (mechanical) | pass | pass | pass | pass | pass | pass | pass | pass | pass |
| Implications derivable and actor-named (judged) | pass | pass | pass | pass | pass | pass | pass | pass | pass |
