---
type: adr
id: adr-2026-09-05-role-offer
title: A role's offer on attaching to an initiative is a data type the attach step outputs, rendered into the initiative
status: checked
version: 3
date: 2026-09-05
decided-by: product-authority
right: escalation
owner: lead-solutions-architect
created: 2026-09-05
updated: 2026-09-05
derives-from: [adr-2026-09-04-request-front-end]
---

# ADR: A role's offer on attaching to an initiative is a data type the attach step outputs, rendered into the initiative

## 1. Context

This repository is the lead shop: the coordinating shop of the product,
owning the product-level definitions under `basis/` and no Bounded
Context — a region of the product with its own model, built by a shop
of its own, a BC shop. An *initiative* is the product-level problem
artifact the PM role frames; before the authority *bets* on it — decides
to spend its *appetite*, the bound in time or capacity the initiative
states — two roles *attach* to it in the
[initiative-check](../basis/processes/initiative-check.md) process: the
solutions architect role writes its feasibility verdict and the
decomposition, the product designer role its usability evidence. A
role's *offer* is what it writes when it attaches.

Pre-state, 2026-09-05. The
[initiative typedef](../basis/artifacts/initiative.md) (v10) requires
of the initiative's §4 — its Feasibility and usability section — "the
solutions architect role's feasibility verdict with its reasons" and
bounds the whole document to 500 words; its
[fitness set](../basis/fitness/initiative.fitness.md) (v4, scenario 5)
judges "verdict present with reasons" and nothing more. The attach
steps of initiative-check (v7) output `initiative: string` — the path
of the document — and their prompts carry the whole of what the offer
must contain; no data type carries it. The
[role-definition typedef](../basis/artifacts/role-definition.md) (v3)
requires two sections, Accountabilities and Exclusive domain; the four
role definitions carry six more the typedef does not name, and none
names the decisions a role must offer on. A *data type*
([typedef](../basis/artifacts/data-type.md), v3) is "a named,
schema-defined structure that passes between process steps but is not
a human-readable document"; the shop has twelve, and three are what a
step outputs for another step to route or decide on —
[check-decision](../basis/types/check-decision.md),
[ask](../basis/types/ask.md), and
[screen-review](../basis/types/screen-review.md), whose `verdict` the
`route-screen` step reads.

Forces. The evidence the discovery conversation reviewed
([sess-2026-09-05-d](../sessions/sess-2026-09-05-d.md)): across the
last three runs the lead-pm shaped the architect's offer by hand — the
verdict's form in an ask, the design decision the bet rests on in a
brief, a risk to the *measure* — the one quantity an initiative names,
with its current condition and its target, by which the outcome is
judged — that landed as prose and drew a finding because the verdict
has no place for one. The initiative
[init-role-decisions](../initiatives/init-role-decisions.md) carries
the framing; its Document History (v2) holds the architect's first
unprompted full offer, kept out of the initiative's §4 by the 500-word rule. Work item
lead-8hcu8 records the gap the offer closes by definition: the bet
step does not ask whether the bet rests on a decision with no record.
Working principles bearing: `define-good-up-front` — the attach
activity has no stated definition of good for its output beyond
"verdict with reasons"; `single-source-of-truth` — the offer's shape
today lives in prompts and in the lead-pm's instructions, several
homes for one fact.

**The escalation that settled it.** The decision is the authority's,
so it records under `right: escalation`: none of the five rights the
solutions architect role holds — stack, guardrail, decomposition,
contract between Bounded Contexts, non-functional requirement — covers
the shape of a lead-shop role's own attachment. The authority ruled
on 2026-09-05, in the discovery conversation on
[req-2026-09-05-feasibility-defined](../requests/req-2026-09-05-feasibility-defined.md):
"Roles should always be ready to offer complete information on the
decisions or parts of decisions that are in their domain. This should
be an aspect of the role and not just instructions from the lead-pm";
"It should be in each role and there should be a section in the
typedef on what domain decisions it owns"; and "converge" on the
position the frame step recorded — the offer takes a fixed shape, a
data type, so the check can route each decision the bet depends on.
The architect's feasibility attachment named this decision — D1 — as
one the bet rests on, and the lead-pm routed it here before the bet.

Options that were real:

- **A typedef section alone.** The role-definition typedef gains a
  section naming the domain decisions each role owns; the offer stays
  prose in the initiative's §4, shaped by each role's own text. Declined: the section
  says what a role owns, not what its offer carries — the screen would
  still judge "verdict with reasons" and the lead-pm would still
  supply the rest by instruction, the evidence under review; and a
  step routes on a field, never on prose — the `route-screen` step
  reads `review.verdict`, and a decision the bet depends on can be
  sent to adr-authoring only if it is a value a branch can test.
- **The offer's parts written into the initiative typedef's §4.**
  Declined: the shape would hold for the initiative only — the
  architect role's feasibility accountability covers every framed
  problem and every feature — and a document section is a rendering
  target, not a value a step outputs; the 500-word rule would carry
  the parts as required prose it has no room for.
- **Extend an existing data type.** `check-decision` or
  `screen-review` given an offer variant. Declined: each is a
  checking role's verdict on a checked thing; an offer is a maker's
  attachment before the check, and one type carrying both misnames
  the second (`use-defined-terms`).

Not decided here: three candidates for records of their own — the
500-word cap's split (D2), whether the designer role's offer fits the
one shape (U2), and the pre-bet route to adr-authoring (D3) — are
listed with their owners and defaults in this record's Document
History (v1).

## 2. Decision

A role's offer on attaching to an initiative is a data type — one type,
whichever role attaches — that the attach step outputs, carrying the
role's verdict, the decisions the bet depends on each with its record
or "none", the risks to the measure, the unknowns each with a default,
and the evidence read; the initiative's §4 carries the offer's verdict
rendered from that value, and the full offer's rendering there once
the initiative typedef's cap is split (the first candidate); until
then the full offer stands in the initiative's Document History.

Bound, not a second decision: the role-definition typedef's section
names the decisions a role owns; it does not define the offer's shape.

## Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms on five; `intent-provenance` rests on the exception
[adr-2026-09-04-request-front-end](adr-2026-09-04-request-front-end.md)
carries, escalated to the authority (work item lead-4kymc).
`knowable-shape` — what the lead shop's attaching roles produce is
readable from the data type and the typedef's section, not from a
prompt or a transcript. `contracts-between-contexts` — no Bounded
Context is touched; the initiative's Decomposition says so.
`actor-neutral-discipline` — the shape attaches to the attach
activity and the role; the same offer is due whoever fills the role,
the authority in person or an agent, and "an aspect of the role and
not just instructions" states that. `local-comprehension` — the
attacher works from the initiative and its level's designated
artifacts and names the evidence it read inside the offer; the
authority bets from the initiative alone. `bidirectional-conformance`
— this record precedes the type and the amendments; forward, the
initiative's measure — roles whose definition names the decisions
they own and that offer complete information on them unasked, 0 of 4
now, 4 of 4 the target; reverse, the type's
Purpose names its producing and consuming steps, so a step writing an
offer no type calls for is a defect. `intent-provenance` — the
request, its route, the initiative, and this record are each
recorded; the entry contract the request names has no artifact yet —
the cited exception.

## 3. Consequences

- The offer has one shape and one home. What changes: one data type
  joins `basis/types` beside check-decision, ask, and screen-review,
  its five parts as fields — the type's name and field names are its
  author's, under the data-type typedef; initiative-check's attach
  steps output it, and the initiative's §4 carries it rendered as §2
  states. For whom: the solutions
  architect and product designer roles, which output it; the cold
  reviewer, whose scenario 5 reads the rendering; the lead-pm, which
  no longer supplies the shape; the authority at the bet, which reads
  the decisions the bet depends on in the initiative. Cost: one type;
  two step amendments and the skill re-rendered; the initiative
  fitness set's scenario 5 amended to judge the rendered parts.
  Forecloses: a verdict in free prose — "feasible" with no decisions,
  risks, or unknowns is incomplete by shape, and a part marked "none"
  is a claim the screen judges.
- The role-definition typedef names what a role owns. What changes:
  the typedef gains a required section, the domain decisions the role
  owns and offers on; its fitness set is hand-amended, the four role
  definitions gain the section and are re-rendered. For whom: the
  product authority, the typedef's owner; the four roles. Cost: the
  typedef amendment in order with brief-030's pending amendment to the
  same typedef; four role edits and one render. Forecloses: an
  obligation to offer that lives only in a process prompt.
- A decision the bet depends on can be routed. What changes: each
  decision entry carries its record or "none", a value a branch can
  test; the pre-bet route to adr-authoring — the third candidate — is
  what would read it and close lead-8hcu8 by definition. For whom:
  the lead-pm; the architect and designer roles, which author the
  records. Cost: a record per unrecorded decision before the bet; the
  session lengthens by each.
- The attach instruction is one sentence. What changes: the shape
  carries what the prompts carried; "here is the initiative, add your
  feasibility or ask questions" is the whole instruction. For whom:
  the lead-pm — no ad-hoc instructions, the authority's direction.
  Cost: a shape gap goes unfilled silently until a screen finds it;
  the type is amended, never the instruction.
- The rendering must fit or the cap must split. What changes: the
  verdict is rendered into the initiative's §4 under the 500-word
  rule and the full offer into its Document History; whether the cap
  splits between §1–3 and the attachments, or the full offer's
  durable rendering moves outside the cap, is the first candidate,
  the initiative typedef owner's. For whom: the attaching roles,
  whose full offer lands in a history row until the cap is ruled; the
  authority, reading the initiative's §4 at the bet. Cost: until it
  is ruled, a full offer overflows the initiative's §4 as
  init-role-decisions shows — §1–3 at 363 words, the offer in a
  history row.

Bound on Bounded Context shops: none — the offer is a lead-shop role's
output at the coordinating level; a BC shop's own attachments stand
under its own operational contract, and extending this shape to them
would be a guardrail decision, the architect role's.

## 4. Reversibility

Reversible at low cost until the type is referenced: while it stands
alone in `basis/types`, reverting is deleting it and restoring the
attach prompts from source control. Hard once the four role
definitions, the role-definition typedef's fitness set, and
initiative-check's data block reference it: each reference re-points,
the roles and the skill re-render, and an initiative carrying a
rendered offer keeps it — readable, but shaped by a type that no
longer exists. Review triggers: a role whose domain the five parts
cannot carry — the designer's offer is the first test; a second
consumer, feature-level feasibility at feature-authoring, needing a
different shape; the initiative typedef's ruling on the cap moving the
offer's rendering out of the initiative's §4; the step-communication
request — how an agent's instruction is assembled, a *no-go* of the
initiative, one of the things it states it will not do — landing
a mechanism that carries the shape itself, so the type would be a
second home.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Authored through the adr-authoring process at its author step, on the lead-pm's routing before the bet on init-role-decisions, for the authority's direction of 2026-09-05 in the discovery conversation on req-2026-09-05-feasibility-defined (lead-ampnd; sess-2026-09-05-d) — the architect's D1 from the initiative's Document History (v2). Right: `escalation` — the decider is the authority, and none of the five rights the solutions architect role holds covers the shape of a lead-shop role's attachment; the adr typedef sends a decision no listed right covers to `right: escalation` in the type whose deciding side raised it, and the architect side raised this one in its feasibility attachment. Recorded as an adr rather than a product decision record because the decision is about the shape of the shop's process data and records, not product value or order. Three candidates not decided here: (1) D2 — the 500-word rule's split between §1–3 and the attachments, or the full offer's durable home outside the cap — the initiative typedef's owner's, put to the authority at the bet; (2) U2 — whether the designer role's offer fits the one shape, its domain, default one role-neutral type with a part the role's domain does not cover marked "none"; (3) D3 — the pre-bet route from the initiative check to adr-authoring for a decision entry marked "none", a process amendment under its owner, reversible. Maker's self-check against the adr fitness set: scenario 1 — one-line title, one decision sentence, actionable; scenario 2 — pre-state with five cited sources, three options each with its reason; scenario 3 — decider and right in frontmatter, the escalation named in §1; scenario 4 — five consequences each with what changes, for whom, cost or foreclosure, the BC bound stated as none; scenario 5 — reversibility with its threshold and four triggers; scenario 6 — the screen stated per principle, the intent-provenance exception cited to the record that carries it. Status draft pending the screen. |
| 1 | 2026-09-05 | review | Screen round 1, the one screen (judge: claude-fable-5-1 / screen prompt v6): three confident — the fifth consequence without its "For whom"; the three candidates unnamed where §1 first points at them; "appetite", "the measure", and "no-go" unglossed at first use, and "§4" colliding with this record's own §4 — and three wobbly, ruled by the lead-pm — the decision sentence carried a second clause on the role-definition typedef, to become a bound after it; the rendering clause not actionable while the cap stands; "the initiative's measure" unglossed in the bidirectional-conformance line. |
| 2 | 2026-09-05 | update | The one revision: the fifth consequence's "For whom" added (the attaching roles, the authority at the bet); the typedef clause moved out of the decision sentence into a bound stated after it, the title unchanged; the rendering clause made actionable now — the verdict rendered into the initiative's §4, the full offer there once the cap is split and in the Document History until then; the three candidates named in one line in §1; the measure glossed in the bidirectional-conformance line; "appetite", "measure", and "no-go" glossed at first use and "the initiative's §4" written wherever the section is meant. |
| 3 | 2026-09-05 | state | `draft` → `checked`: the PM role's pass after the one screen and the one revise the process allows — the three confident findings (a consequence's bearer, the candidates named in reading order, glosses) repaired; the wobbly ones ruled: one decision with the typedef section as a bound; the rendering clause actionable now with the cap's split as the first candidate. The decider is the authority; the record checked for form; `right: escalation` accepted. Authored and revised from the step's own prompt, nothing added by the lead-pm. |
