@bc:shopsystem-templates @origin:lead-ddb2
Feature: rendered bootstrap artifacts — docker-socket group symmetry + the shop-shell entry instruction
  bin/shop-shell grants the docker socket group to BOTH the launcher and attach runs (no EACCES),
  and the bootstrap completion message names bin/shop-shell as the lead-session entry command.

@scenario_hash:84a32b05666d9e82
Scenario Outline: bootstrap of a "lead" shop named "<slug>" writes "bin/shop-shell" that grants the docker socket's owning group to BOTH the launcher "docker run" AND the attach "docker run", so the operator's attach does not get EACCES on the docker API
  Given an existing git repository at a target directory "/tmp/example-lead-shop" with no "bin/" subdirectory
  When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "<slug>", and target directory "/tmp/example-lead-shop"
  Then the exit code is 0
  And the body of "bin/shop-shell" resolves the docker socket's owning group id by the literal substring "stat -L -c '%g' /var/run/docker.sock"
  And every "docker run" invocation in the body of "bin/shop-shell" that mounts the host docker socket by the literal substring "/var/run/docker.sock:/var/run/docker.sock" also carries the literal substring "--group-add" granting that resolved socket-owning group id
  And the "docker run" invocation in the body of "bin/shop-shell" that invokes "bc-container launch" carries the literal substring "--group-add"
  And the "docker run" invocation in the body of "bin/shop-shell" that invokes "bc-container attach" carries the literal substring "--group-add", so the operator's attach is granted the socket's owning group rather than failing with "permission denied while trying to connect to the docker API at unix:///var/run/docker.sock"

  Examples:
    | slug       |
    | shopsystem |
    | dummyco    |

@scenario_hash:72245934ce007af6
Scenario: on completion the lead bootstrap emits an explicit instruction naming the command to enter the brokered lead session, rather than returning to the host with only "start prompting"
  Given an adopter fork whose "bin/bootstrap" has run the footing sequence to solid footing, demonstrated by a successful "git push" and a successful "bd dolt push"
  When bootstrap reaches completion and returns control to the host shell
  Then bootstrap prints a completion message that names the documented command the operator runs to enter the brokered lead session
  And that completion message contains the literal command "bin/shop-shell" as the next step the operator runs to enter the lead session
  And the completion message does not stop at a generic "start prompting" instruction that omits how to enter the lead session
