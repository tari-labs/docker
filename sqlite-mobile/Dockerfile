FROM quay.io/tarilabs/rust-ndk:1.53.0_r21b as base

# Dependency Downloads
ARG SQLITE_VERSION=sqlite-snapshot-201911192122
ARG SQLITE_SOURCE=https://www.sqlite.org/snapshot/${SQLITE_VERSION}.tar.gz
ARG PLATFORMS="x86_64-linux-android;aarch64-linux-android;armv7-linux-androideabi;i686-linux-android"
ARG LEVEL=24

ADD ./build.sh /build.sh
RUN mkdir -p /sqlite
RUN mkdir -p /platforms/sqlite
RUN curl -s ${SQLITE_SOURCE} | tar -xzvf - -C /sqlite --strip-components=1

RUN ./build.sh $PLATFORMS $LEVEL /sqlite

FROM scratch
COPY --from=base /platforms /platforms
