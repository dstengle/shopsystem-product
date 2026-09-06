---
type: request
id: req-2026-09-06-tools-through-skills
status: routed
version: 3
date: 2026-09-06
reader: lead-pm
owner: lead-pm
created: 2026-09-06
updated: 2026-09-06
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: "one principle added to the working principle set, made through principle-set-authoring, its one screen and the owner's approval standing on the authority's direction; within the lead shop's own definitions, demonstrable on the compiled principles page in one session, no appetite worth a bet"
routed-to: ""
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

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Recorded by the lead-pm at the request-intake process's record step; the originator's "record it" confirmed the reading of the words as an ask. Route decided and said at decide-route; awaiting the originator's answer. Evidence at recording: the PO read three tools' argument handling to write verification commands this week; the intake process's scripts carry bare commands with their flags; the lead-pm ran the rendering checks by copying shell from a skill. |
| 2 | 2026-09-06 | update | The route accepted by the originator's "record tools-through-skills", read as the answer and disclosed; landed; work item lead-xsbuk opened; dispatched to the small-change lane. |
| 3 | 2026-09-06 | update | Definition written by the lead-po role at the small-change lane's define step: judged a simple change by the glossary's entry; the principle named (`tools-through-skills`) and its three statements fixed; four acceptance statements, two paths (the principle set and its rendering with source and tool), maker lead-solutions-architect, one verifying command in the form req-2026-09-05-maker-self-check's Definition used. No artifact but this request touched. |
