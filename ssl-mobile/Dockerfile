FROM quay.io/tarilabs/rust-ndk:1.46.0_r21b as base

# Dependency Downloads
ARG OPENSSL_VERSION=1.1.1h
ARG OPENSSL_SOURCE="https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
ARG PLATFORMS="armv7-linux-androideabi;i686-linux-android;x86_64-linux-android;aarch64-linux-android;"
ARG LEVEL=24

ADD ./build.sh /build.sh
RUN mkdir -p /ssl
RUN mkdir -p /platforms/ssl
RUN curl -s ${OPENSSL_SOURCE} | tar -xzvf - -C /ssl --strip-components=1

RUN ./build.sh $PLATFORMS $LEVEL /ssl

FROM scratch
COPY --from=base /platforms /platforms
