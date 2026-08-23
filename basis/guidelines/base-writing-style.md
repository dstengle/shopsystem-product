---
type: quality-guideline
id: base-writing-style
owner: product-authority
status: approved
approved: 2026-08-19
version: 1
created: 2026-08-14
updated: 2026-08-14
---

# Base writing style

These rules apply to everything written for a human reader, regardless of
document type. Document types add a format layer on top of this base; they
never override it.

## Goal

The reader gets the point of any paragraph in one read, any section in 30
seconds, and the whole document in two minutes. Write for the first read.

## Lead with the point

At every scale, state the conclusion first and the support after.

- A document opens with what it found or decided, not how it got there.
- A section opens with its main claim, then evidence.
- A paragraph opens with its point, then elaboration.

If a document type defines a structure, that structure is just this rule
applied to that type. If no structure is defined, use this rule to invent
one.

## Detail placement

Precision serves the point; it never precedes it. Formal specification
language, methods, raw data, scoring tables, and citations go after the
claim they support — or in an appendix. The body is for understanding.

## Sentences

- One idea per sentence.
- Active voice, with a named actor: "Reviewers delete unlinked checks,"
  not "Unlinked checks are subject to deletion."
- Prefer the short common word: "use" not "utilize," "end" not
  "terminate," "before" not "prior to."

## Terminology

- Never use a metaphor as a technical term. If a word describes a thing
  by what it resembles instead of what it literally does, replace it with
  the literal description. Test: could a competent reader from outside
  the team work out the meaning from the words alone? If not, rewrite.
- Banned words. Never use these, in any form:
  - "load-bearing" → say "other work depends on it" or "critical to
    operations"
  - "surface" (as in context surface, config surface) → say "input,"
    "source," or "channel"
  - "seam" → say "boundary" or "integration point"
  - "scar tissue" → describe the actual problem, e.g. "an unreviewed
    workaround that was never removed"
- Explain every insider reference — a past incident, an internal system,
  a person — in one plain sentence, or cut it. Assume the reader knows
  none of our history.

## Style examples

These examples exist only to show sentence style. The domain (a public
library) is deliberately unrelated to our work. Copy the style; never
copy the content or vocabulary into real documents.

bad:

> Unreturned inventory constitutes scar tissue on the circulation loop
> and rapidly becomes load-bearing for downstream shelving throughput.

good:

> Overdue books pile up at the front desk, and staff spend their time
> reshelving late returns instead of helping visitors.

The bad sentence uses two metaphors as terms and never names an actor.
The good sentence says who is affected and what actually happens, in
plain words.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-14 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-19 | state | draft → approved. |
