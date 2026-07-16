@bc:unassigned @origin:brief-023
Feature: shopsystem-knowledge — the coherence gate ships as a lead-installable CLI over a real filesystem corpus (ADR-018 D2 contract tool)

  The coherence gate's check logic — the always-on typed-edge floor
  (coherence_gate_typed_edges.feature) and the artifact-lifecycle rules
  (coherence_gate_lifecycle_rules.feature), reported in the advisory/blocking
  doctor form (coherence_gate_advisory_blocking.feature) — is already fully
  pinned. What has never existed is a way to actually RUN those checks: every
  one of their Given clauses assumes an already-parsed "artifact corpus" with
  no description of where that corpus comes from. `shop-knowledge` exposes no
  command that walks a real directory tree at all — `shop-knowledge validate`
  "takes exactly one document path" (confirmed by direct invocation,
  2026-07-16) and there is no aggregate/corpus mode. lead-bead lead-iohr
  names the missing piece precisely: a lead-installable `[project.scripts]`
  entrypoint plus a filesystem corpus loader, so the ROUTER can run the gate
  lead-side over the lead's own held artifacts (ADR-018 D2 — this corpus
  lives only on the lead host; a BC structurally cannot see it, the lesson
  `lead-5oih` paid for by being mis-scoped and closed as a dispatch-to-BC
  attempt to run the gate over lead-held text). This feature pins that
  missing CLI-and-loader surface — not new check rules, which already exist
  and require no further authoring.

  A second, load-bearing gap the loader must resolve honestly: almost this
  entire real corpus is still legacy prose with no YAML frontmatter at all
  (only one pdr, PDR-034, currently carries real frontmatter; every other
  pdr/adr instance, including the two PDR-034's own frontmatter names —
  pdr-032 via `supersedes: [pdr-032]`, and pdr-032/pdr-033/adr-059 via
  current-state.md's `incorporates: [pdr-032, pdr-033, adr-059]` — is
  legacy). The already-pinned typed-edge and lifecycle checks assume both
  sides of an edge are typed; they say nothing about a target that exists as
  a file but carries no frontmatter to check. Treating that case as either a
  silent pass (hides a real, uncheckable claim) or a hard violation
  (fabricates a defect the legacy corpus's own out-of-scope migration,
  cand-005 Phase 5, is what will actually fix) would both be wrong. This
  feature pins the honest third verdict: unverifiable-legacy, reported and
  advisory, never blocking authoring mode by itself — consistent with the
  same newly-added/pre-existing split `bin/check-knowledge-artifacts`
  (cand-005 Phase 3) already applies for the identical reason.

  @scenario_hash:25628c9bd2e401d6
  Scenario: the gate command walks a real directory tree and feeds typed documents into the already-pinned checks
    Given a corpus root directory containing a pdr file whose frontmatter declares a supersedes edge to a second pdr file
    And that second pdr file's frontmatter carries a superseded-by edge back to the first
    When the operator runs the knowledge context's installed coherence-gate command over the corpus root directory
    Then it reports no asymmetric-supersede finding for the pair
    And the aggregate verdict exits zero

  @scenario_hash:5184003b24ca939e
  Scenario: a supersedes edge to a target file with no YAML frontmatter is reported unverifiable-legacy, not dangling or asymmetric
    Given a corpus root directory containing a pdr file whose frontmatter declares supersedes: [pdr-032]
    And a file named pdr-032 present in the corpus root directory carrying no YAML frontmatter at all
    When the operator runs the knowledge context's installed coherence-gate command over the corpus root directory
    Then it reports the edge as an unverifiable-legacy finding naming the pdr and pdr-032 by id
    And it reports no dangling-edge finding for that edge, because pdr-032 resolves to a real file
    And it reports no asymmetric-supersede finding for that edge, because pdr-032 has no frontmatter that could carry a superseded-by field
    And the unverifiable-legacy finding does not by itself drive the aggregate verdict non-zero

  @scenario_hash:bfb4ce1264d5021c
  Scenario: a current-state incorporates claim naming a legacy decision is reported unverifiable-legacy, not as an unincorporated-decision violation
    Given a corpus root directory containing a current-state.md file whose frontmatter declares incorporates: [pdr-032, pdr-033, adr-059]
    And pdr-032, pdr-033, and adr-059 are each present in the corpus root directory as files carrying no YAML frontmatter
    When the operator runs the knowledge context's installed coherence-gate command over the corpus root directory
    Then it reports each of the three incorporates edges as an unverifiable-legacy finding naming current-state and the legacy target by id
    And it reports no unincorporated-decision finding for any of the three, because their accepted status cannot yet be machine-read
    And none of the three unverifiable-legacy findings by themselves drive the aggregate verdict non-zero

  @scenario_hash:d0f0ad4d25aa409a
  Scenario: a link-field target with no corresponding file anywhere in the corpus is still reported dangling, distinct from the legacy case
    Given a corpus root directory containing an artifact whose frontmatter declares a supersedes edge to an id with no corresponding file anywhere in the corpus root directory
    When the operator runs the knowledge context's installed coherence-gate command over the corpus root directory
    Then it reports a dangling-edge finding naming the source artifact and the unresolved id
    And it does not report an unverifiable-legacy finding for that edge, because no file exists to be legacy

  @scenario_hash:cd8e26dccaf8ddb3
  Scenario: an absent typed-artifact directory does not crash the loader
    Given a corpus root directory that contains no prioritizations subdirectory at all
    When the operator runs the knowledge context's installed coherence-gate command over the corpus root directory
    Then the run completes and reports an aggregate verdict
    And it treats the absent subdirectory as zero prioritization-record instances, not as a loader error

  @scenario_hash:82d9df6a97c9a173
  Scenario: the gate command defaults to authoring mode
    Given a corpus root directory that carries at least one coherence finding
    When the operator runs the knowledge context's installed coherence-gate command over the corpus root directory with no mode specified
    Then it runs in authoring mode
    And it exits zero despite the finding, per the already-pinned authoring-mode contract
