---
type: fitness-set
id: implementation-guidance-fitness
target-type: implementation-guidance
judged: true
executable: false
judged-by: cold-reviewer
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

<!-- Generated from `basis/artifacts/implementation-guidance.md` (its Fitness scenarios section) by `basis/tools/compile_typedef.py`; do not edit by hand — edit the typedef and re-render. -->

# Fitness set: implementation guidance

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

## Scenarios

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

## Compile mapping (each Then → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 — the architect's level | "For each statement in What changes: does it name a contract, a guardrail, a point in the cross-context flow, or a lead-shop definition or tool? Cite any statement that names a context's internals." |
| 2 — cited, never restated | "Is every scenario cited by hash and every contract by name and version, with no scenario text or contract clause reproduced? Cite any restatement." |
| 3 — actionable alone | "Reading the record with the assigned scenarios only: can the shop begin without asking the architect? Cite what is missing, or state none." |
| 4 — reasons for what not to do | "For each entry in What not to do: is the reason named — decomposition, contract, guardrail, or principle? Cite any entry without one." |
| 5 — one assignment | "Are the initiative, feature, context, and scenario hashes named, and is every statement about those scenarios only? Cite any statement that binds a later assignment or another context." |
