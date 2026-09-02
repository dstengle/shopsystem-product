---
type: process-definition
id: skill-rendering-process
owner: product-authority
status: approved
approved: 2026-09-02
version: 4
created: 2026-09-02
updated: 2026-09-02
produces: []
carried-by: skill-rendering-skill
condition-language: cel
annotations:
  claude-code:
    activation: model-judged
    promotion: experiment-local
    use-when: "an approved process definition changes or lands, a loadable skill at the agent's load point stands in doubt — missing, hand-edited, or left by a definition no longer approved — or the shop must confirm that every approved process is available"
---

# Process: Skill rendering

**Purpose:** Make every approved process definition of the lead shop
available at the agent's load point — the `.claude/skills/` directory
the harness loads skills from — by checking what stands there against
a fresh render of each approved definition and reconciling every
difference through the compiler, so that an agent beginning an
activity operates from the approved definition of that activity:
placement at the load point is what makes the skill load, and a clean
check is the shop's evidence that every approved process is available.

**Guiding statement:** A rendering is never the source of truth.
Whatever stands at the load point that a fresh render of an approved
definition would not put there is a finding, and every finding
resolves toward the definition — a re-render, a removal, or the
owner's decision on the definition — never an edit to a skill.

**Outcomes:**
- O1. Every approved process definition has its loadable skill at the
  load point, byte-equal to a fresh render of that definition —
  witnessed by `route`'s clean-check exits on empty `findings`.
- O2. An agent beginning an activity loads that activity's skill:
  availability is placement at the load point, and a skill absent from
  it is a `missing` finding, never assumed loadable — witnessed by
  `check`'s run and `reconcile`'s renders into `load_point`.
- O3. A definition that does not stand approved yields no loadable
  skill: `enumerate` admits only approved definitions, and a skill
  whose source names a definition in `definitions` that does not
  stand approved is a `stale` finding removed at reconciliation —
  witnessed by `enumerate`'s run and the stale rows of `findings`
  consumed by `reconcile`.
- O4. Every finding names its process, or its path in the rendering
  home it stands in, and reaches its consumer — the reconciliation
  (re-render or removal) or the owner: a definition that will not
  compile or names no skill id lands as a review entry in that
  definition's Document History, and a load-point skill that is no
  process rendering is `unrecognized` — escalated by its path, never
  removed. An escalation never ends with the run: a clean check with
  escalations standing routes through `report`, which files each row
  into the governed record the owner reads — witnessed by `check`'s
  output, `route`'s clean-with-escalations branch, and the `reconcile`
  and `report` prompts with `escalations`.
- O5. The load point is the one rendering home: a second home standing
  is a finding, its removal is a reconciliation act, and the index
  amendment it demands is filed to the owner, never made here —
  witnessed by the `second-home` row of `findings` and
  `reconcile`'s prompt.

**Roles:** reconciler and reporter —
[`../roles/lead-solutions-architect.md`](../roles/lead-solutions-architect.md)
(the compilers and the lint are this role's apparatus; it consumes the
check's findings, and its resulting action per finding is a re-render,
a removal, or an escalation). The owner — the product authority —
decides every escalated definition change; that decision lands through
governed evolution, not through a step of this process. The check
itself is mechanical and runs by the runtime against the approved
definitions and the compiler's rendering contract, so the definition
of good sits outside the role that reconciles.

**Carried by:** `.claude/skills/skill-rendering/SKILL.md` — generated
from this definition by
[`../tools/compile_process.py`](../tools/compile_process.py), never
edited by hand. Self-referential by design: this process renders its
own carrier like every other approved definition, and its first run
creates it. Until that first run the carrier does not exist, so its
correspondence to this definition cannot be walked at screening time:
the bootstrap is accepted for the draft, and the process's own first
run — its check against a fresh render — is the check of that
correspondence.

## Flow (compiled)

Generated from the steps below by `tools/compile_process.py`; do not
edit by hand.

```mermaid
flowchart TD
  enumerate["Enumerate the approved definitions — runtime<br/>in — definitions: string<br/>out — approved: string[]"]
  check["Check the load point against a fresh render — runtime<br/>in — approved: string[], load_point: string, retired_home: string, compiler: string, definitions: string<br/>out — findings: string[]"]
  route{"Route on the findings<br/>in — findings: string[], escalations: string[], round: integer, round_cap: integer"}
  reconcile(["Reconcile the findings — agent: lead-solutions-architect<br/>in — findings: string[], approved: string[], load_point: string, retired_home: string, compiler: string, escalations: string[]<br/>out — escalations: string[]"])
  advance_round["Advance the round — runtime<br/>in — round: integer<br/>sets — round: integer"]
  report(["Report the findings left open — agent: lead-solutions-architect<br/>in — findings: string[], approved: string[], escalations: string[]<br/>out — escalations: string[]"])
  __end(("end"))
  __start(("start")) --> enumerate
  enumerate --> check
  check --> route
  route -->|success exit: check clean, nothing escalated — every approved process available| __end
  route -->|success exit: check clean — escalations filed through report| report
  route -->|failsafe exit: round >= round_cap — report with findings open| report
  route -->|else| reconcile
  reconcile --> advance_round
  advance_round --> check
  report --> __end
```


## Data

Each entry names a process-local value. Simple types use JSON Schema
names inline; conditions are CEL expressions over these names. Paths
are relative to the lead shop's repository root, the run's working
directory. The *loadable form* of a process definition is the skill
the compiler generates from it under the process-definition typedef's
rendering contract — front-matter carrying `generated: true`, its
source and `source-digest`, and a body of the purpose, guiding
statement, diagram, and every step with its prompt verbatim; the term's
glossary entry is a filed gap (lead-36apr). `definitions` names the
directory of the lead shop's process definitions and nothing else;
`load_point` is the one rendering home — the directory the harness
loads skills from, so placement there is availability. `retired_home`
is the second rendering home this process retires so that no second
copy can diverge: while the directory exists its presence is a
finding, its removal belongs to `reconcile`, and the amendments the
removal demands — the basis index's `skills/` entry and every Carried
by reference still pointing there — are resulting actions filed to
the owner, never edits this process makes. The compiler has no mode that
skips its in-document diagram write, so `check` compiles a scratch
copy of each definition — the copy keeps its basename, since the
compiler derives the skill's source field from the file name, and the
scratch directory links the sibling type and artifact directories so
the copy's data references resolve as its subject's would — and
the write lands on the copy: the check never mutates its subject, and
the definition itself is written only at reconciliation's re-render,
where that write is the point. An
approved definition that names no `carried-by` skill id cannot render
— at authoring time seven approved definitions stand so — and each is
a first-run finding escalated to the owner. The run declares no
`result`: `produces` is empty because the run's value is state change
— every approved definition available at the load point — and O1's
witness pins it.

```yaml
data:
  definitions: {type: string, format: uri-reference, initial: basis/processes}
  compiler: {type: string, format: uri-reference, initial: basis/tools/compile_process.py}
  load_point: {type: string, format: uri-reference, initial: .claude/skills}
  retired_home: {type: string, format: uri-reference, initial: basis/skills}
  approved: {type: array, items: {type: string}, initial: []}
  findings: {type: array, items: {type: string}, initial: []}
  escalations: {type: array, items: {type: string}, initial: []}
  round: {type: integer, initial: 1}
  round_cap: {type: integer, initial: 3}
```

## Steps

```yaml
start: enumerate
steps:
  - id: enumerate
    name: Enumerate the approved definitions
    run-by: {execution: runtime}
    inputs: [definitions]
    outputs: [approved]
    run: |
      grep -l '^status: approved' ${definitions}/*.md | sort
    next: check

  - id: check
    name: Check the load point against a fresh render
    run-by: {execution: runtime}
    inputs: [approved, load_point, retired_home, compiler, definitions]
    outputs: [findings]
    run: |
      scratch=$(mktemp -d)
      mkdir -p "$scratch/defs"
      ln -s "$PWD/basis/types" "$scratch/types"
      ln -s "$PWD/basis/artifacts" "$scratch/artifacts"
      for def in ${approved}; do
        pid=$(sed -n 's/^id: //p' "$def" | head -1)
        name=$(sed -n 's/^carried-by: //p' "$def" | sed 's/-skill$//')
        if [ -z "$name" ]; then echo "missing $pid no-skill-id"; continue; fi
        copy="$scratch/defs/$(basename "$def")"
        cp "$def" "$copy"
        if ! python3 ${compiler} "$copy" --skill "$scratch/$name/SKILL.md" >/dev/null 2>&1; then
          echo "will-not-compile $pid"; continue
        fi
        if [ ! -f "${load_point}/$name/SKILL.md" ]; then echo "missing $pid"; continue; fi
        diff -q "$scratch/$name/SKILL.md" "${load_point}/$name/SKILL.md" >/dev/null 2>&1 || echo "diverged $pid"
      done
      for f in "${load_point}"/*/SKILL.md; do
        [ -f "$f" ] || continue
        src=$(sed -n 's/^source: //p' "$f")
        case "$src" in
          ${definitions}/*)
            printf '%s\n' ${approved} | grep -qxF -- "$src" || echo "stale $src $f" ;;
          *) echo "unrecognized $f" ;;
        esac
      done
      if [ -d "${retired_home}" ]; then echo "second-home ${retired_home}"; fi
      rm -rf "$scratch"
    next: route

  - id: route
    name: Route on the findings
    run-by: {execution: runtime}
    inputs: [findings, escalations, round, round_cap]
    branches:
      - label: "success exit: check clean, nothing escalated — every approved process available"
        when: size(findings) == 0 && size(escalations) == 0
        next: end
      - label: "success exit: check clean — escalations filed through report"
        when: size(findings) == 0
        next: report
      - label: "failsafe exit: round >= round_cap — report with findings open"
        when: round >= round_cap
        next: report
      - else: reconcile

  - id: reconcile
    name: Reconcile the findings
    run-by: {role: lead-solutions-architect, execution: agent}
    inputs: [findings, approved, load_point, retired_home, compiler, escalations]
    outputs: [escalations]
    prompt: |
      Act on each row of findings by kind, skipping any definition
      already named in escalations. "diverged", or "missing" with a
      skill id: re-render — run
      `python3 ${compiler} <definition> --skill
      <load_point>/<name>/SKILL.md`, the definition's path from
      approved and <name> its carried-by id without the -skill suffix;
      the render overwrites whatever stands, a hand-edit included —
      reconciliation is the re-render, never an edit to the skill.
      "stale": remove that skill's directory from the load point — its
      source names a process definition that does not stand approved,
      so nothing of it stays loadable. "unrecognized": do not remove;
      the skill is no rendering of any process definition, so add its
      path to escalations as the owner's to decide. "second-home":
      remove the retired home directory, then add to escalations the
      fixed notice: "the retired home is removed; the owner is to
      amend the basis index's skills/ entry and sweep for any Carried
      by reference still naming the retired home" — no sweep by this
      step. "will-not-compile", or "missing"
      marked no-skill-id: do not retry; write a review entry into that
      definition's Document History naming this process and the
      defect, and add the definition's path with the entry to
      escalations. Return escalations.
    next: advance-round

  - id: advance-round
    name: Advance the round
    run-by: {execution: runtime}
    inputs: [round]
    set:
      round: round + 1
    next: check

  - id: report
    name: Report the findings left open
    run-by: {role: lead-solutions-architect, execution: agent}
    inputs: [findings, approved, escalations]
    outputs: [escalations]
    prompt: |
      This step files what leaves the run for the owner; it runs at
      the round cap with findings open, or on a clean check with
      escalations standing. For each row of findings still open whose
      definition is not yet named in escalations, write a review entry
      into that definition's Document History — the definition's path
      from approved — naming this process and the finding, and add the
      path with the entry to escalations; a row naming no definition —
      an unrecognized skill — goes to escalations by its path alone.
      Then confirm every escalation row stands in a governed record
      the owner reads: a row naming a definition, as the review entry
      in that definition's Document History; a path-only row — an
      unrecognized skill, the second-home notice — lands in this
      process definition's Document History entry for the run. The
      resulting action on each escalated row is the owner's decision.
      Return escalations.
    next: end
```

## Derived checks

| Outcome | Check | Kind | Where |
|---|---|---|---|
| O1 | the run ends only on `size(findings) == 0`, and with `escalations` standing the clean check routes through `report` | mechanical | `route` branches |
| O2 | every approved definition without its skill at the load point yields a `missing` row; renders land only under `load_point` | mechanical | `check.run`, `reconcile.prompt` |
| O3 | `enumerate` admits only `status: approved`; the scan covers every skill at the load point, marks `stale` only a source under `definitions`, and `reconcile` removes each `stale` row | mechanical | `enumerate.run`, `check.run`, `reconcile.prompt` |
| O4 | each finding row names its process or its path in the rendering home it stands in; a will-not-compile, no-skill-id, or unrecognized row lands in `escalations` — the first two as review entries in the named definition's Document History, the unrecognized row by its path and never removed; every escalation row lands in a governed record, the named definition's Document History or this definition's run entry for a path-only row | judged | `check.run`, `route` branches, `reconcile` and `report` prompts |
| O5 | a `second-home` row stands while `retired_home` exists; its removal and the filed index amendment are directed in `reconcile.prompt` | judged | `check.run`, `reconcile.prompt` |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Authored under init-skills-availability's assigned feature feat-skills-availability as the initiative's deliverable, per the authority's scope ruling: "This should itself be a process." One rendering home decided — the agent's load point, `.claude/skills/` — with `basis/skills/` retired by the run and the index amendment filed to the owner as a resulting action; the seven approved definitions naming no skill id are first-run findings for the owner; "loadable form" defined in Data pending its glossary entry (lead-36apr). |
| 2 | 2026-09-02 | review | Round 1 (judge: claude-fable-5 / process-definition screen): findings — the second-home row named no process (O4 scoped to process-or-home, table aligned); the stale scan read a field the loadable form does not define (source: adopted); the compiler path undeclared (declared as data); the absent carrier (held for the owner). |
| 3 | 2026-09-02 | review | Round 2: findings — the second-home escalation needed undeclared reads (constant text now); the stale scan could remove a non-rendering skill (narrowed to sources under definitions; unrecognized escalated, never removed); the carrier finding carried. |
| 4 | 2026-09-02 | review | Round 3, the cap: findings — escalations could end with the run (success exit now routes through report on non-empty escalations, rows filed to governed records); the check mutated a stale diagram (compile-to-scratch only); the carrier finding to the owner. Post-cap repairs disclosed; the next screen of this file covers them. |
| 4 | 2026-09-02 | state | draft → approved: the owner's decision of 2026-09-02, on the recommended path. Bootstrap exemption recorded: the self-referential carrier does not exist before the first run; its correspondence check is that run's own check against a fresh render — accepted as this screening's exemption. |
| 4 | 2026-09-02 | update | First run over the corpus (the report step at the round cap): 10 skills rendered at the load point — 9 missing created, the hand-diverged stakeholder-presentation re-rendered over its edit, the carrier skill-rendering created (the bootstrap exemption's deferred check passed: the round-2 check diffed the carrier clean against a fresh render) — and the retired home basis/skills/ removed. Escalations: the fixed second-home notice — the retired home is removed; the owner is to amend the basis index's skills/ entry and sweep for any Carried by reference still naming the retired home (ten definitions' Carried by links read as broken by the lint until that sweep) — and seven approved definitions naming no carried-by skill id (corpus-close-out, definition-chain-migration, discovery-conversation, reconcile-and-close, review-conversation, session-handoff, work-conversation), each with the review entry written into its Document History. No unrecognized path, no will-not-compile. Check clean: no — the seven no-skill-id findings stood at the cap. |
