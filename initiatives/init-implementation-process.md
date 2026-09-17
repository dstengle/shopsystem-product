---
type: initiative
id: init-implementation-process
name: Implementation process and roles
status: active
version: 4
owner: lead-pm
created: 2026-09-09
updated: '2026-09-17'
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

**Order flipped 2026-09-17**, on the authority's decision: session
two's content is authored first. Neither session's content changes
and the appetite does not grow — only the order. The reason: session
one's feature specifies what an implementation must be built to, but
building it is what session two's process defines, so whichever went
first went unprocessed. The authority chose to have the process exist
before the build rather than after it. Two consequences bind this
bet: the two features' scenarios are built in one pass, declared as
the bootstrap — the last build this shop makes outside a defined
implementation process; and the proof execution is the process run on
the initiative's next real feature, not on session one's artifacts.

No-gos, each with its reason:

- No process, step, or role text copied from `main` or
  shopsystem-templates into this bet's output, both read as reference
  only: nothing enters this branch except through an import step, and
  those prompts are part of why the rebaseline exists.
- No change to the text of the `delivery-verified` principle or its
  statements: that amendment is split to its own request and check.
  **Superseded 2026-09-16** — that split request ended in the
  principle's removal from the working set, not an amendment to it
  (init-delivery-verified-removal). Nothing this bet produces may
  reinstate its obligation; the open question it leaves — what form of
  evidence a check accepts, and who declares it — rides on
  feat-implementation-good's scenario `@hash:bbccc3a1765c` as a
  recorded decision for adr-authoring.
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

- feat-implementation-good
- feat-implementation-process

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the discovery conversation's frame step, framed across the discovery on request req-2026-09-09-lead-shop-builds (anchor lead-z2nit, session record sess-2026-09-09-c), and set `planned` on the authority's word "bet". Maker's evaluation against the initiative fitness set: 1 pass — the originator quoted from the request's section 1 and the authority's own reframing, with problem, outcome, and the operational contract named; 2 pass — one measure, current condition 0, target stated, interaction types "none" with the reason; 3 pass — two sessions, six no-gos each reasoned; 4 pass on the PM role's standing reading that a no-go must name what it excludes (the gap filed in this fitness set's history, 2026-09-04), no other solution word in sections 1–3; 5 and 6 not applicable — Feasibility and usability and Decomposition are filled at feature authoring, not before the bet (typedef v13); 7 pass — 459 words outside this history, the bet statable from sections 1–3; 8 not applicable — no sub-initiative names this one. |
| 2 | 2026-09-15 | update | Feature feat-implementation-good's self-check passed (gaps recorded: Contributors reasoning, word-target overages); initiative active. |
| 3 | 2026-09-16 | update | The second no-go marked superseded by the lead-pm role: the split request it named (req-2026-09-09-delivery-verified-amendment) ended in the principle's removal from the working set, approved this day, rather than the amendment the no-go anticipated. The no-go's original text is kept as the bet recorded it; the supersession is stated beneath it so no later reader builds to a boundary drawn around a principle that no longer stands. The bet, its appetite, and its other five no-gos are unchanged. |
| 4 | 2026-09-17 | update | Session order flipped by the authority's decision of this day, recorded in Appetite: session two's feature is authored first, session one's `feat-implementation-good` stands checked and unchanged, and both features' scenarios are built in one declared bootstrap pass. Neither session's content and no no-go changed; the appetite does not grow. The reason is the bootstrap `sess-2026-09-16-a` left open — session one specifies what an implementation is built to, session two defines how it is built, and whichever ran first ran outside a defined process. The proof execution moves to the initiative's next real feature. |
