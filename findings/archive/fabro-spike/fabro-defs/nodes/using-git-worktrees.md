# node port: `using-git-worktrees` → `worktree` (command)

**Source:** `using-git-worktrees/SKILL.md` · **Realizes 01b node:** `worktree`. Outcome
edges: `worktree -> plan [label="ok"]` · `worktree -> emit_blk [label="failed"]`.

**Translation note:** authored as a command node → realized as a tool-restricted agent
node (v0.254.0 DOT has no native command handler; see `../README.md`). GATE preserved
literally: the worktree path is `.worktrees/<work_id>` **INSIDE the BC root** — NEVER the
parent (`..`), shared volumes, or any path outside `/workspace`; an out-of-project write
trips a hard Claude-Code permission wall even in bypass mode and stalls the dispatch.

---

## `worktree` — command node

- **exact cmd (fresh work):**
  ```
  git fetch origin
  git worktree add .worktrees/<work_id> -b bc/<work_id> origin/main
  ```
  Creates a worktree at `.worktrees/<work_id>` (INSIDE the BC repo root) on a new branch
  `bc/<work_id>` based on `origin/main`. All implementation (`src/`/`tests/`/`features/`)
  happens inside this worktree, never on `main` directly.
- **edge cases (deterministic handling):**
  - Branch `bc/<work_id>` already exists (prior interrupted session) → do NOT create a new
    one; resume: `git worktree add .worktrees/<work_id> bc/<work_id>`.
  - git reports the worktree already registered → `git worktree prune` the stale worktree,
    then proceed.
- **BC-root boundary check (hard gate):** the worktree path MUST be within the BC
  repository root (`.worktrees/<work_id>`). NEVER `..`, lead-shop dirs, shared volumes, or
  any path outside `/workspace`. A containerized BC cannot write outside `/workspace`.
- **outcome edges:** `-> plan [label="ok"]` (worktree created/resumed on `bc/<work_id>`)
  · `-> emit_blk [label="failed"]` (git worktree add fails, or the boundary check would
  place the worktree outside the BC root — block with named evidence rather than writing
  out of bounds).
- **agent-node realization:** `class="command"`, `permissions="read-write"`,
  `prompt="Run EXACTLY the git worktree commands for work_id <work_id>, choosing the
  fresh-vs-resume-vs-prune branch by the observed git state per the rules above. NEVER
  create a worktree outside .worktrees/<work_id> within the BC root — if that is the only
  option, emit outcome 'failed'. Emit 'ok' iff .worktrees/<work_id> is checked out to
  bc/<work_id>; else 'failed'. Use no other judgment."`
- **later cleanup (post-integration, after work_done — not a graph edge here):**
  `git worktree remove .worktrees/<work_id> ; git branch -d bc/<work_id>`.
