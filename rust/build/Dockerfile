# Build image for the Tari project; includes libZMQ, clippy, rustfmt and other development tools
FROM rust:1.36

ARG NIGHTLY_VERSION=nightly-2019-07-15

RUN set -eux; \
    apt-get update; \
    apt-get install -y git build-essential libtool pkg-config autotools-dev autoconf automake cmake uuid-dev libpcre3-dev libsodium-dev valgrind libncurses5-dev libncursesw5-dev libunwind-dev libsystemd-dev liblz4-dev libmicrohttpd-dev; \
    wget https://github.com/zeromq/libzmq/releases/download/v4.3.2/zeromq-4.3.2.tar.gz; \
    tar xvzf zeromq-4.3.2.tar.gz; \
    cd zeromq-4.3.2; \
    ./autogen.sh; \
    ./configure --with-libsodium; \
    make check; \
    make install; \
    ldconfig; \
    cd ..; \
    rm -rf zeromq-4.3.2; \
    rm -f zeromq-4.3.2.tar.gz; \
    wget https://github.com/zeromq/czmq/releases/download/v4.2.0/czmq-4.2.0.tar.gz; \
    tar xvzf czmq-4.2.0.tar.gz; \
    cd czmq-4.2.0; \
    ./configure; \
    make check; \
    make install; \
    ldconfig; \
    cd ..; \
    rm -rf czmq-4.2.0; \
    rm -f czmq-4.2.0.tar.gz; \
    wget https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz; \
    tar xvzf sqlite-autoconf-3290000.tar.gz; \
    cd sqlite-autoconf-3290000; \
    ./configure; \
    make install; \
    cd ..; \
    rm -rf sqlite-autoconf-3290000; \
    rm -f sqlite-autoconf-3290000.tar.gz; \
    rm -rf /var/lib/apt/lists/*;

RUN rustup update $NIGHTLY_VERSION; \
    rustup default $NIGHTLY_VERSION; \
    rustup component add rustfmt clippy

RUN cargo install mdbook
