# Builder Stage
FROM ubuntu:22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git cmake ninja-build pkg-config ccache clang llvm lld \
    binfmt-support libsdl2-dev libepoxy-dev libssl-dev python-setuptools \
    g++-x86-64-linux-gnu nasm python3-clang libstdc++-10-dev-i386-cross \
    libstdc++-10-dev-amd64-cross libstdc++-10-dev-arm64-cross squashfs-tools \
    squashfuse libc-bin expect curl sudo fuse wget

# Add user fex and configure
RUN useradd -m -s /bin/bash fex \
    && usermod -aG sudo fex \
    && echo "fex ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/fex

USER fex
WORKDIR /home/fex

# Clone and build FEX
RUN git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git \
    && cd FEX \
    && mkdir Build \
    && cd Build \
    && CC="ccache clang" CXX="ccache clang++" cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTS=False -DENABLE_ASSERTIONS=False -G Ninja .. \
    && ninja -j$(nproc)

# Copy Ubuntu_22_04.tar.gz to the correct directory
COPY files/Ubuntu_22_04.tar.gz /home/fex/.fex-emu/RootFS/

# Runner Stage
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && apt-get install -y libssl-dev libc-bin curl sudo fuse \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user steam and configure
RUN useradd -m -s /bin/bash steam \
    && echo 'root:steamcmd' | chpasswd \
    && mkdir -p /palworld && chown -R steam:steam /palworld

# Copy built FEX and scripts
COPY --from=builder /home/fex/FEX/Build /home/steam/FEX/Build
COPY scripts/init.sh /home/steam/init.sh
COPY scripts/start.sh /home/steam/start.sh
RUN chmod +x /home/steam/init.sh /home/steam/start.sh

USER steam
WORKDIR /home/steam

# Create .fex-emu directory and configure FEX Emulator
RUN mkdir -p /home/steam/.fex-emu
COPY --from=builder /home/fex/.fex-emu/RootFS/Ubuntu_22_04.tar.gz ./Ubuntu_22_04.tar.gz
RUN tar xzf Ubuntu_22_04.tar.gz \
    && echo '{"Config":{"RootFS":"Ubuntu_22_04"}}' > /home/steam/.fex-emu/Config.json \
    && rm ./Ubuntu_22_04.tar.gz

# Download Steam CMD
WORKDIR /home/steam/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Set working directory and entrypoint
WORKDIR /home/steam
ENTRYPOINT ["/bin/bash", "/home/steam/init.sh"]
