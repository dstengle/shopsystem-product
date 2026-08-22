---
type: decision-brief
status: delivered
date: 2026-08-22
reader: product-authority
decisions-requested: 7
annex: rebaseline:basis/records/principle-set-chain-review-material.md
verified-by:
  - {round: 1, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
  - {round: 2, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
  - {round: 3, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
  - {round: 4, verdict: findings, judge: claude-fable-5, prompt: cold-read-v1}
---

# Brief 029 — Phase 0 chain review: the principle-set chain and its exemplar

**Delivered at the round cap (4 cold-read rounds; final round: six of
seven asks confident, ask 1's summary-review dependence marked as an
accepted tradeoff).** The round-4 residuals — the delta ledger not
closing (now closed: D1–D7 and D9 in ask 2, D8 in ask 3, D10 in
ask 5), ask 6's vague default, and two dense sentences — were
repaired after the round, unverified by a further cold read. Rounds
1–3 findings were repaired and re-verified in later rounds.

## The answer first

Phase 0's build steps are done on the `rebaseline` branch: the
principle-set definition chain is drafted (five new links beside the
approved typedef), the mechanical derivation reports all six links
present, and the exemplar — your approved nine-principle set run
through the drafted chain — passes every fitness scenario.
**Recommendation: rule the chain-and-exemplar verdict
"tradeoffs-accepted" (ask 1), and charter the architecture principle
set as its own instance authored through this chain (ask 2).** Ask 1
gates the chain approval stamps and everything after; ask 2 gates
Phase 0's exit; asks 3–7 resolve on silence, each by the default
stated with it.

The one discovery that reframes the run: the keeper
(`01-principles.md`, the old spec chapter) holds **architecture**
principles — how the system is built — while the approved set holds
**working** principles — how the shop works. They are not the same
document at different quality; they are two instances of the
principle-set type. The rewrite therefore cannot "reconcile the
chapter into the approved set" as the action row assumed; the honest
move is to author the architecture set as a second instance through
the chain you are now reviewing. That is ask 2, and it is what
Phase 0 — "architecture principles; everything derives from them" —
promised in the first place.

## Asks

Gating restated: ask 1 gates the stamps, ask 2 gates Phase 0's exit,
asks 3–7 resolve on silence by their defaults. The friction-finding
ids F1–F7 used below are inventoried, one per id, in ask 6.

**1. The chain-and-exemplar verdict.** *(Gates the chain approval.)*

What the verdict covers:
- The chain's four new documents: quality guideline (six rules, each
  with a test, criterion, and yes/no decision), fitness set (six
  judged scenarios, compiled to an eight-row judge rubric), authoring
  process (draft → fresh-context screen-read → dual-exit route with a
  round-3 park → your ruling as the terminal gate), and the skill —
  generated from the process by `basis/tools/compile_process.py`
  (digest fed20c3027db), nobody hand-wrote it. Roles: the existing
  cold-reviewer, reused; no new seat.
- The exemplar: your approved nine-principle set passes all six
  fitness scenarios and the mechanical keyword and slug scans, with
  ONE accepted tradeoff, marked as such in the material: one
  implication of `define-good-up-front` (your R12 addition) is only
  arguably derivable from its statement. The principle's text was
  left untouched — the set is approved — and the point is filed as a
  review item.

What the verdict excludes: the seven process-friction findings
inventoried in ask 6. None is a defect in the chain's documents —
they are gaps in the *migration process around* the chain (routing,
filing, typing of the material itself), each filed rather than
fixed-by-lowering-a-check, so they do not defeat this verdict.

*Recommend: verdict "tradeoffs-accepted" — on it, the four new links
stamp approved.* Evidence: whole-basis lint passes on the branch; the
derivation reports every link non-empty; the material is the annex
(committed `9d5b02b` on `rebaseline`). *Default: verdict "findings" —
the chain returns for a round-2 revision; nothing stamps.* (Accepted
tradeoff: the four documents are summarized here, not reproduced —
judging their full text means opening the annex; the price of a
summary review.)

**2. Charter the architecture principle set.** *(Gates Phase 0
exit.)* The delta ledger, closed: D1 is the governing scope mismatch
itself; D2–D7 are the keeper's six architecture principles (knowable
shape, contracts-only currency, actor-neutral discipline,
architecture-level local comprehension, reverse conformance, intent
provenance); D9 is the keeper's reinforcement web (how its principles
support one another). D2–D7 and D9 — everything D1 governs — become a
new architecture principle-set instance, authored through
the just-approved chain (its authoring process, guideline, fitness
set, and your ruling as the gate). The keeper then retires with
coverage against that instance. *Recommend: charter it; Phase 0 exits
when you approve the architecture set.* Evidence: the scope mismatch
is documented delta-by-delta in the review material; authoring
through the chain is exactly the pattern the migration exists to
prove. *Default: the run parks with a finding and Phase 0 exits
incomplete.*

**3. Home of the exception rule (delta D8).** The old chapter's rule
that any
exception to a principle must be recorded, scoped, and time-bounded
needs a home in the new corpus. *Recommend: it rides ask 2 — decided
inside the architecture set's authoring, at your review of that
instance.* Evidence: the rule governs principle *use*, so it belongs
with a principle set's own definition rather than a standalone
record. *Default: held as an open item to that same review — the two
paths converge.*

**4. Two one-line amendments to approved documents.**
(a) The principle-set typedef's "Produced by" line —
before: *"seed drafting; amended only by the owner's ruling"*;
after: *"the principle-set authoring process
(`../processes/principle-set-authoring.md`); amended only by the
owner's ruling."*
(b) The cold-reviewer role's competencies —
before: *"the fitness set at `../fitness/decision-brief.fitness.md`,
which this role judges"*;
after: *"the fitness set of the artifact type under review (currently
`decision-brief` and `principle-set`), which this role judges."*
*Recommend: approve both, applied with the ask-1 stamps.* Evidence:
the exact wordings above are the whole change; leaving them creates a
dual authority between approved documents — this is friction finding
F4 in ask 6's inventory below. *Default: the friction stands and is filed as
a finding.*

**5. Glossary gaps (delta D10).** "Activity" appears in four approved
principle
statements yet is undefined; "shop" and "Bounded Context" are used
but not glossary-defined. *Recommend: draft the three entries during
ask 2's authoring; they stamp with that review.* Evidence: the
use-defined-terms principle's first conviction was exactly this
defect class. *Default: filed as a finding.*

**6. The seven friction findings, inventoried** (each with what stays
broken if unfixed):
- F1 — the exemplar's review material has no defined artifact type;
  unfixed, every future chain review produces undefined-format
  material.
- F2 — no scope-routing rule for cross-scope keepers; unfixed, the
  next mismatched keeper stalls its run the way this one nearly did
  (ask 2 resolves this instance).
- F3 — no rule for judge-role reuse vs a new seat; unfixed, each run
  re-decides ad hoc (reuse chosen this run).
- F4 — the typedef dual-authority; resolved outright by ask 4a.
- F5 — when two sibling instances of one type exist (here: the
  working and architecture principle sets), which derives from which
  — or neither — is undefined; unfixed, the provenance edge between
  them cannot be recorded.
- F6 — the same tests live in both the set's own fitness screen and
  the judge's fitness set. This run resolved it: the screen is the
  author's self-check, the fitness set is the judge's rubric.
  **Silence adopts that split as the standing resolution — the one
  durable policy in this inventory.**
- F7 — the drafting agent had no work-item id in its context and
  could not file the finding items itself; I file them as beads (the
  shop's work-item tracker) under the review conversation when your
  ruling lands.

*Recommend: accept F1, F2, F3, F5, F7 as filed findings — each
missing definition gets built by the run that needs it, per your
Phase 1 ruling's pattern — and adopt the F6 split.* Evidence: every
finding is recorded with its occurrence in the review material.
*Default: on silence I file the same items when this brief's
silence window closes, instead of on your explicit ruling — the
filed set is identical either way.*

**7. Round-cap semantics.** The new authoring process routes your
ruling back through the same round counter that caps the judge loop —
judge rounds and authority-return rounds share one bounded budget of
three before the park (worked example: two judge rounds spent on
findings leave room for exactly one authority return before the
process parks with a filed finding). *Recommend: accept as designed;
a single cap keeps every loop's total bounded.* Evidence: the dual-exit
pattern mirrors the migration process you approved this morning.
*Default: accept — silence keeps the drafted wiring.*

## Deferred (notes, not asks)

- The review material lives at `basis/records/` on the branch, while
  the Seed (the branch's initial provisioning step, completed this
  morning) ruled records single-source on `main`. At reconciliation I
  will move it under `main`'s record-keeping and leave the branch
  records-free, keeping the Seed rule intact.
- The linter caught one banned-term defect in the drafted material
  mid-run; it was repaired before commit — the mechanical checks are
  doing their job on the new tree.

## Annex

The review material (chain links, exemplar verdict, deltas D1–D10,
findings F1–F7):
`basis/records/principle-set-chain-review-material.md` on
`rebaseline` at `9d5b02b`. The chain files themselves:
`basis/guidelines/principle-set.md`,
`basis/fitness/principle-set.fitness.md`,
`basis/processes/principle-set-authoring.md`,
`basis/skills/principle-set-authoring/SKILL.md`. Optional; every ask
above is decidable from this brief.
