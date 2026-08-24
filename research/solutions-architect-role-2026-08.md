---
type: research-report
id: solutions-architect-role-2026-08
status: delivered
version: 7
date: 2026-08-23
question: How does industry define the solutions architect role, and how would it replace lead-architect as lead-solutions-architect — owning product-wide technology stack decisions — complementing lead-po and lead-pm?
requested-by: product-authority
created: 2026-08-23
updated: 2026-08-23
---

# Research report: the solutions architect role

## Executive summary

*How to read the labels.* Each finding carries a confidence: **high**
— several sources opened in full agree, at least one of them primary
(the standard, framework, or author itself); **medium** — one opened
source, or only secondary accounts (a practitioner or explainer
describing the primary); **low** — recall without a source, or a
primary that could not be read. "Secondhand" marks a quote taken from
a secondary account because the primary was unreachable. An
independent verification pass — a fresh context that reopened every
cited source — ran three rounds; its residuals are in Limitations.

1. **The premise holds with one caveat.** "Solutions architect" is a
   formally defined industry role — SFIA 9 (the Skills Framework for
   the Information Age) gives it a skill, ARCH "solution
   architecture", with graded levels; IASA (the architects'
   professional body) a job description in its body of knowledge; The
   Open Group (publisher of the TOGAF architecture framework) a
   certification track, Open CA; and the major cloud vendors
   certifications under that title or a close one (AWS and Microsoft
   "Solutions Architect"; Google "Professional Cloud Architect") —
   whereas no source opened defines plain "architect" (the reason a
   rename is worth making — see Alternatives). The caveat: the definitions
   agree on the core but split on scope — TOGAF, quoted secondhand,
   scopes it to a single project or release and Gartner (the analyst
   firm) to "a specific solution", while SFIA's top level and SAFe
   (the Scaled Agile Framework) in its Solution Architect role scope
   it across many. *(High for the defined role; the scope split is
   medium — its TOGAF and Gartner sides are secondhand.)*
2. **The agreed core: accountable for a solution's technical vision
   and its delivered value.** Open CA: "the overall technical vision
   for a particular solution"; IASA: "owns the value of the delivery
   of a system from inception throughout the delivery lifecycle";
   SFIA: architecture "to deliver agreed business outcomes". This is
   exactly the delivery-verified accountability the shop's principles
   demand, and it is broader than the current `lead-architect`, which
   owns structure but not delivered value. *(High.)*
3. **No source assigns product-wide technology-stack ownership to the
   solutions-architect title by name.** One government SFIA profile
   says "Solutions architects decide which technologies to use";
   vendors imply
   selection within their own platform; IASA's enterprise-architect
   description says project tool selection "has to be given by the
   Global Enterprise architect team"; Gregor Hohpe (*The Architect
   Elevator*) and the Architecture Advice Process (Andrew Harmel-Law's
   decision practice, in which anyone may decide after consulting
   those affected and those with expertise) place it with delivery
   teams "within agreed-upon bounds of general principles or a
   published IT strategy". In an organization with no enterprise-architecture
   layer — one lead shop over its Bounded Contexts — the solutions
   architect seat is the only place those bounds can be set. The
   sound form, reconciling the sources: the seat **decides the
   product-wide stack and platform guardrails**, recorded as
   architecture decision records, and Bounded Context shops decide
   within them. *(High — that no source assigns it to the title, and
   what each source says instead.)* The reconciliation — the seat
   sets the bounds — is this report's judgment. *(Medium.)*
4. **Decomposition stays with the seat.** The DDD community's
   statement is unambiguous — "Finding boundaries is a software
   architect's job and can't be delegated" — and, in a secondhand
   summary of SAFe, the architect
   "define[s] the systems, subsystems and interfaces". The context
   map's relationship kinds — the domain-driven-design patterns for
   how two contexts relate: conformist, anti-corruption layer, open
   host, partnership — are the vocabulary of the contracts between
   contexts. *(Medium — one community source opened in full plus a framework
   abstract.)* Team-boundary
   design, by contrast, is
   contested between architects and product leadership. *(Medium.)*
5. **The clean split with PM and PO is by decision rights, not
   duties.** Architect decides: principles, target architecture, technology
   direction, integration strategy, cross-product dependencies,
   platform selection, guardrails. PO: priority, scope, sequencing
   within those guardrails. Team: implementation. PM: what the
   product is for. A practitioner governance essay (Pettersson,
   "Architect vs Product Owner"), paraphrased: the confusion
   comes from unclear decision rights, not unclear responsibilities —
   "When both roles understand their decision rights, conflict
   becomes collaboration." SAFe frames architect and
   Product Management as peer leaders. *(Medium: the split rests on
   practitioner sources, with SAFe read only as an abstract.)*
6. **Fewer decisions, better held.** Martin Fowler: "an architect's
   value is inversely proportional to the number of decisions he or
   she makes" — the seat should own the hard-to-reverse few (stack,
   decomposition, integration contracts, non-functional requirements)
   and bound everything else, never approve everything. Governance
   instruments with industry backing: architecture
   decision records kept in source control, and an advice process in
   place of a review board (boards "correlate with low organizational
   performance") — both carried by the Thoughtworks Technology Radar,
   whose rings Adopt and Trial are its recommendation levels. A
   third instrument, from TOGAF's implementation-governance phase and
   known only secondhand: an architecture contract under which the
   architect presents the stakeholder three non-compliance options —
   enforce the target, grant temporary relief, or change the
   architecture — and the stakeholder chooses. *(Labels: Radar
   instruments high; architecture contract medium, secondhand; the
   Fowler rule medium — a gather worker opened the paper in full, but
   its PDF was unreadable to the verification pass, so the quote
   stands un-reverified.)*

7. **The report's proposal for `lead-solutions-architect`** — a
   proposal composed from findings 2–6, not a finding, so it carries
   no confidence label. It is written to the six-section role form
   the pending typedef amendment (brief-030) proposes — *posture,
   decision rights, admissible evidence, interfaces, knowledge and
   skills, anti-rationalization* — with the seat's existing
   accountabilities and deliverables as inputs to the two sections
   the current typedef already has (accountabilities; exclusive
   domain). Shop terms used below: a *Bounded Context* is one
   designed region of the product with its own model, owned by one
   shop; a *vehicle* is the typed message a request to a Bounded
   Context shop travels in; *pre-state* is what a context actually
   is before a change, read from its *contract surface* — what its
   contracts state — never its internals; *clarify* is a Bounded
   Context shop's question back to the lead shop; an *ADR* is an
   architecture decision record; *enabler work* is technical work
   that makes features possible.
   *Existing accountabilities kept:* the structural model of the
   product (an artifact readable without the code); decomposition —
   "which Bounded Context owns a capability" — as the exclusive
   domain; scenario assignment; reconciliation of returned work;
   architecture answers to clarify questions.
   *Posture:* pre-state determines the vehicle, verified against the
   contract surface; own the hard-to-reverse few decisions and bound
   the rest.
   *Decision rights — decides:* the product-wide technology stack and
   platform guardrails, each an ADR; integration strategy and each
   contract's relationship kind; the product's non-functional
   requirements. *— recommends:* enabler work into the PO's backlog
   (the SAFe-derived clause that the architect also manages capacity
   for it rests on an UNVERIFIED gather note and is not proposed).
   *— escalates to the authority:* contract-breaking changes;
   cross-context conflicts; any stack decision that commits the
   product to a vendor or a recurring cost — the threshold below
   which such decisions stay with the seat is the authority's to set
   at approval; until set, all of them escalate. *— bounds, never
   approves:* Bounded Context shops choose within the guardrails; a
   choice outside them is raised as a contract question.
   *Admissible evidence:* contract surfaces; sweeps of the whole
   scenario registry through the aggregate tooling, never one
   context's copy; ADRs in source control; the canonical package
   data rather than any locally poured copy. Not authoritative:
   local copies, spike findings, forward-looking prose, and code
   reachable only by entering a Bounded Context.
   *Interfaces:* PM (framed intent → feasibility and shape); PO
   (scenarios → assignment; a backlog structured to mirror the
   decomposition; enabler requests); Bounded Context shops (typed
   messages; clarify); the authority (escalations).
   *Knowledge and skills:* SFIA's top-level competencies — setting
   policy, balancing functional, service-quality, cost, and
   operational requirements, coordinating a target architecture
   across many efforts — plus consultancy, specialist advice, and
   emerging-technology monitoring; domain-driven context mapping;
   ADR authoring; and four shop-specific skills to be defined with
   the seat: choosing the vehicle, verifying pre-state, sweeping the
   scenario registry for completeness, and reconciling returned work.
   *Anti-rationalization:* "I can read the pre-state from the code"
   → only the contract surface counts. "It is just a tightening" →
   net-new behavior dressed as a tightening is a vehicle error. "No
   conflicting scenario exists" → only after a registry-wide sweep.
   "The teams will pick a sensible stack" → without a published
   guardrail there is no bound to pick within.
   *Deliverables (inputs to accountabilities):* ADRs; contracts as
   interface specifications; technical plans and migration roadmaps;
   trade-off records.

## Method

Three parallel gather workers in fresh contexts, 15 searches, 25
pages opened in full and 3 as abstracts (SAFe's official role pages
sit behind a login; the TOGAF standard behind Open Group SSO; the
Gartner glossary returned 403; Open CA's conformance PDFs would not
extract). Evidence was extracted quotes-first into 18 entries, then
synthesized; an independent fresh-context verification pass followed.
Every finding names its source; secondhand sources are marked.

## Findings

### F1 — A defined role, with contested scope *(high)*

- SFIA 9, Solution architecture (ARCH): "Developing and
  communicating a multi-dimensional solution architecture to deliver
  agreed business outcomes." Level 4 contributes and documents
  trade-offs; level 5 "Leads the development of solution
  architectures in specific business, infrastructure or functional
  areas" and evaluates change requests; level 6 "Leads the
  development of architectures for complex solutions…", sets policies,
  "Manages trade-offs and balances functional, service quality, cost
  efficiency and systems management requirements", and coordinates
  target architecture across multiple projects.
- Open CA (The Open Group): "Solution architects are responsible for
  leading the practice and introducing the overall technical vision
  for a particular solution."
- IASA BTABoK: "The solution architect owns the value of the delivery
  of a system from inception throughout the delivery lifecycle";
  deliverables named on the page: "technical design documentation",
  "formal models of the system", and "optimized solution designs" (a
  gather note also listed impact analyses; not re-found on
  verification — UNVERIFIED).
- Scope conflict: TOGAF (quoted secondhand) scopes solution
  architecture to "a single project or project release" and, per
  Wikipedia, "does not recognize the role 'solution architect' in its
  TOGAF skills framework"; SFIA level 6 and SAFe's Solution Architect
  ("a shared technical and architectural vision for a Solution
  Train" — SAFe's unit for a solution built by several release trains)
  scope it across many. For a lead seat over a whole product, the SFIA-6 /
  SAFe reading is the fitting one.

### F2 — Technology selection: what the sources actually say *(high)*

- Explicit: Queensland Government's SFIA role profile — the solutions
  architects "decide which technologies to use" and are "the link
  between the needs of the organisation and the developers" (SFIA
  skills at level 5: ARCH solution architecture, CNSL consultancy,
  TECH specialist advice, EMRG emerging-technology monitoring).
- Implied within a platform: AWS — "Design solutions that
  incorporate AWS services to meet current business requirements…";
  Microsoft — "translating business requirements into designs for
  Azure solutions… You should manage how decisions in each area
  affect an overall solution."
- Placed elsewhere: IASA's enterprise-architect job description —
  "The IT tool selection for a project has to be given by the Global
  Enterprise architect team not the BU IT teams"; Hohpe — "empower
  development teams to make architecture decisions, within
  agreed-upon bounds of general principles or a published IT
  strategy"; the Architecture Advice Process — "Anyone can make an
  architectural decision" after consulting those affected and those
  with expertise, with ADRs recording the advice.
- The reconciliation (judgment, *medium*): the sources describe a
  two-level structure — bounds set above, choices made within. Where
  no enterprise layer exists, the solutions-architect seat sets the
  bounds: the product-wide stack and platform guardrails, each an
  ADR; the Bounded Context shops choose within them, and a choice
  outside the bounds is a contract question, not a local option.

### F3 — Decomposition, contracts, and non-functional requirements *(medium: community and framework-abstract sources agree; no primary text)*

- Avanscoperta, a domain-driven-design training firm's explainer
  (the DDD community's reading, not a standard): "Finding boundaries is a software architect's
  job and can't be delegated"; "A Bounded Context is typically the
  responsibility of a single team"; internal "implementation style
  and working agreements can be local to a Bounded Context… The
  responsible team would be in charge of the decision." Context
  mapping supplies the relationship kinds — conformist,
  anti-corruption layer, open host, partnership — which are the
  contract vocabulary between contexts.
- SAFe (abstract; secondhand detail): the architect "Define[s] the
  systems, subsystems and interfaces on which solutions are
  developed", defines enablers and non-functional requirements, and —
  per a gather note from the SAFe abstract that the verifier could not
  re-find, UNVERIFIED — manages capacity for enablement work, "in line
  with ART's business vision" (ART: SAFe's Agile Release Train, the
  program-level delivery unit).
- Contested: Mind the Product places team-topology design with
  product leaders; continuous-architecture.org runs it as a joint
  workshop of PO/PM and architects with "architecture defined"
  first. Domain boundaries sit with the architect; team boundaries
  are shared.

### F4 — The interface with PM and PO *(medium: practitioner sources; SAFe abstract-only; no published three-way RACI)*

- Pettersson, a practitioner governance essay: "Architects optimize the system. Product Owners
  optimize the product." Under the heading "Architects Make
  Architectural Decisions": "Architecture principles, Target
  architecture, Technology direction, Integration strategy,
  Cross-product dependencies, Platform selection, Technical
  guardrails"; Product Owners decide "Product vision, Product
  roadmap, Backlog priority, Sprint objectives, Feature sequencing,
  Customer trade-offs, Release priorities"; "The architect provides
  direction. The Product Owner decides priorities within those
  guardrails. The delivery team determines how to implement the
  solution."
- ondata, a practitioner blog on role terms: the Product Manager "define[s] the product"; the PO
  "represents the client (user) voice"; the architect "defines how
  the product works internally"; in small teams, "agree on the role description upfront".
- SAFe: Product Management "responsible for defining desirable,
  viable, feasible, and sustainable solutions" and "works closely
  with the System Architect… as leaders of the Agile Release Train".
- Failure modes on record: unclear decision rights (Pettersson); a
  single backlog over a service-based architecture — "setting
  yourself up for failure", patterns missed, conflicting requirements
  undetected (Lawson, a practitioner post); poorly drawn boundaries —
  teams "blocked by other teams" (Mind the Product, a product-
  management publication).

### F5 — How many decisions, and governed how *(high for governance instruments; medium for the Fowler rule — primary unreadable to the verifier)*

- Fowler, reporting Ralph Johnson's definition: architecture is "the
  decisions that you wish you could get right early in a project";
  and Fowler's own rule: "an architect's value is inversely
  proportional to the number of decisions he or she makes"; the
  better style mentors the team to take on more decisions.
- Thoughtworks Radar: lightweight ADRs — Adopt, "storing these
  details in source control"; the Architecture Advice Process —
  Trial; "The traditional approach of Architecture Review Boards is
  counterproductive, often hindering workflow and correlating with
  low organizational performance." Even a board-centric
  responsibility matrix keeps the proposer accountable for the
  proposal's content, the board consulted — for the seat, decisions
  are owned by whoever proposes them, and the seat bounds rather
  than approves.
- TOGAF Phase G (secondhand, paraphrased): an Architecture Contract
  binds the implementation team to the architecture stakeholders; on
  non-compliance the architect presents three options — enforcing
  the target architecture, granting temporary relief, or changing
  the architecture — and "the choice of action belongs to a
  Stakeholder".

## What this means for `lead-solutions-architect`

The rename is justified and the content change is specific; the
single proposal text is executive-summary item 7 — kept in one place
so the two cannot diverge. Governance of the seat's decisions: ADRs in
source control; an advice-process shape for decisions inside a
Bounded Context; the architecture contract's enforce / relief / change
outcomes for non-conformance, chosen by the stakeholder.

## Alternatives considered

- *Keep the title "architect".* No opened source defines it; the
  seat would stay as thin as the evidence found it. Rejected.
- *"Enterprise architect".* Organization-wide scope, "typically
  covers all missions and functions" (Berrisford, secondhand — a
  scope definition, not the enterprise-architect role's); not
  accountable for a
  solution's delivery. Wrong scope for a product seat. Rejected.
- *"Software / application architect".* Implementation-level,
  inside one system — the Bounded Context shop's own concern.
  Rejected.
- *"Technical architect".* Undefined in every source opened.
  Rejected.
- *Put stack decisions with the Bounded Context shops entirely
  (pure advice process).* Industry-backed for decisions inside a
  bound; but the sources that back it all presuppose a published
  strategy setting the bound, which in this shop only this seat can
  own. Adopted as the inner layer, not the whole.

## Limitations

- SAFe's official System Architect, Solution Architect, and Product
  Management pages are login-walled; only their abstracts were read,
  and the detail on enablers/NFRs comes from a secondary summary.
- The TOGAF standard is behind Open Group SSO; its text is quoted
  secondhand (Berrisford, Conexiam, Wikipedia). Whether TOGAF's
  skills framework formally recognizes a solution-architect role
  could not be verified directly.
- Gartner's glossary returned 403; its definition is secondhand via
  Wikipedia. Open CA's per-level conformance requirements would not
  extract from PDF.
- No published three-way PM / PO / solutions-architect RACI was
  found; the split in F4 composes a two-way practitioner source with
  SAFe's framing.
- The stack-ownership reconciliation in F2 is this report's
  judgment, not a sourced claim; it is labeled medium.
- Sweep was one afternoon, US-only search index; consultancy
  taxonomies beyond one mid-size firm were not opened.
- The verification loop reached its cap (three rounds). Round 3's
  residuals were quote-fidelity items — a dropped article, missing
  ellipses on truncated quotes, one SAFe clause the verifier could
  not re-find (now marked UNVERIFIED), and the Fowler primary being
  unreadable to a fresh context (label split) — repaired after the
  round without a fourth verification pass; they are disclosed here
  rather than certified.
- The cold-read loop also reached its cap (three rounds). Round 3
  found the report actionable from the summary and returned
  presentation residuals — item 7's heads not mapped to the role
  form's sections, a duplicate proposal text in the body, shop
  vocabulary unglossed, one label split unclear — repaired after
  the round without a fourth read; two remain as written: ADRs'
  "high" rests on the Radar entry with Harmel-Law's use of ADRs as
  the second source, and the Method and Sources sections stay in
  the body rather than an appendix, as the report typedef requires.

## Sources (opened this run)

- SFIA 9, Solution architecture: https://sfia-online.org/en/sfia-9/skills/solution-architecture — full
- Queensland Government SFIA profile, Solutions architect: https://www.forgov.qld.gov.au/recruitment-performance-and-career/career-development/develop-digital-and-ict-capabilities/skills-framework-for-the-information-age-sfia-role-profiles/solutions-architect — full
- Open Group, Open CA: https://www.opengroup.org/certifications/certified-architect-open-ca — full
- IASA BTABoK, Job description: https://iasa-global.github.io/btabok/job_description.html — full
- Berrisford, EA and SA roles in TOGAF: http://grahamberrisford.com/01EAingeneral/EAroles/EA%20and%20SA%20roles%20in%20TOGAF.htm — full, secondary
- Wikipedia, Solution architecture: https://en.wikipedia.org/wiki/Solution_architecture — full, secondary
- Conexiam, TOGAF Phase G: https://conexiam.com/togaf-adm-phase-g-ensure-value-with-implementation-governance/ — full, secondary
- Fowler, Who Needs an Architect?: https://martinfowler.com/ieeeSoftware/whoNeedsArchitect.pdf — full (opened by a gather worker; the PDF did not extract for the fresh-context verifier) ; attribution confirmed at https://martinfowler.com/architecture/
- Hohpe, The Architect Elevator: https://martinfowler.com/articles/architect-elevator.html (the quoted 'within agreed-upon bounds' passage is on this copy) ; https://www.enterpriseintegrationpatterns.com/ramblings/79_elevator.html — full
- ERNI, Triple-A saga part II: https://www.betterask.erni/the-triple-a-saga-architecture-architects-and-agile-part-ii/ — full, secondary
- AWS SAA-C03 exam guide: https://docs.aws.amazon.com/aws-certification/latest/solutions-architect-associate-03/solutions-architect-associate-03.html — full
- Microsoft Azure Solutions Architect Expert: https://learn.microsoft.com/en-us/credentials/certifications/azure-solutions-architect/ — full
- Google Professional Cloud Architect: https://cloud.google.com/learn/certification/cloud-architect — full
- Harmel-Law, Scaling architecture conversationally: https://martinfowler.com/articles/scaling-architecture-conversationally.html — full
- Thoughtworks Radar, lightweight ADRs: https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records — full
- Thoughtworks Radar, architecture advice process: https://www.thoughtworks.com/en-us/radar/techniques/architecture-advice-process — full
- The Art of CTO, architecture review process: https://theartofcto.com/frameworks/architecture-review-process — full, secondary
- Pettersson, Architect vs Product Owner: https://pettersson.dev/governance/architect-productowner/ — full, secondary
- ondata, PO / architect / PM terms: https://ondata.blog/articles/on-the-usage-of-terms-product-owner-software-architect-and-product-manager/ — full, secondary
- Avanscoperta, Context mapping; Bounded context: https://www.avanscoperta.it/en/context-mapping/ ; https://www.avanscoperta.it/en/bounded-context/ — full
- SAFe, System Architect; Solution Architect; Product Management: https://framework.scaledagile.com/system-architect ; https://framework.scaledagile.com/solution-architect ; https://framework.scaledagile.com/product-management/ — abstract only (login)
- scrum-master.org, System Architect in a SAFe train: https://scrum-master.org/en/role-of-the-sae-or-system-architect-in-an-safe-train/ — full, secondary
- Lawson, single-backlog smell: https://www.linkedin.com/pulse/smell-single-backlog-service-based-architecture-james-lawson — full, secondary
- Mind the Product, Team Topologies for product leaders: https://www.mindtheproduct.com/product-leaders-guide-to-team-topologies/ — full, secondary
- Team Topologies, key concepts: https://teamtopologies.com/key-concepts — full
- continuous-architecture.org, Team Topologies practice: https://www.continuous-architecture.org/practices/team-topologies/ — full, secondary
- UNOPENED: Gartner glossary (403); TOGAF standard chapters (SSO); Open CA conformance PDFs (extraction failed); climbtheladder comparison opened but not relied on.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Drafted from three parallel gather workers' notes (18 evidence entries) through the research-inquiry process. |
| 1 | 2026-08-23 | review | Verification round 1 (fresh context, sources reopened): findings — a vendor overreach, a scope claim misattributed to Gartner, a paraphrase presented as a quote, an SFIA level-6 misquote, F4 over-labeled high, a Johnson definition attributed to Fowler, a selective RACI reading, a truncated URL. |
| 2 | 2026-08-23 | update | Round-1 repairs applied; two IASA deliverables marked UNVERIFIED; F4 and summary 5 downgraded to medium. |
| 2 | 2026-08-23 | review | Verification round 2 (fresh context): findings — the non-compliance choice belongs to the stakeholder, not the architect; one Pettersson sentence was a paraphrase in quotation marks; the Queensland quote altered; F3 over-labeled; an unsourced scope phrase in Alternatives. |
| 3 | 2026-08-23 | update | Round-2 repairs applied; F3 and summary 4 downgraded to medium; paraphrases marked; Berrisford cited for the enterprise-scope phrase. |
| 3 | 2026-08-23 | review | Verification round 3 (cap): findings — quote-fidelity residuals only (an article dropped, ellipses, one SAFe clause not re-found, the Fowler primary unreadable to a fresh context); one earlier UNVERIFIED item (solution designs) confirmed. |
| 4 | 2026-08-23 | update | Cap residuals repaired post-round and disclosed in Limitations; Fowler label split; report finalized. |
| 4 | 2026-08-23 | review | Cold read round 1 (as the consumer): findings — the role content sat at the end of the body; authorities and confidence labels arrived unintroduced; the architecture-contract instrument over-labeled. |
| 5 | 2026-08-23 | update | Presentation repairs: summary item 7 carries the proposed role content; label scheme stated once; every authority and framework term introduced at first use; the architecture-contract instrument split to medium; the review-board sentence given its point. No finding's substance changed. |
| 5 | 2026-08-23 | review | Cold read round 2: findings — the proposal filled three of the role form's six sections; the escalation threshold unstated; item 6 carried overlapping labels; authorities unintroduced in item 1. |
| 6 | 2026-08-23 | update | Proposal completed (posture, admissible evidence, knowledge and skills, anti-rationalization; threshold ownership stated), marked as a proposal outside the confidence scheme; item 6 collapsed to one label statement; every authority introduced at first use. |
| 6 | 2026-08-23 | review | Cold read round 3 (cap): actionable from the summary; presentation residuals — item 7 unmapped to the form's sections, duplicate proposal text, unglossed shop vocabulary, an unclear split label. |
| 7 | 2026-08-23 | update | Cap residuals repaired post-round and disclosed in Limitations: item 7 restructured onto the six sections with a gloss line; the body section collapsed to a pointer; item 1 and item 3 labels split; the unverified capacity clause excluded from the proposal. |
| 7 | 2026-08-23 | state | draft → delivered to the product authority; registered in the research index on `rebaseline`. |
