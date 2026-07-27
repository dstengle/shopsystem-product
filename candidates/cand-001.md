---
type: candidate
id: cand-001
title: PM mode + artifact type system + coherence gate
status: shaped
created: 2026-07-09
updated: 2026-07-09
authors: ["Claude (acting lead-pm)", dstengle]
description: Shaped candidate for a PM main-session mode, an 8-type artifact system, and a coherence gate.
derives-from: [intent-001]
session: sess-2026-07-09-a
experiments: []
brief:
parked-until:
beads: []
---

# cand-001 — PM mode + artifact type system + coherence gate

## Verbatim anchors

Recovered from the derives-from intent (intent-001); this candidate
predates the Verbatim-anchors section requirement, so the originating
stakeholder verbatims that shaped it are cited here by date:

2026-07-09: "it feels like I'm missing a product manager. There is a
product owner that keeps after the PDRs, but there isn't really a role
or activity that is brainstorming with a product direction outcome as
opposed to a specific incremental feature implementation."

2026-07-09: "There is also a lot of things that seem to fall back on
the router since it is the only interactive role, but it is often
acting like far more than a simple router."

2026-07-09 (scope): "I'm currently trying to create a system for
people who have an idea of what they want to build and want to use
spec-driven methods to accomplish that. I'm not currently trying to
create a full system for taking a product to market."

## Problem

The system has no interactive product-direction capability: the PO's
PDR-012 elevation put dialogic responsibilities on a batch substrate,
and the overflow accretes at the router (e.g. the discovery-dialogue
gate). Separately, no living current-state view exists, so product
truth requires replaying the decision log. Both gaps degrade the
stakeholder experience intent-001 names.

## Appetite

**TBD — product authority to set before dispatch.** Suggested framing:
one dispatch round for gate + schema adoption; one for role/skill
adoption; migration of the legacy corpus explicitly NOT in this
appetite (own candidate).

## Solution sketch

A PM persona as a main-session mode (not a subagent), entered by
router classification, exited only by closing a session record that
links produced artifacts. Six artifact types with YAML frontmatter,
enum lifecycles, and typed links (intent record, candidate, session
record, prioritization record, plus migrated brief/PDR/ADR and the
current-state living doc). A coherence gate validating schema, link
resolution, bidirectional supersession, lifecycle conditions, and
incorporates-claims. Knowledge BC owns artifact shapes and the gate;
templates BC owns the PM role and skills; pour distributes both.

## Rabbit holes

- Pour generalization: if pouring is hardwired to role templates,
  extending it to knowledge-BC assets may exceed appetite — fence it
  as a follow-on if so.
- Legacy corpus migration (prose statuses → enum + changelog across
  ~90 docs): explicitly out of this candidate.
- Renumbering provisional ids and cross-links on ingestion.

## No-gos

GTM disciplines (market research, personas, positioning, pricing,
growth metrics) — parked per intent-001, not deleted from PDR-012's
research. The PM never writes scenarios. The router gains no product
judgment.

## Evidence / experiments

**2026-07-09 — typedef generation PoC** (`payload/typedef-poc/`):
assumption tested — template/schema drift can be eliminated by
construction rather than review. A per-type `typedef/*.yaml` declares
fields, link semantics, and body sections; a ~120-line generator
emits both the template and the schema fragment; `--check` mode
fails CI on any hand-edit of generated files. Result: PDR type
round-trips with full fidelity (frontmatter comments, section
guidance, conditional link rules); drift detection verified by
deliberate hand-edit. Bonus capability surfaced: `x-required-sections`
gives the gate a body-structure check previously unenforced.
Motivating incident: template/schema drift occurred in this very
package within a single authoring pass (pdr templates showed
`derives-from`; schema didn't require it).

Assumptions still warranting a spike before dispatch:
1. Gate prototype over the existing corpus with legacy exemptions —
   does it produce signal or noise? (findings/ spike)
2. Pour mechanism can distribute non-role assets without structural
   change.

## Resolution

(open — awaiting PDR ratification and appetite)

## Changelog

- 2026-07-09 opened and shaped in sess-2026-07-09-a.
