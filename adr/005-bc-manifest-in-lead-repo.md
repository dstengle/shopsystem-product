# ADR-005: BC Manifest as a Committed File in the Lead Repo, Managed via bc-launcher CLI

**Status:** Accepted  
**Date:** 2026-05-20  
**Author:** Lead Architect

---

## Context

The shopsystem framework grows by adding Bounded Context (BC) shops, each with
a GitHub remote and a canonical name. As the product expands, there is no
single machine-readable record of which BCs belong to a product, what their
canonical names are, or where their source repositories live. Derived
representations — `repos/` clones, DB registry entries, container launch
lists — are currently inferred ad-hoc from directory contents and session
context.

This ADR decides where the authoritative BC registry lives and which component
manages it.

---

## Decision

The BC manifest is a **committed file in the lead repo root**, at a
well-known path. It is the single source of truth for:

- Which BCs belong to the product
- Each BC's canonical name
- Each BC's GitHub remote URL
- Each BC's role label

The file must be parseable by a standard-library parser (no custom module),
self-documenting from field names and values alone, and machine-readable for
pipeline scripts.

The **`bc-container` CLI** (owned by `shopsystem-bc-launcher`) provides the
`manifest`-family subcommands that read, validate, and synchronize from this
file. The same BC that owns container lifecycle (`launch`, `stop`, `status`,
`list`) owns manifest lifecycle — there is one tool for operating on the
product's BC set.

All derived representations flow from the manifest:
- `bc-container manifest sync --clone` reconciles `repos/` clones to
  manifest declarations.
- `bc-container manifest validate` checks GitHub remote reachability and
  local-clone alignment.
- `bc-container manifest list` emits the canonical BC set for pipeline
  consumption.

---

## Alternatives Considered

### Manifest in the database only (no committed file)

The messaging BC already uses a Postgres database for mailbox state. One
option is to store the BC registry there.

**Rejected:** A database entry is not auditable via `git log`. Adding or
removing a BC would have no diff in version control. The lead repo is already
the orchestration point for the product; manifest changes should be reviewed
as pull requests alongside the scenarios and ADRs that drove them.

### Manifest in a separate service or registry

Maintain a standalone service (e.g., a GitHub repository, a hosted registry,
a Terraform-managed resource) that declares the BC set.

**Rejected:** Adds an external dependency that must be reachable for basic
operations. The lead repo is self-contained and available offline; the
manifest should be too. A separate service also splits configuration from
the repo that consumes it.

### Manifest inferred from the `repos/` directory

Treat the `repos/` directory as the implicit manifest: whichever BC repos are
cloned there are "in the product."

**Rejected:** `repos/` is gitignored and local to each developer's workstation.
It is not committed, not shared, not authoritative. A developer who clones
the lead repo fresh has no `repos/` and no way to know which BCs belong.
Inference from a gitignored directory inverts the relationship: the manifest
should drive what gets cloned, not the other way around.

---

## Rationale

A committed file in the lead repo satisfies all constraints:

1. **Auditability.** `git log -- <manifest-path>` shows every BC addition,
   removal, and remote change, with the committer and the reason.
2. **Single source of truth.** One file drives cloning, validation, and
   container launch — no reconciliation between sources is needed.
3. **Self-contained.** A fresh checkout of the lead repo is sufficient to
   know the full BC set. No DB connection, no service call, no directory scan.
4. **Right owner.** `shopsystem-bc-launcher` is already the BC responsible
   for container lifecycle operations across the product's BC set. Extending
   it with manifest management keeps the operational surface coherent: one
   tool, one BC, one concern.

---

## Consequences

- A manifest file must be created in the lead repo root and committed as part
  of the work assigned to `shopsystem-bc-launcher` under work_id `lead-81l`.
- All 25 bc-manifest scenarios (brief 005) have been dispatched to
  `shopsystem-bc-launcher` via `assign_scenarios` (work_id `lead-81l`).
- The `repos/` directory remains gitignored. It is a local cache derived from
  the manifest, not an authoritative source.
- Future BC additions require: (1) a manifest entry, (2) a commit, (3) a
  `bc-container manifest sync --clone` run. The validate command will catch
  stale or mismatched clones.
