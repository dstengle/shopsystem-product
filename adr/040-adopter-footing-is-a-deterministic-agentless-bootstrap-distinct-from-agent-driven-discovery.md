---
id: ADR-040
kind: adr
title: The adopter Footing is a deterministic, agent-less bootstrap script in a `shopsystem-starter` template repo, architecturally distinct from agent-driven Discovery; framework code lives only in the published image, never in the adopter's repo
status: accepted
date: "2026-06-18"
description: The adopter Footing is a deterministic, agent-less bootstrap script in a `shopsystem-starter` template repo, architecturally distinct from agent-driven Discovery; framework code...
beads: [lead-2xi3, lead-5cgv, lead-7if5, lead-8vxy, lead-94mn, lead-architect, lead-driveable, lead-integration, lead-okre, lead-reinstalls, lead-repo, lead-shop, lead-yrex]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018, ADR-026, ADR-028, ADR-038, ADR-039, PDR-011, PDR-019]
  pins: []
  related: []
---
# ADR-040 — The adopter Footing is a deterministic, agent-less bootstrap script in a `shopsystem-starter` template repo, architecturally distinct from agent-driven Discovery; framework code lives only in the published image, never in the adopter's repo

**Status:** accepted (2026-06-18)
**Tier:** system-global (per [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md) — this is a cross-BC, per-product structural decision about *how an adopter stands up a NEW product on this framework*: it touches the published image lineage (bc-launcher/bc-base), the `shop-templates bootstrap` surface (templates), and the lead host's provisioning ops; it is not framework-doctrine (§1–6) and not one BC's internals.)
**Authors:** dstengle (intent, the 2026-06-18 phased reframe on `lead-5cgv`), Claude (lead-architect)
**Pins:** the FINAL discussion decisions recorded on `lead-5cgv` (dave, 2026-06-18) and operationalized in `briefs/012-adopter-bootstrap-stand-up-product.md` §2 — *the bootstrap splits into Footing (deterministic, NO agent) → Discovery (agent-driven) → BC creation; the footing is a readable script in the adopter's own `shopsystem-starter`-forked repo; framework code lives ONLY in the published image.*
**Anchored to:** [ADR-026](026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md) (the one human credential gate; the brokered-credential substrate the footing provisions) and its D2 addendum + `lead-yrex` (the proposal-based OAuth gate that makes the credential capture in-script); [ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md) (broker as a per-shop supporting service; zero host-credential coupling); [ADR-018](018-empirical-verification-is-contract-surface.md) (the lead carries no `repos/` BC source; the adopter likewise carries no framework code — both receive framework IP only as installed/imaged distributions); [ADR-038](038-manifest-product-field-is-the-canonical-product-identity-source.md) (the manifest `product:` field as the single declared identity the footing derives the slug/network/prefix/namespace from); [ADR-039](039-release-cadence-version-bump-is-part-of-the-fix-lead-reinstalls-as-a-cadence-step.md) (the release cadence that guarantees the published image the footing pulls carries every genericity fix).
**Anchored on (PDR):** [PDR-019](../pdr/019-adopter-bootstrap-stand-up-product.md) (the product-decision record this ADR backs); [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md).
**Related beads:** `lead-5cgv` (the stand-up-product capability — the parent), `lead-8vxy` (lead-driveable provision — the gate-reliability slice this footing depends on), `lead-yrex` (the proposal-based OAuth gate — CLOSED, the in-script-capture enabler), `lead-7if5` (`.env` gitignore — CLOSED, a footing-correctness fix already landed), `lead-2xi3` (bc-base `:latest` lag — the image-pin pre-state), `lead-94mn` (this instance's drifted ops files), `lead-okre` (create-bc skill, the Phase-3 pair).

---

## Context

`briefs/012` and the adopter-journey finding (`lead-y73x`) name an ACUTE
promise-vs-delivery gap (P1): the front door promises *"talk to the lead and it
stands up your product,"* but the lead is a router with no skill that drives
services-up → broker-provision → first-BC. The original `lead-5cgv` framing —
*"lead orchestrates bring-up from a plain-language request"* — conflated two
phases that have **opposite reliability requirements**:

1. **Getting onto solid footing** (services up, broker provisioned, remotes
   wired, green `git push` + `bd dolt push`) must be **deterministic and
   repeatable**. An agent is the wrong tool: its non-determinism is exactly the
   liability at the step the adopter least tolerates flakiness.
2. **Defining the product** (problem-framing → JTBD → journey → brief/PDR) is
   **inherently agent-driven** — it is the judgment work the PM/lead roles exist
   for, and it *cannot* be a deterministic script.

Collapsing these into one "ask the agent to do everything" flow is what makes
the Stage-3 dip the deepest in the journey: the adopter reaches for the promised
orchestration at the exact moment a non-deterministic agent is least
trustworthy. The reframe dave settled (2026-06-18) **splits them at the footing
boundary**: a deterministic, agent-less script reaches footing; the agent enters
only afterward, at an explicit Discovery step.

A second structural question rides here: **where does framework code live in the
adopter's world?** ADR-018 established that the *lead host* carries no `repos/`
BC source — it receives BC IP only as installed packages and emissions. The
adopter is the same shape one level out: their repo must not become a fork of
framework code that immediately goes stale. The brief's constraint
("framework code lives ONLY in the published image; the starter is compose +
script + env-example + README") is the adopter-facing restatement of the
ADR-018 no-vendored-source doctrine.

This is a structural / packaging / bootstrap-topology decision with a real
product-UX surface (the adopter's first experience) — it pairs a PDR
(PDR-019, the product decision) with this ADR (the durable, hard-to-reverse
structural commitments). It is recorded as an ADR because the choices below
(image lineage, the starter-repo artifact, the phase boundary) are **expensive
to reverse** once an adopter cohort has forked the starter.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified 2026-06-18 from the lead CWD (`/workspaces/shopsystem-product`) against
this repo's `adr/`/`pdr/`, `bin/agent-vault-provision`, `bin/shop-shell`,
`.env.example`, `bc-manifest.yaml`, the installed `shop-templates bootstrap`
CLI (`--help`), and the `bd` registry. No BC source read, run, or git-observed.

1. **The OAuth credential is NOW capturable in-script via a PROPOSAL — the old
   "dashboard-only" note is SUPERSEDED. CONFIRMED** via `bd show lead-yrex`
   (CLOSED, reconciled, origin/main `d47c110`, rides templates v0.10.0): the
   canonical `bin/agent-vault-provision` Claude-OAuth gate was rewritten from a
   manual dashboard hand-create to an **OAuth-typed `CLAUDE_OAUTH`
   credential-slot PROPOSAL** created programmatically via `agent-vault vault
   proposal create -f -` (stdin JSON: `action:set, type:oauth,
   oauth.token_url` required + `client_id` + `scopes`, value unset). The human
   role drops to **approving the printed proposal** (`vault proposal approve
   <num> CLAUDE_OAUTH=<value> --yes`). Refresh is PRESERVED (`type:oauth` +
   persisted `token_url`, load-bearing-proved against a live 0.32.0 broker, not
   static). This **corrects** the prior `lead-5jbc` "OAuth not scriptable" note
   that `bin/agent-vault-provision`'s step 4b (on THIS instance) and ADR-026 D4
   still narrate. The local provision script is the STALE pre-rewrite copy
   (`lead-94mn` confirms THIS instance's ops files drifted; the canonical v0.10+
   body is proposal-based).

2. **`bc-base` is built brokered / non-interactive; the bootstrap phase needs an
   interactive `claude` + `gh` auth beat. CONFIRMED** via `bin/shop-shell`
   (runs `agent-vault run`-style brokered, NO host `~/.claude`/`~/.gitconfig`,
   creds via `AGENT_VAULT_*` + MITM `HTTPS_PROXY`) and ADR-026 D1 (the BC agent
   is wrapped `agent-vault run -- claude`, container holds only a
   `__PLACEHOLDER__` credential). The footing's auth beat is **before** any
   broker token exists — it is the interactive human paste/approve that
   *produces* the broker credential, so it cannot itself run under the brokered,
   placeholder-credential model bc-base ships.

3. **`shop-templates bootstrap` exists and scaffolds a lead repo. CONFIRMED**
   via `shop-templates bootstrap --help`: flags `--shop-type {bc,lead}`,
   `--shop-name`, `--target`. It is the documented pour entrypoint the footing
   step 4 invokes from the image. `lead-7if5` (CLOSED) already hardened the
   rendered `.gitignore` to ignore `.env`/`.env.*` with a `!.env.example`
   negation — a footing-correctness fix already in templates v0.11.0.

4. **The image-tag pin is a known live pain. CONFIRMED** via `bd show
   lead-2xi3` (OPEN): `bc-container launch` default `--image` is
   `ghcr.io/dstengle/shopsystem-bc-base:latest`, and on this host `:latest` ==
   v0.2.8 == messaging 0.2.1 (PRE-slug-projection), while v0.3.1 bakes messaging
   0.4.0 and projects the slug correctly. A footing that resolves `:latest` would
   silently bootstrap a stale, mis-projecting product.

5. **The manifest `product:` field is the single declared identity. CONFIRMED**
   via ADR-038 (accepted) + `bc-manifest.yaml` (the live file carries
   `name/remote/role` entries, no `product:` key yet — the field exists in
   `controller.launch()` but is unused on this instance). The footing's naming
   enforcement derives `<product>` once and the manifest declares it.

6. **@scenario_hash retirement enumeration. CONFIRMED — empty.** Ran
   `grep -r "@scenario_hash" features/` over the lead-held `features/` Gherkin in
   this repo. This is a planning PDR + structural ADR; it authors no Gherkin and
   retires no pinned BC-side coverage. The decomposition's `assign_scenarios`
   units (PDR-019) introduce NEW capability and the `request_bugfix` units
   tighten existing-but-unpinned ops-template behavior; none retire or supersede
   a prior BC `@scenario_hash`. The Gherkin is lead-po's next step; this ADR
   pins no hashes.

---

## Decision

### D1 — Image lineage: the footing pulls the EXISTING `bc-base`/bc-launcher image, run with an INTERACTIVE bootstrap entrypoint MODE — NOT a new image

The published image the footing pulls is the **existing `bc-base` lineage**
(owned by `shopsystem-bc-launcher` per [ADR-021](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)),
invoked in an **interactive bootstrap entrypoint mode** — not a separate
purpose-built bootstrap image.

Rationale (Finding 2): the bootstrap phase's one interactive beat (a human
`claude` + `gh` auth that *produces* the broker credential) is the **only** thing
that distinguishes the footing run from a normal brokered run; everything else
(the framework CLIs `shop-templates`, `shop-msg`, `bc-container`; the
`agent-vault` client; `claude`, `gh`, `git`) is **already baked** into bc-base.
A new image would duplicate that entire baked surface to add one entrypoint
variation, and would fork the release/rebuild cadence (ADR-021/022, ADR-039)
into two image lineages the lead must keep current — doubling the drift surface
the `:latest`-lag pain (Finding 4) already demonstrates. An entrypoint **mode**
on the one lineage keeps a single image, a single rebuild, a single reinstall
cadence. The mode difference is: run `claude`/`gh` interactively (TTY, host
input) for the one auth beat, instead of the brokered placeholder-credential
wrap bc-base defaults to. Owner: **shopsystem-bc-launcher** (it owns the image
and the launch/entrypoint surface).

### D2 — Claude-OAuth capture is IN-SCRIPT via the proposal gate; the human only APPROVES — no dashboard route

The footing captures the refreshing Claude-OAuth credential **inside the
deterministic script**, via the `lead-yrex` proposal mechanism (Finding 1): the
script `agent-vault vault proposal create -f -` creates the OAuth-typed
`CLAUDE_OAUTH` credential slot programmatically; the **single human beat is
approving the printed proposal** (`proposal approve <num> CLAUDE_OAUTH=<value>
--yes`), supplying the secret at approve time (ADR-026 D4 preserved). Refresh is
preserved (`type:oauth` + persisted `token_url`).

This **answers the brief's open Q1 in the affirmative**: the gate CAN be a
one-shot in-script create-then-approve; it does **not** route the human to the
dashboard. The footing consolidates this with the GitHub PAT paste (ADR-026 D4
GitHub leg) and the owner password into **one up-front human auth gate** (the
brief's §4 constraint), directly targeting the Stage-5 wall. The
`lead-yrex`-rewritten canonical `bin/agent-vault-provision` is the body the
footing wraps; THIS instance's stale dashboard-narrating copy (`lead-94mn`) is
reconciled to canonical, not carried forward.

The remaining gap is that provision is still an INTERACTIVE `read -s` script the
*lead* cannot drive end-to-end (`lead-8vxy`): for the footing to consolidate the
gate cleanly it accepts the non-secret + secret inputs via env/args and isolates
the one genuine human approval into a clean handoff. That is `lead-8vxy`'s slice
(routed to templates), a **dependency** of this footing, not re-solved here.

### D3 — The starter `compose` does NOT pin the image tag; the deterministic bootstrap script RESOLVES and pins a known-good tag at run time

The `shopsystem-starter` `compose.yaml` references the image **without a
hard-coded tag in the committed file**; the **bootstrap script resolves the
known-good tag at run time** and pins it for that footing run (writing the
resolved tag into the rendered `.env`/compose-override the run uses).

Rationale (Finding 4): a tag pinned in the committed starter compose is the
exact `:latest`-vs-`:v0.3.1` lag trap `lead-2xi3` documents, frozen into every
fork — an adopter who forks the starter six months later inherits a stale pin
they must know to bump. Resolving in the script keeps the *fork* evergreen while
keeping the *run* reproducible: the script resolves the current known-good
release tag (the ADR-039 cadence guarantees that release carries every
genericity fix), records it in the run's `.env`, and the adopter can read exactly
which tag they got. This honors both halves of the brief's Q3 tension
(reproducibility of the RUN, freshness of the FORK) without freezing staleness
into the template. The resolution logic lives in the bootstrap script (owner:
**shopsystem-templates**, which owns the rendered ops artifacts).

### D4 — The auth→vault→steady-state credential flow is a one-direction ratchet: interactive capture (footing) → provisioned agent-vault → brokered steady state

The credential lifecycle is exactly three beats, in order, and never runs
backward:

1. **Interactive capture (footing, one human gate):** the bootstrap script, in
   the interactive image mode (D1), runs the consolidated auth gate (D2): owner
   password → GitHub PAT paste → Claude-OAuth proposal create-then-approve. This
   is the ONLY beat with a human and the ONLY beat that touches a raw secret.
2. **Provisioned agent-vault (the durable store):** the secrets land in the
   broker vault (ADR-026/028); the broker mints the `av_agt_` proxy token and
   the CA. `.env` records `AGENT_VAULT_MASTER_PASSWORD` (auto-unlock on restart)
   and the proxy token (`.env.example` already documents both, and `lead-7if5`
   guarantees `.env` is gitignored).
3. **Brokered steady state:** every subsequent run — `bin/shop-shell`, every
   `bc-container launch`, Discovery, BC creation — is brokered: NO host
   credential mount, creds via `AGENT_VAULT_*` + MITM `HTTPS_PROXY` (ADR-028).
   No re-paste; the broker auto-refreshes the OAuth token.

The interactive beat (1) is precisely the bc-base-default-violating beat D1's
entrypoint mode exists to allow; once (2) completes, the system is in the normal
brokered posture and the interactive mode is never needed again for that product.

### D5 — The footing↔Discovery boundary is the green-push line; the footing is a script, Discovery is the agent

The footing ENDS — and Discovery BEGINS — at **solid footing: green `git push`
+ `bd dolt push`, then STOP** (brief §2 step 7). Everything up to and including
that line is the deterministic, agent-less script (services up, one auth gate,
`shop-templates bootstrap` pour, `<product>-lead-beads` create, git+beads remote
wiring, a dolt-push smoke test). Everything after it — defining the product
(problem-framing → JTBD → journey → brief/PDR) and standing up the first BC — is
**agent-driven and an explicit separate step the adopter runs**. The
plain-language "lead orchestrates from a request" the front door promises lives
in **Discovery**, not in the footing script. This boundary is load-bearing: it
is what lets the footing be deterministic (the one thing the adopter least
tolerates flaking) while keeping the judgment work where an agent belongs.

### D6 — Naming enforcement: validate the one user-chosen name, derive `<product>`, offer `gh repo rename`; force the shape for ALL tooling-created repos via the manifest `product:`

Only the lead repo name is user-chosen (the one "Use this template" fork). The
bootstrap script (owner: **shopsystem-templates**):

1. **validates** the forked repo name against the `*-lead` shape;
2. **derives** `<product>` from it (strip the `-lead` suffix) and writes it into
   the manifest `product:` field (ADR-038 — the single declared identity the
   slug/network/prefix/namespace all derive from);
3. if the name does not match `*-lead`, **offers `gh repo rename`** (a
   rename-after-the-fork, NOT a re-fork);
4. **forces** the `<product>-lead-beads`, `<product>-<bc>`, `<product>-<bc>-beads`
   shape for every TOOLING-created repo (beads repo, each BC repo) — these are
   created under the derived `<product>`, so they cannot drift (brief §3). The
   `<product>-<bc>` shape is the existing ADR-038 BC-name-shape gate
   (`lead-xntx`, shipped) applied under the derived slug.

Because every repo except the one forked lead repo is tooling-created under the
derived `<product>`, the convention is enforced for free; only the single
user-chosen name needs the validate→derive→offer-rename path.

---

## Alternatives considered

**A new purpose-built bootstrap image (D1 rejected alternative).** Rejected:
duplicates the entire baked framework-CLI surface bc-base already carries to add
one interactive entrypoint variation, and forks the ADR-021/022/039 image
release+rebuild+reinstall cadence into two lineages the lead must keep current —
doubling the `:latest`-lag drift surface (Finding 4) for no capability the
existing lineage lacks. An entrypoint **mode** is strictly cheaper and keeps a
single delivery cadence.

**Route the Claude-OAuth gate to the dashboard (D2 rejected alternative).** This
was the PRE-`lead-yrex` reality and what the stale local provision script
(`lead-94mn`) and ADR-026 D4 still narrate. Rejected: `lead-yrex` (CLOSED,
load-bearing-proved against a live 0.32.0 broker) established the proposal path
captures a refresh-preserving `type:oauth` credential in-script, leaving the
human only to approve. Routing to the dashboard would re-introduce the
context-switch the brief explicitly wants consolidated into one in-script gate,
on stale evidence the rewrite already corrected.

**Pin the image tag in the starter `compose.yaml` (D3 rejected alternative).**
Rejected: freezes `lead-2xi3`'s staleness trap into every fork — an adopter
forking months later inherits a stale pin. Resolving the tag in the script keeps
the fork evergreen and the run reproducible, satisfying both halves of the
brief's Q3 tension.

**Keep the original one-phase "agent orchestrates everything" framing (D5
rejected alternative).** Rejected: it is the root cause of the deepest journey
dip — it puts a non-deterministic agent at the footing step the adopter least
tolerates flaking. Splitting at the green-push line lets the footing be
deterministic while keeping judgment work agent-driven.

**Vendor framework code into the starter repo.** Rejected: it is the
adopter-level violation of ADR-018's no-vendored-source doctrine — the fork goes
stale the moment any framework package releases, and re-introduces exactly the
drift ADR-039's cadence exists to eliminate. Framework code lives only in the
image; the starter is compose + script + env-example + README.

---

## Consequences

- **One image lineage, one cadence** (D1): the footing rides bc-base's existing
  ADR-021/022/039 release+rebuild+reinstall cadence; no second image to keep
  current. The interactive entrypoint mode is a bc-launcher capability addition.
- **The Stage-5 wall is consolidated into one in-script gate** (D2/D4): owner
  password + GitHub PAT + Claude-OAuth approve, once, up front, no dashboard
  round-trip. Depends on `lead-8vxy` (lead-driveable provision) for the clean
  env-driven + single-approval handoff.
- **Forks stay evergreen, runs stay reproducible** (D3): the staleness trap is
  not frozen into the template; each run records the resolved tag.
- **The footing is deterministic and readable** (D5): a template fork plus a
  readable script in the adopter's own repo — non-magical, inspectable, no
  opaque agent at the footing.
- **Naming cannot drift** (D6): only the one user-chosen lead name needs
  enforcement; everything else is tooling-created under the derived `<product>`
  and pinned by the manifest `product:` field (ADR-038).
- **A NEW artifact — `shopsystem-starter` — must be created and homed** (PDR-019
  decides ownership): it carries compose + bootstrap script + `.env.example` +
  README, NO framework code. PDR-019 decides whether it is a lead-owned
  standalone template repo or gains a BC.
- **THIS instance's drifted ops files are reconciled, not forked forward**
  (`lead-94mn`): the canonical proposal-based provision body (`lead-yrex`) is the
  one the footing wraps.
- **No tier collapse.** System-global (per-product, cross-BC: image lineage,
  templates ops, lead provisioning); not framework doctrine, not one BC's
  internals. Tagged `system-global` per ADR-034.
- **No Gherkin authored, no dispatch sent, no `@scenario_hash` retired** here
  (Finding 6). The decomposition + vehicles are recorded in PDR-019 for lead-po
  (Gherkin) and the router (dispatch).

## Cross-references

- [PDR-019](../pdr/019-adopter-bootstrap-stand-up-product.md) — the product
  decision this ADR backs; the decomposition + dispatch plan.
- `briefs/012-adopter-bootstrap-stand-up-product.md` — the PO brief; §2 phases,
  §3 naming, §4 constraints, §6 the three open questions D1/D2/D3 resolve.
- `findings/adopter-journey-exploration-2026-06-18.md` (`lead-y73x`) — the JTBD +
  journey map; the Stage-3 / Stage-5 dips this ADR targets.
- [ADR-026](026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
  / `lead-yrex` — the one human gate; the proposal-based OAuth capture (D2).
- [ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
  — broker as a per-shop supporting service; zero host-credential coupling (D4).
- [ADR-038](038-manifest-product-field-is-the-canonical-product-identity-source.md)
  — the manifest `product:` field the naming enforcement derives from (D6).
- [ADR-039](039-release-cadence-version-bump-is-part-of-the-fix-lead-reinstalls-as-a-cadence-step.md)
  — the cadence that guarantees the resolved image (D3) carries every fix.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  no-vendored-source doctrine the starter's image-only-framework-code rule mirrors.
- `lead-5cgv` (parent), `lead-8vxy` (lead-driveable provision dependency),
  `lead-7if5` / `lead-2xi3` / `lead-94mn` / `lead-okre` (cross-referenced beads).

## Addendum (2026-06-25, PDR-021) — the starter slims to README + bin/bootstrap

This ADR's Context describes the `shopsystem-starter` repo as carrying
`compose.yaml` + `bin/bootstrap` + `.env.example` + `README.md`. [PDR-021](../pdr/021-unify-product-bringup-on-the-footing-runway.md)
narrows that: the starter carries **only `README.md` + `bin/bootstrap`**.
`compose.yaml` and `.env.example` are **rendered into the fork** by
`bin/bootstrap`'s in-container `shop-templates bootstrap` (versioned with the
published image), not carried in the starter.

This is consistent with — and deepens — this ADR's core doctrine ("framework
code lives only in the published image, never forked-and-stale"): any artifact
the image can render is removed from the starter so it cannot drift. The
published starter had in fact drifted (last rendered from templates v0.14.0
while templates were at v0.25.0); the slim removes that drift surface entirely.
The fork→`./bin/bootstrap`→render→`bin/footing`→stop→Discovery flow and the
Footing/Discovery boundary are unchanged.
