---
type: artifact-typedef
id: role-definition-typedef
defines: role-definition
owner: product-authority
status: approved
approved: 2026-08-22
version: 3
created: 2026-08-19
updated: 2026-08-25
ancestry: [definition, role-definition]
---

# Artifact type: role-definition

## Identity and ancestry

- **Type:** `role-definition` — a named capability contract and its
  accountabilities. A role says *who* and *what for* — never *when*;
  sequencing lives in process definitions, which name roles in their
  steps.
- **Produced by:** the author of the first process that needs the role.
  **Consumed by:** the runtime that instantiates the role (the
  frontmatter is the machine contract); process definitions (by name);
  reviewers checking the one-responsible-role rule.

## Required frontmatter

Functional contract keys first — `name`, `description`, `tools` (the
capability boundary: the list of allowed tool names), `maxTurns` — then the identity
base: `type: role-definition`, `id`, `owner`, `status`, `created`,
`updated`.

## Required sections

1. **Accountabilities** — 4–6 bullets: what the role answers for.
2. **Exclusive domain** — the one thing only this role may decide (e.g. a
   review round's verdict); derived from the rule that every decision has
   exactly one responsible role.

## Rules

- **No sequencing text.** Any sentence saying when the role acts is a
  misfiled process step.
- The capability contract enforces the role's stance mechanically where
  it can (read-only tools for a reviewer; a turn cap against drift).

## Commitment (Definition of Done)

A role definition is done when the role can be instantiated from the file
alone and no line says when to act. **Consequence on failure:** processes
naming the role do not pass conformance review.

## Sources

Capability-contract practice from the Claude Code subagent format
(frontmatter as machine contract); the exclusive domain derives from
RACI's one-Accountable rule.

## Derived review checklist

- Functional keys present and first. *(§Required frontmatter)*
- 4–6 accountabilities; exactly one exclusive domain. *(§Required sections)*
- No sequencing text — judged check. *(§Rules)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
