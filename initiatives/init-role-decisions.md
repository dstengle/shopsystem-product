---
type: initiative
id: init-role-decisions
name: Roles own their decisions
status: proposed
version: 3
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
request: ../requests/req-2026-09-05-feasibility-defined.md
---

# Initiative: Roles own their decisions

## Framing

Originator (product authority, 2026-09-05, through the lead shop's
operational contract, which has no artifact yet (lead-4kymc); the
request req-2026-09-05-feasibility-defined, its section 1): "Feasibility
needs to be defined. Right now there isn't a way for the architect to
express either ADRs or the need for them. This will become an issue for
the designer as well." And in the review of evidence: "Roles should
always be ready to offer complete information on the decisions or
parts of decisions that are in their domain. This should be an aspect
of the role and not just instructions from the lead-pm."

Problem: a role attaching to an initiative has no defined shape for
what it must offer, so the lead-pm supplies it by hand each time, and
the decisions a bet rests on reach the record only if someone asks.
Outcome: each role definition names the domain decisions it owns, and
the role offers complete information on them, without being asked,
when it attaches — its verdict, the decisions the bet depends on, the
risks to the measure, what it does not know, the evidence it used — in
a fixed shape a check can judge and a step can route; the step's
instruction is one sentence, and a bet no longer rests on an
unrecorded decision.

## For whom

The authority at the bet, the lead-pm, and the four roles. Measure:
roles that, given only "here is the initiative, add your feasibility
or ask questions", come back with the full information on the
decisions they own, nothing added by the lead-pm. Now: 0 of 4. Target:
4 of 4 — the two that attach in the initiative check shown there, the
PO and lead-pm at their own steps. Interaction types: none — the
attachment is read inside a process step; no core task carries it.

## Appetite

One working session of the lead shop. No-gos, each with its reason:

- The step-communication request — how an agent's instruction is
  assembled — stays its own request; this initiative changes what a
  role offers, not how the instruction is built.
- The bet itself — who takes it and on what — is unchanged.

## Feasibility and usability

Feasible in one session (the request-routing precedent). Work: one
typedef section, four role sections, one data type, the attach prompts
cut to one sentence with a route to adr-authoring; renders re-run.
Unrecorded decisions the bet depends on: the offer's shape and home
(an ADR before the bet); the 500-word cap's split — 137 words remained
for both attachments. Risk: two roles attach here, not four. Evidence:
four features, no conflict; no contract. Full offer: history v2.
(architect, 2026-09-05)

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
