---
type: intent-record
id: intent-012
title: The shop must ground itself in the system's true current state reliably AND inspectably, so the product authority can trust it to run without being the safety net
status: recorded
created: 2026-07-27
updated: 2026-07-27
authors: [dstengle, "Claude (lead-pm)"]
description: "The product authority is a mandatory participant in operating the shop — not by choice but because the agents cannot reliably or affordably build, nor visibly show, an accurate picture of what the system has decided. So work comes out wrong or inconsistent and he must catch it, and agents cannot even reach the relevant decisions without him feeding context cues. The optimization target is VERIFIABLE grounding: trust earned by inspecting that a decision stood on the true current state, not by a clean error record."
stakeholder: dstengle
session: sess-2026-07-27-a
superseded-by:
beads: [lead-fb3vk]
---

# intent-012 — verifiable grounding so the shop runs without the safety net

## Verbatim anchors

- 2026-07-25 (dstengle): "the document and role system is not up and running
  fully, leading to issues with how the work is being performed"; "Everything is
  getting difficult and error-prone which is why this is the highest priority."
- 2026-07-27 (dstengle): "my having to catch them is the biggest issue and is
  related to or underlies the other two… If the system can't build an accurate
  picture… things come out wrong and I have to catch it… it is difficult to even
  get to the decisions without me providing additional context cues… I am not
  able to trust the system to run more autonomously. Solving [the] trust/autonomy
  problem will either solve the other two or make them easier to solve."
- 2026-07-27 (dstengle): "We're optimizing for verifiable grounding and if
  corrections are still necessary then we can figure out the root cause of that
  issue, which may be related to grounding or something else like quality of
  previous artifacts."

## The goal behind the ask

The product authority can **delegate operation of the shop and step away** —
because the agents ground themselves in the system's true current decided state
**reliably** and, crucially, **inspectably**. Trust is earned by *seeing* that a
decision was built on the current truth, not by the absence of mistakes. Today he
is the mandatory safety net: he must remain present to catch wrong or inconsistent
work and to supply the context cues agents need to even locate the relevant
decisions. The named solution ("knowledge tools as the basis, eliminate grep,
progressive disclosure, more skills") is a *means*; the end is **legible,
verifiable grounding** that lets him trust by inspection.

## Who it serves

- **The product authority (primary):** freed from being the required error-detector
  and context-provider, able to trust the shop to run more autonomously.
- **The operating agents:** able to self-orient in the system's decided state
  instead of depending on the authority's cues.
- **The shop's autonomy** as a whole — the capability to run correctly unsupervised.

## Constraints

- **The target is verifiable/inspectable grounding, not zero-defect output.** The
  grounding an agent stood on must be visible and auditable from the outside.
- Better retrieval an agent *may* use proves nothing — grounding must be *routed
  through* the tools by the doctrine and *shown* in what the agent produces
  (evidenced empirically: the read-tools already exist but nothing routes through
  them — `drafts/knowledge-tools-and-skills-analysis.md`).
- Build on the just-delivered artifact system (coherence gate, materialized
  provenance edges, two-views, the `shop-knowledge` CLI, the write-<kind> skills)
  as the substrate.

## Non-goals

- Eliminating all corrections. A residual correction is a **diagnosable signal**
  (grounding gap vs. downstream cause such as artifact quality), not a failure of
  this intent.
- The artifact **writing-style / reviewability** problem — the authority explicitly
  scoped it out as a separate problem (`lead-nvs7i`); it may be a distinct root of
  residual corrections but is not this intent.
- Artifact **quality** as its own axis — noted as a possible separate root, not
  solved here.

## Appetite signal

Large — a system-level capability spanning tools, skills, and doctrine, likely a
multi-slice initiative on the scale of the artifact-system restructuring.

## Failure conditions

- Better tools ship but the **doctrine still routes grounding around them**
  (grep/raw-read) — the current failing state.
- Grounding improves but is **not made visible** — the authority still cannot
  trust by inspection, so he stays the safety net.
- An agent grounds on **stale/superseded** decisions (a grounding failure he would
  have to catch) — the current lump-all-statuses default enables this.
- An agent **proceeds confidently on a partial/wrong basis without verifying** and
  without knowing its coverage is thin (the discipline/self-awareness gap, evidenced
  this session by a freehand-ADR attempt and an over-confident fleet-rebuild claim).

## Open threads

- **Mechanisms decomposition** — retrieval/cost tools (search, current-default,
  L1, section-pull, map) vs. discipline/verification skills vs. the doctrine
  rewire — surveyed in `drafts/knowledge-tools-and-skills-analysis.md`; the split
  and ordering are shaping questions.
- **The FORM of "verifiable grounding"** — does an agent *cite its grounding* in
  what it produces (which decisions it stood on, that they were current)? That
  concrete form is a shaping question, not decided here.
- **Corpus scope** — `shop-knowledge` indexes the artifact corpus; `features/`
  (scenarios) and mailbox/bd state are separate surfaces. Whether to unify or
  orchestrate is an open product decision.
- **Residual-correction diagnosis** — the writing-style (`lead-nvs7i`) and
  artifact-quality axes as candidate roots to separate from grounding once this
  lands.
