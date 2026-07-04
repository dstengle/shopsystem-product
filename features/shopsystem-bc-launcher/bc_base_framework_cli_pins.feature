@bc_internal
Feature: bc-base Dockerfile pins the four dstengle framework CLIs to their owner/repo and installs bd as the steveyegge/beads binary (shopsystem-bc-launcher-tuk, scoped by lead-6rm4)

  This is a BC-INTERNAL test-rigor hardening (bead shopsystem-bc-launcher-tuk,
  surfaced during the lead-po0j review; scoped under lead-6rm4). It is NOT a
  lead-assigned scenario: the @bc_internal tag below is a BC-owned marker, NOT
  a lead @scenario_hash.

  Scenario 42 (ccb145d71c7100a2) pins only the shop-templates install, and
  scenario 36 (d9909f38abea83b5) requires only ">=1 dstengle VCS pin + reject
  editable clones". Neither structurally binds the OTHER dstengle framework
  CLIs to their correct owner/repo. That hole let two consecutive wrong-repo
  404 defects ship green (dstengle/shop-msg and dstengle/beads; corrected in
  lead-b6gd / lead-po0j).

  This scenario asserts the FOUR dstengle framework-CLI installs
  (shopsystem-messaging, scenarios, shop-templates, shopsystem-bc-launcher) are
  each present in the
  "<pkg> @ git+https://github.com/dstengle/<repo>.git@vMAJOR.MINOR.PATCH"
  VCS-pin shape with its CORRECT owner/repo, and rejects editable clones for
  all four — so a wrong-owner/wrong-repo regression (the 404 class) on ANY of
  the four FAILS the test.

  beads is NOT a dstengle utility and NOT pip-installable (lead-6rm4): bd is a
  third-party Go binary installed from the steveyegge/beads releases. This
  scenario additionally asserts bd is installed via that binary release pinned
  to BD_VERSION=1.0.3 into /usr/local/bin/bd, and that beads is NOT reverted to
  a pip VCS pin. Mutating BD_VERSION away from 1.0.3, changing the owner away
  from steveyegge, or reverting beads to a pip pin FAILS the test.

  Version is asserted by SHAPE (vMAJOR.MINOR.PATCH) for the four pip pins, not
  exact value, so legitimate version bumps do not break the test while the 404
  class still trips.

  @bc_internal @bc:shopsystem-bc-launcher
  Scenario: the bc-base Dockerfile pins the four dstengle framework CLIs and installs bd as the steveyegge binary
    Given the shopsystem-bc-launcher BC repository
    When the bc-base Dockerfile in that repository is inspected
    Then the Dockerfile installs the four dstengle framework CLIs each from a VCS version pin bound to its correct owner and repo
    And bd is installed from the steveyegge/beads binary release pinned to BD_VERSION=1.0.3 rather than from a pip VCS pin
    And none of the four dstengle framework CLIs is installed from an editable clone
