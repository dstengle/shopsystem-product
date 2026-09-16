---
type: adr
id: adr-2026-09-16-scenario-evidence-form
title: Evidence of a scenario's effect is the shop's pass/fail where executable, the checking role's mark where not
status: recorded
version: 1
date: 2026-09-16
decided-by: product-authority
right: guardrail
owner: lead-solutions-architect
created: 2026-09-16
updated: 2026-09-16
---

# ADR: Evidence of a scenario's effect is the shop's pass/fail where executable, the checking role's mark where not

## 1. Context

Terms, from the existing type system: a fitness set already carries
`judged` and `executable` as frontmatter fields, one true and the
other false, never both — the
[fitness-set typedef](../basis/artifacts/fitness-set.md) treats a
criterion set an automated runner can execute and a criterion set a
role must read and judge as two distinct, named kinds of check. This
decision applies the same distinction to a feature's scenarios.

Pre-state, read from lead-shop-held records. `delivery-verified` — the
working principle requiring an implementation's effect "demonstrated
in the running system" before it counted done — was removed whole from
the working set on 2026-09-15
([basis/principles.md](../basis/principles.md) v12, Document History),
under init-delivery-verified-removal, on the product authority's own
words: "There is no mechanism that would be possible to implement in
the current system that would meet the principle. This will need to be
brought back when the system is more mature." The removal deliberately
left open what a check accepts in the principle's place; nothing
replaced it.

feat-implementation-good (v4), authored against that gap, carries
seven scenarios stating a definition of good for implementation
engineering. Scenario @hash:bbccc3a1765c requires that "the checking
role requires an implementation's effect shown, not declared." At the
feature's add-constraints step the lead-solutions-architect role (this
role) read that scenario against the removal and found no fixed
mechanism naming what evidence a check accepts or which role declares
it satisfied, and recorded that as a needs-decision line rather than
deciding it — feat-implementation-good's Contributors section and its
Edges table row "What form of evidence a check accepts... routed to
adr-authoring." The same feature's own seven scenarios are themselves
an instance of the open question: they are judged reads of definition
documents (this typedef, the role definitions, the fitness set), not
tests any runner can execute — so the question the removal left open
is live in the very feature that raised it.

The product authority decided this on 2026-09-16 in conversation with
the lead-pm, in two statements, in order:

1. "Evidence is the shop presenting the pass/fail status of the
   scenario tests."
2. Asked what a pass/fail is for a scenario with no executable test —
   feat-implementation-good's own seven — the authority answered:
   "Scenario tests means executable tests. For non-executable tests,
   the checking role can mark the scenarios as passed."

Forces. The authority's 2026-09-09 position
([sessions/sess-2026-09-09-c.md](../sessions/sess-2026-09-09-c.md)) —
"the scenario can close when the implementer shows it as complete
through passing scenarios but the PM is ultimately responsible for
whether the delivered feature meets the user need" — sets a level above
this one (the PM's accountability, written into the lead-pm role
definition under init-implementation-process) and is not restated or
contradicted here; this record settles only what a check accepts as
the scenario's own evidence, not what stands above it. The same
session confirmed four defects in `main`'s implementation-role
prompts, one of which bears directly on this decision: "the check held
inside the maker's own prompt." A decision that let a maker's own
declaration stand as evidence, executable or not, would recreate that
defect; the authority's second statement instead names a role other
than the maker — "the checking role" — as the one who marks a
non-executable scenario passed, and feat-implementation-good's own
scenario 4 ("two implementation roles carry the definition, one making
and one checking... neither role is both") already requires that the
checking role and the maker role are not the same role. This decision
does not itself name who fills the checking role; it states only what
counts as evidence once a checking role exists, so it adds no route
back to the defect.

Options that were real.

- **One evidence form for every scenario — require every scenario be
  made executable before it can be checked.** Not chosen: the
  authority's own second statement rules it out directly ("for
  non-executable tests, the checking role can mark the scenarios as
  passed") — the authority was asked exactly this question, in the
  concrete case of feat-implementation-good's seven read-based
  scenarios, and declined to force executability as a precondition.
- **The maker's own declaration counts as evidence, for either form.**
  Not chosen: this is the fourth confirmed defect verbatim ("the check
  held inside the maker's own prompt"). The authority's first statement
  requires the shop to present a test's pass/fail status rather than a
  maker's say-so, and the second names the checking role, not the
  maker, as the one who marks a non-executable scenario passed.

No other option was put to the authority in the recorded conversation;
these two are the ones the two statements, read together, foreclose.

Self-evaluation against the [adr fitness set](../basis/fitness/adr.fitness.md),
scenario by scenario: (1) the title names the decision in one line and
§2 states it as one sentence a reader can act on, its two forms one
conditional rule rather than two decisions — pass. (2) this Context
states the pre-state and forces with their sources (the removal, the
feature, the two sessions cited) and names two real options with the
reason each was declined — pass. (3) §2 names `decided-by:
product-authority` and `right: guardrail`, standing on the authority's
own word per the typedef's rule — pass. (4) each Consequences bullet
names what changes, for whom, and its cost, and the two bounds on
Bounded Context shops are stated as bounds — pass. (5) §4 states the
decision is hard to reverse once built against, and names its
triggers — pass. (6) §2.1 states the principles screen result,
conformance, against every principle in the set — pass. No fail found
against this fitness set.

## 2. Decision

Where a feature's scenario has an executable test, the evidence a
check accepts that the scenario's effect occurred is the shop
presenting that test's pass/fail status; where a scenario has no
executable test, the evidence is the checking role — a role other than
the scenario's maker — marking the scenario passed.

### 2.1 Principles screen

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms, no exception carried.

- `actor-neutral-discipline` — the rule attaches to the scenario (does
  it carry an executable test or not), never to which kind of actor
  built or checks it; a human checking role and an agent checking role
  mark a non-executable scenario passed under the identical rule, and
  neither gets a lighter bar for being a particular kind of actor.
- `bidirectional-conformance` — this decision states what forward
  conformance evidence a check accepts (did the built scenario do what
  the design said) for the implementation activity generally; it does
  not touch the reverse direction or gate any retirement, so it neither
  conforms further ground it does not need nor conflicts.
- `contracts-between-contexts` — no Bounded Context contract is in
  scope; the decision governs how any shop's own check reads its own
  scenarios, not a channel between two Bounded Contexts.
- `knowable-shape` — no first-class entity (Bounded Context or shop) is
  created or described here; nothing in this decision touches that
  principle's obligation.
- `local-comprehension` — the decision does not change what artifacts
  any level must read; it names what a check accepts as evidence within
  work already scoped to its level.
- `intent-provenance` — the decision does not route intent; it does not
  bear on this principle.

## 3. Consequences

- **A shop with an executable scenario test presents that test's
  pass/fail status as its evidence.** What changes: the check no longer
  accepts a maker's declaration that the scenario is done — it requires
  the test's own pass/fail output. For whom: every shop that implements,
  Bounded Context or lead, whose maker role must run and present the
  test; the checking role, who reads the presented status rather than
  taking the maker's word. Cost: an executable scenario cannot close
  without a runnable test existing and being run. Bound on Bounded
  Context shops: a BC shop performing implementation MUST present the
  pass/fail status of a scenario's executable test as that scenario's
  evidence; it MUST NOT substitute its own declaration.
- **A shop with a non-executable scenario has the checking role mark it
  passed.** What changes: where no runner can execute the scenario (a
  judged read of definition documents, as feat-implementation-good's own
  seven scenarios are), the checking role's mark is the evidence, in
  place of a test result that cannot exist. For whom: the checking
  role, who takes on a judgment accountability for these scenarios that
  it did not carry under the removed principle; the maker role, which
  gains no path to mark its own scenario passed. Cost: a non-executable
  scenario's evidence rests on the checking role's judgment rather than
  a reproducible test run, which is weaker evidence than the executable
  form and cannot be independently re-executed later. Bound on Bounded
  Context shops: a BC shop performing implementation MUST route a
  non-executable scenario's pass/fail to a checking role distinct from
  the scenario's maker; it MUST NOT mark its own non-executable
  scenario passed.
- **The maker/checking role split, already required by
  feat-implementation-good's scenario 4 and the working set's
  `define-good-up-front`, is load-bearing for both forms.** What
  changes: nothing new is required of that split by this decision, but
  both evidence forms depend on it — the executable form because the
  checking role, not the maker, is the one reading the presented status
  at check time, and the non-executable form because the mark comes
  from the checking role by name. Cost: none beyond what
  feat-implementation-good already commits to. Forecloses: a
  non-executable scenario closing on the maker's own mark under either
  form.

Two questions this decision does not settle — the subject named them
neither directly nor by omission the architect can resolve from the
pre-state — are put to the lead-pm role as asks, each with the default
this record acts on for this pass, per the `asks: [lead-pm]` provision
of the `author` step:

- **Ask 1** (kind: `scope`) — Presented to whom, and where the evidence
  lands. The authority said the shop "presents" the pass/fail status,
  and named no destination. `reconcile-and-close` (the router role's
  process for consuming a BC's completed dispatch) is the obvious
  existing landing point, but feat-implementation-good's own scope note
  says the lead shop's implementation scenarios sit in the lead shop's
  own tree with no dispatch, so `reconcile-and-close` as written may not
  reach them. Default, acted on here: the evidence lands wherever the
  work item that carries the scenario closes — `reconcile-and-close` for
  a dispatched BC scenario, and the equivalent close step of the
  implementation process (not yet defined; session two of
  init-implementation-process) for the lead shop's own. No process
  definition is amended by this record to carry that default; it binds
  only this record's reading until stated in the processes themselves.
- **Ask 2** (kind: `reserved-decision`) — Whether the shop's presented
  pass/fail stands on its own or must be independently re-run by the
  lead. The authority's first statement says the shop "presents" the
  status; it does not say whether presentation alone suffices. Default,
  acted on here: it stands on its own — the authority's word is
  "presenting," not "re-running," and requiring an independent re-run
  is a stronger bar the authority was not asked about and did not
  state; this default may prove wrong and is the lead-pm's to correct.

## 4. Reversibility

Hard to reverse once the implementation process (init-implementation-process,
session two) and the maker/checking role definitions are built against
it: both role definitions and the process's check step will be written
to this evidence bar, and every scenario closed under it will have been
closed on this reading of "evidence." Reversing later means rewriting
both role definitions, the process's check step, and re-judging
whatever closed under the old bar. Review triggers: the authority's own
stated intent to bring `delivery-verified` back "when the system is
more mature" — that reinstatement, once it happens, replaces or
subsumes this record's non-executable-scenario form with whatever
mechanism the mature system supports; or either ask above resolving
against its default.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-16 | update | Authored by the lead-solutions-architect role from the needs-decision line this role wrote at feature-authoring's add-constraints step on feat-implementation-good (v4), anchor lead-ft3ad, per the product authority's decision of 2026-09-16 taken in conversation with the lead-pm (two statements, quoted in Context). Pre-state read from lead-shop-held records alone: feat-implementation-good, basis/principles.md v12's Document History, sessions/sess-2026-09-15-a.md, sessions/sess-2026-09-09-c.md, the fitness-set typedef's judged/executable fields, and basis/architecture-principles.md. One decision, stated with its two forms as the subject requires. Two questions the subject leaves open put to lead-pm as asks, each with a default acted on for this pass, per the process's first-pass rule. |
| 1 | 2026-09-16 | state | draft → recorded, by the `record` step. Evaluation against the [adr fitness set](../basis/fitness/adr.fitness.md): all six scenarios pass, per the scenario-by-scenario self-evaluation stated in §1 Context — one decision named and stated actionably; the context carrying forces, sources, and two real options each with the reason declined; the decider and right named and standing on the authority's own word; every consequence priced for whom and at what cost, with both Bounded-Context bounds stated as bounds; reversibility stated with its triggers; the principles screen stated. Evaluation against the [architecture principle set](../basis/architecture-principles.md): conformance on all six principles, per §2.1 — `actor-neutral-discipline` (the rule attaches to the scenario, not the actor kind checking or making it), `bidirectional-conformance` (states forward-evidence acceptance only, touches neither the reverse direction nor a retirement gate), `contracts-between-contexts`, `knowable-shape`, `local-comprehension`, and `intent-provenance` (each screened and found not implicated or not conflicting, per §2.1); no exception carried, nothing absorbed as a deviation. Made by the lead-solutions-architect role. |
