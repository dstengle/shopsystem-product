---
type: request
id: req-2026-09-09-delivery-verified-amendment
status: routed
version: 1
date: 2026-09-09
reader: lead-pm
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
originator: product-authority
received-through: operational-contract
arose-in: req-2026-09-09-lead-shop-builds
route: discovery
route-reason: "the `delivery-verified` principle is amended, not applied: 'running system' does not hold for a library or a corpus, and 'the scenario can close when the implementer shows it as complete' is on its face what the principle's second statement forbids; three things are unsettled and the open question of whether the feature's done bar itself moves decides sequencing against init-implementation-process, so the substance is framed and bet before an amendment is authored — and a principle amendment reaches every shop and every session, `.claude/shop/principles.md` being compiled from `basis/principles.md`, which is more than the small-change lane's appetite"
routed-to: ""
---

# Request: the `delivery-verified` amendment — principle and definition of good

## 1. What is requested

The product authority, 2026-09-09, in the discovery conversation on
[req-2026-09-09-lead-shop-builds](req-2026-09-09-lead-shop-builds.md)
(anchor lead-z2nit, session record
[sess-2026-09-09-c](../sessions/sess-2026-09-09-c.md)), at exchange 4,
on the principle in force: "on done-without-effect: We need to take
care with delivery-verified. It could result in a lot of bottlenecks
and extra work if it is dogmatic and put in the wrong place. The term
"running system" itself is problematic when you are talking about
libraries or non-server products. The scenario can close when the
implementer shows it as complete through passing scenarios but the PM
is ultimately responsible for whether the delivered feature meets the
user need. How we validate will be highly dependent on the type of
product being built."

And at exchange 5, directing the split: "split our the principle vs
definition of good" — read as "split out"; the reading was put back to
the authority at exchange 6 and not disputed.

**The principle at issue.** `delivery-verified`, in the working set at
[`basis/principles.md`](../basis/principles.md), owned by the product
authority. Its statements today: "Work MUST be counted done only when
its effect is demonstrated in the running system" and "Artifacts
existing, checks passing, or reviews approving MUST NOT count as done
on their own."

**The conflict, as the discovery named it and did not smooth.** "The
scenario can close when the implementer shows it as complete through
passing scenarios" is on its face what the second statement forbids:
passing checks, on their own, closing the work.

**What an amendment would have to settle** — three things, from the
conversation of 2026-09-09:

1. What general form replaces "running system", so the statement holds
   for a library, a corpus of definitions, a command-line tool, and a
   server alike. The discovery put forward the small-change lane's
   *verifying observation* — one command, run from the repository
   root, whose exit status 0 shows the effect and whose output is the
   evidence ([`basis/processes/small-change.md`](../basis/processes/small-change.md)
   §Verification) — as a candidate for the amendment's author to test,
   not as a decision taken.
2. The two-level closure: the implementer closes on passing scenarios,
   and the PM answers for whether the delivered feature meets the user
   need — and which words of the principle that changes.
3. That the form of validation is declared per product rather than
   fixed, with the rule stated in the amendment. Who declares it, and
   where a shop reads it, is not this ask: that was carried to the
   operational-contract discovery (lead-bmmzh).

**What this request must settle, and why it decides sequencing.** The
question was put to the authority at exchange 6 and is unanswered:
whether the PM's level is an accountability standing *above* today's
bar — in which case the amendment needs no sequencing against
[init-implementation-process](../initiatives/init-implementation-process.md)
— or whether the feature's done bar itself moves, nothing counted done
until the PM has answered, in which case the amendment sequences
before that initiative's build-step exit wording.

**Related, and already decided elsewhere.** The PM's accountability
for whether the delivered feature meets the user need is being written
into the lead-pm role definition under init-implementation-process, on
the authority's words of the same conversation: "Write the
accountability into the lead-pm role." The amendment is authored
against the role wording that initiative produces, on the reading that
held at exchange 6.

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract (lead-4kymc), in
conversation — it arose inside the discovery conversation on
req-2026-09-09-lead-shop-builds and was split out of that bet.

## 3. Route

Route said by the lead-pm role, 2026-09-09: **discovery**, form
**interview**. Why: the ask amends a principle rather than applying
one, and its substance is not settled — the general form that replaces
"running system", the two-level closure and the words it changes, and
the per-product declaration are three open questions, and above them
the unanswered one this request must settle, whether the done bar
itself moves. That answer is the authority's, so the conversation is
an interview and not a brainstorm: the shape is already named, what is
missing is the owner's words on each point. It is not the small-change
lane: a principle amendment reaches every shop and every session,
`.claude/shop/principles.md` being compiled from `basis/principles.md`
into every one, and the sequencing question can move another
initiative's exit wording — appetite worth a bet, not a correction
demonstrable in a session.

What the route means for who does the work: the discovery frames an
initiative and the authority bets on it; the amendment itself is then
authored through
[principle-set-authoring](../basis/processes/principle-set-authoring.md)
— the author drafts through the guideline, an independent
fresh-context judge scores the draft against the fitness set, and the
set enters force only by the owner's approval. The route field does
not name that process; the route names where the ask goes next, and
that is the conversation that settles what the amendment must say.
Topic: "the `delivery-verified` amendment — what replaces 'running
system' and where the done bar sits
(req-2026-09-09-delivery-verified-amendment)".

Originator's answer: **not yet answered**. The route is recorded as
said and nothing is acted on until the authority answers.

## 4. Result

Empty: the route awaits the originator's answer.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the request-intake process's record step from the authority's words of 2026-09-09, split out of the discovery on req-2026-09-09-lead-shop-builds (anchor lead-z2nit); routed at the route step to discovery, interview form, with the open question this request must settle stated in section 1. The originator has not answered the route; nothing is acted on. |
