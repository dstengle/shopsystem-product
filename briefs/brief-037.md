---
type: decision-brief
id: brief-037
status: draft
date: 2026-09-06
reader: product-authority
decisions-requested: 3
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
version: 1
---

# Brief 037: roles own their decisions — delivered on step prompts alone; three decisions

Yesterday you ruled that every role must offer complete information
on the decisions it owns, as part of the role and not by instruction
from the lead-pm (the product manager's role: yours, agent-assisted).
Today you bet on the initiative — the record of one problem worth
solving, which you commit a bound of time to — that carries that
ruling, and the flow after the bet (order, feature, assignment,
build) ran with every role given only its step's own prompt. Did it
work, and what now? It did: all four role definitions now name the
decisions they own (4 of 4), and two of the four roles have already
offered unasked, observed (2 of 4; the other two are observed at
their next steps). Confirm the approvals your bet carried (Ask 1),
authorize the one small change that completes the design (Ask 2), and
answer the two routes still owed (Ask 3). The day's other work is
below the asks, informational.

**What was built.** Before you bet, two roles *attach* to the
initiative: the solutions architect role writes its feasibility, the
product designer role its usability evidence. An *attachment* is
what a role writes there; the role's *offer* is the information it
carries — a verdict with reasons, the decisions the bet depends on,
the risks to the measure (the one number the initiative is judged
by), what the role does not know, and the evidence it read. Until
today that shape lived in prompts and in the lead-pm's hand-written
instructions. Now: one data type, `role-offer`, holds the five parts,
and each attach step outputs it from a one-sentence prompt; the
role-definition typedef — the definition of what a role definition
must contain — requires a Decisions owned section, and all four
lead-shop roles carry one; the initiative's check judges each
attachment by the five parts, by name. Every file the agents load is
current with its definition.

**What gates and what defaults.** Ask 1 confirms decisions already
taken; on silence it stands. Asks 2 and 3 gate work; on silence the
route in Ask 2 is filed as a note with no work, and each request in
Ask 3 stays recorded.

**Ask 1 — confirm the approvals taken on your bet.** Your bet of
2026-09-06 ("bet for init-role-decisions") was the authority for
eleven definition changes with you absent, all owned by you and all
made by the architect role: the `role-offer` data type (new); the
role-definition typedef and its fitness set (the scenarios a checker
scores against); the four role definitions (the PM, PO, architect, and
designer roles); the initiative-check process, whose two attach
prompts are now one sentence each; and the initiative typedef with
its fitness set and guideline. Versions in the annex; each history
row says the owner's approval is pending. Evidence: the lint — the
script that checks every definition — passes; the role-rendering
check reads ok for all four roles; the skill-rendering check is
clean, run under bash (see the note below); the initiative fitness
set's scenario 5 names the five parts, so a missing part is a finding
by name. Accepted tradeoff: the feature's eighth scenario — each role
offers at its own step — is not yet demonstrated for the PM and PO
roles; the 2 of 4 observed are the architect and designer, before the
definitions changed, and count as the baseline. What a no does: the
type is now referenced by four roles, a fitness set, and the process,
so reversal means re-pointing each and re-rendering, by a later
record; until then the definitions stand. Recommendation: confirm.
*Default:* stands.

**Ask 2 — authorize the pre-bet route, or file it.** Shall the
initiative check gain one route — for each decision in an offer whose
record reads "none", send it to decision-record authoring before the
screen (the fresh-context judge's scoring of the initiative against
its fitness set) — as the next change through the lane, the
small-change path: defined, made, checked, verified, no bet? Today
the lead-pm does this by hand: yesterday it sent the architect's
first such decision to an ADR (architecture decision record) before
your bet. That ADR, `adr-2026-09-05-role-offer`, names this route
the third of three candidates it left undecided — bounded,
reversible, a process amendment — and this build left it out as
bounded. Evidence: the offer's decisions field carries a record id or
the literal "none" so a step can branch on it; the initiative's
outcome — no bet rests on an unrecorded decision — depends on this
route or on the lead-pm's hand; today's first lane ran define 2
minutes, make 5, check and verify under 1, and the second, with one
repair, 7 minutes define to done by commit times. *File it:* a
request recorded, no work; the guarantee stays manual.
Recommendation: authorize. *Default:* filed.

**Ask 3 — answer the two routes owed.** For each, the lead-pm has
said a route; nothing is acted on until you accept or object.

- Status said plainly (`req-2026-09-06-plain-status`) → the lane: one
  rule in the base writing style — when work waits, say what it waits
  on and on whom, never a shorthand. Why a definition: the transcript
  is not loaded by a later session; the guideline is.
- Communication between steps and agents in the most effective format
  (`req-2026-09-05-step-communication`) → discovery, a conversation
  with you that frames an initiative: how an agent's instruction is
  assembled, across every process. It waited on the typedef
  renderings, yesterday's delivery, in since 2026-09-05.

Recommendation: accept both. *Default:* each stays recorded, nothing
acted on.

**Also today — informational.** The implementation guidance artifact
— the architect's notes to an implementer, one per Bounded Context,
kept as a historical record — was made through the lane and first
produced at this feature's assignment; the implementer built from the
scenarios and that record alone. The tools-through-skills principle —
every framework tool is used through a skill that states its uses; an
agent prefers the skill; a tool with no skill is recorded as a gap —
was made through the lane after one screen and one repair. Journaling
messages offline is filed as work item lead-j30gv. Your two questions
on the lead-pm's status shorthand are Ask 3's first request.

**Three notes — informational.** The attachments' home: the two
baseline attachments run 668 and 629 words; you ruled the
initiative's 500-word cap soft with 20% variance (600), so neither
fits, and the full offer stands in a history row while the verdict
stands in the section. Where it lands is the ADR's first candidate,
and the ruling is the initiative typedef's owner's, which is you. The
implementer found that the skill-rendering check's script splits
words only under bash; under zsh every skill reads missing. Filed as
work item lead-1qzt0. The words "offer" and "attach" are defined in
the feature's vocabulary, not the glossary; you asked yesterday what
an offer is. Both are glossary candidates, on your word.

**What this run cost.** The flow after the bet — order, bet record,
feature, assignment, build — ran 38 minutes wall-clock from commit
times (17:48 to 18:26), with the principle's lane and one request
intake inside it; the morning's review and the guidance lane ran
15:43 to 15:53. Agent time by step is not in the repository, so no
like-for-like against yesterday's 105 agent minutes. Screens on this
initiative since its discovery: six — initiative, ADR, order, bet
record, feature, principle — each once with one revise, under your
single-cycle rule; the counts per screen are in the annex.

## Deferred (notes, not asks)

- The order of this typedef amendment with brief-030's pending
  amendment to the same typedef is yours as owner.
- The designer's recommendation to screen the type's field names is
  pending, a recommendation.
- The finding kept open at the bet — the architect's one-session
  verdict resting on an undescribed precedent — is answered by the
  run: delivery landed in one session.
- The initiative stands `active`; the `completed` state is still a
  pending amendment. The operational contract gap (lead-4kymc) is
  unchanged.

## Annex

Optional: [annex-037](annex-037.md) — the artifacts with versions,
the Decisions owned sections quoted, the attach prompt, the screens
with their counts, the flow's timeline, the two lanes, the ADR's three
candidates, the requests, and this brief's cold read.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Composed by the lead-pm role's assisting agent from the session's records at the stakeholder-presentation frame and compose steps, for the authority's confirmation of the approvals its bet carried, the pre-bet route's authorization, and the two route answers owed. |
| 1 | 2026-09-06 | review | Cold read by the composing agent in the same context, not a fresh one — disclosed; the process's fresh-context cold reviewer has not run (judge: claude-fable-5-1). Verdict findings: the decision layer at 448 words; "the whole flow" unnamed; "did it hold" ambiguous; the day's other work in the decision layer with "tools-through-skills" unglossed; Ask 1 counting nine changes where the list holds eleven; the skill-rendering check called clean without its shell; "uncovered"; "the design decision" before the ADR's introduction; "screen" never glossed; "guidance record" reaching Ask 2 unintroduced; a lane timing claimed for both lanes where one is recorded; "your — ruling"; "held" in two senses in one note; "filed" unexplained in the gate paragraph. All repaired in this version before it was recorded: the other work moved below the asks as informational and glossed; the count corrected; the shell stated; the glosses added; the second lane timed by commit; the decision layer at 377 words. |
