---
type: action-table
id: memory-action-table
subject: bd-memories
rows: 67
revision: 4
owner: product-authority
status: draft
created: 2026-08-22
updated: 2026-08-22
---

# Action table: the 67 frozen memories

All writes to the agent memory tool (`bd remember`) were frozen by your
ruling of 2026-08-21; the 67 memories below are that frozen set.
Cross-session state is now carried by conversation anchors — the session
records, review records, and work items the approved conversation types
write — so the memory channel's job is gone and this table settles its
contents.

## How to rule

One block decision closes this table (rev 4, per the authority's
rulings of 2026-08-22): **approve all 67 rows** — 55 retire, 11
route-to-chain, 1 to backlog. No memory becomes a new document. All 67
export verbatim to the archive branch `archive/memory-2026-08` — never
stored on `main`, so it cannot poison context; reachable deliberately.
`bd forget` runs in bulk (the single sanctioned exception to the write
freeze). The 11 route-to-chain rows get a pointer note on the work of
the definition chain that will consume them — where "is this discipline
still needed?" is decided with full context, at chain review. The sc06
scenario body goes into a backlog work item carrying the verbatim text.
Classification was performed 2026-08-22 by four independent agents
searching the corpus per memory; the authority then ruled that
disciplines and process-bound rules route to chains rather than becoming
old-format records.

## Route-to-chain (11 rows) and backlog (1 row)

Retired from the memory channel like every other row (archived, then
forgotten); each additionally gets a pointer note on the work item of
the definition chain that will consume it. Whether the discipline is
still needed is decided at that chain's review.

| key | rule or content carried | consuming chain |
|---|---|---|
| operational-hazard-david-2026-07-08-never-recreate | authority-issued safety rule: broker recreate is operator-only; in-session bounce kills the live session | agent-vault / broker operations process |
| silent-agent-exit-failure-mode-a | bc-status must gate on agent-process liveness; stale-checks probe `ps`; supervisor/auto-restart | bc-launcher liveness process + scenarios |
| confirmed-correcting-my-earlier-ret | bc-status tracks watch registration, not agent liveness; marker-inject is the authoritative liveness test | bc-launcher liveness process + scenarios |
| bc-container-start-agent-also-false | start-agent's liveness gate must check the actual claude process | bc-launcher liveness process + scenarios |
| fabro-fixes-stranded-by-delivery-path | work_done + green release + green rebuild are not proof; scout relaunch/runtime-inspect after fabro-path releases (adr-063 cites this memory by name) | reconcile-and-close / delivery-verification chain |
| shopsystem-effectiveness-the-fabro-engage-was-never-validate | unit-scenario proof insufficient; router scout-launches end-to-end after first delivery | reconcile-and-close / delivery-verification chain |
| duplicate-dispatch-check-closed-beads | pre-dispatch rule: search closed work items before any request_bugfix | dispatch process chain |
| router-pre-dispatch-gap-lead-qi0q-2026-06 | reconcile a stale work-item premise against adr/ and pdr/ before dispatch (adr-045 cites the lesson by name) | dispatch process chain |
| router-architect-effectiveness-the-17e9342e-re-pin-ruling | cross-version import-source assertions confirmed against the actual target version | dispatch process chain (architect pre-state verification) |
| router-effectiveness-i-missed-a-real-2nd-blocked | on a Monitor event, verify the BC substrate, never just the mailbox snapshot | router monitor-handling process |
| resume-2026-07-04-lead-architect-handoff-before | scenario-ownership model: `@bc` owner on the scenario; cross-BC scenario owned by one integration-point BC | scenario/feature typedef chain |
| deferred-revised-sc06-body-5174e405a19358fa-per-adr-024 | the deferred revised sc06 scenario body (adr-024 D2 cites only its hash) | **backlog work item carrying the verbatim body** (authority ruling: content rides in the registry, not the archive) |

## Retire (55 rows)

Two rows moved here by the authority's rulings:

| key | justification |
|---|---|
| standing-directive-david-2026-07-06-from-now | fabro-dogfood directive was overridden in practice; the authority recognizes the override — retire |
| lead-shop-ownership-rule-david-2026-07-08 | the ownership boundary will resurface and be re-decided fresh; rescuing the stale rule would prejudge it — retire |

The original 53:

| key | justification |
|---|---|
| artifact-object-graph-provenance-model-2026-07-17 | governed: adr-067 (provenance spine, derives-from edges) and brief-024 fold in all 2026-07-17 object-graph decisions |
| bc-base-dep-pin-plumbing | invariant pinned in features/shopsystem-bc-launcher/bc_base_self_pin_poll.feature; rest operational status |
| bc-bd-backend-can-wedge-on-launch-empty | operational recovery recipe; underlying defect pinned in standup/scaffold/beads features |
| bc-wedge-recovery-recipe | operational how-to; liveness gap tracked as work item lead-2z9po |
| bd-cwd-drift-trap | stale: lead host carries no repos/ checkouts per adr-018; scenario no longer exists |
| bd-dolt-push-via-agent-vault | operational how-to; no decision |
| correction-to-shopsystem-effectiveness-silent-agent-exit-sta | operational diagnostic heuristic; no contract-level decision |
| docker-only-onboarding-prototype-landed-in-lead-repo | status snapshot; artifacts in repo, governed by INSTALL.md and adr-043 |
| fabro-429-is-oauth-system-prompt-gate-NOT-rate-limit | root cause governed in brief-017; stakeholder record intent-002 |
| fabro-429-resilience-PROVEN-at-runtime | milestone snapshot; framing superseded by brief-017 |
| fabro-substantive-work-blocker-is-429-fail-fast | superseded diagnosis (brief-017); method rests on adr-018 |
| handoff-2-2026-07-14-fleet-ops-fleet | fleet status snapshot plus operational recipes |
| handoff-2026-06-27-pre-clear-shopsystem-adopter | directive governed by pdr-023; rest bootstrap snapshot |
| handoff-2026-07-14-pm-preclear | governed by brief-017 and intent-002; rest pre-clear status |
| handoff-2026-07-14-pre-clear-arc-1 | governed by adr-058, adr-061, watcher real-server feature pin |
| handoff-2026-07-17-pre-reboot | governed by cand-005, sess-2026-07-16-a, adr-066 |
| handoff-2026-07-18-legacy-migration-resume | status snapshot; governed by brief-024 and session records |
| handoff-2026-07-25-uhxoc-restructuring-proposed | sess-2026-07-25-a records it; artifacts exist as intent-008..011, cand-006..009, pdr-035..038, adr-067..071 |
| handoff-2026-08-02-verifiable-grounding-shaping | binding content in cand-010; intent-012 and sess-2026-08-02-b govern the rest |
| handoff-2026-08-05-dialogue-mode | sess-2026-08-05-a records the mode correction verbatim |
| launcher-mission-complete-2026-05-30-bc-launcher | mission-complete snapshot; work items closed |
| lead-r8di-gate-bug-q616-fnj5-family-is | governed by docs/runbooks/review-venv-import-integrity.md |
| lead-ybxs-dispatched-shop-msg-send-request-bugfix | status snapshot of a completed dispatch plus a one-off workaround; no decision |
| manual-propagation-workaround-for-missing-shop-templates-upd | operational workaround for a tracked gap |
| operational-gotcha-2026-07-09-the-agent-vault | troubleshooting gotcha; tracked on finding work item lead-d4ja |
| progressive-disclosure-epic-lead-x7bp-reframed-2026-07 | captured in findings/progressive-disclosure/09; era named a failed branch |
| pyyaml-1-1-coerces-github-actions-on-key | BC-internal test-helper detail; outside the lead's record surface |
| resume-handoff-package-ingestion-epic-lead-ac1f-p02 | blocked-state snapshot; its decision governed by findings/external-content-license-compatibility.md |
| shop-msg-cli-quick-ref-for-shopsystem-product | CLI how-to; documented in the canonical lead primer |
| shop-msg-send-hashes-feature-line-included-violates | empty pointer stub; no content |
| shop-msg-send-hashes-feature-line-included-violates-117 | resolved and governed by adr-060 (block-only hash alignment) |
| shopsystem-bc-launcher-assert-docker-run-includes-flag | operational to-do; noted in the BC's work_done |
| shopsystem-bc-launcher-is-a-private-github-repo | stale environment note; superseded by adr-026 brokered credentials |
| shopsystem-effectiveness-a-fabro-engaged-bc-leaks-zombies | governed by bc_container_fabro_engage_external_watcher.feature (tini fix, watcher) |
| shopsystem-effectiveness-bc-emit-work-done-wrapper-templates | pinned in bc_emit_work_done_wrapper.feature; defects fixed |
| shopsystem-effectiveness-bc-status-does-not-reflect-fabro | governed by adr-062 and fabro_liveness_heartbeat_parity.feature |
| shopsystem-effectiveness-cross-bc-dep-conflict-silently-bloc | governed by adr-060 (co-install, fleet adoption) and adr-052 (CI parity) |
| shopsystem-effectiveness-delivery-lag-is-the-session-s | adr-039 governs release cadence |
| shopsystem-effectiveness-fabro-path-broken-by-incomplete-n4 | stale bug-era state; superseded by the external watcher |
| shopsystem-effectiveness-key-bcs-cannot-validate-the-fabro | adr-052 adopts the lesson (empty-middle gap, real-image tier) |
| shopsystem-effectiveness-reactive-engage-stall-a-bc-brought | pinned in tmux_default_engage_autonomously_processes_dispatched_work.feature |
| shopsystem-effectiveness-refinement-the-reactive-engage-stal | same coverage plus the fabro-analogue watcher feature |
| shopsystem-effectiveness-release-emits-also-hit-the-bc | false-STALE root pinned fixed in bc_emit_work_done_wrapper.feature |
| shopsystem-effectiveness-scenarios-cli-canonicalization-chan | adr-060 records exactly this |
| shopsystem-effectiveness-the-fabro-engage-bug-stack-keeps | stale: superseded engage path; lockstep lesson governed by adr-062 |
| shopsystem-fabro-engage-work-item-execution-is-the | status snapshot overtaken by the 2026-07-12 convergence |
| shopsystem-milestone-2026-07-12-the-fabro-engage | milestone snapshot; decisions are adr-057 and adr-058 |
| shopsystem-milestone-knowledge-converged-on-fabro-with-the | status snapshot; dispatcher design governed by adr-058 |
| spike-plane-excluded-from-coherence-graph-2026-07 | key-only stub duplicating the next entry |
| spike-plane-excluded-from-coherence-graph-2026-07-17 | brief-024 folds in all 2026-07-17 decisions |
| spike-precedence-rule-david-2026-07-06-feedback | adr-065 (accepted) pins the rule, citing this exact failure |
| verification-discipline-v0-30-0-37-adopter-bootstrap | fixes governed by pdr-022 D3, footing-feature Thens, adr-043 |
| vocabulary-dev-model-queued-behind-cand-005-2026-07-19 | sess-2026-07-19-a records the park; sess-2026-07-25-a its un-gating |

## Execution on approval

1. Export all 67 memories verbatim to the archive branch
   `archive/memory-2026-08` (never on `main`; reachable deliberately by
   checkout).
2. File the sc06 backlog work item carrying the verbatim scenario body.
3. File one pointer note per route-to-chain row on its consuming chain's
   work item (creating the item where none exists yet), citing the
   archive branch and key.
4. `bd forget` all 67 in bulk — the sanctioned exception to the write
   freeze. The channel stays closed to writes; conversation anchors own
   cross-session state. No new documents are written now.
