# BC work-loop single-source: the two-projection generation mechanism (design)

**Bead:** lead-xinb (P1, IN_PROGRESS) · **Author:** lead-architect · **Date:** 2026-07-06
**Status:** design recommendation — DESIGN ONLY, no dispatch. Direction FIXED by
David 2026-07-06 (Option A = generation, two hard constraints). This artifact is
the mechanism design that honors those constraints, for David review before any
`assign_scenarios` / `request_bugfix` dispatch.
**Discipline:** every claim below is grounded in the artifact/tool surface per
ADR-018 D1/D2 — this repo's `features/`, `adr/`/`pdr/`, `findings/fabro-spike/`,
and the installed `shop-templates` / `bc-container` CLI `--help` surface. No BC
source read, run, or git-observed (the lead host carries none).

---

## 0. The problem, restated from the pins (not re-litigated)

The fabro loop def carries its OWN node-body copies of the six BC role prompts
(bc-implementer / bc-reviewer / bc-review / bc-router / bc-sufficiency-check /
work-done-gate) AND the five vendored skills (test-driven-development /
subagent-driven-development / using-git-worktrees / writing-plans-bdd /
integrating-to-main) — the SAME content `shopsystem-templates` owns for the tmux
`.claude/` path. Confirmed against `findings/fabro-spike/fabro-defs/nodes/` (11
node-body files) and its `README.md` node-id→furniture map. The fabro bodies are
a **dialect translation**, not a textual dupe: `findings/fabro-spike/fabro-defs/
nodes/bc-implementer.md` shows the translation rules explicitly (Skill-tool
invocation → prose INLINED into the node `prompt=`; `Task`/subagent fan-out →
`parallel=true`; `model: inherit` → `class="coding"`). No mechanical diff keeps
two such homes in sync — that is the drift this bead closes.

**Why it exists (settled, from ADR-050/051):** the fabro *engage tier* replaces
the tmux/claude engage with a headless `fabro run workflow.fabro` run-graph
(ADR-050 D3). Engage is a launch concern, so bc-launcher owns it — CORRECT for
the graph TOPOLOGY/mechanism. The conflation is that the def bundle also swept in
the role-prompt + skill CONTENT.

---

## 1. Pre-state, verified empirically (ADR-018 D1/D2)

### 1a. How the `.claude` pour works today — the model to mirror

Two poured surfaces, one binary:

- **bc-base bakes the `shop-templates` BINARY** from a VCS version pin, alongside
  the other framework CLIs — scenario `ccb145d71c7100a2`
  (`bc_base_shop_templates_pin.feature`): *"installs shop-templates from a
  github.com/dstengle/shopsystem-templates @ vMAJOR.MINOR.PATCH version pin …
  NOT from an editable clone."*
- **`bc-container launch` runs the pour INSIDE the container workspace after
  clone** — scenario `75ae95be0ecf1640` (`bc_container_shop_templates_pour.feature`):
  *"After cloning … bc-container launch runs a shop-templates 'pour' inside the
  container's workspace directory, populating the workspace's '.claude/skills/'
  … as an explicit launch step after the clone."*
- **`--workspace-mount` SKIPS the pour** — `bc-container launch --help`: a
  workspace-mount launch *"SKIPS the clone and ALL clone-path provisioning (no bd
  bootstrap, no shop-templates re-pour), presenting the host tree unchanged (its
  committed .beads registry and poured .claude/skills are left byte-unchanged)."*

So the load-bearing property that makes `.claude` **NOT require an image
rebuild to change**: the *binary* is baked; the *content* is package data the
binary emits at pour time into `/workspace`. Change a role prompt or skill →
release a new `shop-templates` → the next launch pours the new content. No
bc-base rebuild. `.claude/` is committed in a lead repo (verified: `git ls-files
.claude/` returns the tracked tree here) and, for a workspace-mount launch, used
byte-unchanged — i.e. a repo MAY commit its poured `.claude` and mount it.

This is EXACTLY the mechanism the target mirrors for `.fabro/`.

### 1b. How the fabro def is delivered today — what David rejects

The def is delivered the OLD way: a 15-file bundle owned by bc-launcher at
`src/bc_launcher/assets/fabro-def/`, **baked into the bc-base image**, launch-wired
to `/workspace/.fabro/`. Pinned by `2dfefe2ba81e418d`
(`bc_container_fabro_def_validates.feature`): *"the self-contained fabro loop def
bundle that lead-h2bj delivered under src/bc_launcher/assets/fabro-def/ … pins the
def's VALIDITY as an ADR-051 Implementer→Reviewer loop that `fabro validate`
accepts."* The scenario Given/When binds the def to *"the pinned bc-base image"* /
*"present in that running container."* This baked-bundle delivery is what
constraint (2) rejects.

### 1c. What `fabro validate` needs — self-containment is a DIR property, not a bake property

`2dfefe2ba81e418d` requires the def be *"a self-contained bc-shop
Implementer→Reviewer loop graph … the graph file is present, every node body the
graph references is present in the def alongside it so the loop is runnable from
the def alone."* Read against `findings/fabro-spike/fabro-defs/` (workflow.fabro +
nodes/*.md + workflow.toml + project.toml + vaults/default): **self-containment is
a property of the def DIRECTORY at RUN time — every `prompt_file` body sits
alongside `workflow.fabro`.** It is ORTHOGONAL to whether that directory arrived
by bake or by pour. A def GENERATED into `/workspace/.fabro/` at pour time — before
`fabro run` — is equally self-contained and equally `fabro validate`-green at run
time. So the target PRESERVES self-containment; only the *delivery premise* in the
pin's wording ("on the pinned bc-base image") must change.

### 1d. Runtime binary vs workflow content — the clean seam

Separable and already separated in the pins:

- **RUNTIME binaries (baked, stay baked):** fabro v0.254.0 + anthropic-oauth-shim —
  scenario `a3512aedb8763150` (`bc_base_fabro_and_oauth_shim.feature`). These are
  executables, correctly baked in bc-base; constraint (1)/(2) are about *workflow
  content*, not runtime binaries. Confirmed STAYS.
- **WORKFLOW content (baked today, must be poured):** `workflow.fabro` topology +
  the generated node bodies. This is what moves.

---

## 2. The generation mechanism

### 2.1 Single source → two projections

```
        SINGLE SOURCE  (shopsystem-templates package data — UNCHANGED)
        ├─ role templates: bc-implementer, bc-reviewer  (+ bc-router,
        │    bc-review, bc-sufficiency-check, work-done-gate as role/gate furniture)
        └─ vendored skills: test-driven-development, subagent-driven-development,
             using-git-worktrees, writing-plans-bdd, integrating-to-main
                    │
        shop-templates pour  (the SAME binary, at pour/provision time)
          ├──────────────────────────────┬──────────────────────────────
          ▼                               ▼
   .claude/  (tmux engage)         .fabro/  (fabro engage)   ← NEW projection
   [exists today, unchanged]       ├─ workflow.fabro  (ADR-051 topology skeleton,
                                   │    poured VERBATIM from a static asset)
                                   ├─ workflow.toml / project.toml / vaults/default
                                   │    (poured verbatim; vault = __PLACEHOLDER__ only)
                                   └─ nodes/<piece>.md  (GENERATED from single source
                                        via the dialect-translation rules)
```

- **Canonical source unit:** the EXISTING templates + skills, **unchanged as the
  authoring surface**. The `.claude/` projection continues to pour them as
  `SKILL.md` / agent-template files. The `.fabro/` projection runs them through a
  deterministic **dialect generator** that applies the translation rules already
  catalogued in `findings/fabro-spike/fabro-defs/README.md` §"Standing translation
  rules" (Skill-tool → inlined prose; Task fan-out → `parallel=true`; Monitor →
  command-node drain; model → `class=`). See §5 OQ1 for the one open question
  about whether that generation needs an intermediate representation.
- **Fixed skeleton vs generated content:** the graph TOPOLOGY — 23 nodes / 45
  edges, `emit_r` sole emitter, native-`script=` vs agent node split, fail-closed
  `outcome=failed` edges — is the ADR-051 CONTRACT and is the fixed skeleton. The
  node PROMPT BODIES (the 6 judgment agents `classify, suff, plan, impl, review,
  impl_f`) are the GENERATED content. Per ADR-051 finding 4(a)/(c), the native
  `script=` nodes carry LITERAL command text and NO role-prompt content, so **only
  the agent-node bodies are single-source-derived**; the native nodes are part of
  the skeleton.

### 2.2 Where the topology skeleton lives — RECOMMENDATION: move it to templates

**Recommend: the ADR-051 topology skeleton (`workflow.fabro` + `workflow.toml` +
`project.toml` + `vaults/default` scaffold) moves from bc-launcher's baked
`src/bc_launcher/assets/fabro-def/` into `shopsystem-templates` as a STATIC
package-data asset, poured verbatim; the node bodies are generated by the pour.
ADR-051 remains the governing contract; a templates-side scenario pins that the
poured skeleton still conforms to it.**

Reasoning:

1. **Self-containment forces single ownership of the emitted unit.**
   `2dfefe2ba81e418d` requires the def be runnable from the def alone — skeleton
   AND bodies present together. If templates generated the bodies but bc-launcher
   still owned/baked the skeleton, the pour would have to reach into a
   bc-launcher-baked skeleton and inject bodies — that re-introduces a two-home
   coupling at pour time and re-bakes half the def, defeating constraint (2).
   ONE home for the whole emitted def = templates.
2. **ADR-051 is a CONTRACT, not a storage location.** The invariants (`emit_r`
   sole gated emitter, fail-closed edges, native-node state-change enforcement)
   constrain the skeleton wherever it lives. Co-locating the skeleton asset in
   templates does not weaken ADR-051; a new templates scenario pins conformance
   (see N3). ADR-051's own retirement-enumeration was EMPTY (finding 6: no
   `features/` scenario pins fabro loop-graph behavior), so nothing in ADR-051 is
   re-decided by relocating the asset.
3. **The skeleton is a static ARTIFACT, not launch LOGIC.** The fabro-substrate
   KNOWLEDGE (native `script=`, `[run.environment.env]` overlay, v0.254.0 quirks)
   is encoded once in a static `.fabro` file; the launch LOGIC that consumes it
   (start the ephemeral fabro server, wire the oauth-shim, `fabro run
   workflow.fabro`) stays bc-launcher. Moving the static asset does not move the
   logic.
4. **Change-frequency asymmetry is fine.** The skeleton changes only on an
   ADR-051 substrate-mechanism revision (rare); the bodies change whenever a role
   prompt or skill changes (frequent). Both as templates package data — skeleton
   near-static, bodies generated — is coherent with how templates already ships
   near-static `settings.json` next to frequently-edited role templates.

### 2.3 When / where generation runs

- **Clone-launch path (primary):** `bc-container launch` runs the `shop-templates`
  pour after clone — the SAME explicit launch step that pins `.claude/skills`
  today (`75ae95be0ecf1640`) — now ALSO emitting `/workspace/.fabro/` (skeleton
  poured verbatim + `nodes/` generated). Mirrors the `.claude` mechanism exactly.
- **`--workspace-mount` path:** pour SKIPPED (per `launch --help`); the committed
  `/workspace/.fabro/` is used byte-unchanged, exactly as committed `.claude/skills`
  is today. A repo MAY commit its poured `.fabro/` and mount it.
- **Lead bootstrap path:** `shop-templates bootstrap --shop-type lead` does NOT
  emit `.fabro/` — the fabro engage is a BC-container concern only; a lead shop is
  not a launched container and never runs the fabro loop. `.fabro/` generation is
  scoped to the launch/container pour path.
- **Determinism / no-drift:** the generator MUST be deterministic — identical
  single source ⇒ **byte-identical** `.fabro/`. This is the property that makes the
  `--workspace-mount` committed def provably equal to a fresh pour (no silent
  drift) and is the direct analogue of the progressive-disclosure single-source
  precedent (`findings/progressive-disclosure/08-recommendation.md` §"Single
  source, no drift": *"identical source → byte-identical … named projections"*)
  and the ADR-019 scenarios single-source doctrine (one canonical text, identical
  on every surface). Pin this explicitly (N2).

---

## 3. Ownership map

| Piece | Today | Target owner | Later discriminator (DO NOT dispatch) |
|---|---|---|---|
| Single source: role templates + vendored skills + BC role/gate prompts | shopsystem-templates | **UNCHANGED — templates** | n/a |
| `.claude/` projection (bootstrap + launch pour) | templates binary; launch step `75ae95be0ecf1640` | **UNCHANGED** | n/a |
| `.fabro/` node-body GENERATION (dialect translation from single source) | bc-launcher, hand-maintained in baked bundle | **MOVE → templates** | net-new templates capability → `assign_scenarios` |
| ADR-051 topology skeleton (`workflow.fabro`/`.toml`/`project.toml`/vault scaffold) | bc-launcher asset, baked into bc-base | **MOVE → templates static asset**; ADR-051 stays governing contract | net-new templates asset + conformance pin → `assign_scenarios` |
| Launch/engage wiring (`fabro server start --foreground --no-web`; `fabro run workflow.fabro -I …`) | bc-launcher | **UNCHANGED bc-launcher** — same mechanism, new source location (poured `/workspace/.fabro/`, not baked) | flat re-anchor of the def-location premise in a pinned scenario → `request_bugfix` |
| Launch pour STEP now also emits `/workspace/.fabro/` | bc-launcher bakes def instead | **bc-launcher launch step** invokes the extended pour; deletes `src/bc_launcher/assets/fabro-def/` | net-new launch pour coverage → `assign_scenarios` (parallel to `75ae95be0ecf1640`) |
| fabro binary v0.254.0 + anthropic-oauth-shim bake | bc-launcher / bc-base (`a3512aedb8763150`) | **UNCHANGED — stays baked** (runtime, not workflow content) | none — confirm only |
| `shop-templates` binary bake | bc-launcher / bc-base (`ccb145d71c7100a2`) | **UNCHANGED** (binary now additionally emits `.fabro/`) | none — the new emit capability is templates-side, not a bc-base change |

---

## 4. Pins to change / add

**@scenario_hash enumeration** (per the message-type sufficiency check, run against
the lead-held `features/` in this repo — `grep -r "@scenario_hash" features/`):
the fabro-affected pins are the four in `features/shopsystem-bc-launcher/`, plus
the two `.claude`/binary pour pins referenced for parity. Enumerated below with the
exact change and vehicle. (No dispatch here — this is the pre-computed conflict set
the eventual dispatches must carry.)

### REOPEN (pinned scenario — resolving the drift REQUIRES reopening)

- **`2dfefe2ba81e418d`** (`bc_container_fabro_def_validates.feature`, @origin
  adr-051) — the load-bearing reopen. Today: *"the def bundle lead-h2bj delivered
  under src/bc_launcher/assets/fabro-def/ … present in that running container on
  the pinned bc-base image."* Change: the DELIVERY premise moves from
  **baked-bundle-on-bc-base** to **pour-generated-into-/workspace/.fabro/ by
  shop-templates at launch.** The VALIDITY assertions — `fabro validate` exit 0 /
  zero diagnostics, ADR-051 graph invariants (`emit_r` sole emitter, fail-closed
  failsafe edges), `__PLACEHOLDER__`-only native vault — all HOLD unchanged. Because
  the def CONTENT is moving to templates, the VALIDITY half of this scenario should
  **re-home to a `shopsystem-templates` scenario** (see N3); the bc-launcher side
  retains only "launch runs the pour that emits `.fabro/`" (see N4). Editing the
  scenario body changes its hash → the PO re-authors; eventual vehicle
  `request_bugfix` (correcting an existing pinned behavior's premise).

### TOUCH (light premise re-anchor — pinned scenarios cross-referencing the def location)

- **`68e14cdcd8b7c145`** (`bc_container_orchestrator_flag_engage_tier.feature`,
  @origin adr-050) — its Given references *"the pinned bc-base image carrying the
  self-contained fabro def at /workspace/.fabro/ (scenario 75,
  @scenario_hash:2dfefe2ba81e418d)."* Re-anchor the clause to "carrying the def
  **poured** into /workspace/.fabro/ at launch." The engage argv (`fabro server
  start --foreground --no-web`, `fabro run workflow.fabro -I BC_NAME=… -I
  WORK_ID=…`), the base_url wiring, the no-tmux-engage assertions, and the
  launch-parity clause all HOLD. Hash changes on the text edit → `request_bugfix`.
- **`8b5a1b9e5499293b`** (`bc_container_fabro_path_oauth_shim_wiring.feature`,
  @origin adr-049) — its Given references *"the self-contained fabro def whose
  native vault holds only '__PLACEHOLDER__' (scenario 75)."* Same light re-anchor of
  the def-location premise. The oauth-shim start + `[llm.providers.anthropic]`
  base_url wiring + placeholder-vault assertions all HOLD (the poured vault scaffold
  is placeholder-only). Hash changes on the text edit → `request_bugfix`.

### CONFIRM STAYS (no change)

- **`a3512aedb8763150`** + companion **`4fc67c610cba6227`**
  (`bc_base_fabro_and_oauth_shim.feature`) — bake of fabro binary v0.254.0 +
  oauth-shim + the centralized-poll enrollment. RUNTIME binaries, correctly baked;
  David's constraint separates runtime binary (baked, fine) from workflow content
  (poured). STAYS unchanged.
- **`ccb145d71c7100a2`** (`bc_base_shop_templates_pin.feature`) — bc-base bakes the
  `shop-templates` binary from a VCS pin. STAYS; the binary simply gains the
  `.fabro/`-emit capability (a templates release, not a bc-base change).
- **`75ae95be0ecf1640`** (`bc_container_shop_templates_pour.feature`) — the
  `.claude/skills` launch-pour pin. Leave INTACT; add the `.fabro/` emit as a NEW
  parallel scenario (N4) rather than editing the `.claude` pin.

### NEW pins the target needs

- **N1 (templates):** `shop-templates` pour emits the `.fabro/` projection —
  skeleton asset poured verbatim + `nodes/` bodies generated from the single-source
  role/skill content — alongside `.claude/`. → `assign_scenarios`.
- **N2 (templates):** the generated `.fabro/` def is DETERMINISTIC — identical
  single source ⇒ byte-identical `.fabro/` (the no-drift / commit-equals-repour
  property; cites the progressive-disclosure byte-identical precedent + ADR-019).
  → `assign_scenarios`.
- **N3 (templates):** the generated `.fabro/` def passes `fabro validate` (exit 0,
  zero diagnostics) AND conforms to ADR-051 (`emit_r` sole gated emitter,
  fail-closed edges, placeholder-only vault) — the VALIDITY assertions migrated from
  `2dfefe2ba81e418d`, now owned where the generation lives. Fidelity: runs the REAL
  fabro binary, as `2dfefe2ba81e418d` LEG 1 does. → `assign_scenarios`.
- **N4 (bc-launcher):** `bc-container launch` runs the pour that emits
  `/workspace/.fabro/` (parallel to `75ae95be0ecf1640` for `.claude`);
  `--workspace-mount` skips it and uses the committed `.fabro/` byte-unchanged; the
  baked `src/bc_launcher/assets/fabro-def/` bundle is retired. → `assign_scenarios`
  (net-new launch pour coverage) + the retirement of the baked bundle.

---

## 5. Cross-links and open questions

**Cross-links (noted, NOT designed here):**
- **DDD review (lead-bh2m):** this IS the "BC work-loop" ubiquitous-language /
  ownership question — who owns "the BC work-loop" as a concept. The ownership map
  (§3) is the concrete resolution for the fabro-vs-tmux projection split; the
  broader ubiquitous-language naming stays in lead-bh2m.
- **Knowledge-context epic (lead-x7bp):** this is an instance of the single-sourcing
  doctrine (guidance/skills as a single-sourced KIND). OQ1 below is where the two
  overlap most directly (whether the single source needs a new structured "kind").

**Open questions:**

- **OQ1 (genuine — needs David; scope/vocabulary):** *Is the Markdown→fabro-DOT
  dialect translation mechanical enough to generate byte-stably from the EXISTING
  role/skill Markdown, or must the single source grow an intermediate/structured
  representation?* The translation rules are catalogued
  (`findings/fabro-spike/fabro-defs/README.md`: Skill-tool→inlined, Task→`parallel=true`,
  Monitor→command-drain, model→`class=`), but they were applied BY HAND in the
  spike. A deterministic generator must encode them. If the existing Markdown is
  insufficiently structured to drive byte-stable generation, the single source may
  need a new structured "kind" — which ties directly into lead-x7bp's
  guidance/skills single-sourcing kind. This is the crux design risk and a genuine
  scope/vocabulary call (what the canonical source UNIT is), not an operational one.
  It may also warrant a BC feasibility `clarify` to shopsystem-templates once
  scoped — but the SCOPE decision (introduce an IR or not) is David's first.
- **OQ2 (lighter — David parity call):** Should the committed-`.fabro/`
  (`--workspace-mount`) path be a first-class supported artifact (repos commit their
  poured `.fabro/`, as `.claude` is committable today), or is `.fabro/` always
  ephemeral/pour-only? Determinism (N2) makes committed==repour safe either way;
  this is a convention choice parallel to how `.claude/skills` is treated.

---

## 6. DRAFT ADR skeleton (pending David review — direction fixed, OQ1 open)

> **DRAFT — do not file until OQ1 is resolved and David signs off.** Reopens the
> pinned scenario `2dfefe2ba81e418d` (delivery premise: baked-into-bc-base →
> pour-generated-into-workspace).

**Title (draft):** The BC work-loop is single-sourced from `shopsystem-templates`
and projected to TWO poured surfaces — `.claude/` (tmux engage) and `.fabro/`
(fabro engage); the fabro def is GENERATED at pour time into `/workspace/.fabro/`,
never baked into bc-base.

- **Anchored on:** ADR-051 (loop-graph contract — governing invariant the poured
  def conforms to), ADR-050 (engage-tier launch parity), ADR-019 (scenarios
  single-source doctrine), ADR-037 (templates ship self-contained role
  content), ADR-018 (artifact-surface verification), PDR-014 (the pour is the
  canonical templates delivery + graduation mechanism).
- **Decision:** (D1) ONE canonical source = templates role prompts + vendored
  skills; (D2) `shop-templates` pour emits BOTH `.claude/` and `.fabro/`
  deterministically (byte-identical to source); (D3) the ADR-051 topology skeleton
  is a templates static asset, node bodies are generated; (D4) fabro binary +
  oauth-shim stay baked (runtime), def content is poured (workflow); (D5)
  bc-launcher retains only launch/engage wiring and the retired baked bundle is
  removed.
- **Reopens:** `2dfefe2ba81e418d` (see §4).
