---
type: artifact-typedef
id: quality-guideline-typedef
defines: quality-guideline
owner: product-authority
status: approved
approved: 2026-08-22
version: 1
created: 2026-08-19
updated: 2026-08-19
ancestry: [definition, quality-guideline]
---

# Artifact type: quality-guideline

## Identity and ancestry

- **Type:** `quality-guideline` — the definition of well-made prose for
  an artifact type or for all prose (the base writing style is a
  quality-guideline every other one layers on and never overrides).
- **Produced by:** the owner (authority-authored styles are stored verbatim as guideline documents) or
  a definition author deriving type-specific rules. **Consumed by:**
  authors at write time (the Highlights block is the layer compiled into
  generating context); mechanical style checks and judges, which cite
  rules by number.

## Required frontmatter

`type: quality-guideline`, `id`, `owner`, `status`, `created`,
`updated`; `target-type` (the artifact type governed; absent for the
base style, which governs all prose).

## Required sections

1. **Voice principle** — one sentence naming the reader and the stance.
2. **Highlights** — the compressed layer compiled into the author's
   context.
3. **Layers** — what this guideline sits on and the precedence order when
   rules conflict (a approved principle beats the artifact type's typedef, which beats
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
is decidable yes/no on real text and feeds a named check — a check that
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
| 1 | 2026-08-19 | update | Authored (seed layer); earlier history, if any, in the review record ledger on `main`. |
| 1 | 2026-08-22 | state | draft → approved. |
