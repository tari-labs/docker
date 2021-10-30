# Build image for the Tari project; includes SQLite, clippy, rustfmt and other development tools
FROM rust:1.56

ARG NIGHTLY_VERSION=nightly-2021-09-18

# libs contains:
#    https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz
ADD libs libs/
RUN set -eux; \
    apt-key add ./libs/llvm-snapshot.gpg.key; \
    echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y build-essential cmake \
    libsodium-dev libunwind-dev libsystemd-dev liblz4-dev \
    libmicrohttpd-dev \
    clang-format clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 liblldb-dev libomp-dev libomp5 lld llvm-dev llvm-runtime llvm \
    valgrind
RUN tar xvzf libs/sqlite-autoconf-3360000.tar.gz; \
    cd sqlite-autoconf-3360000; \
    ./configure; \
    make install; \
    cd ..; \
    rm -rf sqlite-autoconf-3360000; \
    rm -f sqlite-autoconf-3360000.tar.gz; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf libs

RUN rustup update $NIGHTLY_VERSION; \
    rustup default $NIGHTLY_VERSION; \
    rustup component add rustfmt clippy

# RUN cargo install mdbook

# Node and npm
ENV NODE_VERSION=12.22.6
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
