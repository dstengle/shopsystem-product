---
type: material
id: principle-set-chain-review-material
owner: product-authority
status: draft
created: 2026-08-22
updated: 2026-08-22
---

# Exemplar reconciliation: principle-set (Phase 0)

This is the `exemplar` output of the definition-chain-migration Phase 0
run: material for the authority's review of the principle-set chain, not
a baseline artifact. Its own format is undefined — recorded below as
friction finding F1; per the migration process's guiding statement it is
source material for that review and claims no other standing.

The exemplar keeper is `main:01-principles.md` (the old spec chapter,
action keep-rewrite, directive: reconcile into the approved set). The
rewrite target already exists and is approved:
[`../principles.md`](../principles.md) (R23). The exemplar work was
therefore: (1) verify the approved set against the drafted chain,
(2) reconcile the keeper — every binding delta listed, none applied,
(3) record every point where the chain failed to decide.

## 1. Verification of the approved set against the drafted chain

Verdict: **tradeoffs-accepted** — the approved set passes the drafted
guideline and fitness set; one wobbly finding (V7 below), no repairs
required, no change made to the approved document.

- Scenario 1 (good defined first; four parts only; slug citations):
  pass. The opening self-definition precedes every principle; no
  principle carries a fifth part; a scan for numbered references
  (`Principle <n>`) returns none.
- Scenario 2 (statement decides alone): pass for all nine statements.
- Scenario 3 (rationale holds evidence): pass — every rationale cites a
  held incident (67 unreviewed memories, the dropped
  mechanism_observation channel, the schema-copy drift, six
  fabro-launcher defects, the 2026-08-03 trust break, the "kind"
  coinage) or a named source (Deming, ASD-STE100, ISO 704, least
  privilege).
- Scenario 4 (implications derivable, actor-named): pass, with V7.
- Scenario 5 (screen covers the set): pass — nine columns, all test
  rows, claimed passes reproduced.
- Scenario 6 (rejects something): pass — the screen's Spool row states
  the rejected work per principle.
- Mechanical keyword check (guideline rule 2): pass — BCP 14 capitals
  outside statements appear only in the opening's keyword-definition
  sentence (line 20); the other capitals (lines 106, 180) sit inside
  statements.
- V7 (wobbly, accepted): `define-good-up-front`'s last implication —
  "Whoever proposes a new activity writes the proposal as a draft
  instance of the activity's type" — is only arguably derivable from the
  statement; it reads as a new obligation added by ruling R12. Accepted
  here because the ruling is the authority's own; listed as chain-review
  item CR7.

## 2. Reconciliation deltas: the keeper vs the approved set

Every delta where the keeper carries something binding that the approved
set does not. None applied — the set is approved; each routes to the
chain review.

- D1 — scope mismatch, the governing delta. The keeper's six principles
  govern the designed system (Bounded Contexts, shops, contracts,
  conformance): scope `architecture` in the typedef's terms. The
  approved set is scope `working`. Reconciling the chapter "into the
  approved set" as the actions row directs would mix scopes in one
  document; the typedef gives a set exactly one scope. Every delta below
  is therefore a candidate for a second, architecture-scope set — or an
  explicit retirement ruling — not an amendment to the working set.
- D2 — keeper P1 (each first-class entity has a knowable shape;
  descriptions authoritative and complete from outside). Binding;
  absent from the nine.
- D3 — keeper P2 (contracts are the only currency across Bounded
  Contexts; no out-of-band channel between contexts). Binding; absent.
  `governed-context` governs agent context, not inter-context traffic.
- D4 — keeper P3 (discipline attaches to activities in shops, not to
  actor kinds). Partially carried: `no-orphan-activities` requires
  process membership, but the actor-neutrality rule — same rules for
  human, agent, service — appears nowhere. Binding residue; absent.
- D5 — keeper P4 (comprehension is local at every level; maps, not
  codebases). The working-scope analog exists (`least-context`), but the
  architecture-level reading ladder is absent. If an architecture set is
  chartered, the typedef's `derives-from` rule applies — lineage
  direction undecided (F5).
- D6 — keeper P5 (design is authoritative; bidirectional conformance).
  Partially carried: `single-source-of-truth` gives one authoritative
  home and `delivery-verified` gives forward demonstration; reverse
  conformance — "did we build only what we said", conformance-gated
  retirement and refactoring — is absent. Binding residue.
- D7 — keeper P6 (intent flows in from outside, through contracts, with
  provenance preserved). Binding; absent entirely.
- D8 — keeper §1.8 exception rule: "Compromising any one is admissible
  only as a recorded, scoped, time-bounded exception — itself an
  activity with provenance." A binding meta-rule with no home in the
  approved set or its typedef. Absent.
- D9 — keeper §1.8 reinforcement web (how principles support one
  another). Explanatory rather than binding, but the four-part form has
  no defined place for inter-principle relations; whether such prose is
  admissible is undecided (folded into CR1's authoring questions).
- D10 — keeper §1.1 vocabulary: Bounded Context, shop, activity.
  "Activity" appears in the statements of four approved principles, yet
  none of the three terms is in the glossary — the `use-defined-terms`
  test ("a reader must know it to perform or check the work") fires on
  the approved set itself. Binding; absent.
- Not deltas: §1.0 (context cost as bottleneck — rationale material,
  carried in spirit by `least-context`); the "Anti-pattern ruled out"
  blocks (form only; under guideline rule 5 their content folds into
  rationales and implications of any future rewrite).

## 3. Chain-review items (proposed, not applied)

- CR1: rule on the architecture mass (D1–D9): charter an
  architecture-scope principle set authored through this chain with the
  keeper as source material, or retire the six explicitly. Until ruled,
  the keeper's keep-rewrite action is only partially satisfiable.
- CR2: rule where the exception mechanism (D8) lives — a principle in
  each set, or a rule in the principle-set typedef.
- CR3: add glossary entries for activity, shop, and Bounded Context
  (D10), rewritten from the keeper, not pasted.
- CR4: amend the principle-set typedef's "Produced by" line to name
  `principle-set-authoring-process` once the chain is approved; today it
  says "seed drafting; amended only by the owner's ruling", which would
  leave the new process a second, unnamed authority (F4).
- CR5: generalize `cold-reviewer` — its approved definition is bound to
  presentations and names only the decision-brief fitness set; the
  chain reuses it as the principle-set judge per the prefer-reuse rule
  (F3). Either amend its competencies line to "the fitness set the
  invoking process names" or define a distinct reviewer role.
- CR6: optionally require a mechanical slug-citation lint behind
  guideline rule 6, which today rests on the judged scenario alone.
- CR7: rule on V7 — accept `define-good-up-front`'s proposal-as-draft
  implication as a standing tradeoff, or move the obligation into the
  statement at the set's next amendment.

## 4. Chain-friction findings (where the chain failed to decide)

- F1: the migration process types its `exemplar` output as a bare
  string and defines no artifact type for the exemplar record — so this
  document exists in an undefined format inside a system whose guiding
  statement forbids exactly that. Options: define the type, or rule
  that the chain review's review-record carries the material and the
  run produces no separate file.
- F2: no rule routes a keeper whose content sits at a different scope
  than the approved target set. The actions-row directive could not be
  executed as written (D1); routing the mass to chain-review items was
  this run's judgment call, not the chain's.
- F3: the chain requires a `judged-by` seat but offers no rule for
  choosing between reusing a role defined for another target type and
  defining a new one; prefer-reuse came from the run's dispatch, not
  from a chain document (CR5).
- F4: two authorities over how a principle set comes to be (typedef
  "Produced by" vs the new process) until CR4 lands.
- F5: `derives-from` lineage direction between peer-scope analogs
  (keeper P4 vs `least-context`) is undefined — the typedef defines the
  field but not which set declares it when both rules stand.
- F6: the in-document fitness screen and the external fitness set are
  two homes for the same tests — a `single-source-of-truth` tension the
  chain inherits from the typedef. This run resolved it as: the screen
  is the author's self-check, the fitness set is the judge's rubric,
  and fitness scenario 5 audits the screen against the text. The
  authority approves this split or restructures it.
- F7: the run had no registry work-item id in view at this seat, so no
  review-record could be opened (its frontmatter requires `work-item`)
  and no beads could be filed for CR items; filing is left to the
  router at reconciliation.
