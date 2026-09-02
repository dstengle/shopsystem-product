---
type: decision-brief
id: brief-033
status: delivered
date: 2026-09-02
reader: product-authority
decisions-requested: 4
annex: annex-033.md
version: 5
---

# Brief 033: the adr chain and its exemplar, for your review

**Open findings at the round cap (four cold reads).** Ask 3's rule
is silent on the residual case — with the answer here: the two
rights lists are the roles' definitions read exhaustively (the
architect's five, the PM/PO's four); a decision no listed right
covers is the authority's, records under `right: escalation` in the
type whose deciding side it reaches the authority from, and a
decision exercising rights from both lists is two decisions, split
per the one-decision rule. Ask 1 bundles the `derived-by` removal in
its evidence rather than its question line — read the question as
"do the six links stand, and the removal with them?". Ask 2's
question sentence carries its glosses inline; ask 3's recording
happens at your ruling either way, silent or spoken. *Screen prompt
v1* is the adr screen step's prompt as first versioned today.

**The answer first.** The adr chain is built and lint-clean, and its
exemplar — a real record written through the drafted chain —
screened clean on round 1. The chain is the six linked definitions
of the *adr* type (architecture decision record, the architect-side
counterpart of the product decision record (PDR)): typedef, fitness
set, guideline, authoring process, rendered skill, glossary term.
This is the authority-review step of today's
definition-chain-migration run: four asks; approving them stamps the
chain and meets your migration gate — ADR definitions before
anything is pulled from `main`.

**Ask 1 — approve the chain (gates everything).**
*Question:* do the six links stand?
*Recommendation:* approve. *Evidence:* the form follows your rulings
— Nygard plus required Reversibility, considered options folded into
Context; the check mirrors the PO output check: the architect
authors, a cold screen judges, you rule, with the architecture
principles a named criterion. Approval also ratifies one removal
the keeper autopsy (the read of `main`'s 69 records) motivated: the
new typedef keeps `derives-from` — a record's frontmatter list of
the records its decision builds on — and drops the `derived-by`
reverse list: a hand-maintained reverse index is a second home for
one fact, derivable by search. *Default:* none —
silence holds the chain in draft.

**Ask 2 — pass the exemplar, ruling on the right.**
*Question:* does the exemplar — the record of the shop's standing
CEL choice (*CEL*: the Common Expression Language, every process
definition's declared condition language; the choice stood
unrecorded) — pass, and did the architect role hold the `stack`
decision right it exercised? (A *decision right* is an authority a
role's definition grants; ask 3 lists them.)
*Recommendation:* pass; the right held. *Evidence:* screen clean,
round 1, all criteria confident (judge: claude-fable-5, screen
prompt v1); the approved architect role definition grants it — the
stack is its exclusive domain: "which technologies the product is
built on is decided by this role alone." *Default:* on silence the
record passes and the right stands as exercised.

**Ask 3 — rule the ADR/PDR boundary.**
*Question:* which decisions record as adr, which as product decision
record? (the migration plan assigns this ruling here)
*Recommendation:* the exercised right decides — architect rights
(stack, guardrail, decomposition, contract, non-functional
requirement) → adr; PM/PO rights (framing, bet, ordering, scope) →
product decision record. *Evidence:* both typedefs carry `right` in
frontmatter, so the boundary is checkable at the screen. *Default:*
stands on silence; recorded in both typedefs' histories.

**Ask 4 — name the instances' home.**
*Question:* where do decision-record instances live? Neither typedef
says. *Recommendation:* name `decisions/` (repository root) in both
typedefs at approval. *Evidence:* the one PDR instance already lives
there. *Default:* stands on silence.

(Accepted tradeoff: this layer runs ~440 words against the 400
budget — the glosses the two cold reads demanded are on the page.)

## Support layer (informational — attached to no ask)

`lint_basis.py --derive-chain`, the lint tool's chain report, still
read retired `basis/skills/`; repaired this run to `.claude/skills/`,
the load point skills load from. The rendered adr-authoring skill is
draft-sourced until ask 1 lands. *Deferrals:* the 87-keeper rewrite
(Phase 3); retiring `main`'s generated write-adr skill (cut-over).

Annex: [annex-033.md](annex-033.md) — the six links, the exemplar,
the screen review, and the friction log.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Composed for the adr chain's authority-review step (definition-chain-migration run of 2026-09-02). |
| 1 | 2026-09-02 | review | Cold read round 1 (claude-fable-5): findings — the `derived-by` removal rode unexplained inside ask 1; ask 2's silence default ambiguous; chain links, exemplar, autopsy, Nygard, load point unintroduced; ask 3 missing its question, ask 4 its evidence. |
| 2 | 2026-09-02 | update | Round-1 findings repaired: the removal named as one with its reason; defaults made crisp; links enumerated at first mention; template restored; terms glossed. |
| 2 | 2026-09-02 | review | Cold read round 2 (claude-fable-5): findings — ask 2's rights half unevidenced; the exemplar and the CEL record not named as one; decision right unglossed at first use; ask 1's evidence sentence elliptical; the removed edge's referents unstated. |
| 3 | 2026-09-02 | update | Round-2 findings repaired: the role definition's exclusive-domain grant quoted as ask 2's rights evidence; exemplar named in the ask; decision right glossed; ask 1's evidence unpacked; the edge's carrier and endpoints stated; the derivation tool named in support. |
| 3 | 2026-09-02 | review | Cold read round 3 (claude-fable-5): findings — ask 2's default covered one of its two halves; ask 1's removal sentence attached to the autopsy, not the typedef; the quoted grant's dash garbled mid-quote; PDR unexpanded; opening spine buried. |
| 4 | 2026-09-02 | update | Round-3 findings repaired: ask 2's default covers both halves; the removal attributed to the typedef with the autopsy as motivation; a grammatical span of the grant quoted with the domain named in prose; PDR expanded at first use; the opening leads with the verdict sentence. |
| 4 | 2026-09-02 | review | Cold read round 4 (claude-fable-5): findings — ask 3 silent on a decision outside or across the two rights lists (the one decidability blocker); ask 1's rider not in its question line; ask 2's question syntactically overloaded; screen prompt v1 and the run vocabulary unintroduced. |
| 5 | 2026-09-02 | state | Failsafe exit at the round cap: delivered with the open findings stated at the top, ask 3's residual answered inline there. Round log: findings / findings / findings / findings, all rounds judged by claude-fable-5. |
| 5 | 2026-09-02 | state | The authority's rulings received: asks 1–3 as recommended (chain approved with the derived-by removal; exemplar passes, the stack right held; the exercised right decides the boundary); ask 4 ruled after discussion — one shared `decisions/` home, separate directories weighed near-cosmetic with a per-audience publication boundary as the revisit trigger. Applied to the affected definitions. |
