# Builder stage for box86 and box64
FROM arm64v8/ubuntu:latest as builder

# Adding multiarch support and installing build dependencies
# Adding Python3 for box86 compilation
RUN dpkg --add-architecture armhf \
    && apt-get update \
    && apt-get install -y \
        crossbuild-essential-armhf \
        git build-essential cmake python3 \
        gcc-arm-linux-gnueabihf \
        libc6:armhf libncurses5:armhf libstdc++6:armhf \
        curl

# Cloning and building box86
RUN git clone https://github.com/ptitSeb/box86 \
    && cd box86 \
    && mkdir build && cd build \
    && cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    && make -j$(nproc) \
    && make install

# Download and install steamcmd
RUN mkdir -p /home/steam/steamcmd \
    && cd /home/steam/steamcmd \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -


# Runner stage
FROM arm64v8/ubuntu:latest

# Copying the Box86 binary and steamcmd from the builder
COPY --from=builder /usr/local/bin/box86 /usr/local/bin/box86
COPY --from=builder /home/steam/steamcmd /home/steam/steamcmd

# Installing necessary runtime packages and setting up the working directory
RUN apt-get update && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /home/steam/server \
    && groupadd -r steam && useradd -r -g steam steam

# Setting up the working directory
WORKDIR /home/steam/server

# Copying scripts to the container filesystem
COPY /scripts/init.sh ./init.sh
COPY /scripts/start.sh ./start.sh

# Granting execution rights to the scripts
RUN chmod +x ./init.sh ./start.sh

# Exposing the port
EXPOSE ${PORT}

# Setting the entry point
ENTRYPOINT ["./init.sh"]
