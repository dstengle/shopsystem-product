# Process-definition pilot — the stakeholder-presentation process

**Superseded by the full basis experiment on branch `experiment/new-basis`
(`basis/` — one slice per foundational format; this pilot's content became
`basis/processes/stakeholder-presentation.md`). Kept here as the original
single-slice draft; review happens on the branch.**

**Experiment, 2026-08-10, for authority review.** This is the first real
process written in the composed definition format, so the format can be
judged on an exemplar before anything rolls out. It sits in `drafts/`
(ungated); nothing here is ratified. Pilot subject: the
stakeholder-presentation process — chosen because it is the smallest real
multi-activity process in the shop, was adversarially calibrated three days
ago, and exercises every format feature: a loop, two roles, artifacts in and
out, derived checks, and a judged fitness set.

**Format provenance (the amalgam rule).** No single standard is adopted
wholesale. Each part is taken intact from a named source, and bespoke-ness
lives only in the composition: the header is ISO/IEC/IEEE 24774 (name,
purpose, observable outcomes); each activity is an ETVX cell (entry / tasks /
validation / exit); loop termination is an Essence-style reached-state
success exit plus a round-cap failsafe. The `annotations:` blocks are the one
extension: namespaced projection metadata (`runtime.*`) that translators
consume and definition semantics ignore.

---

## Process: Stakeholder presentation

**Purpose:** Turn source material into a presentation the product authority
can decide from in one short sitting, verified by an independent cold read
before delivery.

**Outcomes** (observable, per 24774):

- O1. A presentation exists whose decision layer is ≤ ~400 words and whose
  decision + support layers together are ≤ ~1,500 words.
- O2. Every ask in it carries a recommendation, inline evidence, and a
  default, and states whether it gates work or resolves on silence.
- O3. An independent cold read has returned clean, or flags only tradeoffs
  the author explicitly accepted.
- O4. The original material survives intact as a labeled, linked annex.

**Roles** (assignment overlay; one accountable seat):
author — lead-pm (Accountable); cold reviewer — fresh-context persona
subagent (Verifier; never the author).

**Artifacts:** in — source material, its named reader, the decisions it must
enable. out — the presentation; the annex; the round verdicts.

**Carried by:** `.claude/skills/stakeholder-presentation/SKILL.md` — a
*derived* projection of this definition (see Projections below), never the
source of truth.

## Activities

### A1 — Frame

- **Entry:** source material exists; its reader and the decision(s) it must
  enable are named.
- **Tasks:** enumerate the asks; scope them to the decision horizon (defer
  what does not gate the next unit of work); group and order by consequence;
  split the material if the budget cannot hold it.
- **Validation:** each planned ask names the decision it serves; ask count
  ≤ 7 after grouping.
- **Exit:** an ask list exists meeting the validation conditions.
- **Annotations:**
  `runtime.claude-code: {carrier: stakeholder-presentation SKILL.md §"Decision asks"}`
  `runtime.fabro: {model: e.g. high-reasoning tier; max_attempts: 2}`

### A2 — Compose

- **Entry:** A1 exit holds.
- **Tasks:** write decision + support layers fresh (never abridge by
  deletion); gloss every proper noun and coinage at first mention; attach
  every content block to an ask or label it informational; demote the
  original to a labeled annex.
- **Validation:** layer budgets met (O1); no unglossed coinages; no
  commitments outside asks.
- **Exit:** a complete presentation draft plus labeled annex exist.
- **Annotations:**
  `runtime.claude-code: {carrier: SKILL.md §"Structure", §"Style rules"}`
  `runtime.fabro: {model: e.g. high-reasoning tier}`

### A3 — Cold-read loop (loop: A3a → A3b, repeat)

- **A3a Review:** a fresh-context persona (never the author, no annex, no
  prior-round memory) reads the presentation alone and reports stumbles,
  unintroduced terms, per-ask decidability, overload verdict, top changes.
- **A3b Revise:** author repairs findings; consistency sweep (counts,
  cross-references, stated promises held against every later line).
- **Success exit (reached state):** a round returns clean or flags only
  author-accepted tradeoffs.
- **Failsafe exit (round cap):** 4 rounds without the success state —
  deliver to the stakeholder *with the open findings attached* rather than
  looping further. Both exit forms are legal per the format: reached-state
  is the success semantics; the cap bounds cost. A count-only exit is also
  legal where rounds *are* the semantics ("run three rounds").
- **Annotations:**
  `runtime.claude-code: {carrier: SKILL.md §"Verification"; reviewer: fresh subagent per round}`
  `runtime.fabro: {A3a: separate node + separate context from A3b; loop: cyclic edge, guard = success exit, counter = failsafe cap}`

### A4 — Deliver

- **Entry:** A3 exited (either exit).
- **Tasks:** deliver the presentation; record round verdicts; if failsafe
  exit, state the open findings up front.
- **Validation:** O1–O4 all hold.
- **Exit:** stakeholder has the presentation; process instance closed.

## Derived checks (full traceability table — seed-document rule)

| Outcome | Check | Kind |
|---|---|---|
| O1 | word counts measured against budgets | mechanical |
| O2 | each ask parsed for recommendation + evidence + default + gate/default marker | mechanical |
| O2 | ask decidability | judged (fitness set below) |
| O3 | round verdicts recorded; final round clean or tradeoffs marked accepted | mechanical presence + judged |
| O4 | annex exists, labeled, linked from the presentation | mechanical |

## Fitness set (judged by the cold reviewer — non-executable, no step definitions)

- Given the presentation and its annex, when the stakeholder reads only the
  presentation, then every requested decision can be made without opening
  the annex.
- Given the first paragraph alone, when the reader stops there, then it
  states the answer or recommendation, not background.
- Given any proper noun or coinage, when it first appears, then a gloss
  appears with it or the stakeholder demonstrably owns the term.
- Given each ask in isolation, when read, then it carries recommendation,
  evidence, and default, and the set states which asks gate work.

## Projections (the source-of-truth requirement)

This definition is the single source of truth; runnable surfaces are
compiled from it and conformance-checked against it.

**Claude Code projection (exists today):**
`stakeholder-presentation/SKILL.md` carries A1 as "Decision asks", A2 as
"Structure" + "Style rules" + "Reforming an existing document", A3 as
"Verification — independent cold read", and this fitness set verbatim.
Conformance note: the current skill is a faithful projection except that it
does not state A3's 4-round failsafe cap — one line to add if this pilot is
accepted.

**Fabro projection (sketch):** each activity compiles to a node; `Entry` →
node guard, `Validation` → node post-check, the A3 loop → a cyclic edge with
the success exit as guard and the cap as counter; `runtime.fabro.*`
annotations feed node configuration (model tier, max_attempts, context
separation between A3a and A3b). Nothing in the definition body needs to
change for this projection — the annotations carry everything
fabro-specific, which is the property the source-of-truth requirement
demands.

---

**Review asks for this pilot** (all default-free — it is an experiment):
does the composed format read as one format or as three standards stapled
together; are the annotation blocks the right shape for the fabro
requirement; is the dual-exit loop rule (reached-state success + cap
failsafe, count-only where rounds are the semantics) the rule you wanted;
and is the derived-carrier rule for process-shaped skills right — a skill
may guide a multi-activity process, but only as a projection of a definition
like this one.
