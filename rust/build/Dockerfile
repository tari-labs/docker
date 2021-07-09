# Build image for the Tari project; includes libZMQ, clippy, rustfmt and other development tools
FROM rust:1.53

ARG NIGHTLY_VERSION=nightly-2021-05-09

# libs contains:
#    https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz
ADD libs libs/
RUN set -eux; \
    apt-key add ./libs/llvm-snapshot.gpg.key; \
    echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-11 main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y git build-essential libtool pkg-config autotools-dev autoconf automake cmake uuid-dev \
    libpcre3-dev libsodium-dev valgrind libncurses5-dev libncursesw5-dev libunwind-dev libsystemd-dev liblz4-dev \
    libmicrohttpd-dev libssl-dev \
    libllvm11 llvm-11 llvm-11-dev llvm-11-runtime llvm-11-tools \
    clang-11 clang-tools-11 libclang-common-11-dev libclang-11-dev libclang1-11 clang-format-11 clangd-11 \
    libfuzzer-11-dev \
    libc++-11-dev libc++abi-11-dev \
    libcap2-bin libicu-dev libbsd-dev
RUN tar xvzf libs/sqlite-autoconf-3290000.tar.gz; \
    cd sqlite-autoconf-3290000; \
    ./configure; \
    make install; \
    cd ..; \
    rm -rf sqlite-autoconf-3290000; \
    rm -f sqlite-autoconf-3290000.tar.gz; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf libs

RUN rustup update $NIGHTLY_VERSION; \
    rustup default $NIGHTLY_VERSION; \
    rustup component add rustfmt clippy

RUN cargo install mdbook

# Node and npm
ENV NODE_VERSION=14.14.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
