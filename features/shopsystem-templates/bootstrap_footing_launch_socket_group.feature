@bc:shopsystem-templates @origin:lead-27ka
Feature: bin/bootstrap grants the footing-launch container the host docker-socket group
  The footing-launch 'docker run … bash ./bin/footing' passes --group-add for the host
  docker-socket gid resolved at run time (stat -L -c %g /var/run/docker.sock), so footing's
  vscode user can USE the mounted socket — compose-up + the lead-rs0i self-attach run
  instead of being permission-denied. The render-only run is unchanged.

@scenario_hash:4512bf0148b44a63
Scenario: bootstrap grants the footing-launch container the host docker-socket group
  Given bin/bootstrap has rendered bin/footing and is about to launch it
  And the launch is a "docker run" that bind-mounts "/var/run/docker.sock" into a container whose default user is "vscode"
  When bootstrap composes the "bash ./bin/footing" launch command
  Then the launch command resolves the host docker-socket group id at run time from "stat -L -c '%g' /var/run/docker.sock"
  And the launch command includes a "--group-add" argument set to that resolved socket group id
  And the resolved socket group id is read at run time rather than hardcoded

@scenario_hash:a9a30b1304d0029a
Scenario: footing's docker commands are not permission-denied in the bootstrap-launched container
  Given bin/bootstrap launches "bash ./bin/footing" in a container that bind-mounts the host docker socket
  And that container is launched with "--group-add" set to the run-time-resolved host docker-socket group id
  And the container's default user "vscode" is not otherwise a member of the host docker group
  When footing runs its first docker command against the mounted socket inside that container
  Then the docker command is permitted rather than returning a permission-denied error
  And footing can run "docker compose up -d postgres agent-vault" and "docker network connect" against the mounted socket
