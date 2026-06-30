# ADR-043 — Every derived bootstrap coordinate is computed ONCE at a canonical point and re-used; nothing recomputes or hardcodes it

**Status:** accepted (ratified by dave, 2026-06-26, lead-kc0k); D2 artifact
shape/path FINALIZED 2026-06-28 (lead-7wta) and RECONCILED-TO-IMPLEMENTATION
2026-06-29 (lead-7wta) against the now-shipped pinning scenarios 211/213/228 —
see "D2 — FINALIZED" below (`bin/ops-coordinates`, a rendered shell-sourceable
env-file; a derived single-source **managed-render** artifact that
`shop-templates update` OWNS — refreshed, NOT advisory-on-drift).
**Tier:** system-global (cross-BC / per-product structural decision about how the
adopter bootstrap derives identity, coordinates, ports, names, and org — it
touches the `shop-templates bootstrap` render surface (cli.py), the rendered ops
artifacts (compose.yaml + the `bin/` ops scripts), and the footing runway; not
framework-doctrine §1–6 and not one BC's internals.)
**Authors:** dstengle (intent — the 2026-06-26 product-authority directive on
lead-kc0k: "We keep getting hit with hardcoded values … any value like this
should be determined at a single point and re-used"), Claude (lead-architect).
**Anchored to:**
[ADR-038](038-manifest-product-field-is-the-canonical-product-identity-source.md)
(the manifest `product:` field is THE canonical declared product identity — this
ADR makes every derived coordinate flow from it),
[ADR-040](040-adopter-footing-is-a-deterministic-agentless-bootstrap-distinct-from-agent-driven-discovery.md)
(the footing runway this governs),
[ADR-018](018-empirical-verification-is-contract-surface.md) (the audit below is
artifact-surface only).
**Related beads:** `lead-kc0k` (this audit/directive — parent), `lead-yh0s` (the
`PRODUCT` vs `OPS_SLUG` dual-source consolidation — a specific instance this ADR
generalizes), `lead-yudo` (footing delegates credential provisioning to
`bin/agent-vault-provision` — removes the ops-script duplication class), plus the
whole v0.30–0.35 bug run this ADR is the durable fix for: `lead-h2rq`/`lead-4sg9`
(vault create), `lead-pdsd`/`lead-0j60` (PAT store), `lead-21uk` (proposal #),
`lead-nhr2` (host port + sync.remote org/name).

---

## Context

Across the v0.30.0–v0.35.0 adopter-bootstrap bug run, nearly every defect was a
**duplicated-derivation** failure: a value that should have ONE source was
recomputed (or hardcoded) in a second place, and the two diverged. Concretely
this run produced: the GitHub org hardcoded `dstengle` in N places vs derived
from origin in one; `:14321` (the container port) assumed where the **generated
host port** was needed; the beads repo named `-product-beads` in cli.py vs
`-lead-beads` in footing; and the product slug derived as `{{OPS_SLUG}}` at render
time vs `${REPO_NAME%-lead}` at runtime. Each was patched at one site; the next
site re-broke. The product authority's directive names the root: **single source
of truth.**

### Empirical audit (artifact surface, ADR-018 D1/D2 — templates HEAD `36236ff` = v0.35.0)

Verified via proxy-authed `gh` over the 7 templates source files; counts are
literal occurrences, classified into **live duplication** vs **legitimately-fixed
or comment**. (A "legit-exempt" value is one with a single correct source — e.g.
the in-network *container* port 14321, or the product-neutral framework image
reference — that is NOT a per-product duplication.)

**Class F — product IDENTITY derivation (THE ROOT).** Two parallel regimes that
must coincide but are computed independently:
- **Render-time:** `{{OPS_SLUG}}` injected by `shop-templates bootstrap` — 24
  occurrences in `compose.yaml`, plus the cli.py rendering machinery.
- **Runtime:** `PRODUCT="${REPO_NAME%-lead}"` (footing L86, from the fork dir
  basename); the manifest `product:` field footing writes (L88).
  → These coincide ONLY by construction (the fork is `<slug>-lead` and
  `OPS_SLUG=slug`). ADR-038 already names the manifest `product:` as canonical,
  but nothing forces the render-time and runtime derivations to flow from it.
  This is the generator behind Classes A/B/E.

**Class A — GitHub org `dstengle`.** `cli.py` L776 LIVE
(`return f"git+https://github.com/dstengle/{shop_name}-beads.git"` — the sync.remote
bug lead-nhr2 patches at runtime in footing, but cli.py still RENDERS the wrong
org); L769/772/782 are docstring/comment. `shop-shell` L106/108/121 are
`ghcr.io/dstengle/shopsystem-bc-lead:latest` — the **product-neutral framework
image reference** (scenario-172 exempt; NOT a per-product literal). So the live
org-duplication is cli.py's beads-remote render, which must derive from the same
origin owner footing derives (lead-pdsd I2 / lead-nhr2), not a hardcoded default.

**Class B — broker ports 14321/14322.** `compose.yaml` is the canonical source:
the CONTAINER ports are fixed 14321/14322 (correct, single source), and the HOST
ports are the generated `{{OPS_VAULT_API_PORT}} = 14321 + crc32(slug)%1000` /
`{{OPS_VAULT_PROXY_PORT}}` (L65-88). The live bug is HOST-context code that assumes
the container port: `agent-vault-approve-claude` L91
(`-e AGENT_VAULT_ADDR=http://localhost:14321`) and any host call that does not read
the generated/mapped port. footing L299-308 (lead-nhr2) already models the correct
pattern (`docker port … 14321` → host-reachable addr). The other `:14321`
occurrences are in-network container-port uses (legit single source).

**Class C — host literals `localhost`/`127.0.0.1`.** approve-claude L91
(`http://localhost:14321` — couples Class B); compose L94 healthcheck
`127.0.0.1` (in-container, legit). footing L307 records `http://localhost:<mapped>`
(the lead-nhr2 fix). The defect subset is the approve-claude host literal.

**Class D — postgres coordinates.** `compose.yaml` is canonical: `POSTGRES_USER:
{{OPS_SLUG}}` (L39), `POSTGRES_DB: {{OPS_SLUG}}` (L41), host port
`{{OPS_POSTGRES_PORT}} = 5432 + crc32(slug)%1000` (L47), container 5432. cli.py
(6 occurrences) renders DSN/coords — must reference the same single source, not
re-spell `5432`/creds independently.

**Class E — beads-repo NAME forms.** `cli.py` `_product_beads_remote` builds
`{shop_name}-beads` (= `<slug>-product-beads`) at L776; footing forces
`$PRODUCT-lead-beads` (L467/491/513) and `$PRODUCT-<bc>-beads`. lead-nhr2 fixes
the *runtime* sync.remote, but cli.py still *renders* the divergent name. One
canonical naming rule (`<product>-lead-beads`, `<product>-<bc>-beads`) must be
the single source both render and runtime use.

**What is NOT a duplication (do not "fix"):** the in-network container ports
(14321/14322/5432), the product-neutral framework image references
(`shopsystem-bc-lead`/`-bc-base`, scenario-172 exempt), and the compose-rendered
`{{OPS_*}}` tokens that ALREADY are the single generated source. The defect is
every place that RE-DERIVES or HARDCODES a value the canonical source already
holds.

---

## Decision

### D1 — The manifest `product:` field (ADR-038) is the single identity root; every coordinate derives from it

At footing time the manifest `product:` field is written once (ADR-038) and is
THE product identity. Every product coordinate — slug, network name, container
names (`<product>-postgres`, `<product>-agent-vault`), vault name, beads repo
names, the org (from origin), and the generated ports — is computed from that one
declared identity (plus origin owner for the org, plus the generated-port rule),
and re-used. `PRODUCT="${REPO_NAME%-lead}"` and the render-time `{{OPS_SLUG}}`
both reconcile TO the manifest `product:` rather than being independent
derivations (closes lead-yh0s).

### D2 — A single rendered "ops coordinates" source the scripts SOURCE, rather than each script re-deriving

`shop-templates bootstrap` renders ONE canonical coordinates artifact (e.g. an
`ops/coordinates` env-file or a `[product]` block of the manifest) carrying the
derived coordinates — slug, container names, vault name, the generated host ports,
the beads repo names, the org placeholder — and every `bin/` ops script
(`footing`, `agent-vault-provision`, `agent-vault-check`,
`agent-vault-approve-claude`, `shop-shell`) **sources that one file** instead of
re-spelling `{{OPS_SLUG}}` / `14321` / `dstengle` / `-beads` independently. A value
appears as a literal in exactly ONE place (the renderer / the coordinates file);
everywhere else is a variable reference.

#### D2 — FINALIZED (2026-06-28, lead-7wta): the artifact is `bin/ops-coordinates`, a rendered shell-sourceable env-file

D2 above deliberately left the artifact's concrete shape/path OPEN ("an
`ops/coordinates` env-file OR a `[product]` block of the manifest"). The
keystone of the on-disk single-source initiative — shop-shell, the `bin/`
provision scripts, AND bc-launcher network resolution all consume this one
artifact — so the shape is now ratified.

**RECONCILED-TO-IMPLEMENTATION (2026-06-29, lead-7wta).** The 2026-06-28
finalization below is now confirmed against the shop-templates scenarios that
SHIPPED and reconciled this session — the implemented reality, on the
contract/artifact surface (ADR-018 D1/D2), is:

- **Scenario 211** (`@scenario_hash:0a3a8267109b5792`,
  `features/templates/211-*.gherkin`) — `shop-templates bootstrap` renders the
  single shell-sourceable `bin/ops-coordinates` `KEY=value` env-file, derived
  from the manifest `product:` root, carrying the slug-NEUTRAL OPS_* keys each
  placeholder-safe env-overridable. This pins the FORMAT, PATH, KEYS, and the
  **slug contract** (`_ops_slug` strips a trailing `-product`, so shop name
  `shopsystem-product` → slug `shopsystem`) and the placeholder-safe
  `OPS_BC_BEADS_REPO_FMT="<slug>-{bc}-beads"` with the literal `{bc}` intact,
  plus `OPS_FRAMEWORK_IMAGE` resolving non-empty.
- **Scenario 213** (`@scenario_hash:4c646ae20a1540e3`,
  `features/templates/213-*.gherkin`) — `shop-templates update` against an
  existing repo lacking `bin/ops-coordinates` RENDERS it (create-if-absent),
  byte-equal to the bootstrap render.
- **Scenario 228** (`@scenario_hash:8e5955d5fb5bb9c8`,
  `features/templates/228-*.gherkin`) — `shop-templates update` against a repo
  whose `bin/ops-coordinates` has DRIFTED REFRESHES it in place, overwriting
  the stale body byte-equal to the current canonical bootstrap render.

All three hashes reproduce under the installed `scenarios hash` contract tool
over the lead-held block-only Gherkin (verified 2026-06-29). **The one place
the implemented reality DIVERGES from the 2026-06-28 prediction below is the
`update` behavior:** the prediction said `update` does NOT overwrite the
artifact (advisory-on-drift only, mirroring compose.yaml under scenarios
139/140). The shipped contract chose the OPPOSITE and stronger guarantee:
`bin/ops-coordinates` is a derived single-source **managed-render** artifact
whose ONLY customization path is environment override, so `update` OWNS its
refresh — create-if-absent (213) AND refresh-drifted-in-place (228) — exactly
as it re-pours the managed agent files (scenarios 35/36) and the managed lead
skill group (162-164), and explicitly does NOT apply the shop-owned
drift-advisory contract (139/140) used for `compose.yaml` and `bin/shop-shell`.
The text below is corrected to record this. The artifact SHAPE itself
(env-file, `bin/ops-coordinates`, the OPS_* key set, the slug contract) is
unchanged from the 2026-06-28 finalization and is confirmed by 211.

**FORMAT — a rendered, directly shell-sourceable env-file (`KEY=value` lines).**
Chosen over the manifest-`[product]`-block alternative. The decisive constraint
is the consumer mechanism the PO-authored scenarios already pin: scenarios 204
(`@scenario_hash:b7ea0de32ef49854`), 205 (`@scenario_hash:1885dea2b4550fde`),
and the bc-launcher network scenario 63 (`@scenario_hash:5a1fc25a7823b268`) all
require each `bin/` script to obtain its coordinates by a shell `source `/`. `
directive. A YAML `[product]` block is NOT shell-sourceable — `source` of YAML
fails; consuming it would force every `bin/` script (and bc-launcher) to carry a
YAML parser. A `KEY=value` env-file `source`s natively in bash. This is the lean
ADR-046's Open-dependency section already recorded; D2 now ratifies it.

**PATH — `bin/ops-coordinates`** (a sibling of the `bin/` ops scripts). Chosen
over `ops/coordinates`. The scripts source it as `source
"$(dirname "$0")/ops-coordinates"` (the form scenarios 204/205 authored against
— a sibling of `bin/shop-shell`); `$(dirname "$0")` already resolves to `bin/`,
so a sibling needs no path math and no new top-level `ops/` directory. The
existing ops-scaffolding set is `bin/`-rooted (the six-file set scenario 174
enumerates: compose.yaml + the `bin/` scripts), and `bin/ops-coordinates` joins
it as one more `bin/`-rooted ops file written by bootstrap. (NOTE — unlike the
hand-editable shop-owned ops scripts of scenarios 136/137/139, the shipped
contract makes `bin/ops-coordinates` a derived managed-render artifact that
`update` re-pours; see the DERIVATION paragraph and the RECONCILED note above —
scenarios 213/228.)

**CONTENT / KEYS — the env-file exports stable, slug-NEUTRAL `OPS_*` keys** (so
every script references `$OPS_*` regardless of slug; only the VALUES carry the
product identity). Each line honors the ADR-038 D3 precedence inline
(`OPS_X="${<OVERRIDE_ENV>:-<rendered-default>}"`) so an explicit environment
assignment still takes precedence over the rendered default — satisfying the
"environment-overridable" leg of scenarios 204/205. The key set, reconciled with
D1's coordinate list + ADR-046's framework image + the values
shop-shell / the `bin/` scripts / bc-launcher actually consume (live values for
slug `shopsystem` shown):

- `OPS_SLUG` — product slug (`shopsystem`); the ADR-038 `product:` derivation
  root. The slug contract (scenario 211) is `_ops_slug`, which strips a trailing
  `-product` from the shop name (so `shopsystem-product` → `shopsystem`).
- `OPS_NETWORK` — docker network name (`shopsystem`); consumed by shop-shell's
  outer `--network` AND inner `bc-container launch --network`, and by
  bc-launcher's `_resolve_shop_network()` (lead-ngzl, today reading
  compose.yaml/name.md as the INTERIM — switches to this artifact, see
  Consequences).
- `OPS_POSTGRES_CONTAINER` — `shopsystem-postgres`.
- `OPS_VAULT_CONTAINER` — `shopsystem-agent-vault`.
- `OPS_VAULT_NAME` — the agent-vault credential store name.
- `OPS_BROKER_ADDR` — in-network broker address (`http://agent-vault:14321`);
  the host-mapped form is runtime-discovered (see DERIVATION).
- `OPS_POSTGRES_PORT` — generated host port (`5829` = `5432 + crc32(slug)%1000`),
  inline default over `SHOPSYSTEM_POSTGRES_PORT`.
- `OPS_VAULT_API_PORT` / `OPS_VAULT_PROXY_PORT` — generated host ports
  (`15082` / `14462`), inline defaults over `SHOPSYSTEM_VAULT_*_PORT`.
- `OPS_DATA_ROOT` — persistent data root (`$HOME/.local/share/shopsystem`),
  inline default over `SHOPSYSTEM_DATA`; shop-shell's env-file path derives from it.
- `OPS_LEAD_BEADS_REPO` — `shopsystem-lead-beads`;
  `OPS_BC_BEADS_REPO_FMT` — `shopsystem-{bc}-beads` (the D5 naming rule). Per
  scenario 211 this key is rendered in a PLACEHOLDER-SAFE form (outside the
  `${:-}` default, or with the brace escaped) so that the literal `{bc}`
  placeholder survives sourcing intact while the key remains env-overridable —
  the prior naive `"${OPS_BC_BEADS_REPO_FMT:-<slug>-{bc}-beads}"` corrupted the
  value because bash closes the expansion on the first `}`.
- `OPS_ORG` — GitHub org/owner, DERIVED FROM `git remote get-url origin` ONCE
  (D4, lead-pdsd I2); rendered as an origin-derived placeholder footing fills.
- `OPS_FRAMEWORK_IMAGE` — `ghcr.io/dstengle/shopsystem-bc-lead:latest` (ADR-046:
  the framework launcher/leaf image joins the coordinate set, overriding
  ADR-028's product-neutral-image exemption for `bin/shop-shell`).

**DERIVATION + WHO RENDERS.** The artifact is DERIVED at bootstrap from the
manifest `product:` root (D1 / ADR-038): `shop-templates bootstrap` (cli.py
render tokens) writes `bin/ops-coordinates` ONCE, alongside compose.yaml and the
other `bin/` ops scripts, with the render-time-derivable values substituted from
`product:`. The two genuinely runtime-only coordinates — `OPS_ORG` (the actual
origin owner) and the host-MAPPED broker/postgres addresses — are filled ONCE by
the footing runtime in the fork (ADR-040 runway; per D6 / lead-nhr2's
`docker port … 14321` discovery), written into the SAME artifact, never
re-derived downstream. Because `bin/ops-coordinates` is a DERIVED
single-source managed-render artifact (its only customization path is
environment override, not hand-editing), `shop-templates update` OWNS its
refresh: it renders the artifact create-if-absent (scenario 213,
`@scenario_hash:4c646ae20a1540e3`) and refreshes a drifted artifact in place
byte-equal to the current canonical bootstrap render (scenario 228,
`@scenario_hash:8e5955d5fb5bb9c8`) — re-pouring it as it does the managed agent
files (35/36) and the managed lead skill group (162-164), and explicitly NOT
applying the shop-owned drift-advisory contract (139/140) used for
`compose.yaml`/`bin/shop-shell`. (The footing-filled runtime-only coordinates —
`OPS_ORG` and the host-MAPPED addresses — are an environment-override layer over
the rendered defaults, consistent with that managed render.) A value appears as a
literal in exactly ONE place — this artifact — and every `bin/` script plus
bc-launcher carries only `$OPS_*` references.

### D3 — The generated-port rule lives in ONE place

`<host_port> = <container_port> + crc32(slug) % 1000` (and the
`<SLUG_UPPER>_*_PORT` overrides) is already centralized in `compose.yaml`'s render
tokens. D2's coordinates artifact carries the RESOLVED host ports (or footing
discovers them via `docker port` once, per lead-nhr2, and records them), so no
host-context script ever re-assumes `:14321`.

### D4 — The org is derived from origin once (not hardcoded)

The GitHub org/owner is parsed from `git remote get-url origin` ONCE (lead-pdsd
I2) and recorded in the coordinates source; cli.py's beads-remote render stops
emitting a hardcoded `dstengle` and instead leaves an origin-derived placeholder
the footing runtime fills (or footing rewrites it, as lead-nhr2 does for
sync.remote). The product-neutral framework image references stay as-is (exempt).

### D5 — One canonical beads-naming rule

`<product>-lead-beads` (lead) and `<product>-<bc>-beads` (per BC) is the single
naming rule, sourced from the coordinates artifact; cli.py's render and footing's
runtime both use it — eliminating the `-product-beads` vs `-lead-beads` split.

### D6 — Where it cannot be single-sourced, it is DERIVED, never re-spelled

Any value that genuinely cannot be pre-rendered (e.g. a runtime-discovered mapped
port) is derived ONCE at the earliest point that can compute it and recorded for
re-use, never independently recomputed downstream.

---

## Consequences

- **lead-yudo (footing-delegates-to-provision) composes with this and is
  amplified:** delegating credential provisioning to `bin/agent-vault-provision`
  removes the largest ops-script duplication surface (footing stops re-deriving
  vault/credential coordinates provision already holds). The two should be
  sequenced together.
- **lead-yh0s is subsumed:** the PRODUCT-vs-OPS_SLUG dual-source is the Class-F
  instance D1 closes; lead-yh0s becomes the first concrete slice.
- This is **expensive to reverse** once the coordinates-source contract ships and
  adopters fork it — hence ADR-tier. The product authority ratifies the
  principle + the canonical mechanism (D2's coordinates artifact).

---

## Alternatives considered

- **Patch each hardcode in place (status quo).** Rejected — that is exactly what
  the v0.30–0.35 run did; every patch re-broke at the next un-patched site. Does
  not address the generator (Class F).
- **Push all derivation into cli.py render tokens only.** Rejected — footing runs
  at runtime in the fork with information cli.py render time does not have (the
  actual origin owner, the actual mapped host port), so a render-only single
  source cannot cover the runtime-derived coordinates. The coordinates artifact
  (D2) bridges render-time and runtime under one contract.
