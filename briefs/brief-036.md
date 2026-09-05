---
type: decision-brief
id: brief-036
status: delivered
date: 2026-09-05
reader: product-authority
decisions-requested: 3
annex: annex-036.md
relates-to:
  - initiatives/init-typedef-rendering.md
  - features/feat-typedef-rendering.md
  - decisions/adr-2026-09-05-typedef-rendering.md
  - decisions/pdr-2026-09-05-bet-typedef-rendering.md
  - requests/req-2026-09-05-typedef-rendering.md
version: 2
---

# Brief 036: typedef rendering delivered — the proof stands; three decisions

This morning you found yesterday's run cost too much for what it
built (136 minutes of agent time). You converged on one fix first —
every artifact type's maker and checker working from one standard,
its typedef — and bet on it today. The proof: the bet's own decision
record, made and checked from that standard in the session that built
it. Did it work, and what now? It worked: the initiative's measure —
types whose maker and checker work from one standard, each having
used it once — is 1 of 22, from 0. Confirm the approvals (Ask 1),
decide the batch of the other 21 types (Ask 2), and answer the five
routes waiting on you (Ask 3). Your sixth ask today — one review cycle
for every process — is done; this brief is the first delivered under
it.

**What was built.** A typedef is the definition of an artifact type —
what a decision record or a feature must contain. Until today a type's
standard was three hand-written documents: the typedef, a guideline
(the writing rules its maker reads), and a fitness set (the test
scenarios its checker scores against). Now only the typedef is
hand-edited; it carries the rules and scenarios as sections. A compiler, the script `compile_typedef.py`,
produces both from it and stamps each with a source digest — twelve
characters of the typedef's hash that tie a produced document to its
exact source. A rendering process, `typedef-rendering`, re-produces
any produced document that is not current; its first run found the
one converted type current. The checks that read a guideline or a
fitness set read the same paths as before.

**The proof.** The PO role, the lead shop's product owner, made the
decision record for this bet from the produced guideline. Before
submitting, the author ran the produced fitness set's five scenarios
on the draft: five of five. The check — a fresh-context judge scoring
against the produced fitness set — found no confident finding (a
defect the judge is sure of) in three rounds, and its report names
the source digest the maker wrote from, `d2e74320dabb`.

**What gates and what defaults.** Ask 1 confirms decisions already
taken; on silence it stands. Asks 2 and 3 gate work; on silence
the batch stays a note and each request stays recorded.

**Ask 1 — confirm the approvals taken on your standing direction.**
Your direction of 2026-09-04 to continue through implementation,
renewed today by "Get this started", was the authority for three
approvals with you absent: one process (`typedef-rendering`, above);
four typedef amendments — the typedef of typedefs now admits the two
sections; the guideline's typedef (type key `quality-guideline`) and
the fitness set's now admit a produced document naming its source and
digest, with no version of its own; the decision record's typedef now carries its rules and
scenarios; and one compiler, with a `--check` mode that compares what
stands with a fresh production. Versions in the annex; all made by
the solutions architect role, the shop's tool maintainer. Evidence:
the proof record is checked — three screen rounds (a screen is the
judge's scoring of an artifact against its fitness set), no confident
finding in any; the third was the cap, the last round the old rule
allowed, and two wobbly glosses (findings the judge could not settle)
were made past it and disclosed. Re-run before this delivery from the
repository root: the compiler's check on the converted type reports
no difference; the typedef's digest recomputes to `d2e74320dabb`; the
lint, the script that checks every definition, passes; the process's
rendered skill (the file an agent loads to run it) is one of the 22
skills the runtime lists. Accepted tradeoff: two of the feature's
seven scenarios — a standard changed after production, and a hand
edit of a produced document — were not demonstrated by a run this
session. The measure counts the maker's and the checker's use, which
happened; those two behaviors are carried by the compiler's check and
the process's screen. Confirmation binds the definitions at these
versions. A no: the definitions stay as they stand until you cancel by
a later decision record, and the produced texts keep serving the
checks. Recommendation: confirm. *Default:* stands.

**Ask 2 — authorize the batch, or stop here.** Shall the PO role
draft the batch of the other 21 artifact types as this initiative's
second feature, for your bet through the initiative check, the
process that screens an initiative and ends in your go or no-go? Two
options. *Draft now:* the initiative's Appetite (the time you bet)
names the batch as a second bet sized after the proof, and the proof
is in; the drafting is one PO step, one screen, and one revise under
the new rule; what the 12 types with no guideline or fitness set today
should produce is the drafter's to propose and yours to decide at the
bet. *Stop here:* the ADR — the architecture decision record behind
this design — rates it reversible at low cost while one type is
converted and hard after the batch, so this is the last cheap point
to stop; one type then keeps the pattern and the other 21 stay
hand-written in up to three places. Recommendation: draft now.
*Default:* a note in the initiative; no work.

**Ask 3 — answer the five routes.** Five requests from this morning's
run review are recorded; for each, the lead-pm role (the product
manager's role: yours, agent-assisted) has said a route, and nothing
is acted on until you accept or object. Discovery is a conversation
with you that frames an initiative; the lane is the small-change path
for a simple change: defined, made, checked, verified, no bet.

- Communication between steps and agents in the most effective
  format → discovery: a design decision across every process, what
  an agent's instruction is assembled from.
- Feasibility defined, with a way for the architect and the designer
  to say which decisions are needed → discovery: it changes the
  initiative's definition and the initiative check.
- Never build tools mid-process → the lane: one rule in the process
  definition's typedef, checked by the lint.
- Prompts name the banned words themselves → the lane: the compiler
  already places text in every prompt; the same mechanism.
- Implementers run their own checks before submitting → the lane: one
  sentence in the define-good-up-front principle.

Recommendation: accept all five. *Default:* each stays recorded, its
route said, nothing acted on.

**What this run cost, like for like.** Agent time about 105 minutes —
first implementation about 53, review cycles about 52 (screens 32,
revises 20) — against last run's 136 (66 and 70). 16 screen rounds on
6 artifacts against 20 on 8: 2.7 rounds per artifact, unchanged. The
maker's own check against the fitness set ran before 5 of the 6
screens; it cut confident findings (the annex has each round's
count), but wobbly findings still carried 5 of the 6 artifacts to the
cap of three rounds. Rounds per artifact did not fall until your
single-cycle ruling, which arrived during the last screen.

## Deferred (notes, not asks)

- The produced guideline and fitness set carry the typedef's version,
  not one of their own, without saying so; the typedefs say it, the
  produced files do not. A follow-on, to be recorded as a request.
- The initiative stands `active` with its measure met; the
  `completed` state is still a pending amendment.
- This initiative's request entered through the lead shop's
  operational contract — the statement of what the lead shop accepts
  and from whom — which has no artifact yet (tracked as `lead-4kymc`);
  the discovery on that gap, a separate request, is parked.
- The ADR's four open questions are in the annex.

## Annex

Optional: [annex-036](annex-036.md) — the artifacts with versions,
screen rounds per artifact with judge stamps and confident counts, the
proof's evidence quoted, the process run and today's re-checks, the
cost figures, every ruling the lead-pm role made, the five requests,
the ADR's four questions, and this brief's cold read.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Composed by the lead-pm role's assisting agent from the session's records at the stakeholder-presentation frame and compose steps, for the authority's confirmation of the approvals and the second-bet authorization. |
| 1 | 2026-09-05 | review | Cold read, the one round the definition allows (judge: claude-fable-5-1, cold-reviewer): findings — Asks 1 and 2 wobbly; overload in Ask 1 and the informational paragraph; Ask 1 without the proof record's outcome, the two undemonstrated scenarios unpriced, no statement of what a no does, a five-document version list, "Get this started" cited as the authority; Ask 2 without "stop here" as an option or the drafting's size; the six requests as information the reader could not act on; the cost paragraph not like for like; stumbles — a dangling "Bet", "one standard" before its introduction, "each reads the path it always read", the two 22s, and screen, cap, run, order, work item, frontmatter, operational contract, the artifact-typedef typedef unglossed. |
| 2 | 2026-09-05 | update | Revised once on the cold read: Ask 1 states the proof record's outcome, marks the two undemonstrated scenarios an accepted tradeoff with its reason, says what a no does, names the standing direction (2026-09-04, renewed by "Get this started"), and sends versions to the annex; the informational paragraph became Ask 3 (the five routes, one line each, default recorded and not acted on), decisions-requested 3, the single-review-cycle change stated done in the answer; Ask 2 presents "stop here" with its case and sizes the drafting; the cost paragraph restated like for like (agent time 105 against 136; 16 rounds on 6 against 20 on 8); every listed term glossed or replaced, the slugs dropped. |
| 2 | 2026-09-05 | state | draft → delivered after the one revise the definition allows; no finding left open. |
