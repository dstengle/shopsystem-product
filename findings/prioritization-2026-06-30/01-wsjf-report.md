# WSJF / CD3 (Cost of Delay ÷ Job Size) — Application Report

SOURCE NOTE. The prompt's `cat undefined` is a broken path placeholder (confirmed: `cat: undefined: No such file or directory`). The real backlog is this lead shop's beads (bd) registry, read via `bd list --json` — 50 issues. Fields per row: id, title (with bracket tags), description, status, priority, issue_type, dependencies[] (typed edges), dependency_count, dependent_count, created_at/updated_at. comment_count is 0 for all rows and assignee/owner are near-constant, so both are excluded as non-discriminating.

BACKLOG SHAPE (empirical basis). status open=38 / in_progress=11 / blocked=1; priority P1=11 / P2=35 / P3=4; issue_type task=21 / bug=15 / feature=13 / chore=1. Age 0–32 days (median ~3, oldest lead-ji28 created 2026-05-29); a young backlog, so age is only a tie-breaker. 23/50 rows carry dependency edges; 7/50 have dependent_count>0 (all =1); blocks-edges concentrate leverage in lead-mdng (blocks 3), lead-odqd (blocks 6), lead-glel (blocks 2), lead-7wta (blocks ml51 + enables 5lqg/py3y).

HOW WSJF/CD3 WAS APPLIED. WSJF = Cost of Delay ÷ Job Size, ranked descending. There is NO native effort or value field in bd, so BOTH the CoD numerator and the Job-Size denominator are ESTIMATED on a modified-Fibonacci {1,2,3,5,8,13} scale with fixed rubrics, making this a faithful RELATIVE ranking, not an absolute time-denominated cost.
- Cost of Delay = Value (V) + Time-Criticality (T) + Risk-Reduction/Opportunity-Enablement (R), each on the Fib scale.
  - V anchored by Priority floor (P1=8, P2=3, P3=1) raised by ADR/PDR linkage and blocks-adopters CoD-class (e.g. p83k/lu91 hit V=13: P1 + ADR-045 + MITM/security; mdng/l7uz V=13: P1 + initiative/bootstrap).
  - T anchored by HIGH-tier keywords (recurs / silently / stale / bootstrap / security / MITM ⇒ T≥8) plus a minor age nudge. z3e2 got T=13 (RECURS + fresh-bootstrap + active product-authority debug). I tempered lead-cnjj from the rubric's keyword-driven T≥8 down to T=5 after reading: its "security" is a posture DECISION needing user judgment, not a live incident — flagged below.
  - R = baseline 1, +1 Fib step per dependent_count and per explicit enables/unblocks phrase. Leverage hubs: odqd R=8 (blocks 6), glel/7wta R=5, mdng R=5.
- Job Size on the Fib scale: maintenance/doc/doctrine = 1–2; simple bug = 2–3; contract bug = 3–5; new vehicle/capability author = 8–13; +1 step per dependency_count coupling; −1 step if scenarios are already pinned (well-specified, e.g. y9e2 J=2, x4w7 J=2).
- Ties broken by dependent_count then older age first.

KEY ESTIMATES & ASSUMPTIONS (all marked Med confidence unless noted). High-confidence rows are where structured fields agree strongly: p83k, lu91 (P1+ADR+security+small known fix), x4mk (stale+mechanical re-render), 7w0w (silent foot-gun+small), y9e2 (PDR-019+pinned scenario, one-row grow). Low confidence: jasu (description empty — title-only), oitw (description empty AND status=blocked).

WHAT WSJF HANDLES POORLY HERE (called out so the ranking isn't misread):
1. EPICS/INITIATIVES are penalised by their large denominator. lead-mdng (rk30), lead-odqd (rk39), lead-l7uz (rk27), lead-h9nv (rk48), lead-22x1 (rk50) carry high Value/leverage but J=13 sinks their per-unit WSJF. WSJF is telling you to SPLIT them, not to defer them — each should be sliced (work-splitting) before a Must commitment. lead-mdng and lead-odqd in particular gate large downstream sets.
2. HIGH-UNCERTAINTY URGENT WORK is mis-served. lead-z3e2 is THE active P1 debug thread (credential bug RECURS on fresh bootstrap) and earns the highest CoD in the backlog (23), but its investigation-inflated J=8 drops it to rk14 — below cheap P2 hygiene. Schedulability overrides WSJF here: it is in-flight and product-authority-driven, so it should be worked now regardless of rank. Its blocker chain (z3e2 → al1r → oxd8 → igzz, plus the cl1u vehicle) is the spine of the approve-claude/credential family and should be sequenced together.
3. CALIBRATION-GUARD HITS (P3 above P1). The guard flagged three: lead-cnjj (P3, rk13), lead-x4w7 (P3, rk22) and lead-qhp9 (P3, rk31) land above several P1s (cl1u rk25, oxd8 rk26, l7uz rk27, mdng rk30, y1we rk34). This is a genuine WSJF artifact: the P3s are tiny (J=2–3) while those P1s are author/epic-sized (J=8–13). I kept the computed WSJF (it is correct per-unit) but the MoSCoW band is the corrective overlay — every P1 is Must irrespective of WSJF rank, and the three P3s are Could. cnjj additionally is a product-DECISION requiring user judgment (dotfile-bind-mount removal + token-rotation policy), so it is schedulability-gated on the product authority, not freely startable.
4. SCHEDULABILITY GATES (compute the score, defer execution): lead-oitw is status=blocked; lead-5lqg blocked-by lead-ow4d; lead-py3y blocked-by lead-ml51; lead-zhlo needs a skew-free Docker host (environmental); lead-y9e2 gated on lead-y4pg landing; lead-cnjj needs a product-authority decision. These keep their WSJF rank but are sequenced behind their unblockers.

CONFLICT/SUPERSEDE handling: the approve-claude family (al1r/z3e2/oxd8/igzz/cl1u) is one coherent chain — oxd8 authors the corrective pin AND supersedes the refuted approve-claude pin, igzz obtains the register, cl1u authors the request_scenario_register vehicle that closes the visibility gap. They are not double-counted; each scores its own slice and the chain is Must-grouped. lead-q14e (reconcile drifted shop-shell to v0.45.0, carries the ADR-045 CA-inline fix) overlaps lead-p83k (the P1 instance of that same fix) and lead-lu91 (the adopter pin) — same defect surface, distinct vehicles; p83k is the Must P1, q14e the Should reconcile carrier.

MoSCoW overlay (band per row in the ranking components): Must = the 11 P1s (contract/adopter blockers + PDR-committed authoring). Should = P2 with foot-gun/mid CoD or contract/ADR/PDR linkage. Could = P3, pure reconciliation/mirror hygiene, doctrine/chore, back-burner spikes, and the blocked/decision-gated rows.

## Ranking (best → worst)

| # | id | score | confidence | reason |
|---|---|---|---|---|
| 1 | lead-p83k | WSJF 7.33 | High | MoSCoW=Must. Highest WSJF: P1 security/TLS defect with a small, already-understood fix (mirrors lu91's delivered CA-inline). in_progress; lead's own shop-shell. |
| 2 | lead-lu91 | WSJF 7.33 | High | MoSCoW=Must. Adopter-side origin of the CA path-vs-inline defect; same small high-value profile as p83k. Sequence together. |
| 3 | lead-y9e2 | WSJF 6.0 | High | MoSCoW=Should. Tiny, well-specified PDR-pinned scenario edit with contract-correctness urgency. Gated on lead-y4pg landing (schedulability). |
| 4 | lead-x4mk | WSJF 5.0 | High | MoSCoW=Should. Stale adopter starter (v0.28.0) re-rendered cheaply; desc notes it is not the agent-vault blocker, so not Must, but high WSJF. |
| 5 | lead-j1pd | WSJF 4.5 | Med | MoSCoW=Could. Cheap doctrine fix (gate artifact-derived pre-states on publish-run completion); high WSJF purely from low cost. |
| 6 | lead-7w0w | WSJF 4.0 | High | MoSCoW=Should. Silent foot-gun: empty --scenario-hash accepted and no stdout confirmation; small fix. |
| 7 | lead-al1r | WSJF 3.8 | Med | MoSCoW=Must. Structural approve-claude oauth-seed defect, silent blank-credential adopter blocker; in_progress, fix path (a) delivered. |
| 8 | lead-q14e | WSJF 3.6 | Med | MoSCoW=Should. Reconciles drifted shop-owned ops files to v0.45.0; overlaps p83k (Must P1 instance) of the same CA-inline surface. m0uy reports update won't ren |
| 9 | lead-igzz | WSJF 3.2 | Med | MoSCoW=Must. Obtains shopsystem-templates scenario register for 3 approve-claude pins; resolves lead-al1r residual #3 register-visibility gap. Partially gated o |
| 10 | lead-ko2v | WSJF 3.0 | Med | MoSCoW=Should. Cached :latest means delivered fixes silently don't take effect until manual docker pull — broad delivery-correctness foot-gun. |
| 11 | lead-glel | WSJF 3.0 | Med | MoSCoW=Should. High-leverage mirror reconcile: lead-held network-naming 18/20 are phantom vs bc-launcher register; unblocks two items. |
| 12 | lead-jasu | WSJF 3.0 | Low | MoSCoW=Should. Cut messaging v0.4.2 carrying the rqox clobber fix. Low confidence — description empty, scored from title only. |
| 13 | lead-cnjj | WSJF 3.0 | Med | MoSCoW=Could. CALIBRATION FLAG: P3 ranking above several P1s is a small-job-size artifact. It is a product-AUTHORITY decision (dotfile bind-mount removal + toke |
| 14 | lead-z3e2 | WSJF 2.88 | Med | MoSCoW=Must. WSJF-HANDLES-POORLY case: highest CoD but uncertainty-inflated job size sinks it to mid-rank. Schedulability OVERRIDES WSJF — this is THE active P1 |
| 15 | lead-ji28 | WSJF 2.8 | Med | MoSCoW=Must. Feature-line-included vs block-only hash mismatch misdirects reconciliation. Oldest row (32d) and in_progress — possible stall; age nudge applied. |
| 16 | lead-m0uy | WSJF 2.4 | Med | MoSCoW=Should. shop-templates update doesn't render bin/ops-coordinates; existing repos can't adopt canonical scripts via update. |
| 17 | lead-9mog | WSJF 2.4 | Med | MoSCoW=Should. bc-emit Check 3 reads stale local features/ tree → refuses an already-reconciled scenario, misdirecting to --force. Newest row (0630). |
| 18 | lead-zhlo | WSJF 2.33 | Med | MoSCoW=Could. Re-run adopter cold-walkthrough on a skew-free host. Schedulability-gated: this host's ZFS bind-mount skew blocks it (environmental). |
| 19 | lead-9q8e | WSJF 2.33 | Med | MoSCoW=Could. Sync lead-held scenario 119 to the BC-amended body (re-pin 98c6065→8edfb82); reconciliation hygiene. |
| 20 | lead-99l1 | WSJF 2.2 | Med | MoSCoW=Should. BC agent over-defers (permission menu) despite full-autonomy mandate, blocking queued leads. |
| 21 | lead-3nf7 | WSJF 2.0 | Med | MoSCoW=Should. bring-up-bc skill mostly delivered per description; small remainder. in_progress. |
| 22 | lead-x4w7 | WSJF 2.0 | Med | MoSCoW=Could. CALIBRATION FLAG: P3 above some P1s due to tiny job size. v0.15.0 tag ships pyproject 0.14.0; pin via one Examples row. |
| 23 | lead-rtgg | WSJF 2.0 | Med | MoSCoW=Could. Mirror reconcile of bc-launcher network-naming family {19,21–26}; pure reconciliation hygiene. |
| 24 | lead-7wta | WSJF 1.875 | Med | MoSCoW=Should. High-leverage ADR-043 D2 finalize (ops-coordinates artifact shape); unblocks 5lqg/py3y/ml51. |
| 25 | lead-cl1u | WSJF 1.875 | Med | MoSCoW=Must. Authors the new request_scenario_register message-type vehicle that closes the register-visibility gap; in_progress. Must despite mid WSJF (P1). |
| 26 | lead-oxd8 | WSJF 1.875 | Med | MoSCoW=Must. Authors refreshable-CLAUDE_OAUTH corrective pin and supersedes the refuted approve-claude pin (lead-al1r residual). Conflict-resolver for the famil |
| 27 | lead-l7uz | WSJF 1.846 | Med | MoSCoW=Must. End-to-end new-product bootstrap path. WSJF-HANDLES-POORLY: epic-sized denominator sinks per-unit score — SPLIT into thin slices before committing. |
| 28 | lead-kf36 | WSJF 1.8 | Med | MoSCoW=Could. bd-dolt created_by re-export normalization (source of emit-gate clean-tree churn). Separate bd-fork track, not shopsystem-templates. |
| 29 | lead-ogky | WSJF 1.8 | Med | MoSCoW=Could. Architect supersede-dispatch should enumerate BC-local UNPINNED scenarios too; doctrine + skill auto-cleanup gap. |
| 30 | lead-mdng | WSJF 1.769 | Med | MoSCoW=Must. agent-vault credential substrate initiative; high value and leverage. WSJF-HANDLES-POORLY: epic — SPLIT (open design decisions A/B); gates 3 downst |
| 31 | lead-qhp9 | WSJF 1.667 | Med | MoSCoW=Could. CALIBRATION FLAG (P3 above a P1). Messaging release incl consume-enum fix + lead shop-msg upgrade; unblocks one stuck outbox row (glel). 'Low urge |
| 32 | lead-y6gu | WSJF 1.6 | Med | MoSCoW=Could. Re-scope xc0d drifted RETIRE 45–47 + REVISE; lead mirror diverged from messaging committed register. Reconciliation hygiene. |
| 33 | lead-eipz | WSJF 1.6 | Med | MoSCoW=Should. Pin remaining BC→lead response types in consume-outbox enum (request_shop_card_response et al). Follow-up to lead-ay7j. |
| 34 | lead-y1we | WSJF 1.538 | Med | MoSCoW=Must. PDR-022 Phase-A delegation scenarios (footing invokes agent-vault-provision + provision-contract). WSJF-HANDLES-POORLY: large authoring job; Must b |
| 35 | lead-scdm | WSJF 1.5 | Med | MoSCoW=Should. Re-pin shop-shell SHAPE legs lost when 172/134 retire under lead-ml51; prevents silent contract loss. |
| 36 | lead-vglj | WSJF 1.375 | Med | MoSCoW=Should. Lead detects effectively-empty repo and proactively starts product-discovery; ties to the discovery gate. in_progress. |
| 37 | lead-a15t | WSJF 1.333 | Med | MoSCoW=Could. work-done-gate Check 4 RED-sub-issue criterion ambiguous; explicitly 'low priority, signal-quality not a hard gate gap'. |
| 38 | lead-arp1 | WSJF 1.25 | Med | MoSCoW=Should. doctor as a BC healthcheck that GATES operations (credentials/connections/beads health). Extends lead-q3r1. |
| 39 | lead-odqd | WSJF 1.231 | Med | MoSCoW=Should. Iterative-experimentation capability initiative; highest dependency leverage in the backlog. WSJF-HANDLES-POORLY: epic — SPLIT; R=8 reflects 6 bl |
| 40 | lead-oyaj | WSJF 1.125 | Med | MoSCoW=Should. BC self-resolves fixable procedural gate failures before work_done; PDR + scenario authoring. |
| 41 | lead-5lqg | WSJF 1.125 | Med | MoSCoW=Should. Switch bc-launcher _resolve_shop_network() to the ratified bin/ops-coordinates artifact. Schedulability-gated: blocked-by lead-ow4d. |
| 42 | lead-py3y | WSJF 1.125 | Med | MoSCoW=Should. Sharpen ADR-043 source-target leg of ml51 204/205 + bc-launcher 63 to concrete bin/ops-coordinates. Schedulability-gated: blocked-by lead-ml51. |
| 43 | lead-2nf1 | WSJF 1.125 | Med | MoSCoW=Should. Overhaul create-bc skill (derive owner from lead, align with bootstrap/footing, clone-not-bind-mount). in_progress. |
| 44 | lead-4vue | WSJF 1.0 | Med | MoSCoW=Should. Re-author revised bodies for messaging-registry 02 (idempotency) + 05 (field-position) under abstract addressing. |
| 45 | lead-h2p0 | WSJF 0.875 | Med | MoSCoW=Could. Lead-side inter-component version-dependency view. P2 but convenience-hygiene CoD-class → Could; bridges loos (BOM). |
| 46 | lead-loos | WSJF 0.769 | Med | MoSCoW=Should. System build manifest (BOM): explicit component versions → one system release version, reflected back as repo tags. Large new capability. |
| 47 | lead-oitw | WSJF 0.75 | Low | MoSCoW=Could. assign_scenarios from lead. Schedulability: status=BLOCKED. Low confidence — description empty, title-only. |
| 48 | lead-h9nv | WSJF 0.615 | Med | MoSCoW=Should. Propagate BC-local-architect role + 3-tier ADR to templates + framework spec. WSJF-HANDLES-POORLY: oversized batch — split per prong. |
| 49 | lead-f6ta | WSJF 0.462 | Med | MoSCoW=Could. fabro alternable-orchestration-substrate spike; explicitly back-burner per user (2026-06-04). |
| 50 | lead-22x1 | WSJF 0.462 | Med | MoSCoW=Could. WS-7 Skills corpus. WSJF-HANDLES-POORLY: epic — SPLIT; partly gated on WS-3 settling. Lowest WSJF in the backlog (tied). |
