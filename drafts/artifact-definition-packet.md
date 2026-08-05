# Artifact-Definition Packet (sitting material — nothing here is ratified)

Assembled 2026-08-05 from six read-only lanes: the authority's verdict ledger, the ADR candidate definition, the PDR job archaeology (all 39 records), the brief/commitment material (all 25 briefs), the PM-arc kinds survey, and the definition-format analysis. Nothing under /workspace was modified by any lane. Discipline held throughout: **every criterion cites >=2 in-repo specimens, or an external grounding plus >=1 specimen** (the R8 rule — R8 was demoted for resting on one quoted reaction, pdrs/pdr-039.md:115-118, and that precedent governs this packet). External practice is marked EXTERNAL-REFERENCE and is input for the authority, never authority. Where a signal rests on one specimen it is labeled SINGLE-SPECIMEN and appears in §7 as a question, not a criterion. Options stay options. "RATIFIED" in §1 and §6 describes verdicts and rules *already* ratified on record; every candidate definition, framing, checklist, and recommendation in this packet awaits the sittings.

## 0. How to read this packet (the definition format recommendation, with its micro-example, and the per-sitting sequence)

**The commissioning bar, verbatim:** "I see no reason to proceed without a strong definition for these artifacts that makes it simple and clear when they are good enough." (sess-2026-08-05-a.md:36-37.) Recorded constraints on how the definitions may be built:

- **Per-kind and exhaustive, not a principle set** — pdr-039 "is by no means an exhaustive, well-thought-out ruleset" (sess-2026-08-05-a.md:22-24); its evidence base is ADR-only (pdr-039.md:110-115).
- **No decision lens on non-decision kinds** — "Key artifacts like a brief are not just decision records." (sess-2026-08-05-a.md:32.)
- **No criterion from a single specimen** — the R8 demotion: "depends on one observation quoted from me and could be dangerous if embraced as a rule" (sess-2026-08-05-a.md:30-31).
- **No in-corpus exemplar as the model** — adr-029's exemplar status revoked ("there is nothing to like"); "positive doctrine comes from authority verdicts, not in-corpus models" (sess-2026-08-04-a.md:39-42; pdr-039.md:23-26).
- **Definitions precede rules and enforcement** — "The rules here feed those definitions; they do not substitute for them" (pdr-039.md:120-122); the trust break was green-while-broken (sess-2026-08-03-a.md:79-91).
- **The template slots are the authority's own:** "per-kind definitions (the kind's job, reader contract, content obligations, a simple/clear good-enough test, boundaries)" (lead-jozud.2 comment 2026-08-05 10:16).

**Recommended definition format (for ratification at Sitting 1): one composite card per kind**, four parts in order:

1. **Job statement** — one sentence, in the needs vocabulary pdr-037 promised and never wrote (pdr-037.md:41-45 promises one per-kind needs section; its body carries none — confirmed drafts/rebaseline-bill.md:303 and sess-2026-08-05-a.md:42-43).
2. **Reader contract** — 1-2 sentences naming the kind's reader and the task they complete from the document alone. This is THE good-enough test, in the grain of "simple and clear." The pattern already exists ratified and adjudicated in-repo: pdr-035's self-containment requirement (pdr-035.md:76-79) and adr-072's own re-litigation sentence (adr-072.md:283-286). EXTERNAL-REFERENCE: Diátaxis / Nygard reader-orientation.
3. **Review checklist** — 5-9 binary items walkable at the sitting; every item traceable to >=2 verdict specimens; each tagged [C] judgment / flaggable-[M] / frontmatter-visible; carries pdr-039's explicit non-exhaustiveness note; grows only by ratified-iteration changelog (the doctrine-loop form already ratified as pdr-039 Option C, pdr-039.md:37-49).
4. **Exemplar slot + anti-exemplar citation** — the card cannot flip `accepted` while the exemplar slot is empty, forcing the per-kind authoring the sitting sequence already commissions (sess-2026-08-05-a.md:54-55). Anti-exemplars are cited by id with clause-annotated flaws only (for ADR they exist adjudicated and free: adr-072, adr-067, adr-029). Exemplar-required applies only to kinds surviving the kind-set-M ruling (bill:124) — prioritization-record has zero instances ever (bill:149).

**Why composite, not any pure form:** a checklist alone re-creates verification-by-proxy (intent-013 root cause 1, intent-013.md:37-40; pdr-039's own Option-B rejection: "the checkable subset would masquerade as the whole bar", pdr-039.md:33-36); a reader contract alone is unwalkable judgment that drifts (pdr-039.md:98-100); an exemplar alone is a single specimen — the R8 sin institutionalized. Every mechanism the composite uses is already ratified working practice in this repo; no new governance to invent.

**Micro-example (the ADR card headline; full candidate in §2):**

> **adr — architecture decision record.** Job: record one architecture decision so it cannot be silently re-litigated and the next architect applies it instead of re-deriving it. **Reader contract:** an ADR is good enough when the next architect facing the question it answers can (a) state the decision from the title alone; (b) apply it from Decision + Consequences without opening any superseded record and without asking the authority; and (c) see in Context what facts would have to change for the decision to be worth revisiting. It is NOT good enough if the reader must reconstruct the decision from options, findings, or a session transcript — or if what it "decides" is a default they already had.

(Clause grounding: (a) the adr-067/adr-029 title verdicts + corrective commit cdb8919; (b) pdr-035.md:76-79 + adr-067's "extensive superseded-decision reliance"; (c) adr-072.md:347-350; final sentence R1's two specimens.)

**Per-sitting sequence** (cap = 3 artifacts authored-or-reviewed per sitting — intent-013.md:59-61; pdr-039.md:90-92):

| Sitting | Agenda | Posture |
|---|---|---|
| 1 | Ratify the format itself; work the ADR card (§2); re-confirm or strike the four effectively-single-specimen ratified rules (R8 content, R9, R10, R11 — §6.2) | The authority holds a known standard ("I actually have a good idea of what an ADR should have", sess-2026-08-05-a.md:28-29); §2 is the thing to mark up |
| 2 | PDR (§3) | Job-first discovery — the format was never authority-validated ("I've been trusting the system with respect to PDRs"); the three framings are the agenda, not a confirmation exercise |
| 3 | Brief (§4) | Non-decision kind: job, lifecycle, boundaries |
| 4 | PM-arc kinds (§5) | Sequence with/after the kind-set-M ruling (bill:124) so no card is authored for a kind that dies; five kinds may force a split sitting |

**Carrier caution (standing):** ratify cards as per-kind decision records now — pdr-037's sectioned-needs home exists accepted-but-empty, and per-kind records honor the standing "one core-schema record + one per type" directive (R11). Do NOT route definition text into the write-\<kind\> skills or the gate yet: the typedef→skill channel is broken and divergent for 7 of 8 kinds, so doctrine landed there today becomes a third copy (findings/typedef-doctrine-carrier-feasibility-2026-08-03.md:44-51, 261-272, 299-303). Gate enforcement comes last, frontmatter-visible clauses only, and no check is believed until demonstrated red on a planted defect (intent-013.md:69-72; pdr-039.md:94-97).

**Status legend for §1:** RATIFIED (in-sitting or by accepted record) · RECORDED (authority verbatim, not yet a rule) · SINGLE-SPECIMEN (one artifact/observation — an elicitation question, never a criterion) · INFERRED (analysis of an authority reaction, not their words).

## 1. The authority's verdict ledger (per kind; single-specimen items marked as elicitation questions, not criteria)

Compiled from the four session records, pdr-039 (rules + changelog), the adr-072/adr-067 changelogs, intent-013's verbatim anchors, nine beads, and four bd memories. Excluded on principle: drafts/rebaseline-bill.md Part-B dispositions (proposals awaiting the deferred bill sitting, not verdicts).

### 1.1 ADR — the only kind the authority claims a known standard for

Every ratified pdr-039 rule was distilled from ADR specimens only (pdr-039.md:110-113).

| # | Verdict | Source | Carries into | Status |
|---|---|---|---|---|
| A1 | adr-072 REJECTED (first in 69 ADRs): "a record that keeps the default and builds nothing is not a decision" | adr-072.md:338-350; sess-2026-08-04-a.md:27-29 | R1 (decide the non-default; deferrals are non-decisions) | RATIFIED — 2 specimens (adr-072 whole-record; adr-029 D5 deferral, pdr-039.md:124-125) |
| A2 | Per-item triage of adr-072: "D2/D5 restate existing practice…, D3/D5 are tightenings that belong with ADR-070/071, D4 is an acceptance criterion…, D6 is work-queue triage…, D7 is bookkeeping" | adr-072.md:340-348 | R2 (every numbered item independently survives triage) | RATIFIED — 3 specimens (adr-072, adr-029 "D1-D5 each mis-homed", adr-067 plane conflation) |
| A3 | "The title for ADR-072 is practically gibberish. If it's an ADR, it should state the decision and I cannot tell what that is." | lead-atiki comment 2026-08-03 | R5 (title = the one decision); proposed by the authority's own observation as the first machine check | RATIFIED; corpus-quantified (28 of 69 titles exceed 25 words). EXTERNAL-REFERENCE: matches Nygard/MADR convention — input only |
| A4 | adr-067, six verdicts in one sitting: title/description state no decision; superseded-decision reliance; aggregating supersession; plane conflation; D8 ephemeral content; "it shouldn't have flipped to accepted — it fails the granularity check" | sess-2026-08-04-a.md:33-38; adr-067.md:319-332 | R5, R6, R7, R9, R10 | R5/R6/R7 multi-specimen; **R9 SINGLE-SPECIMEN** (adr-067 D8 the only clean one; adr-072 D7 a weak second) → §7; **R10 SINGLE-SPECIMEN** (the one flip; the 41-stale pattern supports R4, not R10) → §7 |
| A5 | Superseded reliance quantified: adr-067 names superseded records "23/20/18 times in prose", ADR-059 in its title; "7 violating edges across 4 documents" incl. 3 briefs | sess-2026-08-03-a.md:36-41, 73-75 | R6 (active ground) — demonstrated cross-kind reach | RATIFIED, multi-specimen + the 2026-07-06 spike-precedence rule |
| A6 | The 2026-07-25 batch dropped the standing structural directive ("one core-schema record + one per type") — adr-069 aggregated all eight types | sess-2026-08-04-a.md:31-33 | R7 second specimen; R11 (recorded directives bind authoring) | R7 RATIFIED (adr-067 + adr-069); **R11 SINGLE-SPECIMEN** → §7 |
| A7 | adr-029 exemplar revoked: "there is nothing to like" — the corpus holds no exemplar | sess-2026-08-04-a.md:39-42; pdr-039.md:23-26 | Constraint on the definitions themselves: stated criteria, never "looks like adr-NNN" | RATIFIED |
| A8 | RACI cause: "a contract/RACI issue between the different roles… is causing ADRs to potentially take on the wrong things… the original product owner role took on a lot of decisions that would normally be up to architects" | lead-jozud.2 description (verbatim) | No rule yet — open investigation; the definition must state whose decisions the kind carries | RECORDED |
| A9 | Contested-challenge ruling: the uniform-write-API question "stays an open question to be brought fresh if wanted"; rejection preserves deliberation "as anti-re-litigation trace" | lead-ut1e6 2026-08-03/04; adr-072.md:346-350 | R1/R2 scope (a small answer must not settle the big thing); R4 (rejection is first-class and keeps its deliberation) | RATIFIED via the ruling |

### 1.2 PDR — the never-validated kind; the authority's largest disclosed gap

| # | Verdict | Source | Carries into | Status |
|---|---|---|---|---|
| P1 | "only ADRs were reviewed, when PDRs are currently the main decision driver… I'm not sure that ADRs and PDRs can be governed by the same ruleset… I've been trusting the system with respect to PDRs as a format" | sess-2026-08-05-a.md:26-29 | Founds Sitting 2's job-first posture; no pdr-039 rule may be assumed to transfer | RECORDED |
| P2 | "We are trying to repair the corpus without defining how a good artifact… is constructed in the first place… pdr-039 may turn out to have very large gaps" | sess-2026-08-05-a.md:33-35 | Definitions precede rule generalization | RECORDED |
| P3 | pdr-037's promised per-kind needs sections were never written; adr/pdr schemas differ only by `decision-makers` + "Options considered" | lead-jozud.2 2026-08-05; pdr-037.md:41-45 vs body | A live specimen that a PDR can be accepted with its content obligation unmet — feeds the PDR definition and R10's realization clause | RECORDED (as the hole, fact; as a rule source, one specimen) |
| P4 | "ALWAYS a PDR — every scenario family points to exactly one PDR via definedBy… PDR = PO commitment, never a PM bet" — self-hedged "works for now, prove out in practice" | bd memory 2026-07-17 | Candidate job statement for the kind | SINGLE-SPECIMEN → §7: does it still hold? |

### 1.3 Brief

| # | Verdict | Source | Carries into | Status |
|---|---|---|---|---|
| B1 | "Key artifacts like a brief are not just decision records." | sess-2026-08-05-a.md:32 | The brief needs its own job statement, not R1-R11 | RECORDED; SINGLE-SPECIMEN as stated (no brief ever reviewed in a sitting) → §7 |
| B2 | Brief demoted to "OPTIONAL OFF-SPINE strategic grouping… JOINS… never on the provenance path" | bd memory 2026-07-17 | Candidate job: off-spine, non-decisional | SINGLE-SPECIMEN — but B1+B2 converge; the convergence is itself evidence |
| B3 | brief-018/019/023 "each derive from two superseded decisions" | sess-2026-08-03-a.md:73-75 | R6 demonstrably applies to briefs | RECORDED (3 specimens, router-verified, not a sitting verdict) |

### 1.4 Candidate — no direct quality verdict exists

| # | Signal | Source | Status |
|---|---|---|---|
| C1 | "Pointing scenario origin at a candidate = a MISTAKE (ties contract to a provisional bet)"; candidate = "a PM bet" distinct from the PO commitment | bd memory 2026-07-17 | SINGLE-SPECIMEN → §7 |
| C2 | cand-010's forks "resolved WITH product authority" in-session — the kind operating as the fork-resolution surface | sess-2026-08-02-b.md:9; lead-fb3vk | INFERRED — no quality verdict on any candidate exists |

### 1.5 Intent — no direct verdict; the kind currently carries the authority's own words

| # | Signal | Source | Status |
|---|---|---|---|
| I1 | "EVERYTHING TRACES TO INTENT — every node must reach an Intent via required parent edges, else legacyRoot:true" | bd memory 2026-07-17 | SINGLE-SPECIMEN → §7 |
| I2 | intent-013 carries a "Verbatim anchors" section no schema requires, produced in the session the authority directed | intent-013.md:13-31 | INFERRED → §7: is verbatim-anchor carrying a content obligation? |

### 1.6 Session record — no direct verdict; two system findings

| # | Finding | Source | Status |
|---|---|---|---|
| S1 | The generated write-session-record skill names sections ("Mode, Produced artifacts, Outcome") diverging from the live schema ("Outcome, Open threads") — the kind's authoring channel contradicts its schema | sess-2026-08-03-b.md:54-58 | INFERRED → §7: must be adjudicated |
| S2 | R9 assigns the kind a job: the sanctioned home of ephemera scrubbed from permanent records | pdr-039.md:75-77 | RATIFIED for decision records; the session-side implication never separately ratified → §7 |

### 1.7 Current-state

| # | Finding | Source | Status |
|---|---|---|---|
| CS1 | current-state-001's "Artifact system (live)" paragraph claims capabilities contradicted the same week (lead-8aqj3, lead-j7t0j, lead-ulris); BC/substrate/invariants sections are unfilled seed placeholders — "The grounding document is itself evidence." | sess-2026-08-03-b.md:47-53 | SINGLE-SPECIMEN + INFERRED (only one instance exists; no per-kind verdict) → §7 |

### 1.8 Prioritization record

**Empty ledger.** No authority verdict, bead, memory, or session anchor addressing the kind's quality exists in any examined source. Definition must be elicited from zero (§5.5, §7).

### 1.9 Cross-kind verdicts (operationalized in §6)

| # | Verdict | Source | Status |
|---|---|---|---|
| X1 | The commissioning verdict (§0) — per kind, simple, clear, decidable good-enough | sess-2026-08-05-a.md:36-37 | RECORDED |
| X2 | "…by no means an exhaustive, well-thought-out ruleset" — exhaustive per kind, not interpretable principles | sess-2026-08-05-a.md:22-24 | RECORDED |
| X3 | R8 demoted: "depends on one observation quoted from me… A 'plane' can contain many things." | sess-2026-08-05-a.md:30-31; pdr-039.md:115-118 | RATIFIED as demotion — the cardinal-sin precedent governing this packet |
| X4 | Trust break: "How can I trust any of these documents?… The schema should be strict for front-matter." (0/167 artifacts carry a declared-required field while the gate reports zero findings) | lead-j7t0j verbatim; sess-2026-08-03-a.md:79-97 | RECORDED DIRECTIVE — strict closed-set frontmatter, Phase-2 sequenced, "NOT shaped, NOT dispatched" |
| X5 | Founding frustrations: "far too simplistic… very poorly thought out things like ADRs"; "ADR-072… make[s] me question the quality of all of the decisions"; "needs to start with artifacts written to a high standard" | intent-013.md:15-25 | RECORDED — definitions serve trust repair; quality must be verifiable |
| X6 | Quality decomposed into content / legibility / structural-trust, answering the authority's own "metadata quality or artifact quality overall?" | intent-013.md:26-29 | RECORDED — every card addresses all three axes or says which |
| X7 | "an iterative process to review and steadily capture doctrine"; never one-shot; machines not asked to check thought quality; red-before-green | intent-013.md:30-31, 62-72 | RATIFIED via intent-013 → pdr-039 |
| X8 | Batch authoring banned (the 17-artifact 2026-07-25 batch is the named pattern); cap 3 per sitting — good-enough includes reviewable-enough | intent-013.md:59-61; lead-jozud.1 | RATIFIED |
| X9 | R4 terminal states; rejection first-class (0 rejections in 69 ADRs while 41 records linger proposed) | lead-jozud.1; pdr-039.md:60-61; bill:15 | RATIFIED, corpus-quantified — each card states its kind's terminal states and their meanings |
| X10 | Definitions and role charters are ONE body of work: "Kind set M and the RACI cut are OUTPUTS of the definitions, not inputs" — and the five-slot template | lead-jozud.2 2026-08-05 | RECORDED |
| X11 | Reviewer legibility a separate problem; suspected roots (verbosity, buried decisions, altitude, rendering) "to discover, not assume" | lead-nvs7i 2026-07-27 | RECORDED → §7 |
| X12 | Spike/findings never authoritative; findings/ removed as a kind — the 8-kind set is itself an authority ruling; grounding through non-kinds outlawed (now R6) | bd memories 2026-07-06 + 2026-07-17 | RATIFIED (two independent rulings, converging) |
| X13 | Rebaseline committed; CRUFT ELIMINATION binding; rewrite-forward the default keeper disposition | lead-jozud 2026-08-04 19:59/20:11 | RECORDED, COMMITTED — each good-enough test must work as a rewrite acceptance test |
| X14 | Grounding-trace principle: question → terms → queries → grounded set → decision; "the AUDIT SURFACE is the derived TERMS" | lead-fb3vk 2026-07-29 | RECORDED (arc paused; the principle is the authority's) |
| X15 | Ownership boundary: code-looking surfaces owned by shopsystem-templates; lead-owned: features/, briefs/, adr/, pdr/, beads | bd memory 2026-07-08 | RECORDED (its findings/ mention superseded by X12) |
| X16 | beads/graph coupling "intended or accidental" — unresolved | lead-d0jmz | RECORDED → §7 |

**Source-coverage note.** All lane-named sources were read; `bd memories quality` returned no matches (older feedback recovered via the feedback query and a full 66-memory scan). adr-029's changelog does not record the exemplar revocation — that verdict lives only in sess-2026-08-04-a.md:39-42 and pdr-039.md:23-26 (a possible R4/R9 follow-up at rewrite).

## 2. ADR — candidate definition + the elicitation questions where the authority's standard overrides

Built from three kept-distinct sources. (1) The verdict ledger, §1.1. (2) An empirical consumption census (read-only, this week): 24 distinct ADR ids `@origin`-cited in features/ (the bill counts 30-32 by other methods — discrepancy carried, not smoothed); 435 frontmatter edges target adr-\* ids (bill tool: 482 of 867 — scopes differ, magnitudes agree); adr-018 is the most-consumed record (55 mentions; 53 derived-by back-edges); adr-064 D3's cite-never-restate dispatch convention; 27/69 titles exceed 25 words; **62/69 descriptions end mid-sentence** — truncated first lines of Context, not authored abstracts; the machine schema requires only Context/Decision/Consequences (no Options section, unlike pdr). (3) EXTERNAL-REFERENCE ADR practice — Nygard form (one significant decision; value-neutral Context; active-voice Decision; ALL consequences; immutable once accepted, supersede-don't-edit), MADR (decision drivers, considered options, "chosen because", Confirmation section), the one-decision convention, adr-tools status lifecycle — input, never authority.

### 2.1 Job

An ADR **permanently records one architecture decision that changes the standing default**, so three consumers rely on it without re-derivation: (1) the next architect reads the decision instead of re-litigating it (adr-072.md:282-286; the rejection changelog preserves deliberation for exactly this purpose, :345-350); (2) dispatch and scenario authoring cite it by reference — `@origin` tags and dispatch prose (adr-064 D3) — never restating doctrine from memory; (3) pre-state verification treats it as authoritative artifact surface (ADR-018 D1; .claude/shop/primer.md:54-57). Negative half, from the verdicts: an ADR is NOT a work log, status note, acceptance-criteria carrier, work-queue, or restatement of pinned practice (adr-072 per-item triage; R1/R2).

### 2.2 Reader contract

| Reader | When | Needs |
|---|---|---|
| lead-architect (pre-state) | before every new decision/dispatch | what is currently decided and active, findable from title/description without the body — the unguarded staleness surfaces are "the title, the description, and the prose body — exactly what an agent reads first" (sess-2026-08-03-a.md:38-41) |
| Dispatch author | composing shop-msg prose | a citable Dx stable enough to reference, never restate (adr-064 D3; bill:200) |
| PO / feature surface | authoring/retiring scenarios | a stable id as `@origin` anchor (24+ ids feature-cited) |
| Gate + navigate/query | continuously | complete, symmetric frontmatter edges; lineage in frontmatter, not prose (R6; 435 measured edges) |
| Product authority | acceptance sitting | a record reviewable solo within the 3-artifact cap (intent-013 root cause 4: "decision units oversized past solo review bandwidth") |
| current-state gate | on acceptance | id joins `incorporates` (current-state.md:18; bill:148) |

### 2.3 Content obligations (what each part must accomplish — not section names)

| Part | Obligation | Grounding |
|---|---|---|
| Title | Names the ONE decision, scannable — not an abstract or enumeration | R5; lead-atiki verdict; adr-029 "useless title"; adr-067 verdict; commit cdb8919 |
| Description | The decision as an authored abstract — "what was decided?" answerable without the body (today 62/69 are truncated Context fragments) | R5; adr-029.md:9 vs adr-072.md:10 as the two poles |
| Frontmatter edges | All lineage machine-checkable in frontmatter; prose carries no load-bearing lineage and relies on no superseded ground | R6; adr-067 verdict; sess-2026-08-03-a.md:36-41 |
| Context | Why the default must change; pre-state demonstrated empirically against the artifact surface and cited (never BC code) | ADR-018 D1/D2; all three reviewed specimens carry the section; primer. EXTERNAL-REFERENCE: Nygard value-neutral context |
| Options | Real alternatives, each with an evidence-tied rejection reason | present in all three specimens; EXTERNAL-REFERENCE: MADR. NOT schema-required for adr today (it is for pdr) → Q2 |
| Decision | Decides a non-default (R1); every numbered item survives triage as ADR material (R2) — no restated practice, tightenings, acceptance criteria, queue triage, bookkeeping, or deferrals-as-decisions | adr-072 per-item taxonomy; adr-029 "D1-D5 each mis-homed"; R1 amendment (pdr-039.md:124-125) |
| Consequences | What becomes true; implied work named, not dispatched or sequenced; honest costs stated | adr-067 "named here, NOT dispatched" (:264-266) vs adr-072 D6 rejection; pdr-039's own "Honest cost" pattern. EXTERNAL-REFERENCE: Nygard positive AND negative consequences → Q5 |
| Changelog | The one sanctioned self-containment exception (PDR-035 via adr-067.md:23-25); carries flips, verdicts, amendments; ephemera scrubbed at flip (R9) | adr-072 and adr-067 authority-verdict changelogs; R9/R10 |
| Status | Reaches a terminal state; rejected is first-class and keeps its deliberation | R4; the adr-072 precedent; 41 R4-stale records (bill:15, :73). EXTERNAL-REFERENCE: adr-tools lifecycle matches |
| Size | Proportional to decision weight; reviewable solo in one sitting | R3; adr-072 (351 lines to keep a default, rejected) vs adr-064's praised narrow granularity; adr-056 (~10 items, rewrite mandated, bill:58) |

### 2.4 Draft good-enough checklist — the thing to mark up ([M] = machine-flaggable)

1. **Non-default:** decides something not already the default; keep-the-default and deferrals routed out. [judgment] — R1; adr-072; adr-029 D5.
2. **Triage clean:** every numbered item is ADR material; tightenings/criteria/queue-items/bookkeeping re-homed. [judgment; item count [M]] — adr-072 (7 items, 0 survive); adr-029 (5 items, 0 survive); adr-056.
3. **Title states the one decision, <=~25 words.** [[M]] — lead-atiki (the authority's own observation, proposed as the first enforcement rule); 27/69 fail today.
4. **Description is an authored abstract ending in a complete sentence, distinct from Context line 1.** [[M]-flaggable] — R5; 62/69 fail today; adr-029 vs adr-072 poles.
5. **Pre-state cited:** empirical demonstration against the artifact surface with commands/exit codes or citations, per ADR-018 D1/D2. [presence [M]; sufficiency judgment] — all three specimens; primer.
6. **Options real:** >=1 rejected alternative with an evidence-tied reason. [presence [M]; quality judgment] — three specimens + EXTERNAL-REFERENCE (MADR). *Held open pending Q2 — the weakest-grounded item: no authority verdict demands it and the schema does not require it.*
7. **Active ground:** no superseded id load-bearing in title/description/body prose; lineage in frontmatter only. [[M]] — R6; adr-067; sess-2026-08-03-a.md:36-41.
8. **Supersession simplifies:** a successor collapses N into fewer, clearer records — never an aggregate. [judgment; size signal [M]] — R7; adr-067 + adr-069.
9. **No ephemeral scaffolding** in permanent sections; acceptance mechanics live in changelog/session/beads, scrubbed at flip. [[M] phrase-scan] — R9 (SINGLE-SPECIMEN — re-confirm, §7).
10. **Flip gate:** no acceptance with open forks, failed granularity, or scaffolding; flip requires changelog entry + realization evidence or named realization work. [[M] partial] — R10 (SINGLE-SPECIMEN as to the flip clauses — re-confirm, §7); the 41 stale-proposed records ground the R4 half.
11. **Consequences name implied work and honest costs; nothing dispatched, sequenced, or role-assigned from inside the record.** [judgment] — adr-067 named-not-dispatched vs adr-072 D6/D7 vs adr-029's PO-assignment flag (bill:320).
12. **Machine-valid** (validate + gate + schema) — necessary, never sufficient: "a green check proves nothing about this doctrine" until Phase 2 lands red-on-planted-defect (pdr-039.md:95-97; the trust break was green-while-broken). [[M]]
13. **Structural directives honored** — any recorded authority directive binds; deviation needs explicit sign-off in the artifact. [judgment] — R11 (SINGLE-SPECIMEN — re-confirm, §7); the adr-069 forcing case.

### 2.5 Boundaries — what belongs elsewhere (specimens; see also §6.1)

| Content class | Belongs in | Specimen |
|---|---|---|
| v1 scope / capability deferral / roadmap fencing | PDR / brief | adr-008; adr-061 (bill:309, :312) |
| BC charter scope | brief / PDR | adr-002 (bill:310) |
| Release policy / cadence | PDR | adr-039 D1 (bill:311) |
| Acceptance criteria for dispatched work | the brief's scenarios | adr-072 D4 (adr-072.md:343-345); brief-025 counter-example (bill:319) |
| Work-queue triage / sequencing | beads | adr-072 D6 ("already filed as lead-8aqj3"); adr-029's P3 bead (adr-029.md:145) |
| Bookkeeping | session record / nowhere | adr-072 D7 |
| Restating pinned invariants | cite by reference | adr-072 D2/D5; adr-064 D3 as the positive pattern |
| Tightenings of another decision | amendment on that decision | R2; adr-072 D3/D5 → ADR-070/071 |
| Role/work assignment | beads / role contracts | adr-029 Consequences ("lead-po's Phase-2 job", bill:320); lead-jozud.2 |
| Decision mechanics grounded in a PDR | open RACI question | adr-029 D4 flag "authority: confusing" (bill:320) → Q13 |

### 2.6 Elicitation questions — where your standard overrides this draft

**Granularity and the D1..Dn idiom.**
1. Is the numbered multi-decision idiom acceptable at all, or is the standard literally one D per record? adr-018 resolved four delegated questions as D1-D6 and is the corpus's most-consumed ADR (55 edge mentions, quoted in the live primers) — but it predates the doctrine loop. Does adr-018 meet your bar? (The corpus officially holds no exemplar.)
2. Are "Options considered" obligatory in an ADR? Schema says no (it does for pdr); all three reviewed specimens carry it; external practice treats it as core. Require, encourage, or leave free?
3. What is the granularity test in one sentence? R2 gives triage categories; adr-067 "fails the granularity check" — is it "one decision, one plane, one accepting authority," or something simpler you already hold?

**Content obligations.**
4. Is the empirical pre-state section mandatory for EVERY ADR, or only dispatch-implying ones? Tension: adr-072 carried the corpus's most rigorous pre-state findings and was still rejected — rigor at the wrong altitude? Cap findings to those load-bearing for the decision?
5. Where exactly is the Consequences line between "implied work named" (adr-067, unflagged) and "work-queue triage" (adr-072 D6, rejected)? Is the rule: naming that work exists is fine; filing/sequencing/scoping it is bead material?
6. What must the description accomplish that the title does not, and is there a length bound? (62/69 are truncated Context fragments today.)
7. Is the "Cross-references (bare-id traceability)" prose section wanted at all now that R6 puts lineage in frontmatter — or duplication to scrub?
8. Changelog: what must an entry carry at each status flip beyond date + verdict? Is the adr-072 rejection changelog (verdict + per-item disposition + anti-re-litigation clause + bead closure) the template?

**Lifecycle and status.**
9. Is the adr-072 pattern — full deliberation preserved inside a rejected record — the standing convention for every rejection?
10. Should acceptance require the pre-state to be RE-verified at flip time? (adr-067 flipped one day after authoring with forks open; R10 catches forks but not stale evidence.)
11. Does "realization evidence or named realization work" belong in the ADR itself, or is current-state's `incorporates` the realization ledger?

**Boundaries / RACI (feeds lead-jozud.2).**
12. What is THE discriminator between ADR and PDR — the content plane, or who accepts the record? (Schemas differ today only by `decision-makers` + one section; EXTERNAL-REFERENCE: RFC-tradition track typing separates by acceptor, bill:334.)
13. adr-029 D4 was flagged "grounding decision mechanics in a PDR (authority: confusing)" — state the legal grounding directions between ADR and PDR.
14. Deferrals-with-trigger: bead-only, or is there a class of "recorded non-decision with a watched trigger" deserving a home?
15. Does an ADR ever legitimately carry role assignments, or is that always bead/role-contract material?

**Good-enough test format.**
16. Do you want the test as (a) a short sitting checklist, (b) machine gates once demonstrated red, or (c) a prose paragraph held in mind? The draft assumes (a) evolving into (b).
17. Title bound: ratify ~25 words as the machine-checkable line, or set a different number?
18. Which of the 13 checklist items would you strike, and what known item is missing? You said you have a good idea of what an ADR should have — this list is the thing to mark up.

## 3. PDR — the job archaeology (the table), what the 39 actually did, and 2-3 candidate framings as real options

**Corpus vitals.** 39 records: **25 proposed / 12 accepted / 1 rejected (pdr-031) / 1 superseded (pdr-032)**; oldest still-proposed date to 2026-05-11. Authorship: ~20 by lead-po; 4 by lead-architect (pdr-016/019/020/022 — exactly the most architecture-shaped); 8 by lead-pm/acting (the entire pdr-032-039 stratum). All 39 carry `decision-makers: [dstengle]`. Schema delta vs adr: only `decision-makers` + "Options considered" + `derives-from` non-emptiness (confirmed in-sitting, sess-2026-08-05-a.md:42-43). Headline fact that is itself archaeology: **the operative doctrine mostly lives in proposed records** — pdr-002 governs the shipped primer (.claude/shop/primer.md:7), pdr-003 is cited by 16 feature lines, pdr-011 is pinned by adr-018; under pdr-035's accepted-set current-system view, most of what the system runs on is invisible.

**The table.** "Better home?" applies the authority's recorded boundary instincts (ADR = architecture the Architect makes in dispatch work, artifact-lifecycle.md:85-87; PDR = ratification of genuinely competing product options, :82-85; R2 triage, pdr-039.md:54-57; B1) — discovery input, not verdicts; the kind/RACI division is itself under investigation (pdr-039.md:101-103). Plane labels are omitted per the R8 demotion.

| id | status | Actual job (from the Decision) | Better home under authority instincts? |
|---|---|---|---|
| pdr-001 | proposed | Standard: quality bar for role templates ("the PDR-001 bar", cited by pdr-013 D4) | Standard-not-decision; charter/standard home — RACI-open |
| pdr-002 | proposed | Role-charter/architecture: router + two subagents, dispatch rules; governs the shipped primer | ADR-shaped execution topology |
| pdr-003 | proposed | Mechanism: CLAUDE.md four-file split, byte-for-byte update semantics | ADR — file-contract mechanics, zero product content |
| pdr-004 | proposed | Architecture: which BC owns bc-container | ADR |
| pdr-005 | proposed | Process rule: PO naming ban + Architect accuracy gate | Role-charter amendment; R2 tightening of pdr-001 |
| pdr-006 | proposed | Architecture: BC manifest ownership + CLI surface | ADR |
| pdr-007 | accepted | Mechanism policy: clean-break flag migration + caller task list | ADR + bead |
| pdr-009 | accepted | Mechanism: implicit CWD shop resolution incl. error behavior | ADR — CLI design |
| pdr-010 | accepted | Post-hoc umbrella over adr-011..017 — derives-from and derived-by are the SAME seven ADRs | ADR, or an acceptance act on the ADR set; circular edges are a graph smell |
| pdr-011 | proposed | Doctrine definition: "verify pre-state empirically" = contract-surface-only; pinned by adr-018 | Arguably legit PDR (operating meaning) — or primer/ADR |
| pdr-012 | proposed | Role-charter: lead-po → empowered-PM | RACI-open — the investigation's core specimen; amended by pdr-033 |
| pdr-013 | proposed | Role discipline + bet: right-sizing with pre-registered proxies | Split: discipline → charter; the bet is genuinely product |
| pdr-014 | proposed | Mechanism + policy: canonical skill-group pour + graduation path | ADR (pour) + graduation policy PDR-ish |
| pdr-015 | proposed | Scope-commit; self-titled "solution-space framing (intent…)" | Brief/intent-record |
| pdr-016 | proposed | Capability ratification: spike lifecycle, "mechanism locked (pinned by ADR-029)" | ADR umbrella / acceptance act |
| pdr-017 | proposed | Scope-commit: agent-vault standup as SB-1..7 outcomes; self-titled "problem framing (intent…)" | Brief/intent-record |
| pdr-018 | proposed | Product-direction: the dummy-product spike IS the MVP acceptance gate (8 conditions) | KEEP — genuine authority-ratified bar |
| pdr-019 | proposed | Dispatch plan: U1-U7 table with owning BC/vehicle/ordering | ADR + beads — an Architect dispatch table in a PDR |
| pdr-020 | proposed | Architecture: lead shell = bc-container-launched bc-base session | ADR — clearest architecture-in-disguise |
| pdr-021 | accepted | Product + mechanism: D1 one canonical bringup path; D3-D5 broker mechanics | Split: D1 keep; D3-D5 → ADR |
| pdr-022 | accepted | Refactor plan: provisioning delegation, docker-exec-only, two phases | ADR + bead |
| pdr-023 | proposed | Directive transcript + mechanism: "Product authority, verbatim points 1-3" + .provenance marker design | Split: verbatim = the product decision; marker → ADR |
| pdr-024 | proposed | Feature definition: bin/doctor, three checks, exit-code contract | Brief-shaped feature commit; contract → ADR |
| pdr-025 | proposed | Requirement pinning: three behaviors already carrying @scenario_hash | Brief + scenarios — scenario work wearing a PDR |
| pdr-026 | proposed | Interface contract: OCI label/ENV provenance key names | ADR |
| pdr-027 | proposed | Product-direction: empty-repo detection fires proactive discovery instead of idle | KEEP — adopter-experience behavior the authority chose |
| pdr-028 | proposed | Feature behavior: bootstrap refuses stale image | request_bugfix / brief; R2 implementation detail |
| pdr-029 | accepted | Protocol decision: request_scenario_register a distinct vehicle | ADR — message-type design is the Architect's charter item |
| pdr-030 | proposed | Product + mechanism: D1 version "bumped by product semantics"; D2 manifest mechanics | Split: D1 keep; D2/D3 → ADR |
| pdr-031 | rejected | BC founding bundle (knowledge BC, posture, projections, gate) | Candidate/brief-sized bundle; NOTE: accepted pdr-035 claims to supersede it "in full" while its status is `rejected` |
| pdr-032 | superseded | Ownership + schema taxonomy (8 types, kind→type) | Its successors split it correctly: needs → 035/037; schema → adr-067/069 |
| pdr-033 | accepted | Role-charter/RACI: PM as main-session mode; amends pdr-012 | RACI-open — most-consumed PDR in the corpus (28 feature-prose cites) |
| pdr-034 | proposed | Scope-commit: full-corpus migration appetite | KEEP-ish — matches the lifecycle doc's own exemplar list |
| pdr-035 | accepted | Product foundation: why artifacts exist; eight kinds; self-containment — "at capability altitude" | KEEP — the needs-lane pattern working as designed |
| pdr-036 | accepted | Capability commit: one read-only corpus CLI; mechanics deferred to the mechanism ADR | KEEP — same pattern |
| pdr-037 | accepted | Meta/authoring-shape: per-kind needs "shall be" one sectioned PDR — the sections were never authored | The actual decision is an authoring plan; the promised content is this packet's hole |
| pdr-038 | accepted | Capability commit: writing skill per kind + blocking enforcement; mechanism → ADRs | KEEP — needs-lane pattern |
| pdr-039 | proposed | Standard: 11-rule quality doctrine, changelog-grown, under authority critique | Standard-not-decision; whether standards are a PDR job is itself elicitation |
| pdr-900 | accepted | Placeholder: synthetic legacy wrapper, all four body sections empty | Graph device, not a decision; needs its own sanctioned form |

**Job tally and headline.**

| Job actually performed | Count | Members |
|---|---|---|
| Process/mechanism design | 11 | 003, 007, 009, 014, 019, 022, 025, 026, 028 + mechanism-halves of 021, 023 |
| Architecture | 7 | 004, 006, 010, 020, 029, 031, 032 |
| Role-charter / RACI | 6 | 001, 002, 005, 012, 013, 033 |
| Genuine product-direction / ratified bet | ~8 | 018, 021-D1, 027, 030-D1, 034, 035, 036, 038 |
| Scope-commit / intent (brief-shaped) | 4 | 015, 017, 023-points, 024 |
| Governance/doctrine standard | 3 | 011, 016, 039 |
| Placeholder | 1 | 900 |

Under the authority's own boundary instincts, roughly **8-10 of 39** did the job the lifecycle doc assigns the kind. The largest actual job is process/mechanism design, the second architecture — and the four architect-authored PDRs sit exactly in those buckets. The kind absorbed whatever decision the lead needed recorded, discriminated by *who ratified* (always dstengle), not by *what was decided*.

**How PDRs are consumed (measured).** Scenario origin: only **8 distinct PDRs across 11 feature files** carry `@origin:pdr-*` — versus `@origin:adr-056` ×23 and `@origin:brief-001` ×19; scenario production runs through briefs, ADRs, and beads, not PDRs. Feature-prose citation has a different top list: pdr-033 (28), pdr-003 (16), pdr-010 (15), pdr-032 (14), pdr-023 (13) — the most-cited PDR in the contract surface is the role-charter one. Frontmatter consumption is strictly downstream (ADRs and briefs derive from PDRs; zero upstream `derives-from` or `references` edges target a PDR); pdr-010's edges are circular; the needs→schema pairs are live (035→adr-067, 037→adr-069, 038→adr-070/071). Primer and mode bodies quote pdr-002/011/033 as standing operating rules — **standing-ruleset consumption, a job the decision-record form was never designed for**, and why pdr-001/012/033 keep being re-cited rather than realized-and-closed. current-state's `incorporates` carries exactly the 12 accepted PDRs. The lifecycle doc pinned the *status enum* as defect-free — nothing about content ("I've been trusting the system with respect to PDRs as a format").

**Candidate framings — real options, no recommendation.**

**Framing A — PDR = the product authority's bet ledger (ratification record).** A PDR records a choice the authority made between genuinely competing options about what the product is, does, or promises: scope, acceptance bars, release identity, adopter experience, appetite. Required content: the real options, the chosen bet, the accepted cost, the observable product consequence, the realization path. Good-enough: a reader answers *what was chosen over what, by whom, at what accepted cost, and how we'll know it landed* — without opening any other document. Grounding (>=2 specimens): pdr-018, pdr-030 D1, pdr-027, pdr-034, pdr-023's verbatim points, plus artifact-lifecycle.md:82-85's own description. Consequence for the 39: ~8-10 remain; ~18 re-home to ADR; ~4 to brief/intent; the role-charter six await the RACI cut; 900 and 039 need their own homes. EXTERNAL-REFERENCE: SVPG opportunity assessment + Shape Up bet + Spotify DIBB.

**Framing B — PDR = needs-altitude direction record, paired with a mechanism ADR (codify the late-stratum pattern).** A PDR fixes the *need and its boundaries* at capability altitude and explicitly defers mechanics to a paired ADR. Good-enough (the altitude test): *could a different mechanism satisfy this PDR unchanged?* If no, it contains an ADR and fails. Grounding — the pattern already exists and works: pdr-035→adr-067, pdr-036→adr-068, pdr-037→adr-069, pdr-038→adr-070/071 ("this PDR fixes the need and boundaries; field and flag mechanics are the mechanism ADR's job"); counter-specimens pdr-009 (error semantics), pdr-026 (key names), pdr-020 (Dockerfiles), pdr-025 (inline hashes). Gives the ADR/PDR boundary a mechanical test rather than a plane taxonomy — compatible with the R8 demotion. EXTERNAL-REFERENCE: PRD-vs-design-doc split.

**Framing C — PDR = the lead's general decision record; ADR narrows to structure-within-ratified-direction.** Accept the archaeology: the PDR is *the* decision record for anything the product authority must ratify, regardless of plane — "the main decision driver" (sess-2026-08-05-a.md:26); the ADR narrows to decisions the Architect takes autonomously within ratified direction. Discriminator = **decider seat**, not content plane. Good-enough: decision in title (R5), options real, `decision-makers` correct for the seat, realization path, terminal state (R4). Grounding: all 39 carry `decision-makers: [dstengle]`; the four architect-authored PDRs are exactly the seat violations this framing re-homes; pdr-010's circular edges show ratification-of-architect-work already forced through the kind. Residue: leaves "brief is not a decision record" homeless and the standard job (001, 039) needing a subtype or fourth surface. EXTERNAL-REFERENCE: MADR any-decision records; Oxide RFDs (one kind, discriminated by state machine and decider); the common industry three-surface split (product bets / ADRs / a process-handbook register) — the missing third surface matching the 11-record process mass.

The ten PDR elicitation questions the archaeology raises are in §7, Sitting 2.

## 4. Brief — candidate definition, lifecycle proposal, boundaries

**Corpus facts.** 25 briefs; status **draft 20, ready 5, delivered 0, withdrawn 0 — terminal statuses never once used** (bill:144). Schema: required sections Summary + Scope only; the generated template carries zero per-kind guidance. Sizes 126 lines (brief-013) to 1,372 (brief-007). 23/25 carry a duplicate `## Source (pre-modernization)` tail; briefs 004-007's `description` fields are semantically void truncations. Candidate anchor required only beyond 015 (`legacy_brief_ceiling = 15` grandfather, bill:129; adr-069 D3). Graph position: **briefs are terminal in the typed graph** — zero artifacts derive from a brief; all downstream life is off-graph (`@origin` tags, role prompts, beads).

**Three eras (the form was never stable):** Era 1 (001-008, May): invariants + lettered scope items + out-of-scope + sequencing + "The brief commits **intent**, not scenarios" (verbatim in five briefs). Era 1.5 (009-015, June): JTBD/outcome framing; "Output… is not the measure; the behavior change… is" (verbatim in eight briefs); vocabulary sections. Era 2 (016-023, July): candidate-anchored commitments ("The pinned solution shape (from cand-00X, not re-decided here)"). Era 3 (024-025): changelogs + explicit acceptance sections + recorded authority commits.

**Consumption (the empirical reader contract).** 13 briefs have live `@origin` scenario consumption (brief-001 ×19; brief-013 ×5 — the tightest specimen: 126 lines naming its beads, its PDR, and its pinning scenarios); 2 more via retired-scenario provenance (020/021); 022 realized in the role prompts; **brief-024 was executed end-to-end — the migrated repo is the proof — and still sits at `ready`**; 015/016 realized under adjacent adr ids; 4 briefs show no downstream trace at all, including **brief-007: 1,372 lines, status ready, zero consumption ever**. Mis-mint violation specimens: brief-016 (a dated product decision recorded in a brief — the kind has no `decision-makers` field, bill:317), brief-018 (schema-plane change as a brief, bill:318), brief-021 (architecture selection + source-level root-cause in a brief Summary, bill:318); counter-example done right: brief-025's Architect question — "Evidence assembled… without a recommendation" (bill:319). Escalation works: brief-004→pdr-004, brief-005→pdr-006, brief-006→pdr-007.

### Candidate definition

**Job.** A brief is the **commitment contract**: it converts a ratified direction (committed candidate, or accepted PDR in the pre-candidate era) into a bounded, dispatchable unit of work — carrying what the Gherkin cannot: work-split, sequencing, boundary (out-of-scope/No-gos), acceptance bar, and open questions routed to the owning role. It is **not a decision record** (B1, sess-2026-08-05-a.md:32): every decision it relies on is *cited* into it by id and date, never *minted* in it (violation specimens 016/018/021; boundary-held specimen 025).

**Reader contract, in order:** (1) the later PO authoring scenarios — every scope unit scenario-pinnable (13 briefs prove the path); (2) the Architect at pre-state/discriminator — sequencing, vehicle-relevant facts, questions explicitly addressed to them (brief-001.md:162-175; brief-025.md:257-290); (3) the authority at commit — title/description alone state need→outcome so the L0 card is decidable (positive specimen brief-013.md:4; negative brief-025.md:4,9); (4) the reconciler at close — an acceptance surface concrete enough that "done" is checkable (brief-024.md:336; brief-025.md:292-339).

**Content obligations** (each >=2 specimens or external+1): anchor resolves + decisions cited never restated (adr-069 D3; 10 candidate-anchored briefs; violations 016/018) · outcome as observable behavior change, outputs disclaimed (eight-brief house pattern) · work-split into independently dispatchable, sequenced units (001-006 items; 024 phases; 025 steps; consumed at that granularity, commit 9bc5860) · explicit out-of-scope/No-gos with a blown-appetite rule (001-006; brief-025.md:225-226; EXTERNAL-REFERENCE Shape Up circuit-breaker) · acceptance: per-unit accepted-when + DoD, or explicit delegation to named scenario pins (024; 025; delegation form 013) · what-would-NOT-satisfy (004, 005, 006, 014) · open questions routed, not answered, with the escalation trigger named (002/004/005/006 → three minted PDRs; 025) · load-bearing vocabulary where terms are introduced (009, 014, 016, 017, 022) · role-boundary hygiene: PO commits scope/vocabulary, mechanism stays "the Architect's call" (the era-1 refrain; brief-025's dispositions).

**Draft good-enough checklist.** Good enough to commit when: (1) title states need/outcome in product language (013 vs 025 contrast; EXTERNAL-REFERENCE one-pager/working-backwards titling); (2) description stands alone, no id-chain needed (broken specimens 004-006; overloaded 025); (3) the anchor resolves to a committed/accepted upstream; (4) every decision inside is a citation, none minted (016/018/021); (5) outcome is an observable behavior change (8 specimens); (6) work-split units are each scenario-pinnable and independently dispatchable, sequencing stated (001-006, 024, 025); (7) out-of-scope/No-gos named with the blown-appetite rule (001-006, 025); (8) an acceptance surface exists (013, 024, 025); (9) open questions routed to a named role, none blocking units that don't need it (002-E; 025); (10) nothing re-conducts discovery or re-litigates the candidate ("not re-decided here", 017/022; "settled… not to be re-litigated", 025); (11) length proportional to the commitment — 126-line brief-013 fully consumed vs 1,372-line brief-007 never (a brief-specific analog of R3 with its own two specimens, not imported decision doctrine).

### Lifecycle proposal

```
draft --(authority ratifies the commitment: the event 024/025 changelogs already record)--> committed
committed --(first scenario/bead cites it: the observable @origin event)--> in-delivery
in-delivery --(acceptance/DoD met and reconciled)--> delivered
any pre-delivered --> withdrawn | superseded
```

- Rename `ready` → `committed` — the word practice already uses (artifact-lifecycle.md:78-79; brief-024's own mapping treated `committed` as `ready`; the candidate enum has `briefed`/`committed`).
- `in-delivery` optional; the minimum honest machine is `draft → committed → {delivered | withdrawn | superseded}` — but **each terminal flip must be owned** (the bill's reserved question (c), bill:164; the reconciler at `work_done` is the natural `delivered` owner). Without a named owner the terminal states die again — 25/25 specimens prove it: the status machine failed four distinct ways (status never gated consumption — draft brief-001 has 19 live origins; delivery happened without the flip — 024; current `ready` values are migration-mapped, not lived; real states like "paused" have no representation).
- "Paused" stays a bead/sequencing fact, not a status — reversible scheduling, not artifact state (sess-2026-08-04-a.md:21 distinguished it from `withdrawn` explicitly).

### Boundaries

| vs | Boundary | Basis |
|---|---|---|
| candidate | Candidate = the shaped bet; brief = its commitment into work. Re-verifying the candidate's empirical claims at commit is legitimate (brief-025.md:52-68); re-shaping is not ("not re-decided here", 017/022) |
| pdr | PDR decides among options and carries `decision-makers`; brief has no such field by design. A pinned product decision in a brief is a routing failure — cite a pdr id instead (specimen 016, bill:317) |
| scenario | Scenario = one hash-identified behavior; brief = the bundle carrying what Gherkin can't. Handoff = the `@origin` tag (13 specimens) |
| bead | Beads point at the brief (025 names lead-cx7w9/lead-fb3vk; 013 names lead-j8so/lead-q3r1); scheduling state lives on beads |
| intent-record | Intent = direction from discovery; a brief re-opening "why" has drifted upstream (lead-pm "owns the why… never writes scenarios or briefs", bill:297) |
| runbook/spec (no kind today) | brief-024 did a brief's commitment job with a plan's body — brief or missing kind is an elicitation question |

EXTERNAL-REFERENCE (input, never authority): Shape Up pitch/betting table — the candidate kind already IS the pitch (sections match adr-069 D3's requireds); the brief is the post-bet artifact, thicker than Shape Up's because a fleet of non-interactive implementers "cannot ask follow-up questions cheaply" (.claude/agents/lead-po.md:142-144). PRD-lite/one-pager: standalone title+summary read 10× more than the body. DoR/DoD + INVEST: diagnoses why the status machine died — "delivered" had no checkable meaning until 024/025 added acceptance surfaces.

Brief elicitation questions: §7, Sitting 3. Maintenance flags carried: the `Source (pre-modernization)` tails and broken descriptions (a scrub-or-bill question); the stale `scenario-refs/origin-index.txt`; the lead-po.md "product brief" (singular) terminology collision.

## 5. PM-arc kinds — per-kind job, minimal definition, and the collapse question with census facts

**Cross-kind findings shaping every good-enough test below** (each >=2 specimens): **C1 — structural validation proves nothing about content:** intent-900, cand-900, and sess-2026-05-11-a all validate with every required section empty; any good-enough test must be content-level. **C2 — gate-checked obligations get maintained; prose obligations rot:** current-state's gated `incorporates` is perfect while its ungated body is still scaffold; candidate statuses lag their own bodies. **C3 — the candidate status machine is not operated:** cand-002, cand-003, cand-010 each record commitment in their Resolution while frontmatter stays `shaped` — census correction: **9 of 11 candidates are committed by body-truth**, not the bill's "shaped 5, committed 6". **C4 — the PM-arc kinds are the only kinds with structural consumers wired in** (session exit gate; current-state incorporates gate; intent's 13 inbound edges) — their census health is edge-level, not content-level.

### 5.1 intent-record (census: 14, all `recorded` — bill:146)

**Job:** head of the provenance spine — preserve the authority's directional ask (dated verbatim words, the goal behind them, boundaries) before any solutioning. 13 inbound `derives-from` edges verified (11 candidates, pdr-039, brief-024); 2 of 14 intents recorded and never shaped (intent-003, intent-005). **Minimal obligations** (specimen counts): dated verbatim anchors — the audit surface downstream artifacts re-quote (3); goal-behind-the-ask separating means from end (3, incl. the reframing act itself in sess-2026-07-14-a); falsifiable non-goals/failure conditions (3); appetite signal even when non-numeric (4); open threads routed, not decided (2). **Draft good-enough test:** a reader not present can state the ask AND distinguish it from any proposed solution; every anchor dated and verbatim; failure conditions falsifiable, not restated goals; it decides nothing (R1 from the other side — the intent is where the question was asked); non-empty is not the bar — each section would survive the authority reading it back against their own words (C1 floor). EXTERNAL-REFERENCE: continuous-discovery opportunity records (Torres) + the problem half of working-backwards — both agree with observed practice. **Collapse question:** strongest empirical case in the family (most-consumed PM kind; single honest status; intent-012/013 arguably among the corpus's best artifacts of any kind) vs near-1:1 candidate pairing and the dead-letter risk. RACI-DEPENDENT — reserved for lead-jozud.2 (bill §4(d), ruling 6).

### 5.2 candidate (census: 11; frontmatter shaped 5 / committed 6; body-truth 9/11 committed — C3)

**Job:** the shaping vehicle — bound ONE bet (problem, appetite, sketch, rabbit holes, no-gos) so the authority's commit decision is made on a bounded object; the Resolutions show it performing exactly this ("Committed 2026-07-16 by product authority: 'Fund it all'", cand-005.md:464; cand-010's forks resolved "against my recommendations" then committed with a directed build sequence). **Minimal obligations:** empirically grounded problem — commands, probes, PoCs cited (3); appetite with a blown-appetite tripwire (2, incl. counter-specimen cand-001 whose open appetite tracks with never committing); rabbit holes each carrying a bound or named owner/gate (2); no-gos naming where the excluded thing lives (2); evidence re-verified at hand-off, drift graded (2); Resolution naming committer, date, directed conditions (4). **Draft good-enough test:** `shaped` only when every rabbit hole is bounded or routed, appetite names "blown", every empirical claim carries its probe; `committed` only when the Resolution names the authority, date, and conditions — AND the status field says so (three specimens fail that clause today); hand-off bar: the brief carries the candidate's sequence "verbatim… rather than reopening it" (cand-010.md:253) — if the brief author must re-derive the bet, the candidate was not good enough. EXTERNAL-REFERENCE: Shape Up pitch — the required sections map essentially 1:1; done = bounded and de-risked enough to bet on, not fully specified. **Collapse question:** real content division in the strong pairs (intent-012 holds the why; cand-010 the bounded bet — no duplication) and the kind carries the commit ceremony; against — near-1:1 pairing, the intent-013→pdr-039 bypass precedent, 4 of 6 statuses never used. RACI-DEPENDENT, plus status-flip ownership unassigned.

### 5.3 session-record (census: 15 at bill; 16 live — 14 closed, 2 open)

**Job:** the mode's exit gate and the sitting's provenance. Three structural consumers verified: the exit gate ("No session closes without an artifact" — the only kind whose production is *forced*; `produced`/`revised` are its only type-required fields); the doctrine-loop rationale home (pdr-039 Option C keeps rule rationale here; R9 routes ephemera here); next-session reconstruction with retro-annotation (sess-2026-07-19-a superseded-noted, then `revised:` by its successor). Not PM-exclusive in practice: sess-2026-07-19-a was authored by architect + PO. **Minimal obligations:** truthful, complete produced/revised (2 — the consumer chain rests on it; weak floor: the synthetic empty record + the basename-dangle blind spot, bill:168); authority verdicts recorded in substance, attributed and dated (3 — incl. "against my recommendations" fork records and the pdr-039 critique's only durable home); open threads with routing/owners (2); honest failure capture (2 — the 17-artifact anomaly documented, the dead plan preserved under supersession). **Draft good-enough test:** produced/revised complete and truthful; every ruling attributable and recognizable by the authority as their words; threads routed; closed at mode exit (two sit open today); and the sizing clause — a produced list exceeding the review cap is evidence of a bad *session*, faithfully recorded: the record can be good while the session was not, and the definition keeps those judgments separate. EXTERNAL-REFERENCE: decision-journal + lab-notebook practice ("never rewrite, annotate" matches the retro-annotation convention); the exit gate has no external analogue — the kind's distinguishing feature. **Collapse question:** strongest earn in the family ("proven by consumer", bill:147). Open edge: PM-arc kind or all-modes kind — determines who the exit gate binds and who closes open sessions. RACI-DEPENDENT.

### 5.4 current-state (census: 1, `current`)

**Job:** the incorporates-gate target and the outward-claims anchor — one place present-tense truth lives, with a mechanical update obligation at every acceptance ("gate-checked, so every accepted decision must be claimed here. The README and site are outward renderings", current-state.md:93-96). **The defining empirical fact — the kind's split reality:** the gate-checked half is perfectly maintained (61 `incorporates` ids; the gate BLOCKS on archive-inconsistency, bill:353) while the prose half is still template scaffold — `#### <bc-canonical-name>` placeholders observed 2026-07-14 and still present at `updated: 2026-07-27` (two dated observations). It currently performs the *ledger* half of its job and not the *fact-sheet* half, while claiming the README anchors to it — and CS1 (§1.7) shows the filled paragraph asserting contradicted capability. **Minimal obligations:** complete incorporates ledger (gate-enforced); present-tense fact per capability with its decision anchor (the seed shape + the invariants section both demand it); no WHY content (:5-6 — the inverse of the decision kinds); ADR-069 D7 snapshot discipline (:98-104). **Draft good-enough test:** gate green; **no seeded section still a placeholder** (the current specimen fails today); a reader answers "what does the system do right now" without opening a decision record; any why-sentence fails; no outward claim lacks an entry here. Clause two is load-bearing: C2 says ungated prose rots, so either gate section-non-emptiness or accept that the kind is a ledger, not a fact sheet — **a genuine authority choice, not a default**. EXTERNAL-REFERENCE: arc42 living overview / Diátaxis Reference (named in-file as its own lineage) — reference material is pure description and only trustworthy when maintained by a process hook; the gate is such a hook, the empty body shows where none exists. **Collapse question:** n=1, so the earn rests on consumers (the one working per-acceptance gate; the archive interlock) vs "is a hand-maintained fact sheet redundant with a rendered accepted-set view?" RACI-DEPENDENT.

### 5.5 prioritization-record (census: **0 instances ever** — bill:149)

**Intended job:** capture an ordering and its rationale (schema: Ranking, Rationale; draft/active/superseded); "prioritization records order the dispatch queue" (lead-pm mode body). **Actual:** the directory does not exist; the gate does not watch it (open ledger item, bill:221); full authoring ceremony exists unexercised (typedef + three skills) — the inverse of the corpus norm; the one real prioritization ran untyped (findings/prioritization-2026-06-30 — WSJF + MoSCoW over 50 live beads, with full rationale, and its Must-set was evidently consumed); the need was intent-recorded and never shaped (intent-005, no derived-by). **Provisional obligations — each ONE specimen + EXTERNAL-REFERENCE, the permitted minimum; re-ground at the first real instance:** per-item ordering rationale a dissenter could argue with (specimen + prioritization SKILL.md); judgment items surfaced for the authority, not buried in scores (specimen's MoSCoW rationale + EXTERNAL-REFERENCE "scoring narrows the list, judgment makes the final call"); method fitness stated for THIS backlog (specimen's framework-ranking + EXTERNAL-REFERENCE WSJF/RICE/Kano fit practice); dated and supersedable — orderings decay. **Collapse question — the sharpest in the lane, two honest readings:** (i) the *kind* failed — retire it; ordering lives as a session-record outcome until practice demands a type (the 2026-06-30 exercise proves the job can be done well without the kind); (ii) the *system* failed the kind — the sequencing mode was never entered, and the first real multi-intent collision will need it. Either ruling carries mechanical cost (drop → the two-BC coordinated dispatch, bill:226; keep → the gate fix, bill:221). RACI-DEPENDENT.

## 6. Cross-kind material — boundaries between kinds (the specimens), what pdr-039's surviving rules carry, RACI-dependent items listed

### 6.1 Boundaries between kinds — the specimens

The ADR-side routing table is §2.5; the brief-side table §4. The cross-kind synthesis, one row per observed mis-homing class:

| Content class | Observed in (wrong home) | Belongs in | Specimens |
|---|---|---|---|
| Scope/deferral/roadmap/charter | ADRs | PDR / brief | adr-008, adr-061, adr-002 (bill:309-312) |
| Acceptance criteria | ADR | the brief's scenarios | adr-072 D4; brief-025 as the positive form |
| Work-queue triage / sequencing / bookkeeping | ADR | beads / session record | adr-072 D6, D7; adr-029's P3 bead |
| Restated pinned practice | ADR | cite by reference | adr-072 D2/D5; adr-064 D3 (positive) |
| Architecture / mechanism / CLI contracts | PDRs | ADR | pdr-003/004/006/009/019/020/026/029 (§3 table); the four architect-authored PDRs |
| Intent / problem framing | PDRs | intent-record / brief | pdr-015, pdr-017 (self-titled "intent"/"problem framing") |
| Product decision minted downstream | brief | PDR, cited by id | brief-016 (bill:317) |
| Schema-plane change | brief | decision record | brief-018 (bill:318) |
| Architecture + root-cause analysis | brief Summary | decision/evidence home (open: its addenda were load-bearing) | brief-021 (bill:318) |
| Discovery re-opened downstream | brief | intent/candidate | the "not re-decided here" refrain (017, 022, 025) |
| Ephemera / rule rationale / scaffolding | permanent records | session record / changelog / beads | R9; adr-067 D8; pdr-039 Option C |
| Grounding through non-authoritative chains | any kind | outlawed (R6) | spike-precedence rule 2026-07-06; findings-removal 2026-07-17; brief-018/019/023 |
| Boundary held correctly | — | — | brief-025's evidence-without-recommendation (bill:319) |

**The unsettled discriminator:** ADR vs PDR schemas differ today only by `decision-makers` + "Options considered" (sess-2026-08-05-a.md:42-43). Three live cuts: content plane (the instincts rubric), altitude (Framing B's "could a different mechanism satisfy it unchanged?"), decider seat (Framing C; EXTERNAL-REFERENCE: RFC-track typing separates records by who accepts them, bill:334). This is elicitation (§2.6 Q12; §7 Sitting 2), not settled — and it is the same question as lead-jozud.2's RACI charter (A8/X10: kind set M and the RACI cut are OUTPUTS of the definitions).

### 6.2 What pdr-039's surviving rules carry

Validity scope on all of these: **the ADR kind only** — the authority's critique was ADR-only evidence generalized (P1); transfer to any other kind is a per-kind question.

| Rule | Content | Specimens | Status |
|---|---|---|---|
| R1 | Decide the non-default; keep-the-default and deferrals are not decisions | adr-072 whole-record; adr-029 D5 (in-sitting amendment) | RATIFIED, 2 specimens |
| R2 | Every numbered item independently survives triage (decision / tightening / detail) | adr-072, adr-029, adr-067 | RATIFIED, 3 specimens |
| R3 | Length proportional to decision weight | ratified in-sitting; adr-072 (351 lines, rejected); adr-056 rewrite mandate | RATIFIED; first legibility carrier (X11) |
| R4 | Every proposal reaches a terminal state; rejection first-class | adr-072 precedent; 41 stale records corpus-wide | RATIFIED, corpus-quantified |
| R5 | Title and description state the decision | adr-067, adr-029, lead-atiki + 28-title corpus scan | RATIFIED; first machine-check candidate |
| R6 | Active decisions stand on active ground; no grounding through non-authoritative chains | adr-067; 3 briefs; the two 2026-07 findings-plane rulings | RATIFIED; demonstrated multi-kind reach |
| R7 | Supersession must shrink and simplify the active set | adr-067; adr-069 | RATIFIED, 2 specimens |
| R8 | (one plane per record) | one quoted reaction | **DEMOTED** by the authority — bounded observation; safe content already in R2; its content is an open question |
| R9 | No ephemeral scaffolding in permanent records; ephemera lives in session records/beads/changelog | adr-067 D8 (clean); adr-072 D7 (weak); bill's adr-024/adr-061 scrub entries corroborate but are proposals, not verdicts | RATIFIED but **effectively SINGLE-SPECIMEN** → re-confirm at Sitting 1 |
| R10 | No acceptance flip with open forks / failed granularity / missing realization evidence | the one adr-067 flip (the 41-stale pattern supports R4, not R10) | RATIFIED but **SINGLE-SPECIMEN** → re-confirm at Sitting 1 |
| R11 | Recorded structural directives bind authoring; deviation needs explicit sign-off | the one adr-069 dropped-directive event | RATIFIED but **SINGLE-SPECIMEN** → re-confirm at Sitting 1 |

Ratified changelog amendments constraining everything above: (1) scope honesty — v1's evidence base is three ADRs in one sitting; (2) the R8 demotion; (3) "The rules here feed those definitions; they do not substitute for them" (pdr-039.md:110-122).

### 6.3 RACI-dependent register (surfaced, not decided — all feed lead-jozud.2)

Context: no typedef or schema names an authoring role for any kind (bill:303) — the RACI half has no machine surface today. Kind set M and the RACI cut are **outputs** of the definitions, not inputs (X10).

1. PM-arc family survival as separate kinds vs collapse (intent/candidate/session) — bill §4(d), §3 ruling 6.
2. prioritization-record survival — either ruling carries mechanical cost (two-BC dispatch vs gate fix).
3. current-state survival and ledger-vs-fact-sheet identity.
4. session-record scope: PM-exclusive or all-modes (sess-2026-07-19-a authored by architect+PO); who the exit gate binds; who closes open records.
5. Candidate status-flip ownership at commit (PM steward vs committing authority) — the C3 lag has no owner.
6. Intent revision surface: indefinitely revisable under one `recorded` status with no changelog, or a revision surface needed (intent-012's ninth non-schema section).
7. Per-kind re-homing of pdr-039 rules (R9's session-record home; R1's intent-side boundary).
8. Direct intent→decision arc legality (intent-013 → pdr-039, skipping candidate) — legal arc or bypass to forbid.
9. Brief terminal-flip ownership — "which kind owns the brief→BC dispatch handoff" decides whether delivered/withdrawn get real transitions or get cut (bill:164 (c)).
10. The ADR/PDR decider-seat cut and the role-charter six's home (pdr-001/002/005/012/013/033) — the A8 investigation's core.
11. The process-decision surface: 11+ PDRs did process/mechanism work with no process kind — third kind, ADR subtype, or legitimate PDR territory.
12. `beads:` coupling — intended or accidental (X16); whether it belongs in any kind's contract.
13. The strict-frontmatter directive (X4) — recorded, unrouted, Phase-2 sequenced; definitions precede enforcement.

## 7. Open elicitation list — every question the sittings must answer, ordered by which sitting

Single-specimen and INFERRED items from §1 appear here by construction (the R8 rule: they are questions, not criteria). Full context lives in the section cited.

### Sitting 1 — the definition format + the ADR card (§0, §2)

**Format (§0):**
- F1. Ratify the composite card (job + reader contract + tagged checklist + exemplar slot/flip-gate) — or a pure form, or a different composition?
- F2. Confirm carrier sequencing: definitions ratified as per-kind decision records now; write-skills and gate deferred behind the single-source fix; enforcement red-before-green?
- F3. Confirm the exemplar-required flip-gate applies only to kinds surviving the kind-set-M ruling?

**Single-specimen ratified-rule re-confirmations (§6.2):**
- D1. R8's content (one plane per record) — ratify with a second specimen, or leave demoted?
- D2. R9 (no ephemera) — confirm on a second clean specimen before it enters the ADR card?
- D3. R10's flip clauses — confirm independently of R4?
- D4. R11 (structural directives bind) — confirm beyond the one adr-069 event?

**ADR (full text §2.6):** Q1 D1..Dn idiom / does adr-018 meet the bar · Q2 Options required? · Q3 the granularity test in one sentence · Q4 pre-state mandatory for every ADR, capped to load-bearing findings? · Q5 the Consequences line (named work vs queue triage) · Q6 description's job and length bound · Q7 keep the bare-id cross-references section? · Q8 changelog minimum at flip; adr-072 as rejection template? · Q9 rejection-preserves-deliberation as standing convention? · Q10 re-verify pre-state at flip? · Q11 realization evidence in-record or in `incorporates`? · Q12 THE ADR/PDR discriminator — plane or accepting seat? · Q13 legal grounding directions ADR↔PDR · Q14 a home for deferrals-with-trigger? · Q15 role assignments ever legitimate in an ADR? · Q16 test format (checklist / gates / prose)? · Q17 ratify the ~25-word title bound? · Q18 strike/add against the 13-item checklist.

### Sitting 2 — PDR (§3; job-first discovery)

- P-A. Which framing — A (bet ledger), B (needs-altitude + paired mechanism ADR), C (decider-seat general record) — or a fourth of your own?
- P-B. Does "always a PDR / PDR = the PO commitment node" (the self-hedged 2026-07-17 model, P4) still hold?
- P-1. The process mass (11+ of 39): a third record kind, an ADR subtype, or legitimate PDR territory because the product IS the framework?
- P-2. The role-charter six: product decisions, or does the RACI investigation get its own charter kind? (pdr-033 is the corpus's most-consumed PDR — a definition silent here leaves it unclassified.)
- P-3. Standing standards (pdr-001, pdr-039) consumed as rulesets forever: a PDR job, an ADR job, or a distinct governed-document kind?
- P-4. Post-hoc umbrella ratification (pdr-010, pdr-016): a PDR job, or an acceptance flip on the ADRs themselves?
- P-5. Operative-while-proposed (25 of 39; pdr-002/003/011 load-bearing): enforce R4 retroactively at rebaseline, or add an "operative" state?
- P-6. Multi-decision bundles are the norm: bind one-decision-per-record, and split or grandfather at rebaseline?
- P-7. The intent-shaped PDRs (015, 017): hand that job explicitly to intent-record/brief now those kinds exist?
- P-8. Reject-vs-supersede semantics: pdr-031 is `rejected` while accepted pdr-035 claims to supersede it "in full" — which disposition wins?
- P-9. pdr-900: sanction a graph-grounding placeholder form exempt from content obligations, or replace the device?
- P-10. pdr-037's disposition: do the ratified definitions supersede it (fulfilling its decision), amend it, or land as new records leaving an accepted PDR whose promised content never existed?

### Sitting 3 — brief (§4)

- B-A. Ratify the job statement: commitment contract — decisions cited, never minted (the B1+B2 convergence)?
- B-1. Acceptance owner (measurements in the brief, 025 model) or acceptance composer over named scenario pins (013 model) — pick or rank.
- B-2. Who flips `delivered` — Architect at reconciliation, PO, authority — or cut the enum to draft→committed→{withdrawn|superseded}?
- B-3. Rename `ready` → `committed`?
- B-4. Candidate anchor universal going forward (kill the ceiling-15 exemption)? May a brief still anchor directly to a PDR (the 001-006 pattern)?
- B-5. The brief-024 shape: is an executable lead-side spec a brief, or a missing runbook/migration-plan kind?
- B-6. The brief-020/021 shape: correction records with root-cause — briefs, or thin briefs pointing at evidence homed elsewhere? (021's addenda were demonstrably load-bearing.)
- B-7. Vocabulary sections: required when the brief introduces terms?
- B-8. Adopt the need→outcome titling rule kind-wide (013 as the positive template)?
- B-9. The "product brief" (singular, lead-po.md) vs briefs/brief-NNN terminology collision: rename, or fold into current-state?
- B-10. Scrub the `Source (pre-modernization)` tails (23 briefs) and broken descriptions — in the rewrite bill or a maintenance pass?
- B-11. Reference realizations inside briefs (003's pipeline, 021's shim): keep or route?

### Sitting 4 — PM-arc kinds (§5; with/after the kind-set-M ruling)

- M-1. Family collapse or survival: intent / candidate / session as separate kinds (register item 1).
- M-2. prioritization-record: retire (ordering lives in session records until practice demands a type) or keep (fix the gate, enter the sequencing mode)? Either way, the mechanical cost fires.
- M-3. current-state: ledger or fact sheet — gate section-non-emptiness, or accept ledger-only and drop the fact-sheet claim?
- I-a. Ratify "everything traces to intent" as the kind's invariant (I1, single-specimen)?
- I-b. Is the verbatim-anchors section a content obligation of the intent kind (I2)?
- I-c. Intent revision surface (register item 6)? I-d. Direct intent→decision arcs legal (register item 8)?
- C-a. Ratify "candidate = provisional bet nothing contractual hangs from" (C1, single-specimen)?
- C-b. Who flips candidate status at commit (register item 5)? C-c. Ratify the shaped/committed good-enough clauses as drafted (§5.2)?
- S-a. Adjudicate the session schema vs generated-skill divergence (S1). S-b. Ratify the R9 ephemera-home job for the kind (S2). S-c. PM-only or all-modes (register item 4)? S-d. Who closes the two open records?
- CS-a. Ratify the current-state truth discipline: every claim traceable to demonstrated behavior; no placeholders in non-seed status (CS1)?
- PR-a. Define prioritization-record from zero: confirm intended reader and job. PR-b. Accept the three provisional obligations on the explicit condition they are re-grounded at the first real instance?

### Cross-sitting / standing

- X-a. Legibility roots per kind (verbosity, buried decisions, altitude, rendering) — explicitly "to discover, not assume" (X11); each card carries a legibility clause or says why not.
- X-b. `beads:` coupling — intended or accidental (X16); the schema half of every definition waits on it.
- X-c. Strict-frontmatter directive routing (X4) — Phase-2 sequenced; confirm definitions precede enforcement and no green check is believed before a planted-defect red.
- X-d. Rewrite-forward acceptance (X13): confirm each ratified good-enough test is usable verbatim as the rewrite acceptance test for that kind's records.

Nothing in this packet is ratified. Every SINGLE-SPECIMEN and INFERRED item above is a question by construction; the sittings turn them into criteria or strike them.
---

## Verification annex — adversarial pass results (folded, not smoothed)

Two verifiers: an R8-failure-mode hunt (single-specimen criteria, smuggled recommendations) and a completeness/fidelity check against sources. Where a verdict conflicts with the body, the verdict wins.

- **[OMISSION-FOUND]** Packet per-sitting sequence: Sitting 1 ratifies the format and works the ADR card; PDR at Sitting 2; brief at Sitting 3; only the PM-arc kinds (Sitting 4) wait on the kind-set-M ruling
  — The packet omits the authority's second same-session directive and the recorded NEW SEQUENCE that supersedes the packet's own. sess-2026-08-05-a.md:41-46: 'Do not assume that these are the right artifacts... I've heard of a brief, but never heard of a PDR. One professional product manager was confused when I said PDR and not PRD'; :77-78: 'Revised sitting sequence: sitting 0 decides the artifact SET from the resolution map; per-kind definitions follow for surviving kinds only.' Bead lead-jozud.2 comment 2026-08-05 10:24 ('SET-LEVEL DEEPENING... NEW SEQUENCE: (a) definition-foundation pack + (b) common-practice atlas -> (c) resolution map -> sitting 0 decides the SET -> per-kind definitions for survivors only') supersedes the 10:16 comment ('ADR first, PDR second, brief + PM-arc after') that the packet's sequence implements. Under the current record ALL per-kind cards — including ADR and PDR — wait on sitting 0, not just the PM-arc kinds; the common-practice atlas track and the vocabulary-anchoring directive ('bespoke because needed vs bespoke by accident', :66-68) appear nowhere in the packet.
- **[REFUTED]** §2.3/§2.4 checklist item 6 — 'Options real': grounded in 'three specimens + EXTERNAL-REFERENCE (MADR)'; §2.3 says the Options section is 'present in all three specimens'
  — adr-067 has NO Options section at all (its H2/H3 set is Context, Pre-state findings, Decision, Consequences, Changelog — adrs/adr-067.md:17-317). adr-029 carries 'Alternatives considered' only inside its '## Source (pre-modernization)' legacy appendix (adr-029.md:178,298), not the live body. Only adr-072 has a live '### Options considered' (adr-072.md:139). The criterion therefore rests on ONE live specimen plus an external reference — an R8-failure-mode instance mislabeled as three-specimen. The packet's own hedge ('the weakest-grounded item') understates this: its specimen count is wrong, not just weak. By contrast the adjacent claim that all three specimens carry a pre-state section IS correct (adr-029.md:24, adr-067.md:30, adr-072.md:31).
- **[REFUTED]** §1.5 I2 / §7 I-b — intent-013 carries a 'Verbatim anchors' section 'no schema requires'
  — The intent-record schema REQUIRES 'Verbatim anchors' — the live re-poured skill reads: 'those required sections are: Verbatim anchors, The goal behind the ask, Who it serves, Constraints, Non-goals, Appetite signal, Failure conditions, Open threads' (.claude/skills/write-intent-record/SKILL.md:24). All 14 intent records carry the heading, including the generated synthetic intent-900 (empty). sess-2026-08-03-a.md:61-63 already referred to 'the schema's eight' sections. Elicitation question I-b as framed rests on an inverted premise; the real question (empty-but-valid vs meaningful anchors, per C1) survives, but the packet's factual claim does not.
- **[REFUTED]** §1.6 S1 / §7 S-a — 'the generated write-session-record skill names sections (Mode, Produced artifacts, Outcome) diverging from the live schema — the kind's authoring channel contradicts its schema' (present tense)
  — True at sess-2026-08-03-b's open (:54-58) but fixed before the packet was assembled: the same session record's Outcome (:31-36) states the lead-ulris fix 'completed the full loop — fix sourced live from shop-knowledge, release v0.55.0 cut and delivered, lead skills re-poured, and the enforcement demonstrated red on a planted defect'. The live skill now names exactly the schema's sections: 'Outcome, Open threads' (.claude/skills/write-session-record/SKILL.md:24,28). S-a is moot as an adjudication item unless reframed historically.
- **[WEAKENED]** Carrier caution (§0): 'the typedef→skill channel is broken and divergent for 7 of 8 kinds, so doctrine landed there today becomes a third copy'
  — Stale premise. The 7-of-8 divergence was the 2026-08-03 measurement (findings/typedef-doctrine-carrier-feasibility-2026-08-03.md:40-51); sess-2026-08-03-b.md:31-36 records the fix landing (v0.55.0, skills re-poured, red-demonstrated), and the live skills now match the schema (write-pdr carries 'Options considered', .claude/skills/write-pdr/SKILL.md:24; write-candidate opens 'exploring', write-candidate/SKILL.md:28). The practical conclusion (don't route definition text into write-skills now) still has support on OTHER grounds — poured skills are clobbered byte-for-byte on update (rebaseline-bill.md:214) and the doctrine-carrier slices 2-3 never landed (finding :261-272) — but the packet's stated reason is no longer true of the live host. Note bd lead-8xgdq remains open, apparently as unswept hygiene (its note points at closed lead-ulris).
- **[REFUTED]** §0: 'Every mechanism the composite uses is already ratified working practice in this repo; no new governance to invent'
  — The exemplar-slot flip-gate ('the card cannot flip accepted while the exemplar slot is empty') has zero in-repo precedent: no kind conditions acceptance on an exemplar, and the corpus's exemplar state is the opposite — 'the corpus contains no exemplar' (pdr-039.md:23-26; sess-2026-08-04-a.md:39-42). Its cited anchor, 'the per-kind authoring the sitting sequence already commissions (sess-2026-08-05-a.md:54-55)', points at the pdr-039 amendment sentence, which commissions no exemplar authoring. This is a recommendation smuggled as settled fact — the exact options-open failure the packet was checked for. The other three composite parts do have real grounding (job/needs: pdr-037; reader contract: pdr-035.md:76-79 + adr-072.md:281-286; changelog-grown checklist: pdr-039 Option C, pdr-039.md:37-43).
- **[WEAKENED]** §0 micro-example reader-contract clause (c): the reader can 'see in Context what facts would have to change for the decision to be worth revisiting', grounded on adr-072.md:347-350
  — Single-specimen and a stretched reading: adr-072.md:346-350 is the rejection CHANGELOG's anti-re-litigation clause ('a future proposal... is a fresh decision to be made on its own merits'), which neither states nor implies a Context obligation to name revisit-triggers. No second specimen is offered. Clauses (a) and (b) of the micro-example are properly multi-specimen (adr-067/adr-029 title verdicts + cdb8919; pdr-035.md:76-79 + adr-067's superseded-reliance verdict). Clause (c) is an R8-failure-mode instance inside the packet's flagship example and should be demoted to an elicitation question.
- **[WEAKENED]** Carrier caution: 'per-kind records honor the standing one core-schema record + one per type directive (R11)' as grounds for ratifying definitions as per-kind decision records now
  — Double stretch. (1) The directive is scoped to the schema restructure — 'one core-schema record + one per type' (sess-2026-08-04-a.md:32-33, about adr-069 aggregating all eight TYPE SCHEMAS); applying it to definition cards is analogy, not the directive. (2) R11 is single-specimen by the packet's own audit (§6.2: 'RATIFIED but SINGLE-SPECIMEN → re-confirm at Sitting 1', question D4) — so the carrier recommendation leans on a rule the packet itself queues for re-confirmation. The recommendation may still be right (pdr-037's sectioned-needs home is real), but this grounding is the packet using a single-specimen rule as load-bearing while elsewhere flagging it.
- **[WEAKENED]** Title-bound quantification: §1.1 A3 says '28 of 69 titles exceed 25 words'; §2 and §2.4 item 3 say '27/69'
  — Internal inconsistency carried without note. Live measurement reproduces 27/69 (adr-072 was retitled 60→22 words in commit cdb8919, per lead-atiki comment 2026-08-03); the bead's 28/69 predates that fix. Both defensible, but the packet presents them as the same fact in different sections. Also minor attribution smear: the gibberish quote is the authority's verbatim (lead-atiki comment 2026-08-03 19:54, confirmed), but proposing it 'as the first machine check / first enforcement rule' was the ROUTER's framing (sess-2026-08-03-a.md:110-112), not the authority's.
- **[WEAKENED]** Citation accuracy across the packet
  — A handful of citations point to the wrong lines or over-quote: 'sess-2026-08-05-a.md:42-43' for the pdr-037/schema-delta confirmation (actually :57-58; :42-46 is the never-quoted PDR/PRD passage — see the omission verdict); 'sess-2026-08-05-a.md:54-55' for commissioned per-kind authoring (those lines record the pdr-039 amendments); §3's pdr-010 'derives-from and derived-by are the SAME seven ADRs' (derived-by additionally carries adr-048); 'adr-072 (351 lines)' (350); X4 renders the lead-j7t0j directive as an authority quote 'The schema should be strict for front-matter' where the bead reads 'FRONT-MATTER SCHEMA MUST BE STRICT: reject unrecognized keys (closed field set)' — substance right, quotation marks unearned. None of these flips a conclusion; all should be corrected before a sitting.
- **[CONFIRMED]** §0/§1 authority verdict ledger — the commissioning bar, the pdr-039 critiques, the three ADR adjudications, and the RACI thread are quoted accurately with correct ratification status
  — All load-bearing quotes reproduce verbatim: commissioning bar (sess-2026-08-05-a.md:36-37), principle-set critique (:22-24), PDR trust disclosure (:25-29), R8 demotion (:30-31; pdr-039.md:114-117), brief non-decision (:32), definitions-precede-rules (pdr-039.md:121-122). adr-072 rejection + per-item triage + anti-re-litigation confirmed (adr-072.md:338-350); adr-067 six verdicts and R10-violation changelog confirmed (sess-2026-08-04-a.md:30-38; adr-067.md:319-332); adr-029 revocation confirmed (sess-2026-08-04-a.md:39-42) and the source-coverage note is right that adr-029 carries no changelog recording it (adr-029 has no Changelog section at all); RACI verbatim confirmed (lead-jozud.2 description); lead-ut1e6 close reason confirms 'stays an open question to be brought fresh if wanted'. R1's two specimens (adr-072 + adr-029 D5 amendment, pdr-039.md:124-126) check out.
- **[CONFIRMED]** Corpus quantifications used as criterion grounding (§2, §4, §5)
  — Independently reproduced: 27/69 ADR titles >25 words and 62/69 descriptions not ending in a complete sentence (live measurement); 24 distinct @origin ADR ids in features/ (packet's own-census figure exact; the carried 30-32 bill discrepancy is honest); @origin:adr-056 ×23, @origin:brief-001 ×19, 8 distinct PDR origins across 11 files, 13 distinct briefs origin-cited, brief-013 ×5; feature-prose pdr-033=28, pdr-003=16, pdr-010=15, pdr-032=14, pdr-023=13; adr-018 derived-by=53; current-state incorporates=61 ids carrying exactly the 12 accepted PDRs (current-state.md:18); PDR statuses 25/12/1/1; briefs draft 20/ready 5, 23/25 pre-modernization tails, brief-013=126 lines vs brief-007=1,372/ready/zero-origin, brief-024 ready; candidates 5 shaped/6 committed; intents 14 recorded with intent-003/005 lacking derived-by; sessions 16 live (14 closed, 2 open); pdr-900 four empty body sections; intent-900 and sess-2026-05-11-a empty-but-valid (C1); the current-state '#### <bc-canonical-name>' placeholder still present at updated: 2026-07-27.
- **[CONFIRMED]** The pdr-037 hole and the adr/pdr schema delta (the packet's foundational facts)
  — pdr-037 (accepted) decides per-kind needs 'as one sectioned PDR (one section per kind)' (pdrs/pdr-037.md:41-45) and its body carries no per-kind section; corroborated at rebaseline-bill.md:303 ('its 69-line body contains none') and sess-2026-08-05-a.md:57-58. Schema delta confirmed: adr requires Context/Decision/Consequences only while pdr adds 'Options considered' + decision-makers (findings/typedef-doctrine-carrier-feasibility-2026-08-03.md:42-43; sess-2026-08-05-a.md:58; bill:162). pdr-035 self-containment quoted correctly (pdr-035.md:76-85) and pdr-035 does claim to supersede rejected pdr-031 'in full' (pdr-035.md:93-94), so elicitation P-8 is a real conflict.
- **[CONFIRMED]** §3 PDR job archaeology — statuses, authorship strata, consumption channels, and the per-record characterizations
  — Spot-checks all hold: architect-authored = exactly pdr-016/019/020/022; lead-pm stratum = pdr-032..039; pdr-010's circular edge set real (derives-from = derived-by∩ the same seven adr-011..017); pdr-015/017 self-titled 'solution-space framing (intent...)'/'problem framing (intent...)'; pdr-016 'locked (pinned by ADR-029)' at :76; pdr-023 'Product authority, verbatim points 1–3' at :61,245; pdr-018/020/027 titles as characterized; pdr-002 governs the shipped primer (.claude/shop/primer.md 'dispatched per PDR-002'). The three framings are presented as genuine options with grounding on both sides and no recommendation — the options-open discipline holds in §3.
- **[CONFIRMED]** §4 brief material — eras, refrains, consumption, mis-mint specimens, dead status machine
  — 'The brief commits **intent**, not scenarios' verbatim in five briefs (001/002/003/004/005); 'is not the measure' family in 8 briefs; briefs 004-007 descriptions are void truncations (verified frontmatter); terminal statuses never used (draft 20/ready 5/delivered 0/withdrawn 0); brief-001 has 19 live origins while status draft (status never gated consumption); mis-mint specimens brief-016/018/021 and the brief-025 counter-example match rebaseline-bill.md:317-319; escalation to minted PDRs is real in brief prose (brief-004:50 flags PDR-004, brief-005:54 flags PDR-006, brief-006:97 defers to PDR-007's decision) though NOT in frontmatter edges — the packet doesn't claim edges, so this stands; work-split consumption at unit granularity confirmed via commit 9bc5860; lead-po.md:139-144 'cannot ask follow-up questions cheaply' verbatim; sess-2026-08-04-a.md:21 'paused, not withdrawn' verbatim. Minor: the ready→committed rename's lifecycle-doc anchor is thin (artifact-lifecycle.md:78-79 says only 'the PO owns the commitment'; the brief lifecycle is explicitly 'not yet audited' at :154) — but it is posed as question B-3, so acceptable.
- **[CONFIRMED]** §5 PM-arc survey — C1-C4 cross-kind findings and the candidate body-truth correction (9/11 committed)
  — C3 verified directly: cand-002 ('Committed 2026-07-14', :255-257), cand-003 ('Committed 2026-07-15', :159-161), cand-010 ('Committed 2026-08-03 by the product authority', :228) all carry frontmatter status: shaped — with the 6 frontmatter-committed, body-truth is 9/11, correcting bill:145. cand-005:463-464 'Fund it all' verbatim; cand-010:253 brief-carries-sequence-verbatim claim accurate (:233-235); sess-2026-08-02-b.md:9 'resolved the open shaping forks with the product authority' confirmed, and its Outcome adds 'against my recommendations' (also quoted in §5.3). C1 confirmed (intent-900/cand-900/sess-2026-05-11-a all-empty-but-valid). sess-2026-07-19-a authored by architect+PO confirmed. Prioritization-record zero-instances and the untyped 2026-06-30 exercise match bill:149; §5.5's one-specimen+external labeling complies with the packet's stated minimum rule.
- **[CONFIRMED]** Beads-and-memories evidence base (P4, B2, C1-candidate, I1, X10-X16) exists as cited
  — The 2026-07-17 object-graph memory carries verbatim: 'ALWAYS a PDR', 'never a PM bet (candidate). Pointing scenario origin at a candidate = a MISTAKE (ties contract to a provisional bet)', 'BRIEF is DEMOTED... OPTIONAL OFF-SPINE... JOINS... never on the provenance path', 'EVERYTHING TRACES TO INTENT... legacyRoot:true', self-hedged 'works for now, prove out in practice'. The 2026-07-17 spike/findings-removal memory (with 2026-07-06 basis) grounds X12; the 2026-07-08 ownership memory grounds X15 (packet correctly notes its findings/ mention is superseded). lead-jozud comments 2026-08-04 19:59/20:11 confirm X13 verbatim (CRUFT ELIMINATION, rewrite-forward); lead-jozud.2 10:16 confirms X10 and the five-slot template verbatim; lead-nvs7i 'to discover, not assume' and lead-d0jmz 'intended or accidental' verbatim; lead-fb3vk 2026-07-29 'the AUDIT SURFACE is the derived TERMS' verbatim. The packet's status labels on these (RECORDED / SINGLE-SPECIMEN → §7 question) are accurate — P4, B1/B2, C1, I1, CS1 are all correctly converted to elicitation questions rather than criteria.
- **[CONFIRMED]** Packet-wide R8-discipline self-audit — SINGLE-SPECIMEN flags on ratified rules R9/R10/R11 and the §7 question conversion
  — The packet's own flags match the record: R9's only clean specimen is adr-067 D8 (sess-2026-08-04-a.md:36-37) with adr-072 D7 a weak second; R10's flip clauses rest on the single adr-067 acceptance event (adr-067.md:319-332) while the 41-stale pattern indeed supports R4 not R10 (bill:15,73); R11 rests on the single adr-069 dropped-directive event (sess-2026-08-04-a.md:31-33). All three are correctly queued as Sitting-1 re-confirmations (D2-D4) rather than used as settled criteria — with the one exception already flagged (the carrier caution leaning on R11). Aside from the specific findings above (Options-item mislabeling, micro-example clause (c), exemplar flip-gate), no other checklist item was found resting on fewer specimens than it claims; external references are consistently marked EXTERNAL-REFERENCE and none is presented as in-repo practice.
- **[CONFIRMED]** §1 verdict ledger fidelity: the authority quotes in A1-A9, P1-P4, B1-B3, C1-C2, I1-I2, S1-S2, CS1, and X1-X16 are accurate to their sources
  — Every quoted verdict re-read at source and confirmed verbatim or faithful-in-substance: commissioning bar (sess-2026-08-05-a.md:36-37), principle-set critique (:22-24), PDR trust disclosure (:25-29), R8 demotion (:30-31), brief-not-decision-record (:32), adr-072 rejection language (adr-072.md:338-350), per-item triage (adr-072.md:341-346), adr-067 six verdicts (sess-2026-08-04-a.md:33-38; adr-067.md:319-332), adr-029 revocation (:39-42), RACI thread (lead-jozud.2 description, verbatim), lead-atiki title verdict (comment 2026-08-03 19:54, verbatim), lead-j7t0j trust-break verbatim incl. 'The schema should be strict for front-matter', the 2026-07-17 object-graph memory (P4/B2/C1/I1 all verbatim), X10 template-slots quote (lead-jozud.2 comment 10:16, verbatim), X11 (lead-nvs7i 'to discover, not assume'), X12 (both memories exist: spike-precedence 2026-07-06 + spike-plane-excluded 2026-07-17), X13 (lead-jozud 20:11 CRUFT ELIMINATION/rewrite-forward), X14 ('The AUDIT SURFACE is the derived TERMS', lead-fb3vk 2026-07-29), X16 (lead-d0jmz 'intended or accidental'). pdr-039's three changelog amendments and Option B/C text all match. 'bd memories quality' returning no matches also confirmed.
- **[REFUTED]** §6.2 (and §1.1 A3/A4) label R5, R6, R7 as RATIFIED and R9-R11 as 'RATIFIED but single-specimen'
  — Only R1-R4 were ratified in-sitting. Both pdr-039.md:123-128 ('R5–R11 distilled ... and ratified by this record's acceptance') and sess-2026-08-04-a.md:51-52 ('its acceptance ratifies R5–R11; R1–R4 were ratified in-sitting') condition R5-R11 ratification on pdr-039's acceptance — which 'remains held' (pdr-039.md:122; sess-2026-08-05-a.md:54-56, 87). The packet's own legend says RATIFIED means 'already ratified on record', so R5/R6/R7 rows in §6.2, A3's 'RATIFIED', and the R9-R11 'RATIFIED but' phrasing overstate status. Practical consequence: Sitting 1's agenda re-confirms only R8-R11 (§7 D1-D4) when R5-R7 equally await ratification. The underlying verdicts (title gibberish, superseded reliance, aggregating supersession) are genuine and multi-specimen — it is the rule-ratification status that is wrong.
- **[OMISSION-FOUND]** The verdict ledger and the §0 per-sitting sequence reflect everything the authority ruled on 2026-08-05
  — The largest gap in the packet. sess-2026-08-05-a.md:39-52 records a SECOND directive the ledger omits entirely: 'Do not assume that these are the right artifacts ... I've heard of a brief, but never heard of a PDR. One professional product manager was confused when I said PDR and not PRD', plus the scalability-limit/'hasn't at all been a waste' balance. lead-jozud.2 comment 2026-08-05 10:24 (SET-LEVEL DEEPENING) and sess-2026-08-05-a.md:62-78 then set a NEW SEQUENCE that supersedes the 10:16 proposal the packet's §0 table follows: (a) definition-foundation pack + (b) common-practice atlas → (c) resolution map → 'sitting 0 decides the artifact SET ... per-kind definitions follow for surviving kinds only', with a novelty-budget principle ('bespoke because needed' vs 'bespoke by accident'). The packet's Sittings 1-3 (ADR/PDR/brief cards before any set ruling) contradict this; its kind-set gating (F3, Sitting 4) covers only PM-arc kinds when the authority put the whole set — including PDR vocabulary itself — in scope for sitting 0. §1.2 also lacks the 'never heard of a PDR' verdict, which bears directly on Sitting 2's framings (a rename/PRD-anchored option is live but absent from Framings A-C). The common-practice-atlas twin track is nowhere in the packet.
- **[CONFIRMED]** §3 PDR archaeology: actual-job classifications on the sampled records (pdr-003, pdr-010, pdr-018, pdr-020, pdr-031, pdr-033, pdr-037, pdr-900) and the corpus vitals
  — All sampled classifications hold on full read. pdr-003 is pure file-contract/update mechanics with scenario amendments ('ADR-shaped', ✓). pdr-010 is a post-hoc umbrella whose derives-from/derived-by both name adr-011..017 (circular, ✓ — derived-by additionally carries adr-048, a trivial imprecision in 'the SAME seven'). pdr-018 is a genuine authority-shaped MVP acceptance gate (KEEP, ✓). pdr-020 is launcher/image architecture authored by lead-architect ('clearest architecture-in-disguise', ✓). pdr-031 is rejected while accepted pdr-035's description claims 'On acceptance it supersedes PDR-031 (fully)' yet its frontmatter supersedes only pdr-032 (P-8 contradiction real, ✓). pdr-033 is the PM/PO role charter (✓). pdr-037's Decision (pdr-037.md:41-45) promises per-kind needs 'authored as one sectioned PDR' and its 69-line body carries no per-kind section (✓, matches bill:303 and lead-jozud.2). pdr-900 has all four body sections empty (✓). Census exact: 25 proposed / 12 accepted / 1 rejected (pdr-031) / 1 superseded (pdr-032); current-state incorporates carries exactly the 12 accepted PDRs; primer.md:7 cites PDR-002.
- **[CONFIRMED]** §3 consumption measurements: @origin and feature-prose citation counts
  — Re-measured independently, all exact: @origin:adr-056 ×23, @origin:brief-001 ×19, 24 distinct ADR ids and 8 distinct PDR ids in @origin tags, @origin:pdr-* across 11 feature files; case-insensitive feature-prose citations pdr-033: 28, pdr-003: 16, pdr-010: 15, pdr-032: 14, pdr-023: 13 — the packet's exact figures. adr-018 carries 53 derived-by back-edges as claimed.
- **[CONFIRMED]** §2 ADR census facts: 62/69 truncated descriptions; 27/69 (§2) vs 28/69 (§1.1 A3) over-long titles
  — 62/69 descriptions not ending in a complete sentence confirmed exactly (the 7 complete: adr-056, adr-067..072). Current title count >25 words = 27/69 (my measure), matching §2; lead-atiki's bead says 28 of 69 — measured before adr-072's title was cut from 60 to 22 words the same session (recorded in the bead), which reconciles both figures. The packet carries 28 (A3) and 27 (§2) without noting the discrepancy or its cause — a small unflagged inconsistency, not an error.
- **[CONFIRMED]** §4/§5 census and specimen facts (briefs, candidates, intents, session records, current-state, prioritization-record)
  — All verified: 25 briefs, draft 20 / ready 5, terminal statuses never used (bill:144); brief-001 draft with 19 live @origin; brief-024 ready despite execution; brief-007 1372 lines / brief-013 126 lines exact; 23/25 'Source (pre-modernization)' tails; brief-013 names lead-j8so/lead-q3r1 and derives from pdr-024/019. Candidates 11 (frontmatter shaped 5 / committed 6); C3 body-truth confirmed — cand-002 ('Committed 2026-07-14'), cand-003 ('Committed 2026-07-15'), cand-010 ('Committed 2026-08-03') all record authority commitment while frontmatter stays shaped; cand-005.md:464 'Fund it all' exact; 'against my recommendations' is at sess-2026-08-02-b.md:20-21 (the session record, as §5.3 attributes it). Intents 14, all recorded. Sessions 16 files, 14 closed / 2 open (08-04-a, 08-05-a). current-state: 61 incorporates, '#### <bc-canonical-name>' placeholder still present at line 70 under updated: 2026-07-27, why-content prohibition at :5-6, gate-obligation text at :92-95. prioritization-record: no directory exists, zero instances; findings/prioritization-2026-06-30 exists untyped — §1.8's empty ledger stands (no memory, bead, or session verdict on the kind found).
- **[WEAKENED]** X9's parenthetical '0 rejections in 69 ADRs while 41 records linger proposed' attributed to lead-jozud.1
  — lead-jozud.1's ratification comment says '0 rejections in 69 ADRs while 17 linger proposed' (ADR-scope, at ratification time). The 41 figure is the bill's later cross-corpus count (bill:15: 16 proposed ADRs + 25 proposed PDRs). The substance survives via bill:15/:73, but the quote as attributed conflates two sources and two scopes.
- **[WEAKENED]** pdr-018 characterized as 'the dummy-product spike IS the MVP acceptance gate (8 conditions)'
  — The gate list in pdr-018's Decision ('satisfied only when ALL hold') runs 1-9, not 8: (8) every wall is a bead validated by re-running, (9) the single BC implements a real (trivial) feature. Classification (KEEP, genuine authority-ratified bar) holds; the condition count is off by one.
- **[WEAKENED]** §0 citation accuracy for the 2026-08-05 confirming evidence and the commissioning of per-kind authoring
  — Two line-number miscitations in §0: the pdr-037-hole/schema-delta confirmation is cited as sess-2026-08-05-a.md:42-43 but lives at :57-58 (:41-46 is the omitted set-level directive — the miscitation likely masks the omission); the exemplar-slot rationale cites sess-2026-08-05-a.md:54-55 'the per-kind authoring the sitting sequence already commissions', but :54-55 is the pdr-039 amendment/bill-deferral line — the commissioning lives in the description (:9) and open threads (:69-73). Content exists in the record in both cases; the anchors are wrong. Also minor: the micro-example's clause (c) ('see in Context what facts would have to change') is grounded on adr-072.md:347-350, which is changelog fresh-decision language, not a Context-section specimen — no in-repo specimen actually shows a Context stating revisit conditions, making clause (c) the card's weakest-grounded clause (worth flagging at Sitting 1 rather than presenting as grounded).
- **[CONFIRMED]** The candidate definitions (§2, §4, §5) cover the jobs the corpus shows each kind performing
  — Per-kind job coverage checks out against the corpus: the ADR card's reader contract covers all observed consumption (scenario @origin anchoring, dispatch citation per adr-064 D3 at adr-064.md:132, pre-state surface, gate edges, acceptance sitting, incorporates join); the §3 tally buckets absorb every sampled PDR job with the odd shapes surfaced as questions (P-1 process mass, P-3 standards, P-4 umbrellas, P-9 placeholder); the brief card covers commitment, work-split, acceptance, escalation-to-PDR (brief-004→pdr-004 etc.), and routes the correction-record (B-6) and runbook (B-5) shapes as questions; all 8 kinds have cards or definitions. Two residual coverage gaps, both minor next to the set-level omission: (1) the 'Source (pre-modernization)' duplicate tails also sit on ADRs and PDRs (adr-029:178, pdr-003:256, pdr-010:155) but the scrub question (B-10) is raised only for briefs — the ADR/PDR cards are silent on the appendix mass their own rewrite tests must handle; (2) §3's framings lack the rename/industry-anchor option the omitted PDR/PRD verdict makes live (covered in the omission row).
- **[WEAKENED]** Source-coverage note: 'adr-029's changelog does not record the exemplar revocation'
  — Understated: adr-029 has no Changelog section at all (sections are Context/Decision/Consequences/Source only). The substantive point — the revocation verdict lives only in sess-2026-08-04-a.md:39-42 and pdr-039.md:23-26 — is confirmed and if anything stronger than stated.

**Lane flags:**

- verdict-ledger: prioritization-record has an empty verdict ledger — definition must be elicited from zero
- verdict-ledger: candidate/intent/session/current-state kinds have no direct authority quality verdicts; only single-specimen or inferred signals
- verdict-ledger: R9, R10, R11 each rest on effectively one specimen despite being ratified in pdr-039 — flag for re-confirmation in the ADR sitting
- verdict-ledger: adr-029 changelog does not record the exemplar revocation; the verdict exists only in sess-2026-08-04-a and pdr-039 context
- verdict-ledger: bd memories quality returned no matches — older feedback was recovered via the feedback query and full-listing scan instead
- verdict-ledger: drafts/rebaseline-bill.md Part-B rulings are proposals, not authority verdicts — excluded from the ledger
- adr-candidate: Read-only maintained: nothing under /workspace was modified
- adr-candidate: Lane discrepancy carried, not smoothed: @origin ADR-citation counts differ by method/tree (my features/-only grep: 24 distinct ADR ids; bill 1: 32 distinct decision ids; bill 4: 30 adr ids feature-cited; bill's own lane disagreement 3 documents the id-class dispute)
- adr-candidate: Frontmatter-edge counts differ by method: my typed-dir script found 435 adr-targeted edges vs bill [tool] 482 of 867 — magnitudes agree, scopes differ (bill includes current-state incorporates and all 11 link fields)
- adr-candidate: adr-029 carries no Changelog section; its verdicts live only in sess-2026-08-04-a — the revocation is not annotated on the record itself (possible R4/R9 follow-up for the F7 rewrite)
- adr-candidate: Checklist item 6 (Options considered) is the weakest-grounded: specimens all carry the section but no authority verdict demands it and the machine schema does not require it — held open as elicitation Q2 rather than asserted
- pdr-archaeology: 25 of 39 PDRs are status:proposed yet several (pdr-002, pdr-003, pdr-011) are load-bearing in the shipped primer and feature corpus — the current-system view excludes most operative doctrine
- pdr-archaeology: pdr-031 is status:rejected while accepted pdr-035 claims to supersede it in full — reject-vs-supersede semantics undefined
- pdr-archaeology: pdr-010 has identical derives-from and derived-by ADR sets (adr-011..017) — circular provenance from post-hoc ratification
- pdr-archaeology: pdr-900 is an accepted PDR with all four body sections empty (sanctioned synthetic placeholder, unclassifiable under any decision-record definition)
- pdr-archaeology: The four architect-authored PDRs (016, 019, 020, 022) are exactly the most architecture-shaped specimens — authorship seat predicts the boundary violation
- brief-commitment: Read-only compliance: nothing under /workspace was modified.
- brief-commitment: The authority's brief-025 critique ('title doesn't represent a need/solution; description is a mess of references') was not found verbatim in-repo; it is treated as live direction from the lane commission and supported by in-corpus contrast (brief-013 vs brief-025 title/description).
- brief-commitment: scenario-refs/origin-index.txt is stale (pre-migration slugs, briefs 001-015 only); all consumption tallies were re-derived from live grep over features/, not from the index.
- brief-commitment: Legacy migration damage worth a maintenance pass: 23/25 briefs carry a duplicate 'Source (pre-modernization)' body and briefs 004-007 have semantically broken description fields (truncated first-line grabs).
- pm-arc-kinds: RACI-DEPENDENT: PM-arc family collapse (intent/candidate/session) reserved for lead-jozud.2 — bill s4(d)/s3 ruling 6
- pm-arc-kinds: RACI-DEPENDENT: prioritization-record survival — zero instances ever; either ruling carries mechanical cost (two-BC dispatch vs gate fix)
- pm-arc-kinds: RACI-DEPENDENT: current-state ledger-vs-fact-sheet identity — gate-checked half maintained, prose half is template scaffold since at least 2026-07-14
- pm-arc-kinds: RACI-DEPENDENT: session-record scope — already used by non-PM roles (sess-2026-07-19-a), exit-gate binding unassigned
- pm-arc-kinds: RACI-DEPENDENT: candidate status-flip ownership — 3 candidates body-committed but frontmatter shaped (cand-002, cand-003, cand-010)
- pm-arc-kinds: DATA CORRECTION to census: bill s4 'shaped 5, committed 6' understates body-truth — 9 of 11 candidates committed per their own Resolution sections
- pm-arc-kinds: WEAK-SPECIMEN WARNING: intent-900, cand-900, sess-2026-05-11-a all validate with empty sections — structural validation cannot be the good-enough test
- pm-arc-kinds: SINGLE-SPECIMEN CAVEAT: all prioritization-record criteria rest on one untyped specimen (findings/prioritization-2026-06-30) plus EXTERNAL-REFERENCE — re-ground at first real instance
- pm-arc-kinds: PRECEDENT: intent-013 derived directly by pdr-039, skipping the candidate stage — pipeline bypass legality undecided
- definition-format: READ-ONLY honored: nothing under /workspace modified; only read files and ran read-only shop-knowledge projections
- definition-format: pdr-037 hole independently confirmed: Decision promises one section per kind (pdr-037:41-45); body carries none
- definition-format: Carrier caution for the sitting: definition text must not land in write-<kind> skills or shop-templates yet — the typedef→skill channel is broken and divergent for 7/8 kinds (findings/typedef-doctrine-carrier-feasibility-2026-08-03.md §1a); doctrine there now becomes a third copy
- definition-format: Exemplar-required flip-gate should apply only to kinds surviving the kind-set-M ruling (bill §3 ruling 6); prioritization-record has zero instances ever (bill:149)
- definition-format: R-rule reuse in the ADR micro-example is legitimate for the ADR kind only — the authority's critique was ADR-only evidence generalized to all kinds; R8 content used nowhere
- definition-format: External references (Diátaxis/Nygard reader-orientation, checklist practice, rubric anchor papers, DoD) marked EXTERNAL-REFERENCE throughout, framed as input not authority
