---
type: quality-guideline
id: implementation-guidance-guideline
target-type: implementation-guidance
owner: product-authority
status: approved
approved: 2026-09-06
version: 1
created: 2026-09-06
updated: 2026-09-06
generated: true
generated-by: basis/tools/compile_typedef.py
source: basis/artifacts/implementation-guidance.md
source-digest: sha256:85b888063bbd
---

<!-- Generated from `basis/artifacts/implementation-guidance.md` (its Writing rules section) by `basis/tools/compile_typedef.py`; do not edit by hand — edit the typedef and re-render. -->

# Guideline: implementation guidance

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
of the [base writing style](base-writing-style.md); the
base always applies and is never overridden. When rules conflict, an
approved principle beats the
[implementation-guidance typedef](../artifacts/implementation-guidance.md), which
beats this guideline. Every rule feeds the
[implementation-guidance fitness set](../fitness/implementation-guidance.fitness.md),
evaluated by the maker at the
[scenario-assignment process](../processes/scenario-assignment.md)'s
assign step.

---

## Rules

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
