---
name: stakeholder-presentation
description: Reform any document or message aimed at the product authority (or another human stakeholder) into a decision-first presentation — answer first, layered depth, bounded length, asks that carry recommendations and defaults — then verify it with an independent cold read before delivery. Use BEFORE delivering any report, sitting material, or status update longer than ~300 words, and to reform an existing document that fails the accessibility bar.
---

# Stakeholder presentation (communication style guide skill)

**LOCAL skill** (provenance: lead-local, not canonical; candidate for promotion
to shopsystem-templates once proven). Directed by the product authority
2026-08-06: *"I expect a report to be a presentation, not a compiled list of
research results… make sure all communication and documents are as accessible
as possible."* Adopts established forms per
[`drafts/definition-format-research.md`](../../../drafts/definition-format-research.md):
Minto pyramid / SCQA, BLUF, government briefing-note asks, Amazon-memo annex
separation, Federal Plain Language rules. Calibrated 2026-08-06 by three
adversarial stakeholder-persona rounds; the rules below marked ◆ were earned
from failures those rounds caught.

## The one rule

**Lead with the answer.** The reader must get the most important thing even if
they stop after the first paragraph — and must be able to make every requested
decision without opening an annex **or the author's head**.

## Structure — three layers, strict

1. **Decision layer** (≤ 1 page, ~400 words): an SCQA opening — Situation,
   Complication, Question, Answer — in at most four sentences, then the
   recommendation(s) and the asks.
2. **Support layer** (with layer 1, ≤ ~1,500 words total): reasoning, options,
   tradeoffs. Tables for option comparisons; prose only for causal reasoning.
3. **Reference annex**: the full research or detail — separate file or clearly
   separated back-matter, linked, labeled optional. Never required for the
   decision.

If the material cannot fit the budget, the scope is too big: split by
decision, not by topic.

## Decision asks

- Each ask is four lines: **question → recommendation → one-line why →
  default if unanswered**. Never hand the stakeholder an open research
  question when a recommendation is possible; they accept or override.
- At most 7 asks; group related asks; order by consequence.
- ◆ **Scope asks to the decision horizon.** Ask only what gates the next unit
  of work. Tool adoptions and operational commitments are deferred to the
  sitting where that machinery is actually built. A deferral is a note, never
  an ask — "ratify my recommendation to defer" is a null decision.
- ◆ **Say which asks gate and which default.** State plainly which asks
  require an answer before work proceeds and which resolve by their default
  on silence — "all of these gate X" is false if defaults exist.
- ◆ **Every substantive content block attaches to an ask** or is explicitly
  labeled informational. The largest commitment in a document must never ride
  in on no decision. Block-ratification ("ratify this table; flag rows") is a
  legitimate ask, but it must state **what ratification binds** and what
  remains a drafting default revisable later.
- ◆ **No smuggled commitments.** Anything that costs the stakeholder ongoing
  time, adopts a tool, or fixes a process must appear inside an ask or be
  named a drafting default — never only in prose between asks.
- Asks carry their evidence inline ("operated sets run ~10: GOV.UK's eleven"),
  not by reference.

## Style rules

- ◆ **Standalone means proper nouns too.** Gloss every proper noun, tool
  name, standard, and coinage at first mention — one clause each. Never
  condition an ask on machinery the document does not explain. Terms the
  stakeholder demonstrably owns (their own product vocabulary) are exempt.
- World-standard vocabulary; headings state conclusions, not topics.
- One idea per sentence; no forward references — "see below" means
  restructure. No new coinages in the closing.
- Numbers over adjectives. State uncertainty once, precisely.
- ◆ **No process citations or revision deltas.** Do not cite the skill or
  method that produced the document; do not spend the reader's attention on
  differences from a draft they never saw.
- Illustrative examples are marked as such ("e.g.") — an unmarked example
  reads as a commitment.
- Chat replies follow the same rules: outcome first, no process narration.

## Reforming an existing document

1. Name the reader and the decision(s) the document must enable.
2. Write the decision and support layers fresh — re-present; never abridge by
   deletion.
3. Demote the original intact to reference annex, labeled as such at its top.
4. Run the verification protocol below.

## Verification — independent cold read (mandatory)

◆ **The author cannot cold-read their own text**: terms pass the author's eye
because the context lives in the author's head. Before delivery, a
fresh-context reviewer (subagent persona simulating the stakeholder: expert,
~5 minutes, has NOT read the annex, allergic to unintroduced terms) reads the
presentation alone and reports: stumbles in order, unintroduced terms,
per-ask decidability (confident / wobbly / cannot decide), overload verdict,
top 3 changes. Revise and repeat with a fresh reviewer until a round returns
clean or flags only accepted tradeoffs. A consistency sweep rides along:
counts and cross-references match; stated promises ("nothing commits you to
tooling") hold against every line that follows them.

## Fitness checks (judged by the cold reviewer, not executed — no step definitions)

- Given the presentation and its annex, when the stakeholder reads only
  layers 1–2, then every requested decision can be made without opening the
  annex.
- Given the first paragraph alone, when the reader stops there, then it
  states the answer or recommendation, not background.
- Given any section in layers 1–2, when asked "which ask does this serve?",
  then a specific ask can be named — otherwise the section belongs in the
  annex.
- Given any proper noun or coinage, when it first appears, then a gloss
  appears with it or the stakeholder demonstrably owns the term.
- Given each ask, when read in isolation, then it carries a recommendation,
  its evidence, and a default — and the set states which asks gate work and
  which resolve on silence.
- Given the word counts, when measured, then layer 1 ≤ ~400 words and layers
  1–2 together ≤ ~1,500.
