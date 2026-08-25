---
type: artifact-typedef
id: research-report-typedef
defines: research-report
owner: product-authority
status: approved
approved: 2026-08-23
version: 4
created: 2026-08-23
updated: 2026-08-25
ancestry: [research-report]
---

# Artifact type: research-report

## Identity and ancestry

- **Type:** `research-report` — the answer to a research question,
  delivered so its consumer can act on it: findings each carrying a
  confidence level and a source that exists, the alternatives
  considered, and the limits of what was learned.
- **Produced by:** the research-inquiry process
  ([`../processes/research-inquiry.md`](../processes/research-inquiry.md)).
  **Consumed by:** whoever asked the question — the product authority
  or a process that needs a sourced answer; stored on the `research`
  branch and cited from the live system by branch and path.

## Required frontmatter

`type: research-report`, `id`, `status` (draft | delivered), `version`,
`date`, `question` (the question answered, verbatim), `requested-by`
(the consumer role), `created`, `updated`.

## Rules

- Every finding carries a confidence level from the report's declared
  scheme and at least one source identifier — a URL, DOI, or
  repository path — that was opened during the run. A claim resting
  on model knowledge alone is labeled as such with lowered confidence.
- Confidence (in the evidence and analysis) and likelihood (of the
  claim being true or the event occurring) are stated separately,
  never in one phrase.
- Facts, assumptions, and judgments are distinguishable on the page.
- A reference that could not be verified to exist is marked
  UNVERIFIED, never silently kept; the report never presents a
  reference it did not open.
- A report lives on the `research` branch and is registered as a row
  in the research index (`research/index.md` on `rebaseline`); no
  other tree carries the body.

## Required sections

1. **Executive summary** — the top findings, each with its confidence,
   answer first.
2. **Method** — what was searched, fetched, and read; what could not
   be.
3. **Findings** — each: the finding, its confidence, its sources,
   and the evidence quoted or paraphrased from them.
4. **Alternatives considered** — plausible readings that were weighed
   and why the findings stand against them (a required section even
   when short).
5. **Limitations** — missing data, unreadable sources, scope limits,
   and what would change the judgment.
6. **Sources** — every source opened, with its verification status.

## Commitment (Definition of Done)

A research report is done when every finding traces to an opened
source or is labeled knowledge-only, every reference is verified or
marked, the consumer's question is answered in the executive summary,
and a cold read confirms the consumer can act on it. **Consequence on
failure:** the report is not delivered; a report with unverified
references presented as verified is withdrawn.

## Sources

ICD 203 analytic tradecraft standards (source quality; uncertainty
and confidence; distinguishing facts, assumptions, and judgments;
alternatives; relevance; argumentation up front); Kent's words of
estimative probability (defined confidence language); vendor
hallucination-reduction guidance (quotes-first grounding, citation
with retraction, permitted abstention); the research report on the
`research` branch that established these requirements
(`research:research/research-prompting-2026-08.md`).

## Derived review checklist

- Every finding carries confidence and an opened source; knowledge-only
  claims labeled. *(§Rules)*
- Confidence and likelihood never combined in one phrase. *(§Rules)*
- Alternatives section present and non-empty. *(§Required sections 4)*
- Every reference verified or marked UNVERIFIED. *(§Rules)*
- Cold read passed before delivery. *(Commitment)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored from the research report on research prompting; the type's guideline and fitness set are not yet authored — chain incomplete, a filed gap. |
| 2 | 2026-08-23 | update | Owner direction: registration moves to the typed research index. |
| 3 | 2026-08-23 | update | Owner direction: the research index instance lives on `rebaseline` at `research/index.md`, not on `main`. |
| 3 | 2026-08-23 | state | draft → approved by the owner. Guideline and fitness set for the type remain to be authored — a filed gap. |
| 4 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
