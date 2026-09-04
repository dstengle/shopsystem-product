---
type: decision-brief
id: brief-035
status: draft
date: 2026-09-04
reader: product-authority
decisions-requested: 5
annex: annex-035.md
relates-to:
  - initiatives/init-request-routing.md
  - features/feat-request-routing.md
  - decisions/adr-2026-09-04-request-front-end.md
  - decisions/pdr-2026-09-04-bet-request-routing.md
  - requests/req-2026-09-04-brief-relates-to.md
  - requests/req-2026-09-04-operational-contract.md
version: 4
---

# Brief 035: request routing and the small-change lane delivered, for your ratification

You directed today that the shop "continue all the way through
implementation" of `init-request-routing` — the initiative that makes
every ask brought to the lead shop a recorded request with a decided
route, and gives a simple change a lane past the bet — and that the
architect produce its design record. It ran from the bet to a
verified result in one session; you were absent at every decision
reserved for you: the bet, two process approvals, seven amendments
(five definitions, the glossary, and the lint), and the originator's
answers at two steps of the first intake run — the originator being
whoever brings an ask; you, here. Do those stand, and how should one
architecture principle the design cannot fully satisfy yet be
carried? Recommendation: ratify Asks 1–4, route one new request
(Ask 5).

**The answer.** The measure is met — simple changes verified through
a recorded, routed request: from 0 to 1. A request is the record
every ask now gets on arrival; the lead-pm routes it to a discovery
conversation (the ask is large enough to frame an initiative and bet
on), the small-change lane (a simple change the lead shop makes
within its own definitions, defined up front, checked by a different
role, verified in the running system, no bet), or declined, on your
ruling (the record survives). Your example is
`req-2026-09-04-brief-relates-to`: routed to the lane, defined, made,
checked, verified by the lint (the script that checks the
repository's definitions) with exit 0, done; the `relates-to` field
this brief carries is that change working. The door is the
`request-intake` process and the lane the `small-change` process;
both are approved, rendered into `.claude/skills/`, the directory
the agent runtime loads skills from, and the runtime listed them in a
session. One lint defect the first run exposed was repaired the
same run (Ask 2); the lead-pm re-ran the lint over the tree before
delivery: PASS, 0 violations. Everything named here is committed and
pushed.

**What gates and what defaults.** Asks 1–4 ratify decisions already
recorded on your direction; each resolves on silence as "stands" and
can be reversed by a cancellation — a later decision record under the
same right as the original, `bet`.
Ask 5 gates work: the request is recorded and waits for your route;
on silence it stays awaiting.

**Ask 1 — ratify the bet on `init-request-routing`.** The bet — your
commitment of one working session of the lead shop to the problem —
was taken at the round cap of the cold screen (a fresh-context judge
scoring the initiative against its fitness scenarios; three rounds is
the cap). No finding in any round was confident — a defect the judge
was sure of. Three at the cap were wobbly — findings the judge could
not settle either way — all under the screen's scenario 4, the rule
that the initiative's Framing section names no solution. One, whether
an operational contract with no artifact counts as the contract the
Framing names, was repaired to the judge's own wording after the cap
and disclosed; it is the same gap Asks 4 and 5 point at. Two were
held: the no-go question — whether listing something an initiative
will not do counts as naming a structure the Framing must not name,
which scenario 4 does not answer and is filed for you in that
scenario's own history — and whether the three routes in the outcome
are an outcome or a mechanism, held because they are your own
decision from the discovery. Ratifying binds this bet only; the no-go
question stays yours. Recommendation: ratify. *Default:* stands.

**Ask 2 — ratify the approvals taken on your direction.** Two
process definitions, `request-intake` and `small-change`, each
approved at its screen cap with post-cap repairs disclosed (rounds
and findings in the annex). Seven amendments: five definitions — the
request typedef (a typedef is the definition of an artifact type; v3,
a received ask admitted), the discovery-conversation process (v11,
it accepts a request), the initiative typedef (v10, a request link),
the feature typedef (v12, a `small` size), the decision-brief typedef
(v4, `relates-to`) — the glossary (v21, five terms), and the lint (a
request check and the brief check; the request check mis-parsed the
lane's link on the request and was repaired the same run). The two
processes were rendered to the load point, and the skill-rendering
check confirmed the renderings current. Approval binds the
definitions at these versions.

Two post-cap repairs change behavior, both in `request-intake`. At
its observe step — where the originator hears the route the lead-pm
said — the originator may object; each objection is answered by a
re-decision; after three the route stands and the objection is
recorded. First repair, that cap: every loop in this shop declares an
exit, so at the cap the route stands, the objection is recorded on
the request, and the originator is told to bring the question to you.
The honest cost: the process does not yet distinguish you, as
originator, from any other, so at the cap your own objection would be
recorded rather than ruled. That gap is filed today as `lead-2ivie` —
an objection by the authority as originator is a ruling, not an
objection subject to the cap — to be repaired through the lane; until
then the lead-pm treats your objection as a ruling by practice. Cost
if wrong: your objection recorded instead of ruled, for one run.
Second repair, the not-simple return: when the lane finds a change
not simple, the lead-pm decides the route again from the request and
names a topic — a one-line topic for the discovery, from the
request's words — before any discovery opens. Cost if wrong: one
misrouted run, put before you at that run's observe step.
Recommendation: ratify. *Default:* stands.

**Ask 3 — ratify the first intake run's answers.** The intake
process requires the originator's own yes at its confirm step and an
answer to the route at its observe step; this run had neither, because
you had left after converging and your direction said to continue. The
lead-pm read the direction as both answers and disclosed it on the
request. Recommendation: ratify for this run only, no precedent — the
next run asks you fresh at each step. *Default:* stands, for this run
only.

**Ask 4 — ratify where the exception is recorded.**
`intent-provenance` is the architecture principle that whoever accepts
intent records it at the contract it entered through. The ADR (the
architecture decision record, `adr-2026-09-04-request-front-end`)
names it as the one principle the design cannot satisfy today: the
request records intent at entry, but the lead shop's operational
contract — the statement of what the lead shop accepts and from whom
— has no artifact on this branch. The lead-pm's ruling, open to your
objection: the exception is recorded in the ADR and stands there
until that artifact names the request as its entry record;
`lead-4kymc`, the item in the work register (the tracker of work in
motion), is only the pointer, not the exception's home.
Recommendation: ratify. *Default:* stands.

**Ask 5 — route the request for the operational-contract artifact.**
Recorded as `req-2026-09-04-operational-contract`: an artifact
stating the contract through which intent enters the lead shop and
naming the request as its entry record. Its originator is the
lead-solutions-architect role — the ask arose inside the ADR's
authoring run, and the record's own closing note was the
confirmation. The lead-pm has said its route, discovery, not the
lane, and your answer is awaited: a contract stating what the lead
shop accepts and from whom is framing-level — it decides what the
shop takes in — larger than a simple change within existing
definitions, and the lane would return it as not simple. If you
route it to the lane instead, the lead-po role defines the change and
the architect makes it. Recommendation: route to discovery.
*Default:* awaiting — recorded, the route said, nothing acted on.

## Deferred (notes, not asks)

- Filed this session as work-register items, not framed:
  `lead-1d0eo` (a governed home for settings that belong to this
  installation, not the product), `lead-izfpk` (backlog ordering to
  cover all open work, not only planned initiatives), `lead-vx02q`
  (converting the register's open items into requests — a scale note,
  not an ask: 217 open items), `lead-ghulb` (the Framing refined with
  you), `lead-g5tu9` (the session-handoff definition's push line
  omits the credential tool this environment requires; this
  delivery's push used it).
- The initiative's `completed` state is still a pending amendment;
  `init-roles-availability` and `init-request-routing` stand `active`
  with their measures met.
- Asks 1 and 2 of brief-034 — ratifying the roles-availability bet
  and the role-rendering process approval — still stand on silence.

## Annex

Optional: [annex-035](annex-035.md) — the artifacts, screen rounds
per artifact with judge stamps, run outputs, the request's Result
section quoted, and every ruling the lead-pm made in your absence.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Composed by the lead-pm from the session's records for the authority's ratification. |
| 2 | 2026-09-04 | review | Cold read round 1 (judge: claude-fable-5-1, cold-reviewer): findings — Ask 3 confident, Asks 1 and 4 wobbly, Ask 2 cannot-decide; overload in Asks 1 and 2; the three routes never named; "originator", "cancellation", "work item", "the lane's definer" unintroduced; the wobbly gloss equated with cannot-decide; the no-go question stated twice; Ask 2's round counts and rendering-gate sentence; Ask 4's carrier ruling not stated as a fact to object to. |
| 2 | 2026-09-04 | update | Revised on cold read round 1: the three routes named once in the answer with the measure in one line; originator, cancellation, work item, and the lead-po as the lane's definer introduced; Ask 1's wobbly gloss corrected and the no-go question explained in one sentence, removed from Deferred; Ask 2's round counts moved to the annex, the two behavior repairs and the check 9 repair stated plainly, the rendering-gate sentence replaced by the skill-rendering check result; Ask 3's pointer cut; Ask 4 retitled as the authorization, the carrier ruling stated as the lead-pm's, the author and content of the artifact named; the two active initiatives and brief-034's asks named in Deferred. |
| 3 | 2026-09-04 | review | Cold read round 2 (judge: claude-fable-5-1, cold-reviewer): findings — Asks 1 and 3 confident, Asks 2 and 4 wobbly, overload slightly over in Ask 2; the objection cap without its reason or honest cost; Ask 4 bundling a ruling and an authorization; numbers and referents unreconciled (seven amendments, the measure's count, "21 approved", "the fitness question", "the same right", "design exception", "topic", "it" in Ask 4, the 217 figure, "typedef", three Deferred terms). |
| 3 | 2026-09-04 | update | Revised on cold read round 2, on the lead-pm's rulings: Ask 2's objection cap given its own paragraph with the loop-exit reason, the authority-as-originator gap filed as lead-2ivie and the practice until it is repaired, cost if wrong restated; Ask 4 split — the carrier ruling (Ask 4, default stands) and routing the operational-contract request (Ask 5: recorded on delivery as req-2026-09-04-operational-contract, recommendation discovery, default route awaiting), decisions-requested 5; numbers and referents reconciled and the listed terms glossed or dropped. |
| 4 | 2026-09-04 | review | Cold read round 3 (judge: claude-fable-5-1, cold-reviewer): findings — Asks 1, 3, 4, 5 confident, Ask 2 wobbly, overload slightly over in Ask 2; the objection loop unintroduced before its cap and the two repairs out of order; check-9 mechanics in the ask; "carrier", "bet right", "observe step", "work register", "the criterion", "initiative fitness set", "the Framing", "check 10" at first use; the contract finding's link to Asks 4 and 5 unstated; commit and push state unstated; defaults not in one form. |
| 4 | 2026-09-04 | update | Revised on cold read round 3: the objection loop introduced in one sentence, the repairs ordered cap then not-simple, check 9's mechanics reduced to one clause (details in the annex); terms glossed or replaced at first use and Ask 4 retitled "where the exception is recorded"; Ask 1 links the contract finding to Asks 4 and 5; the answer states the work is committed and pushed, lead-g5tu9 scoped in Deferred; the rendering sentence restated as rendered to the load point and confirmed current; defaults normalized; req-2026-09-04-operational-contract added to relates-to now that it is recorded (originator the lead-solutions-architect role, arisen inside the ADR's authoring run; route discovery, said, answer awaited) and Ask 5 restated accordingly. |
