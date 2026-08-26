---
type: principle-set
id: experience-principles
scope: experience
owner: product-authority
status: draft
version: 2
created: 2026-08-26
updated: 2026-08-26
derives-from:
  agent-is-a-user: actor-neutral-discipline
---

# Experience principles

## What this set governs

This is the experience-scope principle set: the standing rules for how
the product's interactions are designed, whichever interaction type a
person or an agent reaches the product by — command line, terminal,
graphical or web, API and SDK, conversational, voice, or a generated
document. It is a peer of the working-scope set,
[Founding principles](principles.md), which governs how every activity
is performed, and of the architecture-scope set,
[Architecture principles](architecture-principles.md), which governs
what the designed system must look like; this set governs what a person
or an agent meets when they use it. It is the first layer of the
experience guidance corpus the
[product designer role](roles/lead-product-designer.md) owns; the
guidelines that apply it to each interaction type sit beneath it.
Backticked slugs cite principles; a slug not defined in this document is
defined in the working or architecture set. The terms interaction type,
experience guidance corpus, generated interface, BC-shop, contract, and
intent are defined in the [glossary](glossary.md). Two words carry one
sense each here: an *agent* is a software caller using the product on
someone's behalf; an *assistant interaction* is one in which the
product itself acts on an intent the person stated rather than on a
command — conversational, voice, or an assistant acting for the person
(a closed set; the solutions architect role is the lead shop's
architecture role). Where a principle here applies another set's
principle at the experience level, the frontmatter declares the lineage
in `derives-from` instead of restating the rule as a second authority.

## What a good principle looks like

This section restates the shared definition from the
[principle-set typedef](artifacts/principle-set.md) so this document can
be read alone; the restatement is a rendering, not a second authority.

A principle is a standing rule, in four parts: a name, a statement, a
rationale, and implications.

- The **statement** is the rule. It carries the only normative keywords
  (MUST, SHOULD, MAY — interpreted per BCP 14 when, and only when, they
  appear in capitals) and is testable: shown a piece of work, you can
  answer yes or no. A statement carrying more than one obligation
  presents one obligation per bullet.
- The **rationale** says why the rule earns its place: the failure it
  prevents, shown as a generic example; well-known external references
  may support it, the product's own history never appears. Rationales
  stay prose.
- The **implications** are the price tag: one implication per bullet,
  the concrete change each named actor absorbs to honor the rule. They
  add no obligations — every implication must be derivable from the
  statement.

A good principle passes the tests applied in the fitness screen at the
end: its statement is testable (TOGAF's understandable, complete,
consistent); it helps you say no (Jared Spool, "Creating Great Design
Principles"); it is not fluff and not a goal in disguise (Richard
Rumelt, *Good Strategy/Bad Strategy*); it is not permission-to-play —
something every competent product already does (Patrick Lencioni, "Make
Your Values Mean Something"); and it implies at least one practice and
at least one check.

## The principles

### Consistent, not uniform (`consistent-not-uniform`)

**Statement.**
- Every interaction type MUST name the product's things and actions with
  the product's one vocabulary, as the experience guidance corpus
  records it.
- Every interaction type MUST follow, for its form and idiom, the
  platform interface guidelines the corpus names for that type.
- Where a platform guideline names an action differently from the
  vocabulary, the platform's word MUST be used in that interaction
  type and the mapping recorded in the vocabulary.
- A rule of the corpus MAY be varied for one interaction type only
  with the variation and its reason recorded in the corpus.

**Rationale.** A product reached through a command line, a web page,
and a chat window is three products when each names the same object
differently, and a foreign one when its command line ignores the
terminal's conventions to imitate its web page. People carry their
expectations from the platform they are on — Nielsen Norman Group's
usability heuristic "consistency and standards" and Jakob's law of
internet user experience — and from the last place they met the
product. The GOV.UK design principles put it as "be consistent, not
uniform": the same language and patterns wherever possible, without a
straitjacket. Words and rules are shared; form follows the platform.

**Implications.**
- The product designer role maintains the vocabulary, its per-platform
  mappings, and the named platform guidelines per interaction type in
  the corpus.
- The product designer role screens every interaction type's text
  against the vocabulary.
- BC-shops building an interaction cite the platform guideline the
  corpus names for its type.
- The product designer role records each variation with its reason; an
  unrecorded variation is a finding against the corpus.

### Core-task parity (`core-task-parity`)

**Statement.**
- Every interaction type the product offers MUST support every task on
  the corpus's core-task list.
- An option the product offers in one interaction type MUST be
  reachable in every other interaction type that presents the same
  task.

**Rationale.** A voice assistant that can start an order but only a
screen can confirm it strands the person who has no screen; a chat
interface that offers three choices only one of which the graphical
interface shows teaches people that the product hides things. Google's
conversation design guidelines and Amazon's Alexa design guide converge
on the rule: voice-first but not voice-only, every option offered in
one modality reachable in the other, the core message the same across
them. Parity of tasks and options is what lets a person move between
interaction types without relearning what the product can do.

**Implications.**
- The product designer role keeps the core-task list in the corpus.
- The product designer role screens each new interaction type against
  the list before delivery.
- BC-shops that add an option to one interaction type add it to every
  other type presenting that task.
- The PO role's acceptance scenarios for a task name the interaction
  types it must hold on.

### The agent is a user (`agent-is-a-user`)

**Statement.**
- Every interface an agent uses to reach the product — a tool
  definition, a command line, an API, or an SDK (a closed set) — MUST
  be designed as an interface: named for its caller, its behavior
  stated in its documentation, and screened by the product designer
  role.
- An agent-facing interface MUST NOT expose a capability a person could
  not reach through some interaction type.

**Rationale.** A tool whose parameters are named for the implementer
rather than the caller is misread by the agent calling it, and the
agent's failure is recorded as the agent's. Nielsen Norman Group's "AI
Agents as Users" states the shift plainly — "user" is no longer
synonymous with "human" — and Anthropic's guidance on building agents
asks for as much care in the agent-computer interface as in the human
one. This principle is `actor-neutral-discipline` applied at the
interface: the discipline of design does not lapse because the user is
an agent, and an agent gains no capability a person lacks. An interface
no one designed is still an interface; it is only an undesigned one.

**Implications.**
- The solutions architect role submits contracts, command lines, and
  tool definitions to the product designer role's screen before they
  are published.
- BC-shops write tool and API documentation for the caller, with the
  same care as user-facing help.
- The product designer role screens agent-facing interfaces against
  the corpus with the same patterns as human-facing ones.

### Evidence, not opinion (`evidence-not-opinion`)

**Statement.**
- A claim that an interaction is usable MUST rest on observed use — a
  user test, a tested prototype, or measured task completion (a closed
  set the corpus may extend) — or be labeled a hypothesis.
- A preference — a stakeholder's, a maker's, the designer's own — MUST
  NOT decide a design question that observed use can answer; what the
  product is for is the PM role's decision, not a design question.

**Rationale.** Design by committee, where every opinion in the room
weighs the same, produces the least-common-denominator interface; the
alternative is not one taste in charge but one decision-maker deciding
on evidence. Human-centred design as ISO 9241-210 describes it is
driven and refined by user-centred evaluation; GOV.UK's third design
principle is "design with data." Nielsen Norman Group's "The
Product-Manager Archetype" names the failure the second bullet
prevents: a sketch handed over as a requirement, with the designer
asked to polish it instead of to test it.

**Implications.**
- The product designer role records the evidence behind each design
  decision in the corpus, and labels the rest hypotheses.
- The PM role treats a wireframe or sketch from any role as input to be
  tested, never as a requirement.
- BC-shops label an untested interaction's usability a hypothesis when
  they deliver it.

### Accessible by standard (`accessible-by-standard`)

**Statement.**
- Every graphical, web, and document interaction MUST meet WCAG 2.2 at
  level AA.
- Every non-web interaction — command line, terminal, voice, and
  assistant interactions (a closed set; APIs and SDKs are agent-facing
  and governed by `agent-is-a-user`) — MUST apply the WCAG 2.2
  success criteria as WCAG2ICT describes for non-web software, with a
  record of which criteria do not apply and why.
- Accessibility conformance MUST be established before an interaction
  is delivered.

**Rationale.** An interface that conveys meaning by color alone, or a
terminal screen that a screen reader cannot follow, excludes the people
who depend on assistive technology and, increasingly, the agents that
read the same structure. The W3C's guidelines are the one shared
standard — WCAG 2.2 is ISO/IEC 40500:2025 — and, as GOV.UK's sixth
design principle has it, accessible design is good design: the
discipline it imposes, clear names and predictable structure, serves
every user. Retrofitting accessibility costs more than building it and
reaches fewer.

**Implications.**
- The product designer role names the accessibility target per
  interaction type in the corpus, with the WCAG2ICT applicability
  record for non-web types.
- BC-shops test each interaction with assistive technology before
  delivery and attach the result.
- The PO role's acceptance scenarios for an interaction include its
  accessibility criteria.

### Errors guide recovery (`errors-guide-recovery`)

**Statement.**
- Every error the product shows MUST say what happened, in the
  product's vocabulary and the person's natural language, and what the
  person can do next.
- An error MUST NOT expose an internal identifier or message in place
  of that explanation, though it MAY carry one alongside it.

**Rationale.** A command that fails with a stack trace, a form that
says "invalid input" without saying which field, a chat assistant that
answers a misunderstanding with silence — each leaves the person to
guess, and in a command line, where there is no interface to guide
them, the error message is the interface. The Command Line Interface
Guidelines (clig.dev) say it directly: catch errors and rewrite them
for humans. Microsoft's Guidelines for Human-AI Interaction ask the
same of assistants — support efficient correction — and Google's
conversation design guidelines warn that one poorly handled error
outweighs dozens of successful turns.

**Implications.**
- BC-shops write every user-facing error with its next step, and keep
  the internal detail in a log or an alongside field.
- The product designer role screens error text against the vocabulary
  and voice.
- The solutions architect role's contracts define error responses that
  carry a human-readable explanation, not only a code.

### Control stays with the person (`control-stays-with-the-person`)

**Statement.**
- An assistant interaction MUST make clear what the product can do.
- An assistant interaction MUST say what it is about to do before an
  action the corpus classes as hard to reverse.
- An assistant interaction MUST let the person correct, dismiss, or
  stop it at any point.
- An assistant interaction MUST hand control back to the person when it
  fails.
- A generated interface MUST stay within the constraints the corpus
  states for it; it MAY vary its form within them.

**Rationale.** Intent-based interaction reverses the locus of control:
the person states an outcome and the system chooses the steps. That is
its value and its danger. An assistant that books the wrong thing
silently, or cannot be interrupted, or shows a different interface each
visit, loses the trust that makes delegation possible. Microsoft's
Guidelines for Human-AI Interaction — make clear what the system can
do, support efficient invocation, dismissal, and correction, provide
global controls — and Ben Shneiderman's *Human-Centered AI*, which
holds that high automation and high human control are compatible
rather than a trade-off, point the same way: the system may act, and
the person stays in charge.

**Implications.**
- BC-shops building an assistant interaction implement the confirm,
  correct, dismiss, and stop controls before the interaction is
  delivered.
- The product designer role screens assistant interactions against the
  human-AI guidelines named in the corpus.
- The product designer role states, in the corpus, which actions are
  hard to reverse and the constraints a generated interface varies
  within.

## Fitness screen (the intro's tests; sources: TOGAF, Spool, Rumelt, Lencioni)

| Screen | consistent-not-uniform | core-task-parity | agent-is-a-user | evidence-not-opinion | accessible-by-standard | errors-guide-recovery | control-stays-with-the-person |
|---|---|---|---|---|---|---|---|
| Statement testable (TOGAF: understandable, complete, consistent) | pass — precedence stated between vocabulary and platform | pass — against the corpus's list | pass | pass | pass | pass | pass |
| Helps you say no (Spool) | yes: rejects a second name for one thing and a CLI that imitates a web page | yes: rejects a task or option offered on one type only | yes: rejects an undesigned tool definition and an agent-only capability | yes: rejects a preference deciding a testable question | yes: rejects color-only meaning and accessibility as a later pass | yes: rejects a bare code or stack trace as an error | yes: rejects silent action, uninterruptible assistants, and unconstrained generated interfaces |
| Not fluff, not a goal-in-disguise (Rumelt) | pass — directs without prescribing form | pass | pass | pass | pass | pass | pass |
| Not permission-to-play (Lencioni) | pass — most multi-interface products drift into several vocabularies | pass — most voice and chat interfaces are subsets of the screen | pass — most tool definitions are named for the implementer | pass — most design questions are settled by the loudest preference | pass on bullets 2 and 3 — web AA is a legal floor in places; non-web application before delivery is rare | pass on bullet 2 — most CLI errors are stack traces | pass — most assistants act without confirming and cannot be stopped mid-action |
| Implies ≥1 practice and ≥1 check (this document's intro) | vocabulary and mappings maintained; text screened | core-task list kept; new type screened | screen before publication; agent-interface screen | evidence recorded per decision; sketches tested not adopted | target named per type; assistive-technology test before delivery | next-step in every error; error-text screen | controls implemented before delivery; human-AI guideline screen |
| Normative keywords used in statements only; capitals elsewhere only as the opening's mentions (mechanical) | pass | pass | pass | pass | pass | pass | pass |
| Implications derivable and actor-named, one per bullet (judged) | pass | pass | pass | pass | pass | pass | pass |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Drafted through the principle-set authoring chain by owner direction, scope experience, from the research report on the product designer role (on the `research` branch: `research/product-designer-role-2026-08.md`) and the external standards it names; the first layer of the experience guidance corpus. |
| 1 | 2026-08-26 | review | Screen round 1: findings — bullets in conflict in consistent-not-uniform; fused obligations and an undefined "generated interface" in control-stays-with-the-person; "agent" in two senses; fused and passive implications; open enumerations; sources unnamed; BC-shop term. |
| 2 | 2026-08-26 | update | Repairs: precedence between vocabulary and platform guidelines stated in the statement; obligations one per bullet; enumerations marked closed; assistant interaction and generated interface defined (glossary); every source named; lineage to actor-neutral-discipline stated in the rationale; implications split and actor-named, none adding an obligation; BC-shop used. |
| 2 | 2026-08-26 | review | Screen round 2: clean — all six scenarios and seven rules pass per principle, the mechanical grep passes, every screen cell reproducible; seven stumbles polished in place (enumeration closed, error language, the assistant statement split, API/SDK placement stated). |
