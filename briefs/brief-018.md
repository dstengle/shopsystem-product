---
type: brief
id: brief-018
title: 'Candidate typedef: add a `Verbatim anchors` section'
status: draft
created: 2026-07-14
updated: 2026-07-17
authors: [David Stenglein (product authority), Claude (lead-po)]
description: The `candidate` artifact typedef is missing a `Verbatim anchors` section
derives-from: [adr-059, adr-018, pdr-032, adr-056]
---

## Summary

## Scope

## Source (pre-modernization)

#### 1. The problem

The `candidate` artifact typedef is missing a `Verbatim anchors` section
that the `intent-record` typedef already has. Every intent record in this
repo (`intent-001` through `intent-005`) carries a `## Verbatim anchors`
section — a dated, verbatim, append-in-place list of stakeholder quotes,
positioned immediately after the title and before the record's first
narrative section (`## The goal behind the ask`). No candidate does; a
candidate's body sections today are Problem, Appetite, Solution sketch,
Rabbit holes, No-gos, Evidence / experiments, Resolution, Changelog — none
of them a verbatim-quote home.

`candidates/cand-002.md` is the concrete, already-realized cost of this
gap. During its shaping session the stakeholder said things that materially
changed the candidate's shape — e.g. flagging that literal per-provider
model IDs in `model_stylesheet` would defeat the candidate's own purpose
(provider switches would still require hand-rewriting every node-class
mapping), and separately demanding to know how a feasibility probe would
run and insisting on zero filesystem footprint. Both interactions were
consequential enough to reshape the candidate's solution sketch and trigger
a correction of a wrong precedent citation. They survive today ONLY as the
router's own paraphrased prose inside cand-002's `Evidence` and `Changelog`
sections ("product authority flagged...", "product authority caught...") —
not as structured, dated, verbatim quotes the way intent records capture
stakeholder input. A reader who wants to know exactly what the stakeholder
said — not what the PM paraphrased them as having said — has no citable
source. This is a real, stakeholder-identified gap: candidate-shaping
sessions lose citation fidelity for everything that happens after the
intent record closes, precisely the period when a candidate's shape is
still actively being negotiated.

#### 2. The job-to-be-done

*When a stakeholder says something during a candidate-shaping session that
materially changes the candidate's shape, I want that statement captured
verbatim and dated, in the same append-in-place way an intent record
captures it, so that later readers can cite exactly what was said instead
of trusting my paraphrase of it.*

#### 3. The outcome (observable behavior change)

- A candidate document generated after this fix carries a `## Verbatim
  anchors` section, positioned immediately after the title and before the
  `## Problem` section — the same placement discipline intent-record
  already uses (before its own first narrative section).
- The section's shape matches intent-record's exactly: dated
  (`YYYY-MM-DD: "<quote>"`), verbatim, appended to in place as the shaping
  session progresses — not synthesized after the fact from memory or from
  the Evidence/Changelog prose.
- The body-section-conformance check (`x-required-sections`, per ADR-059 /
  `body_section_conformance.feature`) enforces `Verbatim anchors` on
  candidate documents the same way it already enforces every other required
  section on every other type: a candidate missing the section is reported
  non-conforming, naming the missing section; a candidate carrying it
  passes.

Output (one new heading in a template) is not the measure; the behavior
change — a PM shaping a candidate has a structured, citable home for
stakeholder statements from the moment shaping starts, and stops losing
that fidelity to paraphrase — is.

#### 4. The pinned shape

- **What changes:** the `candidate` typedef (`typedef/candidate.yaml`,
  owned by shopsystem-knowledge, not readable from the lead host per
  ADR-018 — no BC source clone here) gains one new body section entry:
  `Verbatim anchors`, required, structurally equivalent to the
  `intent-record` typedef's existing `Verbatim anchors` entry (same
  dated/verbatim/append-in-place guidance text, same "required" status).
  Per ADR-059, this is a single-source change: editing the typedef
  regenerates BOTH the candidate template (`.md`) and the candidate schema
  fragment's `x-required-sections` list; the generated files themselves are
  never hand-edited (drift-gated).
- **Placement:** immediately after the candidate's title (`# cand-NNN —
  ...`), before `## Problem` — mirroring intent-record's placement of
  `Verbatim anchors` before `## The goal behind the ask`.
- **What does NOT change:** every other candidate section (Problem,
  Appetite, Solution sketch, Rabbit holes, No-gos, Evidence / experiments,
  Resolution, Changelog) is untouched — this is an addition, not a
  restructuring. `intent-record`'s own typedef and section shape are
  untouched. No other one of the eight artifact types (session-record,
  prioritization-record, brief, pdr, adr, current-state) is touched.

#### 5. Scope

**In scope** (pinned by §7's scenarios):

- The `candidate` typedef declares a `Verbatim anchors` required body
  section, shaped like intent-record's.
- The generated candidate template carries that section in the pinned
  placement.
- The body-section-conformance check enforces `Verbatim anchors` on
  candidate documents (missing ⇒ non-conforming named; present ⇒
  conforming).

**Out of scope / explicit non-goals:**

- **Backfilling `cand-001`/`cand-002` (or any existing candidate) with a
  reconstructed `Verbatim anchors` section.** This brief fixes the format
  going forward; retroactively reconstructing quotes for candidates already
  shaped would itself be exactly the paraphrase-not-verbatim failure mode
  this brief exists to prevent (nobody can reconstruct a verbatim quote
  after the fact with integrity). If the stakeholder wants cand-002
  specifically annotated, that is a separate, explicit request — not
  assumed here.
- **Changing intent-record's `Verbatim anchors` shape.** Untouched; it is
  the reference shape this brief copies, not a co-target.
- **Any other body-section change to any of the eight types.** Not
  requested, not in scope.
- **Legacy corpus migration** of the existing non-conforming candidates
  against the new required-section set — per PDR-032's existing "legacy
  corpus migration is deferred to its own future candidate" posture,
  which this brief inherits rather than re-litigates.

#### 6. Dispatch target

Single-BC: **shopsystem-knowledge**. Confirmed, not assumed — see the
"Anchored to" citations above and §1 of PDR-032 / ADR-059. The message-type
discriminator (capability exists but unpinned ⇒ likely `request_bugfix`,
versus genuinely new capability ⇒ `assign_scenarios`) is the Architect's
call at dispatch time, made against empirical pre-state verification of the
knowledge BC's current typedef/generator surface; not decided here.

#### 7. Pinned scenarios

Authored, hashed, and written to disk at:

- [`features/shopsystem-knowledge/candidate_verbatim_anchors_section.feature`](../features/shopsystem-knowledge/candidate_verbatim_anchors_section.feature)
  - `@scenario_hash:df3a4e715fad03a8` — the candidate typedef declares a
    `Verbatim anchors` section shaped like intent-record's (same
    dated/verbatim/append-in-place guidance; same pre-first-narrative-
    section placement).
  - `@scenario_hash:2e7f311162e627bc` — a candidate document missing
    `Verbatim anchors` is reported non-conforming, naming the missing
    section (mirrors `body_section_conformance.feature`'s existing
    missing-section pattern, applied to the newly-required candidate
    section).
  - `@scenario_hash:917da713e6101b0d` — a candidate document carrying
    `Verbatim anchors` alongside its other required sections passes
    conformance.

`@scenario_hash` values above were computed by the PO via the installed
`scenarios hash` CLI (block-only canonicalization) and independently
reproduced with `scenarios verify --hash <h>` against each on-disk block;
they are written on-disk directly above each `Scenario:` line, per this
shop's authoring convention. All three scenarios currently carry
`@bc:unassigned @origin:brief-018` at the feature level (the ADR-056 D8
transitional marker); `scenarios validate` currently reports
`E_UNKNOWN_ORIGIN` for `brief-018` because this brief and its bead are not
yet in the origin registry — the same transitional state brief-017's own
not-yet-dispatched feature files are in as of this writing. The Architect
resolves this at assignment (real `@bc:shopsystem-knowledge` tag + a
registered origin), a mechanical step, not a re-derivation.

#### 8. Strategic trace

Traces to the artifact-type-system strategic bet PDR-032 records (knowledge
BC owns artifact shapes and integrity) and ADR-059 refines (typedef
single-sourcing eliminates format drift by construction). This is not an
orphan feature: it is a small, bounded gap-fix inside an already-committed
system, surfaced by using that system in anger (cand-002's own shaping
session) rather than a new strategic direction. No brief-level strategic
reframing is needed or claimed.

#### 9. What would NOT satisfy the stakeholder

- Adding `Verbatim anchors` to the candidate **template** by hand without
  touching the typedef — this reinstalls exactly the hand-authored
  template/schema-drift defect ADR-059 exists to eliminate; the fix must go
  through the typedef, not a direct template edit.
- Fabricating verbatim-looking quotes for `cand-002` retroactively to
  "backfill" the section — a synthesized quote is not a verbatim quote; see
  §5's explicit non-goal.
- A `Verbatim anchors` section that is a one-time synthesized narrative
  written after the fact rather than a section shaped for live, dated,
  append-in-place capture as a shaping session progresses.
- Silently changing other candidate sections' required-ness or wording
  while touching this one — this brief is additive only.
