---
type: request
id: req-2026-09-04-brief-relates-to
status: done
version: 7
date: 2026-09-04
reader: lead-pm
owner: lead-pm
created: 2026-09-04
updated: 2026-09-04
originator: product-authority
received-through: operational-contract
arose-in: lead-1kp6m
route: small-change
route-reason: "a simple change: within the lead shop's own definitions (the decision-brief typedef and the lint that checks briefs), no Bounded Context, demonstrable in one session, no appetite worth a bet"
routed-to: requests/req-2026-09-04-brief-relates-to.md#result
work-item: lead-16rrj
---

# Request: a decision brief says what it relates to

## 1. What is requested

The product authority, 2026-09-04, in the discovery conversation
lead-1kp6m (session sess-2026-09-04-b): "For instance I want to
decision-brief to have metadata pointing to whatever it is related
to. This is a trivial, but functional change that shouldn't require a
lot of process."

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-04: **the small-change
lane**. What it means: the lead shop makes the change within its own
definitions, defines it up front, has it checked by a role other than
its maker, and verifies it in the running system, with no bet and no
check of record. Why: the change stays within the lead shop's own
definitions — the decision-brief typedef and the lint that checks
briefs — touches no Bounded Context, is demonstrable in one session
by a brief carrying the field passing the lint and an unknown key
failing it, and spends no appetite worth a bet. Topic: "a decision
brief names what it relates to (req-2026-09-04-brief-relates-to)".

Originator's answer: **accepted** — the authority's standing direction
of this session, disclosed as the answer read at the observe step in
place of a fresh answer; the route was said here before any action.
Work item lead-16rrj opened for the lane; it points here and
carries nothing of what was asked.

## 4. Result

### Definition

req-2026-09-04-brief-relates-to — defined by the lead-po role,
2026-09-04, at the small-change process's define step. Judged simple
by the glossary's entry: the change stays within the lead shop's own
definitions, touches no Bounded Context, and its effect is
demonstrable in the running system in one session.

**What will be different — acceptance statements.**

1. Given the decision-brief typedef's closed field set, when a
   decision brief's frontmatter is read, then the set admits a field
   `relates-to` whose value is a list of one or more paths, each from
   the repository root to an artifact the brief is about — an
   initiative, a feature, a decision record, a work item, or another
   artifact of the shop — and the typedef states what the field
   carries and that every path in it resolves.
2. Given the lint that checks the basis tree, when it is run from the
   repository root, then it also checks every brief in `briefs/`
   against the decision-brief typedef's closed field set and that
   every path under `relates-to` resolves to an existing file, and its
   exit is nonzero on any violation.
3. Given the lint, when it is pointed at a single brief by path
   (`python3 basis/tools/lint_basis.py --brief <path>`), then it
   checks that brief alone by the same rules, exiting 0 when the brief
   passes and nonzero when it does not.
4. Given the existing brief `briefs/brief-034.md`, when the lint runs
   over the tree or over that brief alone, then the brief carries
   `relates-to` naming what it relates to and passes.
5. Given a brief whose frontmatter carries a key the closed set does
   not admit, or a `relates-to` path that does not resolve, when the
   lint runs over it, then the lint exits nonzero.
6. Given the definition that names the lint, when it is read, then it
   says the lint checks briefs and that the lint can be pointed at a
   single brief.

**Artifacts the change touches, by path** — the whole of what the
maker may change; no rendering is involved:

- `basis/artifacts/decision-brief.md` — the decision-brief typedef,
  amended under this request.
- `basis/tools/lint_basis.py` — the lint, a tool changed together
  with the definition that names it.
- `basis/README.md` — the definition that names the lint.
- `briefs/brief-034.md` — the existing brief, gaining the field.

**Maker role:** lead-solutions-architect.

**Verifying observation** — one command, run from the repository
root; exit 0 shows the effect in the running system and its output is
the evidence:

```
python3 basis/tools/lint_basis.py && python3 basis/tools/lint_basis.py --brief briefs/brief-034.md && d=$(mktemp -d) && sed 's/^relates-to:/bogus-key: 1\nrelates-to:/' briefs/brief-034.md > "$d/unknown-key.md" && ! python3 basis/tools/lint_basis.py --brief "$d/unknown-key.md" && sed '/^relates-to:/,/^[^ ]/{s|^relates-to:\s*\S.*|relates-to: no-such-dir/x.md|;s|^\(\s*- \)|\1no-such-dir/|}' briefs/brief-034.md > "$d/dangling-link.md" && ! python3 basis/tools/lint_basis.py --brief "$d/dangling-link.md"
```

What it shows: the tree lint passes with the field in place; brief-034
passes alone; a copy of brief-034 with an unknown key fails; a copy of
brief-034 whose `relates-to` paths point nowhere fails.

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-04,
at the small-change process's make step. Paths changed, with version
before and after:

- `basis/artifacts/decision-brief.md` — v3 → v4: `relates-to` added
  to the closed field set as an optional list of repository-root paths
  to the artifacts the brief is about, each resolving; the lint and
  its `--brief` mode named; the derived checklist gains the
  path-resolution line. History row cites this request.
- `basis/tools/lint_basis.py` — a tool, unversioned; its header
  docstring now carries check 10 and the `--brief PATH` mode. Check
  10 walks `briefs/` at the repository root (absent: no violations),
  takes as a brief each file whose `type` is `decision-brief` — the
  annexes beside them are not briefs and are not walked — and checks
  the closed set (the typedef's eight keys plus `relates-to`, unknown
  keys rejected), `type`, the status vocabulary, and that every
  `relates-to` entry is a path resolving from the repository root.
  `--brief <path>` runs the same rules on one file, wherever it lives,
  and reports in the existing format with the existing exit rule.
  Checks 1–9 and `--derive-chain` unchanged.
- `basis/README.md` — v7 → v8: §Checks says the lint checks briefs
  and can be pointed at one brief; history row cites this request.
- `briefs/brief-034.md` — v5 → v6: `relates-to` added naming
  `initiatives/init-roles-availability.md`,
  `features/feat-roles-availability.md`,
  `decisions/adr-2026-09-03-role-rendering.md`,
  `decisions/pdr-2026-09-03-bet-roles-availability.md`; the brief is
  delivered and its content is unchanged; history row cites this
  request.

Run by the maker before returning: the verifying observation, from
the repository root, exited 0 (tree lint PASS; brief-034 alone PASS;
the unknown-key copy FAIL 1 violation; the dangling-link copy FAIL 4
violations); the plain lint exited 0 with `PASS: 0 violation(s)`. The
verify step runs the observation again.

### Check

**Round 1** — verdict: **pass** — by the lead-pm role, 2026-09-04, at
the small-change process's check step; the maker was the
lead-solutions-architect role. Each acceptance statement decided
against the changed artifacts: (1) the typedef v4 admits `relates-to`
as a list of repository-root paths and states what it carries and that
every path resolves; (2) the lint's check 10 walks `briefs/` and the
README v8 says so; (3) the `--brief <path>` mode exists with the same
rules; (4) brief-034 v6 carries the field naming the initiative, the
feature, the ADR, and the PDR; (5) the unknown-key and dangling-path
cases fail by the observation the maker ran; (6) the README names the
brief check and the single-brief mode. Producing rules: every history
row cites this request and every version is bumped; the lint changed
together with the README that names it; no rendering involved; every
path in Change made is in the Definition's list. Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-04, at the small-change process's
verify step; its evidence, the output lines and the closing exit:

```
PASS: 0 violation(s)
PASS: 0 violation(s)
<scratch>/unknown-key.md: unknown front-matter key `bogus-key` — the field set is closed (decision-brief typedef §Required frontmatter)
FAIL: 1 violation(s)
<scratch>/dangling-link.md: `relates-to` path `no-such-dir/initiatives/init-roles-availability.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
<scratch>/dangling-link.md: `relates-to` path `no-such-dir/features/feat-roles-availability.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
<scratch>/dangling-link.md: `relates-to` path `no-such-dir/decisions/adr-2026-09-03-role-rendering.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
<scratch>/dangling-link.md: `relates-to` path `no-such-dir/decisions/pdr-2026-09-03-bet-roles-availability.md` does not resolve from the repository root (decision-brief typedef §Required frontmatter)
FAIL: 4 violation(s)
exit 0
```

Recorded by the lead-pm role, 2026-09-04. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the request
and this result no bet was taken and no check of record was run. The
effect in the running system: the lint that every session runs accepts
a decision brief that says what it relates to and rejects one with an
unknown key or a path that does not resolve.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-04 | update | Recorded by the lead-pm at the request-intake process's record step, the first run of that process. The originator's confirmation of the reading: the authority's standing direction of this session — "continue all the way through implementation unless there is anything absolutely requiring clarification from me … you have my permission to continue through" — given after converging on init-request-routing, whose measure names this change; disclosed here as the confirmation the record step read, in place of a fresh yes at the confirm step. The discovery run the ask arose in had already closed. |
| 2 | 2026-09-04 | update | Route decided and said by the lead-pm (decide-route): small-change, with its reason and topic; the originator's answer landed as accepted on the standing direction (land); work item lead-16rrj opened for the lane. |
| 3 | 2026-09-04 | update | Definition written by the lead-po at the small-change process's define step: judged simple by the glossary's entry; six acceptance statements, four artifacts by path, maker lead-solutions-architect, one verifying observation. |
| 4 | 2026-09-04 | update | Change made, round 1, by the lead-solutions-architect at the small-change process's make step: the four artifacts the Definition names changed under their own producing rules (typedef v4, README v8, brief-034 v6, the lint's check 10 and --brief mode); the observation run by the maker exited 0. |
| 5 | 2026-09-04 | update | Check passed (round 1) by the lead-pm role; the verifying observation run by the runtime, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 6 | 2026-09-04 | update | Where the route led written into routed-to — this request's own Result section — by the lead-pm at the request-intake process's land-result step; the lane's work item lead-16rrj closed as done. |
| 7 | 2026-09-04 | update | The first intake run's reading of the standing direction as the originator's answers at the confirm and observe steps ratified for this run only, no precedent, by the authority's ruling of 2026-09-04 on brief-035 — "Take defaults. For 5. take discovery" (brief-035 ask 3, default taken). |
