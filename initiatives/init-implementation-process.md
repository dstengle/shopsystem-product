---
type: initiative
id: init-implementation-process
name: Implementation process and roles
status: planned
version: 1
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
request: ../requests/req-2026-09-09-lead-shop-builds.md
---

# Initiative: Implementation process and roles

## Framing

Originator (product authority, 2026-09-09, through the lead shop's
operational contract (lead-4kymc, no artifact yet);
req-2026-09-09-lead-shop-builds, section 1): "The discussion of doing
builds in the lead shop needs some brainstorming work. Please set up a
new request for this."

The authority reframed it in the discovery conversation (lead-z2nit,
sess-2026-09-09-c): "This the build process and roles, not
specifically the lead shop. We're handling builds in the lead shop by
defining the missing implementation process and allowing the lead shop
to do implementation."

Problem: the system defines no implementation process and no
implementation roles, so the build activity belongs to no process and
no stated definition of good governs it. The lead shop's own undefined
builds exposed it; gap lead-ki66p is the standing record.

Outcome: one implementation process, with a stated definition of good
implementation engineering and the roles that carry it; every shop
that implements executes it on what it owns, and each execution's cost
lands on an initiative.

## For whom

Every shop that implements, Bounded Context and lead alike, and the
authority reading cost per initiative. Measure: scenarios built
through a defined implementation process. Now 0 — every build so far
was made outside any process. Target: every scenario of the next
assigned feature, its cost recorded on that feature's initiative. The
proof is lead-side, because the shop is frozen.

Interaction types: none — the outcome adds no core task, and the ones
it touches hold already.

## Appetite

Two working sessions: one for the definition of good for
implementation engineering and the two implementation roles; one for
the implementation process, the lead shop's permission to execute it,
and one proof execution. Phase 2, above the unstarted
typedef-rendering batch.

No-gos, each with its reason:

- No process, step, or role text copied from `main` or
  shopsystem-templates into this bet's output, both read as reference
  only: nothing enters this branch except through an import step, and
  those prompts are part of why the rebaseline exists.
- No change to the text of the `delivery-verified` principle or its
  statements: that amendment is split to its own request and check.
- No packaging, install, or rendering mechanism for delivering
  definitions to dependent shops: the authority named that work
  separate, and this process reads the corpus in place.
- No context record created and no Bounded Context designation
  changed: that belongs to the operational-contract discovery
  (lead-bmmzh).
- No change to a scenario assigned to a Bounded Context: its dispatch
  and reconcile-and-close path stand, because only the lead-held
  assignment's route into the new process is inside the bet.
- No dispatch to a Bounded Context shop and no mailbox work; the only
  execution is the lead shop's own: the shop is frozen until
  cut-over.

## Features

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the discovery conversation's frame step, framed across the discovery on request req-2026-09-09-lead-shop-builds (anchor lead-z2nit, session record sess-2026-09-09-c), and set `planned` on the authority's word "bet". Maker's evaluation against the initiative fitness set: 1 pass — the originator quoted from the request's section 1 and the authority's own reframing, with problem, outcome, and the operational contract named; 2 pass — one measure, current condition 0, target stated, interaction types "none" with the reason; 3 pass — two sessions, six no-gos each reasoned; 4 pass on the PM role's standing reading that a no-go must name what it excludes (the gap filed in this fitness set's history, 2026-09-04), no other solution word in sections 1–3; 5 and 6 not applicable — Feasibility and usability and Decomposition are filled at feature authoring, not before the bet (typedef v13); 7 pass — 459 words outside this history, the bet statable from sections 1–3; 8 not applicable — no sub-initiative names this one. |
