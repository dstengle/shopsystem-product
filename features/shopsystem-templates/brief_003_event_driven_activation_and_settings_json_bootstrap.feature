# RETIRED-scenario provenance & narrative (relocated to file header on
# lead-import so canonical block-only hashes match the shopsystem-templates
# canonical; scenario bodies and @scenario_hash pins are byte-identical):
#   @scenario_hash:cad1153ef4dfd18c RETIRED (lead-3c6)
#   Asserted CLAUDE.md body contains "inotify-tools", "coreutils", "inotifywait", "stdbuf".
#   Under PDR-003 alt F, CLAUDE.md is a pure @-import file; host-prereq naming relocated
#   to .claude/canonical/<shop_type>-primer.md, pinned by lead-shop scenario 64.
#   @scenario_hash:6bc3eb5f62115d91 RETIRED (lead-5r0)
#   Asserted bc primer contains "inotify-tools", "coreutils", "inotifywait", "stdbuf".
#   Superseded by lead-5r0: session-start section now describes shop-msg prime/watch;
#   host-level filesystem watcher prereqs removed entirely from bc primer.
#   ---------------------------------------------------------------------
#   brief-003 realization revision (lead-pn9 / parent lead-o00):
#   the activation mechanism shifts from a SessionStart hook running
#   `inotifywait -m` (which Claude Code awaits synchronously and so
#   hangs session startup) to a router-side instruction in the canonical
#   CLAUDE.md primer to arm the in-session Monitor tool on the same
#   pipeline. Scenarios 71-75 below carry the revised realization;
#   scenarios 57, 58, 59, 65, 68 (hashes 1621b59b0ea8b20b,
#   679d227f04533ad4, c1e7f31eeef73e05, a9379ab3a162158d,
#   287e6a4f31533336) were retired in this round.
#   ---------------------------------------------------------------------
#   @scenario_hash:206ca3d0fa40bcad RETIRED (lead-5r0)
#   Asserted bc primer contains "stdbuf -oL inotifywait", "-m -e create,moved_to",
#   "inbox/" as the Monitor pipeline.
#   Superseded by lead-5r0: bc primer now instructs "shop-msg watch --bc-root ."
#   (postgres LISTEN/NOTIFY) instead of inotifywait. Lead primer [repos/*/outbox/]
#   also superseded by the same replacement.
#   @scenario_hash:206ca3d0fa40bcad-lead-only RETIRED (lead-51u)
#   Asserted returned body contains stdbuf -oL inotifywait, -m -e create,moved_to, repos/*/outbox/.
#   Superseded by lead-51u: lead primer now uses shop-msg watch --lead-root .; no host prereqs required.
#   @scenario_hash:206ca3d0fa40bcad-lead-only-replacement RETIRED (lead-eqn)
#   Asserted the lead CLAUDE.md primer template contains literal substring "--lead-root".
#   This flag no longer exists; shop-msg now uses --lead <name> for lead-side commands.
#   Superseded by lead-eqn: Brief 006 replaced --lead-root with --lead <name>.
#   @scenario_hash:d87ccb133fa64d2f[bc] RETIRED (lead-5r0)
#   Asserted bc primer contains inotifywait, stdbuf, refuse-to-arm instruction.
#   Superseded by lead-5r0: bc primer now uses shop-msg watch; no host prereqs required.
#   @scenario_hash:d87ccb133fa64d2f RETIRED (lead-51u)
#   Asserted returned body contains inotifywait, stdbuf, and instructions to verify PATH and refuse-to-arm.
#   Superseded by lead-51u: lead primer now uses shop-msg watch --lead-root .; no host prereqs required.
#   @scenario_hash:9f15982aa00829f1 RETIRED (lead-3c6)
#   Asserted CLAUDE.md body contains Monitor activation instruction strings.
#   Under PDR-003 alt F, CLAUDE.md is a pure @-import file; Monitor activation instruction
#   relocated to .claude/canonical/<shop_type>-primer.md, pinned by lead-shop scenarios
#   71, 72, and 73.
#   @scenario_hash:11cf1e054f79fed4 RETIRED (lead-7yh)
#   Asserted BC settings.json has no SessionStart entries.
#   Superseded by lead-7yh: BC settings.json now declares "shop-msg prime"
#   as the sole SessionStart hook, analogous to the lead template's "bd prime".
#   @scenario_hash:ec6b7da92e34ef12 RETIRED (lead-eqn)
#   Asserted the bc settings.json SessionStart hook command equals "shop-msg prime --bc-root .".
#   This flag no longer exists; shop-msg now uses --bc <name> for BC-side commands.
#   Superseded by lead-eqn: Brief 006 replaced --bc-root with --bc <name>; bc.json
#   template now uses "shop-msg prime --bc {{SHOP_NAME}}".
#   @scenario_hash:71797e9017c95fed RETIRED (lead-33r)
#   Asserted "bd prime" was the SOLE inner-hook command under SessionStart
#   for the lead canonical. Under PDR-009, "shop-msg prime" is a second
#   short-lived, cleanly-terminating SessionStart hook that belongs
#   alongside "bd prime" (the bare command, no addressing flag, identity
#   resolved via CWD walk-up). The "sole" qualifier is retired; the
#   composition is pinned by features/canonical_settings_hooks_no_shop_identity_pdr009.feature
#   scenarios 9317b34e56712c7c and d3cc63377ac86cce.
@bc:shopsystem-templates @origin:brief-003
Feature: brief 003: event-driven shop activation and canonical .claude/settings.json bootstrap extension

  @scenario_hash:cbaa3e1d226b6000
  Scenario Outline: bootstrap writes the canonical ".claude/settings.json" for the shop type into the target directory, byte-for-byte equal to the current canonical package-data file
  Given an existing git repository at a target directory "<target>" with no ".claude/settings.json" file
  When I invoke the "shop-templates" bootstrap entry point with shop type "<shop_type>", shop name "<shop_name>", and target directory "<target>"
  Then the exit code is 0
  And the target directory contains a file at ".claude/settings.json"
  And the content of that file equals the package-data file contents of the canonical ".claude/settings.json" template for shop type "<shop_type>" byte-for-byte

  Examples:
    | shop_type | shop_name               | target                       |
    | bc        | shopsystem-messaging    | /tmp/example-bc-shop         |
    | lead      | shopsystem-product      | /tmp/example-lead-shop       |

  @scenario_hash:395b2fbf05a2b487
  Scenario Outline: the "shop-templates" update entry point re-pours ".claude/settings.json" from the current canonical package data, treating it as bootstrap-managed (not init-only); stale content is replaced and already-current content is preserved
  Given an existing git repository at a target directory "<target>" that was previously bootstrapped as a "<shop_type>" shop named "<shop_name>"
  And the file at ".claude/settings.json" in the target directory differs from the current canonical ".claude/settings.json" template for shop type "<shop_type>"
  When I invoke the "shop-templates" update entry point against the target directory "<target>"
  Then the exit code is 0
  And after the invocation the file at ".claude/settings.json" in the target directory equals the current canonical ".claude/settings.json" template for shop type "<shop_type>" byte-for-byte

  Examples:
    | shop_type | shop_name               | target                       |
    | bc        | shopsystem-messaging    | /tmp/example-bc-shop         |
    | lead      | shopsystem-product      | /tmp/example-lead-shop       |

  @scenario_hash:5245163e76065d3b
  Scenario Outline: invoking "shop-templates" update against a target directory whose ".claude/settings.json" already equals the current canonical leaves the file byte-for-byte unchanged
  Given an existing git repository at a target directory "<target>" that was previously bootstrapped as a "<shop_type>" shop named "<shop_name>"
  And the file at ".claude/settings.json" in the target directory equals the current canonical ".claude/settings.json" template for shop type "<shop_type>" byte-for-byte
  When I invoke the "shop-templates" update entry point against the target directory "<target>"
  Then the exit code is 0
  And after the invocation the file at ".claude/settings.json" in the target directory still equals the current canonical ".claude/settings.json" template for shop type "<shop_type>" byte-for-byte

  Examples:
    | shop_type | shop_name               | target                       |
    | bc        | shopsystem-messaging    | /tmp/example-bc-shop         |
    | lead      | shopsystem-product      | /tmp/example-lead-shop       |

  @scenario_hash:e5f21b444322fb0a
  Scenario: on session start in a bootstrapped lead shop, every BC CLI installed into the product venv (for example "shop-msg", "shop-templates") resolves invocations to the current source tree of that BC's clone under "repos/", so an edit to a BC's source is reflected in the next CLI invocation without an intervening manual reinstall
  Given an existing git repository at a target directory "/tmp/example-lead-shop" that was previously bootstrapped as a "lead" shop named "shopsystem-product"
  And the target directory contains a sibling BC clone at "repos/shopsystem-messaging/" whose installed package name is "shop-msg"
  And a fresh edit has been made to a Python source file under "repos/shopsystem-messaging/src/" that changes observable CLI behavior of "shop-msg"
  When a Claude Code session starts in the target directory and the "SessionStart" hooks declared by ".claude/settings.json" complete
  And the agent invokes the "shop-msg" CLI through its normal entry point
  Then the invocation exhibits the post-edit observable behavior
  And no manual "pip install" step is required between the source edit and the invocation

  @scenario_hash:0493e0fb3b603da1
  Scenario: bootstrap of a lead shop installs each sibling BC clone under "repos/" into the product venv in editable mode, so that source-tree edits in a BC clone are immediately reflected in subsequent CLI invocations against the lead shop's venv without an intervening manual reinstall
  Given a target directory "/tmp/example-lead-shop" containing an existing git repository
  And the target directory contains a sibling BC clone at "repos/shopsystem-messaging/" with a valid Python package whose installed entry point name is "shop-msg"
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And the product venv reports the installed location of the "shop-msg" distribution as pointing into "repos/shopsystem-messaging/" of the target directory
  And the "pip show shop-msg" output for the product venv records the install as editable

  @scenario_hash:0e939a4c07562852
  Scenario: the canonical "CLAUDE.md" primer template for shop type "lead" instructs the router to use "shop-msg watch" and states that no host-level prerequisites are required for the Monitor activation pipeline
    When I ask the "shop-templates" package for the canonical "CLAUDE.md" primer template for shop type "lead" through its public template-access surface
    Then a non-empty template body is returned
    And the returned body contains the literal substring "shop-msg watch"
    And the returned body does not contain the literal substring "inotifywait"
    And the returned body does not contain the literal substring "stdbuf"
    And the returned body contains the literal substring "no host-level"

