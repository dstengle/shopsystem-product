---
type: artifact-typedef
id: implementation-guidance-typedef
defines: implementation-guidance
owner: product-authority
status: approved
approved: 2026-09-06
version: 1
created: 2026-09-06
updated: 2026-09-06
ancestry: [implementation-guidance]
---

# Artifact type: implementation-guidance

## Identity and ancestry

- **Type:** `implementation-guidance` — the solutions architect role's
  guidance to one Bounded Context shop for the scenarios assigned to
  it in one assignment: what those scenarios change in that context
  at the level the architect may see, the contracts and scenarios it
  rests on, and what not to do. A historical record of the assignment
  it was written for — technical implementation changes over time
  while the scenario contract does not — never the contract itself.
- **Produced by:** the
  [lead-solutions-architect role](../roles/lead-solutions-architect.md)
  at the [scenario-assignment process](../processes/scenario-assignment.md)'s
  assign step, one per Bounded Context that receives scenarios in that
  assignment, written from the
  [guideline](../guidelines/implementation-guidance.md) and evaluated
  by its maker against the
  [implementation-guidance fitness set](../fitness/implementation-guidance.fitness.md)
  before the assignment is recorded. The guideline and the fitness set
  are renderings of this typedef — produced from its Writing rules and
  Fitness scenarios sections by `basis/tools/compile_typedef.py`, never
  edited by hand.
  **Consumed by:** the shop implementing those scenarios; the
  [reconcile-and-close process](../processes/reconcile-and-close.md),
  which records whether the guidance held when the work returns.

## Required frontmatter

`type: implementation-guidance`, `id`, `status` (written — set at the
assign step | held | not-held — the last two set by the
reconcile-and-close process when the work returns), `version`,
`initiative` (a link to the initiative), `feature` (a link to the
feature), `context` (the Bounded Context the guidance is for, as
tagged), `scenarios` (the `@hash:` values assigned to that context
that the guidance covers), `owner`, `created`, `updated`. The field
set is closed.

## Required sections

1. **What changes** — what the assigned scenarios change in that
   context at the level the architect may see: its contracts, the
   guardrails that apply, where the cross-context flow touches it;
   and, for the lead shop building its own definitions, the
   definitions and tools to change.
2. **References** — the contracts and the scenarios the guidance rests
   on, cited by contract name and version and by scenario hash; never
   restated.
3. **What not to do** — each with the reason.

## Rules

- Instances live in `guidance/` at the repository root, one per
  feature and context, at `guidance/<feature>-<context>.md` — the
  feature's id and the context's name as tagged; the lint walks the
  directory for the required frontmatter.
- An instance is a historical record: it binds nothing after the
  assignment it was written for, because technical implementation
  changes over time while the scenario contract does not unless
  explicit changes are made. A later assignment gets its own record.
- An instance stays at the level the architect may see of a context —
  its contracts, the guardrails, the cross-context flow — never the
  context's internals, except where the lead shop builds its own
  definitions, whose definitions and tools the record may name.
- An instance is never sent in a message now: the message contract is
  unchanged by this type, and the designer's guidance is a later part.
- An instance's frontmatter and references are the only places the
  initiative, feature, contracts, and scenarios appear; the body cites
  them and does not restate them.

## Commitment (Definition of Done)

An instance is done when the implementing shop can act on it with the
assigned scenarios alone — nothing further from the architect needed
to begin — and its maker has evaluated it against the fitness set and
recorded that evaluation in the assignment's Document History entry.
**Consequence on failure:** the shop raises a clarify question on
structure or contract to the architect role, and the reconcile-and-close
process records the guidance as not held.

## Sources

ISO/IEC/IEEE 42010 (an architecture description addressed to one
stakeholder's concerns — here one implementing shop's) for the
per-context split; Nygard's architecture decision record for a dated
record that binds by reference and is superseded, never edited;
Evans' context map for what the architect may see of a context — its
contracts and relationships, never its internals; the what-not-to-do
section and the historical-record rule as the shop's own additions,
from the authority's direction of 2026-09-06 recorded in
req-2026-09-06-implementation-guidance; the
[implementation-guidance fitness set](../fitness/implementation-guidance.fitness.md).

## Writing rules

**Voice principle.** Write the record for the shop that will start on
the assigned scenarios tomorrow with nothing from you but this: what
changes at the edge it shares with the product, which contracts and
guardrails that touches, what it must not do and why — and nothing it
could read in the scenarios themselves.

**Highlights (the layer compiled into generating context):** the
change stated at the level the architect may see — contract,
guardrail, cross-context flow — never the context's internals · every
contract and scenario cited by name, version, or hash, never restated ·
actionable with the assigned scenarios alone · each thing not to do
carries its reason · bound to one assignment: the initiative, feature,
context, and scenario hashes it covers, and no claim past them.

**Layers:** this guideline adds implementation-guidance rules on top
of the [base writing style](../guidelines/base-writing-style.md); the
base always applies and is never overridden. When rules conflict, an
approved principle beats the
[implementation-guidance typedef](implementation-guidance.md), which
beats this guideline. Every rule feeds the
[implementation-guidance fitness set](../fitness/implementation-guidance.fitness.md),
evaluated by the maker at the
[scenario-assignment process](../processes/scenario-assignment.md)'s
assign step.

---

### Rules

**1. Stay at the level the architect may see.**
Before: "Add a `status` column to the runs table, index it, and
update the repository class."
After: "The reporting context's list contract gains a status field —
one contract version; the schema-migration guardrail applies; the
operations context reads the field across the run-list flow."
*Test:* read each statement in What changes. *Criterion:* every
statement names a contract, a guardrail, or a point in the
cross-context flow — or, for the lead shop's own definitions, a
definition or tool — and none names the context's internals.
*Decision:* yes/no per statement.
*Derived check:* judged — implementation-guidance fitness scenario 1.

**2. Cite, never restate.**
Before: "Scenario: a failed run is listed. Given a run has failed,
When the operator opens the run list, Then …"
After: "Scenarios `@hash:a1b2c3` and `@hash:d4e5f6` of
feat-run-status; the reporting list contract, version 3, §2."
*Test:* compare the References section and the body with the
scenarios and contracts they name. *Criterion:* each is cited by
hash, or by name and version, and no scenario text or contract clause
is reproduced. *Decision:* yes/no per reference.
*Derived check:* judged — implementation-guidance fitness scenario 2.

**3. Actionable with the scenarios alone.**
Before: "Talk to the architect before starting on the contract
change."
After: "Version the list contract from 3 to 4 adding `status`
(enum: the run states the reporting contract already defines);
consumers are the operations context's run-list view only."
*Test:* read the record as the implementing shop with the assigned
scenarios beside it. *Criterion:* the shop can begin without a
further answer from the architect — every contract to version, every
guardrail to honour, and every point of the flow is named.
*Decision:* yes/no per record.
*Derived check:* judged — implementation-guidance fitness scenario 3.

**4. Each thing not to do carries its reason.**
Before: "Don't add another endpoint."
After: "Do not add a second list endpoint: the decomposition places
listing in the reporting context, and a second one would give the
list contract two homes."
*Test:* read each entry in What not to do. *Criterion:* each names
what not to do and the reason, in the decomposition, a contract, a
guardrail, or a principle. *Decision:* yes/no per entry.
*Derived check:* judged — implementation-guidance fitness scenario 4.

**5. Bound to one assignment.**
Before: "From now on every context must expose a status field."
After: "For the scenarios of feat-run-status assigned to the
reporting context on 2026-09-06 (`@hash:a1b2c3`, `@hash:d4e5f6`):
…" — with the frontmatter naming the initiative, feature, context,
and those hashes.
*Test:* read the frontmatter and the body's scope statements.
*Criterion:* the initiative, feature, context, and scenario hashes are
named and every statement is about those scenarios; no statement
binds a later assignment or another context. *Decision:* yes/no per
record.
*Derived check:* judged — implementation-guidance fitness scenario 5.

## Fitness scenarios

An implementation guidance record is the solutions architect role's
guidance to one Bounded Context shop for one assignment. These
scenarios are the criteria set the record is evaluated against: by
its maker at the [scenario-assignment process](../processes/scenario-assignment.md)'s
assign step before the assignment is recorded, and read again by the
[reconcile-and-close process](../processes/reconcile-and-close.md)
when it records whether the guidance held. No check of record
screens a record: the type is a historical record, not the contract.
**Judged by:** `cold-reviewer`, never executed; where a judge reads
the record, the judge's model and prompt version are recorded with the
verdict. The judge reads only the criteria set and the record; every
scenario therefore asks for what the record itself carries.

The record's parts: What changes and What not to do are the shop's own
form, from the authority's direction on
req-2026-09-06-implementation-guidance; References follows the
architecture decision record's practice of binding by reference; the
per-context split follows ISO/IEC/IEEE 42010's address to one
stakeholder's concerns; the bound to one assignment is the record's
historical-record rule.

### Scenarios

Scenario 1: at the level the architect may see
  Given the record's What changes section
  When each statement is read
  Then it names a contract, a guardrail, or a point in the
  cross-context flow — or, for the lead shop's own definitions, a
  definition or tool — and none names the context's internals

Scenario 2: cited, never restated
  Given the record's References section and body
  When they are compared with the scenarios and contracts they name
  Then each is cited by hash, or by name and version, and no scenario
  text or contract clause is reproduced

Scenario 3: actionable with the scenarios alone
  Given the record and the assigned scenarios
  When the implementing shop reads them together
  Then it can begin without a further answer from the architect —
  every contract to version, every guardrail to honour, and every
  point of the flow is named

Scenario 4: each thing not to do carries its reason
  Given the record's What not to do section
  When each entry is read
  Then it names what not to do and the reason, in the decomposition, a
  contract, a guardrail, or a principle

Scenario 5: bound to one assignment
  Given the record's frontmatter and body
  When a reader asks what the record covers
  Then the initiative, feature, context, and scenario hashes are named
  and every statement is about those scenarios; no statement binds a
  later assignment or another context

### Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — the architect's level | "For each statement in What changes: does it name a contract, a guardrail, a point in the cross-context flow, or a lead-shop definition or tool? Cite any statement that names a context's internals." |
| 2 — cited, never restated | "Is every scenario cited by hash and every contract by name and version, with no scenario text or contract clause reproduced? Cite any restatement." |
| 3 — actionable alone | "Reading the record with the assigned scenarios only: can the shop begin without asking the architect? Cite what is missing, or state none." |
| 4 — reasons for what not to do | "For each entry in What not to do: is the reason named — decomposition, contract, guardrail, or principle? Cite any entry without one." |
| 5 — one assignment | "Are the initiative, feature, context, and scenario hashes named, and is every statement about those scenarios only? Cite any statement that binds a later assignment or another context." |

## Derived review checklist

- Every statement in What changes is at the architect's level — contract, guardrail, flow, or a lead-shop definition or tool. *(§Required sections 1, §Rules; fitness 1)*
- Contracts and scenarios cited, never restated. *(§Required sections 2, §Rules; fitness 2)*
- The shop can act on the record with the assigned scenarios alone. *(§Commitment; fitness 3)*
- Each thing not to do carries its reason. *(§Required sections 3; fitness 4)*
- Initiative, feature, context, and scenario hashes named; nothing binds past this assignment. *(§Required frontmatter, §Rules; fitness 5)*
- The record is not sent in a message; it lives at `guidance/<feature>-<context>.md`. *(§Rules)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Authored under req-2026-09-06-implementation-guidance at the small-change process's make step, from the authority's direction of 2026-09-06 recorded in that request ("For now create an implementation guidance artifact that references the initiative"; "guidance per bounded context"; "created with the scenarios in mind"; "only be part of a historical record"): the type, its identity, frontmatter, sections, rules, commitment, and sources; the Writing rules and Fitness scenarios sections carried here so the guideline and fitness set are produced by basis/tools/compile_typedef.py. Status approved on the authority's direction of 2026-09-06 as the request records it. Maker's evaluation against the artifact-typedef typedef's checklist: defines matches the instance type; the eight required sections present in order; the commitment states a consequence; sources present, no pinned example links; every checklist entry cites a clause; Writing rules and Fitness scenarios both present, each in the produced text's form. Made by the lead-solutions-architect role. |
