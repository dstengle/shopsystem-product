---
type: principle-set
id: architecture-principles
scope: architecture
owner: product-authority
status: draft
created: 2026-08-23
updated: 2026-08-23
derives-from:
  local-comprehension: least-context
verified-by:
  - round: 1
    role: cold-reviewer
    model: claude-fable-5
    date: 2026-08-23
    verdict: clean
    notes: all 6 scenarios + mechanical check pass; 7 stumbles reported
      in the round log, none a scenario fail
  - round: 2
    role: cold-reviewer
    model: claude-fable-5
    date: 2026-08-23
    verdict: clean
    notes: re-screen after the authority's rationale re-rule (generic
      examples only, no product operational history); all scenarios
      pass under the amended fitness set; 6 stumbles reported, none a
      scenario fail
  - round: 3
    role: cold-reviewer
    model: claude-fable-5
    date: 2026-08-23
    verdict: clean
    notes: re-screen after the authority's statement-clarity findings
      (local-comprehension re-enumerated, intent-provenance expanded
      with intent defined inline, conformance questions restored); all
      scenarios pass; 6 polish-level stumbles reported, none a
      scenario fail
---

# Architecture principles

## What this set governs

This is the architecture-scope principle set: the standing rules for how
the product is designed — its regions, their boundaries, and the entities
that build and evolve them. It is a peer of the working-scope set,
[Founding principles](principles.md), which governs how every activity is
performed; this set governs what the designed system must look like.
Backticked slugs cite principles; a slug not defined in this document is
defined in the working set. The terms Bounded Context, shop, activity,
contract, relationship kind, and intent are defined in the
[glossary](glossary.md). Two distinctions those terms carry are used
throughout: a shop is either the lead shop — the system-level
coordinator, owning the product-level artifacts and no Bounded
Context — or a BC-shop, owning exactly one; and a contract is offered
either as a product contract, on a Bounded Context, or as an
operational contract, on a shop.

Where a principle here applies a working-scope principle at the
architecture level, this document declares the lineage in its
frontmatter — `derives-from` maps the principle in this set to the
working-scope principle it applies — instead of restating the rule as a
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
  answer yes or no.
- The **rationale** says why the rule earns its place: the failure it
  prevents, shown as a generic example; well-known external references
  may support it, the product's own history never appears.
- The **implications** are the price tag: the concrete changes each named
  actor absorbs to honor the rule. Every implication must be derivable
  from the statement; none adds a new obligation.

A principle is good when its statement is testable, it rejects work we
would otherwise do (Spool), it directs without prescribing method
(Rumelt), it is not a claim every shop would make (Lencioni), and it
implies at least one practice and one check. The fitness screen at the
end of this document applies these tests to the principles above it.

---

## Every first-class entity has a knowable shape (`knowable-shape`)

**Statement.** The product MUST have exactly two kinds of first-class
entity: the Bounded Context and the shop. Each Bounded Context MUST be
contained and produced by exactly one BC-shop; the lead shop MUST NOT
contain one. Every first-class entity MUST carry a description,
maintained as an artifact, from which an outside reader can name what
the entity is for, what it accepts and produces, what it guarantees, and
the contracts it offers — without reading its internal code or
configuration and without asking its maintainers.

**Rationale.** When an entity's shape lives only in its internals, every
consumer, coordinator, and reviewer pays to rediscover it, and each
rediscovery reaches a different answer: nobody can say what a service
guarantees without opening its source, the answer holds only until the
next commit, and no description can be trusted without re-inspecting
the thing it describes. Parnas made the design case in 1972: a module
is known by what its interface states, not by what its implementation
happens to do. Without
`knowable-shape`, `contracts-between-contexts` is speculative — no one
can write a contract for an entity whose shape no one can state.

**Implications.** Whoever creates a Bounded Context or a shop writes its
description at creation; an entity without a description is not yet
created, whatever code exists. Maintainers keep the description
authoritative: when an outside reader must open internals to answer a
question the description claims to cover, the description is the defect
and its maintainer repairs it. Architects reason from descriptions;
opening an entity's internals is audit work — checking that a
description is true — not the normal way to learn what the entity is.

## Contracts are the only channel between Bounded Contexts (`contracts-between-contexts`)

**Statement.** Anything one Bounded Context expects of another MUST pass
through a named, versioned contract stating the schemas exchanged, the
meaning of each operation, the error behavior, and the relationship
kind. A Bounded Context MUST NOT rely on anything its counterpart's
contract does not state, and contexts MUST NOT share state or
coordinate outside their contracts.

**Rationale.** Unstated expectations cannot be reviewed, versioned, or
deliberately kept — they are discovered when they break. Hyrum's law
(Winters, Manshreck, and Wright, *Software Engineering at Google*)
records the observed endpoint: with enough consumers, every observable
behavior of a system will be depended on by somebody, whatever the
contract says — the only defense is making the contract the sole thing a
consumer is entitled to. Evans (*Domain-Driven Design*, 2003) draws
context boundaries for the same reason: models stay coherent only when
what crosses between them is explicit. Without this rule,
`local-comprehension` collapses — a consumer must read a counterpart's
internals to learn what is safe to use.

**Implications.** Contract authors put every promise in the contract
document — schemas, semantics, errors, relationship kind; a promise made
anywhere else is not owed. Reviewers of a consuming context treat
reliance on unstated behavior as that context's defect, and treat the
underlying need as a contract-change request, not a license to work
around the contract. Integrators who need a channel the contract lacks
amend the contract first or do not integrate.

## Discipline attaches to activities, not actors (`actor-neutral-discipline`)

**Statement.** Rules, authority, and required records MUST attach to the
activity and the role performing it, never to the kind of actor filling
the role; an activity MUST NOT record less, skip checks, or gain
authority because a particular kind of actor — human, agent, or
service — performs it.

**Rationale.** Rules forked by actor kind create bypasses: whichever
fork is weakest becomes the route around the discipline, and social
routes — "just ask the team next door" — are exactly the moves agents
scale beyond anyone's review. Role-based access control (Ferraiolo and
Kuhn, 1992; the NIST RBAC model) grounds the mechanism: grant to roles,
and the actor mix can change without regranting authority. The working
set's `no-orphan-activities` already places every activity in a process;
this rule keeps those processes actor-neutral, which is what keeps
`contracts-between-contexts` binding on whoever shows up — an actor that
could renegotiate the rules by kind could talk its way around a
contract.

**Implications.** Process authors demand the same inputs, checks, and
records from a step whoever performs it; "it was just an automation"
excuses no missing record. Reviewers strike rule text that splits one
activity by actor kind — "humans may, agents must" — the rule attaches
to the activity or it goes. Whoever grants authority grants it to a role
within a process; a standing grant to an individual actor is a defect
whoever holds it.

## Comprehension is local at every level (`local-comprehension`)

**Statement.** A participant MUST NOT need to read beyond the level
they are working at, and the design MUST designate, for each level, the
description artifacts sufficient for that level's work. The levels, and
their designated artifacts, are:

- working inside a shop — that shop's own records and code;
- consuming a Bounded Context — that context's contracts;
- working across Bounded Contexts — the contracts and the system-level
  map of the contexts and their relationships;
- coordinating the system — the product-level descriptions the lead
  shop owns.

Work at a level MUST be performable from its designated artifacts
alone. A task that can be done only by reading below its level MUST be
treated as a design defect — a missing or incomplete description or
contract — not as the reader's burden.

**Rationale.** The cost of working on one part of the product has to
stay proportional to that part, or growth taxes every participant; for
agents the tax is literal — context loaded is context paid for. The
familiar endpoint of the failure: a corpus with no designated reading
levels grows until a one-line change is one nobody dares make without
reading the whole system first, and every newcomer must read far beyond
the task at hand before starting it. This rule applies the
working set's `least-context` to the designed system — the lineage is
declared in this document's frontmatter: `least-context` caps what an
activity loads, and a design obeying this rule is what makes that cap
reachable, because the artifacts an activity needs exist at its own
level.

**Implications.** Designers ship each level's designated artifacts as
part of the design; a level whose work demands undesignated reading is
unfinished design. Whoever hits a task that requires reading below its
level files the defect against the design and does not normalize the
deep read into practice. Reviewers of a design check the reading bound:
the artifacts a task needs stay proportional to the task's level, not
to the product's size.

## Design is authoritative, conformance runs both ways (`bidirectional-conformance`)

**Statement.** The design — descriptions, contracts, recorded
decisions — MUST be the authoritative statement of what the product is
and does, and code MUST conform to it. Conformance MUST be checked in
both directions: forward — every design element MUST have code
implementing it (did we build what we said?) — and reverse — every code
element MUST be called for by the design (did we build only what we
said?). A design change
MUST itself be a recorded activity, and retirement and refactoring MUST
be gated on both conformance checks.

**Rationale.** When code is the authority, descriptions decay into
folklore and `knowable-shape` drifts false — the description stops
matching the entity it claims to describe. Forward checking alone
misses half the failure: features removed on paper live on as unowned
code, and undecided behavior accumulates until the design describes a
product that no longer exists. Murphy, Notkin, and Sullivan's reflexion
models (1995) demonstrated the two-directional comparison this
statement requires — computing both what the design promises that the
code lacks, and what the code contains that the design never called
for. The working set holds the two flanking rules at working scope:
`single-source-of-truth` gives every fact one authoritative home, and
`delivery-verified` demands the forward direction be demonstrated in
the running system; this rule adds the reverse direction and gates
retirement and refactoring on the pair.

**Implications.** Whoever changes behavior records the design change —
before the code change or in the same recorded activity; silent drift
is reverted, never adopted after the fact. Whoever retires a feature
removes it from the design first; the reverse check then names the code
that may be deleted, and nothing else is. Refactorers demonstrate both
checks unchanged — no behavior lost forward, none gained in reverse.
Reviewers reject code no design element calls for, however good it is.

## Intent enters through contracts and keeps its provenance (`intent-provenance`)

**Statement.** Intent — a desired outcome expressed by an originator at
the product's edge — MUST enter the product through a contract: a
product contract on a Bounded Context or an operational contract on a
shop. The shop that receives intent MAY translate it, and MAY delegate
it to other shops, only ever through those shops' contracts. Every
receipt, translation, and delegation MUST be recorded, so that any
activity can be traced back to the originating expression without
ambiguity.

**Rationale.** Intent that loses its origin cannot be re-decided: when
priorities shift, no one can tell which work still serves a live desire
and which serves a decision nobody remembers making — "why did we build
this?" becomes answerable only by whoever happened to be present.
IEEE 29148 (requirements engineering) standardizes exactly the chain
this statement demands: each requirement traceable to its source and to
what implements it. Routing intent through contracts keeps
`contracts-between-contexts` whole at the product's edge — a backlog
living outside the product's contracts is an out-of-band channel like
any other, aimed at the builders instead of the contexts. And the trace
is what gives `bidirectional-conformance` its meaning: conformance can
verify that code matches design, but only provenance can verify that
either matches what anyone asked for.

**Implications.** Whoever accepts intent records it at the contract
where it entered before working on it. Whoever translates or delegates
intent records each translation against the original, at every step.
Reviewers may demand the originator chain for any activity; a trace
that dead-ends is a recording defect to repair, not a question to drop.

---

## Fitness screen (the intro's tests; sources: TOGAF, Spool, Rumelt, Lencioni)

| Screen | knowable-shape | contracts-between-contexts | actor-neutral-discipline | local-comprehension | bidirectional-conformance | intent-provenance |
|---|---|---|---|---|---|---|
| Statement testable (TOGAF: understandable, complete, consistent) | pass | pass | pass | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects entities knowable only by reading internals or asking maintainers | yes: rejects unstated cross-context reliance and out-of-band coordination | yes: rejects per-actor-kind rulebooks and recordless automation | yes: rejects designs that make below-level reading a prerequisite | yes: rejects silent drift and paper-only retirement | yes: rejects untraceable work and backlogs outside the product's contracts |
| Not fluff, not a goal-in-disguise (Rumelt) | pass — directs without prescribing method | pass | pass | pass | pass | pass |
| Not permission-to-play (Lencioni) | pass — most products are known by their code, not their descriptions | pass — most systems tolerate out-of-band coupling | pass — most shops rule humans and automations differently | pass — most systems require reading internals to work safely | pass — reverse conformance is rarely checked anywhere | pass — most backlogs live outside the product's audit trail |
| Implies ≥1 practice and ≥1 check (this document's intro) | description-at-creation practice; description-completeness audit | contract-first integration; unstated-reliance review | same-records-per-step authoring; actor-kind rule-text review | designated artifacts per level; below-level-read defect filing | design-change-first practice; two-direction conformance check | record-at-entry practice; originator-chain audit |
| Normative keywords used in statements only; capitals elsewhere only as the opening's mentions (mechanical) | pass | pass | pass | pass | pass | pass |
| Implications derivable and actor-named (judged) | pass | pass | pass | pass | pass | pass |
