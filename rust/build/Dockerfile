# Build image for the Tari project; includes libZMQ, clippy, rustfmt and other development tools
FROM rust:1.43

ARG NIGHTLY_VERSION=nightly-2020-01-08

# libs contains:
#    https://github.com/zeromq/libzmq/releases/download/v4.3.2/zeromq-4.3.2.tar.gz
#    https://github.com/zeromq/czmq/releases/download/v4.2.0/czmq-4.2.0.tar.gz
#    https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz
ADD libs libs/
RUN set -eux; \
    apt-key add ./libs/llvm-snapshot.gpg.key; \
    echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-9 main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y git build-essential libtool pkg-config autotools-dev autoconf automake cmake uuid-dev \
    libpcre3-dev libsodium-dev valgrind libncurses5-dev libncursesw5-dev libunwind-dev libsystemd-dev liblz4-dev \
    libmicrohttpd-dev libssl-dev \
    libllvm9 llvm-9 llvm-9-dev llvm-9-runtime llvm-9-tools \
    clang-9 clang-tools-9 libclang-common-9-dev libclang-9-dev libclang1-9 clang-format-9 clangd-9 \
    libfuzzer-9-dev \
    libc++-9-dev libc++abi-9-dev
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
