@bc:shopsystem-templates @origin:lead-kz4j
Feature: postgres runs as its default in-image uid (host-user-ownership revert)
  The compose postgres service carries no user: override and footing does not chown
  pgdata to the host uid; footing still ensures the pgdata bind-source dir exists.

@scenario_hash:6d14fb619c484829
Scenario: postgres runs as its default in-image uid and footing does not force host-user ownership of pgdata
  Given a rendered ops scaffolding for a product slug
  And the data root resolves to ${<SLUG_UPPER>_DATA:-$HOME/.local/share/<slug>} with pgdata under it
  When the compose postgres service definition is rendered
  Then the postgres service carries no "user:" override and runs as its default in-image uid
  When footing brings the ops services up
  Then footing does not export HOST_UID or HOST_GID from id -u or id -g
  And footing does not chown the data root or pgdata to the host uid or gid
  And footing still ensures the data-root pgdata directory exists so the bind-mount source is present
  When the postgres container initializes the bind-mounted pgdata
  Then pgdata is owned by postgres's standard in-image uid via the image's normal init
  And postgres initializes and serves normally on the configured database
