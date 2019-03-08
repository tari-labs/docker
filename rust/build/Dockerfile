# Build image for the Tari project; includes libZMQ, clippy, rustfmt and other development tools
FROM rust:1.33

ARG NIGHTLY_VERSION=nightly-2019-03-08

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      libczmq-dev; \
    rm -rf /var/lib/apt/lists/*;

RUN rustup update $NIGHTLY_VERSION; \
    rustup default $NIGHTLY_VERSION; \
    rustup component add rustfmt clippy

RUN cargo install mdbook