---
type: initiative
id: init-role-decisions
name: Roles own their decisions
status: proposed
version: 1
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
4 of 4, shown on one initiative check. Interaction types: none — the
attachment is read inside a process step; no core task carries it.

## Appetite

One working session of the lead shop. No-gos, each with its reason:

- The step-communication request — how an agent's instruction is
  assembled — stays its own request; this initiative changes what a
  role offers, not how the instruction is built.
- The bet itself — who takes it and on what — is unchanged.

## Feasibility and usability

Not yet.

## Decomposition

Not yet.

## Features

None yet.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence — "converge" (work item lead-ampnd; session sess-2026-09-05-d; review-of-evidence form). Positions reached: the obligation is written in each role, with a section in the role-definition typedef on what domain decisions the role owns; the offer takes a fixed shape (a data type) so the initiative check can route each decision the bet depends on to adr-authoring before the bet — closing lead-8hcu8 by definition; the evidence reviewed was the lead-pm's three ad-hoc instructions to the architect across the last runs, recorded in the session. |
