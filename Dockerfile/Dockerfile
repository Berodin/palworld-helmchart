# Stage 1: Builder
# Use the latest Debian base image for ARM64
FROM debian:latest as builder

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and SteamCMD
# dpkg --add-architecture i386: Adds support for i386 architecture
# apt-get update && apt-get install: Installs the required packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wget lib32gcc-s1 steamcmd procps xdg-user-dirs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install the game using SteamCMD
RUN /usr/games/steamcmd +login anonymous +force_install_dir "/palworld" +app_update 2394010 validate +quit

# Stage 2: Runner
# Start again from a clean Debian image
FROM debian:latest

# Repeat the installation of the necessary dependencies without SteamCMD
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y lib32gcc-s1 procps xdg-user-dirs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the game from the builder stage
COPY --from=builder /palworld /palworld

# Define environment variables for server configuration
ENV PORT=27015 \
    PUID=1000 \
    PGID=1000 \
    PLAYERS=10 \
    MULTITHREADING=false \
    COMMUNITY=false \
    PUBLIC_IP= \
    PUBLIC_PORT= \
    SERVER_PASSWORD= \
    SERVER_NAME="My Palworld Server" \
    ADMIN_PASSWORD= \
    UPDATE_ON_BOOT=true

# Copy the startup scripts into the image
COPY ./scripts/* /home/steam/

# Set the necessary permissions for the scripts
RUN chmod +x /home/steam/init.sh /home/steam/start.sh

# Set the working directory
WORKDIR /home/steam

# Health check to monitor the server process
# --start-period=5m: The time to wait before starting health checks
# CMD pgrep "PalServer-Linux" > /dev/null || exit 1: The actual command to check the process
HEALTHCHECK --start-period=5m CMD pgrep "PalServer-Linux" > /dev/null || exit 1

# Expose the game server port
EXPOSE ${PORT}

# Set the entrypoint to the initialization script
ENTRYPOINT ["/home/steam/init.sh"]
