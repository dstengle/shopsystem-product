---
type: index
id: basis-index
owner: product-authority
status: approved
approved: 2026-08-23
version: 6
created: 2026-08-10
updated: 2026-09-02
---

# Basis index

The `basis/` tree is the shop's definition corpus. Every activity on
the `rebaseline` branch operates through these definitions; nothing
here is advisory.

## What lives where

- [`principles.md`](principles.md) — the working-scope principle set:
  how every activity is performed.
- [`architecture-principles.md`](architecture-principles.md) — the
  architecture-scope principle set: how the system is designed.
- [`glossary.md`](glossary.md) — the defined-term list, combined with
  every schema element name.
- `artifacts/` — artifact typedefs, rooted at
  [`artifacts/definition.md`](artifacts/definition.md), which carries
  the requirements every definition document inherits (frontmatter
  identity, version, Document History).
- `types/` — data types passed between process steps.
- `processes/` — process definitions; every activity belongs to one.
- `guidelines/` — prose quality rules per artifact type, layered on
  [`guidelines/base-writing-style.md`](guidelines/base-writing-style.md).
- `fitness/` — judged Given/When/Then scenario sets per artifact type.
- `roles/` — role definitions (roles, accountabilities, competencies).
- generated skill renderings live at the agent's load point —
  `.claude/skills/` at the repository root — maintained by the
  [skill-rendering process](processes/skill-rendering.md); never edited
  by hand.
- `tools/` — the compilers and the lint
  ([`tools/lint_basis.py`](tools/lint_basis.py)).

## How definitions change

A definition changes only through its producing process, by the
owner's decision. Every change lands as a versioned entry in the
changed artifact's Document History — that section and the repository
history are the only records of how the corpus evolved; no separate
decision ledger exists, and no live document cites one.

## Checks

The whole tree lints with `tools/lint_basis.py`: frontmatter identity,
version and Document History presence, resolvable links, required
headings per type, banned vocabulary, and no numbered-decision
references.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-10 | update | Grew as the new-basis experiment index: walkthrough, numbered-decision ledger, approval state. |
| 2 | 2026-08-23 | update | Rewritten as the basis index by owner direction: the ledger practice is retired — decisions live as the changes they produced, recorded in each artifact's Document History; the walkthrough and ledger are removed (the repository history retains them). The `index` artifact type has no typedef yet — a filed gap. |
| 3 | 2026-08-23 | update | Research section added: reports live on the `research` branch, cited by branch and path. |
| 4 | 2026-08-23 | update | Research section removed by owner direction: research is registered in the typed research index on `main`, not in this index's prose. |
| 5 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
| 6 | 2026-09-02 | update | Owner's sweep per skill-rendering's second-home escalation: the skills/ entry re-formed — renderings live at the agent's load point (.claude/skills/), maintained by the skill-rendering process; basis/skills/ removed by its first run. |
