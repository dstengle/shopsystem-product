---
type: quality-guideline
id: base-writing-style
owner: product-authority
status: approved
approved: 2026-08-19
version: 5
created: 2026-08-14
updated: 2026-09-09
---

# Base writing style

Rules for everything written for a human reader. A document type's
format sits on top; it never overrides these rules.

## Say what, not why

State the point first, then what supports it — document, section, and
paragraph each open with their point. No reasoning, options, or
self-argument in an artifact's body; put that in the Document History
row. Do not explain what the reader can already see.

## Sentences and words

- Short sentences, one idea each.
- Active voice, a named actor: "Reviewers delete unlinked checks," not
  "Unlinked checks are subject to deletion."
- Plain, common words: "use" not "utilize."
- No metaphor as a technical term — say the literal thing.
- Explain an insider reference in one plain sentence, or cut it.
- When work is waiting, say what it is waiting on and on whom, in
  plain words; never use a shorthand for the state of the work in its
  place.
- Never use a banned word; the lint holds the list.

## History rows

One sentence: what changed, under what.

## Word targets

| Kind | Words |
|---|---|
| Role prompt (rendered) | 400 |
| Feature | 1,000 |
| Document History row (feature) | 25 |
| Contributors passage (feature) | 70 |
| Edges row (feature) | 20 |
| Initiative | 400 |
| Process definition | 800 |
| Guidance record | 600 |
| Decision record | 500 |

## Status

Tested on real runs before stable: word counts recorded against these
targets.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-14 | update | Authored (seed layer); earlier history, if any, in the repository history. |
| 1 | 2026-08-19 | state | draft → approved. |
| 2 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |
| 3 | 2026-09-08 | update | Rewritten to its own rule under feat-plain-voice: short sentences, plain words, say what not why, word targets by kind, tested on real runs before stable. |
| 4 | 2026-09-09 | update | One rule added under req-2026-09-06-plain-status: when work is waiting, say what it is waiting on and on whom, in plain words, never a shorthand for the state of the work; no existing rule changed. |
| 5 | 2026-09-09 | update | Three word targets added, citing feat-plain-voice-sections' hashes @hash:89e4c7718ea0/b87a61e043b1/4d7011c002b3: Document History row 25w, Contributors 70w, Edges row 20w — 7x25+70+10x20+537=982, under 1,000. |
