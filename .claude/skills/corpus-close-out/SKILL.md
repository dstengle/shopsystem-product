---
name: corpus-close-out
description: 'Execute the migration plan''s pre-decided retire and terminal actions
  mechanically, at cut-over: snapshot the corpus, delete the terminal trees, move
  each run''s retired rows to the archive, regenerate the scenario refs, verify every
  actioned row landed where its action says, and finally promote the migration branch
  to `main`.'
type: skill
id: corpus-close-out-skill
status: approved
created: 2026-08-22
updated: 2026-09-02
generated: true
generated-by: basis/tools/compile_process.py
derived-from: corpus-close-out-process
source: basis/processes/corpus-close-out.md
source-digest: sha256:157420881529
---

# Corpus close out (compiled from `corpus-close-out-process`)

Execute the migration plan's pre-decided retire and terminal actions mechanically, at cut-over: snapshot the corpus, delete the terminal trees, move each run's retired rows to the archive, regenerate the scenario refs, verify every actioned row landed where its action says, and finally promote the migration branch to `main`.

**The decisions were made at the review; this process only carries them out. Mass moves are mechanical or they do not happen — no judgment, no review loop, and no silent completion: a row not where it should be fails the run loudly, by id.**

Result of a run: `report` (close-out-report).

```mermaid
flowchart TD
  derive_run_type["Derive the run type from the stage — runtime<br/>in — stage: string<br/>sets — run_type: string"]
  select_rows["Select the actioned rows in scope — runtime<br/>in — actions: action-table, stage: string, run_type: string<br/>sets — terminal_ids: string[], terminal_paths: string[], retire_ids: string[]"]
  route_stage{"Route on the stage<br/>in — stage: string"}
  snapshot_tag["Tag the pre-migration snapshot — runtime"]
  delete_terminal["Delete the terminal trees — runtime<br/>in — terminal_paths: string[]"]
  archive_retire["Move the run's retired rows to the archive — runtime<br/>in — run_type: string, retire_ids: string[]"]
  route_final{"Route on the final stage<br/>in — final: boolean"}
  regen_scenario_refs["Regenerate the scenario refs — runtime"]
  post_check["Verify every actioned row landed — runtime<br/>in — stage: string, retire_ids: string[], terminal_ids: string[]<br/>out — report: close-out-report"]
  route_promote{"Route on promotion<br/>in — final: boolean"}
  promote_branch["Promote the migration branch to main — runtime<br/>in — branch: string"]
  __end(("end<br/>result — report: close-out-report"))
  __start(("start")) --> derive_run_type
  derive_run_type --> select_rows
  select_rows --> route_stage
  route_stage -->|pre-run stage: snapshot, then delete terminal| snapshot_tag
  route_stage -->|else| archive_retire
  snapshot_tag --> delete_terminal
  delete_terminal --> post_check
  archive_retire --> route_final
  route_final -->|final stage: regenerate scenario refs| regen_scenario_refs
  route_final -->|else| post_check
  regen_scenario_refs --> post_check
  post_check --> route_promote
  route_promote -->|final stage: promote the migration branch to main| promote_branch
  route_promote -->|else| __end
  promote_branch --> __end
```

## derive-run-type — Derive the run type from the stage

Run by the runtime — no agent, no prose. reads: stage · writes: run_type.

```yaml
set:
  run_type: 'stage == "pre-run" ? "" : stage.replace("post-run:", "")'
next: select-rows
```

## select-rows — Select the actioned rows in scope

Run by the runtime — no agent, no prose. reads: actions, stage, run_type · writes: terminal_ids, terminal_paths, retire_ids.

```yaml
set:
  terminal_ids: actions.filter(r, r.action == "terminal").map(r, r.id)
  terminal_paths: actions.filter(r, r.action == "terminal").map(r, r.path)
  retire_ids: 'stage == "pre-run" ? [] : actions.filter(r, r.action == "retire" &&
    r.id.startsWith(run_type + "-")).map(r, r.id)'
next: route-stage
```

## route-stage — Route on the stage

Run by the runtime — no agent, no prose. reads: stage · writes: —.

```yaml
branches:
- label: 'pre-run stage: snapshot, then delete terminal'
  when: stage == "pre-run"
  next: snapshot-tag
- else: archive-retire
```

## snapshot-tag — Tag the pre-migration snapshot

Run by the runtime — no agent, no prose. reads: — · writes: —.

```yaml
run: 'git tag -a pre-migration -m "Safety snapshot: full corpus before migration close-out"

  git push origin pre-migration

  '
next: delete-terminal
```

## delete-terminal — Delete the terminal trees

Run by the runtime — no agent, no prose. reads: terminal_paths · writes: —.

```yaml
run: 'git rm -r ${terminal_paths}

  git commit -m "Close-out pre-run: delete terminal trees (recoverable via pre-migration
  tag only)"

  '
next: post-check
```

## archive-retire — Move the run's retired rows to the archive

Run by the runtime — no agent, no prose. reads: run_type, retire_ids · writes: —.

```yaml
run: 'archive-move --type ${run_type} --ids ${retire_ids}

  '
next: route-final
```

## route-final — Route on the final stage

Run by the runtime — no agent, no prose. reads: final · writes: —.

```yaml
branches:
- label: 'final stage: regenerate scenario refs'
  when: final
  next: regen-scenario-refs
- else: post-check
```

## regen-scenario-refs — Regenerate the scenario refs

Run by the runtime — no agent, no prose. reads: — · writes: —.

```yaml
run: 'bin/gen-scenario-refs

  '
next: post-check
```

## post-check — Verify every actioned row landed

Run by the runtime — no agent, no prose. reads: stage, retire_ids, terminal_ids · writes: report.

```yaml
run: 'archive-move --verify --stage ${stage} --retire ${retire_ids} --terminal ${terminal_ids}

  '
next: route-promote
```

## route-promote — Route on promotion

Run by the runtime — no agent, no prose. reads: final · writes: —.

```yaml
branches:
- label: 'final stage: promote the migration branch to main'
  when: final
  next: promote-branch
- else: end
```

## promote-branch — Promote the migration branch to main

Run by the runtime — no agent, no prose. reads: branch · writes: —.

```yaml
run: 'git checkout main

  git reset --hard ${branch}

  git push --force-with-lease origin main

  '
next: end
```
