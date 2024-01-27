# Builder Stage
FROM ubuntu:22.04 as builder

# Setzen Sie Umgebungsvariablen, um interaktive Aufforderungen zu vermeiden
ENV DEBIAN_FRONTEND=noninteractive

# Aktualisieren Sie das System und installieren Sie die notwendigen Pakete
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ninja-build \
    pkg-config \
    ccache \
    clang \
    llvm \
    lld \
    binfmt-support \
    libsdl2-dev \
    libepoxy-dev \
    libssl-dev \
    python-setuptools \
    g++-x86-64-linux-gnu \
    nasm \
    python3-clang \
    libstdc++-10-dev-i386-cross \
    libstdc++-10-dev-amd64-cross \
    libstdc++-10-dev-arm64-cross \
    squashfs-tools \
    squashfuse \
    libc-bin \
    expect \
    curl \
    sudo \
    fuse \
    wget

# Fügen Sie Benutzer hinzu und konfigurieren Sie sie
RUN useradd -m -s /bin/bash fex \
    && usermod -aG sudo fex \
    && echo "fex ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/fex

RUN groupadd -r steam -g 1001 && \
    useradd -u 1001 -r -g steam -m -d /home/steam -s /bin/bash -c "Steam User" steam && \
    echo 'root:steamcmd' | chpasswd

# Kopieren Sie Ihre Skripte in das Image
COPY scripts/init.sh /home/steam/init.sh
COPY scripts/start.sh /home/steam/start.sh

# Setzen Sie die nötigen Berechtigungen
RUN chmod +x /home/steam/init.sh /home/steam/start.sh

# Klonen und bauen Sie FEX
USER fex
WORKDIR /home/fex
RUN git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git \
    && cd FEX \
    && mkdir Build \
    && cd Build \
    && CC="ccache clang" CXX="ccache clang++" cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTS=False -DENABLE_ASSERTIONS=False -G Ninja .. \
    && ninja -j$(nproc)

# Installieren Sie FEX
WORKDIR /home/fex/FEX/Build
RUN sudo ninja install \
    && sudo ninja binfmt_misc_32 \
    && sudo ninja binfmt_misc_64

# Vorbereiten des Steam- und FEX-Emu-Verzeichnisses
USER steam
WORKDIR /home/steam/.fex-emu/RootFS/
COPY files/Ubuntu_22_04.tar.gz /home/steam/.fex-emu/RootFS/Ubuntu_22_04.tar.gz
RUN tar xzf /home/steam/.fex-emu/RootFS/Ubuntu_22_04.tar.gz -C /home/steam/.fex-emu/RootFS/ \
    && rm /home/steam/.fex-emu/RootFS/Ubuntu_22_04.tar.gz

WORKDIR /home/steam/.fex-emu
RUN echo '{"Config":{"RootFS":"Ubuntu_22_04"}}' > ./Config.json

WORKDIR /home/steam/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Setzen Sie den Arbeitsordner und den Eintrittspunkt
WORKDIR /home/steam
ENTRYPOINT ["/bin/bash", "/home/steam/init.sh"]
