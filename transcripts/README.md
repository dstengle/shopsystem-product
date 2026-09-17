# Agent transcripts — permanent record

Raw execution transcripts of every Claude Code session and subagent run
reachable from this machine, copied here on 2026-09-17 at the product
authority's direction, so the record survives the machine they were
written on.

## What this is

740 JSONL files, 274.6 MB, copied verbatim from `~/.claude/projects/`.
Directory names are the harness's own: the working directory of the
session, with path separators replaced by dashes.

| Directory | Files | What it holds |
|---|---|---|
| `-home-vscode-rebaseline/` | 667 | This branch's sessions, and every subagent and workflow run beneath them |
| `-workspace/` | 71 | Sessions run from the `/workspace` checkout |
| `-home-vscode/` | 1 | One session run from the home directory |
| `-home-vscode--claude-jobs-71c24a0e-tmp/` | 1 | One job-scoped temporary session |

Top-level `<uuid>.jsonl` files are main-loop sessions. Files under
`subagents/` are individual agent runs; those under
`subagents/workflows/<run>/` are workflow runs, with `journal.jsonl`
recording each agent's return value.

## What it is evidence of

`system-analysis-2026-09-17.md` at the repository root was written partly
from these files — what agents actually did, as against what the
definitions told them to do. Its own limits section notes that the
transcript-derived figures were the most confident it produced and the
least verifiable, because they lay outside the repository. They no
longer do.

## Caveats

- **The 2026-09-17 session's own transcript is partial.** It was still
  being written when the copy was made, and it is the session that made
  it.
- **No redaction was performed.** The files were scanned for credential
  patterns — GitHub tokens, API keys, AWS keys, private keys, Slack
  tokens — and none matched, which is consistent with `agent-vault`
  injecting credentials on the wire so they never reach a transcript.
  The scan was pattern-based, not exhaustive.
- **These are not governed artifacts.** No typedef defines them, no
  process produces them, and the lint does not read them. They are kept
  as raw evidence, not as a record the system maintains.
- **They are append-only history.** Nothing here should be edited. A
  correction belongs in the artifact that cites them.
