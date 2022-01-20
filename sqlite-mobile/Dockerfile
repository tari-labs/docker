FROM quay.io/tarilabs/rust-ndk:1.58.0_r21b as base

RUN apt-get update && apt-get install libdigest-sha3-perl

# Dependency Downloads
ARG SQLITE_VERSION=sqlite-snapshot-202201112328
ARG SQLITE_GZ=${SQLITE_VERSION}.tar.gz
ARG SQLITE_SOURCE=https://www.sqlite.org/snapshot/${SQLITE_GZ}
ARG PLATFORMS="x86_64-linux-android;aarch64-linux-android;armv7-linux-androideabi;i686-linux-android"
ARG LEVEL=24

ADD ./build.sh /build.sh
RUN mkdir -p /sqlite
RUN mkdir -p /platforms/sqlite
RUN curl ${SQLITE_SOURCE} -o ${SQLITE_GZ}
RUN if [[ $(sha3sum SQLITE_GZ) != "fe750a6858aa656f18d1dcd600043b39fadd02d81a90e51ff48981281c8710fd $SQLITE_GZ" ]]; then exit 1; fi
RUN tar -xzvf ${SQLITE_GZ} -C /sqlite --strip-components=1

RUN ./build.sh $PLATFORMS $LEVEL /sqlite

FROM scratch
COPY --from=base /platforms /platforms
