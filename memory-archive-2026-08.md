---
type: memory-archive
id: memory-archive-2026-08
status: closed
created: 2026-08-22
updated: 2026-08-22
---

# Memory archive 2026-08

The 67 bd memories retired by the approved action table
(drafts/memory-action-table.md on main, rev 4). Verbatim export; the
channel is closed. This branch is out of ambient context by design —
read it deliberately or not at all.

### artifact-object-graph-provenance-model-2026-07-17
OBJECT-GRAPH ARTIFACT/PROVENANCE MODEL — decided 2026-07-17 (David + Claude, design session; 'works for now, prove out in practice'). Reframes the PM/PO/Architect artifact flow as a typed object graph with a UNIFORM single-parent provenance SPINE: Scenario -> PDR -> Candidate -> Intent -> Session. KEY DECISIONS: (1) ALWAYS a PDR — every scenario family points to exactly one PDR via 'definedBy' (required); a PDR carries placeholder:true when the candidate was committed with no real deliberation. This makes the PM/PO boundary STRUCTURAL: a scenario's parent is always a PO commitment (PDR), never a PM bet (candidate). Pointing scenario origin at a candidate = a MISTAKE (ties contract to a provisional bet). (2) EVERYTHING TRACES TO INTENT — enforceable invariant: every node must reach an Intent via required parent edges, else legacyRoot:true (grandfathered pre-intent-system, explicit/auditable, NOT a general escape hatch). Orphans = coherence-gate errors (pure graph reachability). (3) BRIEF is DEMOTED from 'the anchor scenarios trace to' to an OPTIONAL OFF-SPINE strategic grouping a PDR may reference (pdr.anchoredTo). Briefs are JOINS (many candidates over time) -> never on the provenance path; a reused brief gets a CHANGELOG entry, NOT an added derives-from. This resolves the lead-po.md contradiction (scenarios trace to PDR, not brief) + the brief-singular-vs-many question (brief = theme node). (4) derives-from is UNCHANGED = the lineage edge on frontmatter artifacts (candidate.derivesFrom->intent, pdr.commits->candidate, adr.derivesFrom->(pdr|adr) required-non-empty). We did NOT redefine it. (5) Scenario @origin:bead is the layering INVERSION to fix: documents must NOT depend on the opaque bead registry for provenance; flip to scenario.definedBy->PDR (a filesystem doc). Beads stay a WORK overlay that points INTO the doc graph, never the reverse. CONSEQUENCE FOR RISK 1 (brief-024): the object-graph invariant FLIPS the PO's root:true-exemption recommendation — an exemption manufactures the orphans the invariant outlaws; keep adr.derives-from required-non-empty and BACKFILL genuine origins from .specstory(May)/git-history/session-records, marking only truly-unrecoverable ones legacyRoot. PROVENANCE DATA MAP: .specstory/history=21 verbatim transcripts May 11-27 only (genesis-era ADR/PDR origins); July work already traced in sessions/*.md produced/revised + 58 bd memories; June transcript GAP; git history dates+beads every artifact. NEXT ACTIONS: (a) land this model as a PDR (governs the type system, knowledge-owned per PDR-032; must precede brief-024 migration since it sets required edges definedBy/always-PDR/adr-trace/legacyRoot); (b) reshape brief-024 to instantiate the object graph + provenance backfill (not just add frontmatter); (c) PROVE OUT on ONE bounded real chain end-to-end before the 119-file migration; (d) this whole conversation was a deciding PM-session — needs a session-record with produced/revised. Ties to [[handoff-2026-07-17-pre-reboot]], cand-005 Phase 5, brief-024, lead-cea24 (reframed).



### bc-base-dep-pin-plumbing
shopsystem bc-base dep-pin plumbing (from lead-tzw4y mechanism_observation, bc-launcher, 2026-07-14): docker/bc-base/Dockerfile has TWO install pins with DIFFERENT natures. (1) shop-templates = EXTERNAL dep, line 81 parameterized @${SHOP_TEMPLATES_VERSION} (ARG-driven). (2) shopsystem-bc-launcher = SELF-PIN, line 82 a LITERAL @vX.Y.Z (NOT parameterized). The centralized poll poll-bc-base-deps.yml bumps bc-base dep pins: it greps the launcher LITERAL ('shopsystem-bc-launcher(?:\.git)?@\Kv[0-9]+...' line 145) + seds it (line 199) — so the launcher install MUST stay a literal or the poll breaks (pinned scenario 493bbbb7dcb61d7e bc_base_self_pin_poll). Anti-drift: ARG default + install literal kept EQUAL (guard test_bc_base_launcher_self_pin_literal_equals_arg_default). IMPLICATION for Bug A (lead-s6cy) delivery: once shop-templates releases 0.52.4, poll-bc-base-deps.yml should auto-bump bc-base's SHOP_TEMPLATES_VERSION + trigger publish-bc-base rebuild -> bakes 0.52.4. If the poll is slow/scheduled, may need a manual pin-bump + bc-launcher release to force the rebuild. LESSON for dispatches: do NOT prescribe parameterizing the launcher self-pin (breaks the poll grep); prescribe a literal lockstep bump guarded by equals-arg/equals-release invariants.



### bc-bd-backend-can-wedge-on-launch-empty
BC bd backend can wedge on launch: empty Dolt working set + no issue_prefix despite committed .beads/issues.jsonl carrying a prefix (launcher derives name-prefix e.g. 'templates'/'shopsystem_templates' but repo uses 'tmpl'). All 5 bd recovery cmds mutually block. ESCAPE HATCH (verified bd v1.0.3): 'bd config set issue_prefix <p>' FAILS its op but side-effect auto-imports issues.jsonl into empty DB AND adopts the prefix -> backend operational. Wedge breaks work-done-gate Check 4 (no plan sub-issues possible) -> forces all emissions to blocked. Root causes: lead-rply (launcher provisioning, ->bc-launcher) + lead-vlsu (upstream bd init-safety). Inspect/fix via docker exec into bc-<name> (operational state, ADR-018 admissible).



### bc-wedge-recovery-recipe
shopsystem-knowledge BC agent was found genuinely wedged (2026-07-16): claude process alive+sleeping but totally unresponsive to ANY tmux send-keys (Enter/digit/arrow/Escape) for 30+ hrs, screen frozen mid an AskUserQuestion modal (unrelated lead-ptr7a deadlock). docker healthcheck 'unhealthy'/'messaging database unreachable at <unset>' was a RED HERRING/pre-existing on both bc-shopsystem-knowledge and bc-shopsystem-templates, not the actual blocker -- bc-container status (agent_presence) and manual tmux capture-pane responsiveness testing are the real liveness signals. bc-container start-agent no-ops if a live claude+armed watcher is detected (_agent_online), even if truly wedged -- so it will NOT fix a genuine hang by itself. Recovery recipe that worked: (1) docker exec kill -TERM the wedged claude PID + its shop-msg watch child procs, (2) tmux kill-session -t agent inside the container (bc-container start-agent's tmux new-session silently no-ops/fails if a stale 'agent' session still exists, producing a false 60s-readiness-timeout diagnostic even after the claude proc is dead), (3) THEN bc-container start-agent <bc-name> succeeds cleanly and drains the pending inbox. Durable BC-side state (mechanism_observation, bd bead) survives the kill since it was already emitted before the freeze -- confirm that before killing.



### bd-cwd-drift-trap
bd uses CWD to locate .beads/, NOT a fixed repo path. When CWD drifts into a sibling repo (e.g. repos/shopsystem-templates/), bd operations hit THAT repo's bd, not the lead shop's bd — and you see different prefixes (shopsystem-templates-*) and different issue sets. Symptom this session (2026-05-22): I cd'd into repos/shopsystem-templates early on, never cd'd back, then spent multiple turns convinced sub-agents were 'confabulating' lead-* IDs that bd 'didn't have'. They weren't confabulating — they were in the right CWD (lead repo) and I was in the wrong one. Workaround: pin every bd/shop-msg/git invocation to /workspaces/shopsystem-product as CWD (use cd or git -C), and treat 'bd show X says no issue found' as a CWD-check trigger before assuming the issue doesn't exist.



### bd-dolt-push-via-agent-vault
bd dolt push (and any credentialed dolt remote op) MUST be run as: agent-vault run bd dolt push. A bare 'bd dolt push' fails with 'remote end hung up unexpectedly / dolt does not support interactive credential prompts' — dolt needs the agent-vault credential broker to inject the remote credentials. This is the standard session-close step for persisting bead state (closes, new beads, memories) to the bead remote; git origin auto-syncs separately.



### correction-to-shopsystem-effectiveness-silent-agent-exit-sta
CORRECTION to shopsystem-effectiveness-silent-agent-exit + start-agent-false-liveness observations: templates was NOT dead — its tmux 'agent' window showed a bash shell with command output because the Claude agent was MID-Bash-tool-work (investigating its repo); it was actively working lead-8ki2 and COMPLETED the release. LESSON: do NOT conclude agent-death from a tmux-shows-shell snapshot or a single ps-grep miss (ps/pgrep can race a busy agent). The authoritative liveness signal is PROGRESS (work_done over time) or a sustained-idle Claude UI. bc-status=online + start-agent-no-op were CORRECT here. Reserve re-launch for confirmed no-progress-over-a-window, not a single snapshot.



### deferred-revised-sc06-body-5174e405a19358fa-per-adr-024
Deferred revised sc06 body (5174e405a19358fa) per ADR-024 D2 / lead-8z1o:
Scenario: the system-wide outstanding view counts a canonical scenario absent from every BC journal and the lead snapshot as outstanding
  Given a canonical scenario authored under this repo's features with block-only canonical hash "h6"
  And no BC journal records "h6" as completed and the lead snapshot does not record "h6" as completed
  When the system-wide outstanding view is computed over all canonical scenarios under features
  Then the outstanding view lists the scenario with block-only canonical hash "h6" as outstanding
  And the scenario with hash "h6" is counted in the outstanding denominator on its absence from every BC journal and the lead snapshot alone, independent of whether any work_done ever landed for it



### docker-only-onboarding-prototype-landed-in-lead-repo
Docker-only onboarding prototype in lead repo (updated 2026-06-01 lead-bbjx): compose.yaml (postgres + shopsystem network + pgdata bind to $SHOPSYSTEM_DATA default $HOME/.local/share/shopsystem); bin/shop-shell (brings up postgres if needed, then docker run shopsystem-shell:dev with /workspace + docker.sock + ~/.claude + ~/.gitconfig mounts AND --group-add $(stat -L -c '%g' /var/run/docker.sock) so the non-root vscode user can reach the mode-660 root:docker socket — without this, docker is permission-denied inside the shell); Dockerfile.shopsystem-shell now REBASED onto ghcr.io/dstengle/devcontainer-python-node-claude:latest (was python:3.12-slim), which already ships claude + bd + docker CLI + tmux + node + Microsoft docker-init.sh entrypoint, so the Dockerfile only pipx-installs the framework CLIs (scenarios v0.1.0, shop-templates d1a8937, shopsystem-messaging 1514e8a, pinned to pyproject.toml); bc-launcher still OMITTED (private repo, no creds in image). Build: docker build -t shopsystem-shell:dev -f Dockerfile.shopsystem-shell . These three files are now shop-owned ops scaffolding rendered by shopsystem-templates bootstrap (per lead-xjsq); 'shop-templates update' won't clobber them but emits a drift advisory. The socket-perms + claude fixes should propagate UP into the canonical template via a request_bugfix to shopsystem-templates.



### duplicate-dispatch-check-closed-beads
Before dispatching request_bugfix, search CLOSED beads (not just the contract/artifact surface) for the same mechanism/file — a stale-but-open bead can duplicate a defect already fixed by a different, closed bead (lead-qz8v duplicated lead-rvdl's already-closed fix, redispatched 9 days after resolution; see lead-e30fv).



### fabro-429-is-oauth-system-prompt-gate-NOT-rate-limit
shopsystem ROOT CAUSE (proven 2026-07-14, CORRECTS all prior fabro-429 diagnoses): fabro's 'rate_limit_error' 429 is NOT a rate limit. fabro's anthropic-oauth-shim (/usr/local/bin/anthropic-oauth-shim, launcher-baked) routes requests through the Claude SUBSCRIPTION OAuth (adds Authorization: Bearer <dummy> for agent-vault to inject the real token + anthropic-beta: oauth-2025-04-20). Anthropic gates PREMIUM models (sonnet-4-5/opus) on the request carrying the interactive Claude Code SYSTEM-PROMPT identity ('You are Claude Code, Anthropic''s official CLI for Claude.'). fabro's node requests send the NODE prompt (e.g. 'You are the classify step ONLY...'), NOT the CC identity -> Anthropic rejects with a MISLEADING rate_limit_error. haiku is EXEMPT. EMPIRICAL (through the shim, same instant): sonnet bare->429; sonnet + CC system prompt->200; sonnet + CC user-agent only->429; opus + CC fingerprint->200; haiku bare->200. Interactive Claude Code (lead session, tmux, a normal claude) ALWAYS sends the CC system prompt so sonnet works; fabro (SDK path) does not -> that is why 'we don''t have this problem with tmux'. DO NOT chase rate limits / token budgets / caching / request-frequency / retries for this -- ALL WRONG. DO NOT spoof the CC fingerprint (David: ToS). FIX = use fabro's multi-model advantage via OpenRouter/per-token (lead-obfub). The overnight lead-6ev8 429-retry 'fix' was premised on this misdiagnosis (retrying a hard policy rejection); lead-01jw.3 diagnostic-block + lead-8hpz liveness + lead-i3gs/lead-d1fv delivery fixes remain valid.



### fabro-429-resilience-PROVEN-at-runtime
shopsystem MILESTONE 2026-07-14: FABRO IS NOW 429-RESILIENT AT RUNTIME (the core reliability goal). Proven by lead scout run 01KXFS00B73EACBWGPHAM4216Y (shopsystem-templates on --orchestrator fabro, bc-base w/ shop-templates 0.52.4 + launcher 0.3.72): the bc-router classify LLM node ran with max_attempts=5 (was 1=fail-fast) + two-level exponential backoff (LLM-client 0.6->3.7s within-attempt; workflow-node 2.8->44s between-attempt), RETRYING through 429s instead of fail-fast. Full delivery chain that got the fix to runtime: lead-6ev8 fix was FIRST mis-delivered (bc-launcher assets/fabro-def mirror, NOT the poured source) + stranded by 2 delivery bugs (lead-i3gs bc-base baked stale launcher via a hardcoded Dockerfile literal != ARG; lead-szyg/lead-xinb workflow.fabro poured from shop-templates not the launcher mirror). RE-HOMED to shop-templates poured workflow.fabro (lead-s6cy) -> released 0.52.4 -> poll-bc-base-deps bumped bc-base pin (needed a manual GitHub Release, lead-4fq9y: poll is Release-based, BCs cut tag-only) -> rebuild -> relaunch -> SCOUT. REMAINING: (1) lead-5kb25 diagnostic emit_blk classification degenerate at runtime (429->unknown/no-tail, stub-tested-but-runtime-broken); (2) full COMPLETION demo awaits a transient (not persistent) 429 window; (3) relaunch messaging+rest of fleet on the new image (lead-14xb). KEY REINFORCED LESSON: only a LEAD SCOUT (relaunch+runtime-inspect+re-dispatch) proves a fabro-path fix reaches+works at runtime — BC work_done + green release + green rebuild ALL lied here (fix was stranded); the scout caught both the strand AND the diagnostic-classification gap.



### fabro-fixes-stranded-by-delivery-path
shopsystem MILESTONE + effectiveness 2026-07-14: the 3 fabro-reliability fixes (lead-01jw.3 diagnostic-block + lead-8hpz liveness + lead-6ev8 429-retry) were gated-complete + merged + released (bc-launcher v0.3.71) but a LEAD SCOUT (relaunch templates on rebuilt bc-base:latest + inspect runtime) proved NONE reaches runtime. TWO delivery bugs: (A) POUR-SOURCE DRIFT (lead-szyg/lead-xinb) - runtime /workspace/.fabro/workflow.fabro is poured from the shop_templates PACKAGE (v0.52.3), NOT the bc-launcher assets/fabro-def/ mirror where the diagnostic+retry fixes were made; runtime still has emit_blk retry=2/0 max_retries/content-free summary. (B) BC-BASE BAKES STALE LAUNCHER (lead-i3gs) - rebuilt bc-base:latest bakes launcher 0.3.66 not 0.3.71 (ARG not tracking tag; layer cache). LESSON (reinforces the key memory): a BC 'work_done complete' + a version-bumped release + a GREEN publish-bc-base run are STILL NOT proof a fix reaches runtime - ONLY a lead scout (relaunch + runtime-inspect + re-dispatch) is. The scout is mandatory after every fabro-path release. Also: workflow.fabro has a canonical-ownership problem (launcher mirror vs shop-templates pour) that MUST be single-sourced (lead-xinb) or fixes keep stranding. Corrective chain in lead-d1fv.



### fabro-substantive-work-blocker-is-429-fail-fast
shopsystem MILESTONE + effectiveness 2026-07-14: DIAGNOSED the fabro substantive-work reliability blocker. The fabro SUBSTRATE IS SOUND — dogfood run 01KXF5XB24R1RXDX4KEESVVC53 (templates on --orchestrator fabro, real request_maintenance lead-mavi) executed ALL native (non-LLM) workflow nodes successfully (prime, work-tracker health gate, drain inbox, read message), is leak-free (77-206MB idle, PID1=tini, 0 zombies, single-run mem reclaimed 77->114->back), and auth/agent-vault/proxy/oauth ALL WORK (oauth-shim logged POST /v1/messages 200). The SOLE blocker to substantive work: the fabro LLM/ACP path FAILS-FAST on a transient 429 — run died at first LLM node 'bc-router classify' with 'Rate limited by anthropic', oauth-shim showed 1x200 then 429x4, workflow nodes run max_attempts=1 (no retry budget/backoff). A tmux claude agent survives identical 429s (Claude Code CLI robust backoff), which is EXACTLY why tmux completed lead-ew86 where fabro blocked opaquely. So fabro=trivial-only was NEVER a capability gap — it is a runtime-parity RESILIENCE gap under the fleet-shared-account rate-limiting. FIX: 3 request_bugfix dispatched to shopsystem-bc-launcher, all tmux-parity — lead-6ev8 (LLM node retries 429/5xx w/ bounded exponential backoff, survives burst), lead-01jw.3 (failsafe blocked work_done carries failing-node + reason-class + run tail), lead-8hpz (fabro liveness heartbeat parity). METHOD LESSON: to diagnose a fabro block WITHOUT waiting for the observability fix, dogfood a REAL bead to a fabro BC then read the container runtime logs (/workspace/.fabro/fabro-watch.log + anthropic-oauth-shim.log + fabro-server.log) via docker exec — operational surface, ADR-018 admissible, NOT BC source. This turned lead-01jw.3 facet-2 from 'unknown' to a known single root cause in one run.



### handoff-2-2026-07-14-fleet-ops-fleet
HANDOFF-2 2026-07-14 FLEET+OPS. FLEET: messaging+templates on v0.3.69 fabro watcher engage (leak-free); bc-launcher on tmux(v0.3.69 img); knowledge on tmux(v0.3.68 img, PM/PO done); scenarios dormant. MY bc-container=v0.3.70 (tmux fix live). NEXT/FRONTIER: lead-01jw.3 - make fabro finite runs surface WHY they block + actually complete substantive work; until then fabro=trivial-only, tmux(now autonomous)=reliable substantive path. OTHER OPEN: lead-s8cd(fabro>=50-run soak, needs lead-01jw fix+soak env), lead-iohr(knowledge ships coherence-gate as lead-installable CLI->lead-dprd), lead-r5sk adopter re-pour(needs shop-templates release), lead-br6q(shop-msg pending-inbox masked by consumed blocked work_done; no outbox-removal CLI), bc-emit force-supersede gap + lead-qz8v(jwi false-STALE), lead-mv16(beads remote reseed, blocked lead-tc38), lead-maha(BC test-perf ~10GB pytest), lead-589q(ADR-050 D3 P8 clarify-likely conform-impl not new ADR), create-bc beads GAPs(lead-tc38/vb6j/r34c/7jc2/4qqi), lead-065a(bd migrate wisps). OPS: (a) DISCIPLINE-NEVER read/grep/clone/git-observe BC source from lead (ADR-018); artifact surface only; DISPATCH fixes via PO->Architect (request_bugfix); lead NEVER codes BC fixes; releases+relaunches+reconciliation ARE the router's. (b) LAUNCHER RELEASE: clone launcher, git config identity dave@missingmass.io, bump pyproject version + docker/bc-base/Dockerfile ARG SHOPSYSTEM_BC_LAUNCHER_VERSION, commit, tag vX at bump commit, push main+tag (publish-bc-base is TAG-triggered, no workflow_dispatch), then pip install --upgrade shopsystem-bc-launcher@git+...@vX for MY bc-container. (c) BEADS HEAL: v0.3.69+ self-heal works but logs cosmetic exit-10; manual heal=strip sync.remote from .beads/config.yaml, bd init --from-jsonl --reinit-local -p <prefix> --destroy-token DESTROY-<prefix>, restore config. (d) MONITORS re-arm at session-start (runaway: fabro-server RSS>=1.5GiB/>=50%core + container-mem>=15GiB backstop; inbox watcher shop-msg watch). (e) tmux now autonomous v0.3.70-no manual 'go' needed.



### handoff-2026-06-27-pre-clear-shopsystem-adopter
HANDOFF (2026-06-27, pre-clear) — SHOPSYSTEM ADOPTER-BOOTSTRAP STATE.
RELEASES: shop-templates v0.43.0 is the head; :latest image still v0.42.0 — bc-launcher v0.3.30 image bump IN FLIGHT (lead-sch1, SHOP_TEMPLATES_VERSION->v0.43.0). ON lead-sch1 work_done: consume+close, pull :latest, confirm shop_templates==0.43.0 (carries beads-repo 'gh repo create --add-readme', the user's LAST bootstrap blocker), then user re-tests ./bin/bootstrap.
BOOTSTRAP CHAIN COMPLETE thru v0.43.0 — all blockers fixed+live-verified: env-init upsert, vault-create(env not --address), broker-local Member-role credential set, startup(volume-reset/healthcheck-slug/pgdata), proposal-# (.env-persist), vault host-port (docker port), sync.remote org+name, dolt-push out-of-band auth (insteadOf, token-free sync.remote), provision .env-writeback UPSERT (fleet token lands in pre-created .env), beads-repo --add-readme. ADR-043 (single-source ops-coordinates) + PDR-022 (footing DELEGATES provisioning to bin/agent-vault-provision) DONE+verified. postgres-uid revert (no user: override) DONE.
IN FLIGHT (architect, background, just dispatched): SKILLS PROVENANCE design — product-authority directive: (1) re-pour overwrites ONLY canonical skills, LOCAL skills SURVIVE re-pours (never clobbered); (2) a MARKER FILE (per-skill, human+agent readable) declaring canonical vs local; (3) supports experiment + durable local skills + migration path local->canonical. Architect drafting PDR + routing to shopsystem-templates (cli.py/bootstrap skill-rendering). ON architect report: nudge BC -> release -> live-verify (render->add local skill->re-render->survives + canonical refreshed) -> THEN mark restored PM skills provenance:local per the marker format.
PM SKILLS RESTORED (commit 5671c96) to THIS lead from 84df061^: jobs-to-be-done/problem-framing-canvas/opportunity-solution-tree/customer-journey-map/company-research/work-splitting + skills README — were collaterally deleted in the 84df061 'backlog sweep' (and earlier a v0.13.0 re-pour). Live again now; to be marked provenance:local once the model lands. Only bring-up-bc+create-bc are canonical (in templates).
MECHANICS: gh proxy works via GH_TOKEN=dummy gh api/release. Nudge BCs: sudo -n BCLAUNCHER_HOST_HOME=/home/dstengle bc-container inject <bc> '<full-autonomy msg>'. Releases: request_maintenance to shopsystem-templates (gh release create) THEN shopsystem-bc-launcher (Dockerfile SHOP_TEMPLATES_VERSION bump + self-pin v0.3.NN -> publish-bc-base rebuild :latest). LEAD live-verifies broker/dolt-dependent behavior (BC sandbox has no docker/broker) — test the REAL rendered command/mechanism, not a hand-approximation (see verification-discipline memory). Architect=ac90ece11a530409d. Session close: git add/commit, bd dolt push, git push.
P2 BACKLOG (~10, user-direction-needed, NOT auto-driven): lead-99l1(BC over-defers) j1pd ogky zhlo y9e2 5l0w 22x1(WS-7 skills corpus — RELATES to the provenance work) kf36 qi0q h9nv.



### handoff-2026-07-14-pm-preclear
HANDOFF 2026-07-14 (pre-/clear, David directing). THE BIG CORRECTION: the fabro 'reliability issue' chased all overnight + today (429 fail-fast -> retries -> rate-limit -> token/caching theories) was MISDIAGNOSED. Real root cause (proven): fabro's oauth-shim uses the Claude SUBSCRIPTION OAuth; Anthropic rejects premium-model (sonnet/opus) requests lacking the Claude Code system-prompt identity, as a MISLEADING rate_limit_error (haiku exempt). See memory [fabro-429-is-oauth-system-prompt-gate-NOT-rate-limit]. DAVID'S DIRECTION: do NOT spoof Claude Code (ToS); use fabro's multi-model advantage via OpenRouter/per-token. NEXT STEPS (post-clear, in order): (1) lead-obfub — set up OpenRouter as fabro's LLM provider (agent-vault credential surface ADR-049; pick models per node-class); validate a REAL assign_scenarios completes end-to-end on fabro (still NEVER observed — every fabro run this session blocked at the classify LLM node on the OAuth gate). (2) lead-qyemq — re-pour + re-launch the LEAD shop to adopt the NEW PM SYSTEM (lead-pm main-session mode + discovery/PM skills: discovery-dialogue, option-tradeoff, prioritization, problem-space-mapping, product-narrative, shaping). CAUTION: lead is the host shop (bc-shopsystem-lead); re-launch is self-affecting. (3) lead-2ckf7 — build the system-effectiveness testing harness (token-use per prompt variant; model comparison; via fabro events telemetry + OpenRouter). STATE: templates is on fabro (bc-base w/ shop-templates 0.52.4 + launcher 0.3.72). EXPERIMENTAL runtime hot-patches on templates .fabro/workflow.fabro (max_retries->1; model_stylesheet default haiku->sonnet) are EPHEMERAL (vanish on relaunch); durable model-default fix = lead-txhou. Overnight fabro work that REMAINS VALID: tini leak fix, lead-i3gs (bc-base stale-launcher, fixed+verified), delivery-path (lead-d1fv chain), lead-01jw.3 diagnostic-block, lead-8hpz liveness. INVALID/misdirected: lead-6ev8 (429 retry) addressed a non-problem. Any Monitors from this session stop at session end. bd + git pushed.



### handoff-2026-07-14-pre-clear-arc-1
HANDOFF 2026-07-14 (pre-clear). ARC: (1) bd registry migrated v32->v53 on THIS lead host (designated migrator); http.postBuffer=1073741824 set global (lead-d4ja) so 'bd dolt push' works. (2) FABRO LEAK (lead-01jw): ADR-058 infinite 'fabro run dispatcher.toml' engage leaked to 28GiB -> replaced by EXTERNAL agent-free per-container WATCHER engage (shop-msg watch fires ONE finite 'fabro run workflow.fabro' per inbox msg against ONE shared per-container fabro server + telemetry + bc_presence heartbeat). Shipped over 3 iterations: v0.3.67 (finite runs cant start-server conflict), v0.3.68 (address mismatch, CAUGHT BY VERIFICATION), v0.3.69 (REAL cause: fabro install leaves TCP:32276 daemon + shared server died missing SESSION_SECRET; fix stops install daemon + sources server.env so bind==FABRO_SERVER; PROVEN vs real server). CYCLE-BREAKER: BC engage fixes MUST be proven vs a REAL fabro server - stub tests shipped it broken twice (89e975a7 = real-server-required pin). (3) v0.3.69 KNOWN-GOOD ONLY FOR MECHANISM + TRIVIAL WORK: trivial probe -> work_done, but FIRST SUBSTANTIVE dispatch (lead-ew86 code fix) BLOCKED OPAQUELY on fabro while a TMUX agent completed the SAME work -> lead-01jw.3 IS THE OPEN FRONTIER (fabro finite runs cant complete a real code-fix loop + emit CONTENT-FREE failsafe on block). (4) PM/PO epic lead-ac1f CLOSED (PM mode + all-8 typedefs lead-mfnt + coherence-gate capability + role deltas + ADR-061). (5) TMUX AUTONOMY RESTORED (lead-ew86 v0.3.70): --orchestrator split (lead-9sq) had regressed tmux DEFAULT from autonomous (months) to await-direction; fixed-default now drains-AND-processes; interactive=explicit non-default override.



### handoff-2026-07-17-pre-reboot
PRE-REBOOT HANDOFF 2026-07-17. Read this first via bd prime after clear/reboot.

ARC THIS SESSION: (1) overnight autonomous triage/bug-fix sweep across ~90 bd-ready beads
while product authority slept (see sessions/sess-2026-07-16-a.md early sections + many
lead-* beads closed/dispatched that night). (2) Product authority asked whether
adr/048 passes shop-knowledge validate -- correctly doesn't -- but checking it exposed
the WHOLE knowledge/schema system was broken: typedefs didn't match real practice,
zero PM skills called the validator, the fix for that was unreleased, this repo's
skill pour was 2 releases stale, no enforcement existed anywhere, the coherence gate
was never built. Recorded as intent-007, shaped into cand-005 (5 phases, dependency-
ordered), committed full-chain ("fund it all"). (3) Separately, product authority got
direct license permission from Dean Peters to restore 20 reverted PM technique skills
-- done, adr/066, all 20 live in .claude/skills/, attribution correct. (4) Exercised
one skill (incoming-request-advisor) on a real request -- opened a framework-self-
optimization discovery-dialogue that got QUEUED, NOT STARTED (product authority
corrected initial scope-narrowing to "open discovery", then redirected to keep
driving cand-005 instead). (5) Product authority requested full shutdown prep:
commit+push everything lead+fleet, prepare session for clear/resume.

CAND-005 STATE (candidates/cand-005.md is the source of truth, read it fully):
- Phase 1 (typedef correctness): LANDED, VERIFIED BEHAVIORALLY. lead-x53ez closed.
- Phase 2 (release+repour): LANDED, VERIFIED. shop-templates v0.53.0 cut, this host
  upgraded+repoured. lead-jqew9 closed.
- Phase 3 (minimal enforcement): LANDED, VERIFIED. bin/doctor poured+tested,
  bin/check-knowledge-artifacts pre-commit hook built+tested (blocks new
  non-conforming artifacts, warns-only on ~125 pre-existing legacy files).
- Phase 4 (coherence gate CLI): DISPATCHED (lead-iohr) then work_done REJECTED after
  real behavioral verification found 2 genuine bugs (pdrs/adrs vs pdr/adr directory-key
  mismatch; legacy-id derivation uses raw filename stem, breaks on this repo's real
  numeric-slug legacy filenames). Filed lead-cea24 (P1, full repro+fix shape) --
  NOT YET DISPATCHED. NEXT ACTION when resumed: dispatch request_bugfix for
  lead-cea24 to shopsystem-knowledge, re-verify behaviorally against THIS repo's
  real corpus (not the BC's own fixtures) before accepting, same rigor as phases 1-3.
- Phase 5 (cand-004/pdr-034 legacy corpus migration): BLOCKED pending Phase 4 landing.
  Do not dispatch ahead of that.

FLEET SHUTDOWN-PREP STATE (all real, verified 2026-07-17):
- Lead repo: clean, all pushed to origin/main (commits through 2edacf9), bd dolt
  pushed. Includes committing the accumulated pre-pause OpenRouter/fabro-thread work
  (ADR-064, briefs 020-022, cand-003, 2 runbooks) that was correctly left untouched
  all night out of respect for the pause -- now safely committed since it was
  completed work, not resuming the pause itself.
- All 6 real BCs (bc-launcher, bc-launcher-dagger, knowledge, messaging, scenarios,
  templates): bd/dolt registries confirmed pushed, no committed-but-unpushed local
  commits anywhere, mailboxes fully drained.
- shopsystem-messaging: had genuine unique uncommitted code (partial lead-br6q fix,
  no live agent) -- PRESERVED on branch wip/lead-br6q-partial-2026-07-17 (commit
  2eaa6451, pushed to origin), main untouched at 6bb9124. Explicitly flagged
  UNFINISHED in the commit message -- do not treat as a completed fix. The originally
  -dispatched conflicting scenario ab7c5029713969e4 remains unaddressed.
- shopsystem-bc-launcher: live agent mid-conversation with itself about a
  heterogeneous canonical-repour diff bundling 2 unattributed policy changes; a
  queued-but-UNSENT "(A) confirmed" tmux line exists -- I deliberately did NOT send
  it, don't have context on what it confirms. Low risk (canonical/regeneratable
  content) but needs a human or the BC's own agent to resolve, not blind approval.
- shopsystem-templates: live agent was mid-analysis of a similar canonical diff,
  non-destructive, no risk either way, no action taken.
- shopsystem-knowledge: live agent correctly self-resolved (left canonical content
  uncommitted, that's correct per doctrine -- lands via repour not shop commit).
  Also flagged a SKILL.md naming-convention fix worth landing in shopsystem-templates
  canonical source -- not yet relayed/dispatched, minor, low priority.
- shopsystem-bc-launcher-dagger, shopsystem-scenarios, fabro-e2e, fabro-throwaway:
  no active risk (no running containers, nothing uncommitted, or registry-only
  placeholders with nothing to lose).
- GOTCHA for future docker exec git/bd ops: must prefix with
  ". /etc/profile.d/agent-vault-ca.sh;" or git fetch/push falsely appears broken
  (agent-vault MITM broker CA not materialized in a plain non-login exec shell).

PAUSED, NOT TOUCHED THIS SESSION: the OpenRouter/fabro-orchestrator thread
(brief-017). lead-yekmk (live end-to-end OpenRouter proof retry) remains un-retried.
Resume only on explicit product-authority direction -- this was an overnight-only
pause instruction from 2026-07-16, worth confirming still applies rather than
assuming indefinitely.

QUEUED, NOT STARTED: framework-self-optimization discovery-dialogue. Product
authority wants to "start making optimizations to the prompts, processes, and
skills to make the system more efficient and effective" -- explicitly corrected
scope framing to "open discovery, don't pre-pick" rather than narrowing to one
layer. Next session: pick this back up as a genuine discovery-dialogue PM session,
grounded in this session's own real evidence (dispatch tool-use counts, which
agents needed multiple correction rounds, where verification caught real errors
vs added pure overhead) rather than guessing at inefficiencies.

OTHER OPEN ITEMS: lead-c46ug (P3, minor process note, not urgent). lead-2z9po (P1,
BC-liveness detection gap -- bc-container status reports a wedged agent as online,
needs Architect/PO scoping, not yet started). lead-81fdg (SHOPMSG_DSN healthcheck
false-negative -- real architecture decision deferred to product authority, two
options recorded on the bead, still awaiting their call).


### handoff-2026-07-18-legacy-migration-resume
COMPLETE 2026-07-18. legacy-corpus modernization (brief-024) FULLY DELIVERED + MERGED TO MAIN. All 6 steps done incl. step-5-full. Merge cb3e2a7 (content-fill 118 docs, gate 66->0, intent->intents via lead-yy0xy @5f5ac8a, link rewrite). Then main 6139af9 = coherence gate wired into pre-commit (shop-knowledge-gate --mode distribution, BLOCKING, scoped to commits touching gated artifact dirs, --no-verify escape hatch; verified green-pass/broken-block/noncorpus-skip). David: 'Trust it, add the gate' — content-fill accepted as-is (no human review pass), gate added. Corpus uniformly plural, gate green distribution mode. Validate 135/7 = KNOWN lead-6n4j6 modern gaps (out of scope). Knowledge BC online (relaunched from Exited-143). lead-ptr7a closed (superseded by lead-6n4j6). NOTHING PENDING on this migration. Repo auto-commits+pushes ~1min (timestamp msgs pre-empt descriptive commits; used cherry-pick to land 6139af9 on main). Remaining repo work = separate fleet/fabro-ops backlog in bd ready (out of this migration's scope).



### handoff-2026-07-25-uhxoc-restructuring-proposed
HANDOFF 2026-07-25 (authority offline autonomous drive). Session sess-2026-07-25-a (read it — full acceptance queue). ARC: (1) session-start drift diagnosis — beads over-report open work via consume≠close + no bead→commit edge (root: router reconciliation-close is manual/unenforced; NOT lost messages). Filed lead-t96cf (P1, parked, = work-tracking-plane twin of lead-uhxoc's materialized-edge/gate pattern). (2) Closed cand-005 (all 5 knowledge/schema precondition-chain phases landed; status stays 'committed' — no 'done' status; un-gates vocabulary-dev-model). (3) Landed migrate/legacy-corpus-modernization to main (f93c2c4) + deleted branch. (4) AUTONOMOUS DRIVE of lead-uhxoc artifact-system restructuring: all 7 intents -> PROPOSED/authored, gate-green both modes, committed+pushed, NOT self-ratified (lead-pm never ratifies). 17 artifacts: #1 intent-008/cand-006/pdr-035 (foundational needs, requirement-only, supersedes pdr-031+pdr-032-founding at accept); #2 adr-067 (base schema: 3 materialized bidirectional edge pairs, tags, distribution, external-refs, N:M supersession; supersedes adr-059 at accept); #3 intent-010/cand-008/pdr-037+adr-069 (per-type needs+schema, PDR-032 coverage-complete, current-state=VERSIONED D7); #4 intent-011/cand-009/pdr-038+adr-070(skill-template)+adr-071(shop-templates BLOCKING enforcement) — the authoring-guidance layer; #5/6/7 FOLDED -> intent-009/cand-007/pdr-036+adr-068 (read-only graph CLI navigate/render-with-view-filtering/query, reuses load_corpus). Slice beads lead-x9gca/qa76u/4vvdo/2lxya + folded lead-vy38p/jk8j4/81ulx, all in_progress w/ fork comments. NEXT (needs authority): ratify in dep order #1->#2->#3->#4/tooling, materializing supersedes edges + current-state.incorporates at each accept; decide flagged forks (the fold; #3/#4 granularity; #2 vocabulary product|system-wide vs framework|system-global collision; current-state versioned instance-migration); THEN dispatch implied BC work (knowledge=edges/loader/CLI/typedefs; templates=writing-skill enforcement+generator; scenarios=gate rules). DEFERRED: lead-t96cf; registry reconciliation sweep of other consumed-but-open beads (lead-01jw.3/tzw4y/2yo43/915f) per 'structural-first' call.



### handoff-2026-08-02-verifiable-grounding-shaping
HANDOFF (updated 2026-08-03, pre-reboot) — VERIFIABLE-GROUNDING first bet COMMITTED. Epic lead-fb3vk; intent intent-012. cand-010 'Corpus entry-point finding as a composable, tag-based skill set' is COMMITTED (2026-08-03), validated, coherence gate green, pushed (commit d6e9585). \n\nRESUME HERE -> NEXT ACTION: RE-DISPATCH lead-po to author the commitment for cand-010 (a lead-po background dispatch was in flight but was STOPPED for a reboot before writing anything — no artifacts produced, tree clean). The lead-po charge: author a brief + PDR (scenarios anchor to the PDR per artifact-object-graph-provenance-model-2026-07-17; candidate->PDR is the derives-from spine edge; set symmetric derived-by on cand-010 and advance its status like committed cand-009 carries pdr-038) + a work-split of the directed build sequence into thin scenarios with bead work_ids under lead-fb3vk. Author Gherkin for settled parts (tag-query atomic skill + composite over the EXISTING query facet); MARK tagging-skill/tag-write scenarios BLOCKED pending a lead-architect probe (open architecture q: is a tag written via a dedicated corpus command or a gate-revalidated frontmatter edit?). Ownership split to surface: steps 1-2 = shopsystem-templates skills / shopsystem-knowledge tool; steps 3-5 = lead-side application+measurement.\n\nAUTHORITY-DIRECTED BUILD SEQUENCE (binding, on cand-010): (1) tag-query command skill(s) [atomic, queryable first]; (2) tagging skill [writes/refreshes tags]; (3) tag a SELECTION of docs (a subset, NOT all 153) + get HUMAN FEEDBACK on tags; (4) TEST the tagging skills; (5) RE-RUN the discovery probe + MEASURE IMPACT -> this is the GATE: full-corpus population trusted ONLY after impact shown. Appetite narrowed to selection-first; the 'PoL probe before scale' rabbit hole is RESOLVED by step 5.\n\nSHAPE (settled, do not reopen): first bet = FIND half (not the record-form skill = NEXT bet); spine = TAGS (spine A) populated by INFERENCE bootstrap, NOT semantic search (=follow-on); deliverable = COMPOSITION (thin atomic corpus-command skills that just RUN a command, no runtime help-probing, + one find-entry-points composite), NOT a monolith; completeness = an inference sweep over every doc flagging relevant-but-untagged (review signal, not authoritative selector). Absorbs cand-003's knowledge-corpus element. DEFERRED (out of bounds, still open beads): lead-3gyuq graph-as-domain; lead-d0jmz bd-coupling. FOLLOW-ON (named, unfiled): record-form skill, semantic search (spine B), full atomic/operational skill library.\n\nEMPIRICAL (dogfooded): 0/153 artifacts carry tags today; shop-knowledge query works (clean L0) but --help returns an error string AND exits 0 -> filed bug lead-wnrvo (route request_maintenance to shopsystem-knowledge, separate from cand-010).\n\nSESSION START after reboot: re-arm Monitor (shop-msg watch --lead shopsystem-product), run the drain (was empty), then re-dispatch lead-po as above. ARTIFACTS: candidates/cand-010.md; sessions/sess-2026-08-02-b.md (closed, produced cand-010); intents/intent-012.md.



### handoff-2026-08-05-dialogue-mode
HANDOFF 2026-08-05 (clear-prep, authority-directed). MODE CORRECTION GOVERNS THE RESUME: the authority said 'I feel like we're in the wrong mode here. I want to have a dialog about the statements I'm making, not just steering the current activity.' Resume as lead-pm DIALOGUE about their statements — engage, question, push back as an interlocutor — do NOT convert statements into bead comments/artifacts/workflows until the thinking converges. THE AGENDA (their statements, verbatim anchors in sessions/sess-2026-08-05-a.md): (1) the progressive-disclosure era is a failed branch pointing to 'a limit on scalability of the concepts'; (2) do not assume the current 8 artifact kinds/workflow are right — resolve against common PM practice ('never heard of a PDR... professional PM confused when I said PDR and not PRD'); (3) the working core (dispatch machinery + implemented scenarios) is real, 'hasn't at all been a waste'; (4) foundations are in question — pdr-039 is a principle set not a ruleset, PDR format never authority-validated. STATE: intent-013 arc, epic lead-jozud; freeze standing (brief-025 paused, cap 3/session); pdr-039 proposed+amended, acceptance HELD; adr-072 rejected; adr-067 annotated; rebaseline bill (drafts/rebaseline-bill.md) = census, sitting DEFERRED; artifact-definition packet (drafts/artifact-definition-packet.md) = sitting material NOT ratified, read WITH its verification annex (annex wins); common-practice atlas deliberately NOT launched (authority interrupt). FLEET: templates online (tmux), knowledge+messaging down since reboot, lead up. Session start: arm watcher, drain (expect empty), then OPEN THE DIALOGUE — no workflows, no dispatches, no artifact authoring first.



### launcher-mission-complete-2026-05-30-bc-launcher
Launcher mission COMPLETE 2026-05-30: bc-launcher 9cbb9c1 ships both the launch-step-5 and inject paths using two discrete tmux send-keys invocations (text alone, then bare Enter). Empirically verified at lead — bc-container launch shopsystem-templates with default startup prompt produces an ENGAGED agent at +15s (Monitor armed, pending inbox drained, prose 'Session-start sequence complete' emitted) with no manual empty-inject workaround required. Beads lead-xsmn / lead-9q0f / lead-hyee / lead-lez1 all closed. The 'launch + send-work end-to-end' goal in feedback_autonomous_launcher_mission is satisfied; resume normal lead-shop discipline (no direct edits to repos/*).



### lead-r8di-gate-bug-q616-fnj5-family-is
lead-r8di gate-bug (q616/fnj5 family) is NOT a source defect — it was a stale site-packages install-shadow. bd_facade.py NON_GATING_DEPENDENCY_TYPES already includes relates-to; live-consultation contract 48ade065ce073a54 always correct in source. Live reclassify-doesn't-clear-gate symptom = frozen non-editable shop_msg/catalog copy ({parent-child}-only) shadowing the editable /workspace/src checkout (same as shopsystem-messaging-c1f, now conftest editable-install-guarded, origin/main 1fba988/71cf840). DIAGNOSTIC FLIP: any field recurrence of the gate refusing a reclassified-edge send => check for stale install shadow (pip install -e), NOT a gate-logic defect. lead-r8di shipped ZERO src change (additive regression teeth only).



### lead-shop-ownership-rule-david-2026-07-08
Lead-shop ownership rule (David, 2026-07-08): anything in the lead shop that LOOKS LIKE CODE — e.g. compose.yaml and other rendered/templated artifacts — is OWNED by the shopsystem-templates BC, NOT hand-editable in the lead shop. Permanent changes to such artifacts route through shopsystem-templates via shop-msg dispatch. Lead-owned surfaces that are NOT code: features/ (PO-authored scenarios), briefs/, adr/, pdr/, findings/, beads.



### lead-ybxs-dispatched-shop-msg-send-request-bugfix
lead-ybxs dispatched: shop-msg send request_bugfix --bc shopsystem-templates --work-id lead-ybxs (2 fixes to ops scaffolding, ref impl f551e30). Pre-state verified against installed shop_templates package data ops/shop-shell + ops/Dockerfile.shopsystem-shell. Conflict enum: 134 (d7f3b1b3118f6a88) additive, 135 (2dfa4b5ab79dd829) CONTRADICTED by docker-ce-cli removal -> needs lead-side PO body revision, 137 (f706707653aa646a) unaffected. NOTE: DB registry was empty this session; re-added shopsystem-product (lead) and shopsystem-templates via shop-msg registry add over DSN postgresql://postgres:postgres@shopsystem-messaging-postgres-1:5432/shopsystem (container-network address; localhost:5432 refused, SHOPMSG_DSN unset in lead-host shell).



### manual-propagation-workaround-for-missing-shop-templates-upd
Manual propagation workaround for missing 'shop-templates update' (lead-xjsq): refresh canonical lead-primer and inline agent files by 'cp $PKG/templates/claude/lead.md .claude/canonical/lead-primer.md' and 'shop-templates show <role> > .claude/agents/<role>.md'. The package data path is $VENV/lib/python<ver>/site-packages/shop_templates/templates. Used to close lead-6gaj's propagation gap.



### operational-gotcha-2026-07-09-the-agent-vault
Operational gotcha (2026-07-09): the agent-vault broker proxy (v0.32.0) returns HTTP 413 for request bodies sent with Transfer-Encoding: chunked, regardless of actual size — NOT a size cap. Git streams any push larger than http.postBuffer (default ~1MB) as chunked, so large dolt/git pushes through the proxy fail with 413. FIX: git config --global http.postBuffer 1073741824 (1 GiB) so git buffers and sends a single Content-Length request the proxy accepts. Diagnose with GIT_TRACE_CURL=1. This is DISTINCT from the rate-limit (429) and CA-trust (SSL) issues. Durable fix belongs in shopsystem-templates-rendered git config or an agent-vault image upgrade. See finding bead lead-d4ja.



### operational-hazard-david-2026-07-08-never-recreate
Operational hazard (David, 2026-07-08): NEVER recreate/restart/down the shopsystem-agent-vault broker (docker compose up -d / restart / down agent-vault) from WITHIN the lead session. The lead session's outbound traffic routes through that broker as HTTPS_PROXY, so bouncing it kills the live session. Broker recreates (e.g. to pick up compose/env changes like AGENT_VAULT_RATELIMIT_PROFILE default-off) MUST be done EXTERNALLY by the operator. In-session-safe: package upgrade + bin/bootstrap re-render (steps a-c of lead-y8ds); operator-only: the recreate (step d).



### progressive-disclosure-epic-lead-x7bp-reframed-2026-07
Progressive-disclosure epic lead-x7bp REFRAMED (2026-07-05, David): not a 'decisions' BC but a GENERALIZED KNOWLEDGE context with typed knowledge kinds. Taxonomy (priority order): architecture-decision (ADR/PDR — PRIMARY motivation, validated frontmatter-tiering mechanism in findings/progressive-disclosure/) > development-PRINCIPLE (NEW kind skills can't express: declarative, obligation[MUST/SHOULD] x activation[always/situation-conditioned, non-discretionary] x composition[several assemble per activity] — this IS the epic's 'task-conditioned access patterns'; today done ad-hoc via CLAUDE.md @-includes) > skill/recipe (existing .claude/skills, discretionary/single-match, unchanged) > experiment/research (findings). Research is DONE + committed (CONFIRM verdict); decisions-framed decomposition beads lead-iixm/q4my/cufo/9c56 marked DO-NOT-EXECUTE pending reframe. Next: focused reframe-research pass; sharpest open Q = the principle ACTIVATION model (what is an 'activity', how activation is expressed/matched). Full dialogue in lead-x7bp notes.



### pyyaml-1-1-coerces-github-actions-on-key
PyYAML 1.1 coerces GitHub Actions 'on' key to boolean True. In step defs parsing workflow YAML with yaml.safe_load(), use wf.get(True) not wf.get('on'). The shopsystem-devcontainer BC uses a _get_workflow_on() helper (tests/conftest.py:820) as the fix. Consider ruamel.yaml (YAML 1.2) to avoid this permanently.



### resume-2026-07-04-lead-architect-handoff-before
RESUME 2026-07-04 (lead-architect handoff before /clear). (1) DONE+GRADUATED: lead-holds-all feature-ownership restored — lead features/ holds ALL features (BC imports under features/<bc>/ + lead-owned + migrated dagger-ci/test-harness). commit 5b0530e, epic-done 82df1c8, on main, scenarios validate --aggregate GREEN (228 .feature/649 scn). devcontainer+docs stay parked in features-provisional/ (David: devcontainer no current use, keep docs parked). Templates note: 10 scenarios had trailing RETIRED comments the installed scenarios v0.3.1 sweeps into the block (hash flip); relocated them to file header in lead copies, hashes now match BC pins byte-for-byte. Root cause tracked as lead-vzxd.9 (fix=v0.3.2 in f248475) — informational, nothing needed from David. (2) BEAD lead-vede (P2, decision): feature/scenario/BC ownership model — a FEATURE is customer-value and may span BCs; the single @bc owner belongs on the SCENARIO not the feature; cross-BC interaction scenario owned by a single integration-point BC (David had me REMOVE the 'API gateway/workflow-orchestration' parenthetical). Current feature-level @bc inheritance likely drives BC bloat. Related lead-bh2m. (3) BEAD lead-x7bp (P1, EPIC): progressive disclosure for LLM artifacts (ADR/PDR/brief) — tiered L0 title+desc / L1 decision-only (ship to BCs) / L2 full doc (lead-architect authoring); formalize YAML frontmatter + generate tiers+index from ONE source (avoid summary/full drift, nbx5 single-source precedent); decision-coherence GATE (analogous to scenarios --aggregate / ADR-047) to catch contradictory/superseded active decisions; consult-decision-index gate in lead-po/lead-architect prompts. Refs: Google Open Knowledge Format (GoogleCloudPlatform/knowledge-catalog, okf/SPEC.md — md+YAML frontmatter, index.md progressive disclosure, required 'type', desc, cross-links, log.md, citations); llms.txt (Answer.AI); Anthropic Agent Skills progressive disclosure (metadata->SKILL.md->resources, already used here); MCP resources; Diataxis; MADR/Nygard ADR; RAPTOR/GraphRAG/contextual-retrieval. (4) DAVID DIRECTIVE (open): run lead-x7bp via SUBAGENTS + /workflows, NOT monolithically. IMPORTANT: the lead-architect subagent has only Read/Edit/Write/Bash — no Task/subagent-dispatch, no slash commands; so /workflows + subagent orchestration is the ROUTER's job. There is NO .claude/workflows or .claude/commands dir yet; bd has formula/mol/swarm workflow tooling but no formulas defined. Router should decompose lead-x7bp into a workflow/swarm and dispatch. (5) HYGIENE: beads lead-vede+lead-x7bp created locally, NOT yet 'bd dolt push'ed — router session-close must push. Shared checkout has concurrent router activity; ~1153 zombie procs (git/fabro/telemetry) + a stale 'ddd-artifact-options' background agent hanging around — host cleanup is David's call.



### resume-handoff-package-ingestion-epic-lead-ac1f-p02
RESUME handoff-package ingestion (epic lead-ac1f): P02 PM-mode re-render DONE/live (693d113). P01/Round-1 BLOCKED — shopsystem-knowledge OFFLINE, lead-oji4+lead-92oy unconsumed; root cause bc-launcher E2BIG (lead-m4zt, driver.py exec_run passes bundle as >128KB argv). USER fixing bc-launcher directly in container bc-shopsystem-bc-launcher BEFORE other work. After fix: hotfix/upgrade installed bc_launcher -> bring up knowledge BC -> reconcile Round 1 -> Phase 2 (land pkg2 artifacts from /tmp/handoff-package-2). deanpeters skills removed (CC-BY-NC-SA vs MIT). See lead-ac1f notes for full resume steps.



### router-architect-effectiveness-the-17e9342e-re-pin-ruling
router/architect effectiveness: the 17e9342e re-pin ruling named the WRONG MODULE — it said 'imports parse_then_block_only_hash from scenarios.hash' (mirroring the old pin's scenarios.hash) but in scenarios v0.3.1 the block-only fn lives in scenarios.outstanding; scenarios.hash only exposes whole-text compute_scenario_hash. The lead runs scenarios 0.2.0 and CANNOT import 0.3.1 to verify the module, so the assumption went unchecked; messaging (which CAN import 0.3.1) caught the ImportError and correctly refused to fake the import. LESSON: a scenario pin that asserts a specific import SOURCE (module.symbol) for a cross-version dependency must have the module/symbol confirmed against the ACTUAL target version — ask the BC or defer the module name to the BC, don't assume it mirrors the old module.



### router-effectiveness-i-missed-a-real-2nd-blocked
router effectiveness: I MISSED a real 2nd blocked work_done from messaging (lead-14xb.1) by dismissing its Monitor event as a 'stale replay' because pending-outbox looked empty at check time. LESSON: a Monitor <work_id> work_done event where pending-outbox appears empty is NOT necessarily stale — verify the BC's ACTUAL state (its git log / tmux summary / bead flush commits) before concluding stale, especially when the BC was mid-work. The messaging BC had flushed 'chore(beads): ... 2nd work_done blocked (meta-scenario 17e9342e)' — visible in its git log. A stale-vs-real check must look at the BC substrate, not only the lead mailbox snapshot (mailbox rows can be consumed/overwritten per work_id between the event and the check).



### router-pre-dispatch-gap-lead-qi0q-2026-06
ROUTER PRE-DISPATCH GAP (lead-qi0q, 2026-06-27): before dispatching a bead pulled off the bd-ready backlog, verify the bead's PREMISE against CURRENT design (relevant ADRs/PDRs), not just whether its scenario is already-pinned. lead-qi0q (filed 2026-06-10, 'add docker CLI to bc-base') was overtaken 4 days later by PDR-020 Addendum II (2026-06-23, bc-base/bc-lead split keeping docker bc-lead-only by deliberate security decision). The architect's pre-state check confirmed 'no scenario pins docker on bc-base PATH' (true) but missed that an ADR/PDR DELIBERATELY EXCLUDES it -> dispatched a scenario that reversed a security PDR; BC correctly raised a clarify. LESSON: for any backlog bead older than recent design decisions, reconcile its premise against adr/+pdr/ FIRST. Stale-premise beads must be retired/re-scoped, not dispatched verbatim.



### shop-msg-cli-quick-ref-for-shopsystem-product
shop-msg CLI quick-ref for shopsystem-product lead: binary at /workspaces/shopsystem-product/.venv/bin/shop-msg (NOT on PATH — activate venv or use absolute path). Lead canonical name in registry is the SLUG 'shopsystem-product' (with hyphen), even though .claude/shop/name.md displays 'shopsystem product' (with space). Use --lead shopsystem-product everywhere. Common surface: 'shop-msg watch --lead shopsystem-product' (Monitor-compatible, persistent); 'shop-msg pending outbox --lead shopsystem-product [--bc-name <bc>]' (BC responses pending consume; --bc-name not --bc); 'shop-msg pending inbox --lead shopsystem-product' (BC clarifies); 'shop-msg read outbox --bc <name> --work-id <id>' (read a specific response; uses --bc not --bc-name); 'shop-msg consume outbox --bc <name> --work-id <id> --message-type <clarify|work_done|mechanism_observation>'; 'shop-msg send <verb>' for lead dispatches. 'shop-msg prime' is BROKEN by the name.md slug mismatch — don't rely on it for orientation.


### shop-msg-send-hashes-feature-line-included-violates
shop-msg-send-hashes-feature-line-included-violates-117



### shop-msg-send-hashes-feature-line-included-violates-117
Dispatch hazard found 2026-06-02 (during lead-tk0f): the INSTALLED shop-msg send / scenarios.hash.compute_scenario_hash canonicalizes by wrapping the gherkin body with a 'Feature:' header and hashing the Feature-line-INCLUDED text. Canonical scenario features/templates/117 REQUIRES scenario-block-only hashing (Feature line NOT included) — so the installed tool violates 117. Empirical: bare scenario block of 135 hashes 9bc85eced7685a40; same block with a Feature: line hashes differently (transient 0ff0711ff6334e47 seen via --scenario-file). The ScenarioPayload validator enforces hash==compute_scenario_hash(gherkin), so passing Feature-line-bearing gherkin forces the WRONG hash and disagrees with on-disk @scenario_hash: tags. WORKAROUND when dispatching: build the payload with a Feature-line-FREE gherkin block and use 'shop-msg send --payload <file>' (not --scenario-file) so the pinned hash matches the canonical scenario-block-only value. PROPER FIX is an architect-deferred decision (117 lines 46-59): which BC owns canonicalization — shopsystem-scenarios or shopsystem-messaging — then request_bugfix. Not yet filed.



### shopsystem-bc-launcher-assert-docker-run-includes-flag
shopsystem-bc-launcher: assert_docker_run_includes_flag step does not assert container_name against the run_cmd — latent fragility if multiple containers run in same test. BC noted this in lead-0eu work_done summary. Queue a request_bugfix once lead-90z and lead-cyo are processed.



### shopsystem-bc-launcher-is-a-private-github-repo
shopsystem-bc-launcher is a PRIVATE github repo as of 2026-06-01. Host devcontainer has cached git creds so 'pip install git+https://...bc-launcher' works; fresh containers without creds get 'fatal: could not read Username for https://github.com'. Affects: Dockerfile pre-warm layers, bootstrap from any non-credentialed environment. Decision deferred to user via lead-aj5f (P1, labeled human): make repo public, or document credential mounting.



### shopsystem-effectiveness-a-fabro-engaged-bc-leaks-zombies
shopsystem effectiveness: a fabro-engaged BC LEAKS ZOMBIES + burns ~1 core. Root: container PID1='sleep infinity' is not a reaping init, and the ADR-058 dispatcher poll spawns a 'bd' subprocess every ~5s whose parent exits unreaped -> 532 bd zombies in 15min (98% of procs). Plus the in-container fabro server idles hot at ~31% CPU. A single fabro BC = ~1 core; the whole fleet on fabro would be ~5 cores + PID exhaustion. LESSON: the fabro engage's per-poll subprocess spawning + the non-reaping container init are a resource-correctness gap that ONLY shows at runtime (another reason a docker-capable fabro e2e gate is mandatory). Vindicates NOT flipping the fleet before this was found.



### shopsystem-effectiveness-bc-container-start-agent-also-false
shopsystem effectiveness: 'bc-container start-agent' ALSO false-positives on liveness — it refused to recover templates' dead agent ('already has a live agent and is online, no-op') using the same watch/registration signal instead of checking for an actual claude process. So the sanctioned recovery tool is defeated by the same bug it should fix. Robust recovery = re-launch the container (bc-container launch). start-agent's liveness gate must check ps for the claude process.



### shopsystem-effectiveness-bc-emit-work-done-wrapper-templates
shopsystem effectiveness: bc-emit work-done wrapper (templates-owned, ADR-036/042) repeatedly drifted from the canonical shopsystem-scenarios splitter — three distinct block-extraction defects surfaced (feature-level-tag fold [lead-rvdl, fixed], Scenario-Outline-boundary fold [subsumed by lead-rvdl], RED-title-token nomenclature [lead-lgga, fixed]). Lesson: the wrapper MUST reuse the canonical iter_scenarios/_SCENARIO_RE splitter (never re-implement block delimitation); add a regression pinning wrapper-scan == test_scenario_hash_tag_invariant over the corpus.



### shopsystem-effectiveness-bc-status-does-not-reflect-fabro
shopsystem effectiveness: bc-status does NOT reflect fabro-engage liveness. knowledge's fabro dispatcher was alive + cycling (fabro run dispatcher.toml running the poll/dispatch/wait loop) yet 'shop-msg bc-status' reported it 'offline 932'. The bc-status heartbeat is maintained by the TMUX Claude agent's session-start, which the fabro engage path REPLACES (no tmux agent) — so a genuinely-working fabro BC reads 'offline'. Fleet on fabro needs a fabro-path liveness/heartbeat signal (the dispatcher should register/heartbeat), else bc-status is useless for the fabro fleet. Authoritative fabro-liveness = the dispatcher process + fabro-run.log loop, not bc-status.



### shopsystem-effectiveness-confirmed-correcting-my-earlier-ret
shopsystem effectiveness CONFIRMED (correcting my earlier retraction): the SILENT AGENT-EXIT failure mode IS REAL. A 'bc-container inject' of a prompt to shopsystem-templates hit a BASH SHELL (produced '-bash: syntax error near unexpected token' — the injected prose ran as a shell command), definitively proving the tmux 'agent' window is a dead bash shell, not a live Claude agent. bc-status still said 'online 14' (false — tracks watch registration, not agent liveness), and pgrep found a claude process (leftover/defunct, not foreground of the agent window). So a BC's Claude agent CAN exit after completing work, dropping the tmux 'agent' window to the launch shell, while bc-status lies 'online' and start-agent false-no-ops. AUTHORITATIVE liveness test: inject a harmless marker and check whether the tmux echoes a Claude UI response vs a bash error; or check the agent-window foreground process. Recovery: restart claude in-window or re-launch.



### shopsystem-effectiveness-cross-bc-dep-conflict-silently-bloc
shopsystem effectiveness: CROSS-BC DEP CONFLICT silently blocks bc-base rebuild. bc-base co-installs shop-msg(messaging) + shop-templates + scenarios; when shop-templates 0.52.0 required scenarios==0.3.1 but messaging pinned scenarios==0.2.0, the publish-bc-base.yml pip layer failed ResolutionImpossible and bc-base was NOT republished — with NO shop-msg signal (the CI failure is invisible to the lead; only surfaced because the launcher agent checked the workflow run and CORRECTED its premature forced-complete). LESSONS: (1) a BC releasing a dep-version bump must coordinate ALL co-installed siblings (scenarios is a shared transitive dep of messaging+templates) BEFORE the bc-base pin bump; (2) publish-bc-base CI failures need a lead-visible signal (the digest-poll or a status hook), not silent; (3) an agent force-completing a deliverable BEFORE observing the async CI result is a real hazard — the gate should await the workflow run.



### shopsystem-effectiveness-delivery-lag-is-the-session-s
shopsystem effectiveness: DELIVERY-LAG is the session's dominant friction. Fixes land on a BC's origin/main but do NOT reach RUNNING BCs until a templates release + bc-base rebuild. This caused the SAME bc-emit wrapper bug to force 5 separate --force escape-valve emits across launcher/templates/knowledge in one session. Lesson: after landing a shared-surface fix (bc-emit/work-loop/templates), DELIVER it (release+rebuild) before continuing dependent work, or expect repeated forced-recovery.



### shopsystem-effectiveness-fabro-path-broken-by-incomplete-n4
shopsystem effectiveness: FABRO-PATH BROKEN by incomplete N4 retirement (found by scouting knowledge on --orchestrator fabro, bc-launcher v0.3.61). N4(b) removed the baked assets/fabro-def/ bundle (def is now POURED to the container /workspace/.fabro/ by shop-templates), BUT the fabro-path WIRING still reads the retired baked asset: fabro/settings.py:134 _fabro_workflow_toml_install_script does (_fabro_def_asset_root()/'workflow.toml').read_text() -> FileNotFoundError on every fabro launch. The workflow.toml BC_NAME/WORK_ID rewrite (and def_bundle.py:37 _load_fabro_def_files) must operate on the POURED /workspace/.fabro/ container files, not the host-side baked asset. LESSON: retiring a baked asset (N4) requires updating ALL code that READS it, not just the placement call — and the fabro-engage path was never validated end-to-end before release (no scout). tmux path unaffected (skips fabro wiring). Ties to lead-bq2z (dead _place_fabro_def_bundle).



### shopsystem-effectiveness-key-bcs-cannot-validate-the-fabro
shopsystem effectiveness KEY: BCs CANNOT validate the fabro ENGAGE end-to-end — the BC env has NO docker (their suites inspect committed artifacts structurally / via FakeDockerDriver, run no containers). So fabro-engage bugs (pour completeness, wiring, runtime crash) are STRUCTURALLY INVISIBLE to the BC gated loop and only surface when the LEAD launches a real container on --orchestrator fabro. IMPLICATION: (1) the lead MUST scout-launch on fabro after every fabro-affecting release and drive the fix loop (lead scouts -> finds bug -> dispatch -> BC fixes structurally -> release -> bc-base rebuild -> lead re-scouts); (2) a BC 'work_done complete' on a fabro-path change is NOT proof the engage runs — only a lead scout is; (3) shopsystem needs a docker-capable fabro-engage e2e test (a lead-side or CI harness that actually runs 'fabro run dispatcher.toml' in a container) as the real gate. This is the ROOT reason the whole fabro engage shipped never-validated.



### shopsystem-effectiveness-reactive-engage-stall-a-bc-brought
shopsystem effectiveness: REACTIVE-ENGAGE STALL — a BC brought online with dispatches ALREADY in its inbox never works them: the shop-msg watch LISTEN/NOTIFY fires only on NEW arrivals, and the session-start prompt lists-but-doesn't-work pending items then idles 'await direction'. A lead 'shop-msg send nudge' did NOT wake the idle Claude agent; only 'bc-container inject' of a work-the-inbox prompt started a turn. Filed lead-za30-adjacent P1. Lesson: session-start MUST drain+WORK pre-existing inbox, and reactive wake must start a turn on nudge.



### shopsystem-effectiveness-refinement-the-reactive-engage-stal
shopsystem effectiveness REFINEMENT: the reactive-engage stall is specifically for dispatches QUEUED BEFORE the agent comes online (knowledge case: watch fires only on NEW arrivals, so pre-existing inbox items never trigger it + startup-drain lists-but-doesn't-work them + deep 'await direction' idle resists nudge). Dispatches arriving to an ALREADY-ONLINE agent DO get worked (templates worked lead-8ki2, messaging worked lead-pkq0 — the watch woke them). So the fix scope is narrower: session-start must WORK the pre-existing inbox; steady-state reactive dispatch is fine. Also: shop-msg promote can't deposit a queued dispatch lacking payload_ref (bd placeholder) — recovery is a direct re-send of the request.



### shopsystem-effectiveness-release-emits-also-hit-the-bc
shopsystem effectiveness: RELEASE emits ALSO hit the bc-emit wrapper false-STALE (templates v0.52.0 and messaging v0.4.5 BOTH forced --force via ADR-039 D4). That's 6-7 forced-recovery emits in one session from ONE unfixed wrapper. A flat release (zero payload scenarios) STILL runs the whole-corpus scenario-hash precondition and false-refuses on ANY unrelated stale/mis-blocked tag -> the wrapper is unusable for routine sign-off fleet-wide until delivered. Strongly reinforces: deliver shared-surface fixes FIRST.



### shopsystem-effectiveness-scenarios-cli-canonicalization-chan
shopsystem effectiveness: SCENARIOS CLI CANONICALIZATION CHANGE (ADR-056 D5) is a hidden fleet-breaker. scenarios 0.3.1 changed 'scenarios hash' CLI from whole-text to parse-then-block-only while keeping the LIBRARY compute_scenario_hash byte-identical. A contract-surface check ('library byte-identical -> additive') MISSED it because the change was in the CLI subcommand, not the lib. messaging's catalog pins catalog._canonical_scenario_hash == 'scenarios hash' CLI (test masked by pure-block samples where block-only==whole-text). LESSON: a dependency's CLI-surface canonicalization can diverge from its library API; verify BOTH. The on-disk @scenario_hash pins are already block-only (ADR-019), so aligning messaging catalog to block-only is CONFORMANCE, and the fleet adopts simultaneously via bc-base rebuild + lead reinstall (the convergence itself).



### shopsystem-effectiveness-silent-agent-exit-failure-mode-a
shopsystem effectiveness: SILENT AGENT-EXIT failure mode — a BC's Claude agent can EXIT (tmux 'agent' window drops to a bash shell, no claude process), yet 'shop-msg bc-status' still reports the BC 'online' because status tracks the shop-msg watch/registration, NOT agent liveness. Result: dispatches sit unworked forever with no signal (worse than the reactive-engage stall — here there is no agent at all). Observed on templates after it completed several work_done. LESSON: (1) bc-status MUST gate on agent-process liveness, not just watch registration; (2) BCs need agent auto-restart / a supervisor; (3) the lead's in-flight stale-check must probe agent liveness (ps claude), not trust bc-status=online. Recovery: 'bc-container start-agent <bc>' (recovers an agent-less but cloned/healthy container).



### shopsystem-effectiveness-the-fabro-engage-bug-stack-keeps
shopsystem effectiveness: the fabro engage bug stack keeps unpeeling because it was NEVER run e2e — layer 3: shop-templates _pour_fabro (ADR-057) emits the ADR-051 WORKFLOW def but not the ADR-058 DISPATCHER def (dispatcher.toml etc.) that the engage 'fabro run dispatcher.toml' actually runs. _pour_fabro was written against the older def shape and not updated when ADR-058 added the reactive dispatcher. LESSON: when a def/asset set grows (ADR-051 -> ADR-058), EVERY emitter/pour of it must be updated in lockstep; and a pour must be validated by RUNNING the thing it feeds (fabro run), not just 'files present'.


### shopsystem-effectiveness-the-fabro-engage-was-never-validate
shopsystem effectiveness: the fabro engage was NEVER validated end-to-end before this session's convergence attempt — scouting revealed a STACK of breakage: (1) shop-templates 'update' CLI doesn't emit .fabro (N1-N3 built _pour_fabro but didn't wire it into update -> unit scenarios passed via a test harness, masking that the real launch pour path emits nothing); (2) bc-launcher N4 fabro-wiring reads the retired baked asset; (3) new-bc-base bd schema skew v32->v53 breaks bd bootstrap. LESSON: a capability verified only by unit scenarios (fabro validate on a poured def) is NOT proven until it runs through the REAL launch path end-to-end. ADR-057/N4 needed a SCOUT (one real fabro launch to online) before release; the router should scout-launch on fabro immediately after the first delivery, not after building the whole convergence.



### shopsystem-fabro-engage-work-item-execution-is-the
shopsystem: fabro engage work-item execution is the ONE unverified last-mile layer. The dispatcher's decide() SPAWNs a workflow.fabro bc-shop-loop per pending work_id (type-agnostic SKIP/SPAWN), verified present+running. NOT yet proven: a real assign_scenarios/request_bugfix dispatch on fabro spawns a child that RUNS workflow.fabro (Implementer->Reviewer) to completion + emits work_done. Testing needs a real implement-work dispatch + watching the full loop (minutes). Recommend proving this on ONE BC before flipping the whole fleet, since a broken work-completion path would leave BCs online-on-fabro but non-functional.



### shopsystem-milestone-2026-07-12-the-fabro-engage
shopsystem MILESTONE 2026-07-12: the FABRO ENGAGE now RUNS end-to-end (proven on shopsystem-knowledge). Full layer stack solved: (1) keystone lead-1cj1 - shop-templates 'update' pours .fabro; (2) lead-a3kg - launcher wiring reads POURED workflow.toml not baked asset; (3) lead-5qj1/lead-opd8 - _pour_fabro emits the ADR-058 dispatcher def (dispatcher.toml/.fabro/dispatch_acp_agent.py); (4) FABRO DISPATCHER BC_NAME - the wiring must rewrite dispatcher.toml [run.environment.env] BC_NAME too (not just workflow.toml), else the reactive watcher runs against the bundle default 'fabro-throwaway'. With all 4: 'fabro run dispatcher.toml' primes + 'dispatch_acp_agent.py --bc <BC>' + 'shop-msg watch --bc <BC>' run against the CORRECT BC. Lead launcher HOTFIXED for #4 (durable bc-launcher fix owed). Layers 1-3 released (v0.52.1/v0.3.62/v0.52.2-guess; canonical v0.52.3 in flight).



### shopsystem-milestone-knowledge-converged-on-fabro-with-the
shopsystem MILESTONE: knowledge CONVERGED on fabro with the durable release (bc-launcher v0.3.64 + bc-base 08521f1d canonical v0.52.3). The ADR-058 reactive dispatcher runs its full loop correctly: poll (list pending inbox work ids) -> dispatch (ACP script-agent SKIP/SPAWN decisions, spawn child detached) -> wait -> poll, all keyed to the correct BC (shopsystem-knowledge). All 4 fabro-engage layers durably fixed + released. The fabro engage is PROVEN working end-to-end at the dispatcher-loop level.



### spike-plane-excluded-from-coherence-graph-2026-07
spike-plane-excluded-from-coherence-graph-2026-07-17



### spike-plane-excluded-from-coherence-graph-2026-07-17
SPIKE/FINDINGS PLANE EXCLUDED FROM COHERENCE GRAPH + SYNTHETIC LEGACY GROUNDING (David, 2026-07-17). Governs [[artifact-object-graph-provenance-model-2026-07-17]]. BASIS: [[spike-precedence-rule-david-2026-07-06-feedback]] + ADR-032 + PDR-016 — findings/ is NON-AUTHORITATIVE, historical-reference-only; reason there are 8 types and NO 'finding' type (anti-context-poisoning, lead-x7bp class). DECISIONS: (1) NO 'finding' type. (2) findings/ REMOVED entirely; durable content ABSORBED AS NOTES into real typed artifacts. (3) NO 'legacyRoot' field. (4) LEGACY artifacts get SYNTHETIC GROUNDING: a synthetic PDR/brief (+ minimal synthetic candidate/intent/session chain) that WRAPS the finding content, TITLES ITSELF 'Legacy: ...' (filter handle = TITLE, ids are pattern-locked), giving the legacy ADR/PDR a real resolvable derives-from target. Result = ONE CONSISTENT CORPUS: every node a normal typed artifact tracing to a (possibly synthetic) intent; no special fields. PROVEN 2026-07-17 on adr-001: synthetic chain adr-001->pdr-900->cand-900->intent-900 (+ sess produced them) ALL validate conforming; GATE resolves FULL chain, ZERO dangling. Supersedes earlier legacyRoot+empty-derives-from idea. DIRECTORY CONVENTION DECISION (David 2026-07-17): UNIFORMLY PLURAL. The loader currently maps intent-record->intent/ (SINGULAR) while candidates/sessions/briefs/pdrs/adrs are plural — an inconsistency (mirror of the pdr/pdrs corpus bug). FIX: knowledge-BC one-line SUBDIR_TYPES intent-record->intents (must land BEFORE corpus rename) + corpus rename intent/->intents/. Target dirs ALL PLURAL: intents/ candidates/ sessions/ briefs/ pdrs/ adrs/. OTHER EMPIRICAL FINDINGS (for brief-024): 'unincorporated-decision' gate rule — every accepted pdr/adr must be claimed in current-state incorporates; pdr.derives-from is required-present but MAY be empty (adr must be non-empty); validator ACCEPTS unknown frontmatter fields (forward-compatible additive adoption). MIGRATION must: BC fixes (intent-record->intents dir); generate synthetic genesis substructure the ~63 legacy ADRs + legacy PDRs derive-from; absorb findings as notes; rename+repath all dirs/files/links; remove findings/.



### spike-precedence-rule-david-2026-07-06-feedback
SPIKE PRECEDENCE RULE (David 2026-07-06, feedback): spike/findings material is NEVER authoritative over ADRs/PDRs. In ANY pre-state verification, canonical evidence = ADR/PDR + features/ + live CLI surface; findings/*spike* is HISTORICAL REFERENCE ONLY, never current-state evidence, unless the ADR/PDR that graduated it points back to it. ROOT: this session an architect read findings/fabro-spike/ + stale ADR-048 forward-looking prose and reported fabro's current state WRONG (fabro is productionized: bc-container launch --orchestrator fabro, features/shopsystem-bc-launcher/). Same failure class as lead-x7bp (stale decisions masquerading as current). Tracked in the spike-lifecycle-containment bead.



### standing-directive-david-2026-07-06-from-now
STANDING DIRECTIVE (David 2026-07-06): from now on, launch/bring-up any new BC under fabro (--orchestrator fabro) to shake fabro out with real use (dogfood). Affects create-bc (lead-2nf1), bring-up (lead-3nf7), the dagger dogfood (lead-6tks), and the BC-lifecycle-management design (must account for fabro teardown/graceful-exit).



### verification-discipline-v0-30-0-37-adopter-bootstrap
VERIFICATION DISCIPLINE (v0.30-0.37 adopter-bootstrap arc): when a BC fix depends on a runtime the BC sandbox LACKS (agent-vault broker, docker), the LEAD must live-verify the ACTUAL rendered command/mechanism against a real instance — NOT a hand-approximation. ~4 fixes this run false-passed because the verifier ran a DIFFERENT invocation than the code: (1) 'vault create --address' (rejected flag, masked by 2>/dev/null) — I'd tested the without-address form; (2) 'vault credential set' under the owner REMOTE scoped session fails 'Member role required' — works ONLY broker-local docker-exec (provision's way); (3) approve-claude proposal# via 'grep -oE [0-9]+ | tail -n1' grabbed the CREATED-timestamp minutes not the # column. Pin the MECHANISM/structure in the scenario (not just the value), and the lead live-verifies the real rendered command end-to-end before release. ADR-043 (single-source-of-truth) is the durable fix for the duplicated-derivation bug class.



### vocabulary-dev-model-queued-behind-cand-005-2026-07-19
SEQUENCING DIRECTIVE (David, 2026-07-19): The vocabulary-dev-model integration — the two handoffs (dev-model/Model-2 + vocabulary-lifecycle-v3) plus /tmp/vocabulary-dev-model/integration-analysis.md — must NOT be advanced, neither ratified via its six §8 rulings NOR taken to PM discovery, until cand-005 (the knowledge/schema precondition chain) is COMPLETE. Reason: a 4-pass lead-architect reconciliation (2026-07-19) showed the integration analysis was frozen 2026-07-11 against a 2026-07-09 snapshot and assumes a FINISHED ADR-059 typedef + coherence-gate foundation — but cand-005/intent-007 ('fund it all') found that foundation substantially broken on 2026-07-16 and is still closing it. Key drifts the analysis carries: lead-kz33 CLOSED 2026-07-12 (its 'fold into one role-material wave' landing pad is gone); the scenario-identity bug family (lead-ji28/wek9/s4av/4qy) it targets was already CLOSED by 2026-06-30; ADR-047 is the WRONG gate (version-BOM, not artifact-graph — brief-023 caught this); ADR-065 made 'findings never authoritative' doctrine so the handoffs are background-only until graduated to PDR/ADR; PDR-032 since ACCEPTED as EXTEND (strengthens the format-routing ruling). When cand-005 lands, RE-ENTER the vocabulary work via PM discovery from first principles (David's explicit framing), NOT by walking the stale rulings. DDD epic lead-bh2m remains the intended landing pad (untouched since 2026-07-07).


# 🚨 SESSION CLOSE PROTOCOL 🚨

**CRITICAL**: Before saying "done" or "complete", you MUST run this checklist:

```
[ ] 1. bd close <id1> <id2> ...   (close completed issues)
[ ] 2. run quality gates        (tests, linters, builds when relevant)
[ ] 3. git status               (check what changed)
[ ] 4. follow active profile    (conservative: report handoff; team-maintainer: commit/sync/push if enabled)
```

**Policy:** Conservative is the default. Commit, sync, or push only when the active user, orchestrator, or repository profile grants that authority.

