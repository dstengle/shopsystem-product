# PDR-033 — PM as main-session mode; PO retains convergent contract work

**Status:** accepted (ratified by dstengle, 2026-07-09) — landed as PDR-033
from handoff-package `pdr-P02` (external PM-mode session `sess-2026-07-09-a`).
**Authors:** Claude (acting lead-pm), dstengle
**Decision-makers:** dstengle
**Amends:** [PDR-012](012-lead-po-product-manager-scope-and-architect-structurizr-maintenance.md)
— **partial amendment (clauses a/b/c of the Decision §amendment below); NOT a
full supersession.** PDR-012's lead-architect structurizr commitments and its
anti-build-trap / spec-as-contract disciplines are untouched.
**Derives-from:** `cand-P01`, `intent-P01` (from handoff-package
`sess-2026-07-09-a`; not yet landed in this repo — they ride with the
still-unratified `pdr-P01` / PDR-032).
**Lead bead:** [`lead-gqzf`](#) (P1; parent epic `lead-ac1f`). Phase-3
application of role material (`role-deltas.md`, lead-pm template, PM skills) is
tracked separately on [`lead-kz33`](#) and is **not** performed by this
landing.

## The question

How does the system provide interactive product-direction capability
— discovery, shaping, option facilitation, prioritization — given that
subagent roles are batch-mode and the router must stay thin?

## Context

PDR-012 elevated the lead-po charter to empowered-PM scope but not its
substrate: subagents cannot hold a turn open with a human. The
evidence of the mismatch is PDR-012's own v2 addendum installing the
discovery-dialogue gate at the router — interactive responsibilities
roll downhill to the only seat with the human in it. Interactivity is
a position in the execution topology, not a role attribute; only the
main session has it. Meanwhile the stakeholder has narrowed system
scope: spec-driven realization of a known idea, with product
communication (README, static site) in scope and GTM disciplines out
(intent-P01).

## Options considered

### Option A — complete PDR-012: make the PO interactive

**Pros:** one product role; honors PDR-012's structure.
**Cons:** requires either promoting the PO out of the subagent
topology (contradicts PDR-002's architecture) or faking interactivity
through router relay (the current failure mode); forces one persona to
hold both divergent-discovery and convergent-contract postures.

### Option B — new PM subagent

**Pros:** symmetrical with existing roles; minimal router change.
**Cons:** reproduces the exact substrate mismatch being diagnosed —
a batch PM cannot brainstorm.

### Option C — PM as main-session mode; PO keeps convergent work (chosen in draft)

**Pros:** interactivity lands where it structurally lives; router
stays a classifier (directional/exploratory/ambiguous/multi-option →
enter PM mode); each persona holds one posture; PDR-012's
competencies are redistributed rather than reversed.
**Cons:** main session now carries a persona and its skill group;
mode entry/exit needs explicit discipline (close-with-artifact rule).

## Decision

Adopt Option C. The PM is a main-session mode defined by a poured
skill group and the lead-pm template; sessions terminate only by
closing a session record linking produced/revised artifacts. The PM
owns the why (intent records, candidates), problem-space map
stewardship, prioritization, current-state stewardship, and product
narrative (README/site). The PO owns the commitment (briefs anchored
to shaped candidates, scenarios, clarify responses, PDR drafting from
converged decisions). Disputes route by kind: boundary problems
resolve in the PO; why-problems block the brief and reopen the
candidate in a PM session.

**Amendment to PDR-012:** (a) the upstream interactive disciplines
(interview/discovery, shaping, option facilitation) re-home from the
PO charter to the PM mode; the PO retains the batchable elevation
(problem-and-outcome framing within brief authoring, PDR drafting).
(b) The router-level discovery-dialogue gate is retired in favor of
PM-mode entry. (c) The 2026-06-05 "market-facing competencies are
load-bearing" steering is narrowed: product-communication competencies
(README, site, value narrative) are in scope; market research,
personas, positioning, pricing, and growth metrics are parked, and
the lead-8lgi skill-catalogue mapping is re-filtered accordingly.
PDR-012's lead-architect structurizr commitments are untouched.

## Consequences

Easier: stakeholders get a front door; router prompt shrinks; PO
posture purifies. Harder: main-session template complexity; the
close-with-artifact rule needs gate support (closed session ⇒
non-empty produced/revised). New artifacts and skills per cand-P01.
Current-state impact: invariants gain "directional input enters
through PM mode"; templates BC entry gains the lead-pm template.
Future gate work (named, not specified): README capability claims
anchor to current-state entries.

**Application is deferred to Phase 3 (`lead-kz33`).** This PDR is the
accepted decision; the concrete role material — `role-deltas.md` applied
to the lead-po / router / lead-architect templates, the lead-pm template,
and the PM skills — is dispatched to the `shopsystem-templates` BC as
separate Phase-3 work, gated on this landing. This landing changes no
template, primer, or router content.

## Cross-references

- [PDR-012](012-lead-po-product-manager-scope-and-architect-structurizr-maintenance.md)
  — the empowered-PM elevation this PDR partially amends (clauses a/b/c);
  see its Amended-by note.
- [PDR-002](002-lead-shop-roles-as-subagents.md) — lead-shop roles as
  subagents; the topology constraint (subagents are batch-mode) that makes
  a PM subagent (Option B) unworkable.
- `pdr-P01` (→ reserved PDR-032, not yet ratified) — artifact type-system
  ownership; charters the new artifact frontmatter this PDR deliberately
  does **not** adopt (the corpus is still on the house convention until
  P01 lands).
- Handoff-package `sess-2026-07-09-a` — `intent-P01`, `cand-P01`, and the
  originating PM session; the derives-from lineage, not yet landed in-repo.

## Changelog

- 2026-07-09 drafted in `sess-2026-07-09-a` (as `pdr-P02`); proposed.
- 2026-07-09 ratified by dstengle; landed as PDR-033 from handoff-package
  `pdr-P02`. Frontmatter adapted to the house convention (H1 + bold-field
  header); decision content preserved verbatim. Bidirectional partial-
  amendment linkage with PDR-012 recorded (this side + PDR-012 Amended-by
  note).
</content>
</invoke>
