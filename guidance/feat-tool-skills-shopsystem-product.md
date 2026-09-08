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
updated: 2026-09-08
---

# Implementation guidance: feat-tool-skills for shopsystem-product

For the ten scenarios of feat-tool-skills (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-07 under
init-tool-skills (v10); hashes per the frontmatter's `scenarios` list.
Historical record; binds nothing after it.

## What changes

Guardrail: adr-2026-09-07-tool-answer (v3, checked, §2–§3, constraints
(1)–(6) in the feature's Contributors, not restated here). Order: the
contract, the answer, the producer, the check, the proof.

1. **New data type, `basis/types/tool-description.md`** (data-type
   typedef v3): the flag's name, the shape's fields, the closed set of
   failure codes, the relationship kind, per §2. Designer screens field
   names into the vocabulary. Approval gates any check reading an
   answer against it; until then `@hash:a32ca18f8bd7` is pending, not
   failed.
2. **`lint_basis.py` gains the flag's handler:** answer written first,
   exit 0, parses against the type; other arguments ignored; states
   the three uses the definitions name (the basis-wide run,
   `--derive-chain`, `--process`). Standard library only.
3. **New compiler, `compile_tool.py`** (the `compile_process.py`
   pattern): asks the tool by the flag, writes the skill at the load
   point from the answer alone, `description` naming tool/uses/when,
   body one entry per use, stamped `source`/`source-digest`. The
   compiler is itself a framework tool; its own skill is the next
   feature's.
4. **Load-point check gains recognition of the tool-answer source
   kind** — amend skill-rendering or a sibling definition (the
   process owner's choice, raised not made here): `check` re-asks the
   tool, re-digests, reports a difference naming it; item 3 lands
   before the amended definition is approved (typedef v7's commitment).
   Re-render via `compile_process.py`.
5. **Proof at the load point:** with items 1–4 standing, one agent in
   a fresh context — the skill its only source, excluding the answer,
   type, source, and help — completes each use the skill states, one
   run failing, recorded in the delivery.
6. **Not in this assignment:** the other ten tools' answers/skills and
   six beside-descriptions; whether `--help` also answers (PM's scope
   call); the designer's conformance screen; the vocabulary's tool
   terms; the measure's denominator.
7. **Done:** the flag observed answering; the skill byte-equal to a
   fresh run; the check clean, no `unrecognized`; `lint_basis.py`
   clean; the agent run recorded; delivery marked "hypothesis" until
   `@hash:59116a209cb2` and `@hash:0ca7705b8397` are observed.

## References

- Initiative: init-tool-skills (v10, active). Feature: feat-tool-skills
  (v5, checked), the designer's criteria (a)–(c), constraints (1)–(6);
  scenarios per the frontmatter list.
- Decisions: adr-2026-09-07-tool-answer (v3, checked); the
  generate-then-gate precedents adr-2026-09-05-typedef-rendering (v4),
  adr-2026-09-03-role-rendering (v5); pdr-2026-09-07-bet-tool-skills
  (v3). Research: tool-self-description-2026-09 (v3), evidence not
  authority.
- Contracts: none exist on this branch; the tool-description type of
  item 1 is the shape the lint answers to once it stands.
- Definitions read: data-type typedef v3; process-definition typedef
  v7; skill-rendering v7; reconcile-and-close v4;
  interaction-conformance-check v4 (draft); working principle set v11;
  architecture principle set v6; glossary v23; feature typedef v12
  (fitness v8); api/cli/common guidelines v3; vocabulary v4; patterns
  v4.
- Tools: `lint_basis.py`, `compile_process.py`; to be made,
  `compile_tool.py`.
- Touch-points: feat-skills-availability (v8) `@hash:4899d4bba6ad`,
  `@hash:26f78a3ca4a6`; feat-typedef-rendering (v8), same pattern, no
  scenario shared.

## What not to do

- Do not produce the skill from `--help`, the source, or by parsing:
  the answer is the sole source (`knowable-shape`; `local-comprehension`).
- Do not hand-write or hand-edit any produced `SKILL.md`: a hand edit
  is drift the next production overwrites (`bidirectional-conformance`).
- Do not pass the load-point check by exemption or skip list.
- Do not decide "current" from a kept copy or the source: re-ask the
  tool.
- Do not let the lint perform its normal function on the flag, or
  treat a traceback or nonzero exit as an answer.
- Do not put the shape in a per-tool variant, or read against it before
  the type is approved (`single-source-of-truth`).
- Do not add a dependency outside the standard library, a vendor, or a
  recurring cost without escalating first.
- Do not approve a definition naming `compile_tool.py` before the tool
  exists in the tree.
- Do not give the proof's agent the answer, type, source, or help
  beside the skill (`local-comprehension`).
- Do not count the measure met before both observations land
  (`evidence-not-opinion`).
- Do not write beside-descriptions or the other four tools' skills
  under this assignment: the Appetite's first no-go.
- Do not make `--help` answer as help here: undecided scope, the PM's.
- Do not extend the flag or check to a Bounded Context shop's tool:
  none exists (`contracts-between-contexts`).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step for the ten scenarios assigned to shopsystem-product; pre-state observed by running the lint on the flag. Self-check v1: all five fitness scenarios pass. Status written; not sent. |
| 2 | 2026-09-08 | update | Rewritten to the plain-voice rule under feat-plain-voice-rest (`@hash:8b1d5c3f9e26`): prose cut to what the rules require, v1 condensed, References unchanged in substance. Self-check v2: scenarios 1–5 hold; scenario 6 evaluated against the 600-word target. Made by the lead-solutions-architect role. |
