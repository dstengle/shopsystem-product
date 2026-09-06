---
type: request
id: req-2026-09-06-implementation-guidance
status: done
version: 5
date: 2026-09-06
reader: lead-pm
owner: lead-pm
created: 2026-09-06
updated: 2026-09-06
originator: product-authority
received-through: operational-contract
arose-in: init-role-decisions
route: small-change
route-reason: "one new artifact type within the lead shop's own definitions — its typedef carrying its writing rules and fitness scenarios so its texts render — and one step of the scenario-assignment process producing it; demonstrable in one session; no appetite worth a bet"
routed-to: requests/req-2026-09-06-implementation-guidance.md#result
work-item: lead-i9mde
---

# Request: an implementation guidance artifact

## 1. What is requested

The product authority, 2026-09-06, in the review of init-role-decisions
with the lead-pm: "The guidance is important as an artifact but should
only be part of a historical record. Technical implementation will
change over time while the contract represented by features and
scenarios will not unless explicit changes are made. … For now create
an implementation guidance artifact that references the initiative and
can be added to the message contract later." And on its content and
timing, earlier in the same review: "This is the architect providing
guidance to the implementer within the initiative." "The implementation
guidance is related to whatever technical changes the implementer will
need to do to the product." "The architect's guidance will be much
more useful if it is created with the scenarios in mind." "What is
important is guidance per bounded context."

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose in the review of init-role-decisions,
proposed and not yet bet.

## 3. Route

Route said by the lead-pm role, 2026-09-06: **the small-change lane**.
Why: one new artifact type within the lead shop's own definitions,
whose typedef carries its writing rules and fitness scenarios so that
its guideline and fitness set render from it, and one step of the
scenario-assignment process producing one per Bounded Context for the
scenarios assigned — demonstrable in one session, spending no
appetite worth a bet. Topic: "an implementation guidance artifact, per
Bounded Context, referencing the initiative, a historical record
(req-2026-09-06-implementation-guidance)".

Originator's answer: **accepted** — "For now create an implementation
guidance artifact", 2026-09-06, the direction and the acceptance in
one. Landed by the lead-pm; work item lead-i9mde opened for the lane; it
points here and carries nothing of what was asked. Bounds from the
same review: the guidance is bounded to what the architect may see of
a context — its contracts, the guardrails, the cross-context flow —
never a context's internals, except where the lead shop builds its
own definitions; it references the contracts and the scenarios and
does not restate them; it is a historical record, not the contract;
the message contract is not changed now (journaling messages offline
is the backlog item lead-j30gv).

## 4. Result

### Definition

req-2026-09-06-implementation-guidance — defined by the lead-po role,
2026-09-06, at the small-change process's define step. Judged against
the glossary's entry for simple change: the change stays within the
lead shop's own definitions (one typedef, one process step, the
glossary, the lint, and the texts rendered from them), touches no
Bounded Context's artifacts, and its effect is demonstrable in one
session by the observation below — a simple change. Bounds carried
from section 3: what the architect may see of a context, never its
internals; references, never restatement; a historical record, not
the contract; the message contract untouched.

**What will be different when the change is done.**

1. *The type exists and qualifies for typedef-rendering.*
   Given the typedef at `basis/artifacts/implementation-guidance.md`,
   When a reader opens it,
   Then it defines the artifact type `implementation-guidance` and
   carries, as sections of its own, the writing rules and the fitness
   scenarios from which the typedef-rendering process produces the
   type's guideline and fitness set — so that the type qualifies for
   that process and no writing rule or fitness scenario for it lives
   anywhere else.

2. *Identity: who produces it, for whom, who consumes it.*
   Given the typedef,
   When a reader looks for who makes an instance and who reads it,
   Then it states: produced by the lead-solutions-architect role at
   the scenario-assignment process's assign step, one per Bounded
   Context that receives scenarios in that assignment; consumed by
   the shop implementing those scenarios, and by the
   reconcile-and-close process, which records whether the guidance
   held.

3. *Required frontmatter.*
   Given the typedef,
   When a reader lists the frontmatter an instance must carry,
   Then the required keys are exactly: `type`, `id`, `status`,
   `version`, `initiative` (a link to the initiative), `feature` (a
   link to the feature), `context` (the Bounded Context the guidance
   is for), `scenarios` (the hashes assigned to that context that the
   guidance covers), `owner`, `created`, `updated`.

4. *Required sections.*
   Given the typedef,
   When a reader lists the sections an instance must carry,
   Then they are: what the assigned scenarios change in that context
   at the level the architect may see — its contracts, the guardrails
   that apply, where the cross-context flow touches it — and, for the
   lead shop building its own definitions, the definitions and tools
   to change; the references to the contracts and to the scenarios,
   which the instance cites and never restates; and what not to do.

5. *Rules.*
   Given the typedef,
   When a reader looks for what an instance binds,
   Then it states that an instance is a historical record: it binds
   nothing after the assignment it was written for, because technical
   implementation changes over time while the scenario contract does
   not; that an instance is never sent in a message now — the message
   contract is unchanged by this type, and the designer's guidance is
   a later part; and that an instance's commitment is met when the
   implementing shop can act on it with the assigned scenarios alone.

6. *The assign step produces it; the record step names it.*
   Given `basis/processes/scenario-assignment.md`,
   When a reader follows the assign step,
   Then its outputs include one implementation-guidance record per
   Bounded Context tagged in that assignment, each at
   `guidance/<feature>-<context>.md` — `guidance/` being a directory
   at the repository root that the lint walks — and the record step
   names those records among what it records; the assign step's
   authorship of them sits with the lead-solutions-architect role,
   the step's existing role; nothing else in the process changes.

7. *The glossary carries the term.*
   Given `basis/glossary.md`,
   When a reader looks up **implementation guidance**,
   Then an entry defines it consistently with statements 2, 4 and 5 —
   per Bounded Context, from the architect at assignment, referencing
   the contracts and scenarios, a historical record that is not the
   contract.

8. *The lint knows the type.*
   Given `basis/tools/lint_basis.py`,
   When the lint runs from the repository root,
   Then it walks `guidance/` when that directory exists, and a record
   there missing any required key of statement 3 fails the lint with
   the missing key named — the check being one function beside the
   lint's other per-type checks; and the corpus as it stands passes.

9. *The corpus index and the produced texts are current.*
   Given `basis/README.md`, `basis/guidelines/implementation-guidance.md`
   and `basis/fitness/implementation-guidance.fitness.md`,
   When a reader opens them,
   Then the README lists the new typedef and its two produced texts;
   and the guideline and fitness set are what
   `basis/tools/compile_typedef.py` renders from the typedef, so that
   the typedef-rendering check reports nothing for the type.

10. *The skill is the process.*
    Given `.claude/skills/scenario-assignment/SKILL.md`,
    When it is compared with a fresh render of the amended process
    definition by `basis/tools/compile_process.py`,
    Then it is identical, and the definition's diagram is the one the
    tool regenerates.

**Artifacts the change touches (paths).**

- `basis/artifacts/implementation-guidance.md` — new typedef.
- `basis/processes/scenario-assignment.md` — the assign step's
  outputs and the record step; version bumped, history row citing
  this request.
- `basis/glossary.md` — the term; version bumped, history row citing
  this request.
- `basis/tools/lint_basis.py` — the `guidance/` walk and the required
  keys; changed together with the typedef that names them.
- `basis/README.md` — the index entries; version bumped, history row
  citing this request.
- `basis/guidelines/implementation-guidance.md` — rendering; source
  `basis/artifacts/implementation-guidance.md`; tool
  `basis/tools/compile_typedef.py` (read, not changed): `python3
  basis/tools/compile_typedef.py basis/artifacts/implementation-guidance.md`.
- `basis/fitness/implementation-guidance.fitness.md` — rendering;
  same source and tool as the guideline, produced by the same
  invocation.
- `.claude/skills/scenario-assignment/SKILL.md` — rendering; source
  `basis/processes/scenario-assignment.md`; tool
  `basis/tools/compile_process.py` (read, not changed): `python3
  basis/tools/compile_process.py basis/processes/scenario-assignment.md
  --skill .claude/skills/scenario-assignment/SKILL.md`.

Nothing else is touched: no guidance record is written (the shop is
frozen and no assignment runs), no message contract changes, no
Bounded Context artifact changes.

**Maker.** lead-solutions-architect — the role the make step runs by.

**Verifying observation.** One command, run from the repository root;
exit 0 shows the effect and its output is the evidence. It shows the
lint passing over the corpus as it stands, the typedef-rendering check
printing nothing for the new type (both produced texts current), the
scenario-assignment definition's diagram current and its skill equal
to a fresh render, the glossary carrying the term, and the lint
rejecting a probe guidance record that lacks the required keys (the
probe is removed again by the command).

```
( python3 basis/tools/lint_basis.py && o=$(python3 basis/tools/compile_typedef.py basis/artifacts/implementation-guidance.md --check) && [ -z "$o" ] && echo "implementation-guidance: guideline and fitness set current" && s=$(mktemp -d) && mkdir -p "$s/defs" && ln -s "$PWD/basis/types" "$s/types" && ln -s "$PWD/basis/artifacts" "$s/artifacts" && cp basis/processes/scenario-assignment.md "$s/defs/scenario-assignment.md" && python3 basis/tools/compile_process.py "$s/defs/scenario-assignment.md" --skill "$s/scenario-assignment/SKILL.md" >/dev/null && diff -q "$s/defs/scenario-assignment.md" basis/processes/scenario-assignment.md && diff -q "$s/scenario-assignment/SKILL.md" .claude/skills/scenario-assignment/SKILL.md && echo "scenario-assignment: diagram current, skill equals fresh render" && grep -q '^- \*\*implementation guidance\*\*' basis/glossary.md && echo "glossary: implementation guidance defined" && mkdir -p guidance && printf -- '---\ntype: implementation-guidance\nid: ig-probe\n---\n' > guidance/ig-probe.md && { python3 basis/tools/lint_basis.py >/dev/null 2>&1; r=$?; }; rm -f guidance/ig-probe.md; rmdir guidance 2>/dev/null; [ "${r:-0}" -ne 0 ] && echo "lint: a guidance record missing required keys is rejected" )
```

**Maker's evaluation before the check.** The lead-po evaluated this
definition against the define step's own statement of good: every
statement is Given/When/Then decidable against a named artifact; each
says what and not how; every path is listed, renderings with their
source and tool; the maker role is the make step's; the observation is
one command from the repository root whose exit 0 is the effect. One
read beyond the step's named inputs is disclosed: the argument
handling of `compile_typedef.py` and `compile_process.py` and the
observation of a prior done request, taken to write the command
exactly rather than guess it.

### Change made

**Round 1 — maker: lead-solutions-architect**, 2026-09-06, at the
small-change process's make step. Every path the Definition lists,
made through its own producing rules; nothing outside them touched.

- `basis/artifacts/implementation-guidance.md` — new typedef, absent →
  v1: identity (produced by the lead-solutions-architect role at the
  scenario-assignment process's assign step, one per Bounded Context;
  consumed by the implementing shop and the reconcile-and-close
  process), required frontmatter (the eleven keys of statement 3, the
  field set closed; `status` written | held | not-held), required
  sections (What changes, References, What not to do), rules (a
  historical record binding nothing after its assignment; never sent
  in a message; the architect's level, never internals; instances at
  `guidance/<feature>-<context>.md`), commitment (the shop can act on
  it with the assigned scenarios alone), sources, Writing rules and
  Fitness scenarios (five rules, five scenarios, the compile
  mapping; judge `cold-reviewer` as the sibling decision-record types
  name), derived review checklist; `status: approved`,
  `approved: 2026-09-06`, on the authority's direction of 2026-09-06
  this request records, the history row saying so.
- `basis/guidelines/implementation-guidance.md` — rendering, absent →
  produced (digest of typedef v1); and
  `basis/fitness/implementation-guidance.fitness.md` — rendering,
  absent → produced; both by
  `python3 basis/tools/compile_typedef.py basis/artifacts/implementation-guidance.md`;
  `--check` reports nothing.
- `basis/processes/scenario-assignment.md` — v11 → v12: the `guidance`
  data value (array of paths) added; the assign step outputs it and,
  once every scenario is owned, writes one implementation guidance
  record per context tagged at `guidance/<feature>-<context>.md`; the
  record step reads `guidance` and names each record in the state
  entry; `produces: [implementation-guidance]`, per the
  process-definition typedef's clause that `produces` lists the
  artifact types a run creates; history row citing this request.
  Outcomes, roles, the route, return, and dispatch steps, and the
  derived checks unchanged.
- `.claude/skills/scenario-assignment/SKILL.md` — rendering, digest
  ecd9f2c7b899 → f3662182a662, by
  `python3 basis/tools/compile_process.py basis/processes/scenario-assignment.md --skill .claude/skills/scenario-assignment/SKILL.md`,
  which also regenerated the definition's diagram.
- `basis/glossary.md` — v21 → v22: **implementation guidance** added;
  history row citing this request.
- `basis/tools/lint_basis.py` — check 12 added: `lint_guidance()`,
  beside the other per-type checks, walks `guidance/` at the
  repository root when it exists and reports each required key a
  record lacks by name (and a `type` that is not
  `implementation-guidance`); the module docstring names it. Changed
  together with the typedef that names the keys.
- `basis/README.md` — v11 → v12: the `guidance/` home listed with the
  typedef and its two produced texts; §Checks names check 12; history
  row citing this request.

**Maker's evaluation before the check.** Against the Definition's ten
statements: 1–5 read from the typedef; 6 from the process's data
block, assign and record steps; 7 from the glossary; 8 from the lint,
which reports "front-matter lacks" for `status`, `version`,
`initiative`, `feature`, `context`, `scenarios`, `owner`, `created`,
`updated` for a probe carrying only `type` and `id`; 9 and 10 from
the renderings, which the observation compares with fresh renders.
The observation run as written exited 0 with its five lines; the
plain lint reports `PASS: 0 violation(s)`. Reads beyond the paths,
disclosed: the artifact-typedef typedef and the product-decision-record
typedef for the typedef form, the process-definition typedef's
`produces` clause, the assignment data type, the adr fitness set's
judge, and the reconcile-and-close process's roles — each to make an
artifact by its own producing rules, none changed. One judgement
call: `produces` now lists the type, read as part of statement 6's
"outputs include one implementation-guidance record" rather than as
"else"; the checker decides.

### Check

**Round 1** — verdict: **pass** — by the lead-pm role, 2026-09-06, at
the small-change process's check step; the maker was the
lead-solutions-architect role. Each statement decided against the
changed artifacts: the typedef exists with the identity, field set,
sections, rules, commitment, and its writing rules and fitness
scenarios; its guideline and fitness set are produced and current;
the scenario-assignment process produces one record per context
tagged and names them at its record step, its skill re-rendered; the
glossary carries the term; the lint walks the guidance directory and
refuses a record missing a required key; every history row cites this
request with its version bumped. The maker's judgment call — the
process declaring the type as produced — is within the definition's
statement on the process's outputs. Every path in Change made is in
the Definition's list. Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-06; its evidence:

```
PASS: 0 violation(s)
implementation-guidance: guideline and fitness set current
scenario-assignment: diagram current, skill equals fresh render
glossary: implementation guidance defined
lint: a guidance record missing required keys is rejected
exit 0
```

Recorded by the lead-pm role, 2026-09-06. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the
request and this result no bet was taken and no check of record was
run. The effect in the running system: the next scenario assignment
produces one implementation guidance record per Bounded Context, the
harness lists the re-rendered assignment skill, and the lint refuses a
malformed record.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Recorded by the lead-pm at the request-intake process's record step from the authority's words in the review of init-role-decisions; routed small-change and said; accepted by the originator's own direction; work item lead-i9mde opened; dispatched to the small-change lane. |
| 2 | 2026-09-06 | update | Definition written by the lead-po at the small-change process's define step: judged a simple change; ten Given/When/Then statements over the new typedef, the scenario-assignment process, the glossary, the lint, the README and the three renderings; maker lead-solutions-architect; one verifying observation. No artifact but this request touched. |
| 3 | 2026-09-06 | update | Change made by the lead-solutions-architect at the small-change process's make step, round 1: the implementation-guidance typedef authored (v1, approved on the authority's direction of 2026-09-06) and its guideline and fitness set produced; scenario-assignment v12 with its skill re-rendered; glossary v22; lint check 12; README v12. The observation run as written exited 0; the plain lint passes. |
| 4 | 2026-09-06 | update | Check passed (round 1) by the lead-pm role; the verifying observation run by the runtime, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 5 | 2026-09-06 | update | Where the route led written into routed-to by the lead-pm at the request-intake process's land-result step; the lane's work item lead-i9mde closed as done. |
