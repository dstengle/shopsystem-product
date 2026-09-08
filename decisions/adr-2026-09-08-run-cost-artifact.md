---
type: adr
id: adr-2026-09-08-run-cost-artifact
title: Each run's cost row lands in a new lead-shop artifact beside the session record, written only by a runtime step at session-handoff's collect step
status: checked
version: 3
date: 2026-09-08
decided-by: lead-solutions-architect
right: guardrail
owner: lead-solutions-architect
created: 2026-09-08
updated: 2026-09-08
derives-from: [adr-2026-09-07-coordinator-role]
---

# ADR: Each run's cost row lands in a new lead-shop artifact beside the session record, written only by a runtime step at session-handoff's collect step

## 1. Context

Terms, from the glossary: a *session record* is the anchor of a
discovery conversation — outcome, produced and revised lists, open
threads, select quotes; an *anchor* is the governed record a
conversation attaches to and carries its state across transcript
boundaries; a *run* is one execution of a process, anchored to a work
item. `basis/processes/session-handoff.md` (v3) is the process that
produces the session record: its `collect` step (run-by the router,
execution `agent`) writes the record; `validate`, `route-validation`,
`file-defect`, and `land` are runtime steps. The `session_record` data
value is typed `$ref: session-record, from: pkg:shopsystem-knowledge/session-record`
— a package this shop does not own. Read from that package's own
published distribution metadata (the installed distribution
`shopsystem-knowledge` 0.1.0, whose own metadata reads "shopsystem-knowledge
bounded context," consulted at req-2026-09-07-shop-knowledge-answer,
§2), `pkg:shopsystem-knowledge` is itself a Bounded Context in the
taxonomy's terms — but not one this product's own decomposition
contains: `basis/contexts/` on this branch is empty, so this shop's
own decomposition holds no Bounded Context at all yet, and
`pkg:shopsystem-knowledge` is reached only through that package's own
contract tool, never through a product contract this decomposition
offers or consumes. `basis/processes/reconcile-and-close.md`
names its own `router`-run close step, a second close process with no
row-writing step of its own; a review conversation's anchor (a review
record) has no defined process on this branch at all
(session-handoff.md's own scope note; this branch's primer names the
reconcile-side amendments and the review-conversation anchor process
as open work).

Pre-state, 2026-09-08, read from lead-shop-held records.
init-run-measurement (v3) frames the outcome: "every session close
records, without a model, one row per agent run — step, role, minutes,
context tokens, output tokens where the harness gives them, tool uses —
beside the session record, so any run can be analysed on request," with
the no-gos "no analysis in the step itself — rows only" and "no
measure that needs a model to compute." Two of the four fields are
already within reach through delivered work: feat-process-runner (v9)
records the run's context on its anchor at the run's end (the scenario
"the run's context is recorded on the anchor at its end," hash
`96124cdccf45`) and the delivered router already reads the harness's
own usage report per resumed segment and per launched role —
feat-process-runner's Document History v7 ("Router context per segment
recorded on each anchor from the harness's usage report") and v9 ("the
lane run 40 turns, cache-read 1.69M on haiku... the launched roles
1.15M on fable beside it"). Output tokens are the field the framing itself
already qualifies ("where the harness gives them"): the transcript
carries only a streaming stub, so a row that leaves the field blank
where the harness does not expose it is the scoped answer, not a
shortfall. The feature repository, swept in full — seven other
features read for conflict — names no session record, cost row, or
close step; no conflict. adr-2026-09-07-coordinator-role (checked)
stands as the precedent for this role's `guardrail` right and for the
router-and-anchor mechanics this decision reads rather than
re-decides.

Forces. The originator (product authority, req-2026-09-07-run-efficiency):
"This should be completely mechanical data gathering that can even be
executed for each run to support optional analysis" — no model in the
step, ever. `single-source-of-truth`: the session-record schema is
owned by `pkg:shopsystem-knowledge`, fetched through that package's own
contract tool, not by this shop; a fact this shop does not own gets no
second home written into it. `actor-neutral-discipline`: a row that
records a run's cost is a record kept about an activity, not a
decision taken by one — the same discipline the router's steps already
keep, whoever or whatever fills them.

Options that were real:

- **Amend the session-record schema to carry the row.** Declined: the
  schema is `pkg:shopsystem-knowledge/session-record` — a package this
  shop does not own; amending it would put one fact (a run's cost) in
  two homes reachable by two owners, and this shop has no standing to
  change a schema it does not hold.
- **Compute a missing field, most often output tokens, by estimation.**
  Declined: the initiative's own no-go rules out any measure that needs
  a model, and the framing's own qualifier — "where the harness gives
  them" — already scopes the row to what the harness exposes; an
  estimated number would be indistinguishable from a measured one on
  the row, which is the failure this decision exists to prevent.
- **Write the row from an agent step (the router).** Declined: nothing
  about assembling the row needs judgment — it is a deterministic read
  of the anchor and the harness's usage report — so an agent step would
  spend a turn deciding nothing and would open the door to the
  estimation this decision rules out; `actor-neutral-discipline` asks
  for the same record whoever fills the step, and a runtime step gives
  that for free.
- **Add the same step to reconcile-and-close's close step and to a
  review conversation's anchor process in this decision.** Declined for
  now: reconcile-and-close closes a work item, not a session record, and
  a review conversation has no anchor process defined on this branch at
  all; extending the row to either is a separate question this record
  does not decide — the initiative's own words scope the target to "the
  session record."

## 2. Decision

The one row per agent run that init-run-measurement's outcome calls
for is written into a new artifact this shop owns and keeps beside the
session record — never as an amendment to the session-record schema
owned by `pkg:shopsystem-knowledge` — by a new runtime step (never an
agent step) added to `session-handoff-process` immediately after
`collect`, never inside it: `collect` is itself an agent step (run-by
the router) and keeps writing only the session record it already
writes; the new step follows it in the flow, before `validate`, joining
the process's existing runtime steps. The new step reads only the run's
anchor and the harness's own usage report, and leaves any field the
harness does not expose for a given run — most often output tokens —
blank, never estimated and never computed by a model. Whether
reconcile-and-close's own close step and a
review conversation's anchor need the same step is a separate question,
not decided here.

### 2.1 Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms, no exception carried. `knowable-shape` — the new artifact is
not a first-class entity (no Bounded Context, no shop); it gets a
description at creation like any other lead-shop artifact, and that
description is the first thing the feature that builds it writes.
`contracts-between-contexts` — no Bounded Context of this product's own
decomposition is touched; `pkg:shopsystem-knowledge` is itself a
Bounded Context per its own published metadata (§1) but external to
this decomposition, and this decision reaches it only through the read
already in place — the schema's own `$ref`, via that package's contract
tool — never a new reliance or a second home for its schema. `actor-neutral-discipline` — the row
records the same fields for a run whoever or whatever moved it; running
the write as a runtime step, never an agent step, is this decision's
own instance of the rule, not an exception to it. `local-comprehension`
— the artifact sits at the coordinating level beside the record it
measures, readable from the anchor and the session record alone,
without opening a Bounded Context. `bidirectional-conformance` — this
record is the design change, recorded before `session-handoff-process`
gains its new runtime step immediately after `collect` or the
artifact's typedef is written; the step and the typedef, once built,
are called for by this decision and nothing more. `intent-provenance`
— traces without a gap: the product
authority's words in req-2026-09-07-run-efficiency, to
sess-2026-09-07-b, to init-run-measurement (v2, this role's attach), to
this record.

## 3. Consequences

- A new artifact type exists. What changes: a typedef for the run-cost
  artifact is authored — one file per session record, paired with it —
  naming step, role, minutes, context tokens, output tokens, and tool
  uses as its fields, each nullable except where the harness always
  supplies it; it references the session record's own id rather than
  restating its frontmatter. For whom: the PO role, who defines the
  feature and its typedef; the maker, bound by `single-source-of-truth`
  to a reference, not a copy. Cost: one new typedef, its guideline, and
  its fitness set. Forecloses: a row that duplicates the session
  record's own fields instead of pointing at it.
- `session-handoff-process` gains a runtime step. What changes: a new
  runtime step is added immediately after `collect`, before `validate`
  — never inside `collect` itself, whose own execution stays agent-run
  and whose only output stays the session record — reading the run's
  anchor and the harness's usage report and writing the row; the
  process definition's version advances and its skill re-renders. For
  whom: the PO role, who authors the step; the router, whose `collect`
  step this new step now follows. Cost: one process-definition
  amendment and one re-render. Forecloses: a row written anywhere but
  this named step.
- The write is runtime-only, and a bound: no Bounded Context of this
  product's own decomposition is touched by this decision, but the rule stated here binds whoever
  builds or later amends this step inside the lead shop — the row MUST
  be written by a runtime step, never an agent step, and a field the
  harness does not expose MUST be left blank, never estimated and never
  computed by a model. What changes: the feature's build is checked
  against this bound at its own check, not left to the maker's
  discretion. For whom: the maker; the PO's check. Cost: a build that
  tries to fill a blank field by estimation is returned. Forecloses: a
  cost row indistinguishable between measured and estimated values.
- The Bounded Context this shop reads but does not own stays untouched.
  What changes: `pkg:shopsystem-knowledge` — itself a Bounded Context
  per its own published metadata (§1), external to this product's
  decomposition — gains no field and no version bump to its
  `session-record` schema on this shop's account; it is read exactly as
  today, through its own contract tool. For whom: that package's own
  owner, whose schema this decision does not ask anything of. Cost:
  none. Forecloses: a second home for the session record's own fields.
- Reconcile-and-close and review conversations stay out of scope. What
  changes: nothing — the row exists only for a run that closes through
  `session-handoff-process`. For whom: the authority, whose "every
  session" reading in the initiative is bounded, until a separate
  decision widens it, to the sessions this process closes and to the
  sibling init-process-runner's own rollout of the router. Cost: a
  session that closes through reconcile-and-close, or a review
  conversation, gets no row under this decision. Forecloses: nothing —
  a later record may extend the same step's shape to either anchor.

Bound on Bounded Context shops: none. No Bounded Context of this
product's own decomposition is touched; this decision governs a
lead-shop-only artifact and process step, and reaches
`pkg:shopsystem-knowledge` — a Bounded Context of its own, external to
this decomposition — only through the existing schema read, unchanged.

## 4. Reversibility

Reversible at low cost: the new artifact and the runtime step are
removed without touching the session-record schema, which this
decision never amends, and without changing what `session-handoff-process`
promises elsewhere — the `collect` step still produces the session
record either way. Review triggers: the sibling init-process-runner's
rollout reaches every session, making "every session" in
init-run-measurement's target reachable and prompting a check of
whether the same step belongs on reconcile-and-close's close step and a
review conversation's anchor (§1's declined-for-now option); the
harness begins exposing a field it does not today (most often output
tokens), prompting removal of the blank-field allowance; a field this
decision scopes to the runtime step turns out to need a decision no
runtime step can make, prompting a re-look at the actor-neutral
boundary drawn in §1.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Authored by the lead-solutions-architect role from the D1 decision recorded at init-run-measurement's initiative-check attach-architecture step (that initiative's Document History v2), triggered by this role's bet on initiatives/init-run-measurement.md. Pre-state read from lead-shop-held records alone: the initiative in full, session-handoff-process (v3), feat-process-runner (v9) and its context-at-end scenario, the feature repository's conflict sweep already performed at attach time, and adr-2026-09-07-coordinator-role as the precedent for the `guardrail` right. Screened against the architecture principle set: conforms, no exception carried. Not decided here, left as the initiative's D2 and its own open question: whether reconcile-and-close's close step and a review conversation's anchor need the same runtime step; the run-cost artifact's own typedef, left to the feature's authoring. |
| 2 | 2026-09-08 | review | Cold-read (cold-reviewer, judge model and prompt version not recorded here): three wobbly findings against the adr fitness set — criterion `principles` (`pkg:shopsystem-knowledge`'s place in the Bounded Context/shop taxonomy left unnamed against the blanket "no Bounded Context is touched" claim), scenario 1 (the new step's placement stated two ways — "added at `collect`" in §2, "at (or immediately beside) `collect`" in §3), scenario 2 (the router-usage-report citation bare — "v9's delivery history, v7" names no artifact). |
| 2 | 2026-09-08 | update | The one revise, by the lead-solutions-architect role, repairing all three findings. `pkg:shopsystem-knowledge` named in the taxonomy: per its own published distribution metadata (req-2026-09-07-shop-knowledge-answer, §2, "shopsystem-knowledge bounded context"), it is itself a Bounded Context, but external to this product's own decomposition (`basis/contexts/` empty on this branch) and reached only through its package contract tool — the claim narrowed everywhere from "no Bounded Context is touched" to "no Bounded Context of this product's own decomposition is touched," in §1, §2.1, and both Consequences statements. Placement fixed to one answer, stated identically in §2 and §3: a new runtime step immediately after `collect`, before `validate`, never inside `collect` itself — `collect` stays an agent step producing only the session record; the hedge "at (or immediately beside)" removed. The router-usage-report citation named: feat-process-runner's Document History v7 ("Router context per segment recorded on each anchor from the harness's usage report") and v9 ("the lane run 40 turns, cache-read 1.69M on haiku... the launched roles 1.15M on fable beside it"), replacing the bare "v9's delivery history, v7." Re-screened against the architecture principle set: conforms, no exception carried — `contracts-between-contexts` now states the external Bounded Context by name and the one channel (the existing `$ref`, via its contract tool) this decision reaches it through; the other five principles unchanged by the repair. Self-check against the adr fitness set: scenario 1 pass — one title, one decision sentence, the placement now single-valued; scenario 2 pass — forces and pre-state carry named evidence throughout, including the repaired citation; scenario 3 pass, unchanged; scenario 4 pass — the Bounded Context bound restated as a bound in both places it appears; scenario 5 pass, unchanged; scenario 6 pass — the principles screen restated with the narrowed claim. No other text changed. |
| 3 | 2026-09-08 | review | Cold-reviewer screening (model: claude-sonnet-5, role: cold-reviewer per basis/roles/cold-reviewer.md, task instructions 2026-09-08): three criteria reviewed against ADR fitness set. Verdict: findings on `principles` (Bounded Context taxonomy place named; "no Bounded Context is touched" narrowed to "no Bounded Context of this product's own decomposition is touched"), scenario 1 (step placement stated one way consistently), scenario 2 (router-usage citation artifact and version named specifically). Confidence: wobbly on all three. Findings addressed in the immediately following state entry's repair record. |
| 3 | 2026-09-08 | state | Decision: pass. The one decision holds each criterion of the fitness set. The three wobbly findings from the immediately preceding review — `pkg:shopsystem-knowledge`'s place in Bounded Context taxonomy, placement of the new runtime step (inside vs. beside collect), and router-usage-report citation specificity — are repaired by the lead-solutions-architect's revise (v2, 2026-09-08 update entry). Record length 2,544 words, long but within the criteria. Fitness set: scenario 1 (one decision per ADR) pass; scenario 2 (evidence named and sourced) pass; scenario 3 (decision text matches sections) pass; scenario 4 (Bounded Context bound restated) pass; scenario 5 (reversibility reasoned) pass; scenario 6 (principles screen complete) pass. Status set to checked. |
