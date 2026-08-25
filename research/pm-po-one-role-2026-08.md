---
type: research-report
id: pm-po-one-role-2026-08
status: delivered
version: 7
date: 2026-08-25
question: "Do more research in the vein of Marty Cagan's combined role of PM and PO. Are these the same role with different activities? What is served by having two different roles in our system."
requested-by: product-authority
created: 2026-08-25
updated: 2026-08-25
---

# Research report: are the product manager and product owner one role, and what a second role serves

## Executive summary

*How to read the labels.* Each finding carries a confidence: **high** —
several sources opened in full agree, at least one primary (the author,
framework, or standard itself); **medium** — one opened source, or
secondary accounts only, or several agreeing sources that are case
studies or practitioner report with no controlled comparison; **low** — recall without a source, or a primary
that could not be read. "Secondhand" marks a quote carried by a secondary
account because the primary was unreachable. Confidence is about the
evidence; where a finding predicts an outcome, likelihood is stated in
its own phrase.

*How the sources' vocabulary maps to the shop.* "One person" in the
sources means one accountable party; in this shop a role is a named
capability contract assigned by process steps to whoever fills it, so
"one person" reads as "one accountability". `lead-pm` runs in the
authority's own turn (the interactive position); `lead-po` runs as a
delegated subagent (the batch position). SAFe is the Scaled Agile
Framework; it is cited here as one position on the spectrum, not as a
model for the shop. LeSS is Large-Scale Scrum. RACI is the
responsibility matrix (Responsible does the work; exactly one
Accountable answers for it). SoD is separation of duties; maker/checker means the party that
produces a thing and the party that checks it are different. Product
Focus is a product-management training firm that publishes an annual
survey. Holacracy is
a self-management system whose constitution defines roles formally;
Team Topologies is Skelton and Pais's book on team design. SVPG is
Cagan's firm, the Silicon Valley Product Group, whose essays are the
Cagan sources; Milner is a commentator at Mountain Goat Software (Mike
Cohn's firm); InfoQ published an interview with the Scrum Guide's
authors on the 2020 edition; ISO/IEC/IEEE 24765 is the software
engineering vocabulary standard; PMBOK is the Project Management Body
of Knowledge.
`lead-solutions-architect` is the shop's architecture role. Execution
position — whether a step runs in the authority's turn or as a
delegated agent — is recorded on process steps (`run-by`), not on
roles, by the authority's direction; the authority has since observed
that any activity should be able to pause its step and ask another
role a question, which this report calls an ask mechanism. The prior report on these roles is
`research:research/pm-po-roles-2026-08`.

1. **Cagan's objection is to two accountabilities and to mediated access,
   not to a second role as such.** His test is "so long as it was one
   person"; the harm he names is that the split "causes the PM to lose
   the direct access to engineers" and that "there is no clear owner". He
   sanctions offloading work — acceptance testing is "a very minor
   responsibility", research logistics can go to "part-time
   administrative help" — and accepts a separately-scoped role beside the
   PM (the business owner) when its responsibilities are explicit and it
   does not own solutions. *(High — five SVPG essays opened in full.)*
2. **The Scrum Guide, Pichler, Scrum.org, LeSS, and Perri converge on
   the same shape: one non-delegable accountability, delegable work.**
   Scrum Guide 2020: "The Product Owner may do the above work or may
   delegate the responsibility to others. Regardless, the Product Owner
   remains accountable"; "one person, not a committee". Perri: "Product
   Owner is a role you play on a Scrum team. Product Manager is the
   job." Cagan (interview): "The role the product manager plays on an
   Agile team is the product owner role." Pichler disagrees with Cagan on
   which name carries the larger scope but agrees on one accountability.
   *(High.)*
3. **The answer to "same role with different activities?" is: in the
   sources' own vocabulary, yes — and the distinction they draw is
   accountability versus responsibility, not role versus activity.**
   The 2020 Scrum Guide replaced "role" with "accountability". Milner's
   commentary reads the change as separating role from job title
   ("Apparently some people thought that the term 'role' meant job
   title"); the Guide's own revisions page gives no rationale for the
   word change, and the authors' only stated rationale (InfoQ) concerns
   removing the separate Development Team, not the word. ISO/IEC/IEEE
   24765 defines a role (its second definition, credited to the PMBOK
   Guide 4th ed.) as "a defined function to be performed by a project
   team member" and puts activities and tasks in processes; Holacracy's
   role form is purpose + exclusive domain + accountabilities, where
   accountabilities are "ongoing activities". Scrum and Holacracy make
   one accountability the unit and let it carry many activities; ISO's
   examples — coding and testing as distinct functions — are themselves
   a maker/checker split. Under these forms a second role
   has to earn its existence; the grounds on which it can are in
   finding 5. *(High on the sources' definitions; the reading is the
   report's.)*
4. **The case for two roles, at its strongest, rests on scale and
   distribution — and the reported consequence of that split is a
   hollowed-out PO.** The two-role case: SAFe ("a single person cannot
   handle product and market strategy while also being dedicated to
   agile teams" — secondhand, SAFe's pages are login-walled); Pragmatic
   ("When everyone sits together, there's no need for a product owner";
   a local PO is warranted when development "is split across time zones
   and continents"); Product Focus (35% of PMs also do the PO role, at
   ~40% of their time — survey method unstated); Pichler's scaling essay
   (a strategic/tactical split "works well if a tight integration... is
   not required", unfit for young products). The reported consequence:
   Remta & Buchalcevová (2021, literature mapping) — "the real Product
   Ownership lies in the hands of the Product Manager", the PO "seems
   only to be responsible for driving and overseeing the execution";
   Remta et al. (2020, single case) — "the PO's accountability for product
   leadership fades away"; Perri — "I have never seen this work well...
   No one is doing validation work." No quantitative comparison of split
   versus combined exists; Verwijs: "There is unfortunately a lack of
   quantitative research in this field." *(High that the sources say so;
   medium on the consequence, which rests on case studies and practitioner
   report — likely to recur here if the two roles were split on the
   market/development line, the more so because the scale and
   distribution rationale for that split is absent in a lead shop of
   one authority.)*
5. **The organizational literature gives three grounds on which a second
   role earns its existence — and only one of them is an accountability
   ground.** (a) Separation of duties: the maker should not be the checker
   — the software SoD list puts "identification of a requirement" and
   "review, inspection and approval" in different hands; RACI's single A
   with delegated R is the compatible form. (b) A distinct exclusive
   domain (Holacracy). (c) Cognitive load of the filler (Team Topologies)
   — for agent-filled roles, context load. Bass & Haxby's large-scale
   study shows the practice: a "product owner team" in which a sponsor
   "delegate[s] to a named product owner" and keeps "focus on the project
   vision by reviewing important demonstrations" — one accountability,
   a more available execution position. *(Medium for each ground — (a) rests on secondary accounts, (b) and
   (c) on one opened source each; medium for Bass & Haxby's pattern as
   evidence of the shape.)*
6. **The agent-delegation literature states the shop's arrangement
   directly and names its failure mode.** Koch & Wellbrock (2026): "agents may
   execute tasks, but accountability remains assigned to human roles";
   anti-pattern "Human as liability buffer — Employees carry
   responsibility without time or authority — Give review time,
   criteria, override rights, and escalation paths." An accountable role
   without a stated check is Cagan's "backlog administrator" ("Behind
   Every Great Product") from the other side. *(Medium — one paper opened in full, plus vendor guidance.)*
7. **What a second role serves in this shop — the report's judgment,
   composed from findings 1–6, so no confidence label.**
   *The decision.* Keep two roles, on the maker/checker ground (finding
   5, ground (a)) — which the shop's own principle supplies
   independently of that ground's secondary sources
   (`define-good-up-front`: "The check MUST sit with a different role
   holding a different accountability"). The industry's scale and
   distribution ground does not apply to a lead shop of one authority;
   the execution-position ground (c) is a process fact (`run-by` and
   step inputs), not a role fact, and an ask mechanism would serve it
   without any role split.
   *The two exclusive domains.* `lead-po`: authorship of acceptance
   scenarios, and backlog order, within the PM's framing — the maker.
   `lead-pm`: the framing of intent, and the check on the PO's output
   against that framing — the checker. The prior report gave the PO
   "acceptance — which scenarios count as done"; this report moves that
   check to the PM and leaves the PO authorship. That is the reversal.
   *The three consequences.* The PM's accountability for the product
   outcome is singular and never delegated (Scrum's delegation clause).
   The PM's check on PO output is a named process step with named
   criteria, or the split is nominal (finding 6) — likely, on the
   sources, to decay into a backlog administrator and a rubber stamp
   otherwise. A single role with two activities would satisfy the
   industry sources but would put maker and checker in one
   accountability, which the shop's principle forbids.
8. **The alternative the authority may prefer: one role, `lead-pm`, with
   the PO work as process steps it may run in either position.** This is
   the industry-default shape and the least-definition answer; it
   forfeits the maker/checker check unless that check is placed with
   another role (the authority itself, or `lead-solutions-architect`
   for feasibility only) — a decision, so no confidence label; likely
   to hold only while the authority has the time and criteria to run
   the check in person (finding 6).
## Method

Three parallel gather workers in fresh contexts: Cagan's own position
(SVPG essays opened in full: product-manager-vs-product-owner, ...-revisited,
product-management-start-here, two-in-a-box-pm,
the-product-manager-contribution, behind-every-great-product,
product-managers-vs-business-owners, a-fresh-definition-of-the-product-role;
one interview via LinkedIn; the Wolpers Q&A; Inspired ch. 10 unreachable);
the Scrum Guide 2020, its revisions page, the InfoQ Q&A with Schwaber and
Sutherland, Milner's commentary; Pichler (four essays); the two-role
case (Pichler scaling, Scrum.org West via reader proxy, SAFe summaries
only — login-walled, Pragmatic two, Product Focus, Wolpers theses,
Verwijs review, Remta & Buchalcevová 2021, Remta et al. 2020, Bass &
Haxby 2018 PDF, Sverrisdottir 2014 abstract, LeSS, Perri, Cottmeyer);
role and accountability theory (SEVOCAB ISO/IEC/IEEE 24765 PDF, Holacracy
constitution 5.0, SFIA about page, Galbraith Star Model, Mintzberg 1980,
Team Topologies two pages, Wikipedia on RACI, separation of duties,
maker-checker, Koch & Wellbrock arXiv 2606.16649, Anthropic
building-effective-agents, EU AI Act art. 14). Roughly 45 sources opened
in full. Evidence extracted quotes-first; an independent fresh-context
verification pass followed.

## Findings

### F1 — Cagan's position, verbatim *(high)*

- "Product Manager vs. Product Owner" (svpg.com): "All too often I run
  into companies that have resigned themselves to having two different
  people covering the product role"; "there is no clear owner (neither
  person takes responsibility for the product)"; "find product people
  that can cover both aspects of the role."
- "...Revisited": "I didn't really care what the person was called, so
  long as it was one person"; "the product owner responsibility is just
  a very minor part."
- "Product Management – Start Here": "there's an important
  administrative role called the product owner, and the product manager
  needs to cover these responsibilities"; "the product owner
  responsibilities are just a very small subset of the product manager
  responsibilities."
- "Two in a Box PM": "the way the job is defined indeed really is too
  much for one person... But the way the job is scoped down is the key";
  protect "Direct Access To Users and Customers... Direct Access to
  Business Stakeholders... Direct Access to Engineers and Designer";
  "fight any temptation to place a person (or process) between the PM
  and these people"; the split "causes the PM to lose the direct access
  to engineers"; "it's normal for the PM to be responsible for
  acceptance testing, but that is a very minor responsibility"; "get
  some part-time administrative help to support this work."
- "Behind Every Great Product": "In this model, the product manager is
  really a backlog administrator."
- "Product Managers vs. Business Owners": "Things go wrong when these
  two roles are not clearly defined, especially when the business owner
  believes he is responsible for the product solutions."
- Interview (Jansen, LinkedIn): "The job title is Product Manager. The
  role the product manager plays on an Agile team is the product owner
  role."
- Wolpers Q&A (age-of-product.com): "A product owner is roughly 10% of a
  true product manager."

### F2 — The convergent shape *(high)*

- Scrum Guide 2020 (scrumguides.org): "Scrum defines three specific
  accountabilities within the Scrum Team"; the PO "may do the above work
  or may delegate the responsibility to others. Regardless, the Product
  Owner remains accountable"; "one person, not a committee"; "the entire
  organization must respect their decisions."
- Schwaber (InfoQ): "The separate Development Team could create 'us and
  them' behavior... By removing the Development Team, we have one Scrum
  Team focused on the same objective."
- Pichler: "the Scrum product owner as an agile product manager"; "the
  product owner is a product management role"; on SAFe: "calling the
  tactical role 'product owner'... is an unfortunate mistake"; and, on
  Cagan: "I disagree with his take on the product owner role. I believe
  that it is based on how he has seen the role applied rather than how
  it is intended."
- West (Scrum.org): "organizations need to consolidate on one overall
  decision maker for the product"; "the Product Owner role should be
  performed by a business person, and for many organizations that means
  a product manager."
- LeSS: "She acts as a connector, not an intermediary".
- Perri: "Product Owner is a role you play on a Scrum team. Product
  Manager is the job."

### F3 — Role versus activity in the external forms *(high)*

- Milner (Mountain Goat, on the 2020 Guide): "The term 'role' has been
  dropped in favor of the term 'accountabilities'"; "Apparently some
  people thought that the term 'role' meant job title"; and the
  residual: "That missing word sounds an awful lot like a role to me."
- ISO/IEC/IEEE 24765:2010, 3.2603 role, definition 2 (credited to the
  PMBOK Guide 4th ed.): "a defined function to be
  performed by a project team member, such as testing, filing,
  inspecting, coding"; 3.53 activity: "set of cohesive tasks of a
  process".
- Holacracy Constitution 5.0, 1.1: a Role's Purpose, Domain ("things the
  Role may exclusively control"), Accountabilities ("ongoing activities
  the Role will manage and enact").
- SFIA: "SFIA does not define a fixed methodology or prescribe
  organisational structures, roles or jobs".
- Galbraith, Star Model: "The structure of the organization determines
  the placement of power and authority"; "processes are its physiology".

### F4 — The two-role case and its reported consequences *(high that the sources say so; medium on the consequence)*

- Remta & Buchalcevová 2021 (DOI 10.3390/info12030107), quoting SAFe:
  "SAFe implies that a single person cannot handle product and market
  strategy while also being dedicated to agile teams"; discussion: "the
  removal of the Product Owner's real product ownership. In SAFe, the
  real Product Ownership lies in the hands of the Product Manager";
  conclusions: "the Product Manager has real product ownership, while
  the Product Owner is responsible for driving and overseeing the
  implementation of the requirements."
- Remta, Doležel & Buchalcevová 2020 (DOI 10.1007/978-3-030-58858-8_10):
  "the PO's accountability for product leadership fades away";
  interviewee: "the decisions will come from the management, not the
  product owner." Single case, three interviews.
- Pragmatic Institute: "a product owner's responsibilities are just a
  small subset of product management"; "When everyone sits together,
  there's no need for a product owner"; a local PO "seems essential"
  when development is distributed.
- Product Focus: "35% of Product Managers also do the Product Owner
  role"; "just under 2 days a week"; "get someone else to do the Product
  Owner role – someone who takes direction from you."
- Pichler, scaling: "Splitting product responsibilities along the
  strategic-tactical dimension works well if a tight integration... is
  not required"; risk of "strategic decisions not effectively guiding
  tactical ones".
- Perri: "I have never seen this work well... No one is doing validation
  work"; "If you give a Product Manager a large scrum team's backlog to
  keep filling while you are in discovery mode... neither gets done
  well."
- Verwijs: "There is unfortunately a lack of quantitative research in
  this field."
- Sverrisdottir et al. 2014 (abstract only): "Cases were reported where
  there are two product owners for the same product. One is then
  responsible for business aspect but the other is responsible for
  technical aspects."

### F5 — Grounds for a second role *(medium for each ground and for Bass & Haxby's pattern)*

- Separation of duties (Wikipedia, opened): "the same person or
  organizations performs only one of the following roles: Identification
  of a requirement... Authorization and approval... Design and
  development... Review, inspection and approval... Implementation";
  "When duties cannot be separated, compensating controls should be in
  place." Maker-checker: "for each transaction, there must be at least
  two individuals necessary for its completion."
- RACI (Wikipedia, opened): Accountable is "The one ultimately
  answerable... delegating the work to those responsible"; "According
  to some theories of project management, there must be only one
  accountable stakeholder."
- Team Topologies: "Each new tool, responsibility or domain your team is
  given taxes their mental bandwidth."
- Bass & Haxby 2018 (arXiv 1812.06524): "Product sponsors surround
  themselves with a product owner team and delegate to a named product
  owner... product sponsors maintain focus on the project vision by
  reviewing important demonstrations"; "the purpose of the intermediary
  is to be more accessible and available."
- Mintzberg 1980: structuring "focuses on the division of labor... and
  then the coordination of all of these tasks", which "can be effected
  in at least five basic ways" — "mutual adjustment, direct supervision, and
  the standardization of work processes, outputs, and skills."

### F6 — Agent delegation with human accountability *(medium)*

- Koch & Wellbrock, arXiv 2606.16649: "agents may execute tasks, but
  accountability remains assigned to human roles and organizational
  units"; "Human-in-the-loop must not turn employees into liability
  buffers for poorly designed systems"; remedy: "Give review time,
  criteria, override rights, and escalation paths."
- Anthropic, building-effective-agents: "a central LLM dynamically
  breaks down tasks, delegates them to worker LLMs, and synthesizes
  their results"; "Agents can then pause for human feedback at
  checkpoints."
- EU AI Act art. 14 (by analogy only): overseers must be able to
  "override or reverse the output".

## Alternatives considered

- **Two roles split by facing (market/development) — Pragmatic, SAFe.**
  This is the split Cagan attacks and Remta documents hollowing the PO.
  The shop has no distribution or scale to justify it. Rejected.
- **One role, `lead-pm`, PO work as its activities.** Industry-default
  and vocabulary-consistent (F3). It puts maker and checker in one
  accountability; survives only if the check is placed elsewhere
  (finding 8). Kept as the alternative for the authority.
- **Two roles split by execution position.** Execution position is a
  process fact; the authority has already ruled it out of role typedefs.
  Not a role-level ground. Rejected as the justification, though the
  load benefit stands (ground c).
- **Two roles split by maker/checker.** The only ground both the
  industry sources and the shop's principles support. Adopted in
  finding 7.

## Limitations

- SAFe's role pages are login-walled; its rationale is secondhand via
  Remta & Buchalcevová.
- Inspired ch. 10 (O'Reilly, 403) not opened; Cagan's book position is
  carried by the SVPG essays.
- The consequence evidence (F4) is case studies and practitioner
  report; no controlled comparison exists (Verwijs).
- Product Focus's survey figures lack stated method and year.
- Mintzberg's definition of structure ("divides its labor... achieves
  coordination") was not locatable in the scanned 1980 paper —
  knowledge-only, not used as a finding.
- Scrum.org's own "role → accountabilities" blog posts were bot-blocked;
  the rationale is from Milner and the InfoQ Q&A.
- Residual at the verification cap (round 3): the verifier found
  ground (a) in F5 labeled high on secondary sources only; the relabel
  to medium was applied in this report without a further verification
  round. No other finding was open.
- What would change the judgment: a source showing that separating
  maker and checker of product requirements measurably harms outcomes
  for small teams; or an authority decision that the PM's check on PO
  output is not worth a role.

## Sources

Opened in full unless marked. SVPG: product-manager-vs-product-owner; product-manager-vs-product-owner-revisited; product-management-start-here; two-in-a-box-pm; the-product-manager-contribution; behind-every-great-product; product-managers-vs-business-owners; a-fresh-definition-of-the-product-role. linkedin.com/pulse/interview-empowered-marty-cagan-mark-a-jansen. age-of-product.com/marty-cagan-product-operating-model; age-of-product.com/scrum-product-owner-theses. Inspired 2nd ed. ch. 10 (UNOPENED, 403). scrumguides.org/scrum-guide.html; scrumguides.org/revisions.html; infoq.com/articles/changes-2020-Scrum-guide; mountaingoatsoftware.com top-5-changes-in-the-2020-version-of-the-scrum-guide; Scrum.org role→accountabilities posts (UNOPENED). romanpichler.com: product-manager-vs-product-owner; six-types-of-product-owners; product-owner-product-manager; how-agile-has-changed-product-management; scaling-the-product-owner. scrum.org/resources/product-owner-vs-product-manager (via reader proxy). framework.scaledagile.com/product-owner and /product-management (summary only; login-walled). pragmaticinstitute.com product-owner-vs-product-manager-whats-the-difference; the-strategic-role-of-product-management-when-development-goes-agile. productfocus.com/a-product-owner-is-not-a-product-manager. medium.com/the-liberators/what-makes-a-good-product-owner (via proxy). Remta & Buchalcevová 2021, DOI 10.3390/info12030107 (via proxy). Remta, Doležel & Buchalcevová 2020, DOI 10.1007/978-3-030-58858-8_10 (via proxy). Bass & Haxby 2018, arXiv 1812.06524 (PDF). Sverrisdottir et al. 2014, DOI 10.1016/j.sbspro.2014.03.030 (abstract only). Paasivaara et al. 2012 (UNOPENED). Unger-Windeler et al. 2021 (UNOPENED). less.works/less/framework/product-owner. melissaperri.com 2017/06/29 product-manager-vs-product-owner (via proxy). leadingagile.com 2009/02 product-owner-vs-product-manager (via proxy). ISO/IEC/IEEE 24765:2010 PDF (cse.msu.edu mirror). holacracy.org/constitution/5-0. sfia-online.org/en/about-sfia/about-sfia. jaygalbraith.com StarModel.pdf. Mintzberg 1980, DOI 10.1287/mnsc.26.3.322 (scanned PDF, OCR). teamtopologies.com/key-concepts; itrevolution.com/articles/cognitive-load. en.wikipedia.org: Responsibility_assignment_matrix; Separation_of_duties; Maker-checker. arXiv 2606.16649 (PDF). anthropic.com/engineering/building-effective-agents. artificialintelligenceact.eu/article/14. strata.io human-in-the-loop (PARTIAL).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-25 | update | Draft synthesized from three gather workers' notes. |
| 1 | 2026-08-25 | review | Verification round 1: findings — six attribution and labeling corrections, no retractions. |
| 2 | 2026-08-25 | update | Round-1 repairs applied; finding 7 notes that a general ask mechanism serves ground (c) without a role split, following the authority's observation on interaction. |
| 2 | 2026-08-25 | review | Verification round 2: findings — two precision repairs (a rationale's referent; the scheme lacked the criterion under which F4's consequence label was medium). |
| 3 | 2026-08-25 | update | Round-2 repairs applied: referent made explicit; scheme gains the case-study clause so the label is reproducible. |
| 3 | 2026-08-25 | review | Verification round 3 (cap): findings — one label overstated (ground (a), secondary sources only); no quote or attribution error. |
| 4 | 2026-08-25 | update | Finalized as the report at the verification cap: ground (a) relabeled medium, judgment's footing on the shop's principle made explicit, residual disclosed in Limitations; cold read opened. |
| 4 | 2026-08-25 | review | Cold read round 1: findings — item 7 interleaved decision, domains, and a digression; "acceptance" used in three senses; terms unexplained; likelihood phrases missing; ground (b) overlabeled. |
| 5 | 2026-08-25 | update | Cold-read repairs: item 7 restructured as decision, domains, consequences; the reversal named; terms glossed in the vocabulary note; likelihood phrases added to 4, 7, 8; ground (b) relabeled medium; "backlog administrator" sourced in F1. |
| 5 | 2026-08-25 | review | Cold read round 2: findings — ground (c) overlabeled, item 4's likelihood phrase ambiguous, five terms unglossed, item 3 one sentence. |
| 6 | 2026-08-25 | update | Repairs: every ground in F5 medium; item 4's likelihood names its condition; SVPG, Milner, InfoQ, ISO 24765, PMBOK glossed; item 3 split into sentences; item 3's label states the reading is the report's. |
| 6 | 2026-08-25 | review | Cold read round 3: clean — consumer can act on the summary alone; three non-blocking notes. |
| 7 | 2026-08-25 | update | Non-blocking notes applied (ISO's maker/checker pair is coding/testing; maker/checker and Product Focus glossed); status set to delivered. |
