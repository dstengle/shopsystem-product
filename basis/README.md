---
type: index
id: basis-index
owner: product-authority
status: approved
approved: 2026-08-23
version: 10
created: 2026-08-10
updated: 2026-09-05
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
- For a type whose typedef carries Writing rules and Fitness scenarios
  sections (the [artifact-typedef typedef](artifacts/artifact-typedef.md)
  §Required sections 6–7), its guideline and fitness set at those two
  paths are renderings of the typedef — marked `generated: true`,
  naming their `source` and its `source-digest` — produced by
  [`tools/compile_typedef.py`](tools/compile_typedef.py) and kept
  current by the typedef-rendering process
  (`processes/typedef-rendering.md`, pending); never edited by hand.
- `roles/` — role definitions (roles, accountabilities, competencies).
- generated skill renderings live at the agent's load point —
  `.claude/skills/` at the repository root — maintained by the
  [skill-rendering process](processes/skill-rendering.md); never edited
  by hand.
- `tools/` — the compilers (`compile_principles.py`,
  `compile_process.py`, `compile_role.py`, `compile_typedef.py`) and
  the lint ([`tools/lint_basis.py`](tools/lint_basis.py)).

## How definitions change

A definition changes only through its producing process, by the
owner's decision. Every change lands as a versioned entry in the
changed artifact's Document History — that section and the repository
history are the only records of how the corpus evolved; no separate
decision ledger exists, and no live document cites one.

## Checks

The whole tree lints with `tools/lint_basis.py`: frontmatter identity,
version and Document History presence (a file marked `generated: true`
— a produced guideline or fitness set among them — is exempt from
both, its typedef carrying its version and history), resolvable links,
required headings per type, banned vocabulary, and no
numbered-decision references. A produced guideline or fitness set is
checked against its typedef with `tools/compile_typedef.py <typedef>
--check`: a `missing` or `diverged` row names a text that is not
current; no row means both are. The same lint walks `requests/` at the repository root —
where a received ask's [request](artifacts/request.md) lives; the
directory may not exist yet — and checks each request's frontmatter
for what a received ask carries (`type: request`, identity, the
status and route vocabularies, the route's reason) and that its
`routed-to` link, when present, resolves before any `#` fragment
(the request's own path is accepted: the small-change lane's result
is the request's Result section by fragment). The lint also checks
briefs: it walks `briefs/` at the repository root and checks each
[decision brief](artifacts/decision-brief.md)'s frontmatter against
the typedef's closed field set and that every path under `relates-to`
resolves from the repository root; the same rules run on one brief
alone with `tools/lint_basis.py --brief <path>`. The exit is nonzero
on any violation.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-10 | update | Grew as the new-basis experiment index: walkthrough, numbered-decision ledger, approval state. |
| 2 | 2026-08-23 | update | Rewritten as the basis index by owner direction: the ledger practice is retired — decisions live as the changes they produced, recorded in each artifact's Document History; the walkthrough and ledger are removed (the repository history retains them). The `index` artifact type has no typedef yet — a filed gap. |
| 3 | 2026-08-23 | update | Research section added: reports live on the `research` branch, cited by branch and path. |
| 4 | 2026-08-23 | update | Research section removed by owner direction: research is registered in the typed research index on `main`, not in this index's prose. |
| 5 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
| 6 | 2026-09-02 | update | Owner's sweep per skill-rendering's second-home escalation: the skills/ entry re-formed — renderings live at the agent's load point (.claude/skills/), maintained by the skill-rendering process; basis/skills/ removed by its first run. |
| 7 | 2026-09-04 | update | Under init-request-routing / feat-request-routing on the authority's standing direction of 2026-09-04, per adr-2026-09-04-request-front-end: tools/lint_basis.py extended (its check 9) to walk requests/ at the repository root — absent until the first ask is recorded — and check each received request's frontmatter for the keys, status and route vocabularies the request typedef requires, and that routed-to resolves; §Checks names it. Checks 1–8 walk basis/ as before and the --derive-chain mode reads .claude/skills/ as before; no brief check added — the decision-brief change is the small-change lane's own example run. Made by the architect role. |
| 8 | 2026-09-04 | update | Under req-2026-09-04-brief-relates-to at the small-change process's make step: tools/lint_basis.py extended (its check 10) to walk briefs/ at the repository root and check each decision brief's frontmatter against the decision-brief typedef's closed field set — now admitting `relates-to` — and that every relates-to path resolves from the repository root, with a `--brief <path>` mode that runs the same rules on one brief; §Checks names both. Checks 1–9 and --derive-chain as before. Made by the lead-solutions-architect role. |
| 9 | 2026-09-04 | update | Lint check 9 resolves `routed-to` before its fragment — the small-change lane's result is the request's Result section by fragment, which the first run of request-intake wrote; found by that run under init-request-routing. |
| 10 | 2026-09-05 | update | Under init-typedef-rendering / feat-typedef-rendering (adr-2026-09-05-typedef-rendering): tools/compile_typedef.py added — it produces a type's guideline and fitness set from the Writing rules and Fitness scenarios sections of its typedef, at the paths the checks read, and its --check reports a text not current with the typedef; the guidelines/ and fitness/ entries say which texts are renderings and who keeps them current; §Checks names the compiler's check and records that lint check 7 (version and Document History) exempts a file marked `generated: true` — an exemption that stood since the versioning standard and now covers the produced guideline and fitness set, so no lint code changed. Checks 1–10, --brief, and --derive-chain as before. Made by the lead-solutions-architect role. |
