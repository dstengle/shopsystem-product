---
type: request
id: req-2026-09-06-tools-through-skills
status: done
version: 7
date: 2026-09-06
reader: lead-pm
owner: lead-pm
created: 2026-09-06
updated: 2026-09-06
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: "one principle added to the working principle set, made through principle-set-authoring, its one screen and the owner's approval standing on the authority's direction; within the lead shop's own definitions, demonstrable on the compiled principles page in one session, no appetite worth a bet"
routed-to: requests/req-2026-09-06-tools-through-skills.md#result
work-item: lead-xsbuk
---

# Request: framework tools are used through skills

## 1. What is requested

The product authority, 2026-09-06, in open conversation with the
lead-pm on seeing the PO role read a tool's usage: "All custom tools
must be wrapped in skills that allow the tool to be used for a given
scenario without analysing usage. Is this already a principle or does
it need to be? The principle should be something to the effect that
all framework tools should be self-describing in a way that is
compatible with agent skills and not require analyzing help output.
The corollary would be that an agent should always prefer to use a
skill over a bare bash tool." And, on the lead-pm's answer that no
principle states it: "record it".

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose directly, in conversation.

## 3. Route

Route said by the lead-pm role, 2026-09-06: **the small-change lane**.
What it means: the lead-po role defines the change, the architect
makes it through the principle set's own producing process
(principle-set-authoring: one screen, one revise, the owner's
approval), the lead-pm checks it, the runtime verifies it on the
compiled principles page every session loads. Why: one principle added
to the working principle set — every framework tool usable through a
skill that states its use for a scenario without reading its help; an
agent prefers that skill over a bare invocation; a tool with no such
skill is a gap the shop records — within the lead shop's own
definitions, demonstrable in one session, spending no appetite worth a
bet. Topic: "framework tools are used through skills
(req-2026-09-06-tools-through-skills)".

Originator's answer: **accepted** — "record tools-through-skills",
2026-09-06, read by the lead-pm as the answer to the route said (the
request itself was already recorded); disclosed here. Landed; work
item lead-xsbuk opened for the lane; it points here and carries nothing
of what was asked.

## 4. Result

### Definition

req-2026-09-06-tools-through-skills — defined by the lead-po role,
2026-09-06, at the small-change lane's define step. Judged a simple
change by the glossary's entry: it stays within the lead shop's own
definitions (one principle set and its rendering), touches no Bounded
Context, and its effect is demonstrable in the running system in one
session.

**What will be different.** The working principle set gains one
principle, and the principles page every session loads carries it.

The principle, as it will read in the set — name **Use tools through
skills**, slug `tools-through-skills`, three statements:

> Every framework tool MUST be usable through a skill that states, for
> a scenario, what it does, what it takes, what it returns, and how it
> fails, so that an agent uses it without reading its help.
>
> An agent MUST prefer that skill over a bare invocation of the tool.
>
> A tool with no such skill MUST be recorded as a gap, not worked
> around.

The rationale, implications, and fitness-screen row the set requires of
each principle are the maker's to write, in the set's own form; the
statements above are what the set must say.

Acceptance statements — a checker decides each against the changed
artifacts:

1. **Given** the working principle set at `basis/principles.md`,
   **when** the change is done, **then** it carries the principle
   `tools-through-skills` with the three statements above as its
   statements, each a separate bullet carrying one obligation; and no
   existing principle in the set is changed or removed.
2. **Given** that principle set, **when** the change is done, **then**
   its Document History has a new row, its version bumped, citing this
   request by id (`req-2026-09-06-tools-through-skills`) and recording
   that the amendment was made through principle-set-authoring — the
   set's own producing process, one screen, one revise, the owner's
   approval — with the one screen it ran recorded, and the owner's
   approval standing on the product authority's acceptance of
   2026-09-06 recorded in section 3.
3. **Given** the compiled principles page at `.claude/shop/principles.md`,
   **when** the change is done, **then** it is byte-for-byte a fresh
   render of `basis/principles.md` by `basis/tools/compile_principles.py`,
   and within its `tools-through-skills` entry it carries the three
   statements; it was not edited by hand.
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
python3 basis/tools/lint_basis.py && grep -Fq 'without reading its help' basis/principles.md && grep -Fq 'over a bare invocation' basis/principles.md && grep -Fq 'recorded as a gap' basis/principles.md && grep -Fq 'req-2026-09-06-tools-through-skills' basis/principles.md && awk '/^- \*\*Use tools through skills\*\*/{f=1;next} /^- \*\*/{f=0} f' .claude/shop/principles.md | grep -Fq 'without reading its help' && t=$(mktemp) && python3 basis/tools/compile_principles.py basis/principles.md "$t" && diff "$t" .claude/shop/principles.md && echo 'principles: tools-through-skills present with its three statements, history cites request, rendering fresh, lint clean'
```

What the command decides, in order: the lint passes; the source carries
each of the three new MUST statements (one phrase from each, chosen
short enough to sit on one wrapped line); the source's history cites
this request; the rendering carries the first statement inside its
`tools-through-skills` entry; a fresh render of the source equals the
committed rendering (diff empty). Any failing part exits nonzero.

### Change made

**Round 1** — maker: the lead-solutions-architect role, 2026-09-06, at the
small-change lane's make step.

Paths changed this round:

- `basis/principles.md` — version 9 → 10. The set gains a tenth
  principle, `tools-through-skills`, in the set's four-part form: the
  three statements the Definition fixes, one obligation per bullet,
  each wrapped so its verifying phrase sits on one source line; a
  rationale showing the generic failure (a tool's use reconstructed
  from help output differently by every agent that meets it; a missing
  skill worked around and reconstructed again), supported by Norman,
  *The Design of Everyday Things*; four implications, each on a named
  actor (tool owners, process authors, whoever meets a tool with no
  skill, reviewers), each following from a statement bullet; a
  `tools-through-skills` column in the fitness screen, every row
  filled. Every existing principle and every existing screen cell
  unchanged; `updated` set to 2026-09-06; one Document History row
  citing this request, recording the make through
  principle-set-authoring's draft step, the author's self-check against
  the set's opening tests, that the process's one screen is the
  lead-pm's to run at the lane's check step and record there, and the
  owner's approval standing on the product authority's acceptance of
  2026-09-06 in section 3.
- `.claude/shop/principles.md` — source-digest sha256:87b81b1e3a36 →
  sha256:96ae4155dc8e (the rendering carries no version of its own).
  Re-rendered by `python3 basis/tools/compile_principles.py
  basis/principles.md .claude/shop/principles.md`; not edited by hand.

Nothing outside paths changed by the maker. Disclosed: while this
round ran, a commit of other work by the lead-pm's session (`3b50b9b`)
swept both changed paths into HEAD before this entry was written; the
committed content is byte-for-byte the maker's, as `git diff HEAD` on
both paths shows empty.

Disclosed for the check step's screen: the terms "framework tool",
"skill", "agent", and "gap" have no glossary entry ("skill" is named
only inside the glossary's rendering entry); the glossary lies outside
the lane's paths, so principle-set-authoring's term-to-glossary rule
could not be met in this round. The statements are the Definition's
and were not altered.

The verifying observation was run by the maker from the repository root
after the change: exit 0, last line "principles: tools-through-skills
present with its three statements, history cites request, rendering
fresh, lint clean". The lint run alone: "PASS: 0 violation(s)". Their
results are the lane's to record at verify.

**Round 2** (repair) — maker: the lead-solutions-architect role,
2026-09-06. The one screen principle-set-authoring allows ran at the
lane's check step (judge claude-fable-5-1, screen prompt v6): four
confident findings, three wobbly, the wobbly three ruled by the lead-pm.
At the check step the lead-pm widened the lane's paths to include
`basis/glossary.md`: use-defined-terms requires the binding terms
defined, and the glossary is their home.

Paths changed this round:

- `basis/glossary.md` — version 22 → 23. Three terms added at the end
  of Terms: **framework tool** (a tool the shop's definitions name for
  an activity: the compilers, the lint, the work register's command,
  and their like), **skill** (the rendering at the agent's load point
  that states an activity or a tool's use so an agent performs it from
  the definition alone), **gap** (a missing definition, tool, or skill
  the shop records as a request rather than works around). History row
  citing this request. The set's opening claim that its terms are
  defined in the glossary now holds for the new principle.
- `basis/principles.md` — version 10 → 11. Statement bullet 1: "for a
  scenario" → "for each use it supports". Statement bullet 3 split, one
  obligation each: "A tool with no such skill MUST be recorded as a
  gap." / "A tool with no such skill MUST NOT be worked around."
  Implication bullet 2's second clause became the permission that
  follows — "a step with no agent may carry the bare command" — the
  step-kind terms dropped. Implication bullet 3 split in two, one per
  statement bullet: records the gap as a request through intake; does
  not read the tool's help to proceed. governed-context's "Tool owners
  ship each tool's skill with the tool, in lockstep" moved under
  `tools-through-skills` as its first implication, so the obligation
  has one home; governed-context otherwise unchanged. The
  `tools-through-skills` screen column re-run against the repaired text:
  every cell holds; the Spool cell now names the three rejections.
  The three verifying phrases each still sit on one source line.
  History row 11: the screen's findings in short, the repairs, the
  owner's approval on the authority's acceptance of 2026-09-06.
- `.claude/shop/principles.md` — source-digest sha256:96ae4155dc8e →
  sha256:3c4576a133a4. Re-rendered by the tool; not edited by hand.

Nothing outside the widened paths changed. The verifying observation was
run by the maker from the repository root after the repair: exit 0,
last line "principles: tools-through-skills present with its three
statements, history cites request, rendering fresh, lint clean" — the
Definition's phrase "three statements" now names the three the
Definition fixed, carried as four bullets after the split. The lint run
alone: "PASS: 0 violation(s)".

### Check

**Round 1** — verdict: **fail** — by the lead-pm role, 2026-09-06: the
principle set's own producing process, principle-set-authoring, ran its
one screen at this step (judge claude-fable-5-1 / screen prompt v6):
four confident findings in the amendment — two binding terms
undefined; a bullet with two obligations; an implication with two
changes; a screen cell not reproducible — and three wobbly. Returned to
the maker for the one repair; the lead-pm widened the lane's paths to
the glossary, the home of the binding terms, and recorded it.

**Round 2** — verdict: **pass** — by the lead-pm role, 2026-09-06. The
terms defined in the glossary; the statement and implication bullets
one obligation each; the ship-with-the-tool obligation given one home;
the screen column re-run; the set at v11 with its history row and the
owner's approval standing on the authority's acceptance; the rendering
produced by the compiler. Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-06; its evidence:

```
PASS: 0 violation(s)
/tmp/tmp.PPPmWUq8eD: rendered 10 principles (digest 3c4576a133a4)
principles: tools-through-skills present with its three statements, history cites request, rendering fresh, lint clean
exit 0
```

Recorded by the lead-pm role, 2026-09-06. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the
request and this result no bet was taken and no check of record was
run. The effect in the running system: the principles page compiled
into every session now requires every framework tool to be usable
through a skill, an agent to prefer the skill, and a missing skill to
be recorded as a gap.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Recorded by the lead-pm at the request-intake process's record step; the originator's "record it" confirmed the reading of the words as an ask. Route decided and said at decide-route; awaiting the originator's answer. Evidence at recording: the PO read three tools' argument handling to write verification commands this week; the intake process's scripts carry bare commands with their flags; the lead-pm ran the rendering checks by copying shell from a skill. |
| 2 | 2026-09-06 | update | The route accepted by the originator's "record tools-through-skills", read as the answer and disclosed; landed; work item lead-xsbuk opened; dispatched to the small-change lane. |
| 3 | 2026-09-06 | update | Definition written by the lead-po role at the small-change lane's define step: judged a simple change by the glossary's entry; the principle named (`tools-through-skills`) and its three statements fixed; four acceptance statements, two paths (the principle set and its rendering with source and tool), maker lead-solutions-architect, one verifying command in the form req-2026-09-05-maker-self-check's Definition used. No artifact but this request touched. |
| 4 | 2026-09-06 | update | Change made by the lead-solutions-architect role at the small-change lane's make step, round 1: `basis/principles.md` v9 → v10 amended through principle-set-authoring's draft step (the principle `tools-through-skills` added with its rationale, implications, and screen column); `.claude/shop/principles.md` re-rendered by the tool. Entry written under Change made, disclosing the undefined terms for the screen and the sweep of both paths into HEAD by another commit. |
| 5 | 2026-09-06 | update | Round 2 (repair) made by the lead-solutions-architect role at the small-change lane's make step on the check step's screen findings: `basis/glossary.md` v22 → v23 (framework tool, skill, gap defined — the lead-pm widened paths to the glossary at the check step); `basis/principles.md` v10 → v11 (bullet 1 reworded, bullet 3 split, implications 2 and 3 repaired, the lockstep implication moved from governed-context, screen column re-run); `.claude/shop/principles.md` re-rendered. Entry written under Change made. |
| 6 | 2026-09-06 | update | Check: round 1 fail on the one screen, round 2 pass by the lead-pm role; the verifying observation run by the runtime, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 7 | 2026-09-06 | update | Where the route led written into routed-to by the lead-pm at the request-intake process's land-result step; the lane's work item lead-xsbuk closed as done. |
