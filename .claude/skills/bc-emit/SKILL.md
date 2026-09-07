---
name: bc-emit
description: 'A Bounded Context shop''s command for closing its work: runs the pre-emit
  preconditions on a dispatched work id — the deliverable reachable, the plan''s sub-issues
  closed — then invokes `shop-msg respond work_done` to send the lead its response.
  Run by a Bounded Context shop at the end of its work; the lead shop describes it
  here because its definitions name the response it produces. Not run while the shop
  is frozen. Tool: `bc-emit`, owned by shopsystem-templates; it does not answer the
  standard question, so this skill is produced from the description beside it, `basis/tools/descriptions/bc-emit.json`.
  Uses, each with its exact invocation below: `work-done`.'
type: skill
id: bc-emit-skill
generated: true
generated-by: basis/tools/compile_tool.py
derived-from: bc-emit
source: basis/tools/descriptions/bc-emit.json
source-digest: sha256:d73c83280f8d
stands-beside: bc-emit
tool-owner: shopsystem-templates
---

# bc-emit (produced from the description beside `bc-emit`, `basis/tools/descriptions/bc-emit.json`)

A Bounded Context shop's command for closing its work: runs the pre-emit preconditions on a dispatched work id — the deliverable reachable, the plan's sub-issues closed — then invokes `shop-msg respond work_done` to send the lead its response. Run by a Bounded Context shop at the end of its work; the lead shop describes it here because its definitions name the response it produces. Not run while the shop is frozen.

Uses: [work-done](#work-done).

## work-done

Checks the preconditions for <work_id> — the deliverable commit or tag reachable on the remote, every sub-issue under the plan umbrella closed with at least one RED failing-test sub-issue when <plan_umbrella> is given, no retired hash still carried under features/ — and, when they hold, invokes `shop-msg respond work_done` with the status and summary; when any precondition fails the emit is refused and respond is not invoked.

Invocation:

```sh
bc-emit work-done --work-id <work_id> [--deliverable <deliverable>] [--tag <tag>] [--scenario-hash <scenario_hash>] [--retire-hash <retire_hash>] [--plan-umbrella <plan_umbrella>] [--status <status>] [--bc <bc>] [--summary <summary>] [--repo <repo>]
```

Takes:
- `<work_id>` — the dispatched work id the response answers (required)
- `<deliverable>` — the reachability mode: commit (the work id's commit on origin/main) or tag (a release); omitted, the tool's default mode (optional)
- `<tag>` — the release tag name, in tag mode (optional)
- `<scenario_hash>` — a scenario hash echoed in the payload; repeat the option for each (optional)
- `<retire_hash>` — a scenario hash the consumed dispatch named for retirement; repeat for each; the emit is refused while any is still carried by a scenario block under features/ (optional)
- `<plan_umbrella>` — the bd umbrella bead id carrying the work id's sub-issue decomposition; omitted, the plan preconditions are not enforced (optional)
- `<status>` — the work_done status forwarded: complete, partial, or blocked (optional)
- `<bc>` — the canonical Bounded Context shop name, passed through (optional)
- `<summary>` — the work_done summary, passed through (optional)
- `<repo>` — the repository root the preconditions inspect (omitted: `"the current directory"` is taken)

Returns (text): the output of `shop-msg respond work_done` on standard output; exit status 0 — not yet observed by this shop, the use being a Bounded Context shop's and one the freeze bars

Fails:

| code | exit status | condition | next step |
|---|---|---|---|
| `usage` | 2 | the arguments are not the invocation this tool states — `--work-id` missing, an unknown option, an option without its value, or a value outside its choices; the usage sheet and one line `bc-emit work-done: error: ...` on standard error; nothing is checked or sent | run the invocation the use states, as written |
