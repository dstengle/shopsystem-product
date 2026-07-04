#!/bin/bash
# Poll sonnet-4-5 through the shim until it clears the 429, then run S5 (expect complete).
C=bc-fabro-e2e-clean3
LOG=/workspace/.fabro-e2e-scratch/clean3-s5-complete.log
: > "$LOG"
code=429; n=0
while [ "$code" != "200" ] && [ $n -lt 90 ]; do
  sleep 10; n=$((n+1))
  code=$(docker exec $C bash -lc 'curl -s -o /dev/null -w "%{http_code}" -X POST http://127.0.0.1:8788/v1/messages -H "content-type: application/json" -H "x-api-key: sk-ant-dummy-agent-vault-rides-the-wire" -H "anthropic-version: 2023-06-01" -d "{\"model\":\"claude-sonnet-4-5\",\"max_tokens\":8,\"messages\":[{\"role\":\"user\",\"content\":\"PONG\"}]}"' 2>/dev/null)
done
echo "sonnet cleared after ~$((n*10))s code=$code" >> "$LOG"
if [ "$code" != "200" ]; then echo "GAVE UP: sonnet still 429 after ~$((n*10))s" >> "$LOG"; exit 0; fi
# clear prior work_done rows for a clean read (throwaway)
docker exec shopsystem-postgres psql -U postgres -d shopsystem -c "delete from messages where work_id='fabro-clean3-1' and message_type='work_done';" >> "$LOG" 2>&1
# run S5 for complete
docker exec -u vscode \
  -e HOME=/home/vscode \
  -e SSL_CERT_FILE=/home/vscode/.config/agent-vault/ca.pem \
  -e ANTHROPIC_API_KEY=sk-ant-dummy-agent-vault-rides-the-wire \
  -e ANTHROPIC_BASE_URL=http://127.0.0.1:8788/v1 \
  $C bash -lc 'cd /workspace/.fabro && fabro run workflow.fabro -I BC_NAME=fabro-e2e-clean3 -I WORK_ID=fabro-clean3-1 2>&1' >> "$LOG" 2>&1
echo "=== S5 run done ===" >> "$LOG"
