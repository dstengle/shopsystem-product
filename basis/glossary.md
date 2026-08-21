---
type: glossary
id: glossary
owner: product-authority
status: approved
approved: 2026-08-19
created: 2026-08-19
updated: 2026-08-20
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
- **keeper** — a corpus record the rebaseline bill keeps; rewritten
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
- **rebaseline bill** — the approved per-record table (keep-rewrite,
  retire, or terminal for each corpus record) that drives the rebaseline.
- **experiment index** — the new-basis experiment's README: the
  walkthrough, the numbered rulings, and the review state.
