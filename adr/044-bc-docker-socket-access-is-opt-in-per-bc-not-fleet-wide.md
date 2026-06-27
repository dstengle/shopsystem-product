# ADR-044 — Host docker-socket access is granted OPT-IN per BC (least-privilege), not fleet-wide; the bc-base image only bakes the `docker` CLI, the socket grant stays a launch-time opt-in

**Status:** accepted (2026-06-27)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** the architecture decision the product authority reserved on
`lead-qi0q` (dave, 2026-06-10): *"docker client is inert without the socket
mounted + `--group-add` at launch (like `bin/shop-shell`) — decide whether
socket access is fleet-wide or opt-in per BC (bc-launcher needs it to run real
launch integration tests instead of the fake driver)."*
**Anchored to:**
[ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
(D1/D4 — the LEAD session gets the docker socket + `--group-add` because its
router runs `bc-container launch`; the lead shell is a deliberate socket
consumer);
[ADR-018](018-empirical-verification-is-contract-surface.md) (the
artifact-surface evidence rule — the socket policy is verified against this
repo's `features/`, not BC source);
[ADR-004](004-bc-launcher-as-new-bc.md) (the BC-shop boundary the launch-time
opt-in flag belongs to).
**Anchored on (PDR):**
[PDR-020](../pdr/020-lead-shell-is-a-bc-container-launched-bc-base-session.md)
(slice 1 / `lead-zxtk` — the LEAD profile that introduced the opt-in
docker-socket mount and open question (e): "docker socket mount is an explicit,
lead-only opt-in, never the default; the BC default of NO socket is preserved").
**Related beads:** `lead-qi0q` (this decision + the bc-base CLI-presence pins),
`lead-zxtk` (PDR-020 slice 1, owns scenario 54).

---

## Context

`lead-qi0q` asks the bc-base image to bake three operator CLIs onto PATH — `gh`,
`docker`, and `agent-vault` — and pin their presence (scenario 63,
`@scenario_hash:63ed6ac34b8bd64c`, `@bc:shopsystem-bc-launcher`). Adding the
`docker` CLI surfaces a policy question the product authority explicitly
reserved for the Architect: **the `docker` client is inert without the host
docker socket mounted and the launching user added to the socket's owning group
(`--group-add`).** Baking the CLI into the image does not, by itself, grant any
container access to a docker daemon. So: which BCs get the socket?

The driver is concrete. `shopsystem-bc-launcher` cannot run REAL launch
integration tests without a reachable docker daemon — without the socket it must
fall back to the `FakeDockerDriver`. So at least one BC has a genuine,
declared need for socket access. The question is whether that need generalises
to the whole fleet or stays per-BC.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD against the contract/artifact surface only — no BC
implementation code read, run, or git-observed (the lead host carries no
`repos/` BC source). The admissible surface here is this repo's `features/`, the
`adr/`/`pdr/` records, and the installed `scenarios` CLI.

1. **The opt-in launch behavior is ALREADY pinned.**
   `features/bc-launcher/54-lead-profile-workspace-mount-and-docker-socket.gherkin`
   (PDR-020 slice 1) carries two socket scenarios:
   - `ff370a4e7e9dac5e` — "launch mounts the host docker socket only when the
     opt-in lead-only flag is given" (the socket `/var/run/docker.sock` bind
     mount appears only with the flag);
   - `e177655ba09a73fa` — "launch mounts no docker socket by default when the
     opt-in flag is absent" (the BC default is NO socket).
   So the *mechanism* for opt-in-per-launch already exists and is tested on the
   launcher surface. This decision does not invent it; it adopts it as the fleet
   policy and names its rationale. **Confirmed** (read of scenario 54).

2. **The socket-group grant pattern is ALREADY pinned (symmetric `--group-add`).**
   `features/templates/198-...gherkin` (`84a32b05666d9e82`) pins that the
   rendered `bin/shop-shell` resolves the socket's owning group via
   `stat -L -c '%g' /var/run/docker.sock` and grants it via `--group-add` on
   EVERY socket-mounting `docker run` (both the `bc-container launch` block and
   the `bc-container attach` block), so the non-root user is inside the socket's
   owning group rather than hitting EACCES on the docker API. This is the grant
   mechanism the opt-in policy reuses. **Confirmed** (read of scenario 198).

3. **The LEAD already opts in.** ADR-028 D1/D4 and PDR-020 establish that the
   lead session (router + `bin/shop-shell`) mounts the socket + `--group-add`
   precisely because the lead router runs `bc-container launch` to orchestrate
   BCs. The lead is the first declared consumer; it opts in. **Confirmed**
   (read of ADR-028 / PDR-020).

4. **`docker` CLI presence is net-new in bc-base.** No scenario pins `docker`
   (or `gh`) presence-on-PATH in the image; scenario 51 (`938342272de4e38a`)
   incidentally asserts `agent-vault` (with `shop-templates`/`shop-msg`/
   `bc-container`) on PATH in bootstrap-entrypoint mode only. The CLI is MISSING
   from bc-base today and must be added to the Dockerfile. **Confirmed** (grep
   over `features/`).

This is a structural decision with no product-UX surface change to the
framework's outward face — hence an **ADR**, not a PDR.

---

## Decision

### D1 — Docker-socket access is OPT-IN per BC, granted only to BCs that DECLARE a need; the fleet default is NO socket

Host docker-socket access is **NOT** granted fleet-wide. Each BC that needs the
host docker daemon — today, `shopsystem-bc-launcher`, to run real launch
integration tests instead of the `FakeDockerDriver` — receives the socket via
the existing launch-time opt-in flag (scenario 54, `ff370a4e7e9dac5e`), and
every other BC keeps the default of NO socket (scenario 54, `e177655ba09a73fa`).
The lead session itself is the first opt-in consumer (ADR-028 D1/D4, finding 3),
which is exactly the per-consumer model this ADR generalises.

The grant is two coupled mechanisms, both already pinned:
- **the socket bind mount** `/var/run/docker.sock:/var/run/docker.sock`, present
  only under the opt-in flag (scenario 54); and
- **the `--group-add` of the socket's owning group**, resolved by
  `stat -L -c '%g' /var/run/docker.sock`, on every socket-mounting `docker run`
  (scenario 198) — without which the non-root container user gets EACCES on the
  docker API.

### D2 — The bc-base IMAGE only bakes the `docker` CLI; the socket grant stays a LAUNCH-TIME concern

The bc-base Dockerfile change `lead-qi0q` asks for is strictly **CLI presence**:
install the `docker` client and pin `gh` as an explicit install (not an
incidental property of the upstream base image), keeping `agent-vault` on PATH.
The image grants no socket and confers no daemon access on its own — a container
run from bc-base with no socket mount can still run `docker --version` (scenario
63 pins exactly this: version-only, no reachable daemon required). The socket
grant remains a launch-time opt-in (D1), owned by the launcher boundary
(scenario 54) and the rendered `bin/shop-shell` (scenario 198), not by the
image. This keeps "the tool is present" and "the tool is empowered" as two
separate, separately-pinned concerns.

---

## Alternatives considered

**Fleet-wide socket grant (every BC container mounts the host socket).**
Rejected. Mounting the host docker socket grants effective root on the host
(any container with the socket can launch privileged sibling containers).
Granting that to every BC — most of which never invoke `docker` — is an
unnecessary blast radius and violates least-privilege. The only BC with a
declared need today is the launcher; a per-BC opt-in confines the privilege to
where it is justified, and the mechanism already exists (scenario 54), so
fleet-wide buys nothing but risk.

**Bake the socket grant into the bc-base image / entrypoint.** Rejected. The
socket is a launch-time, host-specific resource (its owning GID is resolved at
launch via `stat`, scenario 198); an image cannot pin a host GID and must not
assume a daemon. Conflating image-CLI-presence with daemon-access would make
every bc-base run socket-coupled, re-creating the fleet-wide posture by the back
door.

---

## Consequences

- **bc-base gains the `docker` CLI** and an explicit pinned `gh` install
  (scenario 63, dispatched to `shopsystem-bc-launcher` under `lead-qi0q`).
  `agent-vault` stays on PATH. The image confers no socket/daemon access.
- **The socket policy is OPT-IN per BC**, reusing the already-pinned launch
  opt-in flag (scenario 54) + the `--group-add` socket-group grant (scenario
  198). No new launcher contract is needed for the policy itself; this ADR
  records the decision and its rationale and ties the bead's driver
  (bc-launcher real launch integration tests) to the existing mechanism.
- **`shopsystem-bc-launcher` is the first non-lead opt-in consumer**: with the
  `docker` CLI baked in (63) plus the launch opt-in flag (54), it can run real
  launch integration tests against a reachable daemon instead of the
  `FakeDockerDriver`. Wiring that into its own test harness is BC-side work
  pinned by 54/198, not by this ADR.
- **The default is preserved**: a BC launched without the opt-in flag gets NO
  socket (scenario 54, `e177655ba09a73fa`).

---

## Cross-references

- [PDR-020](../pdr/020-lead-shell-is-a-bc-container-launched-bc-base-session.md)
  — slice 1 / open question (e): the lead-only opt-in socket mount; BC default
  NO socket. This ADR generalises (e) into the fleet socket policy.
- [ADR-028](028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
  — D1/D4: the lead session is a deliberate socket consumer (the first opt-in).
- `features/bc-launcher/54-lead-profile-workspace-mount-and-docker-socket.gherkin`
  — `ff370a4e7e9dac5e` (opt-in mount) / `e177655ba09a73fa` (default no mount):
  the opt-in mechanism this policy adopts.
- `features/templates/198-bootstrap-shop-shell-grants-docker-socket-group-symmetrically-to-launch-and-attach.gherkin`
  — `84a32b05666d9e82`: the `--group-add` socket-group grant pattern.
- `features/bc-launcher/63-bc-base-bakes-operator-clis-on-path.gherkin`
  — `63ed6ac34b8bd64c`: the bc-base CLI-presence pin (`gh`/`docker`/`agent-vault`).
- [lead-qi0q](beads:lead-qi0q) — the bead carrying this decision + the dispatch.
