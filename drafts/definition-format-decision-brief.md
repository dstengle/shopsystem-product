# Definition formats — decision brief

**Sitting material, 2026-08-06 (rev. 3).** Everything needed to decide is on
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
with three guardrails.** Six asks follow. **Only Ask 0 requires your answer**
— drafting waits on it; the five choices after it resolve by their stated
defaults if you say nothing. Nothing here commits you to any tool: tooling choices for the
fitness-test machinery, and the cadence of your own quality sampling, are
deferred to the sitting where that machinery is actually built.

## Ask 0 — ratify the format table as a block

The seven rows below are the recommended construction formats.
**Ask: ratify the table as a block; flag any row you want re-opened.**
No default — the seed-layer drafting waits on this ratification.
What ratification binds: the **structures and their sources**. The numeric
caps in the rows (3–8 outcomes, 5–9 checklist items, 200-line primers, and
similar), the sampling loop, and row 7's gated release step — a process
commitment, not a structure — are **drafting defaults**, each revisable at
the ratification of the document that carries it.

| Element | Recommended form | Source | What we'd still invent |
|---|---|---|---|
| Process definitions | Name + purpose + 3–8 observable outcomes; each activity a cell of entry conditions / tasks / validation / exit conditions; long-running loops end on reached states, not step counts | ISO 24774, IBM's ETVX frame, OMG Essence | nothing |
| Role definitions | Our existing agent-role file: frontmatter as the capability contract, body as 4–8 accountability bullets; consulted/informed assignments derived into role files, never a standalone chart | Claude Code roles, Scrum, RACI matrices | nothing |
| Artifact schemas | Generic document type + required sections per kind — the structure the per-kind writing guides already enforce (a session record must carry Outcome and Open threads, for example) — plus one Definition-of-Done-style quality commitment per kind and a worked example in the header | ISO 15289, Scrum | only each kind's field content |
| Principles | Name / Statement / Rationale / Implications, with strict keyword discipline for MUST/SHOULD | TOGAF, IETF BCP 14 | a principle checklist assembled from published criteria (TOGAF, Spool, Rumelt, Lencioni) |
| Quality guidelines | Every rule = test + criterion + yes/no decision; rubrics that state only the pass standard; checklists capped at 5–9 items; a style guide whose rules are mechanically enforceable by a prose linter (tool chosen later) | Deming, rubric practice, checklist research (Gawande) | nothing |
| Fitness tests | 3–10 Gherkin scenarios per output kind, evaluated by an LLM reviewer instead of executed as code | your proposal, on top of established LLM-evaluation practice | only the Gherkin syntax layer |
| Skill & context governance | One activity per skill file; role primers capped at 200 lines; skills promoted to shared templates only through a gated release step; document-control rules from ISO 9001 as the audit checklist | Anthropic skill format, ISO 9001 | nothing |

## The Gherkin guardrails (detail for row 6)

The pattern underneath — a scenario, plain-language criteria, an LLM acting
as reviewer — is established practice; only the Gherkin syntax is ours,
justified because it is already the shop's contract vocabulary. Three
guardrails are non-negotiable: every `Then` names an observable property a
reviewer could point at when violated; judged scenarios live outside
`features/` and are marked non-executable; and each `Then` must translate
one-for-one into whichever established evaluation tool is later chosen — a
portability requirement that exists precisely so we never build our own
evaluation engine. The reviewing model and its prompt are fixed and recorded
with each test set, and a sample of its verdicts is graded by you — loop
details set at the deferred tooling sitting.

## The five format choices

1. **Requirement keywords** — IETF style (MUST/SHOULD in capitals) or ISO
   style (shall/should)? *Recommend IETF*: machine-checkable by a linter and
   native to the tooling world we operate in. Default: IETF.
2. **Decision records** — keep our current ADR form, or adopt MADR (a
   community Markdown ADR template adding options-considered and a
   how-compliance-is-verified section)? *Recommend keep ours, add MADR's
   verification section and a one-line summary field.* Default: as
   recommended.
3. **Pass/fail or graded** — are artifact quality verdicts binary gates, or
   graded ladders (draft / ship / exemplary)? *Recommend binary to start*;
   add a ladder only where a kind demonstrably needs stages. Default: binary.
4. **Traceability weight** — does every process definition carry an explicit
   table mapping each outcome to the checks that test it, or do checks simply
   link back to the outcome they test? *Recommend links only*; full tables
   just for the seed-layer documents themselves, where showing the derivation
   is the point. Default: links.
5. **Principle set size** — cap at roughly ten, as one single set? Operated
   public principle sets run at this size (GOV.UK's eleven; TOGAF warns
   against sprawl). *Recommend ~10, one set*; split into framework-wide vs
   shop-local only if sharing across shops later demands it. Default: one
   set of ~10.

## On ratification

With Ask 0 and the five choices settled, I draft the seed layer — the
principles update, and the format that all later definitions follow — in the
ratified forms, as the next sitting material.
