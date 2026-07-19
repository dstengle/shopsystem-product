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

**Phase 2 status: landed and verified (2026-07-16).** Architect
re-verified pre-state via `gh api` before dispatching (`origin/main` HEAD
still `c257e4d`, matching `lead-jqew9`'s prior citation; `releases/latest`
still `v0.52.6@447e08e`, so no tag had been cut since and the dispatch
was not redundant), then dispatched `request_maintenance` ->
`shopsystem-templates` reusing `lead-jqew9` as `work_id`, per the
`lead-5zwz`/`lead-2c2k`/`lead-0r3y`/`lead-14xm` flat-release-cut
precedent shape. `work_done` landed reporting tag `v0.53.0`; Architect
independently re-verified all 4 acceptance criteria via `gh api` (not
trusting the BC's self-report): tag `v0.53.0` -> annotated tag object ->
commit `702125a6f7de1eeccf100ad3eef18d9af62a2559`, which is `origin/main`
HEAD; `compare/<c>...702125a6` for each of `a35c4c0` (lead-1gt5),
`c110bf0` (lead-bo85), and `c257e4d` (lead-5msa9.2) returns
`behind_by: 0` (all three are ancestors of the release commit);
`pyproject.toml` `[project].version` at the tagged commit reads `0.53.0`
(matches tag); the `release` GitHub Actions run for that commit reports
`conclusion: success`; the GitHub release object is non-draft,
non-prerelease, and is `releases/latest`. Consumed the `work_done` row
(`shop-msg consume outbox`). Upgraded this lead host's installed
`shop-templates` package `0.52.6` -> `0.53.0` (`pip show shop-templates`
confirms). Ran a full `shop-templates update --target . --shop-type
lead` (not a narrow single-file edit) — 8 canonical files changed,
purely additive: `.claude/agents/lead-architect.md`,
`.claude/agents/lead-po.md`, and 6 `.claude/skills/*/SKILL.md` files
(`create-bc`, `discovery-dialogue`, `option-tradeoff`, `prioritization`,
`product-narrative`, `shaping`). Verified behaviorally, not just that
files changed: `grep -c shop-knowledge .claude/skills/*/SKILL.md` now
shows real hits in exactly 5 files (`discovery-dialogue` 3,
`option-tradeoff` 3, `prioritization` 2, `product-narrative` 4,
`shaping` 3 — was zero everywhere before this pour), each hit wiring in
`shop-knowledge template`/`shop-knowledge validate` calls per
`lead-5msa9.2`'s intent; `.claude/skills/create-bc/SKILL.md` now
contains the `git init -b main` / `git branch -M main` default-branch
guidance from `lead-1gt5`, absent before. (`lead-bo85`'s decision-table
fix lives in the BC-side `bc.md`/`bc-primer` template, not a lead-pour
target, so it has no lead-host spot-check surface — its landing was
already verified against `shopsystem-templates`' own published source at
close time.) Three pre-existing shop-owned-file advisories
(`bin/shop-shell`, `bin/agent-vault-provision`,
`bin/agent-vault-check` — drifted from canonical, left untouched by
`update` per its own advisory) are unrelated to this phase's scope and
were not actioned. Committed the 8 pour-touched files plus this
`cand-005.md` update. Phase 3 (minimal enforcement) is now unblocked as
the next action; not started by this dispatch.

**Phase 3 — Minimal enforcement.** At least one of: skills that run
`shop-knowledge validate` after producing an artifact and surface
failure to the product authority rather than closing silently (this is
what `lead-5msa9.2` was supposed to deliver — Phase 2 makes it live), or
a pre-commit/CI check. `bin/doctor`'s role here (ADR-047's designated
gate host, currently absent from this repo) needs an Architect check on
whether a correct Phase 2 pour already brings it, or whether it needs
separate action.

**Phase 3 status: landed and verified (2026-07-16).** Architect first
determined what Phase 2 already delivered vs. what remained. Read all 5
newly-wired skill files' actual `shop-knowledge` bodies (not just
grep-counted them): `discovery-dialogue`, `option-tradeoff`,
`prioritization`, `product-narrative`, and `shaping` each genuinely
instruct fetching the canonical template (`shop-knowledge template
<type>`) and, before session close, running `shop-knowledge validate`
against the produced artifact and surfacing a failure to the product
authority rather than closing silently — real enforcement instructions,
not passing mentions. This already satisfies the "skills that call the
validator" half of Phase 3's "at least one of" framing; not duplicated.

`bin/doctor` and `.github/` were confirmed still absent (`ls bin/`,
`ls .github/`). Checked ADR-047 and its anchor PDR-024 directly rather
than guessing: PDR-024 D1 designates `bin/doctor` as
**shop-templates-rendered** ops furniture, rendered at `bootstrap` time,
product-neutral (sources `bin/ops-coordinates`, no per-shop templating).
Confirmed via `pip show -f shop-templates`: the file already ships as
installed package data at `shop_templates/templates/ops/doctor` in the
now-installed `0.53.0`, and its embedded scenario references
(`a6f8c0656a9e1cd9`/`f55aa51f4bd138b3`/`5cf88671d3fab25b`/
`027a4d836bb1ae43`) match this repo's own `features/shopsystem-templates/
ops_doctor_connectivity_checks.feature` (`@origin:lead-q3r1`) exactly —
i.e. this capability was already dispatched and landed upstream; its
absence here is solely because `shop-templates update` deliberately does
not touch `bin/` furniture (the same gap Phase 2 flagged as an advisory
for `bin/shop-shell`/`bin/agent-vault-provision`/`bin/agent-vault-check`).
So bringing it here required **neither** a further shop-templates
dispatch **nor** new local authorship — it required pouring the
byte-identical, already-released package-data file into place (verified
`diff` against the installed copy: identical), which the Architect did:
`bin/doctor` now present, executable, and independently verified
behaviorally (not just presence) via its own dependency-injection knobs
(`DOCTOR_PSQL`/`DOCTOR_CURL`/`DOCTOR_JQ`/`DOCTOR_FEATURES_DIR`) — an
all-pass fixture run correctly emits 4 `[PASS]` lines and exits 0, an
all-fail fixture run correctly emits 3 named `[FAIL]` lines each with a
remediation hint plus an aggregate `[FAIL]` naming the failed checks and
exits 1, and a run against this repo's real `features/`/`bc-manifest.yaml`
correctly surfaces a genuine pre-existing `E_UNKNOWN_ORIGIN` scenario-
corpus violation (`agent_vault_broker_integration.feature`, `@origin`
`adr-028` unresolved) — pre-existing debt outside this phase's scope, not
actioned here. `.github/` remains absent; no CI surface exists in this
repo and none was added — the pre-commit hook below is the chosen vehicle
per Phase 3's own "at least one of" framing.

Built the second, still-missing half: a minimal git pre-commit hook.
Added `bin/check-knowledge-artifacts` (lead-repo-owned local tooling,
deliberately NOT shop-templates-rendered — this enforcement wiring is
specific to this candidate's remediation, unlike `bin/doctor` which is
poured furniture) and installed it as `.git/hooks/pre-commit` (a symlink
back to the tracked script, since `.git/hooks/` itself is untracked —
the tracked script's own header documents the one-line reinstall command
for a fresh clone). The script runs `shop-knowledge validate` over
staged files under `adr/ pdr/ briefs/ candidates/ sessions/ intent/` and
`current-state.md`, split by git status: a **newly-added** file that
fails validate **blocks** the commit (exit non-zero, listing every
violation); a **modified pre-existing** file that fails validate
**warns** (printed, does not block). This split is deliberate, not a
missed edge case: empirically, 125 of 136 currently-tracked files across
these directories fail `shop-knowledge validate` today (checked directly,
not estimated) — almost entirely pre-existing debt Phase 5 (the legacy
corpus migration) is scoped to fix. A blanket hard block would make this
repo's git workflow unusable before Phase 5 lands; blocking only
newly-added non-conforming artifacts closes exactly the gap cand-005's
Problem #5 named ("Four non-conforming files were committed this same
session with nothing stopping it") without silently expanding into
Phase 5's migration scope.

Verified the hook against both a failing and a passing case, in both its
direct-file mode and its real git-staged mode (using `git add`/`git
reset` scratch fixtures on throwaway files, reverted before commit — no
residue): a newly-added non-conforming fixture (copied `intent-record`
template scaffold, missing required frontmatter) correctly **blocks**
with exit 1 and a full violation list; a newly-added conforming fixture
(a real `intent-record` instance with a corrected id) correctly passes
with exit 0 and no false positive; staging a **modification** to an
already-tracked, already-non-conforming file (`adr/047`, which has no
YAML frontmatter, consistent with the pre-existing-ADR-corpus gap Phase 1
did not touch) correctly **warns** without blocking, exiting 0. No CI
workflow was added (`.github/` stays absent) — the pre-commit hook is the
concrete Phase 3 vehicle chosen, per its own "at least one of" framing,
and this repo has no CI runner configured to make a `.github/` addition
actionable yet.

Committed `bin/doctor`, `bin/check-knowledge-artifacts`, and this
`cand-005.md` update. (`.git/hooks/pre-commit` itself is a local
per-clone symlink, not committed — `.git/hooks/` is untracked by design;
the reinstall command lives in the tracked script's header.) Phase 4
(the coherence gate) is next — named as the largest, least-specified
phase, likely warranting its own brief once reached, per this candidate's
own Rabbit holes — not started by this dispatch.

**Phase 4 — Build the actual coherence gate.** PDR-032's cross-artifact
gate rules 4-8 (link resolution, bidirectional supersession,
`incorporates`-claims, lifecycle conditions) have no implementation
anywhere yet. This is real net-new `shopsystem-knowledge` scope, likely
the largest single phase — probably warrants its own brief once reached
rather than being pre-specified here.

**Phase 4 status: dispatched (2026-07-16), not yet landed.** Correction
to the assumption above: PO brief authoring (`briefs/023-coherence-gate-lead-installable-cli.md`)
found the gate-check LOGIC for rules 4-8 was already fully authored and
pinned (`coherence_gate_typed_edges.feature` 11 scenarios,
`coherence_gate_lifecycle_rules.feature` 13 scenarios,
`coherence_gate_advisory_blocking.feature` 4 scenarios) — left undispatched
after a prior attempt (`lead-5oih`) was correctly closed as mis-scoped
(tried to run the gate inside a BC over lead-held artifacts, an ADR-018 D2
violation). Real remaining scope was narrower: wire that existing logic
into a lead-installable CLI (`shop-knowledge gate <corpus-root>`, 6 new
scenarios), with an honest "unverifiable-legacy" verdict for edges
pointing at frontmatter-less legacy targets. Architect independently
verified all 34 scenario hashes (corrected count: 34, not the 33
originally estimated) and dispatched `assign_scenarios` to
`shopsystem-knowledge` reusing work_id `lead-iohr` (already open,
tracking exactly this). Distribution-mode blocking, `bin/doctor` wiring,
and lifecycle-transition-validity checking (as opposed to current-value
validity, already covered by Phase 1) are named, deferred follow-ons, not
dropped.

**`lead-iohr` `work_done` arrived and was NOT accepted (2026-07-16).**
All 34 `scenario_hashes` independently reproduced exactly against the 4
on-disk feature files (no drift), and the BC's own 150-test suite is
green — but behavioral verification against this repo's real corpus
(installed `shopsystem-knowledge@69dd0cd10eac48da7d3c6350d49e4e48497a787e`
on the lead host, then ran the installed `shop-knowledge-gate` command
directly, per this shop's ADR-018 D1/D2 bar for a new CLI surface) found
it fails both of brief-023's own named grounding cases (§6): PDR-034's
`supersedes: [pdr-032]` edge is never evaluated at all — the corpus
loader's `SUBDIR_TYPES` keys are `"pdrs"`/`"adrs"` (plural), not this
repo's real `"pdr"`/`"adr"` directories, so PDR-034 itself (a real, fully
typed file) is invisible to the loader — and `current-state.md`'s
`incorporates: [pdr-032, pdr-033, adr-059]` is wrongly reported as 3
`dangling-edge` findings instead of 3 `unverifiable-legacy` findings, a
second, independent defect (the legacy-id derivation uses the raw
filename stem, which matches the BC's own `<id>.md` synthetic test
fixtures but not this repo's real numeric-slug legacy filenames like
`pdr/032-knowledge-bc-owns-artifact-type-system.md`). Filed as `lead-cea24`
(P1, full repro) and left `lead-iohr` open/annotated rather than closed.
A same-work_id `mechanism_observation` (28/34 scenarios were already-
pinned adoption, not new work — no defect) was filed as low-priority
`lead-c46ug` per this shop's overnight-triage pattern, not actioned now.
Both outbox rows consumed. **Phase 4 remains dispatched, not landed** —
the next action is scoping and dispatching a fix for `lead-cea24`, not
Phase 5.

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
- 2026-07-16 Phase 2 dispatched and landed: `request_maintenance` ->
  `shopsystem-templates` (`work_id lead-jqew9`, reusing the existing
  tracking bead per shop precedent) cut release `v0.53.0` carrying
  `lead-1gt5`/`lead-bo85`/`lead-5msa9.2`; Architect independently
  re-verified all 4 acceptance criteria via `gh api` and consumed
  `work_done`. Lead host upgraded `shop-templates` `0.52.6` -> `0.53.0`
  and a full `shop-templates update` re-poured 8 canonical files;
  `shop-knowledge` wiring confirmed live in 5 PM skills (was zero hits)
  and the `create-bc` `main`-branch fix confirmed present. `lead-jqew9`
  closed. Phase 3 (minimal enforcement) is now unblocked as the next
  action, not started.
- 2026-07-16 Phase 3 landed and verified: confirmed the 5 Phase-2-wired
  PM skills already satisfy the "skills call the validator" half of
  Phase 3 (read their bodies directly, not just grep-counted). Confirmed
  via ADR-047/PDR-024 that `bin/doctor` is already-released
  shop-templates package data (matches this repo's own
  `lead-q3r1`-dispatched `ops_doctor_connectivity_checks.feature`
  hashes exactly) absent here only because `shop-templates update`
  doesn't touch `bin/`; poured it byte-identical from the installed
  package and verified it behaviorally (pass/fail fixture runs, plus a
  real run against this repo surfacing a genuine pre-existing scenario-
  corpus violation, out of scope here). Built and installed
  `bin/check-knowledge-artifacts` as a git pre-commit hook: blocks
  newly-added non-conforming knowledge artifacts, warns (non-blocking)
  on modified pre-existing ones, deliberately not a blanket hard block
  given 125/136 existing files in-scope still fail validate (Phase 5
  territory). Verified against real failing/passing fixtures in both
  direct-file and git-staged modes. Phase 4 (the coherence gate) is next,
  not started by this dispatch.
- 2026-07-16 Phase 4 dispatched: brief-023 authored (28 already-pinned
  check-logic scenarios + 6 new CLI/loader scenarios), Architect verified
  and dispatched `assign_scenarios` reusing `lead-iohr` as work_id.
- 2026-07-16 `lead-iohr` `work_done` arrived and was rejected on
  reconciliation: all 34 scenario hashes reproduced clean, but behavioral
  verification of the installed `shop-knowledge-gate` CLI against this
  repo's real corpus found it fails both of brief-023's own grounding
  cases (PDR-034's `supersedes` edge invisible to the loader; `current-
  state.md`'s `incorporates` edges to legacy PDRs/ADRs wrongly reported
  dangling instead of unverifiable-legacy) — two compounding corpus-loader
  defects (directory-name mismatch, legacy-id derivation mismatch), both
  masked by the BC's own synthetic test fixtures. Filed `lead-cea24` (P1)
  to track the fix; `lead-iohr` left open/annotated. Phase 4 remains
  dispatched-not-landed; Phase 5 stays blocked.
- 2026-07-17 `lead-cea24` REFRAMED by product authority as a
  mis-diagnosis marker: the coherence-gate CLI is correct-as-built for the
  MODERN (uniformly-plural) layout; do NOT backport legacy dir/filename
  parsing into the tool. Correct direction is forward corpus migration
  (the `cand-004`/PDR-034 Phase 5 work). The `intent`→`intents` mirror of
  the pdr/adr key mismatch was split out as `lead-yy0xy` (P1) and
  dispatched `request_bugfix` → `shopsystem-knowledge`. Branch
  `migrate/legacy-corpus-modernization` executed the repo-side rename
  (`adr`→`adrs`, `pdr`→`pdrs`, `intent`→`intents`) plus artifact-file
  renames to `<id>.md` and a frontmatter backfill of the legacy corpus.
- **2026-07-18 Phase 4 VERIFIED-LANDED (lead-architect reconciliation).**
  Provenance: the installed lead-host `shopsystem-knowledge` is a clean
  VCS install pinned exactly to `origin/main` HEAD `5f5ac8a`
  (`dist-info/direct_url.json`: `url=github.com/dstengle/shopsystem-knowledge`,
  `commit=5f5ac8ad8f4336fc330b87d793ef67d79682d0d9`; `gh api compare
  main...5f5ac8a` → `status: identical`, `ahead_by/behind_by: 0`). NOT an
  editable/local install — the pip-reported `0.0.0` is merely an unset
  pyproject version, not a provenance flag. The plural-`SUBDIR_TYPES`
  loader fix is therefore properly landed on BC main: `lead-yy0xy` landed
  via a proper `request_bugfix` TDD loop (commits `ba376f1` test-red /
  `e8d6f8c` green / `5f5ac8a` feat, 2026-07-18, `dispatch_state=consumed`);
  the pdr/adr half needed no BC change (the loader already carried plural
  `pdrs`/`adrs` keys, correct-as-built once the repo renamed forward).
  Behavioral re-verify against this repo's REAL corpus:
  `shop-knowledge-gate --mode authoring .` AND `--mode distribution .`
  both report `no coherence findings`, exit 0; `load_corpus(".")` yields
  142 typed artifacts + 21 legacy_ids (all 21 are repo furniture/spec docs
  — `.env`, `README`, `01-principles`, `CLAUDE`, `pyproject`, etc. — NOT
  one pdr/adr/brief artifact, i.e. the artifact-corpus backfill is
  complete). Both brief-023 §6 grounding-case DEFECTS are gone:
  (a) PDR-034 now loads `typed=True` (no longer invisible); its
  `supersedes: [pdr-032]` frontmatter edge was deliberately deferred by
  the author to acceptance-time (PDR-034 is still `status: proposed`), so
  there is no edge to evaluate — not a loader miss; (b) `current-state.md`
  `incorporates: [..., pdr-032, pdr-033, adr-059]` resolves clean as typed
  edges (the migration made those three targets typed), NOT false-dangling.
  Reconciled and CLOSED `lead-iohr`, `lead-cea24`, `lead-yy0xy` with the
  landing evidence above. NOTE on the output-shape discrepancy: the
  "135 conforming / 7 known-modern-gaps" reading is from `shop-knowledge
  validate` (per-file structural), a DIFFERENT tool than the cross-artifact
  `shop-knowledge-gate` (coherence); the 7 validate failures
  (`cand-001..005` missing `Verbatim anchors`, `intent-003` heading
  mismatch, `current-state.md` structure) are pre-existing per-type
  structural gaps, not coherence-gate findings, and the coherence gate is
  clean in BOTH modes. Phase 4 is verified-landed; Phase 5 is unblocked.
