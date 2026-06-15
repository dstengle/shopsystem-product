# Getting started: stand up a new product with shopsystem

This guide walks a developer from an **empty directory to a working product** —
a new lead shop with its own isolated supporting services and at least one
Bounded Context (BC) online doing real work — by following one documented path,
hitting exactly **one** human-gated step (a credential paste), and hand-editing
no code.

It is the adopter-facing form of the authoritative bootstrap narrative in
[`briefs/011-new-product-bootstrap-path.md`](briefs/011-new-product-bootstrap-path.md).
Every command below is grounded in the live end-to-end runs recorded in
[`findings/dummyco-spike-iter-5.md`](findings/dummyco-spike-iter-5.md) and
[`findings/dummyco-spike-iter-7.md`](findings/dummyco-spike-iter-7.md), which
carried the example product `dummyco` from an empty directory to a BC serving a
real feature.

Throughout, substitute your own values for the placeholders:

| Placeholder | Meaning | Example |
|---|---|---|
| `<product>` / `<slug>` | your product's identity slug | `dummyco` |
| `<dir>` | target directory for the new lead repo | `/srv/dummyco-product` |
| `<bc>` | a Bounded Context name under the product | `greeter` |
| `<image>` | the container image a BC launches from | (see Step 6) |

> The model here is **not** the old `repos/<bc>` editable-clone setup. The lead
> shop carries **no BC source on disk** ([ADR-018](adr/018-empirical-verification-is-contract-surface.md)):
> BCs run as containers that clone themselves internally and report over
> `shop-msg`. If you remember `pip install -e repos/<bc>`, forget it — that path
> is gone.

---

## What you get

When you finish this guide you will have, on one host:

- **A new lead shop** at `<dir>` — its own product-document directories
  (`briefs/`, `adr/`, `pdr/`, `features/`), its own `bd` registry, its own
  role templates and skills, and **zero carried-over content** from any other
  product.
- **Its own isolated supporting services** — a `<product>-postgres` and a
  `<product>-agent-vault` broker on their own docker network, at their own host
  ports, with their own data volume. Two products on one host share nothing at
  runtime.
- **At least one BC online** — cloned and run **brokered** (no real credential
  ever enters the container), serving a real feature you dispatched to it and
  reconciled.

The credentials are **your own** (the same GitHub account and Claude account you
already use) — they are simply held in a per-product broker rather than mounted
from the host. Isolation is about the runtime substrate per product, not about
separate identities.

---

## Prerequisites

You need these on PATH **as installed tools** — from VCS/published pins, **not**
editable-from-a-clone:

- **Docker** (with `docker compose`) — runs the postgres, the broker, and the BC
  containers.
- **`shop-templates`** — the bootstrap/scaffolding CLI (renders the lead shop and
  its `ops/`).
- **`shop-msg`** — the messaging CLI (dispatch + reconcile).
- **`bd`** (beads) — the work-tracking registry CLI.
- **`gh`** (GitHub CLI), authenticated — used to create the product's repos.

> The installed-from-pin pattern is the same one the live fleet uses: e.g. the
> `scenarios` CLI is installed from a VCS pin, not editable from a clone
> (ADR-018, "Migration"). Install your CLIs the same way — from their published
> package or a `git+https://…@<tag>` pin — never `pip install -e <clone>`.

---

## Step 1 — Scaffold the lead shop  *(produces: an empty, self-contained lead repo)*

```bash
shop-templates bootstrap \
  --shop-type lead \
  --shop-name <product>-product \
  --target <dir>
```

This pours a fresh lead repo at `<dir>` with:

- **Empty product-document directories.** `briefs/`, `adr/`, `pdr/`, and
  `features/` carry **no** content from any other product — the only inheritance
  is skills + templates + installed tools.
  > **Note (lead-ii9q):** in a freshly-bootstrapped product these directories are
  > **absent** (not present-and-empty). That is expected — they appear as you
  > author the first brief/PDR/scenario. Do not assume they pre-exist.
- **Its own `bd` registry** — its own issue-prefix and its own `<product>-beads`
  companion remote (not another product's).
- **Self-contained role templates + skills** — `.claude/agents/`
  (`lead-po`, `lead-architect`) poured inline, plus the lead skill-group.
- **Product-scoped `ops/`**, rendered through the `<product>` slug:
  - `compose.yaml` with services `<product>-postgres` and `<product>-agent-vault`
    on docker network `<product>`, at host ports distinct from any other product,
    and a product-scoped data volume;
  - `bin/shop-shell` — broker-wired (reaches Claude and github.com through the
    product's own broker, with **no** host `~/.claude` / `~/.gitconfig` mounts);
  - `bin/agent-vault-provision` and `bin/agent-vault-check` (Step 5 / health).

Because `ops/` is rendered through your slug, a second product's scaffold
contains **zero** other-product literals — it will not collide with anything
already running on the host.

> **Known limitation (lead-2ra5):** the rendered shell `Dockerfile`'s `FROM` line
> is currently namespaced to the framework author's registry. It does not block
> bring-up; mentioned here only so it is not a surprise.

---

## Step 2 — Set the instance secret  *(produces: the product's `.env`)*

```bash
cd <dir>
cp .env.example .env
# edit .env: set AGENT_VAULT_MASTER_PASSWORD to this product's own value, e.g.
#   openssl rand -base64 32
```

`.env` is **gitignored — never commit it.** `AGENT_VAULT_MASTER_PASSWORD` is the
broker master password that auto-unlocks this product's encrypted vault on
restart; it is distinct from any other product's. This is instance config the
lead owns, not code.

---

## Step 3 — Bring up the supporting services  *(produces: postgres + broker running)*

```bash
docker compose up -d            # brings up <product>-postgres + <product>-agent-vault
```

This starts `<product>-postgres` and `<product>-agent-vault` on the `<product>`
docker network at this product's distinct host ports — the two supporting
services every BC depends on before it can do useful work. Because the network,
ports, and data volume are all product-scoped, these come up **alongside** any
other product already running on the host with no collision.

In the iter-5 run these bound, for example, host ports **5714** (postgres),
**14730** (broker API), and **15287** (broker proxy) — your rendered ports come
from the `<product>` slug; read them from your `compose.yaml` / `.env`.

> **Verify before proceeding:** `bin/agent-vault-check` confirms the broker is
> reachable and provisioned, so a credential-substitution failure surfaces here
> rather than mid-work. (After Step 5 it will report fully provisioned.)

---

## Step 4 — Declare the product identity and its BCs  *(produces: `bc-manifest.yaml`)*

Create `bc-manifest.yaml` at the repo root (committed instance config the lead
owns). It declares the product identity once and lists each BC:

```yaml
# bc-manifest.yaml
product: <product>            # the single declared identity (ADR-038); the fleet
                              # tooling derives slug / network / BC-name-shape /
                              # image namespace from this.
bcs:
  - name: <bc>
    remote: https://github.com/<your-org>/<bc>
    role: bc
```

Create the BC's GitHub repos with `gh` (the BC repo plus a private
`<bc>-beads` companion) before launching, the same way the fleet's BCs are
backed by their own repos.

> The `product:` field is load-bearing: it is what makes a message addressed to
> your BC project under your `<product>` slug (`<product>/<bc>`) rather than under
> the framework's slug. Without it you risk a silent cross-product address
> collision (this is exactly the iter-6 → iter-7 fix).

---

## Step 5 — Provision the broker  ←  **THE ONE HUMAN GATE**  *(produces: a provisioned vault + a minted fleet token)*

This is the **single manual credential step, once per product.** Run the
provision script, supplying your real credentials through environment variables;
it wires the broker services, **creates a Claude-OAuth proposal**, and then
**pauses for you to approve that proposal**.

```bash
export AGENT_VAULT_OWNER_PASSWORD='<your-choice>'   # the provision/owner login at
                                                    # the broker (first registrant
                                                    # becomes instance owner)
export GITHUB_USERNAME='<your-github-login>'        # v0.9.0 names (see NOTE below)
export GITHUB_TOKEN='<your-real-github-PAT>'
bin/agent-vault-provision
```

`bin/agent-vault-provision` runs the scripted credential flow against the live
broker — register the owner, create the `<product>` vault, store the GitHub
credential, add the `github-git` / `github-api` / `claude-*` services, mint the
`<product>-fleet` agent token (an `av_agt_…` value written into `.env` as
`AGENT_VAULT_TOKEN`), and fetch the broker root CA into `agent-vault-ca.pem`. It
then **creates a pre-populated OAuth-typed `CLAUDE_OAUTH` credential-slot
proposal** and **pauses** at the one human gate.

### The one human approval — approve the Claude-OAuth proposal

On agent-vault 0.32.0 the refreshing Claude-OAuth credential **is** scriptable
via the structured credential-slot proposal path
([ADR-026](adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
D2/D4) — there is **no dashboard hand-create**. The provision script creates the
proposal for you (it already carries `token_url` + `client_id`); your role drops
to **approving** it and supplying the real token **at approve time**. While the
script waits at its prompt:

1. The script prints the proposal number (e.g. `#1`) and the exact approve
   command. Run it in a second terminal, supplying your genuine Claude-OAuth
   `accessToken` (the one secret the tooling cannot supply for you):

   ```bash
   agent-vault vault proposal approve <number> CLAUDE_OAUTH=<accessToken> --yes --vault '<product>'
   ```

   - The credential key **must** be `CLAUDE_OAUTH` — SCREAMING_SNAKE_CASE.
     Kebab-case (`claude-oauth`) is rejected. This rule is **not** shown in
     `--help`; it only surfaces at the live broker.
   - Because the broker enforces **vault scope** on `proposal create` /
     `proposal approve`, these commands run in *agent mode* — they need a
     vault-scoped session (`AGENT_VAULT_TOKEN` from `agent-vault vault token
     --vault <product>`) plus `AGENT_VAULT_ADDR` and `AGENT_VAULT_VAULT`. The
     rendered `bin/agent-vault-provision` is responsible for establishing that
     scoped session before it creates the proposal; if you approve by hand from
     a fresh shell, mint the scoped session token first.
2. Return to the script's terminal and press **ENTER**. The script then verifies
   `CLAUDE_OAUTH` landed (`agent-vault vault credential list --vault <product>`
   shows the key) before declaring provisioning complete.

After this approval the broker holds your real GitHub credential **and** the
refreshing Claude-OAuth credential (oauth-typed, carrying `token_url` so the
broker auto-refreshes it thereafter), and `.env` carries the minted
`<product>-fleet` token + broker addr + CA path. **No real credential ever enters
a BC container** from here on — the broker substitutes them on outbound requests.

> **NOTE — env-var naming drifts by provision version.** This guide documents the
> **v0.9.0** provision, which reads `GITHUB_USERNAME` / `GITHUB_TOKEN`. Earlier
> v0.8.0 used `GITHUB_PAT` / `GITHUB_PAT_USER` (see iter-5). **Check your rendered
> `bin/agent-vault-provision` for the exact env-var names it reads** before
> exporting, and use those.

> **GOTCHA — `AGENT_VAULT_VAULT` is the PLAIN vault name (lead-9qz5).** The
> fleet-agent **grant** is `<slug>:proxy` (that is correct for the agent token).
> But where the broker proxy's `HTTPS_PROXY` userinfo needs `AGENT_VAULT_VAULT`,
> that value must be the **plain** vault name — `<product>`, **not**
> `<product>:proxy`. Using the `:proxy` form there makes the brokered clone
> **404**. Set it to `<product>`.

---

## Step 6 — Launch the BC and dispatch one scenario  *(produces: a real feature, reconciled)*

### 6a. Launch the BC

With the broker provisioned and healthy, launch the declared BC. The launcher
does **not** auto-derive the network / broker / DSN from `bc-manifest.yaml`'s
`product:` field — those are explicit flags you pass at launch:

```bash
bc-container launch <bc> \
  --image ghcr.io/dstengle/shopsystem-bc-base:v0.3.1 \
  --network <product> \
  --repo-url https://github.com/<your-org>/<bc> \
  --shopmsg-dsn postgresql://<product>:<product>@<product>-postgres:5432/<product> \
  --agent-vault-broker http://<product>-agent-vault:14322 \
  --env-file .env
```

The BC comes up **brokered** — cloned through the product's own broker (no host
credential mount), attached to the `<product>` network, and gated on both
supporting services being reachable. The `--shopmsg-dsn` points the BC at the
product's own postgres **by container name on the `<product>` network** (the
published host port is for host-side tools, not in-network clients). The
`--env-file .env` supplies the broker coordinates (`AGENT_VAULT_ADDR` /
`AGENT_VAULT_TOKEN` / `AGENT_VAULT_VAULT` / `AGENT_VAULT_CA_PEM`) that Step 5
wrote. The BC then registers at `<product>/<bc>` (verifiable via `shop-msg
registry list` — it will show `<product>/<bc>`, **not** `shopsystem/<bc>`).

> **IMAGE — pin `:v0.3.1` (or newer), NOT `:latest`.** The slug-projection that
> makes a fresh BC register at `<product>/<bc>` without an in-container messaging
> upgrade requires **shopsystem-messaging ≥ 0.4.0**, which bc-base **v0.3.1**
> bakes. The floating `:latest` tag can lag (it has pointed at a v0.2.x image
> baking messaging 0.2.1, which predates slug projection and would force an
> in-container pip upgrade). Pin the explicit `v0.3.1` reference shown above.

> **NOTE — verify the exact launch flags against your rendered tooling.** Run
> `bc-container launch --help` to confirm the flag set your installed launcher
> expects; the launcher default `--image`
> (`ghcr.io/dstengle/shopsystem-bc-base:latest`) is the framework author's
> registry and may lag the version you need — pass `--image …:v0.3.1` explicitly.

### 6b. The §6.4 loop — assign → build → reconcile

1. In the new lead shop, **`lead-po` authors one scenario** — a real, buildable
   behavior in plain Gherkin (Given / When / Then), not a plumbing echo.
2. **`lead-architect` dispatches it** to the BC via `assign_scenarios` (the
   architect computes the scenario hash and tags it at dispatch).
3. The BC runs its implementer → reviewer loop and emits **`work_done`** carrying
   `scenario_hashes`.
4. **The lead reconciles** — confirms the scenario register landed and the hashes
   match (assigned == work_done == independent recompute).

When that cycle closes for a genuinely implemented feature under your `<product>`
slug, the second product is **working**: a real feature implemented in a BC,
running self-contained in docker on its own isolated substrate. In the iter-7 run
this was a trivial `greeter` feature (`greeter Ada` → exactly `Hello, Ada!`),
built red → green inside the BC, with a clean three-way hash match.

---

## Troubleshooting / known gotchas

These were live-discovered while standing up the example product — documented so
you do not rediscover them.

- **Brokered clone 404s → check `AGENT_VAULT_VAULT` (lead-9qz5).** The agent
  **grant** is `<slug>:proxy`, but the `HTTPS_PROXY` userinfo vault name
  (`AGENT_VAULT_VAULT`) must be the **plain** `<product>` — not `<product>:proxy`.
  The `:proxy` form there 404s the brokered clone.

- **`proposal create` / `proposal approve` require VAULT SCOPE.** On agent-vault
  0.32.0 the OAuth-proposal verbs run in *agent mode* and refuse an owner/admin
  session with `Error: Session requires vault scope` — even though `vault create`
  / `credential set` / `service add` accept that same owner session. Provide a
  **vault-scoped session token** (`agent-vault vault token --vault <product>`,
  an `av_sess_…` value) as `AGENT_VAULT_TOKEN`, together with `AGENT_VAULT_ADDR`
  (the in-container `http://localhost:14321`) and `AGENT_VAULT_VAULT=<product>`,
  for the `proposal create` and `proposal approve` calls. The rendered
  `bin/agent-vault-provision` must mint and use this scoped session around the
  proposal step (tracked separately if your rendered script misses it).

- **Credential casing is SCREAMING_SNAKE.** The Claude credential **must** be
  named `CLAUDE_OAUTH`; kebab `claude-oauth` is rejected. The same rule applies
  to other credential keys (e.g. the GitHub keys). The rule is **not discoverable
  from `--help`** — it surfaces only at the live broker.

- **Pin the bc-base image to `:v0.3.1`, not `:latest`.** Slug projection
  (`<product>/<bc>` addressing without an in-container messaging upgrade) needs
  shopsystem-messaging ≥ 0.4.0, which bc-base **v0.3.1** bakes; the floating
  `:latest` tag can lag at a v0.2.x image (messaging 0.2.1, pre-slug-projection).

- **Provision env-var names differ by version.** v0.9.0 reads
  `GITHUB_USERNAME` / `GITHUB_TOKEN`; v0.8.0 read `GITHUB_PAT` /
  `GITHUB_PAT_USER`. Always check the env-var names your rendered
  `bin/agent-vault-provision` actually reads.

- **Provision is idempotent on re-run.** `auth register` / `vault create` take
  the idempotent path against an already-owned broker, so re-running provision
  (e.g. to replace a dummy PAT with your real one) cleanly re-stores and pauses
  again at the Claude-OAuth prompt.

- **`briefs/adr/pdr/features` are absent, not empty, after bootstrap
  (lead-ii9q).** They appear as you author content; do not assume they pre-exist.

- **Rendered shell `Dockerfile` `FROM` is author-namespaced (lead-2ra5).** A
  known limitation, not a bring-up blocker.

---

## Where the authority lives

- **Bootstrap narrative (authoritative):** [`briefs/011-new-product-bootstrap-path.md`](briefs/011-new-product-bootstrap-path.md).
- **No BC source on the lead host; brokered, contract-surface verification:**
  [ADR-018](adr/018-empirical-verification-is-contract-surface.md).
- **The brokered-credential model + the one human paste:**
  [ADR-026](adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md).
- **Proven end-to-end command transcripts:**
  [`findings/dummyco-spike-iter-5.md`](findings/dummyco-spike-iter-5.md)
  (provision → human gate) and
  [`findings/dummyco-spike-iter-7.md`](findings/dummyco-spike-iter-7.md)
  (BC launch → §6.4 loop → MVP gate cleared).
