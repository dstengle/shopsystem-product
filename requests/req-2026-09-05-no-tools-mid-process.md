---
type: request
id: req-2026-09-05-no-tools-mid-process
status: done
version: 6
date: 2026-09-05
reader: lead-pm
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: "one rule in the process-definition typedef — a process is not approved while a step names a tool that does not exist — with the lint checking it; within the lead shop's own definitions, demonstrable in one session, no appetite worth a bet"
routed-to: requests/req-2026-09-05-no-tools-mid-process.md#result
work-item: lead-fg9sr
---

# Request: No tools built mid-process

## 1. What is requested

The product authority, 2026-09-05, in open conversation with the
lead-pm reviewing the init-request-routing run: "Building tools as part of a process should never be necessary and a goal for the lead shop should be to never build tools mid-process."

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose directly, in conversation.

## 3. Route

Route said by the lead-pm role, 2026-09-05: **the small-change lane**. Why: one rule in the process-definition typedef — a process is not approved while a step names a tool that does not exist — with the lint checking it; within the lead shop's own definitions, demonstrable in one session, no appetite worth a bet.
Topic: "No tools built mid-process (req-2026-09-05-no-tools-mid-process)".

Originator's answer: **accepted** — "For 3. start the simple tasks",
2026-09-05 (brief-036 ask 3). Landed by the lead-pm; work item lead-fg9sr
opened for the lane; it points here and carries nothing of what was
asked.

## 4. Result

### Definition

req-2026-09-05-no-tools-mid-process — defined by the lead-po role,
2026-09-05, judged a simple change by the glossary's entry: it stays
within the lead shop's own definitions (one typedef, the lint that
checks the tree, the README that names the lint), touches no Bounded
Context, and its effect is one command's exit.

**What will be different when the change is done.**

1. *The rule.* Given the process-definition typedef
   (`basis/artifacts/process-definition.md`), when a reader looks for
   what a step may name as a tool, then the typedef states the rule: a
   process definition is not approved while any step's run script or
   prompt names a tool that does not exist in the repository; and it
   states the lead shop's goal the rule serves: no tool is built
   mid-process — a tool a process needs and the repository lacks is a
   request, routed before the process runs. The typedef's Document
   History carries a row citing `req-2026-09-05-no-tools-mid-process`
   and its version is bumped.

2. *The check over the tree.* Given the lint
   (`basis/tools/lint_basis.py`), when it runs over the tree, then it
   checks every process definition under `basis/processes/` for
   repository tool paths named in a step's `run:` script and in
   `${compiler}`-style parameters — paths of the form
   `basis/tools/*.py`; `bd`, `python3`, and the sh utilities are the
   environment and are not checked — and it reports, with a nonzero
   exit, every definition that names a repository tool path that does
   not exist, naming the definition and the missing path in its output.

3. *The check on one definition.* Given the lint, when it is run with
   `--process <path>`, then it applies the same check to the one
   process definition at that path, whether or not the path lies under
   `basis/processes/`, with the same report and exit — the form
   `--brief <path>` already has.

4. *The definition that names the lint.* Given `basis/README.md`, when
   it describes what the lint checks, then it records this check —
   tool paths a process definition names must exist — with its version
   bumped and a history row citing
   `req-2026-09-05-no-tools-mid-process`.

5. *The tree as it stands.* Given the tree with the change made, when
   the lint runs over it, then it exits 0: no approved process
   definition names a tool the repository lacks.

**Artifacts the change touches** (the whole of what the maker may
change; none is a rendering):

- `basis/artifacts/process-definition.md`
- `basis/tools/lint_basis.py`
- `basis/README.md`

**Maker:** lead-solutions-architect.

**Verifying observation** — one command, from the repository root;
exit 0 shows the effect, its output is the evidence. The lint passes
over the tree; a scratch copy of `basis/processes/skill-rendering.md`
with its `basis/tools/compile_process.py` replaced by
`basis/tools/does-not-exist.py`, linted alone with `--process`, exits
nonzero and names the missing path:

```sh
python3 basis/tools/lint_basis.py && d=$(mktemp -d) && sed 's|basis/tools/compile_process\.py|basis/tools/does-not-exist.py|g' basis/processes/skill-rendering.md > "$d/bad-process.md" && grep -q 'basis/tools/does-not-exist\.py' "$d/bad-process.md" && if python3 basis/tools/lint_basis.py --process "$d/bad-process.md" > "$d/lint.txt" 2>&1; then cat "$d/lint.txt"; echo 'FAIL: the lint accepted a definition naming a tool that does not exist'; false; else cat "$d/lint.txt"; grep -q 'basis/tools/does-not-exist\.py' "$d/lint.txt"; fi
```

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-05.
Paths changed, with versions before and after:

- `basis/artifacts/process-definition.md` — v6 → v7. §Commitment
  (Definition of Done) gains the rule and the goal: a process
  definition is not approved while any step's `run` script or `prompt`
  names a tool that does not exist in the repository; no tool is built
  mid-process — a tool a process needs and the repository lacks is a
  request, routed before the process runs. The Derived review checklist
  gains the matching row. The typedef has no Rules section; Commitment
  is where its "not approved while" rules live, so the rule went there.
  History row cites this request and the authority's words.
- `basis/tools/lint_basis.py` — no version field (a tool; the README
  carries its record). One new function, `lint_process_tools(path)`,
  is check 11: it finds `basis/tools/<name>.py` paths in every step's
  `run:` template and in the `initial:` value of every data value or
  parameter (the tool paths the tree holds today sit as `initial:` on
  data values — `compiler` in skill-rendering, role-rendering,
  typedef-rendering — so both `data` and `parameters` are read),
  reports each that does not exist naming the definition and the
  path, and exits nonzero on a violation. The tree walk runs it over
  `basis/processes/*.md`; `--process <path>` runs it on one file, the
  form `--brief <path>` has. Checks 1–10, `--brief`, and
  `--derive-chain` unchanged; the header docstring names check 11 and
  the mode.
- `basis/README.md` — v10 → v11. §Checks records the check and the
  `--process` mode; history row cites this request.

Observation run from the repository root after the change: the tree
lint `PASS: 0 violation(s)`; the scratch copy naming
`basis/tools/does-not-exist.py`, linted alone with `--process`,
reported `` `data.compiler` initial names `basis/tools/does-not-exist.py`,
which does not exist in the repository `` and `FAIL: 1 violation(s)`;
the command exited 0.

### Check

**Round 1** — verdict: **pass** — by the lead-pm role, 2026-09-05, at
the small-change process's check step; the maker was the
lead-solutions-architect role. Each statement decided against the
changed artifacts: the process-definition typedef states the rule and
the goal (in its Commitment section, the typedef having no Rules
section, as the maker disclosed) with a history row citing this
request and its version bumped; the lint's check 11 walks every process
definition for repository tool paths in run scripts and initial values
and reports a path that does not exist, nonzero; `--process <path>`
lints one definition; the README records the check with a version
bump; the tree lints clean. Every path in Change made is in the
Definition's list. Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-05; its evidence (a first run at
the record step ran an empty command by the lead-pm's mistake and was
recorded as exit 0; caught by the lead-pm, re-run with the observation
as written, and this is the evidence that stands):

```
PASS: 0 violation(s)
<scratch>/bad-process.md: `data.compiler` initial names `basis/tools/does-not-exist.py`, which does not exist in the repository (process-definition typedef §Commitment)
FAIL: 1 violation(s)
exit 0
```

Recorded by the lead-pm role, 2026-09-05. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the
request and this result no bet was taken and no check of record was
run. The effect in the running system: the lint every session runs
refuses a process definition that names a tool the repository does not
have.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded by the lead-pm at the request-intake process's record step; the originator's "record the other requests" confirmed the reading of these words as asks. Route decided and said at decide-route; awaiting the originator's answer. |
| 2 | 2026-09-05 | update | The route accepted by the originator (brief-036 ask 3); landed at the intake's land step; work item lead-fg9sr opened; dispatched to the small-change lane. |
| 3 | 2026-09-05 | update | Definition written by the lead-po at the small-change process's define step: judged a simple change by the glossary's entry; five acceptance statements (the rule and the lead shop's goal in the process-definition typedef; the lint's check over the tree and on one definition by `--process <path>`; the README's record of the check; the tree lints clean); three paths; maker lead-solutions-architect; the verifying observation as one command. No artifact but this request touched. |
| 4 | 2026-09-05 | update | Change made, round 1, by the lead-solutions-architect at the small-change process's make step: the process-definition typedef v6 → v7 (the rule and the goal in §Commitment, a checklist row); tools/lint_basis.py gains check 11 as one function, `lint_process_tools`, with the `--process <path>` mode; basis/README.md v10 → v11 records the check. The verifying observation exited 0 on the maker's run. |
| 5 | 2026-09-05 | update | Check passed (round 1) by the lead-pm role; the verifying observation run by the runtime — a first run was empty by the lead-pm's mistake and was re-run as written, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 6 | 2026-09-05 | update | Where the route led written into routed-to by the lead-pm at the request-intake process's land-result step; the lane's work item lead-fg9sr closed as done. |
