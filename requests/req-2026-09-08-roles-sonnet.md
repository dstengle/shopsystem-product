---
type: request
id: req-2026-09-08-roles-sonnet
status: done
version: 2
date: 2026-09-08
reader: lead-pm
owner: lead-pm
created: 2026-09-08
updated: 2026-09-08
originator: product-authority
received-through: operational-contract
arose-in: init-process-runner
route: small-change
route-reason: "one key's value on five role definitions and their renderings; within the lead shop's own definitions, demonstrable in one session"
routed-to: "requests/req-2026-09-08-roles-sonnet.md#result"
work-item: lead-0olfp
---

# Request: every role but the lead-pm and the router on sonnet

## 1. What is requested

The product authority, 2026-09-08: "Move everything but the lead-pm
and the router to sonnet and recompile the roles."

## 2. From whom

Reader: the lead-pm role. Originator: the product authority, directly.
Received through the lead shop's operational contract, which has no
artifact yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-08: **the small-change lane**.
Why: `model: sonnet` on lead-po, lead-solutions-architect,
lead-product-designer, cold-reviewer, and researcher; lead-pm stays on
fable and the router on haiku; renderings regenerated. Topic: "roles
to sonnet (req-2026-09-08-roles-sonnet)".

Originator's answer: **accepted** — the authority's own instruction.

## 4. Result

### Definition

req-2026-09-08-roles-sonnet: when done, the five roles named run on
the sonnet tier.

- Given the role definitions lead-po, lead-solutions-architect,
  lead-product-designer, cold-reviewer, and researcher, when read,
  then each carries `model: sonnet`.
- Given lead-pm and router, when read, then lead-pm carries
  `model: fable` and router `model: haiku`, unchanged.
- Given the renderings under .claude/agents/, when the role check
  runs, then every rendering is current with its source and reports
  no finding.

Artifacts touched: the five definitions under basis/roles/ and their
renderings under .claude/agents/ by basis/tools/compile_role.py.
Maker role: lead-solutions-architect. Verifying observation:
`python3 basis/tools/compile_role.py --check --findings`, exit 0.
Defined by the lead-pm role at the define step, the lead-po role's
step, on the authority's direct instruction — the instruction is the
definition.

### Change made

Round 1, maker: the lead-solutions-architect role. `model: fable` →
`model: sonnet` on five role definitions, each with one Document
History row citing this request; each rendering re-rendered by
`basis/tools/compile_role.py` (render use), never edited by hand;
lead-pm (fable) and router (haiku) untouched.

| Path | Before | After |
|---|---|---|
| basis/roles/lead-po.md | 15 | 16 |
| basis/roles/lead-solutions-architect.md | 12 | 13 |
| basis/roles/lead-product-designer.md | 4 | 5 |
| basis/roles/cold-reviewer.md | 6 | 7 |
| basis/roles/researcher.md | 6 | 7 |
| .claude/agents/lead-po.md | rendering | re-rendered (digest c1ca48ea377a) |
| .claude/agents/lead-solutions-architect.md | rendering | re-rendered (digest 1e47b6af287b) |
| .claude/agents/lead-product-designer.md | rendering | re-rendered (digest be2f7858fc5d) |
| .claude/agents/cold-reviewer.md | rendering | re-rendered (digest 7e5c562c0606) |
| .claude/agents/researcher.md | rendering | re-rendered (digest af2e87ce58d4) |

Maker's evaluation against the Definition: statement 1 holds — the
five definitions each read `model: sonnet`; statement 2 holds —
lead-pm reads `model: fable`, router `model: haiku`, neither file
changed; statement 3 holds — `python3 basis/tools/compile_role.py
--check --findings` printed no row and exited 0.

### Check

Round 1 — verdict: pass; checker: lead-pm, 2026-09-08. The five definitions and renderings read `model: sonnet`; lead-pm fable and router haiku untouched; the role check reports no finding.

### Verified result

Observation: `python3 basis/tools/compile_role.py --check --findings` — no finding, exit 0, 2026-09-08, by the lead-pm role. The Definition, the Check's verdict, and this result stand; no bet was taken and no check of record was run.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Recorded and defined by the lead-pm from the authority's instruction; route lane, accepted; work item lead-0olfp. |
| 2 | 2026-09-08 | update | Checked and verified by the lead-pm role: pass, round 1; status done; work item lead-0olfp closed. |
