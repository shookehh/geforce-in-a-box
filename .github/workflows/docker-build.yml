# Start from the current Selkies desktop image (CPU-only, no CUDA needed).
# NVIDIA/AMD/Intel GPU passthrough is optional and handled at `docker run` time.
FROM ghcr.io/selkies-project/selkies/desktop:main-ubuntu26.04

USER root
ENV DEBIAN_FRONTEND=noninteractive

# (Optional) install anything extra your session needs. Chrome is already here.
# RUN apt-get update && apt-get install -y --no-install-recommends \
#       <extra packages> \
#     && rm -rf /var/lib/apt/lists/*

# Autostart entry that opens GeForce NOW in Chrome as soon as the desktop is up.
COPY gfn-autostart.desktop /etc/xdg/autostart/gfn-autostart.desktop
RUN chmod 644 /etc/xdg/autostart/gfn-autostart.desktop

# Selkies serves on 8080; go plain-HTTP so Cloudflare terminates TLS.
ENV SELKIES_ENABLE_HTTPS=false
ENV SELKIES_PORT=8080
ENV PASSWD=changeme

EXPOSE 8080
