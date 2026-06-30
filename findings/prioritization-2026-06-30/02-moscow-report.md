# MoSCoW (Must / Should / Could / Won't) — Application Report

SOURCE NOTE: the prompt's `cat undefined` is a broken-path placeholder (confirmed: "cat: undefined: No such file or directory"). The real backlog is this lead shop's beads (bd) registry — 50 issues read via `bd list --json`. Fields used per row: id, title (with bracket tags), description, status, priority (P1/P2/P3), issue_type, created_at/updated_at/started_at, dependencies[] (typed edges), dependency_count, dependent_count. comment_count (all 0) and assignee/owner (near-constant) carry no discriminating signal and were excluded.

HOW MoSCoW WAS APPLIED. MoSCoW is a categorical band, not a numeric score, so each item gets one of {Must, Should, Could, Won't} (the "score" field carries the band label). I applied the agreed rubric, then refined it against the read descriptions so the Must band stays meaningful rather than flooding:
- MUST = a live adopter-blocker or a P1 contract obligation that must land THIS cycle. Concretely: (a) the approve-claude credential family — z3e2/al1r/oxd8/igzz/p83k/lu91 — the active fresh-bootstrap credential failure (product-authority debug thread dated 2026-06-29) plus its corrective pins/register work; (b) the fresh-bootstrap regression family — x4mk (stale starter), ko2v (cached :latest image silently masks delivered fixes), m0uy (update path can't render bin/ops-coordinates) — all named in the recent stale-bootstrap root-cause commits; (c) the remaining P1 contract/bootstrap items cl1u, l7uz, y1we, ji28, mdng.
- SHOULD = P2 work that is important and contract-coupled but is NOT a live adopter crash: foot-gun fixes (7w0w, 9mog), reconciliation that keeps lead-mirror/contract registers honest (y6gu, glel, scdm, q14e, 9q8e), a gating decision (7wta), near-term capabilities (vglj, arp1, 2nf1, 3nf7, loos, oyaj, 99l1), a release delivery (jasu), and PDR/gated scenario edits (y9e2, py3y, 5lqg).
- COULD = P3 items, hygiene/doctrine, views, spikes, and low-CoD reconciliation/old features (qhp9, cnjj, a15t, eipz, rtgg, h2p0, zhlo, ogky, j1pd, 4vue, h9nv, 22x1, f6ta, odqd, x4w7).
- WON'T (this cycle) = out-of-scope/different-track or unschedulable-stale: kf36 (explicitly "bd-fork track, NOT shopsystem-templates" — different product), oitw (status=blocked, empty spec, age 27d).

BAND COUNTS: Must 14, Should 19, Could 15, Won't 2.

ESTIMATES & ASSUMPTIONS (explicit). (1) CoD-class (adopter-blocker vs foot-gun vs hygiene) is keyword-inferred then spot-checked by reading the description for the credential/bootstrap family — those reads are High confidence; pure-keyword rows are Med. (2) "Live regression" promotion of x4mk/ko2v/m0uy from P2 to Must is a judgment call anchored on the 2026-06-29 z3e2 debug thread and the recent stale-bootstrap commits; if those are considered already-mitigated they drop to top-of-Should. (3) The supersede signal (oxd8 "supersede refuted approve-claude pin") was checked: it retires a refuted SCENARIO PIN (an artifact), NOT the bead al1r — al1r is the live root-cause bug and stays Must; no bead is wholly superseded, so the only Won't entries are scope/stale, not supersede. (4) jasu and oitw have empty descriptions (title-only) — lower confidence.

WHERE MoSCoW HANDLES THIS BACKLOG POORLY. (a) The Must band is large (14) because the shop is mid-firefight on a single bootstrap/credential regression — MoSCoW gives no intra-band priority, so the ranking below uses an estimated CoD/leverage secondary order (live-blocker > root-cause > high-leverage durable fix > contract pin > P1 feature > epic). (b) MoSCoW cannot express SEQUENCING: several Shoulds are gated (py3y on lead-ml51, 5lqg blocked-by, y9e2 on lead-y4pg, q14e on the Must m0uy) — they keep their band but must wait; this is noted per-row. (c) EPICS are mis-sized for MoSCoW: mdng (P1, dependency_count 3, 20d no activity) sits in Must as a whole initiative and odqd (dependency_count 6) in Could — both should be decomposed before commitment; flagged. (d) "Won't" in MoSCoW means won't-this-cycle, not never — kf36/oitw may return when their external track / unblocker resolves.

## Ranking (best → worst)

| # | id | score | confidence | reason |
|---|---|---|---|---|
| 1 | lead-z3e2 | Must | High | The #1 live regression: fresh-bootstrap Claude credential failure recurs despite the lead-dui6 fix. Hard adoption blocker under active debug — top Must. |
| 2 | lead-al1r | Must | High | Root cause of the blank-credential symptom; fix in flight. Unblocks the oxd8/igzz reconciliation. Its refuted pin is superseded by oxd8 but the bug itself is li |
| 3 | lead-ko2v | Must | High | Durable fix for the whole stale-image class that masked z3e2/the fresh-bootstrap regression. Silent + adopter-wide leverage — promoted P2->Must. |
| 4 | lead-x4mk | Must | High | Fresh adopters bootstrap from a stale starter — named in the stale-bootstrap root-cause commits. Live adoption blocker, promoted P2->Must. |
| 5 | lead-m0uy | Must | High | Meets Must rubric (ADR-pinned AND blocks-adopters): the update path can't deliver canonical ops scripts. Blocks the q14e reconcile. |
| 6 | lead-p83k | Must | High | Lead's own launcher hands a path-string trust anchor -> TLS failure for launched leaves. ADR-pinned contract breach. |
| 7 | lead-lu91 | Must | High | Contract mismatch causing silent SSL failure; the canonical class that p83k instantiates. ADR+PDR pinned -> Must. |
| 8 | lead-oxd8 | Must | High | Authors the missing scenario pin for the al1r corrective behavior and retires the refuted pin. Required to close the credential family's contract. |
| 9 | lead-igzz | Must | High | Register-visibility gap blocking reconciliation of the credential family (3 pins absent from lead features/). Unblocks family close-out. |
| 10 | lead-cl1u | Must | High | P1 new vehicle (request_scenario_register) that structurally fixes the register-visibility gap igzz hit by hand. P1 + active. |
| 11 | lead-l7uz | Must | High | WS-2 is the adopter's end-to-end bootstrap proof. P1 capability, partially stale (no activity ~4d) — keep Must, nudge for progress. |
| 12 | lead-y1we | Must | High | PDR-022-committed scenario authoring feeding the lead-0j7o dispatch. P1 + PDR-pinned product intent -> Must. |
| 13 | lead-ji28 | Must | High | Silent contract-surface defect: carried scenarios[].hash disagrees with canonical @scenario_hash. P1; oldest item and stale in_progress — Must but flag the stal |
| 14 | lead-mdng | Must | Med | P1 credential-substrate initiative — anchors the whole credential family. But it is an undecomposed epic with open design decisions and 20d idle; Must by priori |
| 15 | lead-7wta | Should | High | Finalizing the single ops-coordinates artifact shape is a gating decision for multiple downstream reconciliation items — highest-leverage Should. |
| 16 | lead-loos | Should | High | PDR-committed product intent (release BOM) with downstream dependents; new capability, not a live blocker -> top Should. |
| 17 | lead-jasu | Should | Med | Release delivery that lands a committed fix to adopters. Should; confidence reduced by empty description. |
| 18 | lead-9mog | Should | High | Foot-gun that misdirects BC agents on reconciled scenarios. P2 foot-gun -> Should. |
| 19 | lead-7w0w | Should | High | Silent malformed-but-valid complete lands with no confirmation. Classic P2 foot-gun -> Should. |
| 20 | lead-arp1 | Should | High | Operational-safety capability (gates ops on credential/connection/beads health). Active P2 capability -> Should. |
| 21 | lead-vglj | Should | Med | Adopter-onboarding capability tied to the bootstrap experience. P2, active -> Should. |
| 22 | lead-2nf1 | Should | High | Tightens the create-bc path adopters use; active P2 -> Should. |
| 23 | lead-3nf7 | Should | Med | Capability to bring up BCs + bake the bring-up skill into templates. P2; in_progress but 25d idle -> Should, flag stall. |
| 24 | lead-y6gu | Should | High | Contract-honesty reconciliation: lead mirror diverged from BC committed register. Unblocks 4vue. Should. |
| 25 | lead-glel | Should | High | Lead mirror carries PHANTOM scenarios vs BC register — re-sync via authoritative register. Reconciliation Should; gated by qhp9 delivery. |
| 26 | lead-scdm | Should | High | Re-pins load-bearing shop-shell behavior (incl negative legs) lost in a retire. Contract-restoration Should. |
| 27 | lead-q14e | Should | High | Reconciles lead's drifted ops files to canonical. Should, but sequenced behind m0uy (which blocks it). |
| 28 | lead-9q8e | Should | High | Keeps lead canonical in agreement with the messaging register. Reconciliation Should. |
| 29 | lead-py3y | Should | Med | Sharpen ADR-043 source-target leg + re-hash. Should but explicitly gated on lead-ml51; sequence after 7wta. |
| 30 | lead-5lqg | Should | Med | Aligns launcher to the ratified artifact. Should but blocked-by upstream (depends on 7wta decision). |
| 31 | lead-y9e2 | Should | Med | PDR-committed scenario-count update, but gated on lead-y4pg landing. Should, sequenced. |
| 32 | lead-oyaj | Should | Med | BC-discipline improvement reducing wasted round-trips. P2 -> Should. |
| 33 | lead-99l1 | Should | Med | Agent-behavior defect that stalls BC autonomy. P2 -> Should; keyword-inferred CoD. |
| 34 | lead-qhp9 | Could | Med | High leverage (unblocks glel) but P3 and an unblocker of a Should (not a Must) -> top of Could. |
| 35 | lead-cnjj | Could | Med | Security-posture product decision needing user judgment, but P3 and not yet a live exploit. Could; route the decision to the product authority. |
| 36 | lead-a15t | Could | High | Mid-tier foot-gun but P3 -> Could. |
| 37 | lead-eipz | Could | Med | Completes enum/scenario coverage; low CoD reconciliation -> Could despite P2. |
| 38 | lead-rtgg | Could | Med | Mirror reconciliation, low live urgency -> Could. |
| 39 | lead-h2p0 | Could | Med | A surface/view feature (TIER-LOW CoD), complements loos. Could. |
| 40 | lead-zhlo | Could | Med | E2E re-run is valuable but currently unschedulable on this host (environment skew). Could until a skew-free host exists. |
| 41 | lead-ogky | Could | Med | Process-completeness improvement, low CoD -> Could. |
| 42 | lead-j1pd | Could | Med | Doctrine/hygiene chore. Could. |
| 43 | lead-4vue | Could | Med | Reconciliation re-author, old and low-CoD; depends on y6gu re-scope. Could. |
| 44 | lead-h9nv | Could | Med | PDR-linked propagation but low urgency and 20d old -> Could. |
| 45 | lead-22x1 | Could | Med | Capability-corpus groundwork, no live demand -> Could. |
| 46 | lead-f6ta | Could | Med | Exploratory spike (alternate substrate); valuable optionality, not committed delivery -> Could. |
| 47 | lead-odqd | Could | Med | Large early-stage initiative (6 upstream deps) with no live urgency -> Could; flagged for decomposition before any commitment. |
| 48 | lead-x4w7 | Could | Med | Minor pre-existing release-version lag, P3, low impact -> bottom of Could. |
| 49 | lead-kf36 | Won't | High | Out of scope for this product/cycle — it belongs to the external bd-fork track and must be coordinated there. Won't this cycle. |
| 50 | lead-oitw | Won't | Low | Unschedulable: status blocked, no spec/description, stale. Won't this cycle until unblocked and specified. |
