---
type: implementation-guidance
id: guidance-feat-artifact-tools-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-artifact-tools.md
feature: ../features/feat-artifact-tools.md
context: shopsystem-product
scenarios: ["@hash:928568f1acda", "@hash:92e0cea25506", "@hash:69bcf1b318fd", "@hash:d99fd67243d9", "@hash:7ca6f58466a8", "@hash:15fb1628e2ee", "@hash:8be406b70517"]
owner: lead-solutions-architect
created: 2026-09-09
updated: 2026-09-09
---

# Implementation guidance: feat-artifact-tools for shopsystem-product

For the seven scenarios of feat-artifact-tools assigned to
shopsystem-product — the lead shop itself — on 2026-09-09 under
init-artifact-tools (v3): `@hash:928568f1acda`, `@hash:92e0cea25506`,
`@hash:69bcf1b318fd`, `@hash:d99fd67243d9`, `@hash:7ca6f58466a8`,
`@hash:15fb1628e2ee`, `@hash:8be406b70517`. Lead shop's own tree: this
record names the definitions and tools to change. Historical record;
binds nothing after it.

## What changes

No contract, no cross-context flow. Guardrails: the appetite's two
no-gos (no typedef change beyond naming a part; no second home for a
calculated field); `tools-through-skills`.

1. **One new tool, with a skill at the load point:** read and write
   actions, cli and api, addressing an artifact by name and a
   caller-named "section" (read) or "part" (write), Contributors'
   own parameter names. Read returns only the named section; write
   applies the named part without restating the rest. Serves
   `@hash:928568f1acda`, `@hash:92e0cea25506`.
2. **Two render actions on the same tool**, read-only, computed fresh
   from the corpus on each call, never stored: a parent's children;
   what references an artifact. Serves `@hash:69bcf1b318fd`,
   `@hash:d99fd67243d9`.
3. **Two fill actions.** A scenario's `@hash:`: sha256 of its
   `Scenario:`/`Given`/`When`/`Then` lines, trimmed and newline-joined,
   first twelve hex digits — the convention already used by hand
   across the repository. A bead's initiative: read from the
   execution's anchor, which already carries it, written onto the bead
   through `bd comment` — `bd`'s only narrative-write action; `create`
   and `close` carry no initiative slot. Serves `@hash:7ca6f58466a8`,
   `@hash:15fb1628e2ee`.
4. **The router's skill gains one call** to the read action, naming a
   process's skill and the one step it needs, replacing a whole-skill
   load. Serves `@hash:8be406b70517`.
5. **Not in this assignment:** feat-initiative-cost-rollup (v9) states
   the same bead-carries-its-initiative fact, triggered at execution
   start, not by a role's ask; this fill action plausibly serves both,
   but that feature's assignment is separate.

## References

- Initiative init-artifact-tools (v3); feature feat-artifact-tools,
  the seven scenarios named above. Contracts: none exist.
- Principle `tools-through-skills`; glossary v26 (`execution`, `bead`,
  `anchor`); `basis/tools/descriptions/bd.json`.
- Touch-point, no conflict: feat-initiative-cost-rollup (v9). Every
  other feature read; none touches an artifact by part.

## What not to do

- Do not change an artifact typedef beyond naming a section or part:
  the appetite's first no-go.
- Do not give a rendered field (children, references) a stored home:
  the appetite's second no-go; render fresh every call.
- Do not let the router's call fall back to the whole skill on an
  unknown step: the designer's errors-guide-recovery criterion
  requires an error naming the skill and the step.
- Do not accept a caller-supplied hash or initiative value: both
  scenarios' Then bars a hand-typed value.
- Do not call the tool bypassing its skill: `tools-through-skills`.
- Do not add an initiative field to `bd`'s schema: use its `comment`
  action; `bd.json` fixes its four actions.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step; repository swept, one touch-point (feat-initiative-cost-rollup), no conflict. Self-check against implementation-guidance-fitness (v3): scenario 1 pass — each statement names a guardrail, principle, or definition/tool, none a context's internals; scenario 2 pass — every scenario cited by hash, no text reproduced; scenario 3 pass — the six actions and the one item outside this assignment are named; scenario 4 pass — each What-not-to-do entry names its reason; scenario 5 pass — initiative, feature, context, and all seven hashes named; scenario 6 pass — `wc -w` puts the document under the 600-word target. Status written; not sent. |
