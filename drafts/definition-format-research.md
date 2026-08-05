# Definition-format research: established forms for the quality-layer seed

**Status: SITTING MATERIAL — not ratified, decides nothing.** This document
describes established external forms and recommends candidates; every decision
in it belongs to the product authority. Date: 2026-08-05. Produced by the
definition-format research directed in the re-founding dialogue (the
construction-definitions-precede-checks re-founding of the quality layer).

Conventions: every claim carries a citation to a verified source. Where the
research corpus contained a described inaccuracy, the corrected fact is used
here and marked "(corrected)".

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
IBM Systems Journal 24(2), 1985, pp. 79–90) is the lightest classic
per-activity frame: Entry criteria, Task set, Validation conditions, eXit
criteria per activity cell, composable by chaining, with no ordering engine.
(Corrected: the original expansion is Validation, not Verification; both
renderings circulate in CMM-lineage secondary literature. A free scan exists at
bitsavers.org despite the IBM Systems Journal paywall.) It is the only classic
form that builds verification into the definition cell itself.

OMG Essence 1.2 (SEMAT; OMG formal/18-10-02, 2018; Essence 2.0 in beta with
formal publication scheduled March 2026; omg.org/spec/Essence/1.2) defines
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
items, the standards world's clearest vocabulary for unpredictable
knowledge-work; IDEF0 (NIST FIPS PUB 183, 1993, withdrawn as a federal
standard in 2008; IEEE 1320.1-1998; ISO/IEC/IEEE 31320-1:2012) with its
Input/Control/Output/Mechanism arrow typing; and PMBOK 6th ed. ITTOs (PMI,
2017), which the PMBOK 7th ed. (2021) itself dropped from the core. ISO/IEC
24744:2014 (SEMDM) models method-level and endeavor-level views of one concept
via powertypes; its uptake is essentially academic.

### 1.2 Role definition formats

OMG SPEM 2.0 (formal/2008-04-01, April 2008; omg.org/spec/SPEM/2.0) draws a
hard structural line between Method Content — reusable Role Definitions
(skills, responsibilities), Task Definitions, Work Product Definitions, typed
Guidance including checklists — and Process, which arranges content occurrences
into lifecycles. A full knowledge base of role/task/artifact definitions can be
maintained without ever creating a process. Eclipse EPF Composer
(projects.eclipse.org/projects/technology.epf; archived, last release 2018) is
the working proof: method plugins publish role/task/work-product/guidance pages
as a browsable static site, no engine. RUP (Kruchten, The Rational Unified
Process: An Introduction, 3rd ed., Addison-Wesley, 2003, ch. 3) is the
ancestor form: roles carry responsibilities plus required competencies, and
every artifact has exactly one responsible role.

The Scrum Guide (Schwaber & Sutherland, November 2020, scrumguides.org) defines
roles as short accountability lists — 4–8 bullets of what the holder is
answerable for, not task scripts.

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

### 1.4 Principle statement formats

TOGAF (The Open Group, TOGAF 9.2, "Architecture Principles" chapter, carried
into the 10th Edition ADM Techniques volume; pubs.opengroup.org) is the only
broadly adopted formal template specifically for principles: Name / Statement
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
rubrics; 15 rubrics developed 2007–2009, a 16th added 2013 — corrected) are the
mature exemplar artifact: Definition + Framing Language + Glossary preamble,
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

### 1.6 Qualitative fitness-test formats for LLM output

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
Evaluation"). No established named standard exists for authoring Gherkin as
fitness specifications judged (not executed) by an LLM; the pattern exists only
as the near-neighbors above. See section 3.

### 1.7 Compiled-context and skill governance

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
validation conditions, exit criteria (Radice et al. 1985). Long-running loops
terminate by definition-level state, not step count: exit criteria expressed as
reached states with short checklists (Essence 1.2 alpha-state form; CMMN's
"milestone with entry criteria" and "exit criterion on a stage" as citable
vocabulary — vocabulary only, not the notation). Checks derive per the 330xx
pattern: outcomes → assessment indicators → rubric items, with traceability but
without capability levels, maturity staging, or assessor machinery (delta).
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
definition's outcomes to the artifact kinds it produces.

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
check. (b) Per-artifact-kind fitness sets take single-point rubric form
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
ideation device when deriving cases from a construction definition.

**2.7 Compiled-context and skill governance — adopt Agent Skills + Claude Code
memory discipline; adapt the Cursor activation taxonomy, llms.txt index, and
Langfuse promotion algebra.**
Concretely: one activity per skill in SKILL.md form with the authoring rules
and evaluation-first loop (Anthropic best practices; the {skills, query, files,
expected_behavior[]} eval structure is the fitness-set container, run via a
promptfoo-style colocated config since Anthropic ships no runner); role primers
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
these format choices derive.

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

1. Normative-language style: BCP 14 ALL-CAPS keywords or ISO shall/should —
   one must be chosen and enforced; both are established, they cannot be mixed
   (RFC 8174; ISO/IEC Directives Part 2).
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
7. Calibration governance: who grades sampled judge verdicts, at what cadence,
   and where is the calibration record kept (per EvalGen the loop is
   non-optional; its ownership is a judgment call)?
8. Scope of the principle set: target size (order of ten per GOV.UK/TOGAF
   guidance) and whether shop principles are one set or split
   canonical-vs-shop-local along the existing .claude/canonical vs .claude/shop
   line.
