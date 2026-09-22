# The next system — design note

Written 2026-09-22 from a conversation between the product authority and the
lead-pm assistant. It records the shape that converged and the decisions
still open. It is a design note, not a plan: no dates, no phases, no
appetite. Those come when the authority bets.

## What it is for

A shop that builds products and builds itself. A lead shop makes decisions,
writes Gherkin features, and hands them to Bounded Context shops. The same
loop that builds a product builds and improves the shop. Self-hosting does
not go away; it is what the system is for.

## Three layers

**Firmware.** Built like ordinary software: code, tests, no shop process.
Three components, each a Bounded Context with a strong contract:

1. **Knowledge base** — the artifact system behind an API.
2. **Orchestration** — runs a process definition: step by step, agent by
   agent, with hold and resume. Deterministic code, not a model.
3. **Messaging** — the mailboxes between the lead shop and the Bounded
   Context shops. Exists today as `shop-msg`.

**Operating system.** Roles, processes, and artifact schemas, held in the
knowledge base. Shipped as a small bootstrap set. Extended and improved by
the shop, through the shop, from the first real feature onward. Any instance
can update it.

**Products.** What the shop exists to build. Product work and operating
system work go through the same loop.

## The knowledge base

### Decisions taken

**Git is canonical. The API is the only access path. The store is derived.**

- Every artifact is serialized to text in a git repository the API owns.
  That repository is what the system boots from. The store — SQLite,
  Postgres, an in-memory tree; it does not matter — is rebuilt from the
  serialization and holds no truth of its own.
- Every change goes through the API. The API validates against the schema,
  writes the store, appends to the journal, serializes, and commits. One
  change, one commit, one author. That is the provenance the old Document
  History tables were faking by hand.
- Nothing edits the serialized text directly. Not a person, not an agent.
  The text is a rendering the human reads and the API writes.
- The human's view is the git repository, rendered. GitHub renders the
  markdown; diffs read as documents; `git log` is the history. The viewing
  experience is free and it does not change from what exists today.

**Artifacts are typed, ordered documents.** A document is an ordered list
of typed sections. A section has a title and a body. Domain parts — a
process step, a data field, a scenario, a work item, a journal row — are
typed nodes with ids, not text quoted inside a code fence. Inline formatting
is never modeled: a section's prose body is a markdown string, and it stays
one.

**Renderings are outputs, never stored in their source.** The diagram, the
agent skill, the subagent prompt, the guideline: each is generated from the
artifact and written elsewhere. Anthropic fixes the shape the last two must
take — YAML frontmatter and a markdown body — so a renderer to exactly that
shape exists whatever the source looks like.

**Work items live in the knowledge base.** A work item is an artifact type.
There is no second store and no second tool. The register is reachable by
the same query as everything else, which is what makes a feedback loop
possible.

**Every artifact carries a schema version from the first day.** Migration is
not built in the first version. Versioning is, so migration is possible
later.

### The API, scoped

Until the crossover, the knowledge API is exactly:

- create, read, update, delete an artifact;
- read and write one part of an artifact by path — a step, a section, a
  row;
- a typed query across the corpus — "features citing this record";
- a leveled read — summary, one section, whole — so an agent loads what its
  task needs and no more;
- a change journal — who changed what, when, through which execution.

Nothing else until the crossover. The list is short on purpose.

### What makes the boundary real

An API is a boundary only if the files are unreachable any other way. Two
mechanisms, both needed:

1. **Tool restriction per role.** A role that only needs the corpus gets the
   API's tools and no file or shell access. The harness enforces this; the
   role definitions already do it for some roles.
2. **The corpus is not on the agent's filesystem.** A role that needs a
   shell — the implementation maker building real code — works in a
   container that does not hold the knowledge base's repository or its
   store. Shell access and corpus access do not coexist in one place.

Without the second, an agent with a shell can read the store or the
serialization directly, and the boundary is advisory. Every advisory
constraint in the last system was breached.

### Why this and not the alternatives

The record of the last system: every mechanically enforced constraint held at
100%; every judged constraint was breached at 81–100%. The seven structural
failures of the artifact model all came through direct editing of files —
none through a tool. The property "recover the whole state from
human-readable text" was never actually held: the text accepted values the
schema did not define.

The industry precedent is GitOps: manifests in git, an API server as the
sole access path, a derived store, clients that never touch files. Every
system surveyed that made a database or JSON the source of truth built a
text twin to get back out.

## Orchestration

Runs a process definition from the knowledge base. Starts an execution,
records its anchor as a work item, calls each step — an agent in a named
role, or a runtime command — with that step's declared inputs and nothing
else, records outputs, routes on conditions, holds when a step needs a
person, resumes on the answer. Writes the cost of every step.

It is code. The last system used a model as the router; it wrote its
bookkeeping in prose, in the wrong form, and cost tokens to do arithmetic.

## Messaging

Exists. `shop-msg` and its Postgres mailboxes carry `assign_scenarios` to a
Bounded Context shop and `work_done` back. The contract on `main` is frozen
and the Bounded Context shops depend on it. It is adapted last, to unfreeze
them, not rebuilt first.

## Order of building

**Knowledge base, then orchestration, then messaging.**

The last system ran for a month in exactly the mode "knowledge base plus
orchestration, no messaging" — the shop frozen, every execution lead-only.
That mode works. Build the knowledge base; build orchestration running
lead-only processes against it; then adapt messaging to bring the Bounded
Context shops back.

## The bootstrap operating system

The smallest loop that closes:

- **Roles:** the decision maker (lead-pm), the feature author (lead-po), the
  architect (assignment and guidance). Maker and checker roles for
  implementation.
- **Processes:** discovery to a decision; feature authoring to a checked
  feature; assignment to a shop; implementation to a checked build.
- **Artifact types:** decision, feature, work item, role, process, schema.

Roughly three roles, four processes, six types. Everything else is added by
the shop, through the shop, after the crossover.

## The crossover

**The system self-delivers when the first operating-system change goes
through the operating system.**

Before it: the firmware is built and tested as ordinary software. The
bootstrap set is loaded. After it: the first real feature is an improvement
to the operating system, taken from decision to checked build through the
loop. Everything after that is the shop's own work.

The firmware is never self-hosted. Building it without a process is not a
defect; it is what firmware is.

## One measurement in the bootstrap

The last system had a principle that effectiveness of prompts and processes
must be measured and definitions updated from the measurement. It was never
once instanced, because nothing could compute it across two stores and hand
written tables. With work items, executions, and cost in one queryable
store, it is a query.

The bootstrap ships one such metric — for example, check-fail rate per
prompt version, or clarification requests per session — computed by the
system, not written by a model. If none ships, the loop dies again.

## The risk, and the guard

Firmware is meta-work. Meta-work is what consumed the last two systems. The
guard is scope stated before the first line, and held: the knowledge API is
the five operations above; the bootstrap is the smallest closing loop; the
crossover is a stated criterion. Anything not needed to reach the crossover
is not built before it.

## Language

The rule the last system's record supports is not "shorter." It is:

- No noun that is not in the glossary or plain English — in artifacts, in
  prompts, and in replies to the authority. A coinage is a defect at first
  use, not after it spreads.
- Every reply that needs a decision says which process is running, what the
  one decision is, and what words decide it.
- Quote the authority; never restate.
- Principles guide; rules constrain. A rule that must bind belongs in the
  API or the schema, where it fails a write. A principle belongs in a prompt,
  where it generalizes.

## Still open

- The serialization format on disk: YAML with block scalars, or a strict
  markdown profile the shop's own parser accepts. Same tree, two
  serializations; the choice is diff readability against parser ownership.
- The API's transport. The authority's preference is **gRPC as the primary
  API layer**: the contract is a `.proto` file, typed and versioned, and the
  same service definition serves every client. For agents, MCP is the
  presentation of that API to the harness — each operation exposed as a tool
  with a schema — not a second API. What remains open is the shape of that
  MCP layer over gRPC, and whether any client needs anything else.
- Which existing code survives as firmware: `shop-msg` yes; `agent-vault`,
  `bc-launcher`, `fabro` to be judged; `bd` retired into the knowledge base;
  the 4,461 lines of regex tooling retired.
- The store engine. Unimportant, by design.
- The first operating-system feature to cross over on.
- The appetite for the firmware, and who builds it.
