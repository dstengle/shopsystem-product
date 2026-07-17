# Runbook: keeping a review venv's import resolution honest

## When this runbook applies

You are running a package's own test suite (or a differential experiment) from
inside a freshly-provisioned virtual environment — the "review venv" — and you
need the tests to import the code you *think* they import. The failure mode this
runbook guards against is a review venv whose import resolution is silently
poisoned: the tests pass or fail against the wrong copy of the package, and the
verdict you report is about code you never actually exercised.

Applies to any shop that provisions a throwaway venv to review a package under
change. The guidance below uses placeholders you substitute for your own shop:

- `<pkg>` — the import name of the package under review.
- `<repo>` — the checkout whose changes you are reviewing (its `src/` is what
  you intend the venv to import).
- `<venv>` — the freshly-provisioned review virtualenv.

> **Read the whole runbook before trusting a single test result from a review
> venv.** A venv that reports "clean" the instant you provision it can lose its
> target package and silently start resolving `<pkg>` from somewhere else within
> a second. The mitigations below assume the poisoning *recurs*, not that it
> happens once.

## The five hazard traps

### Trap 1 — a wrong entry ahead of `<repo>/src` on `sys.path`

The venv's `<pkg>` resolves from the first `sys.path` entry that provides it. An
editable install `.pth`, a stray `PYTHONPATH`, or the current working directory
can sit ahead of `<repo>/src` and win. The tests then import a *different*
`<pkg>` than the one you are reviewing, and every result is about the wrong
tree. Trap 1 is the baseline import-integrity hazard: resolution order, not
intent, decides what gets imported.

### Trap 2 — a stale build artifact shadowing the source

A leftover installed copy of `<pkg>` (a wheel unpacked into `site-packages`, a
`build/`/`*.egg-info` directory, or cached bytecode) can shadow `<repo>/src`
even after you edit the source. The venv imports the frozen artifact, so your
change appears to have no effect — or an already-fixed bug appears to persist.

### Trap 3 — a foreign editable `.pth` redirecting `<pkg>` off-tree

An `__editable__.<pkg>-<ver>.pth` (or a legacy `.egg-link`) dropped into the
venv's `site-packages` redirects `<pkg>` to a path that is *not* `<repo>/src` —
often a sibling checkout or a shared workspace root. Because a `.pth` line is
executed at interpreter startup, this redirect is invisible in your shell env
and only shows up in the *resolved* module path.

### Trap 4 — ambient `VIRTUAL_ENV` clobbers a verified-clean venv (TOCTOU)

The dangerous one, and the reason the others recur. You provision `<venv>`,
verify it is clean (target `<pkg>` resolves to `<repo>/src`, no foreign
`.pth`), and then a provisioning or setup step runs `pip install -e <workspace>`
**without** an explicit `--target`/activation. `pip` honors the **ambient
`VIRTUAL_ENV`** environment variable inherited from the surrounding shell — a
*different* venv than the `<venv>` you just verified — and installs the editable
project there. Within roughly a second of a clean verification, the target venv
loses its own `<pkg>` and gains a foreign `__editable__.<pkg>-<ver>.pth`
pointing at the workspace root. This is a time-of-check/time-of-use (TOCTOU)
window: your "clean" check was true when you ran it and false by the time the
tests import anything. Any review workflow that checks integrity once, up front,
and then trusts it for the rest of the run is exposed to this trap.

### Trap 5 — the blanket purge unmasks a stale non-editable global

The subtle one, and the reason purging alone is not a cure. Its title
deliberately mirrors Trap 1's: the crisp axis between them is *editable vs
non-editable* — Trap 1 is a stale global **editable** install winning on
`sys.path`; Trap 5 is a stale **non-editable** global that survives the very
purge meant to clean up after Trap 4.

- **Symptom.** In a `--system-site-packages` venv, Trap 4's blanket
  `rm -f <venv>/lib/python*/site-packages/__editable__*.pth` deletes the
  reviewer's *own* editable pointer along with any foreign one — the glob
  cannot tell them apart. Import of `<pkg>` then still *succeeds*, silently
  resolving to a stale copy in the inherited global `site-packages`. No error,
  no warning, no missing module.
- **Mechanism.** The stale global is a plain *non-editable* install (a
  `<pkg>-<ver>.dist-info` under the interpreter's global `site-packages`,
  typically root-owned, not removable without `sudo`). It is *not* a `.pth` —
  so **no purge can remove it**. The blanket purge *unmasks* it rather than
  clearing it.
- **Why Traps 1 and 4 do not reach it.** Trap 1 frames the hazard as a sibling
  or deleted worktree — bad path config pointing somewhere *wrong*. This is a
  stale global package sitting exactly where it *belongs*, which that framing
  does not cover. Trap 4's purge is the *trigger* here, not the cure.
- **Why it matters.** A stale global is by construction pre-fix code, so the
  arm it poisons is the one asserting a fix is *absent* — and that reading
  presents as a *finding* rather than a failure, exactly the reading a
  reviewer is least likely to distrust.

**Both mitigations.**

1. Provision the venv **without** `--system-site-packages` — nothing to fall
   back to, so a missing pointer fails *loudly* instead of resolving silently.
   Preferred wherever the dependencies can all install into the venv.
2. Where the suite genuinely needs `--system-site-packages`, re-point via a
   uniquely-named non-`__editable__` `.pth` that the blanket glob does not
   match — e.g.
   `echo <repo>/src > <venv>/lib/python*/site-packages/zz-<work-id>-src.pth`.
   **Correction, established by probe and not by assumption:** the `zz-`
   prefix is **not load-bearing for precedence** — it matters only for
   surviving the `__editable__*` glob. The venv's own `site-packages` is
   processed ahead of the inherited global *regardless of filename prefix*
   (`sys.path` index 5 vs 6 in the probe). Do not cargo-cult `zz-` as a
   sort-order trick.

Trap 4's in-process resolution assert (Mitigation 2, below) is **retained and
reaffirmed as the detector — not weakened.** That assert is precisely what
caught this trap, which is evidence it should stay **mandatory** — not
evidence to weaken it or to drop the purge.

**Composite rule.** On a `--system-site-packages` venv the full sequence is
**purge, re-point, then assert** — dropping any one of the three re-opens
either Trap 4 (a foreign `.pth` survives) or Trap 5 (`<pkg>` resolves from the
inherited global).

## Three mitigations

### Mitigation 1 — purge foreign `__editable__*.pth` after provisioning AND before every run

Because the clobber in Trap 4 *recurs*, a one-time cleanup is not enough. Purge
every foreign `__editable__*.pth` (and stray `.egg-link`) from `<venv>`'s
`site-packages` **immediately after provisioning** and **again immediately
before each test run** — not just once at setup. Treat the purge as part of the
run command, not part of setup, so a clobber that lands between two runs is
removed before the second run imports anything.

### Mitigation 2 — assert import resolution in the SAME process that runs the tests

A separate "check that `<pkg>` resolves to `<repo>/src`" step, run in its own
process before the tests, leaves an assert-then-run TOCTOU window: the resolution
can change between the check process exiting and the test process starting.
Close the window by asserting resolution **in the same process** that runs the
tests — e.g. a session-scoped fixture / conftest hook, or a preamble in the test
process itself, that fails loudly unless `<pkg>.__file__` lives under
`<repo>/src`. The check and the use then share one process image, so nothing can
slip in between them.

### Mitigation 3 — for differential experiments, assert per arm and print the resolved path per arm

When you compare arms (e.g. patched vs. control, or version A vs. version B), a
single up-front integrity check cannot cover every arm — a poisoned *control*
arm silently resolves the same `<pkg>` as the treatment arm and hides the very
difference you are measuring. Assert resolution **independently on every arm**,
in each arm's own process, and **print the resolved `<pkg>` path for each arm**
as part of the experiment output. A poisoned arm then shows up as a visible,
mismatched path in the record rather than as a silently null result.

## Summary

- **Symptom:** a review venv reports test results about a `<pkg>` it never
  actually imported — often after a clean-looking provisioning step.
- **Cause:** import resolution for `<pkg>` is decided by `sys.path` order,
  shadowing artifacts, editable `.pth` redirects, and an inherited global
  `site-packages` — and a `pip install -e` that honors an ambient
  `VIRTUAL_ENV` can clobber a verified-clean `<venv>` within ~1s (a TOCTOU
  window), and the clobber recurs.
- **Do not:** trust a single up-front integrity check, or a resolution check run
  in a separate process from the tests, or one blanket check across every arm of
  a differential experiment; and do not treat a blanket `__editable__*.pth`
  purge as the source of the guarantee — on a `--system-site-packages` venv it
  can delete your own pointer and unmask a stale non-editable global.
- **Do:** purge foreign `__editable__*.pth` after provisioning and before every
  run — but treat purging path config as itself one of the traps: it is
  *necessary and not safe on its own*, so on a `--system-site-packages` venv
  the guarantee comes from **purge, re-point, then assert**, not from the purge
  alone. Assert `<pkg>` resolves under `<repo>/src` in the same process that
  runs the tests; and, for differential experiments, assert per arm and print
  each arm's resolved `<pkg>` path so a poisoned arm is visible rather than
  silent.

## Checklist before trusting any review-venv result

- [ ] Foreign `__editable__*.pth` purged after provisioning **and** again
      immediately before each run (not once at setup).
- [ ] `<pkg>` resolution asserted **in the same process** that runs the tests,
      failing loudly unless `<pkg>.__file__` lives under `<repo>/src`.
- [ ] For differential experiments, resolution asserted **per arm** with each
      arm's resolved `<pkg>` path printed into the record.
- [ ] **Venv-provisioning choice made deliberately:** prefer provisioning
      **without** `--system-site-packages` so a missing pointer fails loudly;
      where the suite needs it, re-point with a uniquely-named non-`__editable__`
      `.pth` and run the full **purge, re-point, then assert** sequence.
- [ ] **Resolution into an inherited global explicitly ruled out:** confirm
      `<pkg>` resolves from `<repo>/src` and **not** from a stale non-editable
      `<pkg>-<ver>.dist-info` in the interpreter's global `site-packages`.
