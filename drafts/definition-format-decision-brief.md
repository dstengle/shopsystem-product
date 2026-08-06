# Definition formats — decision brief

**Sitting material, 2026-08-06 (rev. 2).** Everything needed to decide is on
these two pages. The full verified research is
[`definition-format-research.md`](definition-format-research.md) — a
reference annex, not required reading.

## The answer first

We are rebuilding the system's quality foundations on one rule: before
anything is produced or checked, there must be an explicit definition of what
good construction looks like. The first act is a **seed layer** — a small,
hand-ratified set of documents: the updated founding principles, plus the
format that every later definition (process, role, artifact, guideline) will
follow. You asked, before that drafting starts, whether the world already
provides these formats, and whether your Gherkin fitness-test idea holds up.
**The answer: every element has an established external form to adopt or
adapt — nothing structural needs inventing — and the Gherkin idea is sound
with three guardrails.** Six asks follow; all of them gate the seed-layer
drafting. Two choices from the earlier draft — which evaluation tool runs the
judged tests, and how often you grade samples — are **deferred** to the
sitting where that machinery is actually built, so nothing here commits you
to tooling.

## Ask 0 — ratify the format table as a block

The seven rows below are the recommended construction formats.
**Ask: ratify the table as a block; flag any row you want re-opened.**
No default — the seed-layer drafting waits on this ratification.

| Element | Recommended form | Source | What we'd still invent |
|---|---|---|---|
| Process definitions | Name + purpose + 3–8 observable outcomes; each activity a cell of entry conditions / tasks / validation / exit conditions; long-running loops end on reached states, not step counts | ISO 24774, IBM's ETVX frame, OMG Essence | nothing |
| Role definitions | Our existing agent-role file: frontmatter as the capability contract, body as 4–8 accountability bullets; consulted/informed assignments derived into role files, never a standalone chart | Claude Code roles, Scrum, RACI matrices | nothing |
| Artifact schemas | Generic type + required content per kind (the shape our writing skills already enforce), plus one Definition-of-Done-style quality commitment per kind and a worked example in the header | ISO 15289, Scrum, Microsoft's prompt-asset format | only each kind's field content |
| Principles | Name / Statement / Rationale / Implications, with strict keyword discipline for MUST/SHOULD | TOGAF, IETF BCP 14 | a principle checklist assembled from five published criteria sets |
| Quality guidelines | Every rule = test + criterion + yes/no decision; rubrics that state only the pass standard; checklists capped at 5–9 items; a style guide enforced by a prose linter | Deming, rubric practice, checklist research (Gawande), the Vale linter | nothing |
| Fitness tests | 3–10 Gherkin scenarios per output kind, evaluated by an LLM reviewer instead of executed as code | your proposal, over established LLM-evaluation patterns | only the Gherkin syntax layer |
| Skill & context governance | One activity per skill file; role primers capped at 200 lines; skills promoted to shared templates only through a gated release step; document-control rules from ISO 9001 as the audit checklist | Anthropic skill format, ISO 9001 | nothing |

## The Gherkin guardrails (inside Ask 0, row 6)

The pattern underneath — scenario, plain-language criteria, LLM judge — is
established practice; only the Gherkin syntax is ours, justified because it
is already the shop's contract vocabulary. Three guardrails are
non-negotiable: every `Then` names an observable property a reviewer could
point at when violated; judged scenarios live outside `features/` and are
marked non-executable; each `Then` translates one-for-one into an existing
LLM-evaluation format, so we never build our own evaluation engine. The
judge's model and prompt version are fixed and recorded with each test set,
and you grade a sample of its verdicts on a standing loop (cadence decided
when the machinery is built).

## The five format choices

1. **Requirement keywords** — IETF style (MUST/SHOULD in capitals) or ISO
   style (shall/should)? *Recommend IETF*: machine-checkable by a linter and
   native to the tooling world we operate in. Default: IETF.
2. **Decision records** — keep our current ADR form, or adopt MADR (a
   community Markdown ADR template with options-considered and a
   how-compliance-is-verified section)? *Recommend keep ours, add MADR's
   verification section and a one-line summary field.* Default: as
   recommended.
3. **Pass/fail or graded** — are artifact quality verdicts binary gates, or
   graded ladders (draft / ship / exemplary)? *Recommend binary to start*;
   add a ladder only where a kind demonstrably needs stages. Default: binary.
4. **Traceability weight** — does every process definition carry an explicit
   outcome-to-check table, or do checks just link back to the outcome they
   test? *Recommend links only*; full tables just for the seed-layer
   documents themselves, where the derivation is the point. Default: links.
5. **Principle set size** — cap at roughly ten, as one single set?
   Operated public principle sets run at this size (GOV.UK's eleven; TOGAF
   warns against sprawl). *Recommend ~10, one set*; split into
   framework-wide vs shop-local only if sharing across shops later demands
   it. Default: one set of ~10.

## Deferred, deliberately

Three items from the research are not asked here. Which evaluation tool runs
the judged fitness tests, and your sample-grading cadence, are deferred to
the sitting where the judging machinery is built — deciding tooling before a
single judged scenario exists would be premature. The naming of the shop's
workflow states is decided per-process as each definition is drafted.

## On ratification

With Ask 0 and the five choices settled, I draft the seed layer — the
principles update and the definition-format meta-definition — in the ratified
forms, as the next sitting material.
