---
type: intent-record
id: intent-004
title: Tier/provenance-aware retrieval and citation-validation discipline for roles and subagents
status: recorded
created: 2026-07-14
updated: 2026-07-14
authors: [dstengle, "Claude (acting lead-pm)"]
description: Stakeholder intent for making role/subagent evidence-gathering provenance-aware (canonical vs. historical/spike material) and mechanically validating citations, instead of relying on written-only rules and the router's private memory.
stakeholder: dstengle
session: sess-2026-07-14-b
superseded-by:
beads: []
---

# intent-004 — Tier/provenance-aware retrieval and citation-validation discipline

## Verbatim anchors

2026-07-14: "The progressive disclosure and knowledge system don't seem
to be helping prevent grep pulling in everything. Do we have roles use
skills that use tools with limited access patterns based on document
types and linkage?"

2026-07-14: "The architect work does not seem to include citations, or
if it does, the use of findings/* was not noticed"

2026-07-14: "I'm concerned that the memory system is playing a role
here that it shouldn't. If there are behavioral changes, then prompts
should be adjusted. Memory should be for things that are only relevant
for a period of time."

2026-07-14: "Additionally, there needs to be prompt adjustment to
challenge citation sources and validate that they are acceptable, or
there could even be mechanical checks."

## The goal behind the ask

Subagents (lead-po, lead-architect) currently have unscoped `Grep`/
`Read`/`Bash` access across the whole repo corpus, with no awareness of
document provenance tier — a canonical ADR carries the same retrieval
weight as a pre-superseded `findings/*spike*` file. This produced a
concrete failure in this session's own work: an architect feasibility
probe cited `findings/fabro-spike/*` material (predating ADR-058) as a
"proven precedent" for a mechanism ADR-058 had since replaced. The
router then relayed that finding into a shaped candidate without
flagging its provenance tier, and it was caught only because the
stakeholder independently knew the runtime mechanism had changed. This
repo already has a *written* rule against treating spike material as
authoritative (the spike-precedence rule); the written rule did not
prevent the failure, because nothing mechanically enforces it.

A second, related gap: the router's own correction for this (verifying
subagent citations before trusting them) was recorded as a personal,
cross-session memory entry — which only helps if the router happens to
read it and manually re-inject the discipline into a given dispatch
prompt. It does not touch the actual `lead-architect`/`lead-po`
subagent prompts, which are owned by shopsystem-templates and poured
into this repo, not hand-edited here. The stakeholder's framing: a
durable behavioral correction belongs in the prompt/mechanism layer
that actually governs the role's behavior every time, not in memory
that's supposed to be for what's "only relevant for a period of time."

## Who it serves

The product authority and the router/PM, whose ability to trust
architect/PO findings — and to build shaped candidates on top of them —
depends on citations being reliable and their provenance visible.
Downstream, every future subagent dispatch that would otherwise be able
to repeat this exact failure mode.

## Constraints

- Subagent role prompts are shopsystem-templates-owned and poured, not
  hand-editable in this repo (this shop's own doctrine). Any
  prompt-level fix must route through that BC as a dispatch, not a
  local edit to `.claude/agents/*.md`.
- Whatever mechanism results should not re-litigate or duplicate the
  existing progressive-disclosure epic (`lead-x7bp`) — it should
  reconcile with it, since both are aimed at the same underlying
  problem (context/evidence quality) from different angles.

## Non-goals

- Rebuilding progressive disclosure from scratch. This intent is
  narrower: retrieval scoping and citation-provenance validation
  specifically, not the full tiered-document epic.
- Solving this purely by adding another written rule to a prompt or to
  memory. The stakeholder explicitly wants prompt-level and/or
  mechanical enforcement considered, not just another instruction that
  can be missed the same way the spike-precedence rule was.

## Appetite signal

Not stated. Appetite for implementation to be set at candidate shaping.

## Failure conditions

- A fix that only lives in the router's private memory (as happened
  this session) rather than in the actual role definitions or a
  mechanical gate.
- A written rule added to a role prompt that suffers the same fate as
  the existing spike-precedence rule: correct, but silently skippable
  under load.

## Update (2026-07-14, same day, concrete manifestation found)

A live instance of exactly this problem surfaced while dispatching an
unrelated small fix (`lead-ptr7a`): the `discovery-dialogue`/`shaping`
lead-skills (shop-templates-owned) require producing a schema-governed
artifact (an intent record / a shaped candidate) but contain NO
reference to the canonical schema at all — no bundled template, no
fetch instruction, nothing (confirmed by grepping the full installed
skill package for any pointer language). Separately, shopsystem-
knowledge confirmed it already has the schema-validation CODE
internally (that's what generates its precise clarify responses) but
exposes NO CLI for anything outside itself to call it — so even a
skill that wanted to validate its own output against the real schema
would have no way to. Stakeholder direction: close this gap directly —
each artifact-producing skill should reference the canonical template
and run a shopsystem-knowledge validation tool (once exposed) after
producing an artifact. Dispatched as committed work (skipping further
discovery, per the same PM-mode-entry test that routed `#1` directly to
lead-po) rather than folded further into this intent's own shaping —
see `lead-ptr7a`/beads for the actual dispatch trail once filed.

## Open threads

- Solution shape is genuinely open: a new scoped-retrieval tool
  (limiting what a role can pull in by document type/tier), tighter
  per-role tool grants, a citation-validation gate wired into evidence
  gathering (not just post-hoc document validation, per the existing
  `typedef_drift_check` gate pattern from ADR-059), or some combination
  — not decided here.
- Domain ownership of any resulting mechanism is unconfirmed. Knowledge
  BC owns artifact shapes/integrity per prior PM decisions
  (`sess-2026-07-09-a`) — plausibly also the right owner for a
  retrieval/citation-gate mechanism, but not confirmed.
- Relationship to `lead-x7bp` (progressive disclosure epic), `lead-9lyi`
  (consistency-check experiments — explicitly named in that bead's own
  title as "the check that would have stopped fabro's
  mis-implementation," which is exactly this failure class), and
  `lead-iohr` (coherence gate as installable CLI) needs reconciling at
  shaping time so this doesn't become parallel, un-superseded work.
