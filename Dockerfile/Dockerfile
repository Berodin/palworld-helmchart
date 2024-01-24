# Builder Stage
FROM ubuntu:22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git cmake ninja-build pkg-config ccache clang llvm lld \
    binfmt-support libsdl2-dev libepoxy-dev libssl-dev python-setuptools \
    g++-x86-64-linux-gnu nasm python3-clang libstdc++-10-dev-i386-cross \
    libstdc++-10-dev-amd64-cross libstdc++-10-dev-arm64-cross squashfs-tools \
    squashfuse libc-bin expect curl sudo fuse wget && \
    useradd -m -s /bin/bash fex && \
    usermod -aG sudo fex && \
    echo "fex ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/fex && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER fex
WORKDIR /home/fex
RUN git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git && \
    cd FEX && \
    mkdir Build && \
    cd Build && \
    CC="ccache clang" CXX="ccache clang++" cmake -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTS=False \
    -DENABLE_ASSERTIONS=False -G Ninja .. && \
    ninja -j$(nproc)

# Runner Stage
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libssl-dev libc-bin curl sudo fuse ninja-build && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV ADMIN_PASSWORD='changeit' \
    COMMUNITY='true' \
    MULTITHREADING='false' \
    PGID=1000 \
    PLAYERS=10 \
    PORT=27015 \
    PUBLIC_IP='127.0.0.1' \
    PUBLIC_PORT='8211' \
    PUID=1000 \
    SERVER_NAME='My Palworld Server' \
    SERVER_PASSWORD='changeit' \
    UPDATE_ON_BOOT='true'

RUN useradd -m -s /bin/bash steam && echo 'root:steamcmd' | chpasswd

COPY --from=builder /home/fex/FEX/Build /home/steam/FEX
COPY scripts/init.sh /home/steam/init.sh
COPY scripts/start.sh /home/steam/start.sh

RUN chmod +x /home/steam/init.sh /home/steam/start.sh

WORKDIR /home/fex/FEX/Build
RUN sudo ninja install \
    && sudo ninja binfmt_misc_32 \
    && sudo ninja binfmt_misc_64

USER steam
WORKDIR /home/steam/.fex-emu/RootFS/
COPY files/Ubuntu_22_04.tar.gz ./Ubuntu_22_04.tar.gz
RUN tar xzf Ubuntu_22_04.tar.gz \
    && rm ./Ubuntu_22_04.tar.gz

WORKDIR /home/steam/.fex-emu
RUN echo '{"Config":{"RootFS":"Ubuntu_22_04"}}' > ./Config.json

WORKDIR /home/steam/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

WORKDIR /home/steam
ENTRYPOINT ["/bin/bash", "/home/steam/init.sh"]
