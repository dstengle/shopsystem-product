---
id: PDR-021
kind: pdr
title: Unify product bringup on the Footing runway; the starter is README + bin/bootstrap; lead↔broker is local-first
status: accepted
date: "2026-06-25"
description: Unify product bringup on the Footing runway; the starter is README + bin/bootstrap; lead↔broker is local-first
beads: [lead-27ka, lead-l7uz, lead-mrn2, lead-rs0i, lead-wdvx]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018, ADR-026, ADR-040, PDR-019]
  pins: []
  related: []
---
# PDR-021 — Unify product bringup on the Footing runway; the starter is README + bin/bootstrap; lead↔broker is local-first

**Status:** accepted (dave, 2026-06-25)

**Operationalizes:** [ADR-040](../adr/040-adopter-footing-is-a-deterministic-agentless-bootstrap-distinct-from-agent-driven-discovery.md)
(the deterministic agent-less Footing in a forked starter repo; framework code
only in the published image). This PDR does **not** re-decide that architecture —
it records the product decisions that operationalize it after a 2026-06-25
working session found the documented path had drifted behind the ratified model.

**Anchored on (PDR):** [PDR-019](019-adopter-bootstrap-stand-up-product.md).
**Anchored to (ADR):** ADR-040, [ADR-026](../adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
(the one human credential gate), [ADR-018](../adr/018-empirical-verification-is-contract-surface.md)
(adopter carries no framework code — only the published image).
**Related beads:** lead-l7uz (WS-2 parent), lead-mrn2 (local-first agent-vault),
lead-rs0i (footing network self-attach + starter slim), lead-27ka
(bin/bootstrap `--group-add`), lead-wdvx (bc-container socket usability).

## Context

ADR-040 ratified Footing as the canonical, deterministic, agent-less bringup
runway. In practice two divergent models had grown: `INSTALL.md` documented a
hand-run, **image-based** path (`mkdir myproduct` → `docker run bc-lead bash` →
`shop-templates bootstrap --target /work` → manual compose/provision/shell),
while the ratified path is **`bin/footing`** run in a forked `<product>-lead`
repo. They were incompatible (footing requires a `<product>-lead` dir; the
INSTALL path used `myproduct`), and the scripted-`.env` / local-first work had
landed only on the footing side. Separately, the published `shopsystem-starter`
repo carried `compose.yaml` + `.env.example` that drifted stale (last rendered
v0.14.0 while templates were at v0.25.0).

## Decision

- **D1 — One canonical bringup path: the Footing runway.** Fork
  `shopsystem-starter` (named `<product>-lead`) → `./bin/bootstrap` → it renders
  the lead shop from the published image and runs `bin/footing` → footing stops
  at solid footing → agent-driven Discovery begins. This is the single
  documented path; the image-based hand-run path is retired.

- **D2 — `shop-templates bootstrap` is the internal scaffold primitive, not a
  user front door.** `bin/footing` (via `bin/bootstrap`) calls it to pour the
  structure. It is kept unchanged and is no longer presented to adopters as a
  competing entry point.

- **D3 — The starter is `README.md` + `bin/bootstrap` only.** `compose.yaml` and
  `.env.example` are removed from `templates/starter/` — they are rendered into
  the fork by `bin/bootstrap`'s in-container `shop-templates bootstrap`,
  versioned with the image. **Maintenance model:** the starter is minimal by
  design, so it has no drift surface beyond the thin, stable launcher; there is
  nothing to keep in sync that the image doesn't already version.

- **D4 — lead↔broker agent-vault is local-first.** Footing/provision run the
  `agent-vault` CLI against `AGENT_VAULT_ADDR=http://<product>-agent-vault:14321`
  (auth via `--address`, vault verbs via the `AGENT_VAULT_ADDR` env) rather than
  `docker exec` into the broker. `.env` is scripted before the broker starts
  (generated `AGENT_VAULT_MASTER_PASSWORD` + `AGENT_VAULT_ADDR`); the remaining
  values (`AGENT_VAULT_TOKEN`/`_VAULT`/`_CA_PEM`) are completed post-start.

- **D5 — Footing runs in a networked, docker-capable container.** Because
  `bin/bootstrap` launches footing in a container, two preconditions are
  required and now hold: the launch passes `--group-add <host-socket-gid>` so
  footing's non-root user can use the mounted docker socket (lead-27ka), and
  footing **self-attaches its container to the `<product>` network** after
  `compose up` so the in-network broker address resolves (lead-rs0i).

## Verification

The footing provisioning path (D4 + D5) was **live-proven end-to-end** on the
published `:latest` (bc-lead v0.3.13 / shop-templates v0.27.0): in the real
footing topology (a default-bridge container with the docker socket and
`--group-add`, no `--network`), `compose up` + `docker network connect <slug>
$(hostname)` + local-first `agent-vault auth`/`vault create`/`credential set`
succeed against the in-network broker; without the self-attach the same call
fails with `no such host`. Footing's git/beads/remote-push half and the exact
post-footing ergonomics are documented as current best understanding and remain
adopter-test-verifiable.

## Retirements (so nothing dangles)

- The image-based `myproduct` `INSTALL.md` path (§1–§5 hand-run sequence).
- The starter's carried `compose.yaml` + `.env.example` (now render-time only).
- `INSTALL.md`'s `briefs/011` pointer → `briefs/012`.

## Known follow-ups (not blocking this decision)

- `bin/agent-vault-approve-claude` still uses `docker exec` into the broker
  (works, but inconsistent with the local-first provision/check) — a
  consistency cleanup.
- ADR-040's Context prose enumerates the old four-file starter; see its
  addendum recording the D3 slim.
