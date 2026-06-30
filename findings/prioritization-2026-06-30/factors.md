# Rating Factors & Data-Sufficiency Check

SOURCE NOTE: the prompt's `cat undefined` was a broken path placeholder. The real backlog is this lead shop's beads (bd) registry — 50 issues, read via `bd list --json`. Fields present per row: id, title (with bracket tags), description, status, priority, issue_type, assignee, owner, created_at/updated_at/started_at, dependencies[] (typed edges), dependency_count, dependent_count, comment_count.

BACKLOG SHAPE (the empirical basis for every factor): status open=38 / in_progress=11 / blocked=1; priority P1=11 / P2=35 / P3=4; issue_type task=21 / bug=15 / feature=13 / chore=1. Title bracket-tags observed: [bug]/[BUG]=9, [PO]=2, [architect]=1, [delivery]=1, [product-decision]=1, [product]=1 (35 untagged). Dependency edges: blocks=22, discovered-from=9, related=3, relates-to=2, blocked-by=2, parent-child=1; 23/50 rows have a non-empty deps array, 7/50 have dependent_count>0 (all =1), 14/50 have dependency_count>0. Age: 0-32 days, median ~3, 49/50 from 2026-06 — a YOUNG backlog, so age is a weak discriminator. Signal density over title+description: ADR mentioned in 24/50, PDR in 7/50, scenario-hash/pin in 31/50, adopter-blocker/stale/recurs/bootstrap/silent/security in 34/50, reconcile/maintenance/hygiene/refactor in 32/50, new-capability/author/assign_scenarios in 32/50.

FACTORS: I derived 12 factors. The 9 the product authority named map directly onto bd fields/signals (age<-created_at; ADR/PDR linkage<-regex over title+desc; scenario pins<-@hash/pin signal; new-vs-maintenance<-issue_type+bracket-tag+keywords; cost-of-NOT-doing<-a 3-tier keyword CoD-class; effort<-ESTIMATED, no native field; dependencies<-dependent_count + blocks edges; conflicts<-related/relates-to edges + supersede/refute language). I ADDED 3 the frameworks require: stated Priority (calibration prior + MoSCoW band anchor), upstream-blocked/schedulability (status + blocked-by/dependency_count — gates WSJF execution order vs raw score), and the CoD decomposition triad (Value/Time-Criticality/RR-OE — the WSJF numerator, all estimated). See the factors array for definition/derivation/feeds on each.

DATA SUFFICIENCY (honest, per framework): MoSCoW (B) is fully exercisable — it is categorical and every band has a direct data source, including 'Won't' from the supersede/refute/conflict signals (e.g. lead-oxd8 'supersede refuted approve-claude pin' explicitly retires lead-al1r's refuted pin). WSJF/CD3 (A) is only PARTIALLY sufficient: the Cost-of-Delay numerator can be estimated defensibly from strong structured signal, but there is NO effort/story-point field and no numeric value field, so both the denominator (Job Size) and CoD itself are estimated. WSJF here yields a faithful RELATIVE ranking, not an absolute time-denominated cost. To keep both Apply passes consistent I standardize on a modified-Fibonacci {1,2,3,5,8,13} scale with fixed rubrics for each CoD sub-score and for Job Size, plus a per-row confidence tag (High=structured fields agree, Med=keyword-inferred, Low=empty-description/title-only — 2/50 rows have empty descriptions). Genuinely unpopulatable: RICE-style Reach (no user-count field; only coarse 'blocks-adopters' inference), monetary value (internal framework product), and Confidence (assigned, not stored). comment_count (all 0) and assignee/owner (near-constant) carry no signal and are excluded. Full rubric and tie-break/calibration rules are in data_sufficiency.estimation."}

## Factors

### Age (created-date staleness)
- **Definition:** Days elapsed from created_at to today (2026-06-30). A freshness/decay signal: very old open items either decayed in relevance or have been silently starved.
- **Derivation:** created_at date diffed against today. Range in this backlog: 0-32 days, median ~3 days, 49/50 created in 2026-06 (one straggler in 2026-05). updated_at vs created_at gives an activity/staleness delta for in_progress rows.
- **Feeds:** A: minor positive nudge to Time-Criticality only when age co-occurs with a recurs/blocks signal (age alone is weak here since the backlog is young). B: tie-breaker within a MoSCoW band and a 'Won't / stale-drop' flag for old untouched low-priority rows.

### ADR linkage
- **Definition:** Whether the item is pinned to or governed by an Architecture Decision Record (contract surface).
- **Derivation:** Regex adr[-\s]?\d / \badr\b over title+description. 24/50 rows mention an ADR (e.g. lead-p83k cites ADR-045 CA-inline; ADR-018 empirical-verification). Strong here.
- **Feeds:** A: raises CoD User-Business-Value and Risk-Reduction (an ADR-pinned defect is a contract breach). B: pushes toward Must (contractual obligation already decided).

### PDR linkage
- **Definition:** Whether the item realizes or is bounded by a Product Decision Record (committed product intent).
- **Derivation:** Regex pdr[-\s]?\d / \bpdr\b over title+description. 7/50 rows (e.g. PDR-002 roles-as-subagents, PDR-011/ADR-018). Sparser than ADR.
- **Feeds:** A: raises CoD User-Business-Value / Opportunity-Enablement (delivers committed product intent). B: Must/Should anchor — PDR-committed work is rarely Could.

### Scenario-pin relationship (@scenario_hash)
- **Definition:** Whether the item pins, supersedes, or depends on canonical Gherkin scenarios via @scenario_hash, i.e. how contract-coupled and how well-specified the work is.
- **Derivation:** Regex scenario_hash | @[0-9a-f]{6,} | \bpin | \bhash over title+description; also issue_type=feature with 'author ... Gherkin' (e.g. lead-cl1u). 31/50 rows carry a pin/hash/scenario signal. Reconcile/register items (lead-igzz, lead-eipz) are register-coupled.
- **Feeds:** A: a pinned/well-specified item gets a SMALLER Job-Size (spec reduces uncertainty); unpinned-but-needed raises Risk-Reduction CoD. B: scenarios already pinned => Must (commitment exists); 'author new scenarios' => Should unless a Must CoD overrides.

### Work nature — new-capability vs bug vs maintenance/reconciliation
- **Definition:** Classifies the unit as truly-new work (new vehicle/capability), a defect fix (pinned capability broken), or flat maintenance/reconciliation/hygiene/doc — the shop-system message-type discriminator (assign_scenarios / request_bugfix / request_maintenance).
- **Derivation:** issue_type (feature=13, bug=15, task=21, chore=1) + title bracket tag ([bug], [PO]=author/new, [architect], [delivery], [product-decision]) + keywords (new vehicle/capability/author=32 hits; reconcile/maintenance/hygiene/refactor=32 hits).
- **Feeds:** A: sets which CoD component dominates (bug => Time-Criticality/Risk; new-capability => Value/Opportunity) AND informs Job-Size (new vehicle larger than a maintenance touch). B: Must/Should/Could lean (broken-contract bug => Must; hygiene => Could).

### Cost-of-Delay class (blocks-adopters vs hygiene/foot-gun)
- **Definition:** The qualitative severity of NOT doing the work: hard adoption-blocker / silent-correctness foot-gun / security posture, versus cosmetic or convenience hygiene. This is the heart of the CoD numerator.
- **Derivation:** Keyword tiers over title+description: TIER-HIGH = block|adopter|bootstrap|stale|recurs|silently|security (34/50 hit at least one); TIER-MID = foot-gun|ambiguous|misdirects; TIER-LOW = doc|refactor|hygiene|view/surface. E.g. lead-z3e2 'RECURS on fresh bootstrap', lead-al1r 'structurally wrong seed', lead-x4mk 'starter is STALE' => adopter-blockers; lead-7w0w 'silent foot-gun' => mid.
- **Feeds:** A: the dominant input to Cost of Delay (User-Business-Value + Time-Criticality). B: blocks-adopters => Must; foot-gun => Should; hygiene => Could/Won't.

### Effort / Job Size (ESTIMATED)
- **Definition:** Relative size of the unit of work — the WSJF denominator. No native field exists; it must be estimated.
- **Derivation:** There is NO story-point/estimate field in bd. Proxy estimate from: description length/complexity, issue_type (new feature/vehicle > bug > task/chore), dependency_count (more upstream coupling => larger), and whether scenarios are already pinned (pinned => smaller, well-bounded). Standardize on a modified-Fibonacci relative scale: 1,2,3,5,8,13.
- **Feeds:** A: the Job-Size denominator (WSJF = CoD / Job Size). B: not a primary input, but oversized items flagged for work-splitting before a Must commitment.

### Dependency / blocker leverage (dependent_count + blocks edges)
- **Definition:** How many other backlog items this one unblocks — its enabling leverage. High-leverage upstream items deliver Opportunity-Enablement CoD even when their own direct value is modest.
- **Derivation:** dependent_count field (7/50 rows >0, all dep_cnt=1 here) and dependencies[].type='blocks' (22 blocks edges across 23 rows with non-empty deps). E.g. lead-igzz, lead-al1r, lead-l7uz, lead-qhp9 each unblock a downstream item.
- **Feeds:** A: raises CoD Risk-Reduction/Opportunity-Enablement proportional to dependent_count. B: sequencing — a blocker of a Must is itself effectively Must (must-precede).

### Upstream-blocked / schedulability
- **Definition:** Whether the item is itself waiting on unfinished prerequisites (or status=blocked), making it ineligible to start now regardless of WSJF rank.
- **Derivation:** status field (1 row 'blocked', 11 'in_progress', 38 'open') + dependencies[].type in {blocked-by(2), discovered-from(9)} + dependency_count (14/50 >0). An item with an open depends_on is not 'ready' (cf. bd ready showing 10 of 38).
- **Feeds:** A: gates WSJF execution order (compute the score, but defer scheduling until unblocked). B: a blocked Must stays Must but is sequenced behind its unblocker; informs Won't-this-cycle.

### Conflict / supersede / mutual-exclusion
- **Definition:** Items that overlap, supersede, or contend with another item (cannot both land as-is, or one refutes the other).
- **Derivation:** dependencies[].type in {related(3), relates-to(2), parent-child(1)} + supersede/refute/drift language in description (e.g. lead-oxd8 'supersede refuted approve-claude pin', lead-y6gu 'Re-scope drifted RETIRE/REVISE'). Cross-reference title clusters (the approve-claude/credential family: lead-al1r/z3e2/p83k/lu91/oxd8/igzz).
- **Feeds:** A: collapse conflicting items to avoid double-counting CoD; pick the superseding one. B: the explicit source of 'Won't' (the refuted/superseded member) and of Must-grouping (the family that must land together).

### Stated Priority (P1/P2/P3)
- **Definition:** The product authority's already-recorded coarse priority — a prior to calibrate estimated CoD against, not a substitute for it.
- **Derivation:** priority field: P1=11, P2=35, P3=4. Used to sanity-check derived CoD ranking (a derived WSJF that buries a P1 or elevates a P3 gets re-examined).
- **Feeds:** A: calibration prior / sanity check on the CoD estimate. B: primary anchor for the Must (mostly P1) vs Should (P2) vs Could (P3) initial banding, then adjusted by CoD-class and contract linkage.

### Cost-of-Delay decomposition triad (Value / Time-Criticality / RR-OE) — ESTIMATED
- **Definition:** The three SAFe CoD sub-scores that sum to the WSJF numerator: User-Business Value, Time Criticality (decay/urgency), and Risk-Reduction & Opportunity-Enablement.
- **Derivation:** Each sub-score is ESTIMATED by mapping the structured signals above onto a relative scale: Value <- ADR/PDR linkage + CoD-class + Priority; Time-Criticality <- recurs/silently/security/bootstrap keywords + age; RR/OE <- dependent_count + 'enables/unblocks' language. No native numeric field exists. Standardize each sub-score on modified-Fibonacci 1,2,3,5,8,13; CoD = sum of the three.
- **Feeds:** A: IS the Cost-of-Delay numerator (CoD = Value + TimeCrit + RR/OE). B: secondary — the Value and Time-Criticality reads reinforce Must vs Should banding.

## Data sufficiency

- **Verdict:** A (WSJF/CD3): PARTIALLY sufficient — exercisable only WITH disciplined estimation. The backlog gives rich, structured CoD-class signal (priority, issue_type, ADR/PDR linkage, scenario pins, dependent_count, blocks edges, keyword severity) so the Cost-of-Delay NUMERATOR can be estimated defensibly. But there is NO native effort/story-point field, so the Job-Size DENOMINATOR is wholly estimated — and CoD itself has no numeric source, only inferable signals. Faithful WSJF is achievable as a RELATIVE ranking, not an absolute time-denominated CoD. B (MoSCoW): SUFFICIENT. MoSCoW is categorical and the data supports every band directly: Must <- P1 + ADR/PDR-pinned + blocks-adopters CoD-class + already-pinned scenarios; Should <- P2 + foot-gun/mid CoD; Could <- P3 + hygiene; Won't <- superseded/refuted/conflict signals (e.g. lead-oxd8 supersedes lead-al1r's refuted pin) + stale low-priority. No estimation strictly required, though effort feeds an optional capacity check.
- **Gaps:** Cannot populate from data, must estimate or flag: (1) Effort/Job Size — no story-point/estimate field anywhere in bd; pure estimate. (2) Business value in any currency/revenue terms — this is an internal framework product, so 'value' is adoption-enablement, not money; no quantitative field. (3) Reach (RICE-style user count) — genuinely absent; 'how many adopters affected' is only coarsely inferable from 'blocks-adopters'/'bootstrap' keywords, not counted. (4) Confidence — no field; must be assigned by the estimator. (5) comment_count is 0 for all 50 rows and assignee/owner are near-constant (David Stenglein / dave@missingmass.io) — these carry NO discriminating signal and are excluded. (6) 2/50 rows have empty descriptions — those lean on title-only signal and get lower estimation confidence. (7) 'blocks-adopters vs hygiene' is keyword-INFERRED, not a structured field, so the CoD-class is qualitative and should be spot-checked by reading the description.
- **Estimation method:** Standardized so both Apply passes are reproducible. SCALE: modified-Fibonacci {1,2,3,5,8,13} for every estimated quantity. (A) Cost of Delay = User-Business-Value + Time-Criticality + Risk-Reduction/Opportunity-Enablement, each scored on the Fib scale via fixed rubrics: Value anchored by ADR/PDR linkage + CoD-class + Priority (P1 floor 8, P2 floor 3, P3 floor 1); Time-Criticality anchored by recurs/silently/security/bootstrap/stale keywords (any HIGH-tier keyword => >=8) plus age; RR/OE = 1 baseline, +1 Fib step per dependent_count and per explicit 'enables/unblocks' phrase. Job Size on the Fib scale: maintenance/doc=1-2, simple bug=2-3, contract bug=3-5, new vehicle/capability author=8-13; +1 step per dependency_count coupling; -1 step if scenarios already pinned (well-specified). WSJF = CoD / Job Size, ranked descending; ties broken by dependent_count then age. (B) MoSCoW rubric: Must = P1 OR (ADR/PDR-pinned AND blocks-adopters CoD-class) OR unblocks a Must; Should = P2 with foot-gun/mid CoD; Could = P3 / hygiene; Won't = superseded/refuted/conflict member OR stale low-priority. Confidence tag {High = structured fields agree, Med = keyword-inferred, Low = empty-description/title-only} attached to every estimated row so low-confidence ranks are revisited. Calibration guard: any WSJF order that buries a P1 below a P3 is re-examined against the priority prior before being accepted.
