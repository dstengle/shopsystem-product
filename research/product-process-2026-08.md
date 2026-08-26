---
type: research-report
id: product-process-2026-08
status: delivered
version: 7
date: 2026-08-26
question: "Contrast the product process we are developing against industry standards at the modern end (startups, tech companies): requests are made against a product, not against Bounded Contexts, and a feature can cross several; and the process must let us make sense of how the product has changed over time, where it is now, and where it is going next."
requested-by: product-authority
created: 2026-08-26
updated: 2026-08-26
---

# Research report: the product process against modern practice — the product-level artifact, cross-context features, and the record of past, present, and next

## Executive summary

*How to read the labels.* Each finding carries a confidence: **high** —
several sources opened in full agree, at least one primary (the author,
framework, or company's own text); **medium** — one opened source, or
secondary accounts only, or several opened sources that each carry
only part of the claim, or a consensus with a dissenting opened
source; **low** — recall
without a source, or a primary that could not be read. "Secondhand"
marks a quote carried by a secondary account. This scheme amends the
frame's in one clause: the frame made "several practitioner sources
with no controlled comparison" medium, which would make every finding
here medium, since no controlled comparison of product processes
exists; the report instead grades on sources opened, primaries, and
dissent, and says in Limitations that all the evidence is practitioner
text. Confidence is about the
evidence; where a finding predicts an outcome, likelihood is stated in
its own phrase.

*How the sources' vocabulary maps to the shop.* "Product team",
"stream-aligned team", "feature team", and "component team" are all
kinds of team; our Bounded Context shops are context-owning teams
(Team Topologies' preferred mapping). "Initiative", "pitch", "PR/FAQ",
"opportunity assessment", "Intermission", and "project" are the
sources' names for a product-level, problem-first document; "project"
in Linear's sense is a feature-sized unit that can span teams. Our
*framing* is the PM role's recorded statement of a request's problem
and outcome; our *brief* is addressed to one Bounded Context shop; a
*product decision record* is our ADR-form record of one product-level
decision. Names that recur: Cagan and Moore (Silicon Valley Product
Group); Torres (Product Talk); Perri (product strategy author);
Basecamp (Shape Up); McAllister (an Amazon product manager describing
the PR/FAQ on Quora); Intercom, Figma, Linear, Stripe, GitHub, GitLab
(their own published practice); Bastow (ProdPad); McCarthy (*Product
Roadmaps Relaunched*, secondhand); Mehta and Gadiyali (Reforge; Mehta alone at First Round);
keepachangelog (the changelog convention); Charak and Productboard
(product decision records and product memory); Wardley (Wardley maps,
a strategy-mapping technique); Evans and Fowler (domain-driven
design); the CQRS Journey (a Microsoft patterns guide); Tune, Plöd,
Newman (DDD and microservices practitioners); Narayan ("Products Over
Projects", on Fowler's site); Team Topologies (Skelton
and Pais); LeSS (Large-Scale Scrum); Lee (a Spotify post-mortem).

1. **Every modern practice opened puts a written, product-level,
   problem-first artifact ahead of any feature or team assignment** —
   Cagan's opportunity assessment ("Exactly what problem will this
   solve?"), Torres's opportunity ("an unmet customer need, pain point,
   or desire" — with "more than one way to address" it), Perri's target
   condition (a measured goal on the way to the vision), Basecamp's pitch, Amazon's PR/FAQ, Intercom's one-page
   Intermission that "never includes solutions", Figma's PRD problem
   section, Linear's initiative. Our process has no such artifact: the
   framing is recorded per request but carries no status, measure, or
   history, and the brief is already addressed to one context. *(High.)*
2. **The sources split on what a team receives, but agree on where the
   decision is made.** One school hands a team a problem and an outcome
   (Moore & Cagan: "problems to solve" with "clear measures of
   success"; Torres; Perri); the other hands it a shaped solution with boundaries
   (Shape Up's pitch: problem, appetite, solution, rabbit holes,
   no-gos; Amazon's approved PR/FAQ, which McAllister says "can be used as a
   touchstone; a guiding light" during build).
   Both decide at product level with a recorded go/no-go — Cagan's
   "clear go or no-go decision", Basecamp's betting table, Linear's
   initiative statuses. *(High.)*
3. **"Where it is going" is a chain, not a list:** vision (Moore & Cagan: "most are 3-10 year product visions"), strategy (Cagan: "Choices means focus"; "insights"; "convert
   those insights into action"), then quarterly problems assigned to teams;
   the roadmap re-typed as problems, themes, or initiatives
   (Perri's problem roadmap with a KPI per problem; McCarthy's themes;
   Bastow's Now/Next/Later "organizes work by levels of confidence
   instead of fixed dates"; Linear's initiatives). Reforge (Mehta &
   Gadiyali) dissent: the roadmap is "the sequence of features that
   implement the Product Strategy" with goals beneath it. *(High for
   the chain; medium on the roadmap's re-typing — one dissenting opened
   source.)*
4. **"Where it is now" is the least-recorded of the three** — explicit
   only in Perri's measured current condition ("measured and quantified
   before the work starts to achieve the first target condition"), Bastow's Now column ("the work in motion"),
   Linear's initiative status and health ("on track, at risk, or off
   track"), GitHub's lifecycle tags (preview → GA → retired), and
   Wardley's test that a map needs "position of components relative to
   some form of anchor and movement". Cagan's vision and objectives
   carry no current-state element. *(Medium — several primaries, each
   carrying one element of the claim.)*
5. **"How it has changed" is two histories no source unifies:** what
   shipped — the changelog ("a curated, chronologically ordered list of
   notable changes for each version", "for humans, not machines",
   never "commit log diffs"; Stripe keys it to contract versions with a
   breaking-change flag; GitLab makes the PM responsible for each
   feature's release note) — and why it was decided — product decision
   records ("Every decision has a context", with a "Review Trigger")
   and Productboard's "organizational product memory" ("decisions, the
   reasons behind them, customer evidence"). Only a vendor (Quackback) claims the
   changelog is "an institutional record of product decisions"; the
   decision-record authors say otherwise. *(High that both forms exist, each
   with primary sources; medium that keeping them separate is the
   consensus — one dissenting opened source.)*
6. **Cross-context features: no DDD source has a "feature" artifact —
   the industry answer is an artifact above the context brief, with a
   named owner, and frequency as the warning sign.** Evans handles cross-context work as a
   *relationship between teams* ("forge a partnership… joint
   management of integration"); the CQRS Journey defines a business-process flow "in a single
   place, the process manager" — a saga for the case that "spans
   multiple bounded contexts"; Tune: a dashboard is "a composite of
   capabilities provided by other bounded contexts", and journey
   changes make "multiple business capability
   teams… coordinate" by design; Fowler/Narayan: "Cross-cutting
   initiatives are prioritized by the business or tech leadership.
   Initiatives don't get their own team. They are parceled out to
   pre-existing product-mode teams", with "silo-penetrating…
   solution champions" and "no more than one-third initiative work";
   Team Topologies names time-boxed interaction modes; Linear's
   project "can be shared across multiple teams". The diagnostic the sources name is
   frequency: Newman — wrong boundaries "lead to a larger number of
   cross-service changes"; Tune — "corresponding changes between one
   or more systems… serious warning signs". LeSS is the contrast (one
   product backlog, feature teams, context-owning teams as "component
   teams"). Spotify's documented failure: "did not define a common
   process for cross-team collaboration". *(High.)*
7. **The contrast, item by item — the report's judgment.** Our
   *framing* is the opportunity statement's first half (originator,
   problem, outcome) without persistence, status, or a measure. Our
   *brief* is the sources' team-level project document, but it is the
   first artifact where the sources have a product-level one above it.
   Our *product decision record* matches the decision-history half of
   finding 5. We have no vision/strategy artifact, no roadmap of any
   type, no changelog, no current-state measure, and no count of
   cross-context features. The architect's decomposition exists but
   nothing records the product-level intent it decomposes from, so a
   feature crossing contexts has no home and no owner — Spotify's gap.
   And nothing counts how often a request crosses contexts, so the
   frequency the sources call the warning sign is not observed.
8. **The proposal — composed from findings 1–7, a judgment, so no
   confidence label.** Five artifacts, two of them existing, in one
   chain:
   *(a) Product strategy* — one document, owned by `lead-pm`: the
   vision (years, qualitative), the strategic choices and what is
   declined (Mehta's non-goals; Cagan's "all the things you won't
   do"), the measures (Perri's target conditions with a measured
   current condition each). Drafted by the PM role's assisting agent
   in a discovery conversation, screened by the cold reviewer against a
   strategy fitness set, approved by the authority in a review — the cold reviewer's screen is
   the check of record, since the authority holds `lead-pm` in person,
   an accepted arrangement; amended the same way, each amendment
   carried by a product decision record.
   *(b) Initiative* — the missing product-level artifact, one per
   problem worth solving, made by the PO role from the PM role's
   framing and checked by the PM role through the PO output check
   against an initiative fitness set — the same maker/checker split
   as every PO artifact: the problem and for whom
   (Cagan's first three questions), the outcome and its measure, the
   appetite (Shape Up), the no-gos, a status lifecycle (proposed →
   planned → active → completed | cancelled — Linear's) with dated
   updates, and the PM role's framing quoted as its first section — the
   framing stays the PM's input, cited, and the PO output check covers
   the sections the PO role makes; and — attached by
   `lead-solutions-architect` in a `decompose` step of the PO output
   check, before the PM role decides — the decomposition: which Bounded
   Contexts it touches, the cross-context flow named in one place — the
   saga or process manager that will carry it, or "none" for an
   initiative that touches several contexts without a message flow
   between them — and the relationship kind each pair uses. The PO role derives the
   per-context briefs from it; a brief cites its initiative. An
   initiative is bet on at product level before any brief exists: the
   go/no-go is the PM role's decision, taken in a review, and it is the
   proposed → planned transition; a checked but unbet initiative stays
   proposed. The later transitions each have a maker: planned → active
   when the PO output check passes the first brief derived from it
   (the check's record step); active → completed when
   `reconcile-and-close` reconciles the last delivery under it (the
   same step that writes the changelog entry); any state → cancelled by
   the PM role's decision in a review, with the reason recorded. The
   instance's owner — the accountable role — is `lead-pm`; its maker is
   `lead-po`.
   *(c) Brief* — unchanged in form, now always the child of an
   initiative; a brief with no initiative is a finding.
   *(d) Roadmap* — a Now/Next/Later view of initiatives, a rendering
   the basis compiler generates from the initiatives' statuses (owner
   `lead-pm`; never hand-edited): Now = active, Next = planned, Later =
   proposed; Completed and Cancelled are the recent past.
   *(e) Product changelog* — keepachangelog's form, a rendering the
   compiler generates from entries the `reconcile-and-close` process
   writes when a delivery is reconciled (owner `lead-pm`; never
   hand-edited): one entry per delivered change grouped
   Added/Changed/Deprecated/Removed/Fixed, linking the initiative it
   served and any decision record; the Unreleased section lists the
   active initiatives by name.
   The three questions then have homes: *changed* — the changelog and
   the decision records; *now* — the roadmap's Now column and each
   initiative's status and updates, plus the strategy's current
   conditions; *next* — the strategy's choices and the roadmap's Next
   and Later. And the count of initiatives touching more than one
   context, per period, is a rendering from the initiatives' decomposition
   sections, read by the solutions architect role as the boundary
   signal the sources describe.
9. **What this changes in the definitions — one line each, for the
   authority's decision.**
   - `initiative` typedef (new; owner product-authority; instances owned
     by `lead-pm`): the fields in 8(b); the framing absorbed as its first
     section.
   - `product-strategy` typedef (new; instance owned by `lead-pm`): the
     fields in 8(a).
   - `brief` typedef (amend): a required `initiative` link; a brief with
     none fails its check.
   - `lead-po` role (amend): the initiative as a fourth artifact it
     makes, within the framing.
   - `lead-pm` role (amend): the strategy as an accountability; the
     go/no-go on an initiative (proposed → planned) as a decision; the
     check on initiatives as part of its check on PO output.
   - `initiative` and `product-strategy` fitness sets (new): the
     criteria the checks read.
   - `lead-solutions-architect` role (amend): the decomposition attached
     to the initiative; the cross-context count read as the boundary
     signal.
   - `discovery-conversation` process (amend): the framing step's
     framing becomes the first section of an initiative the PO role
     then makes, rather than a standalone record; the strategy is
     drafted and amended in the same process.
   - `review-conversation` process (amend): the PM role's go/no-go and
     cancellation of an initiative, and the authority's approval of the
     strategy, as outcomes it records.
   - `po-output-check` process (amend): the initiative as a criteria
     source beside the framing; a `decompose` step run by the solutions
     architect role for an initiative, before decide; the record step
     sets an initiative planned → active on its first brief's pass.
   - `reconcile-and-close` process (amend): a runtime step, after the
     router's consume-close, that writes the changelog entry for each
     reconciled delivery and sets the initiative completed when the
     delivery is its last.
   - roadmap, changelog, and cross-context count: generated renderings
     from the compiler; their rendering rules live in the `initiative`
     typedef's rendering contract, as the process-definition typedef
     carries the skill's.
   The four PO typedefs awaiting approval stand; the brief's amendment
   is the only change to them.

## Method

Three parallel gather workers in fresh contexts: the product-level
problem artifact (SVPG five essays, Product Talk, Perri two, Shape Up
four chapters, Working Backwards and McAllister, Intercom two, Lenny's
template index and Figma's PRD, Reforge and First Round on the
strategy stack, Linear Method and docs); the record of past, present,
and next (ProdPad, SVPG two, Perri two, McCarthy secondhand, Linear
Method and docs and changelog, keepachangelog, Stripe, GitHub, and
GitLab changelogs, Charak's product decision records, Productboard
two, Metabase, Wardley); cross-context features (Evans's DDD Reference,
Fowler's bliki two, Vernon via InfoQ, the CQRS Journey on sagas,
Brandolini via two secondaries, Tune two, Plöd, Team Topologies three,
Fowler/Narayan "Products Over Projects", Newman two, LeSS two, Lee on
Spotify). Roughly 60 sources opened in full; unreadable: Perri's
strategy-deployment post (404; secondhand), Vernon's IDDD chapter
(403), Product Roadmaps Relaunched (book; notes from a talk), GitLab's
handbook process pages (navigation only), Lenny's PRD guide
(paywalled), SVPG "problems to solve" (redirect). Evidence extracted
quotes-first; an independent fresh-context verification pass followed.

## Findings

### F1 — The product-level, problem-first artifact *(high)*

- Cagan, "Assessing Product Opportunities": "I ask product managers to
  answer ten fundamental questions: 1. Exactly what problem will this
  solve? (value proposition) 2. For whom do we solve that problem?
  (target market) 3. How big is the opportunity? (market size)"; "a crisp, clear and compelling statement of exactly
  the problem that's solved"; "The purpose of the MRD is to describe
  the opportunity, not the solution".
- Torres, Opportunity Solution Trees: "[a]n opportunity is an unmet
  customer need, pain point, or desire."; "The best way to test if an
  opportunity is really a solution in disguise is to ask, 'Is there
  more than one way to address this opportunity?'"; "a living document
  that should evolve as you learn".
- Perri, product strategy: "The target condition helps break down the
  Challenge… achievable, measurable metrics."; "This is what the
  current reality is compared to the Target Condition. It should be
  measured and quantified before the work starts to achieve the first
  target condition."
- Basecamp, Shape Up: "When a project is defined in a few words, nobody
  knows what it means."; the pitch's five ingredients — "Problem…
  Appetite… Solution… Rabbit holes… No-gos"; "Shaped work indicates
  what not to do. It tells the team where to stop."
- Amazon, Working Backwards: "Problem Paragraph: This is where you
  describe the problem(s) that your product is designed to solve.";
  McAllister: "Once the project moves into development, the press
  release can be used as a touchstone; a guiding light."
- Intercom: "The Intermission is our quirky name for a project
  brief... It never includes solutions because this comes later.";
  "restricted to less than one page and must succinctly cover the
  problem we're solving"; "Everything in our roadmap is broken down by
  team objective, which is broken down into multiple projects, which in
  turn are broken down into individual releases."
- Figma's PRD (Yamashita): "Describe the problem (or opportunity)
  you're trying to solve. Why is it important to our users and our
  business?"; "Keep track of open issues / key decisions here."
- Linear docs: initiatives "express the goals and objectives an
  organization aims to achieve and to monitor progress towards those
  aims"; projects are "units of work that have a clear outcome or
  planned completion date, such as a new feature's launch" and "can be
  shared across multiple teams".

### F2 — Problem or shaped solution; the decision point *(high)*

- Moore & Cagan, "Changing How You Decide Which Problems To Solve":
  "simply providing your empowered product teams with problems to
  solve, and clear measures of success"; "The product strategy
  identifies the most critical problems to solve in the quarter, and
  the product leaders assign those problems to the relevant product
  teams through team objectives."
- Cagan, opportunity assessment: "the company make a clear go or no-go
  decision."
- Shape Up, "Bets, Not Backlogs": "Before each six-week cycle, we hold
  a betting table where stakeholders decide what to do in the next
  cycle."; "If we decide to bet on a pitch, it goes into the next cycle
  to build. If we don't, we let it go."
- Working Backwards: "If the new idea is a go, what happens next should
  be well understood because it is described in the FAQs."
- Linear: "Communicate the current stage of the initiative using
  available statuses—Proposed, Planned, Active, Completed, or
  Canceled."

### F3 — Where it is going *(high for the chain; medium on the roadmap's re-typing — one dissenting opened source)*

- Cagan, "The Alternative to Roadmaps": "The Product Vision: this
  describes the holistic view of what the organization as a whole is
  trying to accomplish. The Business Objectives: this describes the
  specific, prioritized business objectives for each product team.";
  "It is all about outcome rather than output."; "high-integrity
  commitments… for those situations where we need to actually commit
  to a date".
- Moore & Cagan, "Changing How You Decide Which Problems To Solve":
  "A strong product vision will inspire an organization for many years
  (most are 3-10 year product visions)."
- Cagan, product strategy: "Choices means focus. Deciding what few
  things you really need to do, and therefore all the things you won't
  do."
- Perri, "Rethinking the Product Roadmap": "Instead of focusing on
  features to be developed, we focus on problems to be solved."; "We
  assign a KPI to each team which signifies if the problem has been
  solved successfully or not."
- Bastow, Now-Next-Later: "an outcome-focused product roadmap that
  organizes work by levels of confidence instead of fixed dates";
  "Link each Initiative to the OKRs it supports".
- McCarthy et al. (secondhand, talk notes): the roadmap is "A statement
  of intent and direction, not a promise of deliverables"; themes are
  "The problems / jobs to be done / needs of customers".
- Reforge (Mehta & Gadiyali): the roadmap is "the sequence of
  features that implement the Product Strategy"; "The Product Roadmap
  should come before the Product Goals". First Round (Mehta): "Goals
  are at the bottom of the stack, not at the top, because goals should
  come from the roadmap"; "It's important to document those concrete
  choices —
  not just that we've chosen to do A, but also to explicitly reinforce
  that we're *not* going to do B."

### F4 — Where it is now *(medium)*

- Perri: "It should be measured and quantified before the work
  starts to achieve the first target condition."; the kata's "Sellers call office less than twice a week"
  against "We're not sure how often sellers are calling now".
- Bastow: "Now is the work in motion. These are validated Initiatives
  the team is actively working on, where the problem is well
  understood and the focus has shifted to the solution."
- Linear: "Initiative Health shows whether the latest initiative update
  indicated work was on track, at risk, or off track."
- GitHub changelog: release types "Release", "Improvement", "Retired";
  maturity "generally available" / "public preview".
- Wardley, "On being lost": map elements are "[v]isual representation,
  context specific, position of components relative to some form of
  anchor and movement of those components"; "Every single diagram I
  was using to determine strategy in business lacked one or more of
  those basic elements."

### F5 — How it has changed *(high that the forms exist and differ; medium on their separation)*

- keepachangelog 1.1.0: "A changelog is a file which contains a
  curated, chronologically ordered list of notable changes for each
  version of a project."; "Changelogs are for humans, not machines.";
  "Added… Changed… Deprecated… Removed… Fixed… Security"; "Using commit
  log diffs as changelogs is a bad idea: they're full of noise."; "Keep
  an Unreleased section at the top to track upcoming changes."
- Stripe changelog: named release lines with dated versions, a
  "Breaking change?" column, product grouping.
- GitLab: "For each release, the product manager is responsible for
  creating the MR and files for the feature release note."
- Linear Method: "Writing a changelog benefits both internal and
  external communication. Internally, it helps your team to track
  progress and reflect on what they have achieved."
- Charak, Product Decision Records: "Every decision has a context…";
  fields "Name, Date, Status (Open/Accepted/Rejected), Scope, Context,
  Decision, Consequences, Review Trigger"; "important for decisions to
  be revisited every so often."
- Productboard: "Organizational product memory is the shared record of
  what a product organization has learned. It captures your decisions,
  the reasons behind them, customer evidence, and competitive
  context". Metabase: "Institutional memory is a company's collective
  knowledge of what things mean, how they've changed, and who changed
  them."; "If something is in your face every day, you're more likely
  to keep it up to date."
- Quackback (vendor): the changelog creates "an institutional record of
  product decisions" — the one source conflating the two.

### F6 — Cross-context features *(high)*

- Evans, DDD Reference, Partnership: "Where development failure in
  either of two contexts would result in delivery failure for both,
  forge a partnership between the teams in charge of the two contexts.
  Institute a process for coordinated planning of development and
  joint management of integration."; Customer/Supplier: "Negotiate and
  budget tasks for downstream requirements".
- Fowler, BoundedContext: contexts "share concepts (such as products
  and customers)… Different contexts may have completely different
  models of common concepts".
- CQRS Journey, "A Saga on Sagas": "there may be some business
  processes that involve multiple aggregates, or multiple aggregates in
  multiple bounded contexts"; "the definition of the message flow is
  now located in a single place, the process manager"; "the process
  manager does not perform any business logic. It only routes
  messages".
- Tune: "The dashboard does not belong to the Review system — it's a
  composite of capabilities provided by other bounded contexts";
  "when there are changes to the user journey, multiple business
  capability teams may need to coordinate"; "constant meetings,
  corresponding changes between one or more systems, and teams
  constantly being blocked by others are serious warning signs".
- Fowler/Narayan, Products Over Projects: "For initiatives that cut
  across multiple product-mode teams, it is recommended to appoint
  silo-penetrating, priority-negotiating, dependency-managing solution
  champions"; "Cross-cutting initiatives are prioritized by the
  business or tech leadership. Initiatives don't get their own team.
  They are parceled out to pre-existing product-mode teams."; "aim for
  two-thirds roadmap work and no more than one-third initiative work."
- Team Topologies: Collaboration — "working together for a defined
  period of time to discover new things"; X-as-a-Service; Facilitation.
  Plöd: "Bounded contexts are the preferred way of identifying
  boundaries for teams in the team topology environment."
- Newman: "Getting service boundaries wrong can be expensive. It can
  lead to a larger number of cross-service changes"; a team "decided to
  merge the services back into one big application."
- LeSS: "A feature team is a long-lived, cross-functional,
  cross-component team that completes many end-to-end customer
  features"; "Product Backlog Items are not pre-assigned to the teams."
- Lee, Spotify: "Spotify did not define a common process for
  cross-team collaboration."; "Autonomy requires alignment."

## Alternatives considered

- **Keep the brief as the first artifact and let the architect split
  cross-context requests ad hoc.** This is Spotify's documented gap; no
  opened source supports a per-team document as the first product
  artifact. Rejected.
- **Adopt LeSS: one product backlog, no context ownership.** It answers
  "requests against a product" directly but discards the
  context-owning shops the architecture principles and isolation rest
  on. Rejected as a whole; its single-backlog idea survives as the
  roadmap-of-initiatives.
- **Adopt Shape Up whole (pitches, betting, no backlog).** Its pitch is
  the best-formed product-level artifact found, and the appetite and
  no-gos are adopted into the initiative; its rejection of any backlog
  conflicts with the PO role's exclusive domain. Partial adoption.
- **Make the changelog the decision history (Quackback's claim).** The
  decision-record sources separate shipped from decided; conflating
  them loses the reasons. Rejected; both kept, linked.
- **Hand-drawn roadmap.** Every roadmap source warns it drifts into a
  feature list; generating it from initiative statuses keeps it true
  by construction (`single-source-of-truth`). Adopted.

## Limitations

- No controlled comparison of product processes exists; the evidence
  is practitioner texts and company practice, opened in full.
- Perri's strategy-deployment layers are secondhand; the Product
  Roadmaps Relaunched content is from talk notes.
- GitLab's handbook decision practices could not be read.
- The proposal's artifact names (initiative, product strategy) are the
  sources' most common; the authority may prefer the shop's own.
- Residual at the cold-read cap (round 3): the reader found the
  initiative's later status transitions without makers, its owner and
  maker stated inconsistently, and the decomposition without a process;
  all three were closed in this version without a further read.
- Residual at the verification cap (round 3): four precision findings —
  a quote's page, a co-author credit, a label's wording, a paraphrase
  in quotation marks — were repaired in this version without a
  further verification round. No retraction was required in any round.
- What would change the judgment: a source showing that a persistent
  product-level artifact slows small teams more than ad hoc splitting
  costs them; or an authority decision that the framing itself should
  persist and carry the initiative's fields.

## Sources

Opened in full unless marked. svpg.com: product-strategy-overview; assessing-product-opportunities; product-vs-feature-teams; changing-how-you-decide-which-problems-to-solve; product-vision-vs-mission; the-alternative-to-roadmaps; team-objectives-overview; problems-to-solve-not-features-to-build (UNOPENED, redirect). producttalk.org/opportunity-solution-trees. melissaperri.com: 2016/07/14 what-is-good-product-strategy; 2015/07/22 the-product-kata; 2014/05/19 rethinking-the-product-roadmap; strategy-deployment (UNOPENED, secondhand). basecamp.com/shapeup: 1.1-chapter-02; 1.2-chapter-03; 1.5-chapter-06; 2.1-chapter-07. workingbackwards.com/concepts/working-backwards-pr-faq-process; McAllister on Quora (via proxy). intercom.com/blog: rice-simple-prioritization-for-product-managers; how-we-build-software. lennysnewsletter.com/p/my-favorite-templates-issue-37 (via proxy; linked docs not opened). coda.io/@yuhki figma PRD. reforge.com/blog/the-product-strategy-stack (via proxy); review.firstround.com set-non-goals-and-build-a-product-strategy-stack. linear.app: method/introduction; method/product-direction; method/write-issues-not-user-stories; docs/initiatives; docs/projects; changelog. prodpad.com/blog/now-next-later-roadmap. oreilly.com Product Roadmaps Relaunched (UNOPENED); walkerux notes on McCarthy's talk (secondhand). keepachangelog.com/en/1.1.0; docs.stripe.com/changelog; github.blog/changelog; docs.gitlab.com release_notes; handbook.gitlab.com product-processes (UNOPENED, navigation only). quackback.io/blog/keep-a-changelog (vendor). dinker.in/product-decision-records. productboard.com: what-is-organizational-product-memory; why-a-single-source-of-truth-is-critical-for-product-roadmapping (vendor). metabase.com/blog/institutional-memory. medium.com/wardleymaps/on-being-lost (via proxy). domainlanguage.com DDD_Reference_2015-03.pdf (via proxy). martinfowler.com: bliki/BoundedContext; articles/products-over-projects; bliki/BusinessCapabilityCentric (partial). infoq.com news/2016/07/microservices-ddd-vernon (secondhand); infoq.com podcasts sam-newman-ddd-microservices (partial). learn.microsoft.com CQRS Journey jj591569. codecentric.de eventstorming-meets-domain-driven-design (secondhand); virtualddd.com heuristics design-bounded-contexts-around-eventstorming-policies. medium.com/nick-tune-tech-strategy-blog: aligning-teams-with-business-capabilities…; confusing-process-stages-with-bounded-contexts (via proxy). innoq.com 2024/07 identifikation-von-team-grenzen. teamtopologies.com/key-concepts; key-concepts-content core team types; itrevolution.com/articles/four-team-types. samnewman.io 2015/04/07 microservices-for-greenfield. less.works: structure/feature-teams; framework/product-backlog. jeremiahlee.com/posts/failed-squad-goals (via proxy). oreilly.com IDDD ch.14 (UNOPENED).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Draft synthesized from three gather workers' notes. |
| 1 | 2026-08-26 | review | Verification round 1: findings — no retractions; a co-authored essay credited to one author; "touchstone" misattributed to Amazon's site; three silent truncations; the process-manager quote stretched to the multi-context case; a scheme clause that made high unreachable; SAFe named though uncited. |
| 2 | 2026-08-26 | update | Round-1 repairs applied. |
| 2 | 2026-08-26 | review | Verification round 2: findings — one credit half-repaired; one quote tail in F4; the medium clause duplicated and two labels not reproducible; Limitations citing a removed clause. |
| 3 | 2026-08-26 | update | Round-2 repairs applied; the scheme's medium clause rewritten to cover part-claims and dissent. |
| 3 | 2026-08-26 | review | Verification round 3 (cap): findings — no retraction; a First Round quote placed under Reforge; the Reforge blog's co-author omitted; F3's dissent label not in the scheme's terms; a paraphrase inside quotation marks. |
| 4 | 2026-08-26 | update | Finalized as the report at the verification cap: the four round-3 repairs applied without a further verification round, disclosed in Limitations; cold read opened. |
| 4 | 2026-08-26 | review | Cold read round 1: findings — the proposal's initiative statuses did not produce the roadmap's columns; the changelog was curated in one item and generated in another; item 9 not decidable per definition; names arriving unintroduced; the scheme's amendment from the frame unstated. |
| 5 | 2026-08-26 | update | Repairs: planned added to the lifecycle; changelog and roadmap both compiler renderings with named producers and owner; item 9 rewritten one line per definition with the missing rows; a source key in the vocabulary note; the scheme amendment stated; the shop's missing count added to judgment 7 beside finding 6's frequency evidence. |
| 5 | 2026-08-26 | review | Cold read round 2: findings — the initiative's maker and checker were one role and no process made it; the go/no-go was not tied to a transition; the changelog's Unreleased clause named a field the initiative lacked; two statements about the framing contradicted the frame; unattributed quotes and names. |
| 6 | 2026-08-26 | update | Repairs: the PO role makes the initiative and the PM role checks it, the go/no-go being proposed → planned; the strategy's authoring, screening, and approval named; fitness sets added to item 9; the framing statements corrected; attributions and the source key completed. |
| 6 | 2026-08-26 | review | Cold read round 3 (cap): findings — post-planned transitions without makers; owner vs maker on the initiative; the decomposition with no process; the strategy's check of record unstated. |
| 7 | 2026-08-26 | update | Delivered at the cold-read cap: every transition given a maker and process; owner (lead-pm) and maker (lead-po) stated; a decompose step named in the PO output check; the cold-reviewer screen named as the strategy's check of record; residual disclosed. |
| 7 | 2026-08-26 | state | draft → delivered. |
