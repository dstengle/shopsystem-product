# Mechanism Observation Prototype — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `mechanism_observation` BC → lead message and the BC-template discipline that makes BCs surface load-bearing mechanism observations during regular work, validated end-to-end across one full §4.4-shaped slice run.

**Architecture:** Extend the existing `catalog` package with one new Pydantic model; extend `shop-msg-bc/cli.py` with one new `respond` subcommand; revise the `bc-implementer` and `bc-reviewer` templates with a discriminator section. Each observation produces three artifacts: BC-side bead → catalog YAML message → lead-side drain bead. Beads are the within-shop registry; the catalog message is the wire; long-form analysis lives in bead notes/design fields.

**Tech Stack:** Python 3.11+, Pydantic v2, pytest + pytest-bdd, PyYAML, beads (`bd`) for issue tracking. All packages installed editable from `prototypes/message-catalog-v1/` per the existing setup (`pip install -e ./catalog -e ./scenarios -e ./shop-templates -e ./shop-msg-bc -e ./bc-shop`).

**Spec correction:** The design doc named the CLI verb as `shop-msg send mechanism_observation`. The verb has to be `respond` (BC → lead direction; matches `respond clarify` and `respond work_done`). When slice A closes, edit `prototypes/mechanism-observation-v1/design.md` to match.

---

## File map

**Modify (existing in `prototypes/message-catalog-v1/`):**

- `catalog/src/catalog/schemas.py` — add `MechanismObservation` class; extend `BCResponse` union
- `shop-msg-bc/src/shop_msg/cli.py` — add `_cmd_respond_mechanism_observation` and parser wiring
- `shop-msg-bc/tests/conftest.py` — add step definitions for new BDD scenarios
- `shop-templates/src/shop_templates/templates/bc-implementer.md` — add "Surfacing mechanism observations" section
- `shop-templates/src/shop_templates/templates/bc-reviewer.md` — add same section, Reviewer-flavored

**Create (in `prototypes/message-catalog-v1/`):**

- `catalog/tests/test_mechanism_observation.py` — schema-level tests for the new model
- `shop-msg-bc/features/respond_mechanism_observation.feature` — happy path
- `shop-msg-bc/features/respond_mechanism_observation_collision.feature` — outbox collision refuse
- `shop-msg-bc/features/respond_mechanism_observation_path_separator.feature` — bd_ref path-safety
- `shop-msg-bc/features/respond_mechanism_observation_short_body.feature` — body min-length

**Create (in `prototypes/mechanism-observation-v1/`):**

- `runs/slice-A/` — per-slice artifacts (inbox/outbox snapshots, bd outputs, dispatch reports)
- `runs/slice-B1/`, `runs/slice-B2/`, `runs/slice-B3/` (conditional), `runs/slice-C/`
- `lead-drain.md` — documented drain process (created during slice C)
- `findings.md` — cumulative narrative across slices
- `findings-from-mechanism-observation-v1.md` — final consolidation parallel to `findings-from-prototype-1.md`

---

## Task list

### Setup

#### Task 0: File the prototype as a beads epic

**Files:** none (beads only)

- [ ] **Step 1: Create the parent issue**

```bash
bd create --title "mechanism-observation-v1 prototype" --type=feature --priority=2 \
  --description "Validate MechanismObservation message + BC template discipline per prototypes/mechanism-observation-v1/design.md. Slices A, B1, B2, B3 (conditional), C." \
  --label mechanism-observation-v1
```

Note the issue id printed (e.g., `ddd-product-system-abc`). Reference it in subsequent slice issues as the parent.

- [ ] **Step 2: Confirm packages are installed editable**

```bash
shop-msg --help
scenarios --help
shop-templates list
```

Expected: each command prints help / list. If any errors with `command not found`, run from `prototypes/message-catalog-v1/`:

```bash
pip install -e ./catalog -e ./scenarios -e ./shop-templates -e ./shop-msg-bc -e ./bc-shop
```

---

### Slice A — Mechanism

**Goal:** `MechanismObservation` schema + `respond mechanism_observation` CLI work end-to-end. BC manually constructs an observation; round-trip via `shop-msg read outbox` succeeds; bead chain (BC bead ↔ message ↔ lead bead) exists and is queryable.

#### Task A1: Add `MechanismObservation` schema with rejection tests

**Files:**
- Create: `prototypes/message-catalog-v1/catalog/tests/test_mechanism_observation.py`
- Modify: `prototypes/message-catalog-v1/catalog/src/catalog/schemas.py`

- [ ] **Step 1: Write the failing happy-path test**

Create `prototypes/message-catalog-v1/catalog/tests/test_mechanism_observation.py`:

```python
"""Schema-level tests for MechanismObservation.

Per design slice A and prototype 1 finding 4 (input safety belongs in
the schema): every construction site (CLI, hand-rolled tests, future
automation) must hit the same validation. The CLI is not the gate.
"""
import pytest
from pydantic import ValidationError

from catalog.schemas import MechanismObservation


def test_mechanism_observation_minimal_fields_accepted() -> None:
    obs = MechanismObservation(
        message_type="mechanism_observation",
        bd_ref="ddd-product-system-abc",
        subject="bc-implementer template lacks under-asking discriminator",
        body=(
            "While doing lead-022 the template language did not give me a "
            "clear discriminator for whether to clarify or proceed; I had "
            "to fall back on heuristics that another implementer might "
            "interpret differently. Load-bearing because the next BC "
            "running this template will hit the same ambiguity."
        ),
    )
    assert obs.bd_ref == "ddd-product-system-abc"
    assert obs.observed_during is None
    assert obs.evidence is None
    assert obs.proposed_action is None


def test_bd_ref_with_path_separator_is_rejected() -> None:
    with pytest.raises(ValidationError) as excinfo:
        MechanismObservation(
            message_type="mechanism_observation",
            bd_ref="ddd/../etc/passwd",
            subject="anything",
            body="x" * 50,
        )
    assert "bd_ref" in str(excinfo.value)


def test_bd_ref_empty_is_rejected() -> None:
    with pytest.raises(ValidationError):
        MechanismObservation(
            message_type="mechanism_observation",
            bd_ref="",
            subject="anything",
            body="x" * 50,
        )


def test_bd_ref_must_have_suffix() -> None:
    # Regex requires at least one hyphen separating prefix from suffix.
    with pytest.raises(ValidationError):
        MechanismObservation(
            message_type="mechanism_observation",
            bd_ref="noseparator",
            subject="anything",
            body="x" * 50,
        )


def test_subject_too_short_is_rejected() -> None:
    with pytest.raises(ValidationError):
        MechanismObservation(
            message_type="mechanism_observation",
            bd_ref="ddd-product-system-abc",
            subject="hi",  # min length is 5
            body="x" * 50,
        )


def test_subject_too_long_is_rejected() -> None:
    with pytest.raises(ValidationError):
        MechanismObservation(
            message_type="mechanism_observation",
            bd_ref="ddd-product-system-abc",
            subject="x" * 121,  # max length is 120
            body="x" * 50,
        )


def test_body_too_short_is_rejected() -> None:
    # Minimum 50 chars prevents stub observations that carry no
    # explanation of what was observed or why it's load-bearing.
    with pytest.raises(ValidationError):
        MechanismObservation(
            message_type="mechanism_observation",
            bd_ref="ddd-product-system-abc",
            subject="anything",
            body="x" * 49,
        )


def test_optional_fields_round_trip() -> None:
    obs = MechanismObservation(
        message_type="mechanism_observation",
        bd_ref="ddd-product-system-abc",
        subject="anything",
        observed_during="lead-022",
        body="x" * 50,
        evidence=[
            "shop-templates/src/shop_templates/templates/bc-implementer.md:42",
            "catalog/src/catalog/schemas.py:155",
        ],
        proposed_action="Tighten the bc-implementer anti-rationalization section.",
    )
    assert obs.observed_during == "lead-022"
    assert len(obs.evidence) == 2
    assert obs.proposed_action.startswith("Tighten")


def test_evidence_must_be_non_empty_when_present() -> None:
    # Distinguish "no evidence" (None — field omitted) from "empty
    # evidence list" (presence-without-content; reject).
    with pytest.raises(ValidationError):
        MechanismObservation(
            message_type="mechanism_observation",
            bd_ref="ddd-product-system-abc",
            subject="anything",
            body="x" * 50,
            evidence=[],
        )
```

- [ ] **Step 2: Run test to confirm it fails**

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1/catalog
python3 -m pytest tests/test_mechanism_observation.py -v
```

Expected: ImportError or "MechanismObservation not defined" — class doesn't exist yet.

- [ ] **Step 3: Add the schema**

Modify `prototypes/message-catalog-v1/catalog/src/catalog/schemas.py`. Append after `WorkDone` (around line 167):

```python
class MechanismObservation(BaseModel):
    """BC -> lead observation about the shop-system mechanism itself.

    Surfaced alongside `work_done` (or, less commonly, ambient outside any
    directed work) when the BC notices something load-bearing about
    templates, schemas, role discipline, package boundaries, or the
    spec — anything that is mechanism-of-the-system rather than a
    property of the work item itself.

    Carve-outs per design (see `prototypes/mechanism-observation-v1/design.md`):
    - Property of the scenario / work item -> `clarify`
    - Implementation block -> `work_done(blocked)`
    - Mechanism-of-the-system -> `mechanism_observation`

    Three-artifact pattern: this message references a BC-side bead via
    `bd_ref`; the lead's drain creates a corresponding lead-side bead
    that references back. Long-form analysis lives in the bead's notes
    or design field, not in this message.
    """
    message_type: Literal["mechanism_observation"]
    # bd_ref is constrained to a beads issue-id shape: lowercase
    # alphanumerics and hyphens, with at least one hyphen separating
    # prefix (e.g. "ddd-product-system") from suffix (e.g. "abc").
    # Same path-safety reasoning as Clarify.work_id (lead-008): a CLI
    # flag is not the gate; the schema is.
    bd_ref: str = Field(min_length=1, pattern=r"^[a-z0-9-]+-[a-z0-9]+$")
    subject: str = Field(min_length=5, max_length=120)
    observed_during: str | None = None
    body: str = Field(min_length=50)
    evidence: list[str] | None = Field(default=None, min_length=1)
    proposed_action: str | None = None
```

Then update the `BCResponse` union near the bottom:

```python
BCResponse = Union[Clarify, WorkDone, MechanismObservation]
```

- [ ] **Step 4: Run tests to confirm they pass**

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1/catalog
python3 -m pytest tests/test_mechanism_observation.py -v
python3 -m pytest tests/ -v
```

Expected: all `test_mechanism_observation.py` tests pass; all `test_scenario_payload.py` tests still pass.

- [ ] **Step 5: Commit**

```bash
git add prototypes/message-catalog-v1/catalog/src/catalog/schemas.py \
        prototypes/message-catalog-v1/catalog/tests/test_mechanism_observation.py
git commit -m "$(cat <<'EOF'
mechanism-observation: add MechanismObservation schema

BC -> lead message for surfacing observations about the shop-system
mechanism (templates, schemas, role discipline). Schema-level
validation per finding 4: bd_ref regex enforces beads-id shape and
path safety; subject 5-120 chars; body min 50 chars to prevent stubs;
optional evidence list min length 1 when present.

Extends BCResponse union; no consumers updated yet (CLI subcommand is
the next task).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

#### Task A2: Add `shop-msg respond mechanism_observation` CLI happy path

**Files:**
- Create: `prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation.feature`
- Modify: `prototypes/message-catalog-v1/shop-msg-bc/tests/conftest.py`
- Modify: `prototypes/message-catalog-v1/shop-msg-bc/src/shop_msg/cli.py`

- [ ] **Step 1: Write the failing BDD scenario**

Create `prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation.feature`:

```gherkin
Feature: shop-msg respond — write a mechanism_observation outbox YAML

  @scenario_hash:PLACEHOLDER @bc:shop-msg
  Scenario: Reply with a mechanism_observation message
    Given an empty BC at a temporary path
    When I run shop-msg respond mechanism_observation with bd-ref "ddd-product-system-abc" and subject "template lacks discriminator" and body "While doing lead-022 the bc-implementer template did not give me a clear discriminator between two adjacent cases; I fell back on heuristic guessing that the next BC will likely interpret differently."
    Then the BC's outbox contains a file named "ddd-product-system-abc-mechanism_observation.yaml"
    And the file parses as a valid MechanismObservation with bd_ref "ddd-product-system-abc" and subject "template lacks discriminator"
```

Compute the real hash:

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1
scenarios hash < shop-msg-bc/features/respond_mechanism_observation.feature
```

Replace `PLACEHOLDER` with the hash output.

- [ ] **Step 2: Add the new step definitions to conftest.py**

Modify `prototypes/message-catalog-v1/shop-msg-bc/tests/conftest.py`. Add the `MechanismObservation` import to the existing import block:

```python
from catalog.schemas import (
    AssignScenarios,
    Clarify,
    MechanismObservation,
    RequestBugfix,
    RequestMaintenance,
    ScenarioPayload,
    WorkDone,
)
```

Append two new step definitions (path the file's existing structure — these go alongside the other `@when`/`@then` definitions):

```python
@when(
    parsers.re(
        r'I run shop-msg respond mechanism_observation with bd-ref '
        r'"(?P<bd_ref>[^"]*)" and subject "(?P<subject>[^"]*)" and '
        r'body "(?P<body>[^"]*)"'
    )
)
def run_respond_mechanism_observation(
    bc_root: Path, bd_ref: str, subject: str, body: str, context: dict
) -> None:
    result = subprocess.run(
        [
            "shop-msg", "respond", "mechanism_observation",
            "--bc-root", str(bc_root),
            "--bd-ref", bd_ref,
            "--subject", subject,
            "--body", body,
        ],
        capture_output=True,
        text=True,
    )
    context["cli_returncode"] = result.returncode
    context["cli_stdout"] = result.stdout
    context["cli_stderr"] = result.stderr


@then(
    parsers.re(
        r'the file parses as a valid MechanismObservation with '
        r'bd_ref "(?P<bd_ref>[^"]*)" and subject "(?P<subject>[^"]*)"'
    )
)
def file_parses_as_mechanism_observation(
    bc_root: Path, bd_ref: str, subject: str, context: dict
) -> None:
    # Use the bd_ref to find the file (matches the CLI's filename rule).
    path = bc_root / "outbox" / f"{bd_ref}-mechanism_observation.yaml"
    raw = yaml.safe_load(path.read_text())
    obs = MechanismObservation.model_validate(raw)
    assert obs.bd_ref == bd_ref
    assert obs.subject == subject
```

(`the BC's outbox contains a file named ...` is already defined in the existing conftest — reused, no new step needed.)

- [ ] **Step 3: Run BDD to confirm the scenario fails**

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1/shop-msg-bc
python3 -m pytest tests/ -v -k mechanism
```

Expected: failure because `shop-msg respond mechanism_observation` subcommand doesn't exist (CLI exits non-zero with usage error from argparse).

- [ ] **Step 4: Add the CLI subcommand**

Modify `prototypes/message-catalog-v1/shop-msg-bc/src/shop_msg/cli.py`. Add the import (around line 50):

```python
from catalog.schemas import (
    AssignScenarios,
    BCResponse,
    Clarify,
    MechanismObservation,
    RequestBugfix,
    RequestMaintenance,
    ScenarioPayload,
    WorkDone,
)
```

Add the new command function (place after `_cmd_respond_work_done`, around line 137):

```python
def _cmd_respond_mechanism_observation(args: argparse.Namespace) -> int:
    bc_root = Path(args.bc_root)
    outbox = bc_root / "outbox"
    outbox.mkdir(parents=True, exist_ok=True)

    out_path = outbox / f"{args.bd_ref}-mechanism_observation.yaml"
    if out_path.exists():
        # Refuse to overwrite. Same reasoning as the other respond
        # collision checks: the bd_ref identifies one observation
        # uniquely, and silently clobbering destroys the prior record.
        print(
            f"shop-msg respond mechanism_observation: refusing to overwrite "
            f"existing outbox file: {out_path}",
            file=sys.stderr,
        )
        return 1

    message = MechanismObservation(
        message_type="mechanism_observation",
        bd_ref=args.bd_ref,
        subject=args.subject,
        observed_during=args.observed_during,
        body=args.body,
        evidence=list(args.evidence) if args.evidence else None,
        proposed_action=args.proposed_action,
    )

    with out_path.open("w") as f:
        yaml.safe_dump(message.model_dump(exclude_none=True), f, sort_keys=False)
    return 0
```

Wire the subcommand into `build_parser` (in the `respond` block, after `work_done.set_defaults(...)` around line 357):

```python
    mech_obs = respond_sub.add_parser(
        "mechanism_observation",
        help="surface a BC observation about the shop-system mechanism",
    )
    mech_obs.add_argument("--bc-root", required=True, help="BC root directory")
    mech_obs.add_argument(
        "--bd-ref", required=True,
        help="BC-side beads issue id this observation references",
    )
    mech_obs.add_argument(
        "--subject", required=True,
        help="one-line summary; must equal the BC bead's title",
    )
    mech_obs.add_argument(
        "--body", required=True,
        help="markdown body: what was observed and why it's load-bearing",
    )
    mech_obs.add_argument(
        "--observed-during", default=None,
        help="lead-issued work_id the BC was working when this surfaced (optional)",
    )
    mech_obs.add_argument(
        "--evidence", action="append", default=None,
        help="verifiable pointer (file:line, template ref, package name); repeatable",
    )
    mech_obs.add_argument(
        "--proposed-action", default=None,
        help="BC's hypothesis for what to change (optional)",
    )
    mech_obs.set_defaults(func=_cmd_respond_mechanism_observation)
```

Update the module docstring at the top of `cli.py` to document the new subcommand. After the `respond work_done` block (lines 8-11), add:

```python
    respond mechanism_observation --bc-root PATH --bd-ref ID --subject TEXT
                                  --body TEXT [--observed-during ID]
                                  [--evidence TEXT ...] [--proposed-action TEXT]
        Writes <bc-root>/outbox/<bd_ref>-mechanism_observation.yaml as
        a valid MechanismObservation message. The BC must have already
        created a beads issue with id <bd_ref> capturing the same
        subject; this message is the wire carrier referencing it.
```

- [ ] **Step 5: Run BDD to confirm the scenario passes**

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1/shop-msg-bc
python3 -m pytest tests/ -v -k mechanism
```

Expected: pass. Then run the full suite to confirm no regressions:

```bash
python3 -m pytest tests/ -v
```

Expected: all scenarios pass.

- [ ] **Step 6: Commit**

```bash
git add prototypes/message-catalog-v1/shop-msg-bc/src/shop_msg/cli.py \
        prototypes/message-catalog-v1/shop-msg-bc/tests/conftest.py \
        prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation.feature
git commit -m "$(cat <<'EOF'
mechanism-observation: shop-msg respond mechanism_observation CLI

Adds the BC -> lead CLI surface for emitting MechanismObservation
messages. Writes <bc-root>/outbox/<bd_ref>-mechanism_observation.yaml.

BDD round-trip pinned: respond_mechanism_observation.feature.
Existing scenarios unregressed.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

#### Task A3: Pin outbox-collision refuse for `respond mechanism_observation`

**Files:**
- Create: `prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation_collision.feature`
- (No new step definitions — the existing `the BC's outbox already contains a file named ...`, `the command exits non-zero`, and the file-unchanged step from prior collision features cover this.)

- [ ] **Step 1: Write the failing scenario**

Create `prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation_collision.feature`. Model on `respond_clarify_collision.feature` — read that file first to get the exact step phrasings used for the collision and unchanged-check, then mirror them. Replace clarify-specific phrasings with mechanism_observation equivalents.

- [ ] **Step 2: Compute the @scenario_hash and replace the placeholder**

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1
scenarios hash < shop-msg-bc/features/respond_mechanism_observation_collision.feature
```

- [ ] **Step 3: Run BDD; expect pass (the CLI already implements collision-refuse)**

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1/shop-msg-bc
python3 -m pytest tests/ -v -k mechanism_observation_collision
```

Expected: pass. The collision-refuse logic was added in task A2 step 4; this task just pins the behavior.

- [ ] **Step 4: Commit**

```bash
git add prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation_collision.feature
git commit -m "mechanism-observation: pin outbox-collision refuse for respond mechanism_observation

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

#### Task A4: Pin schema-level rejections via the CLI

**Files:**
- Create: `prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation_path_separator.feature`
- Create: `prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation_short_body.feature`

These pin that the schema-level rejections from task A1 propagate through the CLI as non-zero exits — same pattern as `respond_clarify_path_separator.feature`. Two scenarios cover the two flagship invariants.

- [ ] **Step 1: Write `respond_mechanism_observation_path_separator.feature`**

Model on `respond_clarify_path_separator.feature` (read it first). The scenario:

```gherkin
Feature: shop-msg respond mechanism_observation — bd_ref input safety

  @scenario_hash:PLACEHOLDER @bc:shop-msg
  Scenario: Reject bd_ref containing a path separator
    Given an empty BC at a temporary path
    When I run shop-msg respond mechanism_observation with bd-ref "ddd/../etc-passwd" and subject "anything" and body "Body content of at least fifty characters to satisfy the schema's minimum length constraint."
    Then the command exits non-zero
    And no outbox files exist for the malformed bd_ref
```

You will need a new `@then` step `no outbox files exist for the malformed bd_ref` if it doesn't already exist; check `conftest.py` first. If absent, add it (it should glob `outbox` and assert empty).

Compute the hash and substitute.

- [ ] **Step 2: Write `respond_mechanism_observation_short_body.feature`**

```gherkin
Feature: shop-msg respond mechanism_observation — body min-length

  @scenario_hash:PLACEHOLDER @bc:shop-msg
  Scenario: Reject body shorter than the schema's minimum length
    Given an empty BC at a temporary path
    When I run shop-msg respond mechanism_observation with bd-ref "ddd-product-system-abc" and subject "anything" and body "too short"
    Then the command exits non-zero
```

Compute the hash and substitute.

- [ ] **Step 3: Run BDD**

```bash
cd /workspaces/ddd-product-system/prototypes/message-catalog-v1/shop-msg-bc
python3 -m pytest tests/ -v -k mechanism_observation
```

Expected: all four mechanism_observation scenarios pass.

- [ ] **Step 4: Commit**

```bash
git add prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation_path_separator.feature \
        prototypes/message-catalog-v1/shop-msg-bc/features/respond_mechanism_observation_short_body.feature \
        prototypes/message-catalog-v1/shop-msg-bc/tests/conftest.py
git commit -m "mechanism-observation: pin schema rejections via CLI (path-safety, body-length)

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

#### Task A5: End-to-end slice A run with a real observation

**Goal:** Drive one real observation through the entire three-artifact pattern. This is the slice-A pass-criteria gate from the design.

**Files:**
- Create: `prototypes/mechanism-observation-v1/runs/slice-A/` (directory + artifacts)

- [ ] **Step 1: Create the slice issue in beads**

```bash
bd create --title "slice-A: end-to-end mechanism_observation round-trip" \
  --type=task --priority=2 \
  --description "Drive one real observation through BC bead -> message -> lead bead. Pass: queryable bead chain; message YAML on disk; full \`bd list --label=mechanism-observation\` returns both beads." \
  --label mechanism-observation-v1
```

Note the slice issue id (referenced as `<slice-A-id>` below).

- [ ] **Step 2: Pick one real observation as the slice's content**

Read `docs/shop-system/findings-from-prototype-1.md` finding 2's caveat (asymmetric calibration of `clarify`'s anti-rationalization). That caveat IS a real load-bearing mechanism observation about the shop-system. Use it as the slice's worked example: a hypothetical BC dispatch noticed that the bc-implementer template's anti-rationalization section guards only against under-asking and not over-asking.

- [ ] **Step 3: Create the BC originating bead**

```bash
mkdir -p prototypes/mechanism-observation-v1/runs/slice-A
cd prototypes/message-catalog-v1/bc-shop  # use bc-shop as the surrogate BC

bd create --title "bc-implementer anti-rationalization is asymmetrically calibrated" \
  --type=task --priority=2 \
  --label mechanism-observation --label originated \
  --description "$(cat <<'EOF'
## What I observed

The bc-implementer template's anti-rationalization section
(currently lines ~150-167 of bc-implementer.md) lists five thought
patterns that should trigger asking. All five are framed against the
under-asking failure mode ("Asking would be theatre" -> STOP, ask).

There is no symmetric guard against over-asking — the case where the
implementer keeps clarifying when the message is in fact sufficient.
The "asking would be theatre" line could be read either direction
under load.

## Why it's load-bearing

Prototype 1 finding 2's own caveat names this as unvalidated. If
slice B2 of mechanism-observation-v1 puts a fresh BC subagent in
front of a sufficient message, the asymmetric calibration is the
likeliest path to a false-positive observation: the BC reaches for
mechanism_observation when nothing genuinely surfaced.

## What I tried

Re-read the template; the discriminator language for clarify is
clear in one direction only.

## Proposed action

Sharpen the anti-rationalization section with a parallel set of
over-asking guards before slice B2 dispatches.
EOF
)"
```

Capture the bead id printed (e.g., `ddd-product-system-xyz`) — referenced as `<bc-bead-id>`.

- [ ] **Step 4: Construct an empty BC root for the slice and emit the message**

```bash
SLICE_BC=/tmp/slice-A-bc
mkdir -p "$SLICE_BC/inbox" "$SLICE_BC/outbox"

shop-msg respond mechanism_observation \
  --bc-root "$SLICE_BC" \
  --bd-ref "<bc-bead-id>" \
  --subject "bc-implementer anti-rationalization is asymmetrically calibrated" \
  --body "The bc-implementer template's anti-rationalization section guards only the under-asking failure mode (lines ~150-167). There is no symmetric guard against over-asking — the case where the implementer clarifies when the message is sufficient. Slice B2 of mechanism-observation-v1 will likely surface this asymmetry as a false-positive observation channel unless the template gains parallel over-asking guards before dispatch." \
  --observed-during "lead-A1" \
  --evidence "shop-templates/src/shop_templates/templates/bc-implementer.md:150-167" \
  --evidence "docs/shop-system/findings-from-prototype-1.md:80-83" \
  --proposed-action "Add parallel over-asking guards to bc-implementer anti-rationalization before slice B2 dispatches."
```

Verify: `cat $SLICE_BC/outbox/<bc-bead-id>-mechanism_observation.yaml` shows valid YAML.

- [ ] **Step 5: Read it back via the lead-side CLI**

```bash
shop-msg read outbox --bc-root "$SLICE_BC" --work-id "<bc-bead-id>"
```

Wait — `shop-msg read outbox` currently uses `--work-id` and globs `<work_id>-*.yaml` (cli.py:300). Our filename is `<bd_ref>-mechanism_observation.yaml`, so passing `bd_ref` as `--work-id` works (the glob `<bd_ref>-*.yaml` matches). Confirm the read prints `valid mechanism_observation from ...`.

If it errors with a validation message about the union, that means `BCResponse` was not extended in task A1 — go back and confirm.

- [ ] **Step 6: Snapshot the artifacts**

```bash
cp $SLICE_BC/outbox/*.yaml prototypes/mechanism-observation-v1/runs/slice-A/
bd show <bc-bead-id> > prototypes/mechanism-observation-v1/runs/slice-A/bc-bead.txt
```

- [ ] **Step 7: Create the lead drain bead**

```bash
bd create --title "bc-implementer anti-rationalization is asymmetrically calibrated" \
  --type=task --priority=2 \
  --label mechanism-observation --label received \
  --description "Received from BC bead <bc-bead-id> via shop-msg respond mechanism_observation. Outbox file: prototypes/mechanism-observation-v1/runs/slice-A/<bc-bead-id>-mechanism_observation.yaml. Drain decision (slice C will formalize): defer until slice B2 — proposed action targets a template change that gates B2's hard-gate test."
```

Capture the lead-side bead id (`<lead-bead-id>`).

```bash
bd show <lead-bead-id> > prototypes/mechanism-observation-v1/runs/slice-A/lead-bead.txt
```

- [ ] **Step 8: Verify the queries return useful inventory**

```bash
bd list --label mechanism-observation
bd list --label mechanism-observation --label originated
bd list --label mechanism-observation --label received
```

Expected: first command lists both beads; second lists only the BC bead; third lists only the lead bead. Capture each output:

```bash
bd list --label mechanism-observation > prototypes/mechanism-observation-v1/runs/slice-A/bd-list-all.txt
bd list --label mechanism-observation --label originated > prototypes/mechanism-observation-v1/runs/slice-A/bd-list-originated.txt
bd list --label mechanism-observation --label received > prototypes/mechanism-observation-v1/runs/slice-A/bd-list-received.txt
```

- [ ] **Step 9: Close the slice in beads**

```bash
bd update <slice-A-id> --notes "Round-trip closed. BC bead <bc-bead-id>, lead bead <lead-bead-id>, message at runs/slice-A/<bc-bead-id>-mechanism_observation.yaml. Queries return expected inventory."
bd close <slice-A-id>
```

- [ ] **Step 10: Write the slice-A entry in `findings.md`**

Create `prototypes/mechanism-observation-v1/findings.md` with:

```markdown
# mechanism-observation-v1 findings

Cumulative narrative across slices. Each entry records what the slice
attempted, what the artifacts show, and the load-bearing-or-not
classification of any surprises.

---

## Slice A — Mechanism (closed)

**Goal.** End-to-end round-trip of one real `mechanism_observation`:
BC bead -> catalog message -> lead drain bead, with all artifacts
queryable from beads.

**Outcome.** Closed cleanly. The schema rejected malformed bd_ref
(path separator, missing suffix) and short body at construction time;
the CLI propagated the rejections as non-zero exits; the round-trip
read via `shop-msg read outbox` validated the message against the
extended `BCResponse` union without modification to that CLI.

**Surprise:** none. The infrastructure was a straight composition of
existing patterns.

**Artifacts:** `runs/slice-A/`.
```

- [ ] **Step 11: Commit slice A artifacts**

```bash
git add prototypes/mechanism-observation-v1/runs/slice-A/ \
        prototypes/mechanism-observation-v1/findings.md
git commit -m "$(cat <<'EOF'
mechanism-observation slice A: end-to-end round-trip closed

First real mechanism_observation: BC bead -> catalog message -> lead
drain bead, all queryable via `bd list --label mechanism-observation`.
Worked example carries the asymmetric-calibration observation from
prototype 1 finding 2's caveat, which directly informs slice B2's
hard-gate setup.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

- [ ] **Step 12: Edit the design doc to fix the CLI verb wording**

The design doc says `shop-msg send mechanism_observation` in two places. Edit `prototypes/mechanism-observation-v1/design.md`:
- Search for `shop-msg send mechanism_observation`
- Replace with `shop-msg respond mechanism_observation`

Commit:

```bash
git add prototypes/mechanism-observation-v1/design.md
git commit -m "mechanism-observation: design doc — correct CLI verb (respond, not send)

Send is reserved for lead-originated messages (writes to BC inbox).
Mechanism observations are BC-originated (write to BC outbox), so
the verb is respond, matching respond clarify and respond work_done.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

### Slice B1 — Discipline / under-emitting

**Goal:** A fresh BC subagent dispatched against a work item with a real load-bearing mechanism observation embedded reaches for `mechanism_observation` without being prompted by the driver.

**Important characteristic:** this slice may iterate. Per prototype 1's S2 → S2b precedent, expect 2–3 template revisions. Do NOT call slice B1 done after one passing dispatch unless the dispatch's report is convincing on substance (not just shape).

#### Task B1.1: Revise `bc-implementer` template with the discriminator

**Files:**
- Modify: `prototypes/message-catalog-v1/shop-templates/src/shop_templates/templates/bc-implementer.md`

- [ ] **Step 1: File the slice issue**

```bash
bd create --title "slice-B1: BC subagent under-emitting test for mechanism_observation" \
  --type=task --priority=2 \
  --label mechanism-observation-v1
```

- [ ] **Step 2: Add the "Surfacing mechanism observations" section**

Add to `prototypes/message-catalog-v1/shop-templates/src/shop_templates/templates/bc-implementer.md`. Insert after the existing "Hand-off to the Reviewer" section (around line 149) and before "Anti-rationalization":

```markdown
## Surfacing mechanism observations

Before you finish, ask: *did anything about the **mechanism** —
schema shape, role-template wording, sufficiency criteria, package
boundaries, the lead's instructions — strike you as
load-bearing-but-not-scope?*

If yes AND it's something a future BC dispatch or the lead would
want to know, surface it as a `mechanism_observation` alongside your
final message:

1. Create a beads issue capturing what you observed:

   ```
   bd create --title "<one-line subject>" --type=task --priority=2 \
     --label mechanism-observation --label originated \
     --description "<full markdown body: what was observed, why
     it's load-bearing, what you tried>"
   ```

2. Emit the wire message:

   ```
   shop-msg respond mechanism_observation \
     --bc-root <BC root> \
     --bd-ref <bead id from step 1> \
     --subject "<same as bead title>" \
     --body "<readable summary; long-form lives in the bead>" \
     [--observed-during <work_id>] \
     [--evidence <file:line> ...] \
     [--proposed-action <hypothesis>]
   ```

The mechanism_observation is emitted *in addition to* your
clarify/work_done message — it does not replace either.

### Carve-outs (use the right channel)

- A property of the scenario or work item itself (missing
  acceptance criterion, ambiguous work_id) → `clarify`, not a
  mechanism observation.
- An implementation block you cannot fix without further direction
  → `work_done(blocked)`, not a mechanism observation.
- Specifically about the mechanism of the system itself
  (templates, schemas, role discipline, packages, the spec) →
  `mechanism_observation`.

### When to NOT emit a mechanism observation

- Nothing genuinely load-bearing surfaced. Stating "no mechanism
  observations this dispatch" in your report is the right answer
  more often than not.
- The observation is a property of THIS work item only. That
  belongs in `clarify` or in your work_done summary, not as a
  mechanism finding.
- You "want to be helpful" by surfacing something. Helpfulness
  is not load-bearing. If the observation would be valuable to the
  next BC dispatch in the same way `clarify`'s anti-rationalization
  language is valuable, it qualifies. Otherwise it does not.
```

- [ ] **Step 3: Add the parallel over-asking guard to anti-rationalization**

This pre-emptively addresses slice A's surfaced observation (the asymmetric-calibration finding). Without this, slice B2 will likely fail because the template steers toward over-emitting.

Modify the existing anti-rationalization section in `bc-implementer.md` (around lines 152-167). Add after the existing five bullets:

```markdown
### When the message is sufficient — over-asking guards

The same anti-rationalization vigilance applies in the opposite
direction. When considering whether to emit `clarify` (or
`mechanism_observation`), watch for these thoughts. Each one is the
over-asking failure mode:

- *"Better safe than sorry — I'll clarify just in case."* — STOP.
  Read the message again. If the sufficiency check passes, proceed.
- *"This observation might be useful to someone."* — Vague utility
  is not load-bearing. Do not emit `mechanism_observation` to
  decorate your output.
- *"The lead probably wants me to flag this."* — The discriminator
  is in the message and the template, not in your guess about the
  lead's preferences.
- *"Asking shows I'm being thorough."* — Asking is theatre when
  the message is sufficient. Theatre wastes the lead's time.

Sufficiency checks are bidirectional. Failing one of the bullets
above is the same kind of failure as missing the under-asking guard.
```

- [ ] **Step 4: Commit the template revision**

```bash
git add prototypes/message-catalog-v1/shop-templates/src/shop_templates/templates/bc-implementer.md
git commit -m "$(cat <<'EOF'
mechanism-observation: bc-implementer template — add observation discriminator

Adds "Surfacing mechanism observations" section with carve-outs
distinguishing mechanism_observation from clarify and work_done(blocked).
Adds parallel over-asking guards to anti-rationalization section,
addressing slice-A's observed asymmetric calibration.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

#### Task B1.2: Revise `bc-reviewer` template

**Files:**
- Modify: `prototypes/message-catalog-v1/shop-templates/src/shop_templates/templates/bc-reviewer.md`

- [ ] **Step 1: Add the "Surfacing mechanism observations" section**

Append a new section to `bc-reviewer.md` after "Outcomes" (around line 96) and before "Anti-rationalization". The Reviewer-flavored version emphasizes that observations about the *Reviewer's* probing process or template are themselves valid:

```markdown
## Surfacing mechanism observations

If your adversarial probing surfaces something load-bearing about
the **mechanism** itself — your own template's ambiguities, the
schema's gaps, role-discipline failure modes you noticed in the
Implementer's behavior, package-boundary violations — surface it as
a `mechanism_observation` alongside your work_done/clarify message
(see the Implementer template's "Surfacing mechanism observations"
section for the bd + shop-msg sequence).

### Reviewer-specific carve-outs

- A scenario gap (the assigned scenarios don't pin a behaviorally
  important case) → `clarify`, the canonical §4.4 path. Not a
  mechanism observation.
- An implementation gap (the scenarios are fine, the code is wrong)
  → `work_done(status=blocked)`. Not a mechanism observation.
- A pattern in HOW the Implementer reasoned that suggests the
  template's anti-rationalization language fails in some new way
  → `mechanism_observation`. Pin specifically what the template
  language let through.
- Your own probing process surfaced a weakness in the Reviewer
  template (e.g., "I almost dismissed an adjacent case because the
  template doesn't tell me to ask whether reverse cases were pinned")
  → `mechanism_observation`.

### When to NOT emit

Same negative carve-outs as the Implementer: nothing genuinely
load-bearing surfaced; the observation is about THIS scenario
only; or the temptation is "want to be thorough" rather than
"would be load-bearing for the next BC."
```

- [ ] **Step 2: Commit**

```bash
git add prototypes/message-catalog-v1/shop-templates/src/shop_templates/templates/bc-reviewer.md
git commit -m "mechanism-observation: bc-reviewer template — add observation section

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

#### Task B1.3: Construct the slice-B1 work item

**Files:**
- Create: `prototypes/mechanism-observation-v1/runs/slice-B1/work-item.md`

The work item must be a *real* maintenance/bugfix request to the BC such that, in the natural course of doing the work, a load-bearing mechanism observation surfaces. The temptation is to construct an artificial work item designed to trigger an observation; that's overly contrived and produces a poor validation. Better: pick an actual gap in `bc-shop` that needs filling, where doing the work will surface something true about the templates or schemas.

- [ ] **Step 1: Pick a real gap in `bc-shop`**

Read `prototypes/message-catalog-v1/bc-shop/src/temperature.py` and `prototypes/message-catalog-v1/bc-shop/tests/`. Find a real maintenance task — for example, adding a new conversion (Kelvin), or pinning an unpinned input-validation behavior. Pick one whose work could plausibly surface a mechanism observation (e.g., the work involves writing a step definition where the existing patterns are ambiguous, or it touches a schema field whose validation feels under-specified).

- [ ] **Step 2: Draft the work item**

Write `prototypes/mechanism-observation-v1/runs/slice-B1/work-item.md` describing:
- The work item content (description + acceptance criteria — sufficient per existing template; this is NOT a clarify-trigger)
- The mechanism observation that's plausibly available during the work (don't tell the BC about it; the slice tests whether they reach for it)
- The hypothesis: which template lines should make the BC notice + emit

- [ ] **Step 3: Commit the work-item description**

```bash
git add prototypes/mechanism-observation-v1/runs/slice-B1/work-item.md
git commit -m "mechanism-observation slice B1: work item drafted

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

#### Task B1.4: Dispatch the BC subagent

**Files:**
- Create: `prototypes/mechanism-observation-v1/runs/slice-B1/dispatch-1/` (directory + dispatch report + outbox snapshot)

This task is executed by the driver (you-as-orchestrator), not by another subagent. Use the Task tool with the bc-implementer template.

- [ ] **Step 1: Set up the slice's BC root**

```bash
SLICE_BC=/tmp/slice-B1-bc
rm -rf "$SLICE_BC"
cp -r prototypes/message-catalog-v1/bc-shop "$SLICE_BC"
mkdir -p "$SLICE_BC/inbox" "$SLICE_BC/outbox"
```

- [ ] **Step 2: Send the work-item message**

```bash
shop-msg send request_maintenance \
  --bc-root "$SLICE_BC" \
  --work-id lead-B1-001 \
  --description "<from work-item.md>" \
  --acceptance-criterion "<...>" \
  [--acceptance-criterion "<...>"]
```

- [ ] **Step 3: Dispatch the BC implementer subagent**

Use the Task tool. Tool input:
- `subagent_type`: general-purpose (no specialized agent for this)
- `prompt`: the full bc-implementer template (`shop-templates show bc-implementer`) PLUS dispatch context: BC root path, brief on what tools are available

Capture the subagent's final report.

- [ ] **Step 4: Snapshot all artifacts**

```bash
mkdir -p prototypes/mechanism-observation-v1/runs/slice-B1/dispatch-1
cp -r "$SLICE_BC/outbox" prototypes/mechanism-observation-v1/runs/slice-B1/dispatch-1/
# Save the subagent's final report:
# (copy from your terminal / save the Task tool's response text)
echo "<subagent report>" > prototypes/mechanism-observation-v1/runs/slice-B1/dispatch-1/report.md
```

- [ ] **Step 5: Evaluate the outcome**

PASS criteria (all must hold):
- An outbox file named `<bd_ref>-mechanism_observation.yaml` exists.
- The observation's body is substantive (not theatre): describes a real load-bearing observation about the mechanism, not "I noticed the work was straightforward."
- The observation is *not* about the work item itself (carve-out check).

FAIL modes (any one triggers iteration):
- BC emitted only `work_done`, no mechanism_observation, when the work item had a naturally available observation.
- BC emitted mechanism_observation with theatre body.
- BC misclassified — emitted mechanism_observation when `clarify` or `work_done(blocked)` was the right channel.

- [ ] **Step 6: If PASS, write the slice-B1 findings entry and proceed to B2**

Append to `prototypes/mechanism-observation-v1/findings.md`:

```markdown
## Slice B1 — Discipline / under-emitting (closed)

**Goal.** Fresh BC subagent dispatched against a work item with a
naturally-available mechanism observation reaches for
`mechanism_observation` without being prompted.

**Outcome.** [Pass on dispatch N. Body substance: ... Surface
that triggered the observation: ...]

**Iterations:** [number of dispatches needed; what was revised
between them, if anything]

**Artifacts:** `runs/slice-B1/dispatch-N/`
```

Commit and proceed to slice B2.

- [ ] **Step 7: If FAIL, iterate**

The fail mode determines the next move:

- **No mechanism_observation emitted but one was available:** the discriminator language did not register as relevant under load. Revise `bc-implementer.md` "Surfacing mechanism observations" to make the trigger language more specific. Common patterns from prototype 1 S2 → S2b: name the failure mode in concrete terms ("if you fell back on a heuristic the next implementer might interpret differently, that is a mechanism observation").
- **Theatre body:** the carve-out for "want to be helpful" did not catch. Sharpen "When to NOT emit" with a sharper anti-rationalization line.
- **Wrong channel:** the carve-outs for clarify/work_done(blocked) were not load-bearing for the BC. Restate them with sharper examples.

After revising, dispatch a *fresh* subagent (do not continue the same one) against the SAME work item:

```bash
mkdir -p prototypes/mechanism-observation-v1/runs/slice-B1/dispatch-2
# repeat steps 1-5
```

Cap iterations at 4 dispatches. If dispatch 4 still fails, the slice is blocked — escalate via `clarify` to the driver: "the discriminator language does not consistently produce the right behavior; what's the next move?" This is a real outcome, not a failure mode.

---

### Slice B2 — Discipline / over-emitting (HARD GATE)

**Goal:** A fresh BC subagent dispatched against a work item with NO naturally-available mechanism observation does NOT emit `mechanism_observation`. The carve-outs hold under empty conditions.

This slice is the design's hard gate. Per finding 2 caveat, prototype 1 shipped without validating `clarify`'s over-asking side, and we are deliberately not repeating that. B2 must close before slice C runs.

#### Task B2.1: Construct the slice-B2 work item

**Files:**
- Create: `prototypes/mechanism-observation-v1/runs/slice-B2/work-item.md`

- [ ] **Step 1: File the slice issue**

```bash
bd create --title "slice-B2: BC subagent over-emitting test for mechanism_observation (HARD GATE)" \
  --type=task --priority=2 \
  --label mechanism-observation-v1
```

- [ ] **Step 2: Pick a real maintenance task with NO mechanism observation available**

Pick something obviously routine: adding a new test case for an already-pinned behavior, fixing a typo in a docstring, renaming an internal variable. The work must be *sufficient* (acceptance criteria clear, no scenario ambiguity) AND *unsurprising* (the BC's templates and schemas are well-fitted to this kind of work; nothing load-bearing should surface).

- [ ] **Step 3: Commit the work item**

Same as B1.3 step 3.

#### Task B2.2: Dispatch and evaluate

Same shape as B1.4. PASS / FAIL criteria flipped:

PASS:
- BC emitted `work_done` only (or `clarify` if the work was actually unclear, which would mean the work-item construction was wrong — start over).
- BC's report explicitly states "no mechanism observations this dispatch" or equivalent.
- No `mechanism_observation` outbox file exists.

FAIL:
- BC emitted a `mechanism_observation`. The body's content determines what to revise:
  - Theatre body ("the work was straightforward, the templates worked well") → "When to NOT emit" carve-outs need sharpening.
  - Genuinely load-bearing body (the BC found a real mechanism issue you missed) → the work item was wrong; reconstruct.

Iterate up to 4 dispatches per the same cap rule.

**Slice B2 is closed only when one full dispatch produces NO observation AND the BC's report explicitly addresses the carve-out.** A silent absence of mechanism_observation is not the same as a documented "no observations this dispatch" — the latter is the pass.

---

### Slice B3 — Near-miss (conditional)

**Run B3 only if any of the following hold:**
- B1 or B2 surfaced ambiguity about which carve-out applies.
- A template revision in B1/B2 created a new ambiguity between mechanism_observation and clarify or work_done(blocked).
- The driver judges the carve-outs unproven without an explicit positive test.

If none hold, document the skip in `findings.md` and proceed to slice C.

#### Task B3.1: Construct two near-miss work items

**Files:**
- Create: `prototypes/mechanism-observation-v1/runs/slice-B3/work-item-clarify.md`
- Create: `prototypes/mechanism-observation-v1/runs/slice-B3/work-item-blocked.md`

- [ ] **Step 1: Work item where the right answer is `clarify`**

A scenario-level gap that the BC could mistakenly read as a mechanism issue. For example: a `request_bugfix` description that ambiguously identifies which scenario to tighten.

- [ ] **Step 2: Work item where the right answer is `work_done(blocked)`**

A scenario that pins behavior the implementation gets wrong, and the wrongness is a real implementation bug (not a template/schema gap).

#### Task B3.2: Dispatch each work item and evaluate

PASS:
- Clarify work item produces `clarify`, no mechanism_observation.
- Blocked work item produces `work_done(status=blocked)`, no mechanism_observation.

FAIL:
- Either work item produces mechanism_observation. Carve-out language needs revision.

Iterate per the same cap rule.

---

### Slice C — Lead drain

**Goal:** Documented lead-side drain process; lead-side bd inventory has consistent shape across all observations from slices A, B1, and (if run) B3; a fresh reader can pick up the inventory.

#### Task C1: Define the drain process document

**Files:**
- Create: `prototypes/mechanism-observation-v1/lead-drain.md`

- [ ] **Step 1: File the slice issue**

```bash
bd create --title "slice-C: lead drain — formalize the per-observation action" \
  --type=task --priority=2 \
  --label mechanism-observation-v1
```

- [ ] **Step 2: Draft the drain process**

Write `prototypes/mechanism-observation-v1/lead-drain.md`:

```markdown
# Lead drain process for mechanism_observation

The lead drains its outbox of received mechanism observations on a
defined cadence. Cadence is a lead-side decision; a default is
"once per slice closure" for a prototype-scale shop.

## Per-observation procedure

For each `<bc-bead-id>-mechanism_observation.yaml` in any BC's outbox:

1. **Read the message:**
   `shop-msg read outbox --bc-root <bc-root> --work-id <bc-bead-id>`

2. **Read the BC bead** for full context:
   `bd show <bc-bead-id>`

3. **Classify** into one of three drain outcomes (see below).

4. **Create the lead-side bead:**
   ```
   bd create --title "<subject>" --type=task --priority=<see classification> \
     --label mechanism-observation --label received --label <outcome-label> \
     --description "Received from BC bead <bc-bead-id>; outbox file <path>. \
     Classification: <outcome>. Reasoning: <one-paragraph why>."
   ```

5. **Update the BC's outbox** by moving the file to a `processed/`
   subdirectory (so the next drain pass doesn't re-process):
   ```
   mkdir -p <bc-root>/outbox/processed
   mv <bc-root>/outbox/<bc-bead-id>-mechanism_observation.yaml \
      <bc-root>/outbox/processed/
   ```

## Drain outcomes

### Act
Lead-side work follows. The next concrete action is one of:
- A spec edit (a §-level change to docs/shop-system/*.md)
- A template revision (a change to bc-implementer.md or bc-reviewer.md)
- A schema change (a Pydantic constraint added/changed in catalog/)
- An `assign_scenarios` or `request_bugfix` to a BC

The lead bead carries label `act-spec` / `act-template` /
`act-schema` / `act-bc` accordingly. Priority: 1-2 (high enough to
surface in `bd ready`).

### Park
The observation is true and noted but not currently load-bearing
enough to act. The bead stays open with label `parked` and a clear
"revisit-when-X" condition in the description. Priority: 3-4.

### Forward
The observation is load-bearing for a different shop-group (e.g.,
the shop-system maintainer if THIS shop-group is using the
shop-system as a supporting domain). Cross-shop-group routing is
out of scope for this prototype, so this bead carries label
`forwarded-manual` and a description capturing the destination and
the manual hand-off mechanism (email, ticket, etc).

## When the drain is done

After all received observations are classified and labeled, run:

```bash
bd list --label mechanism-observation --label received
bd list --label mechanism-observation --label received --label parked
bd list --label mechanism-observation --label received --label act-template
# etc., one query per outcome label
```

Confirm every received observation has at least one outcome label.
Save the inventory to `runs/slice-C/drain-inventory.txt`.
```

- [ ] **Step 3: Commit**

```bash
git add prototypes/mechanism-observation-v1/lead-drain.md
git commit -m "mechanism-observation slice C: documented drain process

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

#### Task C2: Run the drain on accumulated observations

**Files:**
- Create: `prototypes/mechanism-observation-v1/runs/slice-C/drain-inventory.txt`

- [ ] **Step 1: Walk the per-observation procedure**

For each lead-side bead created during slices A, B1, and (if run) B3, apply the drain procedure from C1. Each lead bead from those slices was created with `--label received` only (no outcome label yet); slice C adds the outcome label and any procedure steps that weren't done during the originating slice.

- [ ] **Step 2: Save the drain inventory**

```bash
mkdir -p prototypes/mechanism-observation-v1/runs/slice-C
{
  echo "=== All received ==="
  bd list --label mechanism-observation --label received
  echo
  echo "=== By outcome ==="
  for outcome in act-spec act-template act-schema act-bc parked forwarded-manual; do
    echo "--- $outcome ---"
    bd list --label mechanism-observation --label received --label "$outcome"
  done
} > prototypes/mechanism-observation-v1/runs/slice-C/drain-inventory.txt
```

- [ ] **Step 3: Verify every received observation is classified**

```bash
# Sanity: count of received minus count of those with at least one outcome
# label should equal zero. Manual check via:
bd list --label mechanism-observation --label received | wc -l
bd list --label mechanism-observation --label received --label act-spec | wc -l
bd list --label mechanism-observation --label received --label act-template | wc -l
bd list --label mechanism-observation --label received --label act-schema | wc -l
bd list --label mechanism-observation --label received --label act-bc | wc -l
bd list --label mechanism-observation --label received --label parked | wc -l
bd list --label mechanism-observation --label received --label forwarded-manual | wc -l
```

The sum of the per-outcome counts must equal the total received count. If lower, some observation has no outcome label — go back and classify it.

- [ ] **Step 4: Commit**

```bash
git add prototypes/mechanism-observation-v1/runs/slice-C/
git commit -m "mechanism-observation slice C: drain inventory after walk-through

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
```

---

### Final consolidation

#### Task F1: Write the cumulative findings doc

**Files:**
- Create: `prototypes/mechanism-observation-v1/findings-from-mechanism-observation-v1.md`

- [ ] **Step 1: Draft the consolidation**

Model on `docs/shop-system/findings-from-prototype-1.md`. Sections:

1. The mechanism_observation message rounds out the catalog (analog of finding 1).
2. The observation discriminator is a per-template discipline — what worked, what didn't (analog of finding 2).
3. Lead drain mechanism — three outcomes are sufficient at this scale (or not, if slice C surfaced gaps).
4. Schema-level invariants on MechanismObservation (analog of finding 4 — bd_ref regex + body length).
5. Three-artifact pattern: bead + message + bead is durable, queryable, and dogfooded against beads (analog of findings 6 + 7).
6. What is NOT yet validated — the items the prototype deferred or did not surface.
7. Implications for the next prototype.

Each section: Claim, Evidence (cite specific slices), Caveats, Implication for spec.

- [ ] **Step 2: Commit and close the parent issue**

```bash
git add prototypes/mechanism-observation-v1/findings-from-mechanism-observation-v1.md
git commit -m "$(cat <<'EOF'
mechanism-observation: consolidated findings from prototype slices A-C

Cumulative claims from slices A, B1, B2, (B3), and C, in the same
shape as findings-from-prototype-1.md. Each claim cites its slice
evidence and names the spec or template the durable claim should
land in. Input artifact for the spec edit pass and for the next
prototype's design.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"

bd close <parent-issue-id-from-task-0>
```

- [ ] **Step 3: Push to remote per session-close protocol**

```bash
git pull --rebase
bd dolt push
git push
git status  # MUST show "up to date with origin"
```

---

## Self-review

Run before handing off to execution:

1. **Spec coverage:** every "in scope" item in the design has at least one task. Schema (A1), CLI (A2-A4), bead conventions (A5, B1.4, C2), drain (C1, C2), template revisions (B1.1, B1.2), slice progression (A through C), findings consolidation (F1). ✓
2. **Placeholders:** the work-item content for slices B1 and B2 is intentionally not pre-specified — the slice's success depends on the work item being a real maintenance task picked from the BC's actual state at execution time, not a contrived setup. The plan's task descriptions name the criteria the work item must satisfy. This is a deliberate gap, not a placeholder failure: pre-specifying would defeat the validation. ✓
3. **Type/name consistency:** `MechanismObservation` (class), `mechanism_observation` (message_type literal, CLI subcommand, label), `mechanism-observation` (label hyphenation), `bd_ref` (field) — verified consistent across A1, A2, A5, conftest.py changes, and template snippets. ✓
4. **CLI verb:** `respond` (not `send`) — corrected inline (task A5 step 12 fixes the design doc). ✓

## Known plan-execution risks

1. **Slice B is the long pole.** Per prototype 1's S2 → S2b precedent, expect 2–3 dispatches per direction (B1 + B2 ≈ 4–6 total dispatches). Budget time accordingly.
2. **B3 conditionality is a judgment call.** The criteria for running B3 are listed but the call is the driver's. When in doubt, run B3 — finding 3's caveat about untested branches is the cautionary precedent.
3. **The work-item picks for B1 and B2 are critical.** A bad pick produces a bad slice. If the first dispatch's outcome looks confounded by work-item construction, redo the work-item before iterating on templates.
4. **Beads dolt push** at session end may show "branch ahead" — that's normal; resolve via `git pull --rebase` then `git push` per the project's CLAUDE.md.
