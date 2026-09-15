#!/bin/bash
fluxbox &
sleep 1
exec google-chrome-stable \
  --no-sandbox \
  --disable-dev-shm-usage \
  --no-first-run \
  --start-maximized \
  "https://play.geforcenow.com/mall"
