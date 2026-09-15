FROM nvidia/cuda:12.2.2-base-ubuntu22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Chromium
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    software-properties-common \
    xvfb \
    fluxbox \
    x11vnc \
    novnc \
    websockify \
    libnvidia-encode1 \
    libnvidia-decode1 \
    ffmpeg \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    cmake \
    git \
    libssl-dev \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libgl1-mesa-dev \
    libgles2-mesa-dev \
    libegl1-mesa-dev \
    libdrm-dev \
    libgbm-dev \
    libasound2-dev \
    libpulse-dev \
    libudev-dev \
    libvdpau-dev \
    libva-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Chromium
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get clean

# Create working directory and user
WORKDIR /opt/selkies
RUN useradd -m -s /bin/bash selkies && \
    usermod -aG video selkies

# Install Selkies (using the official installer)
RUN git clone https://github.com/selkies-project/selkies.git /tmp/selkies && \
    cd /tmp/selkies && \
    pip3 install -r requirements.txt && \
    python3 setup.py install && \
    cd / && \
    rm -rf /tmp/selkies

# Copy configuration files
COPY selkies.conf /opt/selkies/
COPY start-selkies.sh /opt/selkies/
COPY xstartup.sh /opt/selkies/

# Set permissions
RUN chmod +x /opt/selkies/*.sh && \
    chown -R selkies:selkies /opt/selkies

# Switch to non-root user
USER selkies

# Expose ports for Selkies
EXPOSE 8080 8443 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start script
CMD ["/opt/selkies/start-selkies.sh"]
