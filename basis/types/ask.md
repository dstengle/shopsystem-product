---
type: data-type
id: ask
defines: ask
owner: product-authority
status: draft
version: 2
created: 2026-08-25
updated: 2026-08-25
---

# Data type: ask

## Purpose

A question one activity puts to another role, returned by an agent or
human step in place of its outputs. Produced by any step that carries
`asks`; routed by the runtime to whoever fills the role
named in `to`; consumed by that role, which writes `answer`, and by the
asking step, which resumes with the ask in its inputs. The process
declares an `ask` data value (`$ref: ask`) and lists it in each asking
step's inputs. Two resume paths: *answered* — the step acts on
`answer`; *defaulted* — the step acts on `default`, because the
process's `ask-cap` passed unanswered or because the step returned a
second ask in the same run (at most one is allowed). See the
[process-definition typedef](../artifacts/process-definition.md), §The
steps section and §Run lifecycle. A `clarify` — a Bounded Context
shop's question to the lead shop — conforms to this shape.

## Schema

```yaml
schema:
  type: object
  fields:
    to: {type: string}            # asker writes: the role asked; a derived check confirms it is in the step's `asks`
    kind:                         # asker writes: what the asker lacks
      type: string
      enum: [pre-state, intent, reserved-decision, scope, vocabulary, structure, contract]
      # pre-state: what a thing is before a change; intent: what the originator wanted;
      # reserved-decision: a decision another role's domain holds; scope: whether
      # something is in or out; vocabulary: what a term means; structure: which
      # Bounded Context owns something; contract: what is promised across a boundary
    question: {type: string}      # asker writes
    default: {type: string}       # asker writes: what the step will do if the ask resolves defaulted
    checkpoint: {type: string}    # asker writes: partial output sufficient to resume from
    answer: {type: string, optional: true}       # answering role writes
    answered_by: {type: string, optional: true}  # runtime writes: the role that answered
    resolution:                                  # runtime writes
      type: string
      enum: [answered, defaulted, cancelled]     # cancelled: the held run was cancelled
      optional: true
```

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-25 | update | Authored by owner decision: the ask mechanism is held-and-resumed only — a step returns an ask instead of an output, the run holds, the role answers, the step resumes with the answer; asks carry a default and a checkpoint; clarify becomes a specialization. |
| 1 | 2026-08-25 | review | Screened: findings — the ask-resume loop had no exit; the resumed ask had no declared data name; only the answered path was described; three fields had no writer; the kind enum did not cover clarify. |
| 2 | 2026-08-25 | update | Repairs: one ask per step per run; the process declares an `ask` value listed in asking steps' inputs; both resume paths stated; a writer per field; kind enum aligned to clarify's four subjects plus pre-state, intent, and reserved-decision, each explained. |
| 2 | 2026-08-25 | review | Re-screened with the typedef: clean — all eight repairs confirmed, no synchronous form survives; three wording stumbles polished in place. |
