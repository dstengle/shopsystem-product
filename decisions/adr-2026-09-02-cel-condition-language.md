---
type: adr
id: adr-2026-09-02-cel-condition-language
title: CEL is the condition language of process definitions
status: checked
version: 1
date: 2026-09-02
decided-by: lead-solutions-architect
right: stack
owner: lead-solutions-architect
created: 2026-09-02
updated: 2026-09-02
---

# ADR: CEL is the condition language of process definitions

## 1. Context

Every process definition routes on conditions — the branch guards in
its `route-*` steps, written over the declared data names. The
language those conditions are written in decides who can evaluate a
route: an agent following the rendered skill, the compiler checking
the definition, and any future executor all read the same guard.

The choice stands in force today: the approved
[process-definition typedef](../basis/artifacts/process-definition.md)
requires `condition-language: cel` in every definition's frontmatter,
and all nineteen process definitions in `basis/processes/` carry it,
with their branch conditions written as CEL expressions (e.g.
`review.findings.all(f, f.criterion == "uncovered")`). The decision
entered force through that typedef's approval; this record is its
decision record, authored retroactively — the reasons were never
recorded.

Options that were real:

- **Inline Python expressions.** The tooling is Python, so guards
  would execute directly. Declined: an executable host-language guard
  admits side effects and ties every definition to one runtime — a
  BC shop or a future executor on another stack inherits Python to
  read a route.
- **Natural-language conditions.** Readable by any agent. Declined:
  not mechanically checkable — two readers can route the same state
  differently, and the compiler can verify nothing.
- **JSON Logic.** Also an established external form. Declined: no
  quantifier over collections — the definition exit's
  "every finding is uncovered" guard has no direct expression.

Screened against the
[architecture principle set](../basis/architecture-principles.md):
conforms — the guards keep every definition's routing knowable from
the document alone (`knowable-shape`) and readable locally over the
step's declared data names without opening any tooling
(`local-comprehension`); no principle is unsatisfied, nothing is
escalated.

## 2. Decision

Conditions in process definitions are written in CEL (the Common
Expression Language), declared per document by the
`condition-language` frontmatter field, whose authoritative home is
the process-definition typedef.

## 3. Consequences

- Every evaluator of a route — the compiler, an agent following a
  rendered skill, a future executor — reads one spec-defined,
  side-effect-free expression language; what changes: routing becomes
  mechanically checkable; for whom: the lead shop's tooling and every
  agent running a process; cost: a CEL evaluator, or a careful manual
  read, wherever routes are executed.
- Guards cannot mutate state, do I/O, or call the runtime — CEL has
  no side effects; what changes: a condition can only inspect
  declared data; for whom: process authors; forecloses: routing logic
  that hides work inside a guard.
- A bound for shops authoring process definitions for this product:
  a definition's conditions MUST be in the language its
  `condition-language` field declares, and the lead shop's tooling
  evaluates only `cel`; a shop wanting another language raises it as
  a contract question, not a local deviation.

## 4. Reversibility

Reversible per document: `condition-language` is declared in each
definition's frontmatter, so a migration to another language can run
one definition at a time. Moderate in practice — nineteen definitions
and the compiler would move. Review trigger: a hosting runtime that
cannot evaluate CEL, or a routing condition a process needs that CEL
cannot express.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Authored through the adr-authoring process as the adr chain's exemplar — the definition-chain-migration proof run, on a local decision per owner direction. Records retroactively the CEL choice standing in the process-definition typedef since its approval. |
| 1 | 2026-09-02 | review | Screen round 1 (judge claude-fable-5 / adr-screen prompt v1): clean — all six fitness criteria and the principles criterion pass, every finding-check confident; the retroactive authoring weighed against bidirectional-conformance and cleared, the choice having stood in the approved typedef. |
| 1 | 2026-09-02 | state | draft → checked: pass at the PM role's ruling (brief-033 ask 2), the right ruled held — the stack is the solutions architect role's exclusive domain per its approved definition. |
