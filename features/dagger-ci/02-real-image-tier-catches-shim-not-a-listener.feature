@bc:shopsystem-bc-launcher @origin:adr-053
Feature: the dagger real-image tier's bounded shim listen smoke REDs on an oauth-shim that parses --help but never binds its listener

  The real-image tier is the value the structural fakes and a --help-only tier both lack —
  ADR-052 D3 (the NEW real-image tier runs the baked CLIs live where the fakes and a
  --help gate return canned/argparse exit-0). Anchored on ADR-052 (umbrella), ADR-021
  (bc-launcher owns the image), ADR-018/PDR-011 (contract-surface pre-state — observed
  on-host, no BC source read/run/git-observed; findings/dagger-spike/*.md are the artifact
  surface), ADR-049 D2 (the fabro base_url the shim bridges). Evidence:
  findings/dagger-spike/02-dagger-experiment.md (a) Split 2 + 02a-experiment.md. The defect
  is the sharpest structural-green-but-broken split: an anthropic-oauth-shim that still
  parses "--help" (argparse -> exit 0) but "return"s before binding its ThreadingHTTPServer.
  The structural check (--help exit 0 + stdlib-only) AND dagger's own --help tier stay GREEN
  (REAL_IMAGE_TIER_OK); only the bounded shim_listen_smoke — a real-image TCP connect to
  127.0.0.1:8788 — sees the missing listener. Distinct from
  features/bc-launcher/45 (claude-oauth brokered) and features/fabro-orchestration/02
  (agent-vault-only credential injection) — those pin the credential wire and the
  fabro-native-secrets-forbidden contract, not a real-image liveness smoke of the baked
  shim; this NET-NEW pin does not duplicate them.
  @scenario_hash:c7b2c587be09770b
  Scenario: the real-image shim_listen_smoke REDs on a shim that parses --help but never binds while the structural suite and a --help-only tier stay GREEN
    Given a bc-base image whose baked anthropic-oauth-shim parses "--help" to argparse exit 0 but returns before binding its ThreadingHTTPServer
    And a structural check that asserts only "--help" exit 0 and stdlib-only imports
    And a dagger --help tier that runs the shim with "--help" and observes exit 0
    When the dagger real-image tier runs the bounded shim_listen_smoke as a TCP connect to "127.0.0.1:8788" on the fabro ADR-049 D2 base_url
    Then the shim_listen_smoke goes RED with "SHIM_NOT_LISTENING" on exit 1 because nothing is bound at the port
    And the structural check and the dagger --help tier both stay GREEN reporting "REAL_IMAGE_TIER_OK" because a --help gate cannot observe the missing listener
