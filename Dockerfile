FROM ghcr.io/selkies-project/selkies-gstreamer:latest-cuda

USER root
ENV DEBIAN_FRONTEND=noninteractive

# Install Chrome repo dependencies + a window manager
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome
RUN wget -qO - https://dl.google.com/linux/linux_signing_key.pub \
      | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Our startup script (window manager + Chrome)
COPY start-app.sh /start-app.sh
RUN chmod +x /start-app.sh

# Tell Selkies to launch our script inside the streamed display
ENV STARTUPCMD=/start-app.sh

EXPOSE 8080
