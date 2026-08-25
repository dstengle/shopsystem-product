---
type: research-report
id: pm-po-roles-2026-08
status: delivered
version: 6
date: 2026-08-25
question: How does industry define the product manager and product owner roles — accountabilities, decision rights, deliverables — and the interactions between them and with the solutions architect, so that lead-pm and lead-po are complete and clear and the three seats' interactions are defined?
requested-by: product-authority
created: 2026-08-25
updated: 2026-08-25
---

# Research report: the product manager and product owner roles, and their interactions with the solutions architect

## Executive summary

*How to read the labels.* Each finding carries a confidence: **high** —
several sources opened in full agree, at least one of them primary (the
standard, framework, or author itself); **medium** — one opened source,
or only secondary accounts; **low** — recall without a source, or a
primary that could not be read. "Secondhand" marks a quote taken from a
secondary account because the primary was unreachable. An independent
verification pass — a fresh context that reopened every cited source —
ran up to three rounds; its residuals are in Limitations.

*How the sources' vocabulary maps to the shop's seats.* Cagan's
"Product Lead Engineer" and SAFe's "System Architect" are
`lead-solutions-architect`; "Developers", "the team", and "engineering"
are the Bounded Context shops — the shops that each own one Bounded
Context, a designed region of the product; the "interactive seat" is
`lead-pm`, which runs in the human's own turn, and the "batch seat" is
`lead-po`, which runs as a subagent; "enablers" (SAFe) are technical
work items that make features possible; "brief-030" is the pending
decision brief on role depth and the skills import. Shop terms: a
*scenario register* is a Bounded Context shop's own list of the
acceptance scenarios it holds; the *decomposition* is the architect's
record of which Bounded Context owns which capability; a *clarify* is
a shop's typed question back to the lead shop; a *discovery-
conversation anchor* is the governed record a discovery conversation
attaches to; *requirements artifacts* are the brief, the product
decision record (the record of a product-level decision), and the
acceptance scenarios.

1. **Industry is split on whether PM and PO are two seats — and the
   shop's split survives the strongest objection only if one seat owns
   the outcome.** SAFe (the Scaled Agile Framework) splits by level —
   Product Management owns vision, roadmap, and the program backlog;
   the Product Owner owns the team backlog and alone accepts stories.
   Pragmatic Institute splits by facing — market-facing PM,
   development-facing PO. Marty Cagan (Silicon Valley Product Group)
   rejects the split for a product team: it "typically yields very weak
   product", "there is no clear owner", and when the product manager
   is cast as a Scrum product owner "the product manager is really a
   backlog administrator". The
   Scrum Guide has one Product Owner, "one
   person, not a committee", who "may delegate the responsibility to
   others. Regardless, the Product Owner remains accountable." The
   reconciliation for this shop: `lead-pm` is the one accountable seat
   for the product's outcome; `lead-po` holds delegated work — backlog
   and acceptance — never the accountability. *(High on the sources;
   medium on the reconciliation, which is this report's judgment.)*
2. **The PM's decision rights, by risk.** Cagan's four risks give the
   cleanest boundary in any source: "The Product Manager is responsible
   for the value and viability risks, and overall accountable for the
   product's outcomes"; "The Product Lead Engineer is responsible for
   the feasibility risk, and overall accountable for the product's
   delivery"; design owns usability. Melissa Perri: the PM owns "the
   why, what to build, why it matters", the roadmap and the priority;
   the build trap is shipping "with no measures of success" — outputs
   in place of outcomes. Pragmatic: the PM tells development "about the
   problem", not the solution. *(High.)*
3. **The PO's decision rights, and who owns acceptance.** The Scrum
   Guide makes the PO accountable for the Product Goal, backlog items,
   their ordering, and transparency; sizing belongs to the Developers
   and the Definition of Done to the whole team. No opened source has
   the PO author acceptance scenarios alone: Cucumber's official
   guidance makes Gherkin a "Three Amigos" co-product — the PO brings
   scope and "identif[ies] the problem", tester and developer write
   the scenarios and steps, and a pair may write "as long as their
   output is actively reviewed by the product owner"; having "the
   person with the most domain knowledge write the scenarios" is,
   in Cucumber's words, "a weak-ass move". The PO's decision is
   acceptance — which scenarios count as done — not authorship.
   *(High.)*
4. **The PO ↔ architect boundary is "what, not how".** Cohn: "the
   product owner's job is to specify what to build, not how to build
   it"; a PO may dictate architecture only "sparingly, wisely and
   ideally, in consultation with the team". Wolpers: a PO supplying
   "the 'How'" is an anti-pattern — "The Developers answer the 'How'
   question". Xebia: architects promote design ideas with a business
   case onto the backlog, but "which design ideas to implement is
   ultimately made by the product owner". SAFe: the architect defines
   enablers and non-functional requirements; NFRs ride as Definition
   of Done constraints. *(High — Cohn's own text plus two practitioner sources opened in
   full agree; SAFe abstracts concur.)*
5. **The PM ↔ architect boundary is value versus feasibility, decided
   in discovery.** Cagan's split (above); Teresa Torres's product trio
   — PM, designer, engineer — "jointly responsible for a shared
   outcome", interviewing and choosing opportunities together, the
   hand-off model producing "mercenary teams"; a practitioner triad
   puts "the Architect... responsible for ensuring the technical
   feasibility of the feature" while "the Product Owner is ultimately
   responsible for product decisions"; SAFe names Product Management
   and the System Architect co-leaders who negotiate capacity for
   enabler work. *(High for the value/feasibility split; medium for
   the mechanics.)*
6. **The recorded failure modes are symmetric.** Product side: the
   build trap and feature factory — stakeholders dictate features, the
   PM becomes "a waiter", success is "story points completed, not
   outcomes"; the proxy or order-taker PO — the "ticket monkey"
   breaking stakeholder documents into tickets; the PO specifying how.
   Architecture side: the "architecture astronaut" — abstraction
   detached from any user problem. Structural: two people Accountable
   for one decision — "power struggles and decision-making delays".
   *(Medium — practitioner and secondary sources.)*
7. **A gap the sources expose: the lead shop has no usability seat.**
   Every model that names the PM's peers — Cagan's four risks, Torres's
   trio — gives usability its own owner (design). The lead shop's three
   seats cover value/viability, acceptance, and feasibility; usability
   risk has no seat. *(High that the models say so; the gap itself is
   this report's observation.)*
8. **The report's proposal for `lead-pm`, `lead-po`, and the three
   seats' interfaces** — a proposal composed from findings 1–7, not a
   finding, so it carries no confidence label; written to the
   six-section role form (posture, decision rights, admissible
   evidence, interfaces, knowledge and skills, anti-rationalization),
   with the last two sections of each role set out in "What this
   means" below.
   **`lead-pm`.** *Posture:* outcomes, not outputs; problems to solve,
   never features to build; ground before probing — engage the
   authority's statements as an interlocutor and operationalize
   nothing before the authority converges; the seat holds the
   product's outcome and holds it alone. *Decision rights — decides:*
   the framing of intent — what the shop takes an expression to be
   asking for — as the exclusive domain, unchanged from today's role
   text ("what the shop takes an expression to be asking for is decided
   by this seat alone"); and the value and
   viability judgment on any candidate: what problem is worth solving
   and whether the product can sustain the solution. *— recommends:*
   roadmap-level priority — which framed problems come first — to the
   authority. *— escalates:* every product decision the authority
   reserves; any conflict between the PO's scope and the architect's
   feasibility verdict. *— never decides:* feasibility (the
   architect's), acceptance (the PO's), backlog order (the PO's).
   *Admissible evidence:* the originator's own words, recorded;
   discovery-conversation anchors; measured outcomes of shipped work.
   Not authoritative: a stakeholder's feature list read as a
   requirement; the PO's backlog read as the product's intent.
   *Interfaces:* the authority — discovery conversations in, decisions
   out; `lead-po` — framed intent and the outcome it serves out,
   requirements artifacts and scope questions in;
   `lead-solutions-architect` — framed problem and outcome out;
   feasibility verdict, technical risks, and questions in, during
   discovery rather than after it.
   **`lead-po`.** *Posture:* commitment owner, not order taker — scope
   is declined with a recorded reason when it serves no framed
   outcome; what, never how. *Decision rights — decides:* acceptance —
   which scenarios count as done for a behavior — as the exclusive
   domain, replacing today's "the wording of acceptance scenarios";
   backlog content and order within the PM's framing. *— recommends:*
   scope changes to the PM; scenario splits to the Bounded Context
   shop that owns the behavior. *— escalates:* scope conflicts, and
   any scenario the architect reports as infeasible or crossing
   contexts, to the PM. *— never decides:* how a behavior is built
   (the shops' and the architect's); which problem is worth solving
   (the PM's); roadmap-level priority (the PM's recommendation, the
   authority's decision). *Admissible evidence:* the PM's framed
   intent; a sweep of every context's scenario register, never one
   context's copy; the architect's decomposition for where a scenario
   lands. Not authoritative: a stakeholder document transcribed into
   tickets; a scenario the PO wrote alone without the owning shop's
   steps. *Interfaces:* `lead-pm` — framed intent in, requirements
   artifacts and scope questions out; `lead-solutions-architect` —
   accepted scenarios out for assignment; enabler recommendations,
   non-functional constraints, and decomposition changes in, for
   backlog decisions; the backlog kept structured to mirror the
   decomposition; Bounded Context shops — scenarios co-produced
   three-amigos style (PO: scope and approval; shop: steps and edge
   cases; architect: context ownership and feasibility); clarify
   questions on scope and vocabulary answered.
   **Interfaces among the three seats** (the contract): PM → architect:
   framed problem and outcome; architect → PM: feasibility verdict,
   risks, questions — in discovery. PM → PO: framed intent and outcome;
   PO → PM: requirements artifacts, scope questions. PO → architect:
   accepted scenarios for assignment; architect → PO: enabler
   recommendations, non-functional constraints, decomposition changes
   affecting the backlog's structure. What a feasibility verdict does:
   an "infeasible" verdict halts assignment of the framed problem or
   scenario and returns it to the PM for re-framing — it is not a veto
   on the what, and the PM escalates to the authority only if
   re-framing fails; the PO's escalation of an infeasible scenario goes
   to the PM, never past it. Disagreement rule: no seat decides in
   another's domain — the PM cannot direct the how, the architect
   cannot veto the what, the PO cannot re-frame; an unresolved
   conflict escalates to the authority and is recorded. Usability
   (finding 7): the proposal leaves it unowned and lists it as a
   decision the authority must take — a fourth seat, an added
   `lead-pm` accountability, or a deliberate omission.

## Method

Three parallel gather workers in fresh contexts, 19 searches, 30 pages
opened in full and 5 as abstracts (SAFe's role pages are login-walled;
Perri's own essays returned 404, so her positions come from a talk
write-up, a podcast transcript, and a reader's notes; the Medium
PM/PO RACI was unreachable; Adzic's book text was not opened).
Evidence was extracted quotes-first into 18 entries, then synthesized;
an independent fresh-context verification pass followed.

## Findings

### F1 — Two seats or one *(high on the sources; the reconciliation is judgment, medium)*

- SAFe Product Management: "responsible for defining desirable,
  viable, feasible, and sustainable solutions"; "manage and prioritize
  the ART backlog"; leads "as leaders of the Agile Release Train" with
  the System Architect. SAFe Product Owner: "primarily responsible for
  maximizing the value delivered by the team by ensuring that the team
  backlog is aligned"; "part of the larger Product Management
  function"; secondhand — carried by third-party training and
  reference pages (a Global Knowledge SAFe POPM page; the O'Reilly
  SAFe 4.0 Reference Guide), not the public role page: "the only team
  member empowered to accept stories as done".
- Pragmatic Institute: the PM is "the 'messenger of the market'"; "The
  product owner is a development-facing role designed as the 'key
  stakeholder' on the requirements for development"; "The product
  owner's focus should be on helping the Agile team run faster... The
  product manager's focus should be on helping the business run in the
  right direction".
- Cagan: splitting "typically yields very weak product and little
  innovation"; "there is no clear owner (neither person takes
  responsibility for the product)"; "I didn't really care what the
  person was called, so long as it was one person."
- Scrum Guide: "The Product Owner is accountable for maximizing the
  value of the product"; "may delegate the responsibility to others.
  Regardless, the Product Owner remains accountable."; "one person,
  not a committee"; "the entire organization must respect their
  decisions."
- Reconciliation (judgment): the shop's split is by execution position
  — the PM seat holds the human's turn open, the PO seat runs as a
  subagent — not by product scope. Cagan's objection is answered only
  if exactly one seat is accountable for the outcome. The Scrum Guide's
  delegation rule gives the form: `lead-pm` accountable, `lead-po`
  holding delegated backlog and acceptance work.

### F2 — The PM's decision rights *(high)*

- Cagan, four risks: "feasibility risk (whether our engineers can
  build what we need with the time, skills and technology we have)";
  "The Product Lead Engineer is responsible for the feasibility risk,
  and overall accountable for the product's delivery."; "The Product
  Manager is responsible for the value and viability risks, and
  overall accountable for the product's outcomes." Start-here:
  "responsible for ensuring that what gets built is both valuable and
  viable"; empowered PMs receive "problems to solve" not "features to
  build"; "feature teams deliver output, but product teams deliver
  outcomes."
- Perri (secondhand — her essays were unreachable): "Product
  management is really in charge of the why, what to build, why it
  matters."; "Product managers own the roadmaps, they own the
  priority"; "Agile does not have a brain... it does not, and never
  has, told you what to build."
- Pragmatic: the PM observes "customer problems that our company can
  solve, and then tell[s] the development organization about the
  problem."
- Mind the Product's competency framework (abstract): "You likely hold
  no positional power, so your influencing and collaboration skills
  are essential." — decision rights by influence in most
  organizations; in this shop the authority grants them explicitly.

### F3 — The PO's decision rights and acceptance *(high)*

- Scrum Guide: accountable for "Developing and explicitly
  communicating the Product Goal; Creating and clearly communicating
  Product Backlog items; Ordering Product Backlog items; Ensuring that
  the Product Backlog is transparent, visible and understood."; "The
  Developers who will be doing the work are responsible for the
  sizing."; the Definition of Done is the Scrum Team's — "the Scrum
  Team must create a Definition of Done appropriate for the product"
  when no organizational standard exists.
- Cucumber, who does what: "The Three Amigos is a meeting that takes
  user stories and turns them into clean, thorough Gherkin scenarios.
  It involves three voices (at least)"; the PO "is most concerned
  with the scope of the application"; the tester "will be generating
  lots of Scenarios"; the developer "will add many of the Steps"; a
  pair may write "as long as their output is actively reviewed by the
  product owner (or business representative)." Discovery workshop:
  the PO's job is to "identify the problem the team should be trying
  to solve"; rules are "acceptance criteria the team has agreed
  upon". Blog: "have the people who learned the most in that
  conversation — that's generally going to be the tester and
  developer — go off and write down what they heard as scenarios."
- Humanizing Work, splitting: "Invite a whole team or at least a good
  mix of business and technical perspectives."; a good split "needs
  to be a concrete change in system behavior."
- Implication: the current `lead-po` exclusive domain — "the wording
  of acceptance scenarios" — claims authorship the practice
  distributes. The decision that is the PO's alone is acceptance.

### F4 — The PO ↔ architect boundary *(high — three sources opened in full agree, Cohn's primary among them)*

- Cohn: "the product owner's job is to specify what to build, not how
  to build it"; POs "can dictate architectural decisions. But they
  should do so sparingly, wisely and ideally, in consultation with the
  team."
- Wolpers: the anti-pattern of a PO "providing not just the 'Why' but
  also the 'How' and the 'What.' (Just stick with the Scrum Guide and
  its built-in checks & balances: The Developers answer the 'How'
  question"; "The Product Owner is the
  only person to decide what tasks become Product Backlog items".
- Xebia: "The choice of which design ideas to implement is ultimately
  made by the product owner. Architects have an important role in
  explaining and promoting these ideas."; "A design idea with a valid
  business case of its own should also be placed on the product
  backlog."
- SAFe (abstracts): the System Architect works by "defining enablers,
  participating in solution definition, outlining non-functional
  requirements (NFRs), and managing capacity for enablement work";
  "NFRs are persistent qualities and constraints typically revisited
  as part of the definition of done (DoD)". A practitioner source:
  "By collaborating with architects, PO/PMs can ensure that these
  items are appropriately tracked and prioritized in the backlog."
- Reading: the architect proposes and argues; the PO decides whether
  and when architectural work enters the backlog; the PO never
  specifies the how; non-functional requirements ride as constraints
  on done, not as ordinary scenarios.

### F5 — The PM ↔ architect boundary *(high for the split; medium for the mechanics)*

- Cagan (F2): value and viability to the PM; feasibility to the lead
  engineer; "intense collaboration with design and engineering" is
  where winning solutions come from.
- Torres, product trio: "typically comprised of a product manager, a
  designer, and a software engineer... the three roles that—at a
  minimum—are required to create good digital products"; "jointly
  responsible for a shared outcome. They interview customers
  together...choose a target opportunity together...generate solutions
  together."; the hand-off model "often results in designers and
  engineers working as what Marty Cagan... calls 'mercenary teams'
  instead of 'missionary teams'".
- Illustrated Agile (practitioner): "The Architect is responsible for
  ensuring the technical feasibility of the feature. This includes
  staff capability and technical availability."; "While the Product
  Owner is ultimately responsible for product decisions, the discovery
  team develops the product vision collectively."
- decode.agency (practitioner): "Determining if your idea is
  technically feasible is the most important task the solution
  architect has in the product discovery process."
- SAFe (abstract) plus secondary accounts: Product Management and the
  System Architect are co-leaders; "Product managers work with system
  architects to identify technical requirements to support the
  solution and allocate capacity for this work."
- A sample RACI (secondary): the PM Accountable at every stage, the
  architect Responsible in design only; "The person accountable...
  should always be ONE single person".

### F6 — Failure modes *(medium)*

- Build trap / feature factory: teams "defining and shipping software
  with no measures of success"; "Stakeholders dictate what gets built,
  not user insights"; "Success is measured in story points completed,
  not outcomes achieved"; "Every feature adds technical debt"; the PM
  as "a waiter... an order taker" when "Leadership had passed down
  feature requests rather than expected outcomes and goals."
- Proxy and order-taker PO: the "ticket monkey" who "creates Product
  Backlog items by breaking down requirement documents received from
  stakeholders"; without the PO's sole decision over backlog items
  "Scrum turns into a pretty powerful waterfall 2.0 process."
- Dual accountability: "Assigning more than one person as Accountable
  for a task can lead to power struggles and decision-making delays."
- Architecture astronaut (Spolsky): "When you go too far up,
  abstraction-wise, you run out of oxygen... high-level pictures...
  that don't actually mean anything at all."

### F7 — The usability gap *(high that the models say so)*

- Cagan's four risks assign usability to design; Torres's trio
  requires a designer as one of "the three roles that—at a minimum—are
  required". The lead shop's three seats cover value/viability
  (`lead-pm`), acceptance (`lead-po`), and feasibility
  (`lead-solutions-architect`). Usability risk has no owner. Whether
  that is a fourth seat, a PM accountability, or a deliberate omission
  is the authority's call.

## What this means for the two roles

The proposal text is executive-summary item 8 (posture, decision
rights, admissible evidence, interfaces, and the three-seat contract),
kept in one place. The remaining two sections of each role:

**`lead-pm` — knowledge and skills:** discovery interviewing and
opportunity mapping; problem framing; outcome measurement; the
stakeholder-presentation process; the technique skills the pending
skills-import decision brings in. **Anti-rationalization:** "The
stakeholder asked for a feature, so that is the requirement." → the
problem behind it is the requirement. "We shipped it, so it is done."
→ an outcome, not an output, is done. "The PO can hold that
conversation." → the seat that runs in the human's turn is this one.
"Engineering says it is easy, so we should build it." → feasibility is
not value.

**`lead-po` — knowledge and skills:** Gherkin as an acceptance
language; example mapping; work splitting; the brief, product decision
record (the record of a product-level decision), and scenario writing
skills. **Anti-rationalization:** "The stakeholder's document is the
backlog." → the ticket monkey; frame first. "I will specify how, it is
faster." → the how belongs to the shops. "I will write the scenarios
myself." → co-produce; approve. "Priority is the PM's call." → roadmap
priority is; backlog order within the framing is this seat's.

Two changes are substantive rather than presentational: `lead-po`'s
exclusive domain moves from scenario *wording* to scenario
*acceptance*, with authoring co-produced; and `lead-pm` gains the
value-and-viability judgment as a decision right, with feasibility
explicitly not its to decide. The interface contract among the three
seats is new — today the roles name each other only loosely.

## Alternatives considered

- *One product seat (Cagan's model).* Industry-backed for a co-located
  human team; rejected because the shop's split is forced by execution
  topology — the interactive seat and the batch seat cannot be the
  same context — and the outcome-accountability rule answers the
  objection.
- *PO authors scenarios alone (the current role).* No source supports
  it; the BDD sources reject it. Rejected in favor of acceptance as
  the decision and three-amigos authoring.
- *Torres's fully joint trio with no decider.* Rejected as the shop's
  form: the shop requires one accountable seat per decision; the
  trio's joint discovery is adopted as the interaction pattern, the
  decision rights stay split by risk.
- *Fold the PO into the PM and give the PM a subagent for backlog
  work.* Equivalent to the current split under a different name;
  rejected as a rename without content.

## Limitations

- SAFe's role pages are login-walled: the PM/PO/architect mechanics
  (capacity allocation, "content authority", acceptance as the PO's
  sole right) rest on abstracts and secondary accounts.
- Melissa Perri's own essays returned 404; her positions are
  secondhand throughout.
- No published RACI with PM, PO, and architect as separate columns was
  found; the interface contract in item 8 composes Cagan's risk split,
  the Scrum Guide's delegation rule, Cucumber's three-amigos practice,
  and Xebia's backlog rule.
- The reconciliation of the PM/PO split (F1) and the usability gap
  (F7) are this report's judgments, labeled as such.
- Sweep was one session, US-only search index.

## Sources (opened this run)

- Scrum Guide 2020: https://scrumguides.org/scrum-guide.html — full
- SAFe Product Management; Product Owner; System Architect; Nonfunctional Requirements: https://framework.scaledagile.com/product-management/ ; https://framework.scaledagile.com/product-owner/ ; https://framework.scaledagile.com/system-architect/ ; https://framework.scaledagile.com/nonfunctional-requirements/ — abstract only (login)
- Cagan, Product Manager vs Product Owner; Revisited; Four Big Risks; Product Management: Start Here; Behind Every Great Product: https://www.svpg.com/product-manager-vs-product-owner/ ; https://www.svpg.com/product-manager-vs-product-owner-revisited/ ; https://www.svpg.com/four-big-risks/ ; https://www.svpg.com/product-management-start-here/ ; https://www.svpg.com/behind-every-great-product/ — full
- Perri via Mind the Product talk write-up; Product Thinking podcast; Larson's notes: https://www.mindtheproduct.com/escaping-build-trap-melissa-perri/ ; https://www.produxlabs.com/product-thinking-blog/episode-252-project-product-management ; https://lethain.com/notes-escaping-the-build-trap/ — full, secondary
- Pragmatic Institute, Role of Product Management; PO vs PM guide: https://www.pragmaticinstitute.com/resources/articles/product/role-of-product-management/ ; https://www.pragmaticinstitute.com/resources/articles/product/comprehensive-guide-product-owner-vs-product-manager/ — full
- Cucumber, Who does what; Discovery workshop; Who writes the scenarios: https://cucumber.io/docs/bdd/who-does-what/ ; https://cucumber.io/docs/bdd/discovery-workshop/ ; https://cucumber.io/blog/bdd/who-writes-the-cucumber-scenarios/ — full
- Cohn, Can a product owner dictate the architecture: https://www.mountaingoatsoftware.com/blog/can-a-product-owner-dictate-the-architecture — full
- Wolpers, PO anti-patterns: https://age-of-product.com/product-owner-anti-patterns/ — full, secondary
- Pichler, Demystifying the PO role; Six types of product owners: https://www.romanpichler.com/blog/demystifying-the-product-owner-role/ ; https://www.romanpichler.com/blog/six-types-of-product-owners/ — full, secondary
- Xebia, the architect in Scrum: https://xebia.com/blog/architects-scrum-4-what-is-the-role-of-the-architect-in-scrum/ — full, secondary
- Humanizing Work, splitting user stories: https://www.humanizingwork.com/the-humanizing-work-guide-to-splitting-user-stories/ — full
- Torres, Product trio: https://www.producttalk.org/product-trio/ — full
- Illustrated Agile, PO/designer/architect partnership: https://illustratedagile.com/2012/07/10/powerful-partnership-product-owner-designer-architects/ — full, secondary
- Aha!, PM in SAFe; agile-hive, SAFe System Architect; agileseekers, NFR enablers; decode.agency, solution architect in discovery: https://www.aha.io/roadmapping/guide/product-development-methodologies/what-is-the-role-of-pm-in-safe ; https://agile-hive.com/blog/scaled-agile-framework-system-architect/ ; https://agileseekers.com/blog/collaborating-with-system-architects-to-refine-non-functional-enablers ; https://decode.agency/article/solution-architect-in-product-discovery/ — full, secondary
- LogRocket, sample RACI; feature factory; Meegle, RACI for product ownership: https://blog.logrocket.com/product-management/sample-raci-chart-best-practices-template/ ; https://blog.logrocket.com/product-management/build-trap-dangers-feature-factory-mindset/ ; https://www.meegle.com/en_us/topics/raci-matrix/raci-matrix-for-product-ownership — full, secondary
- Wikipedia, Architecture astronaut: https://en.wikipedia.org/wiki/Architecture_astronaut — full, secondary
- Mind the Product, PM competency framework announcement: https://www.mindtheproduct.com/product-management-growth-team-effort/ — abstract
- Secondhand carriers of the SAFe "accept stories as done" line: https://www.globalknowledge.com/en/certifications/certification-training/safe/safe-product-owner---product-manager — full (verified by the verifier); the O'Reilly SAFe 4.0 Reference Guide, ch. 18 — not opened.
- UNOPENED: Perri's essays (404); Medium PM/PO RACI (403); Scrum.org PO anti-patterns (403); Adzic's Specification by Example text.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-25 | update | Drafted from three parallel gather workers' notes (18 evidence entries) through the research-inquiry process. |
| 1 | 2026-08-25 | review | Verification round 1 (fresh context, sources reopened): findings — a misattributed subject (Cagan's "backlog administrator" is the PM under the Scrum PO conception); a paraphrase presented as a quote; a SAFe line marked as on-page that is secondhand; a Definition-of-Done paraphrase unmarked; an elision unshown. |
| 2 | 2026-08-25 | update | Round-1 repairs applied. |
| 2 | 2026-08-25 | review | Verification round 2: findings — one quotation still inexact (the round-1 replacement wording was itself inaccurate); three polish items. |
| 3 | 2026-08-25 | update | Round-2 repairs: the practitioner quote replaced with the verbatim sentence; the secondhand carriers of the SAFe acceptance line named; Torres's attribution of "mercenary teams" to Cagan shown; a needless paraphrase marker dropped. |
| 3 | 2026-08-25 | review | Verification round 3 (cap): clean — every quotation and label reproduced; three polish items offered. |
| 4 | 2026-08-25 | update | Polish applied: the secondhand carriers of the SAFe acceptance line listed as sources; F4 raised to high per the scheme; the Cagan gloss tightened. Report finalized. |
| 4 | 2026-08-25 | review | Cold read round 1 (as the consumer): actionable from the summary; precision residuals — the sources' vocabulary unmapped to the seats, exclusive domains referenced not stated, two priority rights overlapping, a stale label, item 8 over-long. |
| 5 | 2026-08-25 | update | Presentation repairs: vocabulary map added; exclusive domains stated in full; priority rights separated (roadmap-level to the PM's recommendation, backlog order to the PO); splits recommended to the owning shop; knowledge and anti-rationalization moved to the body; the Cagan gloss simplified. |
| 5 | 2026-08-25 | review | Cold read round 2: clean — actionable from the summary and the body's two role sections; precision polishes offered. |
| 6 | 2026-08-25 | update | Polishes applied: the feasibility-verdict rule stated; usability listed as a required decision; shop terms glossed in the vocabulary map; the current exclusive-domain wording quoted. |
| 6 | 2026-08-25 | state | draft → delivered to the product authority; registered in the research index on `rebaseline`. |
