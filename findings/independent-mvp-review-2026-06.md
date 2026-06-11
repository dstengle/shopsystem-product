# Findings from the independent MVP review (2026-06-11)

**Status:** stable artifact. Consolidates an outside review of the
shopsystem at its declared MVP gate, commissioned by the stakeholder
before first use of the framework for a second product. Unlike the
prototype findings docs, no slice run produced this — the method was
four parallel read-only review passes (skills/templates, messaging
CLIs, bootstrap/launcher, docs corpus) plus a direct read of the
spec (§1–§6), the primers, the live fleet state, and the bead
backlog. Test suites were executed (shopsystem-messaging: 152
passed; shopsystem-scenarios: 14 passed).

The review lens, fixed by the stakeholder: *for a new product the
briefs/, adr/, pdr/, and features/ directories start empty; what
must carry over is the skills, templates, and tools — while this
repo's documentation describes how the system will behave for that
new product.* Every finding below is read against that lens.

This document only carries claims that are **load-bearing for the
path to a second product**. The one-line verdict: the architecture
and decision discipline are validated strengths, but the system is
a working *instance*, not yet a working *framework* — every
reviewed subsystem carries at least one hard-coded
`shopsystem`/`dstengle` assumption, and no document walks an
adopter from empty directory to working lead shop.

---

## 1. The architecture and decision corpus are validated strengths

**Claim.** The spec (§1–§6) is internally coherent and normative
without overreach; the ADR/PDR corpus exhibits exemplary decision
traceability; the messaging core faithfully implements its
decisions; the role templates are high-craft and drift-free against
the installed canonical package.

**Evidence.**
- Full read of §1–§6 found no internal contradictions. Role splits
  (PO/Architect, Implementer/Reviewer) carry consistently across
  §3–§5; §1.9 correctly scopes what the principles do not say.
- Supersession chains are clean: ADR-025 over ADR-023 D2/D3,
  ADR-027 amending-not-superseding ADR-009. ADRs pin parent PDRs,
  anchor to intent beads, and name the surfaces requiring revision.
  ADR-018's self-demonstrating empirical-verification section
  (lines 135–157) is a model for the corpus.
- The bd-first three-step send protocol in
  `shop_msg/bd_facade.py` matches ADR-012 exactly. Scenario-hash
  validation is enforced at the schema layer via `@model_validator`
  (`catalog/schemas.py:98–124`) with a cross-package integration
  test pinning agreement with `scenarios hash` — what §5.6 demands.
  §5.7 self-containment holds for every implemented schema. The
  ADR-020 abstract-address migration is complete and path-free.
- `.claude/agents/lead-po.md` and `lead-architect.md` are
  byte-identical to the installed `shop_templates` package copies.
  Their anti-rationalization sections and mechanically checkable
  sufficiency checks are load-bearing, not cosmetic.
- The ADR-026/028 credential model is implemented and proven (the
  fleet flip to brokered v0.2.6 is in git history); bc-base uses
  immutable VCS pins per ADR-021/022 as decided.

**Caveat.** These strengths are validated for N=1 product. None of
them have been exercised by a second instantiation (finding 2).

**Implication.** No spec change. Treat the §1–§6 + ADR + messaging
foundation as a starting condition, the way prototype findings 1–3
were treated by mechanism-observation-v1.

---

## 2. The framework only knows one product: identity constants are baked in at every layer

**Claim.** A second product cannot be stood up on the current
artifacts without code changes. The product identity ("shopsystem",
the `dstengle` org) is a hard-coded constant, not a parameter, in
the messaging layer, the launcher, the manifest, the images, and
the lead-side skills.

**Evidence.**
- `SYSTEM_SLUG = "shopsystem"` at
  `repos/shopsystem-messaging/src/shop_msg/storage.py:222` governs
  `_abstract_address_for()`. A BC registered for a different
  product still projects to `shopsystem/<name>`; routing fails
  **silently** — messages deposit to addresses the receiving shop
  never reads. This single constant defeats the ADR-020 abstract
  addressing investment for any second product.
- bc-launcher's `BC_IMAGE` is a module constant
  (`controller.py:32`, `ghcr.io/dstengle/shopsystem-bc-base:latest`)
  with no override surface; `bin/shop-shell` at least exposes
  `SHOPSYSTEM_SHELL_IMAGE`.
- `bc-manifest.yaml` remotes, `Dockerfile.shopsystem-shell` pins,
  and INSTALL.md step 1 are all `dstengle/`-scoped.
- The `bring-up-bc` skill hard-codes `/home/dstengle` (line 45),
  the author-scoped image (line 19), and the `shopsystem` database
  name (lines 16, 30–31, 52).
- bc-launcher's network resolution reads a `product:` key from
  `bc-manifest.yaml` and falls back to hard-coded `"shopsystem"` —
  but ADR-005 never defines the field and the live manifest does
  not carry it. The exact mechanism a new product needs is
  implemented, undocumented, and unused.

**Caveat.** Each constant is individually a small diff. The finding
is about their distribution (five layers, four repos), not their
depth.

**Implication.** Externalize three identities before any second
product: `SYSTEM_SLUG` (env var in the `SHOPMSG_DSN` pattern, or
derived from the registered lead's system name), `BC_IMAGE`
(env/manifest-driven), and the manifest `product:` field (document
in an ADR-005 successor, populate the live manifest). Re-template
`bring-up-bc` on the same pass.

---

## 3. No end-to-end new-product bootstrap path exists

**Claim.** Starting from nothing, the steps to create a new
product's lead shop and first BC are documented nowhere; the
documents that exist address other audiences and partially
contradict standing doctrine.

**Evidence.**
- INSTALL.md is written for an internal contributor adding a BC to
  *this* product, and instructs `pip install -e repos/<bc-name>`
  (lines 113–115) — directly contrary to ADR-018/PDR-011 doctrine.
- `consumer-wiring.md` covers framework *package* wiring, not
  product *structure*; it never resolves whether a second-product
  adopter clones BCs editable per INSTALL.md or installs published
  pins per ADR-018.
- Brief 007 (adopter-facing docs BC) correctly names this gap and
  is undelivered. Brief 008 Slice 1 (lead-container bootstrap via
  `shop-templates bootstrap --shop-type lead`) has no empirical
  proof pinned in `features/`; `Dockerfile.shopsystem-shell` is an
  unpublished local prototype.
- Undocumented prerequisites: the `shopsystem` network is
  `external: true` in `compose.yaml` (line 74), so first
  `compose up` fails until `docker network create` is run by hand —
  stated only as a precondition inside the bring-up-bc skill;
  bc-launcher must be hand-cloned before `bc-container manifest
  sync` can clone anything else (prime-the-pump step absent).
- There is no "what to keep / what to empty / what to run"
  checklist distinguishing this repo's product content (briefs,
  ADRs, PDRs, features — shopsystem's own record) from the
  framework chassis an adopter inherits.

**Caveat.** The intended fix is already decided (Brief 007 + Brief
008 Slice 1); this finding is about sequencing — both are
undelivered while the MVP label is applied.

**Implication.** Deliver Brief 007 as the checklist above; rewrite
INSTALL.md to stop contradicting ADR-018; pin Slice 1's lead
bootstrap empirically before relying on it.

---

## 4. The §6.4 reconciliation loop is not executable as specified

**Claim.** The spec's central conformance promise — Principle 5's
bidirectional conformance, operationalized as §6.4 reconciliation —
cannot be run through the typed channel, because the two message
types it depends on are unimplemented and three load-bearing
artifact schemas remain deferred. §5.3's catalogue has drifted in
both directions.

**Evidence.**
- §5.3 declares `request_scenario_register` (the §6.4 step-1 pull)
  and `request_shop_card`; neither has a schema class in
  `catalog/schemas.py` nor a CLI subcommand. Prototype-1 findings
  §6 recorded both as closed-as-deferred; the spec never absorbed
  the deferral.
- §5.3 omits `nudge` — implemented, ADR-015-decided, and used by
  the lead primer's standing rules. The messaging README claims
  "eight inter-shop message types" while listing six and
  implementing seven.
- §3.3/§4.3 defer the shop card, scenario register, and Domain &
  Context Map schemas to "a future prototype." In practice
  reconciliation runs off `work_done` payload hashes against
  lead-held scenarios — workable, but not what §6.4 describes.

**Caveat.** The de facto `work_done`-driven reconciliation has been
exercised and works; the gap is spec honesty, not a broken loop.

**Implication for spec.** Either implement the two types or amend
§5.3/§6.4 to describe the push-based mechanism actually in use and
mark the pull-based register as deferred — and add `nudge` to the
catalogue table. A self-hosting framework can tolerate missing
features; it cannot tolerate a spec describing a different system.

---

## 5. The hardest-won operational IP has not propagated to the canonical templates

**Claim.** The local `.claude/canonical/lead-primer.md` has outrun
the installed canonical `lead.md`: the PRIME DIRECTIVE,
choice-suppression rules, idle-detection checklist, Monitor-arming
protocol, and session-start drain exist only in this shop's copy. A
freshly bootstrapped product receives a primer without the very
sections that make the router act autonomously.

**Evidence.**
- Diff of `.claude/canonical/lead-primer.md` against
  `.venv/.../shop_templates/templates/claude/lead.md` (~210 lines):
  the canonical copy lacks all of the above sections.
- ADR-018 names the canonical primer among four surfaces requiring
  revision, with propagation via `request_bugfix` to the templates
  BC; no work-summary entry or bead tracks that revision as
  shipped.
- Related: the role templates cite §3.2/§3.4/§6 of the spec. Those
  files exist in *this* repo as shopsystem product content — a new
  product's lead repo will not have them, so every new product's
  role templates cite a void. The framework spec needs to ship with
  the templates package (or resolve to a published URL).

**Caveat.** The local/canonical split itself is correctly designed
and operationally honored (PDR-003 path F; shop-local primer is
properly shop-owned). The defect is one-way pour-back, not the
split.

**Implication.** Pour the operational sections back into the
canonical template, parameterized; ship or link the spec with the
package; track the ADR-018 canonical-primer revision as an explicit
bead rather than an implied consequence.

---

## 6. ADR-018's no-clones doctrine is contradicted by the lead host's own visible state, with no operational discriminator

**Claim.** ADR-018/PDR-011 assert "no `repos/` directory on the
lead host"; three BC checkouts are physically present, and nothing
outside the ADR itself marks the difference between
"doctrine-in-effect, migration-pending" and "non-compliant setup."

**Evidence.**
- `/repos/` holds shopsystem-messaging, shopsystem-scenarios,
  shopsystem-bc-launcher. `.gitignore` excludes it with a comment,
  and ADR-018's migration section gates removal on lead-bootstrap
  tooling — but that temporal exception lives only inside the ADR.
- INSTALL.md actively builds the forbidden state (finding 3), so an
  adopter produces it with no warning. Both the sanctioned interim
  state and the violating state look identical to an operator: a
  `repos/` directory with editable installs.

**Caveat.** The primers (`.claude/shop/primer.md`) are correctly
updated and consistent with the doctrine; the contradiction is
between the ADR and the install docs/working tree, not within the
agent-facing guidance.

**Implication.** When the flagship principle is "design is
authoritative" (§1.6), the flagship ADR being visibly contradicted
by the lead repo's own state is a method-credibility defect, not a
hygiene nit. Add the dev-mode-exception note wherever `repos/` is
visible, and define the migration's done-condition as a checkable
state.

---

## 7. Installed-package version skew is a latent landmine

**Claim.** The lead `pyproject.toml` pins framework packages at
v0.2.x while the venv actually runs editable installs of `repos/`
checkouts whose own pyprojects declare v0.1.0. The first clean,
non-editable install will fetch different code than everything
validated to date.

**Evidence.** `pyproject.toml:12–16` (scenarios@v0.2.0,
shopsystem-messaging@v0.2.1, shopsystem-bc-launcher@v0.2.0) vs.
`repos/*/pyproject.toml` at v0.1.0; `pip list` shows editable
installs winning silently. Bead `lead-xq0` records the symptom
(venv drift after BC work lands) but not the version-skew
dimension.

**Caveat.** Harmless on this host today; it bites exactly when a
second product or CI does a clean install — i.e., at the moment the
MVP label implies.

**Implication.** Align repos/ versions with the pins (or vice
versa) and make tag-matching part of the BC release discipline.

---

## 8. Skills corpus: orphans, gaps, and missing graduation criteria

**Claim.** The skill set has one orphaned high-value asset, one
missing skill for a core architect activity, and no stated
graduation path from experimental to canonical.

**Evidence.**
- `drafts/skills/test-driven-development/` is complete and
  well-written but unregistered, undiscoverable, and BC-flavored
  (cites `clarify` and assigned scenarios) — it belongs in BC role
  templates, where nothing currently delivers it.
- No skill operationalizes reconciliation, the architect's most
  procedural activity (§3.2, lead-architect.md lines 106–112).
- `bring-up-bc` is marked EXPERIMENTAL while being essential to
  fleet operations; `.claude/skills/README.md:8` tracks the pour
  (`lead-di16`/`lead-tgs4`) but names no graduation criteria.
- Strengths worth keeping: all five PM skills share a consistent
  structure with sufficiency checks, and each explicitly names the
  framework-as-product vs. consumer-product fork — the right
  structural move for a self-hosting system, though the fork
  examples are shopsystem-specific and need generalizing.

**Caveat.** The skills are lead-side experimental by declared
intent; this finding is about the absence of the path out of
"experimental," not the label itself.

**Implication.** Define graduation criteria; graduate or kill the
TDD draft (target: BC role templates); author the reconciliation
skill from the §6.4 procedure once finding 4 settles which
mechanism is normative.

---

## 9. Operational and security loose ends below the architecture line

**Claim.** The credential architecture is sound (finding 1), but a
handful of operational defaults around it would embarrass a second
deployment.

**Evidence.**
- `compose.yaml:26–28` ships `POSTGRES_PASSWORD: postgres`;
  `.env.example` covers the vault master password but is silent on
  postgres.
- `bin/shop-shell:70–71` still bind-mounts host `~/.claude` and
  `~/.gitconfig` into the lead shell — acknowledged open in ADR-028
  but inconsistent with the zero-host-coupling goal BCs already
  meet.
- No documented rotation/revocation runbook for the `av_agt_…`
  proxy token; the provision script has no re-mint subcommand.
- `shop-msg watch` does not survive a Postgres LISTEN drop (known:
  `lead-tsj`); postgres has no compose health check while
  agent-vault does.

**Caveat.** All acceptable for a single-host dev MVP; none
acceptable in a doc that tells an adopter this is how their product
will run.

**Implication.** Fold these into the Brief 007 runbook rather than
fixing piecemeal: password guidance, network create, provisioning
sequence, token rotation, restart behavior.

---

## 10. Self-hosting has a predictable blind spot, and the MVP gate is unchecked

**Claim.** The system's self-correction loop demonstrably works for
*instance* defects but cannot see *genericity* defects; and "MVP"
is currently a judgment, not a checked state.

**Evidence.**
- A majority of this review's operational findings were already
  self-reported beads (`lead-rcjf`, `lead-2id`, `lead-tsj`,
  `lead-xq0`, `lead-zmi`, `lead-i8u`, `lead-3nf7`) — the
  `mechanism_observation` channel and backlog triage are doing
  their job.
- None of the genericity findings (SYSTEM_SLUG, the missing
  instantiation path, the spec'd-but-unimplemented reconciliation
  pull, version skew, canonical-primer thinness) had beads. The
  instance never exercises the framework's genericity, so
  genericity defects never emit an observation.
- The backlog carries 10 P1s and ~60 ready issues at the moment the
  MVP label is applied, and no artifact defines what the MVP gate
  requires — in a system whose ethos is empirical verification.

**Caveat.** This is the expected failure mode of any self-hosting
system, not a process lapse; outside review exists precisely to
supply the missing pressure.

**Implication.** See the recommendation below: make the second
product itself the gate.

---

## 11. Recommendations, prioritized

1. **Make "instantiate a second product" the MVP acceptance test.**
   Stand up a trivial dummy product (one BC) end-to-end and let
   every failure become a bead. This empirically surfaces findings
   2–3 and validates their fixes using the system's own
   methodology. Nothing below is done until this run completes
   clean. (Same shape as prototype-1 §7's "real product BC"
   recommendation — applied to the framework's genericity instead
   of its mechanism.)
2. **Externalize the three identity constants** (finding 2):
   `SYSTEM_SLUG`, `BC_IMAGE`, manifest `product:`. Small diffs,
   outsized unblocking.
3. **Pour the operational primer sections back into the canonical
   template and ship the spec with the templates package**
   (finding 5).
4. **Resolve §5.3 honestly** (finding 4): add `nudge`; implement or
   formally defer `request_scenario_register`/`request_shop_card`;
   re-describe §6.4 around the mechanism actually in use.
5. **Deliver Brief 007 as the keep/empty/run checklist** and
   de-contradict INSTALL.md against ADR-018 (findings 3, 6, 9).
6. **Housekeeping with real payoff** (findings 7, 8): align version
   pins; graduate or kill the TDD draft; define skill graduation
   criteria; add `Tier:` headers to ADRs (ADR-034/035 intent,
   currently not machine-readable); write the MVP gate as a
   checklist and burn the P1s against it.

---

## 12. How to use this document

- Take finding 1 as starting conditions — the foundation is
  validated and does not need re-litigating.
- Findings 2–5 are the load-bearing gaps between "works as
  shopsystem" and "works as a framework"; they are the input to the
  recommendation-1 dummy-product run, which should be scoped as a
  spike or prototype in the existing lineage (this corpus's
  spike-lifecycle machinery fits it naturally).
- Findings 6–9 convert directly into beads; several extend beads
  that already exist and are cross-referenced inline.
- Finding 10 is a standing posture note: schedule outside review
  (or a fresh-eyes dispatch with the new-product lens) at each
  future gate, because the self-hosting loop structurally cannot
  produce these findings itself.
