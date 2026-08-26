---
type: decision-brief
id: brief-031
status: delivered
date: 2026-08-26
reader: product-authority
decisions-requested: 3
annex: annex-031.md
version: 4
---

# Brief 031: the experience corpus records, the conformance check, and the PO typedefs

**Open findings at the round cap (four cold reads).** The decision
layer runs ~480 words against the ~400 budget; three terms arrive
before their gloss — "PO output check" (the process that screens the
PO role's output, approved 2026-08-26), "recording" in ask 2 (the
same thing as the delivery record glossed later in that ask), and
"brief" in ask 3 (the PO role's brief, type `brief`, not this
document's type); and "undecidable" is a review finding, distinct from
the `pending-corpus` status ask 2 names, which the process sets only
on a definition-change verdict. The reader also asked that the
missing delivery-record typedef be marked as an accepted tradeoff: it
is — the process runs without it.

**The answer first.** You asked for three things after approving the
experience guidelines on 2026-08-26: the seven records the guidelines
judge against (together, "the corpus"); the process that reviews a
shop's delivered interaction — one of the glossary's seven interaction
types, as the shop records it — against them; and typedefs for the
four artifacts the PO role makes. All three are built, reviewed clean
in fresh contexts, and pushed. One fact bears on every decision: the
records are seeded from our own definitions, not from users, so every
entry but one is marked `hypothesis`, and a review that encounters a
hypothesis entry returns "undecidable" — a finding against the corpus,
never a pass or a fail of the delivery. Recommendation: approve all
three. Ask 1 gates ask 2 (no records, nothing to review against); ask
3 gates the PO output check's first run. None defaults on silence.

## Asks

**1. Approve the `experience-record` typedef and its seven records.**
*What you approve:* one document type for the corpus's records —
vocabulary, core tasks, interaction patterns, design tokens,
hard-to-reverse actions, persona and voice, variations — each a table
with fixed columns and a `status` of `evidenced` or `hypothesis`; and
the seven seeded instances. *Binds:* the table shapes; the glossary's
seven interaction types as the only type names; and the rule that an
absent record, an empty record, or a hypothesis entry makes a rule
"undecidable" against the corpus. *Drafting default:* the entries —
the product designer role revises them from user research and you
approve each revision as owner. *Evidence:* three review rounds, clean
at the third. *Default:* none.

**2. Approve the `interaction-conformance-check` process.** *What you
approve:* when a shop delivers an interaction, the product designer
role reviews the shop's recording of it against the corpus in a fresh
context, decides from that review alone, and records the decision;
findings the shop can repair are filed as a work item for the
solutions architect role, which carries them to the shop. *Binds:*
those three steps and the routing of findings; the designer may put a
question to the PM or the solutions architect only for what the corpus
cannot answer by design — whether the product should offer the
interaction at all, or whether a contract change is admissible.
*Drafting default:* the three status values (`conforms`, `returned`,
`pending-corpus`) the process writes on the delivery record — the
record a shop returns with its interaction, which has no typedef yet.
*Evidence:* three rounds, clean at the third. *Default:* none.

**3. Approve the typedefs for brief, product decision record,
acceptance scenarios, and backlog order.** *What you approve:* four
document types, each requiring exactly the sections its approved
fitness set judges — the criteria sets you approved for the PO output
check. *Binds:* those sections. *Drafting default:* the wording of the
templates rendered from them. *Evidence:* three rounds, clean at the
third. *Default:* none.

## Deferred

- User research to move record entries from `hypothesis` to
  `evidenced` — the product designer role's field work; not asked here
  because no user-test tooling exists yet.
- Brief-030's two remaining asks (the role-definition typedef; the
  skills import plan) — still open for your decision.

## Annex

[annex-031.md](annex-031.md) — files, versions, and what each review
round caught (optional).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Composed from the three tracks' screens. |
| 1 | 2026-08-26 | review | Cold read round 1: findings — dense evidence sentences, unglossed terms, block approvals not stating what they bind, the delivery-record dependency hidden in Deferred. |
| 2 | 2026-08-26 | update | Each ask restated as what is approved, what it binds, what stays a drafting default; terms glossed on first use; the delivery-record gap stated inside ask 2 as accepted; screen-catch lists moved to the annex. |
| 2 | 2026-08-26 | review | Cold read round 2: findings — decision layer over budget; a binding duplicated across asks 2 and 3; interaction-type tokens, recording, PO output check, and three status values unnamed; ask 2 without a drafting default. |
| 3 | 2026-08-26 | update | Tightened: the status values named once in ask 2 as its drafting default; ask 3 reduced to one sentence; the token list and the PO output check glossed; the gating chain corrected. |
| 3 | 2026-08-26 | review | Cold read round 3: findings — decision layer ~90 words over; "screen" in three senses; the ask criterion abstract; delivery record and the roles' names inconsistent. |
| 4 | 2026-08-26 | update | "review" for the activity throughout; one name per role; the ask criterion made concrete; delivery record glossed at first use; design rationale cut from ask 2. |
| 4 | 2026-08-26 | review | Cold read round 4 (cap): findings — decision layer ~80 words over; three terms before their gloss; undecidable vs pending-corpus unstated; the untyped delivery record not marked accepted. Delivered with the open findings stated first. |
| 4 | 2026-08-26 | state | draft → delivered at the round cap. |
