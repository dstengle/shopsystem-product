---
type: candidate
id: cand-005
title: Close the knowledge/schema system's precondition chain, end to end
status: committed
created: 2026-07-16
updated: 2026-07-16
authors: [dstengle, "Claude (acting lead-pm)"]
description: Shaped candidate sequencing every broken or unwired precondition the knowledge/schema/progressive-disclosure system depends on, in dependency order, so each phase is built on ground that actually holds rather than on parts that individually pass their own test while the system around them stays broken.
derives-from: [intent-007]
session: sess-2026-07-16-a
experiments: []
brief:
parked-until:
beads: []
---

# cand-005 — Close the knowledge/schema system's precondition chain

## Problem

Checking one file (`ADR-048`) against `shop-knowledge validate` answered
correctly — but the question behind it ("is the schema checker trustworthy?")
led to checking the system the checker sits inside, and ten linked
preconditions turned out to hold in only one place. Each broken link was
independently invisible: the CLI validates a file correctly in isolation;
the generator emits a template that matches its own typedef in isolation;
`lead-5msa9.2` shipped skill-wiring that a scratch install verified in
isolation. None of that adds up to a working system, because:

1. **Typedef vs. practice** — the `candidate`/`intent-record`/
   `session-record` typedefs generate templates matching almost no real
   instance ever authored (5 independently-authored files checked,
   `lead-6n4j6`).
2. **Skills don't call the validator** — zero of this repo's 8 poured
   `.claude/skills/*/SKILL.md` files reference `shop-knowledge` at all.
3. **The fix for #2 isn't released** — `lead-5msa9.2`'s wiring landed on
   shop-templates `main` (`c257e4d`) but the installed package here
   (`0.52.6`) predates it; it's merged-unreleased, tracked at `lead-jqew9`.
4. **This repo's pour is separately stale** — `.claude/skills/*` were last
   fully re-rendered from `v0.51.0` (2026-07-10), two releases behind the
   installed package regardless of #3.
5. **Nothing enforces any of it** — no CI, no pre-commit hook, no
   `bin/doctor` (ADR-047's designated host, itself never poured here).
   Four non-conforming files were committed this same session with
   nothing stopping it.
6. **The actual coherence gate was never built** — PDR-032's cross-
   artifact checks (link resolution, bidirectional supersession,
   `incorporates`-claims, lifecycle conditions — "gate rules 4-8") have
   no runnable implementation anywhere; `shop-knowledge` only exposes
   `template`/`schema`/`validate`.
7. **The legacy corpus migration (`cand-004`/PDR-034) sits downstream of
   all of the above** — dispatching it now would migrate ~90 files onto
   a typedef known to be wrong, adding an eleventh broken link instead
   of closing the chain.

## Acceptance criteria

Set by the product authority, verbatim, plus what direct investigation
added:

1. **There is a documented lifecycle flow for artifacts** — not just a
   status enum per type, but documented valid transitions and, per type,
   documented required structure. **Addressed 2026-07-16:**
   [`artifact-lifecycle.md`](../artifact-lifecycle.md) — a graph-form
   cross-type flow plus per-type lifecycle diagrams, explicit about which
   parts are pinned (scenario-enforced) vs. observed-only. Hand-authored,
   not generated — flagged in that document itself as something Phase 4
   (the coherence gate) should eventually supersede with a generated
   equivalent, so this doesn't become another hand-maintained drift trap.
2. **Artifacts are checked** — a tool exists (`shop-knowledge validate`,
   shipped `lead-5msa9.1`) but nothing invokes it automatically, and nothing
   in the PM-authoring path ever has.
3. **The documented lifecycle is checked** — not just structure, but that
   transitions are valid and that a "documented" lifecycle actually
   exists to check against. Currently fails at the precondition: PDR-032's
   lifecycle-condition gate rules (4-8) were scoped, never built.
4. **The gate is passed** — no gate runs anywhere, automatically or
   on-demand as a project ritual. Not close to passing even if it ran:
   most of the corpus fails on first check.

Additional gaps surfaced by this candidate's own investigation, not
originally named but treated as in-scope:

5. Per-type required structure is mostly **never formally specified**,
   not merely drifted — confirmed by Architect Phase 1 work: `intent-record`
   and `session-record` have zero governing scenarios for their body
   structure; `candidate` has exactly one (`Verbatim anchors`, brief-018)
   covering a fraction of its real structure, and that scenario's own
   status-enum assumption is itself wrong; `pdr` has no real defect.
6. **No completion journal exists for PM sessions** — every PM skill
   instructs reading "the current-state doc and the completion journal"
   before shaping; the latter has never been created. This precondition
   has been silently unsatisfiable since PM mode launched.
7. **`current-state.md` is still seed content** — three `<!-- Seed: -->`
   placeholders remain despite `status: live`, undermining the one
   document every session is told to ground itself in first.
8. **`prioritizations/` has never been created** — zero instances, though
   its typedef schema and PM skill both exist (already named in
   `intent-005`; cross-referenced here, not duplicated).
9. **A scenario can be pinned on a false premise and get silently stuck**
   — `lead-ptr7a`/brief-018 was deadlocked on two identical non-answers
   because its own premise (intent-record's typedef already had a
   `Verbatim anchors` field) was false. Found and unstuck mid-investigation,
   not by any mechanism designed to catch it.

## Appetite

**Larger than originally assumed.** `cand-004` was shaped believing the
typedef/skill-wiring layer already worked and only the legacy corpus
needed migrating; that assumption is now known false. Two shapes worth
naming rather than picking silently:

- **Full chain** — fund all five phases below now, closing the system
  end to end in one committed arc.
- **Foundation-first** — commit phases 1-3 (typedef correctness, repour,
  minimal enforcement) now, since those are what make *every other*
  PM-mode artifact produced from here on conform; explicitly defer phase
  4 (the coherence-gate build — the largest, most net-new scope) and
  phase 5 (legacy migration) as named follow-ons rather than silently
  dropping them.

Not decided here — see Resolution.

## Solution sketch

Five phases, strictly in dependency order — each phase's output is a
precondition for the next, so none should start before the one before it
has actually landed and been verified, not just dispatched.

**Phase 1 — Typedef correctness.** Confirmed by Architect feasibility work
(2026-07-16), sharper than originally scoped: `intent-record` and
`session-record` need **PO-authored Gherkin from scratch** (`assign_scenarios`)
— no scenario currently governs their body structure at all, so this is
new requirements-authoring, not a bugfix. `candidate` needs a **targeted
fix**: reconcile its one existing governing scenario's status enum to
include `committed` (and whatever else the real status vocabulary turns
out to need), plus a decision on whether to formally pin the rest of its
structure now or treat `Verbatim anchors` as sufficient partial coverage.
`pdr` needs **no schema fix** — its one gap (`PDR-034`'s `status: draft`)
was a content bug in that one document, not a typedef defect; just fix
the document. Also folds in, same phase (structural gaps found alongside,
not requiring new typedef work, just authorship/action): create a
completion-journal artifact for PM sessions (criterion 6 — origin
still unconfirmed, see Rabbit holes), revise `current-state.md` past its
seed placeholders (criterion 7, partially done — see Changelog), and
document the artifact lifecycle in graph form (criterion 1 — **done**,
`artifact-lifecycle.md`).

**Phase 1 status: landed and verified (2026-07-16).** PO authored 19
pinned scenarios across 5 files; Architect independently re-verified all
19 hash reproductions and the ADR-064 D1/D2-compliant retirement of
`c07e8db63b3c1b42`→`73c7c146e1fd5dd3`, then dispatched `assign_scenarios`
to `shopsystem-knowledge` as `lead-x53ez` (2026-07-16). `work_done`
landed at `shopsystem-knowledge` merge `7f24d61`; Architect independently
verified behaviorally, not just by hash match: installed
`shopsystem-knowledge@7f24d61` on the lead host (same admissible pattern
as prior verifications) and confirmed `shop-knowledge template
intent-record/candidate/session-record` now emit the real 8/9/2-section
bodies (was the old 2-section stub) with the pinned status enums
(`intent-record` → `['recorded']`, `candidate` → includes `committed`)
and the corrected session-record id pattern
(`sess-\d{4}-\d{2}-\d{2}-[a-z]`); `shop-knowledge validate` now correctly
passes 6/7 `intent/*.md` (the 7th, `intent-003.md`, fails legitimately on
a real heading-text mismatch, not a tool defect) and 5/5 `sessions/*.md`.
`candidates/*.md` (including `cand-005.md` itself) still fail on a
missing `Verbatim anchors` section — a pre-existing gap pinned earlier by
brief-018, predating and out of scope for this dispatch, not a defect in
`lead-x53ez`'s fix. All 19 `scenario_hashes` in the `work_done`
reproduce exactly against this repo's `features/shopsystem-knowledge/*`
Gherkin. Per this candidate's own sequencing discipline, Phase 2 is now
unblocked — the next action, not yet started.

**Phase 2 — Release and repour.** Get `lead-5msa9.2`'s wiring (and the
other two fixes already riding the same unreleased range, per
`lead-jqew9`) into a tagged shop-templates release, install it on this
lead host, and run a full `shop-templates update`/pour — not the narrow
single-file edits this repo's last two pour commits were — so
`.claude/skills/*` actually reflects current source.

**Phase 3 — Minimal enforcement.** At least one of: skills that run
`shop-knowledge validate` after producing an artifact and surface
failure to the product authority rather than closing silently (this is
what `lead-5msa9.2` was supposed to deliver — Phase 2 makes it live), or
a pre-commit/CI check. `bin/doctor`'s role here (ADR-047's designated
gate host, currently absent from this repo) needs an Architect check on
whether a correct Phase 2 pour already brings it, or whether it needs
separate action.

**Phase 4 — Build the actual coherence gate.** PDR-032's cross-artifact
gate rules 4-8 (link resolution, bidirectional supersession,
`incorporates`-claims, lifecycle conditions) have no implementation
anywhere yet. This is real net-new `shopsystem-knowledge` scope, likely
the largest single phase — probably warrants its own brief once reached
rather than being pre-specified here.

**Phase 5 — Migrate the legacy corpus.** `cand-004`/PDR-034, unchanged in
substance, run once phases 1-4 give it a schema and gate actually worth
migrating onto. `cand-004` is not duplicated here — it is this
candidate's final phase by reference.

## Rabbit holes

- **Phase 4 scope creep.** The coherence gate is the least-specified
  phase and the most likely to balloon; PDR-032 names gate rules 4-8 but
  doesn't fully spec their implementation. Treat it as its own brief with
  its own appetite-setting, not something to pre-design inside this
  candidate.
- **Phase 1 direction risk.** If the Architect probe finds the typedef
  *was* deliberately minimal (not stale) and practice over-grew without
  a decision authorizing it, the correct fix inverts — practice
  conforms to the typedef, not the reverse. Named explicitly so it isn't
  silently assumed away by the evidence lean stated above.
- **Sequencing discipline.** The whole point of this candidate is that
  each phase's completion must be *verified*, not just dispatched, before
  the next starts — repeating the "shipped in isolation, broken in
  system" failure at the phase level would defeat the candidate's own
  premise.

## No-gos

Re-designing the six-type schema's field/lifecycle semantics from
scratch (Phase 1 reconciles, it does not redesign). Building new
retrieval/citation tooling on top of the fixed system — `intent-004`'s
territory, a distinct follow-on this unblocks but does not build.

## Evidence / experiments

**2026-07-16 — same-session, direct verification, not re-probed:**
`shop-knowledge validate` run against `ADR-048` (correctly non-conforming)
and against `intent-006`/`cand-004`/`pdr-034`/`sess-2026-07-16-a`/
`cand-001`/`cand-003`/`intent-004` (all fail, same shape). `shop-knowledge
template candidate`/`intent-record`/`pdr`/`session-record` compared
directly against real instances. `grep shop-knowledge` across all 8 poured
`.claude/skills/*/SKILL.md`: zero hits. `pip show shop-templates`:
`0.52.6` installed. `git log -- .claude/skills/`: last full re-render
`693d113` (2026-07-10, v0.51.0); most recent pour commit `310ea7b`
(2026-07-14) touched only `lead-primer.md`. `.github/workflows`, `bin/
doctor`: absent. `shop-knowledge --help`/bare invocation: only
`template`/`schema`/`validate` subcommands exist, no gate/coherence
command. `shop-knowledge schema adr`/`schema brief`/`schema
prioritization-record`/`schema current-state`: all return valid schemas
— type coverage exists for all 8 planned types, resolving one of
`cand-004`'s open uncertainties (whether adr/pdr/brief typedefs exist at
all — they do; whether they're *correct* is unverified). `find
/workspace -iname prioritizations`: does not exist. `current-state.md`:
3 `<!-- Seed: -->` markers remain.

**2026-07-16 — Architect Phase 1 feasibility (`acf8d399a7d46a9af`):**
re-verified installed `shop-knowledge` matches `shopsystem-knowledge`
`main` HEAD (no drift). Read `pdr/032`/`adr/059` directly: neither
specifies body-section content for any of the three types. Enumerated
`features/shopsystem-knowledge/*.feature` via `scenarios journal rebuild`
(not hand-grep, per this shop's own retrieval discipline): exactly one
governing scenario for `candidate` (`Verbatim anchors`, brief-018,
hashes `df3a4e715fad03a8`/`2e7f311162e627bc`/`917da713e6101b0d`), zero
for `intent-record`/`session-record`, `decision-makers` already correctly
pinned+enforced for `pdr` (`@scenario_hash:2363911877f9f657`). Found and
unstuck a deadlocked prior thread (`lead-ptr7a`/brief-018) whose premise
was falsified by the actual landed typedef.

## Resolution

**Committed 2026-07-16** by product authority (dstengle): "Fund it all" —
full-chain appetite, all five phases, not foundation-first. Phase 1's
direction (fix the typedef vs. restructure practice) remains an
Architect feasibility call, not resolved by this ratification — the
next action is dispatching that probe. Each phase must still be verified
landed, not just dispatched, before the next starts, per this
candidate's own Rabbit holes.

## Changelog

- 2026-07-16 opened and shaped in `sess-2026-07-16-a`, deriving from
  `intent-007`, in direct response to the product authority's
  precondition-chain question following the `ADR-048`/schema-checker
  check earlier the same session.
- 2026-07-16 committed by product authority: full-chain appetite,
  routed to Architect for Phase 1 feasibility.
- 2026-07-16 revised, same session: Architect Phase 1 findings folded
  in (intent-record/session-record need PO-authored scenarios from
  scratch; candidate needs a targeted status-enum fix; pdr needed no
  typedef fix). Acceptance criteria section added, restating the
  product authority's four stated criteria plus five additional gaps
  this candidate's own investigation surfaced (unspecified-not-drifted
  structure, missing completion journal, stale current-state.md, never-
  exercised prioritizations/, a scenario stuck on a false premise).
  Phase 1 now explicitly folds in completion-journal creation and
  current-state.md revision alongside the typedef work.
- 2026-07-16 authored `artifact-lifecycle.md` (criterion 1 done) and
  linked it from `current-state.md`'s Lead shop section.
- 2026-07-16 PO authored 19 pinned scenarios (5 files); Architect
  verified and dispatched `assign_scenarios` to `shopsystem-knowledge`
  as `lead-x53ez`, after one round of catching and fixing a real ADR-064
  D2 provenance-comment gap in the PO's own retirement of
  `c07e8db63b3c1b42`. Phase 1 now dispatched, awaiting `work_done`.
- 2026-07-16 `lead-x53ez` `work_done` arrived (merge `7f24d61`);
  Architect independently verified behaviorally (installed
  `shopsystem-knowledge@7f24d61`, exercised `template`/`schema`/
  `validate` against real `intent/`/`sessions/`/`candidates/` files, all
  19 scenario hashes reproduced), closed `lead-x53ez`, and consumed the
  outbox row. Phase 1 landed and verified; Phase 2 (release + repour) is
  now unblocked as the next action.
