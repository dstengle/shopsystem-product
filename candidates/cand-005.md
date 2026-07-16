---
type: candidate
id: cand-005
title: Close the knowledge/schema system's precondition chain, end to end
status: shaped
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

**Phase 1 — Typedef correctness.** Reconcile the `candidate`/
`intent-record`/`session-record` typedefs against established practice.
Direction (fix the typedef to match practice, vs. restructure practice to
match the typedef) is an Architect feasibility call, not decided here —
though the evidence (independently-authored instances agreeing with each
other, disagreeing with the typedef) leans toward the typedef being the
actual defect. `pdr`'s typedef is already close (two small field/enum
gaps) and may not need the same depth of reconciliation.

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
command.

## Resolution

(open — appetite shape (full chain vs. foundation-first) and Phase 1
direction awaiting product-authority decision)

## Changelog

- 2026-07-16 opened and shaped in `sess-2026-07-16-a`, deriving from
  `intent-007`, in direct response to the product authority's
  precondition-chain question following the `ADR-048`/schema-checker
  check earlier the same session.
