---
type: research-report
id: product-designer-role-2026-08
status: delivered
version: 6
date: 2026-08-25
question: "Research a product designer role, which is a gap in this system: the user experience has been left to the PO, architect and the authority, and no role makes it consistent; the product has been CLI-focused but the system must handle the full range of user interaction types."
requested-by: product-authority
created: 2026-08-25
updated: 2026-08-25
---

# Research report: the product designer role and consistency across every interaction type

## Executive summary

*How to read the labels.* Each finding carries a confidence: **high** —
several sources opened in full agree, at least one primary (the
standard, framework, or author itself); **medium** — one opened source,
or secondary accounts only (including a paywalled primary carried by an
opened secondary); **low** — recall without a source, or a primary
that could not be read — the one case is ISO 9241-210, the ISO
human-centred design standard, whose principles here come from an
opened and checked secondary; the authority may raise that label, the
report does not. "Several" means two or more. "Secondhand" marks a quote taken from a
secondary account because the primary was unreachable. Confidence is
about the evidence; where a finding predicts an outcome, its likelihood
is stated in its own phrase.

*How the sources' vocabulary maps to the shop.* Cagan's four risks are
value, usability, feasibility, and business viability; his "Product
Lead Engineer" (who owns feasibility) is `lead-solutions-architect`;
Bob Baxley is Cagan's co-author on the 2025 SVPG essay; `researcher` is
the shop's research role, defined in the six-section role form —
posture; decision rights; admissible evidence; interfaces; knowledge
and skills; anti-rationalization; "the team" and "engineers" are
the Bounded Context shops (the shops that each own one Bounded Context,
a designed region of the product); an *interaction type* is one way a
person or an agent reaches the product — command line (CLI), full-screen
terminal (TUI), graphical or web (GUI), API and SDK, conversational
(chat), voice, and generated documents or notifications; a *design
system* is a governed set of reusable patterns, components, and rules
with a named owner; a *scenario* is an acceptance scenario held by a
Bounded Context shop's scenario register; a *clarify* is a shop's typed
question back to the lead shop. Abbreviations: NN/g — Nielsen Norman
Group; SFIA — the Skills Framework for the Information Age, whose level
5 is "ensure, advise"; WCAG — the W3C Web Content Accessibility
Guidelines, WCAG2ICT its non-web application; AIP — Google's API
Improvement Proposals; RACI — the responsibility matrix in which exactly
one party is Accountable; HAX — Microsoft's Human-AI Experience toolkit,
whose 18 Guidelines for Human-AI Interaction are meant throughout;
Grice's Cooperative Principle and "Grice's maxims" name the same
linguistic standard; a *definition chain* is the shop's set of linked
definitions of good for one artifact type (typedef, guideline, fitness
set, process, roles, skill); *external consistency* is NN/g's term for
following the conventions of the platform an interface lives on;
*local-comprehension* and *knowable-shape* are two of the shop's
architecture principles (a part is understandable on its own; the
product's shape is knowable from its contracts).

1. **The gap is real and has a name: design by committee.** The shop's
   present state — experience decided jointly by PO, architect, and
   authority, no single owner — matches ProductPlan's definition:
   "Design by committee is what happens when multiple parties are
   involved in the product design process, and all of their input is
   treated equally." Every opened model that names the PM's peers gives usability its own owner: Cagan's
   four risks ("The Product Designer is responsible for the usability
   risk, and overall accountable for the product's experience — every
   interaction our users and customers have with our product"), Torres's
   product trio (PM, designer, engineer — "the three roles that — at a
   minimum — are required"). The remedy both design-by-committee sources
   (Dovetail; ProductPlan) give is one decision-maker deciding on
   evidence. *(High.)*
2. **The role's scope is medium-neutral by definition, so CLI, API, and
   agent interfaces are inside it.** UX "encompasses all aspects of the
   end-user's interaction" (Norman & Nielsen); interaction design is "the
   conversation between the user and the system" (Cagan & Baxley 2025);
   SFIA's user-experience analysis skill (UNAN) covers "a full range of
   user tasks not just digital tasks". The CLI guidance corpus (clig.dev, Heroku, GitHub's
   Primer CLI) is design guidance in its own right — GitHub files its CLI
   design under its design system. *(High.)*
3. **What carries consistency across interaction types is not a
   component library — it is a small set of governed instruments:**
   design principles as decision rules (NN/g, GOV.UK's "consistent, not
   uniform"), one vocabulary and voice (Primer "Make it feel like GitHub";
   NN/g tone dimensions; the GOV.UK style guide), one core task set that
   every interaction type supports (NN/g omnichannel; Google's
   conversation design; Alexa "voice-first, but not voice-only"), an
   accessibility standard as a cross-cutting constraint (WCAG 2.2 AA;
   WCAG2ICT guidance for non-web), and per-interaction-type conventions honoured
   as external consistency (NN/g usability heuristic 4, "consistency and standards"; clig.dev "the terminal's
   conventions are hardwired into our fingers"). The governed corpora among the
   examples use the same form: criteria + a review body + an
   approval state (GOV.UK contribution criteria; Google AIP editors;
   Azure's stewardship board). *(High.)*
4. **Conversational and agent interfaces have an established external
   check and a real paradigm difference.** Microsoft's 18 Guidelines for
   Human-AI Interaction are modality-independent; Google's conversation
   design rests on Grice's Cooperative Principle; Nielsen classes CLI and
   GUI together as command-based (his "command-based interactions"
   cover both) and conversational/agent as intent-based
   with "reversed locus of control" — the report reads his
   command-based class as covering both command lines and graphical
   interfaces — and expects "a hybrid user interface". The designer's
   consistency task therefore spans two paradigms, and for generated
   interfaces the designer's output becomes guidance rather than screens
   ("Humans will need to provide guidance and constraints for
   generative UI"). *(High for the guidance; medium for the paradigm claim and
   Nielsen's expectation of hybrid interfaces — one author.)*
5. **The agent is also a user.** NN/g: "'user' is no longer synonymous
   with 'human'"; Anthropic: invest in the agent-computer interface "just
   as much effort" as HCI. Accessibility structure (semantic names,
   predictable patterns) and tool/API definitions are the agent's
   interface — so API/SDK ergonomics and agent tool contracts sit in the
   designer's consistency remit, with the architect owning the contract
   itself. *(High — two primary sources opened in full agree; both are
   recent, so the practice they describe is young.)*
6. **The contested boundary with the PM is known and must be allocated
   explicitly.** NN/g's 2021 survey: PMs and UX disagree most on who owns
   discovery research (19% of PMs vs 73% of UX say UX), ideation,
   information architecture, task flows, the research agenda, and who
   explains design to leadership. The recorded failure modes: PMs
   "dictate design by sending wireframes to product designers and asking
   them to polish them"; the designer as decorator (Marvel: "Designers Solve Problems, They
   Don't Push Pixels");
   hand-off leaving the designer to find requirement gaps. *(High.)*
7. **The proposal for `lead-product-designer`** — composed from findings
   1–6, a proposal not a finding, so no confidence label; written to the
   six-section role form used by `researcher` and
   `lead-solutions-architect` — posture; decision rights (decides,
   recommends, escalates, never decides); admissible evidence;
   interfaces; knowledge and skills; anti-rationalization. *Posture:* one experience across every
   interaction type; evidence from users, never opinion; consistent, not
   uniform. *Decides (exclusive domain):* the experience guidance corpus
   — design principles, vocabulary and voice, the rule that every interaction type supports the same core tasks,
   interaction patterns per interaction type, the accessibility target —
   and whether a delivered interaction conforms to it. *Decides:* which
   interaction type a capability is offered through first — an
   experience call, since the PM has already decided the capability is
   worth having and the question left is how people reach it; the
   information architecture and task flows of every interaction type;
   what user research is run and how usability is evaluated. *Recommends:*
   to the PM, opportunities and usability findings that change value
   judgments; to the PO, acceptance scenarios' usability criteria and
   the scenarios that a usability test invalidates; to the architect, the
   ergonomics of contracts, CLIs, and agent tool definitions.
   *Escalates:* to the authority, a principle the experience corpus cannot
   satisfy alongside the architecture principles, and any conflict where
   value (PM) and usability pull apart after re-framing. *Never decides:*
   what problem is worth solving (PM), acceptance (PO), the stack and
   contracts (architect), how a Bounded Context builds a behavior (the
   shop). *Admissible evidence:* user tests and trials, prototypes tested
   with users, expert review against the corpus, context-of-use analysis,
   measured task completion; not admissible — a stakeholder's preference,
   a PM-supplied wireframe as a requirement, the designer's own taste
   unrecorded. *Interfaces:* PM — framed problems and outcomes in;
   usability findings, prototypes, and opportunity evidence out, in
   discovery not after it; PO — scenarios in for usability criteria;
   usability acceptance criteria and test results out; architect —
   contract, CLI, and tool ergonomics reviewed against the corpus;
   feasibility and non-functional constraints in; Bounded Context shops —
   the corpus and its patterns out; conformance findings back; a
   `clarify` on experience questions answered. *Knowledge and skills:* SFIA 9 UNAN (user experience analysis), HCEV (user experience design), USEV (user experience evaluation), URCH (user research) at level 5 ("ensure, advise"); the ISO 9241-210 activities (context of use, user requirements, design solutions, evaluation — secondhand); the HAX guidelines for any agent-facing interaction; WCAG 2.2 AA and WCAG2ICT; clig.dev and Heroku conventions for CLI; Grice's maxims for conversation; the shop's architecture principles (local-comprehension, knowable-shape) as they bear on interfaces.
   *Anti-rationalization:* "It's a CLI, developers don't need design" — clig.dev and GitHub say otherwise. "Consistency later" — GOV.UK's contribution criteria gate at publication. "The PM already sketched it" — NN/g's named failure mode. "An agent doesn't care" — NN/g and Anthropic say the agent is a user. "It looks fine to me" — the designer's own preference is not admissible evidence.
   *Name:* "product designer" follows the three sources the proposal
   adopts (Cagan; Torres; Cagan & Baxley); SFIA names skills, not
   roles, and its skill names say "user experience"; NN/g's page on
   the distinction was unreadable — see 8(c).
8. **Three decisions the sources leave to the authority** — decisions
   carry no confidence label. (a) Whether the
   experience guidance corpus is a new definition type or a principle
   set plus guidelines in the existing chain form — the governance
   examples fit the existing form. (b) whether usability accountability is single — Cagan and RACI, as
   the proposal has it — or joint across the trio, as Torres has it
   ("The trio is jointly responsible for building a desirable, viable,
   feasible, usable, ethical product"); the proposal keeps joint
   discovery either way. (c) Whether the
   role is named `lead-product-designer` or `lead-ux-designer`: the
   sources the proposal adopts say "product designer"; the one source
   on the naming question was unopened.

## Method

Three parallel gather workers in fresh contexts covered: the role's
definition and interfaces (Cagan/SVPG six essays, Torres two, NN/g
seven, SFIA 9 four skills, practitioner sources on failure modes);
consistency mechanisms and CLI/API design (NN/g five, GOV.UK four,
Atlassian three, W3C two, clig.dev, Heroku, 12-factor CLI via mirror,
GitHub Primer CLI via repository source, Docker, Google AIP, Azure
guidelines, Stripe two, Textual — a terminal-UI framework's theming guide, the only
TUI design document found); conversational and agent interfaces
(Google conversation design three pages, Microsoft HAX, NN/g five,
Apple WWDC transcript, Alexa two, Google's People + AI Research (PAIR) guidebook two chapters, Shneiderman, Anthropic,
OpenAI). About 55 sources opened in full; unreadable: ISO 9241-210
(paywalled — principles from a secondary), Material Design 3
(JavaScript-rendered), NN/g "UX vs product designer", Apple HIG Siri
page (substituted by Apple's own WWDC20 transcript), Amershi et al. full
paper (abstract and Microsoft's library used), GOV.UK working-group page
(410; Home Office analogue opened). Evidence extracted quotes-first;
synthesis; an independent fresh-context verification pass followed.

## Findings

### F1 — The gap and its name *(high)*

- Cagan, "The Four Big Risks" (svpg.com/four-big-risks): "The Product
  Designer is responsible for the usability risk, and overall accountable
  for the product's experience – every interaction our users and
  customers have with our product." PM: "value and viability risks";
  engineer: "feasibility risk".
- Torres, "Core Concept: The Product Trio" (producttalk.org): "A product
  trio is typically comprised of a product manager, a designer, and a
  software engineer. These are the three roles that—at a minimum—are
  required to create good digital products."
- Torres, "Product Trios" (2024): "The trio is jointly responsible for
  building a desirable, viable, feasible, usable, ethical product."
- ProductPlan, "How to Avoid Design by Committee": "Design by committee
  is what happens when multiple parties are involved in the product
  design process, and all of their input is treated equally."
- Dovetail, "Design By Committee": "a group of designers, stakeholders,
  and clients working on the same project and sharing equally valid
  opinions"; "In product design, it usually produces low-quality
  results"; "you should only have one decision-maker". Riddle and
  Treder (UXPin), quoted by ProductPlan: "Committee design is not
  collaborative. It's a dictatorship of many".
- NN/g RACI (Kaley 2022): "For each task, there should be only one
  accountable person."
- Cagan 2006, on the absence: "Sometimes the product managers waded into
  the design waters and did what they could."

### F2 — Scope is medium-neutral *(high)*

- Norman & Nielsen, "The Definition of User Experience": "'User
  experience' encompasses all aspects of the end-user's interaction with
  the company, its services, and its products"; UX ⊃ UI ⊃ usability
  ("usability... is a quality attribute of the UI").
- Cagan & Baxley 2025: "The product designer is fundamentally responsible
  for the user experience of the product. The scope of that
  responsibility encompasses the full suite of interactions, touchpoints,
  and visual representations — both online and offline";
  "Interaction design is the practice of creating and choreographing the
  conversation between the user and the system."
- SFIA 9 UNAN: "This skill is inclusive of a full range of user tasks not
  just digital tasks."
- clig.dev: "If a command is going to be used primarily by humans, it
  should be designed for humans first"; "The original Macintosh Human
  Interface Guidelines recommend 'See-and-point (instead of
  remember-and-type)'... These things needn't be mutually exclusive."
- Heroku CLI style guide: "The primary goal of anyone developing CLI
  plugins should always be usability."
- GitHub Primer CLI (repository primer/cli, archived 2024, now under
  primer.style/design): "Command line interfaces are not as visually
  intuitive as graphical interfaces. They have very few affordances...
  We do our best to design our commands to mitigate this."
- Stripe (Bu 2020): "Keeping things simple means making sure your APIs
  are consistent and predictable"; "creating the right packages to
  gradually reveal the power of your API as your users need it."

### F3 — What carries consistency, and how it is governed *(high)*

- NN/g, Design Principles (Rosala): "Product design principles are value
  statements that describe the most important goals that a product or
  service should deliver for users and are used to frame design
  decisions."; "These principles support consistency in the way
  decisions are being made across teams, build confidence in the
  decision, and eliminate fruitless debates."; "Be careful that your
  principles don't conflict."
- GOV.UK Design Principles #9: "Be consistent, not uniform... We should
  use the same language and the same design patterns wherever possible.
  This isn't a straitjacket or a rule book." #7: "We're not designing for
  a screen, we're designing for people."
- NN/g heuristic 4: "Systems should adhere to both internal and external
  consistency — they should use the same patterns everywhere inside the
  system and should also follow web-, platform-, and domain-specific
  conventions." clig.dev: "The terminal's conventions are hardwired into
  our fingers... that's what makes CLIs intuitive and guessable".
- Primer CLI, "Make it feel like GitHub": "Using this tool, it should be
  obvious that it's GitHub and not anything else... reflect the
  GitHub.com interface as much as possible and appropriate"; "Language
  is the most important tool at our disposal for creating a clear,
  understandable product."
- NN/g tone of voice: "Keep your brand personality consistent, but vary
  the tone"; "used when creating writing and other communications for
  all channels."
- NN/g omnichannel: "Your channel experiences should at minimum support
  these core tasks on every channel"; "it's vital... to understand when
  it's okay to compromise consistency in order to provide an
  appropriately optimized experience on each channel."
- Atlassian: "Design tokens are the single source of truth to name and
  store decisions about the user interface."
- W3C: WCAG 2.2 "is an approved... ISO standard: ISO/IEC 40500:2025";
  "can also be applied to non-web information and communications
  technologies"; WCAG2ICT "is not a standard, so it is not possible to
  conform to WCAG2ICT".
- Governance form — GOV.UK contribution criteria: "tested in user
  research and shown to work with a representative sample of users,
  including those with disabilities"; "it has a clear owner". Google
  AIP-1: "Two AIP approvers (other than the author) must provide formal
  signoff"; AIPs "are used by API reviewers as a basis for review
  comments." Azure guidelines: "If you feel you need an exception,
  contact the Azure HTTP/REST Stewardship Board prior to
  implementation." NN/g Design Systems 101: "A design system is only as
  effective as the team that manages it."

### F4 — Conversational and agent interfaces *(high for guidance; medium for the paradigm claim)*

- Google conversation design (the pages carry a notice that
  "Conversational Actions were deprecated on June 13, 2023"; the design
  guidance outlives the retired product): "a breadth of design expertise (for
  example, voice user interface design, interaction design, visual
  design, motion design, and UX writing) that we've refined into a
  single discipline"; rests on "Grice's Maxims"; cross-modality rule:
  start with the spoken prompt, "condense it to create the display
  prompt", "they should still convey the same core message".
- Alexa: "A great Alexa experience is voice-first, but not voice-only";
  "Each touch (or remote) target on screen should have a voice command
  analog".
- Microsoft HAX, 18 guidelines (e.g. G1 "Make clear what the system can
  do", G9 "Support efficient correction", G11 "Make clear why the system
  did what it did", G17 "Provide global controls"); Amershi et al., CHI
  2019, DOI 10.1145/3290605.3300233 (abstract only).
- Nielsen, "AI: First New UI Paradigm in 60 Years": "In command-based
  interactions, the user issues commands to the computer one at a
  time"; generative AI "completely reverses the locus of control";
  "Future AI systems will likely have a hybrid user interface".
- NN/g, Generative UI: "Humans will need to provide guidance and
  constraints for generative UI."; "We must guide the generative UIs, even if we
  aren't making minute decisions about individual components."
- PAIR: "your users will definitely need a manual failsafe"; AI adds
  "context errors" and "background errors". Shneiderman: "high levels of
  human control AND high levels of automation."

### F5 — The agent as a user *(high)*

- NN/g, "AI Agents as Users": "'user' is no longer synonymous with
  'human.'"; "Accessibility guidelines achieve this design goal: clear,
  descriptive element names, predictable interaction patterns".
- Anthropic, "Building effective agents": "plan to invest just as much
  effort in creating good agent-computer interfaces (ACI)" as HCI; "Tool
  definitions and specifications should be given just as much prompt
  engineering attention as your overall prompts."

### F6 — The PM boundary and failure modes *(high)*

- NN/g, Pernice & Budiu 2021: discovery research — 19% of PMs vs 73% of
  UX say UX owns it; IA — "75% of the UXers" say UX, "50% of product
  managers" say development; deciding what UX researches — "a clear
  example of appropriation".
- NN/g, PM archetype 2023: PMs "might try to dictate design by sending
  wireframes to product designers and asking them to polish them".
- Balsamiq (a wireframing vendor) dissents: "product managers can and
  should wireframe" — vendor interest noted; it still proposes a
  "Wireframes Contract" under which the PM does not dictate final design.
- Marvel (Veen quoted): "Good design isn't [decoration]. Good design is
  problem solving."
- Torres 2024: "A product manager hands off requirements to a designer.
  The designer uncovers gaps in the requirements."
- Cagan 2016: designers participate "in all phases of a product, from
  discovery to delivery"; "Good product designers use prototypes as
  their primary canvas"; "constantly testing their ideas with real
  users".
- SFIA 9 level 5 (lead level): UNAN "Determines the approaches to be
  used for user experience analysis"; USEV "Manages user experience
  evaluation... Advises on what to evaluate"; HCEV "Plans and drives user
  experience design activities."

## Alternatives considered

- **Give usability to `lead-pm`.** Cagan's own PM definition excludes
  it; NN/g's survey shows the appropriation this produces. Rejected.
- **Give it to `lead-po` as acceptance criteria.** Acceptance is a
  check, not a definition of good; the check would sit with the same
  role that wrote the criteria. Rejected under `define-good-up-front`.
- **A per-interaction-type designer (CLI designer, conversation
  designer).** Google folded VUI/IxD/visual/writing "into a single
  discipline"; the consistency instruments are cross-type. Rejected;
  interaction-type conventions become sections of the corpus.
- **A design system as a component library first.** No opened source
  claims a component library spans CLI/GUI/API; the sources put
  principles, vocabulary, and governance first. Deferred.
- **Torres's joint accountability for usability.** Compatible in
  discovery; RACI and Cagan still require one accountable. The proposal
  keeps joint discovery and single accountability.

## Limitations

- ISO 9241-210 was not opened (paywalled); its principles are from an
  opened secondary and carry medium confidence under the scheme.
- No authoritative TUI design guideline exists; TUI guidance would be
  derived from clig.dev, WCAG2ICT, and keyboard-first GUI patterns.
- The empirical base for failure modes is practitioner writing and one
  NN/g survey; no controlled study was found.
- "Design theater" as a named failure mode has no primary source and is
  not used.
- The paradigm-shift claim (F4) rests on one author; that his
  command-based class covers both CLI and GUI is the report's reading of
  his article, not a quoted sentence.
- Residual at the cold-read cap (round 3): the reader's findings were
  presentation — untraceable summary quotes, unexpanded terms, a
  scheme departing from the frame; repairs were applied in this version
  without a further cold read.
- What would change the judgment: a source showing a single component
  library successfully spanning CLI, GUI, and API; evidence that
  designer-owned corpora slow small teams more than committee decisions
  cost them.

## Sources

Opened in full unless marked. SVPG: four-big-risks; the-product-designer-role; product-design-and-ai; product-management-vs-product-design (2006); titles-roles-and-responsibilities (2005); product-management-theater. Product Talk: 2021/05/product-trio; product-trios. NN/g: definition-user-experience; ux-career-advice; design-operations-101; designops-roles-partnerships; pm-ux-different-views-of-responsibilities; ux-roles-responsibilities; product-manager-archetype; design-systems-101; consistency-and-standards; design-principles; seamless-cross-channel; tone-of-voice-dimensions; ai-paradigm; generative-ui; definition-ai-agent; ai-agents-as-users; omnichannel-consistency; ux-vs-product-designer (UNOPENED, 403). SFIA 9: user-experience-analysis; user-experience-design; user-experience-evaluation; user-research. ISO 9241-210 (UNOPENED; principles via createchfinland.fi). Balsamiq should-product-managers-wireframe; ProductPlan how-to-avoid-design-by-committee; Dovetail design-by-committee; Marvel designers-solve-problems-dont-push-pixels. GOV.UK: government-design-principles; design-system contribution-criteria; community; designnotes.blog 2023/05/31; Home Office working group; working-group page (UNOPENED, 410). Atlassian: foundations; accessibility; about. Material Design 3 (UNOPENED). W3C: WAI WCAG overview; TR/wcag2ict-22. clig.dev; Heroku cli-style-guide; 12-factor CLI (Medium 403; mirror panlw.github.io); primer/cli repository (.mdx sources); Docker CLI reference; google.aip.dev/1; microsoft/api-guidelines azure/Guidelines.md; stripe.dev payment-api-design; stripe.com api-versioning; textual.textualize.io guide/design. Google conversation-design: welcome; learn-about-conversation; scale-your-design. Microsoft HAX guideline library; Amershi et al. 2019 (abstract only; ACM 403). Apple WWDC20 session 10071 transcript (HIG Siri UNOPENED). Alexa: get-started; be-multimodal. PAIR: feedback-controls; errors-failing. Shneiderman HCIL page; arXiv 2002.04087 (abstract). Anthropic building-effective-agents; OpenAI a-practical-guide-to-building-agents (PDF).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-25 | update | Draft synthesized from three gather workers' notes. |
| 1 | 2026-08-25 | review | Verification round 1: findings — eight wording and attribution repairs, no retractions. |
| 2 | 2026-08-25 | update | Round-1 repairs applied: four quotes restored to the source's wording, one attribution corrected, F5 relabeled high under the scheme, SFIA claim narrowed to UNAN, Google deprecation noted. |
| 2 | 2026-08-25 | review | Verification round 2: clean — all round-1 repairs confirmed at source; five further spot-checks verbatim. |
| 3 | 2026-08-25 | update | Finalized as the report; cold read opened. |
| 3 | 2026-08-25 | review | Cold read round 1: findings — summary quotes not traceable to the body, the proposal's last two sections in two homes, acronyms unexpanded. |
| 4 | 2026-08-25 | update | Cold-read repairs: ProductPlan definition and Torres's trio-accountability quote added to F1 (both already in the verified evidence); abbreviations expanded in the vocabulary note; the proposal's knowledge and anti-rationalization sections kept in one home; scheme made reproducible for paywalled primaries. |
| 4 | 2026-08-25 | review | Cold read round 2: findings — proposal split across summary and body, role name unargued, scheme silently departing from the frame. |
| 5 | 2026-08-25 | update | Cold-read repairs: the whole proposal now in item 7 and the body section removed; naming added as decision 8(c); scheme departure from the frame stated; four risks, Baxley, researcher, chain, external consistency, and two architecture principles introduced; hybrids moved to the medium clause. |
| 5 | 2026-08-25 | review | Cold read round 3 (cap): findings — summary quotes not carried by the body, terms unexpanded, scheme departing from the frame. |
| 6 | 2026-08-25 | update | Delivered at the cold-read cap: quotes made traceable from the verified evidence, frame's scheme restored, terms expanded, decision 8 restated as three decisions; residual disclosed in Limitations. |
