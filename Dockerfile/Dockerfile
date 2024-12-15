# Builder Stage
FROM ubuntu:22.04 AS builder

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the system and install necessary packages
RUN apt-get update && apt-get install -y \
    qtbase5-dev \
    qttools5-dev-tools \
    qt5-qmake \
    qml-module-qtquick-controls \
    qml-module-qtquick-layouts \
    qml-module-qtqml-models2 \
    qtdeclarative5-dev \
    git cmake ninja-build pkg-config ccache clang llvm lld binfmt-support \
    libsdl2-dev libepoxy-dev libssl-dev python-setuptools g++-x86-64-linux-gnu \
    nasm python3-clang libstdc++-10-dev-i386-cross libstdc++-10-dev-amd64-cross \
    libstdc++-10-dev-arm64-cross squashfs-tools squashfuse libc-bin expect \
    curl sudo fuse wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add and configure user
RUN useradd -m -s /bin/bash fex \
    && usermod -aG sudo fex \
    && echo "fex ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/fex

RUN groupadd -r steam -g 1001 && \
    useradd -u 1001 -r -g steam -m -d /home/steam -s /bin/bash -c "Steam User" steam && \
    echo 'steam ALL=(ALL) NOPASSWD: /bin/chown, /bin/chmod' >> /etc/sudoers

# Copy your scripts into the image
COPY scripts/init.sh /home/steam/init.sh
COPY scripts/start.sh /home/steam/start.sh

# Set the necessary permissions
RUN chmod +x /home/steam/init.sh /home/steam/start.sh

# Clone and build FEX
USER fex
WORKDIR /home/fex
RUN git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git \
    && cd FEX \
    && mkdir Build \
    && cd Build \
    && CC="ccache clang" CXX="ccache clang++" cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTS=False -DENABLE_ASSERTIONS=False -G Ninja .. \
    && ninja -j$(nproc)

# Install FEX as root
USER root
WORKDIR /home/fex/FEX/Build
RUN ninja install \
    && echo 'Skipping systemd-binfmt restart' \
    && echo ':FEX-x86:M::\x7fELF\x01\x01\x01::/usr/bin/FEXLoader:' > /etc/binfmt.d/FEX-x86.conf \
    && echo ':FEX-x86_64:M::\x7fELF\x02\x01\x01::/usr/bin/FEXLoader:' > /etc/binfmt.d/FEX-x86_64.conf
    
# Prepare the Steam and FEX-Emu directories
USER steam
WORKDIR /home/steam/.fex-emu/RootFS/
COPY files/Ubuntu_22_04.tar.gz /home/steam/.fex-emu/RootFS/Ubuntu_22_04.tar.gz
RUN tar xzf /home/steam/.fex-emu/RootFS/Ubuntu_22_04.tar.gz -C /home/steam/.fex-emu/RootFS/ \
    && rm /home/steam/.fex-emu/RootFS/Ubuntu_22_04.tar.gz

WORKDIR /home/steam/.fex-emu
RUN echo '{"Config":{"RootFS":"Ubuntu_22_04"}}' > ./Config.json

WORKDIR /home/steam/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Set the working directory and entry point
WORKDIR /home/steam
ENTRYPOINT ["/bin/bash", "/home/steam/init.sh"]