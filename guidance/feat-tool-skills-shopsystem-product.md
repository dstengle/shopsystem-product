---
type: implementation-guidance
id: guidance-feat-tool-skills-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-tool-skills.md
feature: ../features/feat-tool-skills.md
context: shopsystem-product
scenarios: ["@hash:debc381f2c7e", "@hash:a32ca18f8bd7", "@hash:1bf0cead0957", "@hash:c51b20dd4cd9", "@hash:80ac83f71c06", "@hash:5d004d52d1b4", "@hash:d33276bcc8ba", "@hash:c3bde3a9b657", "@hash:59116a209cb2", "@hash:0ca7705b8397"]
owner: lead-solutions-architect
created: 2026-09-07
updated: 2026-09-07
---

# Implementation guidance: feat-tool-skills for shopsystem-product

For the ten scenarios of feat-tool-skills (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-07 under
init-tool-skills (v10): `@hash:debc381f2c7e`, `@hash:a32ca18f8bd7`,
`@hash:1bf0cead0957`, `@hash:c51b20dd4cd9`, `@hash:80ac83f71c06`,
`@hash:5d004d52d1b4`, `@hash:d33276bcc8ba`, `@hash:c3bde3a9b657`,
`@hash:59116a209cb2`, `@hash:0ca7705b8397`. The context is the lead
shop building its own definitions and tools, so this record names the
definitions and tools to change. It is a historical record of this
assignment and binds nothing after it.

## What changes

Contracts: none exist on this branch, so none is versioned. Guardrail:
one binds — adr-2026-09-07-tool-answer (v3, checked), whose §2 is the
decision, §3 the consequences and the bound on Bounded Context shops,
and whose bound reaches the lead shop's own tools; its parts are read
onto the scenarios as constraints (1)–(6) in the feature's Contributors
section, which this record does not restate. The working principle set
compiled into every session (v11, `tools-through-skills`) and the
architecture principle set (v6) apply. Cross-context flow: none. The
changes, in the order the guardrail and the definitions' own rules
require (the contract's home, then the answer, then the producer, then
the check, then the proof):

1. **One data type, new, at `basis/types/tool-description.md`** under
   the data-type typedef (v3) — the contract artifact adr-2026-09-07-tool-answer
   §2 names, written under that record and approved through the
   definition chain. It fixes what §2 lists for it — the flag's name,
   the shape's field names, the closed set of failure codes, the
   relationship kind — and names the home of a beside-description; its
   field names are screened by the product designer role and entered in
   the vocabulary (`basis/experience/vocabulary.md`, v4 at this
   assignment) as that role's action. Bound on this delivery: the type
   stands approved before any check reads an answer against it
   (constraint (2)); until it does, `@hash:a32ca18f8bd7` is pending its
   definition, not failed (the feature's Edges table). The type's
   approval is the enabler this role recommended into the PO role's
   backlog at the add-constraints step; it is inside this assignment's
   order, not beside it. Serves `@hash:debc381f2c7e`,
   `@hash:a32ca18f8bd7`, `@hash:c51b20dd4cd9`.

2. **The lint, `basis/tools/lint_basis.py`, gains the flag's handler.**
   Pre-state observed 2026-09-07 by running, not reading:
   `python3 basis/tools/lint_basis.py --describe` runs the lint's
   normal function (`PASS: 0 violation(s)`, exit 0) — "cannot answer"
   under §2, and `@hash:debc381f2c7e`'s Then unmet. What must hold is
   §2's flag behaviour and constraint (1): the answer written before
   any other action, other arguments ignored, exit 0, parsing against
   the type of item 1; the uses it states are the answer's to decide,
   with the three the definitions name — the run over the basis,
   `--derive-chain <artifact_type>`, `--process <path>` — checked
   present in it (the initiative's Document History v3, U4). How the
   lint composes its answer is the maker's within the bound, in the
   standard library only (constraint (5)). Serves `@hash:debc381f2c7e`,
   `@hash:a32ca18f8bd7`.

3. **One compiler, new, `basis/tools/compile_tool.py`**, beside the
   four under `basis/tools/`, on the `compile_process.py` pattern
   (adr-2026-09-05-typedef-rendering v4 and adr-2026-09-03-role-rendering
   v5 the precedents; the initiative's Document History v3, U3): it asks
   the tool by the flag, and from the answer and nothing else writes
   the skill at the load point, `.claude/skills/<name>/SKILL.md`, in
   the format the harness activates — the frontmatter `description`
   composed to name the tool, its uses, and when to use it (the
   designer's criterion (c); the initiative's Document History v5, U2
   default), the body one entry per use with the five parts
   `@hash:c51b20dd4cd9` names — stamped `source:` the tool's path and
   `source-digest:` `sha256:` plus twelve hex digits over the answer's
   bytes as written (§2's digest gate). This is "the process that keeps
   tool skills current" in its producing half. The compiler is itself a
   framework tool under §3's first consequence; its own answer and skill
   are the second feature's, not a scenario here. Serves
   `@hash:1bf0cead0957`, `@hash:c51b20dd4cd9`, `@hash:80ac83f71c06`.

4. **The check over tool skills and the load-point check's
   recognition** — the process owner's choice between amending
   skill-rendering (v7, `basis/processes/skill-rendering.md`) and
   defining a sibling process for tool skills under the
   process-definition typedef (v7); the owner is the product authority,
   and the choice is raised to it, not made here. What must hold either
   way (constraint (4); §3's third consequence): the `check` step reads
   a skill whose `source:` is a tool under `basis/tools/` by that source
   kind — re-asking the tool by the flag, re-digesting the fresh answer,
   and reporting a difference naming the tool — so that the lint's skill
   is reported current and nothing at the load point is `unrecognized`;
   reconciliation of a not-current tool skill is a re-run of item 3 over
   it. Order fixed by the process-definition typedef v7's commitment: a
   definition whose step names `compile_tool.py` is not approved while
   the repository lacks it (the lint's check 11 and its `--process`
   use), so item 3 lands in the tree before the amended or new
   definition is approved; the approved definition is then re-rendered
   to its skill by
   `python3 basis/tools/compile_process.py <definition> --skill .claude/skills/<name>/SKILL.md`
   under skill-rendering, and feat-skills-availability's seven scenarios
   pass as they do today. Serves `@hash:80ac83f71c06`,
   `@hash:5d004d52d1b4`, `@hash:d33276bcc8ba`.

5. **The proof at the load point.** With items 1–4 standing, the lint's
   skill is placed by item 3 and the load-point check of item 4 runs
   clean; then one agent in a fresh context — the skill its only source
   on the lint, which excludes the answer, the type of item 1, the
   lint's source, and its help (constraint (6)) — is given a task
   calling for each use the skill states, and one run that fails; its
   invocations, returns, and its reading of the failure are recorded in
   the feature's delivery (the initiative's Document History v5, U1
   default). The invocation the skill states for a use is the use's
   command line as the answer gave it, whoever performs the step
   (`actor-neutral-discipline`). Serves `@hash:c3bde3a9b657`,
   `@hash:59116a209cb2`, `@hash:0ca7705b8397`.

6. **Done means** (`delivery-verified`): the lint's flag observed
   answering — exit status 0 and a parse against the approved type,
   both together; the skill at the load point byte-equal to a fresh
   run of item 3; the load-point check clean with no `unrecognized`
   row; `python3 basis/tools/lint_basis.py` clean on the tree; the
   agent run of item 5 recorded; and the delivery marked "hypothesis"
   until `@hash:59116a209cb2` and `@hash:0ca7705b8397` are observed —
   what the reconcile-and-close process (v4) reads when the work
   returns.

7. **Not in this assignment**, each named so the shop does not reach
   for it: the other ten tools' answers and skills and the six
   beside-descriptions (the initiative's Appetite, first no-go; the
   authority's standing direction on the proof's pass); whether `--help`
   also answers as help (the feature's Edges table: a scope call
   recommended to the PM role, undecided); the designer role's
   conformance screen of the delivered skill and answer, including the
   WCAG2ICT applicability record for the answer (interaction-conformance-check
   v4 stands `draft` at this assignment — the designer's step, not a
   scenario); the vocabulary's tool terms (the designer's action, the
   initiative's Document History v5, R2); the measure's denominator (the
   PM role's).

## References

- Initiative: init-tool-skills (v10, active), its Decomposition (none)
  and Appetite. Feature: feat-tool-skills (v5, checked at assignment),
  the designer's criteria (a)–(c), the solutions architect role's
  constraints (1)–(6), and the Edges table as its own record; scenarios
  `@hash:debc381f2c7e`, `@hash:a32ca18f8bd7`, `@hash:1bf0cead0957`,
  `@hash:c51b20dd4cd9`, `@hash:80ac83f71c06`, `@hash:5d004d52d1b4`,
  `@hash:d33276bcc8ba`, `@hash:c3bde3a9b657`, `@hash:59116a209cb2`,
  `@hash:0ca7705b8397`.
- Design decisions: adr-2026-09-07-tool-answer (v3, checked; §2 the
  decision and its parts, §2.1 the principles screen, §3 the
  consequences and the bound on Bounded Context shops);
  adr-2026-09-05-typedef-rendering (v4) and adr-2026-09-03-role-rendering
  (v5), the generate-then-gate precedents; pdr-2026-09-07-bet-tool-skills
  (v3, the bet). The research the decision rests on:
  tool-self-description-2026-09 (v3), registered in
  `research/index.md` (v9), body on the research branch — read as the
  authority's evidence, not as authority.
- Contracts: none exist on this branch. The tool-description data type
  of item 1 is the contract the lint answers to once it stands.
- Definitions, at the versions read: data-type typedef v3;
  process-definition typedef v7; skill-rendering v7; reconcile-and-close
  v4; interaction-conformance-check v4 (draft); the working principle
  set v11; the architecture principle set v6; the glossary v23
  (framework tool, skill, gap); the feature typedef v12 and fitness set
  v8; the api (v3), cli (v3), and common (v3) experience guidelines; the
  vocabulary (v4) and patterns (v4) records.
- Tools, by path: `basis/tools/lint_basis.py`,
  `basis/tools/compile_process.py`; to be made, `basis/tools/compile_tool.py`.
- Touch-points in the repository: feat-skills-availability (v8)
  `@hash:4899d4bba6ad` (the clean pass) and `@hash:26f78a3ca4a6` (the
  reconcile of a hand-diverged render) — the load-point check that item
  4 extends by one source kind and leaves otherwise as it is;
  feat-typedef-rendering (v8), the same pattern on a typedef, no
  scenario shared.

## What not to do

- Do not produce the lint's skill from `--help`, from the lint's
  source, or by walking its parser: the answer is the skill's sole
  source (the guardrail's §2 sentence; its §1 declines each of the
  three; constraint (3); `knowable-shape`, `local-comprehension`).
- Do not hand-write or hand-edit `.claude/skills/<name>/SKILL.md` for
  the lint, and do not edit a process skill there either: a hand edit
  is drift the next production overwrites (§3's third consequence;
  constraint (3); `bidirectional-conformance`), and it is what
  `@hash:5d004d52d1b4` and `@hash:26f78a3ca4a6` exist to find.
- Do not make the load-point check pass the lint's skill by an
  exemption, a skip list, or a hand-marked exception: the scenario asks
  the check to report the skill current, which an exemption cannot
  (constraint (4); `bidirectional-conformance`).
- Do not decide "current with" from a copy of the answer kept since the
  last production, or from the lint's source: the check re-asks the
  tool (constraint (3); the guardrail's digest gate).
- Do not let the lint perform its normal function when asked the flag,
  and do not treat a traceback, a usage sheet, or a nonzero exit as an
  answer: §2's flag behaviour; constraint (1).
- Do not put the shape's parts in a per-tool variant or in prose the
  check interprets, and do not read an answer against the shape before
  the type of item 1 stands approved: the type is the shape's one home
  (`single-source-of-truth`; constraint (2); `define-good-up-front`).
- Do not add a dependency outside the standard library, a vendor, or a
  recurring cost to answer the flag or to produce the skill: the
  guardrail's JSON bound and constraint (5); the cost threshold is
  unset, so any such addition escalates to the authority before it is
  made.
- Do not approve a process definition whose step names
  `compile_tool.py` before that tool exists in the tree: the
  process-definition typedef v7's commitment; a tool a process needs and
  the repository lacks is a request, never built mid-process.
- Do not give the proof's agent the answer, the data type, the source,
  or the help beside the skill: a use completed by reading any of them
  is a skill that does not suffice (constraint (6); the designer's (b);
  `local-comprehension`).
- Do not count the measure met, or write "usable" without "hypothesis",
  before `@hash:59116a209cb2` and `@hash:0ca7705b8397` are observed:
  `evidence-not-opinion`; `delivery-verified`; the feature's Edges row
  on the hypothesis.
- Do not write beside-descriptions for the six external tools, or the
  other four owned tools' handlers and skills, under this assignment:
  the Appetite's first no-go; the second feature is authorized on the
  proof's pass, not before.
- Do not make `--help` answer as help under this assignment: the scope
  call is the PM role's and stands undecided (the feature's Edges
  table); a change to it here would be scope no bet covers.
- Do not extend the flag, the shape, or the check to a Bounded Context
  shop's tool here: the guardrail's bound on such shops stands in
  adr-2026-09-07-tool-answer §3 and needs no scenario; no Bounded
  Context exists on this branch (the Decomposition;
  `contracts-between-contexts`).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Written by the lead-solutions-architect role at the scenario-assignment process (v12) assign step for the ten scenarios of feat-tool-skills assigned to shopsystem-product, from the implementation-guidance guideline (v1); the second record of its type. Pre-state observed by running the lint on the flag (normal function, exit 0), not by reading it. Maker's self-check against the implementation-guidance fitness set (v1): scenario 1 (the architect's level) pass — each of the seven statements in What changes names a lead-shop definition by path and version, a tool by path, a process step by id, or the guardrail's section, and none names a Bounded Context's internals (none exists); how the lint composes its answer is left to the maker within the bound; scenario 2 (cited, never restated) pass — every scenario cited by hash only, the guardrail by id, version, and section, the definitions by id and version, and no scenario text, constraint text, contract clause, or shape field list reproduced (the shape's parts are pointed at as "what §2 lists for it" and "the five parts `@hash:c51b20dd4cd9` names"); scenario 3 (actionable alone) pass — every definition and tool to change is named with its version or path, the two compiler invocations and the lint's flag invocation given, the order between the five items fixed with its reason, the one choice left to another owner (amend or sibling) named with what must hold either way, and what is not in this assignment named as such, so the shop can begin with the scenarios beside it; scenario 4 (reasons) pass — each of the thirteen entries in What not to do names the guardrail's section, a constraint, a principle, a typedef's commitment, the Appetite's no-go, or the decomposition as its reason; scenario 5 (one assignment) pass — the frontmatter and the opening paragraph name the initiative, the feature, the context, and the ten hashes, and every statement is about those scenarios, item 7 and the last four entries of What not to do saying what is not in this assignment rather than binding a later one. Status written; not sent. |
