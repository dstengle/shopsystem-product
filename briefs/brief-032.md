---
type: decision-brief
id: brief-032
status: delivered
date: 2026-08-28
reader: product-authority
decisions-requested: 3
annex: annex-032.md
version: 6
---

# Brief 032: the product flow from discovery to assigned scenarios

**Open findings at the round cap (four cold reads).** The decision
layer runs ~600 words against the ~400 budget — the six sub-process
lines and the batch-to-definition mapping are on the page at your
request; and five terms arrive before their gloss: *initiative* (the
product-level problem artifact, approved 2026-08-28), the *solutions
architect* and *product designer* (existing approved roles, not new
with ask 1), *reconcile-and-close* (the existing process that takes a
shop's returned work), and the *decision-record typedef* (the product
decision record, a PO artifact — not the retired decision ledger).
The reader's three count findings are repaired below.

**The answer first.** The gap you see is real: discovery ends at a
session record (the notes of one conversation) and nothing carries an
idea from there to a scenario a shop can take up. Below is the whole
path as one top-level process, `product-flow`, composed of six
sub-processes — three exist, three are new — and a build plan of five
batches (four screens: B rides with A), about five sessions of work.
Recommendation: approve the model, the build order, and block
approval. Ask 1 gates the work; asks 2 and 3 default on silence.

## Asks

**1. Approve the model.** *What you approve:* one run per initiative
through six sub-processes, in order —
- `discovery-conversation` (exists; amended): you and the assisting
  agent, in one of three forms — brainstorm, interview, or review of
  evidence — leave an initiative recorded `proposed` or `cancelled`.
- `initiative-check` (new): the solutions architect and the product
  designer attach feasibility, decomposition, and usability; the cold
  reviewer screens; you take the bet — the go/no-go on spending the
  initiative's appetite, the time or capacity it names — inside the
  check; a bet moves it from `proposed` to `planned`.
- `backlog-ordering` (new, one step): the PO places the planned
  initiative in the backlog order; the PO output check screens it.
- `feature-authoring` (new): the PO drafts one feature from the
  initiative, co-produces its scenarios with the owning shops (the run
  waits for their answers; while shops are frozen, the PO writes their
  part as a marked hypothesis), and the designer adds criteria.
- `po-output-check` (exists; amended): screens the feature; the
  initiative becomes `active` when its first feature passes.
- `scenario-assignment` (exists as a draft): the architect tags each
  scenario's Bounded Context, chooses the message type, dispatches;
  the loop returns to `feature-authoring` until every feature is
  assigned.
*Binds:* the six and their hand-offs. *Drafting default:* prompts,
caps, wording, outcome states. *Evidence:* the 2026-08-27 system-read
report — a whole-corpus review by three fresh readers — found the
making and carrying steps between the checks undefined; each is now
one of the six (measuring stays on the reconcile side, ask 3). *Default:* none — silence does not
approve.

**2. Approve the build order and block approval.** *What you
approve:* five batches in four screens (B with A), each screen's set approved
as one block. A: `initiative-check`, re-screening the initiative chain (3) and
the decision-record typedef amendment (1) — one session. B: the
discovery amendment, screened with A — half. C: `feature-authoring`
and `backlog-ordering`, re-screening the feature chain (3) and the
three PO guidelines — one to two. D: the `po-output-check` amendment
and `scenario-assignment` with its `assignment` type, re-screening the
process-definition and data-type typedef amendments — half. E:
`product-flow` and the primer's opening paragraph — the one it lacks,
saying what the product is and for whom — screened end to end — one.
*Binds:* A before C before D before E, and that the fourteen
already-drafted definitions the batches re-screen — the initiative
chain (3), the feature chain (3), `scenario-assignment` and its
`assignment` type (2), the three PO guidelines (3), the three typedef
amendments (3) — are approved with their batch, not one by one; the
new work in each batch (five processes and the primer paragraph) is
approved the same way.
*Drafting default:* none. *Evidence:* the last three days ran about
forty screen rounds; this plan runs four for the same definitions.
*Default:* proceed in this order.

**3. Accept what is left out of the five batches.** *What you
approve:* five exclusions — the initiative's `completed` state and the
product changelog (the record of shipped change), both set when a
shop's work returns through reconcile-and-close; the roadmap (a view
of initiatives by state); the `router` role reconcile-and-close names
and no definition holds; discovery forms beyond the three. *Binds:*
none is built in A–E. *Drafting default:* each is noted in the
definition that needs it. *Evidence:* none is on the path from
discovery to assignment. *Default:* accepted.

## Deferred

None.

## Annex

[annex-032.md](annex-032.md) — the flow diagram, the sub-process table
with steps and roles, the batch table, the exclusions (optional).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-28 | update | Composed from the system read's judgment and the definitions built since. |
| 1 | 2026-08-28 | review | Cold read round 1: findings — the model and the batches only in the annex; six named vs five walked; five batches vs four screens unexplained; bet, system read, reconcile, and batch contents unintroduced; a deferral written as a commitment. |
| 2 | 2026-08-28 | update | Six sub-process lines and five batch lines on the page; the screen count explained; terms glossed; the deferred approvals moved into ask 2 as a drafting default; co-production moved into the model. |
| 2 | 2026-08-28 | review | Cold read round 2: findings — the approval-scope clause under Drafting default; six terms unglossed; the opening's screen count against ask 2; effort and the review saving not on the page; a self-contradicting Deferred line. |
| 3 | 2026-08-28 | update | The fourteen definitions moved into Binds and counted; the six terms glossed; effort per batch and the round count on the page; Deferred: none. |
| 3 | 2026-08-28 | review | Cold read round 3: findings — decision layer 62% over; the batch-to-definition mapping not on the page; "B may join A or C" against the four-screen count; two-new/one-new arithmetic; terms unglossed. |
| 4 | 2026-08-28 | update | One line per sub-process; the fourteen definitions mapped to their batches on the page; B fixed with A; three-are-new; system-read, changelog, roadmap, decision-record glossed; one name per role. |
| 4 | 2026-08-28 | review | Cold read round 4 (cap): findings — "fourteen" against the page's count; four exclusions listed as five; "each screened once" against four screens; five terms unglossed; the evidence's "measuring" step unmapped. |
| 5 | 2026-08-28 | update | Counts repaired; the bet's transition stated; measuring routed to ask 3; delivered at the cap with the open findings stated first. |
| 5 | 2026-08-28 | state | draft → delivered at the round cap. |
| 6 | 2026-08-28 | update | The evidence sentence's "measuring" step, unmapped in round 4, routed to ask 3 — one line the cap-round repair missed. |
