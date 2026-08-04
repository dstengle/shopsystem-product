# Rebaseline Bill (draft for authority review)

**Instrument.** intent-013 Phase 1: re-founding of the shopsystem-product corpus. This is the single decision document for the sitting — ratifying it disposes all 108 decision records, fixes the archive mechanism, and opens the rewrite sequence. Assembled from seven read-only census lanes (probes 2026-08-03/04; nothing under /workspace modified). Source tags used throughout: [census] decision-family census · [live] live-mechanism map · [kinds] kind/field census · [scen] scenario-retirement lane · [tool] tooling-compatibility lane · [arch] archive-mechanism lane · [raci] RACI evidence pack. Headline counts (69 ADRs, 39 PDRs, 25 briefs, 11 candidates, 14 intents, 15 sessions, 291 feature files, 141 knowledge-dir hashes, pdr-039 `proposed`, adr-072 `rejected`) were re-verified against the live tree at assembly.

**Governing caveat.** The bill applies pdr-039 R1–R11 in spirit as directed. pdr-039 itself is `status: proposed` and its acceptance is on hold per the authority's rewind-evaluation comment (bd lead-jozud, 2026-08-04 19:59); its machine-tagged rules are queued, not enforced — no figure below is a gate result [kinds].

**Headline totals** (held consistent across all sections):

| Measure | Value | Source |
|---|---|---|
| Decision records censused | 108 = 69 ADR + 39 PDR | [census] |
| Dispositions proposed | 86 KEEP-REWRITE · 11 RETIRE · 5 AUTHORITY-CALL · 6 already-terminal | [census] |
| Collapse target (R7) | 86 keepers → 32–38 rewritten records | [census] |
| Typed instances, all 8 kinds | 174 | [kinds][tool] |
| R4-stale records terminal-stated by these dispositions | 41 (16 proposed ADRs + 25 proposed PDRs) | [census][kinds] |
| Scenario hashes retiring | 153 across 30 files (141 shopsystem-knowledge / 12 shopsystem-templates) | [scen] |
| Pre-modernization appendix mass leaving | 45.5% of typed-corpus bytes (1,509,299 / 3,316,804 B across 118 files), zero inbound references | [arch] |
| Verified-live mechanism families | 8 (plus 2 code defects, neither decision debt) | [live] |
| Archive mechanism recommended | in-repo `archive` branch + snapshot tag (option b) | [arch] |
| Authority sittings to land Phase 1 | ≈13–16 at the 3-artifact cap | §8 |

**Accounting note.** The 86 KEEP-REWRITE includes pdr-039 itself, which is not re-dispositioned here: it is the governing instrument, grows only by ratified-iteration changelog, and flips to `accepted` at loop exit [census]. 85 records ride the family rewrites of §1; pdr-039 rides the doctrine loop.

**Lane disagreements (reported, not smoothed).**

1. Branch-era ADR count: 17 by git first-commit [census] vs 15 by frontmatter `created` [kinds]. The delta is exactly the two falsified dates on adr-058/adr-062; git is the truer measure.
2. Committed origin-index size: 121 ids [live] vs 112 ids [scen] vs 97 by its own header (53+29+15) [tool]. All three agree on what matters: stale since 2026-07-04, missing every later record and all cand-* ids.
3. features/ @origin contents: [arch] states @origin tags reference bead ids, not adr/pdr ids; [census], [tool], and [scen] document adr/pdr/brief @origin citations with command evidence (`E_UNKNOWN_ORIGIN: adr-068` reproduced live). Both id classes exist in the tree; the bill's origin-index numbers (§5–6) rely on the three-lane reading.
4. Skill count under .claude/skills/: 29 poured [census] vs 37 total (9 CANONICAL + 6 LOCAL-marked + 22 unmarked) [tool] — different counting scopes; both reported.
5. Typed-corpus size: 174 [kinds][tool] vs 173 [arch, and the authority's own quantification] — one record opened between probes; [arch]'s appendix percentages are computed on 173.
6. KEEP-REWRITE PDR count: 28 in the [census] totals table vs 27 by family enumeration plus pdr-039 carried as instrument — resolved by the accounting note above.
7. Corpus-wide hash-tag total: 1,086 [census] vs 893 line-anchored `@scenario_hash:` tag lines at assembly recount (1,027 unanchored, which includes in-step-text mentions). Method unresolved. The load-bearing retirement counts (141 knowledge / 12 templates) reproduce exactly under the anchored method, so §5 is unaffected.

## 1. The kept bones — verified-live mechanisms and their grounding decisions (keep-rewrite set, with what each rewritten record covers, collapsed per R7)

**What is verifiably alive** — all probes run on this host, read-only [live]:

| # | Mechanism | Probe evidence | State |
|---|---|---|---|
| 1 | shop-msg mailbox protocol + registry (0.4.6) | 14 subcommands; DB reachable; `watch` held LISTEN (READY, exit 124 at timeout); heartbeat table live; postgres container healthy | LIVE |
| 2 | bd work tracking (1.1.0) | 1,163 issues: 183 open / 19 in-progress / 12 blocked / 959 closed / 171 ready | LIVE |
| 3 | scenarios hash + validate (0.3.1) | hash deterministic (`4a43ba52eaa6f4f6` reproduced); `validate --aggregate` RED on both index paths (76 violations bare / 35 with committed index) | mechanism LIVE, reference data drifted (§6) |
| 4 | bc-container lifecycle (0.3.66) | manifest valid, 7 entries; templates + lead containers running on published bc-base images | LIVE, health anomaly (docker-unhealthy vs heartbeat-online — §3 ruling 9) |
| 5 | agent-vault brokerage | broker container healthy 27h; CA committed and trusted; doctor broker line PASS | LIVE |
| 6 | shop-templates pour + writing-skill gate (0.55.0) | list/show/bootstrap/update work; `check-writing-skills --target /workspace` PASS 8/8 kinds | LIVE |
| 7 | shop-knowledge (0.1.0) | validate / template / schema / navigate / single-facet query / render-md / gate all green; gate reports "no coherence findings" both modes | SPLIT: 6 surfaces live, 2 broken (below) |
| 8 | bin/ pre-commit gate | symlink installed to `bin/check-knowledge-artifacts`; both underlying commands verified; recent commits landed through it | LIVE (R100 blind spot — §6) |

**Code defects found — not decision debt; they fold into rewrite dispatches, not this bill's dispositions** [live][scen]: shop-knowledge multi-facet query (last-facet-wins, earlier facets silently discarded); `render --format json` crash (`TypeError … date` at knowledge/cli.py:322; bead lead-uypj5); `--help` broken (lead-wnrvo); writing-skill per-kind-fact divergence, 7 of 8 kinds (lead-8xgdq); ADR-070 D2 amendment frozen (lead-o7qww).

**The keep-rewrite set.** 86 keepers (58 ADR + 28 PDR incl. pdr-039 per the accounting note) collapse to **32–38 rewritten records** [census]. Per family — members, target record count, what each rewritten record covers, and its live grounding:

| Family | Keepers (n) | → | Each rewritten record covers | Live grounding (probe-verified) |
|---|---|---|---|---|
| F1 Genesis | adr-001 (1) | 0 | folds into F2's fleet record | bc-manifest.yaml lists exactly the 4 live BCs |
| F2 BC fleet lifecycle | adr-004/005/021/022/038/039/041/063 + pdr-004/006/026/028 (12) | ~4 | (1) fleet registry + identity [001+004+005+038+pdr-004/006]; (2) image build/publish/provenance [021+022+039+pdr-026/028]; (3) launch diagnostics [041]; (4) model mapping [063 — verification is bc-launcher's work_done per ADR-018] | bc-container 0.3.66; manifest header cites ADR-005/056-D10/028; 76 @bc:shopsystem-bc-launcher scenarios; running containers on published ghcr.io bc-base images |
| F3 Messaging/dispatch | adr-006/009/010/011/012/013/014/015/016/017/020/027 + pdr-007/009/010/029 (16) | ~5 | (1) addressing + registry [006+020+pdr-007/009]; (2) bd↔msg integration + atomicity [011+012+013+016+017+pdr-010]; (3) liveness [014+015]; (4) clarify resolution [009+010+027 — **must re-verify**: `clarify_response_in_band_answer.feature` suggests the primitive adr-009 deferred later landed; verify current vehicle against messaging's work_done before re-authoring]; (5) vehicle catalog [pdr-029] | strongest grounding in corpus: shop-msg subcommand set maps 1:1; 58 scenarios; this lead's own session-start watcher is the LISTEN/NOTIFY mechanism |
| F4 Scenario integrity | adr-019/024/025/056/060/064 + pdr-015 (7) | ~4 | (1) canonicalization + hash [019+060]; (2) scenario schema + DONE gate [056 — **mandatory rewrite**: bundles ~10 decision items, R2/R5/R7 fail signals, most origin-cited record (23 features)]; (3) completion journal [024+025+pdr-015 — 024's sc06-deferral clause is an R1 scrub]; (4) retirement convention [064 — terminal-state it; it is the citation target this bill's own retirements ride] | scenarios 0.3.1 carries hash/verify/validate/journal/consolidate; journal features pinned; adr-064 cited by bc_emit_work_done_retirement_removal.feature |
| F5 Empirical verification | adr-018 + pdr-011 (+pdr-005 → F6) (3) | 1 | the ADR-018 discipline record [018+pdr-011 collapsed] | quoted verbatim in the live primers; pinned by 2 @origin:adr-018 features; binds this very census |
| F6 Roles / PM | pdr-001/002/027/033 (4) | ~2 | (1) role system [pdr-001/002/005]; (2) PM mode [pdr-027/033]. **Content blocked on lead-jozud.2 (§8)** | router pattern is this session's operating mode; agents poured; PM-mode + empty-repo trigger are live standing rules; `shop-templates show lead-pm` works |
| F7 Spike/experiment | adr-029/030/031/032/065 + pdr-016 (6) | ~2 | (1) spike lifecycle [029+030+031+032+pdr-016 — **029 mandatory**: doctrine-loop packet 1 adjudicated it "nothing to like"; the rewrite must not fork from the loop record]; (2) findings-authority + archive rule [065 — candidate to merge into rebaseline doctrine itself] | 8 pinned spike-lifecycle scenarios @origin:pdr-016; findings/archive/ practiced — the very principle this bill generalizes |
| F8 Templates/pour/skills | adr-036/037 + pdr-003/014/023 (5) | ~3 | (1) pour/provenance/update [pdr-003/014/023]; (2) CLI-layer-vs-prose enforcement [036]; (3) spec distribution [037] | shop-templates 0.55.0; 167 @bc:shopsystem-templates scenarios (largest pinned surface); provenance markers live across poured skills |
| F9 Credentials/agent-vault | adr-026/028/045 + pdr-022 (4) | ~2 | (1) broker architecture [026+028+pdr-022]; (2) CA/credential transport [045 — realized at bin/shop-shell:74 by name; needs terminal state per R4] | broker healthy; agent-vault-ca.pem committed; this sandbox's own proxy-credential model is the mechanism |
| F10 Bootstrap/Footing/ops | adr-040/043 + pdr-020/021/024 (5) | ~3 | (1) Footing/bootstrap [040+043+pdr-021]; (2) lead shell [pdr-020, ± adr-046 per §3]; (3) doctor/ops [pdr-024] | ~30 bootstrap_* features; adr-043 2nd-most origin-cited (6); this lead session runs inside the pdr-020/021 shell; bin/doctor exists |
| F12 Fabro substrate | adr-048/049/050/051/057/058/062 (7) | ~3 | (1) substrate + parity boundary [048+050]; (2) loop graph + reactive watcher [051+058]; (3) pour projection + cross-runtime anchor [057+062]; 049 may fold into F9's credential record. **6 of 7 stuck `proposed` while realized — R4 terminal-stating mandatory; recover true dates from git** | fabro CLI installed and pinned into bc-base; poured .fabro/ defs pinned; the running BC containers are launched by this stack |
| F13 Dagger build | adr-052/053/054/055 (4) | ~2 | (1) build substrate + no-divergence [052+053]; (2) build-egress credentials + CA trust [054+055]. Lead-side confirmation is the BC's work_done (dagger absent from lead host by design, correct per ADR-018) | 4 pinned features in features/dagger-ci/, each @origin-cited; dogfood instance in the shop-msg registry |
| F14 Knowledge/typed-artifact | adr-067/068/069/070/071 + pdr-035/036/037/038 (9; pdr-039 carried as instrument) | ≤5 | Phase 1's own scope, per R7 supersession-must-simplify. **adr-067 mandatory rewrite** — on record (pdr-039 Consequences) as accepted-in-violation-of-R10, forks transferred to Phase 1; adoption of its D2/D4/D5/D6 field surface is zero (§4). **Blocked on lead-jozud.2 + the kind ruling (§3 ruling 6)** | shop-knowledge 0.1.0 verbs live; gate green; 27 pinned feature files; 8 write-* skills poured; check-writing-skills PASS — these branch-era records demonstrably ground live behavior and rebut the branch retirement presumption [live] |
| F15 Licensing/ingestion | adr-061/066 (2) | 1 | licensing doctrine + grant register [061+066 collapsed; the BC-enforcement deferral clause is an R1 scrub] | the deanpeters-derived PM skills the grant covers are poured and in active use |
| F11 System BOM | — (0 keepers; adr-047 + pdr-030 are §3 authority calls) | 0–1 | rides §3 ruling | pinned but unrealized: neither system-manifest.yaml nor bin/system-manifest exists |

**Side effects the keep-rewrite set carries** [census]:

- Every disposition simultaneously terminal-states its member: the 41 R4-stale records (16 proposed ADRs + 25 proposed PDRs, most non-terminal 1–3 months) get terminal states as part of this bill.
- Metadata recovery: 13 ADRs (045–055, 058, 062) carry false `created: 2026-05-11` (git first-commit 06-27–07-14); adr-058/062 additionally embed "Accepted …, David" inside their titles while status stayed `proposed` — acceptance never landed. Rewrites recover true dates and states from git.
- Origin-tag load-bearing set: 32 distinct decision ids are @origin-cited in features/ (adr-056 ×23, adr-043 ×6, then adr-018/019/022/028/049/057, pdr-003/022/023 ×2 each, 21 single-citation ids). Retirement of any cited id must re-point or ride adr-064 — see §3 ruling 5 and §5.

## 2. The retire set — decision families leaving the active view (with per-family one-line reasons; totals)

RETIRE = archived with **no successor record**. (Under rewrite-forward plus the archive branch, all 108 originals leave the active tree; the 86 keepers leave with successors per §1, these 11 leave without, 5 await §3.) Source: [census].

| id | family | status today | One-line reason |
|---|---|---|---|
| adr-008 | F1 genesis | accepted | `shopsystem-docs` BC is a dead letter — no @bc:shopsystem-docs tag anywhere, not in the manifest |
| adr-023 | F4 scenario integrity | proposed | superseded-in-fact by adr-025, which derives-from it and re-homed the journal |
| adr-042 | F8 templates | proposed | a work-item/status-correction record — an R1 non-decision; its one open leg (retro-retiring prose pins 105–116) converts to a bead before the record leaves |
| pdr-900 | F1 genesis | accepted | self-described "Legacy: … synthetic grounding" — historical only |
| pdr-012 | F6 roles/PM | proposed | PM half superseded-in-fact by pdr-033 (which derives-from it); structurizr half carried into the F6 roles rewrite |
| pdr-013 | F6 roles/PM | proposed | three-tier-ADR half died with adr-034/035 → adr-067; decomposition half lives as the poured work-splitting skill |
| pdr-017 | F9 credentials | proposed | intent framing, consumed by the standup |
| pdr-018 | F7 spike | proposed | one-shot MVP gate, consumed — findings/independent-mvp-review-2026-06.md exists |
| pdr-019 | F10 bootstrap | proposed | decomposition/dispatch plan, consumed |
| pdr-025 | F9 credentials | proposed | unrealized as named — no bin/agent-vault-approve-claude exists; bin/ carries agent-vault-provision + agent-vault-check instead |
| pdr-034 | F14 knowledge | proposed | superseded-in-fact — intent-013's REBASELINE replaces the migration approach it proposed; R4 needs it terminal |

**Already terminal — noted, not re-disposed (6):** adr-034, adr-035, adr-059 (superseded by adr-067); adr-072 (rejected — first R1/R2 rejection under the doctrine); pdr-031 (rejected); pdr-032 (superseded by the pdr-035/037 line).

**Totals:** 11 RETIRE (3 ADR: 008, 023, 042; 8 PDR: 900, 012, 013, 017, 018, 019, 025, 034) + 6 terminal = 17 records leave with no successor. 86 + 11 + 5 + 6 = 108 ✓.

**Safety fact:** no RETIRE candidate is @origin-cited by any feature [census]. The one origin-cited doubtful record (adr-002) was deliberately routed to §3 for exactly that reason.

**Orphan carries created by this set:** (a) `lead_architect_structurizr_workspace.feature` — structurizr/ untouched since git 2026-07-14; its half of pdr-012 must be carried into the F6 roles rewrite or its scenario retired via adr-064; (b) decomposition discipline now lives only in the poured work-splitting skill — the F6 rewrite must cite or re-home it; (c) adr-042's open leg becomes a bead (above).

## 3. Authority calls — dispositions only the authority can make (each framed as a real choice with its consequence)

**Part A — the five record dispositions** [census][live][tool]:

| Record | The contested fact | Choice A → consequence | Choice B → consequence |
|---|---|---|---|
| adr-002 (harness BC; accepted) | `features/test-harness/shop_test_harness.feature` is pinned @origin:adr-002, but owner shopsystem-test-harness is not in the live-BC set — a pinned scenario with no live owner | KEEP as intent → name the realization and owner per R10 | RETIRE → the bill's only origin-cited retirement; its pinned scenario retires via the adr-064 convention |
| adr-033 (BC-local architect; accepted) | Zero pinned features name the role anywhere; the pinned fabro loop graph (adr-051) is Implementer→Reviewer only with `emit_r` sole emitter — the role appears never realized | RETIRE as superseded-in-fact by the I→R loop → F6/F12 rewrites state the two-role loop as the contract | KEEP as unrealized intent → R10 requires naming the realization work |
| adr-046 (shop-shell exemption override; proposed) | Its title claims to OVERRIDE adr-028's framework-image exemption, but live bin/shop-shell:37–39 still describes shopsystem-bc-lead under "the same exemption" — record and as-built contradict | KEEP and realize → templates-BC dispatch changes shop-shell; F10's lead-shell record states the override | RETIRE → as-built wins; F10's record states the surviving exemption rule |
| adr-047 + pdr-030 (system BOM; proposed) | Scenarios pinned (features/system-manifest/, @origin:adr-047) but system-manifest.yaml and bin/system-manifest do not exist — pinned yet unrealized | KEEP → collapse 2→1 rewritten record and name the realization work (R10); F11 target becomes 1 | RETIRE → pinned scenarios retire via adr-064; F11 target stays 0 |
| adr-067 path (accepted-in-violation-of-R10 on record) | Grounds verified-live behavior (CLI shipped) yet its D2/D4/D5/D6 field surface has zero adoption across 174 instances (§4), and pdr-039 records the R10 violation | KEEP-REWRITE carrying only the adopted pairs → the R7 simplification; unadopted fields die with the original (§4 drop list) | KEEP the full surface → must name the adoption work for tags/distribution/external-references/references, none of which any instance carries |

**Part B — structural rulings the bill cannot proceed past.** Each is a genuine user-judgment choice surfaced by a lane; none follows from contract or defaults.

| # | Ruling | The choice and its consequence |
|---|---|---|
| 1 | Archive mechanism | Ratify option (b), in-repo `archive` branch + tag (§7 recommendation). (a) subdir leaves 100% of the mass grep-reachable behind an instruction — the soft-rule class this shop's own records show failing; (c) separate repo buys marginal isolation (main history retains the mass regardless) at the highest standing cost [arch] |
| 2 | Mass-retirement provenance home | adr-064 D2's provenance-comment convention assumes a surviving file; wholesale file archival leaves no in-file home. Archive branch + this bill as the provenance record, or per-file stubs — noting the gate has **no duplicate-id detection** (probe P4), so stubs carry silent-collision risk [scen][arch] |
| 3 | derives-from anchoring for re-authored keepers | The adr schema requires non-empty `derives-from` resolving in the active corpus, and the distribution gate BLOCKS on any frontmatter edge to an archived id (1 archived record → 3 blocking findings, empirical). Root keepers in the intent-013 → pdr-039 chain (zero CLI change), or dispatch the knowledge BC to relax archived-lineage edges [arch][tool] |
| 4 | Lineage-in-prose (R6) | Archived lineage is unrepresentable in frontmatter without going red; prose/changelog citations are gate-invisible (probe P3). Rule whether prose citation satisfies R6's "lineage lives in frontmatter edges" for archived ancestors [arch] |
| 5 | Origin-index / keeper-id continuity | Regenerating the index against the new active set turns every feature pinning a retired origin red (~49 refs: adr-056 ×23, brief-001 ×19, adr-043 ×6). Re-author keepers under the SAME ids (features stay green) vs new ids + re-originate features (a much larger scenario bill). Also rule: legality of archived ids as @origin on surviving scenarios, and whether cand-* joins the legal set (cand-005 used ×5; the generator never emits cand-* ids) [tool][scen][live] |
| 6 | Kind set M | Which of candidate / intent-record / prioritization-record / current-state survive (input: lead-jozud.2, §9). Gates 23 KIND-CONDITIONAL hashes + 11 lead_pm_template hashes (§5) and decides whether the two-BC coordinated dispatch fires at all — active-tree-only with an unchanged kind set needs **zero CLI changes** [scen][tool][kinds] |
| 7 | `distribution` field voiding | adr-067 D5 declares it required on every instance; 0 of 174 carry it and the validator does not enforce it. Rule whether that voids part of the accepted record or is re-decided in the F14 rewrite [kinds] |
| 8 | Container-health authority | Both BC containers are docker-`unhealthy` while shop-msg heartbeat reports templates online (22s). Which contract defines "BC is up" — needed before rebaseline dispatches rely on BC liveness [live][census] |
| 9 | Auto-commit mechanism | 73 timestamp-message commits touch corpus files; the driver is off-host and unidentified, and whether it runs the pre-commit hook is unverifiable from this host. Confirm and disable during the archival window, or accept the risk of a half-moved-tree snapshot bypassing the gate [tool] |
| 10 | bd memories + .specstory | 66 session-start memories inject retired-era framing (e.g. the PDR-032 object-graph memory) and 22 committed transcripts stay grep-reachable regardless of file archiving. In-bill curation pass (recommended by [arch] — otherwise the poison-prevention claim is hollow) vs separate work |
| 11 | legacy_brief_ceiling = 15 | Baked into the knowledge BC (coherence.py:134): if new briefs renumber from 001, the first 15 are silently exempt from the candidate-anchor check. Dispatch to zero it, or number new briefs above 15 [tool] |
| 12 | Pre-existing scenario-origin red | doctor check 4 is red today for reasons independent of the rebaseline (phantom `.scenarios/origin-index` path, renamed-dir validator defaults, gen-scenario-refs regenerating an empty index). Ride this bill or declare out of scope [tool][live] |
| 13 | skills_provenance_marker exclusion | Recommended KEEP outside the scenario retirement set (pre-branch pdr-023; grounds live pour behavior). Confirm inclusion or exclusion [scen] |
| 14 | Archive grep-exposure hardening | Instruction text is the only mitigation for free-form Grep/Read reaching archived content under any option; whether a harder mechanism (e.g. a poured deny rule) is wanted is a RACI-adjacent call [tool][arch] |

## 4. Kind and field baseline — the empirical day-1 kept-kind/kept-field candidate, RACI-dependent items clearly marked

All figures from the 174-instance census [kinds] (gate probes run on a scratch copy, never /workspace).

**Instance and status reality per kind:**

| kind | n | status distribution | The telling fact |
|---|---|---|---|
| adr | 69 | accepted 49, proposed 16, superseded 3, rejected 1 | most load-bearing kind by every measure (1,479 inbound mentions; 30 ids feature-cited) |
| pdr | 39 | proposed 25, accepted 12, rejected 1, superseded 1 | content proven, status machine broken: 64% never left `proposed` |
| brief | 25 | draft 20, ready 5, delivered 0, withdrawn 0 | 2nd-most feature-grounded content; terminal statuses never once used in 25 instances |
| candidate | 11 | shaped 5, committed 6 | 4 of 6 schema statuses never used; shaped→committed arc is real |
| intent-record | 14 | recorded 14 | honest single-status design; head of the provenance spine (13 edges target intents) |
| session-record | 15 | closed 14, open 1 | proven by consumer: the PM-mode exit gate requires produced/revised |
| current-state | 1 | current 1 | proven by gate: `unincorporated-decision` is a working check |
| prioritization-record | 0 | — | full ceremony: typedef + 2 skills exist, **zero instances ever**; the one real prioritization (2026-06-30) predates the kind, untyped in findings/ |

**Day-1 field baseline (empirical):**

- **Carry, universal (100% populated on all 174):** `type, id, title, status, created, updated, authors, description`.
- **Carry, edges (consumer-verified):** `derives-from`/`derived-by` — 361 edges, 100% reciprocal, 0 dangling, consumed by gate and navigate (defect-planting probes fired red); `supersedes`/`superseded-by` — 5 pairs, gate-checked, R6-required. These two pairs are the entire working graph. ([tool] counts 867 edges across all 11 link fields, 482 targeting adr-* — a different measure, both correct.)
- **Carry, kind-scoped (not base):** `incorporates` (current-state only; 61 ids; gate-checked), `produced`/`revised` (session-record only; PM-gate-consumed — note produced covers 100% of intents+candidates but only 6/69 adrs), `candidate` forward link (brief), `session` (candidate/intent), `beads` (17 files, live cross-registry data, currently un-gated).
- **Drop on day 1 (zero or negative evidence):** `tags`, `distribution` (schema-required per accepted adr-067 D5, 0 instances, unenforced — §3 ruling 7), `external-references`, `references`/`referenced-by` (0 instances; the sole attempt was reverted by the authority in commit c893a2f), `experiments` (0/10 nonempty), `mode` (abandoned after 5), `parked-until` (1 use, bypassing the status machine it served), `stakeholder` (all 12 identical: dstengle), `brief` backlink on candidates (1/10; no reciprocity check exists), `superseded-by` on intents (0/12), `beads` on session-records (0/5).

**Headline gap:** only the edge pairs that predate or survived contact with practice carry data; the entire adr-067 D2/D4/D5/D6 field surface shipped (bead lead-qa76u closed) with **zero adoption** — and adr-072, the decision on how those fields get written, is the corpus's only rejected ADR.

**RACI-DEPENDENT — census data supplied, decision reserved for lead-jozud.2 (§8, §9):**

- (a) whether adr and pdr remain distinct kinds — schemas differ only by `decision-makers` + the "Options considered" section; status sets identical; field usage near-identical;
- (b) whether `decision-makers` survives — all 45 values are `[dstengle]`; informative only under a multi-seat RACI outcome;
- (c) which kind owns the brief→BC dispatch handoff — decides whether brief's dead delivered/withdrawn states get real transitions or get cut;
- (d) survival of the PM-arc kind family (candidate/intent/session) as separate kinds vs collapse — 90%+ branch-era, yet the PM system's own record;
- (e) re-homing of pdr-039's rules per kind (flagged in pdr-039's own Consequences).

**Hygiene facts for the bill:** the real corpus is gate-clean ("no coherence findings"); one latent dangle the gate cannot see (`sess-2026-07-19-a` `revised: [current-state]` — pre-versioning singleton name, resolved by basename match, a tooling blind spot to confirm with the BC); features/ cites two nonexistent ids (adr-999 ×3, apparently a planted-defect sentinel — confirm, else it is a real dangling reference; brief-042 ×1); the synthetic 900-trio (pdr-900/cand-900/intent-900) inflates three kind counts by one each.

## 5. Scenario retirement set — files, counts, BC obligations, ADR-064 mechanics

**Premise** [scen]: canonicalization is block-only (ADR-056 D4.6/D5), so re-authoring changes every hash — under rewrite-forward, **all 153 current hashes in scope retire mechanically**; the KEEP/REWRITE/RETIRE verdict governs whether a successor scenario is authored, not whether the old hash survives. Caveat: any scenario text kept byte-identical keeps its hash and drops out of the 153.

**Totals (unit = live `@scenario_hash` blocks; knowledge count 141 re-verified at assembly):**

| Bucket | Files | Hashes |
|---|---|---|
| RETIRE, no successor — the rejected pdr-031 L0/L1/L2 + discovery surface (authoring_discovery, single_source_projection, active_digest_generation, distribution_boundary; per-hash lists enumerated in the lane record) | 4 | 15 |
| REWRITE-SMALLER — validate / gate / read-CLI / typedef / writing-skill mechanism survives, re-authored for the smaller kind set (17 knowledge files = 103; writing_skill_template_structure 3 + writing_skill_enforcement 5 + lead_skill_artifact_validation_gate 4 = 12) | 20 | 115 |
| KIND-CONDITIONAL — awaiting §3 ruling 6 (candidate ×3 files = 9, intent-record ×2 = 7, current_state_versioned_schema = 7) | 6 | 23 |
| **Retirement set total** | **30** | **153** |
| KEEP as-is, recommended excluded: skills_provenance_marker.feature (pre-branch pdr-023; grounds live pour — §3 ruling 13) | 1 | 5 |
| Already retired in these files (precedent in place; no action) | — | 2 |
| Secondary, kind-set-sensitive, outside the set: lead_pm_template (11) + lead_primer_product_authority_discovery_gate (1) | 2 | 12 |

**BC notification obligations** (register membership evidenced by closed reconciliations, quoted in the lane record):

| BC | Hashes to retire from its register | Notes |
|---|---|---|
| shopsystem-knowledge | **141** (all knowledge-dir hashes; membership via closed dispatches lead-oji4 (Round-1: 61), lead-mfnt, lead-5msa9.1, lead-x53ez, lead-ptr7a, lead-qa76u, lead-4vvdo/.1, lead-vy38p.1, lead-iohr) | 15 of these retire with no successor; 23 conditional on ruling 6 |
| shopsystem-templates | **12** (8 writing-skill hashes via lead-2lxya + 4 lead_skill_artifact_validation_gate via lead-5msa9.2) | lead_pm_template's 11 join only if ruling 6 drops kinds it names |
| any other BC | **0** — sweep of the remaining 261 feature files found no coupled scenarios | — |

Dispatch-addressing caution: `artifact_schema_cli.feature`, `coherence_gate_lead_installable_cli.feature`, and `lead_skill_artifact_validation_gate.feature` still carry `@bc:unassigned` although closed dispatches verified their hashes into BC registers — **address retirement dispatches from bead evidence, not tags**. Mailbox state verified: lead inbox and outbox both empty; nothing in flight blocks the dispatches.

**ADR-064 mechanics that apply:**

1. **D1** — a retired hash is satisfied only when unreachable by block-only recompute from the as-committed features/ tree; `bc-emit work-done --retire-hash` hard-refuses otherwise (itself pinned by bc_emit_work_done_retirement_removal.feature, whose 2 hashes are NOT in this set).
2. **D2** — delete the Given/When/Then body from the live block region; record provenance (hash, why, successor, original body) in a comment outside any canonical region.
3. **D3** — every retirement dispatch cites ADR-064 D1/D2 by reference, never restated from memory.
4. **Gap** — D2 assumes a surviving file; wholesale archival of 27+ files leaves no in-file provenance home → §3 ruling 2. adr-064 is itself `proposed` and gets terminal-stated in the F4 rewrite.
5. **ADR-056 D10 obligation** — the committed origin-index is stale (`E_UNKNOWN_ORIGIN: adr-068` reproduced live; cand-005 unlisted); post-archive, regenerate via a repaired bin/gen-scenario-refs (currently broken, §6) and apply §3 ruling 5 on archived-id legality. Re-authored scenarios should carry fresh origins, mooting most cases.

**Open beads that fold into the rewrite dispatches** (not fixed against retiring scenarios): lead-uypj5 (render json crash), lead-wnrvo (--help broken), lead-o7qww (ADR-070 D2 amendment, frozen), lead-8xgdq (writing-skill fact divergence). bd hygiene: dispatch children lead-vy38p.1 and lead-4vvdo.1 remain open though parents record work_done consumed — sweep with the epic.

## 6. Tooling compatibility cut — lead-side config edits vs BC dispatches, itemized

**Empirical facts the cut rests on** [tool]:

- **Structural safety:** the shop-knowledge loader family (gate/navigate/render/query/digest) walks a fixed 7-subdir one-level allowlist plus root-level *.md — `archive/` is **never read** (empirically proven with an archived adr-001). Hazard: any root-level file WITH frontmatter silently joins the typed corpus — archive index/README must live inside archive/.
- **Edge closure is the real cost:** dangling-edge is BLOCKING in distribution mode; archiving one record produced 3 blocking findings; the corpus carries 867 link-field edges (482 → adr-*). The keeper set must be edge-closed — rewrite-forward must strip/re-anchor edges, not copy records.
- **R100 hazard:** a pure `git mv` archival commit stages as R100, which the hook's `--diff-filter=ACM` excludes — the move itself runs NO validation and NO gate (empirically verified). The first subsequent gated commit blocks on every dangling edge. Land archive-move + edge-closure as one gated-green series (or sanctioned `--no-verify` checkpoints, hook line 119), and verify with a manual `shop-knowledge-gate --mode distribution /workspace` before declaring done — the hook alone never gates the move.
- **Zero-CLI-change path exists:** active-tree-only with an **unchanged kind set** requires no BC code changes — the loader tolerates absent dirs. Shrinking 8 kinds to M fires **two coordinated dispatches** (below); until both ship, `shop-knowledge validate` still accepts retired kinds, and stale write-<retired-kind> skills linger unpruned (no .provenance marker, not group members — manual deletion; ambient poison until then).
- **Poured-file clobber rule:** CLAUDE.md, .claude/canonical/lead-primer.md, agents, bin/doctor, and all 8 write-* skills are re-poured byte-for-byte by `shop-templates update` — local edits are not a viable vehicle even temporarily. `.claude/shop/primer.md` is the shop-owned pointer surface (and already carries dangling `adr/`/`pdr/` links).
- **Origin surface is already red pre-rebaseline:** doctor check 4 fails (49 unknown origins via the phantom `.scenarios/origin-index` default); validator defaults scan `adr/ pdr/ briefs/` against the renamed `adrs/ pdrs/`; `bin/gen-scenario-refs` scans nonexistent dirs with a stale filename regex and would regenerate an **empty** index today. → §3 ruling 12.

**The ledger:**

| Change | Vehicle |
|---|---|
| Gated-dir regex shrink; add missing `prioritizations/` to the gate; collapse the A-BLOCK/M-WARN legacy tier to always-block | lead-side edit (bin/check-knowledge-artifacts) |
| shop/primer.md re-point at the new active set (and never into archive/) | lead-side rewrite |
| Delete stale write-<retired-kind> skill dirs after the kind-shrink release; advisor-skill text edits if dirs rename | lead-side |
| Rewrite or retire bin/gen-scenario-refs; regenerate origin-index post-archive; DOCTOR_ORIGIN_INDEX env override in .env | lead-side |
| Hook reinstall note: the pre-commit symlink is untracked — fresh clones have no hook; any migration worktree must `ln -sf` it | lead-side |
| Kind-set shrink N=8 → M | **two coordinated BC dispatches**: shopsystem-knowledge (artifact_types.py:244 ARTIFACT_TYPES) + shopsystem-templates (writing_skills.py:54 RECOGNIZED_KINDS / :79 KIND_PRESENTATION) — a kind dropped by one but not the other makes the pour skip it and the gate FAIL it |
| legacy_brief_ceiling=15 zeroing; loader dir renames or new kind dirs; archived-target dangling-edge policy (if §3 ruling 3 chooses relax) | shopsystem-knowledge dispatch |
| lead-primer.md text (carries stale `adr/`/`pdr/` names today), CLAUDE.md body, agents, lead-pm mode body, doctor default paths | shopsystem-templates dispatch |
| Active-tree-only with unchanged kind set | **none** — edge closure + pointer edits above only |

**Unresolved and flagged:** the auto-commit mechanism (73 timestamp-message commits, off-host, hook-bypass unverifiable) → §3 ruling 9.

## 7. Archive mechanism — recommendation with tradeoffs and the poison-prevention checklist

**Recommendation** [arch]: **option (b) — archive branch in the same repo**, executed as:

1. Tag the pre-rebaseline tip (e.g. `pre-rebaseline-2026-08`).
2. Create branch `archive` from it, tree reorganized into the typed-dir corpus layout — proven CLI-navigable as its own corpus root via `--corpus` (probe P5). Push both refs. (Precedent already in-repo: `backup/pre-scrub-2026-05-27`, `pre-pruning`.)
3. One deletion commit on main removes the retired mass.
4. Leave a short `archive.md` pointer in the active tree with the two retrieval recipes: `git show archive:<path>` per file; `git worktree add <path-outside-/workspace> archive` + `shop-knowledge … --corpus <worktree>` for full navigation (the scratch-worktree pattern is already in live use).

**Why not (a) in-repo `archive/` subdir:** the knowledge CLIs were never the leak — they are allowlist-scoped already; the leak is Grep/Read over the checkout, and (a) leaves 100% of the mass in the checkout behind an instruction — the exact soft-rule class this shop's own session records show failing (sess-2026-07-15-a). **Why not (c) separate repo:** main history retains the full mass regardless (no rewrite proposed), so isolation is marginal, at the highest standing cost (second repo, credentials, dual pushes), inverting the one-repo discipline.

**Honest tradeoffs of (b):** deliberate retrieval becomes git-plumbing-shaped (mitigated by the recipe file); the archive branch must **never** be checked out under /workspace — a worktree there re-enters the grep surface; `git grep` across refs still reaches retired text (accepted: that is deliberate, not ambient).

**The 45.5% appendix mass:** `## Source (pre-modernization)` sections in 118 of 173 typed docs = 1,509,299 of 3,316,804 bytes; **zero inbound references anywhere** (grep across all typed dirs, findings, features, .claude). Appendices travel inside their files to the branch; rewrite-forward keepers are new files and simply do not carry them. Nothing to extract, relocate, or index.

**Lane conflict, restated here where it originates:** [arch] asserts features/ @origin tags reference bead ids, not adr/pdr ids; [census]/[tool]/[scen] document adr/pdr/brief @origin citations with live command evidence. Both id classes exist; the bill's §5–6 origin-index treatment follows the three-lane reading. [arch]'s narrower point stands regardless: features/ is outside the knowledge-graph walk, so artifact archiving is invisible to the knowledge CLIs.

**Poison-prevention checklist** (merged [tool] §3 + [arch] interlocks):

| # | Surface | Reads archived content? | Required action |
|---|---|---|---|
| 1 | shop-knowledge loader family | NO (fixed allowlist, proven) | none |
| 2 | bin/check-knowledge-artifacts | NO (regex-anchored to gated dirs) | none |
| 3 | scenarios validate origin dir-scan | NO (fixed roots) | none |
| 4 | Poured agents' `grep … features/` habits | NO, provided archive/ content never lands under features/ | keep archive out of features/ |
| 5 | Committed origin-index | **YES-equivalent** — a static list: retired ids stay legal @origin until regenerated | regenerate post-archive; §3 ruling 5 |
| 6 | Stale write-<retired-kind> skills | **YES** — trigger text invites authoring a retired kind; never auto-pruned | manual deletion after the kind-shrink release |
| 7 | Router free-form Grep/Read | **YES under option (a); NO under (b)** for the working tree; git refs reachable only deliberately | adopt (b); §3 ruling 14 for hardening |
| 8 | Root-level frontmatter ingestion | conditional — any root .md with frontmatter joins the corpus | archive pointer file carries no frontmatter; archive content stays on the branch |
| 9 | bd prime memories | **YES** — 66 memories inject retired-era framing every session, independent of file archiving | curation pass rides the bill (§3 ruling 10) |
| 10 | .specstory transcripts (22 committed) + findings/, drafts/ (12), scratch*, work-summary.md | **YES** — grep-reachable, CLI-invisible | archive branch takes them wholesale in the same sweep |
| 11 | Session-record produced-edges | interlock — a kept session whose produced artifact archives goes gate-red | sessions and their produced artifacts archive together, or kept sessions get edges scrubbed |
| 12 | Re-authored keeper `derives-from` | interlock — must resolve in the active corpus | §3 ruling 3 (root in the intent-013 → pdr-039 chain) |
| 13 | Duplicate-id blindness | gate detects none (probe P4) | no tombstone-stub scheme without a BC-side check |

## 8. Effort and sequencing — what lands in which order, sized in sittings (3-artifact cap) and mechanical bulk moves; what is blocked on lead-jozud.2

A **sitting** = one authority working session, capped at 3 substantive artifacts reviewed/ratified (pdr-039 discipline). **Bulk** = router/architect mechanical work between sittings, costing no authority time beyond spot ratification.

| Step | What lands | Size | Blocked on |
|---|---|---|---|
| 0. Pre-flight | Disable/confirm auto-commit (ruling 9); snapshot tag + `archive` branch creation; bd-memory curation list + .specstory sweep prep (ruling 10); hook-reinstall note | bulk | rulings 9–10 (ratified in step 1) |
| 1. Bill sitting | This document: ratify the 86/11/5/6 dispositions, archive mechanism (ruling 1), provenance home (2), derives-from + lineage (3–4), origin-index/id-continuity (5), auto-commit/bd-memory (9–10), ceiling (11), scope of pre-existing red (12), skills_provenance exclusion (13), container-health authority (8) | **1 sitting** (one artifact under review; outputs are dispositions, not new records) | — |
| 2. lead-jozud.2 RACI dialogue | Kind set M (ruling 6), adr/pdr merge, decision-makers, brief handoff, PM-arc family, plane separation / record-kind design, pdr-039 rule re-homing. Evidence pack ready (§9). **Sequenced before mass rewriting** — a merge outcome changes the kind every rewritten record is written as | **1–2 sittings** | step 1 |
| 3. Bulk move | Archive-branch curation; main-tree deletion; edge-scrubbed active tree; shop/primer re-point; hook regex + WARN-tier collapse; bd forget pass; landed as one gated-green series (or sanctioned `--no-verify` checkpoints) with a manual distribution-gate verification — the R100 hazard means the hook alone never gates the move | bulk, interleaved with step 4's first records (keepers need active parents per ruling 3) | steps 1–2 |
| 4. RACI-independent rewrites | F2–F5, F7–F10, F12, F13, F15 ≈ **25–30 records**; includes the F3 clarify-vehicle re-verify (via messaging work_done) and adr-063 confirmation (via bc-launcher work_done); Part-A authority-call outcomes (adr-002/033/046/047+pdr-030) fold into their family sittings (0–2 extra records) | **9–10 sittings** at cap 3 | step 1 (not step 2, except any record whose kind changes under a merge ruling) |
| 5. Kind-dependent tail | Two-BC coordinated kind dispatch (if shrink; §6); F6 (~2) + F14 (≤5) ≈ **7 records**; KIND-CONDITIONAL scenario dispositions (23 + 11 hashes); stale write-* skill deletion after the release | **2–3 sittings** + bulk dispatches | **lead-jozud.2** |
| 6. Scenario retirement + reconciliation | Retirement dispatches: shopsystem-knowledge 141, shopsystem-templates 12 (addressed from bead evidence, citing ADR-064 D1/D2 per D3); fold beads lead-uypj5/wnrvo/o7qww/8xgdq into rewrite dispatches; close lead-vy38p.1/4vvdo.1; repair gen-scenario-refs, regenerate origin-index, drive `scenarios validate --aggregate` to green or explicitly-ruled residue | bulk (architect dispatches; BC loops do the work) | steps 4–5 (new scenario set), ruling 5 |
| 7. Close-out | current-state re-issue incorporating the new record set; doctor ruling per 12; pdr-039 → `accepted` at loop exit; this bill archived as the mass-retirement provenance record if ruling 2 so chooses | bulk + spot ratification | all above |

**Sitting arithmetic:** 32–38 rewritten records / 3 per sitting = 11–13 rewrite sittings (steps 4+5), + 1 bill sitting + 1–2 RACI sittings = **≈13–16 authority sittings total**. All archive moves, scenario dispatches, register reconciliations, and index regeneration are mechanical bulk.

**Explicitly blocked on lead-jozud.2:** the final kind set and hence the two-BC dispatch; the day-1 baseline items (a)–(e) of §4; F6 and F14 rewrite content (~7 records); 23 KIND-CONDITIONAL + 11 lead_pm_template hashes; and — if the adr/pdr merge is chosen — the record-kind of every rewrite, which is why the merge question should be ruled **first** within the jozud.2 dialogue. Everything in steps 0, 3, 4, and 6 proceeds without it.

## 9. RACI evidence pack — appended for the kind/role dialogue (specimens with quotes)

Evidence only; no recommended cut [raci]. The authority's framing question (bd lead-jozud.2, verbatim): *"there seems to be a contract/RACI issue between the different roles in the lead shop that is causing ADRs to potentially take on the wrong things. This is a very technical product, so the original product owner role took on a lot of decisions that would normally be up to architects and teams responsible for implementing."*

**The contracts as written:**

| Role | Claims (quotes, cited lines) |
|---|---|
| lead-po (.claude/agents/lead-po.md) | "You own the **commitment**" (l.9–11); "Scenarios are requirements before they are assignments" (l.173); "### Write PDR for new functionality" (l.164–166); owns the product brief's evolution (l.157–158); NOT direction: "The lead-po **does not originate product direction**" (l.34) |
| lead-architect (.claude/agents/lead-architect.md) | "You own **product shape**, scenario assignment, and reconciliation" (l.9–10) — an Architect contract claiming product shape; "### Write ADRs" (l.141–144); vehicle selection + empirical pre-state (l.24–63); ADR↔structurizr gate (l.165–168) |
| lead-pm (`shop-templates show lead-pm`) | "The lead-pm owns the why… never writes scenarios or briefs"; owns "intent records, candidates, prioritization records, session records, **and PDR drafts for converged direction decisions**"; altitude ceiling: "no env var names, no schemas, and no CLI flags" |

**Contract-level facts:**

- **PDR drafting is double-claimed:** pdr-033 Decision (l.53–56) assigns "PDR drafting from converged decisions" to the **PO**; the lead-pm mode body claims "PDR drafts for converged direction decisions"; the lead-primer says lead-po "drafts briefs or PDRs". In practice both draft: pdr-033/037/039 authored "Claude (lead-pm)"; adr-067/069/072 authored "Claude (lead-architect)".
- **The RACI-defining records are all still `proposed`:** pdr-001, pdr-002 (roles-as-subagents topology), pdr-005 (architect review gate), pdr-012 (the PO elevation the authority names as the root symptom). Only pdr-033 (PM re-cut) is accepted. The operating RACI rests on unaccepted records.
- **No machine surface for ownership:** no typedef or schema field names an authoring role for any kind (`shop-knowledge schema <kind>` emits shape only); ownership lives solely in pdr-033 and role prose. pdr-037 (accepted) promises per-kind needs sections; its 69-line body contains none — the "needs" half of each kind's contract is effectively unwritten.

**Boundary-violation specimens (quotes doing the work):**

| Specimen | Quote / fact | Wrong plane |
|---|---|---|
| adr-008 (accepted) | "**v1 publishing format is plain markdown**… does NOT ship a MkDocs/Docusaurus… build… explicitly deferred to a future iteration" | v1 scope + deferral of a product capability, decided in an ADR |
| adr-002 (accepted) | Decision carries a "**Scope (in).**" list for the harness BC | BC charter scope in an ADR |
| adr-039 D1 | "The bump is **semver-by-surface-impact**, judged by the BC" + cadence | release policy in an ADR |
| adr-061 (accepted) | license policy + "**Explicitly fenced as future (NOT decided here).**" | legal/product policy + roadmap fencing in an ADR |
| pdr-002 (proposed) | "Lead-shop operation SHALL be formalized as: 1. **A `lead-po` subagent** at `.claude/agents/lead-po.md`…" | execution topology + file paths in a product record |
| pdr-010 | "When bd and shop-msg disagree, shop-msg wins for sent/received/consumed and bd wins for everything else" | store-of-record precedence in a PDR |
| pdr-020 | Decision 2 embeds a literal `docker run --rm -it -v /var/run/docker.sock:… bc-container launch …` command line | the exact altitude the lead-pm body forbids itself |
| pdr-022, pdr-009, pdr-023 | script decomposition + credential mechanics; CLI resolution mechanism; pour semantics — each in a PDR title | mechanism decisions in product records |
| brief-016 (draft) | "The pinned product decision (made explicitly by the product authority David, 2026-07-08)… **This is not open for the Architect or BC to re-litigate — the scenarios pin it.**" | a dated decision recorded in a brief; the brief kind has no `decision-makers` field |
| brief-018 / brief-021 | a typedef (schema-plane) change carried as a brief; architecture selection + source-level root-cause in a brief Summary | decisions and analysis in briefs |
| brief-025 (counter-example) | "…an Architect call at brief time and it is not a PO call… Evidence assembled… **without a recommendation**" | the boundary correctly drawn — and it produced adr-072, then rejected for deciding process |
| adr-029 D4 | "A confirmed spike graduates via PDR-014…" — authority flag: "grounding decision mechanics in a PDR (authority: confusing)"; session verdict: "**there is nothing to like** — … D1–D5 each mis-homed or a non-decision"; its Consequences task the PO ("The 8 Gherkin scenarios… are lead-po's Phase-2 job") | ADR grounding in a PDR; an ADR assigning PO work |
| adr-072 (rejected) | Asked a schema/surface question; decided a post-write procedure (D2), a mandatory acceptance criterion (D4), work-queue sequencing (D6), bookkeeping (D7). Changelog: "a record that keeps the default and builds nothing is not a decision, and **none of the seven items survives triage as ADR material**" | process decided in a schema question — the doctrine's first rejection |
| adr-067 (authority-confirmed sibling) | "title/description do not state a decision; … **conflates schema/semantics/process planes**; … 'it shouldn't have flipped to accepted'"; adr-069 dropped the standing one-record-per-type directive by aggregating all eight types (the R11 forcing case) | the F14 subject records themselves |

**Plane count across all 69 ADRs** (R8 planes: schema = fields/formats; semantics = relationships/ownership/meaning; process = gating/tools/procedure; classification is judgment, borderline set enumerated for re-cut):

| Bucket | Count | Members |
|---|---|---|
| Single-plane | 8 | 002, 012, 030, 031, 039, 053, 063, 071 |
| Borderline | 9 | 032, 045, 046, 052, 055, 058, 060, 066, 070 |
| Clear multi-plane | 52 | remainder — representative three-plane specimens: adr-005 (manifest fields S / ownership M / CLI P), adr-015 (nudge schema / direction semantics / CLI), adr-056, adr-067 (the authority's named case), adr-069 |

**Range: 52–61 of 69 multi-plane (75–88%).**

**External reference** (model knowledge, not repo evidence): Nygard-tradition ADRs record architecturally significant decisions, one per short record, engineering-owned — scope and scheduling are mis-filings; product records (PRD / Cagan / Amazon PR-FAQ / Shape Up pitches) own problem, outcome, scope, appetite and exclude implementation mechanics; RFC bodies **type records by plane** — IETF standards-track vs BCP, PEP 1's Standards / Informational / **Process** tracks — with a named acceptance authority per track. Common synthesis: the planes are separated primarily by **who accepts the record**, not only by content.

**Pack caveats:** the lane spec cited "adr-061" as a kind-ownership source; adrs/adr-061.md is the MIT-license-ingestion doctrine — the records that do carry ownership content (pdr-033, pdr-037, adr-067, adr-069, pdr-032/adr-059) were substituted, flagged in case a different id was meant. The plane classification is judgment; the 9 borderline cases are listed so the authority can re-cut. If RACI is to be enforced rather than cultural, no machine surface currently exists to land it on.
---

## 10. Verification annex — adversarial pass results (folded, not smoothed)

Two independent verifiers re-ran cited evidence on the keep and retire sides. Corrections and omissions below AMEND the sections above; where they conflict, this annex wins.

**Corrections (refuted or weakened claims):**

1. **§1 F1/F2 — REFUTED detail:** `bc-manifest.yaml` lists **five** live domain BCs (messaging, scenarios, templates, bc-launcher, **knowledge**), not four — "the 4 live BCs" is a stale in-file comment from the 2026-07-04 reconcile. The F1 fold and F2 rewrite must state five.
2. **§1 F9 — WEAKENED:** `agent-vault-ca.pem` is **not committed** — gitignored (line 18), untracked, mode 600, deliberately. The mechanism is live (broker healthy, doctor PASS); the rewritten credentials record must not claim a committed CA.
3. **§2 adr-042 — WEAKENED:** the retire is safe, but its named "open leg" (retro-retiring prose pins 105–116) is stale — all 12 enumerated hashes are already absent from today's tree. No carry bead needed.
4. **§2 pdr-025 — WEAKENED, needs re-adjudication at its family sitting:** "unrealized as named" is literally true of `bin/agent-vault-approve-claude` but materially misleading — pdr-025's three demanded outcomes ARE realized and live-pinned as @bc:shopsystem-templates scenarios. See also omission (e): four of those live pins name the nonexistent script.
5. **§1 F4 — WEAKENED at the edges:** the hash determinism leg reproduces exactly; adjacent journal/validate/consolidate legs were only partially re-verifiable (validate --aggregate is red for pre-existing reasons per §3 ruling 12).

**Omissions found (now part of the bill):**

- **(a) Silent-breakage trap, §8 step 3:** `current-state.md` `incorporates` names two RETIRE records (**adr-008, pdr-900**) — empirically proven BLOCKING on archive ("declares an incorporates edge … not present in the corpus"). The bulk move gains an **incorporates-scrub** step, sequenced before the gate-green series.
- **(b) Silent-breakage trap, §8 step 3:** the framework spec sections — named ambient grounding in the shop primer — hyperlink retiring records: `05-inter-shop-protocol.md:18,:34` and `06-work-tracking.md:36` cite `[ADR-023 D2](adrs/adr-023.md)`. The bulk move gains a **spec-section citation sweep** (§1–§6 files).
- **(c) §6 tooling cut, new row:** the poured `reconcile-and-close` skill FORBIDS the manual consume+close two-step and mandates `bin/reconcile-and-close` — which does not exist on this host. Live mandated surface with a missing executable; fold into the templates-BC dispatch set (or un-pour the skill).
- **(d) §7 checklist, new sweep targets:** `features-provisional/` (23 files, incl. docs/ and devcontainer/ subtrees) and `docs/runbooks/` are grep-reachable and appear in no sweep list. Added to the poison-prevention checklist.
- **(e) §5/§2 cross-reference:** four live-pinned templates-register scenarios (hashes 3b7e07095a354e0a, 9aa82d211517155d, 45dc18d4b0d1730e, 1c054dfdc468860a) name `bin/agent-vault-approve-claude`, which no lead surface provides — the pins assert a script that does not exist. Joins pdr-025's re-adjudication.

**Confirmed under adversarial re-run (unchanged, now higher-confidence):** F2/F3/F8/F14 keep-rewrite groundings; the §2 safety fact (no RETIRE candidate is @origin-cited by any feature; full 161-id census); §5 totals (141+12=153, buckets exact); §6 R100 hazard (git mv bypasses the ACM-filtered hook — scratch-repo proof); §7 archive-branch probes (loader never walks archive/; dangling-edge BLOCKING in distribution mode); §7 appendix mass (45.4–45.5%, zero inbound references).
