workspace "shopsystem" "Canonical C4 structural model of the shopsystem framework (lead shop + BC landscape + inter-shop protocol). §3.3 artifact, owned by the Architect." {

    # ============================================================================
    # SOURCE PROVENANCE (ADR-018 / PDR-011: built ONLY from the contract/artifact
    # surface — this repo's spec sections, adr/, pdr/, features/, message schemas,
    # name registry. NO BC implementation code was read; the lead host carries
    # none. Every element/relationship below cites the surface that grounds it.)
    #
    #   §2  02-bounded-contexts-and-subdomains.md   — BC vs subdomain; Platform Ops
    #   §3  03-lead-shop.md                          — roles, activities, artifacts
    #   §4  04-bc-shop.md                            — Implementer/Reviewer gated loop
    #   §5  05-inter-shop-protocol.md                — hub-and-spoke, message catalogue
    #   §6  06-work-tracking.md                      — bd work_id model
    #   ADR-002  harness BC (Platform Operations subdomain)
    #   ADR-004  bc-launcher BC owns `bc-container`; sets SHOPMSG_DSN in container
    #   ADR-006  name registry in postgres; lead inbox; from/to on every message
    #   ADR-008  docs BC (end-user adoption docs)
    #   ADR-009  clarify resolution = additive re-dispatch on a new bead
    #   ADR-012  outbox atomicity: bd-first / postgres-second / status-flip-third
    #   ADR-014  presence heartbeat collapsed into `shop-msg watch`
    #   ADR-015  nudge message type
    #   ADR-016  shop-msg owns bd integration (CLI-side side effects)
    #   ADR-018  empirical verification = contract surface (the rule this model honors)
    #   ADR-019  canonicalization owned by scenarios BC; messaging transports
    #   ADR-020  routing identity = abstract <system>/<name>; lead = shopsystem/lead
    #   ADR-021  bc-base image owned by bc-launcher; auto-rebuild on utility release
    #   ADR-022  bc-base rebuilds CENTRALIZED in bc-launcher (supersedes ADR-021 §D2)
    #   PDR-031  shopsystem-knowledge founded as a kind-extensible knowledge context
    #   PDR-032  shopsystem-knowledge owns the artifact type system + coherence gate
    #   ADR-059  knowledge BC single-sources per-type typedef -> generated template + schema
    #   features/messaging, features/messaging-registry  — shop-msg + registry behavior
    #   features/scenarios                                — hash/verify behavior
    #   features/templates                                — roles, bootstrap, image publish
    #   features/bc-launcher, features/launcher-credentials — launch + credentials
    #   features/docs                                     — adoption docs
    #   features/test-harness                             — experiment/slice/run/evidence
    #   features/bc-manifest                              — BC manifest surface
    #   features/shopsystem-knowledge                     — typedef/schema/body-section conformance
    # ============================================================================

    model {

        # ---- External actors / systems (System Context) ----
        operator = person "Operator / Stakeholder" {
            description "Drives the lead shop: expresses intent, dispatches work, reconciles. §3 'where stakeholders meet the work'."
        }

        github = softwareSystem "GitHub" "Source repos (dstengle/*), Actions CI, releases (version tags). Each BC = one repo (§4)." {
            tags "External"
        }
        ghcr = softwareSystem "GHCR (ghcr.io/dstengle)" "OCI registry for published images: bc-base, templates, devcontainer (ADR-021/022; features/templates 142, devcontainer 16)." {
            tags "External"
        }

        # ---- The product ----
        shopsystem = softwareSystem "shopsystem framework" {
            description "One lead shop + N BC-shops coordinating via the typed inter-shop protocol over a shared postgres mailbox (§3, §5)."

            # === Lead shop (this repo) ===
            lead = container "Lead shop (shopsystem-product)" "Outward face of the product; owns all product-level artifacts; routes to PO/Architect subagents. Addressed as shopsystem/lead (ADR-020 D1)." "Claude Code + bd + shop-msg CLI" {
                tags "Lead"

                po = component "Product Owner (PO)" "Authors intent: brief, PDRs, Gherkin scenarios; answers clarify on scope/vocabulary (§3.1)." "subagent role"
                architect = component "Architect" "Owns shape, scenario assignment, reconciliation; sends assign_scenarios/request_bugfix/request_maintenance; answers clarify on architecture; maintains THIS workspace (§3.1/§3.2)." "subagent role"
                router = component "Router" "Main-agent: classifies requests, dispatches PO/Architect subagents, arms Monitor on shop-msg watch, drains pending (lead-primer)." "main agent"
                leadArtifacts = component "Product artifacts" "Brief, PDRs, ADRs, this structurizr workspace, Domain & Context Map, canonical Gherkin (features/), scenario-to-BC assignment, lead beads (§3.3)." "Markdown / DSL / Gherkin / beads"
            }

            # === BC-shops (one repo = one BC = one Bounded Context, §4) ===

            messaging = container "Messaging BC (shopsystem-messaging)" "The protocol hub. Owns shop-msg, the postgres mailbox, the name registry, bd integration, presence heartbeat. Subdomain: Inter-shop coordination (ADR-002)." "Python (shop-msg CLI)" {
                tags "BC"

                # Component view detailed below — this is the hub every interaction touches.
                cliSend = component "shop-msg send/respond/consume" "Outbound vehicles (assign_scenarios, request_bugfix, request_maintenance) and BC responses (work_done, clarify, mechanism_observation, nudge); consume releases lead-inbox slot (§5.3, ADR-009)." "CLI"
                cliWatch = component "shop-msg watch + heartbeat" "Postgres LISTEN/NOTIFY wakeup on the lead/BC inbox; upserts bc_presence on a tick (ADR-014). bc-status classifies online/stale/offline." "CLI + LISTEN"
                schemas = component "Catalog schemas (Pydantic)" "The 7 message types + ScenarioPayload value object; from/to required; schema is the contract (§5.2/§5.6, ADR-006 §5)." "Pydantic"
                registry = component "Name registry" "Maps canonical name -> abstract <system>/<name> address; lead is authoritative writer; no filesystem path (ADR-006, ADR-020 D1/D2)." "postgres table"
                bdFacade = component "bd integration facade" "Fires the paired bd side effect for every shop-msg command with a bd correlate, under ADR-012 atomicity (ADR-016)." "subprocess -> bd CLI"
                storage = component "Mailbox storage" "messages table keyed by recipient address; inbox/outbox rows; (work_id,direction,shop) uniqueness; bc_presence table (ADR-006, ADR-012, ADR-014)." "postgres"
            }

            scenarios = container "Scenarios BC (shopsystem-scenarios)" "Owns canonicalization + the `scenarios hash`/`verify` contract tool — the single source of truth for what a scenario hash IS (scenario-block-only). Subdomain: Specification (ADR-002/019)." "Python (scenarios CLI)" {
                tags "BC"
            }

            templates = container "Templates BC (shopsystem-templates)" "Owns role templates (shop-templates show/list), shop bootstrap + update, and image publish-on-tag. Subdomain: Role discipline (ADR-002; features/templates)." "Python (shop-templates CLI)" {
                tags "BC"
            }

            knowledge = container "Knowledge BC (shopsystem-knowledge)" "Sole owner of the artifact type system: per-type typedef -> generated template + JSON Schema fragment (read-only, drift-gated), frontmatter and body-section (x-required-sections) conformance checking, over the eight recognized artifact types. Exposes that logic externally as the `shop-knowledge` CLI (template/schema/validate). Subdomain: Specification (PDR-031/032, ADR-059; features/shopsystem-knowledge)." "Python (shop-knowledge CLI)" {
                tags "BC"
            }

            bclauncher = container "BC Launcher (shopsystem-bc-launcher)" "Owns `bc-container` (launch/attach/inject/monitor/stop/status/list) and the bc-base image (Dockerfile + publish + centralized rebuild). Sets SHOPMSG_DSN in containers. Selects the launch-time LLM provider (Anthropic default / OpenRouter override) and owns the fleet-wide tier+effort->model mapping table used to resolve poured model_stylesheet placeholders (ADR-063). Subdomain: Platform Operations (ADR-004/021/022/063)." "Python (bc-container CLI) + Docker" {
                tags "BC"
            }

            docs = container "Docs BC (shopsystem-docs)" "End-user adoption documentation (v1 plain markdown). Disjoint adopter audience. Subdomain: Platform Operations / adoption (ADR-008; features/docs)." "Markdown" {
                tags "BC"
            }

            harness = container "Test Harness BC (shopsystem-test-harness)" "Validates the framework against itself: experiment/slice/run/evidence/finding/baseline. Composes shop-msg/scenarios/shop-templates at the CLI boundary. Subdomain: Platform Operations (ADR-002; features/test-harness)." "Python (shop-test-harness CLI)" {
                tags "BC"
            }

            # === Planned (not yet instantiated) ===
            ecommerce = container "Ecommerce product BC (PLANNED)" "First real consumer product on the framework; tracked for a future ADR-003. Not yet instantiated (ADR-002 §sequencing)." "TBD" {
                tags "Planned"
            }

            # === Shared infrastructure containers ===
            postgres = container "Shared Postgres mailbox" "The single postgres instance all shops share: messages, shop_registry, bc_presence tables. Reached via SHOPMSG_DSN. The substrate of the inter-shop channel (ADR-006/012/014/020; compose.yaml)." "PostgreSQL" {
                tags "Infra"
            }
            beadsRegistry = container "bd work registry (per shop)" "beads-native work tracking; lead bead IDs are the canonical work_id flowing outward (§6, ADR-011/016). bd is authoritative for state, shop-msg for transport (PDR-010)." "beads + dolt" {
                tags "Infra"
            }
        }

        # ============================================================
        # RELATIONSHIPS — System Context level
        # ============================================================
        operator -> shopsystem "Expresses intent; dispatches work; reconciles results"
        shopsystem -> github "Hosts repos; CI builds/tests; cuts version-tag releases" "git / Actions"
        shopsystem -> ghcr "Publishes + pulls images (bc-base, templates, devcontainer)" "OCI / docker"
        github -> ghcr "Release-tag CI publishes images" "Actions"

        # ============================================================
        # RELATIONSHIPS — Container level
        # ============================================================
        operator -> lead "Operates the lead shop (router + PO/Architect subagents)"

        # Hub-and-spoke (§5.1): only lead <-> BC, mediated by shop-msg over postgres.
        lead -> messaging "assign_scenarios / request_bugfix / request_maintenance / request_scenario_register / request_shop_card; reads work_done/clarify" "shop-msg over postgres"
        lead -> scenarios "Dispatches scenario work; tightenings (ADR-019)" "shop-msg over postgres"
        lead -> templates "Dispatches role-template / bootstrap / image-publish work" "shop-msg over postgres"
        lead -> knowledge "Dispatches artifact-type/schema/validation-CLI work (PDR-031/032, ADR-059)" "shop-msg over postgres"
        lead -> bclauncher "Dispatches launch + bc-base rebuild work (ADR-021/022)" "shop-msg over postgres"
        lead -> docs "Dispatches adoption-doc scenarios (ADR-008)" "shop-msg over postgres"
        lead -> harness "Dispatches harness scenarios (ADR-002 dogfooding)" "shop-msg over postgres"
        lead -> ecommerce "Will dispatch product scenarios once instantiated (PLANNED)" "shop-msg over postgres"

        # BC -> lead responses are the SAME channel, differing by content (§5.1).
        messaging -> lead "work_done / clarify / mechanism_observation / nudge -> lead inbox" "shop-msg over postgres"
        scenarios -> lead "work_done / clarify -> lead inbox" "shop-msg over postgres"
        templates -> lead "work_done / clarify -> lead inbox" "shop-msg over postgres"
        knowledge -> lead "work_done / clarify -> lead inbox" "shop-msg over postgres"
        bclauncher -> lead "work_done / clarify -> lead inbox" "shop-msg over postgres"
        docs -> lead "work_done / clarify -> lead inbox" "shop-msg over postgres"
        harness -> lead "work_done / clarify -> lead inbox" "shop-msg over postgres"

        # Everyone uses shop-msg, whose storage IS the shared postgres (ADR-006).
        lead -> postgres "Reads lead inbox; deposits dispatches (via shop-msg)" "SHOPMSG_DSN"
        postgres -> lead "Delivers inbox notifications to the router's Monitor (LISTEN/NOTIFY; ADR-014)" "shop-msg watch"
        messaging -> postgres "Owns + reads/writes messages, shop_registry, bc_presence" "SHOPMSG_DSN"
        scenarios -> postgres "Reads inbox / writes responses (via shop-msg)" "SHOPMSG_DSN"
        templates -> postgres "Reads inbox / writes responses (via shop-msg)" "SHOPMSG_DSN"
        knowledge -> postgres "Reads inbox / writes responses (via shop-msg)" "SHOPMSG_DSN"
        bclauncher -> postgres "Reads inbox / writes responses (via shop-msg)" "SHOPMSG_DSN"
        docs -> postgres "Reads inbox / writes responses (via shop-msg)" "SHOPMSG_DSN"
        harness -> postgres "Reads inbox / writes responses (via shop-msg)" "SHOPMSG_DSN"

        # bd registry: lead bead IDs are the work_id; shop-msg fires bd side effects (ADR-016).
        lead -> beadsRegistry "Lead beads = canonical work_id; reconciliation close-out (§6)"
        messaging -> beadsRegistry "shop-msg owns bd integration: paired side effect per command (ADR-016)" "subprocess"

        # bc-launcher launches every BC container and manages the bc-base image.
        bclauncher -> messaging "Gates launch on messaging DB reachability (features/bc-launcher/33)"
        bclauncher -> ghcr "Pulls :latest bc-base at launch; publishes rebuilt bc-base (ADR-021 D3 / ADR-022)" "docker pull/push"
        bclauncher -> scenarios "Watches releases; bakes `scenarios` CLI into bc-base (ADR-022 D2)"
        bclauncher -> templates "Watches releases; bakes `shop-templates` into bc-base (ADR-022 D2)"
        templates -> ghcr "Publishes templates + devcontainer images on version tag (features/templates 142, devcontainer 16)" "docker push"

        # Release/CI edges to GitHub used by the bc-base rebuild flow (ADR-022).
        scenarios -> github "Cuts version-tag releases; CI builds/tests (scenario 129 convention)" "git / Actions"
        templates -> github "Cuts version-tag releases; CI builds/tests" "git / Actions"
        messaging -> github "Cuts version-tag releases; CI builds/tests" "git / Actions"
        bclauncher -> github "Polls dep release tags with own GITHUB_TOKEN; hosts bc-base build (ADR-022 D2/D3)" "git / Actions"
        bclauncher -> bclauncher "Scheduled/workflow_dispatch: bump Dockerfile pins, rebuild bc-base if changed (ADR-022 D2/D4)" "Actions"

        # ============================================================
        # RELATIONSHIPS — Component level (messaging hub internals)
        # ============================================================
        lead -> cliSend "Composes assign_scenarios / request_bugfix / request_maintenance"
        cliSend -> schemas "Validates message against the catalog contract (§5.6)"
        cliSend -> registry "Resolves --bc/--lead name -> <system>/<name> address (ADR-020)"
        cliSend -> storage "Deposits the mailbox row (postgres-second, ADR-012)"
        cliSend -> bdFacade "Fires paired bd side effect (ADR-016, ADR-012 atomicity)"
        cliSend -> scenarios "Delegates scenario-hash to `scenarios.hash` (in-process; ADR-019 D2)"
        cliWatch -> storage "LISTEN/NOTIFY on inbox; upserts bc_presence on tick (ADR-014)"
        bdFacade -> beadsRegistry "bd create/update/close via CLI (ADR-016 D4)"
        registry -> storage "Registry + messages co-located in one postgres DB (ADR-006 D1)"
        schemas -> scenarios "ScenarioPayload carries a scenario whose hash rule scenarios owns (ADR-019)"
    }

    views {

        systemContext shopsystem "SystemContext" {
            include *
            autolayout lr
            description "The shopsystem framework, the operator, and the external systems it depends on (GitHub, GHCR)."
        }

        container shopsystem "Containers" {
            include *
            autolayout lr
            description "Lead shop + each BC as a container, the shared postgres mailbox, and the bd registry. Edges labelled with the protocol (shop-msg over postgres)."
        }

        component messaging "MessagingComponents" {
            include *
            autolayout lr
            description "The messaging hub internals: send/respond/consume, watch+heartbeat, catalog schemas, name registry, bd facade, postgres storage. Touched by every inter-shop interaction."
        }

        # ---- Dynamic view (a): assign_scenarios -> gated loop -> work_done -> reconcile ----
        # NOTE: system-scoped dynamic view -> container granularity only (Structurizr
        # rule: components may not appear when the dynamic scope is a software system).
        # Role detail (Architect / Implementer / Reviewer) is carried in the step text.
        dynamic shopsystem "AssignScenariosFlow" {
            description "assign_scenarios dispatch -> BC internal Implementer->Reviewer gated loop -> work_done with scenario_hashes -> lead reconciliation (§4.2/§4.4, ADR-012/016)."
            lead -> messaging "1. Architect: shop-msg send assign_scenarios --bc <name> --work-id <lead-bead> (hash via scenarios)"
            messaging -> postgres "2. bd-first then deposit inbox row (ADR-012 atomicity)"
            messaging -> scenarios "3. Implementer: run BDD; recompute scenario hashes (ADR-019)"
            scenarios -> messaging "4. Reviewer: adversarial gate — block work_done until hashes/clean-tree satisfied (§4.4)"
            messaging -> postgres "5. shop-msg respond work_done(complete) with passing scenario_hashes -> lead inbox"
            postgres -> lead "6. Monitor fires <work_id> work_done; Architect reconciles register + hashes, bd close (ADR-016 D3)"
        }

        # ---- Dynamic view (b): clarify round-trip (additive-bead model, ADR-009) ----
        dynamic shopsystem "ClarifyRoundTrip" {
            description "BC clarify -> lead resolves by additive re-dispatch on a NEW lead bead (ADR-009 layer b); original dispatch stays in flight."
            messaging -> postgres "1. BC: shop-msg respond clarify --work-id <orig> -> lead inbox (asks scope/architecture)"
            postgres -> lead "2. Monitor fires <work_id> clarify; router routes scope/vocab to PO, architecture to Architect"
            lead -> messaging "3. PO/Architect decide; Architect picks vehicle on a NEW bead, send request_bugfix/assign_scenarios --work-id <new-bead>, citing <orig> (additive, ADR-009)"
            messaging -> postgres "4. New dispatch deposited; original row consumed once resolving dispatch is on the wire"
        }

        # ---- Dynamic view (c): bc-base rebuild on utility release (ADR-021/022) ----
        dynamic shopsystem "BcBaseRebuild" {
            description "Framework-utility release -> centralized bc-base rebuild in bc-launcher -> republish :latest -> launch pulls fresh digest (ADR-022 D2/D5; ADR-021 D3)."
            scenarios -> github "1. Utility cuts a version-tag release (vMAJOR.MINOR.PATCH) (scenario 129 convention)"
            bclauncher -> github "2. bc-launcher scheduled/workflow_dispatch poll reads latest dep tags with own GITHUB_TOKEN (ADR-022 D2/D3)"
            bclauncher -> bclauncher "3. Bump @vX.Y.Z pin in bc-base Dockerfile; rebuild only if a pin changed (ADR-022 D2)"
            bclauncher -> ghcr "4. Republish ghcr.io/dstengle/shopsystem-bc-base:latest at new digest (ADR-021 D1)"
            bclauncher -> ghcr "5. Next bc-container launch PULLS current :latest, not stale cache (ADR-021 D3 / scenario 39)"
        }

        styles {
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }
            element "Lead" {
                background #1168bd
                color #ffffff
            }
            element "BC" {
                background #438dd5
                color #ffffff
            }
            element "Infra" {
                background #6b6b6b
                color #ffffff
                shape Cylinder
            }
            element "Planned" {
                background #cccccc
                color #000000
                border Dashed
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
        }
    }
}
