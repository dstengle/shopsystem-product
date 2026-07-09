Feature: shopsystem-knowledge — coherence gate: typed-edge checks (typed artifacts)

  The always-on deterministic floor of the coherence gate. Over the frontmatter
  link fields the knowledge context runs cheap, model-free graph checks —
  asymmetric-supersede, active-yet-superseded, dangling-edge, and supersede-cycle
  — and folds every finding into one aggregate verdict. The dangling-edge check is
  the link-resolution rule (gate rule 2): every link field on every artifact type
  — supersedes, superseded-by, derives-from, experiments, brief, candidate,
  session, produced, revised, incorporates — must resolve to an artifact present in
  the corpus; a pdr's optional session field, when present, must resolve to a
  session-record like any other link field. Frontmatter links are the graph and
  body mentions are commentary: the gate resolves only frontmatter link fields, so
  an id that appears only in body prose forms no edge and a load-bearing mention
  must be promoted to derives-from to become one. The supersede checks are the
  bidirectional-supersession rule (gate rule 3), which accepts a single id or a list
  on supersedes/superseded-by and applies the bidirectionality check per pair (gate
  rule 10). Each finding is reported in doctor form: the check name and its check-id,
  the offending artifacts by id, and a remediation. A clean corpus produces a success
  verdict; any finding drives the aggregate exit non-zero. These typed-edge checks
  are the always-on floor; the governed-delta invariant tripwire is a separate
  opt-in mechanism that only the load-bearing claims which register it are subject
  to — it is hardening, not a required discipline.

  @scenario_hash:bf193a08baeca6a5
  Scenario: an asymmetric supersede without a back-edge is flagged
    Given an artifact corpus in which artifact A declares that it supersedes artifact B
    And artifact B carries no superseded-by edge back to A
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports an asymmetric-supersede finding naming A and B by id
    And the finding carries its check-id and a remediation to write the superseded-by back-edge on B
    And the aggregate verdict exits non-zero

  @scenario_hash:78018b7a77377e6b
  Scenario: a list-valued supersedes with one missing per-pair back-edge is flagged
    Given an artifact corpus in which artifact A declares that it supersedes a list of artifacts B and C
    And artifact B carries a superseded-by edge back to A
    And artifact C carries no superseded-by edge back to A
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports an asymmetric-supersede finding naming A and C by id for the missing back-edge
    And it reports no asymmetric-supersede finding for the resolved A and B pair
    And the aggregate verdict exits non-zero

  @scenario_hash:108a7e052c710d45
  Scenario: a list-valued supersedes with every per-pair back-edge present passes
    Given an artifact corpus in which artifact A declares that it supersedes a list of artifacts B and C
    And artifacts B and C each carry a superseded-by edge back to A
    And artifacts B and C each carry a superseded status
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports no asymmetric-supersede finding for A
    And the aggregate verdict exits zero

  @scenario_hash:e983ffe0fd0f8456
  Scenario: a superseded artifact whose status is not superseded is flagged
    Given an artifact corpus in which artifact B is superseded by artifact A yet artifact B's status is not superseded
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports an active-yet-superseded finding naming B by id
    And the finding carries its check-id and a remediation to set B's status to superseded
    And the aggregate verdict exits non-zero

  @scenario_hash:a2f381efec69a4dd
  Scenario Outline: a link field pointing to a target absent from the corpus is flagged
    Given an artifact corpus in which an artifact declares a <link-field> edge to a target id that is not present in the corpus
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports a dangling-edge finding naming the source artifact and the unresolved target id on its <link-field> edge
    And the finding carries its check-id and a remediation
    And the aggregate verdict exits non-zero

    Examples:
      | link-field    |
      | supersedes    |
      | derives-from  |
      | session       |
      | brief         |
      | candidate     |
      | produced      |
      | incorporates  |

  @scenario_hash:2d1e857cebe9bb38
  Scenario: a supersede cycle is flagged
    Given an artifact corpus in which artifact A supersedes artifact B and artifact B supersedes artifact A
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports a supersede-cycle finding naming the artifacts in the cycle by id
    And the finding carries its check-id and a remediation
    And the aggregate verdict exits non-zero

  @scenario_hash:06e15d23af5e7474
  Scenario: an id mentioned only in body prose creates no graph edge
    Given an artifact corpus in which an artifact's body prose references another present artifact's id but its frontmatter carries no link field naming that id
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it forms no edge from the prose mention because the gate resolves frontmatter link fields only
    And it reports no dangling-edge finding arising from the prose mention
    And the aggregate verdict exits zero

  @scenario_hash:e8cdd261ed7a2325
  Scenario: a load-bearing prose mention promoted to derives-from becomes a resolved graph edge
    Given an artifact whose previously prose-only reference to an upstream artifact has been promoted into its derives-from frontmatter field
    And that upstream artifact is present in the corpus
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it resolves a derives-from edge from the promoting artifact to the upstream artifact
    And it reports no dangling-edge finding for that edge

  @scenario_hash:a42f119a97f362f8
  Scenario: a clean corpus passes with a success aggregate verdict
    Given an artifact corpus whose supersede edges are all symmetric, whose superseded artifacts are all set to superseded status, whose link-field targets all resolve, and which contains no supersede cycle
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports no findings
    And the aggregate verdict exits zero

  @scenario_hash:0921f02f6d4ac7fc
  Scenario: multiple defects fold into one aggregate verdict
    Given an artifact corpus carrying both an asymmetric-supersede defect and a dangling-edge defect
    When the knowledge context runs the typed-edge coherence checks over the corpus
    Then it reports both findings, each named by its own check-id
    And it folds them into a single aggregate verdict that exits non-zero

  @scenario_hash:f6c211e571ec7a64
  Scenario: the governed-delta invariant tripwire is opt-in and skips artifacts that register none
    Given an artifact that registers no governed-delta invariant
    And a separate artifact that opts in by registering a governed-delta invariant over a governed surface
    When the knowledge context runs its coherence checks over the corpus
    Then it evaluates no governed-delta tripwire against the artifact that registered none
    And it evaluates the governed-delta tripwire only against the artifact that opted in
