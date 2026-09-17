---
type: principle-set
id: implementation-principles
scope: implementation
owner: product-authority
status: draft
version: 1
created: 2026-09-17
updated: 2026-09-17
derives-from:
  built-to-the-scenario: bidirectional-conformance
  effect-shown: define-good-up-front
  knowable-from-the-record: local-comprehension
---

# Implementation principles

## What this set governs

This is the implementation-scope principle set: the one stated
definition of good implementation engineering — what counts as good
when a shop, Bounded Context or lead, builds what it owns. It is a peer
of the working-scope set, [Founding principles](principles.md), which
governs how every activity is performed, and of the architecture-scope
set, [Architecture principles](architecture-principles.md), which
governs what the designed system must look like; this set governs what
a built implementation must be. Backticked slugs cite principles; a
slug not defined in this document is defined in one of those two sets.

Two roles carry this set, each defined as a role definition under
`roles/`: the maker role, which makes an implementation, and the
checking role, which checks it against this set. Each role's definition
names this set as the source its accountabilities are drawn from and
restates none of its rules. The terms Bounded Context, shop, activity,
acceptance scenario, feature, initiative, implementation, maker role,
checking role, and evidence are defined in the [glossary](glossary.md).
These terms carry a fixed sense in this set:

- **effect** — what an acceptance scenario's Then states will be
  observable; a scenario *holds* when its effect is observable.
- **design** — what `bidirectional-conformance` makes authoritative:
  descriptions, contracts, and recorded decisions, together with the
  criteria and constraints that ride on a scenario by name in its
  feature. A design element is any one of these.
- **design change** — a change to what an implementation is built to:
  an assigned scenario or a design element added, altered, or retired.
  A design change is *recorded* when the feature or the design carries
  it before the build that relies on it; a change present only in the
  code is unrecorded.
- **mechanism** — the tools, the order of steps, and the techniques by
  which an implementation was made.
- **appetite** and **cost** — the appetite is the initiative's bound on
  what the product will spend, time or capacity, as the initiative's
  Appetite section states it; the cost is what an implementation
  consumed of it, in the same unit.

Where a principle here applies a working-scope or architecture-scope
principle at the implementation level, this document declares the
lineage in its frontmatter — `derives-from` maps the principle in this
set to the principle it applies — instead of restating the rule as a
second authority.

## What a good principle looks like

This section restates the shared definition from the
[principle-set typedef](artifacts/principle-set.md) so this document can
be read alone; the restatement is a rendering, not a second authority.

A principle is a standing rule, in four parts: a name, a statement, a
rationale, and implications.

- The **statement** is the rule. It carries the only normative keywords
  (MUST, SHOULD, MAY — interpreted per BCP 14 when, and only when, they
  appear in capitals) and is testable: shown a piece of work, you can
  answer yes or no. A statement carrying more than one obligation
  presents one obligation per bullet.
- The **rationale** says why the rule earns its place: the failure it
  prevents, shown as a generic example; well-known external references
  may support it, the product's own history never appears. Rationales
  stay prose.
- The **implications** are the price tag: one implication per bullet,
  the concrete change each named actor absorbs to honor the rule. They
  add no obligations — every implication must be derivable from the
  statement, or it is a misfiled rule.

A principle is good when its statement is testable (TOGAF, The Open
Group Architecture Framework: understandable, complete, consistent), it
rejects work we would otherwise do (Jared Spool, "Creating Great Design
Principles"), it directs without prescribing method (Richard Rumelt,
*Good Strategy Bad Strategy*), it is not a claim every shop would make
(Patrick Lencioni, "Make Your Values Mean Something", Harvard Business
Review, 2002), and it implies at least one practice and one check. Two
of those tests carry the weight at this scope: a principle here judges
an implementation by the effect it produces and never names a tool, a
step order, or a technique as the mark of good (Rumelt's test); and it
holds as a standing rule across cases, never as the memory of one
incident (the generic-failure rule every rationale obeys). The fitness
screen at the end of this document applies these tests to the
principles above it.

---

## Build what the scenarios state, and only that (`built-to-the-scenario`)

**Statement.**

- An implementation MUST make every acceptance scenario assigned to it
  hold.
- An implementation MUST NOT add behavior that no assigned scenario and
  no design element calls for.
- Where an assigned scenario cannot hold without behavior the design
  does not call for, the maker role MUST ask for a design change that
  calls for that behavior.
- The maker role MUST NOT build that behavior before the design change
  is recorded.
- The checking role MUST fail an implementation on an assigned scenario
  that does not hold, or on a change that no assigned scenario and no
  design element calls for.

**Rationale.** The assigned scenarios are the one statement of what the
work is for that maker, checker, and consumer all read before the
build. An implementation judged against anything else — the maker's
sense of what was probably wanted, the neighbouring feature that looked
cheap while the code was open — is judged against a target only its
maker can see. The familiar failure runs both ways at once: a builder
handed three scenarios delivers two of them and a configuration option
nobody asked for; the consumer finds the missing scenario in use, and
within a month something depends on the extra option, so it can never
be removed. Beck's rule in *Extreme Programming Explained* — you aren't
going to need it — names the reverse half. The two-direction check is
`bidirectional-conformance`'s, which this principle applies to one
implementation: forward, every assigned scenario built; reverse,
nothing built that the design never called for.

**Implications.**

- The maker role builds from the assigned scenarios and the design
  elements riding on them, and from no scenario it was not assigned.
- The maker role, on finding a scenario that cannot hold without a
  design change, stops and asks for the change; it does not build first
  and record afterward.
- The checking role checks both directions — each assigned scenario
  holds, and each change traces to an assigned scenario or a design
  element — and fails a change that traces to neither, whatever its
  merit.

## The effect is shown, not declared (`effect-shown`)

**Statement.**

- An implementation MUST NOT count as done until evidence exists that
  each assigned scenario's effect occurred.
- That evidence MUST be a record the checking role can read without the
  maker role's account of it.
- The maker role's own declaration that an effect occurred MUST NOT
  stand as evidence.
- The verdict on the evidence MUST sit with the checking role, never
  with the maker role.

**Rationale.** A declaration of done costs nothing to make and is wrong
at the same rate whether it is honest or not, because the maker is the
one reader who cannot see what they did not build. A shop that takes
the maker's word has moved its check to the first consumer, at the
worst moment and the highest price: the familiar failure is the build
reported complete and never exercised, whose consumer finds the
scenario that never held. Segregation of duties — the internal-control
rule that whoever performs a transaction does not also approve it (the
COSO framework) — is the same rule applied to money. This principle
applies the working set's `define-good-up-front`, whose check sits with
a different role, to the one activity where the maker's word is most
often taken.

**Implications.**

- The maker role produces the evidence with the implementation; an
  implementation without it is not submitted.
- The checking role reads the evidence, not the maker's account of it,
  and returns fail where the evidence does not exist, whatever the
  maker reports.
- The checking role, and no other role, marks a scenario passed.

## The effect is judged; the mechanism is the maker's (`effect-not-mechanism`)

**Statement.**

- A check of an implementation MUST judge it by the effect it produces
  against its assigned scenarios.
- A check MUST NOT fail an implementation for the tool, step order, or
  technique that produced it where no design element names one.
- The maker role MAY choose any mechanism the design's stated
  constraints admit.

**Rationale.** A mechanism mandated as the mark of good is a proxy: it
was once seen alongside good results, and the mandate outlives the
correlation. The familiar failure is the shop that reviews for the
technique's presence — passes work that performed the technique and
produced nothing, fails work that produced the effect another way —
until its makers learn to perform the technique rather than the effect.
Goodhart's law names what happens: when a measure becomes a target, it
stops being a good measure. A mandate on mechanism is also, almost
always, written for one kind of maker; judging by effect is what lets
`actor-neutral-discipline` hold in the build, where a human maker and
an agent maker meet the same bar.

**Implications.**

- The checking role writes its verdict in terms of the scenarios'
  effects; a verdict that cites only a mechanism has no standing.
- The maker role chooses its tools and its order for itself, and owes
  no defence of a mechanism the design did not constrain.
- The checking role, when it fails an implementation on a mechanism,
  cites the design element that names that mechanism; a mechanism
  preference that no design element states binds no one.

## Nothing that held stops holding (`nothing-lost`)

**Statement.**

- After an implementation, every scenario that held in what the shop
  owns before it MUST still hold.
- Where a new scenario can hold only if an earlier one stops holding,
  the earlier scenario MUST be retired by a recorded design change
  before the build, not lost by it.
- The checking role MUST fail an implementation on a scenario that held
  before it and does not hold after it.

**Rationale.** An implementation does not land alone; it lands in a
system where every scenario that already holds is a promise someone
relies on. The familiar failure is the shop that checks each change on
its own scenarios only: a year on, the scenarios that still hold are a
subset of the ones ever accepted, nobody can say which subset, and
every consumer re-tests what the shop already claimed. Lehman's laws of
software evolution record the drift — a system's quality declines
unless work is spent to hold it — and so name the price of not spending
it. The retirement route is `bidirectional-conformance`'s: a design
change is a recorded activity, and retirement is gated on it.

**Implications.**

- The maker role shows that the earlier scenarios still hold as part of
  its evidence, not only that the new ones do.
- The checking role fails an implementation on a lost scenario as it
  would on a missing one.
- Whoever needs an earlier scenario to stop holding asks for the design
  change that retires it before the build; the maker role does not
  retire a scenario by building over it.

## What changed is readable from the record (`knowable-from-the-record`)

**Statement.**

- An implementation MUST leave what it changed, and the scenario or
  design element each change answers to, readable from the shop's own
  records.
- Those records MUST suffice for the next maker role to take up the
  same part without the previous maker's account.
- The checking role MUST fail an implementation whose records do not
  suffice, whether or not its scenarios hold.

**Rationale.** The maker who built a part carries what it does and why
in their head, and the next maker either asks, reads everything, or
rebuilds it. The familiar failure is the part whose only description is
a person — "ask whoever wrote it" — which works until that person is
elsewhere. For an agent maker the failure is literal: the next maker is
a fresh context with no memory of the last one, and whatever is not in
the record did not happen. Parnas and Clements, "A Rational Design
Process: How and Why to Fake It" (1986), make the case that the record,
not the process that produced it, is what the next reader uses. This
principle applies `local-comprehension` to one implementation: working
inside a shop is done from that shop's own records and code, so an
implementation leaves records that level can work from.

**Implications.**

- The maker role writes what changed and why into the shop's records
  with the implementation, before submitting it for the check.
- The checking role reads the record as part of the check; an
  implementation the checker can follow only by asking the maker fails
  on its record, whether or not its scenarios hold.
- The next maker role, finding a record that does not suffice, reports
  the shortfall rather than reconstructing the earlier maker's intent
  from the code.

## Cost lands on the initiative (`cost-on-the-initiative`)

**Statement.**

- An implementation MUST stay within the appetite of the initiative its
  feature belongs to.
- The maker role MUST stop an implementation that will not finish
  within that appetite rather than overrun it.
- The maker role MUST report the stop to the initiative's owner.
- The cost of an implementation MUST be recorded on that initiative.
- The checking role MUST NOT give a verdict on an implementation whose
  cost is not recorded on its initiative.

**Rationale.** The appetite is the whole content of the bet: the
authority decided what the problem was worth. An implementation that
spends past it on its own has changed the bet without the bettor, and
one whose cost no record holds cannot be priced against its outcome
afterward, so the next bet is made blind. The familiar failure is the
feature "almost done" for the third week of its two, which nobody
decides to stop because nobody is told. Shape Up (Singer, Basecamp)
fixes the time and varies the scope, with a circuit breaker that ends
the work when the time is up; this principle asks less — stop and
report, and let the owner decide.

**Implications.**

- The maker role reads the appetite before it starts and reports, as
  soon as it can see it, that the work will not fit; it does not extend
  the work quietly.
- The maker role, on stopping, hands the decision on scope or appetite
  to the initiative's owner and does not take it itself.
- The maker role records the cost, in the appetite's unit, with the
  implementation.
- The checking role confirms the cost is recorded on the initiative
  before it gives a verdict; an implementation without a cost entry
  waits on the maker role for the entry.

---

## Fitness screen (the intro's tests; sources: TOGAF, Spool, Rumelt, Lencioni)

| Screen | built-to-the-scenario | effect-shown | effect-not-mechanism | nothing-lost | knowable-from-the-record | cost-on-the-initiative |
|---|---|---|---|---|---|---|
| Statement testable (TOGAF: understandable, complete, consistent) | pass | pass | pass | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects unassigned behavior, partial delivery, behavior built before its design change is recorded, and a verdict that checks one direction only | yes: rejects done on the maker's word and a verdict held by the maker | yes: rejects mechanism mandates and verdicts given on technique | yes: rejects a change checked on its own scenarios alone, retirement by building over, and a pass on a lost scenario | yes: rejects a part knowable only by asking its maker, and a pass on its code alone | yes: rejects silent overrun, unrecorded cost, and a verdict given before the cost is recorded |
| Not fluff, not a goal-in-disguise (Rumelt) | pass — judges by the scenarios held; names no tool, order, or technique | pass — judges by evidence of the effect; names no form of test | pass — the rule is method-neutrality itself | pass — judges by what still holds; names no regression technique | pass — judges by what the next maker can do from the record; names no documentation format | pass — judges by the bound kept and the cost recorded; names no estimating method |
| Not permission-to-play (Lencioni) | pass — most shops build to a ticket title and welcome extras | pass — most shops close on the engineer's "done" | pass — most shops mandate a technique and review for its presence | pass — most shops check a change on its own scenarios and find lost ones in use | pass — most parts are known by asking their maker | pass — most shops overrun and record no cost per bet |
| Implies ≥1 practice and ≥1 check (this document's intro) | scenario-first build and design-change-before-build practice; two-direction fail check | evidence-with-submission practice; evidence-read verdict | maker-chosen mechanism within named constraints; effect-only verdict review, mechanism failure cited to a design element | prior-scenario evidence practice; lost-scenario fail | record-with-change practice; record-suffices fail | appetite read, stop, and report practice; cost-recorded gate on the verdict |
| Normative keywords used in statements only; capitals elsewhere only as the opening's mentions (mechanical) | pass | pass | pass | pass | pass | pass |
| Implications derivable and actor-named, one per bullet (judged) | pass | pass | pass | pass | pass | pass |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-17 | update | Authored by the lead-pm role at principle-set-authoring's `draft` step, anchor lead-f0r3g, scope `implementation` (principle-set typedef v7), from the declared sources alone: init-implementation-process (v4) for the framing and the authority's reframing; feat-implementation-good (v7), whose seven scenarios are the contract; the architect's implementation guidance for this assignment (item 2); adr-2026-09-16-scenario-evidence-form; the working set (v12) and the architecture set (v7) for form and `derives-from` lineage. Six principles, three with declared lineage. Nothing read from `main` or shopsystem-templates, and nothing pasted from any prompt, per the initiative's first no-go; the experience-scope set was not loaded, being outside the declared sources. The ADR's two evidence forms are not restated here: `effect-shown` states the standing rule the decision instantiates — a record the checking role reads without the maker's account, never the maker's declaration — and the two role definitions carry the ADR's forms by citation, per the guidance. Maker's evaluation against the principle-set guideline and fitness set before the screen: scenario 1 pass — the self-definition precedes the first principle, each principle carries the four parts and nothing else, every cross-reference is a slug; scenario 2 pass — every statement decidable on one implementation, one obligation per bullet, and every term a decision turns on defined in the statement, the opening (effect, design, mechanism, appetite, cost) or the glossary (implementation, maker role, checking role, evidence, added this day); scenario 3 pass — each rationale names a generic failure and cites only a published work, a framework, or a named law, none of the product's artifacts, incidents, or decision records; scenario 4 pass — each implication names its actor and the statement bullet it follows from, one per bullet, the cost principle's fourth split from the third for that reason; scenario 5 pass — six columns, seven rows, each cell written from the text above it; scenario 6 pass — the Spool and Lencioni rows name what each rejects and the honest opposite. Against the feature's contract: `@hash:d11bce62c8e2` — one document, at one path, named by both roles; `@hash:c4c48c7eef06` — no statement names a tool, a step order, or a technique as the mark of good, the Rumelt row records this per principle, and the one principle that names mechanism at all (`effect-not-mechanism`) bars it as a criterion; `@hash:ab646950e73e` — every statement is a standing rule and no rationale cites an incident. Terms taken to the glossary before this step closed: implementation, maker role, checking role, evidence; the `scope` entry gains the implementation level. Not done here: `basis/README.md` does not index this set — the experience set is unindexed too, and the index is outside this step's declared outputs. |
| 1 | 2026-09-17 | update | Revised by the lead-pm role at principle-set-authoring's `revise` step, anchor lead-f0r3g, after one cold screen (pass 1, 3, 6; wobbly 2; fail 4, 5), through the principle-set guideline and the base writing style; every finding repaired, no tradeoff accepted. Scenario 2: **design change** and its *recorded* sense added to the opening's fixed-sense terms and used in `built-to-the-scenario` and `nothing-lost`; the two fused obligations split — ask-for-a-design-change and do-not-build-before-it-is-recorded (`built-to-the-scenario`), stop and report (`cost-on-the-initiative`) — one per bullet. Scenario 4: each of the four checking-role implications now follows from a checking-role clause in its own statement — fail on a scenario that does not hold or a change nothing calls for (`built-to-the-scenario`), fail on a lost scenario (`nothing-lost`), fail on records that do not suffice (`knowable-from-the-record`), no verdict before the cost is recorded (`cost-on-the-initiative`); `effect-not-mechanism`'s third implication rewritten onto the checking role, deriving from its second clause, so the set names no third role; `knowable-from-the-record`'s third implication names the next maker role as its actor. Scenario 5: the Spool and practice-and-check rows rewritten for the five changed principles from the text above them, and the bottom row re-read cell by cell. Maker's evaluation against the fitness set: scenario 1 pass — four parts each, every reference a slug; scenario 2 pass — each statement bullet one obligation, decidable on one implementation, every term it turns on defined in the opening or the glossary; scenario 3 pass — rationales unchanged, generic failures and external references only; scenario 4 pass — every implication names its actor and follows from a clause of its own statement; scenario 5 pass — six columns, seven rows, each cell reproducible from the text; scenario 6 pass — the Spool and Lencioni rows state what each principle rejects and the honest opposite. Status stays draft for the owner's approval. |
