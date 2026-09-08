---
type: request
id: req-2026-09-07-contributors-body
status: done
version: 6
date: 2026-09-07
reader: lead-pm
owner: lead-pm
created: 2026-09-07
updated: 2026-09-08
originator: lead-pm
received-through: operational-contract
route: small-change
route-reason: "one rule in the feature typedef's Contributors section — a contributor's criteria and constraints stand in the body; the reasoning behind them, what was considered and not made a criterion, and the maker's self-check stand in the Document History — within the lead shop's own definitions, demonstrable in one session, no appetite worth a bet"
routed-to: "requests/req-2026-09-07-contributors-body.md#result"
work-item: lead-ryr33
---

# Request: the Contributors section carries criteria, not reasoning

## 1. What is requested

The lead-pm, 2026-09-07, from the one screen of feat-tool-skills: the
cold reviewer found the Contributors section at about 315 lines
against a 70-line Gherkin block, and named three passages — what was
considered and not made a criterion, and the makers' principle
screens — that "serve no framed outcome and belong in Document
History (where the principles put the maker's evaluation), not in
the artifact body a shop reads to build." The PO moved them in the
one revise. The next feature's add-usability step was then launched
with that rule written into its instruction by hand — an ad-hoc
instruction the authority has said the lead-pm should not give. The
rule needs the home the roles load: the feature typedef's Contributors
section, and the feature fitness set if a scenario is wanted.

## 2. From whom

Reader: the lead-pm role. Originator: the lead-pm role, from the
screen's finding. Received through the lead shop's operational
contract, which has no artifact yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-07: **the small-change lane**.
Why: one rule in one typedef section — the body holds a contributor's
criteria and constraints, each riding by name on the scenarios it
bounds; the reasoning, what was considered and not made a criterion,
and the maker's self-check go in the Document History row of that
step. Within the lead shop's own definitions, demonstrable in one
session. Topic: "contributors' reasoning in Document History
(req-2026-09-07-contributors-body)".

Originator's answer: **accepted** — the originator is the lead-pm
role. The lane runs after init-tool-skills' second feature, not
beside it: the typedef the running feature is written under does not
change mid-flow.

## 4. Result

### Definition

req-2026-09-07-contributors-body — judged a simple change by the
glossary's entry: one rule in one section of the feature typedef and
the two texts the roles read beside it, all within the lead shop's own
definitions; no Bounded Context touched; the effect demonstrable in one
session by the lint and by the words standing in the three artifacts.

**What will be different.** The feature typedef's Contributors entry
states the rule the screen of feat-tool-skills applied by hand, so
that every feature authored under it carries the rule without an
ad-hoc instruction, and the feature guideline and feature fitness set
say the same thing in their own forms — the guideline as a writing
rule the maker follows, the fitness set as a scenario the cold
reviewer decides. Nothing else in the three artifacts changes.

- Given the feature typedef at version 12, when the change is done,
  then its Contributors entry (Required sections, item 2) states that
  the body of the Contributors section holds a contributor's criteria
  and constraints — each riding by name on the scenarios it bounds —
  and that the reasoning behind them, what was considered and not made
  a criterion, and the maker's self-check stand in the Document
  History row of the step that added them, not in the body; and the
  typedef differs from version 12 only in that entry, its version,
  its `updated` date, and one Document History row naming this
  request.
- Given the feature guideline at version 8, when the change is done,
  then it carries one writing rule saying the same — the Contributors
  body holds criteria and constraints; reasoning, what was considered
  and not made a criterion, and the maker's self-check go in the
  Document History row — and differs from version 8 only in that rule,
  its version, its `updated` date, and one Document History row naming
  this request.
- Given the feature fitness set at version 8, when the change is done,
  then it carries one scenario the cold reviewer can decide from the
  feature alone: a Contributors section whose body carries reasoning,
  what was considered and not made a criterion, or a maker's
  self-check fails, with the passage named; one whose body carries
  criteria and constraints only passes; and the fitness set differs
  from version 8 only in that scenario, its version, its `updated`
  date, and one Document History row naming this request.
- Given the three artifacts changed, when the lint runs over the
  basis tree, then it reports nothing.
- Given any feature authored after the change, when the PO output
  check screens it, then the criterion the screen of feat-tool-skills
  applied by hand stands in the fitness set by name, and the
  add-usability and add-constraints steps need no instruction beyond
  the guideline.

**Artifacts the change touches.** None is a rendering: the feature
typedef carries no `## Writing rules` or `## Fitness scenarios`
section, so the compile-typedef tool does not produce the two texts
from it; each of the three is an approved document edited in place
and read by the roles as it stands.

- `basis/artifacts/feature.md` — the feature typedef, its Contributors
  entry
- `basis/guidelines/feature.md` — the feature guideline, the maker's
  text
- `basis/fitness/feature.fitness.md` — the feature fitness set, the
  cold reviewer's text

**Maker role.** lead-solutions-architect.

**Verifying observation.** One command from the repository root; exit
0 shows the effect, and its output — the lint's silence, then one
`rule present` line per artifact naming this request's row — is the
evidence:

```sh
python3 basis/tools/lint_basis.py && for f in basis/artifacts/feature.md basis/guidelines/feature.md basis/fitness/feature.fitness.md; do t="$(tr -s '[:space:]' ' ' < "$f")"; case "$t" in *"not made a criterion"*"Document History"*|*"Document History"*"not made a criterion"*) ;; *) echo "rule missing: $f"; exit 1;; esac; grep -q "req-2026-09-07-contributors-body" "$f" || { echo "history row missing: $f"; exit 1; }; echo "rule present: $f"; done
```

### Change made

**Round 1** — 2026-09-08. Maker: the lead-solutions-architect role.
Each artifact amended in place through its own form, the three edited
by hand as the Definition says (none is a rendering; compile-typedef
not run). Paths changed, version before → after:

- `basis/artifacts/feature.md` — 12 → 13. The Contributors entry
  (Required sections, item 2) now states that the body holds a
  contributor's criteria and constraints — each riding by name on the
  scenarios it bounds — and nothing else; the reasoning behind them,
  what was considered and not made a criterion, and the maker's
  self-check stand in the Document History row of the step that added
  them. Also changed: `version`, `updated`, one Document History row
  citing this request. The checklist, rules, and every other section
  untouched.
- `basis/guidelines/feature.md` — 8 → 9. Rule 7 added in the
  guideline's Before/After/Test/Criterion/Decision form, derived check
  feature fitness scenario 7. Also changed: `version`, `updated`, one
  Document History row. The Highlights line untouched.
- `basis/fitness/feature.fitness.md` — 8 → 9. Scenario 7 added — a
  Contributors body carrying reasoning, what was considered and not
  made a criterion, or a maker's self-check fails with the passage
  named; one carrying owning shops, criteria, and constraints only
  passes; the judge reads the feature alone — with its row in the
  Compile mapping table, which the set's form requires for every Then.
  Also changed: `version`, `updated`, one Document History row.

Self-check against the Definition before submitting to the check:
the verifying observation run from the root exits 0 — the lint
reports `PASS: 0 violation(s)` and prints `rule present` for each of
the three paths; `git diff -U0` over the three artifacts shows hunks
only at `version`, `updated`, the one entry, rule, or scenario (the
scenario with its mapping row), and the one history row, so each
differs from its prior version only where its acceptance statement
allows. The fifth statement (a later feature's screen needing no
instruction beyond the guideline) is observable only at the next PO
output check and is left to it. Nothing read beyond the Definition and
the three paths.

### Check

**Round 1** — 2026-09-08. Verdict: **pass**. Check role: lead-pm (the
request's owner; not the maker). Finding: none.

Read: the Definition, the round-1 Change made entry, and the three
artifacts at `paths`; run: the Definition's verifying observation
(exit 0 — `PASS: 0 violation(s)`, then `rule present` for each path)
and `git diff -U0 HEAD` over the three paths. Statement 1 holds: the
Contributors entry states the rule, and the typedef's hunks are
`version`, `updated`, that entry, and one history row. Statement 2
holds: rule 7 says the same in the guideline's form; hunks confined
likewise. Statement 3 holds: scenario 7 fails a body carrying
reasoning, what was considered and not made a criterion, or a maker's
self-check, with the passage named, passes one carrying owning shops,
criteria, and constraints only, and reads the feature alone; the
scenario's row in the Compile mapping table is the set's own form for
every Then — the scenario as this artifact carries it — not a change
beyond it. Statement 4 holds: the lint reports nothing. Statement 5:
the criterion stands in the fitness set by name (scenario 7) and rule
7 carries what the add-usability and add-constraints steps need; the
runtime half is observable only at the next PO output check, as the
maker recorded. Change rules: every history row cites this request;
every version bumped (12 → 13, 8 → 9, 8 → 9); none of the three carries
a `generated` or `source-digest` stamp, so no rendering was edited by
hand; `changed` equals `paths`.

### Verified result

2026-09-08. Recorded by the lead-pm role at the small-change lane's
record step. The effect is demonstrated in the running system by the
verifying observation the Definition named — the one command from the
repository root: the lint over the basis tree, then the rule-and-row
check over each of the three artifacts. Its evidence, the output lines
and the closing exit:

```
PASS: 0 violation(s)
rule present: basis/artifacts/feature.md
rule present: basis/guidelines/feature.md
rule present: basis/fitness/feature.fitness.md
exit 0
```

The Definition (written by the lead-po role), the Check's verdict of
pass by the lead-pm role (round 1), and this result stand. Between the
request and this result no bet was taken and no check of record was
run: the change reached its verified result through the lane alone —
define, make, check, verify, record. The fifth acceptance statement's
runtime half — a later feature's screen needing no instruction beyond
the guideline — is observable at the next PO output check, as the
maker and the checker recorded; the criterion it needs stands in the
fitness set by name.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded by the lead-pm at the request-intake process's record step from the screen's finding on feat-tool-skills (its Document History v3) and the ad-hoc instruction given at feat-tool-skills-rest's add-usability step; route decided, said, and accepted; the lane runs after the second feature. |
| 2 | 2026-09-07 | update | Taken up by the first router run (anchors lead-5wzgl for intake, lead-ryr33 for the lane): the lane's define and make steps ran on the cheap model, and make changed the feature typedef beyond the Definition; that change is reverted and the lane re-runs from lead-ryr33 once the roles' model tier is set. |
| 3 | 2026-09-07 | update | Definition written at the small-change lane's define step (re-run from lead-ryr33 on the fable tier): judged simple by the glossary's entry; five acceptance statements, each bounding the change to the one rule so the make step's earlier overreach cannot recur; three artifacts named, none a rendering (the feature typedef has no writing-rules or fitness-scenarios section, confirmed by listing its sections, so compile-typedef does not apply); maker lead-solutions-architect; observation checked to fail before the change. Self-check against the step's definition: what, not how — the statements name the rule's content and its home, not the wording; every path listed; one command from the root. Beyond the named reads, the step listed the basis tree for the three paths and the typedef's section heads, and loaded the compile-typedef skill to settle whether the texts are renderings. |
| 4 | 2026-09-08 | update | Change made at the small-change lane's make step, round 1, by the solutions architect role: feature typedef 12 → 13 (Contributors entry), feature guideline 8 → 9 (rule 7), feature fitness set 8 → 9 (scenario 7 with its rubric row); verifying observation exits 0; each artifact's diff confined to what its acceptance statement allows. |
| 5 | 2026-09-08 | review | Checked at the small-change lane's check step, round 1, by the lead-pm role against the Definition alone: pass, no finding — every acceptance statement holds on the three artifacts and the verifying observation (exit 0), and every change went through its artifact's own rules (history row citing this request, version bumped, no rendering hand-edited, changed paths equal to the named paths). |
| 6 | 2026-09-08 | update | Verified result recorded at the small-change lane's record step by the lead-pm role: the Definition's verifying observation run from the root exits 0 — `PASS: 0 violation(s)`, then `rule present` for each of the three artifacts — so the effect is demonstrated in the running system; the Definition, the round-1 check's pass by the lead-pm role, and this result stand; no bet taken and no check of record run between the request and the result. Status set to done. |
| 7 | 2026-09-08 | update | Routed-to field recorded at the request-intake process's land-result step by the lead-pm role: the change output from the small-change lane (the request's Result section by fragment) written to routed-to, completing the request's small-change route through the lane. |
