@bc:shopsystem-bc-launcher @origin:lead-gfqvi
Feature: the schema-skew heal ABORTS rather than rebuilding when a readable pre-heal export is NOT a subset of the committed issues.jsonl, so the heal never silently drops issues in either direction (durable P0 regression fix for lead-wpnv3)

  ROOT CAUSE (lead-wpnv3, P0, empirical 2026-07-15, shopsystem-bc-launcher's
  own dogfooded schema-skew heal on its wedged tracker): the heal pinned at
  scenario_hash fbf7480ef25f766c in
  standup_heals_beads_schema_wall_reseed_from_jsonl.feature states the
  rebuild's authoritative SOURCE OF TRUTH is the committed
  ".beads/issues.jsonl", unconditionally, with the only named negative case
  being "pre-heal export UNREADABLE -> proceed from jsonl". That pin is
  UNSAFE when the pre-heal export IS readable but carries issues the
  committed jsonl does not (normal steady-state drift between commits): the
  heal silently dropped 26 issues (including two complete epics) by
  rebuilding from the stale 330-issue committed jsonl over the correct
  356-issue pre-heal export.

  SHIPPED FIX (commit 64bb2f1, reconciled on lead-wpnv3): before rebuilding,
  the heal compares the pre-heal export's issue ID set against the committed
  jsonl's ID set. Rebuild proceeds ONLY when the export's ID set is a SUBSET
  of the committed jsonl's ID set (i.e. the committed jsonl is a proven
  superset and no export-only issue would be dropped). When the export is
  readable but NOT a subset -- the export carries at least one issue absent
  from the committed jsonl -- the heal does NOT blindly rebuild from either
  side (neither the original committed-jsonl-only bug, nor an unproven
  rebuild-from-export, which the BC found not symmetric-safe against the
  opposite drift direction). Instead the heal ABORTS before any destructive
  step, names the specific at-risk issue ids and their count, and directs
  the operator to the recovery runbook.

  RELATIONSHIP TO THE EXISTING STANDUP-HEAL REGISTER: this SHARPENS
  scenario_hash fbf7480ef25f766c in
  standup_heals_beads_schema_wall_reseed_from_jsonl.feature, whose only
  negative case (export UNREADABLE -> proceed from jsonl) remains correct
  and is preserved unmodified. This scenario ADDS the narrower, previously
  UNPINNED negative case: export READABLE but NOT a subset of the committed
  jsonl -> ABORT. It is CONSISTENT WITH scenario_hash dc9a29a746921a14's
  general rebuild-and-online happy path (the ordinary case where the export
  IS a subset, or the heal proceeds from jsonl with no drift, continues to
  reach "bd ready" online exactly as already pinned there) and with
  scenario_hash 5765dd7d175901e3's lead-role refusal. It does not retire or
  contradict any existing pin -- purely additive.

  BEHAVIOR ALTITUDE: this pins the OBSERVABLE OUTCOME -- no destructive
  step taken, the specific at-risk ids and their count named in the abort
  output, the recovery runbook cited, nonzero exit, live local database and
  every issue left intact -- WITHOUT prescribing the exact ID-set-comparison
  code sequence (named above only as the proven shipped reference, commit
  64bb2f1).

  FIDELITY (ADR-018): binds to the standup's executable beads-provisioning
  self-heal orchestration -- the pre-heal export capture, the ID-set subset
  comparison, and the abort-before-destructive-step ordering -- read against
  the create-bc / bc-container standup definition and the BC's reconciled
  fix (commit 64bb2f1, regression test replicating the 356/330/26 incident
  shape), NOT a live container or GitHub run.

  @scenario_hash:c1236f6f55c639f8
  Scenario: the schema-skew heal ABORTS before any destructive step when a readable pre-heal export is NOT a subset of the committed issues.jsonl, naming the specific at-risk issue ids
    Given the standup's schema-skew heal has taken a full pre-heal export that is READABLE
    And the pre-heal export's issue ID set is NOT a subset of the committed ".beads/issues.jsonl"'s issue ID set, so at least one issue present in the export is absent from the committed jsonl
    When the heal evaluates whether to proceed with the rebuild
    Then the heal ABORTS before any destructive step, performing NEITHER a rebuild from the committed jsonl NOR a rebuild from the pre-heal export
    And the heal's abort output names the specific at-risk issue ids and their count that are present in the pre-heal export but absent from the committed jsonl
    And the heal's abort output directs the operator to the recovery runbook "docs/runbooks/beads-schema-skew-recovery.md"
    And the heal exits nonzero, leaving the live local dolt database and every issue intact and unmodified
