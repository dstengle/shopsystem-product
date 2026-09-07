---
name: compile-principles
description: 'Renders a principle set into the compact prompt block compiled into
  every session: one line per principle carrying its name, slug, and statement — a
  bulleted statement kept as one obligation per bullet — with front-matter naming
  the set and a digest of its text; rationales and implications stay in the source.
  Use it after a principle set changes, to refresh the rendering the sessions load.
  Tool: `basis/tools/compile_principles.py`. Uses, each with its exact invocation
  below: `render`.'
type: skill
id: compile-principles-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: compile-principles
source: basis/tools/compile_principles.py
source-digest: sha256:55a98386214d
---

# compile-principles (produced from the answer of `basis/tools/compile_principles.py`)

Renders a principle set into the compact prompt block compiled into every session: one line per principle carrying its name, slug, and statement — a bulleted statement kept as one obligation per bullet — with front-matter naming the set and a digest of its text; rationales and implications stay in the source. Use it after a principle set changes, to refresh the rendering the sessions load.

Uses: [render](#render).

## render

Reads the principle set, parses each `## <name> (`<slug>`)` section's **Statement**, and writes the rendering to <out>, overwriting what stands there. Nothing else is written; the source is not changed.

Invocation:

```sh
python3 basis/tools/compile_principles.py <principles> <out>
```

Takes:
- `<principles>` — the path of the principle set to render, for example basis/principles.md (required)
- `<out>` — the path the rendering is written to, for example .claude/shop/principles.md (required)

Returns (text): one line on standard output, `<out>: rendered <n> principles (digest <12 hex>)`; exit status 0; the rendering written at <out>

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `unreadable` | 2 | no file exists at <principles>, or it cannot be read; one line on standard error beginning `unreadable:` names the path | give the path of an existing principle set and run the invocation again |
| `unparseable` | 1 | the file has no front-matter, its front-matter does not parse or lacks `id`, or no `## <name> (`<slug>`)` section with a **Statement** was found; one line on standard error beginning `unparseable:` names the path and the defect; nothing is written | repair the principle set at the named defect and run the invocation again |
| `unwritable` | 1 | <out> could not be written; one line on standard error beginning `unwritable:` names the path and the reason | give a writable <out> path and run the invocation again |
| `usage` | 2 | the arguments are not the one invocation this tool states; one line on standard error beginning `usage:` names it; nothing is written | run the invocation the use states, as written |
