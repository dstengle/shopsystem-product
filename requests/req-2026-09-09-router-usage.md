---
type: request
id: req-2026-09-09-router-usage
status: done
version: 2
date: 2026-09-09
reader: lead-pm
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
originator: product-authority
received-through: operational-contract
arose-in: init-run-measurement
route: small-change
route-reason: "one accountability on the router's definition and its rendering; within the lead shop's own definitions, demonstrable in one session"
routed-to: "requests/req-2026-09-09-router-usage.md#result"
work-item: lead-1pe9i
---

# Request: the router records usage on the bead

## 1. What is requested

From req-2026-09-08-initiative-cost-rollup: "the router records usage
per segment on every anchor." The rollup sums minutes only, because
the router on sonnet writes no usage comment; the one on haiku did.

## 2. From whom

Reader: the lead-pm role. Originator: the product authority. Received
through the lead shop's operational contract (lead-4kymc).

## 3. Route

The small-change lane. Accepted.

## 4. Result

### Definition

req-2026-09-09-router-usage: when done, every router turn ends by
writing the harness's usage for that turn on the bead.

- Given basis/roles/router.md, when read, then an accountability says
  the router writes, at the end of each of its turns, one comment on
  the bead: context tokens, output tokens, and model, as the harness
  reports them, blank where it does not.
- Given .claude/agents/router.md, when the role check runs, then the
  rendering is current and reports no finding.

Artifacts touched: basis/roles/router.md and its rendering by
basis/tools/compile_role.py. Maker role: lead-solutions-architect.
Verifying observation: `python3 basis/tools/compile_role.py --check --findings`,
exit 0. Defined by the lead-pm.

### Change made

Round 1, made by the lead-solutions-architect role: basis/roles/router.md
(version 9 → 10, an accountability line added for the per-turn usage
comment); .claude/agents/router.md re-rendered by
`basis/tools/compile_role.py` (digest unset → `c7d991fc0953`). The check
(`--check --findings`) exits 0.

### Check

Round 1 — pass; checker: lead-pm, 2026-09-09. The accountability stands in the definition; the rendering is current; the role check reports no finding.

### Verified result

Observation: `python3 basis/tools/compile_role.py --check --findings` — no finding, exit 0, 2026-09-09, by the lead-pm role. No bet taken, no check of record run.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded and defined by the lead-pm; route lane, accepted; work item lead-1pe9i. |
| 2 | 2026-09-09 | update | Checked and verified by the lead-pm; done; work item lead-1pe9i closed. |
