---
type: artifact-typedef
id: product-decision-record-typedef
defines: product-decision-record
owner: product-authority
status: approved
approved: 2026-08-31
version: 7
created: 2026-08-26
updated: 2026-09-05
ancestry: [product-decision-record]
---

# Artifact type: product-decision-record

## Identity and ancestry

- **Type:** `product-decision-record` — the record of one product-level
  decision and its reasons: what was decided, by which role under which
  right, against which alternatives, with what consequences, and how
  hard it is to reverse. The product-side counterpart of the
  architecture decision record.
- **Produced by:** the [PO role](../roles/lead-po.md), for a decision the
  PM role or the PO role has taken; checked by the
  [PO output check](../processes/po-output-check.md) against the
  [product-decision-record fitness set](../fitness/product-decision-record.fitness.md).
  The [guideline](../guidelines/product-decision-record.md) the PO role
  writes from and the fitness set the check screens against are
  renderings of this typedef — produced from its Writing rules and
  Fitness scenarios sections by `basis/tools/compile_typedef.py`, never
  edited by hand.
  **Consumed by:** every role whose later decision the record bounds;
  Bounded Context shops; the PM role at the check.

## Required frontmatter

`type: product-decision-record`, `id`, `status` (draft | checked |
returned | pending-definition | superseded — replaces `checked` when the PO role
files a later record naming this one as superseded), `version`, `date`,
`decided-by` (the role, or `product-authority`), `right` (the decision
right exercised — for the authority's go, hold, or no-go on an
initiative, `bet` — or
`escalation`, in which case §1 names the escalation that settled it), `owner`, `created`, `updated`.

## Required sections

1. **Decision** — exactly one decision, as a sentence a reader can act
   on.
2. **Alternatives** — at least one the deciding role could have chosen,
   with the reason it was not.
3. **Consequences** — each: what changes, for whom, and what it costs or
   forecloses.
4. **Reversibility** — how hard the decision is to reverse and, if hard,
   what would trigger revisiting it.

## Rules

- Instances live in `decisions/` at the repository root — one shared
  home with the adr type, the filename prefix and the frontmatter
  `type` discriminating; which type records a decision is decided by
  the right exercised, per the rule the
  [adr typedef](adr.md) states.
- Whether the named role held the right it exercised is the PM role's
  ruling at the check, not the record's claim; a record whose decider
  is the authority is checked for form only.
- A superseding record links the one it supersedes.

## Commitment (Definition of Done)

A record is done when it has passed the PO output check against its
fitness set and the framing. **Consequence on failure:** it is returned with the
criterion named and binds nothing.

## Sources

Nygard's architecture decision record (decision, consequences); MADR
(considered alternatives); decider and reversibility as the shop's own
additions, from the roles' decision rights; the
[product-decision-record fitness set](../fitness/product-decision-record.fitness.md).

## Writing rules

**Voice principle.** Write the record for the role that, a year from
now, must decide whether to undo this decision: one decision, the
alternatives that were real, what it cost, who held the right, and
what would bring it back for review.

**Highlights (the layer compiled into generating context):** exactly
one decision, as a sentence someone can act on · at least one
alternative the deciding role could have chosen, with the reason
against it · consequences priced: what changes, for whom, at what cost
· the deciding role and its right, or the escalation · reversibility
and its trigger.

**Layers:** this guideline adds product-decision-record rules on top
of the [base writing style](../guidelines/base-writing-style.md); the base always
applies and is never overridden. When rules conflict, an approved
principle beats the
[product-decision-record typedef](product-decision-record.md),
which beats this guideline. Every rule feeds the
[product-decision-record fitness set](../fitness/product-decision-record.fitness.md),
scored in the [PO output check](../processes/po-output-check.md).

---

### Rules

**1. One decision, actionable.**
Before: "We will improve the run list and consider notifications
later, and also revisit the status model."
After: "Failed runs are shown in the run list; notifications are a
separate decision (linked)."
*Test:* count the decisions in the decision sentence. *Criterion:*
exactly one, and a reader can say what to do differently tomorrow
because of it. *Decision:* yes/no per record.
*Derived check:* judged — product-decision-record fitness scenario 1.

**2. A real alternative, with the reason against it.**
Before: "Alternatives: do nothing." (a real alternative, with no
reason against it)
After: "Alternative: notify on failure instead of listing — declined
because the outcome is 'visible at a glance', and a notification is
read once and lost."
*Test:* read each alternative. *Criterion:* at least one is a choice
the deciding role could have made and carries the reason it was not. *Decision:* yes/no per record.
*Derived check:* judged — product-decision-record fitness scenario 2.

**3. Name the decider and the right.**
Before: "It was agreed that…"
After: "Decided by the PM role under its value-and-viability decision
right; the
architect's feasibility verdict (linked) was 'feasible within the
current stack'."
*Test:* read the frontmatter `decided-by` and `right`, and §1 where
`right` is `escalation`. *Criterion:* the role and the decision right
are named, or the escalation that settled it is. *Decision:* yes/no per
record.
*Derived check:* judged — product-decision-record fitness scenario 3.

**4. Price each consequence.**
Before: "This will affect the run list and possibly performance."
After: "The run list gains a status column: the reporting context
changes its list contract (a version); operators see one more column;
cost — one contract version and its consumers' updates."
*Test:* for each consequence, find what changes, for whom, and what it
costs or forecloses. *Criterion:* all three present. *Decision:* yes/no
per consequence.
*Derived check:* judged — product-decision-record fitness scenario 4.

**5. Say how hard it is to undo, and what would bring it back.**
Before: nothing on reversibility.
After: "Reversible: the column can be removed in one contract version.
Review trigger: if failed runs exceed one in five, listing is not
enough and the alerting alternative is reopened."
*Test:* read the reversibility section. *Criterion:* it states the
difficulty and, for a hard-to-reverse decision, the trigger that
reopens it. *Decision:* yes/no per record.
*Derived check:* judged — product-decision-record fitness scenario 5.

## Fitness scenarios

A product decision record is the PO role's record of one product-level
decision and its reasons. These scenarios are the criteria set the
[PO output check](../processes/po-output-check.md) screens a record
against, alongside the framing (criterion `framing`). **Judged by:**
`cold-reviewer`, never executed; the judge's model and prompt version
are recorded with each round verdict. The judge reads only the
criteria set, the framing, and the artifact; every scenario therefore
asks for what the artifact itself carries, and a fact it must carry —
a term's definition, a reference, a reason — is what these scenarios
make it carry.

The record's parts: decision and consequences follow Nygard's
architecture decision record form; considered alternatives follow
MADR; decider (from the roles' decision rights) and reversibility are
the shop's own additions — adopted and extended per
`external-standards-first`; whether the named role held the right it
exercised is the PM role's ruling at the decide step, not the judge's.

### Scenarios

Scenario 1: one decision
  Given the record
  When its decision statement is parsed
  Then it states exactly one decision, as a sentence a reader can act
  on

Scenario 2: the alternatives were real
  Given the record's alternatives
  When each alternative is read
  Then at least one alternative is stated that the deciding role could
  have chosen, with the reason it was not

Scenario 3: the decider and the right are named
  Given the record's statement of who decided
  When it is read
  Then it names the role that decided and the decision right it
  exercised, or the escalation that settled it

Scenario 4: consequences are priced
  Given the record's consequences
  When each consequence is read
  Then it names what changes, for whom, and what it costs or forecloses

Scenario 5: reversibility is stated
  Given the record
  When a reader asks how hard the decision is to reverse
  Then the record says so and, for a decision it calls hard to reverse,
  names what would trigger revisiting it

### Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — one decision | "Quote the decision sentence. Is it one decision, actionable? Any no = fail." |
| 2 — real alternatives | "Is at least one alternative stated that the deciding role could have chosen, with the reason against it? Cite it or its absence." |
| 3 — decider and right named | "Does the record name the deciding role and the right exercised, or the escalation? Cite the sentence or its absence." |
| 4 — consequences priced | "For each consequence: what changes, for whom, at what cost? Cite any consequence missing one." |
| 5 — reversibility | "Does the record state how hard the decision is to reverse and, if hard, what would trigger revisiting it? Cite the sentence or its absence." |

## Derived review checklist

- One decision, actionable. *(§Required sections 1; fitness 1)*
- A real alternative with its reason. *(§Required sections 2; fitness 2)*
- Decider and right, or the escalation, named. *(§Required frontmatter; fitness 3)*
- Each consequence names what changes, for whom, at what cost. *(§Required sections 3; fitness 4)*
- Reversibility and its trigger stated. *(§Required sections 4; fitness 5)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction from the approved fitness set; the ADR and MADR forms adopted for decision, consequences, and alternatives, with decider and reversibility as the shop's own additions. |
| 1 | 2026-08-26 | review | Screened: findings — definition wrongly in the ancestry; a PM-agent producer path ungrounded; the framing missing from the commitment; the escalation branch under-carried; an unverifiable Fowler attribution; checklist cited another document. |
| 2 | 2026-08-26 | update | Repairs: ancestry corrected; PO role sole producer; framing added; escalation named when right is escalation; attribution dropped; superseded's setter named; checklist cites this typedef's clauses. |
| 2 | 2026-08-26 | review | Re-screened: clean; two stumbles. |
| 3 | 2026-08-26 | update | the escalation's home named; superseded's transition from checked stated. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean — every round-2 change and stumble addressed; checklist citations resolve after renumbering. |
| 4 | 2026-08-28 | update | From the initiative chain's screen: the authority admitted as decider with the `bet` right, so the go/no-go on an initiative can be recorded; such a record is checked for form only. |
| 5 | 2026-08-31 | review | Batch A+B screen round 1: the bet right covers the go, the hold, and the no-go, so a cancellation at the bet or a discovery decline records under it. |
| 5 | 2026-08-31 | state | draft → approved with batch A+B as one block (brief-032 ask 2, default accepted). |
| 6 | 2026-09-02 | update | Owner rulings at the adr chain's review (brief-033 asks 3 and 4): instances live in the shared `decisions/` home, and the exercised right decides which decision-record type records a decision — the rule's one home is the adr typedef, referenced here. |
| 7 | 2026-09-05 | update | Under init-typedef-rendering / feat-typedef-rendering (the proof type the initiative's Appetite names; the architect's constraints C1, C3, C5; adr-2026-09-05-typedef-rendering): the guideline's Voice principle, Highlights, Layers, and Rules (guideline v2) folded in as the Writing rules section and the fitness set's intro, Scenarios, and Compile mapping (fitness set v3) as the Fitness scenarios section, verbatim in substance — the fitness intro's sentences about a pending typedef dropped, since this typedef now carries the scenarios, and its judging role stated as a Judged by line; links re-based to this file's directory. From this version the guideline and the fitness set are renderings of this typedef, produced by basis/tools/compile_typedef.py; their own histories end at guideline v2 and fitness set v3 and stay readable in the repository history. Made by the lead-solutions-architect role. |
