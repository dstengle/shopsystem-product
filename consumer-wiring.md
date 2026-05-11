# Consumer wiring (phase 1)

How a consumer product or a BC-shop pulls in the shopsystem framework
packages in phase-1, per [ADR-001](adr/001-framework-packaging.md)
§Phase-1 wiring.

## What the consumer depends on

The three framework packages live under separate repos but use plain
distribution names. The repo name and distribution name diverge for
two of the three; declare the dep by **distribution name** on the left
of `@`:

| Repo                                                                | Distribution name      |
|---------------------------------------------------------------------|------------------------|
| [shopsystem-scenarios](https://github.com/dstengle/shopsystem-scenarios)   | `scenarios`            |
| [shopsystem-templates](https://github.com/dstengle/shopsystem-templates)   | `shop-templates`       |
| [shopsystem-messaging](https://github.com/dstengle/shopsystem-messaging)   | `shopsystem-messaging` |

`shopsystem-messaging` transitively pulls `scenarios` (the messaging
schemas delegate the canonical scenario-hash to `scenarios.hash`), so
a consumer that needs messaging doesn't need to declare `scenarios`
explicitly — but declaring it anyway is the more robust pattern
(explicit > transitive when the consumer reads the dep list).

## `pyproject.toml` snippet

```toml
[project]
name = "my-bc-shop"
requires-python = ">=3.10"
dependencies = [
    "scenarios @ git+https://github.com/dstengle/shopsystem-scenarios@v0.1.0",
    "shop-templates @ git+https://github.com/dstengle/shopsystem-templates@v0.1.0",
    "shopsystem-messaging @ git+https://github.com/dstengle/shopsystem-messaging@v0.1.0",
]
```

Pin to a **tag**, not a branch. The shape stabilizes through tags;
phase-2 will publish to PyPI once names are settled.

## Install and verify

```bash
pip install -e .                  # or `pip install .` for non-dev
shop-msg --help                   # messaging CLI on PATH
scenarios --help                  # scenarios CLI on PATH
shop-templates list               # 4 role templates
```

A lead-shop consumes all three. A BC-shop typically consumes
`shopsystem-messaging` (for `shop-msg` + `catalog.schemas`) and
`shop-templates` (for the BC role prompts); `scenarios` arrives
transitively.

## What stays editable

Nothing — phase-1 explicitly moves consumers off editable installs of
the framework packages. Editable installs remain appropriate for the
consumer's own packages (the lead-shop and BC-shop directories within
the consumer product's repo), not for the framework deps.

## What this defers (phase-2)

- **PyPI publishing.** When shapes stabilize, framework packages will
  publish, and consumers will drop the `@ git+...` form for plain
  version specifiers.
- **CLI renames.** The CLIs keep their current binary names
  (`shop-msg`, `scenarios`, `shop-templates`) per ADR-001's
  no-rename-in-phase-1 rule.
