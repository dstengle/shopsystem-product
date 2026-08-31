---
type: glossary
id: glossary
owner: product-authority
status: approved
approved: 2026-08-19
version: 17
created: 2026-08-19
updated: 2026-08-31
---

# Glossary

## How the list combines

The defined-term list is this glossary combined with every schema element
name. Per the `use-defined-terms` principle, a writer choosing between
terms uses one of these when one fits.

## Terms

- **artifact type** — a named, schema-defined document type (e.g.
  `decision-brief`); the term the schema registry uses. Not "kind".
- **data type** — a named, schema-defined structure that is not a
  human-readable document (e.g. `review`); passed between process steps.
- **simple type** — a JSON Schema primitive (`string`, `integer`,
  `boolean`, `array`, `object`), usable inline without registration.
- **typedef** — the single source a type is generated from; templates and
  schema fragments are its renderings (owned by shopsystem-knowledge).
- **schema** — the machine-checkable shape of a type: fields, types,
  enums, required sections.
- **process definition** — the source of truth for a process: header
  (purpose, outcomes, roles), data section, steps section.
- **step** — one unit of a process: an agent step (carries a prompt) or a
  runtime step (carries `set`, `run`, or `branches`; no prose).
- **rendering** — a generated output of a definition (a skill, a
  diagram, a template); never edited by hand, never the source of truth.
- **guiding statement** — an optional header element of a process
  definition that directs judgment across the whole process; compiled
  into every rendering.
- **fitness set** — judged (never executed) Given/When/Then scenarios
  scoring an artifact type's quality.
- **guideline** — prose quality rules for an artifact type, each with a
  test, a criterion, and a yes/no decision.
- **role** — a named capability contract and set of accountabilities,
  assigned by process steps to whoever fills it; sequencing lives in
  process definitions, not roles.
- **principle** — a standing rule about how we work: name, statement,
  rationale, implications (see the principles document's opening
  definition).
- **seed layer** — the hand-approved definitions the regress terminates
  at: the principle set plus one typedef per definition document type.
- **owner** — the role that approves changes to a definition; named in
  every definition's frontmatter.
- **definition chain** — the six linked definitions of good for one
  artifact type; required before instances are authored or rewritten.
- **keeper** — a corpus record whose action is keep-rewrite; rewritten
  forward through its type's approved chain, never used as-is.
- **rewrite-forward** — the default for keepers: re-author to the
  approved standard; repair-in-place only for records already at the bar.
- **rebaseline** — Phase 1 of the re-founding arc: the active tree comes
  to hold only chain-conforming records; retired mass moves to the
  archive.
- **scope** (of a principle set) — the level the set governs and whose
  context it loads into: working (every activity), architecture (the
  designed system), or experience (the product's interactions).
- **transcript** — the runtime log of turns; unscoped, not a governed
  artifact, never loaded into context.
- **conversation** — a scoped, bounded discussion attached to exactly one
  anchor; every conversation belongs to a process.
- **anchor** — the governed record a conversation attaches to: a session
  record, a review record, or a work item; carries the conversation's
  state across transcript boundaries.
- **conversation type** — discovery (anchor: a session record), review
  (anchor: a review record and its outcomes), or work (anchor: a work
  item).
- **session record** — the anchor record of a discovery conversation:
  outcome, produced and revised lists, open threads, select quotes.
- **review** — one bounded conversation in which the authority decides
  on presented material. Replaces "sitting".
- **review record** — the anchor record of a review: the material
  presented and the outcomes applied; each decision traces in the
  changed artifacts' Document History, never in a standing ledger.
- **park** — the failsafe for work that cannot pass review within its
  round cap: set aside with a filed finding.
- **round cap** — the declared maximum review rounds before a loop's
  failsafe exit fires.
- **action** — the approved choice for one record: keep-rewrite, keep,
  retire, or terminal, with its target.
- **authority-call** — a row marker on a migration-plan row awaiting a
  decision from the authority; not an action — the row has no effect and
  is out of scope for any run until ruled.
- **action table** — the table of records and their actions; approved row
  by row or in blocks at a review. Drives any bulk record change.
- **close-out** — the mechanical execution of the migration plan's
  pre-decided retire and terminal actions: snapshot, delete, archive
  move, a loud post-check, and the branch promotion; no review loop.
  All stages run consecutively at cut-over.
- **snapshot tag** — the annotated git tag (`pre-migration`) on `main`'s
  pre-execution commit, preserving the full corpus for terminal-recovery;
  after close-out a terminal record exists only there.
- **migration plan** — the rebaseline's action table plus the order of
  the per-type migration runs. Replaces "rebaseline bill".
- **run** — one execution of a process, anchored to a work item; states:
  running, held, done, cancelled.
- **hold** — a run state: paused with its step and data preserved in its
  anchor, by inactivity or by an ask; a held run is resumed or
  cancelled, never dropped.
- **checkpoint** — updating a conversation's anchor when a transcript
  ends mid-conversation; a checkpoint is not a close.
- **branched conversation** — a conversation run as a sub-process of
  another run; its anchor records the parent (`branched-from`).
- **Bounded Context** — a deliberately drawn region of the product with
  one internal language, one model, and one set of contracts to other
  regions; drawn by design, never discovered after the fact (Evans,
  *Domain-Driven Design*).
- **shop** — the entity that builds, operates, and evolves part of the
  product. Two types: the lead shop (the system-level coordinator; owns
  product-level artifacts and no Bounded Context) and the BC-shop (owns
  and produces exactly one Bounded Context). By the owner's decision a
  BC-shop is a component team in the product literature's sense: it
  receives bounded work for its context and does not own a feature end
  to end; a request that crosses contexts is decomposed above it, in
  the initiative, never by the shops between themselves.
- **activity** — a discrete unit of work performed inside a shop,
  following a contract or process, with inputs, outcomes, and provenance
  recorded. What an actor is stays unconstrained; the activity has the
  same shape whoever performs it.
- **contract** — a named, versioned statement of what one entity
  promises another: the schemas exchanged, the meaning of each
  operation, the error behavior, and the relationship kind. Offered as a
  product contract (on a Bounded Context) or an operational contract (on
  a shop); nothing outside a contract is promised.
- **relationship kind** — the named pattern a contract declares for how
  two Bounded Contexts relate, drawn from the context-mapping catalogue
  (Evans, *Domain-Driven Design*): customer–supplier, conformist,
  anti-corruption layer, open host service, published language, shared
  kernel, or separate ways.
- **vehicle** — the message type a request to a Bounded Context shop
  travels in; chosen from the pre-state, never from the request's
  wording.
- **pre-state** — what a Bounded Context actually is before a change,
  read from its contracts and its view of the scenario register — both
  lead-shop-held records — never from its internals and never by
  querying the shop.
- **framing** — the PM role's recorded statement of what a request is
  about: the originator, the problem taken to be worth solving, the
  outcome it serves, and the contract it entered through; the
  exclusive decision of `lead-pm`; written as the first section of an
  initiative and nowhere else.
- **initiative** — the product-level problem artifact: one problem
  worth solving, stated for the product, with its framing, one
  measured outcome, an appetite and no-gos, the feasibility and
  usability attachments, and the solutions architect's decomposition;
  made by the PM role, screened by the cold reviewer, bet on by the
  authority; features are made from it.
- **acceptance scenario** — a Gherkin scenario in a feature that
  states, as a requirement, what counts as done for one behavior;
  co-produced by the PO role and the owning Bounded Context shop;
  assigned to that context by a `@bounded-context:<name>` tag the
  solutions architect writes; held in that shop's scenario register.
- **scenario register** — the lead shop's one register of every
  acceptance scenario in the system, with each scenario's hash, state,
  and `@bounded-context:` assignment; read as per-context views.
  Maintained asynchronously — assignment writes to it when scenarios
  are dispatched, and reconcile-and-close confirms and updates it when
  a shop's work returns — never by querying shops on demand. The
  authoritative record for assignment and for pre-state verification.
- **ask** — a question one activity puts to another role in place of
  its output, carrying a default and a checkpoint; the run holds, the
  role answers, the step resumes — never a wait in place (data type
  `ask`; process-definition typedef §Run lifecycle).
- **clarify** — an ask from a Bounded Context shop to the lead shop on
  scope, vocabulary, structure, or contract; answered by the role whose
  domain the question falls in.
- **decomposition** — the solutions architect's record of which Bounded
  Context owns which capability, and the relationship kind of each
  contract between contexts.
- **enabler work** — technical work that makes a feature possible;
  recommended by the solutions architect, placed in the backlog by the
  PO role.
- **interaction type** — one way a person or an agent reaches the
  product: command line (CLI), full-screen terminal (TUI), graphical or
  web (GUI), API and SDK, conversational, voice, or a generated document
  or notification; each honours its own conventions within one
  experience. The experience guidelines cover conversational and voice
  together as the `assistant` guideline.
- **experience guidance corpus** — the product designer role's
  principle set and guidelines for the experience: design principles,
  vocabulary and voice, core-task parity across interaction types,
  interaction patterns per type, and the accessibility target; the
  role's exclusive domain.
- **originator** — whoever expresses intent at the product's edge: a
  person, a shop, or a system outside the product.
- **generated interface** — an interface whose form the product composes
  at run time from the person's context, within constraints the
  experience guidance corpus states; a form, not an interaction type.
- **assistant interaction** — an interaction in which the product acts on
  an intent the person stated rather than on a command — conversational,
  voice, or an assistant acting for the person (a closed set); the locus
  of control is the product's, so the experience principles bound it.
- **feature** — a Gherkin Feature: one capability from the user's or
  agent's point of view — a narrative saying who, what, and the outcome
  — with the acceptance scenarios that state what counts as done for
  it; product-level, belonging to its framing or initiative; its
  scenarios may be owned by several Bounded Contexts. The PO role's
  artifact. (The per-shop *brief* was retired 2026-08-28; the
  `decision-brief` to the authority is unrelated.)
- **check of record** — the check whose verdict the definitions rely
  on for an artifact when the role that makes it also holds the
  authority that approves it; for the initiative, the cold reviewer's
  screen.
- **bet** — the authority's decision to spend an initiative's appetite:
  the go/no-go, taken in a review, moving it from `proposed` to
  `planned`.
- **product decision record** — the PO role's record of one
  product-level decision — decision, alternatives, consequences,
  decider and right, reversibility; ADR and MADR forms; checked as PO
  output.
- **intent** — a desired outcome expressed by an originator at the
  product's edge; enters the product through a contract and keeps its
  provenance through every translation and delegation.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Seed term list authored. |
| 1 | 2026-08-19 | state | draft → approved. |
| 2 | 2026-08-22 | update | Conversation-model terms added; action extended to four values, authority-call and action-table amended, close-out and snapshot tag added. |
| 3 | 2026-08-23 | update | Architecture terms added, riding the architecture-principle-set approval: Bounded Context, shop, activity, contract, relationship kind, intent. |
| 3 | 2026-08-23 | state | The six architecture terms approved with the architecture principle set; pending markers removed. |
| 4 | 2026-08-23 | update | Owner direction: ruling and experiment-index entries removed with the ledger practice; review and review-record entries rewritten to the outcomes model. |
| 5 | 2026-08-23 | update | Anchor entry added — the term recurred as an unintroduced-term stumble across three screens. |
| 6 | 2026-08-23 | update | vehicle and pre-state added — terms the lead-solutions-architect role turns on. |
| 7 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
| 8 | 2026-08-25 | update | framing, acceptance scenario, scenario register, clarify, decomposition, enabler work added — each arrived undefined in the PM and PO role screens. |
| 9 | 2026-08-25 | update | interaction type and experience guidance corpus added with the lead-product-designer role. |
| 10 | 2026-08-25 | update | ask added; clarify re-based as an ask; hold now names the ask as a cause. |
| 10 | 2026-08-25 | update | originator added — used by the PM role and the ask type without a definition. |
| 11 | 2026-08-26 | update | scope gains the experience level with the experience principle set. |
| 11 | 2026-08-26 | update | generated interface and assistant interaction added with the experience principle set. |
| 12 | 2026-08-26 | update | interaction type: the guidelines' `assistant` coverage of conversational and voice noted. |
| 13 | 2026-08-27 | update | Owner decision, from the system-read report: BC-shops are component teams by design; stated in the shop entry. |
| 14 | 2026-08-28 | update | Owner decision: feature added; acceptance scenario and scenario register carry the `@bounded-context:` assignment; the per-shop brief retired. |
| 15 | 2026-08-28 | update | initiative added; framing stated to live in the initiative's first section. |
| 16 | 2026-08-28 | update | framing carries the contract; check of record, bet, and product decision record added — each arrived undefined in the initiative chain's screen. |
| 17 | 2026-08-31 | update | Owner direction: the scenario register is the lead shop's one register with per-context views, maintained asynchronously from dispatch and reconciliation — not each shop's own list queried on demand; pre-state reads lead-shop-held records. |
