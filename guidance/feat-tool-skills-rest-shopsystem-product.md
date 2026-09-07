---
type: implementation-guidance
id: guidance-feat-tool-skills-rest-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-tool-skills.md
feature: ../features/feat-tool-skills-rest.md
context: shopsystem-product
scenarios: ["@hash:c648ef04449d", "@hash:6f6f93180b23", "@hash:f20a781be781", "@hash:802c8401fbc7", "@hash:a7657325c775", "@hash:f3c767a50e31", "@hash:5441feae9b88", "@hash:4d3e67a4f717", "@hash:d6d0e85cf003", "@hash:f87375439754", "@hash:8dfa9ca5923e", "@hash:62f7ccb607b9", "@hash:1177727e510a", "@hash:14a7607203db", "@hash:8a5b9a35a86a", "@hash:572bb00db7d9"]
owner: lead-solutions-architect
created: 2026-09-07
updated: 2026-09-07
---

# Implementation guidance: feat-tool-skills-rest for shopsystem-product

For the sixteen scenarios of feat-tool-skills-rest (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-07 under
init-tool-skills (v13): `@hash:c648ef04449d`, `@hash:6f6f93180b23`,
`@hash:f20a781be781`, `@hash:802c8401fbc7`, `@hash:a7657325c775`,
`@hash:f3c767a50e31`, `@hash:5441feae9b88`, `@hash:4d3e67a4f717`,
`@hash:d6d0e85cf003`, `@hash:f87375439754`, `@hash:8dfa9ca5923e`,
`@hash:62f7ccb607b9`, `@hash:1177727e510a`, `@hash:14a7607203db`,
`@hash:8a5b9a35a86a`, `@hash:572bb00db7d9`. The context is the lead
shop building its own definitions and tools, so this record names the
definitions and tools to change. It is a historical record of this
assignment and binds nothing after it.

## What changes

Contracts between contexts: none exist on this branch, so none is
versioned. The shape every answer and every description is read
against is the tool-description data type (v2, approved) — the
contract artifact the guardrail names, not a contract of any Bounded
Context's. Guardrail: one binds — adr-2026-09-07-tool-answer (v3,
checked), whose §2 is the decision, §3 the consequences and the bound
on Bounded Context shops, §4 the review triggers; its parts are read
onto the scenarios as constraints (1)–(9) in the feature's
Contributors section, which this record does not restate. The working
principle set compiled into every session (v11, `tools-through-skills`)
and the architecture principle set (v6) apply. Cross-context flow:
none; the owners of the six external tools are reached by no contract,
and the relationship kind while a tool does not answer is conformist
(constraint (7)).

Pre-state observed 2026-09-07 by running each tool on the flag alone,
not by reading any: the lint answers (exit 0, parses; its skill stands
at the load point, produced by `basis/tools/compile_tool.py`); of the
five compilers, none answers — `compile_tool.py` a usage sheet (exit
1), `compile_principles.py` a traceback (exit 1), `compile_process.py`
the flag read as a file path (exit 1), `compile_role.py` and
`compile_typedef.py` a usage sheet (exit 2) — so `@hash:c648ef04449d`'s
Then is unmet on each; the six external tools each reject the flag
without performing a use (`bd`, `agent-vault`: unknown flag, exit 1;
`shop-msg`, `bc-emit`, `shop-templates`: a command required, exit 2;
`shop-knowledge`: unknown subcommand, exit 2), so constraint (9)'s
finding is not raised today; `basis/tools/descriptions/` does not
exist; skill-rendering (v8) reads two source kinds, and a load-point
skill whose `source:` is a file under the descriptions home would fall
to its `no-answer` row today (the feature's Edges row on it). The
changes, in the order the guardrail and the definitions' own rules
require (the answers, then the producer's second source, then the
descriptions and their gaps, then the check, then the proof):

1. **The five compilers gain the flag's handler** —
   `basis/tools/compile_principles.py`, `compile_typedef.py`,
   `compile_process.py`, `compile_role.py`, and `compile_tool.py`, the
   producer among them with no special case. What must hold is §2's
   flag behaviour and constraint (1): the answer written to standard
   output with exit 0 before any other action, whatever the tool's
   parser would do with the remaining arguments, parsing against the
   data type (v2), each tool's `name` unique among the twelve. The
   uses each answer states are the answer's to decide, with every use
   a process definition's step or a load-point skill names for the
   tool checked present in it — found by searching `basis/processes/`
   and `.claude/skills/` for the tool's name: for `compile_process.py`,
   the definition alone and `--skill <path>` (skill-rendering); for
   `compile_typedef.py`, `--guideline`/`--fitness` and `--check`
   (typedef-rendering); for `compile_role.py`, the definition alone,
   `--agent <out>`, and `--check` with `--roles` and `--findings`
   (role-rendering); for `compile_principles.py`, the invocation
   principle-set-authoring names; for `compile_tool.py`, `<tool>` and
   `<tool> --load-point <dir>` (skill-rendering v8). Standard library
   only (constraint (5)); the schema block's reading through PyYAML is
   the shop's existing stack, nothing added (the Edges row on it).
   Serves `@hash:c648ef04449d` (read once per compiler),
   `@hash:f20a781be781`, `@hash:4d3e67a4f717`.

2. **The producer gains its second source, the description file.**
   `basis/tools/compile_tool.py` reads, beside a tool's answer, a
   description at `basis/tools/descriptions/<name>.json` — the home the
   data type (v2) names — as an instance of the same shape: the same
   schema block and the same validation, `stands_beside` and
   `tool_owner` required of that kind (constraint (2)). The skill is
   produced from the file's bytes and nothing else, its provenance
   naming the file as `source:` and, beside it, the tool the file
   stands beside, its `source-digest:` over the file's bytes
   (constraint (3)). A description lacking a part yields no skill and a
   report that names the tool and the part by the field name the data
   type fixes, with a stable code from the type's closed set beside the
   explanation and the next step, never in place of them (the
   designer's (d)); every failure the producer can meet on a
   description or an answer is in the producer's own answer, so its own
   skill names it. The producer's own skill is produced by the same
   invocation as any tool's, run on itself, and placed at the load
   point. Serves `@hash:6f6f93180b23` (read once per compiler),
   `@hash:f20a781be781`, `@hash:a7657325c775`, `@hash:f3c767a50e31`,
   `@hash:4d3e67a4f717`, `@hash:d6d0e85cf003`, `@hash:f87375439754`.

3. **Six descriptions, one per external tool**, at the home of item
   2, each `name` unique among the twelve: written from what the tool
   shows whoever runs it — its help, its behaviour when run — and never
   from its source (constraint (7)); `stands_beside` carrying the
   invocation the check makes, the executable as invoked (`bd`,
   `shop-msg`, `shop-knowledge`, `agent-vault`, `bc-emit`,
   `shop-templates`); `tool_owner` the shop the tool's provenance
   names, read and not guessed — where none can be named, the feature's
   Edges row on it carries the PO role's proposed default, unruled by
   the PM role at this assignment: the description says so, the lead
   shop holds the gap as its own, and `@hash:802c8401fbc7`'s Then is
   reported unmet for that tool, not resolved by a guess. Uses, as the
   check ruled (the feature's Contributors section, "for each use it
   supports"): at least every use a shop definition or a load-point
   skill names — for `bd`, `create`, `close`, `comment`, `dolt`; for
   `shop-msg`, `send`, `consume`, `vehicle-for` (a use the freeze bars
   is described, not run); for `shop-knowledge`, `validate`, `schema`;
   for `bc-emit`, `work-done` — and every use the shop runs by hand,
   which for `agent-vault` and `shop-templates`, named by no
   definition, is what the shop's session records show run. Serves
   `@hash:802c8401fbc7` (read once per tool), `@hash:f3c767a50e31`,
   `@hash:4d3e67a4f717`.

4. **Six gap records, one per external tool**, in the form the check
   ruled (constraint (8)): one request record each under the request
   typedef (v3) at `requests/`, its frontmatter the typedef's closed
   set — `route: awaiting`, `originator` this role, `arose-in` this
   delivery — and the owning shop named as addressee in the body, the
   closed set admitting no addressee field; the body's first line what
   happened and, as its one action, what answering takes — `--describe`
   answered in the data type (v2)'s shape, and where the type is
   published (the designer's (e)). Opened when the tool's description
   is written; held, not routed, not sent, while the shop is frozen;
   closing on one event only, item 5's check observing the answer; no
   work item unless the lane asks one. The lint's check 9 reads the
   frontmatter. Serves `@hash:5441feae9b88` (read once per tool),
   `@hash:62f7ccb607b9`.

5. **The check over the load point recognizes the third source kind**
   — the amendment to skill-rendering (v8,
   `basis/processes/skill-rendering.md`) that its own v8 entry raises
   to the process owner, the product authority; taken by the same
   default as at v8, one load point having one check, and raised to
   the owner with the amended definition's entry. What must hold
   (constraints (4) and (9); §3's fourth consequence): the definition's
   data names the descriptions home as `tools` names the tools
   directory; `check` reads a load-point skill whose `source:` is a
   file at that home by that kind — each run re-produces from every
   description to scratch through the producer, diffs, and reports a
   difference naming the tool — and asks the tool each description
   stands beside with the flag alone and nothing else, an answer there
   a finding of a second home that `reconcile` resolves by producing
   the skill from the answer and retiring the description, never by
   editing either; `unrecognized` reserved for a source of none of the
   three kinds; no exemption, no skip list; a tool observed performing
   a use when asked is a finding to this role, its asking suspended
   for that tool. Order fixed by the process-definition typedef v7's
   commitment: item 2 lands in the tree before the amended definition
   is approved (the lint's `--process` use checks it); the approved
   definition is then re-rendered by
   `python3 basis/tools/compile_process.py basis/processes/skill-rendering.md --skill .claude/skills/skill-rendering/SKILL.md`
   under skill-rendering, and feat-skills-availability's seven
   scenarios and feat-tool-skills' clean pass hold as today. Serves
   `@hash:8dfa9ca5923e`, `@hash:d6d0e85cf003`, `@hash:f87375439754`,
   `@hash:62f7ccb607b9`, `@hash:1177727e510a`.

6. **The proof at the load point.** With items 1–5 standing, the
   eleven skills are placed by
   `python3 basis/tools/compile_tool.py <tool or description> --load-point .claude/skills`
   and the check of item 5 runs clean — twelve tool skills current,
   every approved process's skill current, no row unrecognized, no
   `no-answer` row. Then agents in fresh contexts, each with the
   twelve tool skills at the load point and no other source on any
   tool (constraint (6)): per tool at least one use the skill states —
   for a tool whose uses the freeze bars, a use it allows, or
   "hypothesis" for that tool, which of the two the PM role reads with
   the measure; at least once on a description-produced skill; and one
   run that fails, its reading taken from the skill alone. Invocations,
   returns, and readings are recorded in the feature's delivery (the
   designer's (a)–(c)). Serves `@hash:14a7607203db`,
   `@hash:8a5b9a35a86a`, `@hash:572bb00db7d9`.

7. **Done means** (`delivery-verified`): the five flags observed
   answering — exit 0 and a parse against the data type (v2), both
   together; the twelve skills byte-equal to a fresh production; the
   check of item 5 clean; `python3 basis/tools/lint_basis.py` clean on
   the tree, the six requests of item 4 among what it reads; the agent
   runs of item 6 recorded, "hypothesis" written per tool where an
   observation is missing; the six gaps standing `awaiting`; and two
   readings this role makes at the delivery and records in
   adr-2026-09-07-tool-answer's history — each external tool's
   relationship kind (conformist while it does not answer) and the
   record's fifth review trigger (six descriptions against six
   answering tools: not fired). The measure, 6 of 12, is the PM role's
   to read. This is what the reconcile-and-close process (v4) reads
   when the work returns.

8. **Not in this assignment**, each named so the shop does not reach
   for it: whether `--help` also answers as help (the scope call stands
   with the PM role, the feature's Edges table); a gap's reaching its
   owner, or any message sent (the freeze; the dispatch step barred,
   work item lead-ki66p); the conformance screen of the four interfaces
   and the `cli` type's WCAG2ICT applicability record (the designer
   role's, at the delivery); a check over a description's drift from
   its tool (none reaches it until the tool answers — the Edges row);
   a Bounded Context shop's tool (none exists on this branch).

## References

- Initiative: init-tool-skills (v13, active), its Decomposition
  (none), its Appetite's two no-gos, and its Document History v2 and
  v11 (the authority's standing direction). Feature:
  feat-tool-skills-rest (v5, checked at assignment), the designer's
  criteria (a)–(e), the solutions architect role's constraints (1)–(9),
  and the Edges table as its own record; the sixteen scenarios cited
  by hash in the opening paragraph.
- Design decisions: adr-2026-09-07-tool-answer (v3, checked; §2 the
  decision and its parts, §2.1 the principles screen, §3 the
  consequences and the bound on Bounded Context shops, §4 the review
  triggers); pdr-2026-09-07-bet-tool-skills (v3, the bet);
  adr-2026-09-05-typedef-rendering (v4) and adr-2026-09-03-role-rendering
  (v5), the generate-then-gate precedents.
- Contracts: none exist on this branch. The tool-description data type
  (v2, approved) is the shape every answer and every description is
  read against.
- Definitions, at the versions read: data-type typedef v3;
  process-definition typedef v7; request typedef v3; skill-rendering
  v8; reconcile-and-close v4; interaction-conformance-check v4 (draft);
  the working principle set v11; the architecture principle set v6;
  the glossary v23 (framework tool, skill, gap); the feature typedef
  v12; the vocabulary (v6) and patterns (v4) records.
- Tools, by path: the six under `basis/tools/`; the six external tools
  by the invocation the check makes — `bd`, `shop-msg`,
  `shop-knowledge`, `agent-vault`, `bc-emit`, `shop-templates`.
- Touch-points in the repository, none a conflict: feat-tool-skills
  (v8, assigned, delivered) `@hash:5d004d52d1b4` — reads of any tool
  that answers and is not specified again — and `@hash:d33276bcc8ba`,
  the clean pass with the lint's skill, which `@hash:1177727e510a`'s
  Given includes; feat-skills-availability (v8) `@hash:4899d4bba6ad`
  and `@hash:26f78a3ca4a6`, the load-point check item 5 extends by one
  source kind and leaves otherwise as it is; feat-request-routing (v8)
  `@hash:eec1236a2a09` and `@hash:57f41d5f9f17`, the form item 4's
  records take — an ask arising inside a run, recorded and awaiting
  its route.
- The previous record of this type for the same context:
  guidance/feat-tool-skills-shopsystem-product.md (v1).

## What not to do

- Do not read a compiler's or an external tool's source to write its
  answer or its description: a description is written from what the
  tool shows whoever runs it (constraint (7); the Appetite's second
  no-go; `knowable-shape`).
- Do not give a description a relaxed schema, a per-tool variant, or a
  home other than the one the data type names: the type is the shape's
  one home (constraint (2); `single-source-of-truth`).
- Do not let a description stand as a skill's source once the check
  observes its tool answering: a second home is the finding §3's
  fourth consequence names, resolved toward the answer (constraint (4);
  `bidirectional-conformance`).
- Do not edit a produced skill, and do not repair drift found in use
  in the skill: the description is the source and the next production
  overwrites the skill (constraint (3); the guardrail's digest gate).
- Do not decide "current with" from a copy of an answer or a
  description kept since the last production, or from the program's
  source: the check re-asks and re-produces each run (constraint (3)).
- Do not pass the load-point check by an exemption, a skip list, or a
  hand-marked exception, and do not leave `unrecognized` or
  `no-answer` to cover a description-sourced skill: the scenario asks
  the check to report the skill current, which an exemption cannot
  (constraint (4); `bidirectional-conformance`).
- Do not invoke an external tool in the check for anything but the
  flag alone, and do not run a use the freeze bars to make the proof:
  a tool that cannot answer promises nothing about what it does when
  asked (constraint (9); the primer's freeze).
- Do not guess a tool's owner, and do not name the lead shop as owner
  to fill the field: the description is the lead shop's record about
  another shop's tool, and an owner not named is the Then unmet,
  reported (constraint (7); the Edges row's default, the PM role's to
  rule).
- Do not close a gap by hand, on a change to the description, or on a
  skill written around the tool, and do not route or send a gap
  record: the gap closes on the answer alone, and the shop is frozen
  (constraint (8); `tools-through-skills`; the dispatch step barred,
  work item lead-ki66p).
- Do not add a frontmatter field to a gap record for its addressee:
  the request typedef (v3)'s field set is closed and the lint's check 9
  reads it.
- Do not approve the amended skill-rendering definition before the
  producer reads descriptions in the tree: a definition whose step
  needs what the repository lacks is not approved (the
  process-definition typedef v7's commitment).
- Do not let a compiler perform a use when asked the flag, and do not
  treat a traceback, a usage sheet, the flag read as a path, or a
  nonzero exit as an answer: §2's flag behaviour (constraint (1)).
- Do not add a dependency outside the standard library, a vendor, or a
  recurring cost to answer the flag or to produce a skill: the
  guardrail's JSON bound (constraint (5)); the cost threshold is unset,
  so any such addition escalates to the authority before it is made.
- Do not give the proof's agent the answer, the description, the data
  type, the source, or the help beside the skill: a use completed by
  reading any of them is a skill that does not suffice (constraint (6);
  the designer's (a); `local-comprehension`).
- Do not count the measure met, or write "usable" without
  "hypothesis" for a tool whose observation is missing:
  `evidence-not-opinion`; `delivery-verified`; the Edges row on the
  hypothesis.
- Do not make `--help` answer as help, and do not extend the flag, the
  shape, or the check to a Bounded Context shop's tool: the scope call
  stands undecided with the PM role (the Edges table); the guardrail's
  bound on such shops stands in §3 and needs no scenario, and no
  Bounded Context exists on this branch (the Decomposition;
  `contracts-between-contexts`).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Written by the lead-solutions-architect role at the scenario-assignment process (v12) assign step for the sixteen scenarios of feat-tool-skills-rest assigned to shopsystem-product, from the implementation-guidance guideline (v1); the third record of its type. Pre-state observed by running each of the twelve tools on the flag alone (the lint answers; the five compilers cannot; the six external tools reject the flag without performing a use), not by reading any. Maker's self-check against the implementation-guidance fitness set (v1): scenario 1 (the architect's level) pass — each of the eight items in What changes names a lead-shop tool by path, a definition by id and version, a process step by id, a record's home by path, or the guardrail's section, and none names a Bounded Context's internals (none exists); how each compiler composes its answer, how the producer validates a file, and how the check's loop is written are left to the maker within the bound; scenario 2 (cited, never restated) pass — every scenario cited by hash only, the guardrail by id, version, and section, the data type by id and version, the definitions by id and version, and no scenario text, constraint text, contract clause, or schema field list reproduced (the shape's parts are pointed at as the data type's, the two fields of a description by their names alone); scenario 3 (actionable alone) pass — every tool and definition to change is named with its path or version, the producing invocation and the re-render invocation given, the descriptions' home and the gap records' form and lane fixed, the minimum uses per external tool listed from the definitions that name them, the order between the items fixed with its reason, the one choice left to another owner (the amendment's default) named with what must hold either way, the one open datum (an owner that cannot be named) given the default that stands and what to report, and what is not in this assignment named as such; scenario 4 (reasons) pass — each of the sixteen entries in What not to do names the guardrail's section, a constraint, a principle, a typedef's commitment, the Appetite's no-go, the freeze, or the decomposition as its reason; scenario 5 (one assignment) pass — the frontmatter and the opening paragraph name the initiative, the feature, the context, and the sixteen hashes, and every statement is about those scenarios, item 8 and the last entry of What not to do saying what is not in this assignment rather than binding a later one. Status written; not sent. |
