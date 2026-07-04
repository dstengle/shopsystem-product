@bc:shopsystem-templates @origin:lead-ae4h
Feature: bin/bootstrap runs the footing launch on the bc-lead image (carries the docker CLI)
  The footing-launch 'docker run … bash ./bin/footing' uses the bc-LEAD image
  (ghcr.io/dstengle/shopsystem-bc-lead:latest = bc-base + docker CLI), not bc-base, so
  footing's 'docker compose up' + 'docker network connect' resolve rather than failing
  'docker: command not found'. Env-overridable, :latest-floating, run-time digest recorded;
  the render-only run stays on bc-base.

@scenario_hash:967121fc8840560c
Scenario: bootstrap runs bin/footing on the lead image that carries the docker CLI, not the bc-base image
  Given an adopter fork created from the starter that carries "bin/bootstrap"
  And the bc-base image "ghcr.io/dstengle/shopsystem-bc-base:latest" carries NO docker CLI while the lead image "ghcr.io/dstengle/shopsystem-bc-lead:latest" carries the docker CLI
  And the rendered "bin/footing" issues docker commands "docker compose up" and "docker network connect" during its sequence
  When the adopter runs "bin/bootstrap" through to the footing-launch step that invokes "bash ./bin/footing"
  Then the image that "bin/bootstrap" pulls and runs "bin/footing" on resolves from the lead image reference "ghcr.io/dstengle/shopsystem-bc-lead", not from "ghcr.io/dstengle/shopsystem-bc-base"
  And because that launch image carries the docker CLI, the "docker compose up" and "docker network connect" calls "bin/footing" issues resolve to the docker binary and do not fail with "docker: command not found"

@scenario_hash:12cedbdd93a76e29
Scenario: the footing-launch image reference stays env-overridable and floats on :latest
  Given an adopter fork that carries "bin/bootstrap"
  When the adopter runs "bin/bootstrap" with no image-override environment variable set
  Then "bin/bootstrap" defaults the footing-launch image reference to "ghcr.io/dstengle/shopsystem-bc-lead:latest", floating on the ":latest" tag per ADR-040 D3 rather than pinning a fixed tag in the committed file
  And when the adopter runs "bin/bootstrap" with the image-override environment variable set to a different reference, "bin/bootstrap" pulls and runs "bin/footing" on that overridden reference instead of the default
  And "bin/bootstrap" resolves the floating reference at run time and records the resolved digest in the run ".env" so the footing-launch run is reproducible
