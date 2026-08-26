---
type: artifact-typedef
id: experience-record-typedef
defines: experience-record
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
ancestry: [definition, experience-record]
---

# Artifact type: experience-record

## Identity and ancestry

- **Type:** `experience-record` — one of the seven records of the
  experience guidance corpus that the experience guidelines and the
  interaction fitness set judge against: the vocabulary and its
  platform mappings, the core-task list, the interaction patterns, the
  design tokens, the hard-to-reverse classification, the persona and
  voice, and the variations record. A record is a definition of good
  for interactions — a table the product designer role maintains and
  a screen (a judged check against a criteria set) reads — not prose.
- **Produced by:** the product designer role, from user research and
  the product's own definitions; every change is approved by the owner
  named in the frontmatter, as for any definition. **Consumed by:** the
  [interaction fitness set](../fitness/interaction.fitness.md)'s judge;
  the experience guidelines' rules; Bounded Context shops building an
  interaction; the PO role, for acceptance criteria.

## Required frontmatter

`type: experience-record`, `id`, `record` (one of `vocabulary`,
`core-tasks`, `patterns`, `tokens`, `hard-to-reverse`, `persona-voice`,
`variations` — a closed set), `owner`, `status`, `version`, `created`,
`updated`; `maintained-by: lead-product-designer`. Wherever a record
names interaction types it uses the closed token set `cli`, `tui`,
`gui`, `api` (API and SDK), `conversational`, `voice`, `document` —
the glossary's interaction types, one token each, or `every type`
where a column admits it.

## Required sections

1. An **opening** stating which record this is, what reads it, and
   what an entry means.
2. **Entries** — one table, columns fixed per record kind, every kind
   ending in `status` (`evidenced` — the source is a user test,
   measured use, or a platform guideline; for `variations`, a recorded
   reason — or `hypothesis` — the entry is proposed from a product
   definition or by design judgment and awaits evidence) and, except `variations`, `source`:
   - `vocabulary`: term · meaning ("see glossary" for a glossary term)
     · platform mappings (type: word, only where the platform's word
     differs) · source · status.
   - `core-tasks`: task · what a person or agent accomplishes ·
     interaction types it holds on (every type, unless the next column
     gives a reason) · types it is removed from, with the reason ·
     options every type must offer · source · status.
   - `patterns`: pattern · where it applies · the shape (in words) ·
     platform guideline it follows, by name · source · status.
   - `tokens`: token · value · used for · source · status.
   - `hard-to-reverse`: a product action · why it is hard to reverse ·
     what the assistant states before it · source · status.
   - `persona-voice`: dimension or trait · setting · when it varies ·
     source · status.
   - `variations`: rule varied · interaction type · the variation · the
     reason · recorded by (the guideline or the role; this record's
     evidence is the reason, so it carries no source column) · status.
   A record with no entries yet says so in one sentence under the
   heading. The screen's verdicts: a record that does not exist —
   "undecidable: record absent"; a record with no entry for what the
   rule needs — "undecidable: record empty"; an entry marked
   `hypothesis` — "undecidable: entry is a hypothesis". Each is a
   finding against the corpus, never a pass and never a finding
   against the delivery.
3. **Checks** — which guideline rules and fitness scenarios read this
   record: the document linked and the rule or scenario number.

## Rules

- An entry's `source` names the evidence for an `evidenced` entry (a
  user test, measured use, a platform guideline) or the origin of a
  `hypothesis` entry (a product definition, or "design judgment");
  never a stakeholder's or maker's preference presented as evidence
  (`evidence-not-opinion`).
- A term in the vocabulary that is also in the
  [glossary](../glossary.md) carries the glossary's meaning, written
  "see glossary"; the vocabulary adds the platform mappings.
- The variations record is the one home for a per-type departure from
  a corpus rule (`consistent-not-uniform` bullet 4).

## Commitment (Definition of Done)

A record is done when the screen that reads it can decide every rule
that names it without asking the product designer role — every entry
the rule needs present and `evidenced`. **Consequence
on failure:** the rules that name it return the applicable
undecidable verdict — record absent, record empty, or entry is a
hypothesis — and every interaction they screen carries that finding.

## Sources

Design-system practice (Atlassian's tokens as "the single source of
truth"; GOV.UK's design system contribution model); Nielsen Norman
Group's tone-of-voice dimensions (persona-voice); the experience
principle set; the experience guidelines that name each record.

## Derived review checklist

- `record` is one of the seven; `maintained-by` present. *(§Required frontmatter)*
- The table's columns match the record kind. *(§Required sections 2)*
- Every entry carries a status, and a source that is evidence or a `hypothesis` mark; variations carry a reason instead of a source. *(§Required sections 2; §Rules)*
- Interaction types use the closed token set. *(§Required frontmatter)*
- The Checks section names at least one rule or scenario. *(§Required sections 3)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction so the corpus records the experience guidelines judge against have a definition before their instances; seven record kinds, one table shape each. |
| 1 | 2026-08-26 | review | Screened with the seven instances: findings — interaction-type tokens undefined; evidence-not-opinion not applied to the records (seeds enforceable as evidence); no verdict for a present-but-empty record; variations had no source column for the checklist to read; rule 2 contradicted the meaning column; who approves amendments unclear. |
| 2 | 2026-08-26 | update | Repairs: closed token set; a status column (evidenced / hypothesis) on every kind with the screen's three undecidable verdicts; variations' reason stands in for source; "see glossary" for glossary terms; owner approves every change; Checks cite document and number. |
| 2 | 2026-08-26 | review | Re-screened: findings — the commitment named one of three verdicts; variations could not be evidenced under the status definition; rule 1 and the status definition disagreed on source; "every type" not admitted by the token rule. |
| 3 | 2026-08-26 | update | all four aligned; screen introduced. |
| 3 | 2026-08-26 | review | Re-screened (round 3): clean. |
