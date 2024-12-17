FROM docker.io/sonroyaalmerol/steamcmd-arm64:root-2024-12-08 AS base-arm64

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    procps=2:4.0.2-3 \
    wget \
    gettext-base=0.21-12 \
    xdg-user-dirs=0.18-1 \
    jo=1.9-1 \
    jq=1.6-2.1 \
    netcat-traditional=1.10-47 \
    libicu72=72.1-3 \
    unzip=6.0-28 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV ARM64_DEVICE=rpi4-pre3 \
    PLAYERS= \
    MULTITHREADING=false \
    COMMUNITY=false \
    UPDATE_ON_BOOT=true \
    QUERY_PORT=27015 \
    REST_API_PORT=8212 \
    DISABLE_GENERATE_ENGINE=true \
    BOX64_DYNAREC_STRONGMEM=1 \
    BOX64_DYNAREC_BIGBLOCK=1 \
    BOX64_DYNAREC_SAFEFLAGS=1 \
    BOX64_DYNAREC_FASTROUND=1 \
    BOX64_DYNAREC_FASTNAN=1 \
    BOX64_DYNAREC_X87DOUBLE=0

# Copy your scripts into the image
COPY scripts/init.sh /home/steam/init.sh
COPY scripts/start.sh /home/steam/start.sh

# Set the necessary permissions
RUN chmod +x /home/steam/init.sh /home/steam/start.sh

# Create the /palworld directory and set ownership
RUN mkdir -p /palworld && \
    chown -R steam:steam /palworld && \
    chmod -R 770 /palworld

USER steam

# Set the working directory and entry point
WORKDIR /home/steam
ENTRYPOINT ["/bin/bash", "/home/steam/init.sh"]