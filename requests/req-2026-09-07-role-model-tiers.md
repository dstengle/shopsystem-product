---
type: request
id: req-2026-09-07-role-model-tiers
status: done
version: 4
date: 2026-09-07
reader: lead-pm
owner: lead-pm
created: 2026-09-07
updated: 2026-09-07
originator: product-authority
received-through: operational-contract
arose-in: init-process-runner
route: small-change
route-reason: "one frontmatter key on six role definitions and their renderings — each role names the model tier it runs on, so a role launched by the router runs on its own tier and not the router's; within the lead shop's own definitions, demonstrable in one session"
routed-to: "requests/req-2026-09-07-role-model-tiers.md#result"
work-item: lead-qdbqn
---

# Request: each role names its model tier

## 1. What is requested

The product authority, 2026-09-07, on brief-039: "keep defaults on
rulings, fix the role to model mappings." Ask 2's default, option (a):
each role definition names its tier — lead-pm, lead-po,
lead-solutions-architect, lead-product-designer, cold-reviewer, and
researcher on Fable, the tier they ran on before the router; the
router alone on haiku.

## 2. From whom

Reader: the lead-pm role. Originator: the product authority, ruling on
brief-039. Received through the lead shop's operational contract,
which has no artifact yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-07: **the small-change lane**.
Why: the role rendering already admits `model`; the change is that
key on six definitions, re-rendered. Topic: "role model tiers
(req-2026-09-07-role-model-tiers)".

Originator's answer: **accepted** — the authority's own ruling. Runs
now, by the lead-pm's hand as before, since the router's re-run waits
on it.

## 4. Result

### Definition

req-2026-09-07-role-model-tiers. Judged a simple change by the
glossary's entry: the key lands on the lead shop's own role
definitions and their renderings, touches no Bounded Context, and the
compiler's check shows the effect in one session.

**What will be different.**

- Given the six role definitions lead-pm, lead-po,
  lead-solutions-architect, lead-product-designer, cold-reviewer, and
  researcher, when a checker reads each one's frontmatter, then each
  carries a `model` key naming the Fable tier the role ran on before
  the router, and no definition among the six is without it.
- Given the router's definition, when a checker reads its
  frontmatter, then its `model` key names haiku, and no other role
  names that tier.
- Given the six renderings under `.claude/agents/`, when a checker
  compares each rendering's `model` against its source definition,
  then they agree, and the compiler's check reports the renderings
  current with their sources.
- Given a role among the six launched by the router, when a checker
  reads the rendering the harness loads for it, then the tier the
  rendering names is the role's own and not the router's.

**Artifacts touched.**

- `basis/roles/lead-pm.md`, `basis/roles/lead-po.md`,
  `basis/roles/lead-solutions-architect.md`,
  `basis/roles/lead-product-designer.md`,
  `basis/roles/cold-reviewer.md`, `basis/roles/researcher.md` — the
  sources; one history row each.
- `.claude/agents/lead-pm.md`, `.claude/agents/lead-po.md`,
  `.claude/agents/lead-solutions-architect.md`,
  `.claude/agents/lead-product-designer.md`,
  `.claude/agents/cold-reviewer.md`, `.claude/agents/researcher.md` —
  renderings of the sources above by `basis/tools/compile_role.py`;
  regenerated, not hand-edited.
- `basis/artifacts/role-definition.md` — only if the typedef does not
  already admit the `model` key; then the key stated there, with a
  history row.

**Maker role.** lead-solutions-architect.

**Verifying observation.** From the repository root:
`python3 basis/tools/compile_role.py --check --findings` — exit 0
shows every rendering current with a source that names its tier; the
output is the evidence.

Maker's self-check against this definition is recorded on the request
at the make step.

### Change made

**Round 1 — maker: lead-solutions-architect.** Paths changed, version
before → after:

- `basis/roles/lead-pm.md` 10 → 11; `basis/roles/lead-po.md` 14 → 15;
  `basis/roles/lead-solutions-architect.md` 11 → 12;
  `basis/roles/lead-product-designer.md` 3 → 4;
  `basis/roles/cold-reviewer.md` 5 → 6; `basis/roles/researcher.md`
  5 → 6 — each gains `model: fable` among the functional keys (after
  `tools`, the router's placement), `updated` set, one history row
  citing this request.
- `.claude/agents/{lead-pm,lead-po,lead-solutions-architect,lead-product-designer,cold-reviewer,researcher}.md`
  — re-rendered by `python3 basis/tools/compile_role.py <definition>
  --agent <out>` (renderings carry no version; digests e0883be435c2,
  ad10954e8392, 87d67af6e36b, f36394c6532f, 1ccacd7c8afc,
  a531dd945101).
- `basis/artifacts/role-definition.md` 4 → 5 — the conditional path
  taken: the typedef's Required frontmatter named only `name`,
  `description`, `tools`, `maxTurns` and the identity base, nowhere
  `model`; one sentence states the optional key, with a history row.
- `basis/roles/router.md` untouched: it already carries `model: haiku`
  at v4.

Maker's self-check against the Definition: statement 1 holds — all six
frontmatters carry `model: fable`, none without it (`grep '^model:'
basis/roles/*.md`); statement 2 holds — the router names haiku and no
other definition does; statement 3 holds — each rendering's `model`
equals its source's, and `python3 basis/tools/compile_role.py --check
--findings` exits 0 with no rows; statement 4 holds — the rendering
the harness loads for each of the six names `fable`, the role's own
tier, not the router's `haiku`. Nothing outside the listed paths was
touched; no rendering was hand-edited.

### Check

Round 1 — verdict: pass; checker: lead-pm, 2026-09-07. Each statement holds: the six definitions carry `model: fable`; the router alone `haiku`; every rendering's `model` equals its source's and the role check reports no finding; a role launched by the router loads a rendering naming its own tier. The typedef amendment stands: the typedef stated nothing on the key, and a role's tier is now readable from the definition, not the compiler.

### Verified result

Observation: `python3 basis/tools/compile_role.py --check --findings` — no finding, exit 0, 2026-09-07, by the lead-pm role. The Definition, the Check's verdict by the lead-pm role, and this result stand; between the request and this result no bet was taken and no check of record was run.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Recorded by the lead-pm from the authority's ruling on brief-039; route lane, accepted. |
| 2 | 2026-09-07 | update | Definition written by the lead-po at the small-change define step: judged simple by the glossary entry; four acceptance statements, thirteen paths (six sources, six renderings, the typedef conditionally), maker lead-solutions-architect, observation `python3 basis/tools/compile_role.py --check --findings`. No artifact but this request touched. |
| 3 | 2026-09-07 | update | Change made recorded by the lead-solutions-architect at the small-change make step, round 1: six role definitions given `model: fable` and bumped, six renderings regenerated by compile_role.py, the role-definition typedef 4 → 5 stating the optional key; self-check against the four acceptance statements recorded, compiler check exit 0. |
| 4 | 2026-09-07 | update | Checked and verified by the lead-pm role: pass, round 1; the observation exit 0. Status done; work item lead-qdbqn closed. |
