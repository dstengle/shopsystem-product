---
type: request
id: req-2026-09-06-pre-bet-route
status: done
version: 5
date: 2026-09-06
reader: lead-pm
owner: lead-pm
created: 2026-09-06
updated: 2026-09-06
originator: product-authority
received-through: operational-contract
arose-in: brief-037
route: small-change
route-reason: "one route added to the initiative-check process — each decision in an attaching role's offer whose record reads none is sent to adr-authoring before the screen — within the lead shop's own definitions, demonstrable on the next initiative check, no appetite worth a bet; the checked ADR listed it as a reversible process change"
routed-to: requests/req-2026-09-06-pre-bet-route.md#result
work-item: lead-ov7bc
---

# Request: the pre-bet route to decision-record authoring

## 1. What is requested

The product authority, 2026-09-06, on brief-037 ask 2 — "Shall the
initiative check gain one route: for each decision in an offer whose
record reads none, send it to decision-record authoring before the
screen, as the next change through the lane?" — "1 & 2 confirm".

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose in brief-037's second ask, authorized.

## 3. Route

Route said by the lead-pm role, 2026-09-06: **the small-change lane**.
Why: one route added to the initiative-check process, the third
candidate adr-2026-09-05-role-offer listed as a reversible process
change; within the lead shop's own definitions, demonstrable on the
next initiative check. Topic: "the pre-bet route to decision-record
authoring (req-2026-09-06-pre-bet-route)".

Originator's answer: **accepted** — the authorization itself, "1 & 2
confirm". Landed by the lead-pm; work item lead-ov7bc opened for the lane.

## 4. Result

### Definition

req-2026-09-06-pre-bet-route — defined by the lead-po role,
2026-09-06, at the small-change process's define step.

**Simplicity.** Judged against the glossary's entry for simple
change: the change stays within the lead shop's own definitions —
two process definitions, their two skill renderings, and one data
type — touches no Bounded Context, and its effect is demonstrable in
the running system from the repository root in one session. It is a
simple change; the lane proceeds. Two paths beyond the three the
route named are touched, each for a reason the acceptance statements
carry: adr-authoring's run returns a check-decision, which holds no
record id, so the route has nothing to write until that process
returns the record it made; and the role-offer type's Purpose names
the pre-bet route as a consumer "once the process's owner adds it",
which single-source-of-truth requires to name the step once it
exists.

**Scope.** The initiative-check process gains one route between its
two attach steps and its screen: for each entry in the solutions
architect role's offer (`feasibility_offer`) whose `record` reads the
literal `none`, the adr-authoring process runs as a sub-process on
that decision and the record it returns is written into the entry;
when no entry reads `none` the run passes straight to the screen.

Bound, with its reason: the product designer role's offer
(`usability_offer`) carries decision entries of the same shape, but
the route does not read them. The adr typedef's rule sends a decision
no listed right covers to `right: escalation` "in the type whose
deciding side raised it", and the designer's side has no record type
in `basis/artifacts` and no authoring process; adr-authoring's author
step is the solutions architect role's, and its prompt returns an
ask on another role's domain. Routing a designer's entry there would
put an experience decision through a process and a type that do not
admit it — a definition change beyond this request. Until the
designer's side has a record type and a process, a `none` in the
usability offer stays what it is today: a claim the screen judges
against the role's domain, routed by hand by the PM role before the
bet, as initiative-check's v8 history records. This is a scope
recommendation to the PM role; the definition below stands on it, and
the PM role's check may widen it.

**Acceptance statements.** Each is decided against the changed
artifacts.

1. Given basis/processes/initiative-check.md, when its steps are read
   in order, then between `attach-usability` and `screen` stand two
   steps: a runtime step with id `route-decisions` that reads
   `feasibility_offer` and carries labeled branch rows — a success
   exit, labeled as the reached state "no entry reads none", whose
   `next` is `screen`, and an else whose `next` is the sub-process
   step — and a step with id `author-decision-record` whose `run-by`
   is `{execution: sub-process, process: adr-authoring-process, from:
   adr-authoring.md}`; `attach-usability`'s `next` is
   `route-decisions`; and every other step's routing is as it stood.
2. Given the `author-decision-record` step, when one pass runs on one
   entry whose `record` reads `none`, then the subject it hands
   adr-authoring states, in the terms adr-authoring's Data gives a
   subject — what must be decided, by whom, and where its evidence
   sits: the decision as the entry names it; the role whose offer
   raised it (the offer's `role`), which decides under a right it
   holds, or the authority under escalation where no such right
   covers it, as the adr typedef's rule says; the trigger — the bet on
   the initiative at `initiative`; and the evidence — the offer as
   rendered into that initiative's Document History. The architecture
   principle set and the adr fitness set the sub-process needs are
   declared in initiative-check's Data with their sources, not added
   as parameters.
3. Given a pass of the sub-process that returns, when the run
   continues, then the entry's `record` reads the returned record's
   id — the `id` in its frontmatter, never `none` — and the initiative
   the screen reads shows that id at the entry; whichever step
   writes it writes the id and nothing else of the attachment, so no
   role's verdict is rewritten. The record's status is not judged by
   the route: it stands in the record, for the screen and for the
   authority at `decide`.
4. Given the loop `route-decisions` → `author-decision-record` →
   `route-decisions`, when it is read in full, then its exit is the
   labeled success row of statement 1; each pass rewrites one entry
   from `none` to an id, so the count of entries reading `none` falls
   by one per pass and the passes never exceed the number of entries
   in the offer — the bound the route named. No separate cap is
   needed and none is added.
5. Given an offer in which no entry reads `none`, when the run
   reaches `route-decisions`, then it continues to `screen` with no
   sub-process run; `screen`'s inputs remain `initiative` and
   `criteria_path` only and it keeps `fresh-context: true`.
6. Given initiative-check's `parameters` list, `result`, and every
   step other than the two added and `attach-usability`'s `next`,
   when read after the change, then they are as they stood at v8; and
   basis/processes/product-flow.md and its skill are unchanged, its
   `check` step mapping positionally as before.
7. Given basis/processes/adr-authoring.md, when its steps block is
   read, then `result` is `artifact` — the record the run made, as
   the process-definition typedef's result rule states ("the
   artifact, not a status record") — and its steps are otherwise as
   they stood at v2; the decision the PM role took stands in the
   record's status and Document History, as its `record` step already
   writes. Its prose names the record as what a run returns wherever
   it named the decision as that.
8. Given basis/types/role-offer.md, when its Purpose is read, then it
   names `route-decisions` and `author-decision-record` of
   initiative-check as the consumer that reads each entry's `record`
   and the writer of the record's id in place of `none`, replacing
   "once the process's owner adds it"; the schema is unchanged — the
   `record` field already holds an id, so no field is added.
9. Given initiative-check's Outcomes and Derived checks, when read,
   then one outcome states the route — every `none` in the
   architect's offer is a record before the screen, or the run goes
   straight to the screen — witnessed by `route-decisions`'s branches
   and `author-decision-record`'s `run-by`, with its row in the
   table; the bound on the designer's offer, above, is stated in the
   definition in one sentence where the Data paragraph names the two
   offers.
10. Given each of the three changed definitions, when its Document
    History is read, then its last row cites
    `req-2026-09-06-pre-bet-route` and its `version` is one higher
    than the version that stood before (initiative-check 8 → 9,
    adr-authoring 2 → 3, role-offer 1 → 2); and each definition
    carries the maker's evaluation against its typedef's checklist,
    as the working principle requires.
11. Given the two changed process definitions read against their
    rendered skills, when compared, then each definition's flow
    diagram is the one the rendering tool regenerates from its steps,
    and each skill equals a fresh render — the rendering is never
    edited by hand.
12. Given the repository after the change, when the basis lint and the
    verifying observation below run, then both exit 0.

**Artifacts touched (paths).** The maker reads these and changes
nothing else.

Definitions (sources):
- basis/processes/initiative-check.md
- basis/processes/adr-authoring.md
- basis/types/role-offer.md

Renderings — each re-rendered from its source by the rendering tool,
never edited by hand:
- .claude/skills/initiative-check/SKILL.md (source
  basis/processes/initiative-check.md; tool
  basis/tools/compile_process.py)
- .claude/skills/adr-authoring/SKILL.md (source
  basis/processes/adr-authoring.md; tool
  basis/tools/compile_process.py)

Read, not changed: basis/tools/compile_process.py;
basis/artifacts/process-definition.md; basis/artifacts/adr.md;
basis/fitness/adr.fitness.md; basis/architecture-principles.md;
basis/processes/product-flow.md.

**Maker role.** lead-solutions-architect — the role the make step runs
by; it is also adr-authoring's maker role, and the lane's check is the
PM role's, not its own.

**Verifying observation.** One command, run from the repository root;
exit 0 shows the effect, its output is the evidence. It runs the
basis lint; confirms by id that the route step and the sub-process
step exist in initiative-check and that the sub-process named is
adr-authoring; confirms adr-authoring's result is the record; and for
each of the two changed process definitions confirms that the
definition's diagram is the one the tool regenerates and that the
skill at the load point equals a fresh render.

```
( python3 basis/tools/lint_basis.py && p=basis/processes/initiative-check.md && grep -q -E '^  - id: route-decisions$' "$p" && grep -q -E '^  - id: author-decision-record$' "$p" && grep -q -E 'execution: sub-process, process: adr-authoring-process, from: adr-authoring.md' "$p" && grep -q -E '^result: artifact$' basis/processes/adr-authoring.md && echo "initiative-check: route-decisions and author-decision-record present, adr-authoring runs as the sub-process; adr-authoring: result is the record" && s=$(mktemp -d) && mkdir -p "$s/defs" && ln -s "$PWD/basis/types" "$s/types" && ln -s "$PWD/basis/artifacts" "$s/artifacts" && for n in initiative-check adr-authoring; do d="basis/processes/$n.md"; cp "$d" "$s/defs/$n.md" && python3 basis/tools/compile_process.py "$s/defs/$n.md" --skill "$s/$n/SKILL.md" >/dev/null && diff -q "$s/defs/$n.md" "$d" && diff -q "$s/$n/SKILL.md" ".claude/skills/$n/SKILL.md" && echo "$n: diagram current, skill equals fresh render" || exit 1; done )
```

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-06.

Paths changed, each with its version before and after:

- basis/processes/initiative-check.md — 8 → 9. The two steps added
  between `attach-usability` and `screen`: `route-decisions`
  (runtime; branches on `feasibility_offer` — "success exit: no entry
  reads none" to `screen`, else to the sub-process step) and
  `author-decision-record` (`{execution: sub-process, process:
  adr-authoring-process, from: adr-authoring.md}`, inputs `subject,
  principles, adr_criteria` mapping positionally to adr-authoring's
  parameters, output `record`, `next: route-decisions`);
  `attach-usability`'s `next` is `route-decisions`; the `parameters`
  list, `result`, and every other step unchanged. Data gains
  `principles` and `adr_criteria` at `initial` values (the
  architecture principle set, the adr fitness set), `subject`, and
  `record`; the frontmatter gains `produces: [adr]` and the declared
  condition function `record_id` (string -> string: the `id` in the
  record's frontmatter). O6 and its derived check; the Purpose and
  Roles name the sub-process; the bound on the designer's offer
  stated in one sentence in Data with its reason. The maker's
  choices under the Definition's "whichever step writes it" and
  their reasons: `route-decisions` writes the id — its `run` (sed)
  into the initiative at the entry, matched by the type's field name
  and literal `record: none`, the first in the document; its `set`
  into the offer's entry through `record_id`, and the next subject
  in adr-authoring's terms. The `run` and the `set` each read
  `record` and neither reads what the other wrote, so their order
  in the rendering does not bear; the `set`'s assignments apply in
  the order written (the subject after the rewrite). Two runtime
  contents in one step is a first in the corpus: the Definition
  admits exactly two steps, the entry must be rewritten in the data
  for the loop to reach its exit, and the initiative must show the
  id before the screen — no single content kind does both. The
  in-place write carries no history row of its own in the
  initiative; the record's own Document History, which adr-authoring
  writes, is the record of it.
- basis/processes/adr-authoring.md — 2 → 3. `result: artifact`; the
  Data prose states what a run returns; steps unchanged.
- basis/types/role-offer.md — 1 → 2. The Purpose names
  `route-decisions` and `author-decision-record` as the consumer and
  the writer; schema unchanged.
- .claude/skills/initiative-check/SKILL.md — re-rendered by
  basis/tools/compile_process.py from its source; source-digest
  sha256:08e85a0ae7ba → sha256:bc43f9ddb913.
- .claude/skills/adr-authoring/SKILL.md — re-rendered by
  basis/tools/compile_process.py from its source; source-digest
  sha256:ab34ce6ef7d6 → sha256:9709209e8685.

Evaluation of each changed definition against its definition of
good, recorded in each one's history row: the two process
definitions against the process-definition typedef's checklist and
fitness set (compile clean and byte-stable, no prose outside
`prompt`, the new loop's labeled exit, declared reads only, the
result the artifact, no tool the repository lacks); the data type
against the data-type typedef's checklist. Verifying observation:
exit 0 — "initiative-check: route-decisions and
author-decision-record present, adr-authoring runs as the
sub-process; adr-authoring: result is the record"; "initiative-check:
diagram current, skill equals fresh render"; "adr-authoring: diagram
current, skill equals fresh render". Lint: PASS, 0 violations.

### Check

**Round 1** — verdict: **pass** — by the lead-pm role, 2026-09-06, at
the small-change process's check step; the maker was the
lead-solutions-architect role. Each statement decided against the
changed definitions: the initiative check gains the route and the
sub-process step, bounded by the entries, with its labeled exit to the
screen; adr-authoring returns the record it made; the type names the
steps; the diagrams are regenerated and the skills equal a fresh
render; each history row cites this request with its version bumped;
the product flow's mapping is untouched. The maker's two disclosures
weighed: a runtime step carrying both a write to the initiative and a
rewrite of the offer's entry is within the definition's statement on
writing the record before the screen; the in-place write presumes the
offer rendered in the type's field shape, which the initiative typedef
(v11) requires, so the first attachment made under it is where the
route is first exercised. Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-06; its evidence:

```
PASS: 0 violation(s)
initiative-check: route-decisions and author-decision-record present, adr-authoring runs as the sub-process; adr-authoring: result is the record
initiative-check: diagram current, skill equals fresh render
adr-authoring: diagram current, skill equals fresh render
exit 0
```

Recorded by the lead-pm role, 2026-09-06. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the
request and this result no bet was taken and no check of record was
run. The effect in the running system: the next initiative check sends
each decision the architect names as unrecorded to ADR authoring
before the screen, so no bet rests on an unrecorded decision by
definition — the gap filed as lead-8hcu8 closed.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Recorded by the lead-pm at the request-intake process's record step from brief-037 ask 2 and the authority's confirmation; routed small-change, said, and accepted by the authorization; work item lead-ov7bc opened; dispatched to the small-change lane. |
| 2 | 2026-09-06 | update | Definition written by the lead-po role at the small-change process's define step: judged a simple change by the glossary's entry; twelve acceptance statements; paths — initiative-check and adr-authoring with their two skill renderings (source and tool named), the role-offer type; two paths beyond the route's three, each with its reason (adr-authoring's result must be the record for the route to have an id to write; the type's Purpose must name the step that consumes it); scope bound to the architect's offer with the reason recorded — the designer's side has no record type or authoring process under the adr typedef's rule — as a recommendation to the PM role; maker lead-solutions-architect; verifying observation as one command from the repository root. Maker's evaluation of this definition against the step's prompt: opens with the request's id; every statement decidable by reading a named artifact; every path listed with its rendering's source and tool; one observation whose exit 0 shows the effect, in the form req-2026-09-05-single-review-cycle used, with the grep by step id added. |
| 3 | 2026-09-06 | update | Change made, round 1, by the lead-solutions-architect role at the small-change process's make step: initiative-check 8 → 9, adr-authoring 2 → 3, role-offer 1 → 2, the two skills re-rendered by the compiler; the maker's choices under "whichever step writes it" recorded with their reasons; the verifying observation exit 0 and the lint clean. |
| 4 | 2026-09-06 | update | Check passed (round 1) by the lead-pm role; the verifying observation run by the runtime, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 5 | 2026-09-06 | update | Where the route led written into routed-to by the lead-pm at the request-intake process's land-result step; the lane's work item lead-ov7bc closed as done; lead-8hcu8 closed as applied. |
