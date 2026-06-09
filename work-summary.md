# Work Summary — 2026-06-08

## In Progress (6)

| ID | P | Summary |
|---|---|---|
| lead-ji28 | P1 | **Bug:** hash canonicalization mismatch — `scenarios[].hash` uses Feature-line-included form; `@scenario_hash` tags use block-only |
| lead-o6tp | P1 | **ADR-candidate:** move procedural pre-emit checks from template prose into `shop-msg respond` CLI enforcement |
| lead-xc0d | P2 | **Dispatch:** `request_bugfix` → shopsystem-messaging (pending send) |
| lead-3nf7 | P2 | **Bring-up:** BC fleet via `bc-container` + bake bring-up skill into lead templates |
| lead-uxmg | P2 | **Bake phase 4:** relaunch all BCs on new bc-base digest |
| lead-di16 | P3 | **Track C:** experimental PM-skill slices (adapt deanpeters skills) |

---

## Ready (60 total)

### P1 — 10 issues

| ID | Summary |
|---|---|
| lead-rl0f | `shop-msg respond` has no direction guard; lead can silently mis-route clarify answers |
| lead-1j1h | Credential-authorization assertion bug in 40-family `repository_dispatch` EMIT |
| lead-h1tw | Registry routing identity should be abstract `<system>/<name>`, not a filesystem path |
| lead-n5r1 | BC-container startup readiness gate (beads-functional + DB-reachability + health check) |
| lead-gw60 | Reconciliation gap: defect (a) in lead-pw41 still unverified |
| lead-0217 | BC self-registers with container-internal path, polluting lead registry |
| lead-hdn3 | BC primer missing autonomous-drain pin — BCs pause between inbox items |
| lead-fnj5 | `bd close` doesn't transition `dispatch_state` from `consumed→closed`; breaks strict-mode `--depends-on` |
| lead-2id | `shop-msg respond` collision is unrecoverable; `consume outbox` doesn't free lead-inbox row |
| lead-7wp | Verified dispatch (lead-xea) lost from BC inbox between sessions |

### P2 — 40 issues

| ID | Summary |
|---|---|
| lead-b6x | lead-0bw reconciliation blocked: BC working tree modifies conftest.py but no commit on messaging main |
| lead-oyaj | BC discipline: self-resolve fixable procedural gate failures before work_done |
| lead-cnbu | Architect design: BC-local architect role + three-tier ADR mechanism |
| lead-ir9m | Initiative: BC design quality — decomposition discipline + BC-local architect + ADR hierarchy |
| lead-tgs4 | Initiative: lead-architect structurizr workspace + PO→PM role elevation |
| lead-fzym | Cut v0.2.0 release of shopsystem-bc-launcher from current main |
| lead-yxsr | BC agents go idle-at-prompt after finishing work, don't return to react loop |
| lead-czwo | Centralized bc-base rebuild trigger: bc-launcher polls baked-dep releases, bumps pins, rebuilds |
| lead-s4av | BC-held bc-launcher 36-41 gherkin bodies drifted from dispatched hashes |
| lead-g015 | assign_scenarios from lead (lead-jx4u) |
| lead-w84j | assign_scenarios from lead (lead-8dx7) |
| lead-p6oz | assign_scenarios from lead (lead-ieph) |
| lead-wek9 | Stored @scenario_hash tags drift from canonical block-only hash across messaging features/ |
| lead-y6gu | Re-scope xc0d drifted RETIRE 45-47 + REVISE 01/02/05/15/21/22 |
| lead-4vue | PO re-author revised bodies for messaging-registry scenarios 02 + 05 under abstract addressing |
| lead-rcjf | No consume-inbox command + supersession does not drain BC inbox |
| lead-kmtl | Tighten shop_msg scenario-hash computation to canonical block-only form |
| lead-3lw6 | Recurring registry-reset + unset SHOPMSG_DSN drift on lead host |
| lead-6669 | dispatch assign_scenarios → shopsystem-templates |
| lead-gf4h | Audit shop-msg CLI paths that scope bd cwd to registry shop_root for absent-path crash |
| lead-og6q | lead-ji28 migration: re-canonicalize serialized hashes |
| lead-nps | Screen-scraped readiness markers must be unambiguous across UI states |
| lead-plt | BC work_done emit fidelity — summary placeholder and incomplete scenario_hashes |
| lead-b3z | shop-msg respond work_done lacks CLI-layer repeat-emit collision guard |
| lead-497 | BC test fixtures leak synthetic rows into shop_registry without cleanup |
| lead-tsj | Postgres-backed shop-msg state lost across LISTEN connection drop |
| lead-8z1 | request_maintenance: shopsystem-messaging — allow multiple clarify rows per work_id |
| lead-8bz | request_maintenance: shopsystem-messaging postgres backend |
| lead-d6o | Clarify protocol gap — clarify-resolution requires explicit re-dispatch with original scenarios |
| lead-xq0 | Product venv installs drift from BC source after BC work lands (no auto-reinstall) |
| lead-4qy | bc-implementer template should require hash-recompute verification after @scenario_hash edits |
| lead-6t3 | Round-4 outlook: per-step CLI naming for WRITE-mailbox actions across all four canonical templates |
| lead-wgv | scenarios hash canonicalization ambiguity — raw body vs wrapped+tagged form |
| lead-rv9 | work_done(blocked) protocol gap — lead-side response shape unspecified |
| lead-4wy | Catalog work_id pattern asymmetry — Clarify rejects what AssignScenarios/RequestBugfix accept |

### P3 — 10 issues

| ID | Summary |
|---|---|
| lead-ogvl | Framework git-URL convention inconsistency (.git vs no-.git) causes pip conflicts |
| lead-9ja4 | Package/repo name mismatch: `shop-templates` in repo `shopsystem-templates` |
| lead-ykq2 | Correct lead's own .claude/shop/name.md from display form to canonical slug |
| lead-ln5x | features/templates/123 uses illustrative --note flag; real surface is --subject/--body |
| lead-1ne2 | shop-msg send lacks --description/--rationale flag for lead-side dispatch context |
| lead-ymct | Parallel in-flight dispatches to same BC create commit-sequencing deadlock |
| lead-bp3 | shop-msg consume gap: no 'consume inbox' surface for lead-side responses |
| lead-670 | mechanism_observation: cross-tracker work_id pattern (shopsystem-templates-918) |
| lead-vvz | shopsystem-messaging conftest synthetic-name fixtures lack finalizers |
| lead-i8u | shop-templates bootstrap fails on existing .beads/ — needs idempotent/skip mode |
| lead-yug | Framework convention: @supersedes:<hash> tag for scenario replacement |
| lead-725 | bc-implementer singleton-inbox presumption constrains lead-shop dispatch cadence |
| lead-zmi | shop-msg not on default PATH — requires venv activation for cold dispatches |
| lead-otu | Scenario register surface for templates BC (lead-architect activity currently degenerate) |

### P4

| ID | Summary |
|---|---|
| lead-f6ta | Spike: fabro as alternable orchestration substrate (BC launch + Monitor loop) |
