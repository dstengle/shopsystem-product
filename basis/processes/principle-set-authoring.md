---
type: process-definition
id: principle-set-authoring-process
owner: product-authority
status: approved
approved: 2026-08-23
version: 6
created: 2026-08-22
updated: 2026-08-26
produces: [principle-set]
carried-by: principle-set-authoring-skill
condition-language: cel
hold-after: P7D
annotations:
  claude-code:
    activation: model-judged
    promotion: experiment-local
    use-when: "authoring or amending a principle set"
---

# Process: Principle-set authoring

**Purpose:** Author or amend a principle set: the author drafts through
the guideline, an independent fresh-context judge scores the draft
against the fitness set, and the set enters force only by the owner's
approval.

**Guiding statement:** Define good before governing with it. A principle
enters the set only through the written definition of a good principle —
the statement decides, the rationale evidences, the implications price —
never on taste.

**Outcomes:**
- O1. A draft in the four-part form with its screen exists, at the
  requested scope — witnessed by the check on `draft` and fitness
  scenarios 1 and 5.
- O2. An independent fresh-context judge has scored every round against
  the fitness set — witnessed by `screen-read` and the `round_log`.
- O3. The set enters force only by the owner's approval — witnessed by
  `authority-approve` and the `route-approval` branches: `end` is
  reached only by the owner's approving verdict or the `park` failsafe,
  and only the approving verdict puts the set in force.
- O4. A draft that cannot pass within its round caps parks with a filed
  finding instead of looping — witnessed by the failsafe branches of
  `route-verdict` and `route-approval` and the `park` step; an inactive
  authority exchange holds per `hold-after` and the run lifecycle.

**Roles:** author — lead-pm, held by the authority; its agent steps
assist: `draft` and `revise` prepare the set and keep new terms flowing
to the glossary, and the authority decides at `authority-approve` whether
the set stands. screen judge —
[`../roles/cold-reviewer.md`](../roles/cold-reviewer.md) (Verifier; a
fresh instance per round, never the author; scores the
[fitness set](../fitness/principle-set.fitness.md)). approver —
product-authority (human-held role; the owner named in the set's frontmatter —
the only role that moves the set to approved).

**Carried by:**
[`../skills/principle-set-authoring/SKILL.md`](../skills/principle-set-authoring/SKILL.md)
— generated from this definition by
[`../tools/compile_process.py`](../tools/compile_process.py), never
edited by hand.

## Flow (compiled)

Generated from the steps below by `tools/compile_process.py`; do not
edit by hand.

```mermaid
flowchart TD
  draft(["Draft the set — agent: lead-pm<br/>in — sources: string[], scope: string, guideline_paths: string[], glossary: glossary<br/>out — set: principle-set, glossary: glossary"])
  screen_read(["Screen read — agent: cold-reviewer<br/>in — set: principle-set, fitness_path: string<br/>out — review: review"])
  log_round["Record the round — runtime<br/>in — review: review, round_log: review[]<br/>sets — round_log: review[]"]
  route_verdict{"Route on the verdict<br/>in — review: review, round: integer"}
  revise(["Revise — agent: lead-pm<br/>in — set: principle-set, review: review, guideline_paths: string[]<br/>out — set: principle-set"])
  advance_round["Advance the round counter — runtime<br/>in — round: integer<br/>sets — round: integer"]
  authority_approve[["Owner decides on the screened draft — human: product-authority<br/>in — set: principle-set, round_log: review[]<br/>out — set: principle-set, review: review"]]
  route_approval{"Route on the owner's decision<br/>in — review: review, round: integer"}
  park["Park the draft with a finding — runtime<br/>in — scope: string, round: integer, review: review"]
  __end(("end<br/>result — set: principle-set"))
  __start(("start")) --> draft
  draft --> screen_read
  screen_read --> log_round
  log_round --> route_verdict
  route_verdict -->|success exit: clean or tradeoffs accepted| authority_approve
  route_verdict -->|failsafe exit: round >= 3| park
  route_verdict -->|else| revise
  revise --> advance_round
  advance_round --> screen_read
  authority_approve --> route_approval
  route_approval -->|success exit: owner approves| __end
  route_approval -->|failsafe exit: round >= 6| park
  route_approval -->|else| revise
  park --> __end
```


## Data

Each entry names a process-local value. Simple types use JSON Schema
names inline; every structured shape is a `$ref` to a defined type with
an explicit source — `from:` links the defining file, or names the owning
package as `pkg:<package>/<type>` (fetched through that package's
contract tool). Conditions are CEL (Common Expression Language)
expressions over these names. `sources` lists the paths of the run's
source material — the owner's stated directions, autopsies of prior
instances, external standards, and, for an amendment, the existing
set; together with `guideline_paths` and `fitness_path` it is the
declared context load list per `least-context`.

```yaml
data:
  sources: {type: array, items: {type: string}}
  scope: {type: string, enum: [working, architecture]}
  guideline_paths: {type: array, items: {type: string}, initial: [../guidelines/principle-set.md, ../guidelines/base-writing-style.md]}
  fitness_path: {type: string, initial: ../fitness/principle-set.fitness.md}
  glossary: {$ref: glossary, from: ../artifacts/glossary-typedef.md}
  set: {$ref: principle-set, from: ../artifacts/principle-set.md}
  review: {$ref: review, from: ../types/review.md}
  round: {type: integer, initial: 1}
  round_log: {type: array, items: {$ref: review}, initial: []}
```

## Steps

```yaml
start: draft
parameters: [sources, scope]
result: set
steps:
  - id: draft
    name: Draft the set
    run-by: {role: lead-pm, execution: agent}
    inputs: [sources, scope, guideline_paths, glossary]
    outputs: [set, glossary]
    checks:
      - set.scope == scope
    prompt: |
      Author the set, or amend the existing one, from the listed sources
      only — the owner's stated directions, autopsies of prior
      instances, named external standards, and, when amending, the
      existing set listed among the sources. Content in an undefined
      format is source material for a rewrite, never pasted. Open by
      defining what a good principle looks like; then write each
      principle in the four parts — slugged name, statement, rationale,
      implications — through the guideline files listed in
      guideline_paths. Close with the fitness screen applying the
      opening's tests to every principle. Every new or changed term
      goes to the glossary before the draft leaves this step.
    next: screen-read

  - id: screen-read
    name: Screen read
    run-by: {role: cold-reviewer, execution: agent, fresh-context: true}
    inputs: [set, fitness_path]
    outputs: [review]
    prompt: |
      Read the set alone, fresh — you have seen no earlier round, and
      that is the point. Score it against every scenario in the fitness
      set at fitness_path, in order; for each fail cite the
      principle and quote the failing text. Report stumbles in reading
      order and your top three changes. Verdict "clean" only if every
      scenario passes; "tradeoffs-accepted" only if every remaining
      finding is marked in the text as an accepted tradeoff; otherwise
      "findings".
    next: log-round

  - id: log-round
    name: Record the round
    run-by: {execution: runtime}
    inputs: [review, round_log]
    set:
      round_log: round_log + [review]
    next: route-verdict

  - id: route-verdict
    name: Route on the verdict
    run-by: {execution: runtime}
    inputs: [review, round]
    branches:
      - label: "success exit: clean or tradeoffs accepted"
        when: review.verdict in ["clean", "tradeoffs-accepted"]
        next: authority-approve
      - label: "failsafe exit: round >= 3"
        when: round >= 3
        next: park
      - else: revise

  - id: revise
    name: Revise
    run-by: {role: lead-pm, execution: agent}
    inputs: [set, review, guideline_paths]
    outputs: [set]
    prompt: |
      Repair every finding in the review, through the guideline files
      listed in guideline_paths. Re-check
      the screen table for every principle you changed — the screen is
      the author's self-check and must match the text it sits under.
      Mark any finding you will not repair as an accepted tradeoff, in
      the text, with one sentence saying why.
    next: advance-round

  - id: advance-round
    name: Advance the round counter
    run-by: {execution: runtime}
    inputs: [round]
    set:
      round: round + 1
    next: screen-read

  - id: authority-approve
    name: Owner decides on the screened draft
    run-by: {role: product-authority, execution: human}
    inputs: [set, round_log]
    outputs: [set, review]
    prompt: |
      The screened draft and its round log are in front of you. Your
      decision is the review's verdict. "clean" or "tradeoffs-accepted"
      approves: the set is stamped — status approved, the approval date,
      your role as owner — and from that point it is the standard
      activities are checked against, amendable only through this
      process by your decision. "findings" returns the draft to the author
      with your findings; the round counter keeps running, so a draft
      that cannot satisfy you within the cap parks instead of looping.
      Silence holds the run after the declared window — `hold-after` in
      this definition's frontmatter — per the process-definition
      typedef's run lifecycle; the held run keeps its resume point.
    next: route-approval

  - id: route-approval
    name: Route on the owner's decision
    run-by: {execution: runtime}
    inputs: [review, round]
    branches:
      - label: "success exit: owner approves"
        when: review.verdict in ["clean", "tradeoffs-accepted"]
        next: end
      - label: "failsafe exit: round >= 6"
        when: round >= 6
        next: park
      - else: revise

  - id: park
    name: Park the draft with a finding
    run-by: {execution: runtime}
    inputs: [scope, round, review]
    run: |
      bd create --title "Principle set parked: ${scope} scope after ${round} rounds" \
        --body "${review.top_changes}"
    next: end
```

## Derived checks

| Outcome | Check | Kind | Where |
|---|---|---|---|
| O1 | draft scope matches the requested scope | mechanical | `draft.checks` |
| O1 | four-part form; screen present and covering | judged | fitness scenarios 1 and 5, scored in `screen-read` |
| O2 | every round recorded; judge fresh per round | mechanical | `log-round` set; `screen-read` `fresh-context` |
| O3 | `end` reached only by the owner's approving verdict or `park`; only the verdict puts the set in force | mechanical | `route-approval` branches |
| O4 | both loops capped; parked drafts carry a filed finding | mechanical | `route-verdict` and `route-approval` failsafe branches; `park.run` |
| all | this definition compiles and screens against the principle set | mechanical + judged | the compiler; the principles screen |

## Sources

The draft → fresh cold read → dual-exit route loop is the shop's
stakeholder-presentation shape, reapplied; the owner's terminal gate
composes the review-conversation model (the authority's close is the
only end). Deming grounds the role separation: the author and the
judge read one definition, and the check sits with a different role.
Format provenance (ISO 24774 header, GitHub-Actions-shaped steps, CEL,
the dual-exit rule) lives in the process-definition typedef, not here.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-22 | update | Authored as part of the principle-set chain. |
| 1 | 2026-08-23 | state | draft → approved by the owner. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 2 | 2026-08-23 | review | Screened against the drafted process-definition fitness set: findings — agent prompts load undeclared context (guideline, fitness set, the existing set for amends; "the anchor" undefined); route-verdict's branch order lets the owner-rejection loop run unbounded, so the promised park cannot fire; O3's witness clause ignores the park path. Repairs await the owner's decision at the meta-chain review. |
| 3 | 2026-08-23 | update | Owner-directed repairs through the approved process-definition guideline: context loads declared (guideline_paths and fitness_path as data; the existing set rides sources for amendments; prompts reference declared names only; "the anchor" replaced with the run lifecycle's held-run resume point); the owner-rejection loop gains a labeled failsafe (round >= 6 → park); O3/O4 witness clauses corrected for the park path. |
| 3 | 2026-08-23 | state | Repairs approved by the owner with the meta-chain approval. |
| 3 | 2026-08-23 | review | Re-screened after repairs: findings — one residual (the glossary duty in draft's prompt references undeclared context); two mechanical stumbles (round absent from route-approval inputs; the hold window unlinked). |
| 4 | 2026-08-23 | update | Residual repairs: glossary declared as data and as draft's input/output; round added to route-approval's inputs; the hold window linked to `hold-after` and the typedef's run lifecycle. |
| 4 | 2026-08-23 | review | Final re-screen against the process-definition fitness set: clean — all six scenarios pass; three stumbles (hold-window frontmatter reference, the compiled 'writes: —' summary on set-clause steps, O1's cross-file witness), none a fail. |
| 5 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
| 6 | 2026-08-26 | update | Owner decision: lead-pm is held by the authority in person; the Roles header now names what the role's agent steps prepare and what the authority decides, per the lead-pm role's Interfaces. |
| 6 | 2026-08-26 | review | Assist re-basing screened: the header named a step that does not exist — repaired in place. |
