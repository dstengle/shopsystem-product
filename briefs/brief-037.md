---
type: decision-brief
id: brief-037
status: delivered
date: 2026-09-06
reader: product-authority
decisions-requested: 4
annex: annex-037.md
relates-to:
  - initiatives/init-role-decisions.md
  - features/feat-role-decisions.md
  - decisions/adr-2026-09-05-role-offer.md
  - decisions/pdr-2026-09-06-bet-role-decisions.md
  - guidance/feat-role-decisions-shopsystem-product.md
  - requests/req-2026-09-06-implementation-guidance.md
  - requests/req-2026-09-06-tools-through-skills.md
  - requests/req-2026-09-06-plain-status.md
version: 2
---

# Brief 037: roles own their decisions delivered; four decisions

Yesterday you ruled that every role must offer complete information
on the decisions it owns, as part of the role and not by instruction
from the lead-pm (your role, agent-assisted).
Today you bet on the initiative — the record of one problem worth
solving, which you commit a bound of time to — that carries that
ruling, and the flow after the bet (order, feature, assignment,
build) ran with every role given only its step's own prompt. What did
it demonstrate; what now? Every role definition names the
decisions it owns (4 of 4), and the attach steps now run from
one-sentence prompts and output a typed offer; no role is yet
observed offering under the changed definitions — the two offers
observed are the pre-change baseline, read next at the initiative
check, frame, and feature draft. Confirm the approvals your bet
carried (1), authorize the change that completes the design (2),
answer two routes owed (3), rule where an oversized attachment lives
(4).

**What was built.** Before you bet, two roles *attach* to the
initiative: the architect writes its feasibility, the designer its
usability evidence. An *attachment* is what a role writes there; the
role's *offer* is the information it carries — a verdict with reasons,
the decisions the bet depends on, the risks to the measure (the
initiative's one judged number), what the role does not know, and the
evidence it read. Now one data type, `role-offer`, holds the five
parts, and each attach step outputs it from a one-sentence prompt; the
role-definition typedef (what a role definition must contain) requires
a Decisions owned section, which all four roles carry; the initiative's
check judges each attachment by the five parts, by name.

**Four terms.** A *fitness set* is the scenarios a checker scores an
artifact against. A *screen* is a fresh-context judge's scoring of an
artifact against its fitness set. A *route* is the lead-pm's proposed
handling of a request: discovery (a conversation with you that frames
an initiative), the lane, or decline. The *lane* is the small-change
path: defined, made, checked, verified, no bet.

**What gates and what defaults.** Asks 1 and 4 confirm rulings in
force; on silence each stands. Asks 2 and 3 gate work; on silence Ask
2's branch is filed as a note, no work, and Ask 3's requests stay
recorded.

**Ask 1 — confirm the approvals taken on your bet.** Your bet of
2026-09-06 ("bet for init-role-decisions") was the authority for
eleven definition changes with you absent — one type, one typedef and
its fitness set, four roles, one process, one typedef with its
fitness set and guideline — all owned by you, all made by the
architect role, each pending your approval and in force until you
cancel. The type is `role-offer`; the typedefs are the
role-definition typedef and the initiative typedef; the process is
initiative-check, whose two attach prompts are now one sentence each.
Versions in the annex. Evidence: the lint — the script that checks
every definition — passes; the rendering checks report every skill
and role current with its definition, the skill check when run under
bash — its script splits words only under that shell, and under zsh every
skill reads missing, a defect the implementer found and filed as
lead-1qzt0 (an item in the shop's work register); the initiative
fitness set's scenario 5 names the five parts, so a missing part is a
finding by name. Accepted tradeoff: the feature's eighth scenario —
each role offers at its own step — is not demonstrated for any role
under the changed definitions; the definitions are delivered, the
observations are not. What a no does: the type is now referenced by
four roles, a fitness set, and the process, so reversal means
re-pointing each and re-rendering, by a later record; until then the
definitions stand. Recommendation: confirm. *Default:* stands.

**Ask 2 — authorize the pre-bet branch, or file it.** The initiative
check would gain one branch: for each decision in an offer whose
record reads "none", send it to decision-record authoring before the
screen. Shall that branch be made as the next change through the
lane? Today the lead-pm does this by hand: yesterday it sent the
architect's first such decision to an ADR (architecture decision
record) before your bet. That ADR, `adr-2026-09-05-role-offer`,
listed the branch as a reversible process change, and this build did
not include it. Evidence: the offer's decisions field carries a
record id or the literal "none" so a step can branch on it; the
initiative's outcome — no bet rests on an unrecorded decision —
depends on this branch or on the lead-pm's hand; today's first lane
ran define 2 minutes, make 5, check and verify under 1, and the
second, with one repair, 7 minutes define to done by commit times.
*File it:* a request recorded, no work; the guarantee stays manual.
Recommendation: authorize. *Default:* filed.

**Ask 3 — answer the two routes owed.** For each, the lead-pm has
said a route; nothing is acted on until you accept or object.

- Status said plainly (`req-2026-09-06-plain-status`), from your two
  questions — "What is meant by nothing else is independent?" and
  "How will you know to say that from here after the session ends?"
  — → the lane: one rule in the base writing style — when work waits,
  say what it waits on and on whom, never a shorthand. Why a
  definition: the transcript is not loaded by a later session; the
  guideline is.
- Communication between steps and agents in the most effective format
  (`req-2026-09-05-step-communication`) → discovery. The problem
  observed: in the request-routing run, the lead-pm's prose
  instructions to agents carried design errors, found at that run's
  review. What it costs you: one interview. Why now: it depends on
  the typedef renderings, yesterday's delivery, waiting since
  2026-09-05.

Recommendation: accept both. *Default:* each stays recorded, nothing
acted on.

**Ask 4 — where does an attachment larger than the cap live?** At the
bet you ruled the initiative's 500-word cap soft with 20 percent
variance (600); the two baseline attachments run 668 and 629 words,
so each exceeds even that on its own. The ADR names this its first
open candidate; the ruling is the initiative typedef's owner's, which
is you. Recommendation: the full attachment stands outside the cap,
in the attaching role's history entry as now, with the verdict in the
section. Splitting the cap instead would need a number for the
attachments and a screen criterion for it. *Default:* stands as now.

**Also today — informational,** one line each; the annex has the
rest. The implementation guidance artifact — the architect's notes to
an implementer, one per Bounded Context, a historical record — was
made through the lane, this feature's assignment produced the first
record, and the implementer built from the scenarios and that record
alone. The tools-through-skills principle — every framework tool is
used through a skill that states its uses — was made through the lane
after one screen and one repair. Journaling messages offline is filed
as lead-j30gv.

**What this run cost.** The flow after the bet — order, bet record,
feature, assignment, build — ran 38 minutes wall-clock from commit
times (17:48 to 18:26), with the principle's lane and one request
intake inside it. Agent time by step is not in the repository, so no
like-for-like against yesterday's 105 agent minutes. Every screen on
this initiative ran once with one revise, under your single-cycle
rule; the counts are in the annex.

## Deferred (notes, not asks)

- "Offer" and "attach" are defined in the feature's vocabulary, not
  the glossary; you asked yesterday what an offer is. Not asked
  today; the PO's, at the next glossary amendment.
- The designer's recommendation to screen the type's field names is
  pending, a recommendation.
- The finding kept open at the bet — the architect's one-session
  verdict resting on an undescribed precedent — is answered by the
  run: delivery landed in one session.
- The initiative stands `active`; the `completed` state is still a
  pending amendment.

## Annex

Optional: [annex-037](annex-037.md) — the artifacts with versions,
the Decisions owned sections quoted, the attach prompt, the screens
with their counts, the flow's timeline, the two lanes, the ADR's three
candidates, the requests, the notes, and this brief's cold read.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Composed by the lead-pm role's assisting agent from the session's records at the stakeholder-presentation frame and compose steps, after the agent's own read against the guidelines (the decision layer cut from 448 to 377 words, glosses added, a count corrected). |
| 1 | 2026-09-06 | review | Cold read, the one round the definition allows (judge: claude-fable-5-1, cold-reviewer, fresh context): findings — Ask 1 wobbly (the 2 of 4 read as today's result where it is the pre-change baseline; the eleven changes listed as types, not counted; the shell caveat apart from the evidence it qualifies); Ask 2 wobbly (one sentence carrying the branch and its path; "left it out as bounded"); Ask 3 half confident, half cannot-decide (the second request without the problem observed, its cost, or why now; the status questions unquoted); over-sized; the attachment's home and the glossary candidacy as decisions hidden in notes; route, lane, screen, and fitness set unintroduced before the gate paragraph; "It did" unqualified and a tense slip; work-item ids and "the operational contract gap" unglossed. |
| 2 | 2026-09-06 | update | Revised once on the cold read: the opener states what the run demonstrated and that no role is yet observed under the changed definitions; Ask 4 added (the attachment's home; recommendation the full attachment outside the cap in the history entry as now), decisions-requested 4; the four terms introduced before the gate paragraph; the eleven changes counted, "pending your approval, in force until you cancel"; the shell caveat moved beside the skill-rendering evidence and lead-1qzt0 glossed; Ask 2's question in two sentences and the ADR's listing restated; Ask 3's second request given the problem observed, the cost, and why now, the status questions quoted; the other work cut to one line each and the screen count, the amendment-ordering note, and the rest sent to the annex; the glossary candidacy a deferral in the words given; the operational contract gap cut. |
| 2 | 2026-09-06 | state | draft → delivered after the one revise the definition allows; no finding left open. |
