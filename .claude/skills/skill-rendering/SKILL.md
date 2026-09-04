---
name: skill-rendering
description: "Make every approved process definition of the lead shop available at\
  \ the agent's load point \u2014 the `.claude/skills/` directory the harness loads\
  \ skills from \u2014 by checking what stands there against a fresh render of each\
  \ approved definition and reconciling every difference through the compiler, so\
  \ that an agent beginning an activity operates from the approved definition of that\
  \ activity: placement at the load point is what makes the skill load, and a clean\
  \ check is the shop's evidence that every approved process is available. Use when\
  \ an approved process definition changes or lands, a loadable skill at the agent's\
  \ load point stands in doubt \u2014 missing, hand-edited, or left by a definition\
  \ no longer approved \u2014 or the shop must confirm that every approved process\
  \ is available."
type: skill
id: skill-rendering-skill
status: approved
created: 2026-09-02
updated: 2026-09-04
generated: true
generated-by: basis/tools/compile_process.py
derived-from: skill-rendering-process
source: basis/processes/skill-rendering.md
source-digest: sha256:914d68931adb
activation: model-judged
promotion: experiment-local
---

# Skill rendering (compiled from `skill-rendering-process`)

Make every approved process definition of the lead shop available at the agent's load point — the `.claude/skills/` directory the harness loads skills from — by checking what stands there against a fresh render of each approved definition and reconciling every difference through the compiler, so that an agent beginning an activity operates from the approved definition of that activity: placement at the load point is what makes the skill load, and a clean check is the shop's evidence that every approved process is available.

**A rendering is never the source of truth. Whatever stands at the load point that a fresh render of an approved definition would not put there is a finding, and every finding resolves toward the definition — a re-render, a removal, or the owner's decision on the definition — never an edit to a skill.**

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

## enumerate — Enumerate the approved definitions

Run by the runtime — no agent, no prose. reads: definitions · writes: approved.

```yaml
run: 'grep -l ''^status: approved'' ${definitions}/*.md | sort

  '
next: check
```

## check — Check the load point against a fresh render

Run by the runtime — no agent, no prose. reads: approved, load_point, retired_home, compiler, definitions · writes: findings.

```yaml
run: "scratch=$(mktemp -d)\nmkdir -p \"$scratch/defs\"\nln -s \"$PWD/basis/types\"\
  \ \"$scratch/types\"\nln -s \"$PWD/basis/artifacts\" \"$scratch/artifacts\"\nfor\
  \ def in ${approved}; do\n  pid=$(sed -n 's/^id: //p' \"$def\" | head -1)\n  name=$(sed\
  \ -n 's/^carried-by: //p' \"$def\" | sed 's/-skill$//')\n  if [ -z \"$name\" ];\
  \ then echo \"missing $pid no-skill-id\"; continue; fi\n  copy=\"$scratch/defs/$(basename\
  \ \"$def\")\"\n  cp \"$def\" \"$copy\"\n  if ! python3 ${compiler} \"$copy\" --skill\
  \ \"$scratch/$name/SKILL.md\" >/dev/null 2>&1; then\n    echo \"will-not-compile\
  \ $pid\"; continue\n  fi\n  if [ ! -f \"${load_point}/$name/SKILL.md\" ]; then echo\
  \ \"missing $pid\"; continue; fi\n  diff -q \"$scratch/$name/SKILL.md\" \"${load_point}/$name/SKILL.md\"\
  \ >/dev/null 2>&1 || echo \"diverged $pid\"\ndone\nfor f in \"${load_point}\"/*/SKILL.md;\
  \ do\n  [ -f \"$f\" ] || continue\n  src=$(sed -n 's/^source: //p' \"$f\")\n  case\
  \ \"$src\" in\n    ${definitions}/*)\n      printf '%s\\n' ${approved} | grep -qxF\
  \ -- \"$src\" || echo \"stale $src $f\" ;;\n    *) echo \"unrecognized $f\" ;;\n\
  \  esac\ndone\nif [ -d \"${retired_home}\" ]; then echo \"second-home ${retired_home}\"\
  ; fi\nrm -rf \"$scratch\"\n"
next: route
```

## route — Route on the findings

Run by the runtime — no agent, no prose. reads: findings, escalations, round, round_cap · writes: —.

```yaml
branches:
- label: "success exit: check clean, nothing escalated \u2014 every approved process\
    \ available"
  when: size(findings) == 0 && size(escalations) == 0
  next: end
- label: "success exit: check clean \u2014 escalations filed through report"
  when: size(findings) == 0
  next: report
- label: "failsafe exit: round >= round_cap \u2014 report with findings open"
  when: round >= round_cap
  next: report
- else: reconcile
```

## reconcile — Reconcile the findings

Run by an agent in role `lead-solutions-architect`. reads: findings, approved, load_point, retired_home, compiler, escalations · writes: escalations.
- then: `advance-round`

Prompt:

```text
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
```

## advance-round — Advance the round

Run by the runtime — no agent, no prose. reads: round · writes: round.

```yaml
set:
  round: round + 1
next: check
```

## report — Report the findings left open

Run by an agent in role `lead-solutions-architect`. reads: findings, approved, escalations · writes: escalations.
- then: `end`

Prompt:

```text
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
```
