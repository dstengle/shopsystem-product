---
type: brief
id: brief-011
title: 'The end-to-end new-product bootstrap path: empty dir → a working second product'
status: draft
created: 2026-06-12
updated: 2026-07-17
authors: [dstengle (stakeholder), Claude (lead-po)]
description: '*A developer standing up a second product from scratch can go from an empty'
derives-from: [pdr-018, adr-038, adr-037, adr-026, adr-028, adr-018, adr-029]
---

## Summary

The job-to-be-done: a developer standing up a second product from scratch can go
from an empty target directory to a working lead shop — with its own isolated
supporting services and at least one BC online doing real work — by following one
documented path, hitting exactly one human-gated credential step, and hand-editing
nothing. This is the WS-2 deliverable that the WS-0 dummy-product spike (PDR-018)
is the acceptance gate for. The independent MVP review (finding 3) named the gap:
no document walks an adopter from empty `briefs/adr/pdr/features` to a working
lead shop. This brief is that document.

Three load-bearing constraints are settled. (1) The lead instance owns no code
(lead-8cc2): every step either runs a `shop-templates` / `bc-container` / `bd` /
`shop-msg` command or sets a value in instance config (`.env`,
`bc-manifest.yaml`); no step edits rendered `ops/` code, role templates, or skills
in place — genericity fixes go to `shop-templates` and re-pour. (2) Full
per-product isolation: two products on one host share nothing at runtime (distinct
docker network, host ports, data volume, broker, and postgres), with the product
slug as the non-collision discriminator. (3) Identity is declared once (ADR-038):
the product sets `product: <slug>` in its manifest and the fleet tooling derives
the slug, network, BC-name-shape prefix, and (where applicable) image namespace
from it. The credentials throughout are the developer's own (same GitHub account,
same Claude account) — simply held in a per-product broker rather than mounted
from the host; isolation is about the runtime substrate per product, not about
separate identities.

## Scope

Committed (settled, not open): the six-step bootstrap shape and the one human gate
(Step 4); the isolation invariant (own network, ports, data, broker, postgres,
slug as discriminator); the no-code-in-the-instance invariant (lead-8cc2); and
identity-declared-once via `product:` (ADR-038).

The bootstrap walk — six steps, one human gate: (1) scaffold the lead shop
(`shop-templates bootstrap --shop-type lead --shop-name <product>-product --target
<dir>`) → a fresh lead repo with empty product-document directories (the only
inheritance is skills + templates + installed tools, not another product's
artifacts — PDR-018 condition 1), its own `.beads` registry + `<product>-beads`
remote, self-contained role templates + skills (ADR-037; the framework spec §1–6
is NOT shipped, ADR-037 D1), and product-scoped `ops/` rendered through the slug
(`compose.yaml` with `<product>-postgres` and `<product>-agent-vault` on docker
network `<product>` at host ports distinct from any other product and a
product-scoped data volume / `SHOPSYSTEM_DATA` equivalent; `bin/shop-shell`
broker-wired per ADR-026 with no host `~/.claude` / `~/.gitconfig` mounts;
`bin/agent-vault-provision` and `bin/agent-vault-check`) — zero `shopsystem-*`
literals, no collision with the live fleet. (2) Set the instance secret (`cp
.env.example .env`; set `AGENT_VAULT_MASTER_PASSWORD` to this product's own value)
→ a gitignored `.env` carrying the broker master password that auto-unlocks the
encrypted vault (ADR-028 D1); instance config, not code. (3) Bring up supporting
services (`bin/shop-shell` or `docker compose up -d`) → `<product>-postgres` and
`<product>-agent-vault` on the `<product>` network at distinct host ports (ADR-026
D2/D3), alongside any other product with no collision. (4) Provision the broker —
THE ONE HUMAN GATE (`bin/agent-vault-provision`) → a provisioned `<product>`
broker vault + a minted `<product>-fleet` agent token; the human, exactly once,
pastes the GitHub PAT and sets the Claude OAuth credential via the agent-vault
dashboard (the refreshing-OAuth type is not CLI-expressible, ADR-026 D2 caveat;
the broker auto-refreshes it), and the script mints the `<product>-fleet` token
(record the `av_agt_…` value — it wires `shop-shell` and the BC launches); after
this no real credential ever enters a BC container, and `bin/agent-vault-check`
confirms the broker is reachable/provisioned before a launch. (5) Declare and
launch the BC(s) — declare in `bc-manifest.yaml` (carrying `product: <product>`
per ADR-038 D1 plus one `{name, remote, role}` entry per BC) and run
`bc-container launch <bc> --image <product-image> [flags]` → the BC online, cloned
brokered, attached to the `<product>` network, gated on both supporting services
reachable (ADR-026 D3), with `product:` + `--image` flowing the identity (ADR-038
D2) so a message addressed to it projects under `<product>`, not
`shopsystem/<name>` (the silent-routing defeat PDR-018 condition 2 guards).
(6) Dispatch work — lead-po authors at least one real, buildable scenario;
lead-architect dispatches via `assign_scenarios`; the BC runs its
implementer→reviewer loop and emits `work_done` carrying `scenario_hashes`; the
lead reconciles the register and matches the hashes → the §6.4 reconciliation
cycle closes under `<product>`, which IS the PDR-018 acceptance gate (conditions
5–7 + 9–10). The second product is then working.

Left open (Architect's call at dispatch / the spike's call empirically): the
exact `bc-container launch` flag set and the canonical `--image` reference for a
non-shopsystem product (ADR-038's open question — whether `product:` also defaults
the image namespace or `--image`/`BC_IMAGE` stays a fully independent override;
the conservative reading, `--image` independent, is what this brief documents, and
the spike confirms or refutes it); and whether any prime-the-pump prerequisite
(manual `docker network create` vs compose `external: true`, or a hand-clone of
the launcher before manifest sync) survives once the rendered `ops/` lands
(PDR-018's WS-2 dependency surface forecasts these as walls; the spike beads each
one it actually hits).

INSTALL.md rewrite scope: the current `INSTALL.md` is stale against the settled
architecture and must be rewritten. Defects to remove: (1) it contradicts ADR-018
/ lead-8cc2 by instructing `pip install -e repos/<bc>` and `git clone …
repos/<bc-name>` as an adopter path (the lead host carries no `repos/` BC source;
that entire model must be dropped); (2) it is shopsystem-and-dstengle-hard-coded
(every command bakes `dstengle/<bc-name>` and the `shopsystem` identity; the
rewrite must be the generic `<product>` walk with identity from `product: <slug>`
per ADR-038); (3) it predates the broker (no agent-vault broker, one-time paste,
or brokered clone; the rewrite must center Step 4 as the single gate and describe
brokered launch per ADR-026). What `INSTALL.md` should become: a thin pointer to
this brief as the authoritative bootstrap narrative plus the concrete §2 command
transcript parameterized on `<product>`. Scope split (deliberate): this brief is
the authoritative narrative now; the actual `INSTALL.md` file rewrite is carried
as a follow-up under lead-l7uz (item 2).

Relationship to the WS-0 spike (PDR-018): this brief IS the documented path the
spike re-executes from empty. The mapping is exact — Step 1 → condition 1 (empty
start, proven empty); Step 5 → condition 2 (distinct identity end-to-end); Steps
1–5 → condition 3 (one BC, documented path only); Step 6 → conditions 4–7 (typed
round-trip + §6.4 cycle); Step 6 + Steps 3/5 → conditions 9–10 (real feature,
self-contained docker). Each missing or broken step becomes a bead routed to its
owner (WS-1 fixes to the BC via `request_bugfix`; WS-2 doc/path gaps back to this
brief); the final clean re-run validates the fixes.

One open scope/vocabulary question for the user: does the throwaway
dummy-product spike (PDR-018) stand up a REAL per-product broker (full Step 4
paste), or may it skip the broker for the spike only? The settled architecture
says every product gets its own broker, but PDR-018 is an explicitly throwaway,
time-boxed spike whose durable output is a verdict, not a kept product
(ADR-029/030). Proposed default (PO, pending the user's call): the spike DOES
stand up a real per-product broker and does the Step 4 paste, because Step 4 — the
one human gate — is itself part of what the bootstrap path must prove walks
cleanly under a non-shopsystem slug; skipping it would leave the most
failure-prone, most identity-coupled step unexercised by the very run that exists
to prove the path. The cost is one extra credential paste into a throwaway vault;
the payoff is that the gate covers the whole documented path. If the user prefers
the spike reuse the existing shopsystem broker (treating own-broker-per-product as
a graduation-time, not a spike, requirement), §2 / PDR-018's scope amend
accordingly.

## Source (pre-modernization)

#### 1. The job-to-be-done

*A developer standing up a second product from scratch can go from an empty
target directory to a working lead shop — with its own isolated supporting
services and at least one BC online and doing real work — by following one
documented path, hitting exactly one human-gated credential step, and
hand-editing nothing.*

This is the WS-2 deliverable that the WS-0 dummy-product spike (PDR-018) is the
acceptance gate for. The independent MVP review (finding 3) named the gap
precisely: *no document walks an adopter from empty `briefs/adr/pdr/features`
to a working lead shop.* This brief is that document.

The load-bearing constraints, all settled:

- **The lead instance owns no code** (lead-8cc2). Every step below either runs a
  `shop-templates` / `bc-container` / `bd` / `shop-msg` command, or sets a value
  in instance config (`.env`, `bc-manifest.yaml`). No step edits rendered `ops/`
  code, role templates, or skills in place — genericity fixes go to
  `shop-templates` and re-pour, never in-place here.
- **Full per-product isolation** (per-product-instances decision). Two products
  on one host share nothing at runtime: distinct docker network, distinct host
  ports, distinct data volume, distinct broker, distinct postgres. The product
  slug is the discriminator that keeps them from colliding.
- **Identity is declared once** (ADR-038). The product sets `product: <slug>` in
  its manifest and the fleet tooling derives the slug, network, BC-name-shape
  prefix, and (where applicable) image namespace from it.

---

#### 2. The bootstrap walk — six steps, one human gate

Each step is framed by **what it produces**. The single human-gated step is
**Step 4** (the credential paste); every other step is mechanical and
scriptable. Throughout, `<product>` is the new product's slug (e.g. `dummyco`)
and `<dir>` is the target directory for the new lead repo.

> The credentials are the **developer's own** (the same GitHub account and the
> same Claude account they already use) — they are simply held in a
> **per-product broker** rather than mounted from the host. Isolation is about
> the *runtime substrate* per product, not about separate identities.

##### Step 1 — Scaffold the lead shop

**Run:**

```bash
shop-templates bootstrap \
  --shop-type lead \
  --shop-name <product>-product \
  --target <dir>
```

**Produces:** a fresh lead repo at `<dir>` with:

- **Empty product-document directories** — `briefs/`, `adr/`, `pdr/`,
  `features/` with no carried-over shopsystem content (the inheritance boundary
  PDR-018 condition 1 puts under test: the *only* inheritance is skills +
  templates + installed tools, not another product's artifacts).
- **Its own `.beads` registry** — initialized for this product, its own
  issue-prefix and its own `<product>-beads` companion remote (not shopsystem's).
- **Self-contained role templates + skills** (ADR-037) — `.claude/agents/`
  (lead-po, lead-architect) and the lead skill-group, poured inline; the
  framework spec §1–6 is NOT shipped (ADR-037 D1).
- **Product-scoped `ops/`** (lead-8cc2), rendered via the `<product>` slug:
  - `compose.yaml` with services `<product>-postgres` and `<product>-agent-vault`
    on docker network `<product>`, at **host ports distinct** from any other
    product on the host, and a **product-scoped data volume / `SHOPSYSTEM_DATA`
    equivalent** so two products never share pgdata or vault state;
  - `bin/shop-shell` — broker-wired (reaches Claude + github.com through the
    product's own broker, no host `~/.claude` / `~/.gitconfig` mounts per
    ADR-026);
  - `bin/agent-vault-provision` and `bin/agent-vault-check` (Step 4 / health).

  Because `ops/` is rendered through the slug, the scaffold of a second product
  contains **zero `shopsystem-*` literals** — no collision with the live fleet.

##### Step 2 — Set the instance secret

**Run:**

```bash
cd <dir>
cp .env.example .env
### edit .env: set AGENT_VAULT_MASTER_PASSWORD to this product's own value,
###   e.g.  openssl rand -base64 32
```

**Produces:** the product's `.env` (gitignored, never committed) carrying
`AGENT_VAULT_MASTER_PASSWORD` — the broker master password that auto-unlocks
this product's encrypted vault on restart (ADR-028 D1), distinct from any other
product's. This is instance config the lead owns, not code.

##### Step 3 — Bring up the supporting services

**Run:**

```bash
bin/shop-shell        # or: docker compose up -d
```

**Produces:** `<product>-postgres` and `<product>-agent-vault` running on the
`<product>` docker network at this product's distinct host ports — the two
supporting services every BC depends on before it can do useful work (ADR-026
D2/D3). Because the network, ports, and data volume are all product-scoped,
these come up **alongside** any other product already running on the host with
no collision.

##### Step 4 — Provision the broker  ← THE ONE HUMAN GATE

**Run:**

```bash
bin/agent-vault-provision
```

**Produces:** a provisioned `<product>` broker vault and a minted
`<product>-fleet` agent token. This is the **single manual credential step, once
per product**. The human, exactly once:

1. Pastes the **GitHub PAT** (the developer's own GitHub credential).
2. Sets the **Claude OAuth credential via the agent-vault dashboard** — the
   refreshing-OAuth credential type is NOT expressible through the CLI surface
   and must be created in the dashboard Credentials tab (ADR-026 D2 provisioning
   caveat). The broker auto-refreshes it thereafter.

The script then mints the `<product>-fleet` agent token (record the `av_agt_…`
value; it wires `shop-shell` and the BC launches). Everything else in
provisioning is scriptable; this paste is the only out-of-band secret
(ADR-026 D4). After this step, **no real credential ever enters a BC
container** — the broker substitutes them on outbound requests.

> **Health check (not a step, a confirmation):** `bin/agent-vault-check`
> verifies the broker is reachable and provisioned before you launch a BC, so a
> credential-substitution failure surfaces here rather than mid-work.

##### Step 5 — Declare and launch the BC(s)

**Declare** the product's BC(s) in `bc-manifest.yaml` (instance config the lead
owns). The manifest carries `product: <product>` (ADR-038 D1 — the single
declared identity) and one `{name, remote, role}` entry per BC.

**Run:**

```bash
bc-container launch <bc> --image <product-image> [<launch flags>]
```

**Produces:** the product's BC online — cloned **brokered** (through the
product's own broker, no host credential mount), attached to the `<product>`
network, gated on both supporting services being reachable (ADR-026 D3). The
`product:` manifest field plus the `--image` flag flow the product identity
through launch (ADR-038 D2): the BC's name-shape, network, and slug all derive
from `<product>`, so a message addressed to it projects under the `<product>`
slug — not `shopsystem/<name>` (the silent-routing defeat PDR-018 condition 2
guards against).

##### Step 6 — Dispatch work

**In the new lead shop:** lead-po authors at least one scenario (a real,
buildable behavior — not a plumbing echo); lead-architect dispatches it to the
BC via `assign_scenarios`; the BC runs its implementer→reviewer loop and emits
`work_done` carrying `scenario_hashes`; the lead reconciles the scenario
register and matches the hashes.

**Produces:** the §6.4 reconciliation cycle closing for a genuinely implemented
feature, under the `<product>` slug — which IS the PDR-018 acceptance gate
(conditions 5–7 + 9–10). At this point the second product is *working*: a real
feature implemented in a BC, running self-contained in docker on its own
isolated substrate.

---

#### 3. What this brief commits vs. leaves open

**Committed (settled, not open):**

- The six-step shape and the **one human gate** (Step 4).
- The **isolation invariant**: each product gets its own network, ports, data,
  broker, and postgres; the slug is the non-collision discriminator.
- The **no-code-in-the-instance invariant** (lead-8cc2): every step is a tool
  command or an instance-config edit; nothing edits rendered `ops/`/templates/
  skills in place.
- **Identity-declared-once** via `product:` (ADR-038).

**Left open (Architect's call at dispatch / the spike's call empirically):**

- The exact `bc-container launch` flag set and the canonical `--image`
  reference for a non-shopsystem product (ADR-038's open question: whether
  `product:` *also* defaults the image namespace, or `--image`/`BC_IMAGE` stays
  a fully independent override). The conservative reading — `--image` independent
  — is what this brief documents; the spike confirms or refutes it.
- Whether any prime-the-pump prerequisite (e.g. a manual `docker network create`
  vs. compose `external: true`, or a hand-clone of the launcher before manifest
  sync) survives once the rendered `ops/` lands — PDR-018's WS-2 dependency
  surface forecasts these as walls; the spike beads each one it actually hits.

---

#### 4. INSTALL.md — what it must become (rewrite scope)

The current `INSTALL.md` is **stale against the settled architecture** and must
be rewritten. Specific defects to remove:

1. **It contradicts ADR-018 / lead-8cc2.** It instructs
   `pip install -e repos/<bc>` and `git clone … repos/<bc-name>` as an *adopter*
   path — i.e. it tells the adopter to clone BC source onto the lead host and
   install it editable. The lead host carries **no `repos/` BC source** (ADR-018);
   BC code lives only inside BC containers. That entire `repos/`-on-the-lead model
   must be dropped from the adopter narrative.
2. **It is shopsystem-and-dstengle-hard-coded.** Every command bakes
   `dstengle/<bc-name>` and the `shopsystem` identity. The rewrite must be the
   **generic `<product>` walk** of §2 above, where identity comes from
   `product: <slug>` in the manifest (ADR-038), not hard-coded org/slug literals.
3. **It predates the broker.** It has no notion of the agent-vault broker, the
   one-time credential paste, or brokered BC clone. The rewrite must center
   Step 4 as the single human gate and describe brokered launch (ADR-026).

**What `INSTALL.md` should become:** a thin pointer to *this brief* as the
authoritative bootstrap narrative, plus the concrete command transcript of §2
parameterized on `<product>` — the empty-dir→working-product walk, no
`repos/<bc>`-on-lead, no hard-coded org/slug, one human gate.

> **Scope split (deliberate).** This brief is the authoritative narrative now.
> The actual `INSTALL.md` file rewrite is carried as a **follow-up** under
> lead-l7uz (the bead already scopes it as item 2). This brief states precisely
> what the rewrite must produce so it is a mechanical edit, not a re-decision.

---

#### 5. Relationship to the WS-0 spike (PDR-018) — this is the documented path it runs

PDR-018's acceptance gate is *"the architect re-executes the documented path
from empty, not a one-time narration."* **This brief is that documented path.**
The mapping is exact:

| Brief 011 step | PDR-018 gate condition |
|---|---|
| Step 1 (scaffold, empty product docs) | Condition 1 (empty start, proven empty) |
| Step 5 (`product:` + `--image` flow identity) | Conditions 2 (distinct identity end-to-end) |
| Steps 1–5 (tools/templates only, no hand-edits) | Condition 3 (one BC, documented path only) |
| Step 6 (assign → work_done → reconcile) | Conditions 4–7 (typed round-trip + §6.4 cycle) |
| Step 6 (real feature) + Steps 3/5 (containerized) | Conditions 9–10 (real feature, self-contained docker) |

Each step the spike finds **missing or broken** becomes a bead routed to its
owner (WS-1 fixes to the BC via `request_bugfix`; WS-2 doc/path gaps back to
this brief); the final clean re-run validates the fixes. This brief is the spec
the spike measures against.

---

#### 6. One open scope/vocabulary question for the user

**Does the throwaway dummy-product spike (PDR-018) stand up a REAL per-product
broker (full Step 4 paste), or may it skip the broker for the spike only?**

The settled architecture says *every product gets its own broker* (per-product
isolation). But PDR-018 is an explicitly **throwaway, time-boxed spike** whose
durable output is a verdict, not a kept product (ADR-029/030). Standing up and
provisioning a real `<product>` broker — including the one human paste — for a
probe that is torn down at teardown may be more ceremony than the spike needs to
prove genericity.

**Proposed default (mine, pending your call):** the spike **DOES stand up a real
per-product broker and does the Step 4 paste**, because Step 4 — the one human
gate — is itself part of what the bootstrap path must prove walks cleanly under
a non-shopsystem slug. Skipping it would leave the single most failure-prone,
most identity-coupled step *unexercised* by the very run that exists to prove the
path. The cost is one extra credential paste into a throwaway vault; the payoff
is that the gate actually covers the whole documented path, Step 4 included. If
you'd rather the spike reuse the existing shopsystem broker (treating "own
broker per product" as a graduation-time requirement, not a spike requirement),
say so and I'll amend §2 / PDR-018's scope accordingly.
