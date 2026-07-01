# node port: `test-driven-development` → inner-loop module inlined into `impl` / `impl_f`

**Source:** `test-driven-development/SKILL.md` (+ `testing-anti-patterns.md` reference) ·
**Realizes:** the RED→GREEN→REFACTOR inner loop that runs *inside* the `impl` (scenario)
and `impl_f` (flat) agent nodes; **asserted structurally by** the `redgate` command node
and by `work-done-gate` Check 5. Not a standalone graph node — it is the gate-bearing
prompt MODULE that `nodes/bc-implementer.md` includes into each implementer agent body.

**Translation note:** the SKILL was invoked via the Skill tool per behavior; here it is
inlined. Every GATE preserved literally: the Iron Law, MANDATORY watch-it-fail, separate
`test(red):`/`feat(green):` commits (never combined), TDD-mandatory with the ONLY
exception path being a `clarify` to the lead (no self-granted exception). The shopsystem
adaptation — "no human in the BC loop; where the original skill defers to a human partner,
the BC emits a `clarify` to the lead and awaits the decision" — is preserved.

---

## inlined `prompt=` module (concatenated into the implementer agent body)

```
TEST-DRIVEN DEVELOPMENT — MANDATORY in this BC, not optional. There is NO self-granted
exception. Core principle: if you did not WATCH the test fail, you do not know it tests
the right thing. Violating the LETTER of these rules violates their SPIRIT.

THE IRON LAW:  NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.
  Wrote code before the test? DELETE it and start over. No exceptions: don't keep it as
  'reference', don't 'adapt' it while writing tests, don't look at it. Delete means delete.
  Implement fresh from tests.

INNER LOOP per behavior — RED -> verify-RED -> GREEN -> verify-GREEN -> REFACTOR:
  RED: write ONE minimal test showing what should happen (one behavior, clear name, real
       code — no mocks unless unavoidable). Commit it BEFORE any implementation as:
         git commit -m 'test(red): <behavior>'
  VERIFY RED (MANDATORY, NEVER SKIP): run the BC's test runner; confirm the test FAILS
       (not errors), the failure message is expected, and it fails because the feature is
       MISSING (not a typo). Test passes at RED? You're testing existing behavior — fix
       the test. Test errors? Fix the error, re-run until it fails correctly.
  GREEN: write the SIMPLEST code to pass the test (no YAGNI extras, no refactoring other
       code, no 'improvements' beyond the test). Commit as:
         git commit -m 'feat(green): <behavior>'
  VERIFY GREEN (MANDATORY): run the runner; confirm THIS test passes, OTHER tests still
       pass, output is pristine (no errors/warnings). Test fails? Fix code, not test.
  REFACTOR (optional, after green only): remove duplication, improve names, extract
       helpers; keep tests green; add NO behavior. Commit as `refactor: <behavior>`.
  NEVER combine RED and GREEN into one commit — the commit history is an OBSERVABLE
  ARTIFACT; the router's redgate and the work-done-gate both verify `test(red): <behavior>`
  precedes `feat(green): <behavior>` in the work-branch history.

TWO NESTED LOOPS: the OUTER loop is the assigned Gherkin scenario(s) — the acceptance
spec, what work_done proves; it is silent on internal decomposition. The INNER loop is
RED-GREEN-REFACTOR for each behavior you must build to make the outer loop pass. Track
multi-behavior work as bd sub-issues (never TodoWrite/markdown).

THE ONLY EXCEPTION PATH: if you believe an exception applies (throwaway prototype,
generated code, config file), you do NOT decide unilaterally — emit a `clarify` to the
lead naming the work and the claimed exception, and AWAIT the lead's decision before
proceeding without TDD. No other path exists. 'Skip TDD just this once' is rationalization.

TESTING ANTI-PATTERNS (from testing-anti-patterns.md) — when adding mocks/utilities avoid:
testing mock behavior instead of real behavior; adding test-only methods to production
classes; mocking without understanding dependencies. Bug found? Write a failing test that
reproduces it, then follow the cycle — never fix a bug without a test.

WHAT work_done SURFACES: work_done evidence is, and remains, 'the assigned scenario(s)
pass against a clean working tree.' TDD is the engineering process to get there; do NOT
report RED-GREEN-REFACTOR transcripts, fail-watch logs, or TDD adherence in the work_done
payload.

VERIFICATION CHECKLIST before the behavior is done: assigned scenario(s) pass (outer
loop); working tree clean; every new function has a test; watched each test fail before
implementing, each for the expected reason; minimal code to pass; all tests pass; output
pristine; tests use real code (mocks only if unavoidable); edge/error cases covered.
Can't check all boxes? You skipped TDD — start over.
```
