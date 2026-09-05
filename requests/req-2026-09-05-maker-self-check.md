---
type: request
id: req-2026-09-05-maker-self-check
status: done
version: 7
date: 2026-09-05
reader: lead-pm
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: "one sentence added to the define-good-up-front principle — the maker evaluates its output against the definition before submitting — made through principle-set-authoring, the principle set's own producing process; the step-level sweep that gives every maker the tests to run is init-typedef-rendering's rendering"
routed-to: requests/req-2026-09-05-maker-self-check.md#result
work-item: lead-5fk6d
---

# Request: Implementers run their own checks before submitting

## 1. What is requested

The product authority, 2026-09-05, in open conversation with the
lead-pm reviewing the init-request-routing run: "I definitely agree with implementers running their own checks." And earlier: "Reviews were always meant to be a safety check and define good up front is supposed to help implementation quality, not just shift the quality responsibility to checks."

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose directly, in conversation.

## 3. Route

Route said by the lead-pm role, 2026-09-05: **the small-change lane**. Why: one sentence added to the define-good-up-front principle — the maker evaluates its output against the definition before submitting — made through principle-set-authoring, the principle set's own producing process; the step-level sweep that gives every maker the tests to run is init-typedef-rendering's rendering.
Topic: "Implementers run their own checks before submitting (req-2026-09-05-maker-self-check)".

Originator's answer: **accepted** — "For 3. start the simple tasks",
2026-09-05 (brief-036 ask 3). Landed by the lead-pm; work item lead-5fk6d
opened for the lane; it points here and carries nothing of what was
asked.

## 4. Result

### Definition

req-2026-09-05-maker-self-check — defined by the lead-po role, 2026-09-05,
at the small-change lane's define step. Judged a simple change by the
glossary's entry: it stays within the lead shop's own definitions (one
principle set and its rendering), touches no Bounded Context, and its
effect is demonstrable in the running system in one session.

**What will be different.** The working principle set gains one
statement under the principle `define-good-up-front`, and the
principles page every session loads carries it.

The statement, as it will read in the set:

> The maker of an activity's output MUST evaluate that output against
> the definition of good before submitting it to the check, and record
> that it did.

Acceptance statements — a checker decides each against the changed
artifacts:

1. **Given** the working principle set at `basis/principles.md`,
   **when** the change is done, **then** the principle
   `define-good-up-front` carries the statement above as one of its
   statements, beside the three it has, none of which is changed or
   removed; and no other principle in the set is changed.
2. **Given** that principle set, **when** the change is done, **then**
   its Document History has a new row, its version bumped, citing this
   request by id (`req-2026-09-05-maker-self-check`) and recording that
   the amendment was made through principle-set-authoring — the set's
   own producing process, now one screen, one revise, the owner's
   approval — with the one screen it ran recorded, and the owner's
   approval standing on the product authority's ruling of 2026-09-05
   accepting this request.
3. **Given** the compiled principles page at `.claude/shop/principles.md`,
   **when** the change is done, **then** it is byte-for-byte a fresh
   render of `basis/principles.md` by `basis/tools/compile_principles.py`,
   and within its `define-good-up-front` entry it carries the new
   statement; it was not edited by hand.
4. **Given** the basis tree, **when** the change is done, **then** the
   lint passes.

**Artifacts the change touches (paths):**

- `basis/principles.md` — the working principle set; the source.
- `.claude/shop/principles.md` — a rendering: source
  `basis/principles.md`, tool `basis/tools/compile_principles.py`
  (invoked as `python3 basis/tools/compile_principles.py <source> <out>`);
  re-rendered, never hand-edited.

**Maker:** lead-solutions-architect — the role the make step runs by.
It makes the amendment through principle-set-authoring's author step,
records the one screen that process runs, and re-renders the page.

**Verifying observation** — one command, run from the repository root;
exit 0 shows the effect in the running system and its output is the
evidence:

```
python3 basis/tools/lint_basis.py && grep -Fq 'MUST evaluate that output against the definition of good before submitting it to the check' basis/principles.md && grep -Fq 'req-2026-09-05-maker-self-check' basis/principles.md && awk '/^- \*\*Define what good looks like up front\*\*/{f=1;next} /^- \*\*/{f=0} f' .claude/shop/principles.md | grep -Fq 'MUST evaluate that output against the definition of good before submitting it to the check' && t=$(mktemp) && python3 basis/tools/compile_principles.py basis/principles.md "$t" && diff "$t" .claude/shop/principles.md && echo 'principles: statement present under define-good-up-front, history cites request, rendering fresh, lint clean'
```

What the command decides, in order: the lint passes; the source carries
the new MUST statement; the source's history cites this request; the
rendering carries the statement inside its `define-good-up-front` entry;
a fresh render of the source equals the committed rendering (diff
empty). Any failing part exits nonzero.

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-05, at the
small-change lane's make step.

Paths changed this round:

- `basis/principles.md` — version 7 → 8. The statement the Definition
  fixes added as the fourth statement of `define-good-up-front`, its
  three existing statements, every other principle, and the fitness
  screen unchanged; `updated` set to 2026-09-05; one Document History
  row citing this request, recording the make through
  principle-set-authoring's draft step, the author's self-check against
  the fitness screen, that the process's one screen is the lead-pm's to
  run at the lane's check step and record there, and the owner's
  approval standing on the product authority's ruling of 2026-09-05.
- `.claude/shop/principles.md` — source-digest sha256:db2146e7321d →
  sha256:c77df1cce9ee (the rendering carries no version of its own).
  Re-rendered by `python3 basis/tools/compile_principles.py
  basis/principles.md .claude/shop/principles.md`; not edited by hand.

Nothing outside paths changed. The verifying observation was run by the
maker from the repository root after the change and the lint run alone;
their results are the lane's to record at verify.

**Round 2** (repair) — maker: the lead-solutions-architect role,
2026-09-05. The one screen principle-set-authoring allows ran at the
lane's check step (judge claude-fable-5-1, screen prompt v6): one
confident finding, two wobbly, one cosmetic.

Paths changed this round:

- `basis/principles.md` — version 8 → 9. The fourth statement split into
  two bullets, one obligation each: "Whoever makes an activity's output
  MUST evaluate that output against the definition of good before
  submitting it to the check." and "That evaluation MUST be recorded
  with the output — in its Document History or the step's own output."
  (repairs the confident finding and both wobbly ones — "maker" replaced
  by the set's actor vocabulary, the record's home named). The fitness
  screen's Spool cell for define-good-up-front reworded: "yes: rejects
  checks held by the maker alone, and submission without the maker's own
  evaluation" (the cosmetic finding). The first new bullet wraps as
  tightly as the observation's grep phrase allows, that phrase on one
  source line. History row recording the screen's findings, the repairs,
  and the owner's approval on the authority's ruling.
- `.claude/shop/principles.md` — source-digest sha256:c77df1cce9ee →
  sha256:87b81b1e3a36. Re-rendered by the tool; not edited by hand.

Nothing outside paths changed.

### Check

**Round 1** — verdict: **fail** — by the lead-pm role, 2026-09-05: the
principle set's own producing process, principle-set-authoring, ran its
one screen at this step (judge claude-fable-5-1 / screen prompt v6):
one confident finding in the amendment — the new bullet carried two
obligations — and two wobbly ("maker" outside the set's vocabulary;
the record's home unnamed; the fitness-screen cell reading against the
new statement). Finding returned to the maker for the one repair.

**Round 2** — verdict: **pass** — by the lead-pm role, 2026-09-05. The
amendment stands as two bullets, one obligation each, in the set's own
actor vocabulary, the record's home named; the screen cell reconciled;
the set at v9 with its history row citing this request and the owner's
approval standing on the authority's ruling; the rendering produced by
the compiler. Every path in Change made is in the Definition's list.
Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-05; its evidence:

```
PASS: 0 violation(s)
/tmp/tmp.kN3QuBrAx8: rendered 9 principles (digest 87b81b1e3a36)
principles: statement present under define-good-up-front, history cites request, rendering fresh, lint clean
exit 0
```

Recorded by the lead-pm role, 2026-09-05. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the
request and this result no bet was taken and no check of record was
run. The effect in the running system: the principles page compiled
into every session now requires whoever makes an output to evaluate
it against the definition of good before the check, and to record it.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded by the lead-pm at the request-intake process's record step; the originator's "record the other requests" confirmed the reading of these words as asks. Route decided and said at decide-route; awaiting the originator's answer. |
| 2 | 2026-09-05 | update | The route accepted by the originator (brief-036 ask 3); landed at the intake's land step; work item lead-5fk6d opened; dispatched to the small-change lane. |
| 3 | 2026-09-05 | update | Definition written by the lead-po role at the small-change lane's define step: judged a simple change by the glossary's entry; four acceptance statements, two paths (the principle set and its rendering with source and tool), maker lead-solutions-architect, one verifying command. No artifact but this request touched. |
| 4 | 2026-09-05 | update | Change made by the lead-solutions-architect role at the small-change lane's make step, round 1: `basis/principles.md` v7 → v8 amended through principle-set-authoring's draft step; `.claude/shop/principles.md` re-rendered by the tool. Entry written under Change made. |
| 5 | 2026-09-05 | update | Round 2 (repair) made by the lead-solutions-architect role at the small-change lane's make step on the check step's screen findings: `basis/principles.md` v8 → v9 (fourth statement split in two, actor vocabulary and record's home fixed, Spool screen cell reworded); `.claude/shop/principles.md` re-rendered. Entry written under Change made. |
| 6 | 2026-09-05 | update | Check: round 1 fail on the one screen (the bullet's two obligations), round 2 pass by the lead-pm role; the verifying observation run by the runtime, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 7 | 2026-09-05 | update | Where the route led written into routed-to by the lead-pm at the request-intake process's land-result step; the lane's work item lead-5fk6d closed as done. |
