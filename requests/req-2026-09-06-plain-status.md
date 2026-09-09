---
type: request
id: req-2026-09-06-plain-status
status: done
version: 7
date: 2026-09-06
reader: lead-pm
owner: lead-pm
created: 2026-09-06
updated: '2026-09-09'
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: one rule added to the base writing style guideline the lead-pm's prose
  and every rendered role load — state what is being waited on plainly, never a shorthand
  for the state of the work — within the lead shop's own definitions, demonstrable
  in one session, no appetite worth a bet
routed-to: requests/req-2026-09-06-plain-status.md#result
work-item: lead-jsqmr
---

# Request: status is said plainly

## 1. What is requested

The product authority, 2026-09-06, on the lead-pm's habit of ending
turns with "nothing else is independent": "What is meant by nothing
else is independent?" — and, on the lead-pm's undertaking to say it
plainly from then on: "How will you know to say that from here after
the session ends?"

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose directly, in conversation.

## 3. Route

Route said by the lead-pm role, 2026-09-06: **the small-change lane**.
Why: the correction needs a home a later session loads; the transcript
is not one and memory writes are frozen at handoff. The home is the
base writing style guideline, which the lead-pm's prose and every
rendered role load: one rule — when work is waiting, say what it is
waiting on and on whom, in plain words; never a shorthand for the state
of the work. Within the lead shop's own definitions, demonstrable in
one session. Topic: "status said plainly (req-2026-09-06-plain-status)".

Originator's answer: **accepted** — the authority's order for the
session of 2026-09-09 names this among the three lane items to run.
The route stands as said; the lane runs on the register item named in
the `work-item` field, which points at this request by id and carries
nothing of what was asked.

## 4. Result

### Definition

req-2026-09-06-plain-status — defined by the lead-po role, 2026-09-09,
at the small-change lane's define step. Judged against the glossary's
simple change entry: the change stays within one instance of the lead
shop's own definitions — the base writing style guideline, which the
lead-pm's prose and every rendered role load — touches no Bounded
Context, and its effect is demonstrable in the running system, by
reading the changed guideline, in one session.

What will be different when the change is done: the base writing
style guideline gains one rule — when work is waiting, the writer
says what it is waiting on and on whom, in plain words, never a
shorthand for the state of the work.

Acceptance:

- **Given** the base writing style guideline at
  `basis/guidelines/base-writing-style.md`, **when** the change is
  done, **then** it carries a rule stating that when work is waiting,
  the writer says what it is waiting on and on whom, in plain words,
  and never uses a shorthand for the state of the work in its place;
  and no existing rule in the guideline is changed or removed.
- **Given** that guideline, **when** the change is done, **then** its
  Document History carries a new row citing this request by id
  (`req-2026-09-06-plain-status`), and its version is bumped.
- **Given** the basis tree, **when** the change is done, **then** the
  lint passes.

Artifacts the change touches (paths):

- `basis/guidelines/base-writing-style.md` — the guideline; no
  rendering of it exists, so it is the sole artifact the change
  touches.

Maker: lead-solutions-architect — the role the make step runs by.

Verifying observation — one command, run from the repository root;
exit 0 shows the effect in the running system and its output is the
evidence:

```
python3 basis/tools/lint_basis.py && grep -n "shorthand for the state of the work" basis/guidelines/base-writing-style.md
```

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-09, at
the small-change lane's make step.

Paths changed this round:

- `basis/guidelines/base-writing-style.md` — version 3 → 4. Under
  "Sentences and words," one bullet added: when work is waiting, say
  what it is waiting on and on whom, in plain words; never use a
  shorthand for the state of the work in its place. No existing rule
  changed or removed. `updated` set to 2026-09-09. One Document
  History row added citing this request by id.

Nothing outside paths changed by the maker. Self-check against the
acceptance statements before this write: the added bullet states the
rule as the Definition gives it, no existing rule in the guideline is
touched, the Document History row cites this request and the version
is bumped. Verifying observation run and passing: lint exits 0, and
the grep for "shorthand for the state of the work" finds a match in
the changed guideline.

### Check

**Round 1** — verdict: **pass**. Checker: the lead-pm role, 2026-09-09,
at the small-change lane's check step. Finding: none.

Judged against the Definition alone. The first acceptance statement
holds: the guideline carries the rule under "Sentences and words" —
when work is waiting, say what it is waiting on and on whom, in plain
words; never use a shorthand for the state of the work in its place —
and the diff against the committed version shows no existing rule
changed or removed. The second holds: Document History row 4 cites
`req-2026-09-06-plain-status`, version 3 → 4. The third holds: the
verifying command run from the repository root exits 0 — lint reports
0 violations and the grep finds the phrase at line 33. Producing rules:
the history row cites the request, the version is bumped, the
Definition records no rendering of the guideline so none was edited by
hand, nothing was made the Definition does not cover, and the one path
in changed is the one path in paths.

### Verified result

Verified by the lead-pm role, 2026-09-09, at the small-change lane's
verify step. The verifying observation the Definition named — one
command, run from the repository root:

```
python3 basis/tools/lint_basis.py && grep -n "shorthand for the state of the work" basis/guidelines/base-writing-style.md
```

Evidence — the output captured on that run, and the closing exit
status:

```
vocabulary residue: 19 files
PASS: 0 violation(s)
33:  plain words; never use a shorthand for the state of the work in its
65:| 4 | 2026-09-09 | update | One rule added under req-2026-09-06-plain-status: when work is waiting, say what it is waiting on and on whom, in plain words, never a shorthand for the state of the work; no existing rule changed. |
exit 0
```

The lint passes with 0 violations; the grep finds the rule's phrase at
line 33 of the guideline, in the added rule, and at line 65, in the
Document History row that cites this request; the command exits 0.
The effect is demonstrated in the running system — the guideline the
lead-pm's prose and every rendered role load now carries the rule.

The Definition, the Check's verdict of pass by the lead-pm role
(round 1), and this result stand. Between the request and this result
no bet was taken and no check of record was run: the change ran the
small-change lane, which carries no initiative, no bet, and no check
of record.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Recorded by the lead-pm at the request-intake process's record step from the authority's two questions, read as an ask for the correction to survive the session; route decided and said; awaiting the originator's answer. |
| 2 | 2026-09-09 | update | The originator's answer: the product authority's order for the session of 2026-09-09 names this among the three lane items to run; taken as accept, landed by the request-intake process from its land step. |
| 3 | 2026-09-09 | update | Landed by the lead-pm at the request-intake process's land step: the originator's answer written in section 3 as accepted; the route stands as said with its reason; the small-change lane's register work item opened — lead-jsqmr, titled with this request's id and slug, carrying nothing of what was asked — and its id written in the `work-item` field (no earlier item to replace). Checked against the step's definition of good before submitting: answer recorded, work item opened and named, route and reason untouched. |
| 4 | 2026-09-09 | update | Definition written by the lead-po role at the small-change lane's define step: judged a simple change by the glossary's entry; one artifact (`basis/guidelines/base-writing-style.md`, no rendering of it), three acceptance statements, maker lead-solutions-architect, one verifying command (lint plus a grep for the rule's phrase). No artifact but this request touched. Self-check against define-good-up-front: the definition says what — the rule's substance and the phrase a checker can decide against the changed guideline — never how it is placed in the guideline's structure. |
| 5 | 2026-09-09 | update | Check written by the lead-pm role at the small-change lane's check step, round 1: verdict pass, no finding — each acceptance statement decided against the changed guideline and the verifying command's exit 0, each change against the artifact's producing rules; changed equals paths. Only this request touched. |
| 6 | 2026-09-09 | update | Verified result written by the lead-pm role at the small-change lane's verify step: the verifying command run from the repository root, its output lines and exit 0 recorded as evidence; the Definition, the Check's pass, and this result stand; no bet taken and no check of record run between the request and this result. Status set to done. Only this request touched. |
| 7 | 2026-09-09 | update | Where the route led written into `routed-to` — this request's own Result section by fragment, `requests/req-2026-09-06-plain-status.md#result`, the `change` the small-change lane returned — by the lead-pm role at the request-intake process's land-result step. Nothing the lane wrote written twice: the Definition, Check, and Verified result stand as the lane left them, status done stands, and the work item lead-jsqmr was already closed by the lane as done. Self-check against the step's definition of good before submitting: `routed-to` filled with the fragment the lane returned, one history row added, version bumped, no other part of this request and no other artifact touched.
