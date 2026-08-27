---
type: research-report
id: system-read-2026-08
status: delivered
version: 6
date: 2026-08-27
question: "Can we get a cold read of the entire system from a product leadership persona? Can this just be done as research? I'd like to get feedback on what we are building from a holistic perspective."
requested-by: product-authority
created: 2026-08-27
updated: 2026-08-27
---

# Research report: a cold read of the whole system against the product operating model

## Executive summary

*How to read the labels.* **High** — the claim is read directly from
quoted basis text and judged against a standard the shop's own research
reports carry; **medium** — an inference across several documents, or a
judgment of fit; **low** — a prediction about how the system will
behave in use, which no run has yet shown. Confidence is about the
evidence; where a finding predicts, likelihood is stated in its own
phrase.

*How it was read.* Three readers in fresh contexts read the corpus
with different lenses — the product operating model, end-to-end
coherence, and a product leader's first hour — against a stated
standard, not a persona: the shop's research-prompting report found
expert personas do not improve accuracy, so each reader was given the
product operating model as the five research reports document it
(Cagan, Torres, Perri, Shape Up, Amazon, Team Topologies, DDD) and the
shop's nine working principles.

*Vocabulary.* The *basis* is the definition corpus on `rebaseline`;
a *hop* is one hand-off in a feature's path from request to shipped
change, and its *carrier* is the process or step defined to perform
it; a *making hop* produces an artifact (a framing, a brief), as
against a checking or carrying hop; the three readers are named by
lens — R1 the operating-model reader, R2 the coherence reader, R3 the
cold-arrival reader; "product-process report" is
`research/product-process-2026-08.md`, and citations of the form
"report F6" name that report's finding, not this one's; *framing* is the PM role's recorded statement of a request's
problem and outcome; the *initiative* is the product-level artifact
the product-process report proposes; a *BC-shop* owns one Bounded
Context; the *router* is a role name `reconcile-and-close` uses.

1. **The verdict, in the coherence reader's words: "a well-built
   checking apparatus around an empty making pipeline."** Tracing one
   feature through the defined chain, four of ten hops have a defined
   carrier — two checks (the PO output check, the conformance check),
   one carrying hop (`reconcile-and-close`), and the discovery
   conversation, which produces a session record (a conversation's
   anchor, not a chain artifact) but not the framing the next hop
   needs. No hop that makes a chain artifact has a carrier. No process produces a framing, authors a
   brief or scenario set, assigns checked work to a shop, dispatches
   it, answers an ask, writes a changelog, or measures an outcome.
   By the corpus's own rule — a definition chain "required before
   instances are authored" — no PO artifact may yet be authored: the
   four types have typedefs and fitness sets but no guideline,
   authoring process, or skill. *(High.)*
2. **The product is never named.** No document on a newcomer's path
   says what the product does or for whom; the cold-arrival reader
   inferred "a system for running AI-agent shops" from the core-task
   list (the experience record of tasks the product must support) at
   minute 55. The architecture principles make the design "the
   authoritative statement of what the product is and does," and the
   architect is accountable for a structural model "readable without
   the code" — neither artifact exists. No customer or user appears in
   any discovery process; the only discovery is the authority in
   dialogue with an agent. *(High.)*
3. **The framing — the pivot every check runs against — is the one
   artifact no role checks and no typedef defines.** It is
   `lead-pm`'s exclusive decision ("no role overrides this one's
   framing"), the criterion always named in the PO output check, and a
   required frontmatter link in two of the four PO typedefs (brief,
   acceptance scenarios) — with no typedef,
   status, measure, or history. The role the authority holds in person
   is the only role whose output is exempt from `define-good-up-front`.
   *(High.)*
4. **Three of the four product risks have a named owner; feasibility is
   owned only by reference** — the architect's six accountabilities
   never name it. Viability is the PM's with no evidence source: the
   admissible-evidence list carries nothing on cost or capacity, and the
   one cost signal (the architect's vendor threshold) escalates to the
   authority, not the PM role. *(High for the text; medium for the
   consequence.)*
5. **Nothing measures an outcome after shipping, so `delivery-verified`
   stops at the demonstration and the product is outside
   `feedback-loops-with-consumers`.** The PM's evidence list names
   "measured outcomes of shipped work"; no process produces one;
   `reconcile-and-close` ends at "follow-ups filed." The principles
   measure the shop's machinery and never the product. *(High; the
   operating-model reader's gloss, "the build trap encoded as a
   principle set," is its judgment.)*
6. **The shop is Shape Up-style bounded delegation to component
   teams, and no document says so.** BC-shops receive a problem slice
   plus a co-produced Gherkin set and are done when every scenario has
   a status — bounded scope, fixed done, not an empowered team choosing
   how to reach an outcome. Coherent as a design; unnamed, so a reader
   applies Cagan's empowered-team expectations to the wrong unit;
   for a request that crosses contexts, the product-process
   report's F6 (Fowler/Narayan) gives the cross-team answer: "solution champions" and initiatives "parceled
   out to pre-existing product-mode teams". The
   appetite Shape Up pairs with bounded work is absent from the brief.
   *(Medium — fit judgment.)*
7. **Three principle conflicts the design carries.**
   `least-context` ("nothing ambient") against `CLAUDE.md` loading the
   principles and primer into every session; `single-source-of-truth`
   against the primer as a second, stale statement of state and against
   inline restatements of framing, ask, and the four risks that the
   cold-reviewer's "unintroduced term" standard has been pushing into
   role files; and `define-good-up-front` against one person holding
   `product-authority` and `lead-pm`. The basis names that same-person
   holding but never says the cold-reviewer screen is therefore the
   check of record; only the product-process report does. State it in
   the basis, or the maker/checker split has no home. *(High for the first two; medium for the third.)*
8. **Under-defined where the product is, over-defined where it is
   not.** No product description, context map, decomposition or ADR
   typedef, operational contract for the lead shop (the contract
   the architecture principle `intent-provenance` says intent enters
   the product through), roadmap, changelog,
   answering step for asks, or `router` role — yet three conversation
   processes with seven-day holds, a 300-line close-out process
   blocking on a tool that "is a spec, not a build," a chain-migration
   process, and three review rounds per definition before any instance
   exists. The migration plan's own Phase 2 rule: "Any definition not
   needed for it is not foundation work." The cold-arrival reader's
   count: ~2,000 lines on how documents are checked, zero describing a
   user, a problem, or an outcome. *(High for the inventory; medium for
   the judgment.)*
9. **No cadence.** The only time constants are `hold-after: P7D` and
   `ask-cap: P1D`; nothing schedules when problems are chosen, bets
   placed, priorities re-read, or users seen. Every loop is
   event-driven from the authority's next message. *(High for the
   observation; low for the prediction that follows — that for one
   person this is the same as no prioritization process — which is
   likely, in use.)*
10. **The ask mechanism's defaults are decisions in disguise for a
    one-person shop.** An ask on scope or intent that goes unanswered
    for a day resolves to the asker's default — so the reserved decision is
    taken by the asking role, the very role the ask exists to keep it
    from; "at most one ask per
    run" presses the asker to guess on the second question; and no
    process defines the answering step for `lead-pm` or the architect.
    Hold-and-resume fits asynchronous fleets; the authority works in
    the interactive position. *(Medium for the reading of the
    definitions; low for the prediction that defaults will silently
    become scope decisions in use — likely, on the one-day cap.)*
11. **What a product leader would copy — the reasons to keep the
    apparatus.** The PM decides from a fresh-context screen verdict,
    never from the artifact, so the backlog-administrator failure is
    designed out; the "definition-change" exit routes an unnamed defect
    to the standard, not the maker — the one feedback loop with a
    named consumer; every loop declares its exit; decisions live only
    as Document History in the changed artifact; the decision-brief
    discipline (answer first, asks with defaults, a budget, an
    independent cold read) is, in the cold-arrival reader's words, "the best-designed decision
    path in the corpus"; the lead-pm anti-rationalization list is, in the same reader's words, "the sharpest writing in the
    corpus"; provenance end to end; usability owned.
    *(High that they are present; medium that they are rare.)*
12. **The product-process proposal, re-read by these lenses.** It
    fills the artifact gaps (strategy, initiative, roadmap, changelog)
    but as written moves the writing of the problem, its measure,
    appetite, and no-gos to the role whose exclusive domain is backlog
    order — the hollowed-out PO of the PM/PO research inverted into a
    hollowed-out PM — and still leaves the framing unscreened and the
    outcome unmeasured. The principle-compatible form: the PM makes
    the initiative (absorbing the framing), the cold reviewer screens
    it against a fitness set, the authority bets in a review — the
    pattern the proposal already uses for the strategy. *(Medium.)*
13. **The judgment — the smallest set of changes that makes one
    feature traceable end to end, and what to defer.** Five changes and
    two repairs, not the dozen the proposal lists: (a) an `initiative` typedef with a status, one outcome
    measure, an appetite, and the framing absorbed as its first section
    — made by `lead-pm`, screened by the cold reviewer, bet by the
    authority; (b) one PO authoring process that ends at the PO output
    check, its skill the compiled rendering — which leaves each PO type
    still without a guideline, so accepting (b) means the authority
    accepts the chain rule unmet for the four PO types during Phase 2's
    first run, recorded in their Document History — a yes/no of its
    own; (c) an
    assignment step the architect runs, carrying checked scenarios to
    a shop; (d) a changelog-and-measure step in `reconcile-and-close`
    that closes the initiative's outcome; (e) the first paragraph the
    primer lacks — what the product is, for whom, what phase we are in
    — before Phase 2 starts, since every reader stumbled on its absence
    first. Plus two one-line repairs: a `router` role, and feasibility
    named in the architect's accountabilities. Defer until a run needs
    them: the three conversation processes' hold machinery, close-out,
    chain-migration, and further review rounds on definitions with no
    instance.
14. **Two decisions only the authority can take.** Whether BC-shops are
    component teams by design (name it) or should become
    stream-aligned for some flows (Fowler/Narayan's cross-team
    initiatives with "solution champions"; LeSS's feature teams); and whether the framing gets its check inside the initiative (13(a)
    absorbs it, and the cold reviewer screens the whole) or on its own
    — answered by 13(a) if taken; live only if 13(a) is declined, in
    which case: a fitness set and a screen for the framing, or accept it
    as the one unchecked artifact, stated as such.

## Method

Three readers in fresh contexts, each given the frame's standard and
one lens: R1 the product operating model (four risks, problems vs
features, vision→strategy→discovery→delivery); R2 coherence — one
imagined feature ("export a report as CSV from the CLI and the GUI",
crossing two contexts) traced hop by hop through every defined process
and artifact, with principle conflicts and orphan activities recorded;
R3 cold arrival — the primer and README first, then only what they
link, sixteen documents in one hour, ending at one concrete decision
("approve a brief"). Each returned quoted basis text with path and
heading. Sources: the basis on `rebaseline` at commit `08fe8a3`, the
five research reports the frame named — a sixth, the
solutions-architect report, was not opened (the product-process report
read from
`origin/research`, since the local `research` ref lags the remote —
noted by one reader), and `main:drafts/migration-plan.md`. No web
source was opened; standards are cited through the reports that carry
them. An independent verification pass reopened the basis files
behind every quote.

## Findings

### F1 — The making pipeline is undefined *(high)*

- R2's trace of ten hops: "Of ten hops, four have a defined carrier.
  Two of those four are the check steps; the making steps between them
  are undefined."
- No framing producer: `discovery-conversation` produces only
  `session_record` (`$ref: session-record, from:
  pkg:shopsystem-knowledge/session-record`); grep of `basis/processes/`
  for "framing" outside `po-output-check` returns nothing;
  `po-output-check` takes `framing: {type: string, format:
  uri-reference}`.
- `no-orphan-activities`: "Every activity in the system MUST be part of
  a defined process"; `lead-po` is "the role that makes the
  requirements" and no process has a brief, scenario set, or order among
  its outputs; `po-output-check` begins with `parameters: [artifact,
  framing, criteria_path]` — the artifact already exists.
- The chain rule: "definition chain — the six linked definitions of
  good for one artifact type; required before instances are authored"
  (glossary); the four PO types hold typedef and fitness set only.
- Assignment: the architect is accountable for "Scenario assignment:
  every accepted scenario mapped to the Bounded Context that owns it";
  no process defines assignment, message composition, or dispatch; the
  BC side arrives as foreign types (`pkg:shopsystem-messaging`,
  `pkg:shopsystem-knowledge`, `pkg:beads`) on a branch whose primer
  says "Nothing exists here except through an explicit import step."
- `reconcile-and-close` runs steps as `run-by: {role: router,
  execution: agent}`; `basis/roles/` holds no `router.md`; "Carried by:
  the existing `reconcile-and-close` skill + executable wrapper" —
  `basis/skills/reconcile-and-close/` exists and is empty; the discrepancy branch files a
  task and ends, with no consuming process.
- Asks: "Answering is an activity of the answering role… those steps
  are defined in the processes that answer, not here"
  (process-definition typedef); no process defines an answering step
  for `lead-pm` or `lead-solutions-architect`.

### F2 — The product is unnamed; discovery has no customer *(high)*

- R3: "No document on the newcomer's path states what the product does
  or for whom"; the primer opens "This is the `rebaseline` branch: the
  greenfield tree of the shopsystem-product migration"; the README
  opens "The `basis/` tree is the shop's definition corpus"; the
  product's substance appears only in `basis/experience/core-tasks.md`
  ("start a run", "answer an ask", "raise a clarify").
- `architecture-principles.md` §bidirectional-conformance: "The design
  — descriptions, contracts, recorded decisions — MUST be the
  authoritative statement of what the product is and does";
  `lead-solutions-architect.md`: "The structural model of the product,
  maintained as an artifact readable without the code" — no such
  artifact in the tree.
- `discovery-conversation.md` §Roles: "product-authority… lead-pm — held
  by the same person; its agent steps assist"; the migration plan's
  Phase 2: "the PM interviews the authority about the
  progressive-disclosure feature"; `lead-product-designer.md` may
  decide "what user research runs" — no process runs any.
- R1: the architect and designer are absent from the discovery process
  though both roles' interfaces and the PM/PO research place feasibility
  and usability "in discovery rather than after it"; `lead-pm`'s
  anti-rationalization "'It's infeasible, so the framing is wrong.' →
  Infeasible returns the problem for re-framing" confirms a post-hoc
  loop.

### F3 — The framing is unchecked and untyped *(high)*

- `glossary.md`: "framing — the PM role's recorded statement of what a
  request is about"; `lead-pm.md`: "the framing of intent… is decided
  by this role alone"; "no role overrides this one's framing."
- `po-output-check.md` §Data: "The framing is always a criterion, named
  `framing`; until a criteria set exists for a type, `criteria_path`
  names the framing itself."
- `brief.md` §Required frontmatter: "`framing` (link to the framing it
  serves)" — R3: "a link to an artifact type that has no typedef";
  `ls basis/artifacts | grep -i fram` returns nothing.
- `principles.md` §define-good-up-front: "The check MUST sit with a
  different role holding a different accountability."
- Product-process report, item 1: the framing "carries no status,
  measure, or history."

### F4 — Risk ownership: feasibility by reference, viability without evidence *(high / medium)*

- `lead-pm.md` §Knowledge and skills: "value and viability here;
  feasibility with the solutions architect; usability with the product
  designer"; `lead-product-designer.md`: "usability is yours."
- `lead-solutions-architect.md` §Accountable for lists the structural
  model, stack and guardrails, decomposition, scenario assignment,
  reconciliation, conformance; "feasibility" appears only in
  §Interfaces: "feasibility and shape return."
- `lead-pm.md` §Admissible evidence: "the originator's own words,
  recorded; discovery-conversation anchors; measured outcomes of
  shipped work; a screen verdict" — nothing on cost or capacity;
  `lead-solutions-architect.md` §Escalates: "any stack decision that
  commits the product to a vendor or a recurring cost above the
  threshold the authority sets."

### F5 — No outcome is measured after shipping *(high)*

- `lead-pm.md` §Admissible evidence: "measured outcomes of shipped
  work"; `reconcile-and-close.md` §Purpose: "the response consumed, the
  work item closed with a traceable reason, the scenario contract
  confirmed, and follow-ups filed" — the flow ends at `file-tail`.
- `principles.md` §delivery-verified: "Work MUST be counted done only
  when its effect is demonstrated in the running system";
  §feedback-loops-with-consumers: "The effectiveness of processes,
  tools, and prompts MUST be measured" — the product is not in the
  list; "Owners of judged checks grade a sample of verdicts on a
  standing calibration schedule" — no calibration process exists.
- A grep for "changelog|metric|measur" over `basis/` finds no hit that
  names a measure of a shipped outcome; the nearest are lead-pm's
  evidence list, the designer's "measured task completion", and the
  experience record's "measured use".
- `bidirectional-conformance` requires "every code element MUST be
  called for by the design"; no reverse-direction instrument exists.
- Ordering: `reconcile-and-close` and `interaction-conformance-check`
  are unordered peers; a work item can close before the conformance
  check runs.

### F6 — Bounded delegation to component teams, unnamed *(medium)*

- `acceptance-scenarios.md`: "the set the PO role submits and the owning
  Bounded Context shop executes"; `reconcile-and-close.md` O3: "The
  scenario register and pinned hashes are confirmed consistent with
  what was dispatched"; `verify` prompt: "Silence on a scenario is a
  discrepancy, not a pass."
- `architecture-principles.md` §knowable-shape: "Each Bounded Context
  MUST be contained and produced by exactly one" shop; `glossary.md`:
  "the lead shop (the system-level coordinator; owns product-level
  artifacts and no Bounded Context) and the BC-shop (owns and produces
  exactly one Bounded Context)."
- Product-process report item 6: LeSS is the contrast, with
  context-owning teams as "component teams"; item 7: "nothing counts
  how often a request crosses contexts"; F6 (Fowler/Narayan):
  "Initiatives don't get their own team. They are parceled out to
  pre-existing product-mode teams."
- `brief.md` §Required sections — Scope, What the shop needs; no
  appetite; product-process item 8(b) puts the appetite on the
  initiative only.

### F7 — Principle conflicts the design carries *(high / medium)*

- `principles.md` §least-context implication: "Whoever runs a session
  loads a conversation's anchor and its definition chain, nothing
  ambient"; `CLAUDE.md` imports `.claude/shop/principles.md` and
  `.claude/shop/primer.md` into every session.
- The primer's §Current state names Phase 1 open items; `basis/` shows
  them done — a second statement of state.
- `principles.md` §single-source-of-truth remedy: "Writers link or
  `$ref` instead of restating"; `lead-pm.md` restates framing and ask
  inline; `lead-product-designer.md` restates the four risks;
  `lead-po.md` says "until they exist, the frozen corpus on `main` is
  the reference" while `basis/artifacts/brief.md` exists; R2: the
  cold-reviewer's "unintroduced term is a defect" standard "is pushing
  text toward restatement and against the principle."
- `po-output-check.md`: `decide` is `lead-pm`; the framing is
  `lead-pm`'s; the fitness set is `product-authority`'s;
  definition-change routes to the same person; the different role in
  the loop is `cold-reviewer`; product-process item 8(a): "the cold
  reviewer's screen is the check of record, since the authority holds
  `lead-pm` in person, an accepted arrangement."
- `interaction-conformance-check.md`: "screener — lead-product-designer
  in a fresh context… Decider — the same role"; the corpus screened is
  that role's exclusive domain; R2: "the same role with amnesia."

### F8 — Over- and under-definition *(high / medium)*

- Missing typedefs and processes: product description, context map,
  decomposition, ADR, the lead shop's operational contract
  (`intent-provenance` requires intent to "enter the product through a
  contract"), roadmap, changelog, answering steps, `router`.
- Present: `discovery-`, `review-`, `work-conversation`, each
  `hold-after: P7D` with classification enums, plus `session-handoff`,
  all with `bd` runtime steps; `corpus-close-out` (~300 lines) on
  `archive-move`, "a spec, not a build… The steps that call it block
  until the tool exists"; `definition-chain-migration` requiring six
  links per type; `brief.md` v1→v3 in one day.
- `main:drafts/migration-plan.md` §Phase 2: "Any definition not needed
  for it is not foundation work — it gets built later, by the run that
  needs it."
- R3: "Nine working principles, an architecture set, an experience set,
  six roles, twelve processes, nineteen typedefs, nine fitness sets and
  eleven guidelines exist before the first feature" — the verifier
  counts twenty typedefs; the other counts hold.
- R3 on undefined tools and terms: `bd`, CEL, SCQA, BLUF,
  `pkg:shopsystem-knowledge`, "work item", "meta-chain" pass through
  undefined; the glossary's "definition chain — the six linked definitions" never
  enumerates the six, which live in `basis/types/definition-chain.md`,
  linked from nothing on the newcomer's path; the glossary interleaves ~12 migration-mechanics
  terms with the product-model terms.

### F9 — Cadence and the ask mechanism *(medium)*

- Time constants: `hold-after: P7D` in seven processes; `ask-cap: P1D`
  in two; every conversation loop returns to an `observe` step run by
  `product-authority`.
- `process-definition.md` §Run lifecycle: "An unanswered ask resolves
  to its `default` at the process's `ask-cap`… and the run resumes on
  the default"; "A step returns at most one ask per run — the loop's
  exit — and a second resolves `defaulted` at once";
  `po-output-check.md` `revise`: asks may concern "the originator's
  intent, whether a thing is in scope."
- PM/PO one-role report: "`lead-pm` runs in the authority's own turn."

### F10 — What is unusually strong *(high that present; medium that rare)*

- `po-output-check.md` O2: "the artifact reaches the PM role only
  through the findings' quotes — witnessed by `decide`'s inputs, which
  exclude the artifact"; guiding statement: "A finding the criteria
  cannot name is a missing criterion, and the decision that follows is
  a definition change, not a verdict on the maker."
- `process-definition.md`: "Every loop declares its exits as labeled
  branch rows."
- `review-record.md`: decisions trace "in the changed artifacts'
  Document History, never in a standing ledger."
- `decision-brief.md`: "≤ ~400 words", answer first, asks with
  defaults, independent cold read; R3: "the best-designed decision path
  in the corpus."
- `lead-pm.md` §Anti-rationalization: "'The PO knows what I meant.' →
  A framing is recorded or it does not exist" — R3: "the sharpest
  writing in the corpus."
- `architecture-principles.md` §intent-provenance: "any activity can be
  traced back to the originating expression without ambiguity."
- `lead-product-designer.md`: usability owned — the fourth risk most
  startups leave unowned.

## Alternatives considered

- **Judge the system as a delivery apparatus only.** All three readers
  rejected it: the shop's own principles (`delivery-verified`,
  `feedback-loops-with-consumers`) and its cited standard make outcome
  and product the test. Rejected.
- **Treat the product-process proposal as sufficient.** It fills the
  artifact gaps but inherits the unchecked framing and unmeasured
  outcome, and moves the problem statement to the PO. Partially
  adopted (item 13 keeps its initiative, re-homed).
- **Build all dozen changes the proposal lists.** R2's trace shows
  four definitions make one feature traceable, plus the primer
  paragraph and two repairs; the Phase 2 rule defers the rest.
  Rejected in favour of the five and two.
- **Read with a persona.** Rejected on the research-prompting report's
  finding; each reader was given a standard instead.

## Limitations

- The system is judged as a design; no feature has run through it.
  Predictions carry their likelihood in their own phrase (items 9, 10).
- The readers did not open the BC-shop side (`main`'s frozen shops,
  the `pkg:` packages); findings about dispatch and reconciliation are
  from the lead shop's definitions alone.
- The local `research` ref lags `origin/research`; one reader noted
  the product-process report was read from the remote.
- Counts (documents, lines, rounds) are the readers' at commit
  `08fe8a3`.
- What would change the judgment: a first feature run through the
  chain in Phase 2 showing the making hops are supplied by the
  authority's own turn cheaply enough that defining them is not worth
  the definition cost; or an authority decision that the framing is
  accepted unchecked by design.

## Sources

The basis on `rebaseline` at `08fe8a3`: `.claude/shop/primer.md`;
`basis/README.md`; `basis/principles.md`;
`basis/architecture-principles.md`; `basis/experience-principles.md`;
`basis/glossary.md`; `basis/roles/*` (six); `basis/processes/*`
(twelve); `basis/artifacts/*` (request, brief,
product-decision-record, acceptance-scenarios, backlog-order,
definition, process-definition, review-record, research-index,
experience-record, decision-brief, fitness-set); `basis/types/*` (ask,
check-decision, verification); `basis/fitness/brief.fitness.md`;
`basis/experience/core-tasks.md`; `basis/tools/lint_basis.py`;
`CLAUDE.md`. `main:drafts/migration-plan.md`. Research reports:
`research/product-process-2026-08.md` (at `de72efa`, `origin/research`),
`pm-po-one-role-2026-08.md`, `pm-po-roles-2026-08.md`,
`product-designer-role-2026-08.md`, `research-prompting-2026-08.md`.
No web source opened.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-27 | update | Draft synthesized from three lens readers' notes. |
| 1 | 2026-08-27 | review | Verification round 1: findings — one retraction (a Fowler "checkout" quote no report carries); a hop count stated two ways; counts (typedefs, hold-after, PO typedefs with a framing link, readers noting the branch lag, reports) corrected; report item numbers; a label mixing confidence and likelihood. |
| 2 | 2026-08-27 | update | Round-1 repairs applied. |
| 2 | 2026-08-27 | review | Verification round 2: clean — all sixteen repairs confirmed at source; five further quotes exact; labels conform. |
| 3 | 2026-08-27 | update | Finalized as the report; cold read opened. |
| 3 | 2026-08-27 | review | Cold read round 1: findings — 13(b)'s effect on the chain rule undecidable; item 9's label folded a prediction into medium; item 7's third clause unparseable; carrier, making hop, reader names, and report citations unintroduced. |
| 4 | 2026-08-27 | update | Repairs: 13(b) states the chain rule's treatment and the count is five changes and two repairs; item 9 split high/low; item 7 in two sentences with the ask explicit; vocabulary block extended; report citations disambiguated. |
| 4 | 2026-08-27 | review | Cold read round 2: findings — 13(b) asked acceptance of a chain-rule consequence it did not name; 14's second decision depended on 13(a) unstated; item 10's low half named no prediction; item 1's closing clause; a stale count in Alternatives. |
| 5 | 2026-08-27 | update | Repairs: 13(b)'s consequence stated as its own yes/no; (e) placed before the deferrals; 14's dependency on 13(a) stated; item 10's prediction named with its likelihood; item 1's clause rewritten; Alternatives reconciled; method split from the label key. |
| 5 | 2026-08-27 | review | Cold read round 3: clean — 13(b)'s consequence and 14's dependency decidable; labels reproducible; three non-blocking notes polished in place. |
| 6 | 2026-08-27 | state | draft → delivered. |
