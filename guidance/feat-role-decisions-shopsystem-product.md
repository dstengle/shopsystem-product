---
type: implementation-guidance
id: guidance-feat-role-decisions-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-role-decisions.md
feature: ../features/feat-role-decisions.md
context: shopsystem-product
scenarios: ["@hash:aba312f2b1ae", "@hash:d24c8e22069d", "@hash:74a11c38f2ce", "@hash:a66e2bd3cd35", "@hash:2fef03c8cc09", "@hash:c15c4d3bdff0", "@hash:3ffc45cf66b9", "@hash:a7aa73a0b41d"]
owner: lead-solutions-architect
created: 2026-09-06
updated: 2026-09-06
---

# Implementation guidance: feat-role-decisions for shopsystem-product

For the eight scenarios of feat-role-decisions (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-06 under
init-role-decisions (v10): `@hash:aba312f2b1ae`, `@hash:d24c8e22069d`,
`@hash:74a11c38f2ce`, `@hash:a66e2bd3cd35`, `@hash:2fef03c8cc09`,
`@hash:c15c4d3bdff0`, `@hash:3ffc45cf66b9`, `@hash:a7aa73a0b41d`. The
context is the lead shop building its own definitions, so this record
names the definitions and tools to change. It is a historical record of
this assignment and binds nothing after it.

## What changes

Contracts: none exist on this branch, so none is versioned. Guardrails:
none is recorded for the stack; the working principle set compiled into
every session and the architecture principle set (v6) apply, and the
design decision the feature implements is adr-2026-09-05-role-offer
(v3). Cross-context flow: none. The changes, in the order the feature's
constraints C1–C7 require (typedef, then instances, then renders):

1. **One data type, new, in `basis/types/`** under the data-type
   typedef (v3) — the type adr-2026-09-05-role-offer v3 §2 decides. Its
   Purpose names its producers, the `attach-architecture` and
   `attach-usability` steps of initiative-check (v7), and its consumers,
   that process's `screen` and `decide` steps and the pre-bet route once
   its owner adds it. Its Schema carries the offer's parts as fields, as
   the ADR's Decision states them, one field per part; the field for the
   decisions the bet depends on holds a decision-record id standing in
   `decisions/` or the value `none`, so a step can branch on it (C5); a
   part outside the attaching role's domain is carried as `none` with the
   reason, never omitted (C1). The type's name and field names are the
   author's; the product designer role screens the draft's field names
   (the initiative's Document History v4, U4). Serves
   `@hash:74a11c38f2ce`, `@hash:a66e2bd3cd35`, `@hash:2fef03c8cc09`,
   `@hash:c15c4d3bdff0`, `@hash:3ffc45cf66b9`.

2. **The role-definition typedef (v3), `basis/artifacts/role-definition.md`**,
   gains one required section, after Exclusive domain: the decisions the
   role owns and that it offers on them, unasked. The section names
   decisions, never a step or a moment — the typedef's own no-sequencing
   rule — and references the type of item 1 by id for the offer's shape
   (C2). Its fitness set (v2, `basis/fitness/role-definition.fitness.md`)
   is hand-written — the typedef carries no Writing rules or Fitness
   scenarios section — so it is hand-amended with one scenario judging
   the section, under the artifact-typedef typedef (v3). Each gets a
   Document History row; the owner is the product authority. Its order
   with brief-030's pending amendment to the same typedef is the
   owner's. Serves `@hash:aba312f2b1ae`, `@hash:d24c8e22069d`.

3. **The four role definitions**, after item 2 stands: `basis/roles/lead-pm.md`
   (v9), `basis/roles/lead-po.md` (v13),
   `basis/roles/lead-solutions-architect.md` (v10),
   `basis/roles/lead-product-designer.md` (v2). Each gains the section,
   its decisions drawn from the definition's own Exclusive domain and
   Decision rights, with a row. Each is then re-rendered to
   `.claude/agents/<name>.md` by
   `basis/tools/compile_role.py <role.md> --agent .claude/agents/<name>.md`
   under the role-rendering process (v7), and
   `basis/tools/compile_role.py --check` reads `ok` for all four. A
   definition carrying the section before item 2 names it does not count
   toward the measure. Serves `@hash:aba312f2b1ae`, `@hash:d24c8e22069d`,
   `@hash:a7aa73a0b41d`.

4. **The initiative-check process (v7), `basis/processes/initiative-check.md`**:
   the two attach steps gain the type of item 1 as an output beside
   `initiative` — the document is still returned, since derived check O1
   reads `initiative` and the verdict renders into it; the Data section
   declares the type; each attach prompt is cut to one sentence naming
   the initiative and asking for the role's attachment or its questions
   (C3; the ADR's fourth consequence). Nothing else in the process
   changes for this feature (C6): the `screen` step still reads the
   initiative and the criteria set only. Then
   `basis/tools/compile_process.py basis/processes/initiative-check.md --skill .claude/skills/initiative-check/SKILL.md`
   under the skill-rendering process (v7) re-produces the diagram and
   the skill. Serves `@hash:74a11c38f2ce`, `@hash:a66e2bd3cd35`,
   `@hash:2fef03c8cc09`, `@hash:3ffc45cf66b9`, `@hash:a7aa73a0b41d`.

5. **The initiative typedef (v10), `basis/artifacts/initiative.md`, §4 and
   the initiative fitness set (v4), `basis/fitness/initiative.fitness.md`**,
   both hand-written, both the product authority's: the typedef's
   Feasibility and usability requirement references the type of item 1
   by id for what each attaching role renders there — the verdict with
   its reasons — and names the initiative's Document History as the full
   offer's home until the cap's split is ruled (the ADR's §2 and first
   candidate; the bet's ruling: cap soft, 20% variance); it restates no
   part. The fitness set's scenario 5 is amended to judge each attaching
   role's offer against the type's parts by name — `none` with a reason
   a passing value the judge tests against the role's domain, a part
   absent without one a finding by this criterion's name — and its
   Compile mapping row with it; each with a row, before any screen is
   relied on for it (C4, C6). Serves `@hash:2fef03c8cc09`,
   `@hash:a66e2bd3cd35`, `@hash:3ffc45cf66b9`, `@hash:c15c4d3bdff0`.

6. **The pre-bet route is not in this assignment.** For
   `@hash:c15c4d3bdff0`, a `none` in the offer's decisions field is routed
   by the lead-pm by hand to adr-authoring (v2) or the PO role's
   product-decision-record process before the `decide` step, as the
   initiative's Document History v3 shows; the route in the process is
   the ADR's third candidate (D3), initiative-check's owner's to add,
   and its landing changes no scenario (C5).

7. **The PM and PO observations** for `@hash:a7aa73a0b41d` come from
   the steps that already exist: discovery-conversation (v11) `frame` for
   the PM role, feature-authoring (v6) `draft` for the PO role. No
   amendment to either process; the observation counts only when the
   step's prompt was the whole instruction (C3), and it is recorded in
   the artifact the step writes.

8. **Done means** (`delivery-verified`): the four definitions carry the
   section from the typedef, `compile_role.py --check` reads `ok` four
   times, the re-rendered skill is byte-equal to a fresh render,
   `python3 basis/tools/lint_basis.py` is clean, and one observation per
   role at its own step stands in a record — what the reconcile-and-close
   process (v4) reads when the work returns.

## References

- Initiative: init-role-decisions (v10, active). Feature:
  feat-role-decisions (v5, checked at assignment), constraints C1–C7 and
  the Edges table as its own record; scenarios `@hash:aba312f2b1ae`,
  `@hash:d24c8e22069d`, `@hash:74a11c38f2ce`, `@hash:a66e2bd3cd35`,
  `@hash:2fef03c8cc09`, `@hash:c15c4d3bdff0`, `@hash:3ffc45cf66b9`,
  `@hash:a7aa73a0b41d`.
- Design decisions: adr-2026-09-05-role-offer (v3, checked; §2 the
  decision, §3 the bound on Bounded Context shops: none);
  pdr-2026-09-06-bet-role-decisions (the bet).
- Contracts: none exist on this branch.
- Definitions, at the versions read: role-definition typedef v3 and its
  fitness set v2; initiative typedef v10 and its fitness set v4;
  initiative-check v7; data-type typedef v3; artifact-typedef typedef
  v3; adr-authoring v2; discovery-conversation v11; feature-authoring
  v6; role-rendering v7; skill-rendering v7; reconcile-and-close v4;
  lead-pm v9, lead-po v13, lead-solutions-architect v10,
  lead-product-designer v2.
- Tools, by path: `basis/tools/compile_role.py`,
  `basis/tools/compile_process.py`, `basis/tools/lint_basis.py`.
- Touch-points in the repository: feat-roles-availability (v6)
  `@hash:d707d4311bdf` and feat-skills-availability (v8)
  `@hash:26f78a3ca4a6` — the reconcile of a hand-diverged render.

## What not to do

- Do not restate the offer's parts in an attach prompt, a role
  definition's section, or the initiative typedef's §4: the type is
  their one home (`single-source-of-truth`; C1).
- Do not add the section to a role definition before the typedef names
  it, and do not edit `.claude/agents/*.md` or
  `.claude/skills/initiative-check/SKILL.md` by hand: the definition is
  the source and the render follows it (`bidirectional-conformance`;
  C2, C6); a hand-diverged render is what `@hash:d707d4311bdf` and
  `@hash:26f78a3ca4a6` exist to find and reconcile.
- Do not write a step name or a "when" into the typedef's section or a
  role's instance of it: the role-definition typedef's no-sequencing
  rule; which step a role acts at is its process's.
- Do not repair a missing part with an instruction added at the step —
  an ask, a brief, a sentence from the lead-pm: the obligation attaches
  to the role and the activity (`actor-neutral-discipline`,
  `governed-context`; C3); the type or the definition is repaired, with
  a row, and an observation made with an added instruction does not
  count.
- Do not add the pre-bet route to adr-authoring into initiative-check
  under this assignment: D3 is bounded, not decided (the ADR's third
  candidate; C5), and the process is its owner's.
- Do not split the 500-word cap or move the full offer's home out of
  the Document History: the initiative typedef owner's own ruling — cap
  soft with 20% variance at the bet, the home the ADR's first candidate
  (C4).
- Do not add Writing rules or Fitness scenarios sections to the
  role-definition or initiative typedef, and do not run
  `basis/tools/compile_typedef.py` on either: their fitness sets are
  hand-written under the artifact-typedef typedef v3, and making them
  produced is a change of the type's standard outside this appetite
  (feat-typedef-rendering's scope, not this feature's).
- Do not let a missing part be reportable only as an "uncovered"
  finding: the decide step's rule leaves the bet available on one, so
  the finding must carry the amended criterion's name
  (`define-good-up-front`; C6).
- Do not make the decisions field prose: a step routes on a value, never
  on prose (C5; the `route-screen` precedent in `screen-review`).
- Do not extend the type or the section to a Bounded Context shop's
  roles or to any message type: the ADR's bound on Bounded Context shops
  is none, and extending it would be a guardrail decision not made here
  (`contracts-between-contexts`; C7).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Written by the lead-solutions-architect role at the scenario-assignment process (v12) assign step for the eight scenarios of feat-role-decisions assigned to shopsystem-product, from the implementation-guidance guideline (v1); the first record of its type. Maker's self-check against the implementation-guidance fitness set (v1): scenario 1 (the architect's level) pass — each of the eight statements in What changes names a lead-shop definition by path and version, a tool by path, or a process step by id, and none names a Bounded Context's internals (none exists); scenario 2 (cited, never restated) pass — every scenario cited by hash only, the ADR and the definitions by id and version, and no scenario text, constraint text, or contract clause reproduced (the offer's parts are pointed at as "as the ADR's Decision states them", not listed); scenario 3 (actionable alone) pass — every definition to change is named with its version, the two compilers with their invocations, the check that closes each, the order between them, and the two things left to other owners named as not in this assignment, so the shop can begin with the scenarios beside it; scenario 4 (reasons) pass — each of the ten entries in What not to do names a principle, a constraint, a rule of a named typedef, or the decomposition's bound as its reason; scenario 5 (one assignment) pass — the frontmatter and the opening paragraph name the initiative, the feature, the context, and the eight hashes, and every statement is about those scenarios, items 6 and 7 saying what is not in this assignment rather than binding a later one. Status written; not sent. |
