---
type: process-definition
id: session-handoff-process
owner: product-authority
status: approved
approved: 2026-08-22
version: 4
created: 2026-08-21
updated: 2026-09-08
produces: [session-record]
carried-by: session-handoff-skill
condition-language: cel
---

# Process: Session handoff

**Purpose:** Close a conversation so later work starts from governed
records alone — no memory channel, no chat summary, and no transcript as
the carrier.

**Guiding statement:** State crosses sessions only inside governed
artifacts. A fact worth remembering has a governed home; a durable
correction amends the definition it corrects, never a memory.

**Outcomes:**
- O1. The session record validates against its type — witnessed by the
  `validate` run and the `route-validation` branches.
- O2. The record and the work registry are pushed — witnessed by the
  atomic `land` run.
- O3. Every durable correction is filed as an amendment bead targeting
  the definition it corrects, and the record only points at those beads —
  witnessed by the check on `collect`.
- O4. A record that cannot validate within the round cap lands anyway
  with a filed defect, so the handoff never silently fails — witnessed by
  the failsafe branch and `file-defect`.
- O5. A session whose conversation ran anchored to a `bd` work item gets
  a cost row for each agent run that item recorded, beside the session
  record and without a model — witnessed by `write-cost-rows`.

**Roles:** router (Accountable — runs the handoff when a conversation
closes). The consumer is the router that next touches the work: the
start drain reads the anchor before accepting it.

**Scope note:** one run closes one discovery conversation, whose anchor
is a session record. Review and work conversations close through their
own anchors — decisions land as changes in the artifacts they affect, work discussion lands
on the work item — under the same discipline: the anchor is the only
carrier. A transcript that ends mid-conversation is not a close; the
conversation stays open until its anchor says otherwise. `run_anchor` is
a second, distinct thing: the `bd` work item the closed conversation's
own run passed through the router on, if it had one — never the session
record itself. An ad hoc conversation the router never moved has none;
`write-cost-rows` then writes nothing.

## Flow (compiled)

Generated from the steps below by `tools/compile_process.py`; do not
edit by hand.

```mermaid
flowchart TD
  collect(["Write the session record — agent: router<br/>out — session_record: session-record, corrections: correction[]"])
  write_cost_rows["Write the cost rows — runtime<br/>in — session_record: session-record, run_anchor: string<br/>out — cost_artifact: string"]
  validate["Validate the record — runtime<br/>in — session_record: session-record<br/>out — validation: validation-report"]
  route_validation{"Route on validation<br/>in — validation: validation-report, round: integer"}
  repair(["Repair the record — agent: router<br/>in — session_record: session-record, validation: validation-report<br/>out — session_record: session-record"])
  advance_round["Advance the round counter — runtime<br/>in — round: integer<br/>sets — round: integer"]
  file_defect["File the validation defect — runtime<br/>in — session_record: session-record, validation: validation-report"]
  land["Land the handoff — runtime<br/>in — session_record: session-record"]
  __end(("end<br/>result — session_record: session-record"))
  __start(("start")) --> collect
  collect --> write_cost_rows
  write_cost_rows --> validate
  validate --> route_validation
  route_validation -->|success exit: record validates| land
  route_validation -->|failsafe exit: round >= 3| file_defect
  route_validation -->|else| repair
  repair --> advance_round
  advance_round --> validate
  file_defect --> land
  land --> __end
```


## Data

Each entry names a process-local value. Simple types use JSON Schema
names inline; every structured shape is a `$ref` to a defined type with
an explicit source — `from:` links the defining file, or names the owning
package as `pkg:<package>/<type>` (fetched through that package's
contract tool).

```yaml
data:
  session_record: {$ref: session-record, from: pkg:shopsystem-knowledge/session-record}
  corrections: {type: array, items: {$ref: correction, from: ../types/correction.md}}
  validation: {$ref: validation-report, from: ../types/validation-report.md}
  round: {type: integer, initial: 1}
  run_anchor: {type: string, initial: ""}
  cost_artifact: {type: string, format: uri-reference, initial: ""}
```

## Steps

```yaml
start: collect
parameters: [run_anchor]
result: session_record
steps:
  - id: collect
    name: Write the session record
    run-by: {role: router, execution: agent}
    inputs: []
    outputs: [session_record, corrections]
    checks:
      - corrections.all(c, c.target != "" && c.bead != "")
    prompt: |
      Write or update the session record: outcome first; the produced and
      revised lists complete; every open thread names its next ready
      action. For each durable correction met this session — a rule,
      preference, or mode change that should outlive the session — file a
      bead targeting the definition it amends and list the pair here. The
      record points; the definition carries. Nothing goes to a memory
      channel: memory writes are frozen.
    next: write-cost-rows

  - id: write-cost-rows
    name: Write the cost rows
    run-by: {execution: runtime}
    inputs: [session_record, run_anchor]
    outputs: [cost_artifact]
    run: |
      python3 basis/tools/write_cost_rows.py ${session_record.id} --anchor ${run_anchor}
    next: validate

  - id: validate
    name: Validate the record
    run-by: {execution: runtime}
    inputs: [session_record]
    outputs: [validation]
    run: |
      shop-knowledge validate ${session_record.path}
    next: route-validation

  - id: route-validation
    name: Route on validation
    run-by: {execution: runtime}
    inputs: [validation, round]
    branches:
      - label: "success exit: record validates"
        when: validation.ok
        next: land
      - label: "failsafe exit: round >= 3"
        when: round >= 3
        next: file-defect
      - else: repair

  - id: repair
    name: Repair the record
    run-by: {role: router, execution: agent}
    inputs: [session_record, validation]
    outputs: [session_record]
    prompt: |
      Repair every named violation in the validation errors. Do not
      remove content to pass validation — a section the schema demands is
      written, not deleted.
    next: advance-round

  - id: advance-round
    name: Advance the round counter
    run-by: {execution: runtime}
    inputs: [round]
    set:
      round: round + 1
    next: validate

  - id: file-defect
    name: File the validation defect
    run-by: {execution: runtime}
    inputs: [session_record, validation]
    run: |
      bd create --title "Session record failed validation at handoff: ${session_record.id}" \
        --body "${validation.errors}"
    next: land

  - id: land
    name: Land the handoff
    run-by: {execution: runtime}
    atomic: true
    inputs: [session_record]
    run: |
      git add -A && git commit -m "Session handoff: ${session_record.id}"
      bd dolt push
      git push
    next: end
```

## Derived checks

| Outcome | Check | Kind | Where |
|---|---|---|---|
| O1 | validation ran; success branch requires `validation.ok` | mechanical | `route-validation` |
| O2 | commit, registry push, and git push are one atomic act | mechanical | `land.atomic` |
| O3 | every correction row carries a target and a bead | mechanical | `collect.checks` |
| O4 | failsafe lands with a filed defect, never a silent drop | mechanical | `file-defect.run` |
| O5 | a cost row per agent run on `run_anchor`, none computed by a model, no row for a runtime step | mechanical | `write-cost-rows.run` |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-21 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 2 | 2026-09-02 | review | Skill rendering run (skill-rendering-process): the definition stands approved with no carried-by skill id, so no loadable skill renders at the agent’s load point — finding "missing session-handoff-process no-skill-id" escalated; the owner decides the amendment. |
| 3 | 2026-09-02 | update | Owner decision, resolving the skill-rendering first run's no-skill-id escalation: carried-by session-handoff-skill added, so the process renders to the agent's load point like every approved definition; the prose Carried-by paragraph left to the consistency pass (lead-dyz0o). |
| 4 | 2026-09-08 | update | Built under feat-run-measurement's five scenarios assigned to shopsystem-product (guidance/feat-run-measurement-shopsystem-product.md v1), per adr-2026-09-08-run-cost-artifact (D1, D2) and its unknowns' defaults (U1 wall-clock minutes; U3 no row for a runtime step). `write-cost-rows`, a runtime step, added between `collect` and `validate`: it reads the session's own run_anchor (new parameter and data value, distinct from the anchor-as-session-record sense the Scope note already carries) through `basis/tools/write_cost_rows.py`, and the process definition of the step the anchor names, and writes the run-cost typedef's rows to `sessions/<id>-cost.md` — never amending the session record, never a step naming a Bounded Context, no model computing a field. An empty run_anchor (no process definition moved the closed conversation through the router) writes nothing, per the feature's Edges row on that case. O5 and its derived check added. Self-check against the process-definition typedef's producing rules: every step's inputs and outputs declared in Data; no `$ref` added, none to source; the new tool exists at the path the step names before this version compiles, so check 11 passes; the loop's exits unchanged; no prose outside `prompt` fields, `write-cost-rows` carrying none since it is a runtime step. Observed in the running tree: `python3 basis/tools/write_cost_rows.py sess-2026-09-07-b --anchor lead-5wzgl` against the real anchor of the delivered request-intake run (feat-process-runner's own demonstration), producing `sessions/sess-2026-09-07-b-cost.md` — four agent/human-step rows and three router-turn rows, no row for any of the anchor's eight runtime or sub-process steps, one field blank where the anchor's own usage-report comment gave no separable per-step figure (never estimated), the session record itself unread by the write and unchanged. Made by the lead-solutions-architect role. |
