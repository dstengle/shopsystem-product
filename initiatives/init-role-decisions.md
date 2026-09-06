---
type: initiative
id: init-role-decisions
name: Roles own their decisions
status: proposed
version: 7
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
request: ../requests/req-2026-09-05-feasibility-defined.md
---

# Initiative: Roles own their decisions

## Framing

Originator (product authority, 2026-09-05, through the lead shop's
operational contract, which has no artifact yet (lead-4kymc); the
request req-2026-09-05-feasibility-defined; in its review of
evidence, the framer's wording standing for the request's section 1):
"Roles should
always be ready to offer complete information on the decisions or
parts of decisions that are in their domain. This should be an aspect
of the role and not just instructions from the lead-pm."

Problem: a role attaching to an initiative has no defined shape for
what it must offer, so the lead-pm supplies it by hand each time, and
the decisions a bet rests on reach the record only if someone asks.
Outcome: a role attaching to an initiative offers complete information
on the decisions it owns without being asked — its verdict, the
decisions the bet depends on, the risks to the measure, what it does
not know, the evidence it used — and no bet rests on an unrecorded
decision.

## For whom

The authority at the bet, the lead-pm, and the four roles. Measure:
roles whose definition names the decisions they own and that, given
only their step's instruction with nothing added by the lead-pm, come
back with complete information on them. Now: 0 of 4 — no definition
names them yet; the two offers this check produced are the baseline.
Target: 4 of 4, each observed at its own step. Interaction types: none — the
attachment is read inside a process step; no core task carries it.

## Appetite

One working session of the lead shop. No-gos, each with its reason:

- The step-communication request — how an agent's instruction is
  assembled — stays its own request; this initiative changes what a
  role offers, not how the instruction is built.
- The bet itself — who takes it and on what — is unchanged, because
  this changes what a role offers before the bet, and the bet's owner
  and subject are the initiative typedef's, the authority's own.

## Feasibility and usability

Feasible in one session (the request-routing precedent). Work: one
typedef section, four role sections, one data type, the attach prompts
cut to one sentence with a route to adr-authoring; renders re-run.
Unrecorded decisions the bet depends on: the offer's shape and home
(an ADR before the bet); the 500-word cap's split — 137 words remained
for both attachments. Risk: two roles attach here, not four. Evidence:
four features, no conflict; no contract. Full offer: history v2.
(architect, 2026-09-05)

Usability: none due; attachment read at a step, no core task carries
it (concur). Offer: history v4. (designer, 2026-09-05)

## Decomposition

None: no Bounded Context is touched — every amended definition sits in
the lead shop's tree; no contract exists on this branch. Cross-context
flow: none.

## Features

None yet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence — "converge" (work item lead-ampnd; session sess-2026-09-05-d; review-of-evidence form). Positions reached: the obligation is written in each role, with a section in the role-definition typedef on what domain decisions the role owns; the offer takes a fixed shape (a data type) so the initiative check can route each decision the bet depends on to adr-authoring before the bet — closing lead-8hcu8 by definition; the evidence reviewed was the lead-pm's three ad-hoc instructions to the architect across the last runs, recorded in the session. |
| 2 | 2026-09-05 | update | Feasibility and decomposition attached by the architect at the initiative-check's attach step, on the one-sentence instruction the measure names. The full offer, which the 500-word rule keeps out of §4 (§1–3 stood at 363 words; 137 remained for both attachments): *Verdict* — feasible within one session. *Work* — the role-definition typedef (v3: two required sections, a hand-written fitness set, the four roles already carrying sections it does not name) gains a required section naming the domain decisions the role owns and offers on when it attaches, its fitness set hand-amended under the artifact-typedef typedef v3's rule for a type whose texts are not produced; the four role definitions gain the section and are re-rendered by role-rendering (feat-roles-availability's reconcile scenario); one data type in basis/types, beside check-decision, ask, and screen-review, carries the offer — verdict, the decisions the bet depends on each with its record or "none", the risks to the measure, the unknowns each with a default, the evidence read — so a screen judges it and a step routes on it; initiative-check's attach prompts cut to one sentence, the attach outputs typed, and a route to adr-authoring for each decision with no record before the screen — closing lead-8hcu8 by definition — under the single-review-cycle rule, the skill re-rendered (feat-skills-availability). *Decisions the bet depends on, none recorded* — D1: the offer's shape and home — a data type rendered into §4, or a typedef section alone; hard to reverse once four roles, a fitness set, and a process reference it: an architecture decision record before the bet, the subject ready for adr-authoring. D2: the 500-word rule's split between §1–3 and the attachments, or the full offer's home outside the cap (the data type; the history row); the initiative typedef is the authority's — recommended, not decided here; without it the measure's "full information" and fitness scenario 7 conflict on every initiative, as here. D3: the pre-bet route to adr-authoring — a process amendment under its owner, reversible; bounded, not decided. *Risks to the measure* — R1: the check calls two attaching roles; the PM and PO roles have no attach step in it, so 4 of 4 is not observable on one initiative check as the process stands — §2's to settle, reported not rewritten. R2: D2 — this attachment is compressed to fit and the offer recorded here instead. R3: the two re-renders must run in the session; the precedent fits. *Unknowns* — U1: brief-030's pending amendment to the same typedef (the primer names it; no record on this branch states its content) — default: this amendment lands first with its history row. U2: whether the designer's offer takes the same shape — the designer's domain; default: one role-neutral shape, a field the role does not own marked none due (actor-neutral-discipline). *Evidence* — the initiative; features/ read in full (four features, all assigned and delivered in the lead shop's tree; no scenario names a role's decisions, a verdict, or an attach step; touch-points: the two availability features' reconcile scenarios carry the re-renders and feat-typedef-rendering's C5 binds the typedef-first order; no conflict); contracts: none exist; the role-definition, initiative, artifact-typedef, and data-type typedefs; initiative-check v7 and adr-authoring v2; the initiative fitness set v4; check-decision and ask; the architecture principle set v6; sess-2026-09-05-d; req-2026-09-05-feasibility-defined; work items lead-8hcu8 and lead-4kymc. *Principle screen* — actor-neutral-discipline: the obligation attaches to the role, whoever fills it — conforms; local-comprehension: the offer names its evidence from the level's designated artifacts — conforms; knowable-shape: the section is the role's description of what it offers — conforms; bidirectional-conformance: typedef, then instances, then renders, each recorded — conforms; contracts-between-contexts: no context touched; intent-provenance: the operational-contract exception (lead-4kymc) stands as adr-2026-09-04-request-front-end records it, not absorbed; no new exception to escalate. *Maker's self-check* against the initiative fitness set — scenario 5: verdict with reasons present; scenario 6: contexts, relationship kinds, and flow-or-none present; scenario 7: 466 words after the attachment, within 500, §1–3 untouched, 34 words left for the designer's attachment. |
| 3 | 2026-09-05 | update | The architect's attachment, made from the step's own prompt and the one sentence "add your feasibility or ask questions" with nothing added by the lead-pm — the measure's first data point: the full offer came unprompted (verdict, three decisions the bet depends on, three risks, two unknowns, evidence). Its R1 taken: the measure now says where each role's offer is shown. Its D1 — the offer's shape and home — routed to adr-authoring before the bet. Its D2 — the word cap's split between the framing and the attachments — put to the authority at the bet. |
| 4 | 2026-09-05 | update | Usability attached by the designer at the initiative-check's attach step, on the step's prompt and the one sentence, nothing added by the lead-pm — the measure's second data point. The full offer, kept out of §4 by the 500-word rule (19 words fitted): *Verdict* — no usability attachment due; the For whom section's "none" concurs with the corpus on examination, not by default: the attachment is made by a role and read by the check and the step's route inside a run, so no one reaches it through an interaction type; against the core-task list v4, none of the seven tasks carries a role's attachment — the nearest, "read a decision", reads the check-decision the attachment feeds, not the attachment; against `agent-is-a-user`, the offer's data type falls outside the principle's closed set (tool definition, command line, API, SDK), so no interface screen is owed under it. This is expert review against the corpus, admissible for the question "is there an interaction"; the observed use the measure counts is this attachment itself. *Decisions the bet depends on, in the designer's domain* — D4 (answers the architect's U2): the designer's offer takes the same role-neutral shape as the architect's — verdict, the decisions the bet depends on, the risks to the measure, the unknowns, the evidence — with any field the role owns nothing in marked "none due" with its reason; decided here under `actor-neutral-discipline`, carried in the architect's D1 record, no separate record needed. D5: no eighth core task — "attach to an initiative" is a role's step inside a run, not a task a person or agent reaches the product for; the list and its hypothesis labels stand. *Risks to the measure* — R4: the "full information" the measure asks for is read by the authority at the bet in a Document History cell (v2 and this row, each several hundred words inside a table), a reading form no one was observed using; this bears on the architect's D2 and the authority's answer to it: wherever the offer's home lands, the authority must be able to read it at the bet without opening the history table — put to the authority alongside D2, default: the offer's home is a section or an attached record §4 links, not a history row. R5: two roles attach here; the PM and PO data points come from their own steps (the architect's R1, taken at v3). *Unknowns* — U3: whether the check or a person is the offer's first reader, which decides whether R4's reading form matters; default: both, the authority at the bet. U4: the field names of the offer's data type — an agent fills it and an agent reads it, so they should be named for the caller in `agent-is-a-user`'s spirit though the type is outside its closed set; default: the five names above, and the designer screens the draft type when adr-authoring produces it — a recommendation to the architect, not a decision. *Evidence* — the initiative v3 with the architect's offer at v2; experience principles v2 (all seven read; `core-task-parity`, `agent-is-a-user`, `evidence-not-opinion` bear); core-task list v4 (seven entries, all hypotheses); initiative fitness set v4. No observed use exists for a role attachment; none is claimed. *Maker's self-check* against the initiative fitness set — scenario 5: the section states no attachment is due with the For whom section's reason, the reading the step gives "none"; scenario 7: 499 words outside the Document History after this attachment, counted on the body below the front matter with headings, list markers, and dashes each counted as a word (487 without markers and dashes), §1–3 untouched; the 19-word attachment is the room that remained, so nothing further fits §4 without the authority's answer to D2. |
| 5 | 2026-09-05 | review | Initiative-check's one screen (judge: claude-fable-5-1 / screen prompt v5): one confident — the second no-go without its reason — and five wobbly: the measure's "0 of 4" against the two data points; the outcome naming the solution's home and shape; "ADRs" in the originator's quote; the measure's given quoting an instruction; the architect's reason resting on a precedent the initiative does not carry. Repaired in the one revise, the lead-pm's sections: the no-go reasoned; the outcome stated as the condition alone; the measure counts definitions and observes each role at its own step, the two offers named as the baseline; the first quote moved here — the original words of the request's section 1: "Feasibility needs to be defined. Right now there isn't a way for the architect to express either ADRs or the need for them. This will become an issue for the designer as well." Held for the authority at the bet: the architect's precedent as a reason, and the cap's split (D2). |
| 6 | 2026-09-05 | update | The architect's D1 recorded before the bet: [adr-2026-09-05-role-offer](../decisions/adr-2026-09-05-role-offer.md) (checked, v3; one screen, one revise) — a role's offer is one data type the attach step outputs; the role-definition typedef's section names what a role owns and does not define the shape; three candidates split out (the cap's split, the designer's fit, the pre-bet route). |
| 7 | 2026-09-06 | update | Positions reached in the authority's review before the bet, in its words: the attachment at the bet is the verdict with its reasons, the architecture decisions required ("What architecture decisions are required, so as to avoid getting into implementation details"), the risks, the unknowns, the evidence — the architect's work list is not part of it; implementation guidance is "the architect providing guidance to the implementer within the initiative", "related to whatever technical changes the implementer will need to do to the product", created "with the scenarios in mind", "per bounded context", "important as an artifact but … only part of a historical record". The artifact is being made now through the lane (req-2026-09-06-implementation-guidance) and is not this initiative's feature; journaling messages offline is backlog item lead-j30gv. The bet stands open. |
