---
type: implementation-guidance
id: guidance-feat-process-runner-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-process-runner.md
feature: ../features/feat-process-runner.md
context: shopsystem-product
scenarios: ["@hash:7f991d005cc5", "@hash:21a0a96524fb", "@hash:dfb80114f737", "@hash:4353a5e45d00", "@hash:c32dd5b8b474", "@hash:6c3bd78771bc", "@hash:3a9dc4428ded", "@hash:c0234aab4a26", "@hash:6bcebb4e0073", "@hash:6c35e3f87cd0", "@hash:767b608029a3", "@hash:4d31a463c42e", "@hash:8f5b65dca426", "@hash:1809e3236eca", "@hash:28b4f5a6d5dc", "@hash:06a0e40f2325", "@hash:d2f51245aa9a", "@hash:fe0399304a46", "@hash:96124cdccf45"]
owner: lead-solutions-architect
created: 2026-09-07
updated: 2026-09-08
---

# Implementation guidance: feat-process-runner for shopsystem-product

For the nineteen scenarios of feat-process-runner (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-07 under
init-process-runner (v8); hashes per the frontmatter's `scenarios`
list. Historical record; binds nothing after it.

## What changes

Guardrail: adr-2026-09-07-coordinator-role (v3, checked, §2–§4). Order:
actor, its rendering, the return's form, the anchor, the proof.

1. **New role, `basis/roles/router.md`** under the role-definition
   typedef (v4): harness keys plus `model` at the smallest tier;
   Exclusive domain is the run's next step; Decisions owned names none.
   Body carries only run discipline: steps as written, non-zero exit
   held; a condition's value recorded, unreadable asked; an agent step
   launched with its declared inputs alone; a human step or ask held,
   never waited on; hold/answer/resume/cancel at the command line;
   restart from the anchor at each sub-process boundary. Form: cheap
   model until a run shows an agent can launch agent steps, then the
   launch tool joins `tools`.
2. **Render and glossary:**
   `compile_role.py basis/roles/router.md --agent .claude/agents/router.md`;
   `compile_role.py --check --findings` clean. Glossary gains `router`
   (role sense).
3. **`compile_process.py` change:** each agent-run step's rendered
   section names its declared outputs, beside the banned-words line.
   Then every approved definition re-renders via
   `compile_process.py <definition> --skill .claude/skills/<name>/SKILL.md`;
   skill-rendering's check clean.
4. **The anchor**, via the `bd` skill (create/comment/close): run state,
   current step, parameters, router's model, every step's yielded value,
   each ask's fields, the result, token count — enough for a router
   restarted from it alone to continue; an oversized value written as a
   path.
5. **The proof:** one approved process definition, all three step
   kinds, run end to end against a work item, the lead-pm at its own
   steps only, every human turn recorded with the router's turn before
   it.
6. **Not in this assignment:** a step's own rendering or how the
   harness loads a skill (after this work); the fabro target and its
   six annotations (held for migration review); a Bounded Context
   shop's processes (none exists); the designer's corpus entries.
7. **Done:** the role stands, `--check` clean, the compiler change
   lands with a clean skill-rendering pass, the anchor carries every
   field per run, and one process runs end to end with human turns
   recorded.

## References

- Initiative: init-process-runner (v8, active). Feature:
  feat-process-runner (v5, checked); scenarios per the frontmatter
  list.
- Decisions: adr-2026-09-07-coordinator-role (v3, checked); order
  order-2026-09-07-b (v3, §2).
- Contracts: none exist on this branch.
- Definitions read: role-definition typedef v4 (guideline v2, fitness
  v3); process-definition typedef v7; role-rendering v7;
  skill-rendering v9; the `ask` type v2; glossary v24; working
  principle set v11; architecture principle set v6.
- Tools: `compile_role.py`, `compile_process.py`, `bd`, `lint_basis.py`.
- Touch-points: feat-roles-availability (v6) `@hash:ce98da2b6467`,
  `@hash:219547cc8cb5`; feat-skills-availability (v8)
  `@hash:4899d4bba6ad`; feat-role-decisions (v7) `@hash:d24c8e22069d`;
  feat-request-routing (v8) `@hash:eec1236a2a09`.

## What not to do

- Do not write a program that moves a run, or a clock that takes an
  ask's default unattended: the Appetite's first no-go; guardrail §2.
- Do not change a process definition for the run's sake:
  `bidirectional-conformance` — a run's departure is the run's defect.
- Do not give the router a verdict, a route, or a bet, or run the
  lead-pm's steps inside it: guardrail §1, §3; `actor-neutral-discipline`.
- Do not keep run state in the router's context or a file beside the
  anchor: guardrail §3; `local-comprehension`.
- Do not pass an agent step an undeclared value: the typed contract is
  the isolation mechanism.
- Do not answer a human step's question in the router, or take a
  default before the person confirms: `control-stays-with-the-person`.
- Do not evaluate a condition by a tool here, or branch without
  recording the value: guardrail §1, §4.
- Do not re-run or alter a failing command, or answer its prompt: the
  cli guideline rule 2.
- Do not build a step rendering or change how the harness loads a
  skill: guardrail §2.1 (init-artifact-tools).
- Do not name the coordinating role by a second word, or define a
  second role for it: `single-source-of-truth`.
- Do not touch the fabro target or its six annotations: guardrail
  §2.1's carried exception.
- Do not run a Bounded Context shop's processes or assign it a step:
  the decomposition; `contracts-between-contexts`; the freeze.
- Do not write the designer's corpus entries here: `define-good-up-front`
  keeps that check with a different role.
- Do not count the measure met before `@hash:fe0399304a46` and
  `@hash:96124cdccf45` are observed: `evidence-not-opinion`.
- Do not add a dependency, vendor, or recurring cost: any such
  commitment escalates to the authority first.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step for the nineteen scenarios assigned to shopsystem-product. Self-check v1: all five fitness scenarios pass. Status written; not sent. |
| 2 | 2026-09-08 | update | Rewritten to the plain-voice rule under feat-plain-voice-rest (`@hash:8b1d5c3f9e26`): prose cut to what the rules require, v1 condensed, References unchanged in substance. Self-check v2: scenarios 1–5 hold; scenario 6 evaluated against the 600-word target. Made by the lead-solutions-architect role. |
