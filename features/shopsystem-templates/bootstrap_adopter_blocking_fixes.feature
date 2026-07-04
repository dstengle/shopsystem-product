@bc:shopsystem-templates @origin:lead-3t1o
Feature: bootstrap adopter-blocking fixes — no shell Dockerfile for arbitrary slug; credential-free push does not hang
  Two P1 cold-bootstrap (INSTALL) fixes: a lead bootstrap for an arbitrary adopter
  slug emits no Dockerfile.<slug>-shell while still emitting compose.yaml + bin/shop-shell
  (regression guard; the shell-Dockerfile render was retired by the shop-shell
  convergence), and a credential-free bootstrap defers the authenticated bd dolt push
  with a clear offline diagnostic instead of hanging on git authentication.

@scenario_hash:4d3df50770bcc4ef
Scenario: bootstrap of a "lead" shop with an arbitrary adopter slug emits no "Dockerfile.<slug>-shell" while still emitting "bin/shop-shell" and "compose.yaml"
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no top-level file matching "Dockerfile.testxyz-shell", no top-level "Dockerfile.shopsystem-shell", no top-level "compose.yaml", and no file at "bin/shop-shell"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "testxyz-product", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And after the invocation the target directory contains no top-level file named "Dockerfile.testxyz-shell"
  And after the invocation the target directory contains no top-level file matching the glob "Dockerfile.*-shell"
  And after the invocation the target directory contains a top-level file named "compose.yaml"
  And after the invocation the target directory contains a file at "bin/shop-shell" whose owner-execute permission bit is set

@scenario_hash:b47ca2b0841bedbf
Scenario: bootstrap completes scaffolding on a target with no GitHub push credentials without hanging on an authenticated remote push
  Given a target directory "/tmp/example-lead-shop" that is an existing git repository with no ".beads/" directory
  And the environment carries no GitHub push credentials that would authenticate a push to "git+https://github.com/dstengle/testxyz-beads.git"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "testxyz-product", and target directory "/tmp/example-lead-shop"
  Then the invocation returns within the bootstrap time budget rather than blocking on a network push that waits for git authentication
  And the bootstrap does not perform a credential-requiring live push to an authenticated remote during scaffolding
  And the bootstrap emits the scaffolded shop into the target directory, including a top-level "compose.yaml" and a file at "bin/shop-shell"
  And the bootstrap surfaces clear output reporting that the credentialed remote push was skipped or run offline rather than producing no feedback
