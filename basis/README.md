---
type: experiment-index
id: basis-readme
title: The new-basis experiment — slice map, linking model, review surface
status: experiment
created: 2026-08-10
updated: 2026-08-10
authors: [dstengle, "Claude (lead-pm)"]
description: One experimental slice per foundational format, interlocked on the stakeholder-presentation domain; isolated on branch experiment/new-basis.
---

# The new-basis experiment

**Branch `experiment/new-basis`, worktree-isolated. Nothing here touches
`main` or the live corpus.** Authority direction 2026-08-10: prove out the
foundational formats with an example set, via experimental slices, before
any wider implementation.

## What this is

One experimental slice per foundational format from the decision brief's
Ask 0 — but not seven disconnected samples: every slice is drawn from **one
real domain** (the stakeholder-presentation process and its decision-brief
artifact, adversarially calibrated 2026-08-06), so the slices interlock and
the linking model is demonstrated rather than asserted. Principles, which
are domain-independent, use three examples from the re-founding dialogue.

| Slice | Format proven | File |
|---|---|---|
| 1 | Principles (TOGAF 4-part + BCP 14, with the composed fitness screen applied) | `principles.md` |
| 2 | Process definitions (ISO 24774 header + ETVX cells + dual-exit loops) — two examples: one with a loop, one without | `processes/` |
| 3 | Role definitions (subagent container + accountability bullets + domains) | `roles/cold-reviewer.md` |
| 4 | Artifact schemas (15289 generic type + required content + DoD commitment + ancestry) | `artifacts/decision-brief.md` |
| 5 | Quality guidelines (style-guide anatomy; every rule = test + criterion + decision) | `guidelines/stakeholder-communication.md` |
| 6 | Fitness tests (judged Gherkin, segregated, 1:1 judge-rubric compile) | `fitness/decision-brief.fitness.md` |
| 7 | Skill & context governance (skill as *derived projection* of a process definition) | `skills/stakeholder-presentation/SKILL.md` |

## The linking model, concretely

`processes/stakeholder-presentation.md` names its activities → each activity
names its accountable **role** (`roles/cold-reviewer.md` for A3a) and its
carrying **skill** (slice 7, derived, conformance-checked) → the process
consumes and produces **artifact kinds** (`artifacts/decision-brief.md`) →
the artifact kind's quality is defined by the **guideline** (slice 5) and
verified by the **fitness set** (slice 6) → all of it operates under the
**principles** (slice 1). Every arrow is a real link in these files, not a
diagram promise. Projection metadata (`runtime.*` annotations) carries the
fabro/Claude-Code translation layer per the source-of-truth requirement
(recorded on bead lead-jozud.5).

## Review rulings (accumulated as the review proceeds)

- **R1 (2026-08-10, authority): all markdown MUST have front-matter.**
  Applied to every file in `basis/`, using the shared field set the live
  corpus already carries (type, id, title, status, created, updated,
  authors, description) plus per-kind fields. Consequence found on
  application: governance declarations that lived in HTML comments (the
  fitness set's judged/non-executable markers, the skill's derived-from and
  promotion state) moved into front-matter, where derived checks can
  actually read them. Joins the base schema at ratification; propagates to
  all markdown system-wide at rollout.

## Review asks (all default-free — this is the experiment)

Per slice: does the format hold on a real example — anything missing,
anything over-engineered? Across slices: does the linking model read as one
system? And the standing asks from the pilot: amalgam coherence, annotation
shape for fabro, the dual-exit loop rule, the derived-carrier rule for
process-shaped skills.

## What happens after review

Refine here, on this branch, until the formats settle. Ratification then
happens on the refined exemplars; only after that does anything migrate into
the live corpus or roll out across the system.
