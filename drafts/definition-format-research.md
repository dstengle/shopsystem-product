# Definition-format research: established forms for the quality-layer seed

**Status: SITTING MATERIAL — not ratified, decides nothing.** This document
describes established external forms and recommends candidates; every decision
in it belongs to the product authority. Date: 2026-08-05. Produced by the
definition-format research directed in the re-founding dialogue (the
construction-definitions-precede-checks re-founding of the quality layer).

Conventions: every claim carries a citation to a verified source. Where the
research corpus contained a described inaccuracy, the corrected fact is used
here and marked "(corrected)".

Revision note (2026-08-06 repair pass, day after first draft): a
completeness-critique repair added the quality-management lineage (new §1.6),
role-assignment and role-anatomy forms (§1.2), and document-typing traditions
(§1.3), with matching deltas in §2, and repaired cited inconsistencies
(Essence 2.0 status, §2.4/open-question-1 alignment, evaluative and uncited
claims in section 1).

---

## 1. Survey

This section DESCRIBES what exists. It recommends nothing; recommendations are
confined to section 2.

### 1.1 Process definition formats

The ISO/IEC JTC1/SC7 line contains a purpose-built specification for process
description: ISO/IEC/IEEE 24774:2021 (Systems and software engineering — Life
cycle management — Specification for process description, 1st ed., May 2021,
superseding ISO/IEC TR 24774:2010; iso.org/standard/78981.html). Its clause 5.3
required elements are exactly three: process name, purpose, and outcomes; its
clause 5.4 optional elements are activities, tasks, notes, inputs, outputs, and
controls and constraints. Outcomes are short declarative, observable,
assessable results. The process name is a descriptive noun phrase — the
standard warns against verb-noun phrasing, which belongs to activities and
tasks (corrected: an earlier research pass mis-stated this as a verb phrase).
Clause 6 defines process views/viewpoints; clause 7 defines conformance claims.
The standard prescribes description, not execution: it carries no workflow or
sequencing semantics.

ISO/IEC/IEEE 15288:2023 (System life cycle processes) and ISO/IEC/IEEE
12207:2017 (Software life cycle processes) are the large worked corpus written
in that convention: roughly 30 processes each, every one rendered as title,
one-sentence purpose, 3–8 declarative outcomes, then activities decomposed into
shall-level tasks, grouped into agreement / organizational project-enabling /
technical management / technical categories (standards.ieee.org/ieee/15288/10424/).

The ISO/IEC 330xx process-assessment family (ISO/IEC 33001:2015, 33004:2015,
measurement framework in 33020; superseding ISO/IEC 15504 as of March 2015;
iso.org/standard/54175.html) formalizes the connection between definitions and
checks: a Process Reference Model describes each process by purpose + outcomes
only and must be free of capability/measurement aspects; a Process Assessment
Model then maps assessment indicators — base practices and work products — onto
those outcomes; a measurement framework adds rated process attributes. Checks
are formally derived from, and traceable to, purpose+outcome definitions.

ETVX (Radice, Roth, O'Hara, Ciarfella, "A Programming Process Architecture",
IBM Systems Journal 24(2), 1985, pp. 79–90) is a classic
per-activity frame: Entry criteria, Task set, Validation conditions, eXit
criteria per activity cell, composable by chaining, with no ordering engine.
(Corrected: the original expansion is Validation, not Verification; both
renderings circulate in CMM-lineage secondary literature. A free scan exists at
bitsavers.org despite the IBM Systems Journal paywall.) The frame places
validation conditions inside the activity definition cell itself.

OMG Essence 1.2 (SEMAT; OMG formal/18-10-02, 2018; omg.org/spec/Essence —
1.2 remains the current formal version; Essence 2.0 is still an in-process
beta, its beta 2 published March 2026 and not yet formally published as of
August 2026, per the OMG specification page — corrected) defines
progress and health rather than workflow: Alphas (essential trackable concerns)
with ordered named states, each state carrying a short qualitative checklist;
activities whose completion criteria are expressed in terms of alpha states and
work-product levels of detail — a definition-level termination semantic
requiring no engine; competencies with five levels; practice/method
composition; a card presentation format.

CMMI contributes a structural trichotomy: in CMMI for Development V1.3
(CMU/SEI-2010-TR-033, 2010) goals are required components, practices are
expected, and subpractices/example work products are informative — appraisal
targets goal achievement, not practice performance; CMMI V3.0 (ISACA, 2023)
recasts this as practice areas with intent and value statements and
evolutionary practice-group levels. ITIL v3 (Service Design, 2011 ed., Cabinet
Office/TSO) documents every process in one fixed section skeleton (purpose/
objectives, scope, value, policies, activities, triggers/inputs/outputs/
interfaces, CSFs with nested KPIs, risks), and ITIL 4 (AXELOS, 2019; 34
practice guides) does the same for practices — success factors and metrics
nested under the definition.

Notation standards exist but describe flow or I/O, not construction quality:
BPMN 2.0 (OMG formal/2011-01-03; ISO/IEC 19510:2013, which is technically BPMN
2.0.1) with its Descriptive vs Analytic vs Common Executable conformance
sub-classes; CMMN 1.0/1.1 (OMG, 2014; Marin, arXiv:1608.05011) — declarative
case plans with sentries (entry/exit criteria), milestones, and discretionary
items, addressed to case work whose activities cannot be fully pre-sequenced;
IDEF0 (NIST FIPS PUB 183, 1993, withdrawn as a federal
standard in 2008; IEEE 1320.1-1998; ISO/IEC/IEEE 31320-1:2012) with its
Input/Control/Output/Mechanism arrow typing; and PMBOK 6th ed. ITTOs (PMI,
2017), which the PMBOK 7th ed. (2021) itself dropped from the core. ISO/IEC
24744:2014 (SEMDM) models method-level and endeavor-level views of one concept
via powertypes; this survey found no practitioner process corpus written in it
comparable to the 15288/12207 corpus, the application literature encountered
being academic method-engineering work (observation from this research pass,
not a cited measurement).

### 1.2 Role definition formats

OMG SPEM 2.0 (formal/2008-04-01, April 2008; omg.org/spec/SPEM/2.0) draws a
hard structural line between Method Content — reusable Role Definitions
(skills, responsibilities), Task Definitions, Work Product Definitions, typed
Guidance including checklists — and Process, which arranges content occurrences
into lifecycles. A full knowledge base of role/task/artifact definitions can be
maintained without ever creating a process. Eclipse EPF Composer
(projects.eclipse.org/projects/technology.epf; archived, last release 2018)
implements the split in tooling: method plugins publish role/task/work-product/guidance pages
as a browsable static site, no engine. RUP (Kruchten, The Rational Unified
Process: An Introduction, 3rd ed., Addison-Wesley, 2003, ch. 3) is the
ancestor form: roles carry responsibilities plus required competencies, and
every artifact has exactly one responsible role.

The Scrum Guide (Schwaber & Sutherland, November 2020, scrumguides.org) defines
roles as short accountability lists — 4–8 bullets of what the holder is
answerable for, not task scripts.

Responsibility assignment across roles has its own established forms, distinct
from the definition containers above. The responsibility assignment matrix
(RAM) and its common type, the RACI chart, are carried in the PMBOK Guide: a
RAM is "a grid that shows the project resources assigned to each work
package"; a RACI chart is "a common type of RAM that uses responsible,
accountable, consult, and inform statuses to define the involvement of
stakeholders in project activities" (PMI, PMBOK Guide, 6th ed., 2017, §9.1
data-representation tools and glossary — definitions confirmed via
PMI-affiliated PMP literature quoting the Guide, the Guide itself being
paywalled; ancestry in the Linear Responsibility Chart, Cleland & King,
Systems Analysis and Project Management, McGraw-Hill, 1968). The matrix
crosses work items (rows) with roles (columns), one involvement status per
cell. The one-Accountable-per-row rule — exactly one A per deliverable — is
stated as hard doctrine in PMI-affiliated practitioner literature
(observation from this research pass, not a cited survey),
though the PMBOK glossary itself defines only the four statuses; the R-A-C-I
lettering has no documented originator (folklore attributions to GE/1950s are
unverified). Practitioner criticism records recurring failure modes: multiple
As dissolving accountability, R/A conflation, team-level unnamed assignments,
consulted-list bloat, and shelfware charts drafted once and never consulted
(e.g. tallyfy.com/raci-matrix — criticism in circulation, not authority).
Letter-set variants extend the cell vocabulary on the same skeleton: RASCI
(S = Support, splitting doer from helper), RACI-VSL (V = Verifier against
acceptance criteria, S = Signatory), CAIRO (O = explicitly Omitted), RACIQ
(Q = Quality review), PARIS (variant inventory per the Wikipedia RAM article,
en.wikipedia.org/wiki/Responsibility_assignment_matrix). A decision-rights
fork re-targets the matrix from tasks to decisions: Bain's RAPID — Recommend /
Agree / Perform / Input / Decide, "one person who must decide — the single
point of accountability", plus a four-locus taxonomy of decision bottlenecks
(Rogers & Blenko, "Who Has the D?", HBR 84(1), January 2006;
bain.com/insights/who-has-the-d/) — and DACI — Driver / Approver /
Contributors / Informed, one Approver, splitting process ownership (Driver)
from final authority (Approver) (Atlassian Team Playbook,
atlassian.com/team-playbook/plays/daci; the commonly repeated Intuit-1980s
origin is an unverified secondary attribution).

Holacracy constitutionalizes the role definition itself (Holacracy
Constitution v5.0, holacracy.org/constitution/5-0; source text at
github.com/holacracyone/Holacracy-Constitution, CC BY-SA 4.0; Robertson,
Holacracy, Henry Holt, 2015). Its §1.1 defines a Role as a descriptive name
plus three optional typed parts: Purpose ("a capacity, potential, or goal that
the Role will pursue or express"), Domains (things the role exclusively
controls and regulates as its property), and Accountabilities ("ongoing
activities the Role will manage and enact in service of others"), by
HolacracyOne convention phrased as gerunds (a practice convention with no
single defining document identified in this pass). Role and person are
strictly separated: a person filling a role is its Role Lead (§1.2), assigned
by a Circle Lead (§1.4.1), many-to-many in both directions. Definitions change
only through the governance process (Article 5): proposals must be grounded in
a concrete tension with an example (§5.3.1), are processed by integrative
decision-making (§5.4.5), and objections must pass defined validity tests
(§5.3.2–5.3.3); amendments are recorded, giving the role set an audit trail.
A documented exit exists: Medium abandoned Holacracy in 2016, reporting that
"the act of codifying responsibilities in explicit detail hindered a proactive
attitude and sense of communal ownership" (Doyle, "Management and Organization
at Medium", Medium blog, 4 March 2016).

Team Topologies (Skelton & Pais, IT Revolution, 2019; concept definitions at
teamtopologies.com/key-concepts) types teams — stream-aligned, enabling,
complicated-subsystem, platform — and types the relationship between any two
teams into three interaction modes: collaboration ("working together for a
defined period of time to discover new things"), X-as-a-Service ("one team
provides and one team consumes something 'as a Service'"), and facilitating
("one team helps and mentors another team"), with a designed evolution —
collaboration is deliberately time-bounded and expected to decay into
X-as-a-Service as interfaces stabilize. It is the one surveyed form that types
role-to-role interaction rather than involvement in a deliverable.

In current agent practice, the Claude Code subagent definition
(code.claude.com/docs/en/sub-agents) is a Markdown file whose YAML frontmatter
is the delegation and capability contract (required name and description;
optional tools/disallowedTools, model, maxTurns, skills preload list, memory
scope) and whose body is the role's standing system prompt. The shop already
uses this container for lead-po and lead-architect.

### 1.3 Artifact / document-type schema formats

ISO/IEC/IEEE 15289:2019 (Content of life-cycle information items, 4th ed.;
earlier editions 2011/2015/2017; iso.org/standard/74909.html) is the
established meta-format: every information item is classified as one of seven
generic document types — description, plan, policy, procedure, report, request,
specification — each generic type carrying generic content requirements, and
each named item carrying specific required-content clauses. It is explicitly
medium-independent, and its mapping tables tie information items to the
12207/15288 processes that produce and consume them.

RUP artifacts (Kruchten 2003, ch. 3) ship with templates and checkpoints —
per-artifact review checklists attached to the artifact definition. The 2020
Scrum Guide pairs every artifact with exactly one commitment (Product Backlog →
Product Goal, Sprint Backlog → Sprint Goal, Increment → Definition of Done);
the DoD is "a formal description of the state of the Increment when it meets
the quality measures required for the product," with a defined consequence:
non-conforming work returns to the Product Backlog. Microsoft Prompty
(prompty.ai/core-concepts/file-format; microsoft/prompty) demonstrates a
schema-validated asset format whose frontmatter declares inputs, outputs, and
per-input sample/default data. The MCP resources primitive (Model Context
Protocol spec 2025-06-18) standardizes inclusion-decision metadata on context
artifacts: audience, priority 0.0–1.0, lastModified.

Two traditions govern how document kinds themselves are derived and bounded.
DITA 1.3 (OASIS Standard, 17 December 2015; Errata 02, 2018;
docs.oasis-open.org/dita/dita/v1.3) types every topic as one of a small set of
information types sharing one structural envelope (title + prolog metadata +
body): the base triad concept / task / reference, extended in the 1.3
technical-content set by glossaryEntry (introduced in DITA 1.1 — corrected: an
earlier research pass dated it to 1.3) and troubleshooting (the type actually
new in 1.3). Typing exists to "keep documentation focused and modular"; mixing
information types within one topic is the named anti-pattern; and a document's
root element must be <topic> or a specialization, <map> or a specialization,
or <dita> (corrected: <dita> is also a permitted root). Maps — separate
documents that "organize topics and other resources into structured
collections" — carry hierarchy, inter-topic relationships, and key-resolution
context, so organization is fully separated from content. DITA's
specialization architecture (archSpec "Specialization"; the definition sits in
the spec's terminology section) is a governed derivation mechanism: "defining
new element or attribute types as a semantic refinement of existing element or
attribute types". Every specialized type declares its full ancestry (@class),
so a processor that knows only the base type can still process the derived one
(generic fallback); vocabulary compatibility between documents is decidable
(@domains); each type is declared in exactly one vocabulary module; and
constraint modules restrict an existing type's content model as a distinct,
lighter operation than creating a new type (fallback and constraint rules
specified in adjacent archSpec sections).

Diátaxis (Procida, diataxis.fr; authorship per the site's colophon — the
homepage does not name the author) classifies on an axis orthogonal to
15289's content genres: by the user's need at the moment of use. Two axes —
action/cognition crossed with acquisition/application ("at work" vs "at
study") — generate exactly four types: tutorial, how-to guide, reference,
explanation. The type determines "documentation content (what to write),
style (how to write it) and architecture (how to organise it)"; the named
failure mode is the blurring or collapse of the forms into one document,
which the site prescribes keeping apart (an each-document-serves-one-type
rule in paraphrase — the site states it as failure-mode avoidance, not in
those words). Adjacent: arc42 (Hruschka & Starke, arc42.org, in practice
since 2005) is a fixed 12-section skeleton for one composite artifact kind —
the architecture description — with explicit tailoring permission and a
decision-record slot (its section 9) embedding the ADR kind by reference; and
docs-as-code (Write the Docs, writethedocs.org/guide/docs-as-code; Gentle,
Docs Like Code) names the substrate practice — documentation in plain-text
markup under version control, peer-reviewed via the code-review mechanism,
gated by automated tests in CI — while deliberately prescribing no document
types or schemas.

### 1.4 Principle statement formats

TOGAF (The Open Group, TOGAF 9.2, "Architecture Principles" chapter, carried
into the 10th Edition ADM Techniques volume; pubs.opengroup.org) is, among the
sources this survey examined, the only formal template
specifically for principles: Name / Statement
(one-sentence unambiguous rule) / Rationale (business-language why) /
Implications (required actions and impacts), plus five quality criteria for
the set — Understandable, Robust (enables good decisions and enforceable
policies), Complete, Consistent, Stable (enduring but amendable under a change
process). The standard thus already pairs a construction definition with
derived quality criteria.

Sentence-level normative language has two established conventions. IETF BCP 14
(RFC 2119, Bradner 1997; RFC 8174, Leiba 2017; datatracker.ietf.org) defines
MUST/SHOULD/MAY keyword families, restricts normative force to ALL-CAPS
(8174), requires an opt-in boilerplate, and rules that imperatives be used
sparingly and never to mandate implementation method. ISO/IEC Directives Part 2
(9th ed., 2021) binds one modal verb per provision type (shall=requirement,
should=recommendation, may=permission, can=possibility; "must" reserved for
external constraints), requires that requirements be objectively verifiable or
not stated as requirements, bans subjective qualifiers, and mandates an
explicit normative/informative split.

Decision records are a distinct, established artifact kind: the Nygard ADR
(cognitect.com blog, 15 Nov 2011) — Title/Context/Decision/Status/Consequences,
value-neutral context, active-voice "We will…", consequences including
negatives, append-only numbering, supersede-never-rewrite, 1–2 pages; MADR
v4.0.0 (adr.github.io/madr, September 2024) — Markdown Architectural Decision
Records (corrected: v4.0.0 reverted the v3-era "Any Decision Records"
expansion) — adds Considered Options, Decision Drivers, an optional
Confirmation section stating how compliance will be verified, and YAML front
matter; and Y-statements (Zdun, Capilla, Tran, Zimmermann, "Sustainable
Architectural Design Decisions", IEEE Software 30(6), 2013,
doi:10.1109/MS.2013.97) — a one-sentence template whose clauses name the
rejected alternatives (canonically "neglected") and the accepted downside.

Principle fitness criteria exist in the literature: Rumelt (Good Strategy Bad
Strategy, Crown Business, 2011) — a guiding policy "directs and constrains
action without fully defining it"; bad-strategy hallmarks fluff and
goals-mistaken-for-strategy; Spool ("Creating Great Design Principles: 6
Counter-intuitive Tests", UIE, March 2011; articles.centercentre.com) —
evidence-derived, helps-you-say-no, distinguishes-from-competitors,
reversible-in-context, per-project revalidated, meaning-calibrated-on-real-work;
Lencioni ("Make Your Values Mean Something", HBR 80(7), July 2002) — core vs
aspirational vs permission-to-play vs accidental values. Trade-off grammars:
the Agile Manifesto value pairs with the right-side-still-has-value qualifier
(agilemanifesto.org, 2001) and even/over statements — good-vs-good pairs with
declared priority (Dignan, Brave New Work, Portfolio/Penguin, 2019; Kamer,
"Even/Over Statements", The Ready on Medium, 2021). Operated exemplars: the
W3C TAG Web Platform Design Principles (w3ctag.github.io/design-principles;
living note, updated June 2026) — imperative titles with parenthetical stable
names, prose, worked examples, applied in actual spec reviews — and the GOV.UK
Government Design Principles (gov.uk, 2012, updated April 2025; now 11
principles), an amend-in-place principle set with public revision history.

### 1.5 Content-quality guideline and rubric formats

Educational assessment supplies the descriptor-rubric family: Brookhart (How
to Create and Use Rubrics, ASCD, 2013) — criteria about the quality of the
work, crossed with 3–5 prose performance-level descriptors of observable
features (not evaluative adjectives); analytic (per-criterion judgment) vs
holistic (single judgment) variants. The AAC&U VALUE rubrics (aacu.org/value/
rubrics; 15 rubrics developed 2007–2009, a 16th added 2013 — corrected) are a
fully worked, operated artifact set: Definition + Framing Language + Glossary preamble,
then a criteria-by-levels matrix with named ordered levels Capstone /
Milestones / Benchmark, with an explicit localization instruction. The
single-point rubric (Fluckiger, Delta Kappa Gamma Bulletin 76(4), 2010)
authors only the proficient-standard column, with blank flanking columns for
observed shortfalls and excesses.

Binary gates: the Scrum DoD (2020 Scrum Guide) — one uniform itemized quality
contract with a consequence rule; acceptance criteria in scenario-oriented
Given/When/Then form (Gherkin; cucumber.io/docs/gherkin; Adzic, Specification
by Example, Manning, 2011) or rule-oriented list form; and checklist design
constraints from Gawande (The Checklist Manifesto, Metropolitan Books, 2009)
and the Gawande/Boorman "Checklist for Checklists" (projectcheck.org):
DO-CONFIRM vs READ-DO typing, named pause points, 5–9 killer items, ~60–90
second budget, field validation. Fagan inspections (IBM Systems Journal 15(3),
1976; Brykczynski's checklist survey, ACM SIGSOFT SEN 24(1), 1999) derive and
continuously re-derive checklist items from observed defect data.

Quality taxonomies: ISO/IEC 25010:2023 (SQuaRE product quality model) — nine
characteristics decomposed into defined sub-characteristics, deliberately a
vocabulary separated from measures (2502n) and requirements (25030).

Style-guide governance: the Google developer documentation style guide
(developers.google.com/style, public since September 2017) and the Microsoft
Writing Style Guide (learn.microsoft.com/style-guide, 2018–present) converge on
one anatomy — voice principles, a condensed highlights/top-10 layer, topical
rule pages with before/after examples, an A–Z word list, and an explicit
precedence hierarchy (project sheet → this guide → named fallbacks). The Vale
prose linter (vale.sh; LWN, "Vale: enforcing style guidelines for text", 2024)
mechanizes such guides: each YAML rule carries a check pattern, a severity
tier, and a link back to the guideline it enforces, packaged per style guide
with per-project overrides — checks derived from definitions, running in the
wild.

Two architectural devices recur: Deming's operational definition (Out of the
Crisis, MIT Press, 1986, ch. 9) — a quality adjective has "no communicable
meaning" until expressed as sampling/test procedure + criterion + yes/no
decision rule; and WCAG 2.2's conformance architecture (W3C Recommendation, 5
Oct 2023) — principles → guidelines → 86 individually testable success criteria
(A:31, AA:24, AAA:31; corrected — 4.1.1 Parsing was removed as obsolete, so the
commonly repeated 87/A:32 count is wrong), with a strict normative/informative
split: criteria bind, Understanding and Techniques documents inform. Google's
code-review guidance (google.github.io/eng-practices) is a two-layer review
rubric: one senior decision principle (approve once the change "definitely
improves the overall code health," even if imperfect) plus an enumerated aspect
list, with authority routing (style → style guide/linter; design → principles).
The Federal Plain Language Guidelines (PLAIN, 2011, pursuant to the Plain
Writing Act of 2010, Pub. L. 111-274; originally plainlanguage.gov/guidelines,
now hosted at digital.gov/guides/plain-language — corrected URL) contribute the
imperative one-behavior-per-rule granularity with before/after example pairs.

### 1.6 Quality-management lineage: document control, improvement loops, derivation trees

This is the one surveyed tradition whose core artifact is the controlled
definition itself. ISO 9001:2015 clause 7.5 (Quality management systems —
Requirements; iso.org/standard/62085.html — current edition, confirmed 2021,
revision in progress; clause detail cross-verified via the official ISO/TC
176/SC2/N1286 guidance, iso.org/iso/documented_information.pdf, the standard
text itself being paywalled) is the established requirements regime for
controlled documents. The 2015 edition merged "documents" and "records" into
one concept, documented information, with two verbs carrying the old
distinction: maintain (keep current — definitional documents) vs retain (keep
as evidence — records). Clause 7.5.1 scopes the regime two ways — information
the standard requires plus whatever the organization determines necessary,
extent proportional to organization size, process complexity, and competence.
7.5.2 requires on creation and update: identification and description (title,
date, author, reference number), format and media, and review and approval
for suitability and adequacy. 7.5.3 requires that information be available
and suitable for use where and when needed and adequately protected, with
control activities as applicable: distribution, access (view-only vs
view-and-change), retrieval and use, storage and preservation including
legibility, control of changes (version control named explicitly), retention
and disposition; documented information of external origin is identified and
controlled, and information retained as evidence of conformity is protected
from unintended alteration. (The 2008 edition's explicit
prevent-unintended-use-of-obsolete-documents provision, 4.2.3(g), survives in
2015 only by implication of availability plus change control — corrected: an
earlier pass read it as explicit 2015 text.) Beneath it, ISO 9000:2015
(Fundamentals and vocabulary, 4th ed., September 2015;
iso.org/standard/45481.html) supplies the term system: document =
"information and the medium on which it is contained" (3.8.5); documented
information (3.8.6); record = "document stating results achieved or providing
evidence of activities performed" (3.8.10); conformity = fulfilment of a
requirement; objective evidence as the admissibility condition; and the
verification/validation split — confirmation via objective evidence that
specified requirements are fulfilled vs that requirements for a specific
intended use are fulfilled. ISO 10013:2021 (Guidance for documented
information, 1st ed., March 2021; iso.org/standard/75736.html) is the
non-binding how-to companion, updated for digitized documentation and
automated workflow; the traditional documentation-hierarchy pyramid (policy →
procedure → work instruction → form/record) belongs to its predecessor
ISO/TR 10013:2001 — the 2021 foreword states "the original hierarchy of
documentation is no longer used but left open for the user" (corrected: an
earlier pass attributed the pyramid to the 2021 edition).

The improvement-loop lineage is documented end-to-end in Moen, "Foundation
and History of the PDSA Cycle" (Associates in Process Improvement;
deming.org/wp-content/uploads/2020/06/PDSA_History_Ron_Moen.pdf; retrieved in
full for this report). Shewhart (Statistical Method from the Viewpoint of
Quality Control, The Graduate School, USDA, 1939, p. 45; edited by Deming) is
the original statement that specification precedes production precedes
inspection, and that the line closes into a loop: "These three steps must go
in a circle instead of in a straight line... specification, production, and
inspection correspond respectively to making a hypothesis, carrying out an
experiment, and testing the hypothesis." Deming's 1950 JUSE wheel (design
with tests → make → sell → test in service through market research →
redesign) was recast by Japanese executives as Plan–Do–Check–Act (Imai,
Kaizen, Random House, 1986, p. 60; Ishikawa, What Is Total Quality Control?
The Japanese Way, Prentice-Hall, 1985, pp. 56–61 — Plan subdivided into goals
plus methods, Do into training plus implementation). PDCA's terminal phase is
a document-control action: Act is "back to plan if the results are
unsatisfactory, or standardization if the results are satisfactory"; the form
"emphasized the prevention of error recurrence by establishing standards and
the ongoing modification of those standards" (Moen), with Ishikawa adding
that standards are revised continuously from consumer voices and next-process
requirements; in Japanese practice loop turns are documented in the QC-story
format (Lillrank & Kano 1989, per Moen). Deming himself held his cycle apart
from PDCA ("They bear no relation to each other", GAO roundtable 1980; "be
sure to call it PDSA, not the corruption PDCA", letter to Moen, 17 November
1990): PDSA (Out of the Crisis, MIT Press, 1986, p. 88; The New Economics,
MIT Press, 1993, p. 135) plans a change with a stated prediction and its
theory (Moen, Nolan, Provost, Improving Quality Through Planned
Experimentation, McGraw-Hill, 1991, p. 11), runs it — small-scale, per the
1993 cycle figure — Studies observed results against the prediction (not
"Check", which Deming read as "hold back"), and then adopts, abandons, or
re-runs under changed conditions. The Model for Improvement (Langley, Nolan,
Nolan, "The Foundation of Improvement", Quality Progress, June 1994, p. 81;
Langley et al., The Improvement Guide, 2nd ed., Jossey-Bass, 2009, p. 24)
frames every cycle with three questions, the second — "How will we know that
a change is an improvement?" — an explicit check-derivation question. Moen's
division of labor: PDCA for implementation and compliance; PDSA for testing
and learning.

Six Sigma contributes the qualitative-to-checkable derivation tree and the
phase-gated improvement process. The CTQ (critical-to-quality) tree — CTQs
being, in paraphrase of the ASQ Quality Glossary entry, the key measurable
characteristics of a product or process whose performance standards must be
met to satisfy the customer (asq.org/quality-resources/quality-glossary;
handbook treatment in Kubiak & Benbow, The Certified Six Sigma Black Belt
Handbook, 3rd ed., ASQ Quality Press, 2016; GE-lineage practice in Pande,
Neuman & Cavanagh, The Six Sigma Way, McGraw-Hill, 2000; matrix ancestor
Hauser & Clausing, "The House of Quality", HBR 66(3), May–June 1988, pp.
63–73; no single primary inventor source for the tree itself surfaced in
this pass's search of the ASQ materials and handbook literature cited here) —
derives in three fixed levels: a need stated in the customer's qualitative
language; the drivers by which the customer will judge the need met; and
per-driver measurable performance requirements, each with a specification
limit or target. Leaves must be measurable or the derivation is unfinished;
every leaf traces up through a driver to a stated need; and coverage is
testable in both directions (a need with no leaves is unmeasured, a leaf with
no need is unauthorized). DMAIC (ASQ, asq.org/quality-resources/dmaic; Kubiak
& Benbow 2016, organized to the DMAIC-structured ASQ Body of Knowledge)
specifies five phases by their exit deliverables: Define (charter, voice of
customer and CTQs, process map), Measure (baseline, operational definitions
of the measures, measurement-system validation — before any judgment of the
process), Analyze (root causes verified with data), Improve (solutions
validated against the baseline), Control (control plan, process standardized
into controlled documentation, monitoring installed, ownership transferred).
Phase boundaries carry tollgate reviews — phase deliverables reviewed by an
authority seat distinct from the performing team (sponsor/champion/Master
Black Belt) before the next phase is authorized; the tollgate form appears
in the Six Sigma practice literature (e.g., the cited handbook) rather than
on the cited ASQ page. The Control-phase termination rule converges with PDCA's Act: in this
lineage, improvement work terminates in a document-control action on a
governed surface.

### 1.7 Qualitative fitness-test formats for LLM output

The research base: Zheng et al., "Judging LLM-as-a-Judge with MT-Bench and
Chatbot Arena" (NeurIPS 2023; arXiv:2306.05685) established LLM-judge viability
(>80% agreement with humans) and named position, verbosity, and
self-enhancement bias, with mitigations (position swap, reference-guided
grading, chain-of-thought). Zheng et al., "Cheating Automatic LLM Benchmarks"
(ICLR 2025 oral; arXiv:2410.07137) proved judges are adversarially gameable: a
constant null-model response reached 86.5% LC win rate on AlpacaEval 2.0.
G-Eval (Liu et al., EMNLP 2023; arXiv:2303.16634) canonized the derivation
procedure criteria → evaluation steps → judged score (Spearman 0.514 on
summarization). EvalGen (Shankar et al., UIST 2024; arXiv:2404.12272)
established criteria drift: humans discover criteria by grading outputs, so
criteria sets cannot be fully specified a priori and need an iterative
human-calibration loop. CheckList (Ribeiro et al., ACL 2020 Best Paper;
arXiv:2005.04118) is the pre-LLM precedent for small targeted behavioral
probes (MFT/INV/DIR types over a capability matrix).

Production tooling converges on scenario + plain-language criteria + LLM judge:
promptfoo (promptfoo.dev) — declarative YAML tests with vars and llm-rubric
assertions co-resident with deterministic checks, plus a scenarios construct;
DeepEval GEval (deepeval.com) — criteria/evaluation_steps in Python; Ragas
(docs.ragas.io) — score-anchored rubrics (a written description per score
level) and binary Aspect Critique; LangSmith/OpenEvals (docs.langchain.com;
langchain-ai/openevals) — judge factories with binary-preferred, exemplar-
anchored authoring guidance; Braintrust autoevals
(github.com/braintrustdata/autoevals) — constrained choice→score classification;
OpenAI evals (github.com/openai/evals; hosted platform deprecated: read-only
Oct 2026, shutdown Nov 2026) — the ancestral JSONL+YAML model-graded registry.
Anthropic's guidance ("Define success criteria / build evaluations", platform
docs; "Demystifying evals for AI agents", engineering blog, Jan 2026)
prescribes a grader hierarchy (code-based → LLM → human calibration), one
isolated judge per quality dimension, constrained outputs with anchored scales,
and frequent human calibration. LangWatch Scenario (github.com/langwatch/
scenario) is the closest living relative of the shop's proposal: named
scenarios with a situation description, a criteria list of plain-language
expectations, and a Judge Agent returning verdict + reasoning, CI-runnable.

The BDD×LLM literature runs the opposite direction from the shop's proposal —
LLMs generating or assessing Gherkin (arXiv:2403.14965; arXiv:2508.20744;
arXiv:2607.01980; arXiv:2512.01232, "LLM-as-a-Judge for Scalable Test Coverage
Evaluation"). No established named standard was found for authoring Gherkin as
fitness specifications judged (not executed) by an LLM — a negative claim
grounded in this research pass's search scope: arXiv (BDD × LLM ×
judge/evaluation queries), the Cucumber/SmartBear Gherkin documentation, and
the documentation of each eval framework surveyed above; the pattern exists
only as the near-neighbors listed. See section 3.

### 1.8 Compiled-context and skill governance

Anthropic Agent Skills (platform.claude.com/docs — "Skill authoring best
practices"; anthropic.com/engineering — "Equipping agents for the real world",
Oct 2025): a skill is a directory with SKILL.md (YAML frontmatter + body) under
three-tier progressive disclosure — name+description (max 64 chars / 1,024
chars, description stating both what and when) always in context; body (<500
lines) on trigger; references (one level deep) on demand. Authoring rules
include degrees-of-freedom calibration (high/medium/low), evaluation-first
development ("Create evaluations BEFORE writing extensive documentation") with
an eval structure of {skills, query, files, expected_behavior[]} and a
three-scenario minimum, and a pre-share checklist. Claude Code memory
(code.claude.com/docs/en/memory) layers managed-policy > user > project > local
CLAUDE.md files (broadest-first, nearest read last), @imports to depth four,
path-scoped .claude/rules with glob frontmatter, a <200-line budget, a content
discriminator (standing facts stay; multi-step or localized procedure moves to
a skill or path-scoped rule), a verifiable-specificity rule, and the boundary
that CLAUDE.md is context while hard constraints belong in hooks/settings. The
subagent format (section 1.2) supplies the role container.

Adjacent conventions: AGENTS.md (agents.md) — a schema-less well-known file
with nested nearest-wins precedence; Cursor rules (cursor.com/docs/context/
rules) — .mdc files whose frontmatter field combinations encode four activation
modes (Always / Intelligently / Specific Files / Manual), <500-line budget,
org-level Team Rules precedence; llms.txt (Howard, Answer.AI, Sept 2024;
llmstxt.org) — a fixed-grammar curated index (H1, summary, annotated H2 link
lists, an explicit Optional degradation tier); MCP prompts and resources
(modelcontextprotocol.io, spec 2025-06-18) — the user-/application-/model-
controlled taxonomy and the audience/priority/lastModified annotation
vocabulary; Langfuse prompt version control (langfuse.com/docs) — immutable
version IDs plus mutable deployment labels, protected promotion, diffs;
promptfoo declarative eval configs (promptfoo.dev/docs/intro) — versioned
prompts × providers × tests with mixed deterministic and model-graded
assertions gating CI; Prompty (section 1.3) — a schema-validated asset with
declared I/O and sample data; and Anthropic's context-engineering principles
(anthropic.com/engineering/effective-context-engineering-for-ai-agents) — the
smallest high-signal token set, right-altitude prompts, named sections,
just-in-time retrieval, sub-agents returning condensed 1,000–2,000-token
summaries.

---

## 2. Recommendations

Each recommendation names adopt / adapt (with deltas) / bespoke (with
justification), sketches the concrete in-system shape, and cites sources.
Nothing here is decided.

**2.1 Process definitions — adopt ISO/IEC/IEEE 24774 header + ETVX activity
cells; adapt 330xx derivation and Essence/CMMN termination vocabulary.**
Each shop process definition: a noun-phrase name, one-sentence purpose, and
3–8 observable outcomes per 24774:2021 clause 5.3, phrased in the 15288/12207
outcome style ("An X is produced/defined"); each activity inside it an ETVX
cell — entry criteria (the trigger side of "resulting actions"), tasks,
validation conditions, exit criteria (Radice et al. 1985). ETVX is preferred
among the classic activity frames surveyed precisely because it is the one
that builds validation into the definition cell itself. Long-running loops
terminate by definition-level state, not step count: exit criteria expressed as
reached states with short checklists (Essence 1.2 alpha-state form; CMMN's
"milestone with entry criteria" and "exit criterion on a stage" as citable
vocabulary — the clearest standards vocabulary surveyed for unpredictable
knowledge-work termination, but vocabulary only, not the notation). Checks
derive per the 330xx pattern: outcomes → assessment indicators → rubric items,
with traceability but without capability levels, maturity staging, or assessor
machinery (delta). Six Sigma's CTQ tree (§1.6) is adapted as the second
external anchor for the same derivation: need → driver → measurable
requirement, with the leaf-admissibility rule (a leaf is measurable — which is
Deming's operational definition, 2.5(a) — or the derivation is unfinished) and
both coverage tests (an outcome with no derived check is unmeasured; a check
tracing to no outcome is unauthorized), recorded as a small per-kind
need→driver→check table without sigma targets or statistical capability
apparatus (delta).
CMMI's required/expected/informative trichotomy separates what must be true
(checkable) from typical ways to do it (guidance) inside each definition.
BPMN/IDEF0/PMBOK ITTO are not adopted; a descriptive-class diagram may
occasionally illustrate a handoff, rendered in mermaid.

**2.2 Role definitions — adopt the Claude Code subagent container; adapt Scrum
accountability lists and the SPEM content/process split as its discipline.**
Concretely: role = .claude/agents file where the frontmatter is the routing and
capability contract (description as delegation trigger; tools allowlist derived
from the role's do-not list; skills preload list as the declared role→activity
binding, making the compiled surface enumerable and diffable; maxTurns as a
standard termination bound) and the body is the standing identity written as a
Scrum-style accountability list (4–8 answerable-for bullets, 2020 Scrum Guide)
plus RUP-style required competencies (Kruchten 2003). The SPEM 2.0 separation
is the governing rule: roles and skills are Method Content; no ordering or
lifecycle text lives in a role definition. RUP's one-responsible-role-per-
artifact rule binds each artifact kind to exactly one accountable role.

RACI (§1.2) — adapt, as an assignment overlay, not a role-definition
container. The A column is already decided: RUP's one-responsible-role-per-
artifact rule is a standing one-Accountable-per-row constraint over artifact
kinds, so a shop RACI's Accountable assignments must reproduce the existing
artifact→role bindings (a consistency check, not a new decision); what the
matrix genuinely adds is the C/I dimension — who is Consulted on a scope
clarify, who is Informed of a work_done — which today lives only implicitly
in the clarify-routing and Monitor-event rules. Two conditions keep it clear
of the documented failure modes (§1.2): every letter carries a Deming-style
operational definition, and the matrix is derived into role frontmatter and
primers rather than kept as a standalone page (shelfware is the documented
death of RACI charts; a matrix that compiles into agent context cannot rot
unread). RACI-VSL's Verifier is the one variant letter worth carrying: a
per-artifact-kind Verifier column names the seat that runs the derived
checks, keeping judge separate from generator as section 3's Goodharting
mitigations already require. All of this bears directly on the pending
PO-vs-Architect contract investigation (bead lead-jozud.2): rows = artifact
kinds and decision points (brief, PDR, scenario set, dispatch, clarify
response, reconciliation), columns = lead-po, lead-architect, router, BC —
and where the question is decision rights rather than task involvement,
RAPID/DACI vocabulary (a single Decider per decision; Driver vs Approver —
the router drives classification and dispatch to conclusion, the product
authority alone approves) is the cleaner frame (§1.2). From Holacracy (§1.2),
two elements fold into the role container itself rather than the matrix:
Domains as the formal name for exclusive artifact bindings (stating "this
role exclusively controls features/ scenarios" inside the role definition
makes the one-A property structural rather than matrix-side), and the
tension-grounded amendment protocol as an established form for changing role
definitions under change control (converging with TOGAF's
stable-but-amendable, 2.4); Medium's documented exit is the standing caution
against over-codification in a system that compiles role text into context —
Holacracy's own all-parts-optional minimalism plus the existing 200-line
primer budget (2.7) are the counterweights.

**2.3 Artifact/document-type schemas — adopt the 15289 two-level scheme; adapt
with Scrum commitments and Prompty-style validated frontmatter.**
Concretely: a small set of shop generic types (description, plan, record,
request, specification — pruned from 15289:2019's seven), each with generic
content requirements; each named kind (brief, PDR, ADR, session record…) with
specific required-content clauses, exactly the shape the existing write-*
kind-schema mechanism already has — 15289 is the external anchor, not a
migration. Deltas: (a) every artifact kind carries one commitment — a small
DoD-style qualitative criteria set with a stated consequence on failure (2020
Scrum Guide artifact-commitment pairing; RUP checkpoints as the derived review
checklist precedent); (b) frontmatter is schema-validated and declares expected
inputs/outputs plus at least one worked sample (Prompty), and carries
audience/priority/lastModified-style inclusion metadata (MCP resources
annotation vocabulary); (c) 15289-style mapping tables tie each process
definition's outcomes to the artifact kinds it produces. Neither DITA nor
Diátaxis (§1.3) displaces 15289 as the content anchor; each adds a dimension
it lacks. DITA specialization is adapted as the second external anchor for
deriving new kinds: every artifact kind declares its base generic type and
ancestry in frontmatter (the @class analogue), so a validator that knows only
the generic types can still check any future kind at the generic level —
DITA's generic-fallback rule, which is what keeps the kind set safely
open-ended; and tightening an existing kind is a constraint-module-style
operation, a distinct and cheaper governance action than minting a new kind.
From Diátaxis: each kind-schema declares which user-need quadrant the kind
serves, and the one-type-per-document discipline becomes a lintable fitness
check — a mixed-quadrant document fails its kind (the write-* guides are
how-to-shaped while the schemas they enforce are reference-shaped; the
vocabulary keeps the two separated). DITA's XML machinery and Diátaxis's four
documentation types themselves are not adopted; docs-as-code (§1.3) is
adopted trivially as the name of the substrate the shop already runs —
Markdown in git, reviewed, schema-validated in CI — on which every mechanical
check in this report becomes enforceable.

**2.4 Principles — adopt the TOGAF four-part template and BCP 14 keywords;
adapt ISO Directives rules; keep decisions in ADRs, separate.**
Concretely: each principle is Name / Statement / Rationale / Implications
(TOGAF), the Name rendered as an imperative title with a parenthetical stable
handle for citation in reviews (W3C TAG form); even/over grammar (Dignan 2019;
The Ready) is an approved Statement form for priority-call principles, with the
Agile Manifesto's right-side-still-has-value qualifier attached. All definition
kinds — not just principles — adopt BCP 14 (RFC 2119/8174) keyword discipline
with the boilerplate, which is directly lintable; from ISO/IEC Directives Part
2 adopt three rules only (delta: not the ISO document skeleton): one modal per
provision type, requirements must be verifiable or be demoted, explicit
normative/informative tagging. Decisions stay a distinct kind: the shop already
writes Nygard-form ADRs; MADR v4.0.0's Confirmation section and Decision
Drivers, and the Y-statement one-liner (Zdun et al. 2013) as a required summary
field, are the named deltas worth folding in. Principles are standing and
amended under change control (TOGAF Stable); ADRs are immutable and superseded
(Nygard). The principle fitness-test set is assembled — not invented — from
TOGAF's five criteria, Spool's tests 2/3/4, Rumelt's fluff and goal-vs-policy
anti-patterns, and Lencioni's permission-to-play/aspirational screen; this
composition is the only quasi-bespoke element, justified as assembly of
published criteria.

**2.5 Content-quality guidelines and rubrics — adopt Deming's meta-rule,
single-point rubrics, DoD gates, Gawande constraints, the Google two-layer
review form, and the style-guide + Vale enforcement anatomy.**
Concretely: (a) Deming's three elements (test procedure, criterion, yes/no
decision — Out of the Crisis ch. 9) are the acceptance test applied to every
definition the seed layer produces; an unoperationalized adjective is not yet a
check. CTQ's leaf-admissibility rule (§1.6) is the same meta-rule in Six Sigma
form — a derivation is unfinished until its leaves are measurable — and ISO
9000:2015's verification/validation split (§1.6) names the two check families
this layer produces: derived mechanical checks verify against stated
requirements; judged fitness tests (2.6) validate against intended use —
naming the distinction prevents category errors in check design. (b) Per-artifact-kind fitness sets take single-point rubric form
(Fluckiger 2010) — the proficient-standard column IS the construction
definition, reusable verbatim in generator context and reviewer rubric; where a
graded verdict is wanted, an analytic rubric with written per-level anchors
(Brookhart 2013; Ragas score-anchored form; AAC&U Benchmark→Capstone ladder for
draft/ship/exemplary bars, WCAG's cumulative levels as the same device). (c)
Completion contracts take DoD form with a consequence rule (2020 Scrum Guide).
(d) All derived checklists obey Gawande/Boorman constraints — typed DO-CONFIRM
or READ-DO, anchored to named pause points, 5–9 killer items — and their items
are added/retired from observed defects (Fagan/Brykczynski). (e) Review rubrics
take Google's two-layer form: one senior decision principle ("definitely
improves artifact health") + a per-kind aspect list regenerated from the
construction definition, with authority routing so linter-owned rules leave the
rubric. (f) Guideline documents adopt the Google/Microsoft anatomy — voice
principles, condensed highlights (the compiled-into-context layer), topical
rules with before/after pairs (Plain Language Guidelines form), word list,
explicit precedence hierarchy — with mechanical checks packaged Vale-style:
each rule = pattern + severity + link back to its defining guideline. WCAG's
normative/informative split governs the whole layer: criteria bind; intent
docs and techniques inform (WCAG 2.2).

**2.6 Qualitative fitness tests — adapt: Gherkin authoring surface over the
established scenario+criteria+judge pattern (see section 3 for the verdict).**
Concretely: small sets (3–10 cases) per generated-output kind, each case Given
(context) / When (activity) / Then (one falsifiable observable property per
clause), compiled 1:1 into an established judge format — promptfoo llm-rubric
assertions or G-Eval criteria+evaluation_steps — and executed under Anthropic's
grader hierarchy (code checks first, LLM judge only for what code cannot check,
human calibration sampled per EvalGen). Judge conventions: one dimension per
judgment, constrained verdicts with anchored meanings (autoevals choice_scores;
Ragas anchors), reasoning before verdict, judge model and prompt version pinned
(Zheng 2023; arXiv:2410.07137). CheckList's capability×test-type matrix is the
ideation device when deriving cases from a construction definition. The
required calibration loop is an established form, not an invention: it is a
PDSA cycle (§1.6) — a fitness-set or judge-prompt revision records a
prediction (which verdicts will change, and why) before deployment, and its
Study step compares sampled product-authority grading against that prediction
(Moen/Nolan/Provost 1991; EvalGen's iterative human-calibration loop is this
cycle unnamed).

**2.7 Compiled-context and skill governance — adopt Agent Skills + Claude Code
memory discipline; adapt the Cursor activation taxonomy, llms.txt index, and
Langfuse promotion algebra.**
Concretely: one activity per skill in SKILL.md form with the authoring rules
and evaluation-first loop (Anthropic best practices; the {skills, query, files,
expected_behavior[]} eval structure is the fitness-set container, run via a
promptfoo-style colocated config, since Anthropic provides no built-in runner
for these evaluations — the authoring doc states "There is not currently a
built-in way to run these evaluations. Users can create their own evaluation
system" (Skill authoring best practices, platform.claude.com/docs, confirmed
2026-08-06)); role primers
under the 200-line budget with the standing-facts-vs-procedure discriminator
and verifiable-specificity rule (Claude Code memory docs); the context-vs-
enforcement boundary maps onto definitions-vs-mechanical-checks. Deltas from
neighbors: every compiled-context artifact declares its activation mode
(always / model-judged / path-conditional / manual — Cursor's taxonomy as
vocabulary, not .mdc files); catalog surfaces take llms.txt shape (name,
one-line summary, annotated links, explicit Optional tier); canonical-template
promotion is a gated act distinct from authoring, and each shop/BC records
which definition versions it runs (Langfuse's immutable-version/mutable-label
algebra, realized in git + the shopsystem-templates pipeline, not a registry
product). AGENTS.md's schema-less model is explicitly rejected for anything
checks derive from — nothing mechanical can be derived from a file with no
required structure (agents.md). Anthropic's context-engineering principles
(smallest high-signal token set; right altitude; named sections; condensed
subagent summaries) are adopted as citable principle statements from which
these format choices derive. The governance regime itself now has an external
anchor: ISO 9001:2015 clause 7.5 (§1.6) maps one-to-one onto this layer — the
definition corpus is documented information determined necessary; ratification
is review-and-approval for suitability and adequacy; the compiled-context
assembly guarantee is the available-at-point-of-use rule, and the
stale-compiled-prompt hazard is the obsolete-document hazard; canonical
templates from shopsystem-templates are documents of external origin under
control; and the maintain/retain verb pair names the split 2.4 already draws
(principles maintained under change control; ADRs and session records
retained as evidence, protected from unintended alteration). Clause 7.5 is
adapted as a derivable audit rubric for the governance layer — the
requirements checklist and the maintain/retain distinction, not the
certification machinery, with git supplying the mechanics ISO leaves to
procedure; audit traceability (which definition version was in force when an
artifact was produced) restates the version-pinning requirement of 2.6.
PDCA's Act-as-standardization (§1.6) supplies the closure rule the promotion
algebra needs: a finding from any check or reconciliation is closed only when
the governed surface is revised and re-promoted, or explicitly sent back to
plan — improvement terminates in a document-control action, the rule DMAIC's
Control phase states independently.

**Bespoke residue.** No container format needs inventing. The bespoke elements
are: the shop-native content of the schemas (which outcomes, states, and fields
each kind carries), the composed principle-fitness rubric (2.4), and the
Gherkin surface for fitness tests (section 3) — each justified above or below.

---

## 3. The Gherkin-fitness proposal

The proposal (product authority, re-founding dialogue; recorded in
sessions/sess-2026-08-05-b.md): express qualitative fitness tests for
non-deterministic LLM-generated output as Given/When/Then Gherkin scenarios,
explicitly not backed by executable step definitions — evaluated by an LLM
reviewer — with a small set per output type.

**Prior art.** The exact combination — Gherkin syntax judged by an LLM instead
of bound to step definitions — has no established named standard; the BDD×LLM
literature runs the other direction, LLMs generating or rubric-assessing
Gherkin (arXiv:2403.14965; arXiv:2508.20744; arXiv:2607.01980;
arXiv:2512.01232). The underlying semantics, however, are firmly established:
LangWatch Scenario ships scenario-shaped tests whose assertions are
plain-language criteria evaluated by a Judge Agent (github.com/langwatch/
scenario); promptfoo's scenarios + llm-rubric YAML is structurally isomorphic
(vars = Given/When, rubric assertion = Then; promptfoo.dev); G-Eval canonizes
criteria → evaluation steps → judged score (arXiv:2303.16634). The proposal is
therefore a thin syntax adaptation of orthodox practice, not a new evaluation
paradigm — which is what satisfies the bespoke-requires-justification bar, the
justification being literacy reuse: Gherkin is already this shop's
behavior-contract vocabulary (features/ tree, scenario hashes,
assign_scenarios), and the literature confirms G/W/T is LLM-friendly structure
(arXiv:2403.14965).

**Strengths.** (1) One authoring literacy across behavior contracts and fitness
tests — the PO writes both. (2) G/W/T forces context (Given) and activity
(When) to be explicit, which judge prompts need anyway (G-Eval
evaluation_params; promptfoo vars). (3) One-clause-one-property aligns with
Anthropic's one-isolated-judge-per-dimension rule. (4) "Small set" is the
established norm, not a compromise: CheckList MFTs are small targeted probes
(arXiv:2005.04118), and EvalGen shows criteria sets grow from observed
failures rather than upfront enumeration (arXiv:2404.12272).

**Failure modes and mitigations.**
- Unfalsifiable Then-clauses ("Then the brief is compelling") — the judge will
  pass vibes. Mitigation: an authoring rule that every Then names an observable
  property whose violation a reviewer could point at (Deming's test/criterion/
  decision discipline), phrased binary or score-anchored (Ragas; autoevals
  choice_scores).
- Judge gameability and Goodharting — proven by the null-model result
  (arXiv:2410.07137) and the bias catalog (arXiv:2306.05685); acute here
  because generator and judge are LLMs in one system with retry loops.
  Mitigation: keep judge rubrics out of the generator's context where feasible;
  delimit the evaluated artifact as untrusted data; different model family or
  at least separated context for judging; reasoning-before-verdict; human
  spot-audits; never judge-pass-rate as the sole gate for high-stakes
  artifacts.
- Executable-culture confusion — every established Gherkin ecosystem assumes
  step definitions exist (cucumber.io), so judged features will eventually be
  fed to a runner or "fixed" by an agent that binds steps. Mitigation: hard
  segregation (a distinct tree such as fitness/, never features/; a mandatory
  tag such as @judged; a header comment stating evaluation semantics) plus a
  schema-level marker in the artifact-kind definition.
- Criteria drift — criteria cannot be fully specified a priori
  (arXiv:2404.12272). Mitigation: fitness sets are versioned living artifacts
  with a standing calibration loop of sampled product-authority grading, not
  immutable specs.
- Silent judge variance. Mitigation: pin judge model and prompt-template
  version alongside the feature file.

**Alternatives doing the same job.** Adopt promptfoo YAML directly (established
format and runner; loses the Gherkin literacy); LangWatch Scenario criteria
lists (established, agent-oriented; heavier multi-turn machinery than artifact
fitness needs); plain per-kind rubric documents in G-Eval criteria+steps form
(simplest; loses the scenario framing that binds a test to a concrete
situation).

**Verdict: ADAPT — evidence-based.** The pattern beneath the proposal is
orthodox, shipping practice; the Gherkin surface is a justified bespoke twist.
It works under these conditions: (a) every Then-clause passes the
falsifiability rule; (b) judged features are hard-segregated and marked,
schema-level, as non-executable; (c) each Then compiles mechanically 1:1 to a
rubric assertion in an established judge format, so the judged semantics rest
on established tooling rather than a bespoke runner; (d) judges are
bias-hardened and pinned; (e) a human calibration loop with sampled grading
exists and feeds revisions. Absent (a)–(c) in particular, the proposal degrades
into vibes-with-keywords and should not proceed.

---

## 4. Open questions for the authority

1. Normative-language style: ratify 2.4's recommended BCP 14 ALL-CAPS keyword
   discipline, or override it with ISO shall/should — one must be chosen and
   enforced; both are established, they cannot be mixed (RFC 8174; ISO/IEC
   Directives Part 2).
2. Decision-record house form: stay pure Nygard (current practice), or move to
   MADR v4.0.0 for its Confirmation section and machine-parseable front matter?
3. Shop-native state vocabulary: which Essence-style alphas/states name the
   shop's trackable concerns (Intent, Scenario Set, Dispatch, Reconciliation…)?
   This is product vocabulary the research cannot settle.
4. Verdict granularity per artifact kind: binary DoD-style gates, or graded
   Benchmark→Capstone / WCAG-level ladders (draft vs ship vs exemplary) — and
   for which kinds?
5. Compilation target commitment for judged fitness tests: promptfoo as the
   established runner, or an in-house minimal judge harness that consumes the
   same compiled form? (Tool coupling vs bespoke-runner risk.)
6. How much 330xx-style traceability ceremony to carry: explicit
   outcome→indicator→rubric tables per process, or by-convention linking only?
   (The CTQ need→driver→check table, §1.6/2.1, is the candidate concrete
   form if tables are chosen.)
7. Calibration governance: who grades sampled judge verdicts, at what cadence,
   and where is the calibration record kept (per EvalGen the loop is
   non-optional; its ownership is a judgment call)? PDSA (§1.6, 2.6) supplies
   the phase form — prediction before deployment, Study against sampled
   grading — leaving only ownership and cadence to decide.
8. Scope of the principle set: target size (order of ten per GOV.UK/TOGAF
   guidance) and whether shop principles are one set or split
   canonical-vs-shop-local along the existing .claude/canonical vs .claude/shop
   line.
