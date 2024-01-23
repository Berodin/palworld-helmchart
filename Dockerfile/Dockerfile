# Builder Stage
FROM ubuntu:22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git cmake ninja-build pkg-config ccache clang llvm lld \
    binfmt-support libsdl2-dev libepoxy-dev libssl-dev python-setuptools \
    g++-x86-64-linux-gnu nasm python3-clang libstdc++-10-dev-i386-cross \
    libstdc++-10-dev-amd64-cross libstdc++-10-dev-arm64-cross squashfs-tools \
    squashfuse libc-bin expect curl sudo fuse wget

RUN useradd -m -s /bin/bash fex && \
    usermod -aG sudo fex && \
    echo "fex ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/fex

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

RUN apt-get update && apt-get install -y libssl-dev libc-bin curl sudo fuse wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash steam && echo 'root:steamcmd' | chpasswd && \
    mkdir -p /palworld && chown -R steam:steam /palworld

COPY --from=builder /home/fex/FEX/Build /home/steam/FEX
COPY scripts/init.sh ./init.sh
COPY scripts/start.sh ./start.sh
RUN chmod +x ./init.sh ./start.sh

WORKDIR /home/steam/.fex-emu/RootFS/
RUN wget -O Ubuntu_22_04.tar.gz https://www.dropbox.com/scl/fi/16mhn3jrwvzapdw50gt20/Ubuntu_22_04.tar.gz?rlkey=4m256iahwtcijkpzcv8abn7nf && \
    tar xzf Ubuntu_22_04.tar.gz && \
    rm ./Ubuntu_22_04.tar.gz

WORKDIR /home/steam/.fex-emu
RUN echo '{"Config":{"RootFS":"Ubuntu_22_04"}}' > ./Config.json

WORKDIR /home/steam/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

WORKDIR /home/steam

ENTRYPOINT ["/bin/bash", "./init.sh"]
