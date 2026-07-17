---
type: candidate
id: cand-003
title: Structured-corpus query tools as the primary retrieval interface for subagent evidence-gathering
status: shaped
created: 2026-07-15
updated: 2026-07-15
authors: [dstengle, "Claude (acting lead-pm)"]
description: Shaped candidate for routing subagent retrieval against the scenarios corpus (and analogously the knowledge/decision-record corpus) through each corpus's canonical query tool rather than ad-hoc grep, since both are structured records (YAML frontmatter, @-tags) that support cheap, exact, complete queries.
derives-from: [intent-004]
session: sess-2026-07-15-a
experiments: []
brief:
parked-until:
beads: []
---

# cand-003 — Structured-corpus query tools as the primary retrieval interface

## Problem

`intent-004` recorded that subagent retrieval (`lead-po`/`lead-architect`
Grep/Read access) is provenance-blind and unreliable, and left the
solution shape as a genuinely open question. This session produced two
fresh, concrete manifestations of exactly that gap, on the same day:

- Five separate dispatches cited a lead-side scenario file path as if it
  were the BC's own path (this lead's `features/` tree is nested by BC
  name; each BC's own repo carries a flat tree with different
  filenames). Four occurrences were citation-only, zero functional
  impact — the `@scenario_hash` tag, not the path, is the real
  cross-repo identity, so hash-keyed reconciliation caught nothing wrong.
- The fifth was not cosmetic: an architect dispatch built a
  scenario-conflict enumeration by grepping one specific file instead of
  the full corpus. A sibling scenario file in the *same directory*
  carrying a real conflict was missed, and reached a BC only because
  that BC's own implementer was independently careful enough to catch it
  (`lead-ifye3.6`/`lead-r2bsr`).

Verified directly against the installed `scenarios` CLI's own source
this session: the tool's own aggregate/corpus-wide operations already
scan the full tree correctly (no path-shape assumption, no partial-scan
defect). The failure was that the subagent's own manual grep, not the
tool, was scoped incorrectly. The tool that already gets this right
exists; the subagents doing the retrieval aren't consistently using it
as their query interface.

The stakeholder's framing, stated directly: scenario and knowledge
artifacts already carry structured frontmatter (YAML, `@bc`, `@origin`,
`@scenario_hash`, decision-record types/ids) — they are effectively
records, not free text. Exact, complete queries against them should be
cheap via each corpus's own tool, and should not depend on a subagent
correctly hand-crafting a `grep` invocation that happens to cover the
right scope.

## Appetite

**Small.** Bounded to the two gaps this session actually demonstrated:
(1) scenario-corpus retrieval (ownership lookup, hash enumeration,
conflict/dependency checks) goes through the `scenarios` tool's own
query surface as the default path, not ad-hoc grep; (2) the equivalent
question for the knowledge/decision-record corpus (ADR/PDR/brief/finding
lookup) — routed through whatever query capability
`shopsystem-knowledge` exposes or should expose, given it already owns
schema/artifact-integrity per prior PM decisions
(`sess-2026-07-09-a`). Not a rebuild of progressive disclosure
(`lead-x7bp`) and not a general-purpose retrieval-scoping framework —
this candidate reconciles with that epic rather than duplicating it, per
`intent-004`'s own constraint.

## Solution sketch

Two elements, mirroring the stakeholder's own framing:

- **Scenario corpus**: subagent dispatch prompts and/or the `lead-po`/
  `lead-architect` role definitions direct retrieval against
  `features/` through the `scenarios` tool's query commands as the
  primary interface for anything corpus-wide (existence, ownership,
  conflict enumeration) — hand `Grep`/`Read` stays available for reading
  a *specific, already-identified* scenario's full text, not for
  discovering what exists. This is a prompt/role-definition-level
  change (shopsystem-templates-owned, per `intent-004`'s own
  constraint — not a local edit here), not new tooling: the `scenarios`
  CLI already does the right thing; what needs to change is the role
  discipline that decides when to reach for it.
- **Knowledge corpus**: the analogous shape for ADR/PDR/brief/finding
  retrieval, owned by whatever query surface `shopsystem-knowledge`
  exposes now or is extended to expose. Whether that capability already
  exists in queryable form (today's own dispatch history references a
  schema-*validation* CLI being built there, `lead-5msa9`/brief-019 —
  distinct from a *query* interface) is not established here and needs
  an Architect feasibility probe before this element can be shaped
  further.

Both elements share the same underlying mechanism-shape question
`intent-004` left open: is this best delivered as a mechanical gate
(retrieval fails/flags if it didn't go through the tool), a role-prompt
discipline change (cite the tool, don't restate from memory — the same
shape `ADR-064` already used successfully today for the scenario-
retirement convention), or both. Not decided here.

## Rabbit holes

- **Whether `shopsystem-knowledge` currently exposes a query interface
  at all**, versus only validation. Unconfirmed — named as the first
  thing an Architect probe should resolve before this candidate can be
  driven further on the knowledge-corpus element.
- **Mechanical enforcement vs. role-prompt discipline.** `intent-004`
  already flagged that a written-only rule (the existing
  spike-precedence rule) was insufficient once before. Whether this
  needs a hard gate or whether citing the tool the way `ADR-064` did is
  sufficient is an open design question, not resolved here.
- **Scope creep into full progressive disclosure.** `lead-x7bp` already
  exists as a larger epic on context/evidence quality; this candidate
  must reconcile with it, not duplicate or race it. Reconciliation
  itself is unresolved — Architect's call at brief/dispatch time.
- **Whether this fully explains the fifth (serious) incident.** It
  does not, on its own — the missed-sibling-file gap was a scope error
  in a manual grep, not a directory-nesting-vs-`@bc`-tag confusion
  (that was a *different*, already-verified-and-filed insight,
  `lead-xf7t4`). Using the tool as the query interface would have
  caught the missed sibling automatically (the tool's own aggregate
  scan is already correct), which is this candidate's actual argument —
  but it's a distinct fix from `lead-xf7t4`'s directory-flattening
  proposal, not the same fix restated.

## No-gos

Rebuilding progressive disclosure from scratch (`lead-x7bp`'s territory).
A general N-corpus retrieval-scoping framework beyond the two corpora
this session actually demonstrated problems in.

## Evidence / experiments

**2026-07-15 — same-session incident record**, cited directly rather
than re-probed: five wrong-path citations across dispatches today
(four cosmetic, one causing a genuine scope-verification gap,
`lead-ifye3.6`/`lead-r2bsr`); confirmed via direct reading of the
installed `scenarios` CLI's own source (`validate.py`, `journal.py`,
`outstanding.py`) that its aggregate operations use full-tree
`rglob("*.feature")` with no directory-shape assumption — the tool
itself was never the defect.

## Resolution

**Committed 2026-07-15** by product authority (dstengle). Routed to
`lead-po` for brief authoring. The knowledge-corpus element's open
feasibility question (see Rabbit holes) is not resolved by this
ratification — `lead-po` decides at brief-authoring time whether to
scope the brief to the well-understood scenario-corpus element alone
(with the knowledge-corpus element as an explicit follow-on pending an
Architect probe) or to request the probe as part of this same brief's
preparation, per the same pattern `cand-002` used for its own open
unknowns before commitment.

## Changelog

- 2026-07-15 opened and shaped in `sess-2026-07-15-a`, deriving from
  `intent-004`, prompted directly by the product authority proposing
  this solution shape in response to the same day's own incident
  record (five wrong-path citations, one causing a real scope gap).
- 2026-07-15 committed by product authority; routed to `lead-po` for
  brief authoring.
