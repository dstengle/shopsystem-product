#!/usr/bin/env bash
# launch-shim.sh — start the anthropic-oauth-shim for the Fabro U5 close.
#
# The shim must run in a shell whose environment carries the agent-vault proxy
# (HTTPS_PROXY) and MITM CA (SSL_CERT_FILE) — i.e. any normal agent shell in this
# fleet. Python stdlib picks both up automatically; no secrets are passed here.
#
# Usage:
#   ./launch-shim.sh            # foreground on 127.0.0.1:8788
#   PORT=9000 ./launch-shim.sh  # custom port (update settings.toml base_url too)
#
# Then point fabro's anthropic provider at it (see README.md):
#   [llm.providers.anthropic]
#   base_url = "http://127.0.0.1:8788/v1"
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT="${PORT:-8788}"
HOST="${HOST:-127.0.0.1}"

if [ -z "${HTTPS_PROXY:-}" ]; then
  echo "WARNING: HTTPS_PROXY is unset — the shim will NOT reach agent-vault and" >&2
  echo "         Anthropic will reject the dummy credential. Run inside an" >&2
  echo "         agent-vault-enabled shell." >&2
fi

exec python3 "${HERE}/shim.py" --host "${HOST}" --port "${PORT}"
