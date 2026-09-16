#!/bin/bash
LOG=/tmp/cloudflared.log
if [ -n "$TUNNEL_TOKEN" ]; then
  exec /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" >"$LOG" 2>&1
else
  exec /usr/local/bin/cloudflared tunnel --no-autoupdate --url https://localhost:8080 --no-tls-validate >"$LOG" 2>&1
fi
