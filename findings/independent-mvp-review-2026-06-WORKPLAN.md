# Work plan — independent MVP review (2026-06-11)

Decomposition of [independent-mvp-review-2026-06.md](independent-mvp-review-2026-06.md)
into tracked work, routed to owning surfaces and message-type vehicles.
Finding 1 is a *starting condition* (validated foundation — no work). The
remaining findings split into ten work-streams under one epic.

## Organizing principle (review recommendation #1 — the gate)

**Stand up a trivial dummy product (one BC) end-to-end. That run IS the
MVP acceptance test.** It empirically surfaces and validates findings 2–3
using the system's own methodology; nothing is "done" until it runs clean.
This is a **spike/prototype in the existing lineage** (the review's
explicit framing), and it is the spine: WS-1 and WS-2 are *discovered and
proven* by it, not planned in the abstract.

Phasing:
- **Phase A (the gate):** WS-0 spike → drive WS-1 (identity constants) and
  WS-2 (bootstrap path) as the spike hits each wall. Each failure becomes a
  bead and a fix, validated by re-running the spike.
- **Phase B (spec/IP honesty, parallel):** WS-3 (§5.3/§6.4), WS-4 (primer
  pour-back + ship spec), WS-5 (no-clones doctrine). Independent of the spike;
  PO/architect authoring.
- **Phase C (housekeeping with payoff):** WS-6 (version skew), WS-7 (skills),
  WS-8 (ops/security → folded into Brief 007), WS-9 (MVP gate checklist).

## Work-streams

Legend — **Owner**: surface/BC that holds the fix. **Vehicle**: how the lead
dispatches it (assign_scenarios / request_bugfix / request_maintenance /
spec-edit / ADR / lead-local doc). **Author**: which judgment role drafts
intent first.

### WS-0 — Dummy-product instantiation spike *(the gate)* — finding 10/rec-1
- **Work:** stand up a trivial second product (distinct system slug + org, one
  BC) from empty briefs/adr/pdr/features, using only skills+templates+tools.
  Record every wall as a bead. Re-run to validate each fix.
- **Owner:** lead-shop spike (this repo, spike lineage). **Vehicle:** spike/PDR.
  **Author:** lead-po scopes the spike PDR; architect verifies the gate.
- **Deps:** none — it is the driver. **Priority:** P0.

### WS-1 — Externalize the three identity constants — finding 2 / rec-2
1. **`SYSTEM_SLUG`** (silent cross-product routing failure) → **shopsystem-messaging**, `request_bugfix`. Derive from registered lead's system name or env in the `SHOPMSG_DSN` pattern; not a module constant. *Highest-leverage — defeats ADR-020 for any 2nd product.*
2. **`BC_IMAGE` override surface** → **shopsystem-bc-launcher**, `request_bugfix`. Env/manifest-driven (mirror `SHOPSYSTEM_SHELL_IMAGE`).
3. **manifest `product:` field** → **shopsystem-bc-launcher** + **ADR-005 successor** (architect ADR). The mechanism is implemented-but-undocumented-and-unused; define the field, populate the live manifest.
4. **Re-template `bring-up-bc`** (remove `/home/dstengle`, author-scoped image, `shopsystem` db name) → **shopsystem-templates**, `request_bugfix`.
- **Author:** architect (vehicles + ADR-005 successor). **Deps:** surfaced by WS-0. **Priority:** P1.

### WS-2 — New-product bootstrap path — finding 3 / rec-5
1. **Brief 007** (adopter-facing *keep / empty / run* checklist; absorbs WS-8 runbook) → **lead-po** authors; deliver via the docs/adoption surface. *Undelivered; brief exists.*
2. **Rewrite INSTALL.md** to stop contradicting ADR-018/PDR-011 (drop `pip install -e repos/<bc>` as the adopter path) → lead-local doc edit.
3. **Brief 008 Slice 1** (lead bootstrap via `shop-templates bootstrap --shop-type lead`) — pin empirical proof in `features/`; publish `Dockerfile.shopsystem-shell` beyond local prototype → **lead-po** scenario + dispatch.
4. **Document prerequisites:** `docker network create shopsystem` (compose net is `external: true`); bc-launcher prime-the-pump clone before `manifest sync`.
- **Author:** lead-po (brief + scenarios). **Deps:** validated by WS-0. **Priority:** P1.

### WS-3 — §5.3/§6.4 reconciliation spec honesty — finding 4 / rec-4
1. **Add `nudge` to the §5.3 catalogue table** (implemented, ADR-015-decided, omitted) → spec-edit (`05-inter-shop-protocol.md`) + fix messaging README count ("eight" vs six-listed/seven-implemented).
2. **`request_scenario_register` + `request_shop_card`:** decide implement vs formally defer → architect decision; if defer, amend §5.3/§6.4 + record in messaging. If implement → **shopsystem-messaging** assign_scenarios.
3. **Re-describe §6.4** around the `work_done`-hash reconciliation actually in use; mark pull-based register deferred.
- **Author:** lead-architect (spec/ADR + vehicle). **Deps:** none. **Priority:** P1. *Gates WS-7's reconciliation skill.*

### WS-4 — Propagate operational IP to canonical templates — finding 5 / rec-3
1. **Pour back** PRIME DIRECTIVE / choice-suppression / idle-checklist / Monitor-arming / session-start-drain from local `lead-primer.md` into canonical `lead.md`, parameterized → **shopsystem-templates**, `request_bugfix` (the ADR-018-named revision — **track as an explicit bead**, not implied).
2. **Ship/link the framework spec (§1–§6) with the templates package** so new products' role templates don't cite a void → architect decision (framework-tier per ADR-034/035) + templates.
3. **Generalize role-template spec citations** (§3.2/§3.4/§6) to resolve for any product.
- **Author:** lead-architect. **Deps:** none. **Priority:** P1.

### WS-5 — ADR-018 no-clones doctrine vs visible state — finding 6
- Add dev-mode-exception note wherever `repos/` is visible (`.gitignore`, INSTALL.md, working-tree); **define the migration's done-condition as a checkable state** → architect ADR-018 amendment + lead-local doc notes.
- **Author:** lead-architect. **Deps:** pairs with WS-2 INSTALL rewrite. **Priority:** P2.

### WS-6 — Installed-package version skew + release discipline — finding 7
- Align `repos/` pyproject versions with the lead pins (or vice versa); make **tag-matching part of BC release discipline**. Extends **lead-xq0** (adds the version-skew dimension).
- **Author:** architect (release-discipline decision) + per-BC maintenance. **Deps:** none. **Priority:** P2.

### WS-7 — Skills corpus: graduation + gaps — finding 8 / rec-6
1. **Define graduation criteria** (experimental → canonical) → lead-local skills/README + architect.
2. **Graduate or kill the TDD draft** (`drafts/skills/test-driven-development/`) — target: **BC role templates** (it's BC-flavored) → templates.
3. **Author the reconciliation skill** (architect's most procedural activity, §3.2) → **gated on WS-3** settling which mechanism is normative.
4. **Graduate `bring-up-bc`** (EXPERIMENTAL but essential) — extends **lead-3nf7**.
5. Generalize PM-skill framework-vs-consumer fork examples (currently shopsystem-specific) — touches **lead-di16**/**lead-tgs4**.
- **Author:** lead-architect / lead-po. **Deps:** WS-3 for #3. **Priority:** P2.

### WS-8 — Operational/security loose ends — finding 9 (fold into Brief 007 runbook, WS-2)
- `compose.yaml` postgres password guidance (`.env.example` silent on it); remove `bin/shop-shell` host `~/.claude`/`~/.gitconfig` bind-mounts (ADR-028 open, BCs already meet zero-host-coupling); **token rotation/revocation runbook** + `agent-vault-provision` re-mint subcommand; `shop-msg watch` LISTEN-drop resilience (**lead-tsj**, closed — reopen scope?); postgres compose healthcheck.
- **Author:** lead-po (runbook) + targeted fixes. **Deps:** WS-2. **Priority:** P2.

### WS-9 — MVP gate definition + standing review posture — finding 10 / rec-6
- **Write the MVP gate as a checklist** (currently a judgment, not a checked state) and **burn the 10 P1s against it**; add machine-readable `Tier:` headers to ADRs (ADR-034/035 intent). Standing posture: schedule outside review / fresh-eyes new-product-lens dispatch at each future gate.
- **Author:** lead-architect. **Deps:** WS-0 defines "clean." **Priority:** P2.

## Cross-linked existing beads (review §10 — already self-reported)
lead-rcjf (P2, no consume-inbox), lead-xq0 (P2, venv drift → WS-6), lead-zmi
(P3, shop-msg PATH), lead-i8u (P3, bootstrap not idempotent on .beads/ → WS-2),
lead-tsj (closed, LISTEN drop → WS-8), lead-3nf7 (bring-up → WS-7), lead-di16 /
lead-tgs4 (PM skills → WS-7).

## Decisions requiring judgment (route before dispatch)
- **WS-3.2:** implement vs formally defer the two pull-based message types — *architect*, possibly user (scope of the conformance promise).
- **WS-4.2:** how the framework spec ships with templates (vendored copy vs published URL) — *architect* (framework-tier, ADR-034/035).
- **WS-0 scope:** what "trivial dummy product" includes (the spike PDR boundary) — *PO*, likely user (product vocabulary).
- **MVP gate contents (WS-9):** what the checklist must assert — *user + architect*.
