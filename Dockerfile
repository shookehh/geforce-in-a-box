FROM ghcr.io/selkies-project/selkies/desktop:main-ubuntu26.04

USER root
ENV DEBIAN_FRONTEND=noninteractive

# cloudflared for trycloudflare quick tunnels
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && curl -fsSL -o /usr/local/bin/cloudflared \
       https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x /usr/local/bin/cloudflared \
    && rm -rf /var/lib/apt/lists/*

# 1) Launch GeForce NOW in Chrome when the desktop starts
COPY gfn-autostart.desktop /etc/xdg/autostart/gfn-autostart.desktop
# 2) Start the trycloudflare tunnel when the desktop starts
COPY tunnel-autostart.desktop /etc/xdg/autostart/tunnel-autostart.desktop
RUN chmod 644 /etc/xdg/autostart/*.desktop

ENV SELKIES_ENABLE_HTTPS=true
ENV PASSWD=password

EXPOSE 8080
