# Setting up a new BC shop

This document covers the full sequence for standing up a new bounded-context
(BC) shop in the shopsystem product. The sequence assumes you are working from
the lead-shop root (`/workspaces/shopsystem-product`).

## Prerequisites

The following CLIs must be available in the environment:

- `shop-templates` — installed editable from `repos/shopsystem-templates`
- `bd` — beads issue tracker
- `gh` — GitHub CLI, authenticated

If `shop-templates` is not on PATH, install it:

```bash
pip install -e repos/shopsystem-templates
```

## Step 1 — Create the GitHub repos

Two repos are needed: the BC shop itself and a private companion repo for
beads data.

```bash
gh repo create dstengle/<bc-name> --public
gh repo create dstengle/<bc-name>-beads --private \
    --description "Beads issue tracker (Dolt-backed) for <bc-name>"
```

The beads companion repo must have at least one commit (a `main` branch)
before `bd dolt push` will succeed. Initialize it with a README:

```bash
gh repo create dstengle/<bc-name>-beads --private \
    --description "Beads issue tracker (Dolt-backed) for <bc-name>" \
    --add-readme
```

If the BC repo already exists on GitHub (the user created it first), skip the
first command and clone directly in Step 2.

## Step 2 — Clone into repos/

```bash
git clone https://github.com/dstengle/<bc-name> repos/<bc-name>
```

The `repos/` directory is gitignored in the lead shop; clones live there as
siblings, not subdirectories tracked by the lead repo.

## Step 3 — Bootstrap the BC shop

```bash
shop-templates bootstrap \
  --shop-type bc \
  --shop-name <bc-name> \
  --target repos/<bc-name>
```

This single command pours the canonical BC scaffold into the target directory:

| File | What it is |
|---|---|
| `.claude/agents/bc-implementer.md` | Implementer role prompt (inline copy from templates) |
| `.claude/agents/bc-reviewer.md` | Reviewer role prompt (inline copy from templates) |
| `CLAUDE.md` | BC-shop primer with the shop name substituted |
| `.gitignore` | Canonical ignores (inbox/, outbox/, .beads/embeddeddolt/, etc.) |
| `.claude/settings.json` | SessionStart hook watching the BC's inbox |
| `.beads/` | Initialized by `bd init --skip-agents` |

## Step 4 — Configure the beads remote

```bash
cd repos/<bc-name>
bd dolt remote add origin git+https://github.com/dstengle/<bc-name>-beads.git
```

> **Gotcha:** this command triggers a pre-commit hook that can hang for ~5
> minutes. Kill it if stuck (`Ctrl-C`) and re-run — the second attempt
> usually completes immediately.

Then push the beads database:

```bash
bd dolt push
```

Return to the lead-shop root when done:

```bash
cd /workspaces/shopsystem-product
```

## Step 5 — Commit and push the BC scaffolding

From inside the BC repo:

```bash
cd repos/<bc-name>
git add .claude/ CLAUDE.md .gitignore .beads/issues.jsonl .beads/config.yaml
git commit -m "bootstrap: BC shop scaffolding via shop-templates"
git push -u origin main
cd /workspaces/shopsystem-product
```

## Step 6 — Install the BC package (if applicable)

If the BC ships a Python package (has `pyproject.toml`), install it editable
into the lead-shop environment so its CLIs (e.g. `shop-msg`) are on PATH:

```bash
pip install -e repos/<bc-name>
```

## Step 7 — Register the BC in the lead shop

Add the new BC to the **Sibling BC repos** section of `README.md`, then
commit:

```bash
git add README.md
git commit -m "docs: register <bc-name> in sibling BC list"
git push
```

## Keeping agent files current

When `shopsystem-templates` ships updated role-prompt templates, re-pour them
into any existing BC with:

```bash
shop-templates update --shop-type bc --target repos/<bc-name>
```

This reconciles `.claude/agents/` and `.claude/settings.json` against the
current canonical set without touching `CLAUDE.md`, `.gitignore`, or `.beads/`.

## Existing BC beads companions

Each BC's beads data lives in a private repo following the `<shop>-beads`
naming pattern:

- `shopsystem-messaging-beads`
- `shopsystem-scenarios-beads`
- `shopsystem-templates-beads`
- `shopsystem-test-harness-beads`
- `shopsystem-devcontainer-beads` _(pending)_
