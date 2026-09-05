---
type: decision-brief
id: brief-036
status: draft
date: 2026-09-05
reader: product-authority
decisions-requested: 2
annex: annex-036.md
relates-to:
  - initiatives/init-typedef-rendering.md
  - features/feat-typedef-rendering.md
  - decisions/adr-2026-09-05-typedef-rendering.md
  - decisions/pdr-2026-09-05-bet-typedef-rendering.md
  - requests/req-2026-09-05-typedef-rendering.md
version: 1
---

# Brief 036: typedef rendering delivered — the proof stands; two decisions

This morning you found yesterday's run cost too much for what it
built: 136 minutes of agent time, 70 in review cycles, 20 screen
rounds on 8 artifacts. You converged on one fix first, typedef
rendering, made it a request, and bet on it today ("Bet"). The proof had to be the bet's own decision record, made and
checked from one standard, in the same session that built the
standard. Did it work, and what now? It worked: the
initiative's measure — artifact types whose maker and checker work
from one standard — moved from 0 to 1 of 22. Confirm the approvals
taken on your direction (Ask 1) and say whether the other 21 types
get framed for your second bet (Ask 2).

**What was built.** A typedef is the definition of an artifact type —
what a decision record or a feature must contain. Until today a type's
standard lived in three hand-written documents: the typedef, a
guideline (the writing rules its maker reads), and a fitness set (the
test scenarios its checker scores against). Now the typedef alone is
hand-edited; it carries the rules and the scenarios as sections. A
compiler, the script `compile_typedef.py`, produces both from it and
stamps each with a source digest — twelve characters of the typedef's
hash, tying a produced document to the exact typedef it came from. A
rendering process, `typedef-rendering`, checks that every produced
document is current and re-produces any that is not; its first run
found the one converted type current. No check changed: each reads
the path it always read.

**The proof.** The PO role, the lead shop's product owner, made the
decision record for this bet from the produced guideline. Before
submitting, the author ran the produced fitness set's five scenarios
on the draft: five of five. The check then screened the record from
the produced fitness set — three rounds by a fresh-context judge, no
confident finding (a defect the judge is sure of) — and the judge's
report names the same source digest the maker wrote from,
`d2e74320dabb`. Maker and checker worked from one standard, each once.

**What gates and what defaults.** Ask 1 confirms decisions already
taken; on silence it stands. Ask 2 gates work: nothing is drafted until
you say so; on silence the batch stays a note.

**Ask 1 — confirm the approvals taken on your direction.** Three
things were approved on "Get this started" with you absent. The
`typedef-rendering` process, approved at v4 after three screen rounds.
Four typedef amendments, made by the solutions architect role (the
shop's tool maintainer): the artifact-typedef typedef (v3) admits the
two new sections and names the guideline and fitness set as produced
documents; the quality-guideline typedef (v5) and the fitness-set
typedef (v3) each admit a produced document marked as generated, naming its
source and digest, and carrying no version or history of its own; the
product-decision-record typedef (v7) folds in its guideline (v2) and
fitness set (v3), whose own histories end there. The compiler, with a
`--check` mode that compares what stands with a fresh production.
Evidence, run before this delivery from the repository root: the
compiler's check on the converted type reports no difference; the
typedef's digest recomputes to `d2e74320dabb`; the lint — the script
that checks every definition in the tree — passes; and the process's
rendered skill (the file an agent loads to run it) is one of 22 the
runtime lists. Cost, stated plainly: two of the feature's seven
scenarios — a standard changed after production, and a hand edit of a
produced document — were not demonstrated by a run this session; the
compiler's check and the process's screen carry them. Confirmation
binds the definitions at these versions. Recommendation: confirm.
*Default:* stands.

**Ask 2 — authorize the batch to be framed for your second bet.**
Shall the PO role draft the batch of the other 21 types as this
initiative's second feature, for your bet through the initiative check — the process that
screens an initiative and ends in your go or no-go? Recommendation:
yes, now. Evidence: the initiative's Appetite (the time you bet) names
the batch as a second bet sized after the proof, and the proof is in;
12 of the 22 typedefs have no guideline or fitness set today, so the
batch must decide what those produce — the first of four open
questions in the ADR, the architecture decision record behind this
design; and the ADR rates the decision reversible at low cost while
one type is converted and hard after the batch, so this is the last
cheap point to stop. *Default:* a note in the initiative; no work.

**What this run cost, measured.** 16 screen rounds on 6 artifacts,
against 20 on 8 last time — 2.7 rounds per artifact, unchanged.
Makers checked their own draft against the fitness set before the
screen on 5 of the 6. That cut confident findings on the three the PO
made — the backlog order, the feature, the decision record — to 4
across 7 rounds, none on the order; but it did not cut rounds:
wobbly findings, ones the judge could not settle either way, carried
5 of the 6 artifacts to the cap of three rounds. So you cut the
rounds: "a single review cycle." That ruling is recorded as a request,
accepted for the small-change lane (the path for a simple change:
defined, made, checked, verified, no bet), defined by the PO, and
applied as practice at once. It changed no number here — it arrived
during the last screen.

**Informational — no ask.** Six requests from the run review stand
routed and await your answer — accept or object — to the route the
lead-pm role said (the product manager's role: yours, agent-assisted).
Step-communication and feasibility-defined to discovery, a
conversation with you that frames an initiative; no-tools-mid-process,
banned-words-inlined, and maker-self-check to the lane;
single-review-cycle accepted and in the lane. The ADR's four open
questions are in the annex.

## Deferred (notes, not asks)

- The produced guideline and fitness set carry the typedef's version
  (7) and dates in their frontmatter without saying they are the
  typedef's; the typedefs say so, the produced files do not. A
  follow-on, to be recorded as a request.
- The initiative stands `active` with its measure met; the
  `completed` state is still a pending amendment.
- This initiative's request entered through the lead shop's operational contract,
  which has no artifact yet (work item `lead-4kymc`); the discovery on
  that gap, a separate request, is parked.

## Annex

Optional: [annex-036](annex-036.md) — the artifacts with versions,
screen rounds per artifact with judge stamps and confident counts, the
proof's evidence quoted, the process run and today's re-checks, the
cost figures, every ruling the lead-pm role made, the six requests,
and the ADR's four questions.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Composed by the lead-pm role's assisting agent from the session's records at the stakeholder-presentation frame and compose steps, for the authority's confirmation of the approvals and the second-bet authorization. |
