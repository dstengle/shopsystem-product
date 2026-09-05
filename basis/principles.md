---
type: principle-set
id: principles
scope: working
owner: product-authority
status: approved
approved: 2026-08-22
version: 9
created: 2026-08-10
updated: 2026-09-05
---

# Founding principles

## What a good principle looks like

A principle is a standing rule about how we work, in four parts: a name, a
statement, a rationale, and implications. Terms the principles use —
rendering, anchor, definition chain, and the rest — are defined in the
[glossary](glossary.md); the processes and tools the implications name
are defined in this basis's sibling documents.

- The **statement** is the rule. It carries the only normative keywords
  (MUST, SHOULD, MAY — interpreted per BCP 14 when, and only when, they
  appear in capitals) and is testable: shown a piece of work, you can
  answer yes or no. A statement carrying more than one obligation
  presents one obligation per bullet.
- The **rationale** says why the rule earns its place: the failure it
  prevents, shown as a generic example; well-known external references
  may support it. Rationales stay prose.
- The **implications** are the price tag: one implication per bullet,
  the concrete change each named actor absorbs to honor the rule. They
  add no obligations — every implication must be derivable from the
  statement, or it is a misfiled rule.

A principle is good when its statement is testable (TOGAF, The Open
Group Architecture Framework: understandable, complete, consistent), it
rejects something we would otherwise do (Jared Spool, "Creating Great
Design Principles"), it directs without prescribing method (Richard
Rumelt, *Good Strategy Bad Strategy*), it is not a claim every shop
would make (Patrick Lencioni, "Make Your Values Mean Something",
Harvard Business Review, 2002), and it implies at least one practice
and one check. The fitness screen at the end of this document applies these tests
to the principles above it.

---

## Define what good looks like up front (`define-good-up-front`)

**Statement.**

- Every activity MUST operate from a stated definition of what good
  looks like.
- That definition MUST drive both the performance of the activity and
  its check.
- The check MUST sit with a different role holding a different
  accountability.
- Whoever makes an activity's output
  MUST evaluate that output against the definition of good before submitting it to the check.
- That evaluation MUST be recorded with the output — in its Document
  History or the step's own output.

**Rationale.** A definition applied only at the check puts the full weight
of quality after implementation, where rework is most frequent and most
expensive. A definition applied only up front invites gaming and closes
off outside perspective. Two roles reading one definition give both
prevention and challenge. (Deming: cease dependence on inspection; build
quality in — and still inspect.)

**Implications.**

- Authors of new activities ship the definition with the activity, or
  the activity does not enter the system.
- A check that cannot cite the definition clause it projects has no
  standing; anyone may remove it without a new decision.
- Reviewers compare work to the written definition; their own taste is
  not the standard.
- The same role never both performs and checks an activity — process
  definitions name both roles, so this is checkable mechanically.
- A failed spot check sends the maintainer to the definition or the
  check, not only to the artifact.
- Whoever proposes a new activity writes the proposal as a draft
  instance of the activity's type, so the type's derived checks run on
  the proposal before any reviewer reads it.

## Govern the generating context (`governed-context`)

**Statement.**

- Everything loaded into an agent's generating context — prompts,
  skills, memories, primers — MUST trace to an approved definition or a
  governed record.
- An unsanctioned context channel MUST NOT be created or retained.

**Rationale.** What an agent reads determines what it produces, so an
ungoverned context input is an ungoverned generator. The failure
mode this prevents: notes accumulate in channels no process governs, and
work comes to depend on content no one has ever reviewed.

**Implications.**

- Maintainers version every context input.
- Maintainers promote changes through a gated step.
- Maintainers can audit which definition version was in force when an
  artifact was produced.
- Whoever operates a context channel closes it when it lacks a defined
  process and a consumer.
- Tool owners ship each tool's skill with the tool, in lockstep.

## Every activity belongs to a process (`no-orphan-activities`)

**Statement.**

- Every activity in the system MUST be part of a defined process with
  stated expected outcomes, expected outputs, and possible resulting
  actions.
- Every long-running loop MUST declare its exit — a reached-state
  success exit, a round or budget cap, or both.

**Rationale.** An activity outside a process has no consumer for its
output, so the output piles up unread or is thrown away. Both
failure modes follow: feedback stops flowing when nothing consumes it, and
the signal migrates into ungoverned channels instead. Any runtime can follow a process defined at this
level — the requirement is a definition, not a workflow engine.

**Implications.**

- Reviewers treat an activity with no process as a defect, not a
  convenience.
- Authors have no cost excuse: a process definition is a header plus a
  data section and a steps section.
- Reviewers fail any loop without a declared exit.

## Use defined terms (`use-defined-terms`)

**Statement.**

- Important terms MUST be defined in the system, in the glossary or as
  a schema element.
- A term is important when a reader must know it to perform or check
  the work.
- When more than one term could carry a statement, the writer MUST use
  a defined term if one is available.

**Rationale.** The defined-term list — glossary entries plus schema
element names — restricts the available language, and a restricted
language aids clarity and reduces drift. The failure is cheap to reach:
two words for one thing appear within days of each other, and every
reader of both must learn they are the same.
(Controlled-vocabulary practice: ASD-STE100, ISO 704.)

**Implications.**

- Writers check the glossary and the schemas before coining a term; an
  undefined important term is a defect the author repairs by defining
  it or replacing it with a defined one.
- Schema authors are vocabulary authors: naming a field adds a term to
  the restricted language.
- Reviewers flag near-synonym pairs as drift; the losing term is
  removed everywhere, not deprecated in place.
- When in doubt whether a term is important, the writer defines it.

## Use external standards first (`external-standards-first`)

**Statement.**

- A definition MUST adopt an established external form where one fits.
- Bespoke structure MUST be justified by a recorded gap in the form it
  rejects.

**Rationale.** Established forms carry decades of failure-tested
decisions no fresh invention can match, and readers arrive already
knowing them. The failure a bespoke form invites: a home-grown format
half-copies the standard it ignored, every reader must learn it from
scratch, and it silently diverges from the tooling and expectations the
standard would have supplied for free. In practice every element of a
definition system has an established form, and the only bespokeness that
survives review is the composition of adopted parts.

**Implications.**

- Authors search prior art before drafting and name every adopted form
  in the definition's Sources section.
- Reviewers ask "what standard is this from" and treat unjustified
  invention as a defect.

## Single source of truth (`single-source-of-truth`)

**Statement.**

- Every fact, rule, or definition MUST have exactly one authoritative
  home.
- Every other appearance MUST be a reference or a generated rendering.

**Rationale.** Copies drift and each drifting copy trains a different
behavior. Copies of schemas drift from their source, and
pinned example links stop conforming as the source moves on.

**Implications.**

- Writers link or `$ref` instead of restating.
- Only the compiler touches renderings; a hand edit to a rendering is
  reverted, not merged.
- Reviewers treat a second authoritative statement of one rule as a
  defect and remove the losing copy everywhere.

## Feedback loops have consumers (`feedback-loops-with-consumers`)

**Statement.**

- Every feedback channel MUST name its consumer and the resulting
  action.
- The effectiveness of processes, tools, and prompts MUST be measured.
- The definitions of processes, tools, and prompts MUST be updated from
  what is measured.

**Rationale.** A channel without a consumer dies silently and takes its
signal with it: when nothing consumes a channel, senders stop sending
and the signal moves into ungoverned channels. Judged checks decay the same way when no one
grades the judge.

**Implications.**

- Whoever opens a channel names its consumer and resulting action at
  creation, or the channel is closed.
- Owners of judged checks grade a sample of verdicts on a standing
  calibration schedule.
- Definition owners treat measured ineffectiveness as an obligation to
  update the definition, not as background noise.

## Delivery is verified in the running system (`delivery-verified`)

**Statement.**

- Work MUST be counted done only when its effect is demonstrated in
  the running system.
- Artifacts existing, checks passing, or reviews approving MUST NOT
  count as done on their own.

**Rationale.** The gap between green artifacts and working systems is
where the worst defects live: builds publish without the built thing
ever running, and checks stay green while decided behavior goes
unrealized.

**Implications.**

- Definition authors name the runtime demonstration in every
  Definition of Done.
- Reviewers reject completion claims that cite only artifacts.
- Whoever closes work cites the demonstration evidence in the close
  reason — the reconcile process enforces this shape.

## Load the least context (`least-context`)

**Statement.**

- An activity MUST load the minimum context necessary to accomplish
  its task.
- The activity's process MUST name what loads into context and the
  source each input comes from.
- Context from an unapproved source MUST NOT be loaded.

**Rationale.** Extraneous context costs twice: tokens spent carrying it,
and drift when the agent follows something it was never meant to read.
The failure mode this prevents: unreviewed notes loading into every
session regardless of task, and unscoped conversations no one can
associate with specific work. (Least privilege, applied to context.)

**Implications.**

- Process authors declare a step's context inputs the way they declare
  data inputs — the declared list is the load list.
- Whoever runs a session loads a conversation's anchor and its
  definition chain, nothing ambient.
- Maintainers keep historical stores — archives, transcripts — out of
  ambient context; reading one is a deliberate, declared act.
- Reviewers treat an undeclared context load as a defect.

---

## Fitness screen (the intro's tests; sources: TOGAF, Spool, Rumelt, Lencioni)

| Screen | define-good-up-front | governed-context | no-orphan-activities | use-defined-terms | external-standards-first | single-source-of-truth | feedback-loops-with-consumers | delivery-verified | least-context |
|---|---|---|---|---|---|---|---|---|---|
| Statement testable (TOGAF: understandable, complete, consistent) | pass | pass | pass | pass | pass | pass | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects checks held by the maker alone, and submission without the maker's own evaluation | yes: rejects unsanctioned channels | yes: rejects orphan activities | yes: rejects undefined coinages and synonym pairs | yes: rejects unjustified invention | yes: rejects duplicate authorities | yes: rejects consumer-less channels | yes: rejects artifact-only done claims | yes: rejects ambient loads and unapproved sources |
| Not fluff, not a goal-in-disguise (Rumelt) | pass — directs without prescribing method | pass | pass | pass | pass | pass | pass | pass | pass |
| Not permission-to-play (Lencioni) | pass — most systems do NOT work this way | pass | pass | pass | pass | pass | pass | pass | pass |
| Implies ≥1 practice and ≥1 check (this document's intro) | shared-definition practice; role-separation check | promotion gate; provenance audit | process-membership lint; loop-exit review | term lookup before writing; undefined-term and near-synonym lint | prior-art search; Sources-section audit | link-or-ref practice; duplicate-statement review | consumer named at creation; calibration schedule | demonstration named in DoD; close-reason citation check | per-step context declaration; undeclared-load audit |
| Normative keywords used in statements only; capitals elsewhere only as the opening's mentions (mechanical) | pass | pass | pass | pass | pass | pass | pass | pass | pass |
| Implications derivable and actor-named, one per bullet (judged) | pass | pass | pass | pass | pass | pass | pass | pass | pass |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-10 | update | Authored as the working-scope seed set; nine principles. |
| 1 | 2026-08-22 | state | draft → approved by the owner. |
| 2 | 2026-08-23 | update | Rationale examples referencing the pre-migration corpus removed; two implication actors generalized; statements unchanged. |
| 2 | 2026-08-23 | review | Reference-resolvability cold read, two rounds; round 2 clean. |
| 3 | 2026-08-23 | update | Re-formed to bullet form — one obligation or implication per bullet; wording preserved modulo splits, plus three screen-forced repairs: feedback-loops measurement bullet split in two; governed-context maintainer implication split in three; least-context session-load implication gained its actor. |
| 3 | 2026-08-23 | review | Verification cold reads: round 1 findings (three form fusions, repaired); round 2 findings — pre-existing defects exposed by the tightened rubric (use-defined-terms criterion misfiled in an implication; article typo in governed-context; unintroduced cross-document references), repairs awaiting the owner's ruling. |
| 4 | 2026-08-23 | update | Owner-ruled repairs: the importance criterion moved from an implication into the use-defined-terms statement; the article typo in governed-context fixed; the opening gains the glossary and sibling-documents pointer. |
| 4 | 2026-08-23 | state | The three v3 screen-forced repairs stand accepted by the owner. |
| 4 | 2026-08-23 | review | Verification cold read round 3: findings — external-standards-first rationale lacked its generic failure example (scenario 3 fail); two self-containment stumbles. |
| 5 | 2026-08-23 | update | Round-3 repairs under the standing generic-rationale rule: external-standards-first rationale gains its generic failure example; the feedback-loops update bullet made self-contained; "already" dropped from the reconcile implication. |
| 5 | 2026-08-23 | review | Verification cold read round 4: clean — all scenarios pass; 5 polish-level stumbles (bare surname citations, the "projects" verb, two implicit actors), none a fail. |
| 6 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 7 | 2026-08-23 | update | Close-out polish: the opening's test sources named in full (Spool, Rumelt, Lencioni works cited; TOGAF expanded) — the standing cold-read stumble retired. |
| 8 | 2026-09-05 | update | Amended under req-2026-09-05-maker-self-check at the small-change lane's make step by the lead-solutions-architect role, through principle-set-authoring's draft step — the set's own producing process, now one screen, one revise, the owner's approval: define-good-up-front gains a fourth statement, the maker of an activity's output evaluates it against the definition of good before submitting it to the check and records that it did; the three existing statements, every other principle, and the fitness screen unchanged. The author's self-check, as the new statement asks: the fitness screen's define-good-up-front column re-read against the amended statement — every cell holds as written (testable; rejects unevaluated submission as it rejects self-checked work; directs without method; practice and check implied). The process's one screen did not run in this step — it is the lead-pm's to run at the lane's check step and record here. The owner's approval stands on the product authority's ruling of 2026-09-05 accepting the request. |
| 9 | 2026-09-05 | update | Repair under req-2026-09-05-maker-self-check, small-change lane round 2, by the lead-solutions-architect role: principle-set-authoring's one screen ran at the lane's check step (judge claude-fable-5-1, screen prompt v6) — one confident finding, the fourth statement carried two obligations in one bullet; two wobbly, "maker" outside the set's actor vocabulary and the record's home unnamed; one cosmetic, the screen cell for define-good-up-front's Spool test. Repairs: the fourth statement split into two bullets, one obligation each — whoever makes the output evaluates it against the definition of good before submitting it to the check; that evaluation is recorded with the output, in its Document History or the step's own output; the Spool cell reworded to reject checks held by the maker alone and submission without the maker's own evaluation. The first new bullet is wrapped as tightly as its verifying phrase allows — the lane's observation matches it on one source line. The owner's approval stands on the product authority's ruling of 2026-09-05 accepting the request. |
