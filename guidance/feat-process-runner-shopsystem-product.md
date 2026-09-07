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
updated: 2026-09-07
---

# Implementation guidance: feat-process-runner for shopsystem-product

For the nineteen scenarios of feat-process-runner (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-07 under
init-process-runner (v8): `@hash:7f991d005cc5`, `@hash:21a0a96524fb`,
`@hash:dfb80114f737`, `@hash:4353a5e45d00`, `@hash:c32dd5b8b474`,
`@hash:6c3bd78771bc`, `@hash:3a9dc4428ded`, `@hash:c0234aab4a26`,
`@hash:6bcebb4e0073`, `@hash:6c35e3f87cd0`, `@hash:767b608029a3`,
`@hash:4d31a463c42e`, `@hash:8f5b65dca426`, `@hash:1809e3236eca`,
`@hash:28b4f5a6d5dc`, `@hash:06a0e40f2325`, `@hash:d2f51245aa9a`,
`@hash:fe0399304a46`, `@hash:96124cdccf45`. The context is the lead
shop building its own definitions and tools, so this record names the
definitions and tools to change. It is a historical record of this
assignment and binds nothing after it.

## What changes

Contracts: none exist on this branch, so none is versioned. Guardrail:
one binds — adr-2026-09-07-coordinator-role (v3, checked): §2 the
decision, §2.1 the principles screen with two carried exceptions, §3
the consequences and the bound on Bounded Context shops (none new), §4
the review triggers. The working principle set (v11) and the
architecture principle set (v6) apply. Cross-context flow: none. The
changes, in the order the guardrail and the definitions' own rules
require (the actor, then its rendering, then the return's form, then
the anchor's use, then the proof):

1. **One role definition, new, at `basis/roles/router.md`** under the
   role-definition typedef (v4), its guideline (v2), and its fitness
   set (v3), approved by the authority through the definition chain
   (the guardrail's first consequence; the order's first placed
   enabler). Frontmatter: the four required harness keys and `model` —
   a key `compile_role.py` admits — set to the harness's smallest tier
   (the initiative's history v3, U5 default). Sections: the three the
   typedef requires; the exclusive domain is the run's next step read
   from the definition, and Decisions owned names no verdict, route,
   or bet — read with `@hash:d2f51245aa9a` and feat-role-decisions
   (v7) `@hash:d24c8e22069d`, which asks every lead-shop role's
   definition for that section. The body carries the run discipline
   the scenarios state and nothing else — no summary of any process:
   runtime steps as written and a non-zero exit held
   (`@hash:21a0a96524fb`, `@hash:dfb80114f737`); a condition's value
   recorded, an unreadable one asked (`@hash:4353a5e45d00`,
   `@hash:c32dd5b8b474`); an agent step launched with its prompt and
   declared inputs alone (`@hash:6c3bd78771bc`); a human step and an
   ask held, never waited on (`@hash:6bcebb4e0073`,
   `@hash:767b608029a3`); hold, answer, resume, cancel at the command
   line (`@hash:4d31a463c42e`, `@hash:6c35e3f87cd0`,
   `@hash:1809e3236eca`); restart from the anchor, and at least at each
   sub-process boundary (`@hash:8f5b65dca426`, `@hash:28b4f5a6d5dc`;
   the guardrail's second consequence). Form: the session's top-level
   agent on the cheap model until a run shows a rendered agent can
   launch agent steps; then the launch tool joins `tools` (the
   guardrail's last consequence; the initiative's history v3, U1). The
   tool list is the maker's within that.

2. **The rendering and the glossary.** Render by
   `python3 basis/tools/compile_role.py basis/roles/router.md --agent .claude/agents/router.md`
   under role-rendering (v7); the check
   `python3 basis/tools/compile_role.py --check --findings` reports no
   row — feat-roles-availability (v6) `@hash:ce98da2b6467` and
   `@hash:219547cc8cb5` bind the same check. Serves
   `@hash:06a0e40f2325`. The glossary (`basis/glossary.md`, v24) gains
   `router` in the role sense, beside its existing two-sense `ask`
   entry; feat-request-routing (v8)'s use of the word stays the
   lead-pm's activity (the guardrail's first consequence).

3. **One compiler change, `basis/tools/compile_process.py`:** each
   agent-run step's rendered section closes with a line naming the
   step's declared outputs as the form its return takes — beside the
   banned-words line the compiler already appends, the precedent under
   the process-definition typedef (v7)'s rendering contract. The
   order's second placed enabler; the guardrail's consequence "agent
   outputs become parseable". The line's wording is the maker's; what
   must hold is `@hash:3a9dc4428ded` and `@hash:c0234aab4a26`. Then
   every approved definition is re-rendered by
   `python3 basis/tools/compile_process.py <definition> --skill .claude/skills/<name>/SKILL.md`
   under skill-rendering (v9), whose check passes clean —
   feat-skills-availability (v8) `@hash:4899d4bba6ad`. No process
   definition changes.

4. **The anchor, through the `bd` skill** (`create`, `comment`,
   `close`): the run's state, current step, parameters, the router's
   model, every value a step yields (a condition's value beside its
   branch, an exit status beside its message), each ask in the `ask`
   type (v2)'s fields, the result, and the harness's token count are
   written to the work item so that a router started from it alone can
   continue; a value too large for it is written as a path (the
   guardrail's second consequence; the typedef §Run lifecycle). Serves
   `@hash:7f991d005cc5`, `@hash:21a0a96524fb`, `@hash:dfb80114f737`,
   `@hash:4353a5e45d00`, `@hash:c0234aab4a26`, `@hash:6bcebb4e0073`,
   `@hash:6c35e3f87cd0`, `@hash:767b608029a3`, `@hash:4d31a463c42e`,
   `@hash:8f5b65dca426`, `@hash:1809e3236eca`, `@hash:28b4f5a6d5dc`,
   `@hash:d2f51245aa9a`, `@hash:96124cdccf45`. How the record is laid
   out on the item is the maker's.

5. **The proof:** one approved process definition with all three step
   kinds, run end to end against a work item — `@hash:fe0399304a46`
   with `@hash:96124cdccf45` — the lead-pm acting at its own steps and
   nowhere between. Which process is the PM role's at the delivery
   (the feature's Edges, its proposed default). Every human turn is
   recorded with the router's turn before it — the designer's evidence
   form — and the delivery attaches it for that role's screen.

## References

The guardrail adr-2026-09-07-coordinator-role, v3 (§2, §2.1, §3, §4).
The definitions: the role-definition typedef v4, its guideline v2, its
fitness set v3; the process-definition typedef v7 (§The steps section,
§Run lifecycle, §Rendering contract); role-rendering v7;
skill-rendering v9; the `ask` data type v2; the glossary v24; the
working principle set v11; the architecture principle set v6. The
tools, through their skills: `basis/tools/compile_role.py`,
`basis/tools/compile_process.py`, `bd`, `basis/tools/lint_basis.py`.
The scenarios: the nineteen hashes in the frontmatter, of
feat-process-runner v5; the repository touch-points
feat-roles-availability v6 `@hash:ce98da2b6467`, `@hash:219547cc8cb5`;
feat-skills-availability v8 `@hash:4899d4bba6ad`; feat-role-decisions
v7 `@hash:d24c8e22069d`; feat-request-routing v8 `@hash:eec1236a2a09`.
The order order-2026-09-07-b v3 (§2, the two placed enablers).

## What not to do

- Do not write a program that moves a run, or a clock that takes an
  ask's default unattended: the Appetite's first no-go; the guardrail
  §2.
- Do not change a process definition for the run's sake: the Appetite's
  second no-go; `bidirectional-conformance` — a run that departs from
  its definition is the run's defect.
- Do not give the router a verdict, a route, or a bet, or run the
  lead-pm's own agent or human steps inside it: the guardrail §1's
  declined option and §3's first consequence; `actor-neutral-discipline`.
- Do not keep the run's state in the router's context, in a file beside
  the anchor, or in a summary of the process: the guardrail §1's
  declined option and §3's second consequence; `local-comprehension`.
- Do not pass an agent step any value it does not declare: the
  process-definition typedef §The steps section (the typed contract is
  the isolation mechanism); `local-comprehension`.
- Do not answer a human step's or an ask's question in the router, and
  do not cancel or take a default before the person confirms: the
  typedef §Run lifecycle (no synchronous form); the designer's criteria
  (e) and (g); `control-stays-with-the-person`.
- Do not evaluate a condition by a tool under this assignment, and do
  not take a branch without recording the value read: the guardrail
  §1's "not chosen now" and §4's trigger; the order §2's decline.
- Do not re-run, alter, or continue past a failing command, and do not
  answer a command's prompt: the designer's criterion (h); the cli
  guideline rule 2.
- Do not build a rendering of one step or change how the harness loads
  a skill: the guardrail §2.1 places that after this work
  (init-artifact-tools).
- Do not name the coordinating role by a second word or define a second
  role for it: the guardrail §1's declined option;
  `single-source-of-truth`.
- Do not touch the fabro rendering target or the six `fabro:`
  annotations: the guardrail §2.1's carried exception, held for the
  migration review.
- Do not run a Bounded Context shop's process definitions or assign a
  step to a role such a shop fills: the Decomposition; the guardrail
  §3's bound; `contracts-between-contexts`; the freeze (lead-ki66p).
- Do not write the designer role's corpus entries — the vocabulary,
  the patterns record, the WCAG2ICT applicability record — as part of
  this assignment's changes: the feature's Edges names them that role's
  own actions; `define-good-up-front` keeps the check with a different
  role.
- Do not count the measure met, or write "usable" without
  "hypothesis", before `@hash:fe0399304a46` and `@hash:96124cdccf45`
  are observed: `evidence-not-opinion`; `delivery-verified`.
- Do not add a dependency, a vendor, or a recurring cost — a `model`
  value outside the harness's own tiers included: the guardrail §1's
  pre-state (no new vendor); the cost threshold is unset, so any such
  commitment escalates to the authority first.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Written by the lead-solutions-architect role at the scenario-assignment process (v12) assign step for the nineteen scenarios of feat-process-runner assigned to shopsystem-product, from the implementation-guidance guideline (v1); the fourth record of its type. Pre-state read from lead-shop-held records: the guardrail; the role-definition chain (typedef v4, guideline v2, fitness v3); the process-definition typedef v7; role-rendering v7 and skill-rendering v9; the compile-role, compile-process, bd, and lint-basis skills; `basis/roles/` holding six definitions and no router; the glossary v24 with no `router` entry; the feature repository in full. Maker's self-check against the implementation-guidance fitness set (v1): scenario 1 (the architect's level) pass — each of the five items in What changes names a lead-shop definition by path and version, a tool by path through its skill, a process by id and version, or the guardrail's section, and none names a Bounded Context's internals (none exists); the router's tool list, the line's wording, and the anchor's layout are left to the maker within the bound; scenario 2 (cited, never restated) pass — every scenario cited by hash only, the guardrail by id, version, and section, the definitions by id and version, and no scenario text, criterion text, or contract clause reproduced; scenario 3 (actionable alone) pass — every definition and tool to change is named with its path and version, the three invocations given, the order between the five items fixed with its reason, the one choice left to another owner (which process the first run runs) named with what must hold, and what is not in this assignment named as such; scenario 4 (reasons) pass — each of the fifteen entries in What not to do names the guardrail's section, a no-go, a typedef's section, a principle, a designer criterion, the decomposition, or the freeze as its reason; scenario 5 (one assignment) pass — the frontmatter and the opening paragraph name the initiative, the feature, the context, and the nineteen hashes, and every statement is about those scenarios; item 5 names what is another role's at delivery rather than binding a later assignment. Status written; not sent. |
