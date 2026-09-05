---
type: request
id: req-2026-09-05-banned-words-inlined
status: done
version: 6
date: 2026-09-05
reader: lead-pm
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
originator: product-authority
received-through: operational-contract
route: small-change
route-reason: "the compiler already inlines the guiding statement into every rendered step; inlining the banned list with its words is the same mechanism — a tool changed with the definition that names it, demonstrable by a re-render; the wider prompt assembly tooling is req-2026-09-05-step-communication's"
routed-to: requests/req-2026-09-05-banned-words-inlined.md#result
work-item: lead-6s02k
---

# Request: Banned words inlined in every prompt

## 1. What is requested

The product authority, 2026-09-05, in open conversation with the
lead-pm reviewing the init-request-routing run: "Banned words seems like a prompt quality issue. If it says don't use banned words, it should instead say don't use these banned words: \"word-list\". This will require prompt assembly tooling that we don't currently have but will need."

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract, which has no artifact
yet (lead-4kymc). The ask arose directly, in conversation.

## 3. Route

Route said by the lead-pm role, 2026-09-05: **the small-change lane**. Why: the compiler already inlines the guiding statement into every rendered step; inlining the banned list with its words is the same mechanism — a tool changed with the definition that names it, demonstrable by a re-render; the wider prompt assembly tooling is req-2026-09-05-step-communication's.
Topic: "Banned words inlined in every prompt (req-2026-09-05-banned-words-inlined)".

Originator's answer: **accepted** — "For 3. start the simple tasks",
2026-09-05 (brief-036 ask 3). Landed by the lead-pm; work item lead-6s02k
opened for the lane; it points here and carries nothing of what was
asked.

## 4. Result

### Definition

req-2026-09-05-banned-words-inlined — defined by the lead-po, 2026-09-05,
at the small-change lane's define step. Judged against the glossary's
simple change: the change stays within the lead shop's own definitions,
tools, and their renderings, touches no Bounded Context, and its effect
is demonstrable in the running system in one session by a re-render and
the lint — a simple change.

What will be different when the change is done. "The banned line" below
means the text `Do not use these words: ` followed by the entries of the
list `BANNED` in `basis/tools/lint_basis.py`, in the lint's order, joined
by a comma and a space. The words themselves are not written here: this
request is linted.

- **Given** the lint's list `BANNED` in `basis/tools/lint_basis.py`,
  **when** an approved process definition is rendered by
  `basis/tools/compile_process.py`, **then** every step the rendering
  says is run by an agent carries the banned line in its prompt; and
  **when** an approved role definition is rendered by
  `basis/tools/compile_role.py`, **then** the rendered agent file carries
  the banned line in its body.
- **Given** the two compilers, **then** neither holds a copy of the
  list: each obtains it from `basis/tools/lint_basis.py`'s `BANNED`, so
  that a change to the lint's list changes every rendering at the next
  re-render with no change to a compiler; the list's one home stays the
  lint, under the name `BANNED`.
- **Given** the process definitions `basis/processes/skill-rendering.md`
  and `basis/processes/role-rendering.md`, **then** each names in its
  Data, by path, the lint as the source the banned list is loaded from,
  with a Document History row citing this request by id and its version
  bumped; neither spells the words.
- **Given** the load points `.claude/skills/` and `.claude/agents/`
  after the rendering processes' reconcile, **then** every `SKILL.md`
  that has a step run by an agent carries the banned line at least once
  per such step, every agent file carries it, no rendering was edited by
  hand, and both rendering checks — skill-rendering's check step and
  `compile_role.py --check` — report nothing: a fresh render equals what
  stands.
- **Given** the whole tree, **then** the lint passes.

Paths — the whole of what the maker may change:

- `basis/tools/lint_basis.py` — read for the list; changed only so far as
  the compilers can read `BANNED` from it.
- `basis/tools/compile_process.py` — the process compiler; changed
  together with `basis/processes/skill-rendering.md`, which names it.
- `basis/tools/compile_role.py` — the role compiler; changed together
  with `basis/processes/role-rendering.md`, which names it.
- `basis/processes/skill-rendering.md` — process definition; Data.
- `basis/processes/role-rendering.md` — process definition; Data.
- Renderings at the skill load point, each sourced from the approved
  process definition under `basis/processes/` whose `carried-by` names
  it, tool `basis/tools/compile_process.py`, re-rendered by
  skill-rendering's reconcile, never by hand:
  `.claude/skills/adr-authoring/SKILL.md`,
  `.claude/skills/backlog-ordering/SKILL.md`,
  `.claude/skills/corpus-close-out/SKILL.md`,
  `.claude/skills/definition-chain-migration/SKILL.md`,
  `.claude/skills/discovery-conversation/SKILL.md`,
  `.claude/skills/feature-authoring/SKILL.md`,
  `.claude/skills/initiative-check/SKILL.md`,
  `.claude/skills/po-output-check/SKILL.md`,
  `.claude/skills/principle-set-authoring/SKILL.md`,
  `.claude/skills/product-flow/SKILL.md`,
  `.claude/skills/reconcile-and-close/SKILL.md`,
  `.claude/skills/request-intake/SKILL.md`,
  `.claude/skills/research-inquiry/SKILL.md`,
  `.claude/skills/review-conversation/SKILL.md`,
  `.claude/skills/role-rendering/SKILL.md`,
  `.claude/skills/scenario-assignment/SKILL.md`,
  `.claude/skills/session-handoff/SKILL.md`,
  `.claude/skills/skill-rendering/SKILL.md`,
  `.claude/skills/small-change/SKILL.md`,
  `.claude/skills/stakeholder-presentation/SKILL.md`,
  `.claude/skills/typedef-rendering/SKILL.md`,
  `.claude/skills/work-conversation/SKILL.md`.
- Renderings at the agent load point, each sourced from the approved
  role definition of the same name under `basis/roles/`, tool
  `basis/tools/compile_role.py`, re-rendered by role-rendering's
  reconcile, never by hand:
  `.claude/agents/cold-reviewer.md`,
  `.claude/agents/lead-pm.md`,
  `.claude/agents/lead-po.md`,
  `.claude/agents/lead-product-designer.md`,
  `.claude/agents/lead-solutions-architect.md`,
  `.claude/agents/researcher.md`.

Maker: lead-solutions-architect.

Verifying observation — one command from the repository root; exit 0
shows the effect, its output is the evidence:

```sh
python3 basis/tools/lint_basis.py && L="$(python3 -c 'import sys; sys.path.insert(0, "basis/tools"); import lint_basis; print(", ".join(lint_basis.BANNED))')" && echo "banned line: Do not use these words: $L" && for f in .claude/skills/*/SKILL.md; do n=$(grep -c '^Run by an agent in role' "$f"); [ "$n" -gt 0 ] || continue; [ "$(grep -cF "Do not use these words: $L" "$f")" -ge "$n" ] || { echo "banned line missing: $f"; exit 1; }; done && for f in .claude/agents/*.md; do grep -qF "Do not use these words: $L" "$f" || { echo "banned line missing: $f"; exit 1; }; done && echo "banned line present at both load points" && s=$(mktemp -d) && mkdir -p "$s/defs" && ln -s "$PWD/basis/types" "$s/types" && ln -s "$PWD/basis/artifacts" "$s/artifacts" && for d in $(grep -l '^status: approved' basis/processes/*.md); do n=$(sed -n 's/^carried-by: //p' "$d" | sed 's/-skill$//'); cp "$d" "$s/defs/"; python3 basis/tools/compile_process.py "$s/defs/$(basename "$d")" --skill "$s/$n/SKILL.md" >/dev/null && diff -q "$s/$n/SKILL.md" ".claude/skills/$n/SKILL.md" || { echo "diverged: $d"; rm -rf "$s"; exit 1; }; done && rm -rf "$s" && echo "skill-rendering check: nothing" && python3 basis/tools/compile_role.py --check .claude/agents --roles basis/roles --findings $(for d in basis/roles/*.md; do awk 'NR == 1 && !/^---$/ {exit 1} NR > 1 && /^---$/ {exit} NR > 1 && /^status: approved$/ {f = 1} END {exit !f}' "$d" && printf '%s\n' "$d"; done) && echo "role-rendering check: nothing"
```

### Change made

Round 1 — maker: lead-solutions-architect, 2026-09-05.

- `basis/tools/lint_basis.py` — unchanged: `BANNED` already stands at
  module level and the file imports without running its main, so the
  compilers read it as it is.
- `basis/tools/compile_process.py` — changed: imports `BANNED` from the
  lint beside it (its own directory put on `sys.path`, then
  `from lint_basis import BANNED`) and closes every agent-run step's
  prompt block with the banned line, after the prompt text; runtime and
  human-run steps get none. The tool carries no version field; before
  and after are the repository's two states of the file.
- `basis/tools/compile_role.py` — changed: the same import; the banned
  line closes every rendered agent body. No version field, as above.
- `basis/processes/skill-rendering.md` — version 6 → 7: a Data sentence
  names the lint at `basis/tools/lint_basis.py` as the one home the
  compiler loads the list from, under the name `BANNED`; history row
  citing this request.
- `basis/processes/role-rendering.md` — version 6 → 7: the same Data
  sentence for the rendered role's body; history row citing this request.
- Renderings: 22 skills, 6 agents re-rendered through the compilers,
  never by hand — every approved process definition under
  `basis/processes/` (the two definitions above at version 7) to
  `.claude/skills/<name>/SKILL.md`, every approved role definition under
  `basis/roles/` to `.claude/agents/<name>.md`. Each rendering carries
  its source's digest as its version: the two definitions' skills now
  carry the version-7 digests. One skill, `corpus-close-out`, has no
  agent-run step and its re-render is byte-equal to what stood.

The verifying observation, run as written: exit 0, its last lines
"banned line present at both load points", "skill-rendering check:
nothing", "role-rendering check: nothing". The lint: PASS, 0 violations.

### Check

**Round 1** — verdict: **pass** — by the lead-pm role, 2026-09-05, at
the small-change process's check step; the maker was the
lead-solutions-architect role. Each statement decided against the
changed artifacts: every rendered agent-run step and every rendered
agent file carries the line with the words themselves; the compilers
hold no copy and read the lint's list, its one home; the two
rendering definitions say so with history rows citing this request and
versions bumped; both load points carry the line after the re-render
and both rendering checks report nothing; the lint passes. Every path
in Change made is in the Definition's list. Noted, not a finding: the
lint's list holds stems (ratif), so the prompts carry stems; readable
forms are a change to the list, the owner's. Finding: none.

### Verified result

The verifying observation the Definition named was run by the runtime
from the repository root on 2026-09-05; its evidence:

```
PASS: 0 violation(s)
banned line: Do not use these words: ratif, disposition, rebaseline bill, surface, seat
banned line present at both load points
skill-rendering check: nothing
role-rendering check: nothing
exit 0
```

Recorded by the lead-pm role, 2026-09-05. The Definition, the Check's
verdict by the lead-pm role, and this result stand; between the
request and this result no bet was taken and no check of record was
run. The effect in the running system: every skill and role the
harness loads now tells the agent the words not to use.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded by the lead-pm at the request-intake process's record step; the originator's "record the other requests" confirmed the reading of these words as asks. Route decided and said at decide-route; awaiting the originator's answer. |
| 2 | 2026-09-05 | update | The route accepted by the originator (brief-036 ask 3); landed at the intake's land step; work item lead-6s02k opened; dispatched to the small-change lane. |
| 3 | 2026-09-05 | update | Definition written by the lead-po at the small-change lane's define step: judged a simple change by the glossary's entry; acceptance statements, paths (three tools, two process definitions, the 22 skill and 6 agent renderings with source and tool), maker lead-solutions-architect, and the verifying observation recorded under Result. |
| 4 | 2026-09-05 | update | Change made by the lead-solutions-architect at the small-change lane's make step, round 1: both compilers load `BANNED` from the lint and inline the banned line; skill-rendering and role-rendering at version 7 name the lint in Data; 22 skills and 6 agents re-rendered; the observation exits 0 and the lint passes. |
| 5 | 2026-09-05 | update | Check passed (round 1) by the lead-pm role; the verifying observation run by the runtime, exit 0; the verified result recorded and status set to done at the small-change process's record step. |
| 6 | 2026-09-05 | update | Where the route led written into routed-to by the lead-pm at the request-intake process's land-result step; the lane's work item lead-6s02k closed as done. |
