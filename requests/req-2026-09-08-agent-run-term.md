---
type: request
id: req-2026-09-08-agent-run-term
status: done
version: 15
date: 2026-09-08
reader: lead-pm
owner: lead-pm
created: 2026-09-08
updated: 2026-09-09
originator: product-authority
received-through: operational-contract
arose-in: init-run-measurement
route: small-change
route-reason: "decided again by the lead-pm role after the lane failed at its cap on the definition alone: the change stands made in every live artifact; the verifying observation reads each artifact outside its Document History section, as the lint's check 14 does, since a standing history row is never rewritten; demonstrable in one session"
routed-to: "requests/req-2026-09-08-agent-run-term.md#result"
work-item: lead-s4t1d
---

# Request: "agent run" is "step"

## 1. What is requested

Found in the authority's exchange with the implementer of run
measurement, 2026-09-08: the feature, the run-cost typedef,
session-handoff's outcome O5, and write_cost_rows.py say "agent run"
for what the glossary defines as a step. "Run" itself is defined —
one execution of a process on one anchor — and stays.

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract (lead-4kymc).

## 3. Route

The small-change lane: "agent run" becomes "step" (agent step or
human step where it matters) in features/feat-run-measurement.md,
basis/artifacts/run-cost.md, basis/processes/session-handoff.md, and
basis/tools/write_cost_rows.py with its skill re-produced. A changed
scenario text is a new scenario by hash. Accepted.

Originator's answer: accepted. Work item: lead-s4t1d, opened on the
second pass after lead-99scn closed at the lane's round cap; the
route stands as small-change for the reason the front-matter gives.

## 4. Result

### Definition

req-2026-09-08-agent-run-term: when done, "agent run" is gone from
the lead shop's own definitions this request names, in every part but
the standing account a Document History row keeps of what its own
step actually did; every other place it named a step reads the
glossary's term; "run" — one execution of a process on one anchor —
is unchanged everywhere it does not mean a step.

- Given features/feat-run-measurement.md, basis/artifacts/run-cost.md,
  basis/processes/session-handoff.md, and basis/tools/write_cost_rows.py
  as changed, when each is read on the lines above its own `##
  Document History` heading (in full, for a file carrying none), then
  none contains the phrase "agent run"; every place that phrase named
  a step now reads "step", "agent step", or "human step", fitting the
  local sense, and every place "run" named an execution of a process
  on one anchor stands unchanged. A Document History row's own
  account of a past step is outside this statement: a standing row is
  never rewritten.
- Given basis/tools/write_cost_rows.py after the rename, when
  basis/tools/compile_tool.py produces its skill at
  .claude/skills/write-cost-rows/SKILL.md, then the produce use exits
  0 and the written skill carries no occurrence of "agent run".

Artifacts touched: features/feat-run-measurement.md,
basis/artifacts/run-cost.md, basis/processes/session-handoff.md, and
basis/tools/write_cost_rows.py; its rendering
.claude/skills/write-cost-rows/SKILL.md, produced by
basis/tools/compile_tool.py. Maker role: lead-solutions-architect.
Verifying observation: `! ( for f in features/feat-run-measurement.md basis/artifacts/run-cost.md basis/processes/session-handoff.md basis/tools/write_cost_rows.py; do awk '/^## Document History/{exit} {print}' "$f"; done | grep -q "agent run" ) && python3 basis/tools/compile_tool.py basis/tools/write_cost_rows.py --load-point .claude/skills && git diff --quiet -- .claude/skills/write-cost-rows/SKILL.md && ! grep -q "agent run" .claude/skills/write-cost-rows/SKILL.md`,
exit 0. Defined by the lead-po role at the define step, against the
glossary's simple-change entry and the request's Route: the change
stays within the lead shop's own definitions, touches no Bounded
Context, and its effect is demonstrable in one session — simple; the
observation excludes each artifact's own Document History section, as
basis/tools/lint_basis.py check 14 does for the sibling vocabulary
measure, per this second pass's route-reason.

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-09, at
the small-change lane's make step.

Paths changed this round:

- `basis/artifacts/run-cost.md` — version 3 → 4. The retired phrase
  replaced by "step" in the Identity and ancestry bullet and Required
  sections item 1; `run` as the instance noun untouched, out of scope.
- `basis/processes/session-handoff.md` — version 6 → 7. The retired
  phrase replaced by "step" in outcome O5 and its Derived checks row;
  `run_anchor` and `run` as the instance noun untouched; the Flow
  diagram unaffected, not re-rendered.
- `basis/tools/write_cost_rows.py` — no version field (git-tracked
  tool). The retired phrase replaced by "step" in the module
  docstring and in the literal text the tool writes into a run-cost
  instance's body; the `--describe` answer's `DESCRIPTION` dict
  already read "agent or human step," unchanged.
- `.claude/skills/write-cost-rows/SKILL.md` — re-produced via
  `python3 basis/tools/compile_tool.py basis/tools/write_cost_rows.py
  --load-point .claude/skills`; digest unchanged, `sha256:d32b2af40cc8`
  before and after, since the `--describe` answer it renders from
  never carried the retired phrase; `git diff --quiet` confirms no
  drift.
- `features/feat-run-measurement.md` — version 10 → 11. The retired
  phrase replaced by "step" or "agent step" (matching the sibling
  ", restated" scenario's own choice of "agent execution" over the
  bare noun) in the Feature narrative (both copies), the Contributors
  bullet and two Edges rows naming the same scenario, and the
  Given/When/Then text of the three already-superseded scenarios
  `@hash:2eda37f33645`, `@hash:475294f4bb30`, `@hash:a156efde14c9` —
  reopening the v10 no-edit-in-place commitment for these three since
  they are dead (fully superseded by the "execution" restatements
  that carry the live requirement) and this request's own Route
  accepted a changed scenario text as a new scenario by hash; their
  `@hash:` tags left as before, a disclosed mismatch feature fitness
  scenario 3 does not judge. `run` as the instance noun left
  unchanged throughout, out of scope. One new Document History row
  per touched definition, citing this request.

Not fully passing: the verifying observation exits 1 on
`features/feat-run-measurement.md`. The residue is confined to that
file's Document History rows 1, 4, 9, and 10, written 2026-09-08 and
2026-09-09 under earlier steps, each carrying the retired phrase in
its own account of what happened at the time. A Document History
section is a governed, append-only record — never edited in place,
the same rule `basis/tools/lint_basis.py`'s check 14 states for the
sibling "run"-to-"execution" vocabulary measure, excluding Document
History from its own scan for the same reason. Rewriting those four
rows to remove the phrase would misstate what those steps' makers
actually recorded at the time; this maker judged that violation
worse than the check's unmet exit code, and left them standing. Every
other named acceptance statement holds: no live definition, schema,
scenario the request names as owned, or tool output carries the
retired phrase; the skill re-produces clean and undrifted. Escalated
for the check step to decide this gap — accept it as a
recorded exception, or amend the verifying observation to exclude
Document History as check 14 does.

Self-check against `define-good-up-front`: every artifact's own
producing rules honored — a definition amended with a Document
History row citing this request and a version bump; the run-cost
typedef's, session-handoff-process's, and feature's own field and
scenario forms unchanged, wording only; the skill re-rendered by its
tool, never hand-edited; nothing amended that this request's
Definition does not name.

**Round 2** (repair) — maker: the lead-solutions-architect role,
2026-09-09, at the small-change lane's make step, on round 1's check
findings.

Path changed this round:

- `features/feat-run-measurement.md` — version 11 → 12. Finding 2
  repaired: the feature typedef's rule (v18, Rules) that a changed
  scenario text is a new scenario with a new `@hash:` was unmet for
  the three scenarios whose Given/When/Then round 1 edited under
  their old tags. Repaired by minting a new hash for each, computed
  by `python3 basis/tools/artifact_tools.py fill-hash
  features/feat-run-measurement.md --scenario <name>`: `a session
  close records a cost row for each agent step` — `@hash:2eda37f33645`
  → `@hash:9e10b116b46f`; `a field the harness withholds is left
  blank` — `@hash:475294f4bb30` → `@hash:9d92ed6fc1dd`; `minutes are
  recorded as wall-clock time` — `@hash:a156efde14c9` →
  `@hash:c89f144bfa9e`. Chosen over the check's other named conforming
  form (restoring the three texts) because that form needs the
  Definition itself to exclude superseded scenarios alongside
  Document History — a Definition change, closed to this maker at the
  make step — while minting new hashes conforms to the typedef's rule
  as already written, reachable within `paths` alone. Consequence
  disclosed, not fixed: `guidance/feat-run-measurement-shopsystem-product.md`
  still cites the three old hashes; it is outside this request's
  named `paths` and not touched. One new Document History row
  (version 12) recording the repair.

Not repaired, same as round 1's maker escalated: finding 1
(`features/feat-run-measurement.md`'s Document History rows 1, 4, 9,
10 carrying the retired phrase). The check found no rule authorizing
a rewrite of a standing history row in place, and the fitting
repair — excluding Document History from acceptance statement 1 and
the verifying observation, as `basis/tools/lint_basis.py` check 14
already does for the sibling measure — is a change to the Definition.
The Definition is not this maker's to edit at the make step ("the
definition is not yours to edit, and paths is the whole of what you
may change"); left standing, unrepaired, for the define role to
carry forward. The verifying observation, re-run this round, still
exits 1 on `features/feat-run-measurement.md` alone, on this same
disclosed and unrepaired residue; no other artifact or the skill
carries the retired phrase, and the skill re-produces clean and
undrifted.

Self-check against `define-good-up-front`: the typedef's own rule (a
changed scenario text takes a new `@hash:`) now holds for all three
scenarios; no scenario's Given/When/Then re-touched this round, only
its tag line; every other path in `paths` left untouched, since the
check's findings named only this file; nothing amended that the
Definition does not name; finding 1 named plainly as unreachable
within this maker's role rather than worked around.

**Round 3** (repair) — maker: the lead-solutions-architect role, 2026-09-09,
at the small-change lane's make step, on round 2's check finding.

Verified first, by reading, that round 3's premise still holds: read
`requests/req-2026-09-08-agent-run-term.md` section 4 in full, and
both rounds' Change made and Check entries — round 1's finding 2 is
repaired and verified (round 2's check confirms it); round 1's finding
1 (Document History rows 1, 4, 9, 10) and round 2's newly-read (b) (the
Interaction types section, then lines 58–59) both stood unrepaired
going into this round, exactly as the check_finding states.

Path changed this round:

- `features/feat-run-measurement.md` — version 12 → 13. Round-2 finding
  1(b) repaired: the Interaction types section carried the retired
  phrase, split across a line break, inside a passage opened and closed
  with quotation marks as a direct quotation of the initiative's
  Framing section — a document outside this request's `paths` and
  outside this role's authority to change. Rewriting the quoted words
  to the substitute term would misquote that unedited source, the same
  defect the checker found in rewriting a Document History row, so
  that path was not taken. Repaired instead by dropping the quotation
  marks and restating the passage in the feature's own words, matching
  the wording this request already gave the Feature narrative at v11
  ("cost metrics for each step ... so any run can be analysed on
  request"): the passage no longer presents itself as a verbatim
  quotation of another artifact, so no source-fidelity rule is
  engaged, and the retired phrase is gone from this occurrence under
  the Definition's own rule that every place the phrase named a step
  now reads the substitute. `run` as the instance noun ("any run can be
  analysed on request") left unchanged, out of this request's scope.
  Judged within this role's authority as a feature wording matter under
  `paths`: the Interaction types section is ordinary drafted body
  content, revised across this feature's own v2, v4, v5, and v6 —
  unlike Document History, no rule (the feature typedef, the feature
  fitness set's scenario 5, or otherwise) binds it to quote its source
  verbatim; fitness scenario 5 asks only that the "none" reason be one
  "the framing bears out," not that it quote the framing's words
  unchanged. One new Document History row (version 13) recording the
  repair.

Not repaired, same as both prior rounds: finding 1(a)
(`features/feat-run-measurement.md`'s Document History rows 1, 4, 9,
10 carrying the retired phrase). No rule authorizes rewriting a
standing history row in place, and the checker's own named repair —
excluding Document History from acceptance statement 1 and the
verifying observation — is a change to the Definition, which is not
this maker's to edit at the make step; left standing for the define
role, as both round 1's and round 2's makers also escalated it. The
verifying observation, re-run this round, exits 1 on
`features/feat-run-measurement.md` alone, on this same disclosed and
unrepaired residue; the other three artifacts and the skill read
clean, and the skill re-produces with exit 0 and no drift
(`sha256:d32b2af40cc8` before and after).

Self-check against `define-good-up-front`: the Definition's own rule
("every place that phrase named a step now reads 'step', 'agent
step', or 'human step'") now holds for the (b) occurrence, closed
without touching the initiative or any artifact outside `paths`; no
scenario, tag, or other section of this file touched this round; the
one path changed is in `paths`; finding 1(a) named plainly as
unreachable within this maker's role rather than worked around.

**Round 1, second pass** — maker: the lead-solutions-architect role,
2026-09-09, at the small-change lane's make step, on the second pass's
fresh Definition (the define role's rewrite recorded at Document
History version 12, excluding each artifact's own Document History
section from the "no retired phrase" check).

Verified first, by reading: the Definition's acceptance statement 1,
run over each of the four named artifacts on the lines above its own
`## Document History` heading, and statement 2, over the skill's
re-production. Ran the verifying observation exactly as the Definition
states it: `! ( for f in features/feat-run-measurement.md
basis/artifacts/run-cost.md basis/processes/session-handoff.md
basis/tools/write_cost_rows.py; do awk '/^## Document History/{exit}
{print}' "$f"; done | grep -q "agent run" ) && python3
basis/tools/compile_tool.py basis/tools/write_cost_rows.py
--load-point .claude/skills && git diff --quiet --
.claude/skills/write-cost-rows/SKILL.md && ! grep -q "agent run"
.claude/skills/write-cost-rows/SKILL.md` — exits 0: no artifact
carries the retired phrase above its own Document History heading; the
skill re-produces with exit 0, `git diff --quiet` holds (digest
`sha256:d32b2af40cc8` unchanged), and the rendered skill carries no
occurrence of the retired phrase.

The four artifacts stand exactly as the first pass's round 3 left
them — `features/feat-run-measurement.md` at version 13 (the
Interaction types quotation restated in the feature's own words, the
three superseded scenarios re-hashed, the retired phrase gone
everywhere but its own Document History rows 1, 4, 9, 10), `basis/artifacts/run-cost.md`
at version 4, `basis/processes/session-handoff.md` at version 7, and
`basis/tools/write_cost_rows.py` unversioned with its skill
re-produced at digest `sha256:d32b2af40cc8` — nothing was reverted
between passes. The one thing the first pass could not close — finding
1(a), the phrase standing in `features/feat-run-measurement.md`'s
Document History rows 1, 4, 9, 10 — is exactly what this pass's
rewritten Definition now excludes from acceptance statement 1 and the
verifying observation; those four rows still carry the phrase, in
their own standing account of what earlier steps did, and remain
untouched, since a Document History row is never rewritten and the
Definition no longer asks that they be.

No path needed changing. Paths changed this round: none. `changed`
returned as an empty list.

Self-check against `define-good-up-front`: read the Definition and
both prior passes' Change made and Check entries before acting; ran
the verifying observation itself rather than assuming its outcome; a
definition or typedef amended under a request-recording decision
applies only when a change is needed, and none was — the artifacts as
they stand already meet every acceptance statement of the Definition
as currently written; nothing amended that the Definition does not
cover, including nothing amended where nothing was needed.

### Check

**Round 1** — check: the lead-pm role, 2026-09-09, at the small-change
lane's check step. Verdict: **fail**.

Finding 1 — acceptance statement 1 and the verifying observation do
not hold. Statement 1: "Given features/feat-run-measurement.md,
basis/artifacts/run-cost.md, basis/processes/session-handoff.md, and
basis/tools/write_cost_rows.py as changed, when read, then none
contains the phrase "agent run"". Read at this step:
features/feat-run-measurement.md contains the phrase in Document
History rows 1, 4, 9, and 10 (lines 147, 150, 155, 156); the
verifying observation, run here, exits 1 on that file. The other
three artifacts and the skill read clean, and the skill re-produces
with no drift. The Definition carves nothing out of the file; the
shop's precedent for the sibling measure (basis/tools/lint_basis.py
check 14) carves Document History out in so many words, and this
Definition did not. Judged against the Definition as written, the
statement fails. For round 2, the checker's recommendation and the
define role's call: rewriting those rows is not a conforming repair —
no definition rule authorizes rewriting a history row, and doing so
would misstate what earlier makers recorded; the fitting repair is a
definition change at the define step, statement 1 and the verifying
observation excluding the Document History section as check 14 does.

Finding 2 — a change did not go through the feature's own producing
rules. Feature typedef (v18), Rules: "A changed scenario text is a
new scenario with a new `@hash:`." The Given/When/Then of the
scenarios tagged @hash:2eda37f33645, @hash:475294f4bb30, and
@hash:a156efde14c9 was changed this round with each tag left as
before; this request's own Route states the same rule ("A changed
scenario text is a new scenario by hash"). The maker's note that
fitness scenario 3 does not judge the mismatch is right and beside
the point: scenario 3 says so itself ("whether the hash matches the
text is a lint, not this judge's"), and this step judges the
producing rule, not the fitness set. Two conforming forms, the define
and make steps' to choose: the three changed texts take new hashes
(guidance/feat-run-measurement-shopsystem-product.md cites the old
ones — a consequence to weigh); or the three superseded scenarios'
text returns to what it was — a record of what was specified, like a
history row, the live requirement carried by their "execution"
restatements — and the Definition excludes superseded scenarios
alongside Document History. init-execution-vocabulary's appetite
("no edit in place of a delivered artifact — supersede it") is
another initiative's no-go, not this request's Definition, and is not
the failing rule here.

Conforming, for the record: each of the three definitions carries a
history row citing this request and a version bump (run-cost 3 → 4,
session-handoff 6 → 7, feat-run-measurement 10 → 11); no rendering
edited by hand; every path in changed is in paths; `run` as the
instance noun left where it does not mean a step.

**Round 2** — check: the lead-pm role, 2026-09-09, at the small-change
lane's check step, judged fresh against the Definition and each
artifact's own producing rules. Verdict: **fail**.

Round 1's finding 2 is repaired and conforms. The feature typedef's
rule ("A changed scenario text is a new scenario with a new
`@hash:`") now holds: the three scenarios' tags read
@hash:9e10b116b46f, @hash:9d92ed6fc1dd, and @hash:c89f144bfa9e, and
each was recomputed at this step — by `artifact_tools.py fill-hash`
on a copy of the file and by an independent sha256 of the
Scenario/Given/When/Then lines — and matches its current text. No
Given/When/Then was re-touched this round; only the three tag lines
changed. Conforming, for the record: the history row (v12) cites
this request; version 11 → 12; no rendering edited by hand (the
skill re-produces with exit 0 and `git diff --quiet` holds); the one
path in changed is in paths; nothing made that the Definition does
not cover — the request's own Route accepts a changed scenario text
as a new scenario by hash.

Finding 1 — acceptance statement 1 and the verifying observation
still do not hold. Statement 1: "Given features/feat-run-measurement.md,
basis/artifacts/run-cost.md, basis/processes/session-handoff.md, and
basis/tools/write_cost_rows.py as changed, when read, then none
contains the phrase "agent run"". Read at this step,
features/feat-run-measurement.md contains the phrase in two places:
(a) Document History rows 1, 4, 9, and 10 (lines 147, 150, 155,
156), the residue round 1 named and round 2 disclosed as unrepaired;
and (b) the Interaction types section, lines 58–59, where the
initiative's framing is quoted with "agent" ending one line and
"run" beginning the next — a line-based grep cannot see it, which is
why the verifying observation never reported it, but the file, when
read, contains it. The verifying observation, re-run here, exits 1
on this file alone; the other three artifacts and the skill read
clean, with and without line wrapping. The Definition carves nothing
out of the file, so the statement fails as written. A disclosed gap
the make role has no authority to close is still a gap: this step
judges the Definition as written, and the step's own rule allows
pass only when every statement holds, so the verdict cannot be pass
while the Definition stands unamended. This maker did nothing wrong
in leaving it — rewriting a standing history row is not a conforming
repair, as round 1 said — and a third make round cannot close it
either. The repair is the define role's, at the define step: amend
statement 1 and the verifying observation to exclude Document
History as basis/tools/lint_basis.py check 14 does; and decide the
quotation at (b) — either the words quoted change with their source
(the initiative's Framing, not in paths) or a quotation of another
artifact's words is excluded alongside history. Not this maker's or
this checker's to decide. Until the Definition is amended, no make
round can pass this check.

Noted for the define role, outside the finding: (1)
guidance/feat-run-measurement-shopsystem-product.md still cites the
three old hashes, a disclosed consequence outside paths — a stale
reference in a governed record, wanting its own request or a widened
paths; (2) the three ", restated" scenarios' tags
(@hash:82021ef7322f, @hash:50fefe0d5e89, @hash:72e451d72fcd) do not
match their text under the same recompute — their lines are
identical in HEAD and untouched by this request (minted under the
feature's v10 by another measure), so not this request's change and
not a finding here; a lint's, per fitness scenario 3.

**Round 3** — check: the lead-pm role, 2026-09-09, at the small-change
lane's check step, the process's final round (round_cap 3), judged
fresh against the Definition and each artifact's own producing rules.
Verdict: **fail**.

Round 2's finding 1(b) is repaired and conforms. The Interaction types
section (now lines 56–59) reads "every session close records, without
a model, cost metrics for each step ... beside the session record, so
any run can be analysed on request", the quotation marks dropped.
Against the file at HEAD the only word changed in that passage is the
retired phrase; the wording matches the Feature narrative this request
set at v11 ("cost metrics for each step ... so that any run can be
analysed on request"); "run" as the instance noun stands. A
whitespace-collapsed search of the whole file finds no occurrence
split across a line break. The initiative's Framing section is outside
paths and was not read at this step; the passage no longer presents
itself as a quotation of it, and statement 1 does not judge fidelity
to it. Conforming, for the record: history row 13 cites this request;
version 12 → 13; the one path in changed is in paths; no scenario,
tag, or other section touched; no rendering edited by hand — the skill
re-produces with exit 0 and `git diff --quiet` holds, digest
`sha256:d32b2af40cc8` unchanged; nothing made that the Definition does
not cover. The other three definitions and the skill re-read clean at
this step, with and without line wrapping; their round-1 diffs are
wording-only, each with a history row citing this request and a
version bump, and `run` stands where it means an execution (run-cost
§Required sections "for that run"; session-handoff's `run_anchor` and
Scope note; the tool's "for that run" line). Acceptance statement 2
holds.

Finding 1 — acceptance statement 1 and the verifying observation still
do not hold. Statement 1: "Given features/feat-run-measurement.md,
basis/artifacts/run-cost.md, basis/processes/session-handoff.md, and
basis/tools/write_cost_rows.py as changed, when read, then none
contains the phrase "agent run"". Read at this step,
features/feat-run-measurement.md contains the phrase in Document
History rows 1, 4, 9, and 10 (lines 147, 150, 155, 156) and nowhere
else; the verifying observation, re-run here, exits 1 on that file
alone. The Definition carves nothing out of the file, so the statement
fails as written, and this step's rule allows pass only when every
statement holds. The maker was right not to rewrite those rows, for
the reasons rounds 1 and 2 gave, and this was the last make round: the
process exits to hand-back. What the hand-back needs is a Definition
change at the define step, not another make round — statement 1 and
the verifying observation excluding the Document History section, as
basis/tools/lint_basis.py check 14 does for the sibling measure (for
instance, the grep confined to the lines above the `## Document
History` heading). Under that amended Definition the artifacts as they
now stand pass with no further change: every other part of the
Definition is met.

Noted for the hand-back, outside the finding and carried from round 2:
guidance/feat-run-measurement-shopsystem-product.md still cites the
three old hashes (outside paths, wanting its own request or a widened
paths); the three ", restated" scenarios' tags do not match their text
(not this request's change; a lint's, per fitness scenario 3).

**Round 1, second pass** — check: the lead-pm role, 2026-09-09, at
the small-change lane's check step, judged fresh against the second
pass's Definition (rewritten at Document History version 12) and each
artifact's own producing rules. Verdict: **pass**. Finding: none.

Acceptance statement 1 holds. Read at this step, on the lines above
each artifact's own `## Document History` heading (in full for
basis/tools/write_cost_rows.py, which carries none):
features/feat-run-measurement.md (v13), basis/artifacts/run-cost.md
(v4), basis/processes/session-handoff.md (v7), and
basis/tools/write_cost_rows.py contain no occurrence of the retired
phrase — searched line by line and again with whitespace collapsed, so
no occurrence hides across a line break as round 2 of the first pass
once found. Diffed against HEAD, every place the phrase named a step
now reads "step" (the run-cost Identity bullet and Required sections
item 1; session-handoff's O5 and its Derived checks row; the tool's
docstring and the body line it writes; the feature narrative, both
copies, the Interaction types passage, and two Edges rows) or "agent
step" where the local sense is agent-only (the Contributors bullet, one
Edges row, and the three superseded scenarios' Scenario/Given/When/Then
text), and every place "run" names an execution of a process on one
anchor stands unchanged (run-cost's "for that run"; session-handoff's
`run_anchor` and Scope note; the tool's "for that run"; the feature's
"a session whose run passed through the router" and "any run can be
analysed on request"). The phrase remains only in the feature's
Document History rows 1, 4, 9, and 10 (lines 147, 150, 155, 156) —
each a standing row's own account of a past step, which the Definition
now places outside this statement.

Acceptance statement 2 holds. `python3 basis/tools/compile_tool.py
basis/tools/write_cost_rows.py --load-point .claude/skills` exits 0
and reports digest d32b2af40cc8; `git diff --quiet --
.claude/skills/write-cost-rows/SKILL.md` holds, so the rendering on
disk is what the tool produces; the written skill, read in full,
carries no occurrence of the retired phrase. The verifying observation,
run exactly as the Definition states it, exits 0.

Producing rules, for the record: `changed` is empty this round, so no
path lies outside `paths` and no artifact's producing rules were
engaged by this make step; the artifacts as they stand from the first
pass each carry a history row citing this request and a version bump
(run-cost 3 → 4, session-handoff 6 → 7, feat-run-measurement 10 → 13
across three rows), the skill was re-rendered by its tool and never
hand-edited, the three scenarios whose text changed carry new
`@hash:` tags that match their text on recompute at this step
(`artifact_tools.py fill-hash` on a copy of the file: no tag differs),
and nothing was made that the Definition does not cover. The maker's
verified-first, changed-nothing entry is the conforming answer for a
Definition the artifacts already meet.

Carried forward, outside the finding and unchanged from the first
pass: guidance/feat-run-measurement-shopsystem-product.md still cites
the three old hashes (outside paths; wants its own request or a widened
paths); the three ", restated" scenarios' tags do not match their text
(not this request's change; a lint's, per fitness scenario 3).

### Findings at the round cap

Hand-back: the lead-pm role, 2026-09-09, at the small-change lane's
hand-back step. The lane reached its round cap (round_cap 3) with the
change unverified. Round: 3.

check_verdict standing at the cap: **fail** (round 3's check).

check_finding standing at the cap, round 3: acceptance statement 1 —
"Given features/feat-run-measurement.md, basis/artifacts/run-cost.md,
basis/processes/session-handoff.md, and
basis/tools/write_cost_rows.py as changed, when read, then none
contains the phrase "agent run"" — and the verifying observation do
not hold: features/feat-run-measurement.md contains the phrase in
Document History rows 1, 4, 9, and 10 (lines 147, 150, 155, 156) and
nowhere else; the verifying observation exits 1 on that file alone.
Round 2's finding 1(b) (the line-wrapped Interaction types quotation)
is repaired and conforms; the other three definitions and the skill
read clean, statement 2 holds, and round 3's change went through the
feature's producing rules. The Definition carves nothing out of the
file, so the statement fails as written; rewriting standing history
rows is not a conforming repair, and this was the final make round.
Hand-back needs a Definition change at the define step — statement 1
and the verifying observation excluding the Document History section,
as basis/tools/lint_basis.py check 14 does — under which the artifacts
as they now stand pass without further change.

evidence: empty. The cap fell on a check — round 3's — not on verify;
no round of this execution reached the verify step, since
check_verdict was fail in every round, so no round ran the
observation as evidence and there is no earlier round to draw from.

Nothing reverted: the changed artifacts (features/feat-run-measurement.md
v13, basis/artifacts/run-cost.md v4, basis/processes/session-handoff.md
v7, basis/tools/write_cost_rows.py and its re-produced skill) stand as
the maker wrote them, with their histories. The request's route is
set to awaiting with the reason "small-change lane failed at the round
cap" and its status to recorded, so the request is again visible as
awaiting its route; the fitting next route, per the three checks, is
a define-step Definition change carving Document History out of
statement 1 and the verifying observation.

### Verified result

Verified: the lead-pm role, 2026-09-09, at the small-change lane's
verify step, on the second pass.

The verifying observation the Definition names — `! ( for f in
features/feat-run-measurement.md basis/artifacts/run-cost.md
basis/processes/session-handoff.md basis/tools/write_cost_rows.py; do
awk '/^## Document History/{exit} {print}' "$f"; done | grep -q "agent
run" ) && python3 basis/tools/compile_tool.py
basis/tools/write_cost_rows.py --load-point .claude/skills && git diff
--quiet -- .claude/skills/write-cost-rows/SKILL.md && ! grep -q "agent
run" .claude/skills/write-cost-rows/SKILL.md` — was run in the running
system at this step. Evidence, its output lines and closing exit:

```
.claude/skills/write-cost-rows/SKILL.md: generated from write-cost-rows (digest d32b2af40cc8)
exit 0
```

Read against the Definition: no named artifact carries the retired
phrase on the lines above its own `## Document History` heading (in
full for basis/tools/write_cost_rows.py, which carries none); the
skill re-produces with exit 0 at digest d32b2af40cc8, `git diff
--quiet` holds so the rendering on disk is what the tool produces,
and the written skill carries no occurrence of the phrase. Both
acceptance statements hold as the Definition states them.

Standing: the Definition (the lead-po role's rewrite at Document
History version 12), the Check's verdict of pass by the lead-pm role
(round 1 of the second pass, version 13), and this result stand
together. Between the request and this result no bet was taken and no
check of record was run: the small-change lane carries no
initiative-check step, and the request routed on the lead-pm's
decision alone, per its front-matter route-reason.

Carried forward, outside this result and unchanged from the Check:
guidance/feat-run-measurement-shopsystem-product.md still cites the
three old hashes (outside paths; wants its own request or a widened
paths); the three ", restated" scenarios' tags do not match their text
(not this request's change; a lint's, per fitness scenario 3).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Recorded by the lead-pm; routed to the lane, accepted. |
| 2 | 2026-09-08 | update | Held under req-2026-09-08-definition-vs-instance: the instance term is decided there first; this rename follows it. |
| 3 | 2026-09-09 | update | Hold lifted: req-2026-09-08-definition-vs-instance is done (execution is the instance term; glossary v26); the rename follows it, released by the authority's order for the session of 2026-09-09. |
| 4 | 2026-09-09 | update | Landed by the lead-pm: the originator's answer recorded as accepted on the small-change route; work item lead-99scn opened on the register, pointing at this request. |
| 5 | 2026-09-09 | update | Defined by the lead-po role at the define step: judged simple against the glossary's simple-change entry; Definition added to the Result section, naming the four artifacts, the write-cost-rows skill rendering, the maker role, and the verifying observation. |
| 6 | 2026-09-09 | update | Checked by the lead-pm role at the check step, round 1: fail. Two findings under Check in the Result section — acceptance statement 1 and the verifying observation fail on the feature's Document History rows 1, 4, 9, 10 (a definition change at the define step recommended over rewriting history rows); and the feature typedef's rule that a changed scenario text is a new scenario with a new `@hash:` fails on the three superseded scenarios edited under their old tags. |
| 7 | 2026-09-09 | update | Checked by the lead-pm role at the check step, round 2: fail. Under Check in the Result section — round 1's finding 2 repaired and verified (the three new `@hash:` tags recomputed and matching); finding 1 stands, since acceptance statement 1 and the verifying observation still fail on the feature's Document History rows 1, 4, 9, 10 and, newly read, on a line-wrapped quotation of the initiative's framing in the Interaction types section (lines 58–59) that the line-based grep never saw; the repair is a Definition change at the define step, not a third make round. |
| 8 | 2026-09-09 | update | Checked by the lead-pm role at the check step, round 3 (the final round): fail. Under Check in the Result section — round 2's finding 1(b) repaired and verified (the Interaction types passage restated in the feature's own words, the only word changed the retired phrase, no split occurrence left anywhere in the file); finding 1 stands, since acceptance statement 1 and the verifying observation still fail on the feature's Document History rows 1, 4, 9, 10 and nowhere else; round 3's change conforms to the feature's producing rules; statement 2 holds. The process exits to hand-back at its round cap; the repair is a Definition change at the define step excluding Document History, after which the artifacts as they stand pass. Frontmatter version brought in line with the row count. |
| 9 | 2026-09-09 | update | Handed back by the lead-pm role at the hand-back step: the lane reached its round cap (3) with the change unverified — round 3's check verdict fail on the feature's Document History rows 1, 4, 9, 10; evidence empty, since the cap fell on a check and no round reached verify. Findings recorded under Result; route set to awaiting with the reason "small-change lane failed at the round cap"; status recorded. Nothing reverted. |
| 10 | 2026-09-09 | update | Route decided again by the lead-pm at the request-intake process's decide-route step: small-change, the observation carved out of Document History as the checker recommended at rounds 1 and 2; the originator's answer stands from the authority's order for this session. |
| 11 | 2026-09-09 | update | Landed by the lead-pm on the second pass: the originator's answer recorded as accepted on the small-change route; work item lead-s4t1d opened on the register, pointing at this request, replacing lead-99scn (closed at the lane's cap). |
| 12 | 2026-09-09 | update | Defined by the lead-po role at the define step, second pass: Definition in the Result section rewritten — acceptance statement 1 and the verifying observation now read each artifact on the lines above its own `## Document History` heading, excluding a standing history row's account of a past step, as basis/tools/lint_basis.py check 14 does and this pass's route-reason directs; judged simple against the glossary's simple-change entry, unchanged from the first pass. |
| 13 | 2026-09-09 | update | Checked by the lead-pm role at the check step, round 1 of the second pass: pass, no finding. Under Check in the Result section — acceptance statement 1 holds on every named artifact read above its own `## Document History` heading (line-based and whitespace-collapsed), the substitutions fit the local sense and `run` stands where it means an execution; statement 2 holds, the skill re-produced at digest d32b2af40cc8 with no drift and no retired phrase; the verifying observation exits 0; `changed` empty, so no producing rule engaged and no path outside `paths`; the first pass's history rows, version bumps, and re-minted hashes conform on re-read. Two stale-reference notes carried forward, outside the finding. |
| 14 | 2026-09-09 | update | Verified by the lead-pm role at the verify step, second pass: the Definition's verifying observation run in the running system, exit 0 — the skill re-produced at digest d32b2af40cc8 with no drift and no retired phrase, no named artifact carrying the phrase above its own `## Document History` heading. Verified result recorded under Result; the Definition, the Check's pass verdict, and this result stand; no bet taken and no check of record run between the request and this result. Status set to done. |
| 15 | 2026-09-09 | update | Where the route led written into `routed-to` — this request's own Result section by fragment, `requests/req-2026-09-08-agent-run-term.md#result`, the `change` the small-change lane returned on the second pass — by the lead-pm role at the request-intake process's land-result step. Nothing the lane wrote written twice: the Definition, the Check's pass verdict, the Verified result, and the first pass's Findings at the round cap stand as the lane left them; status done stands; the work item lead-s4t1d was already closed by the lane as done. Self-check against the step's definition of good before submitting: `routed-to` filled with the fragment the lane returned, one history row added, version bumped, no other part of this request and no other artifact touched. |
