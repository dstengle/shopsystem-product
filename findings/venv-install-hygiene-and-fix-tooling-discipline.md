# Lead-host install hygiene + "fix the tooling, don't bypass" discipline

Date: 2026-06-19 (recorded from lead-xq0; original surfaced 2026-05-13)

## What the original bead described (now largely obsolete)

lead-xq0 (2026-05-13) described the product venv at
`/workspaces/shopsystem-product/.venv/` carrying NON-editable installs of
`shop_msg` / `shop-templates` that drifted from editable `repos/<bc>`
checkouts: a clean install fetched different code than what was validated,
and `shop-msg pending` was missing from the venv install while present in
BC source. A concrete 2026-06-09 bite: installed `shopsystem-messaging==0.2.1`
lacked the lead-fnj5 dependency-guard fix, stranding the rl0f dispatch.

## Why the original facets no longer reproduce (2026-06-19 state)

- **There is no `.venv`** on the lead host. CLIs are installed to
  `/usr/local/bin` + `/home/vscode/.local/bin` (on PATH unconditionally;
  see lead-zmi resolution).
- **The `repos/<bc>` sibling-clone convention is DEAD** (ADR-018 D1;
  memory `reference_sibling_clones_convention`). The lead carries no BC
  source to read, run, git-observe, OR install editable from. So the
  "editable repos/ drift from pins" mechanism cannot occur.
- **Installs are VCS-pinned, non-editable** from `pyproject.toml` git refs.
  `shopsystem-messaging==0.4.0` is the installed surface today; the lead's
  `pyproject.toml` pins were realigned to current (lead-ome3:
  templates v0.14.0, messaging v0.4.0, scenarios v0.2.0, bc-launcher v0.3.3).

The drift facet is therefore structurally closed by the post-ADR-018
topology: pins ARE the source of truth, and there is no editable second
copy to drift against.

## The evergreen discipline point (the part worth keeping)

The original "ls workaround" — when `shop-msg pending` failed in the venv,
the architect bypassed the CLI by direct `ls` of inbox/outbox, violating
brief-001 invariant 1 (CLI is the SOLE messaging surface) — is the lasting
lesson:

> If a `shop-msg` / `shop-templates` invocation fails, **FIX THE TOOLING**
> (reinstall from the pinned ref, correct PATH, bump the version pin) —
> do NOT bypass the CLI by reading mailbox storage directly.

This is already encoded in the lead-architect template's hard-stop-on-CLI-
failure guidance ("A CLI error is signal, not an obstacle; never work around
a CLI failure with direct database access or hand-written files"). No
further lead-instance action needed; if the team wants this tightened into
the canonical bc/lead templates beyond what's already there, that routes as
a `request_maintenance` to **shopsystem-templates**, not a lead hand-edit.

## Routing

Closed as obsolete-by-topology + discipline-already-canonical. No BC
dispatch required. Hygiene: keep `pyproject.toml` pins matched to the
shipped versions and `pip install` from those pins after a framework bump
(a clean rebuild of the devcontainer image picks them up).
