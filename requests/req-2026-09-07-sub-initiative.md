---
type: request
id: req-2026-09-07-sub-initiative
status: done
version: 3
date: 2026-09-07
reader: lead-pm
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
originator: product-authority
received-through: operational-contract
arose-in: lead-rr5c0
work-item: lead-8yhpb
route: small-change
route-reason: "one optional field and one section on the initiative typedef, one rule (a parent holds no features and is not bet on), and the lint holding the parent's derived list to the children's links — within the lead shop's own definitions, demonstrable in one session, no appetite worth a bet; the run-efficiency frame needs it first"
routed-to: "requests/req-2026-09-07-sub-initiative.md#result"
---

# Request: sub-initiatives

## 1. What is requested

The product authority, 2026-09-07, in the run-efficiency discovery:
"We are hitting a fundamental issue with our single-level initiative
system. This is a group of related initiatives, typically managed as
epic and feature in agile systems. We need a sub-initiative type for
tracking related things. Building a process runner should not be in
the appetite of a measurement initiative." Then: "I prefer
subinitiative. It is more straightforward than adding new
terminology that can be over loaded." — "one type with parent link";
"parents don't have bets, only children"; "I'm okay with only having
the linking one way".

## 2. From whom

Reader: the lead-pm role. Originator: the product authority, in the
discovery conversation on req-2026-09-07-run-efficiency (work item
lead-rr5c0). Received through the lead shop's operational contract,
which has no artifact yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-07: **the small-change lane**.
Why: the initiative typedef gains an optional `parent` field on the
child (the link's one home; the child is written knowing its parent),
a Sub-initiatives section on the parent listing its children — derived
from the children's links, held to them by the lint — and one rule: an
initiative with sub-initiatives holds no features and is not bet on;
its measure is moved by its children, and it completes when they do.
No new type, no new terminology. Within the lead shop's own
definitions, demonstrable in one session. Topic: "sub-initiatives
(req-2026-09-07-sub-initiative)".

Originator's answer: **accepted** — the decisions are the authority's
own, taken in the discovery; runs now, before the frame.

## 4. Result

### Definition

req-2026-09-07-sub-initiative: when the change is done, an initiative
may name another as its parent; the parent lists its children,
derived from their links and held to them by the lint; a parent
holds no features and is not bet on.

Acceptance:

- Given the initiative typedef, when a reader looks for the link
  between a sub-initiative and its parent, then the child carries one
  optional field `parent` naming the parent initiative's id, and the
  parent carries no link field.
- Given an initiative named in at least one other initiative's
  `parent`, when it is read, then it holds a Sub-initiatives section
  listing exactly the initiatives that name it, and the typedef says
  that list is derived from the children's `parent` fields.
- Given an initiative with sub-initiatives, when it is checked against
  the typedef, then it holds no features, its measure is moved by its
  children, and it completes when all its children complete.
- Given the initiative-check process, when its bet step reaches an
  initiative with sub-initiatives, then the step says no bet is taken
  on it and a bet is taken on each child alone.
- Given the lint, when a parent's Sub-initiatives section and the set
  of initiatives naming it in `parent` disagree, then the lint reports
  the disagreement and exits non-zero; when they agree, it does not.
- Given the glossary, when a reader looks up sub-initiative, then it
  finds an entry defining it as an initiative whose `parent` field
  names another initiative, with no new type behind it.
- Given the changed sources, when their renderings are read, then
  each matches its source as its tool produces it.

Artifacts touched:

- `basis/artifacts/initiative.md` — the typedef (source).
- `basis/guidelines/initiative.md` — rendering of
  `basis/artifacts/initiative.md` by `basis/tools/compile_typedef.py`.
- `basis/fitness/initiative.fitness.md` — rendering of
  `basis/artifacts/initiative.md` by `basis/tools/compile_typedef.py`.
- `basis/tools/lint_basis.py` — the lint.
- `basis/processes/initiative-check.md` — the bet step (source).
- `.claude/skills/initiative-check/SKILL.md` — rendering of
  `basis/processes/initiative-check.md` by
  `basis/tools/compile_process.py`.
- `basis/glossary.md` — the entry for sub-initiative.

Maker role: lead-solutions-architect.

Verifying observation, from the repository root, exit 0 and its
output the evidence:

```
python3 basis/tools/lint_basis.py
```

### Change made

Round 1 — maker: lead-solutions-architect, 2026-09-07.

- `basis/artifacts/initiative.md` — v11 → v12: optional frontmatter
  `parent` on the child, the link's one home; §7 Sub-initiatives on
  the parent, derived from the children's `parent` fields and held to
  them by the lint's check 13; the rule that a parent holds no
  features, is not bet on, has its measure moved by its
  sub-initiatives, and completes when all of them complete; a
  checklist row.
- `basis/guidelines/initiative.md` — v5 → v6: rule 8.
- `basis/fitness/initiative.fitness.md` — v5 → v6: scenario 8 and its
  compile-mapping row.
- `basis/tools/lint_basis.py` — check 13 added (`lint_sub_initiatives`,
  run by the tree walk): a `parent` naming no initiative, a parent
  with no Sub-initiatives section, a child missing from the list, and
  a listed entry no child's `parent` accounts for are each reported
  under the initiative typedef §Required sections 7; the docstring
  and the `lint` use's description say checks 1-13. Exercised on a
  throwaway parent/child pair, removed after: each disagreement kind
  reported, agreement clean.
- `basis/processes/initiative-check.md` — v9 → v10: the decide step's
  prompt says an initiative with a Sub-initiatives section is not bet
  on and a bet is taken on each sub-initiative alone, in its own run.
- `.claude/skills/initiative-check/SKILL.md` — re-rendered by
  `basis/tools/compile_process.py` from the v10 source (digest
  bc43f9ddb913 → 3e1d69efe9b4); byte-stable before the change.
- `basis/glossary.md` — v23 → v24: the sub-initiative entry.

Two things the checker should know. First, the guideline and the
fitness set are not renderings today: neither carries a `generated`
stamp, and `compile_typedef.py --check` on the typedef answers
`will-not-compile basis/artifacts/initiative.md check-failed: no
`## Writing rules` section` — the typedef has not yet been brought
under init-typedef-rendering. Both were hand-amended beside the
typedef, as their v5 rows record was done at typedef v11, and each
row says so. Second, `basis/tools/lint_basis.py` is the source of
the lint-basis skill at `.claude/skills/lint-basis/SKILL.md`, which
is outside paths and now stands stale against its source-digest;
its re-rendering is for the lead-pm to route.

Maker's evaluation against the Definition: statements 1 to 6 hold
in the changed artifacts; statement 7 holds for the one rendering
paths names that its tool produces (the initiative-check skill) and
cannot be shown for the guideline and fitness set, for the reason
above. Verifying observation run from the repository root:
`PASS: 0 violation(s)`, exit 0.

### Check

Round 1 — verdict: pass; checker: lead-pm, 2026-09-07. Each
acceptance statement holds against the changed artifacts: the
child's optional `parent` and no link field on the parent (typedef
v12 §Required frontmatter); §7 Sub-initiatives derived and held by
check 13; the no-features, no-bet, measure, and completion rule;
initiative-check v10's decide prompt; check 13 reporting each
disagreement kind and clean on agreement; the glossary entry (v24).
Statement 7 holds for the initiative-check skill; for the guideline
and fitness set the Definition named a rendering tool that does not
apply — the typedef is not yet under typedef rendering — and the
maker hand-amended both as the v11 precedent did, saying so in each
row; ruled conforming. Paths widened at this step, as at glossary
v23: the lint's own skill, `.claude/skills/lint-basis/SKILL.md`, was
re-produced from the lint's answer (digest 092f4fe2e9ee) so the
load-point check reads it current; no other change.

### Verified result

Observation: `python3 basis/tools/lint_basis.py` — output
`PASS: 0 violation(s)`, exit 0, 2026-09-07, by the lead-pm role. The
Definition, the Check's verdict by the lead-pm role, and this result
stand; between the request and this result no bet was taken and no
check of record was run.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded by the lead-pm at the request-intake process's record step from the authority's decisions in the run-efficiency discovery; route lane decided, said, and accepted; runs before the frame. |
| 2 | 2026-09-07 | update | Definition written by the lead-po at the small-change process's define step: judged a simple change by the glossary entry (within the lead shop's own definitions, no Bounded Context touched, demonstrable in one lint run); seven acceptance statements, seven artifacts with renderings and tools named, maker lead-solutions-architect, observation the lint run. Self-evaluation against the step's prompt: says what, never how; no artifact but the request touched. |
| 3 | 2026-09-07 | update | Checked and verified by the lead-pm role: pass, round 1; the lint's skill re-produced at the check step; the observation exit 0. Status done; work item lead-8yhpb closed. |
