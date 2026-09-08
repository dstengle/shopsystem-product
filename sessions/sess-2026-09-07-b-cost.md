---
type: run-cost
id: sess-2026-09-07-b-cost
session: sessions/sess-2026-09-07-b.md
anchor: lead-5wzgl
created: 2026-09-08
updated: 2026-09-08
---

# Run cost: sess-2026-09-07-b

Cost rows for the agent runs recorded on the anchor above, read without a model. A blank field is one the harness's usage report did not expose for that run.

## Rows

| Step | Role | Minutes | Context tokens | Output tokens | Tool uses |
|---|---|---|---|---|---|
| decide-route | lead-pm | 0.9 | 501031 | 11109 |  |
| router: router segment 1, start -> held decide-route | router | 2.6 | 100006 | 2014 |  |
| observe | originator | 0.4 |  |  |  |
| land | lead-pm | 0.3 |  |  |  |
| router: router segment 2, answer decide-route -> held open-lane | router | 3.8 | 630821 | 11041 |  |
| router: router segment 3, resumed at open-lane | router | 12.8 | 516924 | 4939 |  |
| land-result | lead-pm | 0.4 |  |  |  |
