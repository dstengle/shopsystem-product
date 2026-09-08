---
type: request
id: req-2026-09-08-router-sonnet
status: done
version: 2
date: 2026-09-08
reader: lead-pm
owner: lead-pm
created: 2026-09-08
updated: 2026-09-08
originator: product-authority
received-through: operational-contract
arose-in: lead-fresb
route: small-change
route-reason: "one key's value on the router's definition and its rendering, under the authority's ruling on brief-039 Ask 3; within the lead shop's own definitions, demonstrable in one session"
routed-to: "requests/req-2026-09-08-router-sonnet.md#result"
work-item: lead-yf81i
---

# Request: the router on sonnet

## 1. What is requested

The product authority's ruling on brief-039, Ask 3 (2026-09-07, "keep
defaults on rulings"): keep the router on haiku for the re-run and
raise it to the next tier, sonnet, on the first break after
hardening. The break: in the initiative-check run on
init-run-measurement (anchor lead-fresb, 2026-09-08 00:57), the router
launched the second ADR's revise step as a bare agent on haiku, not
from the architect role's rendering on sonnet as its definition says;
that agent then committed to git, and on a failed push changed the
repository's remote to SSH. On the same run a resume read only the
anchor's first event. The authority, on the remote: "Did the router
do this?"

## 2. From whom

Reader: the lead-pm role. Originator: the product authority, by the
standing ruling. Received through the lead shop's operational
contract, which has no artifact yet (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-08: **the small-change lane**.
Why: `model: sonnet` on basis/roles/router.md, its rendering
regenerated. Topic: "router to sonnet (req-2026-09-08-router-sonnet)".

Originator's answer: **accepted** — the ruling stands.

## 4. Result

### Definition

req-2026-09-08-router-sonnet: when done, the router runs on sonnet.

- Given basis/roles/router.md, when read, then it carries
  `model: sonnet` and its history says why.
- Given .claude/agents/router.md, when the role check runs, then the
  rendering is current with its source and reports no finding.

Artifacts touched: basis/roles/router.md and its rendering
.claude/agents/router.md by basis/tools/compile_role.py. Maker role:
lead-solutions-architect. Verifying observation:
`python3 basis/tools/compile_role.py --check --findings`, exit 0.
Defined by the lead-pm at the define step on the ruling's words.

### Change made

Round 1. Maker: lead-solutions-architect. Paths changed: basis/roles/router.md
(version 4 → 5), .claude/agents/router.md (rendering, re-rendered by
`basis/tools/compile_role.py`, digest 14f28215e9a5). `model: haiku` →
`model: sonnet` on basis/roles/router.md, its Document History row 5 citing
req-2026-09-08-router-sonnet and the break; the rendering re-rendered from
the source. Check: `python3 basis/tools/compile_role.py --check --findings`,
exit 0.

### Check

Round 1 — verdict: pass; checker: lead-pm, 2026-09-08. The definition carries `model: sonnet` with the break in its history; the rendering is current and the role check reports no finding.

### Verified result

Observation: `python3 basis/tools/compile_role.py --check --findings` — no finding, exit 0, 2026-09-08, by the lead-pm role. The Definition, the Check's verdict, and this result stand; no bet was taken and no check of record was run.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-08 | update | Recorded and defined by the lead-pm from the ruling and the break; route lane, accepted; work item lead-yf81i. |
| 2 | 2026-09-08 | update | Checked and verified by the lead-pm role: pass, round 1; status done; work item lead-yf81i closed. |
