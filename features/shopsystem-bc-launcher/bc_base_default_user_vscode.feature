@bc:shopsystem-bc-launcher @origin:lead-fwrx
Feature: bc-base and bc-lead default to the vscode user so baked ~/.claude resolves

@scenario_hash:a4caf0477a74e4bc
Scenario: the published bc-base and bc-lead images default to the vscode user so the baked ~/.claude state resolves for the running user
  Given the published image "ghcr.io/dstengle/shopsystem-bc-base:latest"
  And the published image "ghcr.io/dstengle/shopsystem-bc-lead:latest"
  When each image is inspected via "docker inspect" and run via "docker run --rm <image> whoami"
  Then the "Config.User" reported by "docker inspect" is "vscode" for each image
  And "docker run --rm <image> whoami" reports "vscode" for each image
  And the running vscode user's HOME is "/home/vscode" so the baked "/home/vscode/.claude/.credentials.json" and "/home/vscode/.claude.json" onboarding and credential state resolve for the running user
  And claude started as the default user does not enter first-run onboarding or the login-method picker due to a HOME mismatch
