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
updated: 2026-09-08
---

# Implementation guidance: feat-tool-skills-rest for shopsystem-product

For the sixteen scenarios of feat-tool-skills-rest (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-07 under
init-tool-skills (v13); hashes per the frontmatter's `scenarios` list.
The previous record of this type: guidance/feat-tool-skills-shopsystem-product.md.
Historical record; binds nothing after it.

## What changes

Guardrail: adr-2026-09-07-tool-answer (v3, checked, §2–§4, constraints
(1)–(9) in the feature's Contributors, not restated here). Shape: the
tool-description type (v2, approved). No contract; six external
tools' owners reached by none, relationship conformist while a tool
does not answer (constraint 7).

1. **Five compilers gain the flag's handler** (`compile_principles.py`,
   `compile_typedef.py`, `compile_process.py`, `compile_role.py`,
   `compile_tool.py`): answer to standard output, exit 0 before any
   other action, parses against the type, each `name` unique among
   twelve; every use a definition or skill names for the tool present.
   Standard library only.
2. **The producer gains its second source**, a description at
   `basis/tools/descriptions/<name>.json` (the type's named home): same
   schema and validation, `stands_beside`/`tool_owner` required; skill
   produced from the file's bytes alone, `source`/`source-digest` over
   it. A missing part yields no skill and a report naming tool, part,
   and a stable code. The producer's own skill is produced the same
   way, on itself.
3. **Six descriptions, one per external tool**, at that home: written
   from what the tool shows when run, never its source; `stands_beside`
   the invocation the check makes; `tool_owner` read, not guessed —
   where none can be named, the Edges default applies and the Then
   reports unmet, not resolved by guess; uses at least what a
   definition or skill names.
4. **Six gap records**, one per tool, under the request typedef (v3):
   `route: awaiting`, this role `originator`, owner named in the body;
   opened when the description is written, held while frozen, closing
   only when item 5's check observes the tool answering.
5. **Load-point check recognizes the third source kind** — amend
   skill-rendering (raised to the process owner): re-produces from
   each description, diffs, reports a difference; an answering tool is
   resolved toward the answer via `reconcile`, never by editing either.
   Item 2 lands before the amended definition is approved. Re-render
   via `compile_process.py`.
6. **Proof at the load point:** with items 1–5 standing, twelve skills
   placed via `compile_tool.py <tool|description> --load-point .claude/skills`,
   the check clean; agents in fresh contexts, each tool at least one
   use (or "hypothesis" where the freeze bars it), at least once on a
   description-produced skill, one run failing, recorded.
7. **Not in this assignment:** `--help` as help (PM's scope call); a
   gap reaching its owner or any message sent (the freeze); the
   designer's conformance screen; a description-drift check (none
   until the tool answers); a Bounded Context shop's tool (none
   exists).
8. **Done:** five flags answering; twelve skills byte-equal; the check
   clean; `lint_basis.py` clean, the six requests among what it reads;
   agent runs recorded, "hypothesis" per tool where missing; six gaps
   `awaiting`; two readings recorded in the guardrail's history
   (relationship kind; the fifth review trigger, not fired). Measure
   6 of 12, the PM's to read.

## References

- Initiative: init-tool-skills (v13, active). Feature:
  feat-tool-skills-rest (v5, checked), the designer's criteria (a)–(e),
  constraints (1)–(9); scenarios per the frontmatter list.
- Decisions: adr-2026-09-07-tool-answer (v3, checked, §2–§4);
  pdr-2026-09-07-bet-tool-skills (v3); adr-2026-09-05-typedef-rendering
  (v4), adr-2026-09-03-role-rendering (v5).
- Contracts: none exist on this branch; the tool-description type (v2)
  is the shape every answer and description is read against.
- Definitions read: data-type typedef v3; process-definition typedef
  v7; request typedef v3; skill-rendering v8; reconcile-and-close v4;
  interaction-conformance-check v4 (draft); working principle set v11;
  architecture principle set v6; glossary v23; feature typedef v12;
  vocabulary v6; patterns v4.
- Tools: the six under `basis/tools/`; the six external —`bd`,
  `shop-msg`, `shop-knowledge`, `agent-vault`, `bc-emit`,
  `shop-templates`.
- Touch-points: feat-tool-skills (v8, delivered) `@hash:5d004d52d1b4`,
  `@hash:d33276bcc8ba`; feat-skills-availability (v8)
  `@hash:4899d4bba6ad`, `@hash:26f78a3ca4a6`; feat-request-routing (v8)
  `@hash:eec1236a2a09`, `@hash:57f41d5f9f17` — none a conflict.

## What not to do

- Do not read a tool's source to write its answer or description
  (`knowable-shape`; the Appetite's second no-go).
- Do not give a description a relaxed schema or a home outside the
  type's (`single-source-of-truth`).
- Do not let a description stand as source once its tool is observed
  answering: resolve toward the answer (`bidirectional-conformance`).
- Do not edit a produced skill, or repair drift found in use.
- Do not decide "current" from a kept copy or the source; re-ask and
  re-produce.
- Do not pass the check by exemption, or leave `unrecognized`/
  `no-answer` to cover a description-sourced skill.
- Do not invoke an external tool for anything but the flag, or run a
  use the freeze bars.
- Do not guess a tool's owner, or name the lead shop to fill the field.
- Do not close a gap by hand or on a description change, or route/send
  one while frozen (`tools-through-skills`).
- Do not add a frontmatter field to a gap record: the request typedef's
  set is closed.
- Do not approve the amended definition before the producer reads
  descriptions in the tree.
- Do not let a compiler perform a use when asked the flag.
- Do not add a dependency outside the standard library, a vendor, or a
  recurring cost without escalating first.
- Do not give the proof's agent the answer, description, type, source,
  or help beside the skill (`local-comprehension`).
- Do not count the measure met for a tool whose observation is missing
  (`evidence-not-opinion`).
- Do not make `--help` answer as help, or extend the flag/check to a
  Bounded Context shop's tool: none exists
  (`contracts-between-contexts`).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step for the sixteen scenarios assigned to shopsystem-product; pre-state observed by running each of the twelve tools on the flag. Self-check v1: all five fitness scenarios pass. Status written; not sent. |
| 2 | 2026-09-08 | update | Rewritten to the plain-voice rule under feat-plain-voice-rest (`@hash:8b1d5c3f9e26`): prose cut to what the rules require, v1 condensed, References unchanged in substance. Self-check v2: scenarios 1–5 hold; scenario 6 evaluated against the 600-word target. Made by the lead-solutions-architect role. |
