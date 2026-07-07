---
id: ADR-045
kind: adr
title: "`AGENT_VAULT_CA_PEM` carries inline PEM content, not a filesystem path"
status: accepted
date: "2026-06-27"
description: "`AGENT_VAULT_CA_PEM` carries inline PEM content, not a filesystem path"
beads: [lead-b14a, lead-lu91, lead-qi0q]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: []
  pins: []
  related: []
---
# ADR-045 — `AGENT_VAULT_CA_PEM` carries inline PEM content, not a filesystem path

- Status: Accepted (contract fully established from the artifact surface,
  including the encoding — see lead-b14a below; remaining fix is in the
  shop-owned shopsystem-templates scripts, gated on a PO-authored scenario)
- Date: 2026-06-27
- Relates: PDR-020, ADR-026, ADR-028, ADR-018, ADR-043
- Bead: lead-lu91; prior bc-launcher fix lead-b14a (CLOSED, reconciled)

> Number note: the prior ADR-044 was created and then `git rm`'d as withdrawn
> under lead-qi0q (router pre-state error). To avoid history ambiguity this ADR
> takes 045 rather than reusing the withdrawn 044 number.

## Context

A product bootstrap test (testproduct3, 2026-06-27) produced a subtle SSL
failure in the **launched leaf agent** (not the lead). `cat
~/.config/agent-vault/ca.pem` in the leaf printed the literal string
`agent-vault-ca.pem` — a *filename* — instead of a `-----BEGIN CERTIFICATE-----`
block. The trust anchor was a path string, so MITM-proxy TLS validation failed.

`AGENT_VAULT_CA_PEM` was being interpreted under **two incompatible
conventions** across the bring-up chain (trace verified lead-side, ADR-018
artifact surface):

1. **Producer (`bin/agent-vault-provision`, shop-owned, rendered from
   shopsystem-templates):** L237 `CA_PEM_FILE="${AGENT_VAULT_CA_PEM:-agent-vault-ca.pem}"`,
   L239 `agent-vault ca fetch > "$CA_PEM_FILE"` (real cert into a *file*),
   L257/L268 `printf 'AGENT_VAULT_CA_PEM=%s\n' "$CA_PEM_FILE"` — writes the
   **PATH string** into `.env`. The script's own comment (L231-236) flags this
   exact risk: *"If the launch path ever expects inline PEM instead, switch this
   to capture the PEM into the value with proper escaping; path is the safer
   default."*
2. **Transport (`bin/shop-shell`, shop-owned):** L73
   `grep -E '^AGENT_VAULT_[A-Z_]+=' .env > <env-file>` then L101 `docker run
   --env-file <env-file>` — passes the path string into the container as the env
   **value**.
3. **Consumer (bc-base/bc-lead entrypoint, owned by shopsystem-bc-launcher; not
   on the lead host):** materializes the trust file **from the env value
   verbatim**, treating it as **inline PEM** → trust file becomes the literal
   string `agent-vault-ca.pem`.

So the producer emits a PATH; the consumer expects INLINE.

## Decision

**The canonical `AGENT_VAULT_CA_PEM` contract is INLINE PEM content carried as a
multi-line value with REAL internal newlines** (no trailing newline; the bc-base
entrypoint's `printf '%s\n' "${AGENT_VAULT_CA_PEM}"` re-adds exactly one). The
environment value IS the certificate material the entrypoint installs into the
client trust store. It is NOT a filesystem path, and the encoding is NOT a
`\n`-escape or base64 form.

Consequence: the **consumer side (bc-launcher: bc-container + bc-base
entrypoint) is already correct and pinned** (see lead-b14a). The remaining fix
is in the **shop-owned shopsystem-templates scripts** — `bin/agent-vault-provision`
and, critically, `bin/shop-shell` — which must deliver the CA *content* (with
real newlines) into the launcher process environment that `bc-container` reads,
instead of passing the path string verbatim through `grep`+`docker --env-file`.

## Evidence (ADR-018 artifact surface)

- `findings/dummyco-spike-iter-7.md` L95-98: *"AGENT_VAULT_CA_PEM is carried
  inline (PEM text, not a path) … brokered TLS works"* — the curl probe to
  api.anthropic.com returned HTTP 404 (model), not a TLS/cert error, so the MITM
  CA verified against the **inline** trust material. Empirical end-to-end
  validation of the inline form.
- The symptom itself: the env value appeared **verbatim** in the trust file →
  the entrypoint consumes the value as content (inline), confirming the
  direction.
- PDR-020 L39/L71 and ADR-028 L266: the bc-base entrypoint **"materializes the
  CA from `AGENT_VAULT_CA_PEM`"** — i.e. the env value is the CA material.

## Alternative considered and rejected: PATH

Keep `AGENT_VAULT_CA_PEM` as a path. Rejected: it would require changing **three**
components instead of one — the entrypoint would have to `cp` the file at that
path; `shop-shell` would have to mount the CA file into the container at a
container-resolvable path and resolve CWD; and the value-as-path semantics would
have to be pinned at the consumer. It also contradicts the empirically-validated
working form (spike iter-7). The inline form changes only the producer and
matches the already-working consumer. PATH is strictly more surface for no
benefit.

## The encoding is established from the artifact surface — lead-b14a

The encoding question (how multi-line PEM travels) was resolved earlier and is
recorded on the artifact surface, so it is **not guessed** (ADR-018 / the
lead-qi0q lesson):

- **lead-b14a** (request_bugfix → shopsystem-bc-launcher, CLOSED + reconciled
  2026-06-19) fixed bc-container's `_parse_env_file` so a multi-line
  `AGENT_VAULT_CA_PEM` value travels through `bc-container launch --env-file`
  intact (no `splitlines()` truncation). Pinned by
  `@scenario_hash:eb92b4a40939973f` in `features/bc_container_broker_ca_trust.feature`.
- The CA-as-env-var **direction** is pinned by `@scenario_hash:7c3e1a9f5d8b2640`
  and `8d4f2b0a6e9c3751` (same feature), and the **bc-base materialization** by
  `features/bc_base_agent_vault_entrypoint.feature` (`@bc_internal`).
- lead-b14a's reconciled `work_done` states the operator convention explicitly:
  *"env value carries real internal newlines + no trailing newline; printf
  re-adds exactly one"*, and *"no `\n`-escape convention was imposed"*. The
  committed `docker/bc-base/agent-vault-ca.sh` does `printf '%s\n'
  "${AGENT_VAULT_CA_PEM}"`.

So the consumer (bc-launcher) is settled: real-newline inline PEM in the env
value. No further bc-launcher change is required, and no nudge answer is needed
to write the producer/transport fix.

## The real failure is in the shop-owned transport (`bin/shop-shell`)

`bin/shop-shell:73` does `grep -E '^AGENT_VAULT_[A-Z_]+=' .env > <file>` then
`docker run --env-file <file>` (line 101). Two problems for a multi-line CA on
this path: (1) the `grep` keeps only the first physical PEM line (subsequent
lines do not start with `AGENT_VAULT_`); and (2) **docker's** `--env-file` (as
opposed to `bc-container`'s own, which lead-b14a fixed) cannot carry a value
spanning lines. Today the field carries a path string, so it passes through as
the literal value and the entrypoint materializes the *path string* as the trust
anchor — the observed symptom.

The proven-correct shape (the workaround the lead relied on through lead-b14a):
get the CA *content* into the launcher **process environment** with real
newlines (e.g. `export AGENT_VAULT_CA_PEM="$(cat "$CA_FILE")"` then pass `-e
AGENT_VAULT_CA_PEM`), since a process env value CAN hold newlines whereas a
file-based `docker --env-file` cannot. `bin/agent-vault-provision` may continue
to fetch the CA into a file and record its path as a shop-local pointer; the
binding requirement is that the rendered scripts deliver the CA *content* (real
newlines) into the launcher process env `bc-container` reads.

## Status of the fix (lead-lu91)

- Fix → canonical template bodies of `bin/agent-vault-provision` and
  `bin/shop-shell`, owned by **shopsystem-templates** (these are shop-owned
  ops scaffolding per PDR-003 path F / templates scenarios 137/139/172/174;
  `shop-templates update` does not modify the rendered copies, only advises on
  drift, so re-sync into already-bootstrapped products is an operator step).
- Vehicle: `request_bugfix` — Q1: the capability EXISTS (templates renders both
  scripts; the CA travel path exists) but the specific CA-content-travel behavior
  is UNPINNED in templates' feature surface (scenarios 172/174 pin file presence
  and body substrings, none pin CA-content materialization). Tightening of
  unpinned behavior → `request_bugfix`, not `assign_scenarios`.
- **PO scenario-authoring is a prerequisite** and is being returned to the
  router rather than authored here: a scenario pinning that the rendered
  `bin/shop-shell` (+ `bin/agent-vault-provision`) path delivers the broker CA to
  the launched leaf as a valid certificate (the leaf's trust file is a
  `-----BEGIN CERTIFICATE-----` block, not a path string nor a PEM truncated at
  the first newline). shop-templates scenarios assert rendered-body content, so
  this is a body-content scenario in that style.
