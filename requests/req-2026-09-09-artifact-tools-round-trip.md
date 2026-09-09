---
type: request
id: req-2026-09-09-artifact-tools-round-trip
status: routed
version: 1
date: 2026-09-09
reader: lead-pm
owner: lead-pm
created: 2026-09-09
updated: 2026-09-09
originator: lead-pm
received-through: operational-contract
arose-in: req-2026-09-06-plain-status
route: small-change
route-reason: "two defects in the lead shop's own artifact tool, each fixed in the tool with its skill re-produced; within the lead shop's own definitions, demonstrable in one session by a read-append-write round trip and a frontmatter write"
routed-to: ""
---

# Request: artifact-tools' read and write round-trip cleanly

## 1. What is requested

Found in the small-change lane on req-2026-09-06-plain-status
(execution small-change-process:lead-jsqmr, 2026-09-09), by the
lead-pm role at its check and record steps: `artifact_tools.py read
--section` returns a section with its heading, while `write --part`
places content under the heading, so a read-append-write round trip
duplicates the heading; and `write` on a frontmatter string field
double-quotes a value that is already quoted (the base-writing-style
guideline's `updated` came back as `'2026-09-09'`). Both were repaired
by hand in the lane; neither blocked it.

## 2. From whom

Reader: the lead-pm role. Originator: the lead-pm role, from the
lane's own findings on the anchor. Received through the lead shop's
operational contract (lead-4kymc).

## 3. Route

Route said by the lead-pm role, 2026-09-09: **the small-change lane**.
Why: the tool is the lead shop's own (basis/tools/artifact_tools.py);
a read followed by a write of the same part leaves the artifact as it
was, and a write of a string field leaves one pair of quotes at most;
the skill re-produced. Accepted — the originator is the lead-pm role.
Not started: this session's order named three lane items.

## 4. Result

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-09 | update | Recorded by the lead-pm at the request-intake process's record step from the lane's findings on lead-jsqmr; routed to the lane, accepted, not started. |
