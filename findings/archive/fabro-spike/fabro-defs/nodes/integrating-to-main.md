# node port: `integrating-to-main` → `integ` (command)

**Source:** `integrating-to-main/SKILL.md` · **Realizes 01b node:** `integ`. Outcome
edges: `integ -> review [label="ok"]` · `integ -> emit_blk [label="failed"]`.

**Translation note:** command node → tool-restricted agent node. GATE preserved literally:
**pushing is NOT optional** ("BC role discipline does not push" is NOT a reason to skip);
the work_id MUST be carried in the commit as a WHOLE token; on squash, the body MUST
enumerate the staged commits so the test-first sequence survives.

**Single-integration-authority caution (01b §2):** fabro's native `[run.pull_request]`
must be DISABLED for this workflow (`enabled = false`) so `integ` is the sole integration
authority; otherwise fabro opens competing PRs.

---

## `integ` — command node

- **exact cmd:**
  ```
  # in the work branch / worktree:
  git status --porcelain          # MUST be empty; if dirty, stop and clean first
  git log --oneline -5            # confirm work commits present
  # from the BC repo root (not the worktree):
  git fetch origin
  git checkout main
  git merge --no-ff bc/<work_id> -m "feat: <summary> (work_id: <work_id>)"
  git push origin main
  # verify:
  git fetch origin
  git log --oneline origin/main | head -5     # the work_id commit MUST appear
  ```
- **`--no-ff`** preserves the per-dispatch merge commit even if fast-forward is possible.
- **work_id attribution (required):** the commit message MUST carry `<work_id>` — the
  work-done-gate Check 2 searches `git log origin/main -E --grep="\b<work_id>\b"`.
  Acceptable equivalents: a tag or `git notes` naming exactly the work_id.
- **squash policy:** if the strategy is squash, the squash-commit BODY must enumerate the
  staged commits (`git log --oneline bc/<work_id> ^main`) so `test(red)`/`feat(green)`
  order survives the squash for the audit trail on `origin/main`.
- **push-failure handling (deterministic, do not stop until push succeeds):**
  ```
  git pull --rebase origin main
  git push origin main            # resolve conflicts if needed, then push
  ```
- **outcome edges:** `-> review [label="ok"]` (work_id commit verified reachable on
  `origin/main`) · `-> emit_blk [label="failed"]` (tree dirty at entry, or push cannot be
  landed — block; there is NO bypass, NO deferred push).
- **agent-node realization:** `class="command"`, `permissions="read-write"`,
  `prompt="Run EXACTLY the integrate sequence above for work_id <work_id>. Push is part
  of the work — never skip it. On non-fast-forward, pull --rebase and re-push until it
  lands. Emit 'ok' iff, after fetch, git log origin/main contains <work_id> as a whole
  token; else 'failed'. Use no other judgment."`
