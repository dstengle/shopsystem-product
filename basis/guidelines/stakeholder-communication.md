# Guideline: stakeholder communication

**Format slice: quality guideline.** Anatomy per the Google/Microsoft
style-guide convergence: voice principle → condensed highlights (the
compiled-into-context layer) → rules with before/after pairs → precedence.
Every rule carries Deming's three elements — test procedure, criterion,
yes/no decision — and names its derived check (cite-or-delete). Example set:
five rules; a full guideline grows by the same shape.

**Voice principle.** Write for a reader with five minutes and full authority:
answer first, evidence inline, nothing that requires another document.

**Highlights (the layer compiled into generating context):** lead with the
answer · gloss every proper noun at first mention · every ask carries
recommendation + evidence + default · say what gates and what defaults ·
nothing committed outside an ask.

**Precedence:** this guideline < the artifact kind's schema < a ratified
principle. (Nearest-specific wins downward; principles win upward.)

---

## Rules

**1. Lead with the answer.**
Before: "This report surveys eleven standards traditions relevant to…"
After: "Adopt established forms for every element; nothing structural needs
inventing. Details follow."
*Test:* read the first paragraph only. *Criterion:* it states the
answer/recommendation. *Decision:* yes/no.
*Derived check:* judged — fitness scenario 2.

**2. Gloss every proper noun and coinage at first mention.**
Before: "adopt promptfoo (established)."
After: "adopt promptfoo, an open-source LLM-evaluation runner (established)."
*Test:* scan first mentions. *Criterion:* gloss present, or the reader
demonstrably owns the term. *Decision:* yes/no per term.
*Derived check:* mechanical heuristic (capitalized-term scan) + judged —
fitness scenario 3.

**3. State every ask in the four-part form.**
Before: "Should we use BCP 14 or ISO language? Both have merits."
After: "IETF or ISO keywords? Recommend IETF: lintable, native to our
tooling. Default: IETF."
*Test:* parse each ask. *Criterion:* question + recommendation + evidence +
default all present. *Decision:* yes/no per ask.
*Derived check:* mechanical parse — traceability row O2.

**4. Nothing committed outside an ask.**
Before: "…and you grade a sample of its verdicts on a standing loop." (in
prose, no ask)
After: mark it a drafting default inside the binding statement, or make it
an ask.
*Test:* list every commitment of time, tooling, or process. *Criterion:*
each sits in an ask or a named drafting default. *Decision:* yes/no per
commitment.
*Derived check:* judged — cold-reviewer smuggle hunt (role's accountability
list).

**5. Numbers over adjectives.**
Before: "the report is long." After: "the report is 939 lines."
*Test:* scan evaluative adjectives about measurable things. *Criterion:*
a number exists where one could. *Decision:* yes/no per instance.
*Derived check:* mechanical adjective-list lint (style-linter class, tool
chosen later).
