#!/bin/bash

# Set display
export DISPLAY=:99

# Start virtual display
Xvfb :99 -ac -screen 0 1920x1080x24 &
sleep 2

# Start window manager
fluxbox &
sleep 1

# Start Selkies server
cd /opt/selkies
python3 -m selkies.server --config selkies.conf --port 8080 --enable-gpu-encoding &
SELKIES_PID=$!
sleep 3

# Wait for Selkies to be ready
echo "Waiting for Selkies to start..."
for i in {1..30}; do
    if curl -s http://localhost:8080/health > /dev/null 2>&1; then
        echo "✅ Selkies is ready!"
        break
    fi
    sleep 2
done

# Start Chromium with GeForce NOW
google-chrome-stable --no-sandbox --disable-dev-shm-usage \
    --window-size=1920,1080 \
    --start-maximized \
    --autoplay-policy=no-user-gesture-required \
    --remote-debugging-port=9222 \
    "https://play.geforcenow.com/mall" &

echo "🎮 Selkies is running on port 8080"
echo "🌐 Access via: http://localhost:8080"
echo "🖥️  Chromium with GeForce NOW is starting..."

# Keep the container running
wait $SELKIES_PID
