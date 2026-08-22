---
type: migration-plan
id: migration-plan
revision: 2
supersedes: rebaseline-bill (2026-08-04)
owner: product-authority
status: draft
created: 2026-08-22
updated: 2026-08-22
---

# Migration plan: rebaseline against the approved basis

Census run 2026-08-22 by four independent lanes over the live tree,
verifying the 2026-08-04 census where it overlapped and judging
everything after it fresh. This plan is the rebaseline's action table
plus the run order for `definition-chain-migration`; approving it starts
Phase 1.

## How to rule

**Vocabulary for this document.** A *chain* is a type's full definition
of good (typedef, guideline, fitness set, process, roles, compiled
skill); one `definition-chain-migration` run builds a chain and rewrites
that type's keepers through it. Actions: *keep-rewrite* — content still
binding, re-authored through the chain; *keep* — stays as-is, no rewrite
(scenarios and operational files); *retire* — value passed, moves to an
archive branch (never `main`); *terminal* — junk or never-advanced,
deleted or closed as never-accepted. The *F-codes* in reason cells are
the census's rewrite families — clusters of decision records that
collapse into one rewritten record each (F2 fleet … F15 licensing). The
*trust break* is the 2026-08-03 quality failure that triggered the
re-founding (intent-013).

**Ask 1 (block): approve the action table and run order.** Every row
carries its lane's one-line evidence. **Ask 2 (three rulings): the
authority calls below** — each has a recommendation and a default.
Silence on a call is itself handled: the default carries it into the
decision-chain run's review as an open item; nothing is retired or
deleted by silence.

## Summary

| lane | records | keep-rewrite | keep | retire | terminal | authority-call |
|---|---|---|---|---|---|---|
| decisions (adrs, pdrs) | 108 | 87 | — | 17 | 0 | 4 |
| PM records (intents, candidates, briefs, sessions) | 67 | 28 | — | 31 | 7 | 1 |
| docs, findings, drafts, root, junk | 143 | 16 | 5 | 115 | 7 | 0 |
| scenarios (live pins) | 893 pins | — | 860 keep | 27 | — | 6 |
| **records total (md)** | **318** | **131** | **5** | **163** | **14** | **5** |

Scenario notes: scenarios are already the system's native format —
keepers stay as-is; the prior census's 153-hash retirement never
executed and mostly dissolves: of its old set, only the pdr-031 surface
files and the three templates writing-skill files retire (the knowledge
directory is live contract). `scenario-refs/origin-index.txt`
is stale since 2026-07-04 and regenerates mechanically.
`features-provisional/devcontainer` retires per the authority's
2026-07-04 "no current use" ruling; `features-provisional/docs` retires
with adr-008 (shopsystem-docs is a dead letter). The test-harness
authority flag resolved during census: `shopsystem-test-harness` is now
in `bc-manifest.yaml`, so its feature file keeps and adr-002
keep-rewrites.

## Run order (one `definition-chain-migration` run per type)

1. **principle-set (architecture scope)** — spec `01-principles.md`
   rewrites into the architecture principle set; smallest run, chain
   nearly complete, everything downstream cites it.
2. **decision records (adr, pdr)** — the trust break lived here; 87
   keepers, the largest judgment mass. The chain review settles the
   standing kind-set question (ADR vs PDR boundary, RACI) with the
   lead-jozud.2 evidence — the old separate gate is absorbed into this
   run's review.
3. **framework spec (02–06 + artifact-lifecycle, consumer-wiring,
   README, current-state, structurizr)** — the outward face, rewritten
   once decisions are stable.
4. **PM records (intent, candidate, brief, session)** — 28 keepers; the
   session-record chain partly exists (handoff process approved).
5. **findings** — 4 ADR-cited keepers get the finding chain; the other
   95 retire without one.
6. **scenario sweep** — mechanical close-out: retire the listed files,
   regenerate scenario-refs, no chain needed (native format).

Junk trees (`terminal`) delete at execution start; retire mass moves to
archive branches at each run's `archive-retired` step.

## Authority calls (Ask 2)

1. **adr-033 (BC-local architect role)** — never realized; the pinned
   loop is Implementer→Reviewer only. *Recommend retire*: the role
   system re-founds through chains; a needed seat gets decided fresh.
   Default: held to the decision-chain review.
2. **adr-046 (shop-shell CA exemption)** — adr-046 decided to remove
   shop-shell's certificate-authority exemption, but the code still
   carries the exemption: the record says one thing, the running system
   does another. *Recommend retire*: the as-built behavior gets its
   decision fresh in the operations chain. Default: held to the
   decision-chain review.
3. **The system-BOM bundle (adr-047 + pdr-030 + brief-015 +
   features/system-manifest, 6 pins)** — pinned yet unrealized for
   months; no `system-manifest.yaml`, no tool. *Recommend retire the
   records and file one backlog work item carrying the intent verbatim*
   — the same pattern that preserved the sc06 scenario body in the
   memory close-out. Default: held to the decision-chain review.

## Action table — decisions (lane A, 108 rows)

| id | status | action | reason |
|---|---|---|---|
| adr-001 | accepted | keep-rewrite | Genesis; folds into F2 fleet record (now five+ BCs) |
| adr-002 | accepted | keep-rewrite | Contested fact resolved: harness BC now in manifest |
| adr-004 | accepted | keep-rewrite | F2 fleet identity; bc-launcher live |
| adr-005 | accepted | keep-rewrite | F2; manifest mechanism live, header cites it |
| adr-006 | accepted | keep-rewrite | F3 addressing/registry; shop-msg live |
| adr-008 | accepted | retire | shopsystem-docs is a dead letter; no tags, not in manifest |
| adr-009 | accepted | keep-rewrite | F3 clarify vehicle; re-verify deferred primitive first |
| adr-010 | accepted | keep-rewrite | F3 clarify hash-scope rule; still binding |
| adr-011 | accepted | keep-rewrite | F3 bd-msg field mapping; live |
| adr-012 | accepted | keep-rewrite | F3 outbox atomicity; live |
| adr-013 | accepted | keep-rewrite | F3 dependency honoring; live |
| adr-014 | accepted | keep-rewrite | F3 heartbeat-in-watch; watcher is this shop's mechanism |
| adr-015 | accepted | keep-rewrite | F3 nudge liveness; live |
| adr-016 | accepted | keep-rewrite | F3 CLI-owned state changes; live |
| adr-017 | accepted | keep-rewrite | F3 shared work_id cross-reference; live |
| adr-018 | accepted | keep-rewrite | F5 empirical-verification discipline; quoted in live primers |
| adr-019 | accepted | keep-rewrite | F4 canonicalization ownership; scenarios CLI live |
| adr-020 | accepted | keep-rewrite | F3 abstract addressing; live registry |
| adr-021 | accepted | keep-rewrite | F2 bc-base image ownership; images published |
| adr-022 | accepted | keep-rewrite | F2 centralized rebuilds; live build path |
| adr-023 | proposed | retire | Superseded-in-fact by adr-025 (journal re-homed) |
| adr-024 | accepted | keep-rewrite | F4 journal rebuild; sc06-deferral clause scrubbed at rewrite |
| adr-025 | accepted | keep-rewrite | F4 journal-as-file; live scenarios tooling |
| adr-026 | accepted | keep-rewrite | F9 broker architecture; broker healthy |
| adr-027 | accepted | keep-rewrite | F3 respond directionality; live |
| adr-028 | accepted | keep-rewrite | F9 broker-as-supporting-service; live |
| adr-029 | accepted | keep-rewrite | F7 mandatory rewrite; doctrine-loop record |
| adr-030 | accepted | keep-rewrite | F7 spike isolation contract; pinned scenarios |
| adr-031 | accepted | keep-rewrite | F7 wall protocol; pinned |
| adr-032 | accepted | keep-rewrite | F7 spike output form; pinned |
| adr-033 | accepted | authority-call | Role never realized; pinned loop is Implementer-Reviewer only |
| adr-034 | superseded | retire | Superseded by adr-067 |
| adr-035 | superseded | retire | Superseded by adr-067 |
| adr-036 | accepted | keep-rewrite | F8 CLI-vs-prose enforcement; wrapper live |
| adr-037 | accepted | keep-rewrite | F8 spec-distribution boundary; still binding |
| adr-038 | accepted | keep-rewrite | F2 product-identity derivation; live |
| adr-039 | accepted | keep-rewrite | F2 release cadence; live |
| adr-040 | accepted | keep-rewrite | F10 Footing bootstrap; ~30 bootstrap features |
| adr-041 | accepted | keep-rewrite | F2 launch diagnostics; live |
| adr-042 | proposed | retire | Status-correction non-decision; open leg stale |
| adr-043 | accepted | keep-rewrite | F10 compute-once coordinates; 2nd-most origin-cited |
| adr-045 | proposed | keep-rewrite | F9 CA transport realized at shop-shell; needs terminal state |
| adr-046 | proposed | authority-call | Record contradicts as-built shop-shell exemption |
| adr-047 | proposed | authority-call | Scenarios pinned; system-manifest.yaml still nonexistent |
| adr-048 | proposed | keep-rewrite | F12 fabro substrate realized; recover dates at rewrite |
| adr-049 | proposed | keep-rewrite | F12 vault-sole-credential; may fold into F9 |
| adr-050 | proposed | keep-rewrite | F12 launch parity; realized |
| adr-051 | proposed | keep-rewrite | F12 loop graph; poured and pinned |
| adr-052 | proposed | keep-rewrite | F13 dagger substrate; pinned dagger-ci features |
| adr-053 | proposed | keep-rewrite | F13 no-divergence rule; live |
| adr-054 | proposed | keep-rewrite | F13 build-egress credentials; live |
| adr-055 | proposed | keep-rewrite | F13 CA-trust base layer; live |
| adr-056 | accepted | keep-rewrite | F4 mandatory rewrite; most origin-cited (~10 decisions) |
| adr-057 | accepted | keep-rewrite | F12 pour projection; poured .fabro pinned |
| adr-058 | proposed | keep-rewrite | F12 reactive watcher; recover falsified date at rewrite |
| adr-059 | superseded | retire | Superseded by adr-067 |
| adr-060 | accepted | keep-rewrite | F4 block-only hash alignment; live |
| adr-061 | accepted | keep-rewrite | F15 licensing doctrine; collapses with adr-066 |
| adr-062 | proposed | keep-rewrite | F12 cross-runtime anchor; recover falsified date |
| adr-063 | accepted | keep-rewrite | F2 model mapping; verify via bc-launcher work_done |
| adr-064 | proposed | keep-rewrite | F4 retirement convention; this rebaseline's citation target |
| adr-065 | accepted | keep-rewrite | F7 findings-authority rule; may merge into doctrine |
| adr-066 | accepted | keep-rewrite | F15 Peters grant; skills poured and used |
| adr-067 | accepted | keep-rewrite | F14 mandatory rewrite; adopted fields only |
| adr-068 | accepted | keep-rewrite | F14 read-side CLI; verbs live |
| adr-069 | accepted | keep-rewrite | F14 per-type schema; gate green |
| adr-070 | accepted | keep-rewrite | F14 writing-skill structure; 8 skills poured |
| adr-071 | accepted | keep-rewrite | F14 writing-skill enforcement; check passes 8/8 |
| adr-072 | rejected | retire | Rejected; archive as-is |
| pdr-001 | proposed | keep-rewrite | F6 role system; router pattern live |
| pdr-002 | proposed | keep-rewrite | F6 subagent topology; content awaits kind-set review |
| pdr-003 | proposed | keep-rewrite | F8 CLAUDE.md propagation; pour live |
| pdr-004 | proposed | keep-rewrite | F2 container command ownership; live |
| pdr-005 | proposed | keep-rewrite | Folds into F6 roles record |
| pdr-006 | proposed | keep-rewrite | F2 manifest ownership; live |
| pdr-007 | accepted | keep-rewrite | F3 name addressing; live |
| pdr-009 | accepted | keep-rewrite | F3 CWD resolution; live |
| pdr-010 | accepted | keep-rewrite | F3 bd/shop-msg authority split; live |
| pdr-011 | proposed | keep-rewrite | F5; collapses into ADR-018 discipline record |
| pdr-012 | proposed | retire | PM half superseded by pdr-033; structurizr half carried to F6 |
| pdr-013 | proposed | retire | Three-tier half died with adr-067; splitting lives as skill |
| pdr-014 | proposed | keep-rewrite | F8 skill-group pour/graduation; live |
| pdr-015 | proposed | keep-rewrite | F4 journal intent; joins journal record |
| pdr-016 | proposed | keep-rewrite | F7 spike lifecycle; 8 pinned scenarios |
| pdr-017 | proposed | retire | Intent framing consumed by broker standup |
| pdr-018 | proposed | retire | One-shot MVP gate consumed |
| pdr-019 | proposed | retire | Decomposition/dispatch plan consumed |
| pdr-020 | proposed | keep-rewrite | F10 lead shell; sessions run inside it |
| pdr-021 | accepted | keep-rewrite | F10 Footing runway; live |
| pdr-022 | accepted | keep-rewrite | F9 provisioning delegation; tool exists |
| pdr-023 | proposed | keep-rewrite | F8 provenance marker; grounds live pour |
| pdr-024 | proposed | keep-rewrite | F10 doctor; bin/doctor exists |
| pdr-025 | proposed | retire | Named script absent; family re-adjudicates at chain review |
| pdr-026 | proposed | keep-rewrite | F2 image provenance labels; live |
| pdr-027 | proposed | keep-rewrite | F6 empty-repo discovery trigger; live standing rule |
| pdr-028 | proposed | keep-rewrite | F2 bootstrap version check; live |
| pdr-029 | accepted | keep-rewrite | F3 vehicle catalog; live |
| pdr-030 | proposed | authority-call | System BOM pinned yet unrealized; rides adr-047 ruling |
| pdr-031 | rejected | retire | Rejected; its scenario surface retires with it |
| pdr-032 | superseded | retire | Superseded by pdr-035/037 line |
| pdr-033 | accepted | keep-rewrite | F6 PM-mode re-cut; only accepted RACI record |
| pdr-034 | proposed | retire | Superseded-in-fact by intent-013 rebaseline |
| pdr-035 | accepted | keep-rewrite | F14 needs statement; grounds adr-067 line |
| pdr-036 | accepted | keep-rewrite | F14 read-CLI needs; realized |
| pdr-037 | accepted | keep-rewrite | F14 per-kind needs; rewrite writes missing sections |
| pdr-038 | accepted | keep-rewrite | F14 writing-skill mandate; realized |
| pdr-039 | proposed | keep-rewrite | Governing instrument; flips accepted at doctrine-loop exit |
| pdr-900 | accepted | retire | Self-described legacy synthetic grounding |

## Action table — PM records (lane B, 67 rows)

| id | status | action | reason |
|---|---|---|---|
| intent-001 | recorded | keep-rewrite | Spine root of PM system; want ongoing |
| intent-002 | recorded | retire | Fulfilled via briefs 020/021 |
| intent-003 | recorded | keep-rewrite | Spend observability unbuilt; live want |
| intent-004 | recorded | retire | Superseded by intent-012 reframe |
| intent-005 | recorded | keep-rewrite | Ordering need unmet; feeds kind-set review |
| intent-006 | recorded | retire | Fulfilled 07-25; approach superseded by intent-013 |
| intent-007 | recorded | keep-rewrite | Spine parent of committed cand-005 |
| intent-008 | recorded | keep-rewrite | Foundational-statement need is the live arc |
| intent-009 | recorded | retire | Fulfilled; CLI live, only bugfix beads remain |
| intent-010 | recorded | keep-rewrite | Per-kind definitions is current direction |
| intent-011 | recorded | keep-rewrite | Authoring-guidance want re-founds |
| intent-012 | recorded | keep-rewrite | Live epic; grounds cand-010/brief-025 |
| intent-013 | recorded | keep-rewrite | Governing instrument of the rebaseline |
| intent-900 | recorded | retire | Synthetic reconstruction; historical |
| cand-001 | shaped | retire | Realized; superseded by restructuring |
| cand-002 | shaped | retire | Delivered via briefs 017/020/021 |
| cand-003 | shaped | terminal | Never committed; superseded by cand-010 |
| cand-004 | shaped | retire | Parked; rebaseline supersedes |
| cand-005 | committed | keep-rewrite | Origin-cited x5; committed-arc exemplar |
| cand-006 | committed | retire | Delivered as pdr-035 |
| cand-007 | committed | retire | Delivered as pdr-036 |
| cand-008 | committed | retire | Delivered as pdr-037; re-founds under kind-set review |
| cand-009 | committed | retire | Delivered as pdr-038; skills shipped |
| cand-010 | shaped | keep-rewrite | Live first bet under intent-012; frozen not dead |
| cand-900 | committed | retire | Synthetic grounding; historical |
| brief-001 | draft | keep-rewrite | Most origin-cited lane record (x19 pins) |
| brief-002 | draft | keep-rewrite | Origin-cited x4; bootstrap scenarios live |
| brief-003 | draft | keep-rewrite | Origin-cited x2; activation is this session's watcher |
| brief-004 | draft | keep-rewrite | Origin-cited x2; container isolation live |
| brief-005 | draft | keep-rewrite | Origin-cited x1; manifest live |
| brief-006 | draft | keep-rewrite | Origin-cited x3; registry/inbox live |
| brief-007 | ready | retire | Never dispatched; its anchored ADRs keep their content through the F-family rewrites |
| brief-008 | draft | terminal | Orphan draft; never advanced |
| brief-009 | draft | keep-rewrite | Origin-cited x5; journal shipped |
| brief-010 | draft | terminal | Draft never ready; never advanced |
| brief-011 | draft | terminal | Draft never ready; superseded framing |
| brief-012 | draft | terminal | Draft never ready; never advanced |
| brief-013 | draft | keep-rewrite | Origin-cited x5; healthy-bootstrap live |
| brief-014 | draft | keep-rewrite | Origin-cited x2; rides F3 catalog rewrite |
| brief-015 | draft | authority-call | Rides the system-BOM ruling |
| brief-016 | draft | terminal | Draft never ready; re-homes per RACI specimen |
| brief-017 | draft | keep-rewrite | Origin-cited x2; live capability |
| brief-018 | draft | keep-rewrite | Origin-cited x1; re-homes in F14 rewrite |
| brief-019 | draft | keep-rewrite | Origin-cited x2; validation CLI shipped |
| brief-020 | ready | retire | Delivered; fabro provider fix shipped |
| brief-021 | ready | retire | Delivered; egress shim shipped |
| brief-022 | draft | terminal | Draft riding terminal cand-003; zero feature citations |
| brief-023 | draft | keep-rewrite | Origin-cited x1; gate CLI live |
| brief-024 | ready | retire | Executed 07-25; rebaseline supersedes |
| brief-025 | ready | keep-rewrite | Freeze-paused live commitment; re-anchors |
| sess-2026-05-11-a | closed | retire | Synthetic genesis reconstruction |
| sess-2026-07-09-a | closed | retire | Closed history; artifacts carry content |
| sess-2026-07-14-a | closed | retire | Closed history; intents carry content |
| sess-2026-07-14-b | closed | retire | Closed history; intents carry content |
| sess-2026-07-15-a | closed | retire | Closed history; line terminal anyway |
| sess-2026-07-16-a | closed | retire | Closed history; migration consumed |
| sess-2026-07-19-a | closed | retire | Closed history; known dangle noted |
| sess-2026-07-20-a | closed | retire | Closed history; withdrawal recorded |
| sess-2026-07-25-a | closed | retire | Closed history; artifacts carry it |
| sess-2026-07-27-a | closed | retire | Closed history; intent-012 carries reframe |
| sess-2026-08-02-a | closed | retire | Closed history; findings in intent-012 |
| sess-2026-08-02-b | closed | retire | Closed history; cand-010 carries shape |
| sess-2026-08-03-a | closed | retire | Closed history; outcomes carried |
| sess-2026-08-03-b | closed | retire | Closed history; intent-013 records direction |
| sess-2026-08-04-a | open | keep-rewrite | Open doctrine loop; produced pdr-039 |
| sess-2026-08-05-a | closed | keep-rewrite | Post-census; redirect not re-homed yet |
| sess-2026-08-05-b | closed | keep-rewrite | Post-census; live new-basis thread |

## Action table — scenarios (lane C, by directory; file rows only where different)

| path | files | pins | action | reason |
|---|---|---|---|---|
| features/agent-vault-broker/ | 1 | 15 | keep | Live broker contract; service running |
| features/dagger-ci/ | 4 | 4 | keep | Live CI-gate contracts adr-052..055 |
| features/shopsystem-bc-launcher/ | 67 | 222 | keep | Live fleet contract; RETIRED markers are completed retirements |
| features/shopsystem-knowledge/ | 27 | 141 | keep | Live contract, gate green — except four pdr-031 files below |
| features/shopsystem-knowledge/active_digest_generation.feature | 1 | 3 | retire | Rejected pdr-031 surface, no successor |
| features/shopsystem-knowledge/authoring_discovery.feature | 1 | 5 | retire | Rejected pdr-031 surface |
| features/shopsystem-knowledge/single_source_projection.feature | 1 | 4 | retire | Rejected pdr-031 surface |
| features/shopsystem-knowledge/distribution_boundary.feature | 1 | 3 | retire | Rejected pdr-031 surface |
| features/shopsystem-messaging/ | 58 | 153 | keep | Strongest-grounded contract; watcher runs on it |
| features/shopsystem-scenarios/ | 15 | 43 | keep | scenarios 0.3.1 live contract |
| features/shopsystem-templates/ | 116 | 296 | keep | Live BC — except three writing-skill files below |
| features/shopsystem-templates/writing_skill_template_structure.feature | 1 | 3 | retire | Writing-skill mechanism re-authors for smaller kind set |
| features/shopsystem-templates/writing_skill_enforcement.feature | 1 | 5 | retire | Same |
| features/shopsystem-templates/lead_skill_artifact_validation_gate.feature | 1 | 4 | retire | Same |
| features/spike-lifecycle/ | 1 | 8 | keep | @origin:pdr-016; live |
| features/system-manifest/ | 1 | 6 | authority-call | Rides the system-BOM ruling (Ask 2.3) |
| features/test-harness/ | 1 | 5 | keep | Resolved: shopsystem-test-harness now in bc-manifest.yaml |
| features-provisional/devcontainer/ | 17 | — | retire | Authority 2026-07-04: no current use |
| features-provisional/docs/ | 5 | — | retire | Retires with adr-008 (shopsystem-docs dead letter) |
| scenario-refs/origin-index.txt | 1 | — | keep (regenerate) | Stale since 2026-07-04; bin/gen-scenario-refs re-runs |

## Action table — docs, findings, drafts, root, junk (lane D, 143 rows)

Keep-rewrite (16): spec 01–06; README.md; current-state.md;
artifact-lifecycle.md; consumer-wiring.md; structurizr/;
drafts/artifact-system-restructuring.md (the initiative this plan
executes); findings/adopter-journey-exploration-2026-06-18.md,
findings/external-content-license-compatibility.md,
findings/iterative-experimentation-capability.md,
findings/bc-workloop-single-source/02-oq1-generation-spike.md (the four
ADR-cited findings).

Keep as-is (5): CLAUDE.md, INSTALL.md, AGENTS.md, both docs/runbooks.

Terminal (7 trees, deleted): .fabro-e2e-scratch/, .specstory/, scratch/,
scratch_bodies/, scratch_k6xq/, scratchpad/, scratchpad-bodies/.

Retire (115): all other findings, all other drafts, and
work-summary.md — the full per-file list is Appendix A below; every
row's reason is "value passed / consumed / superseded" with no ADR
citing it as governing.

## Execution notes

- Retire mass moves to archive branches (the memory-archive pattern:
  parentless branch, never on `main`); terminal deletes outright.
- The 153-hash retirement from the old census dissolves: hashes re-mint
  mechanically wherever contracts are re-authored; only the listed
  scenario files retire as files.
- Keeper counts by run: run 2 carries 87 decision records; run 4
  carries 28 PM records; runs 1, 3, 5 are small.
- Edge closure verified: every keep-rewrite child has a keep-rewrite
  parent on the provenance spine.

## Appendix A — lane D retire rows (115 files)

drafts/ (18): artifact-definition-packet, definition-format-decision-brief,
definition-format-research, grounding-record-demo-framework-spec,
grounding-record-exp-iter1..5, grounding-researcher-prompt-hardened,
knowledge-tools-and-skills-analysis, memory-action-table (executed),
probe-grounding-record-corpus-scope,
probe-grounding-record-graceful-shutdown (+v2),
process-definition-pilot, rebaseline-bill (superseded by this plan),
skills/test-driven-development/ (2 files).

findings/ top level (16): architect-prestate-verification-discipline,
from-mechanism-observation-v1, from-prototype-1,
independent-mvp-review-2026-06 (+WORKPLAN),
install-walkthrough-2026-06-15,
provision-template-value-format-probe-discipline,
scenario-retirement-rides-contract-vehicle-not-nudge,
scenario-supersession-and-dispatch-discipline,
templates-publishing-flow-2026-06-23,
typedef-doctrine-carrier-feasibility-2026-08-03,
venv-install-hygiene-and-fix-tooling-discipline,
bc-lifecycle/01-graceful-shutdown-recommendation,
bc-workloop-single-source/01-generation-mechanism-design,
ddd/00-current-state-inventory, ddd/01-artifact-options-research.

findings/ddd/research/ (3): A-per-context-definition-artifacts,
B-strategic-map-artifacts, C-discovery-and-fit.

findings/prioritization-2026-06-30/ (6): 00-decision-and-research,
01-wsjf-report, 02-moscow-report, 03-contrast, 04-prioritized-list,
factors.

findings/progressive-disclosure/ (10): 00-plan through
09-handoff-P01-collision-reconciliation.

findings/scenario-integrity/ (5): 00-design through
04-mirror-and-cutover.

findings/archive/ (56): agent-vault-credential-spike,
dummyco-spike-iter-2..7, fabro-2pc-as-steps-spike,
substrate-candidate-comparison-vs-fabro, dagger-spike/ (13 files),
fabro-spike/ (19 files), fabro-spike/fabro-defs/ (14 files).

root (1): work-summary.md.
