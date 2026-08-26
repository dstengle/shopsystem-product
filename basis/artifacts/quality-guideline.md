---
type: artifact-typedef
id: quality-guideline-typedef
defines: quality-guideline
owner: product-authority
status: approved
approved: 2026-08-22
version: 4
created: 2026-08-19
updated: 2026-08-26
ancestry: [definition, quality-guideline]
---

# Artifact type: quality-guideline

## Identity and ancestry

- **Type:** `quality-guideline` — the definition of well-made prose for
  an artifact type or for all prose (the base writing style is a
  quality-guideline every other one layers on and never overrides), or
  of a well-made interaction for one interaction type or for all of
  them (the common experience guideline is the one the per-type
  experience guidelines layer on).
- **Produced by:** the owner (authority-authored styles are stored verbatim as guideline documents) or
  a definition author deriving type-specific rules. **Consumed by:**
  authors at write time (the Highlights block is the layer compiled into
  generating context); mechanical style checks and judges, which cite
  rules by number.

## Required frontmatter

`type: quality-guideline`, `id`, `owner`, `status`, `created`,
`updated`; `target-type` (the artifact type governed; `interaction`
for an experience guideline; absent for the base style, which governs
all prose); `interaction-type` (experience guidelines only: one or more of
`cli`, `tui`, `gui`, `api`, `assistant`, `document` — a closed set
matching the glossary's interaction types, `cli` and `tui` split — or
`all` for the common experience guideline). For an experience
guideline the "artifact type's typedef" in the precedence order is
this typedef, and the common experience guideline ranks above the
per-type ones.

## Required sections

1. **Voice principle** — one sentence naming the reader and the stance.
2. **Highlights** — the compressed layer compiled into the author's
   context.
3. **Layers** — what this guideline sits on and the precedence order when
   rules conflict (an approved principle beats the artifact type's typedef, which beats
   any guideline; the base writing style is a guideline other guidelines
   never override, and it yields to principles and typedefs like any
   guideline).
4. **Rules** — each numbered, with a before/after pair and Deming's three
   elements: a test, a criterion, a yes/no decision — plus the derived
   check it feeds (mechanical, judged, or both).

Sections 1–3 may appear as bolded labels; Rules is a heading. The base
writing style is stored verbatim, so its structure is the authority's
own and is exempt from the section requirements.

## Commitment (Definition of Done)

A quality guideline is done when every rule
is decidable yes/no on real text — or, for an experience guideline, on
a delivered interaction — and feeds a named check (an experience
guideline's judged checks name scenarios of the `interaction` fitness
set) — a check that
exists, or a filed work item for the tool that will run it; "tool chosen
later" with no work item fails. **Consequence on failure:** the rule is
advice, not a definition, and is removed.

## Sources

Google and Microsoft style-guide anatomy (principle → highlights → rules
with examples → precedence); Deming's operational definitions; Federal
Plain Language guidelines.

## Derived review checklist

- Highlights block present and shorter than the rules. *(§Required sections 2)*
- Precedence stated. *(§Required sections 3)*
- Every rule: before/after + test + criterion + decision + derived check.
  *(§Required sections 4)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-22 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-08-26 | update | Owner direction: the type admits experience guidelines — target `interaction`, an `interaction-type` key with a closed set, decidability on a delivered interaction, judged checks naming the `interaction` fitness set — for the experience guidance corpus's second layer. |
| 3 | 2026-08-26 | review | Screened with the experience guidelines: the closed set admitted one value where the cli guideline covers two; the precedence order's second rank had no referent for an interaction target. |
| 4 | 2026-08-26 | update | interaction-type admits one or more values; the precedence referent for experience guidelines stated. |
