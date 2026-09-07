---
type: product-decision-record
id: pdr-2026-09-07-bet-tool-skills
status: draft
version: 1
date: 2026-09-07
decided-by: product-authority
right: bet
owner: lead-po
created: 2026-09-07
updated: 2026-09-07
---

# Product decision record: the bet on init-tool-skills

## Context

The initiative-check — the process that attaches feasibility and
usability to an initiative, screens it once, allows one revise, and
ends in the authority's bet — reached its decide step on 2026-09-07
for [init-tool-skills](../initiatives/init-tool-skills.md) with the
authority's *standing direction* in force: an instruction the
authority gave before the check and the lead-pm recorded at the
initiative's v2 — "If it passes then proceed to the rest without
asking me" — meaning the bet follows the check's pass, the feature
flows through the proof on the lint, and the other ten tools follow
as a second feature on the proof's pass, with no further ask. The
lint is the tool every session runs over the definition corpus; the
proof is the standard question the lint answers, the skill produced
from its answer, and an agent running the lint through that skill.
The bet was therefore taken on the direction, not in person at the
step: the lead-pm read the initiative's Framing, For whom, and
Appetite sections and the screen's result, took the bet as the
direction says, and recorded it (initiative v8).

The one screen (initiative v7) found three confident and five wobbly;
the one revise repaired all but one, which the lead-pm held with its
reason stated: the designer's D1 — the decision that a tool skill's
use entry takes one shape per use — records as an entry in the
experience guidance corpus's patterns record, the designer role's
exclusive domain, not as a record in decisions/. The revise also
noted the cap's margin: the initiative stands at 591 words against
the initiative typedef's 500-word bound, within the 20% variance the
authority ruled at the init-role-decisions bet
([pdr-2026-09-06-bet-role-decisions](pdr-2026-09-06-bet-role-decisions.md),
Context) while the cap's split — whether the bound divides between
the framing sections and the attachments — stands unrecorded.

The decision the bet rests on stood checked before it, for the first
time through the check's own route-decisions step (initiative v6):
[adr-2026-09-07-tool-answer](adr-2026-09-07-tool-answer.md) (v3) — a
framework tool's answer to the standard flag `--describe` is the sole
source of its skill. The architect's offer named it the one decision
the bet depends on; no bet in this shop before this one had its
architecture decision recorded ahead of the decide step.

## 1. Decision

The product authority takes the go on
[init-tool-skills](../initiatives/init-tool-skills.md), betting the
initiative's appetite — one working session of the lead shop for the
proof on the lint — on the initiative at v8, the text after the one
screen and the one revise with the designer's D1 held as a corpus
entry (Context), on 2026-09-07.

The authority's bet is the decision, under the `bet` right — the
right the product-decision-record typedef admits for the authority's
go, hold, or no-go on an initiative. The authority exercised it
through its standing direction (Context), the lead-pm taking the bet
at the initiative-check decide step as that direction instructs and
recording it in the initiative's Document History (v8). The go stands
unless the authority reverses it by a cancellation under the same
right (§4).

## 2. Alternatives

- **Hold — for the cap's split, or for the designer's corpus entry.**
  The authority could have held the bet until the 500-word cap's
  split had a record, since the initiative stands over the bound; or
  until the designer's D1 stood entered in the patterns record, since
  the screen found its "record: none" wobbly. Declined: the cap
  stands soft with 20% variance by the authority's own ruling at the
  prior bet, and 591 words is inside it; and the held finding's
  reason is stated — the designer's decisions land in the corpus,
  the entry is the attachment's own resulting action, and the standing
  direction asks for no hold on a finding the lead-pm can hold with a
  reason. Nothing the appetite spends waited on either.
- **No-go — decline the initiative.** Declined: 0 of 11 framework
  tools is usable through a skill, while the `tools-through-skills`
  principle, in force since 2026-09-06, requires every one to be —
  so every session that runs a tool today either breaks the principle
  or records a gap it cannot close; and the designer's observation
  makes the gap worse than the count reads — three of the five owned
  tools mislead an agent that asks them for help. The shop cannot
  operate under its own principle without this work.

## 3. Consequences

- The initiative moves `proposed` → `planned`: for the lead shop, the
  PO role authors its feature in the feature-authoring process and
  the backlog order places it — the lint's answer, the renderer, the
  load-point check's amendment, the skill, and one run of the lint
  through the skill. Cost: the appetite — one working session of the
  lead shop — is committed to this proof and not available to other
  work.
- The standing direction authorizes the second feature on the proof's
  pass without a further ask: for the lead-pm and the PO role, the
  other ten tools — the four compilers and the renderer by their own
  answers, the six external tools by descriptions written beside them
  — are authored, ordered, and taken up the moment the proof passes,
  with no decide step before the authority. Cost: a second appetite,
  which the initiative does not state, is spent without the authority
  pricing it at the time; the authority's first sight of it is the
  delivery. Forecloses: the authority re-pricing the rest against what
  the proof taught, unless it cancels (§4).
- The bet is taken on the standing direction, not in person: for the
  authority, the held finding and the cap's margin were noted by the
  lead-pm, not ruled by the authority; for every later reader, this
  record and the initiative's v8 row are the only account of how the
  bet was taken. Cost: if the authority would have ruled either
  differently, the remedy is a cancellation, not a repair at the
  step; and this is the first bet in the shop taken this way, so the
  standing-direction form has no observation before this one.
- The designer's D1 stands as a corpus entry: for the designer role,
  the use entry's one shape per use enters the patterns record for
  the `api` type as a hypothesis, made before the feature's delivery
  is screened; for the PO role, its usability scenario (b) — each use
  entry states what it does, takes, returns, and how it fails, with
  the exact invocation — rests on that entry. Cost: the entry is the
  designer's work inside this session; without it the conformance
  screen at delivery returns a finding against the corpus, not the
  skill, and the skill reaches delivery with its shape unscreened.
- The architecture decision's consequences start being spent: for the
  solutions architect role, the lint gains the `--describe` handler
  first, `compile_tool.py` is made, and the skill-rendering process's
  load-point check is amended to recognize a tool source; for the
  product authority, the tool-description data type is written and
  approved through the definition chain. Cost: one handler, one
  compiler, one process amendment, one type definition and its
  approval, all inside the session; until the amendment lands, the
  tool skill at the load point is a standing `unrecognized`
  escalation on every run. Forecloses: `--help` as the source of any
  skill; a description that depends on anything but the tool's answer
  — the initiative's second no-go.
- The measure's target of 1 is met as a hypothesis until the proof's
  last part runs: for the delivering agent and the PO role, "usable
  through a skill" is a usability claim, and the corpus's admissible
  evidence is measured task completion — a fresh-context agent with
  the skill as its only source, the lint's three uses completed and
  one failure read as the skill states it, recorded in the delivery.
  Cost: the initiative cannot close on the skill standing; the
  delivery says "hypothesis" until the run is recorded, and the
  second feature's authorization waits on that run, not on the skill.
- The initiative stays over the typedef's stated bound: for the cold
  reviewer and every later check, the initiative typedef says 500
  words, and the 20% variance lives in another initiative's history
  row and in these two records. Cost: until the cap's split has a
  record of its own, every initiative with two attachments repeats
  this margin, and each PM ruling on it cites a bet's history rather
  than the typedef.

## 4. Reversibility

Reversible by a cancellation, carried by a later product decision
record under the same `bet` right and linking this one. Before the
session is spent, the cost of reversal is that record. Before the
second feature starts, the cost is that record plus withdrawing the
standing direction, which the initiative's v2 row records. After the
session, it is sunk, and undoing what it built is the architecture
decision's own reversal (adr-2026-09-07-tool-answer §4): low while
only the lead shop's tools answer the flag; hard once a Bounded
Context shop's tool answers it and a skill is produced from that
answer, since the flag and shape are then a contract two shops build
to. Review triggers: the proof fails — the fresh-context agent cannot
complete the lint's uses from the skill alone, or a failure it meets
is one the skill does not name — so the direction's condition is
unmet, the second feature does not start, and the initiative returns
to the authority; the appetite is exhausted with the load-point check
still naming the tool skill `unrecognized`; the appetite is exhausted
without the run recorded; the authority ruling that a bet taken on
its standing direction, with the designer's D1 held, was one it would
not have taken in person; the cap's split getting its record and
moving the attachments out of the initiative; or any trigger the
architecture decision names for itself, since this bet spends its
consequences.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Made by the PO role for the authority's go of 2026-09-07 on init-tool-skills — taken at the initiative-check decide step on the authority's standing direction ("If it passes then proceed to the rest without asking me", initiative v2) after the one screen and the one revise, the lead-pm recording it (initiative v8) — from the maker's text `basis/guidelines/product-decision-record.md` (v7; `generated: true`, produced by `basis/tools/compile_typedef.py` from `basis/artifacts/product-decision-record.md`, source-digest `sha256:d2e74320dabb`), layered on `basis/guidelines/base-writing-style.md` (v2). Before any check ran, the author applied the checker's text `basis/fitness/product-decision-record.fitness.md` (produced from the same source, the same digest) to this draft, each scenario read as Given/When/Then: scenario 1 (one decision) pass — §1's first sentence is the one go; the standing direction is how the right was exercised, stated in §1's second paragraph and in Context, not a second decision; the architecture decision the bet rests on is linked, its own record; scenario 2 (the alternatives were real) pass — the hold, with its two grounds and the reason against each, and the no-go, with its reason, each a choice the authority could have made; scenario 3 (decider and right) pass — `decided-by: product-authority`, `right: bet`, and §1 naming both and the direction the right was exercised through; scenario 4 (consequences priced) pass — seven consequences, each with what changes, for whom, and its cost or what it forecloses; scenario 5 (reversibility) pass — §4 states the cost at three points (before the session, before the second feature, after the session), the threshold at which reversal turns hard, and six review triggers, the first being the direction's own condition. Status draft pending the PO output check (form only — the decider is the authority). |
