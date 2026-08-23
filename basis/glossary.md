---
type: glossary
id: glossary
owner: product-authority
status: approved
approved: 2026-08-19
created: 2026-08-19
updated: 2026-08-23
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
- **role** — a named seat with a capability contract and
  accountabilities; sequencing lives in process definitions, not roles.
- **principle** — a standing rule about how we work: name, statement,
  rationale, implications (see the principles document's opening
  definition).
- **seed layer** — the hand-approved definitions the regress terminates
  at: the principle set plus one typedef per definition document type.
- **owner** — the seat that approves changes to a definition; named in
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
  context it loads into: working (every activity) or architecture (the
  designed system).
- **transcript** — the runtime log of turns; unscoped, not a governed
  artifact, never loaded into context.
- **conversation** — a scoped, bounded discussion attached to exactly one
  anchor; every conversation belongs to a process.
- **conversation type** — discovery (anchor: a session record), review
  (anchor: a review record and its rulings), or work (anchor: a work
  item).
- **session record** — the anchor record of a discovery conversation:
  outcome, produced and revised lists, open threads, select quotes.
- **review** — one bounded conversation in which the authority rules on
  presented material. Replaces "sitting".
- **review record** — the anchor record of a review: the material
  presented and the rulings issued.
- **ruling** — a decision the authority records during a review; numbered
  (Rn) in the experiment index and binding on the corpus it governs.
- **park** — the failsafe for work that cannot pass review within its
  round cap: set aside with a filed finding.
- **round cap** — the declared maximum review rounds before a loop's
  failsafe exit fires.
- **action** — the approved choice for one record: keep-rewrite, keep,
  retire, or terminal, with its target. *(amended 2026-08-22, approved R30: extended from the three-value set to match the
  migration plan's use of keep; `authority-call` is not an action — see
  its entry.)*
- **authority-call** — a row marker on a migration-plan row awaiting a
  ruling from the authority; not an action — the row has no effect and
  is out of scope for any run until ruled. *(amended 2026-08-22, approved R30)*
- **action table** — the table of records and their actions; approved row
  by row or in blocks at a review. Drives any bulk record change.
  *(amended 2026-08-22, approved R30: schema-defined as the
  `action-table` data type in `types/action-table.md` — the governed
  channel for per-keeper directives and family nominations.)*
- **close-out** — the mechanical execution of the migration plan's
  pre-decided retire and terminal actions: snapshot, delete, archive
  move, a loud post-check, and the branch promotion; no review loop.
  All stages run consecutively at cut-over (R27). *(added 2026-08-22,
  approved R30.)*
- **snapshot tag** — the annotated git tag (`pre-migration`) on `main`'s
  pre-execution commit, preserving the full corpus for terminal-recovery;
  after close-out a terminal record exists only there. *(added
  2026-08-22, approved R30.)*
- **migration plan** — the rebaseline's action table plus the order of
  the per-type migration runs. Replaces "rebaseline bill".
- **experiment index** — the new-basis experiment's README: the
  walkthrough, the numbered rulings, and the review state.
- **run** — one execution of a process, anchored to a work item; states:
  running, held, done, cancelled.
- **hold** — a run state: paused with its step and data preserved in its
  anchor; a held run is resumed or cancelled, never dropped.
- **checkpoint** — updating a conversation's anchor when a transcript
  ends mid-conversation; a checkpoint is not a close.
- **branched conversation** — a conversation run as a sub-process of
  another run; its anchor records the parent (`branched-from`).
- **Bounded Context** — a deliberately drawn region of the product with
  one internal language, one model, and one set of contracts to other
  regions; drawn by design, never discovered after the fact (Evans,
  *Domain-Driven Design*). *(added 2026-08-23; rides the
  architecture-principle-set approval.)*
- **shop** — the entity that builds, operates, and evolves part of the
  product. Two types: the lead shop (the system-level coordinator; owns
  product-level artifacts and no Bounded Context) and the BC-shop (owns
  and produces exactly one Bounded Context). *(added 2026-08-23; rides
  the architecture-principle-set approval.)*
- **activity** — a discrete unit of work performed inside a shop,
  following a contract or process, with inputs, outcomes, and provenance
  recorded. What an actor is stays unconstrained; the activity has the
  same shape whoever performs it. *(added 2026-08-23; rides the
  architecture-principle-set approval.)*
- **contract** — a named, versioned statement of what one entity
  promises another: the schemas exchanged, the meaning of each
  operation, the error behavior, and the relationship kind. Offered as a
  product contract (on a Bounded Context) or an operational contract (on
  a shop); nothing outside a contract is promised. *(added 2026-08-23;
  rides the architecture-principle-set approval.)*
- **relationship kind** — the named pattern a contract declares for how
  two Bounded Contexts relate, drawn from the context-mapping catalogue
  (Evans, *Domain-Driven Design*): customer–supplier, conformist,
  anti-corruption layer, open host service, published language, shared
  kernel, or separate ways. *(added 2026-08-23; rides the
  architecture-principle-set approval.)*
- **intent** — a desired outcome expressed by an originator at the
  product's edge; enters the product through a contract and keeps its
  provenance through every translation and delegation. *(added
  2026-08-23; rides the architecture-principle-set approval.)*
